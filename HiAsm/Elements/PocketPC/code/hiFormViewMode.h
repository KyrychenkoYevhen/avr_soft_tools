#include "share.h"
#include "aygshell.h"

class THIFormViewMode:public TDebug
{
   private:
    void SetMode(TData &_Data,int Value)
    {
      HWND h = (HWND)ReadInteger(_Data,_data_Handle,0);
      SHFullScreen(h,Value);
    }
   public:
    THI_Event *_data_Handle;

    HI_WORK_LOC(THIFormViewMode,_work_doTackBar)
    {
     SetMode(_Data,ReadBool(_Data)?SHFS_SHOWTASKBAR:SHFS_HIDETASKBAR);
    }
    HI_WORK_LOC(THIFormViewMode,_work_doSipButton)
    {
      SetMode(_Data,ReadBool(_Data)?SHFS_SHOWSIPBUTTON:SHFS_HIDESIPBUTTON);
    }
    HI_WORK_LOC(THIFormViewMode,_work_doStartIcon)
    {
      SetMode(_Data,ReadBool(_Data)?SHFS_SHOWSTARTICON:SHFS_HIDESTARTICON);
    }
};

///////////////////////////////////////////////////////////////////////////

