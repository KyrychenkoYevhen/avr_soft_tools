#include "share.h"

class THIWinExec:public TDebug
{
   private:
   public:
    string _prop_Param;
    string _prop_FileName;
    BYTE _prop_Mode;
    BYTE _prop_RunEvent;

    THI_Event *_data_Params;
    THI_Event *_data_FileName;
    THI_Event *_event_onExec;

    HI_WORK_LOC(THIWinExec,_work_doExec);
    HI_WORK_LOC(THIWinExec,_work_doShellExec);
};

///////////////////////////////////////////////////////////////////////

void THIWinExec::_work_doExec(TData &_Data, WORD Index)
{
  string Fn = ReadFileName(ReadString(_Data,_data_FileName,_prop_FileName));
  string pr = ReadString(_Data,_data_Params,_prop_Param);

  PROCESS_INFORMATION p;
  STARTUPINFOW Si;

  ZeroMemory( &Si, sizeof( Si ));
  Si.cb = sizeof(Si);
  Si.dwFlags = 1;
  Si.wShowWindow = _prop_Mode;

  CreateProcess(PChar(Fn),PChar(pr), NULL, NULL,false, 0, NULL, NULL, &Si, &p);
  if( _prop_RunEvent == 1 )
    WaitForSingleObject(p.hProcess, INFINITE);
  _hi_CreateEvent(_Data,_event_onExec);
}

void THIWinExec::_work_doShellExec(TData &_Data, WORD Index)
{
   string Fn = ReadFileName(ReadString(_Data,_data_FileName,_prop_FileName));
   SHELLEXECUTEINFO si;
   ZeroMemory( &si, sizeof( si ));
   si.cbSize = sizeof(si);
   si.lpFile = PChar(Fn);
   si.nShow = SW_SHOWNORMAL;
   si.lpVerb = _his("open");
   ShellExecuteEx(&si); //0,_his("open"),pchar(Fn),NULL,NULL,SW_SHOWNORMAL);
}
