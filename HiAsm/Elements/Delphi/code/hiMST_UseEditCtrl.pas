unit hiMST_UseEditCtrl;

interface
     
uses Windows, Messages, Kol, Share, Debug, hiMTStrTbl;

{$ifndef KOL3XX}
const
  HDN_FIRST        = -300;           { Header }
  HDN_ITEMCHANGEDA = HDN_FIRST-1;
  HDN_ITEMCHANGEDW = HDN_FIRST - 21;
  
type
  tagNMHEADERA = packed record
    Hdr: TNMHdr;
    Item: Integer;
    Button: Integer;
    PItem: PHDItemA;
  end;
  
  THDNotify = tagNMHEADERA;
  PHDNotify = ^THDNotify;
{$endif}


type
  THIMST_UseEditCtrl = class(TDebug)
   private
     sControl: PControl;
     NewLine: integer;
     FMSTControl: IMSTControl;
     procedure SetMSTControl(Value: IMSTControl); 
     procedure snewcuridx(value:integer);
     function gnewcuridx: integer;
     function fredaction: boolean;
     function fctl3d: boolean;     
   public

     _prop_KeyCellEnter: byte;
     _prop_DblClick: boolean;
     _data_Row: THI_Event;
     _data_Col: THI_Event;
     _event_onEscCell: THI_Event;
     _event_onEnterCell: THI_Event;
     _event_onCellSize: THI_Event;
     _event_onClientRect: THI_Event;
          
     property _prop_MSTControl: IMSTControl read FMSTControl write SetMSTControl;
     property NewCurIdx:integer read gnewcuridx write snewcuridx;
     
     procedure _work_doSetData(var _Data: TData; Index: word);
     procedure _work_doClientRect(var _Data: TData; Index: word);     
     procedure _var_Index(var _Data: TData; Index: word);
     procedure _var_Cell(var _Data: TData; Index: word);
     procedure _var_SubItem(var _Data: TData; Index: word);
     procedure _var_Matrix(var _Data: TData; Index: word);
  end;

implementation


//------------------------------------------------------------------------------
//
function WndProcTabGrid(Sender: PControl; var Msg: TMsg; var Rslt: LRESULT): Boolean;
type
  TMouseDownPt = packed record
    X: Word;
    Y: Word;
  end;
var
  R, ARect: TRect;
  Pt: TMouseDownPt {$ifdef FPC}absolute Msg.lParam{$endif}; 
  HTI: TLVHitTestInfo;
  fClass: THIMST_UseEditCtrl;
  dTop, dWidth, dHeight, Data: TData;
  l: TListViewOptions;

  procedure InitOnEvent;
  var
    b: integer;
  begin
    if fClass.FRedaction then exit;
    R := Sender.LVSubItemRect(fClass.NewLine, fClass.NewCurIdx);
    if fClass.NewCurIdx = 0 then
    begin
      ARect := Sender.LVItemRect(fClass.NewLine, lvipLabel);
      R.Left := ARect.Left;
      R.Right := ARect.Right;
    end; 
    if fClass.fctl3d then
      b := 2
    else
      b := 1;
    l := Sender.LVOptions;

    dtInteger(Data, R.Left + Sender.Left + b);
    dtInteger(dWidth, R.Right - R.Left - 1);
    dtInteger(dTop, R.Top + Sender.Top + b);
    dtInteger(dHeight, R.Bottom - R.Top - 1);

    Data.ldata:= @dTop;
    dTop.ldata:= @dWidth;
    dWidth.ldata:= @dHeight;
    _hi_OnEvent_(fClass._event_onCellSize, Data);
  end;

  procedure EscCell;
  begin
    R := Sender.LVItemRect(fClass.NewLine, lvipBounds);
    ARect := Sender.LVItemRect(fClass.NewLine, lvipLabel);
    R.Left := ARect.Left;
    InvalidateRect(Sender.Handle, @R, false);
    if not fClass.FRedaction then
      _hi_OnEvent(fClass._event_onEscCell, Sender.LVItems[fClass.NewLine, fClass.NewCurIdx]);
  end;
  
begin
  Result := FALSE;
  l:= Sender.LVOptions;
  fClass := THIMST_UseEditCtrl(Sender.CustomData^);
  with fClass do
  begin
    case Msg.message of
      WM_NOTIFY:
        if (THDNotify(Pointer(Msg.LParam)^).Hdr.code = HDN_ITEMCHANGEDA) or
           (THDNotify(Pointer(Msg.LParam)^).Hdr.code = HDN_ITEMCHANGEDW) then
          InitOnEvent;
      WM_RBUTTONDOWN, WM_LBUTTONDOWN:
      begin
        {$ifndef FPC}Pt:= TMouseDownPt(Msg.lParam);{$endif}
        HTI.pt.x := Pt.X;
        HTI.pt.y := Pt.Y;
        Sender.Perform( LVM_SUBITEMHITTEST, 0, Integer( @HTI ) );
        if (HTI.flags <> LVHT_ONITEMSTATEICON) and (HTI.iItem <> -1) then
        begin 
          NewLine := HTI.iItem;
          NewCurIdx := HTI.iSubItem;             
        end;
        EscCell;
      end;
      WM_LBUTTONDBLCLK:
        begin
          {$ifndef FPC}Pt:= TMouseDownPt(Msg.lParam);{$endif}
          HTI.pt.x := Pt.X;
          HTI.pt.y := Pt.Y;
          Sender.Perform( LVM_SUBITEMHITTEST, 0, Integer( @HTI ) );
          if (HTI.flags <> LVHT_ONITEMSTATEICON) and _prop_DblClick  and (HTI.iItem <> -1) then
          begin     
            InitOnEvent;
            _hi_onEvent(fClass._event_onEnterCell);
          end;  
        end;
      WM_HSCROLL, WM_VSCROLL:
        EscCell;
      WM_KEYDOWN:
      begin
        Case Msg.WParam of
          VK_LEFT, VK_RIGHT:
          begin
            if (lvoRowSelect in l) then
            begin
              NewCurIdx := NewCurIdx + Msg.wParam - $26;
              if NewCurIdx >= Sender.LVColCount then
                NewCurIdx := Sender.LVColCount - 1
              else
                if NewCurIdx < 0 then NewCurIdx := 0;
              EscCell;
            end;
          end;
          VK_UP, VK_DOWN:
          begin
            NewLine := NewLine + Msg.wParam - $27;
            if NewLine >= Sender.Count then
              NewLine := Sender.Count - 1
            else
              if NewLine < 0 then
                NewLine := 0;
            EscCell;
          end;
          VK_RETURN:
            if _prop_KeyCellEnter = 1 then
            begin
              InitOnEvent;
              _hi_onEvent(fClass._event_onEnterCell);              
            end;              
          VK_F2:
            begin
              InitOnEvent;
              _hi_onEvent(fClass._event_onEnterCell);
            end;  
          VK_ESCAPE:
            EscCell;
        end;
      end;
    end;
  end;
end;

procedure THIMST_UseEditCtrl.snewcuridx;
begin
  if not Assigned(_prop_MSTControl) then exit;
  _prop_MSTControl.setnewcuridx(value);  
end;

function THIMST_UseEditCtrl.gnewcuridx;
begin
  if Assigned(_prop_MSTControl) then
    Result := _prop_MSTControl.getnewcuridx  
  else
    Result := 0;
end;

function THIMST_UseEditCtrl.fredaction;
begin
  if Assigned(_prop_MSTControl) then
    Result := _prop_MSTControl.getfredaction  
  else
    Result := true;
end;

function THIMST_UseEditCtrl.fctl3d;
begin
  if Assigned(_prop_MSTControl) then
    Result := _prop_MSTControl.getfctl3d  
  else
    Result := true;
end;

procedure THIMST_UseEditCtrl.SetMSTControl;
var
  P: Pointer;
begin
  if Value = nil then exit; 
  FMSTControl := Value;
  sControl := FMSTControl.ctrlpoint;
  FMSTControl.detachwndproc;
  
  //sControl.CustomData := Pointer(Self); // TControl.Destroy ������� FreeMem(fCustomData), ��� ������� � ������
  GetMem(P, SizeOf(Pointer));
  Pointer(P^) := Self;
  sControl.CustomData := P;
  
  sControl.AttachProc(WndProcTabGrid);
end;

procedure THIMST_UseEditCtrl._work_doSetData;
var
  dControl: PControl;
begin
  if not Assigned(_prop_MSTControl) then exit;
  dControl := _prop_MSTControl.ctrlpoint; 
  dControl.LVItems[NewLine, NewCurIdx] := Share.ToString(_Data);
end;

// �������� ������ ������� ���������� ������
//
procedure THIMST_UseEditCtrl._var_SubItem;
begin
  dtInteger(_Data, NewCurIdx);
end;

// �������� �������� ��������� ������ ��� ��������
//
procedure THIMST_UseEditCtrl._var_Cell;
var
  dControl: PControl;
begin
  if not Assigned(_prop_MSTControl) then exit;
  dControl := _prop_MSTControl.ctrlpoint; 
  dtString(_Data, dControl.LVItems[NewLine, NewCurIdx]);
end;

// �������� ������ ���������� ������
//
procedure THIMST_UseEditCtrl._var_Index;
var
  sControl: PControl;
begin
  if not Assigned(_prop_MSTControl) then exit;
  sControl := _prop_MSTControl.ctrlpoint;
  dtInteger(_Data, sControl.CurIndex);
end;

// ������� �����
//
procedure THIMST_UseEditCtrl._var_Matrix;
begin
  if not Assigned(_prop_MSTControl) then exit;
  _prop_MSTControl.matrix(_Data);    
end;

procedure THIMST_UseEditCtrl._work_doClientRect;
var
  Row,Col: integer;
  R, ARect: TRect;
  dTop, dWidth, dHeight, Data: TData;
  b: integer;
  sControl: PControl;  
begin
  Row := ReadInteger(_Data, _data_Row);
  Col := ReadInteger(_Data, _data_Col);
  if not Assigned(_prop_MSTControl) then exit;
  sControl := _prop_MSTControl.ctrlpoint;
  
  R := sControl.LVSubItemRect(Row, Col);
  if Col = 0 then
  begin
    ARect := sControl.LVItemRect(Row, lvipLabel);
    R.Left := ARect.Left;
    R.Right := ARect.Right;
  end; 
  if fctl3d then
    b := 2
  else
    b := 1;

  dtInteger(Data, R.Left + sControl.Left + b);
  dtInteger(dWidth, R.Right - R.Left - 1);
  dtInteger(dTop, R.Top + sControl.Top + b);
  dtInteger(dHeight, R.Bottom - R.Top - 1);

  Data.ldata:= @dTop;
  dTop.ldata:= @dWidth;
  dWidth.ldata:= @dHeight;
  _hi_OnEvent_(_event_onClientRect, Data);
end;

end.