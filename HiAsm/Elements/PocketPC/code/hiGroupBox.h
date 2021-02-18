#ifndef _GROUPBOX_
#define _GROUPBOX_
#include "win.h"

class THIGroupBox:public THIWin
{
   private:
   public:
    THIGroupBox(TWinControl *Parent);
};

/////////////////////////////////////////////////////////////////////

THIGroupBox::THIGroupBox(TWinControl *Parent)
{
   Control = new TGroupBox(Parent,string(_his("")));
   //Control.Font.Create;
   //Control.Font.FontHeight := -11;
   //Control.ExStyle := 0;
}
#endif
