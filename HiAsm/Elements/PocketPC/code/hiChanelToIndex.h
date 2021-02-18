#include "share.h"

class THIChanelToIndex:public TDebug
{
   private:
    TData dt;
   public:
    int _prop_Count;
    THI_Event *_event_onIndex;

    HI_WORK(doWork)
    {
      CreateData(_hie(THIChanelToIndex)->dt,_Data);
      _hi_CreateEvent(_Data,_hie(THIChanelToIndex)->_event_onIndex,Index);
    }
    HI_WORK(_var_Data)
    {
       CreateData(_Data,_hie(THIChanelToIndex)->dt);
    }
};

////////////////////////////////////////////////////////////////

