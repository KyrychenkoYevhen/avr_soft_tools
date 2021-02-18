#include "share.h"

class THISizeWindow:public TDebug
{
  private:
  public:
   int _prop_Width;
   int _prop_Height;

   THI_Event *_data_Height;
   THI_Event *_data_Width;
   THI_Event *_data_Handle; 

   HI_WORK_LOC(THISizeWindow,_work_doWidth);
   HI_WORK_LOC(THISizeWindow,_work_doHeight);
   HI_WORK_LOC(THISizeWindow,_var_CurrentWidth);
   HI_WORK_LOC(THISizeWindow,_var_CurrentHeight);
};


void THISizeWindow::_work_doWidth(TData &_Data,WORD Index)
{
  HWND h = (HWND)ReadInteger(_Data,_data_Handle,0);
  RECT r;
  GetWindowRect(h,&r);
  SetWindowPos(h,0,0,0,ReadInteger(_Data,_data_Width,0),r.bottom-r.top,SWP_NOMOVE | SWP_NOZORDER);
}

void THISizeWindow::_work_doHeight(TData &_Data,WORD Index)
{
  HWND h = (HWND)ReadInteger(_Data,_data_Handle,0);
  RECT r;
  GetWindowRect(h,&r);
  SetWindowPos(h,0,0,0,r.right-r.left,ReadInteger(_Data,_data_Height,0),SWP_NOMOVE | SWP_NOZORDER);
}

void THISizeWindow::_var_CurrentWidth(TData &_Data,WORD Index)
{
  HWND h = (HWND)ReadInteger(_Data,_data_Handle,0);
  RECT r;
  GetWindowRect(h,&r);
  CreateData(_Data,r.right - r.left);
}

void THISizeWindow::_var_CurrentHeight(TData &_Data,WORD Index)
{
  HWND h = (HWND)ReadInteger(_Data,_data_Handle,0);
  RECT r;
  GetWindowRect(h,&r);
  CreateData(_Data,r.bottom - r.top);
}
