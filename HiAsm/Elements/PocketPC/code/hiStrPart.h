#include "share.h"

class THIStrPart:public TDebug
{
   private:
    string FLeft;
   public:
    string _prop_Char;

    THI_Event *_data_Str;
    THI_Event *_event_onPart;
    THI_Event *_event_onSplit;
    THI_Event *_event_onNotFound;

    HI_WORK_LOC(THIStrPart,_work_doSplit);
    HI_WORK(_var_Left){ CreateData(_Data,_hie(THIStrPart)->FLeft); }
};

///////////////////////////////////////////////////////////////////////////

void THIStrPart::_work_doSplit(TData &_Data,WORD Index)
{
  string str = ReadString(_Data,_data_Str,string(_his("")));

  if( !_prop_Char.Empty() )
   if( str.PosEx(_prop_Char,1) == 0 )
      _hi_CreateEvent(_Data,_event_onNotFound,str);
   else if( !str.Empty() )
   {
      FLeft = str.GetTok(_prop_Char);
      _hi_onEvent(_event_onPart,FLeft);
      _hi_onEvent(_event_onSplit,str);
   }
}
