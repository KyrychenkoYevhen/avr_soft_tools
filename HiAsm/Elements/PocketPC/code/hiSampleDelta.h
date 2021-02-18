#include "share.h"

class THISampleDelta:public TDebug
{
   private:
    TData Store;
   public:
    THI_Event *_data_Data;
    THI_Event *_event_onCalcDelta;

    HI_WORK_LOC(THISampleDelta,_work_doCalcDelta);
};

//////////////////////////////////////////////////////////////////////////

void THISampleDelta::_work_doCalcDelta(TData &_Data, WORD Index)
{
   TData dt = ReadData(_Data,_data_Data,NULL);
   switch( Store.data_type )
   {
     case data_int:
       _hi_CreateEvent(_Data,_event_onCalcDelta,-Store.idata + dt.idata);
       break;
     case data_real:
       _hi_CreateEvent(_Data,_event_onCalcDelta,-Store.rdata + dt.rdata);
   }
   Store.data_type = dt.data_type;
   Store.idata = dt.idata;
   Store.rdata = dt.rdata;
}
