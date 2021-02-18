#include "share.h"
#include "wininet.h"

class THIHTTP_Get:public TDebug
{
   private:
    //th:PThread;
    bool FStop;
    TData GData;
    long FSize;
    bool FBusy;

    void ShowInfo()
    {
      _hi_onEvent(_event_onStatus,FSize);
     }
    void Execute();
   public:
    string _prop_URL;
    string _prop_FileName;
    bool _prop_Wait;

   THI_Event *_data_FileName;
   THI_Event *_data_URL;
   THI_Event *_data_Position;
   THI_Event *_event_onURLSize;
   THI_Event *_event_onDownload;
   THI_Event *_event_onStatus;
   THI_Event *_event_onStop;

   THIHTTP_Get() { _data_FileName = _data_URL = _data_Position = _event_onURLSize = _event_onDownload = _event_onStatus = _event_onStop = NULL; }
   HI_WORK_LOC(THIHTTP_Get,_work_doDownload);
   HI_WORK(_work_doStop){ _hie(THIHTTP_Get)->FStop = true; }
   HI_WORK_LOC(THIHTTP_Get,_work_GetURLSize);
   HI_WORK(_var_Busy){ CreateData(_Data,(int)_hie(THIHTTP_Get)->FBusy); }
};

////////////////////////////////////////////////////////////////////////

long GetUrlInfo(string &FileURL)
{
  int Result = 0;
  HINTERNET hSession = InternetOpen(_his("Len HiAsm"),INTERNET_OPEN_TYPE_PRECONFIG,NULL,NULL,0);
  if(hSession)
  {
    HINTERNET hFile = InternetOpenUrl(hSession, PChar(FileURL),NULL, 0, INTERNET_FLAG_RELOAD, 0);
    ULONG dwIndex = 0;
    ULONG dwBufferLen = 20;
    HI_RSTRING buf[20];
    if( HttpQueryInfo(hFile, HTTP_QUERY_CONTENT_LENGTH, buf, &dwBufferLen, &dwIndex) )
      Result = StrToInt(string(buf));
    if(hFile) InternetCloseHandle(hFile);
    InternetCloseHandle(hSession);
  }
  return Result;
}

void THIHTTP_Get::Execute()
{
   FBusy = true;
   HINTERNET NetHandle = InternetOpen(_his("HiAsm"),INTERNET_OPEN_TYPE_DIRECT,NULL,NULL,0);
   FStop = false;
   if(NetHandle)
   {
     string Url = ReadString(GData,_data_URL,_prop_URL);
     _hi_onEvent(_event_onStop, Url);
     HINTERNET UrlHandle = InternetOpenUrl(NetHandle, PChar(Url),NULL,0,0,1);
     if(UrlHandle)
     {
       ULONG BytesRead = ReadInteger(GData,_data_Position,0);
       if( BytesRead )
         InternetSetFilePointer(UrlHandle,BytesRead,NULL,0,0);

       char Buffer[1024];
       FSize = 0;

       string FName = ReadString(GData,_data_FileName,_prop_FileName);
       TStream *fs;
       if( FName.Empty() )
         fs = new TMemoryStream();
       else fs = new TFileStream(FName,string(_his("wb")));

       do {
            ZeroMemory(Buffer,1024);
            InternetReadFile(UrlHandle, Buffer, 1024, &BytesRead);
            if(BytesRead) {
                fs->Write(Buffer,BytesRead);
                FSize += BytesRead;
        
                if(_prop_Wait)
                   ShowInfo();
                else {
                   //else th.Synchronize( ShowInfo );
                }
            }
       } while( BytesRead && !FStop );
       
       InternetCloseHandle(UrlHandle);
       if( FName.Empty() )
       {
          fs->Position = 0;
          _hi_onEvent(_event_onDownload,fs);
          delete fs;
       }
       else
       {
          delete fs;
          _hi_onEvent(_event_onDownload);
       }
      }
     else MessageBox(NULL,_his("Can''t open URL!"),PChar(IntToStr(GetLastError())),MB_OK);  //_his("Error")
     InternetCloseHandle(NetHandle);
    }
   else MessageBox(NULL,_his("I can not connect to Internet!"),_his("Error"),MB_OK);
   FBusy = false;
   _hi_onEvent(_event_onStop);
}

void THIHTTP_Get::_work_doDownload(TData &_Data,WORD Index)
{
   GData = _Data;
   if( _prop_Wait )
    Execute();
   else
   {
      // create thread
   }
}

void THIHTTP_Get::_work_GetURLSize(TData &_Data,WORD Index)
{
   string Url = ReadString(_Data,_data_URL,_prop_URL);
   _hi_onEvent(_event_onURLSize,GetUrlInfo(Url));
}

