#ifndef _STRMASK_
#define _STRMASK_

#include "share.h"

class THIStrMask:public TDebug
{
   private:
   public:
    string _prop_Mask;
    BYTE _prop_CaseSensitive;

    THI_Event *_data_Str;
    THI_Event *_event_onTrue;
    THI_Event *_event_onFalse;

    HI_WORK_LOC(THIStrMask,_work_doCompare);
    HI_WORK(_work_doMask){ _hie(THIStrMask)->_prop_Mask = ToString(_Data); }
};

////////////////////////////////////////////////////////////////////////

bool _StrCmp(string Str,string M,int sInd,int mInd)
{
  while( (M[mInd] != _his('\1'))&&(Str[sInd] != _his('\1')) )
  {
      switch( M[mInd] )
      {
        case _his('?'):
          sInd++;
          mInd++;
          break;
        case _his('#'):
          if( (Str[sInd] >= _his('0') )&&( Str[sInd] <= _his('9') ) )
            sInd++,mInd++;
          else return false;
          break;
       case _his('*'):
          if( Str[sInd + 1] == _his('\1') )
            return (mInd == M.Length()-2);

          if( _StrCmp(Str,M,sInd,mInd+1) )
            return true;

          return _StrCmp(Str,M,sInd+1,mInd);
       default:
          if( M[mInd] == Str[sInd] )
            sInd++,mInd++;
          else return false;
     }
  }
  return (mInd == M.Length()-1)&&(sInd == Str.Length()-1);
}

bool StrCmp(string Str,string M)
{
  return _StrCmp(Str + _his('\1'),M + _his('\1'),0,0);
}

void THIStrMask::_work_doCompare(TData &_Data, WORD Index)
{
   string str = ReadString(_Data,_data_Str,string(_his("")));

   if( str.Empty() )
   {
     if( _prop_Mask.Empty() )
        _hi_CreateEvent(_Data,_event_onTrue,str);
     else _hi_CreateEvent(_Data,_event_onFalse,str);
     return;
   }

   string sstr;
   if( !_prop_CaseSensitive )
     sstr = str.Lower();
   else sstr = str;

   if( StrCmp(sstr,_prop_Mask) )
     _hi_CreateEvent(_Data,_event_onTrue,str);
   else _hi_CreateEvent(_Data,_event_onFalse,str);
}

#endif
