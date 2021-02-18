#include "share.h"

class  THIVolume:public TDebug
{
   private:
   public:
    BYTE _prop_Device;
    THI_Event *_data_Right;
    THI_Event *_data_Left;
    THI_Event *_event_onLVolume;
    THI_Event *_event_onRVolume;

    HI_WORK_LOC(THIVolume,_work_doVolume);
    HI_WORK_LOC(THIVolume,_work_doGetVolume);
    HI_WORK(_work_doDevide){ _hie(THIVolume)->_prop_Device = ToInteger(_Data); }
};

void THIVolume::_work_doVolume(TData &_Data,WORD Index)
{
  int r = ReadInteger(_Data,_data_Left,0);
  int l = ReadInteger(_Data,_data_Right,0);
  if( _prop_Device == 0 )
   waveOutSetVolume(0, (l << 16) + r);
  //else midiOutSetVolume(0, l << 16 + r);
}

void THIVolume::_work_doGetVolume(TData &_Data,WORD Index)
{
  DWORD c;
  if( _prop_Device == 0)
   waveOutGetVolume(0,&c);
  //else midiOutGetVolume(0,&c);
  _hi_onEvent(_event_onLVolume,(int)(c >> 16));
  _hi_onEvent(_event_onRVolume,(int)(c & 0xFFFF));
}
