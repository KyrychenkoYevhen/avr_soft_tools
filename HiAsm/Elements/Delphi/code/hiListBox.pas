unit hiListBox;

interface

{$I share.inc}

uses
  Windows, Messages, Kol, Share, LWinList, hiBoxDrawManager, hiIconsManager, hiIndexManager;

const
  MODE_COMBOBOX      = 0;
  MODE_LISTBOX       = 1;
  MODE_LISTBOXTRANS  = 2;

type
  THIListBox = class(THILWinList)
    private
      Arr, ValArr: PArray;
      fIdxMgr: IIndexManager;
      fBoxDrawManager: IBoxDrawManager;
      fIconsManager: IIconsManager;
      
      procedure Select(idx: Integer); override;
      function _OnMeasureItem( Sender: PObj; Idx: Integer): Integer;
      function _OnDrawItem(Sender: PObj; DC: HDC; const Rect: TRect; ItemIdx: Integer;
                            DrawAction: TDrawAction; ItemState: TDrawState): Boolean;
      procedure _arr_set(var Item: TData; var Val: TData);
      function  _arr_get(var Item: TData; var Val: TData): Boolean;
      function  _arr_count:Integer;
      procedure _val_arr_set(var Item: TData; var Val: TData);
      function  _val_arr_get(var Item: TData; var Val: TData): Boolean;
    
      procedure SetIndexManager(Value: IIndexManager);
      procedure SetInitBoxDrawManager(Value: IBoxDrawManager);
      procedure SetIconsManager(Value: IIconsManager);
      
    protected
      function Add(const Text: string): Integer; override;
      procedure SetStringsBefore(Len: Cardinal); override;
      
    public
      _prop_Strings: string;
      _prop_Sort: Boolean;
      _prop_MultiSelect: Boolean;
      _prop_ItemHeight: Integer;
      _prop_ScrollBar: Boolean;
      
	    _data_ItemData: THI_Event;
      
      property _prop_IndexManager:IIndexManager read fIdxMgr write SetIndexManager;
      property _prop_BoxDrawManager:IBoxDrawManager read fBoxDrawManager write SetInitBoxDrawManager;
      property _prop_IconsManager:IIconsManager read fIconsManager write SetIconsManager;     

      procedure Init; override;
      destructor Destroy; override;
      
      procedure _work_doSelectAll(var _Data: TData; Index: Word);
      procedure _work_doEnsureVisible(var _Data: TData; Index: Word);      
      procedure _work_doUp(var _Data: TData; Index: Word);
      procedure _work_doDown(var _Data: TData; Index: Word);
      procedure _work_doInsert(var _Data: TData; Index: Word);  
      procedure _work_doSelectData(var _Data: TData; Index: Word);      
      
      procedure _var_Index(var _Data: TData; Index: Word);
      procedure _var_SelectArray(var _Data: TData; Index: Word);
      procedure _var_ValueArray(var _Data: TData; Index: Word);
      procedure _var_Data(var _Data: TData; Index: Word);
  end;


implementation



function WndProcSCR(Sender: PControl; var Msg: TMsg; var Rslt: LRESULT): Boolean;
var
  pulScrollLines: Integer;
  TopIdx: Integer;
begin
  Result := False;
    case Msg.message of
	  WM_MOUSEWHEEL:
	  begin
        SystemParametersInfo(SPI_GETWHEELSCROLLLINES, 0, @pulScrollLines, 0);
        TopIdx := SendMessage(Sender.Handle, LB_GETTOPINDEX, 0, 0);
        if SmallInt(Msg.wParam shr 16) < 0 then
          TopIdx := TopIdx + pulScrollLines 
        else if SmallInt(Msg.wParam shr 16) > 0 then
          TopIdx := max(0, TopIdx - pulScrollLines);
        SendMessage(Sender.Handle, LB_SETTOPINDEX, TopIdx, 0);
      end;
    end;
//  end;
end;



destructor THIListBox.Destroy;
begin
  if Arr <> nil then dispose(Arr);
  if ValArr <> nil then dispose(ValArr);
  if (Assigned(_prop_IndexManager)) then
    _prop_IndexManager.removeControl(Control);
  inherited;   
end;

procedure THIListBox.Init;
var  Fl:TListOptions;
begin
  fl := [loNoIntegralHeight, loNoExtendSel];
  if _prop_Sort then include(Fl,loSort);
  if _prop_MultiSelect then include(Fl,loMultiSelect);
  if ManFlags and $8 > 0 then include(Fl,loOwnerDrawFixed);
  Control := NewListbox(FParent,fl);
  Control.OnMeasureItem:= _OnMeasureItem;
  if not _prop_ScrollBar then
  begin
    Control.Style := Control.Style and not WS_VSCROLL;
    Control.AttachProc(WndProcSCR);    
  end;  
  
  if _prop_Ctl3D = 1 then Control.Ctl3D := False;
  
  inherited;
  SetStrings(_prop_Strings);
  Control.OnSelChange := _OnClick;
  if ManFlags and $8 > 0 then Control.OnDrawItem  := _OnDrawItem;
  SendMessage(Control.GetWindowHandle,LB_SETHORIZONTALEXTENT, 200, 0);
  //ShowScrollBar(Control.GetWindowHandle,SB_HORZ,true);
end;

procedure THIListBox.SetIndexManager;
begin
  if Value <> nil then
  begin
    fIdxMgr := Value;  
    _prop_IndexManager.addControl(Control);
  end;
end;

procedure THIListBox.SetInitBoxDrawManager;
begin
  if Value <> nil then fBoxDrawManager := Value;
end;

procedure THIListBox.SetIconsManager;
begin
  if Value <> nil then 
    fIconsManager := Value;
end;

function THIListBox._OnDrawItem;
var
  idx: Integer;
  imgsz: Integer;
  cbRect: TRect;
  IList: PImageList;
begin
   Result := False;
   if Assigned(_prop_BoxDrawManager) then begin
      Result := _prop_BoxDrawManager.draw(Sender, DC, Rect, ItemIdx, ItemState, False, PControl(Sender).Font.Handle);
      if (Assigned(_prop_IndexManager)) and (Assigned(_prop_IconsManager)) then
      begin
         IList := _prop_IconsManager.iconList;
         if not Assigned(IList) then exit;
         cbRect := Rect;
         idx := _prop_IndexManager.outidx(ItemIdx);
         imgsz := _prop_IconsManager.imgsz;         
         with cbRect do
         begin
            Top:= Top + (Bottom - Top - imgsz) div 2;
            Left:= _prop_BoxDrawManager.shift;
            Bottom:= Top + imgsz; 
            Right:= Left + imgsz;
         end;
         if (idx < 0) or (idx > IList.Count - 1) then
           idx := SKIP;      
         IList.StretchDraw(idx, DC, cbRect);   
      end;
   end;
end;

function THIListBox._OnMeasureItem;
begin
  Result := _prop_ItemHeight;
end;

procedure THIListBox._arr_set;
var
  ind: Integer;
begin
  ind := ToIntIndex(Item);
  if(ind >=0)and(ind < Control.Count)then
    Control.ItemSelected[ind] := ReadBool(Val);
end;

function THIListBox._arr_get;
var
  ind: Integer;
begin
  ind := ToIntIndex(Item);
  Result := (ind >= 0) and (ind < Control.Count);
  if Result then
    dtInteger(Val, Byte(Control.ItemSelected[ind]));
end;

function THIListBox._arr_count;
begin
  Result := Control.Count;
end;

procedure THIListBox._val_arr_set;
var
  ind: Integer;
begin
  ind := ToIntIndex(Item);
  if (ind >=0) and (ind < Control.Count) then
    Control.ItemData[ind] := ToInteger(Val);
end;

function THIListBox._val_arr_get;
var
  ind: Integer;
begin
  ind := ToIntIndex(Item);
  Result := (ind >= 0) and (ind < Control.Count);
  if Result then
    dtInteger(Val, Control.ItemData[ind]);
end;

procedure THIListBox.SetStringsBefore(Len: Cardinal);
begin
  inherited;
  Control.Perform(LB_INITSTORAGE, 0, Len);
end;

procedure THIListBox.Select;
begin
  if  _prop_MultiSelect then
    Control.ItemSelected[idx] := not Control.ItemSelected[idx]
  else inherited;
end;

function  THIListBox.Add(const Text: string): Integer;
begin
  Result := Control.Perform(LB_ADDSTRING, 0, NativeInt(PChar(Text)));
end;

procedure THIListBox._work_doSelectAll;
var  a:Boolean; i:Integer;
begin
  a := ReadBool(_Data);
  if _prop_MultiSelect then
    Control.ItemSelected[-1] := a
  else for i := 0 to Control.Count-1 do
    Control.ItemSelected[i] := a;
end;

procedure THIListBox._work_doUp;
var
  str2: string;
  data2: Integer;
begin
  if Control.CurIndex <= 0 then exit;

  str2 := Control.Items[Control.CurIndex - 1];
  data2 := Control.ItemData[Control.CurIndex - 1];
  
  Control.Items[Control.CurIndex - 1] := Control.Items[Control.CurIndex];
  Control.ItemData[Control.CurIndex - 1] := Control.ItemData[Control.CurIndex];    

  Control.Items[Control.CurIndex] := str2;
  Control.ItemData[Control.CurIndex] := data2;

  Control.CurIndex := Control.CurIndex - 1;
end;

procedure THIListBox._work_doDown;
var
  str2: string;
  data2: Integer;
begin
  if (Control.CurIndex = (Control.Count - 1)) or (Control.CurIndex < 0) then exit;

  str2 := Control.Items[Control.CurIndex + 1];
  data2 := Control.ItemData[Control.CurIndex + 1];
  
  Control.Items[Control.CurIndex + 1] := Control.Items[Control.CurIndex];
  Control.ItemData[Control.CurIndex + 1] := Control.ItemData[Control.CurIndex];    

  Control.Items[Control.CurIndex] := str2;
  Control.ItemData[Control.CurIndex] := data2;

  Control.CurIndex := Control.CurIndex + 1;
end;

procedure THIListBox._work_doEnsureVisible;
begin
  Control.Perform(LB_SETTOPINDEX, ToInteger(_Data), 0);
end;

procedure THIListBox._work_doInsert;
var
  ind: Integer;
  dt: TData;
begin
  ind := ToIntIndex(_Data);
  if (ind < -1) or (ind > Control.Count) then Exit;
  if ind = -1 then ind := Control.Count;
  
  Control.Insert(ind, ReadString(_Data, _data_Str));
  if _prop_SelectAdd then Control.CurIndex := ind;
  dt := ReadData(_Data,_data_Value);
  Control.ItemData[ind] := ToInteger(dt);  
  _hi_CreateEvent(_Data,@_event_onChange);
end;

procedure THIListBox._work_doSelectData;
var
  i, ItemData: NativeInt;
begin
  ItemData := ReadInteger(_Data, _data_ItemData);
  for i := 0 to Control.Count - 1 do
  begin
    if Integer(Control.ItemData[i]) = ItemData then 
    begin 
      Control.CurIndex := i;
      break; 
    end; 
  end;
end;

procedure THIListBox._var_SelectArray;
begin
  if Arr = nil then
    Arr := CreateArray(_arr_set, _arr_get, _arr_count, nil);
  dtArray(_Data, Arr);
end;

procedure THIListBox._var_ValueArray;
begin
  if ValArr = nil then
    ValArr := CreateArray(_val_arr_set,_val_arr_get,_arr_count,nil);
  dtArray(_Data,ValArr);
end;

procedure THIListBox._var_Data;
begin
  dtInteger(_Data, Control.ItemData[Control.CurIndex]);
end;

procedure THIListBox._var_Index;
begin
  dtInteger(_Data,Control.CurIndex);
end;

end.