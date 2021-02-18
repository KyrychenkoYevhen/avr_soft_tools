#ifndef _BUTTON_
#define _BUTTON_

#include "Win.h"
//#include "Shlobj.h"

class THIButton:public THIWin
{
 private:
   static void _OnClick(void *ClassPointer,void *Param)
   {
     TData dt;// = _hie(THIButton)->_prop_Data;
     CreateData(dt,_hie(THIButton)->_prop_Data);
     _hi_onEvent( _hie(THIButton)->_event_onClick,dt);

     /*
     BROWSEINFO bi;
     ZeroMemory(&bi,sizeof(BROWSEINFO));
     bi.hwndOwner = ReadHandle;
     HI_RSTRING dn[MAX_PATH];
     bi.pszDisplayName = dn;
     bi.lpszTitle = _his("Test");
     bi.ulFlags = BIF_EDITBOX;
     SHBrowseForFolder(&bi);
     */
   }
 protected:
	  TWinControl *_Parent;
 public:
   TData _prop_Data;
   THI_Event *_event_onClick;

	  THIButton( TWinControl *Parent ){	_Parent = Parent;  }
  	void Init();
   HI_WORK(_work_doCaption)
   {
     _hie(THIButton)->Control->Caption = ToString(_Data);
   }
};

//#############################################################################

void THIButton::Init()
{
   Control = new TButton(_Parent,_prop_Caption);
   //Control = (TWinControl *)btn;
   Control->OnClick = DoNotifyEvent(this,_OnClick);
   THIWin::Init();
}

#endif
