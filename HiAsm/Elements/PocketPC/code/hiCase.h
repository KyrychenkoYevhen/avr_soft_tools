#include "share.h"

class THICase:public TDebug
{
   private:
   public:
    TData _prop_Value;
    THI_Event *_event_onTrue;
    THI_Event *_event_onNextCase;

    HI_WORK_LOC(THICase,_work_doCase)
    {
      if( _Data == _prop_Value  )
        _hi_onEvent(_event_onTrue);
      else _hi_onEvent(_event_onNextCase,_Data);
    }
};
