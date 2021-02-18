unit hiSQLite_Exec;

interface

uses
  Kol, Share, Debug, SqLite3Api;

type
  THISQLite_Exec = class(TDebug)
    private
    public
      _prop_SQL: string;
      _prop_Charset: Byte;
      _data_dbHandle: THI_Event;
      _data_SQL: THI_Event;
      _event_onError: THI_Event;

      procedure _work_doExec(var _Data: TData; Index: Word);
      procedure _work_doCharset(var _Data: TData; Index: Word);
  end;

implementation

uses
  hiSQLite_DB, CodePages;


procedure THISQLite_Exec._work_doExec(var _Data: TData; Index: Word);
var
  id: Pointer;
  msg: PAnsiChar;
  s: string;
  {$ifdef UNICODE}SS: AnsiString;{$endif}
begin
  id := ReadObject(_Data, _data_dbHandle, SQLite_GUID);
  if id <> nil then
  begin
    s := ReadString(_Data, _data_SQL, _prop_SQL);
    {$ifdef UNICODE}
      case _prop_Charset of
        0: SS := s; // В ANSI
        1: SS := StringToUTF8(s); // В UTF-8
      else
        SS := BinaryStringAsAnsiString(s); // Произвольная кодировка, упакованная в binary string
      end;
      sqlite3_exec(id, PAnsiChar(SS), nil, nil, @msg);
    {$else}
      if _prop_Charset = 1 then s := StringToUTF8(s); // В UTF-8
      sqlite3_exec(id, PAnsiChar(s), nil, nil, @msg);
    {$endif}
    
    if msg <> nil then
    begin
      _hi_CreateEvent(_Data, @_event_onError, string(msg));
      sqlite3_free(msg);
    end;
  end;
end;

procedure THISQLite_Exec._work_doCharset(var _Data: TData; Index: Word);
begin
  _prop_Charset := ToInteger(_Data);
end;


end.
