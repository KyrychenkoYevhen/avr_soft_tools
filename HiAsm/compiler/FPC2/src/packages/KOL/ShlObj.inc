// ************************************
// ShlObj.pas - parts included in KOL (by NetSpirit)
// ************************************

type

  PSHItemID = ^TSHItemID;
  TSHItemID = record
    cb: Word;                         { Size of the ID (including cb itself) }
    abID: array[0..0] of Byte;        { The item ID (variable length) }
  end;

  PItemIDList = ^TItemIDList;
  TItemIDList = record
     mkid: TSHItemID;
  end;
  
  
  TFNBFFCallBack = function(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer; stdcall;

  PBrowseInfo = ^TBrowseInfo;
  
  TBrowseInfoA = record
    hwndOwner: HWND;
    pidlRoot: PItemIDList;
    pszDisplayName: PAnsiChar;  { Return display name of item selected. }
    lpszTitle: PAnsiChar;      { text to go in the banner over the tree. }
    ulFlags: UINT;           { Flags that control the return stuff }
    lpfn: TFNBFFCallBack;
    lParam: LPARAM;          { extra info that's passed back in callbacks }
    iImage: Integer;         { output var: where to return the Image index. }
  end;
  
  TBrowseInfoW = record
    hwndOwner: HWND;
    pidlRoot: PItemIDList;
    pszDisplayName: PWideChar;  { Return display name of item selected. }
    lpszTitle: PWideChar;      { text to go in the banner over the tree. }
    ulFlags: UINT;           { Flags that control the return stuff }
    lpfn: TFNBFFCallBack;
    lParam: LPARAM;          { extra info that's passed back in callbacks }
    iImage: Integer;         { output var: where to return the Image index. }
  end;
  TBrowseInfo = {$IFDEF UNICODE_CTRLS} TBrowseInfoW {$ELSE} TBrowseInfoA {$ENDIF};
  
function SHBrowseForFolderA(var lpbi: TBrowseInfoA): PItemIDList; stdcall;
  external 'shell32.dll' name 'SHBrowseForFolderA';
function SHBrowseForFolderW(var lpbi: TBrowseInfoW): PItemIDList; stdcall;
  external 'shell32.dll' name 'SHBrowseForFolderW';
function SHGetPathFromIDListA(pidl: PItemIDList; pszPath: PAnsiChar): BOOL; stdcall;
  external 'shell32.dll' name 'SHGetPathFromIDListA';
function SHGetPathFromIDListW(pidl: PItemIDList; pszPath: PWideChar): BOOL; stdcall;
  external 'shell32.dll' name 'SHGetPathFromIDListW';


function SHBrowseForFolder(var lpbi: TBrowseInfo): PItemIDList; stdcall;
  external 'shell32.dll' name {$ifdef UNICODE}'SHBrowseForFolderW'{$else}'SHBrowseForFolderA'{$endif};
function SHGetPathFromIDList(pidl: PItemIDList; pszPath: PChar): BOOL; stdcall;
  external 'shell32.dll' name {$ifdef UNICODE}'SHGetPathFromIDListW'{$else}'SHGetPathFromIDListA'{$endif};


function SHGetSpecialFolderLocation(hwnd: HWND; csidl: integer; var ppidl: PItemIDList): HResult; stdcall;
  external 'shell32.dll' name 'SHGetSpecialFolderLocation';
  
procedure CoTaskMemFree(pv: Pointer); stdcall; external 'ole32.dll'
  name 'CoTaskMemFree'; // From SysUtils.pas (Delphi), ActiveX.pp (FPC)


const
  BIF_RETURNONLYFSDIRS   = $0001;  { For finding a folder to start document searching }
  BIF_DONTGOBELOWDOMAIN  = $0002;  { For starting the Find Computer }
  BIF_STATUSTEXT         = $0004;
  BIF_RETURNFSANCESTORS  = $0008;
  BIF_EDITBOX            = $0010;
  BIF_VALIDATE           = $0020;  { insist on valid result (or CANCEL) }
  BIF_NEWDIALOGSTYLE     = $0040;  { Use the new dialog layout with the ability to resize }
                                   { Caller needs to call OleInitialize() before using this API (c) JVCL }
  BIF_BROWSEFORCOMPUTER  = $1000;  { Browsing for Computers. }
  BIF_BROWSEFORPRINTER   = $2000;  { Browsing for Printers }
  BIF_BROWSEINCLUDEFILES = $4000;  { Browsing for Everything }

  BFFM_INITIALIZED       = 1;
  BFFM_SELCHANGED        = 2;

  BFFM_SETSTATUSTEXT     = WM_USER + 100;
  BFFM_ENABLEOK          = WM_USER + 101;
  BFFM_SETSELECTION      = WM_USER + 102;
  BFFM_SETSELECTIONW     = WM_USER + 103;