#ifndef __HICOUNTER_H_
#define __HICOUNTER_H_

class  THICounter
{
   private:
    int FCounter;
   public:
    int _prop_Min;
    int _prop_Max;
    int _prop_Step;
    BYTE _prop_Type;
    THI_Event *_data_Min;
    THI_Event *_data_Max;
    THI_Event *_event_onNext;

    HI_WORK_LOC(THICounter,_work_doNext);
    HI_WORK_LOC(THICounter,_work_doPrev);
    HI_WORK_LOC(THICounter,_work_doReset);
    HI_WORK_LOC(THICounter,_work_doMax);
    HI_WORK_LOC(THICounter,_work_doMin);
    HI_WORK_LOC(THICounter,_work_doValue){ FCounter = ToInteger(_Data); }
    HI_WORK_LOC(THICounter,_var_Count);

    void SetCounter(int Value){ FCounter = Value; }
    __declspec( property( put = SetCounter ) ) int _prop_Default;
};

//#############################################################################

void THICounter::_work_doNext(TData &_Data,USHORT Index)
{
   if( _prop_Type == 0)
     FCounter = (FCounter >= _prop_Max)?_prop_Min:FCounter + _prop_Step;
   else FCounter = (FCounter <= _prop_Min)?_prop_Max:FCounter - _prop_Step;
   _hi_onEvent(_event_onNext,FCounter);
}

void THICounter::_work_doPrev(TData &_Data,USHORT Index)
{
   BYTE old = _prop_Type;
   _prop_Type = (int)(!old);
   _work_doNext(_Data,Index);
   _prop_Type = old;
}

void THICounter::_work_doReset(TData &_Data,USHORT Index)
{
   FCounter = (_prop_Type)?_prop_Max:_prop_Min;
}

void THICounter::_work_doMax(TData &_Data,USHORT Index)
{
   _prop_Max = ReadInteger(_Data,_data_Max,0);
}

void THICounter::_work_doMin(TData &_Data,USHORT Index)
{
    _prop_Min = ReadInteger(_Data,_data_Min,0);
}

void THICounter::_var_Count(TData &_Data,USHORT Index)
{
    CreateData(_Data,FCounter);
}

#endif
