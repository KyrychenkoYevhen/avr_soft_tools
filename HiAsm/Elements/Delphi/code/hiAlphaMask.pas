unit hiAlphaMask;

interface

uses Windows, kol, Share, Debug;

type
 ThiAlphaMask = class(TDebug)
   private
     fmask: PBitmap;
     fAlphaBmp: PBitmap;
   public
     _prop_TransparentColor: TColor;
     _prop_InvertMask: boolean;
     _prop_ReplaceMask: boolean;	      
     _data_Bitmap: THI_Event;
     _data_Mask: THI_Event;
     _data_TransparentColor: THI_Event;
     _event_onGetAlphaMask: THI_Event;
     _event_onGetOutlineMask: THI_Event;
     _event_onSetAlphaMask: THI_Event;     

     constructor Create;
     destructor Destroy; override;
     procedure _work_doGetAlphaMask(var _Data:TData; Index:word);
     procedure _work_doGetOutlineMask(var _Data:TData; Index:word);
     procedure _work_doSetAlphaMask(var _Data:TData; Index:word);
     procedure _work_doInvertMask(var _Data:TData; Index:word);
     procedure _work_doReplaceMask(var _Data:TData; Index:word);     
     procedure _var_AlphaBitmapMask(var _Data:TData; Index:word);
     procedure _var_ResultMask(var _Data:TData; Index:word);
 end;

implementation

constructor ThiAlphaMask.Create;
begin
  inherited;
  fmask := NewBitmap(0, 0);
  fAlphaBmp := NewBitmap(0, 0);
end;

destructor ThiAlphaMask.Destroy;
begin
  fmask.free;
  fAlphaBmp.free;
  inherited;
end;

procedure ThiAlphaMask._work_doGetAlphaMask;
var
  Bmp: PBitmap;
  i: integer;
  Scan: PColor;
  ffrommask: TRGB;    
begin
  Bmp := ReadBitmap(_Data, _data_Bitmap);
  if (Bmp = nil) or bmp.Empty then exit;

  fmask.Assign(Bmp);
    
  if fmask.PixelFormat <> pf32bit then fmask.PixelFormat := pf32bit;

  Scan := fmask.ScanLine[fmask.Height - 1];

  for i := 0 to fmask.Height * fmask.Width - 1 do
  begin
    PColor(@ffrommask)^ := Scan^;
    Scan^ := RGB(ffrommask.x, ffrommask.x, ffrommask.x) + ffrommask.x shl 24;  
    inc(Scan);
  end;  

  _hi_onEvent(_event_onGetAlphaMask, fmask);
end;

procedure ThiAlphaMask._work_doGetOutlineMask;
var
  Bmp, smask: PBitmap;
  fTransparent: TColor;
begin
  Bmp := ReadBitmap(_Data, _data_Bitmap);
  fTransparent := Color2RGB(ReadInteger(_Data, _data_TransparentColor, _prop_TransparentColor));
  if (Bmp = nil) or bmp.Empty then exit;
  smask := NewBitmap(0,0);
  smask.Assign(Bmp);
  if smask.PixelFormat <> pf24bit then smask.PixelFormat := pf24bit;  
  smask.Convert2Mask(fTransparent);
  fmask.clear;
  fmask.width := smask.width;
  fmask.height := smask.height;  
  if fmask.PixelFormat <> pf24bit then fmask.PixelFormat := pf24bit;
  if _prop_InvertMask then
    BitBlt(fmask.Canvas.Handle, 0, 0, fmask.width, fmask.height, smask.Canvas.Handle, 0, 0, NOTSRCCOPY)
  else  
    BitBlt(fmask.Canvas.Handle, 0, 0, fmask.width, fmask.height, smask.Canvas.Handle, 0, 0, SRCCOPY);
  fmask.PixelFormat  := pf32bit;
  _hi_onEvent(_event_onGetOutlineMask, fmask);
  smask.free;
end;

procedure ThiAlphaMask._work_doSetAlphaMask;
var
  Bmp, dest, smask: PBitmap;
  i: integer;
  Scan, MS: PColor;
  ffrom, ffrommask: TRGB;
begin
  Bmp := ReadBitmap(_Data, _data_Bitmap);
  smask := ReadBitmap(_Data, _data_Mask);
  if (Bmp = nil) or bmp.Empty or (smask = nil) or smask.Empty then exit;

  fAlphaBmp.Assign(Bmp);  
  if fAlphaBmp.PixelFormat <> pf32bit then fAlphaBmp.PixelFormat := pf32bit;
  
  dest := NewBitmap(fAlphaBmp.width, fAlphaBmp.height);

  SetStretchBltMode(dest.Canvas.Handle, HALFTONE);
  StretchBlt(dest.Canvas.Handle, 0, 0, dest.width, dest.height, smask.Canvas.Handle, 0, 0, smask.width, smask.height, SRCCOPY);

  if dest.PixelFormat <> pf32bit then dest.PixelFormat := pf32bit;  

  Scan := dest.ScanLine[dest.Height - 1];
  MS := fAlphaBmp.Scanline[fAlphaBmp.Height - 1];  

  for i := 0 to fAlphaBmp.Height * fAlphaBmp.Width - 1 do
  begin
    PColor(@ffrom)^ := Scan^;
    PColor(@ffrommask)^ := MS^;
	if _prop_ReplaceMask then
      MS^ := RGB(ffrommask.r * ((ffrom.r + ffrom.g + ffrom.b) div 3) div 255,
	             ffrommask.g * ((ffrom.r + ffrom.g + ffrom.b) div 3) div 255,
				 ffrommask.b * ((ffrom.r + ffrom.g + ffrom.b) div 3) div 255) +
	             (ffrom.r + ffrom.g + ffrom.b) div 3 shl 24
	else
      MS^ := RGB(ffrommask.r*ffrom.r div 255, ffrommask.g*ffrom.g div 255, ffrommask.b*ffrom.b div 255) + (ffrommask.x * ((ffrom.r + ffrom.g + ffrom.b) div 3) div 255) shl 24;
//    MS^ := RGB(ffrommask.r*ffrom.r div 255, ffrommask.g*ffrom.r div 255, ffrommask.b*ffrom.r div 255) + (ffrommask.x * ffrom.r div 255) shl 24;
    inc(Scan);
    inc(MS);      
  end;  

  dest.free;
  _hi_onEvent(_event_onSetAlphaMask, fAlphaBmp);
end;

procedure ThiAlphaMask._var_AlphaBitmapMask;
begin
  dtBitmap(_Data, fAlphaBmp);
end;

procedure ThiAlphaMask._var_ResultMask;
begin
  dtBitmap(_Data, fmask);
end;

procedure ThiAlphaMask._work_doInvertMask;	      
begin
  _prop_InvertMask := ReadBool(_Data);
end;

procedure ThiAlphaMask._work_doReplaceMask;	      
begin
  _prop_ReplaceMask := ReadBool(_Data);
end;

end.