#include "share.h"

class THISwitch:public TDebug
{
   private:
    bool State;
    TData _dat;
    TData _Dataoff;
   public:
    TData _prop_DataOn;

    THI_Event *_data_DataOff;
    THI_Event *_data_DataOn;
    THI_Event *_event_onOff;
    THI_Event *_event_onOn;
    THI_Event *_event_onSwitch;

    HI_WORK_LOC(THISwitch,_work_doSwitch);
    HI_WORK(_work_doReset)
    {
      if( _hie(THISwitch)->State )
        _hie(THISwitch)->_work_doSwitch(_Data,0);
    }
    HI_WORK(_var_State){ CreateData(_Data,_hie(THISwitch)->_dat); }
    void SetOff(TData &Value);
    __declspec( property( put = SetOff ) )TData _prop_DataOff;
    void SetState(BYTE Value);
    __declspec( property( put = SetState ) )BYTE _prop_Default;
};

////////////////////////////////////////////////////////////

void THISwitch::SetOff(TData &Value)
{
   CreateData(_Dataoff,Value);
   CreateData(_dat,Value);
}

void THISwitch::SetState(BYTE Value)
{
   if( Value == 0 )
   {
     State = true;
     CreateData(_dat,_prop_DataOn);
   }
}

void THISwitch::_work_doSwitch(TData &_Data,WORD Index)
{
   _Data.data_type = data_null;
   TData _On = ReadData(_Data,_data_DataOn,&_prop_DataOn);
   TData _Off = ReadData(_Data,_data_DataOff,&_Dataoff);
   State = !State;
   THI_Event *e;
   if( State )
   {
     CreateData(_dat,_On);
     _hi_onEvent(_event_onSwitch,_On);
     e = _event_onOn;
   }
   else
   {
     CreateData(_dat,_Off);
     _hi_onEvent(_event_onSwitch,_Off);
     e = _event_onOff;
   }

   TData tmp;
   CreateData(tmp,_dat);
   _hi_onEvent(e,tmp);
}
