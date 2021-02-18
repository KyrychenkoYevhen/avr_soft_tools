#include "share.h"

int Sc[] = {1,1024,1024*1024};

class THIMemoryStatus:public TDebug
{
   private:
     MEMORYSTATUS lpMemoryStatus;
   public:
    BYTE _prop_Scale;

    HI_WORK_LOC(THIMemoryStatus,_work_Refresh)
    {
      lpMemoryStatus.dwLength = sizeof(MEMORYSTATUS);
      GlobalMemoryStatus(&lpMemoryStatus);
    }
    HI_WORK_LOC(THIMemoryStatus,_var_RAM)
    {
      CreateData(_Data,(int)(lpMemoryStatus.dwTotalPhys/Sc[_prop_Scale]));
    }
    HI_WORK_LOC(THIMemoryStatus,_var_RAM_free)
    {
      CreateData(_Data,(int)(lpMemoryStatus.dwAvailPhys/Sc[_prop_Scale]));
    }
    HI_WORK_LOC(THIMemoryStatus,_var_PageFile)
    {
      CreateData(_Data,(int)(lpMemoryStatus.dwTotalPageFile/Sc[_prop_Scale]));
    }
    HI_WORK_LOC(THIMemoryStatus,_var_PageFile_free)
    {
      CreateData(_Data,(int)(lpMemoryStatus.dwAvailPageFile/Sc[_prop_Scale]));
    }
    HI_WORK_LOC(THIMemoryStatus,_var_Virtual)
    {
      CreateData(_Data,(int)(lpMemoryStatus.dwTotalVirtual/Sc[_prop_Scale]));
    }
    HI_WORK_LOC(THIMemoryStatus,_var_Virtual_free)
    {
      CreateData(_Data,(int)(lpMemoryStatus.dwAvailVirtual/Sc[_prop_Scale]));
    }
};

//////////////////////////////////////////////////////////////////////////

