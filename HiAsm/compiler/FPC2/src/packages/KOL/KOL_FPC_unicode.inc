// ================== For UNICODE from WINDOWS.PAS (temporary) =================== //

const
  HW_PROFILE_GUIDLEN = 39;                 { 36-characters plus NULL terminator }
  MAX_PROFILE_LEN = 80;

type

  MakeIntAtomW = PWideChar;
  
  _RECOVERY_AGENT_INFORMATIONW = record
    NextEntryOffset: DWORD;
    AgentNameLength: DWORD;
    AgentInformation: array[0..0] of WideChar;
  end;
  RECOVERY_AGENT_INFORMATIONW = _RECOVERY_AGENT_INFORMATIONW;
  TRecoveryAgentInformationW = _RECOVERY_AGENT_INFORMATIONW;
  PRecoveryAgentInformationW = ^TRecoveryAgentInformationW;
  
  
  tagHW_PROFILE_INFOW = {packed} record
    dwDockInfo: DWORD;
    szHwProfileGuid: packed array[0..HW_PROFILE_GUIDLEN-1] of WideChar;
    szHwProfileName: packed array[0..MAX_PROFILE_LEN-1] of WideChar;
  end;

  THWProfileInfoW = tagHW_PROFILE_INFOW;
  PHWProfileInfoW = ^THWProfileInfoW;
  
  _DISPLAY_DEVICEW = {packed} record
    cb: DWORD;
    DeviceName: array[0..31] of WideChar;
    DeviceString: array[0..127] of WideChar;
    StateFlags: DWORD;
  end;
  TDisplayDeviceW = _DISPLAY_DEVICEW;
  PDisplayDeviceW = ^TDisplayDeviceW;
  
  
  tagPOLYTEXTW = {packed} record
    x: Integer;
    y: Integer;
    n: UINT;
    PAnsiChar: PWideChar;
    uiFlags: UINT;
    rcl: TRect;
    pdx: PINT;
  end;
  //tagPOLYTEXTW = Windows.TPOLYTEXT;
  POLYTEXTW = tagPOLYTEXTW;
  TPolyTextW = tagPOLYTEXTW;
  PPolyTextW = ^TPolyTextW;
  
  tagGCP_RESULTSW = {packed} record
    lStructSize: DWORD;
    lpOutString: PWideChar;
    lpOrder: PUINT;
    lpDx: PINT;
    lpCaretPos: PINT;
    lpClass: PWideChar;
    lpGlyphs: PUINT;
    nGlyphs: UINT;
    nMaxFit: Integer;
  end;
  //GCP_RESULTSW = Windows.GCP_RESULTS;
  GCP_RESULTSW = tagGCP_RESULTSW;
  TGCPResultsW = GCP_RESULTSW;
  PGCPResultsW = ^TGCPResultsW;
  
  TFNOldFontEnumProcW = TFarProc;
  TFNFontEnumProcW = TFarProc;
  
const
  MM_MAX_AXES_NAMELEN = 16;
  MM_MAX_NUMAXES = 16;
  
type

  tagAXISINFOW = {packed} record
    axMinValue: Longint;
    axMaxValue: Longint;
    axAxisName: array[0..MM_MAX_AXES_NAMELEN-1] of WideChar;
  end;
  TAxisInfoW = tagAXISINFOW;
  PAxisInfoW = ^TAxisInfoW;
  
  tagAXESLISTW = {packed} record
    axlReserved: DWORD;
    axlNumAxes: DWORD;
    axlAxisInfo: array[0..MM_MAX_NUMAXES-1] of TAxisInfoW;
  end;
  TAxesListW = tagAXESLISTW;
  PAxesListW = ^TAxesListW;
  
  tagDESIGNVECTOR = {packed} record
    dvReserved: DWORD;
    dvNumAxes: DWORD;
    dvValues: array[0..MM_MAX_NUMAXES-1] of Longint;
  end;
  TDesignVector = tagDESIGNVECTOR;
  PDesignVector = ^TDesignVector;
  
  tagENUMLOGFONTEXDVW = {packed} record
    elfEnumLogfontEx: TEnumLogFontExW;
    elfDesignVector: TDesignVector;
  end;
  TEnumLogFontExDVW = tagENUMLOGFONTEXDVW;
  PEnumLogFontExDVW = ^TEnumLogFontExDVW;
  
  tagENUMTEXTMETRICW = {packed} record
    etmNewTextMetricEx: TNewTextMetricExW;
    etmAxesList: TAxesListW;
  end;
  TEnumTextMetricW = tagENUMTEXTMETRICW;
  PEnumTextMetricW = ^TEnumTextMetricW;
  
  
  {DOCINFOW = Windows.DOCINFO;
  TDocInfoW = DOCINFOW;
  PDocInfoW = ^TDocInfoW;}
  
  tagCREATESTRUCTW = {packed} record
    lpCreateParams: Pointer;
    hInstance: HINST;
    hMenu: HMENU;
    hwndParent: HWND;
    cy: Integer;
    cx: Integer;
    y: Integer;
    x: Integer;
    style: Longint;
    lpszName: PWideChar;
    lpszClass: PWideChar;
    dwExStyle: DWORD;
  end;
  //CREATESTRUCTW = Windows.CREATESTRUCT;
  CREATESTRUCTW = tagCREATESTRUCTW;
  TCreateStructW = CREATESTRUCTW;
  PCreateStructW = ^TCreateStructW;
  
  TPRMsgBoxCallback = procedure(var lpHelpInfo: THelpInfo);
  
  tagMSGBOXPARAMSW = {packed} record
    cbSize: UINT;
    hwndOwner: HWND;
    hInstance: HINST;
    lpszText: PWideChar;
    lpszCaption: PWideChar;
    dwStyle: DWORD;
    lpszIcon: PWideChar;
    dwContextHelpId: DWORD;
    lpfnMsgBoxCallback: TPRMsgBoxCallback;
    dwLanguageId: DWORD;
  end;
  //MSGBOXPARAMSW = Windows.MSGBOXPARAMS;
  MSGBOXPARAMSW = tagMSGBOXPARAMSW;
  TMsgBoxParamsW = MSGBOXPARAMSW;
  PMsgBoxParamsW = ^TMsgBoxParamsW;
  
  //TMDICreateStructW = Windows.MDICREATESTRUCT;
  tagMDICREATESTRUCTW = {packed} record
    szClass: PWideChar;
    szTitle: PWideChar;
    hOwner: THandle;
    x: Integer;
    y: Integer;
    cx: Integer;
    cy: Integer;
    style: DWORD;
    lParam: LPARAM;  { app-defined stuff }
  end;
  TMDICreateStructW = tagMDICREATESTRUCTW;
  PMDICreateStructW = ^TMDICreateStructW;
  
  tagNONCLIENTMETRICSW = {packed} record
    cbSize: UINT;
    iBorderWidth: Integer;
    iScrollWidth: Integer;
    iScrollHeight: Integer;
    iCaptionWidth: Integer;
    iCaptionHeight: Integer;
    lfCaptionFont: TLogFontW;
    iSmCaptionWidth: Integer;
    iSmCaptionHeight: Integer;
    lfSmCaptionFont: TLogFontW;
    iMenuWidth: Integer;
    iMenuHeight: Integer;
    lfMenuFont: TLogFontW;
    lfStatusFont: TLogFontW;
    lfMessageFont: TLogFontW;
  end;
  //NONCLIENTMETRICSW = Windows.NONCLIENTMETRICS;
  NONCLIENTMETRICSW = tagNONCLIENTMETRICSW;
  TNonClientMetricsW = NONCLIENTMETRICSW;
  PNonClientMetricsW = ^TNonClientMetricsW;
  
  tagICONMETRICSW = {packed} record
    cbSize: UINT;
    iHorzSpacing: Integer;
    iVertSpacing: Integer;
    iTitleWrap: Integer;
    lfFont: TLogFontW;
  end;
  //ICONMETRICSW = Windows.ICONMETRICS;
  ICONMETRICSW = tagICONMETRICSW;
  TIconMetricsW = ICONMETRICSW;
  PIconMetricsW = ^TIconMetricsW;
  
  tagSERIALKEYSW = {packed} record
    cbSize: UINT;
    dwFlags: DWORD;
    lpszActivePort: PWideChar;
    lpszPort: PWideChar;
    iBaudRate: UINT;
    iPortState: UINT;
    iActive: UINT;
  end;
  //SERIALKEYSW = Windows.SERIALKEYS;
  SERIALKEYSW = tagSERIALKEYSW;
  TSerialKeysW = SERIALKEYSW;
  PSerialKeysW = ^TSerialKeysW;
  
  tagHIGHCONTRASTW = {packed} record
    cbSize: UINT;
    dwFlags: DWORD;
    lpszDefaultScheme: PWideChar;
  end;
  //HIGHCONTRASTW = Windows.HIGHCONTRAST;
  HIGHCONTRASTW = tagHIGHCONTRASTW;
  THighContrastW = HIGHCONTRASTW;
  PHighContrastW = ^THighContrastW;
  
  tagSOUNDSENTRYW = {packed} record
    cbSize: UINT;
    dwFlags: DWORD;
    iFSTextEffect: DWORD;
    iFSTextEffectMSec: DWORD;
    iFSTextEffectColorBits: DWORD;
    iFSGrafEffect: DWORD;
    iFSGrafEffectMSec: DWORD;
    iFSGrafEffectColor: DWORD;
    iWindowsEffect: DWORD;
    iWindowsEffectMSec: DWORD;
    lpszWindowsEffectDLL: PWideChar;
    iWindowsEffectOrdinal: DWORD;
  end;
  //SOUNDSENTRYW = Windows.SOUNDSENTRY;
  SOUNDSENTRYW = tagSOUNDSENTRYW;
  TSoundsEntryW = SOUNDSENTRYW;
  PSoundsEntryW = ^TSoundsEntryW;
  
  _numberfmtW = {packed} record
    NumDigits: UINT;        { number of decimal digits }
    LeadingZero: UINT;      { if leading zero in decimal fields }
    Grouping: UINT;         { group size left of decimal }
    lpDecimalSep: PWideChar;   { ptr to decimal separator WideString }
    lpThousandSep: PWideChar;  { ptr to thousand separator WideString }
    NegativeOrder: UINT;    { negative number ordering }
  end;
  //NUMBERFMTW = Windows.NUMBERFMT;
  NUMBERFMTW = _numberfmtW;
  TNumberFmtW = NUMBERFMTW;
  PNumberFmtW = ^TNumberFmtW;
  
  _currencyfmtW = {packed} record
    NumDigits: UINT;           { number of decimal digits }
    LeadingZero: UINT;         { if leading zero in decimal fields }
    Grouping: UINT;            { group size left of decimal }
    lpDecimalSep: PWideChar;      { ptr to decimal separator WideString }
    lpThousandSep: PWideChar;     { ptr to thousand separator WideString }
    NegativeOrder: UINT;       { negative currency ordering }
    PositiveOrder: UINT;       { positive currency ordering }
    lpCurrencySymbol: PWideChar;  { ptr to currency symbol WideString }
  end;
  //CURRENCYFMTW = Windows.CURRENCYFMT;
  //_currencyfmtW = CURRENCYFMTW;
  CURRENCYFMTW = _currencyfmtW;
  TCurrencyFmtW = CURRENCYFMTW;
  PCurrencyFmtW = ^TCurrencyFmtW;
  
  pvalueW = {packed} record
    pv_valuename: PWideChar;           { The value name pointer }
    pv_valuelen: BOOL;
    pv_value_context: Pointer;
    pv_type: DWORD;
  end;
  TPValueW = pvalueW;
  PPValueW = ^TPValueW;
  
  value_entW = {packed} record
    ve_valuename: PWideChar;
    ve_valuelen: DWORD;
    ve_valueptr: DWORD;
    ve_type: DWORD;
  end;
  //VALENTW = Windows.VALENT;
  VALENTW = value_entW;
  TValueEntW = VALENTW;
  PValueEntW = ^TValueEntW;
  
  _NETRESOURCEW = {packed} record
    dwScope: DWORD;
    dwType: DWORD;
    dwDisplayType: DWORD;
    dwUsage: DWORD;
    lpLocalName: PWideChar;
    lpRemoteName: PWideChar;
    lpComment: PWideChar;
    lpProvider: PWideChar;
  end;
  //NETRESOURCEW = Windows.NETRESOURCE;
  NETRESOURCEW = _NETRESOURCEW;
  TNetResourceW = NETRESOURCEW;
  PNetResourceW = ^TNetResourceW;
  
  _DISCDLGSTRUCTW = {packed} record
    cbStructure: DWORD;       { size of this structure in bytes }
    hwndOwner: HWND;          { owner window for the dialog }
    lpLocalName: PWideChar;       { local device name }
    lpRemoteName: PWideChar;      { network resource name }
    dwFlags: DWORD;
  end;
  //DISCDLGSTRUCTW = Windows.DISCDLGSTRUCT;
  //_DISCDLGSTRUCTW = DISCDLGSTRUCTW;
  DISCDLGSTRUCTW = _DISCDLGSTRUCTW;
  TDiscDlgStructW = _DISCDLGSTRUCTW;
  PDiscDlgStructW = ^TDiscDlgStructW;
  
  _UNIVERSAL_NAME_INFOW = {packed} record
    lpUniversalName: PWideChar;
  end;
  //UNIVERSAL_NAME_INFOW = Windows.UNIVERSAL_NAME_INFO;
  UNIVERSAL_NAME_INFOW = _UNIVERSAL_NAME_INFOW;
  TUniversalNameInfoW = UNIVERSAL_NAME_INFOW;
  PUniversalNameInfoW = ^TUniversalNameInfoW;
  
  _REMOTE_NAME_INFOW = {packed} record
    lpUniversalName: PWideChar;
    lpConnectionName: PWideChar;
    lpRemainingPath: PWideChar;
  end;
  //REMOTE_NAME_INFOW = Windows.REMOTE_NAME_INFO;
  REMOTE_NAME_INFOW = _REMOTE_NAME_INFOW;
  TRemoteNameInfoW = REMOTE_NAME_INFOW;
  PRemoteNameInfoW = ^TRemoteNameInfoW;
  
  _FINDEX_INFO_LEVELS = (FindExInfoStandard, FindExInfoMaxInfoLevel);
  TFindexInfoLevels = _FINDEX_INFO_LEVELS;
  FINDEX_INFO_LEVELS = _FINDEX_INFO_LEVELS;  
  
  _FINDEX_SEARCH_OPS = (FindExSearchNameMatch, FindExSearchLimitToDirectories,
    FindExSearchLimitToDevices, FindExSearchMaxSearchOp);
  TFindexSearchOps = _FINDEX_SEARCH_OPS;
  FINDEX_SEARCH_OPS = _FINDEX_SEARCH_OPS;
  
  { Alt-Tab Switch window information. }
  PAltTabInfo = ^TAltTabInfo;
  tagALTTABINFO = {packed} record
    cbSize: DWORD;
    cItems: Integer;
    cColumns: Integer;
    cRows: Integer;
    iColFocus: Integer;
    iRowFocus: Integer;
    cxItem: Integer;
    cyItem: Integer;
    ptStart: TPoint;
  end;
  TAltTabInfo = tagALTTABINFO;
  
  //MENUITEMINFOW = Windows.MENUITEMINFO;
  //TMenuitemInfoW = MENUITEMINFOW;
  //PMenuitemInfoW = ^TMenuitemInfoW;
  
  
  TFNProgressRoutine = TFarProc;
  TFNLocaleEnumProc = TFarProc;
  TFNCodepageEnumProc = TFarProc;
  TFNDateFmtEnumProc = TFarProc;
  TFNTimeFmtEnumProc = TFarProc;
  TFNCalInfoEnumProc = TFarProc;
  
  TFNICMEnumProc = TFarProc;
  
  TFNGrayStringProc = TFarProc;
  TFNSendAsyncProc = TFarProc;
  TFNDrawStateProc = TFarProc;
  
  TFNPropEnumProc = TFarProc;
  TFNPropEnumProcEx = TFarProc;
  
  //TFNEditWordBreakProc = TFarProc;
  TFNNameEnumProc = TFarProc;

  TFNWinStaEnumProc = TFNNameEnumProc;
  TFNDeskTopEnumProc = TFNNameEnumProc;
  


// ================================================================================= //


