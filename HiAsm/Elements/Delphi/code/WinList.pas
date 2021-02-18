unit WinList;

interface

uses
  Windows, Messages, Kol, Share, Win, Debug, CodePages;

const
  RDW_NO  = 0;
  RDW_YES = 1;


type
 THIWinList = class(THIWin)
   private
    Arr:PArray;
    
    procedure SetInCharset(Value: Byte);
    procedure SetOutCharset(Value: Byte);
    
   protected
    FList:PKOLStrList;
    
    FInCharset: Integer;
    FOutCharset: Integer;
    
    procedure SaveToList; virtual;
    procedure SetStrings(const Value: string); virtual; abstract;
    procedure SetStringsBefore(Len: Cardinal); virtual;
    procedure SetStringsAfter; virtual;
    function  Add(const Text: string): Integer; virtual;
    procedure Select(Idx: Integer); virtual;
    procedure _OnClick(Obj: PObj);

    procedure _Set(var Item: TData; var Val: TData); virtual;
    function  _Get(var Item: TData; var Val: TData): Boolean;
    function  _Count: Integer;
    procedure _Add(var Val: TData);
   public
    _prop_FileName: string;
    _prop_AddType: Byte;
    _prop_SelectAdd: Boolean;
    _prop_DataType: Byte;
    _prop_OutBOM: Byte;

    _data_FileName: THI_Event;
    _data_Str: THI_Event;
    _data_Value: THI_Event;
    _event_onChange: THI_Event;
    _event_onClick: THI_Event;
    _event_onSelect: THI_Event;

    property _prop_InCharset: Byte write SetInCharset;
    property _prop_OutCharset: Byte write SetOutCharset;
    
    constructor Create(Parent: PControl);
    destructor Destroy; override;
    
    procedure _work_doAdd(var _Data: TData; Index: Word);
    procedure _work_doClear(var _Data: TData; Index: Word); virtual;
    procedure _work_doDelete(var _Data: TData; Index: Word);
    procedure _work_doText(var _Data: TData; Index: Word);
    procedure _work_doSave(var _Data: TData; Index: Word);
    procedure _work_doAppend(var _Data: TData; Index: Word);
    procedure _work_doAddDir(var _Data: TData; Index: Word);
    procedure _work_doReplace(var _Data: TData; Index: Word);
    procedure _work_doSort(var _Data: TData; Index: Word);

    procedure _work_doSetSelect(var _Data: TData; Index: Word);
    procedure _work_doSetSelStart(var _Data: TData; Index: Word);
    procedure _work_doSetSelLength(var _Data: TData; Index: Word);
    procedure _work_doSelect(var _Data: TData; Index: Word);
    procedure _work_doSelectString(var _Data: TData; Index: Word);
    
    procedure _work_doInCharset(var _Data: TData; Index: Word);
    procedure _work_doOutCharset(var _Data: TData; Index: Word);
    procedure _work_doOutBOM(var _Data: TData; Index: Word);

    procedure _var_Text(var _Data: TData; Index: Word); virtual;
    procedure _var_Count(var _Data: TData; Index: Word);
    procedure _var_EndIdx(var _Data: TData; Index: Word);
    procedure _var_Array(var _Data: TData; Index: Word);
    procedure _var_String(var _Data: TData; Index: Word);
    procedure _var_SelText(var _Data: TData; Index: Word);
 end;

implementation

constructor THIWinList.Create(Parent: PControl);
begin
  FInCharset := DefaultCompilerCP;
  FOutCharset := DefaultCompilerCP;
  _prop_OutBOM := 1;
  inherited;
end;

destructor THIWinList.Destroy;
begin
  if Arr <> nil then Dispose(Arr);
  inherited;
end;

procedure THIWinList.SetInCharset(Value: Byte);
begin
  FInCharset := InCharsetPropText[Value];
end;

procedure THIWinList.SetOutCharset(Value: Byte);
begin
  FOutCharset := OutCharsetPropText[Value];
end;

procedure THIWinList._OnClick(Obj: PObj);
var
  I: NativeInt;
  dt, di: TData;
begin
  I := Control.CurIndex;
  if _prop_DataType = 1 then
    dtString(dt, Control.Items[I])
  else
    dtInteger(dt, I);
  I := Control.ItemData[I];
  if I <> -1 then
  begin
    dtInteger(di, I);
    dt.ldata := @di;
  end;
  _hi_OnEvent_(_event_onClick, dt);
end;

procedure THIWinList.SaveToList;
var
  I: Integer;
begin
  for I := 0 to Control.Count - 1 do
    FList.Add(Control.Items[I]);
end;

procedure THIWinList.Select(Idx: Integer);
begin
  if (Idx < 0) or (Idx >= Control.Count) then
    Idx := -1;
  Control.CurIndex := Idx;
end;

procedure THIWinList._work_doSelect(var _Data: TData; Index: Word);
var
  I: integer;
  dt, di: TData;
begin
  Select(ToInteger(_Data));
  I := Control.CurIndex;
  if _prop_DataType = 1 then
    if I <> -1 then
      dtString(dt, Control.Items[I])
    else
      dtString(dt, '')
  else
    dtInteger(dt, I);
  I := Control.ItemData[I];
  if I <> -1 then
  begin
    dtInteger(di, I);
    dt.ldata := @di;
  end;
  _hi_OnEvent_(_event_onSelect, dt);
end;

procedure THIWinList._work_doSelectString(var _Data: TData; Index: Word);
var
  S, L: string;
begin
  S := Share.ToString(_Data);
  if S = '' then exit;
  L := GetTok(S, '*');
  Select(Control.SearchFor(L, -1, S<>L));
end;

procedure THIWinList._work_doAdd(var _Data: TData; Index: Word);
var
  S: string;
  Idx: Integer;
  dt: TData;
begin
  S := ReadString(_Data, _data_Str);
  if _prop_AddType = 0 then
    Idx := Add(S)
  else
  begin
    Idx := Control.Insert(0, S);
    if Idx = -1 then Control.Text := S + #13#10 + Control.Text;
  end;
  if _prop_SelectAdd then Control.CurIndex := Idx;
  dt := ReadData(_Data,_data_value);
//   if _isInteger(dt) then Control.ItemData[Idx] := ToInteger(dt);
  Control.ItemData[Idx] := ToInteger(dt);
  _hi_CreateEvent(_Data,@_event_onChange);
end;

function THIWinList.Add(const Text: string): Integer;
begin
  Result := Control.Add(Text);
end;

procedure THIWinList._work_doClear(var _Data: TData; Index: Word);
begin
  Control.Clear;
  _hi_CreateEvent(_Data, @_event_onChange);
end;

procedure THIWinList._work_doDelete(var _Data: TData; Index: Word);
var
  Ind, SelStart, SelEnd, FHandle: Integer;
begin
  Ind := ToInteger(_Data);
  if Ind < 0 then Exit;
  Control.Delete(Ind);
  FHandle := Control.Handle;
  SelStart := SendMessage(FHandle, EM_LINEINDEX, Ind, 0);
  if SelStart >= 0 then
  begin
    SelEnd := SendMessage(FHandle, EM_LINEINDEX, Ind + 1, 0);
    if SelEnd < 0 then SelEnd := SelStart +
           SendMessage(FHandle, EM_LINELENGTH, SelStart, 0);
    SendMessage(FHandle, EM_SETSEL, SelStart, SelEnd);
    SendMessage(FHandle, EM_REPLACESEL, 0, NativeInt(PChar('')));
  end;
  
  _hi_CreateEvent(_Data,@_event_onChange);
end;

procedure THIWinList._work_doText(var _Data: TData; Index: Word);
begin
  SetStrings(Share.ToString(_Data));
  _hi_CreateEvent(_Data, @_event_onChange);
end;

procedure THIWinList._work_doSave(var _Data: TData; Index: Word);
var
  FN: string;
begin
  FN := ReadString(_Data, _data_FileName, _prop_FileName);
  FList := NewKOLStrList;
  SaveToList;
  //FList.SaveToFile(FN);
  StrListSaveToFile(FList, FN, FOutCharset, (_prop_OutBOM <> 0));
  FList.Free;
end;

procedure THIWinList._work_doAppend(var _Data: TData; Index: Word);
var
  FN: string;
begin
  FN := ReadString(_Data, _data_FileName, _prop_FileName);
  FList := NewKOLStrList;
  //FList.LoadFromFile(FN);
  SaveToList;
  //FList.SaveToFile(FN);
  StrListSaveToFile(FList, FN, FOutCharset, (_prop_OutBOM <> 0), True);
  FList.Free;   
end;

procedure THIWinList._work_doAddDir(var _Data: TData; Index: Word);
var
  Lst: PDirList;
begin
  Lst := NewDirList(Share.ToString(_Data), '*.*', FILE_ATTRIBUTE_NORMAL);
  SetStrings(Lst.FileList(#13#10, False, False)); //!!!
  Lst.Free;
end;

procedure THIWinList._work_doReplace(var _Data: TData; Index: Word);
var
  Ind: integer;
begin
  Ind := ReadInteger(_Data, NULL);
  if (ind >= 0) and (Ind < Control.Count) then
    Control.Items[Ind] := ReadString(_Data, _data_Str);
end;

procedure THIWinList._work_doSort(var _Data: TData; Index: Word);
begin
  if Control.Count <= 0 then Exit;
  FList := NewKOLStrList;
  SaveToList;
  FList.Sort(true);
  SetStrings(FList.Text);
  FList.Free;
end;

procedure THIWinList._work_doSetSelect(var _Data: TData; Index: Word);
begin
  Control.Selection := Share.ToString(_Data);
end;

procedure THIWinList._work_doSetSelStart(var _Data: TData; Index: Word);
begin
  Control.SelStart := ToInteger(_Data);
end;

procedure THIWinList._work_doSetSelLength(var _Data: TData; Index: Word);
begin
  Control.SelLength := ToInteger(_Data);
end;

procedure THIWinList._work_doInCharset(var _Data: TData; Index: Word);
begin
  FInCharset := ToInteger(_Data);
end;

procedure THIWinList._work_doOutCharset(var _Data: TData; Index: Word);
begin
  FOutCharset := ToInteger(_Data);
end;

procedure THIWinList._work_doOutBOM(var _Data: TData; Index: Word);
begin
  _prop_OutBOM := ToInteger(_Data) and 1;
end;



procedure THIWinList._var_Text(var _Data: TData; Index: Word);
var
  S: string;
begin
  FList := NewKOLStrList;
  SaveToList;
  S := FList.Text; 
  if (FList.Count > 0) and (FList.Items[FList.Count-1] <> '') then
    Delete(S, Length(S)-1, 2); 
  dtString(_Data, S);
  FList.Free;
end;

procedure THIWinList._var_Count(var _Data: TData; Index: Word);
begin
  dtInteger(_Data, Control.Count);
end;

procedure THIWinList._var_EndIdx;
begin
  dtInteger(_Data, Control.Count - 1);
end;

procedure THIWinList._Set(var Item: TData; var Val: TData);
var
  Ind: Integer;
begin
  Ind := ToIntIndex(Item);
  if (Ind >= 0) and (Ind < Control.Count) then
    Control.Items[Ind] := Share.ToString(Val);
end;

procedure THIWinList._Add(var Val: TData);
begin
  Add(Share.ToString(Val));
end;

function THIWinList._Get(var Item: TData; var Val: TData): Boolean;
var
  Ind: Integer;
begin
  Ind := ToIntIndex(Item);
  Result := (Ind >= 0) and (Ind < Control.Count);
  if Result then dtString(Val, Control.Items[Ind]);
end;

function THIWinList._Count: Integer;
begin
  Result := Control.Count;
end;

procedure THIWinList._var_Array(var _Data: TData; Index: Word);
begin
  if Arr = nil then
    Arr := CreateArray(_Set, _Get, _Count, _Add);
  dtArray(_Data, Arr);
end;

procedure THIWinList._var_String(var _Data: TData; Index: Word);
begin
  if (Control.curindex >= 0) then
    dtString(_data,Control.Items[Control.curindex])
  else
    dtNull(_data);
end;

procedure THIWinList._var_SelText(var _Data: TData; Index: Word);
begin
  dtString(_Data, Control.Selection);
end;

procedure THIWinList.SetStringsBefore(Len: Cardinal);
{$ifdef KOL3XX}var V: Boolean;{$endif}
begin
  //  акое-то странное поведение в новой KOL:
  // если установить WM_SETREDRAW := False, а после сделать Control.Clear,
  // (которое приводит к вызову WM_SETTEXT и Invalidate в TControl.SetCaption),
  // то Control.Visible стаЄт False и последующее WM_SETREDRAW := True в
  // THIWinList.SetStringsAfter не выполнитс€

{$ifdef KOL3XX}
  V := Control.Visible;
  if V then
{$else}
  if Control.Visible then
{$endif}
    Control.Perform(WM_SETREDRAW, RDW_NO, 0);
  Control.Clear;
{$ifdef KOL3XX}if V then Control.Visible := True;{$endif}
end;

procedure THIWinList.SetStringsAfter;
begin
  if Control.Visible = False then Exit;
  Control.Perform(WM_SETREDRAW, RDW_YES, 0);
  InvalidateRect(Control.Handle, nil, False);
end;

end.