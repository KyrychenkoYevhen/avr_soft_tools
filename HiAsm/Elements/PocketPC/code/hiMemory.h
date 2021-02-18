#include "share.h"

class THIMemory:public TDebug
{
   private:

   public:
    TData FData;
    TData FDefault;
    THI_Event *_event_onData;

    HI_WORK_LOC(THIMemory,_work_doValue)
    {
      FData = _Data;
      TData dt = FData;
      _hi_onEvent(_event_onData,dt);
    }
    HI_WORK_LOC(THIMemory,_work_doClear)
    {
      FData = FDefault;
      TData dt = FData;
      _hi_onEvent(_event_onData,dt);
    }
    HI_WORK(_var_Value){ CreateData(_Data,_hie(THIMemory)->FData); }

    void SetData(TData &Value){ FDefault = Value; FData = FDefault; }
    __declspec( property( put = SetData ) )TData _prop_Default;
};
