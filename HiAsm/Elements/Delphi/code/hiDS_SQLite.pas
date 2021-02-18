unit hiDS_SQLite;

interface

uses
  Windows, Kol, Share, Debug, SqLite3Api, DS_client;

const
  NO_OPEN_DB = 'Database not opened';

type

  THIDS_SQLite = class(TDebug)
  private
    id: Pointer;
    ds: TIDataSource;
    procedure Close;
    procedure MakeData(var Data: TData; r: Pointer; col: Integer);
    function  procexec(const SQL: string): TData;
    function  procquery(const SQL: string; callBackFields: TCallBackFields; callBackData: TCallBackData): TData;
    function  procqueryscalar(const SQL: string; var Data: TData): TData;
  public
    _prop_Name: string;
    _prop_FileName: string;
    _prop_WaitClose: Boolean;
    _prop_Charset: Byte;

    _data_FileName: THI_Event;
    _event_onOpen: THI_Event;
    _event_onClose: THI_Event;    
    _event_onError: THI_Event;

    constructor Create;
    function getInterfaceDataSource: IDataSource;
    procedure _work_doOpen(var _Data: TData; Index: Word);
    procedure _work_doClose(var _Data: TData; Index: Word);
    procedure _work_doCharset(var _Data: TData; Index: Word);
  end;
  
implementation

uses
  CodePages;

//------------------------- Функции обратного вызова ---------------------------

{function execproccallback(user: Pointer; ncols: Integer; values: PCharPointers; names: PCharPointers): Integer; cdecl;
begin
  Result := 0;
end;}

//------------------------------------------------------------------------------

function THIDS_SQLite.getInterfaceDataSource: IDataSource;
begin
  Result := @ds;
end;

constructor THIDS_SQLite.Create;
begin
  inherited;
  ds.procexec := procexec;
  ds.procqueryscalar := procqueryscalar;
  ds.procquery := procquery;
end; 

procedure THIDS_SQLite._work_doOpen(var _Data: TData; Index: Word);
var
  FN: string;
begin
  if checkSqliteLoaded then
  begin
    Close;
    FN := ReadString(_Data, _data_FileName, _prop_FileName);
    sqlite3_open(PAnsiChar(StringToUTF8(FN)), id);
    if id <> nil then
      _hi_CreateEvent(_Data, @_event_onOpen)
    else  
      _hi_CreateEvent(_Data, @_event_onError);
  end;
end;

procedure THIDS_SQLite._work_doClose(var _Data: TData; Index: Word);
begin
  Close;
  _hi_CreateEvent(_Data, @_event_onClose); 
end;

procedure THIDS_SQLite.Close;
begin
  if id = nil then exit;
  while (sqlite3_close(id) <> SQLITE_OK) and _prop_WaitClose do
    Sleep(10);
  id := nil;
end;

procedure THIDS_SQLite.MakeData(var Data: TData; r: Pointer; col: Integer);
var
  S: AnsiString;
  {$ifdef UNICODE}SS: string;{$endif}
begin
  case sqlite3_column_type(r, col) of
    SQLITE_INTEGER: dtInteger(Data, sqlite3_column_int(r, col));
    SQLITE_FLOAT: dtReal(Data, sqlite3_column_double(r, col));
    else
      begin
        S := sqlite3_column_text(r, col);
        {$ifdef UNICODE}
          case _prop_Charset of
            0: SS := S; // ANSI
            1: SS := UTF8ToString(S); // UTF-8
          else
            SS := AnsiStringAsBinaryString(S); // Произвольная кодировка, упакованная в binary string
          end;
          dtString(Data, SS);
        {$else}
          if _prop_Charset = 1 then S := UTF8ToString(S);
          dtString(Data, S);
        {$endif}
      end;
  end;
end;

function THIDS_SQLite.procexec(const SQL: string): TData;
var
  msg: PAnsiChar;
  s: string;
  {$ifdef UNICODE}SS: AnsiString;{$endif}
begin
  if id = nil then
  begin
    dtString(Result, NO_OPEN_DB);
    exit;
  end; 
  dtNull(Result);
  
  s := SQL;
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
    sqlite3_exec(id, PAnsiChar(s), {execproccallback} nil, nil, @msg);
  {$endif}
  
  if msg <> nil then
  begin
    dtString(Result, string(msg));
    //To avoid memory leaks, the application should invoke sqlite3_free() on error message strings returned 
    //through the 5th parameter of sqlite3_exec() after the error message string is no longer needed.
    sqlite3_free(msg);
  end;
end;

function THIDS_SQLite.procqueryscalar(const SQL: string; var Data: TData): TData;
var
  r: Pointer;
  s: string;
  {$ifdef UNICODE}SS: AnsiString;{$endif}
begin
  if id = nil then
  begin
    dtString(Result, NO_OPEN_DB);
    exit;
  end;
  
  r := nil;
  
  s := SQL;
  {$ifdef UNICODE}
    case _prop_Charset of
      0: SS := s; // В ANSI
      1: SS := StringToUTF8(s); // В UTF-8
    else
      SS := BinaryStringAsAnsiString(s); // Произвольная кодировка, упакованная в binary string
    end;
    
    sqlite3_prepare(id, PAnsiChar(SS), -1, r, nil);
  {$else}
    if _prop_Charset = 1 then s := StringToUTF8(s); // В UTF-8
    sqlite3_prepare(id, PAnsiChar(s), -1, r, nil);
  {$endif}
  
  
  if r = nil then
  begin
    dtString(Result, {$ifdef UNICODE}sqlite3_errmsg16{$else}sqlite3_errmsg{$endif}(id));
    exit;
  end; 
  sqlite3_step(r);
  if sqlite3_data_count(r) = 0 then
    dtNull(Data)
  else
    MakeData(Data, r, 0);
  sqlite3_finalize(r);
  dtNull(Result);
end;

function THIDS_SQLite.procquery(const SQL: string; callBackFields: TCallBackFields; callBackData: TCallBackData): TData;
var
  r: Pointer;
  i, c: Integer;
  list: PKOLStrList;
  dt, ndt: TData;
  sdt: PData;
  s: string;
  {$ifdef UNICODE}SS: AnsiString;{$endif}
begin
  if id = nil then
  begin
    dtString(Result, NO_OPEN_DB);
    exit;
  end;
  
  r := nil;
  
  s := SQL;
  {$ifdef UNICODE}
    case _prop_Charset of
      0: SS := s; // В ANSI
      1: SS := StringToUTF8(s); // В UTF-8
    else
      SS := BinaryStringAsAnsiString(s); // Произвольная кодировка, упакованная в binary string
    end;
    sqlite3_prepare(id, PAnsiChar(SS), -1, r, nil);
  {$else}
    if _prop_Charset = 1 then s := StringToUTF8(s); // В UTF-8
    sqlite3_prepare(id, PAnsiChar(s), -1, r, nil);
  {$endif}
  
  if r = nil then
  begin
    dtString(Result, {$ifdef UNICODE}sqlite3_errmsg16{$else}sqlite3_errmsg{$endif}(id));
    exit;
  end; 

  c := sqlite3_column_count(r); 
  if assigned(callBackFields) then
  begin
    list := NewKOLStrList;
    for i := 0 to c-1 do
    begin
      {$ifdef UNICODE}
        if _prop_Charset = 1 then // Из UTF-8 в UTF-16
          s := sqlite3_column_name16(r, i)
        else // Иначе - из ANSI в UTF-16. Binary string добавлять в список не стоит, так как потом сложно конвертировать (?)
          s := AnsiString(sqlite3_column_name(r, i));
      {$else}
        s := sqlite3_column_name(r, i);
        if _prop_Charset = 1 then s := UTF8ToString(s);
      {$endif}
      list.add(s);
    end;
    callBackFields(list);
    list.free;
  end;
 
  sqlite3_step(r);
  while sqlite3_data_count(r) > 0 do
  begin 
    dtNull(dt);
    for i := 0 to c - 1 do
    begin
      MakeData(ndt, r, i);
      AddMTData(@dt, @ndt, sdt);
    end;
    ndt := dt; 
    callBackData(dt);
    FreeData(@ndt);
    sqlite3_step(r);
  end;
  sqlite3_finalize(r);
  dtNull(Result);
end;


procedure THIDS_SQLite._work_doCharset(var _Data: TData; Index: Word);
begin
  _prop_Charset := ToInteger(_Data);
end;

end.