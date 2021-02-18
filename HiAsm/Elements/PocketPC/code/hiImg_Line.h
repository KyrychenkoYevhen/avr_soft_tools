#include "hiImg_share.h"

class THIImg_Line:public THIImg_Share
{
   protected:
    void MainDraw(TData &_Data,HDC dc);
   public:
    int _prop_Size;
    BYTE _prop_Style;

    THI_Event *_data_Size;
    THI_Event *_data_Style;
};

///////////////////////////////////////////////////////////////////////

void THIImg_Line::MainDraw(TData &_Data,HDC dc)
{
   ReadXY2(_Data);

   int c = ReadColor(_Data,_data_Color,_prop_Color);
   HPEN hp = CreatePen(0,ReadInteger(_Data,_data_Size,_prop_Size),c);
   SelectObject(dc,hp);
   POINT p[2];      // Windows CE 3.0
   p[0].x = x1;
   p[0].y = y1;
   p[1].x = x2;
   p[1].y = y2;
   Polyline(dc,p,2);
   //MoveToEx(dc,x1,y1,NULL);
   //LineTo(dc,x2,y2);
   DeleteObject(hp);
}
