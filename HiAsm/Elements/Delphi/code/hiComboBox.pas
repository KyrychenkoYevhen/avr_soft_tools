unit hiComboBox;

interface

{$I share.inc}

uses
  Windows, Messages, Kol, Share, LWinList, hiBoxDrawManager, hiIconsManager, hiIndexManager;

const
  MODE_COMBOBOX = 0;
  MODE_LISTBOX  = 1;
  CB_SETMINVISIBLE = 5889;

type
  THIComboBox = class(THILWinList)
    private
      fIdxMgr: IIndexManager;
      fBoxDrawManager: IBoxDrawManager;
      fIconsManager: IIconsManager;
      
      procedure SetIndexManager(Value: IIndexManager);
      procedure SetInitBoxDrawManager(Value: IBoxDrawManager);
      procedure SetIconsManager(Value: IIconsManager);
      
      function _OnMeasureItem(Sender: PObj; Idx: Integer): Integer;
      function _OnDrawItem(Sender: PObj; DC: HDC; const Rect: TRect; ItemIdx: Integer;
                            DrawAction: TDrawAction; ItemState: TDrawState): Boolean;
      procedure _OnChange(Obj: PObj);
      {$ifndef KOL3XX}
      procedure _OnDropDown(Sender: PObj);
      {$endif}
      
    protected
      function Add(const Text: string): Integer; override;
      procedure SetStringsBefore(Len: Cardinal); override;
      
    public
      _prop_ReadOnly: Byte;
      _prop_Text: string;
      _prop_Strings: string;
      _prop_Sort: Boolean;
      _prop_ItemHeight: Integer;
      _prop_EditSelectMode: Byte;     
      _prop_DropDownCount: Integer; // === DropDownCount
    
	    _data_ItemData: THI_Event;

      _event_onChangeText: THI_Event;
      
      property _prop_IndexManager:IIndexManager read fIdxMgr write SetIndexManager;
      property _prop_BoxDrawManager:IBoxDrawManager read fBoxDrawManager write SetInitBoxDrawManager;
      property _prop_IconsManager:IIconsManager read fIconsManager write SetIconsManager;
      
      destructor Destroy; override;
      
      procedure Init; override;
      procedure _work_doEditText(var _Data: TData; Index: Word);
      procedure _work_doEditTextNoEvents(var _Data: TData; Index: Word);
      procedure _work_doDropDownCount(var _Data: TData; Index: Word);
      procedure _work_doSelectData(var _Data: TData; Index: Word);
      
      procedure _var_Data(var _Data: TData; Index: Word);
      procedure _var_EditText(var _Data: TData; Index: Word);
      procedure _var_Index(var _Data: TData; Index: Word);
  end;

implementation

destructor THIComboBox.Destroy;
begin
  if (Assigned(_prop_IndexManager)) then
    _prop_IndexManager.removeControl(Control);
  inherited;
end;     

procedure THIComboBox.Init;
var
  Flags: TComboOptions;
begin
  Flags := [{coNoIntegralHeight}];
  if (_prop_ReadOnly = 0) then Include(Flags, coReadOnly);
  if _prop_Sort then Include(Flags, coSort);
  if ManFlags and $8 > 0 then Include(Flags, coOwnerDrawFixed);
  Control := NewCombobox(FParent, Flags);
  Control.OnMeasureItem:= _OnMeasureItem;
  
  //DropDownCount:
  {$ifdef KOL3XX}
  Control.DropDownCount := _prop_DropDownCount;  
  {$else}
  Control.OnDropDown := _OnDropDown;
  {$endif}
  
  inherited;
  
  SetStrings(_prop_Strings);
  with Control{$ifndef F_P}^{$endif} do
  begin
    if (_prop_ReadOnly <> 0) then OnChange := _OnChange;
    Text := _prop_Text;
    OnSelChange := _OnClick;
    if ManFlags and $8 > 0 then OnDrawItem  := _OnDrawItem;
    if (Count > 0) and (_prop_ReadOnly = 0) then CurIndex := 0; 
  end;
end;

procedure THIComboBox.SetIndexManager(Value: IIndexManager);
begin
  if Value <> nil then
  begin
    fIdxMgr := Value;  
    _prop_IndexManager.addControl(Control);
  end;
end;

procedure THIComboBox.SetInitBoxDrawManager(Value: IBoxDrawManager);
begin
  if Value <> nil then fBoxDrawManager := Value;
end;

procedure THIComboBox.SetIconsManager(Value: IIconsManager);
begin
  if Value <> nil then 
    fIconsManager := Value;
end;

procedure THIComboBox.SetStringsBefore(Len: Cardinal);
begin
  inherited;
  Control.Perform(CB_INITSTORAGE, 0, Len * SizeOf(Char));
end;

function THIComboBox.Add(const Text: string): Integer;
begin
  Result := Control.Perform(CB_ADDSTRING, 0, NativeUInt(PChar(Text)));
  if (_prop_ReadOnly = 0) and (Control.CurIndex < 0) then Control.CurIndex := 0;    
end;

function THIComboBox._OnMeasureItem(Sender: PObj; Idx: Integer): Integer;
begin
  Result := _prop_ItemHeight;
end;

function THIComboBox._OnDrawItem(Sender: PObj; DC: HDC; const Rect: TRect; ItemIdx: Integer;
          DrawAction: TDrawAction; ItemState: TDrawState): Boolean;
var
  idx: Integer;
  imgsz: Integer;
  cbRect: TRect;
  IList: PImageList;
begin
  Result := False;
  if Assigned(_prop_BoxDrawManager) then
  begin
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
        if (odsComboboxEdit in ItemState) then inc(Left);
        Bottom:= Top + imgsz; 
        Right:= Left + imgsz;
      end;
      if (idx < 0) or (idx > IList.Count - 1) then idx := SKIP;      
      IList.StretchDraw(idx, DC, cbRect);   
    end;
  end;
end;

procedure THIComboBox._OnChange(Obj: PObj);
begin
  _hi_onEvent(_event_onChangeText, Control.Caption);
end;


// === DropDownCount === //
{$ifndef KOL3XX}
procedure THIComboBox._OnDropDown( Sender: PObj );
var
  CB: PControl;
  IC: Integer;
  H: Integer;
begin
  CB := PControl( Sender );
  IC := CB.Count;
  if IC > _prop_DropDownCount then IC := _prop_DropDownCount;
  if IC < 1 then IC := 1;
  
  H := CB.Perform(CB_GETITEMHEIGHT, 0, 0);
  
  SetWindowPos(CB.Handle, 0, 0, 0, CB.Width, CB.Height + (H * IC) + 2,
                SWP_NOMOVE + SWP_NOZORDER + SWP_NOACTIVATE + SWP_NOSENDCHANGING);
end;
{$endif}

procedure THIComboBox._work_doDropDownCount;
begin
  {$ifdef KOL3XX}
  Control.DropDownCount := ToInteger(_Data);  
  {$else}
  _prop_DropDownCount := ToInteger(_Data);  
  {$endif}
end;
// === ============ === //

procedure THIComboBox._work_doEditText(var _Data: TData; Index: Word);
begin
  Control.Caption := Share.ToString(_Data);
  case _prop_EditSelectMode of
    0: Control.Perform(CB_SETEDITSEL, 0, Integer($FFFF0000));
    1: Control.Perform(CB_SETEDITSEL, 0, MAKELPARAM(length(Control.Caption), length(Control.Caption)));
  end;
  _hi_onEvent(_event_onChangeText, Control.Caption);  
end;

procedure THIComboBox._work_doEditTextNoEvents(var _Data: TData; Index: Word);
begin
  Control.Caption := Share.ToString(_Data);
  case _prop_EditSelectMode of
    0: Control.Perform(CB_SETEDITSEL, 0, Integer($FFFF0000));
    1: Control.Perform(CB_SETEDITSEL, 0, MAKELPARAM(length(Control.Caption), length(Control.Caption)));
  end;
end;

procedure THIComboBox._work_doSelectData(var _Data: TData; Index: Word);
var
  i: Integer;
  ItemData: NativeInt;
begin
  ItemData := ReadInteger(_Data, _data_ItemData);
  for i := 0 to Control.Count - 1 do
  begin
    if NativeInt(Control.ItemData[i]) = ItemData then 
    begin 
      Control.CurIndex := i;
      break; 
    end; 
  end;
end;


procedure THIComboBox._var_Data(var _Data: TData; Index: Word);
begin
  dtInteger(_Data, Control.ItemData[Control.CurIndex]);
end;

procedure THIComboBox._var_EditText(var _Data: TData; Index: Word);
begin
  dtString(_Data, Control.Caption);
end;

procedure THIComboBox._var_Index(var _Data: TData; Index: Word);
begin
  dtInteger(_Data, Control.CurIndex);
end;


end.