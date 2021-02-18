#include "share.h"

class THIEventFromData:public TDebug
{
   private:
    TData dt;
   public:
    THI_Event *_data_Data;
    THI_Event *_event_onEvent;

    HI_WORK(_work_doData)
    {
       _hie(THIEventFromData)->dt = ReadData(_Data,_hie(THIEventFromData)->_data_Data,NULL);
    }
    HI_WORK(_var_GetData)
    {
       _hi_onEvent(_hie(THIEventFromData)->_event_onEvent,_Data);
       _Data = _hie(THIEventFromData)->dt;
    }
};

////////////////////////////////////////////////////////////////
