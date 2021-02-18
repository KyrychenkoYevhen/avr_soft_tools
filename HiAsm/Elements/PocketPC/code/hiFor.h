#include "share.h" 

class THIFor: public TDebug 
{ 
  private: 
   int i;
   int rStart, rEnd; 
  public: 
   int _prop_Start, _prop_End, _prop_Step;
   bool _prop_IncludeEnd, _prop_InData; 
    
   THI_Event *_data_Start, *_data_End; 
   THI_Event *_event_onEvent, * _event_onStop; 
    
   HI_WORK_LOC(THIFor,_work_doFor);
   HI_WORK_LOC(THIFor,_work_doStop) { rEnd = i; }
   HI_WORK(_var_Position) { CreateData(_Data,_hie(THIFor)->i); }
};

//////////////////////////////////////////////////////////////////////

void THIFor::_work_doFor(TData &_Data,WORD Index)
{
     if (!_prop_InData) 
       _Data.data_type = data_null; 
     rStart = ReadInteger(_Data,_data_Start,_prop_Start); 
     rEnd = ReadInteger(_Data,_data_End,_prop_End); 
     if(!_prop_IncludeEnd)
       rEnd -= _prop_Step; 
     i = rStart; 

     if (_prop_Step > 0) 
      for(;i <= rEnd;i += _prop_Step)
       _hi_onEvent(_event_onEvent,i);
     else if (_prop_Step < 0)
      for(;i >= rEnd;i += _prop_Step)
        _hi_onEvent(_event_onEvent,i);

     _hi_CreateEvent(_Data,_event_onStop,i);
}
