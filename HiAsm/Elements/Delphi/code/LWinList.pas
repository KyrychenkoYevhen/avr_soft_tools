unit LWinList;

interface

uses
  Windows, Messages, Kol, Share, WinList, Debug, CodePages;

type
 THILWinList = class(THIWinList)
   protected
    procedure SetStrings(const Value:string); override;
   public
    procedure _work_doLoad(var _Data:TData; Index:word);
 end;

implementation

procedure THILWinList._work_doLoad;
var
  FN: string;
  S: string;
  Strm: PStream;
  //List: PKOLStrList;
  //I: Integer;
begin
  FN := ReadString(_Data, _data_FileName, _prop_FileName);
  Strm := NewReadFileStream(FN);
  if Strm.Handle <> INVALID_HANDLE_VALUE then
  begin
    S := StreamReadString(Strm, Strm.Size, FInCharset, True);
    if S <> '' then
    begin
      {SetStringsBefore(Length(S));
      List := NewKOLStrList; // TODO: прямой парсинг строки по \r\n без задействования KOLStrList
      List.Text := S;
      for I := 0 to List.Count - 1 do
        Add(ListItems[I]);
      List.Free;
      SetStringsAfter;}
      SetStrings(S);
      _hi_CreateEvent(_Data, @_event_onChange);
    end;
  end;
  Strm.Free;
end;

procedure THILWinList.SetStrings;
var
  List: PKOLStrList;
  I: Integer;
begin
  if Value <> '' then
  begin
    SetStringsBefore(Length(Value));
    List := NewKOLStrList;
    List.Text := Value;
    for I := 0 to List.Count - 1 do
      Add(List.Items[I]);
    List.Free;
    SetStringsAfter;
  end;
end;

end.