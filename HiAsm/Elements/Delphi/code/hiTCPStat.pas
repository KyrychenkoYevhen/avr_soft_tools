unit hiTCPStat;

interface

uses
  Windows, KOL, Share, Debug, WinSock;

const
  // Константы состояний порта
  MIB_TCP_STATE_CLOSED     = 1;
  MIB_TCP_STATE_LISTEN     = 2;
  MIB_TCP_STATE_SYN_SENT   = 3;
  MIB_TCP_STATE_SYN_RCVD   = 4;
  MIB_TCP_STATE_ESTAB      = 5;
  MIB_TCP_STATE_FIN_WAIT1  = 6;
  MIB_TCP_STATE_FIN_WAIT2  = 7;
  MIB_TCP_STATE_CLOSE_WAIT = 8;
  MIB_TCP_STATE_CLOSING    = 9;
  MIB_TCP_STATE_LAST_ACK   = 10;
  MIB_TCP_STATE_TIME_WAIT  = 11;
  MIB_TCP_STATE_DELETE_TCB = 12;
  
  // Наименования состояний
  TCPStateNames: array [0..12] of string =
    (
      'UNKNOWN',
      'CLOSED',
      'LISTEN',
      'SYN SENT',
      'SYN RECEIVED',
      'ESTABLISHED',
      'FIN WAIT 1',
      'FIN WAIT 2',
      'CLOSE WAIT',
      'CLOSING',
      'LAST ACK',
      'TIME WAIT',
      'DELETE TCB'
    );

type
  // Стандартная структура для получения ТСР статистики
  PTMibTCPRow = ^TMibTCPRow;
  TMibTCPRow = packed record
    dwState: DWORD;
    dwLocalAddr: DWORD;
    dwLocalPort: DWORD;
    dwRemoteAddr: DWORD;
    dwRemotePort: DWORD;
  end;

  // В данную структуру будет передаваться результат GetTcpTable
  PTMibTCPTable = ^TMibTCPTable;
  TMibTCPTable = packed record
    dwNumEntries: DWORD;
    Table: array[0..0] of TMibTCPRow;
  end;

  // Стандартная структура для получения UDP статистики
  PTMibUdpRow = ^TMibUdpRow;
  TMibUdpRow = packed record
    dwLocalAddr: DWORD;
    dwLocalPort: DWORD;
  end;

  // В данную структуру будет передаваться результат GetUDPTable
  PTMibUdpTable = ^TMibUdpTable;
  TMibUdpTable = packed record
    dwNumEntries: DWORD;
    table: array [0..0] of TMibUdpRow;
  end;

type
  THITCPStat = class(TDebug)
    private
    public
      _event_onEnumTCP: THI_Event;
      _event_onEnumUDP: THI_Event;
      _event_onPortIsOpen: THI_Event;
      _data_IP: THI_Event;
      _data_Port: THI_Event;

      procedure _work_doEnumTCP(var _Data: TData; Index: Word);
      procedure _work_doEnumUDP(var _Data: TData; Index: Word);
      procedure _work_doPortIsOpen(var _Data: TData; Index: Word);
    end;

 function GetTcpTable(pTCPTable: PTMibTCPTable; var pDWSize: DWORD;
                      bOrder: BOOL): DWORD; stdcall; external 'IPHLPAPI.DLL';
 function GetUdpTable(pUDPTable: PTMibUDPTable; var pDWSize: DWORD;
                      bOrder: BOOL): DWORD; stdcall; external 'IPHLPAPI.DLL';

implementation

procedure THITCPStat._work_doEnumTCP;
var
  Size, i: DWORD;
  dtla, dtlp, dtra, dtrp, dtst: TData;
  fTCPTable: PTMibTCPTable;
  
  // Функция преобразует состояние порта в строковый эквивалент
  function PortStateToStr(State: DWORD): string;
  begin
    if State > High(TCPStateNames) then State := 0;
    Result := TCPStateNames[State];
  end;
  
begin
  Size := 0;
  GetMem(fTCPTable, SizeOf(TMibTCPTable));
  try
    if GetTcpTable(fTCPTable, Size, True) <> ERROR_INSUFFICIENT_BUFFER then exit;
    FreeMem(fTCPTable);
    GetMem(fTCPTable, Size);
    if GetTcpTable(fTCPTable, Size, True) <> NO_ERROR then exit;
    for i := 0 to fTCPTable^.dwNumEntries - 1 do
    begin
      dtString(dtla, inet_ntoa(in_addr(fTCPTable^.Table[i].dwLocalAddr)));
      dtInteger(dtlp, htons(fTCPTable^.Table[i].dwLocalPort));
      dtString(dtra, inet_ntoa(in_addr(fTCPTable^.Table[i].dwRemoteAddr)));
      dtInteger(dtrp, htons(fTCPTable^.Table[i].dwRemotePort));
      dtString(dtst, PortStateToStr(fTCPTable^.Table[i].dwState));
      dtla.ldata := @dtlp;
      dtlp.ldata := @dtra;
      dtra.ldata := @dtrp;
      dtrp.ldata := @dtst;
      _hi_onEvent_(_event_onEnumTCP, dtla);
    end;
  finally
    FreeMem(fTCPTable);
  end;  
end;

procedure THITCPStat._work_doEnumUDP;
var
  Size, i: DWORD;
  dtla, dtlp: TData;  
  fUDPTable: PTMibUdpTable;  
begin
  Size := 0;
  GetMem(fUDPTable, SizeOf(TMibUDPTable));
  try   
    if GetUDPTable(fUDPTable, Size, true) <> ERROR_INSUFFICIENT_BUFFER then exit;
    FreeMem(fUDPTable);
    GetMem(fUDPTable, Size);
    if GetUDPTable(fUDPTable, Size, true) <> NO_ERROR then exit;
    for i := 0 to fUDPTable^.dwNumEntries - 1 do
    begin
      dtString(dtla, inet_ntoa(in_addr(fUDPTable^.Table[i].dwLocalAddr)));
      dtInteger(dtlp, htons(fUDPTable^.Table[i].dwLocalPort));
      dtla.ldata := @dtlp;
      _hi_onEvent_(_event_onEnumUDP, dtla);
    end;  
  finally
    FreeMem(fUDPTable);  
  end;
end;

procedure THITCPStat._work_doPortIsOpen;

  function PortTCP_IsOpen(ipAddressStr: AnsiString; dwPort: Word): Boolean;
  var
    Addr: TSockAddr;
    Sock: TSocket;
    WSData: WSAData;
  begin
    Result := False;
    
    // TODO: минимизация частоты вызова
    if WSAStartup($101, WSData) <> 0 then exit; // Initiates use of the Winsock DLL
    
    Sock := Winsock.socket(PF_INET, SOCK_STREAM, IPPROTO_IP); // Create socket
    if Sock <> 0 then
    begin
      //FillChar(Addr, SizeOf(TSockAddr), #0);
      Addr.sin_family := AF_INET; // Set the protocol to use, in this case (IPv4)
      Addr.sin_port := htons(dwPort); // Convert to TCP/IP network byte order (big-endian)
      Addr.sin_addr.S_addr := inet_addr(PAnsiChar(ipAddressStr)); // Convert to IN_ADDR structure
      
      Result := connect(Sock, Addr, SizeOf(Addr)) = 0; // Establishes a connection to a specified socket
      
      // Release socket, on succesfull connection - disconnects
      closesocket(Sock);
    end;
    {else // Ошибка, например, нехватка ресурсов
      _debug(WSAGetLastError);}

    WSACleanup;
  end;

begin
  _hi_onEvent(_event_onPortIsOpen, Ord(PortTCP_IsOpen(ReadString(_Data, _data_IP), ReadInteger(_Data, _data_Port))));
end;

end.