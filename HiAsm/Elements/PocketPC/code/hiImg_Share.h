#ifndef _HI_IMG_SHARE_
#define _HI_IMG_SHARE_

#include "share.h"

class THIImg_Share:public TDebug
{
   protected:
    int x1;
    int y1;
    int x2;
    int y2;

    virtual void MainDraw(TData &_Data,HDC dc) = 0;
    void ReadXY1(TData &_Data);
    void ReadXY2(TData &_Data);
   public:
    int _prop_Color;
    bool _prop_Point2AsOffset;

    THI_Event *_data_Bitmap;
    THI_Event *_data_Color;
    THI_Event *_event_onDraw;

    THI_Event *_data_Point1;
    THI_Event *_data_Point2;

    HI_WORK_LOC(THIImg_Share,_work_doDraw);
};

/////////////////////////////////////////////////////////////////////////////

void THIImg_Share::_work_doDraw(TData &_Data,WORD Index)
{
   TData dt = ReadData(_Data,_data_Bitmap,NULL);
   HDC dc;
   HWND Wnd;
   if( _IsBitmap(dt) )
    ; //dc = ToBitmap(dt)->hdc;
   else
   {
     Wnd = (HWND)ToInteger(dt);
     dc = GetDC( Wnd );
   }

   MainDraw(_Data,dc);

   if( _IsBitmap(dt) )
    ;
   else ReleaseDC(Wnd,dc);
   _hi_CreateEvent(_Data,_event_onDraw);
}

void THIImg_Share::ReadXY1(TData &_Data)
{
   int p = ReadInteger(_Data,_data_Point1,0);
   y1 = p >> 16;
   x1 = p & 0xFFFF;
}

void THIImg_Share::ReadXY2(TData &_Data)
{
   ReadXY1(_Data);
   int p = ReadInteger(_Data,_data_Point2,0);
   y2 = p >> 16;
   x2 = p & 0xFFFF;
   if( _prop_Point2AsOffset )
     x2 += x1,y2 += y1;
}

#endif
