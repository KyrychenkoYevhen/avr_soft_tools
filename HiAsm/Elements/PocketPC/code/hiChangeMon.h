#include "share.h"

class THIChangeMon:public TDebug
{
   private:
    //TData _Dt;
    bool CmpData(TData &D1,TData &D2);
    //void SetData(const Value:TData);
   public:
    TData _prop_Data;
    THI_Event *_data_Data;
    THI_Event *_event_onData;

    HI_WORK_LOC(THIChangeMon,_work_doData);
    //property _prop_Data:TData write SetData;
};

//////////////////////////////////////////////////////////////

bool THIChangeMon::CmpData(TData &D1,TData &D2)
{
   if( D1.data_type == D2.data_type )
    switch( D1.data_type )
    {
      case data_null: return true;
      case data_int : return D1.idata == D2.idata;
      case data_str : return D1.sdata == D2.sdata;
      case data_real: return D1.rdata == D2.rdata;
    }
   else return false;
}

void THIChangeMon::_work_doData(TData &_Data,WORD Index)
{
  TData dt = ReadData(_Data,_data_Data,NULL);
  if( !CmpData(_prop_Data,dt) )
  {
     CreateData(_prop_Data,dt);
     _hi_onEvent(_event_onData,dt);
  }
}
