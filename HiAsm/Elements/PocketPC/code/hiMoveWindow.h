#include "share.h"

class  THIMoveWindow:public TDebug
{
   private:
   public:
    THI_Event *_data_Handle;

    HI_WORK_LOC(THIMoveWindow,_work_doMove);
};


void THIMoveWindow::_work_doMove(TData &_Data,WORD Index)
{
   HWND wnd = (HWND)ReadInteger(_Data,_data_Handle,0);
   ReleaseCapture();
   SendMessage(wnd,WM_SYSCOMMAND, 0xF012, 0);
}
