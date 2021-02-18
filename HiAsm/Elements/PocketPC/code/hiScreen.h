#include "share.h"
#include "cpqutil.h"

typedef struct
{
 ULONG Length;
 ULONG DPMSVersion;
 ULONG PowerState;
} VIDEO_POWER_MANAGEMENT;

typedef enum _VIDEO_POWER_STATE
{
 VideoPowerOn = 1,
 VideoPowerStandBy,
 VideoPowerSuspend,
 VideoPowerOff
} VIDEO_POWER_STATE;

#define SETPOWERMANAGEMENT 6147

class THIScreen:public TDebug
{
   public:
    HI_WORK_LOC(THIScreen,_work_doPower);
    HI_WORK(_work_doBrightness)
    {
      CPQSetBrightness(ToInteger(_Data));
    }
    HI_WORK(_var_Brightness)
    {
      CreateData(_Data,(int)CPQGetBrightness());
    }
    HI_WORK(_var_Width){ CreateData(_Data,GetDeviceCaps(GetDC(0),HORZRES)); }
    HI_WORK(_var_Height){ CreateData(_Data,GetDeviceCaps(GetDC(0),VERTRES)); }
};

/////////////////////////////////////////////////////////////////////

void THIScreen::_work_doPower(TData &_Data,WORD Index)
{
   VIDEO_POWER_MANAGEMENT vpm;
   vpm.Length = sizeof(VIDEO_POWER_MANAGEMENT);
   vpm.DPMSVersion = 0x0001;
   vpm.PowerState = ReadBool(_Data)?VideoPowerOn:VideoPowerOff;
   ExtEscape(GetDC(0), SETPOWERMANAGEMENT, vpm.Length, (LPCSTR) &vpm,0,NULL);
}
