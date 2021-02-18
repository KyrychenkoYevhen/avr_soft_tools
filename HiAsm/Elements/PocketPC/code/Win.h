#ifndef __WIN_H_
#define __WIN_H_

//#include <Windows.h>
#include "WinControls.h"
#include "Share.h"

class THIWin
{
 private:
   int FMouseX;
   int FMouseY;

   #define me (*(TMouseEvent *)Param)
   ON_PROC_LOC(THIWin,_OnMouseUp)
   {
     FMouseX = me.x;
     FMouseY = me.y;
     _hi_onEvent( _event_onMouseUp,me.btn);
     if( _prop_MouseCapture )
       ReleaseCapture();
   }
   ON_PROC_LOC(THIWin,_OnMouseDown)
   {
     FMouseX = me.x;
     FMouseY = me.y;
     _hi_onEvent( _event_onMouseDown,me.btn);
     if( _prop_MouseCapture )
     {
       ReleaseCapture();
       SetCapture(Control->Handle);
     }
   }
   ON_PROC_LOC(THIWin,_OnMouseMove)
   {
     FMouseX = me.x;
     FMouseY = me.y;
     _hi_onEvent(_event_onMouseMove,me.btn);
   }
   ON_PROC(_OnKeyUp)
   {
     _hi_onEvent( _hie(THIWin)->_event_onKeyUp,(int)Param);
   }
   ON_PROC(_OnKeyDown)
   {
     _hi_onEvent( _hie(THIWin)->_event_onKeyDown,(int)Param);
   }
   ON_PROC(_OnSetFocus)
   {
     _hi_onEvent( _hie(THIWin)->_event_onSetFocus);
   }
   ON_PROC(_OnKillFocus)
   {
     _hi_onEvent( _hie(THIWin)->_event_onKillFocus);
   }
   ON_PROC(_OnDblClick)
   {
     _hi_onEvent( _hie(THIWin)->_event_onDblClick);
   }
 protected:
  virtual void Place()
  {
    Control->SetPos(_prop_Left,_prop_Top);
   	Control->SetSize(_prop_Width,_prop_Height);
  }
 public:
 	TWinControl *Control;
 	int _prop_Left;
 	int _prop_Top;
 	int _prop_Width;
	 int _prop_Height;
  int _prop_Align;
  TFontRec _prop_Font;
 	bool _prop_Visible;
 	bool _prop_Enabled;
  bool _prop_Ctl3D;
 	int _prop_Color;
  bool _prop_MouseCapture;
 	string _prop_Caption;
  THI_Event *_event_onMouseUp;
  THI_Event *_event_onMouseDown;
  THI_Event *_event_onMouseMove;
  THI_Event *_event_onKeyDown;
  THI_Event *_event_onKeyUp;
  THI_Event *_event_onSetFocus;
  THI_Event *_event_onKillFocus;
  THI_Event *_event_onDblClick;

 	virtual void Init()
 	{
    Place();

	 	 Control->Visible = _prop_Visible;
    Control->Ctl3D = _prop_Ctl3D;
    Control->Color = _prop_Color;
    Control->Caption = _prop_Caption;
    Control->Font = FontRecToFont(_prop_Font);
    Control->OnMouseUp = DoNotifyEvent(this,_OnMouseUp);
    Control->OnMouseDown = DoNotifyEvent(this,_OnMouseDown);
    Control->OnMouseMove = DoNotifyEvent(this,_OnMouseMove);

    Control->OnDblClick = DoNotifyEvent(this,_OnDblClick);

    Control->OnKeyDown = DoNotifyEvent(this,_OnKeyDown);
    Control->OnKeyUp = DoNotifyEvent(this,_OnKeyUp);

    Control->OnSetFocus = DoNotifyEvent(this,_OnSetFocus);
    Control->OnKillFocus = DoNotifyEvent(this,_OnKillFocus);

    _prop_MouseCapture = false;
	 }
  HI_WORK(_var_Handle){ CreateData(_Data,(int)_hie(THIWin)->Control->Handle ); }
  HI_WORK(_var_MouseX){ CreateData(_Data,(int)_hie(THIWin)->FMouseX ); }
  HI_WORK(_var_MouseY){ CreateData(_Data,(int)_hie(THIWin)->FMouseY ); }
  HI_WORK(_var_Left){ CreateData(_Data,(int)_hie(THIWin)->Control->Left ); }
  HI_WORK(_var_Top){ CreateData(_Data,(int)_hie(THIWin)->Control->Top ); }
  HI_WORK(_var_Width){ CreateData(_Data,(int)_hie(THIWin)->Control->Width ); }
  HI_WORK(_var_Height){ CreateData(_Data,(int)_hie(THIWin)->Control->Height ); }
  HI_WORK(_var_Control){ CreateData(_Data,(int)_hie(THIWin)->Control ); }
  HI_WORK(_work_doLeft){ _hie(THIWin)->Control->Left = ToInteger(_Data); }
  HI_WORK(_work_doTop){ _hie(THIWin)->Control->Top = ToInteger(_Data); }
  HI_WORK(_work_doWidth){ _hie(THIWin)->Control->Width = ToInteger(_Data); }
  HI_WORK(_work_doHeight){ _hie(THIWin)->Control->Height = ToInteger(_Data); }
  HI_WORK(_work_doSetFocus){ _hie(THIWin)->Control->Focused(); }
  HI_WORK(_work_doSendToBack){ _hie(THIWin)->Control->SendToBack(); }
  HI_WORK(_work_doBringToFront){ _hie(THIWin)->Control->BringToFront(); }
  HI_WORK(_work_doVisible){ _hie(THIWin)->Control->Visible = ReadBool(_Data); }
};

#endif
