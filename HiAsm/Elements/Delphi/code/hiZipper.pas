unit hiZipper;

interface

uses Kol, Windows, Share, Debug; 

type
  ZIPResult = integer;
  THIZipper = class( TDebug )
    private
      strZIP                  : string;
      intCount                : integer;
      
      List                    : PKOLStrList;
      ArrList                 : PArray;
      function _GetList( var Item : TData; var Val : TData): boolean;
      function _CountList     : integer;
      function Check( intResult: integer ) : boolean;
    public
      _prop_ZipFileName       : string;
      _prop_BasePath          : string;
      _prop_FileMask          : string;
      _prop_Password          : string;
      _prop_Comment           : string;
      _prop_SpanSize          : integer;
      _prop_UpdateMode        : byte;
      _prop_Method            : byte;
      _prop_SkipOlder         : byte;
      _prop_TestOnly          : byte;
      _prop_ResetAttr         : byte;
      _prop_CheckAttr         : byte;
      _prop_UseFolders        : byte;
      _prop_IncludeSubfolders : byte;
      _prop_OverwriteExisting : byte;
      _prop_Progress          : byte;
      
      _event_onProgress       : THI_Event;
      _event_onError          : THI_Event;
      
      _data_Data              : THI_Event;
      _data_ZipFileName       : THI_Event;
      _data_BasePath          : THI_Event;
      _data_FileMask          : THI_Event;
      _data_Index             : THI_Event;
      
      constructor Create;
      destructor Destroy; override;
      
      procedure _work_doCreate(var _Data: TData; Index: Word);
      procedure _work_doOpen(var _Data: TData; Index: Word);
      procedure _work_doOrder(var _Data: TData; Index: Word);
      procedure _work_doOrderMulti(var _Data: TData; Index: Word);
      procedure _work_doCompress(var _Data: TData; Index: Word);
      procedure _work_doClose(var _Data: TData; Index: Word);
      procedure _work_doExtractAll(var _Data: TData; Index: Word);
      procedure _work_doExtractOne(var _Data: TData; Index: Word);
      procedure _work_doList(var _Data: TData; Index: Word);
      procedure _work_doDelete(var _Data: TData; Index: Word);
      procedure _work_doCancel(var _Data: TData; Index: Word);
      procedure _work_doPassword(var _Data: TData; Index: Word);
      procedure _var_Count(var _Data: TData; Index: Word);
      procedure _var_List(var _Data: TData; Index: Word);
      
  end;

 const
  BSZIP        = 'BSZIP.dll';
  OLE32        = 'OLE32.dll';


implementation

uses HiTime;

function zCancelOperation(
  ): Boolean;  stdcall; 
  external BSZIP name 'zCancelOperation';

function zGetRunTimeInfo( var
  ProcessedFiles,
  ProcessedBytes    : integer
  ): Boolean; stdcall;
  external BSZIP name 'zGetRunTimeInfo';

function CoDosDateTimeToFileTime(
  nDosDate              : Word;
  nDosTime              : Word;
  var filetime          : TFileTime
  ) : BOOLEAN; stdcall;       
  external OLE32 name 'CoDosDateTimeToFileTime';

function zSelectFile(
  index                 : integer;
  how                   : boolean
  ) : Boolean;  stdcall;
  external BSZIP name 'zSelectFile';

function zDeleteFiles(
  ) : Integer;  stdcall;
  external BSZIP name 'zDeleteFiles';

function zGetFileTime(
  index                 : integer
  ) : Integer;  stdcall;
  external BSZIP name 'zGetFileTime';

function zGetFileDate(
  index                 : integer
  ) : Integer;  stdcall;
  external BSZIP name 'zGetFileDate';

function zGetFilePath(
  index                 : integer
  ) : PAnsiChar;  stdcall;
  external BSZIP name 'zGetFilePath';

function zGetFileName(
  index                 : integer
  ) : PAnsiChar;  stdcall;
  external BSZIP name 'zGetFileName';

function zGetFileSize(
  index                 : integer
  ) : Integer;  stdcall;
  external BSZIP name 'zGetFileSize';

function zGetTotalFiles(
  ) : Integer;  stdcall;
  external BSZIP name 'zGetTotalFiles';

function zGetCompressedFileSize(
  index                 : integer
  ): Integer; stdcall;
  external BSZIP name 'zGetCompressedFileSize';
  
function zCreateNewZip(
  zipfilename           : PAnsiChar
  ): ZIPResult; stdcall;
  external BSZIP name 'zCreateNewZip';

function zOpenZipFile(
  zipfilename           : PAnsiChar
  ): ZIPResult; stdcall;
  external BSZIP name 'zOpenZipFile';

function zCloseZipFile(
  ): ZIPResult; stdcall;
  external BSZIP name 'zCloseZipFile';

function zExtractAll(
  ExtractDirectory      : PAnsiChar;
  Password              : PAnsiChar;
  OverwriteExisting     : boolean;
  SkipOlder             : boolean;
  UseFolders            : boolean;
  TestOnly              : boolean;
  RTInfoFunc            : pointer
  ): ZIPResult; stdcall;
  external BSZIP name 'zExtractAll';

function zExtractOne(
  index                 : integer;
  ExtractDirectory      : PAnsiChar;
  Password              : PAnsiChar;
  OverwriteExisting     : boolean;
  SkipOlder             : boolean;
  UseFolders            : boolean;
  TestOnly              : boolean;
  RTInfoFunc            : pointer
  ): ZIPResult; stdcall;
  external BSZIP name 'zExtractOne';

function zOrderFile(
  FileName              : PAnsiChar;
  StoredName            : PAnsiChar;
  UpdateMode            : integer
  ): ZIPResult; stdcall;
  external BSZIP name 'zOrderFile';

function zOrderByWildcards(
  FileMask              : PAnsiChar;
  BasePath              : PAnsiChar;
  IncludeSubfolders     : boolean;
  CheckArchiveAttribute : boolean;
  UpdateMode            : integer
  ): ZIPResult; stdcall;
  external BSZIP name 'zOrderByWildcards';
  
function zCompressFiles(
  TempDir               : PAnsiChar;
  Password              : PAnsiChar;
  CompressionMethod     : integer;
  ResetArchiveAttribute : boolean;
  SpanSize              : integer;
  Comment               : string;
  RTInfoFunc            : pointer
  ): ZIPResult; stdcall;
  external BSZIP name 'zCompressFiles';


var
  pSelf: THIZipper;

procedure onProgress; far;
var
  intFiles: integer;
  intBytes: integer;
begin
  zGetRunTimeInfo(intFiles, intBytes);
  if pSelf._prop_Progress = 0 then
    _hi_OnEvent( pSelf._event_onProgress,  intFiles )
  else
    _hi_OnEvent( pSelf._event_onProgress,  intBytes );
end;


constructor THIZipper.Create;
begin
  inherited Create;
  List := NewKOLStrList;
  ArrList := CreateArray( nil, _GetList, _CountList, nil );
  strZIP := '';
end;

destructor THIZipper.Destroy;
begin
  List.Free;
  if ArrList <> nil then dispose(ArrList);
  inherited;
end;

function THIZipper.Check( intResult: integer ) : boolean;
begin
  Result := False;
  _hi_OnEvent( _event_onError, intResult );
  if intResult = 0 then Result := True;
end;

procedure THIZipper._work_doCreate(var _Data: TData; Index: Word);
begin
  if (strZIP <> '') and Check( zCloseZipFile ) then strZIP := '';
  strZIP := ReadString( _Data, _data_ZipFileName, _prop_ZipFileName );
  if Check( zCreateNewZip( PAnsiChar(AnsiString(strZIP) ) ) ) then
    List.Clear
  else
    strZIP := '';
end;

procedure THIZipper._work_doOpen(var _Data: TData; Index: Word);
begin
  if strZIP <> '' then
    if Check( zCloseZipFile ) then
      strZIP := '';
  strZIP := ReadString( _Data, _data_ZipFileName, _prop_ZipFileName );
  if Check( zOpenZipFile( PAnsiChar( AnsiString(strZIP) ) ) ) then
    List.Clear
  else
    strZIP := '';
end;

procedure THIZipper._work_doList;
const
  tab : string = Char($09);
var
  i : Word;
  strTemp : string;
  date : word;
  time : word;
  sys : TSystemTime;
  Ratio : integer;
  fs : integer;
  cfs : integer;
  sysDateTime: TFileTime;
begin
  if strZIP = '' then Exit;
  intCount := zGetTotalFiles;
  List.Clear;
  for i := 0 to intCount - 1 do
  begin
    strTemp := zGetFileName( i ) + tab;
    date := zGetFileDate( i );
    time := zGetFileTime( i );
    CoDosDateTimeToFileTime( date, time, sysDateTime );
    FileTimeToSystemTime( sysDateTime, sys );
    strTemp := strTemp + TimeToStr( 'D.M.Y h:m:s', sys ) + tab;
    fs := zGetFileSize( i );
    cfs := zGetCompressedFileSize( i );
    if fs <> 0 then
      Ratio := 100 - Trunc( ( cfs / fs ) * 100 )
    else
      Ratio := 0;
    strTemp := strTemp + Int2Str( fs ) + tab;
    strTemp := strTemp + Int2Str( Ratio ) + '%' + tab;
    strTemp := strTemp + Int2Str( cfs ) + tab;
    strTemp := strTemp + zGetFilePath( i );
    List.Add( strTemp );
  end;
end;

procedure THIZipper._work_doOrder(var _Data: TData; Index: Word);
var
  strTemp : string;
  strName : string;
  strStoredName : string;
begin
  if strZIP = '' then Exit;
  strName := ReadString( _Data, _data_Data, '' );
  strTemp := kol.ExtractFilePath( strZIP );
  strStoredName := Copy( strName, Length( strTemp ) + 1, Length( strName ) - Length( strTemp ) );
  if Check( zOrderFile(
                   PAnsiChar(AnsiString(strName)),
                   PAnsiChar(AnsiString(strStoredName)),
                   _prop_UpdateMode 
                   ) )
  then
  begin
    List.Add( kol.ExtractFileName( strName ) );
    intCount := List.Count;
  end;
end;

procedure THIZipper._work_doOrderMulti(var _Data: TData; Index: Word);
var
  strMask: string;
  strPath: string;
begin
  if strZIP = '' then Exit;
  strMask := ReadString( _Data, _data_FileMask, _prop_FileMask );
  strPath := ReadString( _Data, _data_BasePath, _prop_BasePath );
  if (strPath = '') or (strPath[Length(strPath)] <> '\') then strPath := strPath + '\';
  
  Check( zOrderByWildcards(
                   PAnsiChar(AnsiString(strPath + strMask)),
                   PAnsiChar(AnsiString(strPath)),
                   (_prop_IncludeSubfolders = 0),
                   (_prop_CheckAttr = 0),
                   _prop_UpdateMode
                   ) );
end;

procedure THIZipper._work_doCompress;
begin
  if strZIP = '' then Exit;
  
  pSelf := Self;
  Check( zCompressFiles(
                   nil,
                   PAnsiChar(AnsiString(_prop_Password)),
                   _prop_Method,
                   (_prop_ResetAttr = 0),
                   _prop_SpanSize,
                   _prop_Comment,
                   @onProgress
                   ) );
end;

procedure THIZipper._work_doExtractAll(var _Data: TData; Index: Word);
var
  strPath: string;
begin
  if strZIP = '' then Exit;
  strPath := ReadString( _Data, _data_BasePath, _prop_BasePath );
  
  pSelf := Self;
  Check( zExtractAll(
                   PAnsiChar(AnsiString(strPath)),
                   PAnsiChar(AnsiString(_prop_Password)),
                   (_prop_OverwriteExisting = 0),
                   (_prop_SkipOlder = 0),
                   (_prop_UseFolders = 0),
                   (_prop_TestOnly = 0),
                   @onProgress
                   ) );
end;

procedure THIZipper._work_doExtractOne(var _Data: TData; Index: Word);
var
  i: integer;
  strPath: string;
begin
  if strZIP = '' then Exit;
  strPath := ReadString( _Data, _data_BasePath, _prop_BasePath );
  i := ReadInteger( _Data, _data_Index, 0 );
  
  pSelf := Self;
  Check( zExtractOne(
                   i,
                   PAnsiChar(AnsiString(strPath)),
                   PAnsiChar(AnsiString(_prop_Password)),
                   (_prop_OverwriteExisting = 0),
                   (_prop_SkipOlder = 0),
                   (_prop_UseFolders = 0),
                   (_prop_TestOnly = 0),
                   @onProgress
                   ) );
end;

procedure THIZipper._work_doDelete(var _Data: TData; Index: Word);
var
  i : integer;
begin
  if strZIP = '' then Exit;
  i := ToInteger( _Data );
  if zSelectFile( i, True) then
  begin
    Check( zDeleteFiles );
    zSelectFile( i, False )
  end;
end;

procedure THIZipper._work_doCancel;
begin
  if strZIP <> '' then zCancelOperation();
end;

procedure THIZipper._work_doClose;
begin
  if strZIP = '' then Exit; 
  if Check( zCloseZipFile ) then
  begin
    List.Clear; 
    strZIP := '';
  end;
end;

procedure THIZipper._work_doPassword;
begin
  _prop_Password := Share.ToString( _Data );
end;

procedure  THIZipper._var_Count(var _Data:TData; Index:word);
begin
  dtInteger(_Data, intCount);
end;

procedure THIZipper._var_List(var _Data: TData; Index: Word);
begin
  dtArray(_Data, ArrList );
end;

function THIZipper._GetList;
var
  ind: integer;
begin
  ind := ToIntIndex( Item );
  if (ind >= 0) and (ind < List.Count) then
  begin
    Result := true;
    dtString(Val,List.Items[ind]);
  end
  else Result := false;
end;

function THIZipper._CountList;
begin
  Result := List.Count;
end;


end.