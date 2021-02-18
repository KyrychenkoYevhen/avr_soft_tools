unit hiImg_Rectangle;

interface

uses Windows,Kol,Share,Img_Draw;

{$I share.inc}

type
  THIImg_Rectangle = class(THIDraw2PR)
   private
   public
    procedure _work_doDraw(var _Data:TData; Index:word);
  end;

implementation

procedure THIImg_Rectangle._work_doDraw;
var   dt: TData;
      br: HBRUSH;
      pen: HPEN;
      sColor: TColor;
      Pattern: PBitmap;  
      mTransform: PTransform;
begin
   dt := _Data;
TRY
   if not ImgGetDC(_Data) then exit;
   ReadXY(_Data);
   sColor := Color2RGB(ReadInteger(_Data,_data_BgColor,_prop_BgColor));
   if _prop_PatternStyle then
   begin
     Pattern := ReadBitmap(_Data,_data_Pattern);
     if not Assigned(Pattern) or Pattern.Empty then
       br := GetStockObject(NULL_BRUSH)
     else
       br := CreatePatternBrush(Pattern.Handle);
   end
   else
   begin
     if _prop_Style = bsSolid then
        br := CreateSolidBrush(sColor)
     else if _prop_Style = bsClear then
        br := GetStockObject(NULL_BRUSH)
     else
       begin
         SetBkMode(pDC, TRANSPARENT);
         br := CreateHatchBrush(ord(_prop_Style) - 2, sColor);
       end;
   end;    

   ImgNewSizeDC;

   pen := CreatePen(ord(_prop_LineStyle), Round((fScale.x + fScale.y) * ReadInteger(_Data,_data_Size,_prop_Size)/2), Color2RGB(ReadInteger(_Data,_data_Color,_prop_Color)));
   
   SelectObject(pDC,br);
   SelectObject(pDC,Pen);

   mTransform := ReadObject(_Data, _data_Transform, TRANSFORM_GUID);
   if mTransform <> nil then
    if mTransform._Set(pDC,x1,y1,x2,y2) then  //���� ���������� �������� ���������� (rotate, flip)
     PRect(@x1)^ := mTransform._GetRect(MakeRect(x1,y1,x2,y2));
   RoundRect(pDC, x1, y1, x2, y2, rx, ry);
   if mTransform <> nil then mTransform._Reset(pDC); // ����� �������������

   DeleteObject(br);
   DeleteObject(Pen);
FINALLY
   ImgReleaseDC;
   _hi_CreateEvent(_Data,@_event_onDraw,dt);
END;
end;

end.