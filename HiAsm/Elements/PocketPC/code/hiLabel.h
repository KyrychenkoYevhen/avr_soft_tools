#ifndef _LABEL_
#define _LABEL_
#include "win.h"

class THILabel:public THIWin
{
  private:
   static void _OnClick(void *ClassPointer,void *Param)
   {
    _hi_onEvent( _hie(THILabel)->_event_onClick);
   }
  protected:

  public:
     bool _prop_AutoSize;
     THI_Event *_event_onClick;
     THI_Event *_data_Text;

     THILabel(TWinControl *Parent);
     HI_WORK(_work_doText)
     {
       string c;
       _hie(THILabel)->Control->Caption = ReadString(_Data,_hie(THILabel)->_data_Text,c);
     }
     HI_WORK(_var_Caption)
     {
        CreateData(_Data,_hie(THILabel)->Control->Caption);
     }
};

//#############################################################################


THILabel::THILabel(TWinControl *Parent)
{
   Control = new TLabel(Parent,string(_his("")));
   Control->OnClick = DoNotifyEvent(this,_OnClick);
}
#endif
