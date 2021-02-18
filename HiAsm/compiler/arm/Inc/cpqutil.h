//============================================================================
// Filename: cpqutil.h  
// Author: Luke Olbrish
// Abstract: This library has special functions that allow programs to adjust
//      iPAQ settings.
//
//   Date   Who                          Changes Made
// -------- ---	--------------------------------------------------------------
// 07/06/00 LAO Created CPQUtil
//
//============================================================================

// Definitions of the brightness levels of the frontlight
#define BL_POWER_SAVE   (0)
#define BL_LOW_BRIGHT   (1)
#define BL_MED_BRIGHT   (2)
#define BL_HIGH_BRIGHT  (3)
#define BL_SUPER_BRIGHT (4)
#define FLASH_BLOCK_ADDRESS 0xa0000000

#ifdef	__cplusplus
extern "C" {
#endif

//Functions
BOOL CPQReset ( void );
BOOL CPQSetBrightness ( DWORD dwBrightnessLevel );
DWORD CPQGetBrightness ( void );
BOOL CPQGetAutoBrightness ( void );
BOOL CPQGetMicrophoneAGC ( void );
BOOL CPQSetMicrophoneAGC ( BOOL boolAGCStatus );
BOOL CPQSetAutoBrightness ( BOOL boolIsAutoBright );
BOOL GetChipIDs(UINT32 dwBlockAddress, TCHAR sChipOne[], TCHAR sChipTwo[]);

#ifdef	__cplusplus
}
#endif
