unit hiHost;

interface

uses
  WinSock, Kol, Share, Debug;

type
  THIHost = class(TDebug)
    private
      FLocalHostName: string;
    public

      _event_onHostByIP: THI_Event;
      _event_onIPByHost: THI_Event;
      _data_IP: THI_Event;
      _data_HostName: THI_Event;

      procedure _work_doHostByIP(var _Data: TData; Index: Word);
      procedure _work_doIPByHost(var _Data: TData; Index: Word);
      procedure _var_LoacalHostName(var _Data: TData; Index: Word);
      procedure _var_LoacalIP(var _Data: TData; Index: Word);
      
      function uGetLoacalHostName: string; 
      function uHost2IP(HostName: string): string; 
      function uIP2Host(IPAddr : string): string; 
  end;

implementation

var
  WSAData: TWSAData;

procedure THIHost._work_doHostByIP;
var
  ip: string;   
begin
  ip := ReadString(_Data, _data_IP);
  _hi_CreateEvent(_Data, @_event_onHostByIP, uIP2Host(uHost2IP(ip)));
end;

procedure THIHost._work_doIPByHost;
var
  Host: string;   
begin
  Host := ReadString(_Data, _data_HostName, uGetLoacalHostName);
  _hi_CreateEvent(_Data, @_event_onIPByHost, uHost2IP(Host));
end;

procedure THIHost._var_LoacalHostName;
begin
  if FLocalHostName = '' then FLocalHostName := uGetLoacalHostName;
  dtString(_Data, FLocalHostName);
end;

procedure THIHost._var_LoacalIP;
begin
  dtString(_Data, uHost2IP(uGetLoacalHostName));
end;


function THIHost.uGetLoacalHostName: string;
var
  Buffer: array[0..63] of AnsiChar;
begin
  Result := '';
  WinSock.GetHostName(@Buffer, SizeOf(Buffer));
  Result := Buffer;
end;

function THIHost.uHost2IP(HostName: string): string;
type
  TaPInAddr = array[0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe: PHostEnt;
  pptr: PaPInAddr;
  I: Integer;
begin
  Result := '';
  phe := GetHostByName(PAnsiChar(AnsiString(HostName)));
  if phe = nil then exit;
  
  pPtr := PaPInAddr(phe^.h_addr_list);
  I := 0;
  while pPtr^[I] <> nil do
  begin
    Result := inet_ntoa(pPtr^[I]^);
    Inc(I);
  end;
end;

function THIHost.uIP2Host(IPAddr : string): string;
var
  SockAddrIn: TSockAddrIn;
  HostEnt: PHostEnt;
begin
  Result := '';
  SockAddrIn.sin_addr.s_addr := inet_addr(PAnsiChar(AnsiString(IPAddr)));
  HostEnt := GetHostByAddr(@SockAddrIn.sin_addr.S_addr, SizeOf(in_addr), AF_INET);
  if HostEnt = nil then exit;
  Result := Hostent^.h_name;
end;

initialization
  WSAStartup($101, WSAData);

end.