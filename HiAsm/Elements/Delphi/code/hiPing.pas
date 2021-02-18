unit hiPing;

interface

{$I share.inc}

uses
  Windows, WinSock, Kol, Share, Debug;

type
  THIPing = class(TDebug)
    private
      Tm: Word;
      Count: Word;
    public
      _prop_Name: string;
      _prop_ByteCount: Integer;
      _prop_TimeOut: Integer;
      _data_Name: THI_Event;
      _data_ByteCountIn: THI_Event;
      _data_TimeOutIn: THI_Event;
      _event_onFailed: THI_Event;
      _event_onFind: THI_Event;

      constructor Create;
      destructor Destroy; override;

      procedure _work_doPing(var _Data: TData; Index: Word);
      procedure _var_Time(var _Data: TData; Index: Word);
      procedure _var_ByteCount(var _Data: TData; Index: Word);
  end;
  
const
  // �������� ���� icmp_echo_reply.Status:
  IP_SUCCESS = 0;
  IP_BUF_TOO_SMALL = 11001;
  IP_DEST_NET_UNREACHABLE = 11002;
  IP_DEST_HOST_UNREACHABLE = 11003;
  IP_DEST_PROT_UNREACHABLE = 11004;
  IP_DEST_PORT_UNREACHABLE = 11005;
  IP_NO_RESOURCES = 11006;
  IP_BAD_OPTION = 11007;
  IP_HW_ERROR = 11008;
  IP_PACKET_TOO_BIG = 11009;
  IP_REQ_TIMED_OUT = 11010;
  IP_BAD_REQ = 11011;
  IP_BAD_ROUTE = 11012;
  IP_TTL_EXPIRED_TRANSIT = 11013;
  IP_TTL_EXPIRED_REASSEM = 11014;
  IP_PARAM_PROBLEM = 11015;
  IP_SOURCE_QUENCH = 11016;
  IP_OPTION_TOO_BIG = 11017;
  IP_BAD_DESTINATION = 11018;
  IP_GENERAL_FAILURE = 11050;

implementation

type
  ip_option_information = record // ���������� ��������� IP (����������
                            // ���� ��������� � ������ ����� ������ � RFC791.
     Ttl: u_char;          // ����� ����� (������������ traceroute-��)
     Tos: u_char;          // ��� ������������, ������ 0
     Flags: u_char;        // ����� ��������� IP, ������ 0
     OptionsSize: u_char;  // ������ ������ � ���������, ������ 0, �������� 40
     OptionsData: PChar;   // ��������� �� ������
 end;
 
 icmp_echo_reply = record
     Address: DWORD;       // ����� �����������
     Status: u_long;       // IP_STATUS (��. ����)
     RTTime: u_long;       // ����� ����� ���-�������� � ���-�������
				            // � �������������
     DataSize: u_short;    // ������ ������������ ������
     Reserved: u_short;    // ���������������
     Data: Pointer;        // ��������� �� ������������ ������
     Options: ip_option_information; // ���������� �� ��������� IP
 end;
 
 PIPINFO = ^ip_option_information;
 
 PVOID = Pointer;
 
  function IcmpCreateFile(): THandle; stdcall; external 'ICMP.DLL' name
                           'IcmpCreateFile';
 
  function IcmpCloseHandle(IcmpHandle: THandle): BOOL; stdcall;
                            external 'ICMP.DLL' name 'IcmpCloseHandle';
 
  function IcmpSendEcho(
    IcmpHandle: THandle;    // handle, ������������ IcmpCreateFile()
    DestAddress: u_long;    // ����� ���������� (� ������� �������)
    RequestData: PVOID;     // ��������� �� ���������� ������
    RequestSize: Word;      // ������ ���������� ������
    RequestOptns: PIPINFO;  // ��������� �� ���������� ���������
                            // ip_option_information (����� ���� nil)
    ReplyBuffer: PVOID;     // ��������� �� �����, ���������� ������.
    ReplySize: DWORD;       // ������ ������ �������
    Timeout: DWORD          // ����� �������� ������ � �������������
  ): DWORD; stdcall; external 'ICMP.DLL' name 'IcmpSendEcho';

constructor THIPing.Create;
begin
   inherited Create;
   UPD_Init;
end;

destructor THIPing.Destroy;
begin
   UPD_Clear;
   inherited;
end;

procedure THIPing._work_doPing;
label
  finish;
var
  hIP: THandle;
  pingBuffer: Pointer;
  pIpe: ^icmp_echo_reply;
  pHostEn: PHostEnt;
  destAddress: In_Addr;
  BC: Integer;
begin
  hIP := IcmpCreateFile();
  
  if (hIP = INVALID_HANDLE_VALUE) then
  begin
    _hi_CreateEvent(_Data, @_event_onFailed, 1);
    Exit;
  end;
  
  BC := ReadInteger(_Data, _data_ByteCountIn, _prop_ByteCount);
  
  GetMem(pIpe, SizeOf(icmp_echo_reply) + BC);
  GetMem(pingBuffer, BC);
  
  pIpe.Data := pingBuffer;
  pIpe.DataSize := SizeOf(pingBuffer);
  
  pHostEn := gethostbyname(PAnsiChar(AnsiString(ReadString(_Data, _data_Name, _prop_Name))));
  
  if (GetLastError <> 0) then
  begin
    _hi_CreateEvent(_Data, @_event_onFailed, 2);
    goto finish;
  end;
  
  destAddress := PInAddr(pHostEn^.h_addr_list^)^;
  //destAddress.S_addr := inet_addr(PChar(ReadString(_Data, _data_Name, _prop_Name))); // ���� ����� ������ �� IP (��� gethostbyname)
  
  IcmpSendEcho(hIP, destAddress.S_addr, pingBuffer, BC,
               nil, pIpe, SizeOf(icmp_echo_reply) + BC, ReadInteger(_Data, _data_TimeOutIn, _prop_TimeOut));
  
  if (GetLastError <> 0) then
  begin
    _hi_CreateEvent(_Data, @_event_onFailed, 3);
    goto finish;
  end;
  
  Tm := pIpe.RTTime;
  Count := pIpe.DataSize;
  
  if pIpe.Status <> IP_SUCCESS then
  begin
    _hi_CreateEvent(_Data, @_event_onFailed, pIpe.Status);
    goto finish;
  end;
  
  {$ifdef F_P}
  _hi_CreateEvent(_Data, @_event_onFind, Int2Str(LoByte(LoWord(pIpe^.Address))) + '.' +
                             Int2Str(HiByte(LoWord(pIpe^.Address))) + '.' +
                             Int2Str(LoByte(HiWord(pIpe^.Address))) + '.' +
                             Int2Str(HiByte(HiWord(pIpe^.Address))));
  {$else}
  _hi_CreateEvent(_Data, @_event_onFind,Format('%d.%d.%d.%d',
      [LoByte(LoWord(pIpe^.Address)),HiByte(LoWord(pIpe^.Address)),
       LoByte(HiWord(pIpe^.Address)),HiByte(HiWord(pIpe^.Address))]));
  {$endif}
  
  
finish:
  IcmpCloseHandle(hIP);
  FreeMem(pIpe);
  Freemem(pingBuffer);
end;

procedure THIPing._var_Time;
begin
   dtInteger(_Data, Tm);
end;

procedure THIPing._var_ByteCount;
begin
   dtInteger(_Data, Count);
end;

end.
