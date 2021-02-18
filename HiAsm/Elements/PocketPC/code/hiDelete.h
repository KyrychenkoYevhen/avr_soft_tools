#include "share.h"

class THIDelete:public TDebug
{
   private:
   public:
    int _prop_Position;
    int _prop_Count;

    THI_Event *_data_Count;
    THI_Event *_data_Position;
    THI_Event *_data_Str;
    THI_Event *_event_onDelete;

    HI_WORK_LOC(THIDelete,_work_doDelete);
};

////////////////////////////////////////////////////////////////

void THIDelete::_work_doDelete(TData &_Data,WORD Index)
{
    string str = ReadString(_Data,_data_Str,string(_his("")));
    if( !str.Empty() )
    {
       int Pos = ReadInteger(_Data,_data_Position,_prop_Position);
       int Count = ReadInteger(_Data,_data_Count,_prop_Count);
       _hi_onEvent(_event_onDelete,str.Delete(Pos,Count));
    }
}
