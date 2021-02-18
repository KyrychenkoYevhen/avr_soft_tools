#include "share.h"

class THIGetIndexData:public TDebug
{
   private:
    int FIndex;
    int FCount;
   public:
    THI_Event **Data;

    HI_WORK_LOC(THIGetIndexData,_work_doIndex);
    HI_WORK_LOC(THIGetIndexData,_var_Var);

    void SetCount(int Value);
    __declspec( property( put = SetCount) ) int _prop_Count;
};

////////////////////////////////////////////////////////////////

void THIGetIndexData::_work_doIndex(TData &_Data,WORD Index)
{
   int ind = ToInteger(_Data);
   if( (ind >= 0)&&(ind < FCount) )
    FIndex = ind;
   else FIndex = -1;
}

void THIGetIndexData::_var_Var(TData &_Data,WORD Index)
{
   if( FIndex != -1 )
     _ReadData(_Data,Data[FIndex]);
   else _Data.data_type = data_null;
}

void THIGetIndexData::SetCount(int Value)
{
   FCount = Value;
   Data = EventArray(Value);
   FIndex = -1;
}
