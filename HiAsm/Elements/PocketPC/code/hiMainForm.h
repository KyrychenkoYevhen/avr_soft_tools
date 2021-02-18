#include "Win.h"

class THIMainForm:public THIWin
{
private:
  ON_PROC(_OnActivate)
  {
    if( Param )
      _hi_onEvent( _hie(THIMainForm)->_event_onDeActivate);
    else _hi_onEvent( _hie(THIMainForm)->_event_onActivate);
  }
  ON_PROC(_OnSize)
  {
    _hi_onEvent( _hie(THIMainForm)->_event_onResize);
  }
  ON_PROC(_OnClose)
  {
    TData dt;
    dt.data_type = data_null;
    *(bool*)Param = ReadInteger(dt,_hie(THIMainForm)->_data_Close,0) != 0;
  }
  static void Load(void *ClassPointer,void *Param)
  {
     _hi_onEvent( _hie(THIMainForm)->_event_onCreate);
  }
protected:
	void Place()
 {
   if( _prop_BorderStyle )
      THIWin::Place();
 }
public:
 short _prop_BorderStyle;
	bool _prop_DragForm;
 HICON _prop_Icon;
 THI_Event *_data_Close;
 THI_Event *_event_onActivate;
 THI_Event *_event_onDeActivate;
 THI_Event *_event_onCreate;
 THI_Event *_event_onResize;

	THIMainForm( TWinControl *Parant )
	{ 
		 //_prop_BorderStyle = 0;
   //_prop_Width = 240;
   //_prop_Height = 300;
	}
 ~THIMainForm()
 {
   EventOff;
 }
	void Init()
	{
		TForm *form = new TForm(_prop_Caption,(_prop_BorderStyle)?WS_OVERLAPPEDWINDOW:WS_VISIBLE);
  form->SetBorderStyle( _prop_BorderStyle );
  form->OnActivate = DoNotifyEvent(this,_OnActivate);
  form->OnSize = DoNotifyEvent(this,_OnSize);
  form->OnClose = DoNotifyEvent(this,_OnClose);
  form->Icon = /*_prop_Icon; //*/(HICON)0;
		Control = (TWinControl *)form;
  _prop_Ctl3D = true;
		THIWin::Init();
		Control->Show();
  if( !ReadHandle ) ReadHandle = form->Handle;

  InitMan.Add(DoNotifyEvent(this,Load));
	}
	void Start()
 {
   EventOn;
   InitMan.Init();
   Run(Control);
 }
	
 HI_WORK(_work_doClose)
 {
    ((TForm *)_hie(THIMainForm)->Control)->Close();
 }
 HI_WORK(_work_doMinimize)
 {
    ShowWindow(((TForm *)_hie(THIMainForm)->Control)->Handle,SW_MINIMIZE);
 }
 HI_WORK(_work_doRestore)
 {
    ShowWindow(((TForm *)_hie(THIMainForm)->Control)->Handle,SW_SHOW);
 }
 HI_WORK(_work_doCaption)
 {
   _hie(THIMainForm)->Control->Caption = ToString(_Data);
 }
};
