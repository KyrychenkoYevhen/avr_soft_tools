unit mra_proto;

interface

uses
  Windows;

const
  PROTO_VERSION_MAJOR = 1;
  PROTO_VERSION_MINOR = 13;

  PROTO_VERSION = DWORD(PROTO_VERSION_MAJOR shl 16) or DWORD(PROTO_VERSION_MINOR);

  function PROTO_MAJOR(p: DWORD): WORD;
  function PROTO_MINOR(p: DWORD): WORD;

type
  mrim_packet_header_t = packed record
    magic: DWORD; // Magic
    proto: DWORD; // ������ ���������
    seq: DWORD; // Sequence
    msg: DWORD; // ��� ������
    dlen: DWORD; // ����� ������
    from: DWORD; // ����� �����������
    fromport: DWORD; // ���� �����������
    reserved: array[0..15] of BYTE; // ���������������
  end;
  TMRIMPacket = mrim_packet_header_t;
  PMRIMPacket = ^TMRIMPacket;

const
  CS_MAGIC = $DEADBEEF;	// ���������� Magic ( C <-> S )

  MRIM_CS_HELLO = $1001;  // C -> S
    // empty
    
  MRIM_CS_HELLO_ACK = $1002;  // S -> C
    // mrim_connection_params_t


  MRIM_CS_LOGIN_ACK = $1004;  // S -> C
    // empty
    
  MRIM_CS_LOGIN_REJ = $1005;  // S -> C
    // LPS reason
    
  MRIM_CS_PING = $1006;  // C -> S
    // empty
    
  MRIM_CS_MESSAGE	= $1008;  // C -> S
	// UL flags
	// LPS to
	// LPS message
	// LPS rtf-formatted message (>=1.1)
	  MESSAGE_FLAG_OFFLINE = $00000001;
	  MESSAGE_FLAG_NORECV	= $00000004;
	  MESSAGE_FLAG_AUTHORIZE = $00000008; 	// X-MRIM-Flags: 00000008
	  MESSAGE_FLAG_SYSTEM	=	$00000040;
	  MESSAGE_FLAG_RTF = $00000080;
	  MESSAGE_FLAG_CONTACT = $00000200;
	  MESSAGE_FLAG_NOTIFY	=	$00000400;
	  MESSAGE_FLAG_MULTICAST = $00001000;
  MAX_MULTICAST_RECIPIENTS = 50;
	  MESSAGE_USERFLAGS_MASK = $000036A8;	// Flags that user is allowed to set himself


  MRIM_CS_MESSAGE_ACK = $1009;  // S -> C
	// UL msg_id
	// UL flags
	// LPS from
	// LPS message
	// LPS rtf-formatted message (>=1.1)

	
  MRIM_CS_MESSAGE_RECV = $1011;	// C -> S
	// LPS from
	// UL msg_id

  MRIM_CS_MESSAGE_STATUS = $1012;	// S -> C
	// UL status
    MESSAGE_DELIVERED = $0000;	// Message delivered directly to user
	  MESSAGE_REJECTED_NOUSER = $8001;  // Message rejected - no such user
	  MESSAGE_REJECTED_INTERR = $8003;	// Internal server error
	  MESSAGE_REJECTED_LIMIT_EXCEEDED = $8004;	// Offline messages limit exceeded
	  MESSAGE_REJECTED_TOO_LARGE = $8005;	// Message is too large
	  MESSAGE_REJECTED_DENY_OFFMSG = $8006;	// User does not accept offline messages

  MRIM_CS_USER_STATUS	= $100F;	// S -> C
	// UL status
	  STATUS_OFFLINE = $00000000;
	  STATUS_ONLINE	= $00000001;
	  STATUS_AWAY = $00000002;
	  STATUS_UNDETERMINATED	= $00000003;
	  STATUS_FLAG_INVISIBLE	= $80000000;
	// LPS user


  MRIM_CS_LOGOUT = $1013;	// S -> C
	// UL reason
    LOGOUT_NO_RELOGIN_FLAG = $0010;		// Logout due to double login
	
  MRIM_CS_CONNECTION_PARAMS = $1014;	// S -> C
	// mrim_connection_params_t

  MRIM_CS_USER_INFO = $1015;	// S -> C
	// (LPS key, LPS value)* X
	
			
  MRIM_CS_ADD_CONTACT			= $1019;	// C -> S
	// UL flags (group(2) or usual(0) 
	// UL group id (unused if contact is group)
	// LPS contact
	// LPS name
	// LPS unused
	  CONTACT_FLAG_REMOVED	= $00000001;
	  CONTACT_FLAG_GROUP	= $00000002;
	  CONTACT_FLAG_INVISIBLE	= $00000004;
	  CONTACT_FLAG_VISIBLE	= $00000008;
	  CONTACT_FLAG_IGNORE	= $00000010;
	  CONTACT_FLAG_SHADOW	= $00000020;
	
  MRIM_CS_ADD_CONTACT_ACK			= $101A;	// S -> C
	// UL status
	// UL contact_id or (u_long)-1 if status is not OK
	
    CONTACT_OPER_SUCCESS		= $0000;
	  CONTACT_OPER_ERROR		= $0001;
    CONTACT_OPER_INTERR		= $0002;
	  CONTACT_OPER_NO_SUCH_USER	= $0003;
	  CONTACT_OPER_INVALID_INFO	= $0004;
	  CONTACT_OPER_USER_EXISTS	= $0005;
	  CONTACT_OPER_GROUP_LIMIT	= $6;
	
  MRIM_CS_MODIFY_CONTACT			= $101B;	// C -> S
	// UL id
	// UL flags - same as for MRIM_CS_ADD_CONTACT
	// UL group id (unused if contact is group)
	// LPS contact
	// LPS name
	// LPS unused
	
  MRIM_CS_MODIFY_CONTACT_ACK		= $101C;	// S -> C
	// UL status, same as for MRIM_CS_ADD_CONTACT_ACK

  MRIM_CS_OFFLINE_MESSAGE_ACK		= $101D;	// S -> C
	// UIDL
	// LPS offline message

  MRIM_CS_DELETE_OFFLINE_MESSAGE		= $101E;	// C -> S
	// UIDL

	
  MRIM_CS_AUTHORIZE			= $1020;	// C -> S
	// LPS user
	
  MRIM_CS_AUTHORIZE_ACK			= $1021;	// S -> C
	// LPS user

  MRIM_CS_CHANGE_STATUS			= $1022;	// C -> S
	// UL new status


  MRIM_CS_GET_MPOP_SESSION		= $1024;	// C -> S
	
	
  MRIM_CS_MPOP_SESSION			= $1025;	// S -> C
	  MRIM_GET_SESSION_FAIL		= 0;
	  MRIM_GET_SESSION_SUCCESS	= 1;
	//UL status 
	// LPS mpop session


  MRIM_CS_FILE_TRANSFER                   = $1026;  // C->S
        //LPS TO/FROM
        //DWORD id_request - uniq per connect
        //DWORD FILESIZE
        //LPS:  //FILENAME:SIZE;FILENAME:SIZE
                //DESCRIPTION
                //IP:PORT,IP:PORT

  MRIM_CS_FILE_TRANSFER_ACK               = $1027; // S->C
  //DWORD status
  FILE_TRANSFER_STATUS_OK                = 1;
  FILE_TRANSFER_STATUS_DECLINE           = 0;
  FILE_TRANSFER_STATUS_ERROR             = 2;
  FILE_TRANSFER_STATUS_INCOMPATIBLE_VERS = 3;
  FILE_TRANSFER_MIRROR                   = 4;
  //LPS TO/FROM
  //DWORD id_request
  //LPS DESCRIPTION

//white pages!
  MRIM_CS_WP_REQUEST			= $1029; //C->S
//DWORD field, LPS value
  PARAMS_NUMBER_LIMIT		 =	50;
  PARAM_VALUE_LENGTH_LIMIT	 =	64;

//if last symbol in value eq '*' it will be replaced by LIKE '%' 
// params define
// must be in consecutive order (0..N) to quick check in check_anketa_info_request
  MRIM_CS_WP_REQUEST_PARAM_USER = 0;
  MRIM_CS_WP_REQUEST_PARAM_DOMAIN = 1;
  MRIM_CS_WP_REQUEST_PARAM_NICKNAME = 2;
  MRIM_CS_WP_REQUEST_PARAM_FIRSTNAME = 3;
  MRIM_CS_WP_REQUEST_PARAM_LASTNAME = 4;
  MRIM_CS_WP_REQUEST_PARAM_SEX = 5;
  MRIM_CS_WP_REQUEST_PARAM_BIRTHDAY = 6;
  MRIM_CS_WP_REQUEST_PARAM_DATE1 = 7;
  MRIM_CS_WP_REQUEST_PARAM_DATE2 = 8;
  //!!!!!!!!!!!!!!!!!!!online request param must be at end of request!!!!!!!!!!!!!!!
  MRIM_CS_WP_REQUEST_PARAM_ONLINE = 9;
  MRIM_CS_WP_REQUEST_PARAM_STATUS = 10; // we do not used it, yet
  MRIM_CS_WP_REQUEST_PARAM_CITY_ID = 11;
  MRIM_CS_WP_REQUEST_PARAM_ZODIAC = 12;
  MRIM_CS_WP_REQUEST_PARAM_BIRTHDAY_MONTH = 13;
  MRIM_CS_WP_REQUEST_PARAM_BIRTHDAY_DAY = 14;
  MRIM_CS_WP_REQUEST_PARAM_COUNTRY_ID = 15;
  MRIM_CS_WP_REQUEST_PARAM_LOCATION = 16;
  MRIM_CS_WP_REQUEST_PARAM_PHONE = 17;
  MRIM_CS_WP_REQUEST_PARAM_MAX = 18;

  {MRIM_CS_WP_REQUEST_PARAM_USER = 0;
  MRIM_CS_WP_REQUEST_PARAM_DOMAIN = 1;
  MRIM_CS_WP_REQUEST_PARAM_NICKNAME = 2;
  MRIM_CS_WP_REQUEST_PARAM_FIRSTNAME = 3;
  MRIM_CS_WP_REQUEST_PARAM_LASTNAME = 4;
  MRIM_CS_WP_REQUEST_PARAM_SEX = 5;
  MRIM_CS_WP_REQUEST_PARAM_BIRTHDAY = 6;
  MRIM_CS_WP_REQUEST_PARAM_DATE1 = 7;
  MRIM_CS_WP_REQUEST_PARAM_DATE2 = 8;
  //!!!!!!!!!!!!!!!!!!!online request param must be at end of request!!!!!!!!!!!!!!!
  MRIM_CS_WP_REQUEST_PARAM_ONLINE = 9;
  MRIM_CS_WP_REQUEST_PARAM_STATUS = 10; // we do not used it, yet
  MRIM_CS_WP_REQUEST_PARAM_CITY_ID = 11;
  MRIM_CS_WP_REQUEST_PARAM_ZODIAC = 12;
  MRIM_CS_WP_REQUEST_PARAM_BIRTHDAY_MONTH = 13;
  MRIM_CS_WP_REQUEST_PARAM_BIRTHDAY_DAY = 14;
  MRIM_CS_WP_REQUEST_PARAM_COUNTRY_ID = 15;
  MRIM_CS_WP_REQUEST_PARAM_MAX = 16;}

  MRIM_CS_ANKETA_INFO			= $1028; //S->C
//DWORD status 
	  MRIM_ANKETA_INFO_STATUS_OK	 =	1;
	  MRIM_ANKETA_INFO_STATUS_NOUSER	 =	0;
	  MRIM_ANKETA_INFO_STATUS_DBERR	 =	2;
	  MRIM_ANKETA_INFO_STATUS_RATELIMERR =	3;
//DWORD fields_num
//DWORD max_rows
//DWORD server_time sec since 1970 (unixtime)
// fields set 				//%fields_num == 0
//values set 				//%fields_num == 0
//LPS value (numbers too)

	
  MRIM_CS_MAILBOX_STATUS			= $1033;
//DWORD new messages in mailbox


  MRIM_CS_CONTACT_LIST2		= $1037; //S->C
// UL status
  GET_CONTACTS_OK			= $0000;
  GET_CONTACTS_ERROR		= $0001;
  GET_CONTACTS_INTERR		= $0002;
//DWORD status  - if ...OK than this staff:
//DWORD groups number
//mask symbols table:
//'s' - lps
//'u' - unsigned long
//'z' - zero terminated string 
//LPS groups fields mask 
//LPS contacts fields mask 
//group fields
//contacts fields
//groups mask 'us' == flags, name
//contact mask 'uussuu' flags, flags, internal flags, status
	  CONTACT_INTFLAG_NOT_AUTHORIZED	= $0001;

//old packet cs_login with cs_statistic
  MRIM_CS_LOGIN2       	= $1038;  // C -> S
  MAX_CLIENT_DESCRIPTION = 256;
// LPS login
// LPS password
// DWORD status
//+ statistic packet data: 
// LPS client description //max 256

  MRIM_CS_SMS = $1039;
	// UL - unknown
	// LPS - number
	// LPS - text

  MRIM_CS_SMS_ACK = $1040;
	// UL - status

  MRIM_CS_MAILBOX_STATUS_NEW = $1048;
   //UL - MessageNum
   //LPS - Sender
   //LPS - Subject
   //UL - Timestamp
   //UL - Unknown

  ZODIAC: array[1..12] of String = (
	  '����',
	  '�����',
	  '��������',
	  '���',
	  '���',
	  '����',
	  '����',
	  '��������',
	  '�������',
	  '�������',
	  '�������',
	  '����'
  );

  MONTH: array[1..12] of String = (
	  '������',
	  '�������',
	  '����',
	  '������',
	  '���',
	  '����',
	  '����',
	  '������',
	  '��������',
	  '�������',
	  '������',
	  '�������'
  );

  function COUNTRY(Code: Integer): String;  

implementation

function PROTO_MAJOR(p: DWORD): WORD;
begin
  Result := (p and $FFFF0000) shr 16;
end;

function PROTO_MINOR(p: DWORD): WORD;
begin
  Result := (p and $0000FFFF);
end;

function COUNTRY(Code: Integer): String;
begin
  case Code of
    24  :  Result := '������';
	  123 :  Result := '���������';
	  40  :  Result := '�������';
	  81  :  Result := '�����������';
	  82  :  Result := '�������';
	  340 :  Result := '����������';
	  38  :  Result := '�������';
	  41  :  Result := '��������';
	  45  :  Result := '��������������';
	  44  :  Result := '�������';
	  46  :  Result := '��������';
	  48  :  Result := '������';
	  83  :  Result := '������';
	  49  :  Result := '�����';
	  86  :  Result := '�������';
	  95  :  Result := '�����';
	  50  :  Result := '��������';
	  51  :  Result := '��������';
	  34  :  Result := '�������';
	  52  :  Result := '������';
	  84  :  Result := '���������';
	  138 :  Result := '������';
	  107 :  Result := '����';
	  92  :  Result := '�������� (����������)';
	  76  :  Result := '�����';
	  29  :  Result := '����� (����)';
	  108 :  Result := '�����, ����������';
	  53  :  Result := '������';
	  54  :  Result := '�����';
	  59  :  Result := '��������';
	  60  :  Result := '����������';
	  130 :  Result := '����� ��������';
	  61  :  Result := '��������';
	  62  :  Result := '������';
	  35  :  Result := '����������';
	  63  :  Result := '�������';
	  139 :  Result := '���';
	  74  :  Result := '������ � ����������';
	  65  :  Result := '��������';
	  66  :  Result := '��������';
	  91  :  Result := '�����������';
	  90  :  Result := '���������';
	  77  :  Result := '������';
	  93  :  Result := '����������';
	  39  :  Result := '�������';
	  68  :  Result := '���������';
	  37  :  Result := '�������';
	  69  :  Result := '��������';
	  70  :  Result := '�����';
	  71  :  Result := '���������';
	  72  :  Result := '������';
	  73  :  Result := '�������';
	  225 :  Result := '���';
	  75  :  Result := '������';
  end;
end;

end.
