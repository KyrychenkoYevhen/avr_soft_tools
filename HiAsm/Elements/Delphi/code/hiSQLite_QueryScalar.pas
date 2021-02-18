unit hiSQLite_QueryScalar;

interface

uses
  Kol, Share, Debug, SqLite3Api;

type
  THISQLite_QueryScalar = class(TDebug)
    private
      FResult: string; 
    public
      _prop_SQL: string;
      _prop_Charset: Byte;

      _data_SQL: THI_Event;
      _data_dbHandle: THI_Event;
      _event_onError: THI_Event;
      _event_onQuery: THI_Event;

      procedure _work_doQuery(var _Data: TData; Index: Word);
      procedure _work_doCharset(var _Data: TData; Index: Word);
      procedure _var_Result(var _Data: TData; Index: Word);
  end;

implementation

uses
  hiSQLite_DB, CodePages;

function callback(user: Pointer; ncols: Integer; values: PCharPointers; names: PCharPointers): Integer; cdecl;
var
  S: AnsiString;
  {$ifdef UNICODE}SS: string;{$endif}
begin
  S := AnsiString(values[0]); 
  {$ifdef UNICODE}
    case THISQLite_QueryScalar(user)._prop_Charset of
      0: SS := S; // Из ANSI
      1: SS := UTF8ToString(S); // Из UTF-8
    else
      SS := AnsiStringAsBinaryString(S); // Произвольная кодировка, упакованная в binary string
    end;
    THISQLite_QueryScalar(user).FResult := SS; 
  {$else}
    if THISQLite_QueryScalar(user)._prop_Charset = 1 then  S := UTF8ToString(S); // Из UTF-8
    THISQLite_QueryScalar(user).FResult := S; 
  {$endif}
  Result := 0;
end;

procedure THISQLite_QueryScalar._work_doQuery;
var
  id: Pointer;
  msg: PAnsiChar;
  s: string;
  {$ifdef UNICODE}SS: AnsiString;{$endif}
begin
  FResult := '';
  id := ReadObject(_Data, _data_dbHandle, SQLite_GUID);
  s := ReadString(_Data, _data_SQL, _prop_SQL);
  if id <> nil then
  begin
    {$ifdef UNICODE}
      case _prop_Charset of
        0: SS := s; // В ANSI
        1: SS := StringToUTF8(s); // В UTF-8
      else
        SS := BinaryStringAsAnsiString(s); // Произвольная кодировка, упакованная в binary string
      end;
      sqlite3_exec(id, PAnsiChar(SS), callback, self, @msg);
    {$else}
      if _prop_Charset = 1 then s := StringToUTF8(s); // В UTF-8
      sqlite3_exec(id, PAnsiChar(s), callback, self, @msg);
    {$endif}
    
    if msg <> nil then
    begin
      _hi_CreateEvent(_Data, @_event_onError, string(msg));
      sqlite3_free(msg);
    end
    else
      _hi_CreateEvent(_Data, @_event_onQuery, FResult);
  end;
end;

procedure THISQLite_QueryScalar._work_doCharset;
begin
  _prop_Charset := ToInteger(_Data);
end;

procedure THISQLite_QueryScalar._var_Result;
begin
  dtString(_Data, FResult);
end;

end.
