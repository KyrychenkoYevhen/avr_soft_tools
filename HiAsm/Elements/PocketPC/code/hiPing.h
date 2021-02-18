#include "share.h"
#include <Icmpapi.h>
#include <winsock2.h>

class  THIPing
{
   private:
    int Tm;
    int Count;
   public:
    string _prop_Name;
    int _prop_ByteCount;
    THI_Event *_data_Name;
    THI_Event *_event_onFailed;
    THI_Event *_event_onFind;

    HI_WORK_LOC(THIPing,_work_doPing);
    HI_WORK_LOC(THIPing,_var_Time);
    HI_WORK_LOC(THIPing,_var_ByteCount);
};

//#############################################################################

void THIPing::_work_doPing(TData &_Data,USHORT Index)
{
   	HANDLE hIP;
    void *pingBuffer;
    icmp_echo_reply *pIpe;
   	PHOSTENT pHostEn;
   	WORD wVersionRequested;
   	WSADATA lwsaData;
   	in_addr destAddress;

    hIP = IcmpCreateFile();
			
    pIpe = (icmp_echo_reply *)malloc( sizeof(icmp_echo_reply) + _prop_ByteCount);
    pingBuffer = malloc(_prop_ByteCount);
	
    pIpe->Data = pingBuffer;
    pIpe->DataSize = _prop_ByteCount;
    wVersionRequested = MAKEWORD(1,1);
    if( WSAStartup(wVersionRequested,&lwsaData) != 0)
    {
        _hi_onEvent(_event_onFailed,1);
        return;
    }
    #ifdef UNICODE
     string _s = ReadString(_Data,_data_Name,_prop_Name);
     char buf[30];
     WideCharToMultiByte(CP_ACP,0,PChar(_s),-1,buf,30,NULL,NULL);
     pHostEn = gethostbyname(buf);
    #else
     pHostEn = gethostbyname(PChar(ReadString(_Data,_data_Name,_prop_Name)));
    #endif

    if( !pHostEn )
    {
        _hi_onEvent(_event_onFailed,2);
        return;
    }	
    destAddress = *(PIN_ADDR)(*pHostEn->h_addr_list);
    int res = IcmpSendEcho(hIP,destAddress.s_addr,pingBuffer,_prop_ByteCount,
                 NULL,pIpe, sizeof(icmp_echo_reply) + _prop_ByteCount, 5000);

    if ( !res )
    {
        _hi_onEvent(_event_onFailed,3);
        return;
    }
	
    Tm = pIpe->RoundTripTime;
    Count = pIpe->DataSize;
    
    HI_RSTRING s[15];
    Format(s,_his("%d.%d.%d.%d"),LOBYTE(LOWORD(pIpe->Address)),HIBYTE(LOWORD(pIpe->Address)),
                                 LOBYTE(HIWORD(pIpe->Address)),HIBYTE(HIWORD(pIpe->Address)));

    _hi_onEvent(_event_onFind,string(s));
	    
    IcmpCloseHandle(hIP);
    delete pIpe;
    delete pingBuffer;
}

void THIPing::_var_Time(TData &_Data,USHORT Index)
{
   CreateData(_Data,Tm);
}

void THIPing::_var_ByteCount(TData &_Data,USHORT Index)
{
   CreateData(_Data,Count);
}
