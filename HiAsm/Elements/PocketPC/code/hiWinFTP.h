#include "share.h"
#include "wininet.h"

class THIWinFTP:public TDebug
{
   private:
    HINTERNET hNet,hFTP;
   public:
    string _prop_Host;
    string _prop_Username;
    string _prop_Password;
    int _prop_Port;
    string _prop_Directory;
    string _prop_RemoteName;

    THI_Event *_data_LocalName;
    THI_Event *_data_RemoteName;

    THI_Event *_event_onWriteProgress;
    THI_Event *_event_onReadProgress;
    THI_Event *_event_onError;
    THI_Event *_event_onConnect;
    THI_Event *_event_onRead;
    THI_Event *_event_onWrite;

    HI_WORK_LOC(THIWinFTP,_work_doOpen);
    HI_WORK_LOC(THIWinFTP,_work_doClose);
    HI_WORK_LOC(THIWinFTP,_work_doReadFile);
    HI_WORK_LOC(THIWinFTP,_work_doWriteFile);
};

/////////////////////////////////////////////////////////////////////////

void THIWinFTP::_work_doOpen(TData &_Data,WORD Index)
{
   hNet = InternetOpen(_his("HiAsm WinFTP"),INTERNET_OPEN_TYPE_PRECONFIG,NULL,NULL,0);
   if( !hNet )
   {
     _hi_onEvent(_event_onError,1);
     return;
   }

   string Host = _prop_Host;
   string User = _prop_Username;
   string Pass = _prop_Password;
   hFTP = InternetConnect(hNet,PChar(Host),_prop_Port,PChar(User),PChar(Pass),INTERNET_SERVICE_FTP,0,0);
   if( !hFTP )
   {
     InternetCloseHandle(hNet);
     _hi_onEvent(_event_onError,2);
     return;
   }

   if( !FtpSetCurrentDirectory(hFTP, PChar(_prop_Directory)) )
     _hi_onEvent(_event_onError,3);
   _hi_onEvent(_event_onConnect);
}

void THIWinFTP::_work_doClose(TData &_Data,WORD Index)
{
   InternetCloseHandle(hFTP);
   InternetCloseHandle(hNet);
}

#define READ_BUFFERSIZE 4096

void THIWinFTP::_work_doReadFile(TData &_Data,WORD Index)
{
  _Data = ReadData(_Data,_data_LocalName,NULL);
  string fn = ReadString(_Data,_data_RemoteName,_prop_RemoteName);

  WIN32_FIND_DATA sRec;
  if( FtpFindFirstFile(hFTP, PChar(fn), &sRec, 0, 0) )
  {
     int fileSize = sRec.nFileSizeLow;
  }
  else
  {
    _hi_onEvent(_event_onError,4);
    return;
  }

  HINTERNET hFile = FtpOpenFile(hFTP,PChar(fn),GENERIC_READ,FTP_TRANSFER_TYPE_BINARY, 0);
  if( !hFile )
  {
    _hi_onEvent(_event_onError,5);
    return;
  }

  TStream *st;
  if _IsStream(_Data)
    st = ToStream(_Data);
  else st = new TFileStream(ToString(_Data),string(_his("w")));

  char buffer[READ_BUFFERSIZE];
  ULONG bufsize = READ_BUFFERSIZE;

  while( bufsize )
  {
    if( !InternetReadFile(hFile, buffer,READ_BUFFERSIZE,&bufsize) )
       break;
    if( (bufsize > 0) && (bufsize <= READ_BUFFERSIZE) )
      st->Write(buffer, bufsize);
    _hi_onEvent(_event_onReadProgress,st->Position);
  }
  InternetCloseHandle(hFile);
  if( !_IsStream(_Data) )
    delete st;
  _hi_onEvent(_event_onRead);
}

void THIWinFTP::_work_doWriteFile(TData &_Data,WORD Index)
{
  TData dt = ReadData(_Data,_data_LocalName,NULL);
  string fn = ReadString(_Data,_data_RemoteName,_prop_RemoteName);

  HINTERNET hFile = FtpOpenFile(hFTP,PChar(fn),GENERIC_WRITE,FTP_TRANSFER_TYPE_BINARY, 0);
  if( !hFile )
  {
    _hi_onEvent(_event_onError,5);
    return;
  }

  TStream *st;
  if _IsStream(dt)
    st = ToStream(dt);
  else st = new TFileStream(ToString(dt),string(_his("w")));

  ULONG bufsize;
  char buffer[READ_BUFFERSIZE];
  while( st->Position < st->Size() )
  {
    bufsize = READ_BUFFERSIZE;
    bufsize = st->Read(buffer, bufsize);
    if( !InternetWriteFile(hFile, buffer,bufsize,&bufsize) ) break;
    _hi_onEvent(_event_onWriteProgress,st->Position);
  }
  InternetCloseHandle(hFile);
  if( !_IsStream(dt) )
    delete st;

  _hi_onEvent(_event_onWrite);
}
