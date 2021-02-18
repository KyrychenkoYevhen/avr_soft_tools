#include "share.h"

class THIFileTools:public TDebug
{
   private:
   public:
    //BYTE _prop_DelToRecycle;
    THI_Event *_data_NewFileName;
    THI_Event *_data_FileName;
    THI_Event *_event_onEnd;

    HI_WORK_LOC(THIFileTools,_work_doMove);
    HI_WORK_LOC(THIFileTools,_work_doCopy);
    HI_WORK_LOC(THIFileTools,_work_doDelete);
    HI_WORK_LOC(THIFileTools,_work_doFileExists);
};

//////////////////////////////////////////////////////////////////////////

void THIFileTools::_work_doMove(TData &_Data,WORD Index)
{
   string F1 = ReadString(_Data,_data_FileName,string(_his("")));
   string F2 = ReadString(_Data,_data_NewFileName,string(_his("")));
   MoveFile(PChar(F1),PChar(F2));
   if( FileExists(F2) )
     _hi_CreateEvent(_Data,_event_onEnd);
}

void THIFileTools::_work_doCopy(TData &_Data,WORD Index)
{
   string F1 = ReadString(_Data,_data_FileName,string(_his("")));
   string F2 = ReadString(_Data,_data_NewFileName,string(_his("")));
   CopyFile(PChar(F1),PChar(F2),false);
   if( FileExists(F2) )
     _hi_CreateEvent(_Data,_event_onEnd);
}

void THIFileTools::_work_doDelete(TData &_Data,WORD Index)
{
   string F1 = ReadString(_Data,_data_FileName,string(_his("")));
   //if( _prop_DelToRecycle == 0 )
   //   DeleteFile2Recycle(f1)
   //else
     DeleteFile(PChar(F1));
   if( !FileExists(F1) )
     _hi_CreateEvent(_Data,_event_onEnd);
}

void THIFileTools::_work_doFileExists(TData &_Data,WORD Index)
{
   if( FileExists(ReadString(_Data,_data_FileName,string(_his("")))) )
     _hi_CreateEvent(_Data,_event_onEnd,1);
   else _hi_CreateEvent(_Data,_event_onEnd,0);
}
