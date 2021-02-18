unit hiSQLite_DB;

interface

uses
  Windows, Kol, Share, Debug, SqLite3Api;

type
  THISQLite_DB = class(TDebug)
    private
      id: Pointer;
      procedure Close;
    public
      _prop_FileName: string;
      _prop_WaitClose: Boolean;    

      _data_FileName: THI_Event;
      _event_onOpen: THI_Event;
      _event_onError: THI_Event;

      procedure _work_doOpen(var _Data: TData; Index: Word);
      procedure _work_doClose(var _Data: TData; Index: Word);
      procedure _var_dbHandle(var _Data: TData; Index: Word);
  end;
  
var
  SQLite_GUID: Integer;

implementation

uses
  CodePages;

procedure THISQLite_DB._work_doOpen(var _Data: TData; Index: Word);
var
  FN: string;
begin
  if checkSqliteLoaded then
  begin
    Close;
    FN := ReadString(_Data, _data_FileName, _prop_FileName);
    {$ifdef UNICODE}
    sqlite3_open16(PWideChar(FN), id);
    {$else}
    sqlite3_open(PAnsiChar(StringToUTF8(FN)), id);
    {$endif}
    if id <> nil then
    begin
      GenGUID(SQLite_GUID);
      dtObject(_Data, SQLite_GUID, id);
      _hi_CreateEvent(_Data, @_event_onOpen);
    end
    else
      _hi_CreateEvent(_Data, @_event_onError);
  end;
end;

procedure THISQLite_DB._work_doClose(var _Data: TData; Index: Word);
begin
  Close;
end;

procedure THISQLite_DB.Close;
begin
  if id = nil then exit;
  while (sqlite3_close(id) <> SQLITE_OK) and _prop_WaitClose do
    Sleep(10);
  id := nil;   
end;

procedure THISQLite_DB._var_dbHandle(var _Data: TData; Index: Word);
begin
  if id <> nil then
    dtObject(_Data, SQLite_GUID, id)
  else
    dtNull(_Data);
end;

end.