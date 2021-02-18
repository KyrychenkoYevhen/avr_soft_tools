#include "share.h"

class THIPosWindow:public TDebug
{
   private:
   public:
    int _prop_Left;
    int _prop_Top;

    THI_Event *_data_Top;
    THI_Event *_data_Left;
    THI_Event *_data_Handle;

    HI_WORK_LOC(THIPosWindow,_work_doLeft);
    HI_WORK_LOC(THIPosWindow,_work_doTop);
    HI_WORK_LOC(THIPosWindow,_var_CurrentLeft);
    HI_WORK_LOC(THIPosWindow,_var_CurrentTop);
};

void THIPosWindow::_work_doLeft(TData &_Data,WORD Index)
{
   HWND h = (HWND)ReadInteger(_Data,_data_Handle,0);
   RECT t;
   GetWindowRect(h,&t);
   SetWindowPos(h,0,ReadInteger(_Data,_data_Left,_prop_Left),t.top,0,0,SWP_NOSIZE | SWP_NOZORDER | SWP_NOACTIVATE);
}

void THIPosWindow::_work_doTop(TData &_Data,WORD Index)
{
   HWND h = (HWND)ReadInteger(_Data,_data_Handle,0);
   RECT t;
   GetWindowRect(h,&t);
   SetWindowPos(h,0,t.left,ReadInteger(_Data,_data_Top,_prop_Top),0,0,SWP_NOSIZE | SWP_NOZORDER | SWP_NOACTIVATE);
}

void THIPosWindow::_var_CurrentLeft(TData &_Data,WORD Index)
{
   HWND h = (HWND)ReadInteger(_Data,_data_Handle,0);
   RECT r;
   GetWindowRect(h,&r);
   CreateData(_Data,r.left);
}

void THIPosWindow::_var_CurrentTop(TData &_Data,WORD Index)
{
   HWND h = (HWND)ReadInteger(_Data,_data_Handle,0);
   RECT r;
   GetWindowRect(h,&r);
   CreateData(_Data,r.left);
}
