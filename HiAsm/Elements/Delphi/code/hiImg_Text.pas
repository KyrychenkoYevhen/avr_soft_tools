unit hiImg_Text;

interface

{$I share.inc}

uses Windows,Kol,Share,Img_Draw;

type
  THIImg_Text = class(THIDraw2P)
   private
    GFont   : PGraphicTool;
    procedure SetNewFont(Value:TFontRec);
   public

    _prop_Orientation: Integer;
    _data_Orientation: THI_Event;
    
    property _prop_Font:TFontRec write SetNewFont;

    destructor Destroy; override;
    procedure _work_doDraw(var _Data:TData; Index:word);
    procedure _work_doFont(var _Data:TData; Index:word);
    procedure _var_TextWidth(var _Data:TData; Index:word);
    procedure _var_TextHeight(var _Data:TData; Index:word);
  end;

implementation

destructor THIImg_Text.Destroy;
begin
   GFont.free;
   inherited;
end;

procedure THIImg_Text._work_doDraw;
var   dt: TData;
      hOldFont: HFONT;
      OldFontSize: Integer;
      s:string;
      a:integer;
      mTransform: PTransform;
      SizeFont: TSize;
begin
   dt := _Data;
TRY
   if not ImgGetDC(_Data) then exit;
   ReadXY(_Data);
   ImgNewSizeDC;
   s := ReadString(_Data,_data_Text,_prop_Text);
   a := ReadInteger(_Data, _data_Orientation, _prop_Orientation);
   if a < 0 then a := 360 - (abs(a) mod 360); 
   SetBkMode(pDC, TRANSPARENT);
   SetTextColor(pDC, Color2RGB(GFont.Color));   
   OldFontSize := GFont.FontHeight;
   GFont.FontHeight := Round(GFont.FontHeight * fScale.y);
   GFont.FontOrientation := a * 10;
   hOldFont := SelectObject(pDC, GFont.Handle);

   mTransform := ReadObject(_Data, _data_Transform, TRANSFORM_GUID);
   if mTransform <> nil then
    begin
     GetTextExtentPoint32(pDC, PChar(s), Length(s), SizeFont);
     if mTransform._Set(pDC,x1,y1,x1 + SizeFont.cx, y1 + SizeFont.cy) then   //���� ���������� �������� ���������� (rotate, flip)
      PRect(@x1)^ := mTransform._GetRect(MakeRect(x1,y1,x2,y2));
    end;
   TextOut(pDC, x1, y1, PChar(s), length(s));
   if mTransform <> nil then mTransform._Reset(pDC);
   
   SelectObject(pDC, hOldFont);
   GFont.FontHeight := OldFontSize;
FINALLY
   ImgReleaseDC;
   _hi_CreateEvent(_Data,@_event_onDraw,dt);
END;
end;

procedure THIImg_Text._var_TextWidth;
var   SizeFont: TSize;
      DC: HDC;
      s: string;
begin
   s := ReadString(_Data,_data_Text,_prop_Text);
   DC := CreateCompatibleDC(0);
   SelectObject(DC, GFont.Handle);
   GetTextExtentPoint32(DC, PChar(s), Length(s), SizeFont);
   DeleteDC(DC);
   dtInteger(_Data, SizeFont.cx);
end;

procedure THIImg_Text._var_TextHeight;
var   SizeFont: TSize;
      DC: HDC;
      s: string;
begin
   s := ReadString(_Data,_data_Text,_prop_Text);
   DC := CreateCompatibleDC(0);
   SelectObject(DC, GFont.Handle);
   GetTextExtentPoint32(DC, PChar(s), Length(s), SizeFont);
   DeleteDC(DC);
   dtInteger(_Data, SizeFont.cy);
end;

procedure THIImg_Text._work_doFont;
begin
   if _IsFont(_Data) then SetNewFont(pfontrec(_Data.idata)^);
end;

procedure THIImg_Text.SetNewFont;
begin
   if Assigned(GFont) then GFont.free;
   GFont := NewFont;
   GFont.Color:= Value.Color;
   Share.SetFont(GFont,Value.Style);
   GFont.FontName:= Value.Name;
   GFont.FontHeight:= _hi_SizeFnt(Value.Size);
   GFont.FontCharset:= Value.CharSet;
end;

end.