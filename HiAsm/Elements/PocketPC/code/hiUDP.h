#include "share.h"
#include "winsock2.h"

class THIUDP:public TDebug
{
   private:
    SOCKET Handle;
    string FIP;
    string resData;

    bool FStop;
    HANDLE FListenHandle;

    //void SyncExec();
    void Err(int Index);
    void Close();
   public:
    int _prop_LocalPort;
    int _prop_RemotePort;
    string _prop_LocalIP;
    string _prop_RemoteIP;
    bool _prop_AutoConnect;
    BYTE _prop_ReceiveMode;

    THI_Event *_data_Count;
    THI_Event *_data_LocalIP;
    THI_Event *_data_RemoteIP;
    THI_Event *_data_RemotePort;
    THI_Event *_data_LocalPort;
    THI_Event *_data_Data;
    THI_Event *_event_onReceive;
    THI_Event *_event_onError;

    ~THIUDP(){ Close(); }
    HI_WORK_LOC(THIUDP,_work_doOpen);
    HI_WORK_LOC(THIUDP,_work_doSend);
    HI_WORK_LOC(THIUDP,_work_doReceive);
    HI_WORK_LOC(THIUDP,_work_doSendTo);
    HI_WORK_LOC(THIUDP,_work_doReceiveFrom);
    HI_WORK_LOC(THIUDP,_work_doClose);
    HI_WORK(_var_ReceiveIP){ CreateData(_Data,_hie(THIUDP)->FIP); }
    HI_WORK(_var_Activate){ CreateData(_Data,(int)(_hie(THIUDP)->Handle > 0)); }

    void Execute();
};

//////////////////////////////////////////////////////////////////

inline UDP_Init()
{
  WSADATA ws;
  WSAStartup(MAKEWORD(1,1),&ws);
}

DWORD __stdcall ListenFunc(void *Parent)
{
   ((THIUDP *)Parent)->Execute();
   return 0;
}


void THIUDP::_work_doOpen(TData &_Data,WORD Index)
{
  UDP_Init();

  Handle = socket(AF_INET,SOCK_DGRAM,17);
  sockaddr_in SockAddr;
  ZeroMemory(&SockAddr,sizeof(SockAddr));

  SockAddr.sin_family = AF_INET;
  #ifdef UNICODE
   string _s = ReadString(_Data,_data_LocalIP,_prop_LocalIP);
   char buf[60];
   WideCharToMultiByte(CP_ACP,0,PChar(_s),-1,buf,60,NULL,NULL);
   SockAddr.sin_addr.s_addr = inet_addr(buf);
  #else
   SockAddr.sin_addr.s_addr = inet_addr(PChar(ReadString(_Data,_data_LocalIP,_prop_LocalIP)));
  #endif
  SockAddr.sin_port = htons(ReadInteger(_Data,_data_LocalPort,_prop_LocalPort));
  if( bind(Handle,(sockaddr *)&SockAddr,sizeof(SockAddr)) )
  {
     Close();
     Err(1);
     return;
  }

  if( _prop_AutoConnect )
  {
     #ifdef UNICODE
      string _s = ReadString(_Data,_data_RemoteIP,_prop_RemoteIP);
      char buf[60];
      WideCharToMultiByte(CP_ACP,0,PChar(_s),-1,buf,60,NULL,NULL);
      SockAddr.sin_addr.s_addr = inet_addr(buf);
     #else
      SockAddr.sin_addr.s_addr = inet_addr(PChar(ReadString(_Data,_data_RemoteIP,_prop_RemoteIP)));
     #endif
     SockAddr.sin_port = htons(ReadInteger(_Data,_data_RemotePort,_prop_RemotePort));
     if( connect(Handle, (sockaddr *)&SockAddr, sizeof(SockAddr)) )
     {
        Close();
        Err(2);
        return;
     }
  }
  if( _prop_ReceiveMode == 0 )
  {
     FListenHandle = CreateThread(NULL,1024,ListenFunc,this,0,NULL);
  }
}

void THIUDP::Execute()
{
   TData dt;
   FStop = false;
   while( !FStop )
   {
      _work_doReceive(dt,1);
   }
}


//procedure THIUDP.SyncExec;
//begin
//  _hi_OnEvent(_event_onReceive,ResData);
//end;

void THIUDP::Err(int Index)
{
   _hi_onEvent(_event_onError,Index);
}

void THIUDP::Close()
{
   if( FListenHandle )
   {
     FStop = true;
     TerminateThread(FListenHandle,0);
     FListenHandle = NULL;
   }
   closesocket(Handle);
   Handle = 0;
}

void THIUDP::_work_doSend(TData &_Data,WORD Index)
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

void THIUDP::_work_doReceive(TData &_Data,WORD Index)
{
   fd_set FDSet;
   FD_ZERO(&FDSet);
   FD_SET(Handle, &FDSet);
   timeval tm,*rtm;
   if(Index)
   {
    tm.tv_sec = 1;
    tm.tv_usec = 0;
    rtm = &tm;
   }else rtm = NULL;
   if( select(0,&FDSet,NULL,NULL,rtm) > 0 )
   {
     ULONG len;
     ioctlsocket(Handle, FIONREAD, &len);
     char *s = new char[len];
     recv(Handle,s,len,0);
     #ifdef UNICODE
      HI_STRING buf;
      AtoU(s,&buf);
      _hi_onEvent(_event_onReceive,string(buf));
      delete buf;
     #else
      _hi_onEvent(_event_onReceive,string(s));
     #endif
   }
}

void THIUDP::_work_doSendTo(TData &_Data,WORD Index)
{
   sockaddr_in SockAddr;
   SockAddr.sin_family = AF_INET;
   SockAddr.sin_port = htons(ReadInteger(_Data,_data_RemotePort,_prop_RemotePort));
   #ifdef UNICODE
    string _s = ReadString(_Data,_data_RemoteIP,_prop_RemoteIP);
    char buf[60];
    WideCharToMultiByte(CP_ACP,0,PChar(_s),-1,buf,60,NULL,NULL);
    SockAddr.sin_addr.s_addr = inet_addr(buf);
   #else
    SockAddr.sin_addr.s_addr = inet_addr(PChar(ReadString(_Data,_data_RemoteIP,_prop_RemoteIP)));
   #endif

   string s = ReadString(_Data,_data_Data,string(_his("")));
   #ifdef UNICODE
    char *_buf = new char[s.Length()+1];
    WideCharToMultiByte(CP_ACP,0,PChar(s),-1,_buf,s.Length()+1,NULL,NULL);
    sendto(Handle,_buf,s.Length(),0,(sockaddr*)&SockAddr,sizeof(SockAddr));
    delete buf;
   #else
    sendto(Handle,PChar(s),s.Length(),0,(sockaddr*)&SockAddr,sizeof(SockAddr));
   #endif
}

void THIUDP::_work_doReceiveFrom(TData &_Data,WORD Index)
{
   fd_set FDSet;
   FD_ZERO(&FDSet);
   FD_SET(Handle, &FDSet);
   if( select(0,&FDSet,NULL,NULL,NULL) > 0 )
   {
     ULONG len;
     ioctlsocket(Handle, FIONREAD, &len);
     char *s = new char[len];
     sockaddr_in sc;
     len = sizeof(sc);
     recvfrom(Handle,s,len,0,(sockaddr *)&sc,(int *)&len);
     //Format(
     //with TIP(sc.sin_addr.S_addr) do
     //  FIP := int2str(b1) + '.' + int2str(b2)  + '.' +
     //         int2str(b3) + '.' + int2str(b4);
     #ifdef UNICODE
      HI_STRING buf;
      AtoU(s,&buf);
      _hi_onEvent(_event_onReceive,string(buf));
      delete buf;
     #else
      _hi_onEvent(_event_onReceive,string(s));
     #endif
   }
}

void THIUDP::_work_doClose(TData &_Data,WORD Index)
{
   Close();
}
