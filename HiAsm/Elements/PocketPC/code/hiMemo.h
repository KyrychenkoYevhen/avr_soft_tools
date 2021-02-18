#include "WinList.h"

class THIMemo:public THIWinList
{
   private:
    TWinControl *_Parent;
    static void _OnChange(void *ClassPointer,void *Param)
    {
      _hi_onEvent( _hie(THIMemo)->_event_onChange); //,_hie(THIMemo)->Control->Caption );
    }
   public:
    BYTE _prop_ScrollBars;
    bool _prop_ReadOnly;

    THIMemo(TWinControl *Parent)
    {
      _Parent = Parent;
      Control = new TMemo(_Parent,ES_AUTOVSCROLL|ES_AUTOHSCROLL);
      FList = ((TMemo*)Control)->Lines;
    }
    void Init();
    HI_WORK_LOC(THIMemo,_work_doSetSelect){ ((TMemo*)Control)->SelText = ToString(_Data); }
    HI_WORK_LOC(THIMemo,_work_doSetSelStart){ ((TMemo*)Control)->SelStart = ToInteger(_Data); }
    HI_WORK_LOC(THIMemo,_work_doSetSelLength){ ((TMemo*)Control)->SelLength = ToInteger(_Data); }
    HI_WORK_LOC(THIMemo,_var_SelText){ CreateData(_Data,((TMemo*)Control)->SelText); }
};

//######################################################################

int styl[4] = {0,WS_HSCROLL|ES_AUTOHSCROLL,WS_VSCROLL|ES_AUTOVSCROLL,WS_VSCROLL|WS_HSCROLL|ES_AUTOVSCROLL|ES_AUTOHSCROLL};

void THIMemo::Init()
{
  ((TMemo *)Control)->Style = styl[_prop_ScrollBars];
  ((TMemo *)Control)->OnChange = DoNotifyEvent(this,_OnChange);
  THIWin::Init();
}
