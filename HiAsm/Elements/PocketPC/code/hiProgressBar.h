#include "win.h"

class THIProgressBar:public THIWin
{
   private:
    TWinControl *_Parent;
   public:
    BYTE _prop_Kind;
    bool _prop_Smooth;
    int _prop_Max;
    int _prop_ProgressColor;

    THIProgressBar(TWinControl *Parent){_Parent = Parent;}
    void Init();
    HI_WORK(_work_doPosition){ ((TProgressBar*)_hie(THIProgressBar)->Control)->Position = ToInteger(_Data); }
    HI_WORK(_work_doMax){SendMessage(((TProgressBar*)_hie(THIProgressBar)->Control)->Handle, PBM_SETRANGE32, 0, ToInteger(_Data));}
    HI_WORK(_var_Position){}
};

/////////////////////////////////////////////////////////////////

void THIProgressBar::Init()
{
   long fl = 0;
   if(_prop_Smooth)
    fl |= PBS_SMOOTH;
   if(_prop_Kind == 1)
    fl |= PBS_VERTICAL;

   Control = new TProgressBar(_Parent,fl);
   SendMessage(Control->Handle, PBM_SETRANGE32, 0, _prop_Max);
   SendMessage(Control->Handle, 0x2000 + 1, 0, _prop_ProgressColor);
   THIWin::Init();
}
