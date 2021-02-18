#include "win.h"

class THICheckBox:public THIWin
{
   private:
     static void _OnClick(void *ClassPointer,void *Param)
     {
       int ret = SendMessage(_hie(THICheckBox)->Control->Handle,BM_GETSTATE,0,0);
       _hi_onEvent( _hie(THICheckBox)->_event_onCheck,ret&BST_CHECKED);
     }
   public:
    THI_Event *_event_onCheck;
    THI_Event *_event_onClick;

    THICheckBox(TWinControl *Parent);
    HI_WORK(_work_doCheck)
    {
       SendMessage(_hie(THICheckBox)->Control->Handle,BM_SETCHECK,ReadBool(_Data),0);
       _OnClick(ClassPointer,NULL);
    }
    HI_WORK(_work_doCaption)
    {
      _hie(THICheckBox)->Control->Caption = ToString(_Data);
    }
    HI_WORK(_var_Checked)
    {
      int ret = SendMessage(_hie(THICheckBox)->Control->Handle,BM_GETSTATE,0,0);
      CreateData(_Data,ret&BST_CHECKED);
    }
    void SetChecked(bool Value){ if(Value) SendMessage(Control->Handle,BM_SETCHECK,1,0); }
    __declspec( property( put = SetChecked ) )bool _prop_Checked;
};

//////////////////////////////////////////////////////////////////////////

THICheckBox::THICheckBox(TWinControl *Parent)
{
   Control = new TCheckBox(Parent,string(_his("")));
   Control->OnClick = DoNotifyEvent(this,_OnClick);
}
