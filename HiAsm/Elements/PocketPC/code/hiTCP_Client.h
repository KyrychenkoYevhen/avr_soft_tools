#ifndef __HITCP_CLIENT_H_
#define __HITCP_CLIENT_H_

#include "share.h"
#include "winsock2.h"

class THITCP_Client:public TDebug
{
   private:
    SOCKET Handle;
    string FIP;
    string resData;

    bool FStop;
    HANDLE FListenHandle;

    void Err(int Index);
   public:
    int FTimer;

    int _prop_Port;
    string _prop_IP;
    BYTE _prop_DataType;

    THI_Event *_data_IP;
    THI_Event *_data_Port;
    THI_Event *_data_Data;
    THI_Event *_event_onConnect;
    THI_Event *_event_onDisconnect;
    THI_Event *_event_onRead;
    THI_Event *_event_onError;

    THITCP_Client(){ _data_Data = NULL; _data_IP = NULL; _data_Port = NULL; _event_onRead = NULL; _event_onConnect = NULL; _event_onDisconnect = NULL; _event_onError = NULL;}
    ~THITCP_Client(){ Close(); }
    HI_WORK_LOC(THITCP_Client,_work_doOpen);
    HI_WORK_LOC(THITCP_Client,_work_doClose);
    HI_WORK_LOC(THITCP_Client,_work_doSend);
    HI_WORK(_var_Active){ CreateData(_Data,(int)(_hie(THITCP_Client)->Handle > 0)); }

    void Execute();
    void Close();
};

//////////////////////////////////////////////////////////////////

DWORD __stdcall TCP_ListenFunc(void *Parent)
{
   ((THITCP_Client *)Parent)->Execute();
   return 0;
}

void __stdcall TCP_TimerProc(HWND hwnd,UINT uMsg,UINT idEvent,DWORD dwTime)
{
  KillTimer(ReadHandle,((THITCP_Client *)idEvent)->FTimer);
  ((THITCP_Client *)idEvent)->Close();
}

void THITCP_Client::_work_doOpen(TData &_Data,WORD Index)
{
  WSADATA ws;
  WSAStartup(MAKEWORD(1,1),&ws);

  Handle = socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
  sockaddr_in SockAddr;
  ZeroMemory(&SockAddr,sizeof(SockAddr));

  SockAddr.sin_family = AF_INET;
  #ifdef UNICODE
   string _s = ReadString(_Data,_data_IP,_prop_IP);
   char buf[60];
   WideCharToMultiByte(CP_ACP,0,PChar(_s),-1,buf,60,NULL,NULL);
   SockAddr.sin_addr.s_addr = inet_addr(buf);
  #else
   SockAddr.sin_addr.s_addr = inet_addr(PChar(ReadString(_Data,_data_IP,_prop_IP)));
  #endif
  SockAddr.sin_port = htons(ReadInteger(_Data,_data_Port,_prop_Port));

  if( connect(Handle, (sockaddr *)&SockAddr, sizeof(SockAddr)) )
  {
     Close();
     Err(1);
     return;
  }

  FListenHandle = CreateThread(NULL,1024,TCP_ListenFunc,this,0,NULL);
  
  _hi_onEvent(_event_onConnect);
}

void THITCP_Client::Execute()
{
   TData dt;
   FStop = false;
   while( !FStop )
   {
       fd_set FDSet;
       FD_ZERO(&FDSet);
       FD_SET(Handle, &FDSet);
       timeval tm,*rtm;
       tm.tv_sec = 1;
       tm.tv_usec = 0;
       rtm = &tm;

       if( select(0,&FDSet,NULL,NULL,rtm) > 0 )
       {
         ULONG len;
         ioctlsocket(Handle, FIONREAD, &len);
         if(len == 0)
         {
            FTimer = SetTimer(ReadHandle,(long)this,1,TCP_TimerProc);
            return;
         }
         char *s = new char[len];
         recv(Handle,s,len,0);
         #ifdef UNICODE
          HI_STRING buf;
          AtoU(s,&buf);
          _hi_onEvent(_event_onRead,string(buf));
          delete buf;
         #else
          _hi_onEvent(_event_onRead, string(s));
         #endif
       }
   }
}

void THITCP_Client::Err(int Index)
{
   _hi_onEvent(_event_onError,Index);
}

void THITCP_Client::Close()
{
   if( FListenHandle )
   {
     FStop = true;
     TerminateThread(FListenHandle,0);
     FListenHandle = NULL;
     closesocket(Handle);
     Handle = 0;
     _hi_onEvent(_event_onDisconnect);
   }
}

void THITCP_Client::_work_doSend(TData &_Data,WORD Index)
{
   string s = ReadString(_Data,_data_Data,string(_his("")));
   #ifdef UNICODE
    char *buf = new char[s.Length()+1];
    WideCharToMultiByte(CP_ACP,0,PChar(s),-1,buf,s.Length()+1,NULL,NULL);
    send(Handle,buf,s.Length(),0);
    delete buf;
   #else
    send(Handle,PChar(s),s.Length(),0);
   #endif
}

void THITCP_Client::_work_doClose(TData &_Data,WORD Index)
{
   Close();
}

#endif
