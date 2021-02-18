#ifndef __HIMESSAGE_H_
#define __HIMESSAGE_H_

#include <Windows.h>
#include "Share.h"

class THIMessage
{
 private:

 protected:
	
 public:
  int _prop_Type;
  int _prop_Icon;
  string _prop_Caption;
  string _prop_Message;

  THI_Event *_event_onMessage;
  THI_Event *_data_Message;
  THI_Event *_data_Caption;

  HI_WORK_LOC(THIMessage,_work_doMessage);
};

//#############################################################################

const MType[] = {MB_OK,MB_OKCANCEL,MB_YESNO,MB_YESNOCANCEL,MB_RETRYCANCEL,MB_ABORTRETRYIGNORE };
const MIcon[] = {0,MB_ICONHAND,MB_ICONQUESTION,MB_ICONEXCLAMATION,MB_ICONASTERISK,};

void THIMessage::_work_doMessage(TData &_Data,USHORT Index)
{
   int Res = MessageBox(ReadHandle,
               PChar(ReadString(_Data,_data_Message,_prop_Message)),
               PChar(ReadString(_Data,_data_Caption,_prop_Caption)),MType[_prop_Type]|MIcon[_prop_Icon]);
   _hi_onEvent(_event_onMessage,Res);
}

#endif

