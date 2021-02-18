unit hiSQLite_Query;

interface

uses
  Kol, Share, Debug, SqLite3Api;

type
  THISQLite_Query = class(TDebug)
    private
      cok: Boolean;
    public
      _prop_SQL: string;
      _prop_Charset: Byte;
      
      _data_dbHandle: THI_Event;
      _data_SQL: THI_Event;
      
      _event_onQuery: THI_Event;
      _event_onColumns: THI_Event;
      _event_onError: THI_Event;

      procedure _work_doQuery(var _Data: TData; Index: Word);
      procedure _work_doCharset(var _Data: TData; Index: Word);
      procedure _var_LastRowID(var _Data: TData; Index: Word);
  end;

implementation

uses
  hiSQLite_DB, CodePages;


function callback(user: Pointer; ncols: Integer; values: PCharPointers; names: PCharPointers): Integer; cdecl;
var
  dt, ndt: TData;
  sdt: PData;
  i: Integer;
  S: AnsiString;
  {$ifdef UNICODE}SS: string;{$endif}
begin
  if not THISQLite_Query(user).cok then
  begin
    dtNull(dt);
    for i := 0 to ncols-1 do
    begin
      S := AnsiString(names[i]);
      {$ifdef UNICODE}
        case THISQLite_Query(user)._prop_Charset of
          0: SS := S; // Из ANSI
          1: SS := UTF8ToString(S); // Из UTF-8
        else
          SS := AnsiStringAsBinaryString(S); // Произвольная кодировка, упакованная в binary string
        end;
        dtString(ndt, SS);
      {$else}
        if THISQLite_Query(user)._prop_Charset = 1 then S := UTF8ToString(S); // Из UTF-8
        dtString(ndt, S);
      {$endif}
    
      AddMTData(@dt, @ndt, sdt);
    end;
    ndt := dt;
    _hi_onEvent_(THISQLite_Query(user)._event_onColumns, dt);
    FreeData(@ndt);
    THISQLite_Query(user).cok := true;
  end;
  
  dtNull(dt);
  for i := 0 to ncols-1 do
  begin
    S := AnsiString(values[i]);
    {$ifdef UNICODE}
      case THISQLite_Query(user)._prop_Charset of
        0: SS := S; // Из ANSI
        1: SS := UTF8ToString(S); // Из UTF-8
      else
        SS := AnsiStringAsBinaryString(S); // Произвольная кодировка, упакованная в binary string
      end;
      dtString(ndt, SS);
    {$else}
      if THISQLite_Query(user)._prop_Charset = 1 then S := UTF8ToString(S); // Из UTF-8
      dtString(ndt, S);
    {$endif}
    AddMTData(@dt,@ndt,sdt);
  end;
  ndt := dt; 
  _hi_onEvent_(THISQLite_Query(user)._event_onQuery, dt);
  FreeData(@ndt);
  Result := 0;
end;

procedure THISQLite_Query._work_doQuery(var _Data: TData; Index: Word);
var
  id: Pointer;
  msg: PAnsiChar;
  s: string;
  {$ifdef UNICODE}SS: AnsiString;{$endif}
begin
  id := ReadObject(_Data, _data_dbHandle, SQLite_GUID);
  s := ReadString(_Data,_data_SQL,_prop_SQL);
  if id <> nil then
  begin
    cok := False;
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
    end;
  end;
end;

procedure THISQLite_Query._work_doCharset(var _Data: TData; Index: Word);
begin
  _prop_Charset := ToInteger(_Data);
end;

procedure THISQLite_Query._var_LastRowID(var _Data: TData; Index: Word);
var
  id: Pointer;
begin
  id := ReadObject(_Data, _data_dbHandle, SQLite_GUID);
  if id <> nil then
  begin
    dtInteger(_Data, Integer(sqlite3_last_insert_rowid(id)));
  end;
end;

end.