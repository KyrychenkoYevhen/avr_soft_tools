#ifndef _LABEL_
#define _LABEL_
#include "win.h"

typedef void (__stdcall *_sdk_init)(HANDLE h);
typedef int (__stdcall *_sdk_msg)(void *msg);
typedef void (__stdcall *_sdk_command)(char *cmd, char **param);

class THIHiAsmSDK:public THIWin
{
  private:
   HINSTANCE lib;
   _sdk_init sdk_init;
   _sdk_msg sdk_msg;
   _sdk_command sdk_command;

   ON_PROC_LOC(THIHiAsmSDK, _OnMessage)
   {
     sdk_msg(Param);
   }
  protected:

  public:
     THI_Event *_data_Command;
     THI_Event *_data_Param;

     THIHiAsmSDK(TWinControl *Parent);
     HI_WORK(_work_doLoadFromFile) {
       char *param[1];
       string s = ToString(_Data);
       param[0] = (char*)malloc(sizeof(char)*(s.Length()+1));
       UtoA(s.c_str(), param[0], s.Length());
       _hie(THIHiAsmSDK)->sdk_command("open", (char**)param);
       free(param[0]);
     }
     HI_WORK(_work_doSaveToFile) {
       char *param[1];
       string s = ToString(_Data);
       param[0] = (char*)malloc(sizeof(char)*(s.Length()+1));
       UtoA(s.c_str(), param[0], s.Length());
       _hie(THIHiAsmSDK)->sdk_command("save", (char**)param);
       free(param[0]);
     }
     HI_WORK(_work_doCommand) {
       char cmd[256];
       char **param = NULL;
       UtoA(ReadString(_Data, _hie(THIHiAsmSDK)->_data_Command, string(_his(""))).c_str(), cmd, 256);
       string s = ReadString(_Data, _hie(THIHiAsmSDK)->_data_Command, string(_his("")));
       if(s.Length()) {  
         param = (char**)malloc(sizeof(char*));
         param[0] = (char*)malloc(sizeof(char)*(s.Length()+1)); 
         UtoA(s.c_str(), param[0], s.Length());
       }
       _hie(THIHiAsmSDK)->sdk_command(cmd, param);
       if(param) {
         free(param[0]);
         free(param);
       }
     }
/*     HI_WORK(_var_Caption)
     {
        CreateData(_Data,_hie(THILabel)->Control->Caption);
     }
*/
};

//#############################################################################

#include "aygshell.h"

THIHiAsmSDK::THIHiAsmSDK(TWinControl *Parent)
{
   Control = new TPanel(Parent);
   ((TPanel *)Control)->OnMessage = DoNotifyEvent(this,_OnMessage);
   
   lib = LoadLibrary(_his("hiasm_sdk.dll"));
   
   sdk_init = (_sdk_init)GetProcAddress(lib, _his("sdk_init"));
   sdk_msg = (_sdk_msg)GetProcAddress(lib, _his("sdk_msg"));
   sdk_command = (_sdk_command)GetProcAddress(lib, _his("sdk_command"));
   
   sdk_init(Control->Handle);
   
   int dwState = (SHFS_HIDETASKBAR | SHFS_HIDESTARTICON | SHFS_HIDESIPBUTTON);
   SHFullScreen(Parent->Handle, dwState);

   RECT rc;
   SetRect(&rc, 0, 0, GetSystemMetrics(SM_CXSCREEN), GetSystemMetrics(SM_CYSCREEN));
   MoveWindow(Parent->Handle, rc.left, rc.top, rc.right-rc.left, rc.bottom-rc.top, TRUE);
}
#endif
