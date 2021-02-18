unit hiMST_RowAction;

interface
     
uses Kol, Share, Debug, hiMTStrTbl;

const
  ITM_ADD     = -3;
  ITM_INSERT  = -4;
  ITM_REPLACE = -5;

type
  THIMST_RowAction = class(TDebug)
  private

  public
    _prop_Action: byte;
    _prop_MSTControl: IMSTControl;
    _prop_Index: integer;

    _data_Index: THI_Event;
    _event_onChange,
    _event_onResult: THI_Event;
    
    procedure _work_doRowAction0(var _Data: TData; Index: word); // Add
    procedure _work_doRowAction1(var _Data: TData; Index: word); // Insert
    procedure _work_doRowAction2(var _Data: TData; Index: word); // Replace
    procedure _work_doRowAction3(var _Data: TData; Index: word); // DeleteRow
    procedure _work_doRowAction4(var _Data: TData; Index: word); // IconStr
    procedure _work_doRowAction5(var _Data: TData; Index: word); // ColorsStr
    procedure _work_doRowAction6(var _Data: TData; Index: word); // GetIconIdx
    procedure _work_doRowAction7(var _Data: TData; Index: word); // GetRowColors
    procedure _work_doRowAction8(var _Data: TData; Index: word); // UpRow
    procedure _work_doRowAction9(var _Data: TData; Index: word); // DownRow
    
    procedure _var_Count(var _Data: TData; Index: word);
    procedure _var_EndIdx(var _Data: TData; Index: word);    
  end;

implementation

// ��������� ������ � �������
// ARG(Col0, Col1, ... ColN)
//
procedure THIMST_RowAction._work_doRowAction0;
begin
  if not Assigned(_prop_MSTControl) then exit;
  _prop_MSTControl.actionitm(_Data, ITM_ADD);
  _hi_onEvent(_event_onChange);
end;

// ��������� ������ � �������
// ARG(IndexRow, Col0, Col1, ... ColN)
//
procedure THIMST_RowAction._work_doRowAction1;
begin
  if not Assigned(_prop_MSTControl) then exit;
  _prop_MSTControl.actionitm(_Data, ITM_INSERT);
  _hi_onEvent(_event_onChange);
end;

// �������� ������ � �������
// ARG(IndexRow, Col0, Col1, ... ColN)
//
procedure THIMST_RowAction._work_doRowAction2;
begin
  if not Assigned(_prop_MSTControl) then exit;
  _prop_MSTControl.actionitm(_Data, ITM_REPLACE);
  _hi_onEvent(_event_onChange);
end;

// ������� ������ �� �������
// ARG(IndexRow)
//
procedure THIMST_RowAction._work_doRowAction3;
var
  sControl: PControl;
  Item: integer;
begin
  if not Assigned(_prop_MSTControl) then exit;
  sControl := _prop_MSTControl.ctrlpoint;
  Item := ReadInteger(_Data, _data_Index, _prop_Index); 
  if (Item < 0) or (Item > sControl.Count - 1) then exit;
  if Assigned(PData(sControl.LVItemData[Item])) then
  begin
    FreeData(PData(sControl.LVItemData[Item]));
    Dispose(PData(sControl.LVItemData[Item]));
  end;  
  sControl.LVDelete(Item);
  _hi_onEvent(_event_onChange);
end;

// �������� ������ � ������ �� ������ �� ������
// ARG(IndexRow, IndexIcon)
//
procedure THIMST_RowAction._work_doRowAction4; // ��������
var
  idx, newico: integer;
  sControl: PControl;
  SmIList: PImageList;
begin
  if not Assigned(_prop_MSTControl) then exit;
  sControl := _prop_MSTControl.ctrlpoint;
  SmIList := _prop_MSTControl.smiconlist;

//  if _IsNULL(_Data) then exit;
  idx := ReadInteger(_Data, _data_Index, _prop_Index);
  newico := ReadInteger(_Data, Null);
  if Assigned(SmIList) and (idx >= 0) and (idx < sControl.Count) and
     (newico < SmIList.Count) then
  begin
    sControl.LVItemImageIndex[idx]:= newico;
    _hi_onEvent(_event_onChange);
  end;
end;

// ������������� ���� ������ ������ � ���� ������
// ���� � �������� ���������� ����� ����� �������� -1, �������� �������� �� �����
// ARG(IndexRow, IndexColorText (0 - TextColor), ColorRow (0 - TextBkColor))
//
procedure THIMST_RowAction._work_doRowAction5; // ��������
var
  idx, idxcolortxt, colorback: integer;
  sControl: PControl;
  FColorItems: boolean;
  Color: cardinal;
  FData: TData;
begin
//  if _IsNULL(_Data) then exit;

  if not Assigned(_prop_MSTControl) then exit;
  sControl := _prop_MSTControl.ctrlpoint;
  FColorItems := _prop_MSTControl.coloritems;
  
  idx := ReadInteger(_Data, _data_Index, _prop_Index);
  idxcolortxt := ReadInteger(_Data, Null);
  colorback := ReadInteger(_Data, Null);

  if (idx < 0) or (idx > sControl.Count - 1)
     or not FColorItems or (PData(sControl.LVItemData[idx]) = nil) then exit;

  CopyData(@FData, PData(sControl.LVItemData[idx]));

  Color := ToInteger(FData);
  if (idxcolortxt >= 0) and (idxcolortxt <= 15) then
  begin
    Color := $00FFFFFF and Color;
    Color := Cardinal(idxcolortxt shl 24) or Color;
  end;
  if colorback >= 0 then
  begin
    Color := $0F000000 and Color;
    Color := Color or Cardinal(colorback);  
  end;
  FData.data_type := data_int;
  FData.idata := Color;

  CopyData(PData(sControl.LVItemData[idx]), @FData);
  _hi_onEvent(_event_onChange);
end;

// �������� ������ ������ ��� ������
// ARG(IndexRow)
//
procedure THIMST_RowAction._work_doRowAction6;
var
  idx, ind: integer;
  sControl: PControl;
  SmIList: PImageList;
begin
  if not Assigned(_prop_MSTControl) then exit;
  sControl := _prop_MSTControl.ctrlpoint;
  SmIList := _prop_MSTControl.smiconlist;
  ind := ReadInteger(_Data, _data_Index, _prop_Index);;
  idx := -1;
  if Assigned(SmIList) and (SmIList.Count <> 0) and (sControl.Count <> 0) then
    idx := sControl.LVItemImageIndex[ind];
  _hi_onEvent(_event_onResult, idx);
end;

// �������� ���� ������ ������ � ���� ������
// ARG(IndexRow)
//
procedure THIMST_RowAction._work_doRowAction7; // ��������
var
  idx: integer;
  sControl: PControl;
  FData, di, dk, dt: TData;
  Color, idxcolor: cardinal;  
  FColorItems: boolean;  
begin
  if not Assigned(_prop_MSTControl) then exit;
  sControl := _prop_MSTControl.ctrlpoint;
  FColorItems := _prop_MSTControl.coloritems;

  idx:= ReadInteger(_Data, _data_Index, _prop_Index);;
  if (idx < 0) or (idx > sControl.Count - 1)
     or not FColorItems or (PData(sControl.LVItemData[idx]) = nil) then exit;

  CopyData(@FData, PData(sControl.LVItemData[idx]));

  Color := ToInteger(FData);
  dtInteger(dt, Color);
  idxcolor:= ($0F000000 and Color) shr 24;
  dtInteger(di, idxcolor);
  if $FFFFFF and Color = 0 then
     dtInteger(dk, Color2RGB(_prop_MSTControl.textbkcolor))
  else
     dtInteger(dk, $FFFFFF and Color);
  dt.ldata:= @di;
  di.ldata:= @dk;
  _hi_onEvent_(_event_onResult, dt);
end;

// �������� ���������� ����� � �������
//
procedure THIMST_RowAction._var_Count;
var
  sControl: PControl;
begin
  if not Assigned(_prop_MSTControl) then exit;
  sControl := _prop_MSTControl.ctrlpoint;
  dtInteger(_Data, sControl.Count);
end;

// �������� ������ ��������� ������ � �������
//
procedure THIMST_RowAction._var_EndIdx;
var
  sControl: PControl;
begin
  if not Assigned(_prop_MSTControl) then exit;
  sControl := _prop_MSTControl.ctrlpoint;
  dtInteger(_Data, sControl.Count - 1);
end;

// �������� ������ �����
// ARG(IndexRow)
//
procedure THIMST_RowAction._work_doRowAction8;
var
  sControl: PControl;
  dt, di: TData;
  oldindex: integer;
begin
  if not Assigned(_prop_MSTControl) then exit;
  sControl := _prop_MSTControl.ctrlpoint;
  oldindex := ReadInteger(_Data, _data_Index, _prop_Index); 
  if (oldindex <= 0) or (oldindex > sControl.Count - 1) then exit;
  dtNull(dt);
  dtNull(di);  
  oldindex := sControl.LVCurItem; 
  dt := _prop_MSTControl.getstring(oldindex);
  dtInteger(di, oldindex - 1);
  di.ldata := @dt;
  _prop_MSTControl.actionitm(di, ITM_INSERT);
  inc(oldindex); 
  if Assigned(PData(sControl.LVItemData[oldindex])) then
  begin
    FreeData(PData(sControl.LVItemData[oldindex]));
    Dispose(PData(sControl.LVItemData[oldindex]));
  end;  
  sControl.LVDelete(oldindex);
  sControl.LVCurItem := oldindex - 2; 
  _hi_onEvent(_event_onChange, sControl.LVCurItem);
end;

// �������� ������ ����
// ARG(IndexRow)
//
procedure THIMST_RowAction._work_doRowAction9;
var
  sControl: PControl;
  dt, di: TData;
  oldindex: integer;
begin
  if not Assigned(_prop_MSTControl) then exit;
  sControl := _prop_MSTControl.ctrlpoint;
  oldindex := ReadInteger(_Data, _data_Index, _prop_Index); 
  if (oldindex < 0) or (oldindex >= sControl.Count - 1) then exit;
  dtNull(dt);
  dtNull(di);  
  oldindex := sControl.LVCurItem; 
  dt := _prop_MSTControl.getstring(oldindex);
  dtInteger(di, oldindex + 2);
  di.ldata := @dt;
  _prop_MSTControl.actionitm(di, ITM_INSERT);
  if Assigned(PData(sControl.LVItemData[oldindex])) then
  begin
    FreeData(PData(sControl.LVItemData[oldindex]));
    Dispose(PData(sControl.LVItemData[oldindex]));
  end;  
  sControl.LVDelete(oldindex);
  sControl.LVCurItem := oldindex + 1; 
  _hi_onEvent(_event_onChange, sControl.LVCurItem);
end;

end.