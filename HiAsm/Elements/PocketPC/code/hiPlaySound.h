#include <windows.h>
#include "share.h"

class  THIPlaySound
{
   private:
   public:
    BYTE _prop_PlayType;
    string _prop_FileName;
    string _prop_Sound;

    THI_Event *_data_FileName;
    THI_Event *_event_onEndPlay;

    HI_WORK_LOC(THIPlaySound,_work_doPlay);
};

//#############################################################################

const long PlaySound_value[] = {SND_SYNC,SND_ASYNC,SND_ASYNC | SND_LOOP};

void Play(string &SName, long Flag)
{
  if( FileExists(SName) )
    PlaySound(PChar(SName),0,Flag);
  else
  {
    //if( pData <> nil then
    // begin
      LPVOID pData = LoadResData(SName);
      PlaySound((HI_STRING)pData, 0, SND_MEMORY | Flag);
      //FreeResource(hResource);
    // end
    //else PlaySound(nil, 0, SND_ASYNC);
   }
}

void THIPlaySound::_work_doPlay(TData &_Data,USHORT Index)
{
   string FFileName;

   if( _prop_Sound.Length() )
     FFileName = _prop_Sound;
   else FFileName = ReadString(_Data,_data_FileName,_prop_FileName);
   
   Play(FFileName,PlaySound_value[_prop_PlayType]);
   _hi_onEvent(_event_onEndPlay);
}
