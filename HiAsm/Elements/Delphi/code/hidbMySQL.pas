unit hidbMySQL;

interface

uses
  Windows, KOL, Share, Debug, MySQL;

type
  THIdbMySQL = class(TDebug)
    private
      MySQL: TMySQL;
      procedure _OnError(Sender:TObject; Index: Word);
    public
      _prop_Host: string;
      _prop_Login: string;
      _prop_Password: string;
      _prop_DBName: string;
      _prop_Charset: Byte;

      _event_onError: THI_Event;
      _data_DBName: THI_Event;
      _data_Password: THI_Event;
      _data_Login: THI_Event;
      _data_Host: THI_Event;

      constructor Create;
      destructor Destroy; override;
      procedure _work_doOpen(var _Data: TData; Index: Word);
      procedure _work_doClose(var _Data: TData; Index: Word);
      procedure _work_doSelectDB(var _Data: TData; Index: Word);
      procedure _work_doCharset(var _Data: TData; Index: Word);
      procedure _var_dbHandle(var _Data: TData; Index: Word);
      procedure _var_Charset(var _Data: TData; Index: Word);
  end;

var
  MySQL_GUID: Integer;

implementation

const
  Charsets: array [0..5] of string =
  (
    '',
    'ascii',
    'cp1251',
    'latin1',
    'ucs2',
    'utf8'
  );


constructor THIdbMySQL.Create;
begin
  GenGUID(MySQL_GUID);
  inherited;
end;

destructor THIdbMySQL.Destroy;
var
  dt: TData;
begin
  _work_doClose(dt, 0);
  inherited;
end;

procedure THIdbMySQL._work_doOpen;
var
  Host, Login, Pass: string;
begin
  if not Assigned(MySQL) then
  begin
    MySQL := TMySQL.Create;
    MySQL.OnError := _OnError;
    MySQL.Init;
  end;

  Host := ReadString(_Data,_data_Host,_prop_Host);
  Login := ReadString(_Data,_data_Login,_prop_Login);
  Pass := ReadString(_Data,_data_Password,_prop_Password);
  MySQL.Connect(Host, Login, Pass);

  if _prop_Charset <> 0 then MySQL.SetCharset(Charsets[_prop_Charset]);
end;

procedure THIdbMySQL._OnError;
begin
  _hi_OnEvent(_event_onError,integer(Index));
end;

procedure THIdbMySQL._work_doClose;
begin
  if Assigned(MySql) then
  begin
    MySQL.Close;
    MySQL.Destroy;
    MySQL := nil;
  end;
end;

procedure THIdbMySQL._work_doSelectDB;
begin
  MySQL.SelectDB(ReadString(_Data, _data_DBName, _prop_DBName));
end;

procedure THIdbMySQL._work_doCharset;
begin
  MySQL.SetCharset(Share.ToString(_Data));
end;

procedure THIdbMySQL._var_dbHandle;
begin
  if MySQL <> nil then
    dtObject(_Data, MySQL_GUID, MySQL)
  else
    dtNull(_Data);
end;

procedure THIdbMySQL._var_Charset;
begin
  if MySQL <> nil then
    dtString(_Data, MySQL.CharsetName)
  else
    dtNull(_Data);
end;

end.
