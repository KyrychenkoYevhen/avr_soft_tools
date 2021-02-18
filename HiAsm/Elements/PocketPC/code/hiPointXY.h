#include "share.h"

class THIPointXY:public TDebug
{
   private:
   public:
    int _prop_X;
    int _prop_Y;
    THI_Event *_data_Y;
    THI_Event *_data_X;

    HI_WORK_LOC(THIPointXY,_var_Point);
};

////////////////////////////////////////////////////////////////

void THIPointXY::_var_Point(TData &_Data,WORD Index)
{
   _Data.data_type = data_null;
   CreateData(_Data,(ReadInteger(_Data,_data_Y,_prop_Y) << 16) + ReadInteger(_Data,_data_X,_prop_X));
}
