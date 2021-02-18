#ifndef _RADIOBUTTON_
#define _RADIOBUTTON_
#include "win.h"

class THIRadioButton:public THIWin
{
   private:
     static void _OnClick(void *ClassPointer,void *Param)
     {
       _hi_onEvent( _hie(THIRadioButton)->_event_onSelect);
     }
   public:
    THI_Event *_event_onClick;
    THI_Event *_event_onSelect;

    THIRadioButton(TWinControl *Parent);
    HI_WORK(_work_doSelect)
    {
       SendMessage(_hie(THIRadioButton)->Control->Handle,BM_CLICK,0,0);
    }
    HI_WORK(_work_doCaption)
    {
      _hie(THIRadioButton)->Control->Caption = ToString(_Data);
    }
    HI_WORK(_var_Selected)
    {
      int ret = SendMessage(_hie(THIRadioButton)->Control->Handle,BM_GETSTATE,0,0);
      CreateData(_Data,ret&BST_CHECKED);
    }
    void SetSelect(bool Value){ if(Value) SendMessage(Control->Handle,BM_SETCHECK,1,0); }
    __declspec( property( put = SetSelect ) )bool _prop_Selected;
};

//#############################################################################

THIRadioButton::THIRadioButton(TWinControl *Parent)
{
   Control = new TRadioButton(Parent,string(_his("")));
   Control->OnClick = DoNotifyEvent(this,_OnClick);
}

#endif
