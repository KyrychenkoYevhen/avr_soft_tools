#include "share.h"

class THIReplace:public TDebug
{
   private:
   public:
    string _prop_SubStr;
    string _prop_DestStr;

    THI_Event *_data_Dest;
    THI_Event *_data_Sub_str;
    THI_Event *_data_Str;
    THI_Event *_event_onReplace;

    HI_WORK_LOC(THIReplace,_work_doReplace);
};

//////////////////////////////////////////////////////////////////

void THIReplace::_work_doReplace(TData &_Data,WORD Index)
{
    string str = ReadString(_Data,_data_Str,string(_his("")));
    string substr = ReadString(_Data,_data_Sub_str,_prop_SubStr);
    string dest = ReadString(_Data,_data_Dest,_prop_DestStr);

    if( !str.Empty() )
      str.Replace(substr,dest);

    _hi_onEvent(_event_onReplace,str);
}
