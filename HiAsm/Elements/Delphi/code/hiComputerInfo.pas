unit hiComputerInfo;

interface

uses
  Windows, Kol, Share, Debug;

type
  TWinVersion = (wvUnknown, wv95, wv98, wvME, wvNT3, wvNT4, wvW2K, wvXP, wv2003, wvVista, wv7, wv8, wv81, wv10TP, wv10);
  THIComputerInfo = class(TDebug)
    private
      CSDVer: string;
      MajVer, MinVer, BuildN, PlID: DWORD;
      XXbit: Integer;
     
      function DetectWinVersion: TWinVersion;
      function DetectWinVersionStr: string;
    public
      _prop_Mask: string;
      _prop_WinInfoMask: string;

      procedure _var_UserName(var _Data: TData; Index: Word);
      procedure _var_CompName(var _Data: TData; Index: Word);
      procedure _var_CPU(var _Data: TData; Index: Word);
      procedure _var_WinInfo(var _Data: TData; Index: Word);
  end;

implementation

const
  UNLEN = 256;

procedure THIComputerInfo._var_UserName;
var
  Size: Cardinal;
  S: string;
begin
  Size := UNLEN;
  SetLength(S, Size);
  if GetUserName(Pointer(S), Size) then
    SetLength(S, Size-1) // Size incl. null
  else
    S := '';
  dtString(_Data, S);
end;

function GetComputerNameEx(
         NameType: Integer; // name type
         Buffer: PChar; // name buffer
         var Size: DWord // size of name buffer
): BOOL; stdcall; external 'kernel32.dll' name {$ifdef UNICODE}'GetComputerNameExW'{$else}'GetComputerNameExA'{$endif};

procedure THIComputerInfo._var_CompName;
var
  Size: Cardinal;
  S: string;
begin
  Size := MAX_COMPUTERNAME_LENGTH;
  SetLength(S, Size);
  if GetComputerNameEx(1, Pointer(S), Size) then
    SetLength(S, Size)
  else
    S := '';
  dtString(_Data, S);
end;

procedure THIComputerInfo._var_CPU;
var
  SysInfo: TSystemInfo;
  s: string;
begin
  GetSystemInfo(SysInfo);
  s := _prop_Mask;
  Replace(s,'%t',Int2Str(SysInfo.dwProcessorType));
  Replace(s,'%n',Int2Str(SysInfo.dwNumberOfProcessors));
  dtString(_Data,s);
end;

procedure THIComputerInfo._var_WinInfo;
var
  name, res: string;
begin
  name := DetectWinVersionStr;
  res := _prop_WinInfoMask;
  Replace(res, '%n', name);
  Replace(res, '%M', Int2Str(MajVer));
  Replace(res, '%m', Int2Str(MinVer));
  Replace(res, '%p', Int2Str(PlID));
  Replace(res, '%b', Int2Str(BuildN));
  Replace(res, '%o', CSDVer);
  Replace(res, '%x', Int2Str(XXbit));
  dtString(_Data, res);
end;


function THIComputerInfo.DetectWinVersion:TWinVersion;
var
  OSVersionInfo: TOSVersionInfo;
begin
  Result := wvUnknown;
  OSVersionInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  if GetVersionEx(OSVersionInfo) then
  begin
    CSDVer := OSVersionInfo.szCSDVersion;
    MajVer := OSVersionInfo.DwMajorVersion;
    MinVer := OSVersionInfo.DwMinorVersion;
    PlID := OSVersionInfo.dwPlatformId;
    BuildN := OSVersionInfo.dwBuildNumber;
    if GetEnvironmentVariable(PChar('ProgramFiles(x86)'), nil, 0) > 0 then
      XXbit := 64 else XXbit := 32;
    case MajVer of
      3: Result := wvNT3;              // Windows NT 3
      4: case MinVer of
           0: if PlID = VER_PLATFORM_WIN32_NT
                then Result := wvNT4   // Windows NT 4
               else Result := wv95;    // Windows 95
           10: Result := wv98;         // Windows 98
           90: Result := wvME;         // Windows ME
             end;
      5: case MinVer of
           0: Result := wvW2K;         // Windows 2000
           1: Result := wvXP;          // Windows XP
           2: Result := wv2003;        // Windows 2003
         end;
      6: case MinVer of
           0: Result := wvVista;       // Windows Vista
           1: Result := wv7;           // Windows 7
           2: Result := wv8;           // Windows 8
           3: Result := wv81;          // Windows 8.1
           4: Result := wv10;          // Windows 10 Technical Preview
         end;
      10: case MinVer of
           0: Result := wv10;          // Windows 10
         end;         
    end;
  end;
end;

function THIComputerInfo.DetectWinVersionStr:string;
const 
  VersStr : array[TWinVersion] of string = (
    'Unknown',
    '95',
    '98',
    'ME',
    'NT 3',
    'NT 4',
    '2000',
    'XP',
    '2003',
    'Vista',
    '7',
    '8',
    '8.1',
    '10 Technical Preview',
    '10');
begin
  Result := VersStr[DetectWinVersion];
end;

end.
