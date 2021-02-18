#include "share.h"

class  THIWinEnum:public TDebug
{
   private:
    string ReadParam();
   public:
    HWND FHandle;
    string FClassName;
    bool FStop;
    bool _prop_VisibleOnly;
    THI_Event *_data_Caption;
    THI_Event *_event_onEndEnum;
    THI_Event *_event_onFindWindow;

    HI_WORK_LOC(THIWinEnum,_work_doEnum);
    HI_WORK_LOC(THIWinEnum,_work_doFind);
    HI_WORK(_work_doStop){ _hie(THIWinEnum)->FStop = true; }

    HI_WORK( _var_Handle){ CreateData(_Data,(int)_hie(THIWinEnum)->FHandle); }
    HI_WORK( _var_ClassName){ CreateData(_Data,_hie(THIWinEnum)->FClassName); }
    HI_WORK( _var_GetActiveWindow){ CreateData(_Data,(int)GetForegroundWindow()); }
};

//######################################################################

string THIWinEnum::ReadParam()
{
   HI_RSTRING buf[512];
   buf[ GetWindowText(FHandle,buf,512) ] = 0;
   string Result(buf);

   buf[ GetClassName(FHandle,buf,512) ] = 0;
   FClassName = buf;

   return Result;
}

void THIWinEnum::_work_doFind(TData &_Data,WORD Index)
{
   FHandle = FindWindow(NULL,PChar(ReadString(_Data,_data_Caption,string(_his("")))));
   if( FHandle )
     _hi_onEvent(_event_onFindWindow,ReadParam());
}

void THIWinEnum::_work_doEnum(TData &_Data,WORD Index)
{                              //'ProgMan','Program Manager'
   FStop = false;             //FindWindow(_his("Today"),_his(""))
   FHandle = GetWindow(GetForegroundWindow(),GW_HWNDFIRST);
   bool fl;
   while( !FStop && FHandle )
   {
      fl = true;
      if( _prop_VisibleOnly == 0 )
        fl &= IsWindowVisible(FHandle);

      if( fl ) _hi_onEvent(_event_onFindWindow,ReadParam());

      FHandle = GetWindow(FHandle,GW_HWNDNEXT);
   }
   _hi_onEvent(_event_onEndEnum);
}
