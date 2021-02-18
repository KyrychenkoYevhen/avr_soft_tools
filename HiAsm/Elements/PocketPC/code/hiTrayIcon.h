#include "share.h"
#include "shellapi.h"
#include "WinControls.h"

class THITrayIcon:public TDebug
{
   private:
    TForm *ParentForm;
    NOTIFYICONDATA FTrayData;
    bool FInst;

    void AddTrayIcon(bool _hide = true);
    void RemoveTrayIcon();
    static bool OnMessage(void *ClassPointer,int Code,WPARAM wParam,LPARAM lParam);
   public:
    bool _prop_FormHook;
    string _prop_Hint;

    THI_Event *_event_onDblClick;
    THI_Event *_event_onClick;

    THITrayIcon(TWinControl *Parent);
    ~THITrayIcon();
    HI_WORK(_work_doShow){ _hie(THITrayIcon)->RemoveTrayIcon(); }
    HI_WORK(_work_doHide){ _hie(THITrayIcon)->AddTrayIcon(); }
    HI_WORK_LOC(THITrayIcon,_work_doHint);
    HI_WORK_LOC(THITrayIcon,_work_doIcon);
    HI_WORK(_work_doAddTrayIcon){ _hie(THITrayIcon)->AddTrayIcon(false); }
};

//////////////////////////////////////////////////////////////////////

#define TrayID 100
#define CM_TRAYICON (WM_USER + 1)

THITrayIcon::THITrayIcon(TWinControl *Parent)
{
   ParentForm = (TForm*)Parent;
   AddCSProc(ParentForm->OnMessage,this,OnMessage);
}

THITrayIcon::~THITrayIcon()
{
    RemoveTrayIcon();
}

bool THITrayIcon::OnMessage(void *ClassPointer,int Code,WPARAM wParam,LPARAM lParam)
{
  switch( Code )
  {
    case WM_SYSCOMMAND:
      switch( wParam )
      {
        //case SC_RESTORE : RemoveTrayIcon(); break;
        //case SC_MINIMIZE: AddTrayIcon();
      }
      break;
    case WM_DESTROY:
      _hie(THITrayIcon)->RemoveTrayIcon();
      //ParentForm.OnMessage := OldMessage;
      break;
    case WM_CLOSE:
     if( _hie(THITrayIcon)->_prop_FormHook )
     {
        _hie(THITrayIcon)->AddTrayIcon();
        //SendMessage(_hie(THITrayIcon)->ParentForm->Handle,WM_SYSCOMMAND,SC_MINIMIZE,0);
        return true;
     }
     break;
    case WM_SETICON:
      if( _hie(THITrayIcon)->FInst )
      {
        _hie(THITrayIcon)->FTrayData.hIcon = _hie(THITrayIcon)->ParentForm->FIcon;
        Shell_NotifyIcon(NIM_MODIFY,&_hie(THITrayIcon)->FTrayData);
      }
      break;
    case CM_TRAYICON:
      switch( lParam )
      {
        case WM_LBUTTONDBLCLK: _hi_onEvent(_hie(THITrayIcon)->_event_onDblClick,0); break;
        //case WM_RBUTTONDBLCLK: _hi_onEvent(_hie(THITrayIcon)->_event_onDblClick,1); break;
        case WM_LBUTTONUP: _hi_onEvent(_hie(THITrayIcon)->_event_onClick,0); break;
        case WM_LBUTTONDOWN: _hi_onEvent(_hie(THITrayIcon)->_event_onClick,2); break;
        //case WM_RBUTTONUP: _hi_onEvent(_hie(THITrayIcon)->_event_onClick,1); break;
      }
  }
  return false;
}

void THITrayIcon::AddTrayIcon(bool _hide)
{
  if( _hide )
    ParentForm->Hide();
  //if( ParentForm.Parent <> nil then
  //  ShowWindow(ParentForm.Parent.Handle,SW_HIDE);
  //ZeroMemory(&FTrayData,sizeof(FTrayData));
  FTrayData.cbSize = sizeof(FTrayData);
  FTrayData.hWnd = ParentForm->Handle;
  FTrayData.uID = TrayID;
  FTrayData.uFlags = NIF_MESSAGE | NIF_TIP | NIF_ICON;
  FTrayData.uCallbackMessage = CM_TRAYICON;
  HIMAGELIST h = ImageList_Create(16,16,ILC_COLOR|ILC_MASK,0,10);
  ImageList_AddIcon(h,ParentForm->SIcon);
  //ImageList_SetBkColor(h,0);
  FTrayData.hIcon = ImageList_GetIcon(h,0,ILD_TRANSPARENT  );
  ImageList_Destroy(h);
  //FTrayData.hIcon = ParentForm->SIcon;
  strCopy(FTrayData.szTip,PChar(_prop_Hint));

  Shell_NotifyIcon(NIM_ADD,&FTrayData);
  FInst = true;
}

void THITrayIcon::RemoveTrayIcon()
{
   if( FInst )
   {
      Shell_NotifyIcon(NIM_DELETE,&FTrayData);
      //if ParentForm.Parent <> nil then
      //  ShowWindow(ParentForm.Parent.Handle,SW_SHOWNORMAL);
      ParentForm->Show();
      SetForegroundWindow( ParentForm->Handle );
      FInst = false;
   }
}

void THITrayIcon::_work_doHint(TData &_Data,WORD Index)
{
  _prop_Hint = ToString(_Data);
  strCopy(FTrayData.szTip,PChar(_prop_Hint));
  Shell_NotifyIcon(NIM_MODIFY,&FTrayData);
}

void THITrayIcon::_work_doIcon(TData &_Data,WORD Index)
{
  //FTrayData.hIcon = ParentForm->Icon;
  //if( _data.data_type == data_icon )
  //  FTrayData.hIcon = PIcon(_data.idata).Handle;
  //Shell_NotifyIcon(NIM_MODIFY,&FTrayData);
}
