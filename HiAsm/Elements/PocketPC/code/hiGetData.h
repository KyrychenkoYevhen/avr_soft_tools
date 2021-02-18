#include "share.h"

class THIGetData:public TDebug
{
   private:
   public:
    int _prop_Count;
    THI_Event *_data_Data;

    HI_WORK(Data)
    {
       _ReadData(_Data,_hie(THIGetData)->_data_Data);
    }
};

//#############################################################################

