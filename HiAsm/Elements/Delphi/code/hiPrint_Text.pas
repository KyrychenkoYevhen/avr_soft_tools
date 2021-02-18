unit hiPrint_Text;

interface

uses Windows,Kol,Share,Debug,hiDocumentTemplate,Img_Draw,DrawControls;

type
  THIPrint_Text = class(TDocItem)
   private
//    FFontCorrection: boolean;
    FontRec: TFontRec;
    FrameColor, BackColor: TColor;
    GFont   : PGraphicTool;
    txPen:HPEN;
    txBrush:HBRUSH;
    blend: TBlendFunction; 
      
    procedure SetNewFont(Value:TFontRec);
    procedure SetPen(value:TColor);
    procedure SetBrush(value:TColor);
   public
    _prop_Visible:         boolean;
    _prop_Multiline:       boolean;
    _prop_WordBreak:       boolean;
    _prop_Text:            string;
    _prop_FrameStyle:      byte;
    _prop_FrameSize:       byte;
    _prop_BackStyle:       byte;
    _prop_Vertical:        byte;
    _prop_Horizontal:      byte;
    _prop_AlphaBlendValue: byte;
    _prop_Left:            integer;
    _prop_Top:             integer;
    _prop_Right:           integer;
    _prop_Bottom:          integer;
    _prop_Ellipsis:        integer;
    _prop_Sharpen:         integer;
    _prop_TransparentColor:TColor;
    _prop_Fontquality:     TFontQuality;
      

    constructor Create;
    destructor Destroy; override;
    procedure Draw(dc:HDC; x,y:integer; const Scale:TScale; alpha: boolean=false); override;    
    property _prop_Font:TFontRec read FontRec write SetNewFont;
    property _prop_FrameColor:TColor read FrameColor write SetPen;
    property _prop_BackColor:TColor read BackColor write SetBrush;
  end;

implementation

const VAl:array[0..2] of byte = (DT_SINGLELINE or DT_TOP, DT_SINGLELINE or DT_VCENTER, DT_SINGLELINE or DT_BOTTOM);
      HAl:array[0..2] of byte = (DT_LEFT, DT_CENTER, DT_RIGHT);

constructor THIPrint_Text.Create;
begin
   inherited;
   _NameType := _TEXT;
   blend.BlendOp := AC_SRC_OVER;
   blend.BlendFlags := 0;
   blend.SourceConstantAlpha := 255;
   blend.AlphaFormat := AC_SRC_NO_PREMULT_ALPHA;   
end;

destructor THIPrint_Text.Destroy; 
begin      
   GFont.Free;
   DeleteObject(txPen);
   DeleteObject(txBrush);
   inherited;
end;

procedure THIPrint_Text.SetNewFont;
//var
//  ScreenDPI:integer;
//  DC: HDC;  
begin
   FontRec := Value;
   if Assigned(GFont) then GFont.free;
   GFont := NewFont;
   GFont.Color:= Value.Color;
   Share.SetFont(GFont,Value.Style);
   GFont.FontName:= Value.Name;
   GFont.FontHeight:= _hi_SizeFnt(Value.Size);
   GFont.FontCharset:= Value.CharSet;
end;

procedure THIPrint_Text.SetPen;
begin
   DeleteObject(txPen);
   FrameColor := Value;
   txPen := CreatePen(_prop_FrameStyle, _prop_FrameSize, Color2RGB(value));
end;

procedure THIPrint_Text.SetBrush;
begin
   DeleteObject(txBrush);
   BackColor := Value;
   if _prop_BackStyle = 0 then
     txBrush := GetStockObject(NULL_BRUSH)
   else txBrush := CreateSolidBrush(Color2RGB(value));
end;

procedure THIPrint_Text.Draw;
type
  TLine = array[0..0] of byte;
  PLine = ^TLine;
var
  hOldFont: HFONT;
  r,rc,ra,rs:TRect;
  fh:integer;
  pDC: HDC;
  src: PBitmap;
  Flags: Cardinal;
  Fontquality_old: TFontQuality;
  
  Line, Last:PLine;
  i, j, k : integer;
  st: real;
begin
   if not _prop_Visible then exit;
   
   Flags := 0;

   r.Left   := x + _prop_X;
   r.Top    := y + _prop_Y;
   r.Right  := x + _prop_X + _prop_Width;
   r.Bottom := y + _prop_Y + _prop_Height;

   case _prop_Ellipsis of
    1: Flags := DT_WORD_ELLIPSIS;
    2: Flags := DT_MODIFYSTRING or DT_PATH_ELLIPSIS;
    3: Flags := DT_MODIFYSTRING or DT_END_ELLIPSIS;
   end;

   if not alpha then
   begin
     fh := GFont.FontHeight;
     GFont.FontHeight := Round(GFont.FontHeight * Scale.y);
     hOldFont := SelectObject(dc, GFont.Handle);
     SetTextColor(dc, GFont.Color);
     SetBkMode(DC,TRANSPARENT);
     SelectObject(dc, txBrush);
     SelectObject(dc, txPen);
     rc := r;

     ScaleRect(rc, Scale.x, Scale.y);
     Rectangle(dc, rc.Left, rc.Top, rc.Right, rc.Bottom);

     inc(r.Left, _prop_Left);
     inc(r.Top, _prop_Top);
     dec(r.Right, _prop_Right);
     dec(r.Bottom, _prop_Bottom);

     rc := r;
     ScaleRect(rc, Scale.x, Scale.y);
   if not _prop_Multiline then
   begin
     Flags := Flags or hal[_prop_Horizontal] or val[_prop_Vertical] or DT_NOCLIP;
   end   
   else
   begin
     Flags := Flags or hal[_prop_Horizontal] or DT_NOCLIP;
     case _prop_Vertical of
       0: 
     begin
       Flags := Flags or DT_TOP;
       if _prop_WordBreak then Flags := Flags or DT_WORDBREAK;
     end;       
     1:
     begin
           ZeroMemory(@rs, sizeof(rs));
           DrawText(DC, pchar(_prop_Text), length(_prop_Text), rs, Flags or DT_CALCRECT);
           rc.Top := rc.Top + (rc.Bottom - rc.Top - (rs.Bottom - rs.Top)) div 2;
     end;
     2: 
     begin
           ZeroMemory(@rs, sizeof(rs));
           DrawText(DC, pchar(_prop_Text), length(_prop_Text), rs, Flags or DT_CALCRECT);
           rc.Top := rc.Top + (rc.Bottom - ra.Top - (rs.Bottom - rs.Top));
     end;
     end;
   end;
     DrawText(DC, pchar(_prop_Text), length(_prop_Text), rc, Flags);
     SelectObject(dc, hOldFont);
     GFont.FontHeight := fh;     
   end
   else
   begin
     src := NewDIBBitmap(r.Right - r.Left + _prop_FrameSize, r.Bottom - r.Top + _prop_FrameSize, pf32bit);
     pDC := src.Canvas.Handle;
   
     Fontquality_old := GFont.Fontquality; 
     GFont.Fontquality := _prop_Fontquality;
     SelectObject(pdc, GFont.Handle);
     SetTextColor(pdc, GFont.Color);
     SetBkMode(pDC,TRANSPARENT);
     SelectObject(pdc, txBrush);
     SelectObject(pdc, txPen);

     ra.left := _prop_FrameSize div 2;
     ra.Top := _prop_FrameSize div 2;
     ra.Right := src.width - _prop_FrameSize div 2;
     ra.Bottom := src.height - _prop_FrameSize div 2;

     Rectangle(pdc, ra.Left, ra.Top, ra.Right, ra.Bottom);

     inc(ra.Left, _prop_Left);
     inc(ra.Top, _prop_Top);
     dec(ra.Right, _prop_Right);
     dec(ra.Bottom, _prop_Bottom);

   if not _prop_Multiline then
   begin
     Flags := Flags or hal[_prop_Horizontal] or val[_prop_Vertical] or DT_NOCLIP;
   end   
   else
   begin
     Flags := Flags or hal[_prop_Horizontal] or DT_NOCLIP;
     case _prop_Vertical of
       0: 
     begin
       Flags := Flags or DT_TOP;
       if _prop_WordBreak then Flags := Flags or DT_WORDBREAK;
     end;
     1:
     begin
           ZeroMemory(@rs, sizeof(rs));
           DrawText(pDC, pchar(_prop_Text), length(_prop_Text), rs, Flags or DT_CALCRECT);
           ra.Top := ra.Top + (ra.Bottom - ra.Top - (rs.Bottom - rs.Top)) div 2;
     end;
     2: 
     begin
           ZeroMemory(@rs, sizeof(rs));
           DrawText(pDC, pchar(_prop_Text), length(_prop_Text), rs, Flags or DT_CALCRECT);
           ra.Top := ra.Top + (ra.Bottom - ra.Top - (rs.Bottom - rs.Top));
     end;
     end;
   end;
     DrawText(pDC, pchar(_prop_Text), length(_prop_Text), ra, Flags);
     PremultAlphaTransparent(src, _prop_TransparentColor, true);

     st := max(0, min(10, _prop_Sharpen));

     if st > 0 then
     begin 
       st := st / 10;
       for i := 1 to src.Height - 1 do
       begin
         Line := src.ScanLine[i];
         Last := src.ScanLine[i - 1];
         for j := 1 to src.Width - 1 do
         begin
           k := j * 4; 
           Line^[ k ]   := max(0, min(255, Round(Line^[ k ]   + st * (Line^[ k ]   - Last^[k - 4]))));
           Line^[k + 1] := max(0, min(255, Round(Line^[k + 1] + st * (Line^[k + 1] - Last^[k - 3]))));
           Line^[k + 2] := max(0, min(255, Round(Line^[k + 2] + st * (Line^[k + 2] - Last^[k - 2]))));
           Line^[k + 3] := max(0, min(255, Round(Line^[k + 3] + st * (Line^[k + 3] - Last^[k - 1]))));         
         end;
       end;   
     end;

     rc := r;
     dec(rc.Left, _prop_FrameSize div 2);
     dec(rc.Top, _prop_FrameSize div 2);
     inc(rc.Right, _prop_FrameSize div 2);
     inc(rc.Bottom, _prop_FrameSize div 2);
          
     ScaleRect(rc, Scale.x, Scale.y); 
     blend.SourceConstantAlpha := _prop_AlphaBlendValue;
     AlphaBlend(dc, rc.Left, rc.Top, rc.Right - rc.Left, rc.Bottom - rc.Top, pDC, 0, 0, src.width, src.height, blend);
     src.free;
     GFont.Fontquality := Fontquality_old;
   end;
end;

end.