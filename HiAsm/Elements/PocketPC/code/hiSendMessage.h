#include "share.h"

class THISendMessage:public TDebug
{
   private:
   public:
    DWORD _prop_Message;
    WPARAM _prop_WParam;
    LPARAM _prop_LParam;

    THI_Event *_data_Message;
    THI_Event *_data_LParam;
    THI_Event *_data_WParam;
    THI_Event *_data_Handle;
    THI_Event *_event_onSend;

    HI_WORK_LOC(THISendMessage,_work_doSendMessage);
};

void THISendMessage::_work_doSendMessage(TData &_Data,WORD Index)
{
  HWND h = (HWND)ReadInteger(_Data,_data_Handle,0);
  WPARAM w = ReadInteger(_Data,_data_WParam,_prop_WParam);
  LPARAM l = ReadInteger(_Data,_data_LParam,_prop_LParam);
  _hi_onEvent(_event_onSend,SendMessage(h,ReadInteger(_Data,_data_Message,_prop_Message),w,l) );
}
