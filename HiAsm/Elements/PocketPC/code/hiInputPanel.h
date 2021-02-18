#include "share.h"
#include "aygshell.h"

class THIInputPanel:public TDebug
{
   private:
   public:
    HI_WORK(_work_doUp){ SHSipPreference(ReadHandle,SIP_UP); }
    HI_WORK(_work_doDown){ SHSipPreference(ReadHandle,SIP_DOWN); }
};

//////////////////////////////////////////////////////////////////////////
