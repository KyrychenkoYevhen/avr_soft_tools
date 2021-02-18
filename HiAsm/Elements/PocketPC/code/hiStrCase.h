#include "share.h"

class THIStrCase:public TDebug
{
   public:
    BYTE _prop_Type;

    THI_Event *_data_Str;
    THI_Event *_event_onModify;

    HI_WORK_LOC(THIStrCase,_work_doModify);
};

//////////////////////////////////////////////////////////////////////

void THIStrCase::_work_doModify(TData &_Data,WORD Index)
{
   string str = ReadString(_Data,_data_Str,string(_his("")));
   if( _prop_Type )
    str.Lower();
   else str.Upper();
   _hi_CreateEvent(_Data,_event_onModify,str);
}
