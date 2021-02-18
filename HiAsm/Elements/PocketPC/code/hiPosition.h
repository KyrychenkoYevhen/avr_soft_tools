#include "share.h"

class THIPosition:public TDebug
{
   private:
    int FPos;
   public:
    string _prop_Target;
    int _prop_StartPos;
    bool _prop_ZeroPos;
    bool _prop_ShortSearch;

    THI_Event *_data_StartPos;
    THI_Event *_data_Target;
    THI_Event *_data_Str;
    THI_Event *_event_onSearch;

    HI_WORK_LOC(THIPosition,_work_doSearch);
    HI_WORK_LOC(THIPosition,_work_doReset);
    HI_WORK(_var_Position){ CreateData(_Data,_hie(THIPosition)->FPos); }
};

//////////////////////////////////////////////////////////////

void THIPosition::_work_doSearch(TData &_Data,WORD Index)
{
   string Str = ReadString(_Data,_data_Str,string(_his("")));
   string Target = ReadString(_Data,_data_Target,_prop_Target);
   if( (!_prop_ShortSearch) || (FPos == 0) )
     FPos = ReadInteger(_Data,_data_StartPos,_prop_StartPos);

   if( FPos <= 0) FPos = 1; //это для дуракоустойчивости

   if( !Str.Empty() && !Target.Empty() )
     FPos = Str.PosEx(Target,FPos);
   else FPos = 0;

   if( (_prop_ZeroPos) || (FPos > 0) )
     _hi_onEvent(_event_onSearch,FPos);
   if( FPos ) FPos += Target.Length();
}

void THIPosition::_work_doReset(TData &_Data,WORD Index)
{
  FPos = ReadInteger(_Data,_data_StartPos,_prop_StartPos);
}
