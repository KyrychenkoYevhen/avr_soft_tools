#include "share.h"

class THIIndexToChanel:public TDebug
{
   private:
    int FCount;
   public:
    TData _prop_Data;
    THI_Event *_data_Data;
    THI_Event *_data_Index;
    THI_Event **onEvent;

    HI_WORK_LOC(THIIndexToChanel,_work_doEvent);
    void SetCount(int Value);
    __declspec( property( put = SetCount )) int _prop_Count;
};

////////////////////////////////////////////////////////////////

void THIIndexToChanel::SetCount(int Value)
{
   if( Value > 0 )
   {
      onEvent = (THI_Event **)new int[Value];;
      FCount = Value;
   }
   else FCount = 0;
}

void THIIndexToChanel::_work_doEvent(TData &_Data,WORD Index)
{
   int ind = ReadInteger(_Data,_data_Index,0);
   TData dt = ReadData(_Data,_data_Data,&_prop_Data);
   if( (ind >= 0)&&(ind < FCount) )
     _hi_CreateEvent(_Data,onEvent[ind],dt);
}
