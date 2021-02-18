#include "share.h"

class THIService
{
   private:
   public:
    bool SStop;
    HICON _prop_Icon;
    bool _prop_Wait;

    THI_Event *_event_onStop;
    THI_Event *_event_onStart;

    void Start();
    HI_WORK_LOC(THIService,_work_doStop);
};

////////////////////////////////////////////////////////////////////

void THIService::Start()
{
   EventOn;
   _hi_onEvent(_event_onStart);
   SStop = false;
   MSG Msg;
   if( _prop_Wait )
    while( GetMessage( &Msg,0,0,0 ) && !SStop )
    {
     TranslateMessage( &Msg );
     DispatchMessage( &Msg );
    }
   _hi_onEvent(_event_onStop);
   EventOff;
}


void THIService::_work_doStop(TData &_Data,WORD Index)
{
  SStop = true;
  //NewTimer(1).Enabled := true;
}
