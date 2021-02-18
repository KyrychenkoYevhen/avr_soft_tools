#include "share.h"

class THIFormatStr:public TDebug
{
   private:
    int FDataCount;
   public:
    THI_Event **Str;
    string _prop_Mask;
    BYTE _prop_Mode;

    THI_Event *_event_onFString;

    HI_WORK_LOC(THIFormatStr,_work_doString);
    HI_WORK(_work_doMask){ _hie(THIFormatStr)->_prop_Mask = ToString(_Data); }
    void SetCount(int Value);
    __declspec( property ( put = SetCount )) int _prop_DataCount;
};

///////////////////////////////////////////////////////////////////////

void THIFormatStr::SetCount(int Value)
{
   Str = (THI_Event **)new int[Value];
   FDataCount = Value;
}

void THIFormatStr::_work_doString(TData &_Data,WORD Index)
{
  string s = _prop_Mask;

  if( FDataCount > 0 )
  {
    int pos = 1;
    while( pos < s.Length() )
      if( s.c_str()[pos-1] == _his('%') )
      {
        int start = pos;
        pos++;
        if( s.c_str()[pos-1] == _his('%') )
          s.Delete(start,1);
        else
        {
          int i = 0;
          while( (pos <= s.Length())&&( s.c_str()[pos-1] >= _his('0') )&&( s.c_str()[pos-1] <= _his('9') ) )
          {
            i = i*10 + s.c_str()[pos-1] - _his('0');
            pos++;
          }
          if( (i > 0)&&(i <= FDataCount) )
          {
            s.Delete(start,pos - start);
            string s1 = ReadString(_Data,Str[i-1],string(_his("")));
            s.Insert(start-1,s1);
            pos = start;
            if( _prop_Mode == 1 ) pos += s1.Length();
          }
        }
      }
      else pos++;
  }
  _hi_CreateEvent(_Data,_event_onFString,s);
}
