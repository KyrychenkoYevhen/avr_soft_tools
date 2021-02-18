#include "share.h" 
#include "If_arg.h" 

class THIIf_else: public TDebug
{ 
  private: 
  public: 
   BYTE _prop_Type;
   TData _prop_Op1, _prop_Op2;
    
   THI_Event *_data_Op1, *_data_Op2;
   THI_Event *_event_onTrue, *_event_onFalse;
    
   HI_WORK_LOC(THIIf_else,_work_doCompare);
};

////////////////////////////////////////////////////////////////

void THIIf_else::_work_doCompare(TData &_Data,WORD Index)
{
   TData op1,op2,dt;
   dt = _Data;
   op1 = ReadData(_Data,_data_Op1,&_prop_Op1);
   op2 = ReadData(_Data,_data_Op2,&_prop_Op2);
   if( Compare(op1, op2, _prop_Type) )
    _hi_CreateEvent(_Data,_event_onTrue, dt);
   else
    _hi_CreateEvent(_Data,_event_onFalse, dt);
}
