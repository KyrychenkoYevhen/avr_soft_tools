unit hiClipboard;

interface

uses Windows,kol,Share,ShellAPI,ClipboardCopyPaste,Debug;

type
  THIClipboard = class(TDebug)
   private
    Bmp:PBitmap;
    Arr:PArray;
    FDropType:cardinal;
   public
    _data_PutText:THI_Event;
    _data_PutBitmap:THI_Event;
    _data_List:THI_Event;
    _data_PutType:THI_Event;
    _event_onGetItems:THI_Event;
    _event_onGetFinish:THI_Event;
    _prop_Unicode:byte;
    _prop_PutType:byte;

    destructor Destroy; override;
    procedure _work_doPutText(var _Data:TData; Index:word);
    procedure _work_doPutItems(var _Data:TData; Index:word);
    procedure _work_doGetItems(var _Data:TData; Index:word);
    procedure _var_Text(var _Data:TData; Index:word);
    procedure _var_Bitmap(var _Data:TData; Index:word);
    procedure _var_DropType(var _Data:TData; Index:word);
    procedure _work_doPutBitmap(var _Data:TData; Index:word);
    procedure _work_doPutType(var _Data:TData; Index:word);
    procedure _work_doUnicode(var _Data:TData; Index:word);
  end;

implementation

destructor THIClipboard.Destroy;
begin
  if Bmp <> nil then Bmp.Free;
  inherited;
end;

procedure THIClipboard._work_doPutText;
begin
  {$ifdef UNICODE}
    WText2Clipboard(ReadString(_Data, _data_PutText, ''));
  {$else}
    if Bool(_prop_Unicode) then
      Text2Clipboard(ReadString(_Data, _data_PutText, ''))
    else
      WText2Clipboard(WideString(ReadString(_Data, _data_PutText, '')));
  {$endif}
end;

procedure THIClipboard._work_doPutBitmap;
var
  Bitmap: PBitmap;
begin
  Bitmap := ReadBitmap(_Data, _data_PutBitmap);
  Bitmap.CopyToClipboard;
end;

procedure THIClipboard._work_doPutItems;
begin
  Arr := ReadArray(_data_List);
  if Arr = nil then Exit;
  PutClipboard(ReadInteger(_data, _data_PutType, _prop_PutType), Arr);
end;

procedure THIClipboard._work_doGetItems;
var
  H: THandle;
  Buffer: array[0..MAX_PATH] of Char;
  i, numFiles: Integer;
begin
  if not OpenClipboard(Applet.Handle) then Exit;
  if not IsClipboardFormatAvailable(CF_HDROP) then Exit;
  
  H := GetClipboardData(CF_HDROP);
  if H <> 0 then
  begin
    numFiles := DragQueryFile(H, $FFFFFFFF, nil, 0);
    GetDropType(FDropType);
    for i := 0 to numFiles - 1 do
    begin
      Buffer[0] := #0;
      DragQueryFile(H, i, Buffer, SizeOf(Buffer));
      _hi_OnEvent(_event_onGetItems, string(Buffer));
    end;
    //DragFinish(H); // repeatedly paste doesn't work
    
    // Если операция "вырезания" файлов - очищаем буфер
    // (как будто если после Paste файлы были физически перемещены).
    // Возможно, стоит добавить свойство, указывающее это поведение.
    if Bool(FDropType) then EmptyClipboard(); 
    
    _hi_OnEvent(_event_onGetFinish, numFiles);
  end;

  CloseClipboard;
end;

procedure THIClipboard._work_doUnicode;
begin
  _prop_Unicode := ToInteger(_Data);
end;

procedure THIClipboard._work_doPutType;
begin
  _prop_PutType := ToInteger(_Data);
end;

procedure THIClipboard._var_Text;
begin
  {$ifdef UNICODE}
    dtString(_Data, Clipboard2WText);
  {$else}
  if Bool(_prop_Unicode) then
    dtString(_Data, Clipboard2Text)
  else
    dtString(_Data, AnsiString(Clipboard2WText));
  {$endif}
end;

procedure THIClipboard._var_DropType;
begin
  dtInteger(_Data,FDropType);
end;

procedure THIClipboard._var_Bitmap;
begin
  if Bmp = nil then
    Bmp := NewBitmap(0, 0);
  
  Bmp.PasteFromClipboard;
  dtBitmap(_Data, Bmp);
end;

end.