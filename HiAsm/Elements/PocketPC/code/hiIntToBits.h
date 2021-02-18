#include "share.h" 

class THIIntToBits: public TDebug 
{ 
 private:
 public:
    WORD FCount; 
    void SetCount(WORD Value); 

    TData _prop_Data_0; 
    TData _prop_Data_1; 
    bool _prop_ZeroBits; 
    BYTE _prop_Direct; 

    THI_Event *_data_Value; 
    THI_Event **onBit; 

    HI_WORK_LOC(THIIntToBits, _work_doBits); 
    HI_WORK_LOC(THIIntToBits, _work_doBitsRev); 
    __declspec( property (put = SetCount) ) WORD _prop_Count; 
}; 

void THIIntToBits::SetCount(WORD Value) 
{ 
  onBit = EventArray(Value);
  FCount = Value; 
} 

void THIIntToBits::_work_doBits(TData &_data, WORD Index) 
{ 
  TData dt;

  int val = ReadInteger(_data,_data_Value,0);
  for (int i = 0; i < FCount; i++)
  {
    if (((val >> i) & 1) == 1) 
    { 
      dt = _prop_Data_1; 
      _hi_onEvent(onBit[i], dt);
    } 
    else 
      if (_prop_ZeroBits) 
      { 
        dt = _prop_Data_0; 
        _hi_onEvent(onBit[i], dt);
      } 
  }
} 

void THIIntToBits::_work_doBitsRev(TData &_data, WORD Index) 
{ 
  TData dt;

  int val = ReadInteger(_data,_data_Value,0);
   for (int i = FCount-1; i > -1; i--)
   { 
    if (((val >> i) & 1) == 1) 
    { 
      dt = _prop_Data_1; 
      _hi_onEvent(onBit[i], dt);
    } 
    else 
      if (_prop_ZeroBits) 
      { 
        dt = _prop_Data_0; 
        _hi_onEvent(onBit[i], dt);
      } 
   } 
}
