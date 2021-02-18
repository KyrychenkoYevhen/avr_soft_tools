#include "share.h"
#include <winioctl.h>

#define IOCTL_HAL_REBOOT CTL_CODE(FILE_DEVICE_HAL, 15, METHOD_BUFFERED, FILE_ANY_ACCESS)

extern "C" __declspec(dllimport) BOOL KernelIoControl(
  DWORD dwIoControlCode,
  LPVOID lpInBuf,
  DWORD nInBufSize,
  LPVOID lpOutBuf,
  DWORD nOutBufSize,
  LPDWORD lpBytesReturned);

class THIExitWindows:public TDebug
{
   private:

   public:

    HI_WORK(_work_doPowerOff)
    {
      keybd_event(VK_OFF,0,KEYEVENTF_SILENT,0);
      keybd_event(VK_OFF,0,KEYEVENTF_SILENT|KEYEVENTF_KEYUP,0);
    }
    HI_WORK(_work_doReboot)
    {
      KernelIoControl(IOCTL_HAL_REBOOT, NULL, 0, NULL, 0, NULL);
    }
};

///////////////////////////////////////////////////////////////////////////


