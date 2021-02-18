#include "share.h"
#include <stdlib.h>

class THIRandom
{
   private:
    int FRnd;
   public:
    int _prop_Min;
    int _prop_Max;

    THI_Event *_event_onRandom;

    HI_WORK_LOC(THIRandom,_work_doRandom)
    {
       FRnd = (rand()/(float)RAND_MAX)*(_prop_Max - _prop_Min + 1) + _prop_Min;
       _hi_onEvent(_event_onRandom,FRnd);
    }
    HI_WORK(_work_doRandomize){ srand(GetTickCount()); }
    HI_WORK(_work_doMin){ _hie(THIRandom)->_prop_Min = ToInteger(_Data); }
    HI_WORK(_work_doMax){ _hie(THIRandom)->_prop_Max = ToInteger(_Data); }
    HI_WORK(_var_Random){ CreateData(_Data,_hie(THIRandom)->FRnd); }
};

//#############################################################################


