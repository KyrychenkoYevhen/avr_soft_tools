unit EWinList;

interface

uses
  Kol, Share, WinList, Windows, Debug, Messages, CodePages;

type
  THIEWinList = class(THIWinList)
    protected
      procedure SetStrings(const Value: string); override;
    public
      procedure _work_doLoad(var _Data: TData; Index: Word);
 end;

implementation

procedure THIEWinList._work_doLoad;
var
  FN: string;
  Strm: PStream;
  Text: string;
begin
  FN := ReadString(_Data, _data_FileName, _prop_FileName);
  Strm := NewReadFileStream(FN);
  if Strm.Handle <> INVALID_HANDLE_VALUE then
  begin
    Text := StreamReadString(Strm, Strm.Size, FInCharset, True);
    SetStrings(Text);
    _hi_CreateEvent(_Data,@_event_onChange);
  end;
  Strm.Free;
end;

procedure THIEWinList.SetStrings;
begin
  SetStringsBefore(Length(Value));
  Control.Perform(WM_SETTEXT, 0, NativeInt(@Value[1]));
  SetStringsAfter;
end;

end.