#include "share.h"

class THIWinTools:public TDebug
{
   private:
    //procedure SetAttr(h:THandle; CValue:TColor; AValue:byte; Flag:DWORD);
   public:
    THI_Event *_data_Text;
    THI_Event *_data_Handle;

    HI_WORK( _work_doVisible)
    {
       DWORD f = ReadBool(_Data)?SW_SHOW:SW_HIDE;
       ShowWindow((HWND)ReadInteger(_Data,_hie(THIWinTools)->_data_Handle,0),f);
    }
    HI_WORK( _work_doPopup)
    {
       HWND h = ReadBool(_Data)?HWND_TOPMOST:HWND_NOTOPMOST;
       SetWindowPos((HWND)ReadInteger(_Data,_hie(THIWinTools)->_data_Handle,0),h,0,0,0,0,SWP_NOSIZE | SWP_NOMOVE);
    }
    HI_WORK( _work_doClose)
    {
       PostMessage((HWND)ReadInteger(_Data,_hie(THIWinTools)->_data_Handle,0), WM_QUIT, 0, 0);
    }
    HI_WORK( _work_doCaption){ SetWindowText((HWND)ReadInteger(_Data,_hie(THIWinTools)->_data_Handle,0),PChar(ReadString(_Data,_hie(THIWinTools)->_data_Text,string(_his(""))))); }
    HI_WORK( _work_doSendMessage)
    {
       SendMessage((HWND)ReadInteger(_Data,_hie(THIWinTools)->_data_Handle,0), _Data.idata, 0, 0);
    }
    HI_WORK( _work_doActive){ SetForegroundWindow((HWND)ReadInteger(_Data,_hie(THIWinTools)->_data_Handle,0)); }
    HI_WORK( _work_doEnable)
    {
       bool en = ReadBool(_Data);
       EnableWindow((HWND)ReadInteger(_Data,_hie(THIWinTools)->_data_Handle,0), en);
    }

    HI_WORK( _work_doMinimize)
    {
      ShowWindow((HWND)ReadInteger(_Data,_hie(THIWinTools)->_data_Handle,0),SW_MINIMIZE);
    }
    HI_WORK( _work_doNormal)
    {
      ShowWindow((HWND)ReadInteger(_Data,_hie(THIWinTools)->_data_Handle,0),SW_SHOW);
    }
    HI_WORK( _work_doMaximize )
    {
      ShowWindow((HWND)ReadInteger(_Data,_hie(THIWinTools)->_data_Handle,0),SW_MAXIMIZE);
    }

    //HI_WORK( _work_doTransparentColor(var _Data:TData; Index:word);
    //HI_WORK( _work_doAlphaBlendValue(var _Data:TData; Index:word);

    HI_WORK_LOC(THIWinTools,_var_CaptionText);
    HI_WORK_LOC(THIWinTools,_var_FileName);
};


/*
procedure THIWinTools._work_doTransparentColor;
const LWA_COLORKEY = $00000001;
var h:cardinal;
begin
   h := ReadInteger(_Data,_data_Handle,0);
   SetAttr(h,ToInteger(_Data),0,LWA_COLORKEY);
end;

procedure THIWinTools._work_doAlphaBlendValue;
const LWA_ALPHA=$00000002;
var h:cardinal;
begin
   h := ReadInteger(_Data,_data_Handle,0);
   SetAttr(h,0,ToInteger(_Data),LWA_ALPHA);
end;

procedure THIWinTools.SetAttr;
const
  LWA_ALPHA=$00000002;
  ULW_COLORKEY=$00000001;
  ULW_ALPHA=$00000002;
  ULW_OPAQUE=$00000004;
  WS_EX_LAYERED=$00080000;
type
  TSetLayeredWindowAttributes=
    function( hwnd: Integer; crKey: TColor; bAlpha: Byte; dwFlags: DWORD )
    : Boolean; stdcall;
var
  SetLayeredWindowAttributes: TSetLayeredWindowAttributes;
  User32: THandle;
  dw: DWORD;
begin
  User32 := GetModuleHandle( 'User32' );
  SetLayeredWindowAttributes := GetProcAddress( User32, 'SetLayeredWindowAttributes' );
  if Assigned( SetLayeredWindowAttributes ) then
   begin
    dw := GetWindowLong( h, GWL_EXSTYLE );
    SetWindowLong( h, GWL_EXSTYLE, dw or WS_EX_LAYERED );
    //if Control.AlphaBlend < 255 then
    // inc(dw,LWA_ALPHA);
    SetLayeredWindowAttributes( h, CValue, AValue and $FF, Flag);
   end;
end;
*/

void THIWinTools::_var_CaptionText(TData &_Data,WORD Index)
{
  HI_RSTRING buf[MAX_PATH];
  buf[ GetWindowText((HWND)ReadInteger(_Data,_data_Handle,0),buf,MAX_PATH) ] = 0;
  CreateData(_Data,string(buf));
}

void THIWinTools::_var_FileName(TData &_Data,WORD Index)
{
  HI_RSTRING buf[MAX_PATH];
  buf[ GetModuleFileName(hInstance,buf,MAX_PATH) ] = 0;
  CreateData(_Data,string(buf));
}


