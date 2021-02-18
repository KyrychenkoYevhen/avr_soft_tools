unit hiFont;

interface

uses
  Windows, Kol, Share, Debug;

const
  CF_SCREENFONTS = $00000001;
  CF_PRINTERFONTS = $00000002;
  CF_BOTH = CF_SCREENFONTS OR CF_PRINTERFONTS;
  CF_SHOWHELP = $00000004;
  CF_ENABLEHOOK = $00000008;
  CF_ENABLETEMPLATE = $00000010;
  CF_ENABLETEMPLATEHANDLE = $00000020;
  CF_INITTOLOGFONTSTRUCT = $00000040;
  CF_USESTYLE = $00000080;
  CF_EFFECTS = $00000100;
  CF_APPLY = $00000200;
  CF_ANSIONLY = $00000400;
  CF_SCRIPTSONLY = CF_ANSIONLY;
  CF_NOVECTORFONTS = $00000800;
  CF_NOOEMFONTS = CF_NOVECTORFONTS;
  CF_NOSIMULATIONS = $00001000;
  CF_LIMITSIZE = $00002000;
  CF_FIXEDPITCHONLY = $00004000;
  CF_WYSIWYG = $00008000;  // must also have CF_SCREENFONTS & CF_PRINTERFONTS 
  CF_FORCEFONTEXIST = $00010000;
  CF_SCALABLEONLY = $00020000;
  CF_TTONLY = $00040000;
  CF_NOFACESEL = $00080000;
  CF_NOSTYLESEL = $00100000;
  CF_NOSIZESEL = $00200000;
  CF_SELECTSCRIPT = $00400000;
  CF_NOSCRIPTSEL = $00800000;
  CF_NOVERTFONTS = $01000000;



{$ifndef FPC_NEW}
type
  PChooseFontA = ^TChooseFontA;
  PChooseFontW = ^TChooseFontW;
  
  tagCHOOSEFONTA = packed record
    lStructSize: DWORD;
    hWndOwner: HWnd;            { caller's window handle }
    hDC: HDC;                   { printer DC/IC or nil }
    lpLogFont: PLogFontA;     { pointer to a LOGFONT struct }
    iPointSize: Integer;        { 10 * size in points of selected font }
    Flags: DWORD;               { dialog flags }
    rgbColors: COLORREF;        { returned text color }
    lCustData: LPARAM;          { data passed to hook function }
    lpfnHook: function(Wnd: HWND; Message: UINT; wParam: WPARAM; lParam: LPARAM): UINT stdcall;
                                { pointer to hook function }
    lpTemplateName: PAnsiChar;    { custom template name }
    hInstance: HINST;       { instance handle of EXE that contains
                                  custom dialog template }
    lpszStyle: PAnsiChar;         { return the style field here
                                  must be lf_FaceSize or bigger }
    nFontType: Word;            { same value reported to the EnumFonts
                                  call back with the extra fonttype_
                                  bits added }
    wReserved: Word;
    nSizeMin: Integer;          { minimum point size allowed and }
    nSizeMax: Integer;          { maximum point size allowed if
                                  cf_LimitSize is used }
  end;
  
  tagCHOOSEFONTW = packed record
    lStructSize: DWORD;
    hWndOwner: HWnd;            { caller's window handle }
    hDC: HDC;                   { printer DC/IC or nil }
    lpLogFont: PLogFontW;     { pointer to a LOGFONT struct }
    iPointSize: Integer;        { 10 * size in points of selected font }
    Flags: DWORD;               { dialog flags }
    rgbColors: COLORREF;        { returned text color }
    lCustData: LPARAM;          { data passed to hook function }
    lpfnHook: function(Wnd: HWND; Message: UINT; wParam: WPARAM; lParam: LPARAM): UINT stdcall;
                                { pointer to hook function }
    lpTemplateName: PWideChar;    { custom template name }
    hInstance: HINST;       { instance handle of EXE that contains
                                  custom dialog template }
    lpszStyle: PWideChar;         { return the style field here
                                  must be lf_FaceSize or bigger }
    nFontType: Word;            { same value reported to the EnumFonts
                                  call back with the extra fonttype_
                                  bits added }
    wReserved: Word;
    nSizeMin: Integer;          { minimum point size allowed and }
    nSizeMax: Integer;          { maximum point size allowed if
                                  cf_LimitSize is used }
  end;

  tagCHOOSEFONT = tagCHOOSEFONTA;
  TChooseFontA = tagCHOOSEFONTA;
  TChooseFontW = tagCHOOSEFONTW;
  
  TChooseFont = {$ifdef UNICODE}TChooseFontW{$else}TChooseFontA{$endif};
  PChooseFont = ^TChooseFont;
{$endif}

function ChooseFont(var ChooseFont: TChooseFont): Bool; stdcall; external 'comdlg32.dll'  name {$ifdef UNICODE}'ChooseFontW'{$else}'ChooseFontA'{$endif};

type
  THIFont = class(TDebug)
    private
      FR: TFontRec;
    public
      _prop_Font: TFontRec;
      _prop_FontDialog: Boolean;
      _data_Name: THI_Event;
      _data_Color: THI_Event;
      _data_Size: THI_Event;
      _data_Style: THI_Event;
      _data_CharSet: THI_Event;
      _event_onFont: THI_Event;

      procedure _work_doFont(var _Data: TData; Index: Word);
      procedure _var_FontName(var _Data: TData; Index: Word);    
      procedure _var_FontColor(var _Data: TData; Index: Word);
      procedure _var_FontSize(var _Data: TData; Index: Word);
      procedure _var_FontStyle(var _Data: TData; Index: Word);        
      procedure _var_FontStrStyle(var _Data: TData; Index: Word);
      procedure _var_FontCharSet(var _Data: TData; Index: Word);    
  end;




implementation



procedure THIFont._work_doFont;
var
  CF: TChooseFont;
  LF: TLogFont;
  //I: Integer;
begin
  FR.Size := ReadInteger(_Data, _data_Size, _prop_Font.Size);
  FR.Color := ReadInteger(_Data, _data_Color, _prop_Font.Color);
  FR.Name := ReadString(_Data, _data_Name, _prop_Font.Name);
  FR.Style := ReadInteger(_Data, _data_Style, _prop_Font.Style);
  FR.CharSet := ReadInteger(_Data, _data_CharSet, _prop_Font.CharSet);
  
  if _prop_FontDialog then
  begin
    FillChar(LF, SizeOf(LF), #0);
    FillChar(CF, SizeOf(CF), #0);
    
    CF.lStructSize := SizeOf(CF);
    CF.lpLogFont := @LF;
    CF.hWndOwner := ReadHandle;
    CF.Flags := CF_SCREENFONTS or CF_EFFECTS or CF_INITTOLOGFONTSTRUCT;
 
    // init Font_Name   
    //FillChar(LF.lfFaceName, SizeOf(LF.lfFaceName), #0);
    
    //for I := 1 to Length(FR.Name) do LF.lfFaceName[I-1] := FR.Name[I];
    Move(FR.Name[1], LF.lfFaceName[0], Min(Length(FR.Name), LF_FACESIZE-1) * SizeOf(Char));
    
    // init Font_Size
    LF.lfHeight := _hi_SizeFnt(FR.Size);
    // init Font_CharSet
    LF.lfCharSet := Byte(FR.CharSet);
    // init Font_Color
    CF.rgbColors := FR.Color;
    // init Font_Style   
    if FR.Style and 1 > 0 then LF.lfWeight := 700 {else LF.lfWeight := 0};
    if FR.Style and 2 > 0 then LF.lfItalic := 1 {else LF.lfItalic := 0};   
    if FR.Style and 4 > 0 then LF.lfUnderline := 1 {else LF.lfUnderline := 0};   
    if FR.Style and 8 > 0 then LF.lfStrikeOut := 1 {else LF.lfStrikeOut := 0};

    if ChooseFont(CF) then
    begin
      // assigned new Font_Name
      FR.Name := string(LF.lfFaceName);
      // assigned new Font_Size
      FR.Size := CF.iPointSize div 10;
      // assigned new Font_CharSet
      FR.CharSet := LF.lfCharSet;
      // assigned new Font_Color
      FR.Color := CF.rgbColors;
      // assigned new Font_Style
      FR.Style := 0;
      if LF.lfWeight >= 700 then FR.Style := 1;
      if LF.lfItalic    <> 0 then FR.Style := FR.Style + 2;
      if LF.lfUnderline <> 0 then FR.Style := FR.Style + 4;
      if LF.lfStrikeOut <> 0 then FR.Style := FR.Style + 8;
      _hi_OnEvent(_event_onFont, FR);
    end;
  end
  else   
    _hi_OnEvent(_event_onFont, FR);
end;

procedure THIFont._var_FontName;    
begin
  dtString(_Data, FR.Name);
end;

procedure THIFont._var_FontColor;
begin
  dtInteger(_Data, FR.Color);
end;

procedure THIFont._var_FontSize;
begin
  dtInteger(_Data, FR.Size);
end;

procedure THIFont._var_FontStyle;        
begin
  dtInteger(_Data, FR.Style);
end;

procedure THIFont._var_FontStrStyle;
var
  sFontStyle: string;
begin
  sFontStyle := '';
  if FR.Style and 1 <> 0 then sFontStyle := sFontStyle + 'b';
  if FR.Style and 2 <> 0 then sFontStyle := sFontStyle + 'i';   
  if FR.Style and 4 <> 0 then sFontStyle := sFontStyle + 'u';   
  if FR.Style and 8 <> 0 then sFontStyle := sFontStyle + 's';
  dtString(_Data, sFontStyle);
end;

procedure THIFont._var_FontCharSet;
begin
  dtInteger(_Data, FR.CharSet);
end;


end.
