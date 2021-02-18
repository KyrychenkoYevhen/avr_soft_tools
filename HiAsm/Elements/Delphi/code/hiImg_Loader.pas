unit HiImg_Loader; { ��������� �������� Img_Loader}

interface

uses Windows,Messages,Share,Debug,ActiveX{$ifdef FPC}, ComObj{$else}, KOLComObj{$endif},KOL;

const
   IMGCHG_SIZE         = $0001;
   IMGCHG_VIEW         = $0002;
   IMGCHG_COMPLETE     = $0004;
   IMGCHG_ANIMATE      = $0008;
   IMGCHG_MASK         = $000F;

   IMGLOAD_NOTLOADED   = $00100000;
   IMGLOAD_LOADING     = $00200000;
   IMGLOAD_STOPPED     = $00400000;
   IMGLOAD_ERROR       = $00800000;
   IMGLOAD_COMPLETE    = $01000000;
   IMGLOAD_MASK        = $01F00000;

   IMGBITS_NONE        = $02000000;
   IMGBITS_PARTIAL     = $04000000;
   IMGBITS_TOTAL       = $08000000;
   IMGBITS_MASK        = $0E000000;

   IMGANIM_ANIMATED    = $10000000;
   IMGANIM_MASK        = $10000000;

   IMGTRANS_OPAQUE     = $20000000;
   IMGTRANS_MASK       = $20000000;

   DWN_COLORMODE       = $0000003F;
   DWN_DOWNLOADONLY    = $00000040;
   DWN_FORCEDITHER     = $00000080;
   DWN_RAWIMAGE        = $00000100;

type
   IImgCtx = interface(IUnknown)
      ['{3050f3d7-98b5-11cf-bb82-00aa00bdce0b}']
      // Initialization/Download methods
      function Load(pszUrl:PWChar; dwFlags:DWORD): HResult; stdcall;
      function SelectChanges(ulChgOn:DWORD; ulChgOff:DWORD; fSignal:DWORD): HResult; stdcall;
      function SetCallback(pCallback:pointer; pUserData:pointer): HResult; stdcall;
      function Disconnect: HResult; stdcall;

      // Query methods
      function GetUpdateRects(prc:PRect; var prcImg:TRect; var pcrc:integer): HResult; stdcall;
      function GetStateInfo(var pulState:DWORD; var pSize:TSize; fClearChanges:DWORD): HResult; stdcall;
      function GetPalette(var phpal:HPalette): HResult; stdcall;

      // Rendering methods
      function Draw(_hdc:HDC; var prcBounds:TRect): HResult; stdcall;
      function Tile(_hdc:HDC; var pptBackOrg:TPoint; var prcClip:TRect; var psize:TSize): HResult; stdcall;
      function StretchBlt(_hdc:HDC; dstX,dstY,dstXE,dstYE,srcX,srcY,srcXE,srcYE:integer; dwROP:DWORD): HResult; stdcall;
 end;

  THiImg_Loader = class(TDebug)
   private
      FImgCtx              : IImgCtx;
      sz                   : TSize;
      sg                   : boolean;
      FBitmap              : PBitmap;
      hOK                  : THandle;
   public
      _prop_FileName       : string;

      _data_FileName       : THI_Event;

      _event_onLoad        : THI_Event;
      _event_onSize        : THI_Event;      
      _event_onBitmap      : THI_Event;

      constructor Create;
      destructor Destroy; override; 
      procedure _work_doLoad(var _Data:TData; idx:word);
      procedure _work_doSize(var _Data:TData; idx:word);
      
      procedure _var_ImageWidth(var _Data:TData; idx:word);
      procedure _var_ImageHeight(var _Data:TData; idx:word);
      procedure _var_Busy(var _Data:TData; idx:word);
      procedure _var_Bitmap(var _Data:TData; idx:word);
end;
implementation

const
  CLSID_IImgCtx:TGUID = '{3050f3d6-98b5-11cf-bb82-00aa00bdce0b}';
  IID_IImgCtx:TGUID   = '{3050f3d7-98b5-11cf-bb82-00aa00bdce0b}';

constructor THiImg_Loader.Create;
begin
  inherited;
  FBitmap := NewBitmap(0, 0);
  sg := true;
end;

destructor THiImg_Loader.Destroy;
begin
  FBitmap.free;
  if hOK <> 0 then CloseHandle(hOK);
  inherited;
end;

function StringToWideString(const s: AnsiString; codePage: Word): WideString;
var   len: integer;
begin
   Result := '';
   if s = '' then exit;
   len := MultiByteToWideChar(codePage, MB_PRECOMPOSED, PAnsiChar(@s[1]), -1, nil, 0);
   SetLength(Result, len - 1);
   if len <= 1 then exit;
   MultiByteToWideChar(CodePage, MB_PRECOMPOSED, PAnsiChar(@s[1]), -1, PWideChar(@Result[1]), len);
end;

procedure MyCallback(pCtx: pointer; pUserData: pointer); stdcall;
var
  stat: Dword;
  ARect: TRect;
begin
  with THiImg_Loader(pUserData) do
  begin
    FImgCtx.GetStateInfo(stat, sz, 0);
    FImgCtx.Disconnect;
    if (Stat and IMGLOAD_LOADING = 1) then
    begin
    end
    else if (Stat and IMGLOAD_NOTLOADED = 1) OR (Stat and IMGLOAD_STOPPED = 1) OR (Stat and IMGLOAD_ERROR = 1) then 
    begin
      if not FBitmap.Empty then FBitmap.Clear;
      sg := true;
      SetEvent(hOK);
    end
    else
    begin
      ARect := MakeRect(0, 0, sz.cx, sz.cy);
      if not FBitmap.Empty then FBitmap.Clear;
      FBitmap.width := sz.cx;
      FBitmap.height := sz.cy; 
      FImgCtx.Draw(FBitmap.Canvas.handle, ARect);
      sg := true;
      SetEvent(hOK);      
    end;  
  end;
end;

procedure MyCallbackSz(pCtx: pointer; pUserData: pointer); stdcall;
var
  stat: Dword;
begin
  with THiImg_Loader(pUserData) do
  begin
    FImgCtx.GetStateInfo(stat, sz, 0);
    FImgCtx.Disconnect;
    sg := true;
    SetEvent(hOK);    
  end;
end;

procedure THiImg_Loader._work_doLoad;
var
  s,s1: string;
  len: dword;
  fn: pchar;
  m: TMsg;  
begin
  if not sg then exit;
  hOK := CreateEvent(nil, false, false, nil);
TRY    
  s1 := ReadString(_Data,_data_FileName,_prop_FileName);
  len := GetFullPathName(@s1[1],0,nil,fn);
  setlength(s, len - 1);
  GetFullPathName(@s1[1], len, @s[1], fn);
  if not FileExists(s) then exit;
  FImgCtx := CreateComObject(CLSID_IImgCtx) as IImgCtx;
  FImgCtx.Load(PWChar({$ifdef UNICODE}s{$else}StringToWideString(s, 3){$endif}), 0);
  FImgCtx.SetCallback(@MyCallback, pointer(Self));
  FImgCtx.SelectChanges(IMGCHG_COMPLETE,0,1);
  sg := false;
  while WaitForSingleObject(hOK,0) <> WAIT_OBJECT_0 do
  begin
    if not GetMessage(m, 0, 0, 0) then continue;
    TranslateMessage(m);
    DispatchMessage(m);
  end;
  _hi_onEvent(_event_onLoad, FBitmap);
FINALLY
  CloseHandle(hOK);
  hOK := 0;
END;    
end;

procedure THiImg_Loader._work_doSize;
var
  s,s1: string;
  len: dword;
  fn: pchar;
  dtx, dty: TData;
  m: TMsg;    
begin
  if not sg then exit;
  hOK := CreateEvent(nil, false, false, nil);
TRY  
  s1 := ReadString(_Data,_data_FileName,_prop_FileName);
  len := GetFullPathName(@s1[1],0,nil,fn);
  setlength(s, len - 1);
  GetFullPathName(@s1[1], len, @s[1], fn);
  if not FileExists(s) then exit;
  FImgCtx := CreateComObject(CLSID_IImgCtx) as IImgCtx;
  FImgCtx.Load(PWChar(StringToWideString(s, 3)), 0);
  FImgCtx.SetCallback(@MyCallbackSz, pointer(Self));
  FImgCtx.SelectChanges(IMGCHG_SIZE,0,1);
  sg := false;
  while WaitForSingleObject(hOK,0) <> WAIT_OBJECT_0 do
  begin
    if not GetMessage(m, 0, 0, 0) then continue;
    TranslateMessage(m);
    DispatchMessage(m);
  end;
  dtInteger(dtx, sz.cx);
  dtInteger(dty, sz.cy);
  dtx.ldata := @dty;    
  _hi_onEvent(_event_onSize, dtx);
FINALLY
  CloseHandle(hOK);
  hOK := 0;  
END;      
end;

procedure THiImg_Loader._var_ImageWidth;
begin
  if not sg then exit;
  dtInteger(_Data, sz.cx);
end;

procedure THiImg_Loader._var_ImageHeight;
begin
  if not sg then exit;
  dtInteger(_Data, sz.cy);
end;

procedure THiImg_Loader._var_Busy;
begin
  dtInteger(_Data, integer(not sg));
end;

procedure THiImg_Loader._var_Bitmap;
begin
  if not sg then exit;
  dtBitmap(_Data, FBitmap);
end;

initialization
  CoInitialize(nil);
finalization
  CoUninitialize;

end.