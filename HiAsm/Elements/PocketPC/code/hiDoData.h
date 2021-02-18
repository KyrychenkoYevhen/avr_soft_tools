#include "share.h"

class THIDoData:public TDebug
{
   private:
   public:
    TData _prop_Data;
    THI_Event *_data_Data;
    THI_Event *_event_onEventData;

    HI_WORK_LOC(THIDoData,_work_doData)
    {
      _Data.data_type = data_null;
      _hi_onEvent(_event_onEventData,ReadData(_Data,_data_Data,&_prop_Data));
    }
};




