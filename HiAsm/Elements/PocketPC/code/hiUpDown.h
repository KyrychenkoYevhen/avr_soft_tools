#ifndef _UPDOWN_
#define _UPDOWN_

#include "Win.h"

class THIUpDown:public THIWin
{
 private:
   static void _OnPosition(void *ClassPointer,void *Param)
   {
     _hi_onEvent( _hie(THIUpDown)->_event_onPosition,(short)Param);
   }
 protected:
	  TWinControl *_Parent;
 public:
   int _prop_Max;
   int _prop_Min;
   int _prop_Step;
   int _prop_Position;
   BYTE _prop_Kind;

   TData _prop_Data;
   THI_Event *_event_onPosition;

	  THIUpDown( TWinControl *Parent ){	_Parent = Parent;  }
  	void Init();
   HI_WORK(_work_doPosition)
   {
     ((TUpDown*)_hie(THIUpDown)->Control)->Position = ToInteger(_Data);
   }
   HI_WORK(_var_Position)
   {
       CreateData(_Data,((TUpDown*)_hie(THIUpDown)->Control)->Position);
   }
};

//#############################################################################

void THIUpDown::Init()
{
   TUpDown *updown = new TUpDown(_Parent,(_prop_Kind == 0)?UDS_HORZ:0);
   updown->OnPosition = DoNotifyEvent(this,_OnPosition);
   updown->Max = _prop_Max;
   updown->Min = _prop_Min;
   updown->Step = _prop_Step;
   Control = (TWinControl *)updown;
   THIWin::Init();
}

#endif
