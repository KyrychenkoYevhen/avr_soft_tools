#include "share.h"

class THIBlockFind:public TDebug
{
   private:
   public:
    bool _prop_IncludeBlock;
    bool _prop_Delete;
    string _prop_ReplaceStr;
    bool _prop_UserReplace;
    string _prop_StartBlock;
    string _prop_EndBlock;

    THI_Event *_data_Replace;
    THI_Event *_data_Text;
    THI_Event *_event_onEndSearch;
    THI_Event *_event_onSearch;

    HI_WORK_LOC(THIBlockFind,_work_doSearch);
};

////////////////////////////////////////////////////////////////////////

void THIBlockFind::_work_doSearch(TData &_Data, WORD Index)
{
  string Text = ReadString(_Data,_data_Text,string(_his("")));
  int i = Text.PosEx(_prop_StartBlock,1);
  while( i > 0 )
  {
     int j = Text.PosEx(_prop_EndBlock,i + _prop_StartBlock.Length());
     if( j > 0 )
     {
        if( _prop_IncludeBlock )
          _hi_onEvent(_event_onSearch,Text.Copy(i,j - i + _prop_EndBlock.Length()));
        else  _hi_onEvent(_event_onSearch,Text.Copy(i + _prop_StartBlock.Length(),j - i - _prop_StartBlock.Length()));

        if( !_prop_Delete )
          j += _prop_EndBlock.Length();
        else
          if( !_prop_UserReplace ||( _prop_UserReplace &&(ReadInteger(_Data,_data_Replace,0) != 0) ))
          {
              if( _prop_IncludeBlock )
                Text.Delete(i,j -i + _prop_EndBlock.Length());
              else
              {
                  i += _prop_StartBlock.Length();
                  Text.Delete(i,j-i);
              }
              if( !_prop_ReplaceStr.Empty() )
                Text.Insert(i,_prop_ReplaceStr);
              j = i + _prop_ReplaceStr.Length();
          }
        i = Text.PosEx(_prop_StartBlock,j);
     }
     else i = 0;
   }
  _hi_CreateEvent(_Data,_event_onEndSearch,Text);
}
