// FILEDROP.PAS -- ���������� ����������� ��������� OLE. 
// �����: ���� ������ 
// ���� ��������� ��������: 28/05/97 
// Adapted for HiAsm by Nic. June 2011

unit FileDrop;

interface

uses Windows, ActiveX, kol;
type
  TDragDropInfo = class(TObject)
  private
    FInClientArea: Boolean;
    FDropPoint: TPoint;
    FFileList: PKOLStrList;
  public
    constructor Create (ADropPoint: TPoint; AInClient: Boolean);
    destructor Destroy; override;
    procedure Add(const s: String);
    property InClientArea: Boolean read FInClientArea;
    property DropPoint: TPoint read FDropPoint;
    property Files: PKOLStrList read FFileList;
  end;

  TFileDropEvent = procedure(DDI: TDragDropInfo) of object;
  TDragEvent = procedure(grfKeyState: Longint; pt: TPoint) of object;
  TDragLeaveEvent = procedure() of object;
  TDragType = (dtNone, dtCopy, dtMove, dtLink, dtScroll);
  TDragTypes = set of TDragType;

  { TFileDropTarget �����, ��� ��������� ���������� ����� }
  TFileDropTarget = class(TInterfacedObject, IDropTarget)
  private
    FHandle: HWND;
    FOnFilesDropped: TFileDropEvent;
    FOnDragEnter: TDragEvent;
    FOnDragOver: TDragEvent;
    FOnDragLeave: TDragLeaveEvent;
    FDragTypes : TDragTypes;
    function DragType(): Longint;
  public
    constructor Create(Handle: HWND);
    destructor Destroy; override;
    { �� IDropTarget }
    {$ifdef FPC_NEW}
    function DragEnter(const dataObj: IDataObject; grfKeyState: DWORD; pt: TPoint; var dwEffect: DWORD) : HResult; stdcall;
    function DragOver(grfKeyState: DWORD; pt: TPoint; var dwEffect: DWORD): HResult; stdcall;
    function Drop(const dataObj: IDataObject; grfKeyState: DWORD; pt: TPoint; var dwEffect: DWORD): HResult; stdcall;
    {$else}
    function DragEnter(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint; var dwEffect: Longint) : HResult; stdcall;
    function DragOver(grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; stdcall;
    function Drop(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; stdcall;
    {$endif}
    function DragLeave: HResult; stdcall;
    property OnFilesDropped: TFileDropEvent read FOnFilesDropped write FOnFilesDropped;
    property OnDragEnter: TDragEvent read FOnDragEnter write FOnDragEnter;
    property OnDragOver: TDragEvent read FOnDragOver write FOnDragOver;
    property OnDragLeave: TDragLeaveEvent read FOnDragLeave write FOnDragLeave;
    property Dragtypes: TDragTypes read FDragTypes write FDragTypes;
  end;

implementation

uses ShellAPI;

{ TDragDropInfo }

constructor TDragDropInfo.Create(ADropPoint : TPoint; AInClient : Boolean);
begin
  inherited Create;
  FFileList := NewKOLStrList;
  FDropPoint := ADropPoint;
  FInClientArea := AInClient;
end;

destructor TDragDropInfo.Destroy;
begin
  FFileList.Free;
  inherited Destroy;
end;

procedure TDragDropInfo.Add(const s : String);
begin
  Files.Add(s);
end;

{ TFileDropTarget }

constructor TFileDropTarget.Create(Handle: HWND);
begin
  inherited Create;
  _AddRef;
  FHandle := Handle;
  ActiveX.CoLockObjectExternal(Self, true, false);
  ActiveX.RegisterDragDrop(FHandle, Self);
end;

{ Destroy ������� ���������� � ������� � ��������� ����� � ��� }
destructor TFileDropTarget.Destroy;
var
  WorkHandle: HWND;
begin
  { ���� �������� FHandle �� ����� 0, ������, ����� � ����� ��� ��� ����������. 
    �������� �������� �� ��, ��� FHandle ���������� ������ ����� ��������� 0, 
    ������ ��� CoLockObjectExternal � RevokeDragDrop �������� Release,
    ���, � ���� �������, ����� �������� � ������ Free � ������������ ���������.
    ����������, ��� ���� �������� �� ������ �������. ���� ������ �����
    ���������� �� ����, ��� ������� ������ ������ �� 0, ����� ���������� ����������. }
  if (FHandle <> 0) then begin
    WorkHandle := FHandle;
    FHandle := 0;
    ActiveX.CoLockObjectExternal(Self, false, true);
    ActiveX.RevokeDragDrop(WorkHandle);
  end;
  inherited Destroy;
end;

function TFileDropTarget.DragType: Longint;
begin
  result := DROPEFFECT_NONE;
  if (dtCopy in FDragTypes) then result := DROPEFFECT_COPY;
  if (dtMove in FDragTypes) then result := DROPEFFECT_MOVE;
  if (dtLink in FDragTypes) then result := DROPEFFECT_LINK;
  if (dtScroll in FDragTypes) then result := DROPEFFECT_SCROLL;
end;

{$ifdef FPC_NEW}
function TFileDropTarget.DragEnter(const dataObj: IDataObject; grfKeyState: DWORD; pt: TPoint; var dwEffect: DWORD): HResult; stdcall;
{$else}
function TFileDropTarget.DragEnter(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; stdcall;
{$endif}
begin
  { ���� ������ ����������, �������� ��� }
  if (Assigned(FOnDragEnter)) then FOnDragEnter(grfKeyState, pt);
  dwEffect := DragType;
  Result := S_OK;
end;

{$ifdef FPC_NEW}
function TFileDropTarget.DragOver(grfKeyState: DWORD; pt: TPoint; var dwEffect: DWORD): HResult; stdcall;
{$else}
function TFileDropTarget.DragOver(grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; stdcall;
{$endif}
begin
  { ���� ������ ����������, �������� ��� }
  if (Assigned(FOnDragOver)) then FOnDragOver(grfKeyState, pt);
  dwEffect := DragType;
  Result := S_OK;
end;

{ ��������� ���������� ������ }
{$ifdef FPC_NEW}
function TFileDropTarget.Drop(const dataObj: IDataObject; grfKeyState: DWORD; pt: TPoint; var dwEffect: DWORD): HResult; stdcall;
{$else}
function TFileDropTarget.Drop(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; stdcall;
{$endif}
var
  Medium: TSTGMedium;
  Format: TFormatETC;
  NumFiles: Integer;
  i: Integer;
  rslt: Integer;
  DropInfo: TDragDropInfo;
  szFilename: array[0..MAX_PATH] of char;
  InClient: Boolean;
  DropPoint: TPoint;
begin
  dataObj._AddRef;
  { �������� ������. ��������� TFormatETC �������� dataObj.GetData, 
    ��� �������� ������ � � ����� ������� ��� ������ ��������� 
    (��� ���������� ���������� � ��������� TSTGMedium) }
  Format.cfFormat := CF_HDROP;
  Format.ptd := nil;
  Format.dwAspect := DVASPECT_CONTENT;
  Format.lindex := -1;
  Format.tymed := TYMED_HGLOBAL;
  { ������� ������ � ��������� Medium }
  rslt := dataObj.GetData(Format, Medium);
  { ���� ��� ������ �������, ����� ���������, ��� ��� �������� ��������� �������������� FMDD }
  if (rslt = S_OK) then begin
    { �������� ���������� ������ � ������ �������� }
    NumFiles := DragQueryFile(Medium.hGlobal, $FFFFFFFF, nil, 0);
    InClient := DragQueryPoint(Medium.hGlobal, {$ifdef FPC_NEW}@{$endif}DropPoint);
    { ������� ������ TDragDropInfo }
    DropInfo := TDragDropInfo.Create(DropPoint, InClient);
    { ������� ��� ����� � ������ }
    for i := 0 to NumFiles - 1 do begin
      DragQueryFile(Medium.hGlobal, i, szFilename, sizeof(szFilename));
      DropInfo.Add(szFilename);
    end;
    { ���� ������ ����������, �������� ��� }
    if (Assigned(FOnFilesDropped)) then FOnFilesDropped(DropInfo);
    DropInfo.Free;
  end;
  if (Medium.{$ifdef FPC_NEW}PUnkForRelease{$else}unkForRelease{$endif} = nil) then ReleaseStgMedium(Medium);
  dataObj._Release;
  dwEffect := DragType;
  result := S_OK;
end;

function TFileDropTarget.DragLeave: HResult; stdcall;
begin
  { ���� ������ ����������, �������� ��� }
  if (Assigned(FOnDragLeave)) then FOnDragLeave;
  Result := S_OK;
end;

initialization
  OleInitialize(nil);

finalization
  OleUninitialize;

end.
