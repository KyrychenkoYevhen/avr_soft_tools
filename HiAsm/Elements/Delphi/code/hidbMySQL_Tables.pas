unit hidbMySQL_Tables;

interface

uses
  KOL, Share, Debug, MySQL;

type
  THIdbMySQL_Tables = class(TDebug)
    private
    public
      _prop_DBName: string;

      _data_TableName: THI_Event;
      _data_DBName: THI_Event;
      _data_dbHandle: THI_Event;
      _event_onError: THI_Event;
      _event_onEnum: THI_Event;

      procedure _work_doEnum(var _Data: TData; Index: Word);
      procedure _work_doDrop(var _Data: TData; Index: Word);
      procedure _work_doEmpty(var _Data: TData; Index: Word);
  end;

implementation

uses
  hidbMySql;

procedure THIdbMySQL_Tables._work_doEnum(var _Data: TData; Index: Word);
var
  My: TMySQL;
  i: SmallInt;
  db: string;
begin
  My := ReadObject(_Data, _data_dbHandle, MySQL_GUID);
  db := ReadString(_Data, _data_DBName, _prop_DBName);

  if My <> nil then
  begin
    if db = '' then
      My.Query('show tables')
    else
      My.Query('show tables from ' + db);
   
    for i := 0 to My.RecordCount - 1 do
    begin
      _hi_OnEvent(_event_onEnum, My.Values[0]);
      My.FindNext;
    end;
  end
  else
    _hi_OnEvent(_event_onError, 0);
end;

procedure THIdbMySQL_Tables._work_doDrop(var _Data: TData; Index: Word);
var
  My: TMySQL;
begin
  My := ReadObject(_Data, _data_dbHandle, MySQL_GUID);
  if My <> nil then
    My.Execute('drop table ' + ReadString(_Data, _data_TableName, ''))
  else
    _hi_OnEvent(_event_onError, 0);
end;

procedure THIdbMySQL_Tables._work_doEmpty(var _Data: TData; Index: Word);
var
  My: TMySQL;
begin
  My := ReadObject(_Data, _data_dbHandle, MySQL_GUID);
  if My <> nil then
    My.Execute('delete from ' + ReadString(_Data, _data_TableName, ''))
  else
    _hi_OnEvent(_event_onError, 0);
end;

end.
