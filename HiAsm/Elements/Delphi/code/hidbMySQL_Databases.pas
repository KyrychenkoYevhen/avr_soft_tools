unit hidbMySQL_Databases;

interface

uses
  Kol, Share, Debug, MySQL;

type
  THIdbMySQL_Databases = class(TDebug)
    private
    public
      _data_DBName: THI_Event;
      _data_dbHandle: THI_Event;
      _event_onError: THI_Event;
      _event_onEnum: THI_Event;

      procedure _work_doEnum(var _Data: TData; Index: Word);
      procedure _work_doEmpty(var _Data: TData; Index: Word);
      procedure _work_doDrop(var _Data: TData; Index: Word);
  end;

implementation

uses
  hidbMySql;

procedure THIdbMySQL_Databases._work_doEnum;
var
  My: TMySQL;
  I: Byte;
begin
  My := ReadObject(_Data, _data_dbHandle, MySQL_GUID);
  if My <> nil then
  begin
    My.Query('show databases');
    for I := 0 to My.RecordCount - 1 do
    begin
      _hi_OnEvent(_event_onEnum, My.Values[0]);
      My.FindNext;
    end;
  end
  else
    _hi_OnEvent(_event_onError, 0);
end;

procedure THIdbMySQL_Databases._work_doEmpty;
begin

end;

procedure THIdbMySQL_Databases._work_doDrop;
begin

end;

end.
