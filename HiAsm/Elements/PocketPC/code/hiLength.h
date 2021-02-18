#include "share.h"

class THILength:public TDebug
{
   private:
    int FResult;
   public:
    THI_Event *_data_Str;
    THI_Event *_event_onLength;

    HI_WORK_LOC(THILength,_work_doLength);
    HI_WORK(_var_Result)
    {
      CreateData(_Data,_hie(THILength)->FResult);
    }
};

///////////////////////////////////////////////////////////////////

void THILength::_work_doLength(TData &_Data,WORD Index)
{
   FResult = ReadString(_Data,_data_Str,string(_his(""))).Length();
   _hi_onEvent(_event_onLength,FResult);
}
