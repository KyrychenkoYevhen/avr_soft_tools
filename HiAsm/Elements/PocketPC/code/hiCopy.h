#include "share.h"

class THICopy:public TDebug
{
   public:
    int _prop_Position;
    int _prop_Count;

    THI_Event *_data_Count;
    THI_Event *_data_Position;
    THI_Event *_data_Str;
    THI_Event *_event_onCopy;

    HI_WORK_LOC(THICopy,_work_doCopy);
};

//////////////////////////////////////////////////////////////////////////

void THICopy::_work_doCopy(TData &_Data,WORD Index)
{
    string str = ReadString(_Data,_data_Str,string(_his("")));
    if( !str.Empty() )
    {
       int Pos = ReadInteger(_Data,_data_Position,_prop_Position);
       int Count = ReadInteger(_Data,_data_Count,_prop_Count);
       _hi_CreateEvent(_Data,_event_onCopy,str.Copy(Pos,Count));
    }
}
