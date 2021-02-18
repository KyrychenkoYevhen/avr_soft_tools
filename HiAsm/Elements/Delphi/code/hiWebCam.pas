unit hiWebCam;

interface

uses
  Windows, Kol, Share, Debug;

const
  WM_USER = $00000400;

  WM_CAP_START                    = WM_USER; //����� ��� ���������
  WM_CAP_UNICODE_START            = WM_USER + 100;
  
  WM_CAP_GET_CAPSTREAMPTR         = WM_CAP_START + 1;
  //�������� callback ������
  WM_CAP_SET_CALLBACK_ERRORA       = WM_CAP_START + 2;
  WM_CAP_SET_CALLBACK_STATUSA      = WM_CAP_START + 3;
  WM_CAP_SET_CALLBACK_ERRORW       = WM_CAP_UNICODE_START + 2;
  WM_CAP_SET_CALLBACK_STATUSW      = WM_CAP_UNICODE_START + 3;
  
  {$ifdef UNICODE}
  WM_CAP_SET_CALLBACK_ERROR       = WM_CAP_SET_CALLBACK_ERRORW;
  WM_CAP_SET_CALLBACK_STATUS      = WM_CAP_SET_CALLBACK_STATUSW;  
  {$else}
  WM_CAP_SET_CALLBACK_ERROR       = WM_CAP_SET_CALLBACK_ERRORA;
  WM_CAP_SET_CALLBACK_STATUS      = WM_CAP_SET_CALLBACK_STATUSA;
  {$endif}

  WM_CAP_SET_CALLBACK_YIELD       = WM_CAP_START + 4;
  WM_CAP_SET_CALLBACK_FRAME       = WM_CAP_START + 5;
  WM_CAP_SET_CALLBACK_VIDEOSTREAM = WM_CAP_START + 6;
  WM_CAP_SET_CALLBACK_WAVESTREAM  = WM_CAP_START + 7;
  WM_CAP_GET_USER_DATA            = WM_CAP_START + 8;
  WM_CAP_SET_USER_DATA            = WM_CAP_START + 9;

  WM_CAP_DRIVER_CONNECT           = WM_CAP_START + 10;
  WM_CAP_DRIVER_DISCONNECT        = WM_CAP_START + 11;

  WM_CAP_DRIVER_GET_NAMEA          = WM_CAP_START + 12;
  WM_CAP_DRIVER_GET_VERSIONA       = WM_CAP_START + 13;
  WM_CAP_DRIVER_GET_NAMEW          = WM_CAP_UNICODE_START + 12;
  WM_CAP_DRIVER_GET_VERSIONW       = WM_CAP_UNICODE_START + 13;
  
  {$ifdef UNICODE}
  WM_CAP_DRIVER_GET_NAME          = WM_CAP_DRIVER_GET_NAMEA;
  WM_CAP_DRIVER_GET_VERSION       = WM_CAP_DRIVER_GET_VERSIONA;
  {$else}
  WM_CAP_DRIVER_GET_NAME          = WM_CAP_DRIVER_GET_NAMEA;
  WM_CAP_DRIVER_GET_VERSION       = WM_CAP_DRIVER_GET_VERSIONA;
  {$endif}
  
  
  WM_CAP_DRIVER_GET_CAPS          = WM_CAP_START + 14;

  WM_CAP_FILE_SET_CAPTURE_FILEA    = WM_CAP_START + 20;
  WM_CAP_FILE_GET_CAPTURE_FILEA    = WM_CAP_START + 21;
  WM_CAP_FILE_SAVEASA              = WM_CAP_START + 23;
  WM_CAP_FILE_SAVEDIBA             = WM_CAP_START + 25;
  WM_CAP_FILE_SET_CAPTURE_FILEW    = WM_CAP_UNICODE_START + 20;
  WM_CAP_FILE_GET_CAPTURE_FILEW    = WM_CAP_UNICODE_START + 21;
  WM_CAP_FILE_SAVEASW              = WM_CAP_UNICODE_START + 23;
  WM_CAP_FILE_SAVEDIBW             = WM_CAP_UNICODE_START + 25;
  
  {$ifdef UNICODE}
  WM_CAP_FILE_SET_CAPTURE_FILE    = WM_CAP_FILE_SET_CAPTURE_FILEW;
  WM_CAP_FILE_GET_CAPTURE_FILE    = WM_CAP_FILE_GET_CAPTURE_FILEW;
  WM_CAP_FILE_SAVEAS              = WM_CAP_FILE_SAVEASW;
  WM_CAP_FILE_SAVEDIB             = WM_CAP_FILE_SAVEDIBW;
  {$else}
  WM_CAP_FILE_SET_CAPTURE_FILE    = WM_CAP_FILE_SET_CAPTURE_FILEA;
  WM_CAP_FILE_GET_CAPTURE_FILE    = WM_CAP_FILE_GET_CAPTURE_FILEA;
  WM_CAP_FILE_SAVEAS              = WM_CAP_FILE_SAVEASA;
  WM_CAP_FILE_SAVEDIB             = WM_CAP_FILE_SAVEDIBA;
  {$endif}
  
  WM_CAP_FILE_ALLOCATE            = WM_CAP_START + 22;
  WM_CAP_FILE_SET_INFOCHUNK       = WM_CAP_START + 24;

  WM_CAP_EDIT_COPY                = WM_CAP_START + 30;

  WM_CAP_SET_AUDIOFORMAT          = WM_CAP_START + 35;
  WM_CAP_GET_AUDIOFORMAT          = WM_CAP_START + 36;

  WM_CAP_DLG_VIDEOFORMAT          = WM_CAP_START + 41;
  WM_CAP_DLG_VIDEOSOURCE          = WM_CAP_START + 42;
  WM_CAP_DLG_VIDEODISPLAY         = WM_CAP_START + 43;
  WM_CAP_GET_VIDEOFORMAT          = WM_CAP_START + 44;
  WM_CAP_SET_VIDEOFORMAT          = WM_CAP_START + 45;
  WM_CAP_DLG_VIDEOCOMPRESSION     = WM_CAP_START + 46;

  WM_CAP_SET_PREVIEW              = WM_CAP_START + 50;
  WM_CAP_SET_OVERLAY              = WM_CAP_START + 51;
  WM_CAP_SET_PREVIEWRATE          = WM_CAP_START + 52;
  WM_CAP_SET_SCALE                = WM_CAP_START + 53;
  WM_CAP_GET_STATUS               = WM_CAP_START + 54;
  WM_CAP_SET_SCROLL               = WM_CAP_START + 55;

  WM_CAP_GRAB_FRAME               = WM_CAP_START + 60;
  WM_CAP_GRAB_FRAME_NOSTOP        = WM_CAP_START + 61;

  WM_CAP_SEQUENCE                 = WM_CAP_START + 62;
  WM_CAP_SEQUENCE_NOFILE          = WM_CAP_START + 63;
  WM_CAP_SET_SEQUENCE_SETUP       = WM_CAP_START + 64;
  WM_CAP_GET_SEQUENCE_SETUP       = WM_CAP_START + 65;

  WM_CAP_SET_MCI_DEVICEA           = WM_CAP_START + 66;
  WM_CAP_GET_MCI_DEVICEA           = WM_CAP_START + 67;
  WM_CAP_SET_MCI_DEVICEW           = WM_CAP_UNICODE_START + 66;
  WM_CAP_GET_MCI_DEVICEW           = WM_CAP_UNICODE_START + 67;
  
  {$ifdef UNICODE}
  WM_CAP_SET_MCI_DEVICE           = WM_CAP_SET_MCI_DEVICEW;
  WM_CAP_GET_MCI_DEVICE           = WM_CAP_GET_MCI_DEVICEW;
  {$else}
  WM_CAP_SET_MCI_DEVICE           = WM_CAP_SET_MCI_DEVICEA;
  WM_CAP_GET_MCI_DEVICE           = WM_CAP_GET_MCI_DEVICEA;
  {$endif}

  WM_CAP_STOP                     = WM_CAP_START + 68;
  WM_CAP_ABORT                    = WM_CAP_START + 69;

  WM_CAP_SINGLE_FRAME_OPEN        = WM_CAP_START + 70;
  WM_CAP_SINGLE_FRAME_CLOSE       = WM_CAP_START + 71;
  WM_CAP_SINGLE_FRAME             = WM_CAP_START + 72;

  WM_CAP_PAL_OPENA                 = WM_CAP_START + 80;
  WM_CAP_PAL_SAVEA                 = WM_CAP_START + 81;
  WM_CAP_PAL_OPENW                 = WM_CAP_UNICODE_START + 80;
  WM_CAP_PAL_SAVEW                 = WM_CAP_UNICODE_START + 81;
  
  {$ifdef UNICODE}
  WM_CAP_PAL_OPEN                 = WM_CAP_PAL_OPENW;
  WM_CAP_PAL_SAVE                 = WM_CAP_PAL_SAVEW;
  {$else}
  WM_CAP_PAL_OPEN                 = WM_CAP_PAL_OPENA;
  WM_CAP_PAL_SAVE                 = WM_CAP_PAL_SAVEA;
  {$endif}

  WM_CAP_PAL_PASTE                = WM_CAP_START + 82;
  WM_CAP_PAL_AUTOCREATE           = WM_CAP_START + 83;
  WM_CAP_PAL_MANUALCREATE         = WM_CAP_START + 84;

  // Following added post VFW 1.1
  WM_CAP_SET_CALLBACK_CAPCONTROL  = WM_CAP_START + 85;

  CONTROLCALLBACK_PREROLL         = 1 ; //* Waiting to start capture */ 
  CONTROLCALLBACK_CAPTURING       = 2 ; //* Now capturing */

type
  ThiWebCam = class(TDebug)
    private
      hCamCapture: Integer;
      hHandle: HWND;
      fRefreshRate: Integer;
      fViewStyle: Integer;
      procedure Connect;
      procedure DisConnect;
    public
      _prop_FileDIB     : string;
      _prop_FileVideo   : string;
      _data_Scale       : THI_Event;
      _data_RefreshRate : THI_Event;
      _data_ViewStyle   : THI_Event; 
      _data_WinHandle   : THI_Event;
      _data_FileDIB     : THI_Event;
      _data_FileVideo   : THI_Event;
      _event_onConnect  : THI_Event;
      _event_onProgress : THI_Event;

      property _prop_RefreshRate: Integer write fRefreshRate;
      property _prop_ViewStyle: Integer write fViewStyle;
      
      constructor Create;
      destructor Destroy; override;
      
      procedure _work_doConnect(var _Data: TData; Index: Word);
      procedure _work_doDisConnect(var _Data: TData; Index: Word);
      procedure _work_doEditCopy(var _Data: TData; Index: Word);
      procedure _work_doSaveDIB(var _Data: TData; Index: Word);
      procedure _work_doVideoSource(var _Data: TData; Index: Word);
      procedure _work_doVideoFormat(var _Data: TData; Index: Word);
      procedure _work_doVideoCompression(var _Data: TData; Index: Word);    
      procedure _work_doStartSequence(var _Data: TData; Index: Word);
      procedure _work_doStopSequence(var _Data: TData; Index: Word);
      procedure _work_doRefreshRate(var _Data: TData; Index: Word);
      procedure _work_doViewStyle(var _Data: TData; Index: Word);
      procedure _var_Handle(var _Data: TData; Index: Word);
  end;

implementation

function capCreateCaptureWindow (lpszWindowName : PChar; dwStyle : Integer; x : Integer; y : Integer;
            nWidth : Integer; nHeight : Integer; hWndParent : HWND; nID : Integer) : HWND; stdcall;
            external 'avicap32.dll' name {$ifdef UNICODE}'capCreateCaptureWindowW'{$else}'capCreateCaptureWindowA'{$endif};

function CapControlCallback (hWnd: HWND; nState: Integer): LRESULT; stdcall; 
var
  pCls: ThiWebCam; 
begin 
  pCls := ThiWebCam(GetProp(hWnd, PChar('OwnerObject')));
  //Result := nState;
  Result := 1; // Continue capture
  _hi_onEvent(pCls._event_onProgress);
end;

constructor ThiWebCam.Create;
begin
  inherited;
  hCamCapture := 0;
end;

destructor ThiWebCam.Destroy;
begin
  if hCamCapture <> 0 then DestroyWindow(hCamCapture);
  inherited;
end;

procedure ThiWebCam.Connect;
var
  r: TRect;
  S: string;  
begin
  if hCamCapture <> 0 then exit;
  GetWindowRect(hHandle, r);
  S := 'WebCam_' + Int2Str(NativeInt(Self));
  hCamCapture := capCreateCaptureWindow(PChar(S), WS_VISIBLE OR WS_CHILD OR WS_CLIPSIBLINGS, 0, 0, r.right-r.left, r.bottom-r.top, hHandle, LongInt(Self));
  if hCamCapture = 0 then exit;
  SetProp(hCamCapture, PChar('OwnerObject'), NativeInt(Self));
  SendMessage(hCamCapture, WM_CAP_DRIVER_CONNECT, 0, 0);
  SendMessage(hCamCapture, WM_CAP_SET_OVERLAY, 0, 0);
  SendMessage(hCamCapture, WM_CAP_SET_PREVIEW, 1, 0); 
  SendMessage(hCamCapture, WM_CAP_SET_SCALE, fViewStyle, 0);
  SendMessage(hCamCapture, WM_CAP_SET_PREVIEWRATE, fRefreshRate, 0);
  SendMessage(hCamCapture, WM_CAP_SET_CALLBACK_CAPCONTROL, 0, LPARAM(@CapControlCallback));   
end;

procedure ThiWebCam.DisConnect;
begin
  SendMessage(hCamCapture, WM_CAP_DRIVER_DISCONNECT, 0, 0);   
  DestroyWindow(hCamCapture);
  hCamCapture := 0;
end;

procedure ThiWebCam._work_doConnect;
begin
  hHandle := ReadInteger(_Data, _data_WinHandle, 0);
  Connect;
  dtInteger(_Data, hCamCapture);
  _hi_CreateEvent(_Data, @_event_onConnect);
end;

procedure ThiWebCam._work_doDisConnect;
begin
  if hCamCapture = 0 then exit;
  DisConnect;
end;

procedure ThiWebCam._work_doEditCopy;
begin
  if hCamCapture = 0 then exit;
  SendMessage(hCamCapture, WM_CAP_EDIT_COPY, 0, 0);
end;

procedure ThiWebCam._work_doSaveDIB;
var
  Fn: string;
begin
  if hCamCapture = 0 then exit;
  Fn := ReadString(_Data, _data_FileDIB, _prop_FileDIB);
  SendMessage(hCamCapture, WM_CAP_FILE_SAVEDIB, 0, LPARAM(Pointer(Fn)));
end;

procedure ThiWebCam._work_doVideoSource;
begin
  if hCamCapture = 0 then exit;
  SendMessage(hCamCapture, WM_CAP_DLG_VIDEOSOURCE, 0, 0);
  hHandle := ReadInteger(_Data, _data_WinHandle, 0);
  DisConnect;
  Connect;
end;

procedure ThiWebCam._work_doVideoFormat;
begin
  if hCamCapture = 0 then exit;
  SendMessage(hCamCapture, WM_CAP_DLG_VIDEOFORMAT, 0, 0);
end;

procedure ThiWebCam._work_doVideoCompression;
begin
  if hCamCapture = 0 then exit;
  SendMessage(hCamCapture, WM_CAP_DLG_VIDEOCOMPRESSION, 0, 0); 
end;

procedure ThiWebCam._work_doStartSequence;
var
  Fn: string;  
begin
  if hCamCapture = 0 then exit;
  Fn := ReadString(_Data, _data_FileVideo, _prop_FileVideo);
  SendMessage(hCamCapture, WM_CAP_FILE_SET_CAPTURE_FILE, 0, LPARAM(Pointer(Fn)));
  SendMessage(hCamCapture, WM_CAP_SEQUENCE, 0, 0);
end;

procedure ThiWebCam._work_doStopSequence;
begin
  if hCamCapture = 0 then exit;
  SendMessage(hCamCapture, WM_CAP_STOP, 0, 0); 
end;

procedure ThiWebCam._work_doRefreshRate;
begin
  fRefreshRate := ReadInteger(_Data, _data_RefreshRate);
  if hCamCapture = 0 then exit;
  SendMessage(hCamCapture, WM_CAP_SET_PREVIEWRATE, fRefreshRate, 0);
end;

procedure ThiWebCam._work_doViewStyle;
begin
  fViewStyle := ReadInteger(_Data, _data_ViewStyle);
  if hCamCapture = 0 then exit;
  SendMessage(hCamCapture, WM_CAP_SET_SCALE, fViewStyle, 0);
end;

procedure ThiWebCam._var_Handle;
begin
  dtInteger(_Data, hCamCapture);
end;

end.