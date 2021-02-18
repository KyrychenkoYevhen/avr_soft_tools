unit ClipboardCopyPaste;

interface

uses Windows, kol, Share, Debug;

function GetDropType(var dt: Cardinal): Boolean;
procedure PutClipboard(PutType: Integer; Arr: PArray);


implementation

uses ShellAPI, ActiveX;

const
  IID_IEnumIDList:   TGUID = (D1:$000214F2; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_IShellFolder:  TGUID = (D1:$000214E6; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));

  DROPEFFECT_NONE   = 0;
  DROPEFFECT_COPY   = 1;
  DROPEFFECT_MOVE   = 2;
  DROPEFFECT_LINK   = 4;
  DROPEFFECT_SCROLL = $80000000;

  { IShellFolder.GetAttributesOf flags }
  SFGAO_FOLDER            = $20000000;       { It's a folder. }
  
  { Clipboard formats }
  CFSTR_SHELLIDLIST           = 'Shell IDList Array';     { CF_IDLIST }
  CFSTR_PREFERREDDROPEFFECT   = 'Preferred DropEffect';




var
  CF_IDLIST, CF_PREFERREDDROPEFFECT: UINT; //see initialization.


type
  TFileName = String;
  POffsets = ^TOffsets;
  TOffsets = array[0..$FFFF] of UINT;
  
  
  TDropFiles = record
    pFiles: DWord; // Offset of the file list from the beginning of this structure, in bytes.
    pt: TPoint;
    fNC: Bool;
    fWide: Bool;
  end;
  PDropFiles = ^TDropFiles;

  { TSHItemID -- Item ID }
  PSHItemID = ^TSHItemID;
  _SHITEMID = record
    cb: Word;                         { Size of the ID (including cb itself) }
    abID: array[0..0] of Byte;        { The item ID (variable length) }
  end;
  TSHItemID = _SHITEMID;
  SHITEMID = _SHITEMID;

  { format of CF_IDLIST }
  PIDA = ^TIDA;
  _IDA = record
    cidl: UINT;                      { number of relative IDList }
    aoffset: array[0..0] of UINT;    { [0]: folder IDList, [1]-[cidl]: item IDList }
  end;
  TIDA = _IDA;
  CIDA = _IDA;

  { TItemIDList -- List if item IDs (combined with 0-terminator) }
  PItemIDList = ^TItemIDList;
  _ITEMIDLIST = record
     mkid: TSHItemID;
   end;
  TItemIDList = _ITEMIDLIST;
  ITEMIDLIST = _ITEMIDLIST;

{ record for returning strings from IShellFolder member functions }
  PSTRRet = ^TStrRet;
  _STRRET = record
     uType: UINT;              { One of the STRRET_* values }
     case Integer of
       0: (pOleStr: LPWSTR);                    { must be freed by caller of GetDisplayNameOf }
       1: (pStr: LPSTR);                        { NOT USED }
       2: (uOffset: UINT);                      { Offset into SHITEMID (ANSI) }
       3: (cStr: array[0..MAX_PATH-1] of Char); { Buffer to fill in }
    end;
  TStrRet = _STRRET;
  STRRET = _STRRET;

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

function SHGetDesktopFolder(var ppshf: IShellFolder): HResult;
                            stdcall; external 'shell32.dll' name 'SHGetDesktopFolder';






function GetSizeOfPidl(pidl: pItemIDList): integer;
var
  i: integer;
begin
  result := SizeOf(Word);
  repeat
    i := pSHItemID(pidl)^.cb;
    inc(result,i);
    inc(NativeInt(pidl),i);
  until i = 0;
end;

function GetSubPidl(Folder: IShellFolder; Sub: TFilename): pItemIDList;
var
  pchEaten, Attr: Cardinal;
  CDir: WideString;
begin
  result := nil;
  try
    CDir := Sub;
    Folder.ParseDisplayName(Applet.Handle, nil, PWideChar(CDir), pchEaten, result, Attr);
  finally
  end;
end;

function ConvertFilesToShellIDList(path: string; files: PKOLStrList): HGlobal;
var
  shf: IShellFolder;
  PathPidl, pidl: pItemIDList;
  Ida: PIDA;
  pOffset: POffsets;
  ptrByte: ^Byte;
  i, PathPidlSize, IdaSize, PreviousPidlSize: integer;
  MAlloc: IMAlloc;
  CDir: WideString;
  pchEaten, Attr: Cardinal;
begin
  result := 0;
  PathPidl := nil;
  MAlloc := nil;
  Attr := 0;
  try
    if CoGetMalloc(MEMCTX_TASK, MAlloc) <> S_OK then Exit;
    if SHGetDesktopFolder(shf) <> S_OK then exit;
    CDir := ExtractFilePath(path);
    if shf.ParseDisplayName(Applet.Handle, nil, PWideChar(CDir), pchEaten, PathPIDL, Attr) <> S_OK then exit;
    if PathPidl = nil then exit;
    IdaSize := (files.count + 2) * sizeof(UINT);
    PathPidlSize := GetSizeOfPidl(PathPidl);
    //Add to IdaSize space for ALL pidls...
    IdaSize := IdaSize + PathPidlSize;
    for i := 0 to files.count-1 do begin
      pidl := GetSubPidl(shf, files.Items[i]);
      IdaSize := IdaSize + GetSizeOfPidl(pidl);
      MAlloc.Free(pidl);
    end;
    //Allocate memory...
    Result := GlobalAlloc(GMEM_SHARE or GMEM_ZEROINIT, IdaSize);
    if Result = 0 then
    begin
      MAlloc.Free(PathPidl);
      Exit;
    end;
    Ida := GlobalLock(Result);
    FillChar(Ida^,IdaSize,0);
    //Fill in offset and pidl data...
    Ida^.cidl := files.count; //cidl = file count
    pOffset := @(Ida^.aoffset);
    pOffset^[0] := (files.count+2) * sizeof(UINT); //offset of Path pidl
    ptrByte := pointer(Ida);
    inc(ptrByte,pOffset^[0]); //ptrByte now points to Path pidl
    move(PathPidl^, ptrByte^, PathPidlSize); //copy path pidl
    MAlloc.Free(PathPidl);
    PreviousPidlSize := PathPidlSize;
    for i := 1 to files.count do
    begin
      pidl := GetSubPidl(shf, files.Items[i-1]);
      pOffset^[i] := pOffset^[i-1] + UINT(PreviousPidlSize); //offset of pidl
      PreviousPidlSize := GetSizeOfPidl(Pidl);
      ptrByte := pointer(Ida);
      inc(ptrByte,pOffset^[i]); //ptrByte now points to current file pidl
      move(Pidl^, ptrByte^, PreviousPidlSize); //copy file pidl
                            //PreviousPidlSize = current pidl size here
      MAlloc.Free(pidl);
    end;
  finally
    GlobalUnLock(Result);
  end;
end;

function GetDropType(var dt: Cardinal): Boolean;
var
  H: THandle;
  pMem: PDWord;
begin
  Result := False;
  dt := 0; // ��� ���������� � ������ ������?
  if not IsClipboardFormatAvailable(CF_PREFERREDDROPEFFECT) then Exit;
  
  H := GetClipboardData(CF_PREFERREDDROPEFFECT);
  if H <> 0 then
  begin
    pMem := GlobalLock(H);
    if pMem <> nil then
    begin
      if pMem^ = DROPEFFECT_MOVE then
        dt := 1
      else
        dt := 0;
      Result := True;
    end;
    GlobalUnlock(H);
  end;
end;

procedure PutClipboard(PutType: Integer; Arr: PArray);
var
  DropFiles: PDropFiles;
  hGlobal: THandle;
  dItem, dIndex: TData;
  S: string;
  iLen, i: Integer;
  FileNames: PKOLStrList;
  {$ifndef UNICODE}CoInit: HRESULT;{$endif}
label
  finish;
begin
  if not OpenClipboard(Applet.Handle) then Exit;
  EmptyClipboard();
  
  {$ifndef UNICODE}CoInit := S_FALSE;{$endif}
  
  if Bool(PutType) then
    PutType := DROPEFFECT_MOVE
  else
    PutType := DROPEFFECT_COPY or DROPEFFECT_LINK;
  
  FileNames := NewKOLStrList;
  iLen := 0; // ����� � �������� ���� ��� ������ � ������������ #0
  
  for i := 0 to Arr._Count - 1 do
  begin
    dtInteger(dIndex, i);
    Arr._Get(dIndex, dItem);
    S := Share.ToString(dItem);
    Inc(iLen, Length(S)+1);
    FileNames.Add(S);
  end;
  
  if iLen = 0 then goto finish;
  
  
  // Shell IDList Array
  // � Unicode ���� �� ����������. �� ������ ����� � ConvertFilesToShellIDList().
  {$ifndef UNICODE}
  CoInit := CoInitializeEx(nil, COINIT_APARTMENTTHREADED);
  hGlobal := ConvertFilesToShellIDList(FileNames.Items[0], FileNames);
  if hGlobal = 0 then goto finish;
  
  SetClipboardData(CF_IDLIST, hGlobal);
  GlobalUnlock(hGlobal);
  {$endif}
  
  // CF_HDROP
  hGlobal := GlobalAlloc(GMEM_SHARE or GMEM_MOVEABLE or GMEM_ZEROINIT, SizeOf(TDropFiles) + (iLen+1)*SizeOf(Char));
  if hGlobal = 0 then goto finish;
  
  DropFiles := GlobalLock(hGlobal);
  DropFiles^.pFiles := SizeOf(TDropFiles); // ������� ��� � ���������� ������� (����� TDropFiles)
  {$ifdef UNICODE}DropFiles^.fWide := True;{$endif} // ��������� �������� ����� � Unicode
  
  
  // ����������� ��� � ���������� �������
  Inc(NativeUInt(DropFiles), SizeOf(TDropFiles));
  for i := 0 to FileNames.Count - 1 do
  begin
    S := FileNames.Items[i];
    StrPCopy(PChar(DropFiles), S);
    Inc(NativeUInt(DropFiles), (Length(S)+1)*SizeOf(Char));
  end;
  // �������������� ����������� #0 ����� ���� ����
  PChar(DropFiles)^ := #0;
  
  SetClipboardData(CF_HDROP, hGlobal);
  GlobalUnlock(hGlobal);

  // Preferred DropEffect
  hGlobal := GlobalAlloc(GMEM_SHARE or GMEM_MOVEABLE or GMEM_ZEROINIT, SizeOf(Integer));
  if hGlobal = 0 then goto finish;
  
  PInteger(GlobalLock(hGlobal))^ := PutType;
  SetClipboardData(CF_PREFERREDDROPEFFECT, hGlobal);
  GlobalUnlock(hGlobal);

finish:
  CloseClipboard;
  FileNames.Free;
  {$ifndef UNICODE}if CoInit = S_OK then CoUninitialize;{$endif}

end;


initialization

  CF_IDLIST := RegisterClipboardFormat(CFSTR_SHELLIDLIST);
  CF_PREFERREDDROPEFFECT := RegisterClipboardFormat(CFSTR_PREFERREDDROPEFFECT);


end.
