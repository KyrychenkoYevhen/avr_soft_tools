//
// Copyright (c) Microsoft Corporation.  All rights reserved.
//
//
// Use of this source code is subject to the terms of the Microsoft end-user
// license agreement (EULA) under which you licensed this SOFTWARE PRODUCT.
// If you did not accept the terms of the EULA, you are not authorized to use
// this source code. For a copy of the EULA, please see the LICENSE.RTF on your
// install media.
//
/*++
THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
PARTICULAR PURPOSE.

Module Name:

winsock.h

Abstract:

Windows CE version of winsock.h.

Notes:


--*/
/*++

  This file includes parts which are Copyright (c) 1982-1986 Regents
  of the University of California.  All rights reserved.  The
  Berkeley Software License Agreement specifies the terms and
  conditions for redistribution.

Module Name: winsock.h-definitions to be used with the WINSOCK.DLL

Purpose: This header file corresponds to version 1.1 of the Windows Sockets
specification.

--*/

// @CESYSGEN IF CE_MODULES_WINSOCK

#ifndef _WINSOCKAPI_
#define _WINSOCKAPI_

#include <windows.h>

#ifndef WINSOCKAPI
#ifdef UNDER_NT
#define WINSOCKAPI WINAPI
#else
#define WINSOCKAPI __cdecl
#endif
#endif

#ifdef _WIN32_WCE_EMULATION
#ifdef WINSOCKAPI
#undef WINSOCKAPI
#endif
#define WINSOCKAPI WINAPI
#endif

/*
 * Basic system type definitions, taken from the BSD file sys/types.h.
 */
typedef unsigned char   u_char;
typedef unsigned short  u_short;
typedef unsigned int    u_int;
typedef unsigned long   u_long;

/*
 * The new type to be used in all
 * instances which refer to sockets.
 */
#ifdef _WIN64
typedef UINT_PTR        SOCKET;
#else
typedef u_int           SOCKET;
#endif

/*
 * Select uses arrays of SOCKETs.  These macros manipulate such
 * arrays.  FD_SETSIZE may be defined by the user before including
 * this file, but the default here should be >= 64.
 *
 * CAVEAT IMPLEMENTOR and USER: THESE MACROS AND TYPES MUST BE
 * INCLUDED IN WINSOCK.H EXACTLY AS SHOWN HERE.
 */
#ifndef FD_SETSIZE
#define FD_SETSIZE      64
#endif /* FD_SETSIZE */

typedef struct fd_set {
        u_int   fd_count;               /* how many are SET? */
        SOCKET  fd_array[FD_SETSIZE];   /* an array of SOCKETs */
} fd_set;

#ifdef __cplusplus
extern "C" {
#endif

extern int WINSOCKAPI __WSAFDIsSet(SOCKET, fd_set *);

#ifdef __cplusplus
}
#endif

#define FD_CLR(fd, set) do { \
    u_int __i; \
    for (__i = 0; __i < ((fd_set *)(set))->fd_count ; __i++) { \
        if (((fd_set *)(set))->fd_array[__i] == fd) { \
            while (__i < ((fd_set *)(set))->fd_count-1) { \
                ((fd_set *)(set))->fd_array[__i] = \
                    ((fd_set *)(set))->fd_array[__i+1]; \
                __i++; \
            } \
            ((fd_set *)(set))->fd_count--; \
            break; \
        } \
    } \
} while(0)

#define FD_SET(fd, set) do { \
    if ((! __WSAFDIsSet((SOCKET)fd, (fd_set *)set)) &&  \
        (((fd_set *)(set))->fd_count < FD_SETSIZE)) \
        ((fd_set *)(set))->fd_array[((fd_set *)(set))->fd_count++]=fd;\
} while(0)

#define FD_ZERO(set) (((fd_set FAR *)(set))->fd_count=0)

#define FD_ISSET(fd, set) __WSAFDIsSet((SOCKET)(fd), (fd_set FAR *)(set))

/*
 * Structure used in select() call, taken from the BSD file sys/time.h.
 */
struct timeval {
        long    tv_sec;         /* seconds */
        long    tv_usec;        /* and microseconds */
};

/*
 * Operations on timevals.
 *
 * NB: timercmp does not work for >= or <=.
 */
#define timerisset(tvp)         ((tvp)->tv_sec || (tvp)->tv_usec)
#define timercmp(tvp, uvp, cmp) \
        ((tvp)->tv_sec cmp (uvp)->tv_sec || \
         (tvp)->tv_sec == (uvp)->tv_sec && (tvp)->tv_usec cmp (uvp)->tv_usec)
#define timerclear(tvp)         (tvp)->tv_sec = (tvp)->tv_usec = 0

/*
 * Commands for ioctlsocket(),  taken from the BSD file fcntl.h.
 *
 *
 * Ioctl's have the command encoded in the lower word,
 * and the size of any in or out parameters in the upper
 * word.  The high 2 bits of the upper word are used
 * to encode the in/out status of the parameter; for now
 * we restrict parameters to at most 128 bytes.
 */
#define IOCPARM_MASK    0x7ff            /* parameters must be < 2k bytes */
#define	IOCGROUP(x)	(((x) >> 8) & 0xff)
#define IOC_VOID        0x20000000      /* no parameters */
#define IOC_OUT         0x40000000      /* copy out parameters */
#define IOC_IN          0x80000000      /* copy in parameters */
#define IOC_INOUT       (IOC_IN|IOC_OUT)
#define	_IOC(inout,group,num,len) \
	(inout | ((len & IOCPARM_MASK) << 16) | ((group) << 8) | (num))
#define	_IO(g,n)	_IOC(IOC_VOID,	(g), (n), 0)
#define	_IOR(g,n,t)	_IOC(IOC_OUT,	(g), (n), sizeof(t))
#define	_IOW(g,n,t)	_IOC(IOC_IN,	(g), (n), sizeof(t))
/* this should be _IORW, but stdio got there first */
#define	_IOWR(g,n,t)	_IOC(IOC_INOUT,	(g), (n), sizeof(t))


#define FIONREAD    _IOR('f', 127, u_long) /* get # bytes to read */
#define FIONBIO     _IOW('f', 126, u_long) /* set/clear non-blocking i/o */
#define FIOASYNC    _IOW('f', 125, u_long) /* set/clear async i/o */

/* Socket I/O Controls */
#define SIOCSHIWAT  _IOW('s',  0, u_long)  /* set high watermark */
#define SIOCGHIWAT  _IOR('s',  1, u_long)  /* get high watermark */
#define SIOCSLOWAT  _IOW('s',  2, u_long)  /* set low watermark */
#define SIOCGLOWAT  _IOR('s',  3, u_long)  /* get low watermark */
#define SIOCATMARK  _IOR('s',  7, u_long)  /* at oob mark? */

/*
 * Structures returned by network data base library, taken from the
 * BSD file netdb.h.  All addresses are supplied in host order, and
 * returned in network order (suitable for use in system calls).
 */

struct  hostent {
        char    * h_name;           /* official name of host */
        char    * * h_aliases;  /* alias list */
        short   h_addrtype;             /* host address type */
        short   h_length;               /* length of address */
        char    * * h_addr_list; /* list of addresses */
#define h_addr  h_addr_list[0]          /* address, for backward compat */
};

/*
 * It is assumed here that a network number
 * fits in 32 bits.
 */
struct  netent {
        char    * n_name;           /* official name of net */
        char    * * n_aliases;  /* alias list */
        short   n_addrtype;             /* net address type */
        u_long  n_net;                  /* network # */
};

struct  servent {
        char    * s_name;           /* official service name */
        char    * * s_aliases;  /* alias list */
        short   s_port;                 /* port # */
        char    * s_proto;          /* protocol to use */
};

struct  protoent {
        char    * p_name;           /* official protocol name */
        char    * * p_aliases;  /* alias list */
        short   p_proto;                /* protocol # */
};

/*
 * Constants and structures defined by the internet system,
 * Per RFC 790, September 1981, taken from the BSD file netinet/in.h.
 */

/*
 * Protocols
 */
#define IPPROTO_IP              0               /* dummy for IP */
#define IPPROTO_ICMP            1               /* control message protocol */
#define IPPROTO_GGP             2               /* gateway^2 (deprecated) */
#define IPPROTO_TCP             6               /* tcp */
#define IPPROTO_PUP             12              /* pup */
#define IPPROTO_UDP             17              /* user datagram protocol */
#define IPPROTO_IDP             22              /* xns idp */
#define IPPROTO_ND              77              /* UNOFFICIAL net disk proto */
#define IPPROTO_RAW             255             /* raw IP packet */
#define IPPROTO_MAX             256

/*
 * Port/socket numbers: network standard functions
 */
#define IPPORT_ECHO             7
#define IPPORT_DISCARD          9
#define IPPORT_SYSTAT           11
#define IPPORT_DAYTIME          13
#define IPPORT_NETSTAT          15
#define IPPORT_FTP              21
#define IPPORT_TELNET           23
#define IPPORT_SMTP             25
#define IPPORT_TIMESERVER       37
#define IPPORT_NAMESERVER       42
#define IPPORT_WHOIS            43
#define IPPORT_MTP              57

/*
 * Port/socket numbers: host specific functions
 */
#define IPPORT_TFTP             69
#define IPPORT_RJE              77
#define IPPORT_FINGER           79
#define IPPORT_TTYLINK          87
#define IPPORT_SUPDUP           95

/*
 * UNIX TCP sockets
 */
#define IPPORT_EXECSERVER       512
#define IPPORT_LOGINSERVER      513
#define IPPORT_CMDSERVER        514
#define IPPORT_EFSSERVER        520

/*
 * UNIX UDP sockets
 */
#define IPPORT_BIFFUDP          512
#define IPPORT_WHOSERVER        513
#define IPPORT_ROUTESERVER      520
                                        /* 520+1 also used */

/*
 * Ports < IPPORT_RESERVED are reserved for
 * privileged processes (e.g. root).
 */
#define IPPORT_RESERVED         1024

/*
 * Link numbers
 */
#define IMPLINK_IP              155
#define IMPLINK_LOWEXPER        156
#define IMPLINK_HIGHEXPER       158

/*
 * Internet address (old style... should be updated)
 */
struct in_addr {
        union {
                struct { u_char s_b1,s_b2,s_b3,s_b4; } S_un_b;
                struct { u_short s_w1,s_w2; } S_un_w;
                u_long S_addr;
        } S_un;
#define s_addr  S_un.S_addr
                                /* can be used for most tcp & ip code */
#define s_host  S_un.S_un_b.s_b2
                                /* host on imp */
#define s_net   S_un.S_un_b.s_b1
                                /* network */
#define s_imp   S_un.S_un_w.s_w2
                                /* imp */
#define s_impno S_un.S_un_b.s_b4
                                /* imp # */
#define s_lh    S_un.S_un_b.s_b3
                                /* logical host */
};

/*
 * Definitions of bits in internet address integers.
 * On subnets, the decomposition of addresses to host and net parts
 * is done according to subnet mask, not the masks here.
 */
#define IN_CLASSA(i)            (((long)(i) & 0x80000000) == 0)
#define IN_CLASSA_NET           0xff000000
#define IN_CLASSA_NSHIFT        24
#define IN_CLASSA_HOST          0x00ffffff
#define IN_CLASSA_MAX           128

#define IN_CLASSB(i)            (((long)(i) & 0xc0000000) == 0x80000000)
#define IN_CLASSB_NET           0xffff0000
#define IN_CLASSB_NSHIFT        16
#define IN_CLASSB_HOST          0x0000ffff
#define IN_CLASSB_MAX           65536

#define IN_CLASSC(i)            (((long)(i) & 0xe0000000) == 0xc0000000)
#define IN_CLASSC_NET           0xffffff00
#define IN_CLASSC_NSHIFT        8
#define IN_CLASSC_HOST          0x000000ff

#define INADDR_ANY              (u_long)0x00000000
#define INADDR_LOOPBACK         0x7f000001
#define INADDR_BROADCAST        (u_long)0xffffffff
#define INADDR_NONE             0xffffffff

/*
 * Socket address, internet style.
 */
struct sockaddr_in {
        short   sin_family;
        u_short sin_port;
        struct  in_addr sin_addr;
        char    sin_zero[8];
};

#define WSADESCRIPTION_LEN      256
#define WSASYS_STATUS_LEN       128

typedef struct WSAData {
        WORD                    wVersion;
        WORD                    wHighVersion;
        char                    szDescription[WSADESCRIPTION_LEN+1];
        char                    szSystemStatus[WSASYS_STATUS_LEN+1];
        unsigned short          iMaxSockets;
        unsigned short          iMaxUdpDg;
        char FAR *              lpVendorInfo;
} WSADATA;

typedef WSADATA FAR *LPWSADATA;

/*
 * Options for use with [gs]etsockopt at the IP level.
 */
#define IP_OPTIONS          1           /* set/get IP per-packet options    */
#define IP_MULTICAST_IF     2           /* set/get IP multicast interface   */
#define IP_MULTICAST_TTL    3           /* set/get IP multicast timetolive  */
#define IP_MULTICAST_LOOP   4           /* set/get IP multicast loopback    */
#define IP_ADD_MEMBERSHIP   5           /* add  an IP group membership      */
#define IP_DROP_MEMBERSHIP  6           /* drop an IP group membership      */
#define IP_TTL              7           /* set/get IP Time To Live          */
#define IP_TOS              8           /* set/get IP Type Of Service       */
#define IP_DONTFRAGMENT     9           /* set/get IP Don't Fragment flag   */


#define IP_DEFAULT_MULTICAST_TTL   1    /* normally limit m'casts to 1 hop  */
#define IP_DEFAULT_MULTICAST_LOOP  1    /* normally hear sends if a member  */
#define IP_MAX_MEMBERSHIPS         20   /* per socket; must fit in one mbuf */

/*
 * Argument structure for IP_ADD_MEMBERSHIP and IP_DROP_MEMBERSHIP.
 */
struct ip_mreq {
        struct in_addr  imr_multiaddr;  /* IP multicast address of group */
        struct in_addr  imr_interface;  /* local IP address of interface */
};

/*
 * Definitions related to sockets: types, address families, options,
 * taken from the BSD file sys/socket.h.
 */

/*
 * This is used instead of -1, since the
 * SOCKET type is unsigned.
 */
#define INVALID_SOCKET  (SOCKET)(~0)
#define SOCKET_ERROR            (-1)

/*
 * Types
 */
#define SOCK_STREAM     1               /* stream socket */
#define SOCK_DGRAM      2               /* datagram socket */
#define SOCK_RAW        3               /* raw-protocol interface */
#define SOCK_RDM        4               /* reliably-delivered message */
#define SOCK_SEQPACKET  5               /* sequenced packet stream */

/*
 * Option flags per-socket.
 */
#define SO_DEBUG        0x0001          /* turn on debugging info recording */
#define SO_ACCEPTCONN   0x0002          /* socket has had listen() */
#define SO_REUSEADDR    0x0004          /* allow local address reuse */
#define SO_KEEPALIVE    0x0008          /* keep connections alive */
#define SO_DONTROUTE    0x0010          /* just use interface addresses */
#define SO_BROADCAST    0x0020          /* permit sending of broadcast msgs */
#define SO_USELOOPBACK  0x0040          /* bypass hardware when possible */
#define SO_LINGER       0x0080          /* linger on close if data present */
#define SO_OOBINLINE    0x0100          /* leave received OOB data in line */

#define SO_DONTLINGER   (u_int)(~SO_LINGER)

/*
 * Additional options.
 */
#define SO_SNDBUF       0x1001          /* send buffer size */
#define SO_RCVBUF       0x1002          /* receive buffer size */
#define SO_SNDLOWAT     0x1003          /* send low-water mark */
#define SO_RCVLOWAT     0x1004          /* receive low-water mark */
#define SO_SNDTIMEO     0x1005          /* send timeout */
#define SO_RCVTIMEO     0x1006          /* receive timeout */
#define SO_ERROR        0x1007          /* get error status and clear */
#define SO_TYPE         0x1008          /* get socket type */

/*
 * Options for connect and disconnect data and options.  Used only by
 * non-TCP/IP transports such as DECNet, OSI TP4, etc.
 */
#define SO_CONNDATA     0x7000
#define SO_CONNOPT      0x7001
#define SO_DISCDATA     0x7002
#define SO_DISCOPT      0x7003
#define SO_CONNDATALEN  0x7004
#define SO_CONNOPTLEN   0x7005
#define SO_DISCDATALEN  0x7006
#define SO_DISCOPTLEN   0x7007

/*
 * Option for opening sockets for synchronous access.
 */
#define SO_OPENTYPE     0x7008

/*
 * TCP options.
 */
#define TCP_NODELAY     0x0001
#define TCP_BSDURGENT   0x7000


/*
 * Address families.
 */
 //	NOTE: these AF_ types MUST match those in import\tdi.h TDI_ADDRESS_TYPE_ def's
 // otherwise will not be able to correctly match addresses.
#define AF_UNSPEC       0               /* unspecified */
#define AF_UNIX         1               /* local to host (pipes, portals) */
#define AF_INET         2               /* internetwork: UDP, TCP, etc. */
#define AF_IMPLINK      3               /* arpanet imp addresses */
#define AF_PUP          4               /* pup protocols: e.g. BSP */
#define AF_CHAOS        5               /* mit CHAOS protocols */
#define AF_NS           6               /* XEROX NS protocols */
#define AF_IPX          6               /* IPX and SPX */
#define AF_ISO          7               /* ISO protocols */
#define AF_OSI          AF_ISO          /* OSI is ISO */
#define AF_ECMA         8               /* european computer manufacturers */
#define AF_DATAKIT      9               /* datakit protocols */
#define AF_CCITT        10              /* CCITT protocols, X.25 etc */
#define AF_SNA          11              /* IBM SNA */
#define AF_DECnet       12              /* DECnet */
#define AF_DLI          13              /* Direct data link interface */
#define AF_LAT          14              /* LAT */
#define AF_HYLINK       15              /* NSC Hyperchannel */
#define AF_APPLETALK    16              /* AppleTalk */
#define AF_NETBIOS      17              /* NetBios-style addresses */
#define AF_BAN          21				/* Banyan - this replaces the unused AF_PAGER in CE*/
//#define AF_IRDA         22              /* IrDA - defined in af_irda.h*/
#define AF_INET6         23              /* Internetwork Version 6 - replaces AF_RBDS in CE*/

#define AF_MAX          24

/*
 * Structure used by kernel to store most
 * addresses.
 */
struct sockaddr {
        u_short sa_family;              /* address family */
        char    sa_data[14];            /* up to 14 bytes of direct address */
};

/*
 * Structure used by kernel to pass protocol
 * information in raw sockets.
 */
struct sockproto {
        u_short sp_family;              /* address family */
        u_short sp_protocol;            /* protocol */
};

/*
 * Protocol families, same as address families for now.
 */
#define PF_UNSPEC       AF_UNSPEC
#define PF_UNIX         AF_UNIX
#define PF_INET         AF_INET
#define PF_IMPLINK      AF_IMPLINK
#define PF_PUP          AF_PUP
#define PF_CHAOS        AF_CHAOS
#define PF_NS           AF_NS
#define PF_IPX          AF_IPX
#define PF_ISO          AF_ISO
#define PF_OSI          AF_OSI
#define PF_ECMA         AF_ECMA
#define PF_DATAKIT      AF_DATAKIT
#define PF_CCITT        AF_CCITT
#define PF_SNA          AF_SNA
#define PF_DECnet       AF_DECnet
#define PF_DLI          AF_DLI
#define PF_LAT          AF_LAT
#define PF_HYLINK       AF_HYLINK
#define PF_APPLETALK    AF_APPLETALK

#define PF_MAX          AF_MAX

/*
 * Structure used for manipulating linger option.
 */
struct  linger {
        u_short l_onoff;                /* option on/off */
        u_short l_linger;               /* linger time */
};

/*
 * Level number for (get/set)sockopt() to apply to socket itself.
 */
#define SOL_SOCKET      0xffff          /* options for socket level */

/*
 * Maximum queue length specifiable by listen.
 */
#define SOMAXCONN       5

#define MSG_OOB         0x1             /* process out-of-band data */
#define MSG_PEEK        0x2             /* peek at incoming message */
#define MSG_DONTROUTE   0x4             /* send without using routing tables */

#define MSG_MAXIOVLEN   16

#define MSG_PARTIAL     0x8000          /* partial send or recv for message xport */

/*
 * Define constant based on rfc883, used by gethostbyxxxx() calls.
 */
#define MAXGETHOSTSTRUCT        1024

/*
 * Define flags to be used with the WSAAsyncSelect() call.
 */
#define FD_READ         0x01
#define FD_WRITE        0x02
#define FD_OOB          0x04
#define FD_ACCEPT       0x08
#define FD_CONNECT      0x10
#define FD_CLOSE        0x20

/*
 * WinSock error codes are also defined in winerror.h
 * Hence the IFDEF.
 */
#ifndef WSABASEERR

/*
 * All Windows Sockets error constants are biased by WSABASEERR from
 * the "normal"
 */
#define WSABASEERR              10000
/*
 * Windows Sockets definitions of regular Microsoft C error constants
 */
#define WSAEINTR                (WSABASEERR+4)
#define WSAEBADF                (WSABASEERR+9)
#define WSAEACCES               (WSABASEERR+13)
#define WSAEFAULT               (WSABASEERR+14)
#define WSAEINVAL               (WSABASEERR+22)
#define WSAEMFILE               (WSABASEERR+24)

/*
 * Windows Sockets definitions of regular Berkeley error constants
 */
#define WSAEWOULDBLOCK          (WSABASEERR+35)
#define WSAEINPROGRESS          (WSABASEERR+36)
#define WSAEALREADY             (WSABASEERR+37)
#define WSAENOTSOCK             (WSABASEERR+38)
#define WSAEDESTADDRREQ         (WSABASEERR+39)
#define WSAEMSGSIZE             (WSABASEERR+40)
#define WSAEPROTOTYPE           (WSABASEERR+41)
#define WSAENOPROTOOPT          (WSABASEERR+42)
#define WSAEPROTONOSUPPORT      (WSABASEERR+43)
#define WSAESOCKTNOSUPPORT      (WSABASEERR+44)
#define WSAEOPNOTSUPP           (WSABASEERR+45)
#define WSAEPFNOSUPPORT         (WSABASEERR+46)
#define WSAEAFNOSUPPORT         (WSABASEERR+47)
#define WSAEADDRINUSE           (WSABASEERR+48)
#define WSAEADDRNOTAVAIL        (WSABASEERR+49)
#define WSAENETDOWN             (WSABASEERR+50)
#define WSAENETUNREACH          (WSABASEERR+51)
#define WSAENETRESET            (WSABASEERR+52)
#define WSAECONNABORTED         (WSABASEERR+53)
#define WSAECONNRESET           (WSABASEERR+54)
#define WSAENOBUFS              (WSABASEERR+55)
#define WSAEISCONN              (WSABASEERR+56)
#define WSAENOTCONN             (WSABASEERR+57)
#define WSAESHUTDOWN            (WSABASEERR+58)
#define WSAETOOMANYREFS         (WSABASEERR+59)
#define WSAETIMEDOUT            (WSABASEERR+60)
#define WSAECONNREFUSED         (WSABASEERR+61)
#define WSAELOOP                (WSABASEERR+62)
#define WSAENAMETOOLONG         (WSABASEERR+63)
#define WSAEHOSTDOWN            (WSABASEERR+64)
#define WSAEHOSTUNREACH         (WSABASEERR+65)
#define WSAENOTEMPTY            (WSABASEERR+66)
#define WSAEPROCLIM             (WSABASEERR+67)
#define WSAEUSERS               (WSABASEERR+68)
#define WSAEDQUOT               (WSABASEERR+69)
#define WSAESTALE               (WSABASEERR+70)
#define WSAEREMOTE              (WSABASEERR+71)

#define WSAEDISCON              (WSABASEERR+101)

/*
 * Extended Windows Sockets error constant definitions
 */
#define WSASYSNOTREADY          (WSABASEERR+91)
#define WSAVERNOTSUPPORTED      (WSABASEERR+92)
#define WSANOTINITIALISED       (WSABASEERR+93)

/*
 * Error return codes from gethostbyname() and gethostbyaddr()
 * (when using the resolver). Note that these errors are
 * retrieved via WSAGetLastError() and must therefore follow
 * the rules for avoiding clashes with error numbers from
 * specific implementations or language run-time systems.
 * For this reason the codes are based at WSABASEERR+1001.
 * Note also that [WSA]NO_ADDRESS is defined only for
 * compatibility purposes.
 */
 

/* Authoritative Answer: Host not found */
#define WSAHOST_NOT_FOUND       (WSABASEERR+1001)

/* Non-Authoritative: Host not found, or SERVERFAIL */
#define WSATRY_AGAIN            (WSABASEERR+1002)

/* Non recoverable errors, FORMERR, REFUSED, NOTIMP */
#define WSANO_RECOVERY          (WSABASEERR+1003)

/* Valid name, no data record of requested type */
#define WSANO_DATA              (WSABASEERR+1004)

/*
 * WinSock error codes are also defined in winerror.h
 * Hence the IFDEF.
 */
#endif /* ifdef WSABASEERR */

/*
 * Compatibility macros.
 */


#define h_errno         GetLastError()
#define HOST_NOT_FOUND          WSAHOST_NOT_FOUND
#define TRY_AGAIN               WSATRY_AGAIN
#define NO_RECOVERY             WSANO_RECOVERY
#define NO_DATA                 WSANO_DATA
/* no address, look for MX record */
#define WSANO_ADDRESS           WSANO_DATA
#define NO_ADDRESS              WSANO_ADDRESS

/*
 * Windows Sockets errors redefined as regular Berkeley error constants.
 */
#define EWOULDBLOCK             WSAEWOULDBLOCK
#define EINPROGRESS             WSAEINPROGRESS
#define EALREADY                WSAEALREADY
#define ENOTSOCK                WSAENOTSOCK
#define EDESTADDRREQ            WSAEDESTADDRREQ
#define EMSGSIZE                WSAEMSGSIZE
#define EPROTOTYPE              WSAEPROTOTYPE
#define ENOPROTOOPT             WSAENOPROTOOPT
#define EPROTONOSUPPORT         WSAEPROTONOSUPPORT
#define ESOCKTNOSUPPORT         WSAESOCKTNOSUPPORT
#define EOPNOTSUPP              WSAEOPNOTSUPP
#define EPFNOSUPPORT            WSAEPFNOSUPPORT
#define EAFNOSUPPORT            WSAEAFNOSUPPORT
#define EADDRINUSE              WSAEADDRINUSE
#define EADDRNOTAVAIL           WSAEADDRNOTAVAIL
#define ENETDOWN                WSAENETDOWN
#define ENETUNREACH             WSAENETUNREACH
#define ENETRESET               WSAENETRESET
#define ECONNABORTED            WSAECONNABORTED
#define ECONNRESET              WSAECONNRESET
#define ENOBUFS                 WSAENOBUFS
#define EISCONN                 WSAEISCONN
#define ENOTCONN                WSAENOTCONN
#define ESHUTDOWN               WSAESHUTDOWN
#define ETOOMANYREFS            WSAETOOMANYREFS
#define ETIMEDOUT               WSAETIMEDOUT
#define ECONNREFUSED            WSAECONNREFUSED
#define ELOOP                   WSAELOOP
#define ENAMETOOLONG            WSAENAMETOOLONG
#define EHOSTDOWN               WSAEHOSTDOWN
#define EHOSTUNREACH            WSAEHOSTUNREACH
#define ENOTEMPTY               WSAENOTEMPTY
#define EPROCLIM                WSAEPROCLIM
#define EUSERS                  WSAEUSERS
#define EDQUOT                  WSAEDQUOT
#define ESTALE                  WSAESTALE
#define EREMOTE                 WSAEREMOTE

/* Socket function prototypes */

#ifdef __cplusplus
extern "C" {
#endif

SOCKET WINSOCKAPI accept (SOCKET s, struct sockaddr *addr,
                          int *addrlen);

int WINSOCKAPI bind (SOCKET s, const struct sockaddr *addr, int namelen);

int WINSOCKAPI closesocket (SOCKET s);

int WINSOCKAPI connect (SOCKET s, const struct sockaddr *name, int namelen);

int WINSOCKAPI ioctlsocket (SOCKET s, long cmd, u_long *argp);

int WINSOCKAPI getpeername (SOCKET s, struct sockaddr *name,
                            int * namelen);

int WINSOCKAPI getsockname (SOCKET s, struct sockaddr *name,
                            int * namelen);

int WINSOCKAPI getsockopt (SOCKET s, int level, int optname,
                           char * optval, int *optlen);

u_long WINSOCKAPI htonl (u_long hostlong);

u_short WINSOCKAPI htons (u_short hostshort);

unsigned long WINSOCKAPI inet_addr (const char * cp);

char * WINSOCKAPI inet_ntoa (struct in_addr in);

int WINSOCKAPI listen (SOCKET s, int backlog);

u_long WINSOCKAPI ntohl (u_long netlong);

u_short WINSOCKAPI ntohs (u_short netshort);

int WINSOCKAPI recv (SOCKET s, char * buf, int len, int flags);

int WINSOCKAPI recvfrom (SOCKET s, char * buf, int len, int flags,
                         struct sockaddr *from, int * fromlen);

int WINSOCKAPI select (int nfds, fd_set *readfds, fd_set *writefds,
                       fd_set *exceptfds, const struct timeval *timeout);

int WINSOCKAPI send (SOCKET s, const char * buf, int len, int flags);

int WINSOCKAPI sendto (SOCKET s, const char * buf, int len, int flags,
                       const struct sockaddr *to, int tolen);

int WINSOCKAPI setsockopt (SOCKET s, int level, int optname,
                           const char * optval, int optlen);

int WINSOCKAPI shutdown (SOCKET s, int how);

SOCKET WINSOCKAPI socket (int af, int type, int protocol);

/* Database function prototypes */

struct hostent * WINSOCKAPI gethostbyaddr(const char * addr,
                                              int len, int type);

struct hostent * WINSOCKAPI gethostbyname(const char * name);

int WINSOCKAPI gethostname (char * name, int namelen);

// WinCE specific
int WINSOCKAPI sethostname(char *pName, int cName);

/* Microsoft Windows Extension function prototypes */

int WINSOCKAPI WSAStartup(WORD wVersionRequired, LPWSADATA lpWSAData);

int WINSOCKAPI WSACleanup(void);

#define WSASetLastError(iError)		SetLastError(iError)

#define WSAGetLastError()		GetLastError()

int
WINSOCKAPI // WSAAPI
WSAIoctl(
    IN  SOCKET  s,
    IN  DWORD   dwIoControlCode,
    IN  LPVOID  lpvInBuffer OPTIONAL,
    IN  DWORD   cbInBuffer,
    OUT LPVOID  lpvOutBuffer OPTIONAL,
    IN  DWORD   cbOutBuffer,
    OUT LPDWORD lpcbBytesReturned OPTIONAL,
    IN  LPVOID lpOverlapped,
    IN  LPVOID lpCompletionRoutine
    );

#ifdef __cplusplus
}
#endif

/* Microsoft Windows Extended data types */
typedef struct sockaddr SOCKADDR;
typedef struct sockaddr *PSOCKADDR;
typedef struct sockaddr FAR *LPSOCKADDR;

typedef struct sockaddr_in SOCKADDR_IN;
typedef struct sockaddr_in *PSOCKADDR_IN;
typedef struct sockaddr_in FAR *LPSOCKADDR_IN;

typedef struct linger LINGER;
typedef struct linger *PLINGER;
typedef struct linger FAR *LPLINGER;

typedef struct in_addr IN_ADDR;
typedef struct in_addr *PIN_ADDR;
typedef struct in_addr FAR *LPIN_ADDR;

typedef struct fd_set FD_SET;
typedef struct fd_set *PFD_SET;
typedef struct fd_set FAR *LPFD_SET;

typedef struct hostent HOSTENT;
typedef struct hostent *PHOSTENT;
typedef struct hostent FAR *LPHOSTENT;

typedef struct servent SERVENT;
typedef struct servent *PSERVENT;
typedef struct servent FAR *LPSERVENT;

typedef struct protoent PROTOENT;
typedef struct protoent *PPROTOENT;
typedef struct protoent FAR *LPPROTOENT;

typedef struct timeval TIMEVAL;
typedef struct timeval *PTIMEVAL;
typedef struct timeval FAR *LPTIMEVAL;

/*
 * Windows message parameter composition and decomposition
 * macros.
 *
 * WSAMAKEASYNCREPLY is intended for use by the Windows Sockets implementation
 * when constructing the response to a WSAAsyncGetXByY() routine.
 */
#define WSAMAKEASYNCREPLY(buflen,error)     MAKELONG(buflen,error)
/*
 * WSAMAKESELECTREPLY is intended for use by the Windows Sockets implementation
 * when constructing the response to WSAAsyncSelect().
 */
#define WSAMAKESELECTREPLY(event,error)     MAKELONG(event,error)
/*
 * WSAGETASYNCBUFLEN is intended for use by the Windows Sockets application
 * to extract the buffer length from the lParam in the response
 * to a WSAGetXByY().
 */
#define WSAGETASYNCBUFLEN(lParam)           LOWORD(lParam)
/*
 * WSAGETASYNCERROR is intended for use by the Windows Sockets application
 * to extract the error code from the lParam in the response
 * to a WSAGetXByY().
 */
#define WSAGETASYNCERROR(lParam)            HIWORD(lParam)
/*
 * WSAGETSELECTEVENT is intended for use by the Windows Sockets application
 * to extract the event code from the lParam in the response
 * to a WSAAsyncSelect().
 */
#define WSAGETSELECTEVENT(lParam)           LOWORD(lParam)
/*
 * WSAGETSELECTERROR is intended for use by the Windows Sockets application
 * to extract the error code from the lParam in the response
 * to a WSAAsyncSelect().
 */
#define WSAGETSELECTERROR(lParam)           HIWORD(lParam)

#endif  /* _WINSOCKAPI_ */

// @CESYSGEN ENDIF

