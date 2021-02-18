#include "share.h"

class THIMemoryStream:public TDebug
{
   private:
   public:
    TMemoryStream *_prop_Stream;
    THI_Event *_data_SrcStream;

    HI_WORK_LOC(THIMemoryStream,_work_doCopy);
    HI_WORK(_var_Stream){ CreateData(_Data,_hie(THIMemoryStream)->_prop_Stream); }
    HI_WORK(_work_doPosition){ _hie(THIMemoryStream)->_prop_Stream->Position = ToInteger(_Data); }
    HI_WORK(_work_doClear){ _hie(THIMemoryStream)->_prop_Stream->Clear(); }
    HI_WORK(_var_Size){ CreateData(_Data,_hie(THIMemoryStream)->_prop_Stream->Size()); }
};

////////////////////////////////////////////////////////////////////////

void THIMemoryStream::_work_doCopy(TData &_Data,WORD Index)
{
   _prop_Stream->Position = 0;
   TStream *St = ReadStream(_Data,_data_SrcStream,NULL);
   if( St )
     _prop_Stream->CopyFrom(St);
}
