{$IFDEF interface_part}

const
  { alpha format flags }
  AC_SRC_NO_PREMULT_ALPHA = $01;
  AC_SRC_NO_ALPHA = $02;
  AC_DST_NO_PREMULT_ALPHA = $10;
  AC_DST_NO_ALPHA = $20;

  { gradient drawing modes }
  GRADIENT_FILL_RECT_H = $00000000;
  GRADIENT_FILL_RECT_V = $00000001;
   GRADIENT_FILL_TRIANGLE = $00000002;
  GRADIENT_FILL_OP_FLAG = $000000ff;

  HWND_MESSAGE = -3;
  wnd_Message = HWND_MESSAGE;
  
  MOUSEEVENTF_WHEEL           = $0800; { wheel button rolled }


  FILE_ACTION_ADDED                   = $00000001;
  FILE_ACTION_REMOVED                 = $00000002;
  FILE_ACTION_MODIFIED                = $00000003;
  FILE_ACTION_RENAMED_OLD_NAME        = $00000004;
  FILE_ACTION_RENAMED_NEW_NAME        = $00000005;
  
  
type
  TGradientRect = _GRADIENT_RECT;
  PGradientRect = ^TGradientRect;
  
  PWGLSwap = ^TWGLSwap;
  _WGLSWAP = packed record
    hdc: HDC;
    uiFlags: UINT;
  end;
  TWGLSwap = _WGLSWAP;
  WGLSWAP = _WGLSWAP;
  
  PMouseInput = ^TMouseInput;
  tagMOUSEINPUT = packed record
    dx: Longint;
    dy: Longint;
    mouseData: DWORD;
    dwFlags: DWORD;
    time: DWORD;
    dwExtraInfo: DWORD;
  end;
  TMouseInput = tagMOUSEINPUT;

  PKeybdInput = ^TKeybdInput;
  tagKEYBDINPUT = packed record
    wVk: WORD;
    wScan: WORD;
    dwFlags: DWORD;
    time: DWORD;
    dwExtraInfo: DWORD;
  end;
  TKeybdInput = tagKEYBDINPUT;

  PHardwareInput = ^THardwareInput;
  tagHARDWAREINPUT = packed record
    uMsg: DWORD;
    wParamL: WORD;
    wParamH: WORD;
  end;
  THardwareInput = tagHARDWAREINPUT;

  PInput = ^TInput;
  tagINPUT = packed record
    Itype: DWORD;
    case Integer of
      0: (mi: TMouseInput);
      1: (ki: TKeybdInput);
      2: (hi: THardwareInput);
  end;
  TInput = tagINPUT;
  
const
  INPUT_MOUSE = 0;
  INPUT_KEYBOARD = 1;
  INPUT_HARDWARE = 2;

  function SendInput(cInputs: UINT; var pInputs: TInput; cbSize: Integer): UINT;external 'user32' name 'SendInput';
  
  function SetSystemPowerState(fSuspend, fForce: BOOL): BOOL; stdcall; external kernel32 name 'SetSystemPowerState';
  
{$ENDIF interface_part}


{$IFDEF implementation_part}



{$ENDIF implementation_part}

