#include "share.h"

class THIPointInRect:public TDebug
{
   private:
   public:
    bool _prop_Point2AsOffset;

    THI_Event *_data_RPoint2;
    THI_Event *_data_RPoint1;
    THI_Event *_data_Point;
    THI_Event *_event_onFalse;
    THI_Event *_event_onTrue;

    HI_WORK_LOC(THIPointInRect,_work_doCheck);
};

/////////////////////////////////////////////////////////////////

void THIPointInRect::_work_doCheck(TData &_Data,WORD Index)
{
   int p = ReadInteger(_Data,_data_Point,0);
   int rp1 = ReadInteger(_Data,_data_RPoint1,0);
   int rp2 = ReadInteger(_Data,_data_RPoint2,0);

   int px = p & 0xFFFF;
   int py = p >> 16;

   bool Result;
   if( _prop_Point2AsOffset )
     Result = (px >= LOWORD(rp1))&&(px <= LOWORD(rp1) + LOWORD(rp2))&&
              (py >= HIWORD(rp1))&&(py <= HIWORD(rp2) + HIWORD(rp2));
   else
     Result = (px >= LOWORD(rp1))&&(px <= LOWORD(rp2))&&
              (py >= HIWORD(rp1))&&(py <= HIWORD(rp2));

   if( Result )
     _hi_onEvent(_event_onTrue);
   else _hi_onEvent(_event_onFalse);
}
