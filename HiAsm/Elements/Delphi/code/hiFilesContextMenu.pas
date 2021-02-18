unit HiFilesContextMenu;

interface

uses Messages, Windows, Kol, Share, Debug, ActiveX;

const
  CSIDL_DRIVES             = $00000011;

const
  CMIC_MASK_ICON           = $00000010;
  CMIC_MASK_HOTKEY         = $00000020;
  CMIC_MASK_FLAG_NO_UI     = $00000400;
  CMIC_MASK_UNICODE        = $00004000;
  CMIC_MASK_NO_CONSOLE     = $00008000;
  CMIC_MASK_ASYNCOK        = $00100000;
  CMIC_MASK_NOZONECHECKS   = $00800000;
  CMIC_MASK_SHIFT_DOWN     = $10000000;
  CMIC_MASK_CONTROL_DOWN   = $40000000;
  CMIC_MASK_FLAG_LOG_USAGE = $04000000;
  CMIC_MASK_PTINVOKE       = $20000000;

const
{ QueryContextMenu uFlags }

  CMF_NORMAL             = $00000000;
  CMF_DEFAULTONLY        = $00000001;
  CMF_VERBSONLY          = $00000002;
  CMF_EXPLORE            = $00000004;
  CMF_NOVERBS            = $00000008;
  CMF_CANRENAME          = $00000010;
  CMF_NODEFAULT          = $00000020;
  CMF_INCLUDESTATIC      = $00000040;
  CMF_EXTENDEDVERBS      = $00000100; 
  CMF_RESERVED           = $FFFF0000;      { View specific }

const
{ GetCommandString uType }
  GCS_VERBA = 0;
  GCS_HELPTEXTA = 1;
  GCS_VALIDATEA = 2;
  GCS_VERBW = 4;
  GCS_HELPTEXTW = 5;
  GCS_VALIDATEW = 6;
  GCS_UNICODE = 4;
  GCS_VERB = GCS_VERBA;
  GCS_HELPTEXT = GCS_HELPTEXTA;
  GCS_VALIDATE = GCS_VALIDATEA;

 type

  PSTRRet = ^TStrRet;
  {$EXTERNALSYM _STRRET}
  _STRRET = record
     uType: UINT;                               { One of the STRRET_* values }
     case Integer of
       0: (pOleStr: LPWSTR);                    { must be freed by caller of GetDisplayNameOf }
       1: (pStr: LPSTR);                        { NOT USED }
       2: (uOffset: UINT);                      { Offset into SHITEMID (ANSI) }
       3: (cStr: array[0..MAX_PATH-1] of Char); { Buffer to fill in }
    end;
  TStrRet = _STRRET;
  {$EXTERNALSYM STRRET}
  STRRET = _STRRET;

  PSHItemID = ^TSHItemID;
  TSHItemID = packed record
    cb: Word;                         { Size of the ID (including cb itself) }
    abID: array[0..0] of Byte;        { The item ID (variable length) }
  end;

  PItemIDList = ^TItemIDList;
  TItemIDList = record
     mkid: TSHItemID;
  end;

  PCMInvokeCommandInfo = ^TCMInvokeCommandInfo;
  {$EXTERNALSYM _CMINVOKECOMMANDINFO}
  _CMINVOKECOMMANDINFO = record
    cbSize: DWORD;        { must be sizeof(CMINVOKECOMMANDINFO) }
    fMask: DWORD;         { any combination of CMIC_MASK_* }
    hwnd: HWND;           { might be NULL (indicating no owner window) }
    lpVerb: LPCSTR;       { either a string of MAKEINTRESOURCE(idOffset) }
    lpParameters: LPCSTR; { might be NULL (indicating no parameter) }
    lpDirectory: LPCSTR;  { might be NULL (indicating no specific directory) }
    nShow: Integer;       { one of SW_ values for ShowWindow() API }
    dwHotKey: DWORD;
    hIcon: THandle;
  end;

  TCMInvokeCommandInfo = _CMINVOKECOMMANDINFO;
  {$EXTERNALSYM CMINVOKECOMMANDINFO}
  CMINVOKECOMMANDINFO = _CMINVOKECOMMANDINFO;

  PCMInvokeCommandInfoEx = ^TCMInvokeCommandInfoEx;
  {$EXTERNALSYM _CMInvokeCommandInfoEx}
  _CMInvokeCommandInfoEx = record
    cbSize: DWORD;       { must be sizeof(CMINVOKECOMMANDINFOEX) }
    fMask: DWORD;        { any combination of CMIC_MASK_* }
    hwnd: HWND;          { might be NULL (indicating no owner window) }
    lpVerb: LPCSTR;      { either a string or MAKEINTRESOURCE(idOffset) }
    lpParameters: LPCSTR;{ might be NULL (indicating no parameter) }
    lpDirectory: LPCSTR; { might be NULL (indicating no specific directory) }
    nShow: Integer;      { one of SW_ values for ShowWindow() API }
    dwHotKey: DWORD;
    hIcon: THandle;
    lpTitle: LPCSTR;        { For CreateProcess-StartupInfo.lpTitle }
    lpVerbW: LPCWSTR;       { Unicode verb (for those who can use it) }
    lpParametersW: LPCWSTR; { Unicode parameters (for those who can use it) }
    lpDirectoryW: LPCWSTR;  { Unicode directory (for those who can use it) }
    lpTitleW: LPCWSTR;      { Unicode title (for those who can use it) }
    ptInvoke: TPoint;       { Point where it's invoked }
  end;
    TCMInvokeCommandInfoEx = _CMINVOKECOMMANDINFOEX;
    {$EXTERNALSYM CMINVOKECOMMANDINFOEX}
    CMINVOKECOMMANDINFOEX = _CMINVOKECOMMANDINFOEX;


  IEnumIDList = interface(IUnknown)
    ['{000214F2-0000-0000-C000-000000000046}']
    function Next(celt: ULONG; out rgelt: PItemIDList;
      var pceltFetched: ULONG): HResult; stdcall;
    function Skip(celt: ULONG): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out ppenum: IEnumIDList): HResult; stdcall;
  end;

  IShellFolder = interface(IUnknown)
    ['{000214E6-0000-0000-C000-000000000046}']
    function ParseDisplayName(hwndOwner: HWND;
      pbcReserved: Pointer; lpszDisplayName: POLESTR; out pchEaten: ULONG;
      out ppidl: PItemIDList; var dwAttributes: ULONG): HResult; stdcall;
    function EnumObjects(hwndOwner: HWND; grfFlags: DWORD;
      out EnumIDList: IEnumIDList): HResult; stdcall;
    function BindToObject(pidl: PItemIDList; pbcReserved: Pointer;
      const riid: TIID; out ppvOut): HResult; stdcall;
    function BindToStorage(pidl: PItemIDList; pbcReserved: Pointer;
      const riid: TIID; out ppvObj): HResult; stdcall;
    function CompareIDs(lParam: LPARAM;
      pidl1, pidl2: PItemIDList): HResult; stdcall;
    function CreateViewObject(hwndOwner: HWND; const riid: TIID;
      out ppvOut): HResult; stdcall;
    function GetAttributesOf(cidl: UINT; var apidl: PItemIDList;
      var rgfInOut: UINT): HResult; stdcall;
    function GetUIObjectOf(hwndOwner: HWND; cidl: UINT; var apidl: PItemIDList;
      const riid: TIID; prgfInOut: Pointer; out ppvOut): HResult; stdcall;
    function GetDisplayNameOf(pidl: PItemIDList; uFlags: DWORD;
      var lpName: TStrRet): HResult; stdcall;
    function SetNameOf(hwndOwner: HWND; pidl: PItemIDList; lpszName: POLEStr;
      uFlags: DWORD; var ppidlOut: PItemIDList): HResult; stdcall;
  end;

  IContextMenu = interface(IUnknown)
    ['{000214E4-0000-0000-C000-000000000046}']
    function QueryContextMenu(Menu: HMENU;
      indexMenu, idCmdFirst, idCmdLast, uFlags: UINT): HResult; stdcall;
    function InvokeCommand(var lpici: TCMInvokeCommandInfo): HResult; stdcall;
    function GetCommandString(idCmd, uType: UINT; pwReserved: PUINT;
      pszName: LPSTR; cchMax: UINT): HResult; stdcall;
  end;

  IContextMenu2 = interface(IContextMenu)
    ['{000214F4-0000-0000-C000-000000000046}']
    function HandleMenuMsg(uMsg: UINT; WParam, LParam: Integer): HResult; stdcall;
  end;

//------------------------------------------------------------------------------
  THiFilesContextMenu = class(TDebug)
  private
  public
    _data_FileName: THI_Event;
    _event_onCommand: THI_Event;
    procedure _work_doCreateMenu(var _Data:TData; Index:word);
  end;
//------------------------------------------------------------------------------
implementation

const

 IID_IEnumIDList:   TGUID = (D1:$000214F2; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
 IID_IShellFolder:  TGUID = (D1:$000214E6; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
 IID_IContextMenu:  TGUID = (D1:$000214E4; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
 IID_IContextMenu2: TGUID = (D1:$000214F4; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));

function SHGetDesktopFolder(var ppshf: IShellFolder): HResult;
                            stdcall; external 'shell32.dll' name 'SHGetDesktopFolder';

function SHGetMalloc(ppMalloc: IMalloc): HResult;
                     stdcall; external 'shell32.dll' name 'SHGetMalloc';



// ��� ��� ������ ������ ����, ��� �������� ��������
function MenuCallback(Wnd: HWND; Msg: UINT; WParam: WPARAM;
 LParam: LPARAM): LRESULT; stdcall;
var
  ContextMenu2: IContextMenu2;
begin
  case Msg of
    WM_CREATE:
    begin
      ContextMenu2 := IContextMenu2(PCreateStruct(lParam).lpCreateParams);
      SetWindowLongPtr(Wnd, GWLP_USERDATA, NativeInt(ContextMenu2));
      Result := DefWindowProc(Wnd, Msg, wParam, lParam);
    end;
    WM_INITMENUPOPUP:
    begin
      ContextMenu2 := IContextMenu2(GetWindowLongPtr(Wnd, GWLP_USERDATA));
      ContextMenu2.HandleMenuMsg(Msg, wParam, lParam);
      Result := 0;
    end;
    WM_DRAWITEM, WM_MEASUREITEM:
    begin
      ContextMenu2 := IContextMenu2(GetWindowLongPtr(Wnd, GWLP_USERDATA));
      ContextMenu2.HandleMenuMsg(Msg, wParam, lParam);
      Result := 1;
    end;
  else
    Result := DefWindowProc(Wnd, Msg, wParam, lParam);
  end;
end;

// ��� ��� �������� ������ ����, ��� �������� ��������
function CreateMenuCallbackWnd(const ContextMenu: IContextMenu2): HWND;
const
  IcmCallbackWnd = 'ICMCALLBACKWND';
var
  WndClass: TWndClass;
begin
  FillChar(WndClass, SizeOf(WndClass), #0);
  WndClass.lpszClassName := PChar(IcmCallbackWnd);
  WndClass.lpfnWndProc := @MenuCallback;
  WndClass.hInstance := HInstance;
  RegisterClass(WndClass);
  Result := CreateWindow(IcmCallbackWnd, IcmCallbackWnd, WS_POPUPWINDOW, 0,
                         0, 0, 0, 0, 0, HInstance, Pointer(ContextMenu));
end;

procedure GetProperties(Path: String; MousePoint: TPoint; Wnd: HWND; var strCmd: String);
var
  AResult: HRESULT;
  CDir, FName: PWideChar;
  FileName: string;
  DesktopFolder, ShellFolder: IShellFolder;
  pchEaten, Attr: Cardinal;
  pLastId, PathPIDL: PItemIDList;
  MAlloc: IMAlloc;
  ShellContextMenu: HMenu;
  ICMenu: IContextMenu;
  ICMenu2: IContextMenu2;
  PopupMenuResult: BOOL;
  CMD: TCMInvokeCommandInfo;
  ICmd: Integer;
  CallbackWindow: HWND;
  p: Pointer;
  temp: SHORT;
  offset: Word;
  ZVerb: array[0..255] of Char;
begin
  if Path = '' then exit;
  // ��������� �������������
  ShellContextMenu := 0;
  Attr := 0;
  PathPIDL := nil;
  MAlloc := nil;
  CallbackWindow := 0;
TRY
  if CoGetMalloc(MEMCTX_TASK, MAlloc) = S_OK then
  begin
    // �������� ��������� �� ��������� �������� �����
    if SHGetDesktopFolder(DesktopFolder) <> S_OK then exit;
    TRY
      // �������� ����
      CDir := PWideChar(WideString(ExtractFilePath(Path)));
      // �������� ��� �����
      FileName := ExtractFileName(Path);
      // ���� �������� � ������
      if FileName = '' then
      begin
        // �������� ��������� �� ����������
        if DesktopFolder.ParseDisplayName(Wnd, nil, CDir, pchEaten, PathPIDL, Attr) <> S_OK then exit;
        pLastId := PathPIDL;
        while true do
        begin
          offset := pLastId.mkid.cb;
          p := Pointer(pLastId);
          Inc(NativeUInt(p), offset);
          temp := word(p^);
          if temp = 0 then Break;
          pLastId := PItemIDList(p);
        end;
        temp := pLastId.mkid.cb;
        pLastId.mkid.cb := 0;
        if (DesktopFolder.BindToObject(PathPIDL, nil, IID_IShellFolder, Pointer(ShellFolder)) <> S_OK) then exit;
        pLastId.mkid.cb := temp;
        // �������� ��������� �� ����������� ���� �����
        AResult := ShellFolder.GetUIObjectOf(Wnd, 1, pLastId, IID_IContextMenu, nil, Pointer(ICMenu));
      end
      else
      begin
        // �������� ��������� �� ����������"
        if (DesktopFolder.ParseDisplayName(Wnd, nil, CDir, pchEaten, PathPIDL, Attr) <> S_OK) or
           (DesktopFolder.BindToObject(PathPIDL, nil, IID_IShellFolder, Pointer(ShellFolder)) <> S_OK) then exit;
        FName := PWideChar(WideString(FileName));
        // �������� ��������� �� ����
        ShellFolder.ParseDisplayName(Wnd, nil, FName, pchEaten, PathPIDL, Attr);
        // �������� ��������� �� ����������� ���� �����
        AResult := ShellFolder.GetUIObjectOf(Wnd, 1, PathPIDL, IID_IContextMenu, nil, Pointer(ICMenu));
      end;
      // ���� ��������� �� ����. ���� ����, ������ ���:
      if Succeeded(AResult) then
      begin
        ICMenu2 := nil;
        // ������� ����
        ShellContextMenu := CreatePopupMenu;
        // ���������� ��� ����������
        if Succeeded(ICMenu.QueryContextMenu(ShellContextMenu, 0, 1, $7FFF,
                     CMF_EXPLORE or CMF_CANRENAME or CMF_EXTENDEDVERBS)) and
                     Succeeded(ICMenu.QueryInterface(IContextMenu2, ICMenu2)) then
        CallbackWindow := CreateMenuCallbackWnd(ICMenu2);
        TRY
          // ���������� ����
          PopupMenuResult := TrackPopupMenu(ShellContextMenu, TPM_LEFTALIGN or TPM_LEFTBUTTON
                                            or TPM_RIGHTBUTTON or TPM_RETURNCMD,
                                            MousePoint.X, MousePoint.Y, 0, CallbackWindow, nil);
        FINALLY
          ICMenu2 := nil;
        END;
        // ���� ��� ������ ����� ���� ����� ����:
        if PopupMenuResult then
        begin
          // ������ ����� ������ ����� ������ � ICmd
          ICmd := LongInt(PopupMenuResult) - 1;

          // ��������� GetCommandString
          FillChar(ZVerb, SizeOf(ZVerb), #0);
          AResult := ICMenu.GetCommandString(ICmd, {$ifdef UNICODE}GCS_VERBW{$else}GCS_VERBA{$endif}, nil, @ZVerb, Length(ZVerb));
          if AResult <> S_OK then exit;
          strCmd := ZVerb;

          // ��������� ��������� TCMInvokeCommandInfo
          FillChar(CMD, SizeOf(CMD), #0);
          CMD.fMask := CMIC_MASK_ICON; 
          CMD.cbSize := SizeOf(CMD);
          CMD.hWND := Wnd;
          CMD.lpVerb := Pointer(MakeIntResource(ICmd));
          CMD.nShow := SW_SHOWNORMAL;
          // ��������� InvokeCommand � ����������� ����������
          AResult := ICMenu.InvokeCommand(CMD);
          if AResult <> S_OK then exit;
        end;
      end;
    FINALLY
      // ����������� ������� ������� ����� ������ ������ ������
      if PathPIDL <> nil then
        if MAlloc <> nil then
          MAlloc.Free(PathPIDL);

      if ShellContextMenu <> 0 then DestroyMenu(ShellContextMenu);
      if CallbackWindow <> 0 then DestroyWindow(CallbackWindow);
      ICMenu := nil;
      ShellFolder := nil;
      DesktopFolder := nil;
    END;
  end;
FINALLY
  MAlloc := nil;
END;
end;

procedure THiFilesContextMenu._work_doCreateMenu;
var
  fn, cmnd: String;
  pos: TPoint;
  CoInit: HRESULT;  
begin
  fn := ReadString(_data, _data_FileName);
  GetCursorPos(pos);
  CoInit := CoInitializeEx(nil, COINIT_APARTMENTTHREADED);
  GetProperties(fn, pos, Applet.Handle, cmnd);
  if CoInit = S_OK then CoUninitialize;  
  _hi_OnEvent(_event_onCommand, cmnd);
end;

end.