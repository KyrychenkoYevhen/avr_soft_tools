#include "hiImg_share.h"

class THIImg_Text:public THIImg_Share
{
   protected:
    void MainDraw(TData &_Data,HDC dc);
   public:
    TFontRec _prop_Font;
    string _prop_Text;
    int _prop_X;
    int _prop_Y;

    THI_Event *_data_Y;
    THI_Event *_data_X;
    THI_Event *_data_Text;

    HI_WORK_LOC(THIImg_Text,_var_TextWidth);
};

////////////////////////////////////////////////////////////////////////

void THIImg_Text::MainDraw(TData &_Data,HDC dc)
{
   string s = ReadString(_Data,_data_Text,_prop_Text);
   RECT r;
   r.left = ReadInteger(_Data,_data_X,_prop_X);
   r.top = ReadInteger(_Data,_data_Y,_prop_Y);
   r.right = 1000;  // !!!!!!!!!!!!!!!!!!!!!!!!
   r.bottom = 1000; // !!!!!!!!!!!!!!!!!!!!!!!!

   SetBkMode(dc,TRANSPARENT);
   SetTextColor(dc,_prop_Font.Color);
   HFONT hf = FontRecToFont(_prop_Font);

   SelectObject(dc,hf);
   //TextOut(dc,x,y,PChar(s),s.Length());
   DrawText(dc,PChar(s),s.Length(),&r,0);
   DeleteObject(hf);
}

void THIImg_Text::_var_TextWidth(TData &_Data,WORD Index)
{
   /*
   bmp := ReadBitmap(_Data,_data_Bitmap,nil);
   s := ReadString(_Data,_data_Text,_prop_Text);
   _Data.data_type := data_int;
   if (bmp <> nil) then
   { if IsWindow(integer(bmp)) then
     begin

     end
    else  }
     begin   // _debug('on');
      SetFont(bmp.Canvas.Font,_prop_Font.Style);
      bmp.Canvas.Font.FontHeight := _prop_Font.Size + 6;
      bmp.Canvas.Font.FontName := _prop_Font.Name;
      _Data.idata := bmp.Canvas.TextWidth(s);
     end;
   */
}
