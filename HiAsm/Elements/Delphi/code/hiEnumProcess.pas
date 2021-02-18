unit hiEnumProcess; { Расширенное управление процессами в линейке Windows NT }

interface

uses
  Windows, Messages, Kol, Share, tlhelp32, Debug;

const
  STATUS_SUCCESS = 0;

type
  PPOINTER = ^POINTER;
  USHORT = WORD;
  UCHAR = byte;
  PWSTR = PWideChar;

  NTSTATUS = Longint;
  PVOID = Pointer;
  KSPIN_LOCK = ULONG;
  KAFFINITY = ULONG;
  KPRIORITY = Integer;
 
  _UNICODE_STRING = record
    Length: WORD;
    MaximumLength: WORD;
    Buffer:PWideChar;
  end;
  UNICODE_STRING = _UNICODE_STRING;
  PUNICODE_STRING = ^_UNICODE_STRING;
 
  _CURDIR = record
    DosPath: UNICODE_STRING;
    Handle: THandle;
  end;
  CURDIR = _CURDIR;
  PCURDIR = ^_CURDIR;
 
  PLIST_ENTRY = ^_LIST_ENTRY;
  _LIST_ENTRY = record
    Flink: PLIST_ENTRY;
    Blink: PLIST_ENTRY;
  end;
  LIST_ENTRY = _LIST_ENTRY;
  RESTRICTED_POINTER = ^_LIST_ENTRY;
  PRLIST_ENTRY = ^_LIST_ENTRY;
 
  _PEB_LDR_DATA = record
    Length: ULONG;
    Initialized: Boolean;
    SsHandle: PVOID;
    InLoadOrderModuleList: LIST_ENTRY;
    InMemoryOrderModuleList: LIST_ENTRY;
    InInitializationOrderModuleList: LIST_ENTRY;
  end;
  PEB_LDR_DATA = _PEB_LDR_DATA;
  PPEB_LDR_DATA = ^_PEB_LDR_DATA;
 
 
  _RTL_DRIVE_LETTER_CURDIR = record
    Flags: WORD;
    Length: WORD;
    TimeStamp: DWord;
    DosPath: UNICODE_STRING;
  end;
  RTL_DRIVE_LETTER_CURDIR = _RTL_DRIVE_LETTER_CURDIR;
  PRTL_DRIVE_LETTER_CURDIR = ^_RTL_DRIVE_LETTER_CURDIR;
 
 
  _PROCESS_PARAMETERS = record
    MaximumLength: ULONG;
    Length: ULONG;
    Flags: ULONG;
    DebugFlags: ULONG;
    ConsoleHandle: THANDLE;
    ConsoleFlags: ULONG;
    StandardInput: THANDLE;
    StandardOutput: THANDLE;
    StandardError: THANDLE;
    CurrentDirectory: CURDIR;
    DllPath: UNICODE_STRING;
    ImagePathName: UNICODE_STRING;
    CommandLine: UNICODE_STRING;
    Environment: PWideChar;
    StartingX: ULONG;
    StartingY: ULONG;
    CountX: ULONG;
    CountY: ULONG;
    CountCharsX: ULONG;
    CountCharsY: ULONG;
    FillAttribute: ULONG;
    WindowFlags: ULONG;
    ShowWindowFlags: ULONG;
    WindowTitle: UNICODE_STRING;
    Desktop: UNICODE_STRING;
    ShellInfo: UNICODE_STRING;
    RuntimeInfo: UNICODE_STRING;
    CurrentDirectores: array[0..31] of RTL_DRIVE_LETTER_CURDIR;
  end;
  PROCESS_PARAMETERS = _PROCESS_PARAMETERS;
  PPROCESS_PARAMETERS = ^_PROCESS_PARAMETERS;
  PPPROCESS_PARAMETERS = ^PPROCESS_PARAMETERS;
 
  PPEBLOCKROUTINE = procedure; stdcall;
 
  PPEB_FREE_BLOCK = ^_PEB_FREE_BLOCK;
  _PEB_FREE_BLOCK = record
    Next: PPEB_FREE_BLOCK;
    Size: ULONG;
  end;
  PEB_FREE_BLOCK = _PEB_FREE_BLOCK;
 
  _RTL_BITMAP = record
    SizeOfBitMap: DWord;
    Buffer: PDWord;
  end;
  RTL_BITMAP = _RTL_BITMAP;
  PRTL_BITMAP = ^_RTL_BITMAP;
  PPRTL_BITMAP = ^PRTL_BITMAP;
 
  _SYSTEM_STRINGS = record
    SystemRoot: UNICODE_STRING;
    System32Root: UNICODE_STRING;
    BaseNamedObjects: UNICODE_STRING;
  end;
  SYSTEM_STRINGS = _SYSTEM_STRINGS;
  PSYSTEM_STRINGS = ^_SYSTEM_STRINGS;
 
  _TEXT_INFO = record
    Reserved: PVOID;
    SystemStrings: PSYSTEM_STRINGS;
  end;
  TEXT_INFO = _TEXT_INFO;
  PTEXT_INFO = ^_TEXT_INFO;
 
 
  _PEB = record
    InheritedAddressSpace: UCHAR;
    ReadImageFileExecOptions: UCHAR;
    BeingDebugged: UCHAR;
    SpareBool: BYTE;
    Mutant: PVOID;
    ImageBaseAddress: PVOID;
    Ldr: PPEB_LDR_DATA;
    ProcessParameters: PPROCESS_PARAMETERS;
    SubSystemData: PVOID;
    ProcessHeap: PVOID;
    FastPebLock: KSPIN_LOCK;
    FastPebLockRoutine: PPEBLOCKROUTINE;
    FastPebUnlockRoutine: PPEBLOCKROUTINE;
    EnvironmentUpdateCount: ULONG;
    KernelCallbackTable: PPOINTER;
    EventLogSection: PVOID;
    EventLog: PVOID;
    FreeList: PPEB_FREE_BLOCK;
    TlsExpansionCounter: ULONG;
    TlsBitmap: PRTL_BITMAP;
    TlsBitmapData: array[0..1] of ULONG;
    ReadOnlySharedMemoryBase: PVOID;
    ReadOnlySharedMemoryHeap: PVOID;
    ReadOnlyStaticServerData: PTEXT_INFO;
    InitAnsiCodePageData: PVOID;
    InitOemCodePageData: PVOID;
    InitUnicodeCaseTableData: PVOID;
    KeNumberProcessors: ULONG;
    NtGlobalFlag: ULONG;
    d6C: DWord;
    MmCriticalSectionTimeout: Int64;
    MmHeapSegmentReserve: ULONG;
    MmHeapSegmentCommit: ULONG;
    MmHeapDeCommitTotalFreeThreshold: ULONG;
    MmHeapDeCommitFreeBlockThreshold: ULONG;
    NumberOfHeaps: ULONG;
    AvailableHeaps: ULONG;
    ProcessHeapsListBuffer: PHANDLE;
    GdiSharedHandleTable: PVOID;
    ProcessStarterHelper: PVOID;
    GdiDCAttributeList: PVOID;
    LoaderLock: KSPIN_LOCK;
    NtMajorVersion: ULONG;
    NtMinorVersion: ULONG;
    NtBuildNumber: USHORT;
    NtCSDVersion: USHORT;
    PlatformId: ULONG;
    Subsystem: ULONG;
    MajorSubsystemVersion: ULONG;
    MinorSubsystemVersion: ULONG;
    AffinityMask: KAFFINITY;
    GdiHandleBuffer: array[0..33] of ULONG;
    PostProcessInitRoutine: ULONG;
    TlsExpansionBitmap: ULONG;
    TlsExpansionBitmapBits: array[0..127] of UCHAR;
    SessionId: ULONG;
    AppCompatFlags: Int64;
    CSDVersion: PWORD;
  end;
  PEB = _PEB;
  PPEB = ^_PEB;
 
  _PROCESS_BASIC_INFORMATION = record
    ExitStatus: NTSTATUS;
    PebBaseAddress: PPEB;
    AffinityMask: KAFFINITY;
    BasePriority: KPRIORITY;
    UniqueProcessId: ULONG;
    InheritedFromUniqueProcessId: ULONG;
  end;
  PROCESS_BASIC_INFORMATION = _PROCESS_BASIC_INFORMATION;
  PPROCESS_BASIC_INFORMATION = ^_PROCESS_BASIC_INFORMATION;
  TProcessBasicInformation = PROCESS_BASIC_INFORMATION;
  PProcessBasicInformation = ^PROCESS_BASIC_INFORMATION;
 
const     
  NORMAL_PRIORITY_CLASS        = $00000020;
  IDLE_PRIORITY_CLASS          = $00000040;
  HIGH_PRIORITY_CLASS          = $00000080;
  REALTIME_PRIORITY_CLASS      = $00000100;
  BELOW_NORMAL_PRIORITY_CLASS  = $00004000;
  ABOVE_NORMAL_PRIORITY_CLASS  = $00008000;
  OBJ_KERNEL_HANDLE            = $00000200;
  SYSTEM_PROCESSES_AND_THREAD_INFORMATION = 5;
  SE_KERNEL_OBJECT             = 6;

type
  PPSID = ^PSID;
  PPACL = ^PACL;
  SIZE_T = LONGWORD;
  PPSECURITY_DESCRIPTOR = ^PSECURITY_DESCRIPTOR;

type
  PUnicodeString = ^TUnicodeString;
  TUnicodeString = packed record
    Length: Word;
    MaximumLength: Word;
    Buffer: PWideChar;
  end;

type
  PObjectAttributes = ^TObjectAttributes;
  TObjectAttributes = packed record
    Length: DWord;
    RootDirectory: THandle;
    ObjectName: PUnicodeString;
    Attributes: DWord;
    SecurityDescriptor: Pointer;
    SecurityQualityOfService: Pointer;
  end;

type
  PClientID = ^TClientID;
  TClientID = packed record
    UniqueProcess:Cardinal;
    UniqueThread:Cardinal;
  end;

type
  PPROCESS_MEMORY_COUNTERS = ^PROCESS_MEMORY_COUNTERS;
  _PROCESS_MEMORY_COUNTERS = packed record
    cb: DWord;
    PageFaultCount: DWord;
    PeakWorkingSetSize: SIZE_T;
    WorkingSetSize: SIZE_T;
    QuotaPeakPagedPoolUsage: SIZE_T;
    QuotaPagedPoolUsage: SIZE_T;
    QuotaPeakNonPagedPoolUsage: SIZE_T;
    QuotaNonPagedPoolUsage: SIZE_T;
    PagefileUsage: SIZE_T;
    PeakPagefileUsage: SIZE_T;
  end;
  PROCESS_MEMORY_COUNTERS = _PROCESS_MEMORY_COUNTERS;
  TProcessMemoryCounters = PROCESS_MEMORY_COUNTERS;
  PProcessMemoryCounters = PPROCESS_MEMORY_COUNTERS;

type 
  PPerfDataBlock = ^TPerfDataBlock; 
  TPerfDataBlock = record 
    Signature: array[0..3] of WCHAR; 
    LittleEndian: DWord; 
    Version: DWord; 
    Revision: DWord; 
    TotalByteLength: DWord; 
    HeaderLength: DWord; 
    NumObjectTypes: DWord; 
    DefaultObject: Longint; 
    SystemTime: TSystemTime; 
    PerfTime: TLargeInteger; 
    PerfFreq: TLargeInteger; 
    PerfTime100nSec: TLargeInteger; 
    SystemNameLength: DWord; 
    SystemNameOffset: DWord; 
  end; 

  PPerfObjectType = ^TPerfObjectType; 
  TPerfObjectType = record 
    TotalByteLength: DWord; 
    DefinitionLength: DWord; 
    HeaderLength: DWord; 
    ObjectNameTitleIndex: DWord; 
    ObjectNameTitle: LPWSTR; 
    ObjectHelpTitleIndex: DWord; 
    ObjectHelpTitle: LPWSTR; 
    DetailLevel: DWord; 
    NumCounters: DWord; 
    DefaultCounter: Longint; 
    NumInstances: Longint; 
    CodePage: DWord; 
    PerfTime: TLargeInteger; 
    PerfFreq: TLargeInteger; 
  end; 

  PPerfCounterDefinition = ^TPerfCounterDefinition; 
  TPerfCounterDefinition = record 
    ByteLength: DWord; 
    CounterNameTitleIndex: DWord; 
    CounterNameTitle: LPWSTR; 
    CounterHelpTitleIndex: DWord; 
    CounterHelpTitle: LPWSTR; 
    DefaultScale: Longint; 
    DetailLevel: DWord; 
    CounterType: DWord; 
    CounterSize: DWord; 
    CounterOffset: DWord; 
  end; 

  PPerfInstanceDefinition = ^TPerfInstanceDefinition; 
  TPerfInstanceDefinition = record 
    ByteLength: DWord; 
    ParentObjectTitleIndex: DWord; 
    ParentObjectInstance: DWord; 
    UniqueID: Longint; 
    NameOffset: DWord; 
    NameLength: DWord; 
  end; 

  PPerfCounterBlock = ^TPerfCounterBlock; 
  TPerfCounterBlock = record 
    ByteLength: DWord; 
  end;
    
type
  TCB = function: Boolean of object;
  ThiEnumProcess = class(TDebug)
    private
      FProcessUsage: Real;
      FThread: PThread;
      FDebugPrivilege: Boolean;
      FScanID: Integer;
      
      FSearchName: string;
      FProcessID, FParentProcID: Integer;
      FProcName, FProcFullName: string;
      FFound: Boolean;
      
      procedure Enum(CallBack: TCB);
      function GetProcessAccount(proc: THandle): string;
      procedure SetDebugPrivilege(Value: Boolean);
      function EnumAll: Boolean;
      function FindName: Boolean;
      function GetProcessUsage(PID:Cardinal): Real;     
      function Execute(Sender: PThread): NativeInt;
      procedure SyncExec;      
    public
      _prop_Name: string;
      _prop_TimeOut: Integer;
      _prop_TimeScan: Integer;

      _data_ID,
      _data_Name,
      _data_AffinityMask,
      _data_PriorityBoost,
      _data_PriorityClass:THI_Event;

      _event_onProcess,
      _event_onTerminateApp,
      _event_onGetPriority,
      _event_onGetProc,
      _event_onGetProcBoost,
      _event_onGetMemoryInfo,
      _event_onGetProcessAccount,
      _event_onFind,
      _event_onNotFind,
      _event_onCPUUsage,
      _event_onGetCmdLine,
      _event_onEndEnum:THI_Event;

      constructor Create;
      destructor Destroy; override;   
   
      procedure _work_doDebugPrivilege(var _Data: TData; Index: Word);
      procedure _work_doEnum(var _Data: TData; Index: Word);
      procedure _work_doFindID(var _Data: TData; Index: Word);
      procedure _work_doFindName(var _Data: TData; Index: Word);
      procedure _work_doKill(var _Data: TData; Index: Word);
      procedure _work_doTerminateApp(var _Data: TData; Index: Word);   
      procedure _work_doSetPriority(var _Data: TData; Index: Word);
      procedure _work_doSetProc(var _Data: TData; Index: Word);
      procedure _work_doSetProcBoost(var _Data: TData; Index: Word);
      procedure _work_doGetPriority(var _Data: TData; Index: Word);
      procedure _work_doGetMemoryInfo(var _Data: TData; Index: Word);
      procedure _work_doGetProcessAccount(var _Data: TData; Index: Word);
      procedure _work_doGetProc(var _Data: TData; Index: Word);
      procedure _work_doGetProcBoost(var _Data: TData; Index: Word);
      procedure _work_doGetCmdLine(var _Data: TData; Index: Word);
      procedure _work_doStartCPUUsage(var _Data: TData; Index: Word);
      procedure _work_doStopCPUUsage(var _Data: TData; Index: Word);
      procedure _var_CurrentID(var _Data: TData; Index: Word);
      procedure _var_CurrParentID(var _Data: TData; Index: Word);   
      procedure _var_FileName(var _Data: TData; Index: Word);
      procedure _var_CPUCount(var _Data: TData; Index: Word);
      procedure _var_FullPath(var _Data: TData; Index: Word);
      procedure _var_MajorVersion(var _Data: TData; Index: Word);
      procedure _var_MinorVersion(var _Data: TData; Index: Word);   
      property _prop_DebugPrivilege: Boolean write FDebugPrivilege;
  end;

  function GetModuleFileNameEx(hProcess: THandle; hModule: HMODULE; lpFilename: PChar; nSize: DWord): DWord; stdcall;
  function GetProcessMemoryInfo(hProcess: THandle; ppsmemCounters: PPROCESS_MEMORY_COUNTERS; cb: DWord): BOOL; stdcall;
  
  function GetProcessPriorityBoost(hThread: THandle; var DisablePriorityBoost: Bool): BOOL; stdcall;
  function SetProcessPriorityBoost(hThread: THandle; DisablePriorityBoost: Bool): BOOL; stdcall;
  function GetProcessAffinityMask(hProcess: THandle; var lpProcessAffinityMask, lpSystemAffinityMask: DWord): BOOL; stdcall;
  function SetProcessAffinityMask(hProcess: THandle; dwProcessAffinityMask: DWord): BOOL; stdcall;
  
  function GetSecurityInfo(Handle: THandle; ObjectType: DWord; SecurityInfo: SECURITY_INFORMATION; ppsidOwner, ppsidGroup: PPSID;
                                        ppDacl, ppSacl: PPACL; var ppSecurityDescriptor:  PSecurityDescriptor): DWord; stdcall;
  
  function ZwQueryInformationProcess(hProcess: THandle; InformationClass: DWord; Buffer: PChar; BufferLength : DWord;ReturnLength: PDWord): DWord; stdcall;
  function ZwQuerySystemInformation(ASystemInformationClass: DWord; ASystemInformation: Pointer; ASystemInformationLength: DWord;
                                       AReturnLength: PDWord): NTStatus; stdcall;

var
  QueryFullProcessImageName : function(Process: THandle; Flags: DWord; Buffer: PChar; Size: PDWord): BOOL; stdcall;
  GetProcessImageFileName   : function(Process: THandle; Buffer: PChar; Size: DWord): DWord; stdcall;
  
  OSVersion: TOSVersionInfo;



implementation


const
{$ifdef UNICODE}
  NGetModuleFileNameEx = 'GetModuleFileNameExW';
  NGetProcessImageFileName = 'GetProcessImageFileNameW';
  NQueryFullProcessImageName = 'QueryFullProcessImageNameW';
{$else}
  NGetModuleFileNameEx = 'GetModuleFileNameExA';
  NGetProcessImageFileName = 'GetProcessImageFileNameA';
  NQueryFullProcessImageName = 'QueryFullProcessImageNameA';
{$endif}



function GetModuleFileNameEx; external 'psapi.dll' name NGetModuleFileNameEx;
function GetProcessMemoryInfo; external 'psapi.dll' name 'GetProcessMemoryInfo';

function GetProcessPriorityBoost; external 'kernel32.dll' name 'GetProcessPriorityBoost';
function SetProcessPriorityBoost; external 'kernel32.dll' name 'SetProcessPriorityBoost';
function GetProcessAffinityMask; external 'kernel32.dll' name 'GetProcessAffinityMask';
function SetProcessAffinityMask; external 'kernel32.dll' name 'SetProcessAffinityMask';

function GetSecurityInfo; external 'advapi32.dll' name 'GetSecurityInfo';

function ZwQueryInformationProcess; external 'ntdll.dll' name 'ZwQueryInformationProcess';
function ZwQuerySystemInformation; external 'ntdll.dll' name 'ZwQuerySystemInformation';



procedure InitLibraries;
var
  hDLL: THandle;
begin
  FillChar(OSVersion, SizeOf(TOSVersionInfo), 0); 
  OSVersion.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  GetVersionEx(OSVersion);
  
  hDLL := LoadLibrary('psapi.dll');
  if hDLL <> 0 then
  begin
    @GetProcessImageFileName := GetProcAddress(hDLL, NGetProcessImageFileName);       
    CloseHandle(hDLL);
  end;
  
  hDLL := LoadLibrary(kernel32);
  if hDLL <> 0 then
  begin
    @QueryFullProcessImageName  := GetProcAddress(hDLL, NQueryFullProcessImageName);
    CloseHandle(hDLL);
  end;
end;


//**********************************************************************************

function Trim(const Str: string): string;
var
  I, L: Integer;
begin
  if Str = '' then exit;
  L := Length(Str); 
  I := 1;
  while (I <= L) and (Str[I] <= ' ') do Inc(I);
  while (L > I) and (Str[L] <= ' ') do Dec(L);
  if I <= L then
    Result := Copy(Str, I, L-I+1);
end;

//**********************************************************************************

function GetProcessCmdLine(PID: DWord): string;
var
  hProcess: THandle;
  pProcBasicInfo: PROCESS_BASIC_INFORMATION;
  ReturnLength: DWord;
  prb: PEB;
  ProcessParameters: PROCESS_PARAMETERS;
  cb: NativeUInt;
  ws: WideString;
begin
  Result := '';
  if pid = 0 then exit;
  hProcess := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, PID);
  if hProcess = 0 then exit;
  
  TRY
    if (ZwQueryInformationProcess(hProcess, 0, @pProcBasicInfo, SizeOf(PROCESS_BASIC_INFORMATION), @ReturnLength) = STATUS_SUCCESS) then
    begin
      if ReadProcessMemory(hProcess, pProcBasicInfo.PebBaseAddress, @prb, SizeOf(PEB), cb) then
        if ReadProcessMemory(hProcess, prb.ProcessParameters, @ProcessParameters, SizeOf(PROCESS_PARAMETERS), cb) then
        begin
          SetLength(ws, (ProcessParameters.CommandLine.Length div SizeOf(WideChar)));
          if ReadProcessMemory(hProcess, ProcessParameters.CommandLine.Buffer,
                               PWideChar(ws), ProcessParameters.CommandLine.Length, cb)
          then
            Result := ws;
        end;
    end;
  FINALLY
    CloseHandle(hProcess)
  END;
end;

//**********************************************************************************

constructor ThiEnumProcess.Create;
begin
  inherited;
end;

destructor ThiEnumProcess.Destroy;
begin
  if FThread <> nil then free_and_nil(FThread);
  inherited;
end;

function ThiEnumProcess.GetProcessUsage;
var 
  pHandle : THandle;
  mCreationTime, mExitTime, mKernelTime, mUserTime: _FILETIME;
  TotalTime1, TotalTime2: int64;
begin
  SetDebugPrivilege(FDebugPrivilege);
  {We need to get a handle of the process with PROCESS_QUERY_INFORMATION privileges.}
  pHandle := OpenProcess(PROCESS_QUERY_INFORMATION, False, PID);

  {We can use the GetProcessTimes() function to get the amount of time the process has spent in kernel mode and user mode.}
  GetProcessTimes(pHandle, mCreationTime, mExitTime, mKernelTime, mUserTime);
  TotalTime1 := int64(mKernelTime.dwLowDateTime or (mKernelTime.dwHighDateTime shr 32)) +
                int64(mUserTime.dwLowDateTime or (mUserTime.dwHighDateTime shr 32));

  {Wait a little}
  Sleep(_prop_TimeScan); 

  GetProcessTimes(pHandle, mCreationTime, mExitTime, mKernelTime, mUserTime);
  TotalTime2 := int64(mKernelTime.dwLowDateTime or (mKernelTime.dwHighDateTime shr 32)) +
                int64(mUserTime.dwLowDateTime or (mUserTime.dwHighDateTime shr 32));

  {This should work out nicely, as there were approx. _prop_TimeScan between the calls
  and the result will be a percentage between 0 and 100}
  Result := ((TotalTime2 - TotalTime1) / _prop_TimeScan) / 100;

  CloseHandle(pHandle);
end;

function ThiEnumProcess.Execute;
begin
  repeat
    FProcessUsage := GetProcessUsage(FScanID);
    if Assigned(_event_onCPUUsage.Event) then Sender.Synchronize(SyncExec);
  until Sender.Terminated;
  Result := 0;
end;

procedure ThiEnumProcess.SyncExec;
begin
  if FScanID <> FProcessID then
    free_and_nil(FThread)
  else
    _hi_onEvent(_event_onCPUUsage, FProcessUsage);
end;

procedure ThiEnumProcess._work_doStartCPUUsage;
begin
  FScanID := {procEntry.th32ProcessID} FProcessID;
  if FThread <> nil then free_and_nil(FThread);
  FThread := {$ifdef F_P}NewThreadforFPC{$else}NewThread{$endif};
  FThread.OnExecute := Execute;
  FThread.Resume; 
end;

procedure ThiEnumProcess._work_doStopCPUUsage;
begin
  if FThread <> nil then free_and_nil(FThread);
end;

procedure ThiEnumProcess.SetDebugPrivilege;
var
  hToken: THandle;
  TokenPriv, PrevTokenPriv: TOKEN_PRIVILEGES;
  Tmp: Cardinal;
begin
  OpenProcessToken(GetCurrentProcess, TOKEN_ALL_ACCESS, hToken);
  TokenPriv.PrivilegeCount := 1;
  if Value then
    TokenPriv.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED
  else
    TokenPriv.Privileges[0].Attributes := 0;    
  LookupPrivilegeValue(nil, 'SeDebugPrivilege', TokenPriv.Privileges[0].Luid);
  Tmp := 0;
  PrevTokenPriv := TokenPriv;
  AdjustTokenPrivileges(hToken, False, TokenPriv, SizeOf(PrevTokenPriv), PrevTokenPriv, Tmp);
  CloseHandle(hToken);
end;

function ThiEnumProcess.GetProcessAccount;
var
  sd: PSecurityDescriptor;
  snu: SID_NAME_USE;
  DomainName, UserName: string;
  UserNameSize, DomainNameSize: Cardinal;
  sid: PSid;
begin
  Result := '';
  if GetSecurityInfo(proc, SE_KERNEL_OBJECT, OWNER_SECURITY_INFORMATION, @sid, nil, nil, nil, sd) = ERROR_SUCCESS then
  begin
    UserNameSize := 1024;
    DomainNameSize := 1024;
    SetLength(UserName, UserNameSize);
    SetLength(DomainName, DomainNameSize);
    FillChar(UserName[1], UserNameSize, 0);
    FillChar(DomainName[1], DomainNameSize, 0);         

    if LookupAccountSid(nil, sid, @UserName[1], UserNameSize, @DomainName[1], DomainNameSize, snu) then
      Result := Trim(DomainName);

    if OSVersion.dwMajorVersion < 6 then
      if Result = 'BUILTIN' then
        Result := 'SYSTEM'
      else
        Result := Trim(UserName)  
    else
      Result := Trim(UserName);
    
    LocalFree(NativeInt(sd));
  end;
end;

function EnumWindowsProc(Wnd: HWND; ProcessID: DWord): Boolean; stdcall;
var
  PID: DWord;
begin
  GetWindowThreadProcessId(Wnd, @PID);
  if ProcessID = PID then
    PostMessage(Wnd, WM_CLOSE, 0, 0);
  Result := True;
end;

function KillProcess(ProcessID: DWord): Boolean;
var
  proc: THandle;
begin
  proc := OpenProcess(PROCESS_TERMINATE, True, ProcessID);
  Result := TerminateProcess(proc, 1);
  CloseHandle(proc);
end;

function TerminateApp(ProcessID: DWord; Timeout: DWord): Integer;
var
  ProcessHandle: THandle;
begin
  Result := -1;
  if ProcessID = GetCurrentProcessId then exit;
  ProcessHandle := OpenProcess(SYNCHRONIZE or PROCESS_TERMINATE, True, ProcessID);
  if ProcessHandle <> 0 then
  begin
    EnumWindows(@EnumWindowsProc, Lparam(ProcessID));
    if WaitForSingleObject(ProcessHandle, Timeout) = WAIT_OBJECT_0 then
      Result := 0;
  end;
  CloseHandle(ProcessHandle);

  if Result <> 0 then
    if KillProcess(ProcessHandle) then Result := 1;
end;

procedure ThiEnumProcess._work_doTerminateApp;
begin
  SetDebugPrivilege(FDebugPrivilege);
  _hi_onEvent(_event_onTerminateApp, TerminateApp(FProcessID, _prop_TimeOut)); 
end;

procedure ThiEnumProcess._work_doKill;
begin
  SetDebugPrivilege(FDebugPrivilege);
  KillProcess({procEntry.th32ProcessID} FProcessID);
end;

//------------------------------------------------------------------------------

function GetOwnedProcessID(hProcess: THandle): DWord;
var
  Info: PROCESS_BASIC_INFORMATION;
begin
  Result := 0;
  if ZwQueryInformationProcess(hProcess, 0, @Info, SizeOf(Info), nil) = NO_ERROR then
    Result := Info.InheritedFromUniqueProcessId;
end;

var
  DevicePathList: PKOLStrList;
  DevListCS: TRTLCriticalSection;
  
procedure RefreshDeviceList;
const
  BufLen = 256;
var
  Buf: string;
  Len: Integer;
  Letter: array[0..2] of Char;
  DriveMask: DWord;
begin
//  EnterCriticalSection(DevListCS);
    if DevicePathList <> nil then
    begin
      DevicePathList.Clear;
      
      SetLength(Buf, 256);
      Letter[0] := 'A';
      Letter[1] := ':';
      Letter[2] := #0;
      
      // Маска существующих дисков
      DriveMask := GetLogicalDrives;
      // Перебор битов маски и сопоставление диска с буквой
      while DriveMask <> 0 do
      begin
        if (DriveMask and 1) <> 0 then
        begin
          // Получение Device path для указанной буквы диска
          Len := QueryDosDevice(@Letter[0], Pointer(Buf), BufLen);
          if Len <> 0 then
          begin
            //DevicePathList.Add(LowerCase(Copy(Buf, 1, Len-2)) + '\='+Letter);
            DevicePathList.Add(Copy(Buf, 1, Len-2) + '\=' + Letter);
          end;
        end;
        Inc(Letter[0]);
        DriveMask := DriveMask shr 1;
      end;
      DevicePathList.Add('\Device\Mup\=\'); // Сетевые пути SMB идут под этим устройством
    end;
//  LeaveCriticalSection(DevListCS);
end;

function GetPathByDevice(DevicePath: string): string;
  
  function SearchInList: string;
  var
    Item: string;
    I, P, L: Integer;
  begin
    L := Length(DevicePath);
    for I := 0 to DevicePathList.Count - 1 do
    begin
      Item := DevicePathList.Items[I];
      P := Pos('=', Item) - 1; // В P - длина пути из списка (перед "=")
      if {(P < 0) or} P > L then Continue;
      
      //if StrLComp(PAnsiChar(Item), PAnsiChar(DevicePath), P) then
      if CompareMem(Pointer(Item), Pointer(DevicePath), P) then
      begin
        Result := Copy(Item, P+2, Length(Item){-(P+2)}) + Copy(DevicePath, P, Length(DevicePath));
        break;
      end;
    end;
  end;
  
begin
  if DevicePath = '' then exit;
  
  EnterCriticalSection(DevListCS);
    if DevicePathList <> nil then
    begin
      // Ищем в списке
      Result := SearchInList;
      if Result = '' then
      begin
        // Если не найдено - обновляем список устройств и ищем ещё раз
        RefreshDeviceList;
        Result := SearchInList;
      end;
    end;
  LeaveCriticalSection(DevListCS);
end;

function GetProcessFileNameByHandle(hProcess: THandle): string;
var
  Sz: DWord;
begin
  Sz := MAX_PATH;
  SetLength(Result, Sz);
  if Assigned(QueryFullProcessImageName) then
  begin
    if not QueryFullProcessImageName(hProcess, 0, Pointer(Result), @Sz) then Sz := 0;
  end
  else
  begin
    Sz := GetModuleFilenameEx(hProcess, 0, Pointer(Result), Sz); // Не даст результата для 64-битного процесса из 32-битного
    if (Sz = 0) and Assigned(GetProcessImageFileName) then
    begin
      // Выдаёт пути в формате \Device\HarddiskVolume1\WINDOWS\system32\winlogon.exe
      Sz := GetProcessImageFileName(hProcess, Pointer(Result), Sz);
      // Преобразовать в более понятный
      Result := GetPathByDevice(Copy(Result, 1, Sz));
      Sz := Length(Result);
    end;
  end;
  
  if Sz <> DWord(Length(Result)) then SetLength(Result, Sz);
end;

function GetProcessFileNameByID(ID: Integer): string;
var
  HProc: THandle;
begin
  Result := '';
  HProc := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, ID);
  if HProc <> 0 then
  begin
    Result := GetProcessFileNameByHandle(HProc);
    CloseHandle(HProc);
  end;
end;


procedure ThiEnumProcess.Enum(CallBack: TCB);
var
  hSnapshot: THandle;
  R: BOOL;  
  procEnt: TProcessEntry32;
begin
  hSnapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if hSnapshot = INVALID_HANDLE_VALUE then Exit;

  FillChar(procEnt, SizeOf(TProcessEntry32), 0);
  procEnt.dwSize := SizeOf(TProcessEntry32);
  
  R := Process32First(hSnapshot, procEnt);
  while R do
  begin
    if procEnt.th32ProcessID <> 0 then // PID = 0 - "Бездействие системы"
    begin
      FProcessID := procEnt.th32ProcessID;
      FParentProcID := procEnt.th32ParentProcessID;
      
      FProcName := string(procEnt.szExeFile);
      
      FProcFullName := GetProcessFileNameByID(procEnt.th32ProcessID);
      if FProcFullName = '' then FProcFullName := FProcName;
      
      if not CallBack() then Break;
    end;
    R := Process32Next(hSnapshot, procEnt);
  end;
  CloseHandle(hSnapshot);
end;

//------------------------------------------------------------------------------


function ThiEnumProcess.EnumAll: Boolean;
begin
  _hi_OnEvent(_event_onProcess, FProcFullName);
  Result := True;
end;

procedure ThiEnumProcess._work_doEnum;
begin
  Enum(EnumAll);
  
  FProcessID := 0;
  FParentProcID := 0;
  FProcName := '';
  FProcFullName := '';
end;

procedure ThiEnumProcess._work_doFindID;
var
  PID: Integer;
  HProc: THandle;
begin
  PID := ReadInteger(_Data, _data_ID, 0);
  HProc := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, PID);
  if HProc <> 0 then
  begin
    FProcessID := PID;
    FParentProcID := GetOwnedProcessID(HProc);
    FProcFullName := GetProcessFileNameByHandle(HProc);
    
    FProcName := ExtractFileName(FProcFullName);
    if FProcName = '' then FProcName := 'PID'+Int2Str(PID); // TODO: временно, найти гарантированный способ получения без Process32First()
    
    CloseHandle(HProc);
    _hi_CreateEvent(_Data, @_event_onFind);
  end
  else
    _hi_CreateEvent(_Data, @_event_onNotFind);
end;

function ThiEnumProcess.FindName: Boolean;
begin
  Result := (AnsiCompareStr(FSearchName, FProcName) <> 0);
  if not Result then FFound := True;
end;

procedure ThiEnumProcess._work_doFindName;
begin
  FSearchName := ReadString(_Data, _data_Name, _prop_Name);
  FFound := False;
  Enum(FindName);
  if FFound then
    _hi_CreateEvent(_Data, @_event_onFind)
  else
    _hi_CreateEvent(_Data, @_event_onNotFind);
end;

//-------------------------------------------------------------------------------

procedure ThiEnumProcess._work_doGetMemoryInfo;
var
  HProc: THandle;
  PMC: TProcessMemoryCounters;
begin
  SetDebugPrivilege(FDebugPrivilege);
  HProc := OpenProcess(PROCESS_QUERY_INFORMATION, False, FProcessID);
  if GetProcessMemoryInfo(HProc, @PMC, SizeOf(TProcessMemoryCounters)) then
    _hi_CreateEvent(_Data, @_event_onGetMemoryInfo, {$ifdef F_P}Integer{$endif}(PMC.WorkingSetSize));
  CloseHandle(HProc);
end;

procedure ThiEnumProcess._work_doGetProcessAccount;
var
  HProc: THandle;
begin
  SetDebugPrivilege(FDebugPrivilege);
  HProc := OpenProcess(PROCESS_ALL_ACCESS, False, FProcessID);
    _hi_CreateEvent(_Data, @_event_onGetProcessAccount, GetProcessAccount(HProc));
  CloseHandle(HProc);
end;

//-------------------------------------------------------------------------------

procedure ThiEnumProcess._work_doGetPriority;
var
  HProc: THandle;
  pc: Cardinal;
  Priority: Integer;  
begin
  SetDebugPrivilege(FDebugPrivilege);
  HProc := OpenProcess(PROCESS_QUERY_INFORMATION, False, FProcessID);
  pc := Integer(GetPriorityClass(HProc));
  CloseHandle(HProc);
  case pc of
    NORMAL_PRIORITY_CLASS       : Priority := 0;
    IDLE_PRIORITY_CLASS         : Priority := 1;
    HIGH_PRIORITY_CLASS         : Priority := 2;
    REALTIME_PRIORITY_CLASS     : Priority := 3;
    BELOW_NORMAL_PRIORITY_CLASS : Priority := 4;
    ABOVE_NORMAL_PRIORITY_CLASS : Priority := 5;
    else Priority := 0;
  end;
  _hi_CreateEvent(_Data, @_event_onGetPriority, Priority);  
end;

procedure ThiEnumProcess._work_doGetProc;
var
  HProc: THandle;
  lpProcessAffinityMask, lpSystemAffinityMask: DWord;
begin
  SetDebugPrivilege(FDebugPrivilege);
  HProc := OpenProcess(PROCESS_QUERY_INFORMATION, False, FProcessID);
  lpProcessAffinityMask := 0;
  if HProc <> 0 then
  begin
    GetProcessAffinityMask(HProc, lpProcessAffinityMask, lpSystemAffinityMask);
    CloseHandle(HProc);
  end;
  _hi_CreateEvent(_Data, @_event_onGetProc, Integer(lpProcessAffinityMask));
end;

procedure ThiEnumProcess._work_doGetProcBoost;
var
  HProc: THandle;
  DisablePriorityBoost: Bool;
begin
  SetDebugPrivilege(FDebugPrivilege);
  HProc := OpenProcess(PROCESS_QUERY_INFORMATION, False, FProcessID);
  GetProcessPriorityBoost(HProc, DisablePriorityBoost);
  if DisablePriorityBoost then
    _hi_CreateEvent(_Data, @_event_onGetProcBoost, 0)
  else
    _hi_CreateEvent(_Data, @_event_onGetProcBoost, 1);
  CloseHandle(HProc);
end;

procedure ThiEnumProcess._work_doGetCmdLine;
begin
  SetDebugPrivilege(FDebugPrivilege);
  _hi_onEvent(_event_onGetCmdLine, GetProcessCmdLine(FProcessID));
end;

//-------------------------------------------------------------------------------

procedure ThiEnumProcess._work_doSetPriority;
var
  HProc: THandle;
  pc: Cardinal;
begin
  SetDebugPrivilege(FDebugPrivilege);
  HProc := OpenProcess(PROCESS_SET_INFORMATION, False, FProcessID);
  case ReadInteger(_Data, _data_PriorityClass, 0) of
    0: pc := NORMAL_PRIORITY_CLASS;
    1: pc := IDLE_PRIORITY_CLASS;
    2: pc := HIGH_PRIORITY_CLASS;
    3: pc := REALTIME_PRIORITY_CLASS;
    4: pc := BELOW_NORMAL_PRIORITY_CLASS;
    5: pc := ABOVE_NORMAL_PRIORITY_CLASS;
    else pc := NORMAL_PRIORITY_CLASS;
  end;
  SetPriorityClass(HProc, pc);
  CloseHandle(HProc);
end;

procedure ThiEnumProcess._work_doSetProc;
var
  HProc: THandle;
  pc: Byte;
begin
  pc := ReadInteger(_Data, _data_AffinityMask, 0);
  if pc = 0 then Exit;
  SetDebugPrivilege(FDebugPrivilege);
  HProc := OpenProcess(PROCESS_SET_INFORMATION, False, FProcessID);
  SetProcessAffinityMask(HProc, pc);
  CloseHandle(HProc);
end;

procedure ThiEnumProcess._work_doSetProcBoost;
var
  HProc: THandle;
  DisablePriorityBoost:bool;
begin
  DisablePriorityBoost := not Boolean(ReadInteger(_Data,_data_PriorityBoost,0));
  SetDebugPrivilege(FDebugPrivilege);
  HProc := OpenProcess(PROCESS_SET_INFORMATION, False, FProcessID);
  SetProcessPriorityBoost(HProc, DisablePriorityBoost);
  CloseHandle(HProc);
end;

//-------------------------------------------------------------------------------

procedure ThiEnumProcess._var_CurrentID;
begin
  dtInteger(_Data, FProcessID);
end;

procedure ThiEnumProcess._var_CurrParentID;
begin
  dtInteger(_Data, FParentProcID);
end;

procedure ThiEnumProcess._var_FileName;
begin
  dtString(_Data, FProcName);
end;

procedure ThiEnumProcess._var_CPUCount;
var
  lpSystemInfo: _SYSTEM_INFO;
begin
  GetSystemInfo(lpSystemInfo);
  dtInteger(_Data, lpSystemInfo.dwNumberOfProcessors);
end;

procedure ThiEnumProcess._var_FullPath;
begin
  dtString(_Data, FProcFullName);
end;

procedure ThiEnumProcess._var_MajorVersion;
begin
  dtInteger(_Data, OSVersion.dwMajorVersion);
end;

procedure ThiEnumProcess._var_MinorVersion;
begin
  dtInteger(_Data, OSVersion.dwMinorVersion);
end;   

procedure ThiEnumProcess._work_doDebugPrivilege;
begin
  FDebugPrivilege := ReadBool(_Data);
end;

initialization
  InitLibraries;
  DevicePathList := NewKOLStrList;
  InitializeCriticalSection(DevListCS);
  
finalization
  EnterCriticalSection(DevListCS);
    Free_And_Nil(DevicePathList);
  DeleteCriticalSection(DevListCS);

end.