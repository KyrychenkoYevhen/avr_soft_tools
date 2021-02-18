#ifndef _EDIT_
#define _EDIT_

#include "Win.h"

class THIEdit:public THIWin
{
 private:
  static void _OnChange(void *ClassPointer,void *Param)
  {
    _hi_onEvent( _hie(THIEdit)->_event_onChange,_hie(THIEdit)->Control->Caption );
  }
 protected:
	 TWinControl *_Parant;
 public:
  string _prop_Text;
  THI_Event *_event_onChange;
  THI_Event *_event_onEnter;
  THI_Event *_data_Str;

	 THIEdit( TWinControl *Parant ){ _Parant = Parant; }
	 void Init();
  HI_WORK_LOC(THIEdit,_work_doText);
  HI_WORK(_var_Text)
  {
    CreateData(_Data,_hie(THIEdit)->Control->Caption);
  }
};

//#############################################################################

void THIEdit::Init()
{
  TEdit *edit = new TEdit(_Parant,_prop_Text);
  edit->OnChange = DoNotifyEvent(this,_OnChange);
  Control = (TWinControl *)edit;
  _prop_Caption = _prop_Text;
		THIWin::Init();
}

void THIEdit::_work_doText(TData &_Data,USHORT Index)
{
  string c;
  Control->Caption = ReadString(_Data,_data_Str,c);
}
#endif
