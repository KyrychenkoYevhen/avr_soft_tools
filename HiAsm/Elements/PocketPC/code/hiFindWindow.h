#include "share.h"

class THIFindWindow:public TDebug
{
   private:
    HWND FHandle;
   public:
    string _prop_Caption;
    string _prop_ClassName;

    THI_Event *_data_ParentHandle;
    THI_Event *_data_ClassName;
    THI_Event *_data_Caption;
    THI_Event *_event_onFind;

    HI_WORK_LOC(THIFindWindow,_work_doFind);
    HI_WORK_LOC(THIFindWindow,_work_doFindChild);
    HI_WORK(_var_Handle){ CreateData(_Data,(int)_hie(THIFindWindow)->FHandle); }
};

void THIFindWindow::_work_doFind(TData &_Data,WORD Index)
{
   string cl = ReadString(_Data,_data_ClassName,_prop_ClassName);
   string c = ReadString(_Data,_data_Caption,_prop_Caption);
   FHandle = FindWindow(PChar(cl),PChar(c));
   _hi_onEvent(_event_onFind,(int)FHandle);
}

void THIFindWindow::_work_doFindChild(TData &_Data,WORD Index)
{
   //HWND h = (HWND)ReadInteger(_Data,_data_ParentHandle,0);
   //string cl = ReadString(_Data,_data_ClassName,_prop_ClassName);
   //string c = ReadString(_Data,_data_Caption,_prop_Caption);
   //FHandle = FindWindowEx(h,0,PChar(cl),PChar(c));
   //_hi_onEvent(_event_onFind,(int)FHandle);
}
