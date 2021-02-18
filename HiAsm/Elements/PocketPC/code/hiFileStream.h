#include "share.h"

class THIFileStream:public TDebug
{
   private:
    TFileStream *Fs;
    void Close()
    {
      if( Fs )
      {
       delete Fs;
       Fs = NULL;
      }
    }
   public:
    string _prop_FileName;
    BYTE _prop_Mode;
    bool _prop_AutoCopy;

    THI_Event *_data_FileName;
    THI_Event *_event_onLoad;

    HI_WORK_LOC(THIFileStream,_work_doOpen);
    HI_WORK(_work_doClose){ _hie(THIFileStream)->Close(); }
    HI_WORK_LOC(THIFileStream,_work_doCopyFromStream);
    HI_WORK_LOC(THIFileStream,_work_doPosition){   if(Fs) Fs->Position = ToInteger(_Data); }
    HI_WORK(_var_Stream){ CreateData(_Data,_hie(THIFileStream)->Fs); }
    HI_WORK_LOC(THIFileStream,_var_Size){ CreateData(_Data,(Fs)?Fs->Size():0); }
    HI_WORK_LOC(THIFileStream,_var_Position){ CreateData(_Data,(Fs)?Fs->Position:-1); }
};

///////////////////////////////////////////////////////////////////////


void THIFileStream::_work_doOpen(TData &_Data,WORD Index)
{
  Close();
  string fn = ReadFileName(ReadString(_Data,_data_FileName,_prop_FileName));
  if( _prop_Mode == 2 )
    Fs = new TFileStream(fn,string(_his("r+")));
  else if( _prop_Mode == 1 )
    Fs = new TFileStream(fn,string(_his("wb")));
  else
  {
   if( FileExists(fn) )
    Fs = new TFileStream(fn,string(_his("r")));
   else
   {
     //MessageBox(0,'File name not found!','File stream Error',MB_OK);
     return;
   }
  }
  _hi_CreateEvent(_Data,_event_onLoad,Fs);
}

void THIFileStream::_work_doCopyFromStream(TData &_Data,WORD Index)
{
   TData dt;
   dt.data_type = data_null;

   if( !Fs && _prop_AutoCopy )
     _work_doOpen(dt,0);

   if( Fs && (_IsStream(_Data)) )
    if( _prop_Mode == 0 )
       MessageBox(ReadHandle,_his("Please set Mode property to Write"),_his("File stream Error"),MB_OK);
    else
    {
       Fs->CopyFrom(ToStream(_Data));
    }

   if( Fs && _prop_AutoCopy )
     Close();
}
