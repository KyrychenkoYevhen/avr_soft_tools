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
/*


Module Name: winuser.h

--*/
//	@doc BOTH EXTERNAL CEUSER

#ifndef _WINUSER_
#define _WINUSER_

#ifdef __cplusplus
extern "C" {
#endif

#include <windef.h>
#include <mmsystem.h>


typedef struct tagMSG {
    HWND        hwnd;
    UINT        message;
    WPARAM      wParam;
    LPARAM      lParam;
    DWORD       time;
    POINT       pt;
} MSG, *PMSG, *NPMSG, *LPMSG;

#ifndef NORESOURCE

#define MAKEINTRESOURCEA(i) (LPSTR)((DWORD)((WORD)(i)))
#define MAKEINTRESOURCEW(i) (LPWSTR)((DWORD)((WORD)(i)))
#ifdef UNICODE
#define MAKEINTRESOURCE  MAKEINTRESOURCEW
#else
#define MAKEINTRESOURCE  MAKEINTRESOURCEA
#endif // !UNICODE

/*
 * Predefined Resource Types
 */
#define RT_CURSOR           MAKEINTRESOURCE(1)
#define RT_BITMAP           MAKEINTRESOURCE(2)
#define RT_ICON             MAKEINTRESOURCE(3)
#define RT_MENU             MAKEINTRESOURCE(4)
#define RT_DIALOG           MAKEINTRESOURCE(5)
#define RT_STRING           MAKEINTRESOURCE(6)
#define RT_FONTDIR          MAKEINTRESOURCE(7)
#define RT_FONT             MAKEINTRESOURCE(8)
#define RT_ACCELERATOR      MAKEINTRESOURCE(9)
#define RT_RCDATA           MAKEINTRESOURCE(10)
#define RT_MESSAGETABLE     MAKEINTRESOURCE(11)

#define DIFFERENCE          11
#define RT_GROUP_CURSOR     MAKEINTRESOURCE((DWORD)RT_CURSOR + DIFFERENCE)
#define RT_GROUP_ICON       MAKEINTRESOURCE((DWORD)RT_ICON + DIFFERENCE)
#define RT_VERSION          MAKEINTRESOURCE(16)
#define RT_DLGINCLUDE       MAKEINTRESOURCE(17)

#endif /* !NORESOURCE */

typedef LRESULT (CALLBACK* WNDPROC)(HWND, UINT, WPARAM, LPARAM);
typedef BOOL (CALLBACK* DLGPROC)(HWND, UINT, WPARAM, LPARAM);
// @CESYSGEN IF GWES_TIMER
typedef VOID (CALLBACK* TIMERPROC)(HWND, UINT, UINT, DWORD);
// @CESYSGEN ENDIF
// @CESYSGEN IF GWES_WINMGR
typedef BOOL (CALLBACK* PROPENUMPROCEX)(HWND, LPWSTR, HANDLE, DWORD);
// @CESYSGEN ENDIF

/* WNDCLASS */
typedef struct tagWNDCLASSA {
    UINT        style;
    WNDPROC     lpfnWndProc;
    int         cbClsExtra;
    int         cbWndExtra;
    HINSTANCE   hInstance;
    HICON       hIcon;
    HCURSOR     hCursor;
    HBRUSH      hbrBackground;
    LPCSTR      lpszMenuName;
    LPCSTR      lpszClassName;
} WNDCLASSA, *PWNDCLASSA, *LPWNDCLASSA;

typedef struct tagWNDCLASSW {
    UINT        style;
    WNDPROC     lpfnWndProc;
    int         cbClsExtra;
    int         cbWndExtra;
    HINSTANCE   hInstance;
    HICON       hIcon;
    HCURSOR     hCursor;
    HBRUSH      hbrBackground;
    LPCWSTR     lpszMenuName;
    LPCWSTR     lpszClassName;
} WNDCLASSW, *PWNDCLASSW, *LPWNDCLASSW;

#ifdef UNICODE
typedef WNDCLASSW WNDCLASS;
typedef PWNDCLASSW PWNDCLASS;
typedef LPWNDCLASSW LPWNDCLASS;
typedef PWNDCLASSW PWNDCLASS;
#else
typedef WNDCLASSA WNDCLASS;
typedef PWNDCLASSA PWNDCLASS;
typedef LPWNDCLASSA LPWNDCLASS;
typedef PWNDCLASSA PWNDCLASS;
#endif // UNICODE


// @CESYSGEN IF GWES_WINMGR

#define HSHELL_WINDOWCREATED        1
#define HSHELL_WINDOWDESTROYED      2
#define HSHELL_WINDOWACTIVATED      4
#define HSHELL_REDRAW               6
#define HSHELL_TASKMAN              7
#define HSHELL_CAPSLOCK				8

// @CESYSGEN ENDIF


#define POINTSTOPOINT(pt, pts)                          \
        { (pt).x = (LONG)(SHORT)LOWORD(*(LONG*)&pts);   \
          (pt).y = (LONG)(SHORT)HIWORD(*(LONG*)&pts); }

#define POINTTOPOINTS(pt)      (MAKELONG((short)((pt).x), (short)((pt).y)))

// @CESYSGEN IF GWES_WINMGR
#define MAKEWPARAM(l, h)      (WPARAM)MAKELONG(l, h)
#define MAKELPARAM(l, h)      (LPARAM)MAKELONG(l, h)
#define MAKELRESULT(l, h)     (LRESULT)MAKELONG(l, h)


/*
 * Window Messages
 */

#define WM_MOVE                         0x0003
#define WM_SIZE                         0x0005

// @CESYSGEN ENDIF

// @CESYSGEN IF GWES_WMBASE
// @CESYSGEN IF GWES_FOREGND
#define WM_ACTIVATE                     0x0006
/*
 * WM_ACTIVATE state values
 */
#define     WA_INACTIVE     0
#define     WA_ACTIVE       1
#define     WA_CLICKACTIVE  2

#define WM_SETFOCUS                     0x0007
#define WM_KILLFOCUS                    0x0008
// @CESYSGEN ENDIF
// @CESYSGEN ENDIF

// @CESYSGEN IF GWES_WINMGR

#define WM_SETREDRAW                    0x000B
#define WM_SETTEXT                      0x000C
#define WM_GETTEXT                      0x000D
#define WM_GETTEXTLENGTH                0x000E
#define WM_PAINT                        0x000F

// @CESYSGEN ENDIF

// @CESYSGEN IF GWES_WINMGR
#define WM_ERASEBKGND                   0x0014
#define WM_SYSCOLORCHANGE               0x0015
#define WM_SHOWWINDOW                   0x0018
#define WM_WININICHANGE                 0x001A
#if(WINVER >= 0x0400)
#define WM_SETTINGCHANGE                WM_WININICHANGE
#endif /* WINVER >= 0x0400 */

#define WM_FONTCHANGE                   0x001D
#define WM_CANCELMODE                   0x001F
// @CESYSGEN ENDIF

// @CESYSGEN IF GWES_CURSOR || GWES_MCURSOR
#define WM_SETCURSOR                    0x0020
// @CESYSGEN ENDIF

// @CESYSGEN IF GWES_DLGMGR
#define WM_NEXTDLGCTL                   0x0028
// @CESYSGEN ENDIF

// @CESYSGEN IF GWES_WINMGR
#define WM_DRAWITEM                     0x002B
#define WM_MEASUREITEM                  0x002C
#define WM_DELETEITEM                   0x002D
#define WM_SETFONT                      0x0030
#define WM_GETFONT                      0x0031
#define WM_COMPAREITEM                  0x0039

#define WM_WINDOWPOSCHANGED             0x0047

// @CESYSGEN ENDIF

// @CESYSGEN IF GWES_WINMGR


#define WM_NOTIFY                       0x004E
#define WM_HELP                         0x0053

#define WM_STYLECHANGED                 0x007D
// @CESYSGEN ENDIF


// @CESYSGEN IF GWES_DLGMGR
#define WM_GETDLGCODE                   0x0087
// @CESYSGEN ENDIF

// @CESYSGEN IF GWES_KBDUI
#define WM_KEYFIRST                     0x0100
#define WM_KEYDOWN                      0x0100
#define WM_KEYUP                        0x0101
#define WM_CHAR                         0x0102
#define WM_DEADCHAR                     0x0103
#define WM_SYSKEYDOWN                   0x0104
#define WM_SYSKEYUP                     0x0105
#define WM_SYSCHAR                      0x0106
#define WM_SYSDEADCHAR                  0x0107
#define WM_KEYLAST                      0x0108

#define WM_IM_INFO			0x010C

#define WM_IME_STARTCOMPOSITION			0x010D
#define WM_IME_ENDCOMPOSITION			0x010E
#define WM_IME_COMPOSITION				0x010F
#define WM_IME_KEYLAST					0x010F

#define WM_IME_SETCONTEXT				0x0281
#define WM_IME_NOTIFY					0x0282
#define WM_IME_CONTROL					0x0283
#define WM_IME_COMPOSITIONFULL			0x0284
#define WM_IME_SELECT					0x0285
#define WM_IME_CHAR						0x0286
#define WM_IME_SYSTEM					0x0287
#define WM_IME_REQUEST                  0x0288
#define WM_IME_KEYDOWN					0x0290
#define WM_IME_KEYUP					0x0291

// @CESYSGEN ENDIF

// @CESYSGEN IF GWES_DLGMGR
#define WM_INITDIALOG                   0x0110
// @CESYSGEN ENDIF


// @CESYSGEN IF GWES_WINMGR
#define WM_COMMAND                      0x0111
#define WM_SYSCOMMAND                   0x0112
// @CESYSGEN ENDIF
// @CESYSGEN IF GWES_TIMER
#define WM_TIMER   				        0x0113
// @CESYSGEN ENDIF
// @CESYSGEN IF GWES_WINMGR
#define WM_HSCROLL          			0x0114
#define WM_VSCROLL          			0x0115
// @CESYSGEN ENDIF
// @CESYSGEN IF GWES_MENU
#define WM_INITMENUPOPUP                0x0117
#define WM_MENUCHAR                     0x0120
// @CESYSGEN ENDIF

#define WM_MOUSEFIRST                   0x0200
#define WM_MOUSEMOVE                    0x0200
#define WM_LBUTTONDOWN                  0x0201
#define WM_LBUTTONUP                    0x0202
#define WM_LBUTTONDBLCLK                0x0203
#define WM_RBUTTONDOWN                  0x0204
#define WM_RBUTTONUP                    0x0205
#define WM_RBUTTONDBLCLK                0x0206
#define WM_MBUTTONDOWN                  0x0207
#define WM_MBUTTONUP                    0x0208
#define WM_MBUTTONDBLCLK                0x0209
#define WM_MOUSELAST                    0x0209

#define WM_MOUSEWHEEL                   0x020A
#undef WM_MOUSELAST
#define WM_MOUSELAST					0x020A

// @CESYSGEN IF GWES_MENU
#define MENULOOP_WINDOW                 0
#define MENULOOP_POPUP                  1
#define WM_ENTERMENULOOP                0x0211
#define WM_EXITMENULOOP                 0x0212
// @CESYSGEN ENDIF
#define WM_CAPTURECHANGED               0x0215

// @CESYSGEN IF GWES_CLIPBD
#define WM_CUT                          0x0300
#define WM_COPY                         0x0301
#define WM_PASTE                        0x0302
#define WM_CLEAR                        0x0303
#define WM_UNDO                         0x0304
#define WM_RENDERFORMAT                 0x0305
#define WM_RENDERALLFORMATS             0x0306
#define WM_DESTROYCLIPBOARD             0x0307
// @CESYSGEN ENDIF

// @CESYSGEN IF GWES_PGDI || GWES_MGPAL
#define WM_QUERYNEWPALETTE              0x030F
#define WM_PALETTECHANGED               0x0311
// @CESYSGEN ENDIF

// @CESYSGEN IF GWES_MSGBOX
#define WM_CTLCOLORMSGBOX               0x0132
// @CESYSGEN ENDIF
// @CESYSGEN IF GWES_EDCTL
#define WM_CTLCOLOREDIT                 0x0133
// @CESYSGEN ENDIF
// @CESYSGEN IF GWES_LBCTL
#define WM_CTLCOLORLISTBOX              0x0134
// @CESYSGEN ENDIF
// @CESYSGEN IF GWES_BTNCTL
#define WM_CTLCOLORBTN                  0x0135
// @CESYSGEN ENDIF
// @CESYSGEN IF GWES_DLGMGR
#define WM_CTLCOLORDLG                  0x0136
// @CESYSGEN ENDIF
// @CESYSGEN IF GWES_SCBCTL
#define WM_CTLCOLORSCROLLBAR            0x0137
// @CESYSGEN ENDIF
// @CESYSGEN IF GWES_STCCTL
#define WM_CTLCOLORSTATIC               0x0138
// @CESYSGEN ENDIF
#define WM_VKEYTOITEM                   0x002E
#define WM_CHARTOITEM                   0x002F
#define WM_QUERYDRAGICON                0x0037

// New for WINCE
#define WM_DBNOTIFICATION				0x03FD
#define WM_NETCONNECT                   0x03FE
#define WM_HIBERNATE                    0x03FF

#define WM_APP                          0x8000

/*
 * NOTE: All Message Numbers below 0x0400 are RESERVED.
 *
 * Private Window Messages Start Here:
 */
#define WM_USER                         0x0400


// @CESYSGEN IF GWES_WINMGR
/*
 * WM_SIZE message wParam values
 */
#define SIZE_RESTORED       0
#define SIZE_MINIMIZED      1
#define SIZE_MAXIMIZED      2
#define SIZE_MAXSHOW        3
#define SIZE_MAXHIDE        4

/*
 * Window Styles
 */
#ifdef UNDER_NT
#define WS_OVERLAPPED       0x00000000L
#else
// @CESYSGEN IF GWES_NCLIENT
#define WS_OVERLAPPED       WS_BORDER | WS_CAPTION
// @CESYSGEN ENDIF
#endif // UNDER_NT
#define WS_CLIPSIBLINGS     0x04000000L
#define WS_CLIPCHILDREN     0x02000000L
// @CESYSGEN IF GWES_NCLIENT
#define WS_CAPTION          0x00C00000L     /* WS_BORDER | WS_DLGFRAME  */
#define WS_BORDER           0x00800000L
#define WS_DLGFRAME         0x00400000L
#define WS_VSCROLL          0x00200000L
#define WS_HSCROLL          0x00100000L
#define WS_SYSMENU          0x00080000L
#define WS_THICKFRAME		0x00040000L
#define WS_MAXIMIZEBOX		0x00020000L
#define WS_MINIMIZEBOX		0x00010000L
#define WS_SIZEBOX          WS_THICKFRAME
// @CESYSGEN ENDIF
#define WS_POPUP            0x80000000L


/*
 * Class styles
 */
#define CS_DBLCLKS          0x0008
#define CS_GLOBALCLASS      0x4000

/*
 * Extended Window Styles
 */
// @CESYSGEN IF GWES_NCLIENT
#define WS_EX_DLGMODALFRAME     0x00000001L
// @CESYSGEN ENDIF
#define WS_EX_TOPMOST           0x00000008L
#if(WINVER >= 0x0400)
#define WS_EX_TOOLWINDOW        0x00000080L
// @CESYSGEN IF GWES_NCLIENT
#define WS_EX_WINDOWEDGE        0x00000100L
#define WS_EX_CLIENTEDGE        0x00000200L

#define WS_EX_CONTEXTHELP	    0x00000400L
#define WS_EX_STATICEDGE        0x00020000L
// @CESYSGEN ENDIF

// @CESYSGEN IF GWES_NCLIENT
#define WS_EX_OVERLAPPEDWINDOW  (WS_EX_WINDOWEDGE | WS_EX_CLIENTEDGE)

#define WS_EX_CAPTIONOKBTN      0x80000000L
#define WS_EX_NODRAG            0x40000000L
// @CESYSGEN ENDIF
#define WS_EX_ABOVESTARTUP		0x20000000L
#define WS_EX_INK				0x10000000L
#define WS_EX_NOANIMATION		0x04000000L

#endif /* WINVER >= 0x0400 */

/*
 * Class styles
 */
#define CS_VREDRAW          0x0001
#define CS_HREDRAW          0x0002
#define CS_DBLCLKS          0x0008
#define CS_PARENTDC         0x0080
#define CS_NOCLOSE          0x0200
#define CS_SAVEBITS         0x0800
#define CS_GLOBALCLASS      0x4000
#define CS_IME              0x00010000
// @CESYSGEN ENDIF GWES_WINMGR


// @CESYSGEN IF GWES_NCLIENT
/* flags for DrawFrameControl */

#define DFC_CAPTION             1
#define DFC_SCROLL              3
#define DFC_BUTTON              4

#define DFCS_CAPTIONCLOSE       0x0000
#define DFCS_CAPTIONHELP        0x0004
#define DFCS_CAPTIONOKBTN   	0x0080
#define DFCS_CAPTIONMIN         0x0020
#define DFCS_CAPTIONMAX         0x0040
#define DFCS_CAPTIONRESTORE     0x0800

#define DFCS_SCROLLUP           0x0000
#define DFCS_SCROLLDOWN         0x0001
#define DFCS_SCROLLLEFT         0x0002
#define DFCS_SCROLLRIGHT        0x0003
#define DFCS_SCROLLCOMBOBOX     0x0005

#define DFCS_BUTTONCHECK        0x0000
#define DFCS_BUTTONRADIO        0x0004
#define DFCS_BUTTON3STATE       0x0008
#define DFCS_BUTTONPUSH         0x0010

#define DFCS_INACTIVE           0x0100
#define DFCS_PUSHED             0x0200
#define DFCS_CHECKED            0x0400

WINUSERAPI BOOL    WINAPI DrawFrameControl(HDC, LPRECT, UINT, UINT);
// @CESYSGEN ENDIF GWES_NCLIENT



// @CESYSGEN IF GWES_CLIPBD
/*
 * Predefined Clipboard Formats
 */
#define CF_TEXT             1
#define CF_BITMAP           2
#define CF_SYLK             4
#define CF_DIF              5
#define CF_TIFF             6
#define CF_OEMTEXT          7
#define CF_DIB              8
#define CF_PALETTE          9
#define CF_PENDATA          10
#define CF_RIFF             11
#define CF_WAVE             12
#define CF_UNICODETEXT      13
// @CESYSGEN ENDIF
/*
	WM_WININICHANGE section paramater
*/
#define INI_INTL			1			// Regional Setting changed


/*
 * WM_NCHITTEST and MOUSEHOOKSTRUCT Mouse Position Codes
 */
#define HTERROR             (-2)
#define HTTRANSPARENT       (-1)
#define HTNOWHERE           0
#define HTCLIENT            1
#define HTCAPTION           2
#define HTSYSMENU           3
#define HTGROWBOX           4
#define HTSIZE              HTGROWBOX
#define HTMENU              5
#define HTHSCROLL           6
#define HTVSCROLL           7
#define HTMINBUTTON         8
#define HTMAXBUTTON         9
#define HTLEFT              10
#define HTRIGHT             11
#define HTTOP               12
#define HTTOPLEFT           13
#define HTTOPRIGHT          14
#define HTBOTTOM            15
#define HTBOTTOMLEFT        16
#define HTBOTTOMRIGHT       17
#define HTBORDER            18
#define HTREDUCE            HTMINBUTTON
#define HTZOOM              HTMAXBUTTON
#define HTSIZEFIRST         HTLEFT
#define HTSIZELAST          HTBOTTOMRIGHT
#if(WINVER >= 0x0400)
#define HTOBJECT            19
#define HTCLOSE             20
#define HTHELP              21
#endif /* WINVER >= 0x0400 */

WINUSERAPI
UINT
WINAPI
RegisterWindowMessageA(
    LPCSTR lpString);
WINUSERAPI
UINT
WINAPI
RegisterWindowMessageW(
    LPCWSTR lpString);
#ifdef UNICODE
#define RegisterWindowMessage  RegisterWindowMessageW
#else
#define RegisterWindowMessage  RegisterWindowMessageA
#endif // !UNICODE


typedef struct tagCREATESTRUCTA {
    LPVOID      lpCreateParams;
    HINSTANCE   hInstance;
    HMENU       hMenu;
    HWND        hwndParent;
    int         cy;
    int         cx;
    int         y;
    int         x;
    LONG        style;
    LPCSTR      lpszName;
    LPCSTR      lpszClass;
    DWORD       dwExStyle;
} CREATESTRUCTA, *PCREATESTRUCTA, *LPCREATESTRUCTA;

typedef struct tagCREATESTRUCTW {
    LPVOID      lpCreateParams;
    HINSTANCE   hInstance;
    HMENU       hMenu;
    HWND        hwndParent;
    int         cy;
    int         cx;
    int         y;
    int         x;
    LONG        style;
    LPCWSTR     lpszName;
    LPCWSTR     lpszClass;
    DWORD       dwExStyle;
} CREATESTRUCTW, *PCREATESTRUCTW, *LPCREATESTRUCTW;

#ifdef UNICODE
typedef CREATESTRUCTW CREATESTRUCT;
typedef LPCREATESTRUCTW LPCREATESTRUCT;
typedef PCREATESTRUCTW LPCREATESTRUCT;
#else
typedef CREATESTRUCTA CREATESTRUCT;
typedef LPCREATESTRUCTA LPCREATESTRUCT;
typedef PCREATESTRUCTA LPCREATESTRUCT;
#endif // UNICODE

// @CESYSGEN IF GWES_WINMGR

typedef struct tagSTYLESTRUCT
{
    DWORD   styleOld;
    DWORD   styleNew;
} STYLESTRUCT, * LPSTYLESTRUCT;

typedef void * HDWP;

/*
 * WM_WINDOWPOSCHANGED struct pointed to by lParam
 */
typedef struct tagWINDOWPOS {
    HWND    hwnd;
    HWND    hwndInsertAfter;
    int     x;
    int     y;
    int     cx;
    int     cy;
    UINT    flags;
} WINDOWPOS, *LPWINDOWPOS, *PWINDOWPOS;
// @CESYSGEN ENDIF



#if(WINVER >= 0x0400)
#define EW_RESTARTWINDOWS    0x0042L
#define EW_REBOOTSYSTEM      0x0043L
#define EW_EXITANDEXECAPP    0x0044L
#endif /* WINVER >= 0x0400 */

#define EWX_LOGOFF   0
#define EWX_SHUTDOWN 1
#define EWX_REBOOT   2
#define EWX_FORCE    4
#define EWX_POWEROFF 8


/* MESSAGES */

// @CESYSGEN IF GWES_MSGQUE
/*
 * Special HWND value for use with PostMessage() and SendMessage()
 */
#define HWND_BROADCAST  ((HWND)0xffff)

WINUSERAPI
BOOL
WINAPI
PostMessageA(
    HWND hWnd,
    UINT Msg,
    WPARAM wParam,
    LPARAM lParam);
WINUSERAPI
BOOL
WINAPI
PostMessageW(
    HWND hWnd,
    UINT Msg,
    WPARAM wParam,
    LPARAM lParam);
#ifdef UNICODE
#define PostMessage  PostMessageW
#else
#define PostMessage  PostMessageA
#endif // !UNICODE



WINUSERAPI
BOOL
WINAPI
PostThreadMessageA(
    DWORD idThread,
    UINT Msg,
    WPARAM wParam,
    LPARAM lParam);
WINUSERAPI
BOOL
WINAPI
PostThreadMessageW(
    DWORD idThread,
    UINT Msg,
    WPARAM wParam,
    LPARAM lParam);
#ifdef UNICODE
#define PostThreadMessage  PostThreadMessageW
#else
#define PostThreadMessage  PostThreadMessageA
#endif // !UNICODE

VOID
WINAPI
PostQuitMessage(
    int     nExitCode
    );


WINUSERAPI
LRESULT
WINAPI
SendMessageA(
    HWND hWnd,
    UINT Msg,
    WPARAM wParam,
    LPARAM lParam);
WINUSERAPI
LRESULT
WINAPI
SendMessageW(
    HWND hWnd,
    UINT Msg,
    WPARAM wParam,
    LPARAM lParam);
#ifdef UNICODE
#define SendMessage  SendMessageW
#else
#define SendMessage  SendMessageA
#endif // !UNICODE


WINUSERAPI
BOOL
WINAPI
SendNotifyMessageA(
    HWND hWnd,
    UINT Msg,
    WPARAM wParam,
    LPARAM lParam);
WINUSERAPI
BOOL
WINAPI
SendNotifyMessageW(
    HWND hWnd,
    UINT Msg,
    WPARAM wParam,
    LPARAM lParam);
#ifdef UNICODE
#define SendNotifyMessage  SendNotifyMessageW
#else
#define SendNotifyMessage  SendNotifyMessageA
#endif // !UNICODE


WINUSERAPI
LRESULT
WINAPI
SendMessageTimeout(
	HWND		hWnd,            
	UINT		uMsg,             
	WPARAM		wParam,        
	LPARAM		lParam,        
	UINT		fuFlags,         
	UINT		uTimeout,        
	PDWORD_PTR	lpdwResult);

WINUSERAPI
DWORD
WINAPI
GetMessageQueueReadyTimeStamp(
	HWND	hWnd
	);

WINUSERAPI
BOOL
WINAPI
InSendMessage(
	VOID);

WINUSERAPI
DWORD
WINAPI
GetQueueStatus(
	UINT flags);


WINUSERAPI
BOOL
WINAPI
GetMessageA(
    LPMSG lpMsg,
    HWND hWnd ,
    UINT wMsgFilterMin,
    UINT wMsgFilterMax);
WINUSERAPI
BOOL
WINAPI
GetMessageW(
    LPMSG lpMsg,
    HWND hWnd ,
    UINT wMsgFilterMin,
    UINT wMsgFilterMax);
#ifdef UNICODE
#define GetMessage  GetMessageW
#else
#define GetMessage  GetMessageA
#endif // !UNICODE



WINUSERAPI
BOOL
WINAPI
PeekMessageW(
    PMSG pMsg,
    HWND hWnd ,
    UINT wMsgFilterMin,
    UINT wMsgFilterMax,
    UINT wRemoveMsg);
WINUSERAPI
BOOL
WINAPI
PeekMessageA(
    PMSG pMsg,
    HWND hWnd ,
    UINT wMsgFilterMin,
    UINT wMsgFilterMax,
    UINT wRemoveMsg);
#ifdef UNICODE
#define PeekMessage  PeekMessageW
#else
#define PeekMessage  PeekMessageA
#endif // !UNICODE

/*
 * PeekMessage() Options
 */
#define PM_NOREMOVE         0x0000
#define PM_REMOVE           0x0001
#define PM_NOYIELD          0x0002



BOOL
WINAPI
TranslateMessage(
    CONST MSG   *pMsg
    );


WINUSERAPI
LONG
WINAPI
DispatchMessageA(
    CONST MSG *lpMsg);
WINUSERAPI
LONG
WINAPI
DispatchMessageW(
    CONST MSG *lpMsg);
#ifdef UNICODE
#define DispatchMessage  DispatchMessageW
#else
#define DispatchMessage  DispatchMessageA
#endif // !UNICODE

DWORD
WINAPI
GetMessagePos(
	VOID
	);


#define MSGSRC_UNKNOWN				0
#define MSGSRC_SOFTWARE_POST 		1
#define MSGSRC_HARDWARE_KEYBOARD	2

UINT
WINAPI
GetMessageSource(
	void
	);

WINUSERAPI
DWORD
WINAPI
MsgWaitForMultipleObjectsEx(
    DWORD nCount,
    LPHANDLE pHandles,
    DWORD dwMilliseconds,
    DWORD dwWakeMask,
    DWORD dwFlags);

#define MWMO_INPUTAVAILABLE	0x0004

#ifdef UNDER_CE
#define MsgWaitForMultipleObjects(cnt,hndl,wa,ms,wm)	\
	MsgWaitForMultipleObjectsEx(cnt,hndl,ms,wm,0)
#else
WINUSERAPI
DWORD
WINAPI
MsgWaitForMultipleObjects(
    DWORD nCount,
    LPHANDLE pHandles,
    BOOL fWaitAll,
    DWORD dwMilliseconds,
    DWORD dwWakeMask);
#endif
/*
 * Queue status flags for GetQueueStatus() and MsgWaitForMultipleObjects()
 */
#define QS_KEY              0x0001
#define QS_MOUSEMOVE        0x0002
#define QS_MOUSEBUTTON      0x0004
#define QS_POSTMESSAGE      0x0008
#define QS_TIMER            0x0010
#define QS_PAINT            0x0020
#define QS_SENDMESSAGE      0x0040



#define QS_MOUSE           (QS_MOUSEMOVE     | \
                            QS_MOUSEBUTTON)

#define QS_INPUT           (QS_MOUSE         | \
                            QS_KEY)

#define QS_ALLEVENTS       (QS_INPUT         | \
                            QS_POSTMESSAGE   | \
                            QS_TIMER         | \
                            QS_PAINT)

#define QS_ALLINPUT        (QS_INPUT         | \
                            QS_POSTMESSAGE   | \
                            QS_TIMER         | \
                            QS_PAINT         | \
                            QS_SENDMESSAGE)

/*
 * SendMessageTimeout values
 */
#define SMTO_NORMAL         0x0000

// @CESYSGEN ENDIF

/* CAPTURE */


// @CESYSGEN IF GWES_FOREGND
HWND
WINAPI
GetCapture(
    VOID);

HWND
WINAPI
SetCapture(
    HWND hWnd);

BOOL
WINAPI
ReleaseCapture(
    VOID);
// @CESYSGEN ENDIF


// @CESYSGEN IF GWES_WINMGR
BOOL
WINAPI
MoveWindow(
    HWND hWnd,
    int X,
    int Y,
    int nWidth,
    int nHeight,
    BOOL bRepaint);

int
WINAPI
SetWindowRgn (
    HWND hwnd,
	HRGN hrgn,
	BOOL bRedraw
    );

int
WINAPI
GetWindowRgn (
    HWND hwnd,
	HRGN hrgn
    );

BOOL
WINAPI
SetWindowPos (
    HWND hwnd,
    HWND hwndInsertAfter,
    int x,
    int y,
    int dx,
    int dy,
    UINT fuFlags
    );

BOOL
WINAPI
GetWindowRect (
    HWND hwnd,
    LPRECT prc
    );

int
WINAPI
GetWindowTextLengthA(
    HWND hWnd);

int
WINAPI
GetWindowTextLengthW(
    HWND hWnd);
#ifdef UNICODE
#define GetWindowTextLength  GetWindowTextLengthW
#else
#define GetWindowTextLength  GetWindowTextLengthA
#endif

BOOL
WINAPI
GetClientRect (
    HWND hwnd,
    LPRECT prc
    );

BOOL
WINAPI
AdjustWindowRectEx (
    LPRECT prc,
    DWORD  dwStyle,
    BOOL   bMenu,
    DWORD  dwExStyle
    );

BOOL
WINAPI
ValidateRect(
    HWND hWnd ,
    CONST RECT *lpRect);

BOOL
WINAPI
InvalidateRect (
    HWND hwnd,
    LPCRECT prc,
    BOOL fErase
    );

BOOL
WINAPI
ValidateRgn (
	HWND hWnd,
	HRGN hRgn
	);

BOOL
WINAPI
InvalidateRgn (
	HWND hWnd,
	HRGN hRgn,
	BOOL fErase
	);

HWND
WINAPI
GetWindow (
    HWND hwnd,
    UINT uCmd
    );

BOOL
WINAPI
BringWindowToTop(
    HWND hWnd);

HDWP WINAPI BeginDeferWindowPos(
	int nNumWindows);

HDWP WINAPI DeferWindowPos(	
   HDWP hWinPosInfo,
   HWND hWnd,
   HWND hWndInsertAfter,
   int x,
   int y,
   int cx,
   int cy,
   UINT uFlags
   );

BOOL WINAPI EndDeferWindowPos(
  HDWP hWinPosInfo
  );

WINUSERAPI
BOOL
WINAPI
SetProp(
    HWND hWnd,
    LPCWSTR lpString,
    HANDLE hData
	);

WINUSERAPI
HANDLE
WINAPI
GetProp(
    HWND hWnd,
    LPCWSTR lpString
	);

WINUSERAPI
HANDLE
WINAPI
RemoveProp(
    HWND hWnd,
    LPCWSTR lpString
	);

WINUSERAPI
int
WINAPI
EnumPropsEx(
    HWND hWnd,
    PROPENUMPROCEX lpEnumFunc,
    LPARAM lParam
	);


/* Flags for SetWindowPos API */
#define HWND_TOP        ((HWND)0)
#define HWND_TOPMOST    ((HWND)-1)
#define HWND_NOTOPMOST    ((HWND)-2)
#define HWND_BOTTOM     ((HWND)1)

#define SWP_NOSIZE			0x0001
#define SWP_NOMOVE			0x0002
#define SWP_NOZORDER		0x0004
#define SWP_NOACTIVATE		0x0010
#define SWP_FRAMECHANGED	0x0020  /* The frame changed: send WM_NCCALCSIZE */
#define SWP_SHOWWINDOW		0x0040
#define SWP_HIDEWINDOW		0x0080
#define SWP_NOOWNERZORDER   0x0200  /* Don't do owner Z ordering */

#define SWP_DRAWFRAME       SWP_FRAMECHANGED
#define SWP_NOREPOSITION    SWP_NOOWNERZORDER


/* Flags for GetWindow() api */
#define GW_HWNDFIRST        0
#define GW_HWNDLAST         1
#define GW_HWNDNEXT         2
#define GW_HWNDPREV         3
#define GW_OWNER            4
#define GW_CHILD            5
#define GW_MAX              5


int
WINAPI
ScrollWindowEx(
    HWND hWnd,
    int dx,
    int dy,
    CONST RECT *prcScroll,
    CONST RECT *prcClip ,
    HRGN hrgnUpdate,
    LPRECT prcUpdate,
    UINT flags);

#define SW_INVALIDATE       0x0002  /* Invalidate after scrolling */
#define SW_ERASE            0x0004  /* If SW_INVALIDATE, don't send WM_ERASEBACKGROUND */
// @CESYSGEN ENDIF


// @CESYSGEN IF GWES_PGDI || GWES_MGWINMGR
BOOL
WINAPI
ScrollDC(
    HDC hDC,
    int dx,
    int dy,
    CONST RECT *lprcScroll,
    CONST RECT *lprcClip ,
    HRGN hrgnUpdate,
    LPRECT lprcUpdate);
// @CESYSGEN ENDIF


// @CESYSGEN IF GWES_MENU
/*
 * Menu flags
 */
#define MF_BYCOMMAND        0x00000000L
#define MF_BYPOSITION       0x00000400L

#define MF_SEPARATOR        0x00000800L

#define MF_ENABLED          0x00000000L
#define MF_GRAYED           0x00000001L

#define MF_UNCHECKED        0x00000000L
#define MF_CHECKED          0x00000008L

#define MF_STRING           0x00000000L
#define MF_OWNERDRAW        0x00000100L

#define MF_POPUP            0x00000010L
// @CESYSGEN IF GWES_COLUMN
#define MF_MENUBARBREAK     0x00000020L
#define MF_MENUBREAK        0x00000040L
// @CESYSGEN ENDIF

#define MF_UNHILITE         0x00000000L
#define MF_HILITE           0x00000080L

#define MF_END              0x00000080L  /* Obsolete -- only used by old RES files */

#define MFT_STRING          MF_STRING
#define MFT_MENUBARBREAK    MF_MENUBARBREAK
#define MFT_MENUBREAK       MF_MENUBREAK
#define MFT_OWNERDRAW       MF_OWNERDRAW
#define MFT_RADIOCHECK      0x00000200L
#define MFT_SEPARATOR       MF_SEPARATOR

/* Menu flags for Add/Check/EnableMenuItem() */
#define MFS_CHECKED         MF_CHECKED
#define MFS_HILITE          MF_HILITE
#define MFS_ENABLED         MF_ENABLED
#define MFS_UNCHECKED       MF_UNCHECKED
#define MFS_UNHILITE        MF_UNHILITE


#define SC_CLOSE        0xF060
#define SC_KEYMENU      0xF100

BOOL
WINAPI
CheckMenuRadioItem(HMENU, UINT, UINT, UINT, UINT);
// @CESYSGEN ENDIF

// @CESYSGEN IF GWES_LOADBMP
HBITMAP
WINAPI
LoadBitmapA(
    HINSTANCE hInstance,
    LPCSTR lpBitmapName);

HBITMAP
WINAPI
LoadBitmapW(
    HINSTANCE hInstance,
    LPCWSTR lpBitmapName);
#ifdef UNICODE
#define LoadBitmap  LoadBitmapW
#else
#define LoadBitmap  LoadBitmapA
#endif // !UNICODE
// @CESYSGEN ENDIF


// @CESYSGEN IF GWES_WMBASE
/*
 * GetSystemMetrics() codes
 */
#define SM_CXSCREEN             0
#define SM_CYSCREEN             1
#define SM_CXVSCROLL            2
#define SM_CYHSCROLL            3
#define SM_CYCAPTION            4
#define SM_CXBORDER             5
#define SM_CYBORDER             6
#define SM_CXDLGFRAME           7
#define SM_CYDLGFRAME           8
#define SM_CXICON               11
#define SM_CYICON               12
// @CESYSGEN IF GWES_ICONCURS
#define SM_CXCURSOR             13
#define SM_CYCURSOR             14
// @CESYSGEN ENDIF
#define SM_CYMENU               15
#define SM_CXFULLSCREEN 	16
#define SM_CYFULLSCREEN         17
#define SM_MOUSEPRESENT         19
#define SM_CYVSCROLL            20
#define SM_CXHSCROLL            21
#define SM_DEBUG                22
#define SM_CXDOUBLECLK          36
#define SM_CYDOUBLECLK          37
#define SM_CXICONSPACING        38
#define SM_CYICONSPACING        39
#define SM_CXEDGE               45
#define SM_CYEDGE               46
#define SM_CXSMICON             49
#define SM_CYSMICON             50

#define SM_XVIRTUALSCREEN       76
#define SM_YVIRTUALSCREEN       77
#define SM_CXVIRTUALSCREEN      78
#define SM_CYVIRTUALSCREEN      79
#define SM_CMONITORS            80
#define SM_SAMEDISPLAYFORMAT    81

#define SM_CXFIXEDFRAME         SM_CXDLGFRAME
#define SM_CYFIXEDFRAME         SM_CYDLGFRAME


// @CESYSGEN ENDIF


// @CESYSGEN IF GWES_MENU
HMENU
WINAPI
LoadMenuA(
    HINSTANCE hInstance,
    LPCSTR lpMenuName);

HMENU
WINAPI
LoadMenuW(
    HINSTANCE hInstance,
    LPCWSTR lpMenuName);
#ifdef UNICODE
#define LoadMenu  LoadMenuW
#else
#define LoadMenu  LoadMenuA
#endif // !UNICODE

BOOL
WINAPI
DrawMenuBar(
    HWND hWnd);

HMENU
WINAPI
CreateMenu(
    VOID);


HMENU
WINAPI
CreatePopupMenu(
    VOID);


BOOL
WINAPI
DestroyMenu(
    HMENU hMenu);


DWORD
WINAPI
CheckMenuItem(
    HMENU hMenu,
    UINT uIDCheckItem,
    UINT uCheck);


BOOL
WINAPI
EnableMenuItem(
    HMENU hMenu,
    UINT uIDEnableItem,
    UINT uEnable);

HMENU
WINAPI
GetSubMenu(
    HMENU hMenu,
    int nPos);

BOOL
WINAPI
InsertMenuA(
    HMENU hMenu,
    UINT uPosition,
    UINT uFlags,
    UINT uIDNewItem,
    LPCSTR lpNewItem
    );

BOOL
WINAPI
InsertMenuW(
    HMENU hMenu,
    UINT uPosition,
    UINT uFlags,
    UINT uIDNewItem,
    LPCWSTR lpNewItem
    );
#ifdef UNICODE
#define InsertMenu  InsertMenuW
#else
#define InsertMenu  InsertMenuA
#endif // !UNICODE


BOOL
WINAPI
AppendMenuA(
    HMENU hMenu,
    UINT uFlags,
    UINT uIDNewItem,
    LPCSTR lpNewItem
    );

BOOL
WINAPI
AppendMenuW(
    HMENU hMenu,
    UINT uFlags,
    UINT uIDNewItem,
    LPCWSTR lpNewItem
    );
#ifdef UNICODE
#define AppendMenu  AppendMenuW
#else
#define AppendMenu  AppendMenuA
#endif // !UNICODE

BOOL
WINAPI RemoveMenu(
    HMENU hMenu,
    UINT uPosition,
    UINT uFlags);


BOOL
WINAPI
DeleteMenu(
    HMENU hMenu,
    UINT uPosition,
    UINT uFlags);



BOOL
WINAPI
TrackPopupMenu(
    HMENU hMenu,
    UINT uFlags,
    int x,
    int y,
    int nReserved,
    HWND hWnd,
    CONST RECT *prcRect);

typedef struct tagTPMPARAMS
{
    UINT    cbSize;     /* Size of structure */
    RECT    rcExclude;  /* Screen coordinates of rectangle to exclude when positioning */
}   TPMPARAMS;
typedef TPMPARAMS FAR *LPTPMPARAMS;

BOOL
WINAPI
TrackPopupMenuEx(
    HMENU hmenu,
    UINT uFlags,
    int x,
    int y,
    HWND hwnd,
    LPTPMPARAMS lptpm);

#define TrackPopupMenu(hm,u,x,y,r,hw,p) \
        TrackPopupMenuEx((hm),(u),(x),(y),(hw),0)

// WINCE doesn't support a system menu, but in order
// to maintain application compatibility we provide this
// macro to allow disabling of the close box on the caption.
#define GetSystemMenu(hwnd, bRevert)    ((HMENU)(hwnd))

/* return codes for WM_MENUCHAR */
#define MNC_IGNORE  0
#define MNC_CLOSE   1
#define MNC_EXECUTE 2
#define MNC_SELECT  3


#define MIIM_STATE       0x00000001
#define MIIM_ID          0x00000002
#define MIIM_SUBMENU     0x00000004
#define MIIM_CHECKMARKS  0x00000008
#define MIIM_TYPE        0x00000010
#define MIIM_DATA        0x00000020

typedef struct tagMENUITEMINFOA
{
    UINT    cbSize;
    UINT    fMask;
    UINT    fType;          // used if MIIM_TYPE
    UINT    fState;         // used if MIIM_STATE
    UINT    wID;            // used if MIIM_ID
    HMENU   hSubMenu;       // used if MIIM_SUBMENU
    HBITMAP hbmpChecked;    // used if MIIM_CHECKMARKS
    HBITMAP hbmpUnchecked;  // used if MIIM_CHECKMARKS
    DWORD   dwItemData;     // used if MIIM_DATA
    LPSTR   dwTypeData;     // used if MIIM_TYPE
    UINT    cch;            // used if MIIM_TYPE
}   MENUITEMINFOA, FAR *LPMENUITEMINFOA;
typedef struct tagMENUITEMINFOW
{
    UINT    cbSize;
    UINT    fMask;
    UINT    fType;          // used if MIIM_TYPE
    UINT    fState;         // used if MIIM_STATE
    UINT    wID;            // used if MIIM_ID
    HMENU   hSubMenu;       // used if MIIM_SUBMENU
    HBITMAP hbmpChecked;    // used if MIIM_CHECKMARKS
    HBITMAP hbmpUnchecked;  // used if MIIM_CHECKMARKS
    DWORD   dwItemData;     // used if MIIM_DATA
    LPWSTR  dwTypeData;     // used if MIIM_TYPE
    UINT    cch;            // used if MIIM_TYPE
}   MENUITEMINFOW, FAR *LPMENUITEMINFOW;
#ifdef UNICODE
typedef MENUITEMINFOW MENUITEMINFO;
typedef LPMENUITEMINFOW LPMENUITEMINFO;
#else
typedef MENUITEMINFOA MENUITEMINFO;
typedef LPMENUITEMINFOA LPMENUITEMINFO;
#endif // UNICODE
typedef MENUITEMINFOA CONST FAR *LPCMENUITEMINFOA;
typedef MENUITEMINFOW CONST FAR *LPCMENUITEMINFOW;
#ifdef UNICODE
typedef LPCMENUITEMINFOW LPCMENUITEMINFO;
#else
typedef LPCMENUITEMINFOA LPCMENUITEMINFO;
#endif // UNICODE

  WINUSERAPI
  BOOL
  WINAPI
GetMenuItemInfoA(
    HMENU,
    UINT,
    BOOL,
    LPMENUITEMINFOA
    );

 WINUSERAPI
  BOOL
  WINAPI
GetMenuItemInfoW(
    HMENU,
    UINT,
    BOOL,
    LPMENUITEMINFOW
    );

#ifdef UNICODE
#define GetMenuItemInfo  GetMenuItemInfoW
#else
#define GetMenuItemInfo  GetMenuItemInfoA
#endif // !UNICODE



WINUSERAPI
BOOL
WINAPI
SetMenuItemInfoA(
    HMENU,
    UINT,
    BOOL,
    LPCMENUITEMINFOA
    );
WINUSERAPI
BOOL
WINAPI
SetMenuItemInfoW(
    HMENU,
    UINT,
    BOOL,
    LPCMENUITEMINFOW
    );
#ifdef UNICODE
#define SetMenuItemInfo  SetMenuItemInfoW
#else
#define SetMenuItemInfo  SetMenuItemInfoA
#endif // !UNICODE



/*
 * Flags for TrackPopupMenu
 */
#define TPM_LEFTALIGN   0x0000L
#define TPM_CENTERALIGN 0x0004L
#define TPM_RIGHTALIGN  0x0008L

#define TPM_TOPALIGN        0x0000L
#define TPM_VCENTERALIGN    0x0010L
#define TPM_BOTTOMALIGN     0x0020L

#define TPM_HORIZONTAL      0x0000L     /* Horz alignment matters more */
#define TPM_VERTICAL        0x0040L     /* Vert alignment matters more */
#define TPM_NONOTIFY        0x0080L     /* Don't send any notification msgs */
#define TPM_RETURNCMD       0x0100L
// @CESYSGEN ENDIF


// @CESYSGEN IF COREDLL_ACCEL_C
/*
 * Defines for the fVirt field of the Accelerator table structure.
 */
#define FVIRTKEY  TRUE          /* Assumed to be == TRUE */
#define FNOINVERT 0x02
#define FSHIFT    0x04
#define FCONTROL  0x08
#define FALT      0x10

/*	The resource entries in the module each have an extra word of padding
between accelerator entries.  Win95 and WinNT both change the
resource loading process to make the resulting memory image have 24-bits
but we just add the extra padding to the structure.  */
typedef struct tagACCEL {
    BYTE   fVirt;               /* Also called the flags field */
    WORD   key;
    WORD   cmd;
	WORD   pad;					/* Different from Win95 and WinNT */
} ACCEL, *LPACCEL;


HACCEL
WINAPI
LoadAcceleratorsA(
    HINSTANCE hInstance,
    LPCSTR lpTableName);

HACCEL
WINAPI
LoadAcceleratorsW(
    HINSTANCE hInstance,
    LPCWSTR lpTableName);
#ifdef UNICODE
#define LoadAccelerators  LoadAcceleratorsW
#else
#define LoadAccelerators  LoadAcceleratorsA
#endif // !UNICODE


HACCEL
WINAPI
CreateAcceleratorTableA(
    LPACCEL, int);

HACCEL
WINAPI
CreateAcceleratorTableW(
    LPACCEL, int);
#ifdef UNICODE
#define CreateAcceleratorTable  CreateAcceleratorTableW
#else
#define CreateAcceleratorTable  CreateAcceleratorTableA
#endif // !UNICODE

BOOL
WINAPI
DestroyAcceleratorTable(
    HACCEL hAccel);

// @CESYSGEN ENDIF

// @CESYSGEN IF GWES_WINMGR
BOOL
WINAPI
SetSysColors(
    int cElements,
    CONST INT * lpaElements,
    CONST COLORREF * lpaRgbValues);

// @CESYSGEN ENDIF

// @CESYSGEN IF COREDLL_RECTAPI
BOOL
WINAPI
SetRect(
    LPRECT lprc,
    int xLeft,
    int yTop,
    int xRight,
    int yBottom);

BOOL
WINAPI
SetRectEmpty(
    LPRECT lprc);

BOOL
WINAPI
CopyRect(
    LPRECT lprcDst,
    CONST RECT *lprcSrc);

BOOL
WINAPI
InflateRect(
    LPRECT lprc,
    int dx,
    int dy);

BOOL
WINAPI
IntersectRect(
    LPRECT lprcDst,
    CONST RECT *lprcSrc1,
    CONST RECT *lprcSrc2);

BOOL
WINAPI
UnionRect(
    LPRECT lprcDst,
    CONST RECT *lprcSrc1,
    CONST RECT *lprcSrc2);

BOOL
WINAPI
OffsetRect(
    LPRECT lprc,
    int dx,
    int dy);

BOOL
WINAPI
IsRectEmpty(
    CONST RECT *lprc);

BOOL
WINAPI
EqualRect(
    CONST RECT *lprc1,
    CONST RECT *lprc2);

BOOL
WINAPI
PtInRect(
    CONST RECT *lprc,
    POINT pt);

BOOL
WINAPI
SubtractRect(
    LPRECT prcDst,
    CONST RECT *prcSrc1,
    CONST RECT *prcSrc2);

// @CESYSGEN ENDIF

// @CESYSGEN IF GWES_WINMGR
int
WINAPI
MapWindowPoints(
    HWND hWndFrom,
    HWND hWndTo,
    LPPOINT lpPoints,
    UINT cPoints);

HWND
WINAPI
WindowFromPoint(
    POINT Point);

HWND
WINAPI
ChildWindowFromPoint(
    HWND hWndParent,
    POINT Point);

BOOL
WINAPI
ClientToScreen(
    HWND hWnd,
    LPPOINT lpPoint);

BOOL
WINAPI
ScreenToClient(
    HWND hWnd,
    LPPOINT lpPoint);


typedef struct _PAINTSTRUCT {
    HDC     hdc;                /* display DC to be used for painting */
    BOOL    fErase;             /* Indicates whether background needs erased */
    RECT    rcPaint;            /* Rectangle where painting required */
    BOOL    fRestore;           /* RESERVED */
    BOOL    fIncUpdate;         /* RESERVED */
    BYTE    rgbReserved[32];    /* RESERVED */
} PAINTSTRUCT;

typedef PAINTSTRUCT *LPPAINTSTRUCT;
typedef PAINTSTRUCT *PPAINTSTRUCT;
typedef const PAINTSTRUCT *LPCPAINTSTRUCT;
typedef const PAINTSTRUCT *PCPAINTSTRUCT;



BOOL
WINAPI
SetWindowTextA(
    HWND hWnd,
    LPCSTR lpString);

BOOL
WINAPI
SetWindowTextW(
    HWND hWnd,
    LPCWSTR lpString);
#ifdef UNICODE
#define SetWindowText  SetWindowTextW
#else
#define SetWindowText  SetWindowTextA
#endif // !UNICODE


int
WINAPI
GetWindowTextA(
    HWND hWnd,
    LPSTR lpString,
    int nMaxCount);

int
WINAPI
GetWindowTextW(
    HWND hWnd,
    LPWSTR lpString,
    int nMaxCount);
#ifdef UNICODE
#define GetWindowText  GetWindowTextW
#else
#define GetWindowText  GetWindowTextA
#endif // !UNICODE



HDC
WINAPI
BeginPaint (
    HWND hwnd,
    LPPAINTSTRUCT pps
    );

BOOL
WINAPI
EndPaint (
    HWND hwnd,
    LPPAINTSTRUCT pps
    );

BOOL
WINAPI
GetUpdateRect(
    HWND hWnd,
    LPRECT lpRect,
    BOOL bErase);

int
WINAPI
GetUpdateRgn(
    HWND hWnd,
    HRGN hRgn,
    BOOL bErase);

WINUSERAPI
HDC
WINAPI
GetDCEx(
    HWND hWnd ,
    HRGN hrgnClip,
    DWORD flags);

/*
 * GetDCEx() flags
 */
#define DCX_WINDOW           0x00000001L
#define DCX_CACHE            0x00000002L
#define DCX_CLIPCHILDREN     0x00000008L
#define DCX_CLIPSIBLINGS     0x00000010L

#define DCX_EXCLUDERGN       0x00000040L
#define DCX_INTERSECTRGN     0x00000080L

#define DCX_EXCLUDEUPDATE    0x00000100L
#define DCX_INTERSECTUPDATE  0x00000200L


HWND
WINAPI
GetDesktopWindow(
	void
	);


// @CESYSGEN ENDIF


// @CESYSGEN IF GWES_WMBASE

#define WM_NULL                         0x0000
#define WM_CREATE                       0x0001
#define WM_DESTROY                      0x0002

#define WM_CLOSE                        0x0010
#define WM_QUIT                         0x0012


#define WM_COPYDATA                     0x004A
/*
 * lParam of WM_COPYDATA message points to...
 */
typedef struct tagCOPYDATASTRUCT {
    DWORD dwData;
    DWORD cbData;
    PVOID lpData;
} COPYDATASTRUCT, *PCOPYDATASTRUCT;


BOOL
WINAPI
IsWindow(
    HWND hWnd);

BOOL
WINAPI
IsWindowVisible(
    HWND hWnd);


#define WS_CHILD            0x40000000L
#define WS_VISIBLE          0x10000000L
#define WS_DISABLED         0x08000000L


#define WS_GROUP            0x00020000L
#define WS_TABSTOP          0x00010000L

#define WS_EX_NOACTIVATE    0x08000000L


#define CW_USEDEFAULT       ((int)0x80000000)

/*
 * Special value for CreateWindow, et al.
 */
#define HWND_DESKTOP        ((HWND)0)

HWND
WINAPI
CreateWindowExA(
    DWORD dwExStyle,
    LPCSTR lpClassName,
    LPCSTR lpWindowName,
    DWORD dwStyle,
    int X,
    int Y,
    int nWidth,
    int nHeight,
    HWND hWndParent ,
    HMENU hMenu,
    HINSTANCE hInstance,
    LPVOID lpParam);

HWND
WINAPI
CreateWindowExW(
    DWORD dwExStyle,
    LPCWSTR lpClassName,
    LPCWSTR lpWindowName,
    DWORD dwStyle,
    int X,
    int Y,
    int nWidth,
    int nHeight,
    HWND hWndParent ,
    HMENU hMenu,
    HINSTANCE hInstance,
    LPVOID lpParam);

#ifdef UNICODE
#define CreateWindowEx  CreateWindowExW
#else
#define CreateWindowEx  CreateWindowExA
#endif // !UNICODE

#define CreateWindowA(lpClassName, lpWindowName, dwStyle, x, y,\
nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam)\
CreateWindowExA(0L, lpClassName, lpWindowName, dwStyle, x, y,\
nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam)

#define CreateWindowW(lpClassName, lpWindowName, dwStyle, x, y,\
nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam)\
CreateWindowExW(0L, lpClassName, lpWindowName, dwStyle, x, y,\
nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam)

#ifdef UNICODE
#define CreateWindow  CreateWindowW
#else
#define CreateWindow  CreateWindowA
#endif // !UNICODE



BOOL
WINAPI
DestroyWindow (
    HWND hwnd
    );


#ifdef STRICT

WINUSERAPI
LRESULT
WINAPI
CallWindowProcA(
    WNDPROC lpPrevWndFunc,
    HWND hWnd,
    UINT Msg,
    WPARAM wParam,
    LPARAM lParam);
WINUSERAPI
LRESULT
WINAPI
CallWindowProcW(
    WNDPROC lpPrevWndFunc,
    HWND hWnd,
    UINT Msg,
    WPARAM wParam,
    LPARAM lParam);
#ifdef UNICODE
#define CallWindowProc  CallWindowProcW
#else
#define CallWindowProc  CallWindowProcA
#endif // !UNICODE

#else /* !STRICT */

WINUSERAPI
LRESULT
WINAPI
CallWindowProcA(
    FARPROC lpPrevWndFunc,
    HWND hWnd,
    UINT Msg,
    WPARAM wParam,
    LPARAM lParam);
WINUSERAPI
LRESULT
WINAPI
CallWindowProcW(
    FARPROC lpPrevWndFunc,
    HWND hWnd,
    UINT Msg,
    WPARAM wParam,
    LPARAM lParam);
#ifdef UNICODE
#define CallWindowProc  CallWindowProcW
#else
#define CallWindowProc  CallWindowProcA
#endif // !UNICODE

#endif /* !STRICT */


DWORD
WINAPI
GetWindowThreadProcessId(
    HWND hWnd,
    LPDWORD lpdwProcessId);

WINUSERAPI
UINT
WINAPI
GetDoubleClickTime (VOID);


int
WINAPI
GetSystemMetrics(
    int nIndex);

#ifndef UNICODE_ONLY
WINUSERAPI
DWORD
WINAPI
GetClassLongA(
    HWND hWnd,
    int nIndex);
#endif //!UNICODE_ONLY
#ifndef ANSI_ONLY
WINUSERAPI
DWORD
WINAPI
GetClassLongW(
    HWND hWnd,
    int nIndex);
#endif //!ANSI_ONLY
#ifdef UNICODE
#define GetClassLong  GetClassLongW
#else
#define GetClassLong  GetClassLongA
#endif // !UNICODE

#ifndef UNICODE_ONLY
WINUSERAPI
DWORD
WINAPI
SetClassLongA(
    HWND hWnd,
    int nIndex,
    LONG dwNewLong);
#endif //!UNICODE_ONLY
#ifndef ANSI_ONLY
WINUSERAPI
DWORD
WINAPI
SetClassLongW(
    HWND hWnd,
    int nIndex,
    LONG dwNewLong);
#endif //!ANSI_ONLY
#ifdef UNICODE
#define SetClassLong  SetClassLongW
#else
#define SetClassLong  SetClassLongA
#endif // !UNICODE

#define GCL_HCURSOR     (-12)
#define GCL_HICON       (-14)
#define GCL_STYLE       (-26)



// @CESYSGEN IF COREDLL_WMGR_C
/* RegisterClass */

ATOM
WINAPI
RegisterClassA(
    CONST WNDCLASSA *lpWndClass
    );

ATOM
WINAPI
RegisterClassW (
    CONST WNDCLASSW *lpWndClass
    );

#ifdef UNICODE
#define RegisterClass  RegisterClassW
#else
#define RegisterClass  RegisterClassA
#endif // !UNICODE
// @CESYSGEN ENDIF


#ifndef UNICODE_ONLY
WINUSERAPI
BOOL
WINAPI
UnregisterClassA(
    LPCSTR lpClassName,
    HINSTANCE hInstance);
#endif //!UNICODE_ONLY
#ifndef ANSI_ONLY
WINUSERAPI
BOOL
WINAPI
UnregisterClassW(
    LPCWSTR lpClassName,
    HINSTANCE hInstance);
#endif //!ANSI_ONLY
#ifdef UNICODE
#define UnregisterClass  UnregisterClassW
#else
#define UnregisterClass  UnregisterClassA
#endif // !UNICODE


BOOL
WINAPI
GetClassInfoA(
    HINSTANCE hInstance,
    LPCSTR lpClassName,
    LPWNDCLASSA lpWndClass);

BOOL
WINAPI
GetClassInfoW(
    HINSTANCE hInstance,
    LPCWSTR lpClassName,
    LPWNDCLASSW lpWndClass);
#ifdef UNICODE
#define GetClassInfo  GetClassInfoW
#else
#define GetClassInfo  GetClassInfoA
#endif // !UNICODE


#define WM_ENABLE                       0x000A

BOOL
WINAPI
EnableWindow(
    HWND hWnd,
    BOOL bEnable);

BOOL
WINAPI
IsWindowEnabled(
    HWND hWnd);

/*
 * Color Types
 */
#ifdef UNDER_NT
#define SYS_COLOR_INDEX_FLAG        0
#else
#define SYS_COLOR_INDEX_FLAG        0x40000000
#endif // UNDER_NT
#define COLOR_SCROLLBAR           ( 0 | SYS_COLOR_INDEX_FLAG)
#define COLOR_BACKGROUND          ( 1 | SYS_COLOR_INDEX_FLAG)
#define COLOR_ACTIVECAPTION       ( 2 | SYS_COLOR_INDEX_FLAG)
#define COLOR_INACTIVECAPTION     ( 3 | SYS_COLOR_INDEX_FLAG)
#define COLOR_MENU                ( 4 | SYS_COLOR_INDEX_FLAG)
#define COLOR_WINDOW              ( 5 | SYS_COLOR_INDEX_FLAG)
#define COLOR_WINDOWFRAME         ( 6 | SYS_COLOR_INDEX_FLAG)
#define COLOR_MENUTEXT            ( 7 | SYS_COLOR_INDEX_FLAG)
#define COLOR_WINDOWTEXT          ( 8 | SYS_COLOR_INDEX_FLAG)
#define COLOR_CAPTIONTEXT         ( 9 | SYS_COLOR_INDEX_FLAG)
#define COLOR_ACTIVEBORDER        (10 | SYS_COLOR_INDEX_FLAG)
#define COLOR_INACTIVEBORDER      (11 | SYS_COLOR_INDEX_FLAG)
#define COLOR_APPWORKSPACE        (12 | SYS_COLOR_INDEX_FLAG)
#define COLOR_HIGHLIGHT           (13 | SYS_COLOR_INDEX_FLAG)
#define COLOR_HIGHLIGHTTEXT       (14 | SYS_COLOR_INDEX_FLAG)
#define COLOR_BTNFACE             (15 | SYS_COLOR_INDEX_FLAG)
#define COLOR_BTNSHADOW           (16 | SYS_COLOR_INDEX_FLAG)
#define COLOR_GRAYTEXT            (17 | SYS_COLOR_INDEX_FLAG)
#define COLOR_BTNTEXT             (18 | SYS_COLOR_INDEX_FLAG)
#define COLOR_INACTIVECAPTIONTEXT (19 | SYS_COLOR_INDEX_FLAG)
#define COLOR_BTNHIGHLIGHT        (20 | SYS_COLOR_INDEX_FLAG)

#define COLOR_3DDKSHADOW          (21 | SYS_COLOR_INDEX_FLAG)
#define COLOR_3DLIGHT             (22 | SYS_COLOR_INDEX_FLAG)
#define COLOR_INFOTEXT            (23 | SYS_COLOR_INDEX_FLAG)
#define COLOR_INFOBK              (24 | SYS_COLOR_INDEX_FLAG)
#define COLOR_STATIC              (25 | SYS_COLOR_INDEX_FLAG)
#define COLOR_STATICTEXT          (26 | SYS_COLOR_INDEX_FLAG)
#define C_SYS_COLOR_TYPES		27

#define COLOR_DESKTOP           COLOR_BACKGROUND
#define COLOR_3DFACE            COLOR_BTNFACE
#define COLOR_3DSHADOW          COLOR_BTNSHADOW
#define COLOR_3DHIGHLIGHT       COLOR_BTNHIGHLIGHT
#define COLOR_3DHILIGHT         COLOR_BTNHIGHLIGHT

DWORD
WINAPI
GetSysColor(
    int nIndex);

HDC
WINAPI
GetDC (
    HWND hwnd
    );


HDC
WINAPI
GetWindowDC (
    HWND hwnd
    );

int
WINAPI
ReleaseDC (
    HWND hwnd,
    HDC hdc
    );

// @CESYSGEN ENDIF


// @CESYSGEN IF GWES_UIBASE


BOOL
WINAPI
GetMouseMovePoints(
	PPOINT	pptBuf,
	UINT	nBufPoints,
	UINT	*pnPointsRetrieved
	);


#define MOUSEEVENTF_MOVE        0x0001 /* mouse move */
#define MOUSEEVENTF_LEFTDOWN    0x0002 /* left button down */
#define MOUSEEVENTF_LEFTUP      0x0004 /* left button up */
#define MOUSEEVENTF_RIGHTDOWN   0x0008 /* right button down */
#define MOUSEEVENTF_RIGHTUP     0x0010 /* right button up */
#define MOUSEEVENTF_MIDDLEDOWN  0x0020 /* middle button down */
#define MOUSEEVENTF_MIDDLEUP    0x0040 /* middle button up */
#define MOUSEEVENTF_WHEEL       0x0800 /* wheel button rolled */
#define MOUSEEVENTF_VIRTUALDESK 0x4000 /* map to entrire virtual desktop */
#define MOUSEEVENTF_ABSOLUTE    0x8000 /* absolute move */

VOID
WINAPI
mouse_event(
	DWORD dwFlags,
	DWORD dx,
	DWORD dy,
	DWORD cButtons,
	DWORD dwExtraInfo);



typedef struct tagMOUSEINPUT {
    LONG    dx;
    LONG    dy;
    DWORD   mouseData;
    DWORD   dwFlags;
    DWORD   time;
    DWORD   dwExtraInfo;
} MOUSEINPUT, *PMOUSEINPUT, FAR* LPMOUSEINPUT;

typedef struct tagKEYBDINPUT {
    WORD    wVk;
    WORD    wScan;
    DWORD   dwFlags;
    DWORD   time;
    DWORD   dwExtraInfo;
} KEYBDINPUT, *PKEYBDINPUT, FAR* LPKEYBDINPUT;

typedef struct tagHARDWAREINPUT {
    DWORD   uMsg;
    WORD    wParamL;
    WORD    wParamH;
    DWORD   dwExtraInfo;
} HARDWAREINPUT, *PHARDWAREINPUT, FAR* LPHARDWAREINPUT;

#define INPUT_MOUSE     0
#define INPUT_KEYBOARD  1
#define INPUT_HARDWARE  2

typedef struct tagINPUT {
    DWORD   type;
    union
    {
        MOUSEINPUT      mi;
        KEYBDINPUT      ki;
		HARDWAREINPUT	hi;
    };
} INPUT, *PINPUT, FAR* LPINPUT;


WINUSERAPI
UINT
WINAPI
SendInput(
	UINT	nInputs,
	LPINPUT	pInputs,
	int		cbSize
	);


// @CESYSGEN ENDIF



// @CESYSGEN IF GWES_ACCEL
int
WINAPI
TranslateAcceleratorA(
    HWND hWnd,
    HACCEL hAccTable,
    LPMSG lpMsg);

int
WINAPI
TranslateAcceleratorW(
    HWND hWnd,
    HACCEL hAccTable,
    LPMSG lpMsg);
#ifdef UNICODE
#define TranslateAccelerator  TranslateAcceleratorW
#else
#define TranslateAccelerator  TranslateAcceleratorA
#endif
// @CESYSGEN ENDIF



// @CESYSGEN IF GWES_IDLE


void
WINAPI
SystemIdleTimerReset(
	void
	);
// @CESYSGEN ENDIF


// @CESYSGEN IF GWES_DEFWNDPROC

LRESULT
WINAPI
DefWindowProcA(
    HWND hWnd,
    UINT Msg,
    WPARAM wParam,
    LPARAM lParam);

LRESULT
WINAPI
DefWindowProcW(
    HWND hWnd,
    UINT Msg,
    WPARAM wParam,
    LPARAM lParam);
#ifdef UNICODE
#define DefWindowProc  DefWindowProcW
#else
#define DefWindowProc  DefWindowProcA
#endif // !UNICODE

// @CESYSGEN ENDIF




// @CESYSGEN IF GWES_GSETWINLONG

/*
 *  Window field offsets for GetWindowLong()
 */
#define GWL_WNDPROC         (-4)
#define GWL_STYLE           (-16)
#define GWL_EXSTYLE         (-20)
#define GWL_USERDATA        (-21)
#define GWL_ID              (-12)


LONG
WINAPI
GetWindowLongA(
    HWND hWnd,
    int nIndex);

LONG
WINAPI
GetWindowLongW(
    HWND hWnd,
    int nIndex);
#ifdef UNICODE
#define GetWindowLong  GetWindowLongW
#else
#define GetWindowLong  GetWindowLongA
#endif // !UNICODE


LONG
WINAPI
SetWindowLongA(
    HWND hWnd,
    int nIndex,
    LONG dwNewLong);

LONG
WINAPI
SetWindowLongW(
    HWND hWnd,
    int nIndex,
    LONG dwNewLong);
#ifdef UNICODE
#define SetWindowLong  SetWindowLongW
#else
#define SetWindowLong  SetWindowLongA
#endif // !UNICODE

// @CESYSGEN ENDIF



// @CESYSGEN IF GWES_WINMGR
/* Flags for ShowWindow */
#define SW_HIDE             0
#define SW_SHOWNORMAL       1
#define SW_SHOWNOACTIVATE   4
#define SW_SHOW             5
#define SW_MINIMIZE         6
#define SW_SHOWNA           8
#define SW_SHOWMAXIMIZED	11
#define SW_MAXIMIZE			12
#define SW_RESTORE			13


/*
 * RedrawWindow() flags
 */
#define RDW_INVALIDATE          0x0001
#define RDW_INTERNALPAINT       0x0002
#define RDW_ERASE               0x0004

#define RDW_VALIDATE            0x0008
//#define RDW_NOINTERNALPAINT     0x0010   //don't support 
#define RDW_NOERASE             0x0020

#define RDW_NOCHILDREN          0x0040
#define RDW_ALLCHILDREN         0x0080

#define RDW_UPDATENOW           0x0100
#define RDW_ERASENOW            0x0200

//#define RDW_FRAME               0x0400
//#define RDW_NOFRAME             0x0800

#ifdef UNDER_NT
#define SW_MAX              10
#endif

BOOL
WINAPI
IsChild(
    HWND hWndParent,
    HWND hWnd);


BOOL
WINAPI
ShowWindow (
    HWND hwnd,
    INT nCmdShow
    );

BOOL
WINAPI
UpdateWindow (
    HWND hwnd
    );

BOOL 
WINAPI
RedrawWindow(
   HWND hwnd,
   CONST RECT* lprcUpdate,
   HRGN hrgnUpdate,
   UINT  flags
);

HWND
WINAPI
SetParent (
    HWND hwnd,
    HWND hwndParent
    );

HWND
WINAPI
GetParent (
    HWND hwnd
    );

WINUSERAPI
HWND
WINAPI
FindWindowA(
    LPCSTR lpClassName ,
    LPCSTR lpWindowName);
WINUSERAPI
HWND
WINAPI
FindWindowW(
    LPCWSTR lpClassName ,
    LPCWSTR lpWindowName);
#ifdef UNICODE
#define FindWindow  FindWindowW
#else
#define FindWindow  FindWindowA
#endif // !UNICODE


typedef BOOL (CALLBACK* WNDENUMPROC)(HWND, LPARAM);

BOOL
WINAPI
EnumWindows(
    WNDENUMPROC lpEnumFunc,
    LPARAM lParam);



int
WINAPI
GetClassNameA(
    HWND hWnd,
    LPSTR lpClassName,
    int nMaxCount);

int
WINAPI
GetClassNameW(
    HWND hWnd,
    LPWSTR lpClassName,
    int nMaxCount);
#ifdef UNICODE
#define GetClassName  GetClassNameW
#else
#define GetClassName  GetClassNameA
#endif // !UNICODE

// @CESYSGEN ENDIF
/*
 * MessageBox() Flags
 */
#define MB_OK                       0x00000000L
#define MB_OKCANCEL                 0x00000001L
#define MB_ABORTRETRYIGNORE         0x00000002L
#define MB_YESNOCANCEL              0x00000003L
#define MB_YESNO                    0x00000004L
#define MB_RETRYCANCEL              0x00000005L

#define MB_ICONHAND                 0x00000010L
#define MB_ICONQUESTION             0x00000020L
#define MB_ICONEXCLAMATION          0x00000030L
#define MB_ICONASTERISK             0x00000040L

#if(WINVER >= 0x0400)
#define MB_ICONWARNING              MB_ICONEXCLAMATION
#define MB_ICONERROR                MB_ICONHAND
#endif /* WINVER >= 0x0400 */

#define MB_ICONINFORMATION          MB_ICONASTERISK
#define MB_ICONSTOP                 MB_ICONHAND

#define MB_DEFBUTTON1               0x00000000L
#define MB_DEFBUTTON2               0x00000100L
#define MB_DEFBUTTON3               0x00000200L
#if(WINVER >= 0x0400)
#define MB_DEFBUTTON4               0x00000300L
#endif /* WINVER >= 0x0400 */

#define MB_APPLMODAL                0x00000000L
#define MB_SETFOREGROUND            0x00010000L

#define MB_TOPMOST                  0x00040000L

int
WINAPI
MessageBoxA(
    HWND hWnd ,
    LPCSTR lpText,
    LPCSTR lpCaption,
    UINT uType);

int
WINAPI
MessageBoxW(
    HWND hWnd ,
    LPCWSTR lpText,
    LPCWSTR lpCaption,
    UINT uType);
#ifdef UNICODE
#define MessageBox  MessageBoxW
#else
#define MessageBox  MessageBoxA
#endif // !UNICODE

// @CESYSGEN IF GWES_MSGBEEP
BOOL
WINAPI
MessageBeep(
    UINT uType);
// @CESYSGEN ENDIF


// @CESYSGEN IF GWES_CARET
BOOL
WINAPI
CreateCaret(
    HWND hWnd,
    HBITMAP hBitmap,
    int nWidth,
    int nHeight);

BOOL
WINAPI
DestroyCaret(
    VOID);

BOOL
WINAPI
HideCaret(
    HWND hWnd);

BOOL
WINAPI
ShowCaret(
    HWND hWnd);

BOOL
WINAPI
SetCaretPos(
    int X,
    int Y);

BOOL
WINAPI
GetCaretPos(
    LPPOINT lpPoint);


BOOL
WINAPI
SetCaretBlinkTime(
	UINT uMSeconds
	);

UINT
WINAPI
GetCaretBlinkTime(
	VOID
	);
// @CESYSGEN ENDIF


// @CESYSGEN IF GWES_FOREGND
HWND
WINAPI
SetActiveWindow(
	HWND	hWnd);

HWND
WINAPI
GetForegroundWindow(
	VOID);

BOOL
WINAPI
SetForegroundWindow(
	HWND hWnd);


HWND
WINAPI
SetFocus(
    HWND hWnd
    );

HWND
WINAPI
GetActiveWindow(
    VOID
    );

HWND
WINAPI
GetFocus(
    VOID
    );


// @CESYSGEN ENDIF

// @CESYSGEN IF COREDLL_COREIMM
WINUSERAPI
HKL
WINAPI
GetKeyboardLayout(
    DWORD dwThreadId
);
// @CESYSGEN ENDIF




// @CESYSGEN IF GWES_KBDUI
SHORT
WINAPI
GetAsyncKeyState(
    int vKey);

SHORT
WINAPI
GetKeyState(
    int nVirtKey);

WINUSERAPI
VOID
WINAPI
keybd_event(
    BYTE bVk,
    BYTE bScan,
    DWORD dwFlags,
    DWORD dwExtraInfo);


WINUSERAPI
BOOL
WINAPI
PostKeybdMessage(
	HWND	hwnd,
	UINT	VKey,
	UINT	KeyStateFlags,
	UINT	cCharacters,
	UINT	*pShiftStateBuffer,
	UINT *pCharacterBuffer
	);


#define KL_NAMELENGTH       9

WINUSERAPI
BOOL
WINAPI
GetKeyboardLayoutNameA(
    LPSTR pwszKLID);
WINUSERAPI
BOOL
WINAPI
GetKeyboardLayoutNameW(
    LPWSTR pwszKLID);
#ifdef UNICODE
#define GetKeyboardLayoutName  GetKeyboardLayoutNameW
#else
#define GetKeyboardLayoutName  GetKeyboardLayoutNameA
#endif // !UNICODE


WINUSERAPI
UINT
WINAPI
MapVirtualKeyA(
    UINT uCode,
    UINT uMapType);

WINUSERAPI
UINT
WINAPI
MapVirtualKeyW(
    UINT uCode,
    UINT uMapType);
#ifdef UNICODE
#define MapVirtualKey  MapVirtualKeyW
#else
#define MapVirtualKey  MapVirtualKeyA
#endif // !UNICODE

#define KEYEVENTF_EXTENDEDKEY 0x0001
#define KEYEVENTF_KEYUP       0x0002
#define KEYEVENTF_SILENT      0x0004

/*
 * WM_KEYUP/DOWN/CHAR HIWORD(lParam) flags
 */
#define KF_EXTENDED         0x0100
#define KF_ALTDOWN          0x2000
#define KF_REPEAT           0x4000
#define KF_UP               0x8000

/*
 * Virtual Keys, Standard Set
 */
#define VK_LBUTTON        0x01
#define VK_RBUTTON        0x02
#define VK_CANCEL         0x03
#define VK_MBUTTON        0x04    /* NOT contiguous with L & RBUTTON */

#define VK_BACK           0x08
#define VK_TAB            0x09

#define VK_CLEAR          0x0C
#define VK_RETURN         0x0D

#define VK_SHIFT          0x10
#define VK_CONTROL        0x11
#define VK_MENU           0x12
#define VK_PAUSE          0x13
#define VK_CAPITAL        0x14

#define	VK_KANA           0x15
#define VK_HANGEUL        0x15  /* old name - should be here for compatibility */
#define VK_HANGUL         0x15
#define VK_JUNJA          0x17
#define VK_FINAL          0x18
#define VK_HANJA          0x19
#define	VK_KANJI	      0x19

#define VK_ESCAPE         0x1B

#define	VK_CONVERT	     0x1c
#define	VK_NOCONVERT	  0x1d

#define VK_SPACE          0x20
#define VK_PRIOR          0x21
#define VK_NEXT           0x22
#define VK_END            0x23
#define VK_HOME           0x24
#define VK_LEFT           0x25
#define VK_UP             0x26
#define VK_RIGHT          0x27
#define VK_DOWN           0x28
#define VK_SELECT         0x29
#define VK_PRINT          0x2A
#define VK_EXECUTE        0x2B
#define VK_SNAPSHOT       0x2C
#define VK_INSERT         0x2D
#define VK_DELETE         0x2E
#define VK_HELP           0x2F

/* VK_0 thru VK_9 are the same as ASCII '0' thru '9' (0x30 - 0x39) */
/* VK_A thru VK_Z are the same as ASCII 'A' thru 'Z' (0x41 - 0x5A) */

#define VK_LWIN           0x5B
#define VK_RWIN           0x5C
#define VK_APPS           0x5D

#define VK_SLEEP          0x5F

#define VK_NUMPAD0        0x60
#define VK_NUMPAD1        0x61
#define VK_NUMPAD2        0x62
#define VK_NUMPAD3        0x63
#define VK_NUMPAD4        0x64
#define VK_NUMPAD5        0x65
#define VK_NUMPAD6        0x66
#define VK_NUMPAD7        0x67
#define VK_NUMPAD8        0x68
#define VK_NUMPAD9        0x69
#define VK_MULTIPLY       0x6A
#define VK_ADD            0x6B
#define VK_SEPARATOR      0x6C
#define VK_SUBTRACT       0x6D
#define VK_DECIMAL        0x6E
#define VK_DIVIDE         0x6F
#define VK_F1             0x70
#define VK_F2             0x71
#define VK_F3             0x72
#define VK_F4             0x73
#define VK_F5             0x74
#define VK_F6             0x75
#define VK_F7             0x76
#define VK_F8             0x77
#define VK_F9             0x78
#define VK_F10            0x79
#define VK_F11            0x7A
#define VK_F12            0x7B
#define VK_F13            0x7C
#define VK_F14            0x7D
#define VK_F15            0x7E
#define VK_F16            0x7F
#define VK_F17            0x80
#define VK_F18            0x81
#define VK_F19            0x82
#define VK_F20            0x83
#define VK_F21            0x84
#define VK_F22            0x85
#define VK_F23            0x86
#define VK_F24            0x87

#define VK_NUMLOCK        0x90
#define VK_SCROLL         0x91

/*
 * VK_L* & VK_R* - left and right Alt, Ctrl and Shift virtual keys.
 * Used only as parameters to GetAsyncKeyState() and GetKeyState().
 * No other API or message will distinguish left and right keys in this way.
 */
#define VK_LSHIFT         0xA0
#define VK_RSHIFT         0xA1
#define VK_LCONTROL       0xA2
#define VK_RCONTROL       0xA3
#define VK_LMENU          0xA4
#define VK_RMENU          0xA5

#define	VK_EXTEND_BSLASH  0xE2
#define	VK_OEM_102        0xE2

#define VK_PROCESSKEY     0xE5

#define VK_ATTN           0xF6
#define VK_CRSEL          0xF7
#define VK_EXSEL          0xF8
#define VK_EREOF          0xF9
#define VK_PLAY           0xFA
#define VK_ZOOM           0xFB
#define VK_NONAME         0xFC
#define VK_PA1            0xFD
#define VK_OEM_CLEAR      0xFE


#define VK_SEMICOLON		0xBA
#define VK_EQUAL			0xBB
#define VK_COMMA			0xBC
#define VK_HYPHEN			0xBD
#define VK_PERIOD			0xBE
#define VK_SLASH			0xBF
#define VK_BACKQUOTE		0xC0

#define VK_BROWSER_BACK                  0xA6
#define VK_BROWSER_FORWARD               0xA7
#define VK_BROWSER_REFRESH               0xA8
#define VK_BROWSER_STOP                  0xA9
#define VK_BROWSER_SEARCH                0xAA
#define VK_BROWSER_FAVORITES             0xAB
#define VK_BROWSER_HOME                  0xAC
#define VK_VOLUME_MUTE                   0xAD
#define VK_VOLUME_DOWN                   0xAE
#define VK_VOLUME_UP                     0xAF
#define VK_MEDIA_NEXT_TRACK              0xB0
#define VK_MEDIA_PREV_TRACK              0xB1
#define VK_MEDIA_STOP                    0xB2
#define VK_MEDIA_PLAY_PAUSE              0xB3
#define VK_LAUNCH_MAIL                   0xB4
#define VK_LAUNCH_MEDIA_SELECT           0xB5
#define VK_LAUNCH_APP1                   0xB6
#define VK_LAUNCH_APP2                   0xB7

#define VK_LBRACKET			0xDB
#define VK_BACKSLASH		0xDC
#define VK_RBRACKET			0xDD
#define VK_APOSTROPHE		0xDE
#define VK_OFF              0xDF



#define VK_DBE_ALPHANUMERIC              0x0f0
#define VK_DBE_KATAKANA                  0x0f1
#define VK_DBE_HIRAGANA                  0x0f2
#define VK_DBE_SBCSCHAR                  0x0f3
#define VK_DBE_DBCSCHAR                  0x0f4
#define VK_DBE_ROMAN                     0x0f5
#define VK_DBE_NOROMAN                   0x0f6
#define VK_DBE_ENTERWORDREGISTERMODE     0x0f7
#define VK_DBE_ENTERIMECONFIGMODE        0x0f8
#define VK_DBE_FLUSHSTRING               0x0f9
#define VK_DBE_CODEINPUT                 0x0fa
#define VK_DBE_NOCODEINPUT               0x0fb
#define VK_DBE_DETERMINESTRING           0x0fc
#define VK_DBE_ENTERDLGCONVERSIONMODE    0x0fd



// @CESYSGEN ENDIF



// @CESYSGEN IF GWES_STCCTL
// Static control styles, messages and notifications
#define SS_LEFT             0x00000000L
#define SS_CENTER           0x00000001L
#define SS_RIGHT	    0x00000002L
#define SS_ICON 	    0x00000003L
#define SS_LEFTNOWORDWRAP   0x0000000CL
#define SS_BITMAP           0x0000000EL
#define SS_NOPREFIX         0x00000080L
#define SS_CENTERIMAGE      0x00000200L
#if(WINVER >= 0x0400)
#define SS_NOTIFY           0x00000100L
#define STN_CLICKED         0
#define STN_ENABLE          2
#define STN_DISABLE         3
#endif // WINVER >= 0x0400

#define STM_SETIMAGE        0x0172
#define STM_GETIMAGE        0x0173
// @CESYSGEN ENDIF

// @CESYSGEN IF GWES_BTNCTL
// Button control styles, messages and notifications
#define BS_PUSHBUTTON       0x00000000L
#define BS_DEFPUSHBUTTON    0x00000001L
#define BS_CHECKBOX         0x00000002L
#define BS_AUTOCHECKBOX     0x00000003L
#define BS_RADIOBUTTON      0x00000004L
#define BS_3STATE           0x00000005L
#define BS_AUTO3STATE       0x00000006L
#define BS_GROUPBOX         0x00000007L
#define BS_AUTORADIOBUTTON  0x00000009L
#define BS_OWNERDRAW        0x0000000BL
#define BS_LEFTTEXT         0x00000020L
#if (WINVER >= 0x0400)
#define BS_TEXT             0x00000000L
#define BS_LEFT             0x00000100L
#define BS_RIGHT            0x00000200L
#define BS_CENTER           0x00000300L
#define BS_TOP              0x00000400L
#define BS_BOTTOM           0x00000800L
#define BS_VCENTER          0x00000C00L
#define BS_PUSHLIKE         0x00001000L
#define BS_MULTILINE        0x00002000L
#define BS_NOTIFY           0x00004000L
#define BS_RIGHTBUTTON      BS_LEFTTEXT
#endif // WINVER >= 0x0400

#define BN_CLICKED          0
#define BN_PAINT            1
#define BN_DBLCLK           5
#if (WINVER >= 0x0400)
#define BN_SETFOCUS         6
#define BN_KILLFOCUS        7
#endif // WINVER >= 0x0400

#define BM_GETCHECK         0x00F0
#define BM_SETCHECK         0x00F1
#define BM_GETSTATE         0x00F2
#define BM_SETSTATE         0x00F3
#define BM_SETSTYLE         0x00F4
#if (WINVER >= 0x0400)
#define BM_CLICK            0x00F5

#define BST_UNCHECKED       0x0000
#define BST_CHECKED         0x0001
#define BST_INDETERMINATE   0x0002
#define BST_PUSHED          0x0004
#define BST_FOCUS           0x0008
#endif // WINVER >= 0x0400
// @CESYSGEN ENDIF

#define SW_SCROLLCHILDREN   0x0001  /* Scroll children within *lprcScroll. */
#define SW_INVALIDATE       0x0002  /* Invalidate after scrolling */
#define SW_ERASE            0x0004  /* If SW_INVALIDATE, don't send WM_ERASEBACKGROUND */


#if(WINVER >= 0x0400)
typedef struct tagNMHDR
{
    HWND  hwndFrom;
    UINT  idFrom;
    UINT  code;         // NM_ code
}   NMHDR;
typedef NMHDR FAR * LPNMHDR;
#endif

/*
 *  Owner draw control types
 */
// @CESYSGEN IF GWES_MENU
#define ODT_MENU        1
// @CESYSGEN ENDIF
#define ODT_LISTBOX     2
#define ODT_COMBOBOX    3
#define ODT_BUTTON      4

/*
 *  Owner draw actions
 */
#define ODA_DRAWENTIRE  0x0001
#define ODA_SELECT      0x0002
#define ODA_FOCUS       0x0004

/*
 *  Owner draw state
 */
#define ODS_SELECTED    0x0001
#define ODS_GRAYED      0x0002
#define ODS_DISABLED    0x0004
#define ODS_CHECKED     0x0008
#define ODS_FOCUS       0x0010

/*
 * MEASUREITEMSTRUCT for ownerdraw
 */
typedef struct tagMEASUREITEMSTRUCT {
    UINT    CtlType;
    UINT    CtlID;
    UINT    itemID;
    UINT    itemWidth;
    UINT    itemHeight;
    UINT    itemData;
} MEASUREITEMSTRUCT, *PMEASUREITEMSTRUCT, *LPMEASUREITEMSTRUCT;

/*
 *  DRAWITEMSTRUCT for ownerdraw
 */
typedef struct tagDRAWITEMSTRUCT {
    UINT    CtlType;
    UINT    CtlID;
    UINT    itemID;
    UINT    itemAction;
    UINT    itemState;
    HWND    hwndItem;
    HDC     hDC;
    RECT    rcItem;
    DWORD   itemData;
} DRAWITEMSTRUCT, *PDRAWITEMSTRUCT, *LPDRAWITEMSTRUCT;

/*
 * DELETITEMSTRUCT for ownerdraw
 */
typedef struct tagDELETITEMSTRUCT {
    UINT    CtlType;
    UINT    CtlID;
    UINT    itemID;
    HWND    hwndItem;
    UINT    itemData;
} DELETEITEMSTRUCT, *PDELETEITEMSTRUCT, *LPDELETEITEMSTRUCT;

typedef struct tagCOMPAREITEMSTRUCT {
    UINT    CtlType;
    UINT    CtlID;
    HWND    hwndItem;
    UINT    itemID1;
    DWORD   itemData1;
    UINT    itemID2;
    DWORD   itemData2;
    DWORD   dwLocaleId;
} COMPAREITEMSTRUCT, *PCOMPAREITEMSTRUCT, *LPCOMPAREITEMSTRUCT;


// @CESYSGEN IF GWES_EDCTL
/*
 *  Edit Control Styles
 */
#define ES_LEFT         0x0000L
#define ES_CENTER       0x0001L
#define ES_RIGHT        0x0002L
#define ES_MULTILINE    0x0004L
#define ES_UPPERCASE    0x0008L
#define ES_LOWERCASE    0x0010L
#define ES_PASSWORD     0x0020L
#define ES_AUTOVSCROLL  0x0040L
#define ES_AUTOHSCROLL  0x0080L
#define ES_NOHIDESEL    0x0100L
#define ES_COMBOBOX 	0x0200L
#define ES_OEMCONVERT   0x0400L
#define ES_READONLY     0x0800L
#define ES_WANTRETURN   0x1000L
#if(WINVER >= 0x0400)
#define ES_NUMBER           0x2000L
#endif /* WINVER >= 0x0400 */

/*
 *  Edit control notifications
 */
#define EN_SETFOCUS     0x0100
#define EN_KILLFOCUS    0x0200
#define EN_CHANGE       0x0300
#define EN_UPDATE       0x0400
#define EN_ERRSPACE     0x0500
#define EN_MAXTEXT      0x0501
#define EN_HSCROLL      0x0601
#define EN_VSCROLL      0x0602

#if(WINVER >= 0x0400)
/* Edit control EM_SETMARGIN parameters */
#define EC_LEFTMARGIN       0x0001
#define EC_RIGHTMARGIN      0x0002
#define EC_USEFONTINFO      0xffff
#endif /* WINVER >= 0x0400 */

/*
 *  Edit Control Messages
 */
#define EM_GETSEL               0x00B0
#define EM_SETSEL               0x00B1
#define EM_GETRECT              0x00B2
#define EM_SETRECT              0x00B3
#define EM_SETRECTNP            0x00B4
#define EM_SCROLL               0x00B5
#define EM_LINESCROLL           0x00B6
#define EM_SCROLLCARET          0x00B7
#define EM_GETMODIFY            0x00B8
#define EM_SETMODIFY            0x00B9
#define EM_GETLINECOUNT         0x00BA
#define EM_LINEINDEX            0x00BB
#define EM_LINELENGTH           0x00C1
#define EM_REPLACESEL           0x00C2
#define EM_GETLINE              0x00C4
#define EM_LIMITTEXT            0x00C5
#define EM_CANUNDO              0x00C6
#define EM_UNDO                 0x00C7
#define EM_FMTLINES             0x00C8
#define EM_LINEFROMCHAR         0x00C9
#define EM_SETTABSTOPS          0x00CB
#define EM_SETPASSWORDCHAR      0x00CC
#define EM_EMPTYUNDOBUFFER      0x00CD
#define EM_GETFIRSTVISIBLELINE  0x00CE
#define EM_SETREADONLY          0x00CF
#define EM_GETPASSWORDCHAR      0x00D2
#if(WINVER >= 0x0400)
#define EM_SETMARGINS           0x00D3
#define EM_GETMARGINS           0x00D4
#define EM_SETLIMITTEXT         EM_LIMITTEXT   /* ;win40 Name change */
#define EM_GETLIMITTEXT         0x00D5
#define EM_POSFROMCHAR          0x00D6
#define EM_CHARFROMPOS          0x00D7

// Edit control reserved values
#define EM_RESERVED0x00DD       0x00DD    
#define EM_RESERVED0x00DE       0x00DE    
#define EM_RESERVED0x00E0       0x00E0    
#define EM_RESERVED0x00E1       0x00E1    
#endif /* WINVER >= 0x0400 */
// @CESYSGEN ENDIF


// @CESYSGEN IF GWES_SBCMN
/*
 * Scroll Bar Constants
 */
#define SB_HORZ             0
#define SB_VERT             1
#define SB_CTL              2
#define SB_BOTH             3


/*
 * Scroll Bar Commands
 */
#define SB_LINEUP           0
#define SB_LINELEFT         0
#define SB_LINEDOWN         1
#define SB_LINERIGHT        1
#define SB_PAGEUP           2
#define SB_PAGELEFT         2
#define SB_PAGEDOWN         3
#define SB_PAGERIGHT        3
#define SB_THUMBPOSITION    4
#define SB_THUMBTRACK       5
#define SB_TOP              6
#define SB_LEFT             6
#define SB_BOTTOM           7
#define SB_RIGHT            7
#define SB_ENDSCROLL        8


/*
 * Scroll bar messages
 */

#define SBM_SETSCROLLINFO           0x00E9
#define SBM_GETSCROLLINFO           0x00EA

#define SIF_RANGE           0x0001
#define SIF_PAGE            0x0002
#define SIF_POS             0x0004
#define SIF_DISABLENOSCROLL 0x0008
#define SIF_TRACKPOS        0x0010
#define SIF_ALL             (SIF_RANGE | SIF_PAGE | SIF_POS | SIF_TRACKPOS)

typedef struct tagSCROLLINFO
{
    UINT    cbSize;
    UINT    fMask;
    int     nMin;
    int     nMax;
    UINT    nPage;
    int     nPos;
    int     nTrackPos;
}   SCROLLINFO, FAR *LPSCROLLINFO;
typedef SCROLLINFO CONST FAR *LPCSCROLLINFO;

WINUSERAPI
int
WINAPI
SetScrollInfo(
	HWND,
	int,
	LPCSCROLLINFO,
	BOOL);


WINUSERAPI
BOOL
WINAPI
GetScrollInfo(
	HWND,
	int,
	LPSCROLLINFO
	);


int
WINAPI
SetScrollPos(
	HWND	hwnd,
	int		fnBar,
	int		nPos,
	BOOL	bRedraw
	);


BOOL
WINAPI
SetScrollRange(
HWND hwnd,
	int		fnBar,
	int		nMinPos,
	int		nMaxPos,
	BOOL	bRedraw
	);

/*
 * Scroll Bar Styles
 */
#define SBS_HORZ                    0x0000L
#define SBS_VERT                    0x0001L


// @CESYSGEN ENDIF




// @CESYSGEN IF GWES_SCBCTL




// @CESYSGEN ENDIF

#ifndef NOKEYSTATES
/*
 * Key State Masks for Mouse Messages
 */
#define MK_LBUTTON          0x0001
#define MK_RBUTTON          0x0002
#define MK_SHIFT            0x0004
#define MK_CONTROL          0x0008
#define MK_MBUTTON          0x0010

#endif /* !NOKEYSTATES */


/*
 *  Dialog Stuff
 */

/*
 * WARNING:
 * The following structures must NOT be DWORD padded because they are
 * followed by strings, etc that do not have to be DWORD aligned.
 */
#include "pshpack2.h"

/*
 * Dialog Box Command IDs
 */
#define IDOK                1
#define IDCANCEL            2
#define IDABORT             3
#define IDRETRY             4
#define IDIGNORE            5
#define IDYES               6
#define IDNO                7
#if(WINVER >= 0x0400)
#define IDCLOSE         8
#define IDHELP          9
#endif /* WINVER >= 0x0400 */

/*
 * Get/SetWindowWord/Long offsets for use with WC_DIALOG windows
 */
#define DWL_MSGRESULT   0
#define DWL_DLGPROC     4
#define DWL_USER        8

/*
 * original NT 32 bit dialog template:
 */
typedef struct {
    DWORD style;
    DWORD dwExtendedStyle;
    WORD cdit;
    short x;
    short y;
    short cx;
    short cy;
} DLGTEMPLATE;
typedef DLGTEMPLATE *LPDLGTEMPLATEA;
typedef DLGTEMPLATE *LPDLGTEMPLATEW;
#ifdef UNICODE
typedef LPDLGTEMPLATEW LPDLGTEMPLATE;
#else
typedef LPDLGTEMPLATEA LPDLGTEMPLATE;
#endif // UNICODE
typedef CONST DLGTEMPLATE *LPCDLGTEMPLATEA;
typedef CONST DLGTEMPLATE *LPCDLGTEMPLATEW;
#ifdef UNICODE
typedef LPCDLGTEMPLATEW LPCDLGTEMPLATE;
#else
typedef LPCDLGTEMPLATEA LPCDLGTEMPLATE;
#endif // UNICODE

/*
 * 32 bit Dialog item template.
 */
typedef struct {
    DWORD style;
    DWORD dwExtendedStyle;
    short x;
    short y;
    short cx;
    short cy;
    WORD id;
} DLGITEMTEMPLATE;
typedef DLGITEMTEMPLATE *PDLGITEMTEMPLATEA;
typedef DLGITEMTEMPLATE *PDLGITEMTEMPLATEW;
#ifdef UNICODE
typedef PDLGITEMTEMPLATEW PDLGITEMTEMPLATE;
#else
typedef PDLGITEMTEMPLATEA PDLGITEMTEMPLATE;
#endif // UNICODE
typedef DLGITEMTEMPLATE *LPDLGITEMTEMPLATEA;
typedef DLGITEMTEMPLATE *LPDLGITEMTEMPLATEW;
#ifdef UNICODE
typedef LPDLGITEMTEMPLATEW LPDLGITEMTEMPLATE;
#else
typedef LPDLGITEMTEMPLATEA LPDLGITEMTEMPLATE;
#endif // UNICODE

#include "poppack.h" /* Resume normal packing */

/*
 * Dialog Styles
 */
#define DS_LOCALEDIT        0x20L   /* Edit items get Local storage. */
#define DS_SETFONT          0x40L   /* User specified font for Dlg controls */
#define DS_MODALFRAME       0x80L   /* Can be combined with WS_CAPTION  */
#define DS_SETFOREGROUND    0x200L  /* not in Windows 3.1 */

#if(WINVER >= 0x0400)
#define DS_3DLOOK           0x0004L
#define DS_CONTROL          0x0400L
#define DS_CENTER           0x0800L
#define DS_NOCLOSEBTN		0x4000L

#endif /* WINVER >= 0x0400 */

#define DM_GETDEFID         (WM_USER+0)
#define DM_SETDEFID         (WM_USER+1)
// reserved value
#define DM_RESERVED0x2        (WM_USER+2)  



/*
 * Returned in HIWORD() of DM_GETDEFID result if msg is supported
 */
#define DC_HASDEFID         0x534B

#define DLGC_WANTARROWS         0x0001
#define DLGC_WANTTAB            0x0002
#define DLGC_WANTALLKEYS        0x0004
#define DLGC_WANTMESSAGE        0x0004
#define DLGC_HASSETSEL      	0x0008
#define DLGC_DEFPUSHBUTTON      0x0010
#define DLGC_UNDEFPUSHBUTTON    0x0020
#define DLGC_RADIOBUTTON        0x0040
#define DLGC_WANTCHARS          0x0080
#define DLGC_STATIC             0x0100
#define DLGC_BUTTON             0x2000

WINUSERAPI
HWND
WINAPI
CreateDialogIndirectParamA(
    HINSTANCE hInstance,
    LPCDLGTEMPLATEA lpTemplate,
    HWND hWndParent,
    DLGPROC lpDialogFunc,
    LPARAM dwInitParam);
WINUSERAPI
HWND
WINAPI
CreateDialogIndirectParamW(
    HINSTANCE hInstance,
    LPCDLGTEMPLATEW lpTemplate,
    HWND hWndParent,
    DLGPROC lpDialogFunc,
    LPARAM dwInitParam);
#ifdef UNICODE
#define CreateDialogIndirectParam  CreateDialogIndirectParamW
#else
#define CreateDialogIndirectParam  CreateDialogIndirectParamA
#endif // !UNICODE


/*
	@func HWND | CreateDialogIndirect | Creates a modeless dialog box from a dialog box
	template resource.
    @parm HINSTANCE | hInstance | handle of application instance
    @parm LPCDLGTEMPLATE | lpTemplate | Ptr to loaded dialog box template resource
    @parm HWND | hwndOwner | handle of owner window
    @parm DLGPROC | lpDialogFunc | address of dialog box procedure
    @rdesc returns the window handle for the created dialog
	@comm Implemented as a macro in terms of <f CreateDialogIndirectParam>
*/
#define CreateDialogIndirectA(hInstance, lpTemplate, hWndParent, lpDialogFunc) \
    CreateDialogIndirectParamA(hInstance, lpTemplate, hWndParent, lpDialogFunc, 0L)
#define CreateDialogIndirectW(hInstance, lpTemplate, hWndParent, lpDialogFunc) \
    CreateDialogIndirectParamW(hInstance, lpTemplate, hWndParent, lpDialogFunc, 0L)
#ifdef UNICODE
#define CreateDialogIndirect  CreateDialogIndirectW
#else
#define CreateDialogIndirect  CreateDialogIndirectA
#endif // !UNICODE

/*
	@func HWND | CreateDialogParam | Creates a modeless dialog box from a dialog box
	resource ID.
    @parm HINSTANCE | hInstance | handle of application instance
    @parm LPSTR | lpTemplateName | Ptr to dialog box resource name
    @parm HWND | hwndOwner | handle of owner window
    @parm DLGPROC | lpDialogFunc | address of dialog box procedure
    @parm LPARAM | dwInitParam | Initialization parameter
    @rdesc returns the window handle for the created dialog
	@comm Implemented as a macro in terms of <f CreateDialogIndirectParam>
*/
#define CreateDialogParamA(hInstance, lpszDlgName, hwndOwner, lpfnDialog, lParam)    \
    CreateDialogIndirectParamA(hInstance,   \
        (LPCDLGTEMPLATEA)LoadResource(hInstance, FindResource(hInstance, lpszDlgName, RT_DIALOG)), \
        hwndOwner, lpfnDialog, lParam)
#define CreateDialogParamW(hInstance, lpszDlgName, hwndOwner, lpfnDialog, lParam)    \
    CreateDialogIndirectParamW(hInstance,   \
        (LPCDLGTEMPLATEW)LoadResource(hInstance, FindResource(hInstance, lpszDlgName, RT_DIALOG)), \
        hwndOwner, lpfnDialog, lParam)
#ifdef UNICODE
#define CreateDialogParam  CreateDialogParamW
#else
#define CreateDialogParam  CreateDialogParamA
#endif // !UNICODE

/*
	@func HWND | CreateDialog | Creates a modeless dialog box from a dialog box
	resource ID.
    @parm HINSTANCE | hInstance | handle of application instance
    @parm LPSTR | lpTemplateName | Ptr to dialog box resource name
    @parm HWND | hwndOwner | handle of owner window
    @parm DLGPROC | lpDialogFunc | address of dialog box procedure
    @rdesc returns the window handle for the created dialog
	@comm Implemented as a macro in terms of <f CreateDialogIndirectParam>
*/
#define CreateDialogA(hInstance, lpName, hWndParent, lpDialogFunc) \
    CreateDialogParamA(hInstance, lpName, hWndParent, lpDialogFunc, 0L)
#define CreateDialogW(hInstance, lpName, hWndParent, lpDialogFunc) \
    CreateDialogParamW(hInstance, lpName, hWndParent, lpDialogFunc, 0L)
#ifdef UNICODE
#define CreateDialog  CreateDialogW
#else
#define CreateDialog  CreateDialogA
#endif // !UNICODE

int
WINAPI
DialogBoxIndirectParamA(
    HINSTANCE hInstance,
    LPCDLGTEMPLATEA hDialogTemplate,
    HWND hWndParent ,
    DLGPROC lpDialogFunc,
    LPARAM dwInitParam);
int
WINAPI
DialogBoxIndirectParamW(
    HINSTANCE hInstance,
    LPCDLGTEMPLATEW hDialogTemplate,
    HWND hWndParent ,
    DLGPROC lpDialogFunc,
    LPARAM dwInitParam);
#ifdef UNICODE
#define DialogBoxIndirectParam  DialogBoxIndirectParamW
#else
#define DialogBoxIndirectParam  DialogBoxIndirectParamA
#endif // !UNICODE

/*
	@func int | DialogBoxIndirect | Creates a modal dialog box from a dialog box
	template resource.
    @parm HINSTANCE | hInstance | handle of application instance
    @parm LPCDLGTEMPLATE | lpTemplate | identifies loaded dialog box template resource
    @parm HWND | hwndParent | handle of owner window
    @parm DLGPROC | lpDialogFunc | address of dialog box procedure
	@comm Implemented as a macro in terms of <f DialogBoxIndirectParam>
*/
#define DialogBoxIndirectA(hInstance, lpTemplate, hWndParent, lpDialogFunc) \
    DialogBoxIndirectParamA(hInstance, lpTemplate, hWndParent, lpDialogFunc, 0L)
#define DialogBoxIndirectW(hInstance, lpTemplate, hWndParent, lpDialogFunc) \
    DialogBoxIndirectParamW(hInstance, lpTemplate, hWndParent, lpDialogFunc, 0L)
#ifdef UNICODE
#define DialogBoxIndirect  DialogBoxIndirectW
#else
#define DialogBoxIndirect  DialogBoxIndirectA
#endif // !UNICODE

/*
	@func int | DialogBoxParam | Creates a modal dialog box from a dialog box
	template resource.
    @parm HINSTANCE | hInstance | handle of application instance
    @parm LPCTSTR | lpTemplateName | identifies dialog box template
    @parm HWND | hwndParent | handle of owner window
    @parm DLGPROC | lpDialogFunc | address of dialog box procedure
    @parm LPARAM | dwInitParam | initialization value
	@comm Implemented as a macro in terms of <f DialogBoxIndirectParam>
*/
#define DialogBoxParamA(hInstance, lpszDlgName, hwndOwner, lpfnDialog, lParam)    \
    DialogBoxIndirectParamA(hInstance,   \
        (LPCDLGTEMPLATEA)LoadResource(hInstance, FindResource(hInstance, lpszDlgName, RT_DIALOG)), \
        hwndOwner, lpfnDialog, lParam)
#define DialogBoxParamW(hInstance, lpszDlgName, hwndOwner, lpfnDialog, lParam)    \
    DialogBoxIndirectParamW(hInstance,   \
        (LPCDLGTEMPLATEW)LoadResource(hInstance, FindResource(hInstance, lpszDlgName, RT_DIALOG)), \
        hwndOwner, lpfnDialog, lParam)
#ifdef UNICODE
#define DialogBoxParam  DialogBoxParamW
#else
#define DialogBoxParam  DialogBoxParamA
#endif // !UNICODE

/*
	@func int | DialogBox | Creates a modal dialog box from a dialog box
	template resource.
    @parm HINSTANCE | hInstance | handle of application instance
    @parm LPCTSTR | lpTemplateName | identifies dialog box template
    @parm HWND | hwndParent | handle of owner window
    @parm DLGPROC | lpDialogFunc | address of dialog box procedure
	@comm Implemented as a macro in terms of <f DialogBoxIndirectParam>
*/
#define DialogBoxA(hInstance, lpTemplate, hWndParent, lpDialogFunc) \
    DialogBoxParamA(hInstance, lpTemplate, hWndParent, lpDialogFunc, 0L)
#define DialogBoxW(hInstance, lpTemplate, hWndParent, lpDialogFunc) \
    DialogBoxParamW(hInstance, lpTemplate, hWndParent, lpDialogFunc, 0L)
#ifdef UNICODE
#define DialogBox  DialogBoxW
#else
#define DialogBox  DialogBoxA
#endif // !UNICODE

// @CESYSGEN IF GWES_DLGMGR
#ifndef NOCTLMGR



WINUSERAPI
BOOL
WINAPI
IsDialogMessageA(
    HWND hDlg,
    LPMSG lpMsg);

WINUSERAPI
BOOL
WINAPI
IsDialogMessageW(
    HWND hDlg,
    LPMSG lpMsg);

#ifdef UNICODE
#define IsDialogMessage  IsDialogMessageW
#else
#define IsDialogMessage  IsDialogMessageA
#endif // !UNICODE

BOOL
WINAPI
EndDialog(
    HWND hDlg,
    int nResult);

HWND
WINAPI
GetNextDlgGroupItem (
    HWND hDlg,
    HWND hCtl,
    BOOL bPrevious
    );

HWND
WINAPI
GetNextDlgTabItem (
    HWND hDlg,
    HWND hCtl,
    BOOL bPrevious
    );

int
WINAPI
GetDlgCtrlID (
    HWND hWnd
    );

long
WINAPI
GetDialogBaseUnits(
	VOID
	);

BOOL
WINAPI
MapDialogRect (
    HWND hwnd,
    LPRECT prc
    );


HWND
WINAPI
GetDlgItem (
    HWND hDlg,
    int  iCtrlID
    );

WINUSERAPI
LRESULT
WINAPI
DefDlgProcA(
    HWND hDlg,
    UINT Msg,
    WPARAM wParam,
    LPARAM lParam);
WINUSERAPI
LRESULT
WINAPI
DefDlgProcW(
    HWND hDlg,
    UINT Msg,
    WPARAM wParam,
    LPARAM lParam);
#ifdef UNICODE
#define DefDlgProc  DefDlgProcW
#else
#define DefDlgProc  DefDlgProcA
#endif // !UNICODE


/*
 * Window extra bytes needed for private dialog classes.
 */
#define DLGWINDOWEXTRA 32

WINUSERAPI
BOOL
WINAPI
SetDlgItemInt(
    HWND hDlg,
    int nIDDlgItem,
    UINT uValue,
    BOOL bSigned);

WINUSERAPI
UINT
WINAPI
GetDlgItemInt(
    HWND hDlg,
    int nIDDlgItem,
    BOOL *lpTranslated,
    BOOL bSigned);

BOOL
WINAPI
CheckRadioButton(
    HWND hDlg,
    int nIDFirstButton,
    int nIDLastButton,
    int nIDCheckButton);

WINUSERAPI
LONG
WINAPI
SendDlgItemMessageA(
    HWND hDlg,
    int nIDDlgItem,
    UINT Msg,
    WPARAM wParam,
    LPARAM lParam);
WINUSERAPI
LONG
WINAPI
SendDlgItemMessageW(
    HWND hDlg,
    int nIDDlgItem,
    UINT Msg,
    WPARAM wParam,
    LPARAM lParam);
#ifdef UNICODE
#define SendDlgItemMessage  SendDlgItemMessageW
#else
#define SendDlgItemMessage  SendDlgItemMessageA
#endif // !UNICODE

__inline
UINT
WINAPI
IsDlgButtonChecked(HWND hDlg, int nIDButton)
{
    return SendDlgItemMessage((hDlg), (nIDButton), BM_GETCHECK, (WPARAM)0, (LPARAM)0);
}

__inline
BOOL
WINAPI
CheckDlgButton(HWND hDlg, int nIDButton, UINT uCheck)
{
	return SendDlgItemMessage((hDlg), (nIDButton), BM_SETCHECK, (WPARAM)uCheck, (LPARAM)0);
}

WINUSERAPI
BOOL
WINAPI
SetDlgItemTextA(
    HWND hDlg,
    int nIDDlgItem,
    LPCSTR lpString);
WINUSERAPI
BOOL
WINAPI
SetDlgItemTextW(
    HWND hDlg,
    int nIDDlgItem,
    LPCWSTR lpString);
#ifdef UNICODE
#define SetDlgItemText  SetDlgItemTextW
#else
#define SetDlgItemText  SetDlgItemTextA
#endif // !UNICODE

WINUSERAPI
UINT
WINAPI
GetDlgItemTextA(
    HWND hDlg,
    int nIDDlgItem,
    LPSTR lpString,
    int nMaxCount);
WINUSERAPI
UINT
WINAPI
GetDlgItemTextW(
    HWND hDlg,
    int nIDDlgItem,
    LPWSTR lpString,
    int nMaxCount);
#ifdef UNICODE
#define GetDlgItemText  GetDlgItemTextW
#else
#define GetDlgItemText  GetDlgItemTextA
#endif // !UNICODE
/*
@func BOOL | SendDlgItemMessage | Sends a dlg item a message
@parm HWND | hwndDlg | Dialog handle
@parm int | idControl | id of control to send msg to
@parm WPARAM | wparam  | wParam of message
@parm LPARAM | lParam | lParam of message
@comm implemented as macro in terms of <f GetDlgItem> and <f SendMessage>
*/
/*
@func BOOL | SetDlgItemText | Sets text of a dlg item
@parm HWND | hwndDlg | Dialog handle
@parm int | idControl | id of control to send msg to
@parm LPSTR | lpsz  | Ptr to text to be set
@comm implemented as macro in terms of <f GetDlgItem> and <f SetWindowText>
*/
/*
@func BOOL | GetDlgItemText | Gets text of a dlg item
@parm HWND | hwndDlg | Dialog handle
@parm int | idControl | id of control to send msg to
@parm LPSTR | lpsz  | Ptr to text buffer
@parm int | nMaxCount | size of buffer
@comm implemented as macro in terms of <f GetDlgItem> and <f GetWindowText>
*/

#endif // !NOCTLMGR
// @CESYSGEN ENDIF GWES_DLGMGR

// @CESYSGEN IF GWES_LBCTL
/*
 * Listbox Return Values
 */
#define LB_OKAY             0
#define LB_ERR              (-1)
#define LB_ERRSPACE         (-2)

/*
**  The idStaticPath parameter to DlgDirList can have the following values
**  ORed if the list box should show other details of the files along with
**  the name of the files;
*/
                                  /* all other details also will be returned */

/*
 * Listbox Notification Codes
 */
#define LBN_ERRSPACE        (-2)
#define LBN_SELCHANGE       1
#define LBN_DBLCLK          2
#define LBN_SELCANCEL       3
#define LBN_SETFOCUS        4
#define LBN_KILLFOCUS       5

#ifndef NOWINMESSAGES

/*
 * Listbox messages
 */
#define LB_ADDSTRING            0x0180
#define LB_INSERTSTRING         0x0181
#define LB_DELETESTRING         0x0182
#define LB_SELITEMRANGEEX       0x0183
#define LB_RESETCONTENT         0x0184
#define LB_SETSEL               0x0185
#define LB_SETCURSEL            0x0186
#define LB_GETSEL               0x0187
#define LB_GETCURSEL            0x0188
#define LB_GETTEXT              0x0189
#define LB_GETTEXTLEN           0x018A
#define LB_GETCOUNT             0x018B
#define LB_SELECTSTRING         0x018C
#define LB_GETTOPINDEX          0x018E
#define LB_FINDSTRING           0x018F
#define LB_GETSELCOUNT          0x0190
#define LB_GETSELITEMS          0x0191
#define LB_SETTABSTOPS          0x0192
#define LB_GETHORIZONTALEXTENT  0x0193
#define LB_SETHORIZONTALEXTENT  0x0194
#define LB_SETCOLUMNWIDTH       0x0195
#define LB_SETTOPINDEX          0x0197
#define LB_GETITEMRECT          0x0198
#define LB_GETITEMDATA          0x0199
#define LB_SETITEMDATA          0x019A
#define LB_SELITEMRANGE         0x019B
#define LB_SETANCHORINDEX       0x019C
#define LB_GETANCHORINDEX       0x019D
#define LB_SETCARETINDEX        0x019E
#define LB_GETCARETINDEX        0x019F
#define LB_SETITEMHEIGHT        0x01A0
#define LB_GETITEMHEIGHT        0x01A1
#define LB_FINDSTRINGEXACT      0x01A2
#define LB_SETLOCALE            0x01A5
#define LB_GETLOCALE            0x01A6

#if(WINVER >= 0x0400)
#define LB_INITSTORAGE          0x01A8
#define LB_ITEMFROMPOINT        0x01A9
// Listbox control reserved values
#define LB_RESERVED0x01C0         0x01C0   
#define LB_RESERVED0x01C1         0x01C1    
#endif /* WINVER >= 0x0400 */

#if(WINVER >= 0x0400)
#define LB_MSGMAX               0x01C9
#else
#define LB_MSGMAX               0x01A8
#endif

#endif /* !NOWINMESSAGES */

/*
 * Listbox Styles
 */
#define LBS_NOTIFY            0x0001L
#define LBS_SORT              0x0002L
#define LBS_NOREDRAW          0x0004L
#define LBS_MULTIPLESEL       0x0008L
#define LBS_HASSTRINGS        0x0040L
#define LBS_USETABSTOPS       0x0080L
#define LBS_NOINTEGRALHEIGHT  0x0100L
#define LBS_MULTICOLUMN       0x0200L
#define LBS_WANTKEYBOARDINPUT 0x0400L
#define LBS_EXTENDEDSEL       0x0800L
#define LBS_DISABLENOSCROLL   0x1000L
#define LBS_NODATA            0x2000L
#if(WINVER >= 0x0400)
#define LBS_NOSEL             0x4000L
#endif /* WINVER >= 0x0400 */
#define LBS_STANDARD          (LBS_NOTIFY | LBS_SORT | WS_VSCROLL | WS_BORDER)

// Extended styles
#define LBS_EX_CONSTSTRINGDATA   0x00000002L
// @CESYSGEN ENDIF


// @CESYSGEN IF GWES_CMBCTL
/*
 * Combo Box Structures
 */
typedef struct tagCOMBOBOXINFO {
  DWORD cbSize;
  RECT  rcItem;
  RECT  rcButton;
  DWORD stateButton; // Currently unsupported on CE
  HWND  hwndCombo;
  HWND  hwndItem;
  HWND  hwndList;
} COMBOBOXINFO, *PCOMBOBOXINFO, *LPCOMBOBOXINFO;

/*
 * Combo Box return Values
 */
#define CB_OKAY             0
#define CB_ERR              (-1)
#define CB_ERRSPACE         (-2)

/*
 * Combo Box Notification Codes
 */
#define CBN_ERRSPACE        (-1)
#define CBN_SELCHANGE       1
#define CBN_DBLCLK          2
#define CBN_SETFOCUS        3
#define CBN_KILLFOCUS       4
#define CBN_EDITCHANGE      5
#define CBN_EDITUPDATE      6
#define CBN_DROPDOWN        7
#define CBN_CLOSEUP         8
#define CBN_SELENDOK        9
#define CBN_SELENDCANCEL    10

/*
 * Combo Box styles
 */
#define CBS_DROPDOWN          0x0002L
#define CBS_DROPDOWNLIST      0x0003L
#define CBS_AUTOHSCROLL       0x0040L
#define CBS_OEMCONVERT        0x0080L
#define CBS_SORT              0x0100L
#define CBS_HASSTRINGS        0x0200L
#define CBS_NOINTEGRALHEIGHT  0x0400L
#define CBS_DISABLENOSCROLL   0x0800L
#if(WINVER >= 0x0400)
#define CBS_UPPERCASE           0x2000L
#define CBS_LOWERCASE           0x4000L
#endif /* WINVER >= 0x0400 */

// Extended combo box styles
#define CBS_EX_CONSTSTRINGDATA  0x00000002L

/*
 * Combo Box messages
 */
#define CB_GETEDITSEL               0x0140
#define CB_LIMITTEXT                0x0141
#define CB_SETEDITSEL               0x0142
#define CB_ADDSTRING                0x0143
#define CB_DELETESTRING             0x0144
#define CB_GETCOUNT                 0x0146
#define CB_GETCURSEL                0x0147
#define CB_GETLBTEXT                0x0148
#define CB_GETLBTEXTLEN             0x0149
#define CB_INSERTSTRING             0x014A
#define CB_RESETCONTENT             0x014B
#define CB_FINDSTRING               0x014C
#define CB_SELECTSTRING             0x014D
#define CB_SETCURSEL                0x014E
#define CB_SHOWDROPDOWN             0x014F
#define CB_GETITEMDATA              0x0150
#define CB_SETITEMDATA              0x0151
#define CB_GETDROPPEDCONTROLRECT    0x0152
#define CB_SETITEMHEIGHT            0x0153
#define CB_GETITEMHEIGHT            0x0154
#define CB_SETEXTENDEDUI            0x0155
#define CB_GETEXTENDEDUI            0x0156
#define CB_GETDROPPEDSTATE          0x0157
#define CB_FINDSTRINGEXACT          0x0158
#define CB_SETLOCALE                0x0159
#define CB_GETLOCALE                0x015A
#if(WINVER >= 0x0400)
#define CB_GETTOPINDEX              0x015b
#define CB_SETTOPINDEX              0x015c
#define CB_GETHORIZONTALEXTENT      0x015d
#define CB_SETHORIZONTALEXTENT      0x015e
#define CB_GETDROPPEDWIDTH          0x015f
#define CB_SETDROPPEDWIDTH          0x0160
#define CB_INITSTORAGE              0x0161
#define CB_GETCOMBOBOXINFO          0x0162
#endif /* WINVER >= 0x0400 */
#if(WINVER >= 0x0400)
#define CB_MSGMAX                   0x0163
#else
#define CB_MSGMAX                   0x015B
#endif
// @CESYSGEN ENDIF


/*
 * Clipboard Manager Functions
 */

// @CESYSGEN IF GWES_CLIPBD
WINUSERAPI
BOOL
WINAPI
OpenClipboard(
    HWND hWndNewOwner);

WINUSERAPI
BOOL
WINAPI
CloseClipboard(
    VOID);

WINUSERAPI
HWND
WINAPI
GetClipboardOwner(
    VOID);

WINUSERAPI
HANDLE
WINAPI
SetClipboardData(
    UINT uFormat,
    HANDLE hMem);

WINUSERAPI
HANDLE
WINAPI
    GetClipboardData(
    UINT uFormat);

WINUSERAPI
HANDLE
WINAPI
    GetClipboardDataAlloc(
    UINT uFormat);


#ifndef UNICODE_ONLY
WINUSERAPI
UINT
WINAPI
RegisterClipboardFormatA(
    LPCSTR lpszFormat);
#endif //!UNICODE_ONLY
#ifndef ANSI_ONLY
WINUSERAPI
UINT
WINAPI
RegisterClipboardFormatW(
    LPCWSTR lpszFormat);
#endif //!ANSI_ONLY
#ifdef UNICODE
#define RegisterClipboardFormat  RegisterClipboardFormatW
#else
#define RegisterClipboardFormat  RegisterClipboardFormatA
#endif // !UNICODE

WINUSERAPI
int
WINAPI
CountClipboardFormats(
    VOID);

WINUSERAPI
UINT
WINAPI
EnumClipboardFormats(
    UINT format);

#ifndef UNICODE_ONLY
WINUSERAPI
int
WINAPI
GetClipboardFormatNameA(
    UINT format,
    LPSTR lpszFormatName,
    int cchMaxCount);
#endif //!UNICODE_ONLY
#ifndef ANSI_ONLY
WINUSERAPI
int
WINAPI
GetClipboardFormatNameW(
    UINT format,
    LPWSTR lpszFormatName,
    int cchMaxCount);
#endif //!ANSI_ONLY
#ifdef UNICODE
#define GetClipboardFormatName  GetClipboardFormatNameW
#else
#define GetClipboardFormatName  GetClipboardFormatNameA
#endif // !UNICODE

WINUSERAPI
BOOL
WINAPI
EmptyClipboard(
    VOID);

WINUSERAPI
BOOL
WINAPI
IsClipboardFormatAvailable(
    UINT format);

WINUSERAPI
int
WINAPI
GetPriorityClipboardFormat(
    UINT *paFormatPriorityList,
    int cFormats);

WINUSERAPI
HWND
WINAPI
GetOpenClipboardWindow(
    VOID);

// @CESYSGEN ENDIF

/* 3D Border Styles */
#define BDR_RAISEDOUTER     0x0001
#define BDR_SUNKENOUTER     0x0002
#define BDR_RAISEDINNER     0x0004
#define BDR_SUNKENINNER     0x0008

#define BDR_OUTER           0x0003
#define BDR_INNER           0x000C
#define BDR_RAISED          0x0005
#define BDR_SUNKEN          0x000A

#define EDGE_RAISED         (BDR_RAISEDOUTER | BDR_RAISEDINNER)
#define EDGE_SUNKEN         (BDR_SUNKENOUTER | BDR_SUNKENINNER)
#define EDGE_ETCHED         (BDR_SUNKENOUTER | BDR_RAISEDINNER)
#define EDGE_BUMP           (BDR_RAISEDOUTER | BDR_SUNKENINNER)

/* Border Flags */
#define BF_LEFT             0x0001
#define BF_TOP              0x0002
#define BF_RIGHT            0x0004
#define BF_BOTTOM           0x0008

#define BF_DIAGONAL     	0x0010

#define BF_DIAGONAL_ENDTOPRIGHT     (BF_DIAGONAL | BF_TOP | BF_RIGHT)
#define BF_DIAGONAL_ENDTOPLEFT      (BF_DIAGONAL | BF_TOP | BF_LEFT)
#define BF_DIAGONAL_ENDBOTTOMLEFT   (BF_DIAGONAL | BF_BOTTOM | BF_LEFT)
#define BF_DIAGONAL_ENDBOTTOMRIGHT  (BF_DIAGONAL | BF_BOTTOM | BF_RIGHT)

#define BF_TOPLEFT          (BF_TOP | BF_LEFT)
#define BF_TOPRIGHT         (BF_TOP | BF_RIGHT)
#define BF_BOTTOMLEFT       (BF_BOTTOM | BF_LEFT)
#define BF_BOTTOMRIGHT      (BF_BOTTOM | BF_RIGHT)
#define BF_RECT             (BF_LEFT | BF_RIGHT | BF_TOP | BF_BOTTOM)

#define BF_MIDDLE   	    0x0800

#define BF_SOFT             0x1000
#define BF_ADJUST           0x2000
#define BF_FLAT             0x4000
#define BF_MONO             0x8000


/*
 *  Color Types
 */
#define CTLCOLOR_MSGBOX         0
#define CTLCOLOR_EDIT           1
#define CTLCOLOR_LISTBOX        2
#define CTLCOLOR_BTN            3
#define CTLCOLOR_SCOLLBAR       5
#define CTLCOLOR_STATIC         6
#define CTLCOLOR_MAX            7



// @CESYSGEN IF GWES_CURSOR || GWES_MCURSOR

#ifdef UNDER_NT

#ifndef UNICODE_ONLY
WINUSERAPI
HCURSOR
WINAPI
LoadCursorA(
    HINSTANCE hInstance,
    LPCSTR lpCursorName);
#endif //!UNICODE_ONLY
#ifndef ANSI_ONLY
WINUSERAPI
HCURSOR
WINAPI
LoadCursorW(
    HINSTANCE hInstance,
    LPCWSTR lpCursorName);
#endif //!ANSI_ONLY
#ifdef UNICODE
#define LoadCursor  LoadCursorW
#else
#define LoadCursor  LoadCursorA
#endif // !UNICODE

#define IDC_ARROW           MAKEINTRESOURCE(32512) // Arrow cursor for emulation

#else // UNDER_NT

WINUSERAPI
HCURSOR
WINAPI
LoadCursorA(
    HINSTANCE hInstance,
    LPCSTR lpCursorName);
WINUSERAPI
HCURSOR
WINAPI
LoadCursorW(
    HINSTANCE hInstance,
    LPCWSTR lpCursorName);
#undef LoadCursor
#ifdef UNICODE
#define LoadCursor  LoadCursorW
#else
#define LoadCursor  LoadCursorA
#endif // !UNICODE


#endif // UNDER_NT

/*
 * Standard Cursor IDs
 */
#define IDC_ARROW           MAKEINTRESOURCE(32512)
#define IDC_IBEAM           MAKEINTRESOURCE(32513)
#define IDC_WAIT            MAKEINTRESOURCE(32514)
#define IDC_CROSS           MAKEINTRESOURCE(32515)
#define IDC_UPARROW         MAKEINTRESOURCE(32516)
#define IDC_SIZE            MAKEINTRESOURCE(32646)
#define IDC_ICON            MAKEINTRESOURCE(32512)
#define IDC_SIZENWSE        MAKEINTRESOURCE(32642)
#define IDC_SIZENESW        MAKEINTRESOURCE(32643)
#define IDC_SIZEWE          MAKEINTRESOURCE(32644)
#define IDC_SIZENS          MAKEINTRESOURCE(32645)
#define IDC_SIZEALL         MAKEINTRESOURCE(32646)
#define IDC_NO              MAKEINTRESOURCE(32648)
#define IDC_APPSTARTING     MAKEINTRESOURCE(32650)
#define IDC_HELP            MAKEINTRESOURCE(32651)
#define IDC_HAND			MAKEINTRESOURCE(32649)

WINUSERAPI
int
WINAPI
ShowCursor(
    BOOL bShow);

WINUSERAPI
BOOL
WINAPI
SetCursorPos(
    int X,
    int Y);

WINUSERAPI
HCURSOR
WINAPI
SetCursor(
    HCURSOR hCursor);

WINUSERAPI
BOOL
WINAPI
GetCursorPos(
    LPPOINT lpPoint);

WINUSERAPI
BOOL
WINAPI
ClipCursor(
    CONST RECT *lpRect);

WINUSERAPI
BOOL
WINAPI
GetClipCursor(
    LPRECT lpRect);

WINUSERAPI
HCURSOR
WINAPI
GetCursor(
    VOID);

WINUSERAPI
HCURSOR
WINAPI
LoadAnimatedCursor(
    HINSTANCE	hInstance,
    DWORD		ResourceId,
	int			cFrames,
	int			FrameTimeInterval
	);

// @CESYSGEN ENDIF







// @CESYSGEN IF GWES_TIMER
UINT WINAPI SetTimer(
    HWND hwnd,
    UINT idTimer,
    UINT uTimeOut,
    TIMERPROC pfnTimerProc);

BOOL WINAPI KillTimer(
    HWND hwnd,
    UINT idEvent);
// @CESYSGEN ENDIF


// @CESYSGEN IF GWES_KBDUI
DWORD
WINAPI
GetKeyboardStatus(
	VOID
	);

BOOL
WINAPI
EnableHardwareKeyboard(
	BOOL	fEnable
	);



// @CESYSGEN IF GWES_HOTKEY
#define WM_HOTKEY						0x0312

#define MOD_ALT         0x0001
#define MOD_CONTROL     0x0002
#define MOD_SHIFT       0x0004
#define MOD_WIN         0x0008
#define MOD_KEYUP		0x1000


#define IDHOT_SNAPWINDOW        (-1)    /* SHIFT-PRINTSCRN  */
#define IDHOT_SNAPDESKTOP       (-2)    /* PRINTSCRN        */


WINUSERAPI
BOOL
WINAPI
RegisterHotKey(
	HWND	hWnd,
	int		id,
	UINT	fsModifiers,
	UINT	vk
	);

WINUSERAPI
BOOL
WINAPI
UnregisterHotKey(
	HWND	hWnd,
	int		id
	);

WINUSERAPI
BOOL
WINAPI
AllKeys(
	BOOL bAllKeys);

// @CESYSGEN ENDIF



// @CESYSGEN ENDIF


#define SPIF_UPDATEINIFILE	0x0001
#define SPIF_SENDCHANGE		0x0002

// @CESYSGEN IF GWES_CURSOR || GWES_MCURSOR
#define SPI_GETMOUSE                3
#define SPI_SETMOUSE                4
// @CESYSGEN ENDIF

#define SPI_SETDESKWALLPAPER       20
#define SPI_SETDESKPATTERN         21

#define SPI_SETWORKAREA            47
#define SPI_GETWORKAREA            48

// @CESYSGEN IF GWES_ACCESSIB
// @CESYSGEN ENDIF

#define SPI_GETSHOWSOUNDS          56
#define SPI_SETSHOWSOUNDS          57 
		
#define SPI_GETWHEELSCROLLLINES   104
#define SPI_SETWHEELSCROLLLINES   105

#define SPI_GETFONTSMOOTHINGCONTRAST 0x200C
#define SPI_SETFONTSMOOTHINGCONTRAST 0x200D 

// @CESYSGEN IF GWES_IDLE
#define SPI_GETSCREENSAVETIMEOUT	14
#define SPI_SETSCREENSAVETIMEOUT	15

#define SPI_SETBATTERYIDLETIMEOUT	251
#define SPI_GETBATTERYIDLETIMEOUT	252

#define SPI_SETEXTERNALIDLETIMEOUT	253
#define SPI_GETEXTERNALIDLETIMEOUT	254

#define SPI_SETWAKEUPIDLETIMEOUT	255
#define SPI_GETWAKEUPIDLETIMEOUT	256

// @CESYSGEN ENDIF

//The following flags also used with WM_SETTINGCHANGE
// so don't use the values for future SPI_*

//#define SETTINGCHANGE_START  		0x3001
//#define SETTINGCHANGE_RESET  		0x3002
//#define SETTINGCHANGE_END    		0x3003

#define SPI_GETPLATFORMTYPE 257
#define SPI_GETOEMINFO 258

WINUSERAPI
BOOL
WINAPI
SystemParametersInfoA(
    UINT uiAction,
    UINT uiParam,
    PVOID pvParam,
    UINT fWinIni);

WINUSERAPI
BOOL
WINAPI
SystemParametersInfoW(
    UINT uiAction,
    UINT uiParam,
    PVOID pvParam,
    UINT fWinIni);
#ifdef UNICODE
#define SystemParametersInfo  SystemParametersInfoW
#else
#define SystemParametersInfo  SystemParametersInfoA
#endif // !UNICODE


// @CESYSGEN IF GWES_ACCESSIB
// @CESYSGEN ENDIF


































// @CESYSGEN IF GWES_ICONCMN
#define WM_GETICON                      0x007F
#define WM_SETICON                      0x0080

// WM_SETICON / WM_GETICON Type Codes
#define ICON_SMALL          0
#define ICON_BIG            1

// @CESYSGEN ENDIF


// @CESYSGEN IF GWES_ICON

HICON
WINAPI
LoadIconA(
    HINSTANCE hInstance,
    LPCSTR lpIconName);

HICON
WINAPI
LoadIconW(
    HINSTANCE hInstance,
    LPCWSTR lpIconName);
#ifdef UNICODE
#define LoadIcon  LoadIconW
#else
#define LoadIcon  LoadIconA
#endif // !UNICODE


BOOL
WINAPI
DestroyIcon(
    HICON hIcon);


#define DI_MASK         0x0001
#define DI_IMAGE        0x0002
#define DI_NORMAL       0x0003

BOOL
WINAPI
DrawIconEx(
    HDC hdc,
    int xLeft,
    int yTop,
    HICON hIcon,
    int cxWidth,
    int cyWidth,
    UINT istepIfAniCur,
    HBRUSH hbrFlickerFreeDraw,
    UINT diFlags);

#define DrawIcon(hdc,x,y,hicon) \
        DrawIconEx(hdc,x,y,hicon,0,0,0,NULL, DI_NORMAL)



typedef struct _ICONINFO {
    BOOL    fIcon;
    DWORD   xHotspot;
    DWORD   yHotspot;
    HBITMAP hbmMask;
    HBITMAP hbmColor;
} ICONINFO;
typedef ICONINFO *PICONINFO;


HICON
WINAPI
CreateIconIndirect(
    PICONINFO piconinfo);


// @CESYSGEN ENDIF


// @CESYSGEN IF GWES_LOADIMG

// @CESYSGEN IF GWES_LOADBMP
#define IMAGE_BITMAP        0
// @CESYSGEN ENDIF

// @CESYSGEN IF GWES_ICONCMN
#define IMAGE_ICON          1
#define IMAGE_CURSOR		2
// @CESYSGEN ENDIF


#define LR_DEFAULTCOLOR     0x0000

HANDLE
WINAPI
LoadImageA(
    HINSTANCE,
    LPCSTR,
    UINT,
    int,
    int,
    UINT);

HANDLE
WINAPI
LoadImageW(
    HINSTANCE,
    LPCWSTR,
    UINT,
    int,
    int,
    UINT);
#ifdef UNICODE
#define LoadImage  LoadImageW
#else
#define LoadImage  LoadImageA
#endif // !UNICODE
// @CESYSGEN ENDIF


// @CESYSGEN IF GWES_ICONCURS
WINUSERAPI
HCURSOR
WINAPI
CreateCursor(
    HINSTANCE hInst,
    int xHotSpot,
    int yHotSpot,
    int nWidth,
    int nHeight,
    CONST VOID *pvANDPlane,
    CONST VOID *pvXORPlane);

WINUSERAPI
BOOL
WINAPI
DestroyCursor(
    HCURSOR hCursor);

// @CESYSGEN ENDIF



// MultiMonitor API
#if !defined(HMONITOR_DECLARED) && (WINVER < 0x0500)
DECLARE_HANDLE(HMONITOR);
#define HMONITOR_DECLARED
#endif

#define MONITOR_DEFAULTTONULL              0x00000000
#define MONITOR_DEFAULTTOPRIMARY           0x00000001
#define MONITOR_DEFAULTTONEAREST           0x00000002

HMONITOR
WINAPI
MonitorFromPoint(
    IN POINT pt,
    IN DWORD dwFlags);

HMONITOR
WINAPI
MonitorFromRect(
    IN LPCRECT lprc,
    IN DWORD dwFlags);

HMONITOR
WINAPI
MonitorFromWindow( IN HWND hwnd, IN DWORD dwFlags);

#define MONITORINFOF_PRIMARY        0x00000001

#ifndef CCHDEVICENAME
#define CCHDEVICENAME 32
#endif

typedef struct tagMONITORINFO
{
    DWORD   cbSize;
    RECT    rcMonitor;
    RECT    rcWork;
    DWORD   dwFlags;
} MONITORINFO, *LPMONITORINFO;

#ifdef __cplusplus 
typedef struct tagMONITORINFOEX : public tagMONITORINFO
{ 
      TCHAR        szDevice[CCHDEVICENAME]; 
} MONITORINFOEX, *LPMONITORINFOEX; 
#else // ndef __cplusplus 
typedef struct tagMONITORINFOEX
{ 
    MONITORINFO; 
	TCHAR        szDevice[CCHDEVICENAME];
} MONITORINFOEX, *LPMONITORINFOEX; 
#endif

BOOL 
WINAPI 
GetMonitorInfo(
    IN HMONITOR hMonitor,
    IN LPMONITORINFO lpmi);


typedef BOOL (CALLBACK* MONITORENUMPROC)(HMONITOR, HDC, LPRECT, LPARAM);


BOOL
WINAPI
EnumDisplayMonitors(
    IN HDC             hdc,
    IN LPCRECT         lprcClip,
    IN MONITORENUMPROC lpfnEnum,
    IN LPARAM          dwData);


// @CESYSGEN IF GWES_MGBASE

LONG 
WINAPI 
ChangeDisplaySettingsEx(
	IN LPCTSTR         lpszDeviceName,
	IN LPDEVMODE       lpDevMode,
	IN HWND            hwnd,
	IN DWORD           dwflags,
	LPVOID             lParam
	);

#define SETTINGCHANGE_START  0x3001
#define SETTINGCHANGE_RESET  0x3002
#define SETTINGCHANGE_END    0x3003

/* Flags for ChangeDisplaySettings */
//#define CDS_UPDATEREGISTRY  0x00000001
#define CDS_TEST            0x00000002
//#define CDS_FULLSCREEN      0x00000004
//#define CDS_GLOBAL          0x00000008
//#define CDS_SET_PRIMARY     0x00000010
#define CDS_VIDEOPARAMETERS 0x00000020
#define CDS_RESET           0x40000000
//#define CDS_NORESET         0x10000000

/* Return values for ChangeDisplaySettings */
#define DISP_CHANGE_SUCCESSFUL       0
#define DISP_CHANGE_RESTART          1
#define DISP_CHANGE_FAILED          -1
#define DISP_CHANGE_BADMODE         -2
#define DISP_CHANGE_NOTUPDATED      -3
#define DISP_CHANGE_BADFLAGS        -4
#define DISP_CHANGE_BADPARAM        -5
#if(_WIN32_WINNT >= 0x0501)
#define DISP_CHANGE_BADDUALVIEW     -6
#endif /* _WIN32_WINNT >= 0x0501 */

// @CESYSGEN ENDIF GWES_MGBASE

#ifdef __cplusplus
}
#endif /*__cplusplus*/


#ifdef WINCEOEM
#include <pwinuser.h>	// internal defines
#ifdef WINCEMACRO
#include <mwinuser.h>
#endif
#endif


#endif /* _WINUSER_ */
