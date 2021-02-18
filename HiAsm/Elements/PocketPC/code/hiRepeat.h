#include "If_arg.h" 

class THIRepeat: public TDebug 
{ 
  private: 
    bool FStop; 
  public: 
   BYTE _prop_Type;
   TData _prop_Op1, _prop_Op2; 
   BYTE _prop_Check; 
   THI_Event *_data_Op1, *_data_Op2, *_event_onRepeat; 

   HI_WORK_LOC(THIRepeat, _work_doRepeat);
   HI_WORK(_work_doStop){ _hie(THIRepeat)->FStop = true; }
};

/////////////////////////////////////////////////////////////////////

void THIRepeat::_work_doRepeat(TData &_Data,WORD Index)
{
      FStop = false;
      if (_prop_Check == 0) 
        while ((!FStop) && Compare( ReadData(_Data,_data_Op1, &_prop_Op1), ReadData(_Data,_data_Op2,&_prop_Op2),_prop_Type)) 
         _hi_onEvent(_event_onRepeat); 
      else 
        do { 
          _hi_onEvent(_event_onRepeat); 
        } while ((!FStop) && Compare( ReadData(_Data,_data_Op1, &_prop_Op1), ReadData(_Data,_data_Op2,&_prop_Op2),_prop_Type));
}
