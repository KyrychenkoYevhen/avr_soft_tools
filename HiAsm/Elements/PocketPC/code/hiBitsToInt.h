#include "share.h" 

class THIBitsToInt: public TDebug 
{ 
  private: 
    WORD FCount; 
  public: 
    THI_Event **Bit;
    THI_Event *_event_onNumber;

    HI_WORK_LOC(THIBitsToInt, _work_doNumber); 
    HI_WORK_LOC(THIBitsToInt, _var_Number); 
    void SetCount(int Value); 
    __declspec( property( put = SetCount ) ) int _prop_Count; 
}; 

//################################################ 

void THIBitsToInt::_work_doNumber(TData &_Data,USHORT Index) 
{ 
  int val = 0;
  for(int i = 0; i < FCount; i++)
    val += (BYTE) ((ReadInteger(_Data,Bit[i],0) != 0) << i);
  _hi_CreateEvent(_Data,_event_onNumber,val);
} 


void THIBitsToInt::_var_Number(TData &_Data,USHORT Index) 
{ 
  int val = 0;
  for (int i = 0; i < FCount; i++)
    val += (BYTE) ((ReadInteger(_Data,Bit[i],0) != 0) << i);
  CreateData(_Data,val);
}

void THIBitsToInt::SetCount(int Value) 
{ 
   FCount = Value; 
   Bit = EventArray(Value);
}
