unit SqLite3Api;

interface

const

  SQLITEDLL = {$ifdef WIN64}'sqlite3-64.dll'{$else}'sqlite3.dll'{$endif};

  SQLITE_OK         =  0;   // Successful result
  SQLITE_ERROR      =  1;   // SQL error or missing database
  SQLITE_INTERNAL   =  2;   // An internal logic error in SQLite
  SQLITE_PERM       =  3;   // Access permission denied
  SQLITE_ABORT      =  4;   // Callback routine requested an abort
  SQLITE_BUSY       =  5;   // The database file is locked
  SQLITE_LOCKED     =  6;   // A table in the database is locked
  SQLITE_NOMEM      =  7;   // A malloc() failed
  SQLITE_READONLY   =  8;   // Attempt to write a readonly database
  SQLITE_INTERRUPT  =  9;   // Operation terminated by sqlite_interrupt()
  SQLITE_IOERR      = 10;   // Some kind of disk I/O error occurred
  SQLITE_CORRUPT    = 11;   // The database disk image is malformed
  SQLITE_NOTFOUND   = 12;   // (Internal Only) Table or record not found
  SQLITE_FULL       = 13;   // Insertion failed because database is full
  SQLITE_CANTOPEN   = 14;   // Unable to open the database file
  SQLITE_PROTOCOL   = 15;   // Database lock protocol error
  SQLITE_EMPTY      = 16;   // (Internal Only) Database table is empty
  SQLITE_SCHEMA     = 17;   // The database schema changed
  SQLITE_TOOBIG     = 18;   // Too much data for one row of a table
  SQLITE_CONSTRAINT = 19;   // Abort due to contraint violation
  SQLITE_MISMATCH   = 20;   // Data type mismatch
  SQLITE_MISUSE     = 21;   // Library used incorrectly
  SQLITE_NOLFS      = 22;   // Uses OS features not supported on host
  SQLITE_AUTH       = 23;   // Authorization denied
  SQLITE_FORMAT     = 24;   // Auxiliary database format error
  SQLITE_RANGE      = 25;   // 2nd parameter to sqlite_bind out of range
  SQLITE_NOTADB     = 26;   // File opened that is not a database file
  SQLITE_ROW        = 100;  // sqlite_step() has another row ready
  SQLITE_DONE       = 101;  //  sqlite_step() has finished executing

  SQLITE_INTEGER = 1;
  SQLITE_FLOAT = 2;
  SQLITE_TEXT = 3;
  SQLITE_BLOB = 4;
  SQLITE_NULL = 5;

{
** These are the allowed values for the eTextRep argument to
** sqlite3_create_collation and sqlite3_create_function.
}
  SQLITE_UTF8    = 1;
  SQLITE_UTF16LE = 2;
  SQLITE_UTF16BE = 3;
  SQLITE_UTF16   = 4;    // Use native byte order
  SQLITE_ANY     = 5;    // sqlite3_create_function only

  SQLITE_STATIC = 0;
  SQLITE_TRANSIENT = -1;

type

  PPAnsiChar = ^PAnsiChar;
  PPWideChar = ^PWideChar;
  PPValue = ^PValue;
  PValue = Pointer;
  
  TCharPointers = array[0..0] of PAnsiChar;
  PCharPointers = ^TCharPointers;

  TDestructor = procedure(data: Pointer); cdecl;
  TExecCallBack = function(user: Pointer;
                         ncols: Integer;
                         values: PCharPointers;
                         names: PCharPointers): Integer; cdecl;

  TBusyHandler = function(user: Pointer; count: Integer): Integer; cdecl;
  TFuncHandler = procedure(context: Pointer; nArgs: Integer; args: PPValue); cdecl;
  TFuncFinalizer = procedure(context: Pointer); cdecl;
  TUserCollation = function(user: Pointer;
                          lenA: Integer;
                          a: PAnsiChar;
                          lenB: Integer;
                          b: PAnsiChar): Integer; cdecl;

  TUserCollationNeeded = procedure(user: Pointer;
                                 db: Pointer;
                                 eTextRep: Integer;
                                 zName: PAnsiChar); cdecl;

function sqlite3_libVersion(): PAnsiChar; cdecl;

function sqlite3_close(db: Pointer): Integer; cdecl;
function sqlite3_exec(db: Pointer;
                       SQLStatement: PAnsiChar;
                       CallbackPtr: TExecCallBack;
                       CbParam: Pointer;
                       ErrMsg: PPAnsiChar): Integer; cdecl;

function sqlite3_last_insert_rowid(db: Pointer): Int64; cdecl;
function sqlite3_changes(db: Pointer): Integer; cdecl;
function sqlite3_total_changes(db: Pointer): Integer; cdecl;
procedure sqlite3_interrupt(db: Pointer); cdecl;
function sqlite3_complete(P: PAnsiChar): Integer; cdecl;
function sqlite3_busy_handler(db: Pointer;
                               CallbackPtr: TBusyHandler;
                               user: Pointer): Integer; cdecl;
                               
function sqlite3_busy_timeout(db: Pointer; TimeOut: Integer): Integer; cdecl;
procedure sqlite3_free(P: PAnsiChar); cdecl;
function sqlite3_open(dbname: PAnsiChar; var db: Pointer): Integer; cdecl;
function sqlite3_open16(dbname: PWideChar; var db: Pointer): Integer; cdecl;
function sqlite3_errcode(db: Pointer): Integer; cdecl;
function sqlite3_errmsg(db: Pointer): PAnsiChar; cdecl;
function sqlite3_errmsg16(db: Pointer): PWideChar; cdecl;

function sqlite3_prepare(db: Pointer;
                         Sql: PAnsiChar;
                         nBytes: Integer;
                         var stmt: Pointer;
                         pzTail: PPAnsiChar): Integer; cdecl;

function sqlite3_prepare16(db: Pointer;
                         Sql: PWideChar;
                         nBytes: Integer;
                         var stmt: Pointer;
                         pzTail: PPWideChar): Integer; cdecl;

function sqlite3_bind_double(stmt: Pointer; idx: Integer; value: Double): Integer; cdecl;
function sqlite3_bind_int(stmt: Pointer; idx: Integer; value: Integer): Integer; cdecl;
function sqlite3_bind_int64(stmt: Pointer; idx: Integer; value: Int64): Integer; cdecl;
function sqlite3_bind_null(stmt: Pointer; idx: Integer): Integer; cdecl;
//function sqlite3_bind_value(stmt: Pointer; idx: Integer; value: Pointer): Integer; cdecl;
function sqlite3_bind_text(stmt: Pointer;
                           idx: Integer;
                           value: PAnsiChar;
                           size: Integer;
                           xDel: Integer): Integer; cdecl;
function sqlite3_bind_blob(stmt: Pointer;
                           idx: Integer;
                           value: Pointer;
                           size: Integer;
                           xDel: Integer): Integer; cdecl;

function sqlite3_bind_parameter_count(stmt: Pointer): Integer; cdecl;
function sqlite3_bind_parameter_name(stmt: Pointer; idx: Integer): PAnsiChar; cdecl;


function sqlite3_bind_parameter_index(stmt: Pointer; zName: PAnsiChar): Integer; cdecl;


function sqlite3_column_count(pStmt: Pointer): Integer; cdecl;
function sqlite3_column_name(pStmt: Pointer; idx: Integer): PAnsiChar; cdecl;
function sqlite3_column_name16(pStmt: Pointer; idx: Integer): PWideChar; cdecl;
function sqlite3_column_decltype(pStmt: Pointer; idx: Integer): PAnsiChar; cdecl;
function sqlite3_step(pStmt: Pointer): Integer; cdecl;

function sqlite3_data_count(pStmt: Pointer): Integer; cdecl;

function sqlite3_column_blob(pStmt: Pointer; col: Integer): Pointer; cdecl;
function sqlite3_column_bytes(pStmt: Pointer; col: Integer): Integer; cdecl;
function sqlite3_column_double(pStmt: Pointer; col: Integer): Double; cdecl;
function sqlite3_column_int(pStmt: Pointer; col: Integer): Integer; cdecl;
function sqlite3_column_int64(pStmt: Pointer; col: Integer): Int64; cdecl;
function sqlite3_column_text(pStmt: Pointer; col: Integer): PAnsiChar; cdecl;
function sqlite3_column_text16(pStmt: Pointer; col: Integer): PWideChar; cdecl;
function sqlite3_column_type(pStmt: Pointer; col: Integer): Integer; cdecl;

function sqlite3_finalize(pStmt: Pointer): Integer; cdecl;
function sqlite3_reset(pStmt: Pointer): Integer; cdecl;

function sqlite3_create_function(
  db: Pointer;
  zFunctionName: PAnsiChar;
  nArg: Integer;
  eTextRep: Integer;
  userData: Pointer;
  xFunc,
  xStep: TFuncHandler;
  xFinal: TFuncFinalizer): Integer; cdecl;

function sqlite3_aggregate_count(sqlite3_context: Pointer): Integer;  cdecl;

function sqlite3_value_blob(v: PValue): Pointer; cdecl;
function sqlite3_value_bytes(v: PValue): Integer; cdecl;
function sqlite3_value_double(v: PValue): Double; cdecl;
function sqlite3_value_int(v: PValue): Integer; cdecl;
function sqlite3_value_int64(v: PValue): Int64; cdecl;
function sqlite3_value_text(v: PValue): PAnsiChar; cdecl;
function sqlite3_value_type(v: PValue): Integer; cdecl;

function sqlite3_aggregate_context(context: Pointer; nBytes: Integer): Pointer; cdecl;

function sqlite3_user_data(context: Pointer): Pointer; cdecl;

function sqlite3_get_auxdata(context: Pointer; idx: Integer): Pointer; cdecl;
procedure sqlite3_set_auxdata(context: Pointer; idx: Integer;
                              data: Pointer;
                              xDel: Integer); cdecl;

procedure sqlite3_result_blob(context: Pointer; value: Pointer; size: Integer;
                              xDel: Integer); cdecl;
procedure sqlite3_result_double(context: Pointer; value: Double); cdecl;
procedure sqlite3_result_error(context: Pointer; msg: PAnsiChar; len: Integer); cdecl;
procedure sqlite3_result_int(context: Pointer; value: Integer); cdecl;
procedure sqlite3_result_int64(context: Pointer; value: Int64); cdecl;
procedure sqlite3_result_null(context: Pointer); cdecl;
procedure sqlite3_result_text(context: Pointer; value: PAnsiChar; len: Integer;
                              xDel: Integer); cdecl;
procedure sqlite3_result_value(context: Pointer; value: PValue); cdecl;

function sqlite3_create_collation(db: Pointer;
  zName: PAnsiChar;
  eTextRep: Integer;
  userData: Pointer;
  func: TUserCollation): Integer; cdecl;

function sqlite3_collation_needed(db: Pointer;
  userData: Pointer;
  func: TUserCollationNeeded): Integer; cdecl;

function CheckSqliteLoaded: Boolean;

implementation

{$IFDEF SQLITE_OBJ}

uses Windows;

{$ifDEF 3_3_4_OBJ}
  {$L 'SQLiteObj\sqlite3_3_4.obj'}
{$ELSE}
  {$ifDEF 3_7_2_OBJ}
    {$L 'SQLiteObj\sqlite3_7_2.obj'}
  {$ELSE}
    {$L 'SQLiteObj\sqlite3_4_2.obj'}
  {$ENDIF 3_7_2_OBJ}
{$ENDIF 3_3_4_OBJ}
  {$L 'SQLiteObj\_ll.obj'}
  {$L 'SQLiteObj\_ftoul.obj'}
  {$L 'SQLiteObj\ftol.obj'}
  {$L 'SQLiteObj\memmove.obj'}
  {$L 'SQLiteObj\qsort.obj'}

// Stubs for external C RTL functions

const MSVCRT = 'msvcrt.dll';

function _malloc(size: Integer): Pointer; cdecl;
begin
  GetMem(Result, size);
end;

function _realloc(P: Pointer; size: Integer): Pointer; cdecl;
begin
  Result := P;
  ReallocMem(Result, size);
end;

procedure _free(P: Pointer); cdecl;
begin
  FreeMem(P);
end;

procedure __ltolower; cdecl; asm int 3; end; // not used
procedure __ltoupper; cdecl; asm int 3; end; // not used

procedure _localtime; external MSVCRT name 'localtime';
procedure _getenv; external MSVCRT name 'getenv';
procedure _sprintf; external MSVCRT name 'sprintf';
procedure _memcmp; external MSVCRT name 'memcmp';
procedure _memcpy; external MSVCRT name 'memcpy';
procedure _memset; external MSVCRT name 'memset';
procedure _strlen; external MSVCRT name 'strlen';
procedure _strcmp; external MSVCRT name 'strcmp';
procedure _strcpy; external MSVCRT name 'strcpy';
procedure _strncmp; external MSVCRT name 'strncmp';
procedure _strncpy; external MSVCRT name 'strncpy';
procedure _strcat; external MSVCRT name 'strcat';
procedure _isspace; external MSVCRT name 'isspace';
procedure _isalnum; external MSVCRT name 'isalnum';
procedure _isdigit; external MSVCRT name 'isdigit';
procedure _isxdigit; external MSVCRT name 'isxdigit';
procedure _atol; external MSVCRT name 'atol';

function _wsprintfA: Integer; external 'user32.dll' name 'wsprintfA';
procedure RtlUnwind; external 'NtDll.dll' name 'RtlUnwind';

var
  __turboFloat: LongBool = False;
  __streams: Pointer = nil;

// end stubs

function _sqlite3_libVersion: PAnsiChar; cdecl; external;

function _sqlite3_close(db: Pointer): Integer; cdecl; external;
function _sqlite3_exec(db: Pointer;
                       SQLStatement: PAnsiChar;
                       CallbackPtr: TExecCallBack;
                       CbParam: Pointer;
                       ErrMsg: PPAnsiChar): Integer; cdecl; external;

function _sqlite3_last_insert_rowid(db: Pointer): Int64; cdecl; external;
function _sqlite3_changes(db: Pointer): Integer; cdecl; external;
function _sqlite3_total_changes(db: Pointer): Integer; cdecl; external;
procedure _sqlite3_interrupt(db: Pointer); cdecl; external;
function _sqlite3_complete(P: PAnsiChar): Integer; cdecl; external;
function _sqlite3_busy_handler(db: Pointer;
                               CallbackPtr: TBusyHandler;
                               user: Pointer): Integer; cdecl; external;
                               
function _sqlite3_busy_timeout(db: Pointer; TimeOut: Integer): Integer; cdecl; external;
procedure _sqlite3_free(P: PAnsiChar); cdecl; external;
function _sqlite3_open(dbname: PAnsiChar; var db: Pointer): Integer; cdecl; external;
function _sqlite3_open16(dbname: PWideChar; var db: Pointer): Integer; cdecl; external;
function _sqlite3_errcode(db: Pointer): Integer; cdecl; external;
function _sqlite3_errmsg(db: Pointer): PAnsiChar; cdecl; external;
function _sqlite3_errmsg16(db: Pointer): PWideChar; cdecl; external;

function _sqlite3_prepare(db: Pointer;
                         Sql: PAnsiChar;
                         nBytes: Integer;
                         var stmt: Pointer;
                         pzTail: PPAnsiChar): Integer; cdecl; external;

function _sqlite3_prepare16(db: Pointer;
                         Sql: PWideChar;
                         nBytes: Integer;
                         var stmt: Pointer;
                         pzTail: PPWideChar): Integer; cdecl; external;

function _sqlite3_bind_double(stmt: Pointer; idx: Integer; value: Double): Integer; cdecl; external;
function _sqlite3_bind_int(stmt: Pointer; idx: Integer; value: Integer): Integer; cdecl; external;
function _sqlite3_bind_int64(stmt: Pointer; idx: Integer; value: Int64): Integer; cdecl; external;
function _sqlite3_bind_null(stmt: Pointer; idx: Integer): Integer; cdecl; external;
//sqlite3_bind_value(stmt: Pointer; idx: Integer; value: Pointer): Integer; cdecl; external;
function _sqlite3_bind_text(stmt: Pointer;
                           idx: Integer;
                           value: PAnsiChar;
                           size: Integer;
                           xDel: Integer): Integer; cdecl; external;
function _sqlite3_bind_blob(stmt: Pointer;
                           idx: Integer;
                           value: Pointer;
                           size: Integer;
                           xDel: Integer): Integer; cdecl; external;

function _sqlite3_bind_parameter_count(stmt: Pointer): Integer; cdecl; external;
function _sqlite3_bind_parameter_name(stmt: Pointer; idx: Integer): PAnsiChar; cdecl; external;


function _sqlite3_bind_parameter_index(stmt: Pointer; zName: PAnsiChar): Integer; cdecl; external;


function _sqlite3_column_count(pStmt: Pointer): Integer; cdecl; external;
function _sqlite3_column_name(pStmt: Pointer; idx: Integer): PAnsiChar; cdecl; external;
function _sqlite3_column_name16(pStmt: Pointer; idx: Integer): PWideChar; cdecl; external;
function _sqlite3_column_decltype(pStmt: Pointer; idx: Integer): PAnsiChar; cdecl; external;
function _sqlite3_step(pStmt: Pointer): Integer; cdecl; external;

function _sqlite3_data_count(pStmt: Pointer): Integer; cdecl; external;

function _sqlite3_column_blob(pStmt: Pointer; col: Integer): Pointer; cdecl; external;
function _sqlite3_column_bytes(pStmt: Pointer; col: Integer): Integer; cdecl; external;
function _sqlite3_column_double(pStmt: Pointer; col: Integer): Double; cdecl; external;
function _sqlite3_column_int(pStmt: Pointer; col: Integer): Integer; cdecl; external;
function _sqlite3_column_int64(pStmt: Pointer; col: Integer): Int64; cdecl; external;
function _sqlite3_column_text(pStmt: Pointer; col: Integer): PAnsiChar; cdecl; external;
function _sqlite3_column_text16(pStmt: Pointer; col: Integer): PWideChar; cdecl; external;
function _sqlite3_column_type(pStmt: Pointer; col: Integer): Integer; cdecl; external;

function _sqlite3_finalize(pStmt: Pointer): Integer; cdecl; external;
function _sqlite3_reset(pStmt: Pointer): Integer; cdecl; external;

function _sqlite3_create_function(
  db: Pointer;
  zFunctionName: PAnsiChar;
  nArg: Integer;
  eTextRep: Integer;
  userData: Pointer;
  xFunc,
  xStep: TFuncHandler;
  xFinal: TFuncFinalizer): Integer; cdecl; external;

function _sqlite3_aggregate_count(sqlite3_context: Pointer): Integer;  cdecl; external;

function _sqlite3_value_blob(v: PValue): Pointer; cdecl; external;
function _sqlite3_value_bytes(v: PValue): Integer; cdecl; external;
function _sqlite3_value_double(v: PValue): Double; cdecl; external;
function _sqlite3_value_int(v: PValue): Integer; cdecl; external;
function _sqlite3_value_int64(v: PValue): Int64; cdecl; external;
function _sqlite3_value_text(v: PValue): PAnsiChar; cdecl; external;
function _sqlite3_value_type(v: PValue): Integer; cdecl; external;

function _sqlite3_aggregate_context(context: Pointer; nBytes: Integer): Pointer; cdecl; external;

function _sqlite3_user_data(context: Pointer): Pointer; cdecl; external;

function _sqlite3_get_auxdata(context: Pointer; idx: Integer): Pointer; cdecl; external;
procedure _sqlite3_set_auxdata(context: Pointer; idx: Integer;
                              data: Pointer;
                              xDel: Integer); cdecl; external;

procedure _sqlite3_result_blob(context: Pointer; value: Pointer; size: Integer;
                              xDel: Integer); cdecl; external;
procedure _sqlite3_result_double(context: Pointer; value: Double); cdecl; external;
procedure _sqlite3_result_error(context: Pointer; msg: PAnsiChar; len: Integer); cdecl; external;
procedure _sqlite3_result_int(context: Pointer; value: Integer); cdecl; external;
procedure _sqlite3_result_int64(context: Pointer; value: Int64); cdecl; external;
procedure _sqlite3_result_null(context: Pointer); cdecl; external;
procedure _sqlite3_result_text(context: Pointer; value: PAnsiChar; len: Integer;
                              xDel: Integer); cdecl; external;
procedure _sqlite3_result_value(context: Pointer; value: PValue); cdecl; external;

function _sqlite3_create_collation(db: Pointer;
  zName: PAnsiChar;
  eTextRep: Integer;
  userData: Pointer;
  func: TUserCollation): Integer; cdecl; external;

function _sqlite3_collation_needed(db: Pointer;
  userData: Pointer;
  func: TUserCollationNeeded): Integer; cdecl; external;

function sqlite3_libVersion: PAnsiChar; asm pop ebp; jmp _sqlite3_libVersion; end;
function sqlite3_close; asm pop ebp; jmp _sqlite3_close end;
function sqlite3_exec; asm pop ebp; jmp _sqlite3_exec end;
function sqlite3_last_insert_rowid; asm pop ebp; jmp _sqlite3_last_insert_rowid end;
function sqlite3_changes; asm pop ebp; jmp _sqlite3_changes end;
function sqlite3_total_changes; asm pop ebp; jmp _sqlite3_total_changes end;
procedure sqlite3_interrupt; asm pop ebp; jmp _sqlite3_interrupt end;
function sqlite3_complete; asm pop ebp; jmp _sqlite3_complete end;
function sqlite3_busy_handler; asm pop ebp; jmp _sqlite3_busy_handler end;
function sqlite3_busy_timeout; asm pop ebp; jmp _sqlite3_busy_timeout end;
procedure sqlite3_free; asm pop ebp; jmp _sqlite3_free end;
function sqlite3_open; asm pop ebp; jmp _sqlite3_open end;
function sqlite3_open16; asm pop ebp; jmp _sqlite3_open16 end;
function sqlite3_errcode; asm pop ebp; jmp _sqlite3_errcode end;
function sqlite3_errmsg; asm pop ebp; jmp _sqlite3_errmsg end;
function sqlite3_errmsg16; asm pop ebp; jmp _sqlite3_errmsg16 end;
function sqlite3_prepare; asm pop ebp; jmp _sqlite3_prepare end;
function sqlite3_prepare16; asm pop ebp; jmp _sqlite3_prepare16 end;
function sqlite3_bind_double; asm pop ebp; jmp _sqlite3_bind_double end;
function sqlite3_bind_int; asm pop ebp; jmp _sqlite3_bind_int end;
function sqlite3_bind_int64; asm pop ebp; jmp _sqlite3_bind_int64 end;
function sqlite3_bind_null; asm pop ebp; jmp _sqlite3_bind_null end;
//function sqlite3_bind_value; asm pop ebp; jmp _sqlite3_bind_value end;
function sqlite3_bind_text; asm pop ebp; jmp _sqlite3_bind_text end;
function sqlite3_bind_blob; asm pop ebp; jmp _sqlite3_bind_blob end;
function sqlite3_bind_parameter_count; asm pop ebp; jmp _sqlite3_bind_parameter_count end;
function sqlite3_bind_parameter_name; asm pop ebp; jmp _sqlite3_bind_parameter_name end;
function sqlite3_bind_parameter_index; asm pop ebp; jmp _sqlite3_bind_parameter_index end;
function sqlite3_column_count; asm pop ebp; jmp _sqlite3_column_count end;
function sqlite3_column_name; asm pop ebp; jmp _sqlite3_column_name end;
function sqlite3_column_name16; asm pop ebp; jmp _sqlite3_column_name16 end;
function sqlite3_column_decltype; asm pop ebp; jmp _sqlite3_column_decltype end;
function sqlite3_step; asm pop ebp; jmp _sqlite3_step end;
function sqlite3_data_count; asm pop ebp; jmp _sqlite3_data_count end;
function sqlite3_column_blob; asm pop ebp; jmp _sqlite3_column_blob end;
function sqlite3_column_bytes; asm pop ebp; jmp _sqlite3_column_bytes end;
function sqlite3_column_double; asm pop ebp; jmp _sqlite3_column_double end;
function sqlite3_column_int; asm pop ebp; jmp _sqlite3_column_int end;
function sqlite3_column_int64; asm pop ebp; jmp _sqlite3_column_int64 end;
function sqlite3_column_text; asm pop ebp; jmp _sqlite3_column_text end;
function sqlite3_column_text16; asm pop ebp; jmp _sqlite3_column_text16 end;
function sqlite3_column_type; asm pop ebp; jmp _sqlite3_column_type end;
function sqlite3_finalize; asm pop ebp; jmp _sqlite3_finalize end;
function sqlite3_reset; asm pop ebp; jmp _sqlite3_reset end;
function sqlite3_create_function; asm pop ebp; jmp _sqlite3_create_function end;
function sqlite3_aggregate_count; asm pop ebp; jmp _sqlite3_aggregate_count end;
function sqlite3_value_blob; asm pop ebp; jmp _sqlite3_value_blob end;
function sqlite3_value_bytes; asm pop ebp; jmp _sqlite3_value_bytes end;
function sqlite3_value_double; asm pop ebp; jmp _sqlite3_value_double end;
function sqlite3_value_int; asm pop ebp; jmp _sqlite3_value_int end;
function sqlite3_value_int64; asm pop ebp; jmp _sqlite3_value_int64 end;
function sqlite3_value_text; asm pop ebp; jmp _sqlite3_value_text end;
function sqlite3_value_type; asm pop ebp; jmp _sqlite3_value_type end;
function sqlite3_aggregate_context; asm pop ebp; jmp _sqlite3_aggregate_context end;
function sqlite3_user_data; asm pop ebp; jmp _sqlite3_user_data end;
function sqlite3_get_auxdata; asm pop ebp; jmp _sqlite3_get_auxdata end;
procedure sqlite3_set_auxdata; asm pop ebp; jmp _sqlite3_set_auxdata end;
procedure sqlite3_result_blob; asm pop ebp; jmp _sqlite3_result_blob end;
procedure sqlite3_result_double; asm pop ebp; jmp _sqlite3_result_double end;
procedure sqlite3_result_error; asm pop ebp; jmp _sqlite3_result_error end;
procedure sqlite3_result_int; asm pop ebp; jmp _sqlite3_result_int end;
procedure sqlite3_result_int64; asm pop ebp; jmp _sqlite3_result_int64 end;
procedure sqlite3_result_null; asm pop ebp; jmp _sqlite3_result_null end;
procedure sqlite3_result_text; asm pop ebp; jmp _sqlite3_result_text end;
procedure sqlite3_result_value; asm pop ebp; jmp _sqlite3_result_value end;
function sqlite3_create_collation; asm pop ebp; jmp _sqlite3_create_collation end;
function sqlite3_collation_needed; asm pop ebp; jmp _sqlite3_collation_needed end;

{$ELSE}

function sqlite3_libVersion; external SQLITEDLL;
function sqlite3_close; external SQLITEDLL;
function sqlite3_exec; external SQLITEDLL;
function sqlite3_last_insert_rowid; external SQLITEDLL;
function sqlite3_changes; external SQLITEDLL;
function sqlite3_total_changes; external SQLITEDLL;
procedure sqlite3_interrupt; external SQLITEDLL;
function sqlite3_complete; external SQLITEDLL;
function sqlite3_busy_handler; external SQLITEDLL;
function sqlite3_busy_timeout; external SQLITEDLL;
procedure sqlite3_free; external SQLITEDLL;
function sqlite3_open; external SQLITEDLL;
function sqlite3_open16; external SQLITEDLL;
function sqlite3_errcode; external SQLITEDLL;
function sqlite3_errmsg; external SQLITEDLL;
function sqlite3_errmsg16; external SQLITEDLL;
function sqlite3_prepare; external SQLITEDLL;
function sqlite3_prepare16; external SQLITEDLL;
function sqlite3_bind_double; external SQLITEDLL;
function sqlite3_bind_int; external SQLITEDLL;
function sqlite3_bind_int64; external SQLITEDLL;
function sqlite3_bind_null; external SQLITEDLL;
//function sqlite3_bind_value; external SQLITEDLL;
function sqlite3_bind_text; external SQLITEDLL;
function sqlite3_bind_blob; external SQLITEDLL;
function sqlite3_bind_parameter_count; external SQLITEDLL;
function sqlite3_bind_parameter_name; external SQLITEDLL;
function sqlite3_bind_parameter_index; external SQLITEDLL;
function sqlite3_column_count; external SQLITEDLL;
function sqlite3_column_name; external SQLITEDLL;
function sqlite3_column_name16; external SQLITEDLL;
function sqlite3_column_decltype; external SQLITEDLL;
function sqlite3_step; external SQLITEDLL;
function sqlite3_data_count; external SQLITEDLL;
function sqlite3_column_blob; external SQLITEDLL;
function sqlite3_column_bytes; external SQLITEDLL;
function sqlite3_column_double; external SQLITEDLL;
function sqlite3_column_int; external SQLITEDLL;
function sqlite3_column_int64; external SQLITEDLL;
function sqlite3_column_text; external SQLITEDLL;
function sqlite3_column_text16; external SQLITEDLL;
function sqlite3_column_type; external SQLITEDLL;
function sqlite3_finalize; external SQLITEDLL;
function sqlite3_reset; external SQLITEDLL;
function sqlite3_create_function; external SQLITEDLL;
function sqlite3_aggregate_count; external SQLITEDLL;
function sqlite3_value_blob; external SQLITEDLL;
function sqlite3_value_bytes; external SQLITEDLL;
function sqlite3_value_double; external SQLITEDLL;
function sqlite3_value_int; external SQLITEDLL;
function sqlite3_value_int64; external SQLITEDLL;
function sqlite3_value_text; external SQLITEDLL;
function sqlite3_value_type; external SQLITEDLL;
function sqlite3_aggregate_context; external SQLITEDLL;
function sqlite3_user_data; external SQLITEDLL;
function sqlite3_get_auxdata; external SQLITEDLL;
procedure sqlite3_set_auxdata; external SQLITEDLL;
procedure sqlite3_result_blob; external SQLITEDLL;
procedure sqlite3_result_double; external SQLITEDLL;
procedure sqlite3_result_error; external SQLITEDLL;
procedure sqlite3_result_int; external SQLITEDLL;
procedure sqlite3_result_int64; external SQLITEDLL;
procedure sqlite3_result_null; external SQLITEDLL;
procedure sqlite3_result_text; external SQLITEDLL;
procedure sqlite3_result_value; external SQLITEDLL;
function sqlite3_create_collation; external SQLITEDLL;
function sqlite3_collation_needed; external SQLITEDLL;

{$ENDIF}

function checkSqliteLoaded: Boolean;
begin
  Result := true;
end;

end.