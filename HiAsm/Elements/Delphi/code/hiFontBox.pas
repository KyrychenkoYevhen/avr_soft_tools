unit hiFontBox;

interface

uses
  Windows, Messages, Kol, Share, Debug, Win, hiBoxDrawManager;

const
  ICON_SIZE  = 16;

  FT_TRUETYPE_SIGNED = 0;
  FT_RASTER   = 1;
  FT_TRUETYPE = 2;  
  FT_VECTOR   = 3;
  FT_OPENTYPE_SIGNED = 4;
  FT_OPENTYPE = 5;
  
  // NEWTEXTMETRIC.ntmFlags:
  
  NTM_PS_OPENTYPE = $20000 {1 shl 17}; // PostScript OpenType font 
  NTM_TT_OPENTYPE = $40000 {1 shl 18}; // TrueType OpenType font 
  NTM_MULTIPLEMASTER = $80000 {1 shl 19}; // multiple master font 
  NTM_TYPE1 = $100000 {1 shl 20}; // Type 1 font 
  NTM_DSIG = $200000 {1 shl 21}; // font with a digital signature


type
  THIFontBox = class(THIWin)
    private
      fFontName: string;
      fFontHeight: Integer;
      fBoxDrawManager:IBoxDrawManager;
      
      
      
      procedure Kill;
      procedure _onChange(Sender: PObj);
      {$ifndef KOL3XX}
      procedure _OnDropDown(Sender: PObj);
      {$endif}
      procedure SetFontName(const Value: string);
      procedure MakeFontList;
      procedure DestroyFontList;
      function  OnMeasureItem(Sender: PObj; Idx: Integer): Integer;
      function  DrawOnItem(Sender: PObj; DC: HDC; const Rect: TRect; ItemIdx: Integer;
                           DrawAction: TDrawAction; ItemState: TDrawState): Boolean;
      procedure SetInitBoxDrawManager(Value: IBoxDrawManager);
    public
      _prop_SelFont: string;
      _prop_ItemHeight: Integer;
      _prop_DropDownCount: Integer; // === DropDownCount
      
      _data_Font: THI_Event;
      _event_onResult: THI_Event;
      
      procedure Init; override;
      procedure _work_doSetFont(var _Data: TData; Index: Word);
      procedure _work_doReReadFonts(var _Data: TData; Index: Word);
      procedure _work_doDropDownCount(var _Data: TData; Index: Word);
      procedure _var_CurrentFont(var _Data: TData; Index: Word);
      property _prop_BoxDrawManager:IBoxDrawManager read fBoxDrawManager write SetInitBoxDrawManager; 
  end;

implementation


var
  FontIcons: array[0..5] of PIcon;






procedure THIFontBox.Kill;
begin
  DestroyFontList;
end;

procedure THIFontBox.SetFontName(const Value: string);
var
  I: Integer;
begin
  I := Control.IndexOf(Value);
  if I > 0 then
  begin
    fFontName := Value;
    Control.CurIndex := I;
  end
  else
  begin
    fFontName := '???';
    Control.Text := '???';
  end;
end;

procedure THIFontBox.Init;
var
  R: Real;
begin
  Control := NewComboBox(FParent, [coReadOnly, coSort, coOwnerDrawFixed]);
  
  //if ManFlags and $04 > 0 then
    Control.OnMeasureItem := OnMeasureItem;
  Control.OnChange := _onChange;
  
  //DropDownCount:
  {$ifdef KOL3XX}
  Control.DropDownCount := _prop_DropDownCount;  
  {$else}
  Control.OnDropDown := _OnDropDown;
  {$endif}

  Control.Add2AutoFreeEx(Kill);
  
  inherited;
  
  
  R := ((Control.Font.FontHeight * -72) - 36) / ScreenDPI;
  fFontHeight := Integer(Trunc(R));
  if Frac(R) > 0 then
    Inc(fFontHeight);
  if fFontHeight < 11 then fFontHeight := 11; 
  MakeFontList;
  SetFontName(_prop_SelFont);
end;

procedure THIFontBox.SetInitBoxDrawManager;
begin
  if Value <> nil then
    fBoxDrawManager := Value;
end;

procedure THIFontBox._work_doSetFont;
begin
  SetFontName(ReadString(_Data, _data_Font));
end;

procedure THIFontBox._work_doReReadFonts;
begin
  MakeFontList;
  SetFontName(fFontName);
end;

procedure THIFontBox._onChange;
begin
  fFontName := Control.Items[Control.CurIndex];
  _hi_onEvent(_event_onResult, fFontName);
end;

// === DropDownCount === //
{$ifndef KOL3XX}
procedure THIFontBox._OnDropDown( Sender: PObj );
var
  CB: PControl;
  IC: Integer;
  H: Integer;
begin
  CB := PControl( Sender );
  IC := CB.Count;
  if IC > _prop_DropDownCount then IC := _prop_DropDownCount;
  if IC < 1 then IC := 1;
  
  //H := CB.Perform(CB_GETITEMHEIGHT, 0, 0);
  H := _prop_ItemHeight; // For owner-drawn CBs
  
  SetWindowPos(CB.Handle, 0, 0, 0, CB.Width, CB.Height + (H * IC) + 2,
                SWP_NOMOVE + SWP_NOZORDER + SWP_NOACTIVATE + SWP_NOSENDCHANGING);
end;
{$endif}

procedure THIFontBox._work_doDropDownCount;
begin
  {$ifdef KOL3XX}
  Control.DropDownCount := ToInteger(_Data);  
  {$else}
  _prop_DropDownCount := ToInteger(_Data);  
  {$endif}
end;
// === ============ === //


procedure THIFontBox._var_CurrentFont;
begin
  dtString(_Data, fFontName);
end;

//From KOLFontComboBox.pas
function THIFontBox.DrawOnItem(Sender: PObj; DC: HDC; const Rect: TRect; ItemIdx: Integer;
                              DrawAction: TDrawAction; ItemState: TDrawState): Boolean;
var
  xRect: TRect;
  xFont: HFONT;
  ICHandle: HICON;
  FD: PGraphicTool;
  Shift: Integer;
  S: string;
begin
  Result := False;
  FD := Pointer(PControl(Sender).ItemData[ItemIdx]);
  
  xFont := FD.Handle;
  if xFont = 0 then PControl(Sender).Font.Handle;
  
  ICHandle := FontIcons[FD.Tag].Handle;
  
  if Assigned(_prop_BoxDrawManager) then
  begin
    Result := _prop_BoxDrawManager.draw(Sender, DC, Rect, ItemIdx, ItemState, False, xFont);
    Shift := _prop_BoxDrawManager.Shift;
  end
  else
  begin
    xRect := Rect;
    InflateRect(xRect, -1, -1);
    FillRect(DC, Rect, 0);
    
    if ICHandle = 0 then
      Inc(xRect.Left, 2)
    else
      Inc(xRect.Left, 20); // Отступ текста вправо для иконки

    SelectObject(DC, xFont);
    
    S := PControl(Sender).Items[ItemIdx];
    DrawText(DC, Pointer(S), Length(S), xRect, DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
    
    if (odaSelect in DrawAction) then
      InvertRect(DC, Rect);
    
    Shift := 0;
  end;
  
  // Иконка
  if (odsComboboxEdit in ItemState) then Inc(Shift);
  DrawIconEx(DC, Shift, Rect.Top + (Rect.Bottom - Rect.Top - ICON_SIZE) div 2, ICHandle, ICON_SIZE, ICON_SIZE, 0, 0, DI_NORMAL);
end;

procedure THIFontBox.DestroyFontList;
var
  I: Integer;
  FD: PGraphicTool;
begin
  if Control.Count = 0 then exit; 
  for I := 0 to Control.Count - 1 do
  begin 
    FD := Pointer(Control.ItemData[I]);
    FD.Free;
  end;
  Control.Clear;
end;

function EnumFontsProc(var EnumLogFont: TEnumLogFontEx; const TextMetric: TNewTextMetric;
                       FontType: DWord; Data: LPARAM): Integer; stdcall;
var
  FaceName: string;
  FB: THIFontBox;
  i: Integer;
  FD: PGraphicTool;
begin
  FB  := THIFontBox(Data);

  FaceName := string(EnumLogFont.elfLogFont.lfFaceName);
  with EnumLogFont do
  begin
    elfLogFont.lfHeight := -FB.fFontHeight;
    elfLogFont.lfWidth  := 0;
  end;
  
  if (FB.Control.Count = 0) or (FB.Control.IndexOf(FaceName) < 0) then
  begin
    FD := NewFont;

    if EnumLogFont.elflogfont.lfCharSet = SYMBOL_CHARSET then
      FD.AssignHandle(0)
    else
      FD.AssignHandle(CreateFontIndirect(EnumLogFont.elfLogFont));
    
    I := FB.Control.Add(FaceName);
    
    {case Fonttype of
      //DEVICE_FONTTYPE: FD.tag := FT_VECTOR;                      
      RASTER_FONTTYPE: FD.tag := FT_RASTER;
      TRUETYPE_FONTTYPE: FD.tag := FT_TRUETYPE;
      else
        FD.tag := FT_VECTOR;
    end;}
    
    if Fonttype = TRUETYPE_FONTTYPE then
      FD.tag := FT_TRUETYPE
    else
      FD.tag := FT_RASTER;
    
    if TextMetric.ntmFlags and NTM_PS_OPENTYPE <> 0 then
    begin
      if TextMetric.ntmFlags and NTM_DSIG <> 0 then
        FD.tag := FT_OPENTYPE_SIGNED else FD.tag := FT_OPENTYPE;
    end
    else
      if TextMetric.ntmFlags and NTM_TT_OPENTYPE <> 0 then
      begin
        if TextMetric.ntmFlags and NTM_DSIG <> 0 then
          FD.tag := FT_TRUETYPE_SIGNED else FD.tag := FT_TRUETYPE;
      end
      else
        if TextMetric.ntmFlags and NTM_TYPE1 <> 0 then
          FD.tag := FT_VECTOR;
    
    FB.Control.ItemData[I] := NativeInt(FD);
  end;
  
  Result := 1;
end;

function THIFontBox.OnMeasureItem;
begin
  Result := _prop_ItemHeight;
end;

procedure THIFontBox.MakeFontList;
var
  DC: HDC;
begin
  DC := GetDC(0);
  try
    Control.OnDrawItem := nil;
    DestroyFontList;
    EnumFontFamilies(DC, nil, @EnumFontsProc, NativeInt(Self));
    Control.OnDrawItem := DrawOnItem;
  finally
    ReleaseDC(0, DC);
  end;
end;





procedure LoadFontIcons;
var
  H: Thandle;
  I: Integer;
begin
  // Создаём пустые иконки
  for I := 0 to High(FontIcons) do
  begin
    FontIcons[I] := NewIcon;
  end;
  
  // Если DLL загружена - загружаем актуальные
  H := LoadLibraryEx('fontext.dll', 0, LOAD_LIBRARY_AS_DATAFILE);
  if H <> 0 then
  begin
    // Иконки в fontext.dll (Windows XP):
    // 1 - папка шрифтов
    // 2 - TrueType с подписью
    // 3 - растровый
    // 4 - TrueType
    // 5 - векторный (Type 1?)
    // 6 - OpenType с подписью
    // 7 - OpenType
    
    for I := 0 to High(FontIcons) do
    begin
      FontIcons[I].LoadFromResourceID(H, I+2, ICON_SIZE);
    end;
    
    FreeLibrary(H);
  end;
end;

procedure FreeFontIcons;
var
  I: Integer;
begin
  for I := 0 to High(FontIcons) do
    Free_And_Nil(FontIcons[I]);
end;



initialization
  LoadFontIcons;

finalization
  FreeFontIcons

end.