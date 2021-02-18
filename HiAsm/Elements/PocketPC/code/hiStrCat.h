#include "share.h"

class THIStrCat:public TDebug
{
   private:
   public:
    string _prop_Str1;
    string _prop_Str2;

    THI_Event *_data_Str2;
    THI_Event *_data_Str1;
    THI_Event *_event_onStrCat;

    HI_WORK_LOC(THIStrCat,_work_doStrCat);
};

///////////////////////////////////////////////////////////////

void THIStrCat::_work_doStrCat(TData &_Data,WORD Index)
{
    string s1 = ReadString(_Data,_data_Str1,_prop_Str1);
    string s2 = ReadString(_Data,_data_Str2,_prop_Str2);

    _hi_onEvent(_event_onStrCat,s1 + s2);
}
