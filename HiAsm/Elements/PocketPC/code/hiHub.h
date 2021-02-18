#ifndef _HUB_
#define _HUB_
#include "share.h"

class THIHub:public TDebug
{
   private:
     BYTE FOutCount;

   public:
     BYTE _prop_InCount;
     THI_Event **onEvent;

     HI_WORK_LOC(THIHub,doEvent);
     void SetOC(int Value){ onEvent = EventArray(Value); FOutCount = Value;  }
     __declspec( property( put = SetOC ) ) int _prop_OutCount;
};

//#############################################################################

void THIHub::doEvent(TData &_Data,WORD Index)
{
   TData dt;
   for(int i = 0; i < FOutCount; i++)
   {
     CreateData(dt,_Data);
     _hi_onEvent(onEvent[i],dt);
   }
}
#endif
