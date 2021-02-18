#include "share.h"
#include "aygshell.h"

class THIMenuBar:public TDebug
{
  private:
   SHMENUBARINFO inf;
   TWinControl *_Parent;
  public:
    int _prop_Menu;
    THI_Event *_event_onSelectStr;
    THI_Event *_event_onSelectNum;

    THIMenuBar(TWinControl *Parent)
    {
      _Parent = Parent;
    }
    void SetEmpty(bool Value);
    __declspec( property( put = SetEmpty )) bool _prop_Empty;
    HI_WORK_LOC(THIMenuBar,_var_Handle)
    {
      CreateData(_Data,(int)inf.hwndMB);
    }
};

//////////////////////////////////////////////////////////////////////////

WNDPROC OldWndProc;

LRESULT __stdcall __WndProc(HWND Wnd,UINT Msg,WPARAM wParam,LPARAM lParam)
{
  MENUITEMINFO buf;
  HI_RSTRING sbuf[128];

  TBBUTTONINFO tbbi;

  switch( Msg )
  {
    case WM_COMMAND:
      //tbbi.cbSize = sizeof(tbbi);
      //tbbi.dwMask = TBIF_LPARAM;
      tbbi.lParam = (int)CommandBar_GetMenu((HWND)lParam, 0);
      //SendMessage((HWND)lParam,TB_GETBUTTONINFO,1,(LPARAM)&tbbi);
      //CheckMenuItem((HMENU)lParam,wParam,MF_BYCOMMAND | MF_CHECKED);
      //buf.cbSize = sizeof(MENUITEMINFO);
      //buf.fType = MIIM_TYPE;
      //buf.dwTypeData = sbuf;
      //GetMenuItemInfo((HMENU)tbbi.lParam,LOWORD(wParam),false,&buf);
      _hi_onEvent(((THIMenuBar*)GetWindowLong(Wnd,GWL_USERDATA))->_event_onSelectStr,(int)tbbi.lParam);
      _hi_onEvent(((THIMenuBar*)GetWindowLong(Wnd,GWL_USERDATA))->_event_onSelectNum,(int)(wParam - 1));
      break;
  }
	return CallWindowProc(OldWndProc,Wnd,Msg,wParam,lParam);
}

void THIMenuBar::SetEmpty(bool Value)
{
  inf.cbSize = sizeof(inf);
  inf.hwndParent = _Parent->Handle;

  if( Value )
    inf.dwFlags = SHCMBF_EMPTYBAR;
  else inf.dwFlags = SHCMBF_HMENU;

  inf.nToolBarId = _prop_Menu;
  inf.hInstRes = hInstance;
  inf.nBmpId = 0;
  inf.cBmpImages = 0;
  inf.clrBk = GetSysColor(COLOR_BTNFACE);
  if( SHCreateMenuBar(&inf) )
  {
     OldWndProc = (WNDPROC)SetWindowLong(inf.hwndMB,GWL_WNDPROC,(long)__WndProc); //_debug("ok");
     SetWindowLong(inf.hwndMB,GWL_USERDATA,(long)this);


     //_hi_onEvent(_event_onSelectStr,(int)tbbi.cchText);
     
  }
}
