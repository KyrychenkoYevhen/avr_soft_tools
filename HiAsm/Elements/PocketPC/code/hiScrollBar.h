#include "win.h"

class THIScrollBar:public THIWin
{
   private:
     TWinControl *_Parent;
     static void _OnPosition(void *ClassPointer,void *Param)
     {
       _hi_onEvent( _hie(THIScrollBar)->_event_onPosition,(int)Param);
     }
   public:
    BYTE _prop_ScrollMode;
    BYTE _prop_Kind;
    int _prop_Max;
    int _prop_Min;
    int _prop_Position;
    THI_Event *_event_onPosition;

    THIScrollBar(TWinControl *Parent);
    HI_WORK(_work_doPosition)
    {
       ((TScrollBar*)_hie(THIScrollBar)->Control)->Position = ToInteger(_Data);
    }
    HI_WORK(_var_Position)
    {
       CreateData(_Data,((TScrollBar*)_hie(THIScrollBar)->Control)->Position);
    }
    //void SetPosition(int Value){ ((TScrollBar*)Control)->Position = Value; }
    void Init()
    {
      Control = new TScrollBar(_Parent,(_prop_Kind)?SBS_VERT:SBS_HORZ);
      if(_prop_ScrollMode)
       ( (TScrollBar*)Control)->OnEndScroll = DoNotifyEvent(this,_OnPosition);
      else
       ( (TScrollBar*)Control)->OnPosition = DoNotifyEvent(this,_OnPosition);
      //((TScrollBar *)Control)->Kind = _prop_Kind;
      ((TScrollBar *)Control)->Max = _prop_Max;
      ((TScrollBar *)Control)->Min = _prop_Min;
      ((TScrollBar *)Control)->Position = _prop_Position;
      THIWin::Init();
    }
    //__declspec( property( put = SetPosition ) )int _prop_Position;
    //void SetKind(BYTE Value){ ((TScrollBar *)Control)->Kind = Value; }
    //__declspec( property( put = SetKind ) )BYTE _prop_Kind;

    //void SetMax(int Value){ ((TScrollBar *)Control)->Max = Value; }
    //__declspec( property( put = SetMax ) )

    //void SetMin(int Value){ ((TScrollBar *)Control)->Min = Value; }
    //__declspec( property( put = SetMin ) )
};

//#############################################################################

THIScrollBar::THIScrollBar(TWinControl *Parent)
{
   _Parent = Parent;
}
