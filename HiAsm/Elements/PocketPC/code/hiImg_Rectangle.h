#include "hiImg_share.h"

class THIImg_Rectangle:public THIImg_Share
{
   protected:
    void MainDraw(TData &_Data,HDC dc);
   public:
    int _prop_BgColor;
    int _prop_Style;

    THI_Event *_data_BgColor;
};

////////////////////////////////////////////////////////////

void THIImg_Rectangle::MainDraw(TData &_Data,HDC dc)
{
   ReadXY2(_Data);
   HPEN pen = CreatePen(0,1,ReadColor(_Data,_data_Color,_prop_Color));
   HBRUSH br;
   if( _prop_Style == 1 )
      br = CreateSolidBrush(ReadColor(_Data,_data_BgColor,_prop_BgColor));
   else br = (HBRUSH)GetStockObject(NULL_BRUSH);
   SelectObject(dc,br);
   SelectObject(dc,pen);
   Rectangle(dc,x1,y1,x2,y2);
   DeleteObject(br);
   DeleteObject(pen);
}
