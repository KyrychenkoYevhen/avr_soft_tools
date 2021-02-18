unit MySQL;

interface

uses
  KOL, Share, mysqllib, CodePages;

const
  err_init = 1;
  err_connect = 2;
  err_query = 3;
  err_store = 4;
  err_execute = 5;

type

  TLengths = array[0..0] of LongInt;
  PLengths = ^TLengths;
  
  TRow = array[0..0] of PAnsiChar;
  PRow = ^TRow;


  TMySQL = class
    private
      FHandle: PMYSQL;
      FMyResult: PMYSQL_RES;
      Lengths: PLengths;
      FRowNum: TInt64;
      FRow: PMYSQL_ROW;
      FBlobSize: LongInt;
      FConnectionCP: Integer;

      procedure DoError(Index: Word);
      function GetRecordCount: Integer;
      function GetFieldCount: Integer;
      function GetValues(Index: Integer): string;
      function GetFields(Index: Integer): string;
      function GetBlob(Index: Integer): PMYSQL_ROW;
      function GetCharset: string;
      
    public
      OnError: procedure(Sender: TObject; Index: Word) of object;

      constructor Create;
      destructor Destroy; override;
      
      // Функции используют значение FConnectionCP
      function MySQLStrToString(S: PAnsiChar; Len: Integer = -1): string; overload;
      function MySQLStrToString(S: AnsiString): string; overload;
      function StringToMySQLStr(S: string): AnsiString;
      
      procedure Init;
      procedure Connect(Host, Login, Passwd: AnsiString);
      procedure SelectDB(DBName: string);
      procedure SetCharset(CSname: string);
      procedure Close;
      procedure Query(Text: string);
      procedure FindFirst;
      procedure FindNext;
      function Execute(Text: PAnsiChar; Len: Integer): Integer; overload;
      function Execute(Text: string): Integer; overload;
      function BlobToString(P: Pointer; Size: Integer): AnsiString;
      
      property CharsetName: string read GetCharset;
      property RecordCount: Integer read GetRecordCount;
      property FieldCount: Integer read GetFieldCount;
      property Values[Idx: Integer]: string read GetValues;
      property Fields[Idx: Integer]: string read GetFields;
      property Blob[Idx: Integer]: PMYSQL_ROW read GetBlob;
      property BlobSize: LongInt read FBlobSize;
 
  end;



implementation


const
  CP_UTF8 = 65001;
  CP_LATIN1 = 28591;

  MySQLCharsetCP: array[0..3] of
    record
      CS: string;
      Code: Integer;
    end
  = (
    (CS: 'utf8'; Code: CP_UTF8),
    (CS: 'latin1'; Code: CP_LATIN1),
    (CS: 'ascii'; Code: 20127),
    (CS: 'cp1251'; Code: 1251)
  );



constructor TMySQL.Create;
begin
  FConnectionCP := CP_LATIN1; //latin1
  inherited;
end;

destructor TMySQL.Destroy;
begin
  Close;
  inherited;
end;

function TMySQL.MySQLStrToString(S: PAnsiChar; Len: Integer = -1): string;
begin
  Result := '';
  if (Len = 0) or (S = nil) then exit;
  
  if Len < 0 then Len := StrLen(S);
  
  Result := BufToString(S, Len, FConnectionCP, False);
end;

function TMySQL.MySQLStrToString(S: AnsiString): string;
begin
  Result := BufToString(Pointer(S), Length(S), FConnectionCP, False);
end;

function TMySQL.StringToMySQLStr(S: string): AnsiString;
begin
  if FConnectionCP = CP_BINARY then // Без конвертации
    Result := BinaryStringAsAnsiString(S)
  else
    Result := WideStringToAnsiString(S, FConnectionCP);
end;


procedure TMySQL.DoError;
begin
  if AssigneD(OnError) then
    OnError(Self, Index);
end;

procedure TMySQL.Init;
begin
  mysql_load_dll;
end;

procedure TMySQL.Connect(Host, Login, Passwd: AnsiString);
begin
  Close;
  
  FHandle := mysql_init(nil);
  if FHandle = nil then
  begin
    DoError(err_init);
    exit;
  end;
  
  //The user and passwd parameters use whatever character set has been configured for the MYSQL object.
  //By default, this is latin1, but can be changed by calling mysql_options(mysql, MYSQL_SET_CHARSET_NAME, "charset_name") prior to connecting. 
  //mysql_options(FHandle, MYSQL_SET_CHARSET_NAME, PAnsiChar('cp1251'));
  
  // Выше Host, Login, Passwd находятся в текущей кодовой странице Windows 
  // (для Unicode - конвертируются автоматически).
  // Поскольку по-умолчанию MySQL ожидает latin1, то все национальные символы в них
  // будут сконвертированы неправильно.
  
  if Assigned(mysql_real_connect) then
  begin
    if mysql_real_connect(FHandle, PAnsiChar(Host), PAnsiChar(Login), PAnsiChar(Passwd), nil, 0, nil, 0) = nil then
      DoError(err_connect);
  end
  else
    if Assigned(mysql_connect) then
    begin
      if mysql_connect(FHandle, PAnsiChar(Host), PAnsiChar(Login), PAnsiChar(Passwd)) = nil then
        DoError(err_connect);
    end
    else
      DoError(err_connect);
end;

procedure TMySQL.SelectDB(DBName: string);
begin
  mysql_select_db(FHandle, PAnsiChar(AnsiString(DBName)));
end;

procedure TMySQL.SetCharset(CSname: string);
var
  I: Byte;
  S: AnsiString;
begin
  if FHandle <> nil then
  begin
    S := CSname;
    if mysql_set_character_set(FHandle, PAnsiChar(S)) = 0 then
    begin
      // Ищем номер кодовой страницы, соответствующей указанному набору,
      // для последующих преобразований
      for I := 0 to High(MySQLCharsetCP) do
      begin
        if MySQLCharsetCP[I].CS = CSname then
        begin
          FConnectionCP := MySQLCharsetCP[I].Code;
          exit;
        end;
      end;
      FConnectionCP := CP_BINARY; // Если неизвестная - ничего не преобразовывать
    end;
    //else
    //  FConnectionCP := CP_LATIN1; // В случае неправильной кодировки сбрасывается в 'latin1'?
  end;
end;

procedure TMySQL.Close;
begin
  if FHandle <> nil then
  begin
	  if FMyResult <> nil then
    begin
      mysql_free_result(FMyResult);
      FMyResult := nil;
    end;
    mysql_close(FHandle);
    FHandle := nil;
  end;
end;

procedure TMySQL.Query(Text: string);
var
  S: AnsiString;
begin
  S := StringToMySQLStr(Text);
  if FMyResult <> nil then
  begin
	  mysql_free_result(FMyResult);
    FMyResult := nil;
	end;
  
  if mysql_query(FHandle, PAnsiChar(S)) = -1 then
    DoError(err_Query)
  else
  begin
    FMyResult := mysql_store_result(FHandle);
    if FMyResult <> nil then
      FindFirst
    else
      DoError(err_store);
  end;
end;

function TMySQL.Execute(Text: PAnsiChar; Len: Integer): Integer;
begin
  if mysql_real_query(FHandle, Text, Len) <> 0 then
  begin
    DoError(err_execute);
    Result := 0;
  end
  else
    Result := mysql_affected_rows(FHandle);
end;

function TMySQL.Execute(Text: string): Integer;
var
  S: AnsiString;
begin
  S := StringToMySQLStr(Text);
  Result := Execute(PAnsiChar(S), Length(S));
end;

procedure TMySQL.FindFirst;
begin
  FRowNum.Data := 0;
  FRowNum.Pad := 0;
  FRow := nil;
  Lengths := nil;
  FindNext;
end;

procedure TMySQL.FindNext;
begin
  if FMyResult <> nil then
  begin
    mysql_data_seek(FMyResult, FRowNum);
    FRow := mysql_fetch_row(FMyResult);
    Lengths := PLengths(mysql_fetch_lengths(FMyResult));
    Inc(FRowNum.Data);
  end;
end;

function TMySQL.BlobToString(P: Pointer; Size: Integer): AnsiString;
begin
  SetLength(Result, Size*2+1);
  Size := mysql_real_escape_string(FHandle, Pointer(Result), P, Size);
  SetLength(Result, Size);
end;

function TMySQL.GetValues(Index: Integer): string;
var
  Len: LongInt;
begin
  if Lengths <> nil then
    Len := Lengths^[Index]
  else
    Len := 0;
  
  if FRow = nil then
    Result := ''
  else
    Result := MySQLStrToString(TRow(FRow^)[Index], Len);
end;

function TMySQL.GetFields(Index: Integer): string;
var
 Fld: PMYSQL_FIELD;
begin
  if FMyResult = nil then
    Result := ''
  else
  begin
    mysql_field_seek(FMyResult, Index);
    Fld := mysql_fetch_field(FMyResult);
    Result := MySQLStrToString(Fld.name);
  end;
end;

function TMySQL.GetBlob(Index: Integer): PMYSQL_ROW;
begin
  Result := nil;
  FBlobSize := 0;
  
  if FMyResult = nil then exit;
  if FRow = nil then exit;

  if Lengths <> nil then
    FBlobSize  := Lengths^[Index];
  
  Result := TRow(FRow^)[Index];
end;

function TMySQL.GetCharset: string;
begin
  if FHandle = nil then
    Result := ''
  else
    Result := MySQLStrToString(mysql_character_set_name(FHandle));
end;

function TMySQL.GetRecordCount: Integer;
begin
  if FMyResult = nil then
    Result := 0
  else
    Result := mysql_num_rows(FMyResult);
end;

function TMySQL.GetFieldCount: Integer;
begin
  if FMyResult = nil then
    Result := 0
  else
    Result := mysql_num_fields(FMyResult);
end;

end.
