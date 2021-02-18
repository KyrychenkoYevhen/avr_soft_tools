unit hiDeferredEvent;

interface

uses
  Windows, Messages, Kol, Share, Debug;

type
  ThiDeferredEvent = class(TDebug)
    private
      FData: TData;
    public
      _prop_InData: Boolean;
      _prop_Delay: Integer;
      _prop_Data: TData;     
      _data_Data: THI_Event;
      _event_onDeferredEvent: THI_Event;
      procedure _work_doDeferredEvent(var _Data: TData; Index: Word);
 end;

implementation

const
  WM_DEFERREDEVENT = WM_USER + 5555;

var
  MyWindowClass: TWndClass;
  FWnd: THandle;

procedure ThiDeferredEvent._work_doDeferredEvent;
begin
  if _prop_InData then
    FData := ReadData(_Data, _data_Data, @_prop_Data)
  else
    dtNull(FData);
  Sleep(_prop_Delay);  
  PostMessage(FWnd, WM_DEFERREDEVENT, WPARAM(Self), 0);
end;


function MyWndProc(hWnd: HWND; wMsg: Cardinal; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  MySelf: ThiDeferredEvent;
begin
  case wMsg of
    WM_DEFERREDEVENT:
      begin
        MySelf := ThiDeferredEvent(wParam);
        if Assigned(MySelf) then _hi_onEvent(MySelf._event_onDeferredEvent, MySelf.FData);
        Result := 1;
      end;
    else
      Result := DefWindowProc(hWnd, wMsg, wParam, lParam);
  end;
end;

initialization

  FillChar(MyWindowClass, SizeOf(TWndClass), 0);
  with MyWindowClass do
  begin
    lpfnWndProc := @MyWndProc;
    lpszClassName := 'Deferred_Event';
  end;
  MyWindowClass.hInstance := hInstance;
  
  RegisterClass(MyWindowClass);
  
  FWnd := CreateWindowEx(0, MyWindowClass.lpszClassName, '', 0, 0, 0, 0, 0, THandle(HWND_MESSAGE), 0, hInstance, nil);
  
finalization
  Windows.DestroyWindow(FWnd);
  UnregisterClass(MyWindowClass.lpszClassName, hInstance);
  
end.