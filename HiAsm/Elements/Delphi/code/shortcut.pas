unit shortcut;

interface

uses
  Windows, KOL;

procedure CreateLink(const Name, LinkName, wd, d, args, icon: pchar);
procedure ReadLink(const LinkName: string; var Name, wd, d, args, IcoPath: string; var IcoIND: integer);

implementation

const
 SID_IShellLinkA = '{000214EE-0000-0000-C000-000000000046}';
 SID_IShellLinkW = '{000214F9-0000-0000-C000-000000000046}';
 
 CLSID_IShellLink: TGUID = ( D1:$00021401; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
 
 {$ifdef UNICODE}
 IID_IShellLink: TGUID = (D1:$000214F9; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46)); {IID_IShellLinkA}
 {$else}
 IID_IShellLink: TGUID = (D1:$000214EE; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46)); {IID_IShellLinkW}
 {$endif}
 
type
  
  _SHITEMID = record
    cb: Word;
    abID: array[0..0] of Byte;
  end;
 TSHItemID = _SHITEMID;
 SHITEMID = _SHITEMID;
 PItemIDList = ^TItemIDList;
 _ITEMIDLIST = record
  mkid: TSHItemID;
 end;
 TItemIDList = _ITEMIDLIST;

  IShellLinkA = interface(IUnknown) { sl }
    [SID_IShellLinkA]
    function GetPath(pszFile: PAnsiChar; cchMaxPath: Integer;
      var pfd: TWin32FindDataA; fFlags: DWORD): HResult; stdcall;
    function GetIDList(var ppidl: PItemIDList): HResult; stdcall;
    function SetIDList(pidl: PItemIDList): HResult; stdcall;
    function GetDescription(pszName: PAnsiChar; cchMaxName: Integer): HResult; stdcall;
    function SetDescription(pszName: PAnsiChar): HResult; stdcall;
    function GetWorkingDirectory(pszDir: PAnsiChar; cchMaxPath: Integer): HResult; stdcall;
    function SetWorkingDirectory(pszDir: PAnsiChar): HResult; stdcall;
    function GetArguments(pszArgs: PAnsiChar; cchMaxPath: Integer): HResult; stdcall;
    function SetArguments(pszArgs: PAnsiChar): HResult; stdcall;
    function GetHotkey(var pwHotkey: Word): HResult; stdcall;
    function SetHotkey(wHotkey: Word): HResult; stdcall;
    function GetShowCmd(out piShowCmd: Integer): HResult; stdcall;
    function SetShowCmd(iShowCmd: Integer): HResult; stdcall;
    function GetIconLocation(pszIconPath: PAnsiChar; cchIconPath: Integer;
      out piIcon: Integer): HResult; stdcall;
    function SetIconLocation(pszIconPath: PAnsiChar; iIcon: Integer): HResult; stdcall;
    function SetRelativePath(pszPathRel: PAnsiChar; dwReserved: DWORD): HResult; stdcall;
    function Resolve(Wnd: HWND; fFlags: DWORD): HResult; stdcall;
    function SetPath(pszFile: PAnsiChar): HResult; stdcall;
  end;
  
  IShellLinkW = interface(IUnknown) { sl }
    [SID_IShellLinkW]
    function GetPath(pszFile: PWideChar; cchMaxPath: Integer;
      var pfd: TWin32FindDataW; fFlags: DWORD): HResult; stdcall;
    function GetIDList(var ppidl: PItemIDList): HResult; stdcall;
    function SetIDList(pidl: PItemIDList): HResult; stdcall;
    function GetDescription(pszName: PWideChar; cchMaxName: Integer): HResult; stdcall;
    function SetDescription(pszName: PWideChar): HResult; stdcall;
    function GetWorkingDirectory(pszDir: PWideChar; cchMaxPath: Integer): HResult; stdcall;
    function SetWorkingDirectory(pszDir: PWideChar): HResult; stdcall;
    function GetArguments(pszArgs: PWideChar; cchMaxPath: Integer): HResult; stdcall;
    function SetArguments(pszArgs: PWideChar): HResult; stdcall;
    function GetHotkey(var pwHotkey: Word): HResult; stdcall;
    function SetHotkey(wHotkey: Word): HResult; stdcall;
    function GetShowCmd(out piShowCmd: Integer): HResult; stdcall;
    function SetShowCmd(iShowCmd: Integer): HResult; stdcall;
    function GetIconLocation(pszIconPath: PWideChar; cchIconPath: Integer;
      out piIcon: Integer): HResult; stdcall;
    function SetIconLocation(pszIconPath: PWideChar; iIcon: Integer): HResult; stdcall;
    function SetRelativePath(pszPathRel: PWideChar; dwReserved: DWORD): HResult; stdcall;
    function Resolve(Wnd: HWND; fFlags: DWORD): HResult; stdcall;
    function SetPath(pszFile: PWideChar): HResult; stdcall;
  end;

  {$ifdef UNICODE}
    IShellLink = IShellLinkW;
  {$else}
    IShellLink = IShellLinkA;
  {$endif}

type
 IPersist = interface(IUnknown)
  ['{0000010C-0000-0000-C000-000000000046}']
  function GetClassID(out classID: TGUID): HResult; stdcall;
 end;

 IPersistFile = interface(IPersist)
  ['{0000010B-0000-0000-C000-000000000046}']
  function IsDirty: HResult; stdcall;
  function Load(pszFileName: PWideChar; dwMode: Longint): HResult;
   stdcall;
  function Save(pszFileName: PWideChar; fRemember: BOOL): HResult;
   stdcall;
  function SaveCompleted(pszFileName: PWideChar): HResult;
   stdcall;
  function GetCurFile(out pszFileName: PWideChar): HResult;
   stdcall;
 end;

procedure CoUninitialize; stdcall; external 'ole32.dll' name 'CoUninitialize';
function CoInitialize(pvReserved: Pointer): HResult; stdcall; external 'ole32.dll' name 'CoInitialize';
function CoCreateInstance(const clsid: TGUID; unkOuter: IUnknown; dwClsContext: Longint; const iid: TGUID; out pv): HResult; stdcall; external 'ole32.dll' name 'CoCreateInstance';

procedure CreateLink(const Name,LinkName,wd,d,args,icon: pchar);
var
 Obj: IUnknown;
begin
 Coinitialize(nil);
 if CoCreateInstance(CLSID_IShellLink, nil, 1 or 4, IID_IShellLink, Obj) = 0 then
  begin
   (Obj as IShellLink).SetPath(Name);
   (Obj as IShellLink).SetWorkingDirectory(wd);
   (Obj as IShellLink).SetDescription(d);
   (Obj as IShellLink).SetArguments(args);
   (Obj as IShellLink).SetIconLocation(Icon, 0);
   (Obj as IPersistFile).Save(PWideChar(WideString(LinkName)), FALSE);
  end;
 CoUninitialize;
end;

procedure ReadLink(const LinkName: string; var Name, wd, d, Args, IcoPath: string; var IcoIND: integer);
var
  buffer : array[0..255] of char;
  Obj: IUnknown;
  pfd: TWin32FindData;
begin
 Coinitialize(nil);
 if CoCreateInstance(CLSID_IShellLink, nil, 1 or 4, IID_IShellLink, Obj) = 0 then
  begin
   (Obj as IPersistFile).Load(PWideChar(WideString(LinkName)),0);
   (Obj as IShellLink).GetPath(buffer, 256, pfd, 1 or 4);
   Name := buffer;
   (Obj as IShellLink).GetArguments(buffer, 256);
   args := buffer;
   (Obj as IShellLink).GetDescription(buffer, 256);
   d := buffer;
   (Obj as IShellLink).GetWorkingDirectory(buffer, 256);
   wd := buffer;
   (Obj as IShellLink).GetIconLocation(buffer, 256, IcoIND);
   IcoPath := buffer;
  end;
 CoUninitialize;
end;

end.