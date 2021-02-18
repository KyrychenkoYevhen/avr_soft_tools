unit mysqllib;

interface

uses
  Windows;


{$define mysql41}


const
  MYSQL_PORT = 3306;
  LOCAL_HOST = 'localhost';
  MYSQL_LIB = {$ifdef WIN64}'libmysql-64.dll'{$else}'libmysql.dll'{$endif};
  

type
  PLongInt = ^LongInt;
  TBool = Byte;
  
  TInt64 = packed record
    Data: LongInt;
    Pad: LongInt;
  end;
  
  mysql_status = (
    MYSQL_STATUS_READY,
    MYSQL_STATUS_GET_RESULT,
    MYSQL_STATUS_USE_RESULT
  );
  
  mysql_option = (
    MYSQL_OPT_CONNECT_TIMEOUT,MYSQL_OPT_COMPRESS,
    MYSQL_OPT_NAMED_PIPE,MYSQL_INIT_COMMAND,
    MYSQL_READ_DEFAULT_FILE,MYSQL_READ_DEFAULT_GROUP,
    MYSQL_SET_CHARSET_DIR,MYSQL_SET_CHARSET_NAME,
    MYSQL_OPT_LOCAL_INFILE,MYSQL_OPT_PROTOCOL,
    MYSQL_SHARED_MEMORY_BASE_NAME,MYSQL_OPT_READ_TIMEOUT,
    MYSQL_OPT_WRITE_TIMEOUT,MYSQL_OPT_USE_RESULT,
    MYSQL_OPT_USE_REMOTE_CONNECTION,MYSQL_OPT_USE_EMBEDDED_CONNECTION,
    MYSQL_OPT_GUESS_CONNECTION,MYSQL_SET_CLIENT_IP,
    MYSQL_SECURE_AUTH,
    //mysql50
    MYSQL_REPORT_DATA_TRUNCATION, MYSQL_OPT_RECONNECT,
    //mysql51
    MYSQL_OPT_SSL_VERIFY_SERVER_CERT,
    //mysql55}
    MYSQL_PLUGIN_DIR, MYSQL_DEFAULT_AUTH,
    //mysql56}
    MYSQL_OPT_BIND,
    MYSQL_OPT_SSL_KEY, MYSQL_OPT_SSL_CERT, MYSQL_OPT_SSL_CA, MYSQL_OPT_SSL_CAPATH, MYSQL_OPT_SSL_CIPHER, MYSQL_OPT_SSL_CRL, MYSQL_OPT_SSL_CRLPATH,
    MYSQL_OPT_CONNECT_ATTR_RESET, MYSQL_OPT_CONNECT_ATTR_ADD, MYSQL_OPT_CONNECT_ATTR_DELETE,
    MYSQL_SERVER_PUBLIC_KEY,
    MYSQL_ENABLE_CLEARTEXT_PLUGIN,
    MYSQL_OPT_CAN_HANDLE_EXPIRED_PASSWORDS,
    //mysql57}
    MYSQL_OPT_SSL_ENFORCE
  );
  
  MYSQL_FIELD = record
    name:       PAnsiChar; // Name of column
    {$IFDEF mysql41}
    org_name:   PAnsiChar; // Original column name, if an alias
    {$ENDIF}
    table:      PAnsiChar; // Table of column if column was a field
    org_table: PAnsiChar; // Org table name, if table was an alias
    db:         PAnsiChar; // Database for table
    {$IFDEF mysql41}
    catalog:   PAnsiChar; // Catalog for table
    {$ENDIF}
    def:        PAnsiChar; // Default value (set by mysql_list_fields)
    length:     Integer; // Width of column (create length)
    max_length: Integer; // Max width for selected set
    {$IFDEF mysql41}
    name_length:      Integer;
    org_name_length:  Integer;
    table_length:     Integer;
    org_table_length: Integer;
    db_length:        Integer;
    catalog_length:   Integer;
    def_length:       Integer;
    {$ENDIF}
    flags:      Integer; // Div flags
    decimals:   Integer; // Number of decimals in field
    {$IFDEF mysql41}
    charsetnr: Integer; // Character set
    {$ENDIF}
    _type:      Byte; // Type of field. See mysql_com.h for types
    {$IFDEF mysql51}
    extension: pointer;
    {$ENDIF}
  end;
  PMYSQL_FIELD = ^MYSQL_FIELD;

  PMYSQL = Pointer;
  PMYSQL_ROW = Pointer;
  PMYSQL_ROWS = Pointer;
  PMYSQL_DATA = Pointer;
  PMYSQL_RES = Pointer;
  MYSQL_FIELD_OFFSET = Cardinal;
  MYSQL_ROW_OFFSET = PMYSQL_ROWS;


var
  MySQLDLL: THandle;


  mysql_close:          procedure (Handle: PMYSQL); stdcall;
  mysql_query:          function (Handle: PMYSQL; const Query: PAnsiChar): Integer; stdcall;
  mysql_connect:        function (Handle: PMYSQL; const Host, User, Passwd: PAnsiChar): PMYSQL; stdcall;
  mysql_real_connect:   function (Handle: PMYSQL; const Host, User, Passwd, DBName: PAnsiChar; Port: Integer;                               unix_socket: PAnsiChar; client_flag: Cardinal): PMYSQL; stdcall;
  mysql_init:           function (Handle: PMYSQL): PMYSQL; stdcall;
  mysql_select_db:      function (Handle: PMYSQL; const Db: PAnsiChar): Integer; stdcall;
  mysql_store_result:   function (Handle: PMYSQL): PMYSQL_RES; stdcall;
  mysql_fetch_row:      function (Result: PMYSQL_RES): PMYSQL_ROW; stdcall;
  mysql_fetch_lengths:  function (Result: PMYSQL_RES): PLongInt; stdcall;
  mysql_fetch_field:    function (Result: PMYSQL_RES): PMYSQL_FIELD; stdcall;
  mysql_field_seek:     function (Result: PMYSQL_RES; Offset: MYSQL_FIELD_OFFSET): MYSQL_FIELD_OFFSET; stdcall;
  mysql_row_seek:       function (Result: PMYSQL_RES; Row: MYSQL_ROW_OFFSET): MYSQL_ROW_OFFSET; stdcall;
  mysql_data_seek:      procedure (Result: PMYSQL_RES; Offset: TInt64); stdcall;
  mysql_num_fields:     function (Result: PMYSQL_RES): Integer; stdcall;
  mysql_num_rows:       function (Result: PMYSQL_RES): Int64; stdcall;
  mysql_real_query:     function (Handle: PMYSQL; const Query: PAnsiChar; length: Integer): Integer; stdcall;
  mysql_affected_rows:  function (Handle: PMYSQL): Int64; stdcall;
  mysql_free_result:    procedure (Result: PMYSQL_RES); stdcall;
  mysql_real_escape_string: function (Handle: PMYSQL; ato: PAnsiChar; from: PAnsiChar; from_length: Integer): Integer; stdcall;
  mysql_set_character_set:  function (Handle: PMYSQL; csname: PAnsiChar): Integer; stdcall;
  mysql_character_set_name: function(Handle: PMYSQL): PAnsiChar; stdcall;
  mysql_options:        function (Handle: PMYSQL; option: mysql_option; arg: Pointer): Integer; stdcall;



function mysql_load_dll: Boolean;




implementation



function mysql_load_dll: Boolean;
begin
  if MySQLDLL <> 0 then
  begin
    Result := True;
    exit;
  end;
  
  Result := False;
  
  MySQLDLL := LoadLibrary(MYSQL_LIB);
  if MySQLDLL = 0 then exit;
  
  mysql_close         := GetProcAddress(MySQLDLL, 'mysql_close');
  mysql_query         := GetProcAddress(MySQLDLL, 'mysql_query');
  mysql_connect       := GetProcAddress(MySQLDLL, 'mysql_connect');
  mysql_real_connect  := GetProcAddress(MySQLDLL, 'mysql_real_connect');
  mysql_init          := GetProcAddress(MySQLDLL, 'mysql_init');
  mysql_select_db     := GetProcAddress(MySQLDLL, 'mysql_select_db');
  mysql_store_result  := GetProcAddress(MySQLDLL, 'mysql_store_result');
  mysql_fetch_row     := GetProcAddress(MySQLDLL, 'mysql_fetch_row');
  mysql_fetch_lengths := GetProcAddress(MySQLDLL, 'mysql_fetch_lengths');
  mysql_fetch_field   := GetProcAddress(MySQLDLL, 'mysql_fetch_field');
  mysql_field_seek    := GetProcAddress(MySQLDLL, 'mysql_field_seek');
  mysql_row_seek      := GetProcAddress(MySQLDLL, 'mysql_row_seek');
  mysql_data_seek     := GetProcAddress(MySQLDLL, 'mysql_data_seek');
  mysql_num_fields    := GetProcAddress(MySQLDLL, 'mysql_num_fields');
  mysql_num_rows      := GetProcAddress(MySQLDLL, 'mysql_num_rows');
  mysql_real_query    := GetProcAddress(MySQLDLL, 'mysql_real_query');
  mysql_affected_rows := GetProcAddress(MySQLDLL, 'mysql_affected_rows');
  mysql_free_result   := GetProcAddress(MySQLDLL, 'mysql_free_result');
  mysql_real_escape_string := GetProcAddress(MySQLDLL, 'mysql_real_escape_string');
  mysql_set_character_set  := GetProcAddress(MySQLDLL, 'mysql_set_character_set');
  mysql_character_set_name := GetProcAddress(MySQLDLL, 'mysql_character_set_name');
  mysql_options       := GetProcAddress(MySQLDLL, 'mysql_options');
  
  Result :=
    Assigned(mysql_close) and
    Assigned(mysql_query) and
    //Assigned(mysql_connect) and
    Assigned(mysql_real_connect) and
    Assigned(mysql_init) and
    Assigned(mysql_select_db) and
    Assigned(mysql_store_result) and
    Assigned(mysql_fetch_row) and
    Assigned(mysql_fetch_lengths) and
    Assigned(mysql_fetch_field) and
    Assigned(mysql_field_seek) and
    Assigned(mysql_row_seek) and
    Assigned(mysql_data_seek) and
    Assigned(mysql_num_fields) and
    Assigned(mysql_num_rows) and
    Assigned(mysql_real_query) and
    Assigned(mysql_affected_rows) and
    Assigned(mysql_free_result) and
    Assigned(mysql_real_escape_string) and
    Assigned(mysql_set_character_set) and
    Assigned(mysql_character_set_name) and
    Assigned(mysql_options);
  
  if not Result then
  begin
    FreeLibrary(MySQLDLL);
    MySQLDLL := 0;
  end;
end;

end.
