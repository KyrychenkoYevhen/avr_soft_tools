// ================== From WINDOWS.PAS =================== //


const
  HW_PROFILE_GUIDLEN = 39;                 { 36-characters plus NULL terminator }
  MAX_PROFILE_LEN = 80;
  

type
  
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
  
  TFNEditWordBreakProc = TFarProc;
  TFNNameEnumProc = TFarProc;

  TFNWinStaEnumProc = TFNNameEnumProc;
  TFNDeskTopEnumProc = TFNNameEnumProc;
  
  MakeIntAtomA = PAnsiChar;

  _WIN32_FIND_DATAA = record
    dwFileAttributes: DWORD;
    ftCreationTime: TFileTime;
    ftLastAccessTime: TFileTime;
    ftLastWriteTime: TFileTime;
    nFileSizeHigh: DWORD;
    nFileSizeLow: DWORD;
    dwReserved0: DWORD;
    dwReserved1: DWORD;
    cFileName: array[0..MAX_PATH - 1] of AnsiChar;
    cAlternateFileName: array[0..13] of AnsiChar;
  end;  
  TWin32FindDataA = _WIN32_FIND_DATAA;
  PWin32FindDataA = ^TWin32FindDataA;
  
  
  tagHW_PROFILE_INFOA = packed record
    dwDockInfo: DWORD;
    szHwProfileGuid: packed array[0..HW_PROFILE_GUIDLEN-1] of AnsiChar;
    szHwProfileName: packed array[0..MAX_PROFILE_LEN-1] of AnsiChar;
  end;  
  PHWProfileInfoA = ^THWProfileInfoA;
  THWProfileInfoA = tagHW_PROFILE_INFOA;
  
  
  tagLOGCOLORSPACEA = packed record
    lcsSignature: DWORD;
    lcsVersion: DWORD;
    lcsSize: DWORD;
    lcsCSType: LCSCSTYPE;
    lcsIntent: LCSGAMUTMATCH;
    lcsEndpoints: TCIEXYZTriple;
    lcsGammaRed: DWORD;
    lcsGammaGreen: DWORD;
    lcsGammaBlue: DWORD;
    lcsFilename: array[0..259] of AnsiChar;
  end;  
  PLogColorSpaceA = ^TLogColorSpaceA;
  TLogColorSpaceA = tagLOGCOLORSPACEA;
  
  TFNOldFontEnumProcA = TFarProc;
  TFNFontEnumProcA = TFarProc;
  
  TPRMsgBoxCallback = procedure(var lpHelpInfo: THelpInfo);


  tagMDICREATESTRUCTA = packed record
    szClass: PAnsiChar;
    szTitle: PAnsiChar;
    hOwner: THandle;
    x: Integer;
    y: Integer;
    cx: Integer;
    cy: Integer;
    style: DWORD;
    lParam: LPARAM;  { app-defined stuff }
  end;
  PMDICreateStructA = ^TMDICreateStructA;
  TMDICreateStructA = tagMDICREATESTRUCTA;
  
  
  _FINDEX_INFO_LEVELS = (FindExInfoStandard, FindExInfoMaxInfoLevel);
  TFindexInfoLevels = _FINDEX_INFO_LEVELS;
  FINDEX_INFO_LEVELS = _FINDEX_INFO_LEVELS;  
  
  _FINDEX_SEARCH_OPS = (FindExSearchNameMatch, FindExSearchLimitToDirectories,
    FindExSearchLimitToDevices, FindExSearchMaxSearchOp);
  TFindexSearchOps = _FINDEX_SEARCH_OPS;
  FINDEX_SEARCH_OPS = _FINDEX_SEARCH_OPS;  
  

// ================== END from WINDOWS.PAS =================== //
  
