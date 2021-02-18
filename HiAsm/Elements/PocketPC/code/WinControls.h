                        ///////////////////////////////////////////////////////////////////////
//            -----    HiAsm for PocketPC    -----                   //
//           Альтернативная библиотека классов под WinAPI            //
//                                               Create by Dilma     //
///////////////////////////////////////////////////////////////////////

/**********************************************************************
*   ##TWinControl
*   ##TForm
*   ##TButton
*   ##TEdit
*   ##TLabel
*   ##TRadioButton
*   ##TCheckBox
*   ##TScrollBar
*   ##TProgressBar
*   ##TUpDown
*   ##TListBox
*   ##TMemo
*   ##TGroupBox
*   ##TPanel
**********************************************************************/

#ifndef __WINCONTROLS_H__
#define __WINCONTROLS_H__

//#include <Windows.h>
//#include <Wingdi.h>
#include <string.h>
#include <commctrl.h>
#include "basetools.h"

#define caNone 0
#define WM_SETCOLOR WM_USER+100

//    ....optimize for future....
typedef bool TCallProc(void *ClassPointer,int Code,WPARAM wParam,LPARAM lParam);
#define CallCSProc(cs,c,w,l) cs->Proc(cs->ClassPointer,c,w,l)
#define ON_PROC(Name) static void Name(void *ClassPointer,void *Param)
#define ON_PROC_LOC(Class,Method) ON_PROC(Method) { ((Class *)ClassPointer)->Method(Param); } void Method(void *Param)

#define _PROPERTY(Type,_Name,_Set,_Get) \
   Type _Get(); \
   void _Set(Type Value); \
   __declspec( property( put = _Set,get = _Get ) )Type _Name;

//extern struct TCallStack;

struct TCallStack;

struct TCallStack
{
 TCallProc *Proc;
 void *ClassPointer;
 TCallStack *Next;
};

typedef struct
{
  int x;
  int y;
  BYTE btn;
}TMouseEvent;

void AddCSProc(TCallStack *&cs,void *ClassPointer,TCallProc *Proc)
{
  TCallStack *_cs;
  if( cs )
    _cs = cs->Next = new TCallStack();
  else _cs = cs = new TCallStack();
  _cs->ClassPointer = ClassPointer;
  _cs->Proc = Proc;
  _cs->Next = NULL;
}

// ##TWinControl
// ##TWinControl.Body
class TWinControl
{
  private:
    WNDPROC OldWndProc;
  protected:
   HFONT FFont;
   //TCallStack *CallStack;
   void SetWndProc();
   //void AddCSProc(long Code,TCallProc *Proc);
   virtual bool LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam);
   virtual bool EraseBk(int &Result){ return false; }
   void InitFont();
  public:
   HWND Handle;
   HDC dc;
   TWinControl *Parent;
   TNotifyEvent *OnClick;
   TNotifyEvent *OnMouseDown;
   TNotifyEvent *OnMouseMove;
   TNotifyEvent *OnMouseUp;
   TNotifyEvent *OnKeyUp;
   TNotifyEvent *OnKeyDown;
   TNotifyEvent *OnSetFocus;
   TNotifyEvent *OnKillFocus;
   TNotifyEvent *OnSize;
   TNotifyEvent *OnDblClick;
   TCallStack *OnMessage;

   HBRUSH FColorBrush;

   TWinControl();
   ~TWinControl(){ DestroyWindow(Handle); }
   void Show(){ ShowWindow(Handle,SW_SHOW); }
   void Hide(){ ShowWindow(Handle,SW_HIDE); }
   void SetPos(int X,int Y){ SetWindowPos(Handle,NULL,X,Y,0,0,SWP_NOSIZE | SWP_NOZORDER); }
   void SetSize(int W,int H){ SetWindowPos(Handle,NULL,0,0,W,H,SWP_NOMOVE | SWP_NOZORDER); }

   void Focused(){ SetFocus(Handle); }
   void SendToBack(){ SetWindowPos( Handle, HWND_BOTTOM,0,0,0,0,SWP_NOSIZE | SWP_NOMOVE |SWP_NOACTIVATE | SWP_NOOWNERZORDER ); }
   void BringToFront(){ SetWindowPos( Handle, HWND_TOP,0,0,0,0,SWP_NOSIZE | SWP_NOMOVE |SWP_NOACTIVATE | SWP_NOOWNERZORDER|SWP_SHOWWINDOW ); }

   void Invalidate(){ InvalidateRect(Handle,NULL,true); }
   LRESULT WndProc(UINT Msg,WPARAM wParam,LPARAM lParam);

   void SetCaption(string &Caption){ SetWindowText(Handle,PChar(Caption)); }
   string GetCaption();
   void SetVisible(bool Value){ if(Value) Show(); else Hide(); }
   void SetCtl3D(bool Value){ if(Value) Style |= WS_BORDER; else Style &= ~WS_BORDER; }
   void SetStyle(long Value);
   long GetStyle(){ return GetWindowLong(Handle,GWL_STYLE); }
   void SetExStyle(long Value){ SetWindowLong(Handle,GWL_EXSTYLE,Value); Invalidate(); }
   long GetExStyle(){ return GetWindowLong(Handle,GWL_EXSTYLE); }
   void SetLeft(int Value){ SetPos(Value,GetTop()); }
   int  GetLeft(){ RECT r; GetWindowRect(Handle,&r); return r.left; }
   void SetTop(int Value){ SetPos(GetLeft(),Value); }
   int  GetTop(){ RECT r; GetWindowRect(Handle,&r); return r.top; }
   void SetWidth(int Value){ SetSize(Value,GetHeight()); }
   int  GetWidth(){ RECT r; GetWindowRect(Handle,&r); return r.right - r.left; }
   void SetHeight(int Value){ SetSize(GetWidth(),Value); }
   int  GetHeight(){ RECT r; GetWindowRect(Handle,&r); return r.bottom - r.top; }
   void SetColor(int Value){ DeleteObject(FColorBrush); FColorBrush = CreateSolidBrush( (Value&0x80000000)?GetSysColor(Value&0xFF|SYS_COLOR_INDEX_FLAG):Value ); }
   void SetFont(HFONT Value){ DeleteObject( FFont ); FFont = Value; SendMessage(Handle,WM_SETFONT,(long)FFont,0); Invalidate(); }

   __declspec( property( put = SetVisible ) )bool Visible;
   __declspec( property( put = SetCaption,get = GetCaption ) )TString Caption;
   __declspec( property( put = SetCtl3D ) )bool Ctl3D;
   __declspec( property( put = SetStyle,get = GetStyle ) )long Style;
   __declspec( property( put = SetExStyle,get = GetExStyle ) )long ExStyle;
   __declspec( property( put = SetColor ) )int Color;
   __declspec( property( put = SetLeft, get = GetLeft ) )int Left;
   __declspec( property( put = SetTop, get = GetTop ) )int Top;
   __declspec( property( put = SetWidth, get = GetWidth ) )int Width;
   __declspec( property( put = SetHeight, get = GetHeight ) )int Height;
   __declspec( property( put = SetFont ) )HFONT Font;
};

//____________________________________________________________________

// ##TForm
// ##TForm.Body
class TForm:public TWinControl
{
  private:
    bool LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam);
  protected:
  public:
    HICON FIcon;
    HICON SIcon;
    TNotifyEvent *OnActivate;
    TNotifyEvent *OnClose;

    TForm(string &Caption,DWORD FStyle);
    void Close(){ SendMessage(Handle,WM_DESTROY,0,0); }
    void SetBorderStyle(short Value);
    void SetIcon(HICON Icon)
    {
       if( Icon )
       {
        FIcon = Icon;
        SendMessage(Handle,WM_SETICON,ICON_SMALL,(int)FIcon);
       }
       else
       {
        HI_RSTRING buf[MAX_PATH];
        GetModuleFileName(hInstance,buf,MAX_PATH);
        ExtractIconEx(buf,0,&FIcon,&SIcon,1);
        SendMessage(Handle,WM_SETICON,ICON_SMALL,(int)SIcon);
       }
       SendMessage(Handle,WM_SETICON,ICON_BIG,(int)FIcon);
    }
    __declspec( property( put = SetIcon,get = FIcon ) )HICON Icon;
};

//____________________________________________________________________

// ##TButton
// ##TButton.Body
class TButton:public TWinControl
{
  private:
   bool LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam);
  public:
   TButton(TWinControl *_Parent,string &Caption);
};

//____________________________________________________________________

// ##TEdit
// ##TEdit.Body
class TEdit:public TWinControl
{
  private:
   bool LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam);
  protected:
   bool EraseBk(int &Result){ Result = (int)CreateSolidBrush(255); return true; }
  public:
   TNotifyEvent *OnChange;
   TEdit(TWinControl *_Parent, string &Caption);
};

//____________________________________________________________________

// ##TLabel
// ##TLabel.Body
class TLabel:public TWinControl
{
  private:
   bool LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam);
  public:
   TLabel(TWinControl *_Parent, string &Caption);
};

//____________________________________________________________________

// ##TRadioButton
// ##TRadioButton.Body
class TRadioButton:public TWinControl
{
  private:
   bool LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam);
  public:
   TRadioButton(TWinControl *_Parent, string &Caption);
};

//____________________________________________________________________

// ##TCheckBox
// ##TCheckBox.Body
class TCheckBox:public TWinControl
{
  private:
   bool LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam);
  public:
   TCheckBox(TWinControl *_Parent, string &Caption);
};

//____________________________________________________________________

// ##TScrollBar
// ##TScrollBar.Body
class TScrollBar:public TWinControl
{
  private:
   bool LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam);
   void UpdateInfo();
  public:
   int FMin;
   int FMax;
   //DWORD FKind;
   TNotifyEvent *OnPosition;
   TNotifyEvent *OnEndScroll;

   TScrollBar(TWinControl *_Parent,WORD _Kind);
   void CreateWnd();
   void SetMax(int Value){ FMax = Value; UpdateInfo(); }
   __declspec( property( put = SetMax ) )int Max;
   void SetMin(int Value){ FMin = Value; UpdateInfo(); }
   __declspec( property( put = SetMin ) )int Min;
   void SetKind(BYTE Value)
   {
      //DestroyWindow(Handle);
      //FKind = (Value)?SBS_VERT:SBS_HORZ;
      //CreateWnd();
   }
   __declspec( property( put = SetKind ) )BYTE Kind;
   void SetPosition(int Value){ SetScrollPos(Handle,SB_CTL,Value,true); }
   int GetPosition();
   __declspec( property( put = SetPosition,get = GetPosition ) )int Position;
};

//____________________________________________________________________

// ##TProgressBar
// ##TProgressBar.Body
class TProgressBar:public TWinControl
{
  private:
   bool LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam);
  public:
   TProgressBar(TWinControl *_Parent,long Options);
   void SetPosition(int Value){ SendMessage(Handle, PBM_SETPOS, Value, 0); }
   int GetPosition(){ return SendMessage(Handle, PBM_GETPOS, 0, 0); }
   __declspec( property( put = SetPosition,get = GetPosition ) )int Position;
};
//____________________________________________________________________

//#define UDM_SETPOS32 WM_USER + 113
//#define UDM_GETPOS32 WM_USER + 114
//#define UDM_SETRANGE32 WM_USER + 111
//#define UDM_GETRANGE32 WM_USER + 112
//#define UDM_SETACCEL WM_USER + 107

// ##TUpDown
// ##TUpDown.Body
class TUpDown:public TWinControl
{
  private:
   bool LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam);
  public:
   TNotifyEvent *OnPosition;

   TUpDown(TWinControl *_Parent,long Options);
   void SetPosition(int Value){ SendMessage(Handle, UDM_SETPOS, 0, Value); }
   int GetPosition(){ return SendMessage(Handle, UDM_GETPOS, 0, 0); }
   __declspec( property( put = SetPosition,get = GetPosition ) )int Position;
   void SetMax(int Value){ int tmp;  SendMessage(Handle,UDM_GETRANGE32,(long)&tmp,0); SendMessage(Handle,UDM_SETRANGE32, tmp, Value); }
   __declspec( property( put = SetMax ) )int Max;
   void SetMin(int Value){ int tmp;  SendMessage(Handle,UDM_GETRANGE32,0,(long)&tmp); SendMessage(Handle,UDM_SETRANGE32, Value, tmp); }
   __declspec( property( put = SetMin ) )int Min;
   void SetStep(int Value)
   {
     struct{ int nSec; int nInc; }acc;
     acc.nSec = 1;
     acc.nInc = Value;
     SendMessage(Handle,UDM_SETACCEL,1,(long)&acc);
   }
   __declspec( property( put = SetStep ) )int Step;
};

//____________________________________________________________________

class TLBList:public TList
{
  private:
    HWND FHandle;
    string GBuf;
  protected:
    string &Get(int Index)
    {
       HI_RSTRING buf[4095];
       int Len = SendMessage(FHandle, LB_GETTEXT,Index,(long)&buf);
       if( Len < 0 )
         GBuf = _his("");
       else GBuf = buf;
       return GBuf;
    }
  public:
    TLBList(HWND Parent){ FHandle = Parent; }

    void Add(string &s){ SendMessage(FHandle,LB_ADDSTRING,0,(long)PChar(s)); }
    void Insert(int Index,string &s)
    {
      SendMessage(FHandle,LB_INSERTSTRING,Index,(long)PChar(s));
    }
    void Delete(int Index){ SendMessage(FHandle,LB_DELETESTRING,Index,0); }
    void Clear(){ SendMessage(FHandle,LB_RESETCONTENT,0,0); }
    //void SetText(string &Value){}
    //string GetText(){}
    int Count(){ return SendMessage(FHandle,LB_GETCOUNT,0,0);  }
};

// ##TListBox
// ##TListBox.Body
class TListBox:public TWinControl
{
  private:
   bool LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam);
  public:
   TLBList *Lines;

   TListBox(TWinControl *_Parent);
   int GetSelIndex(){ return SendMessage(Handle,LB_GETCURSEL,0,0);  }
   void SetSelIndex(int Value){ SendMessage(Handle,LB_SETCURSEL,Value,0);  }
   __declspec( property( put = SetSelIndex,get = GetSelIndex ) )int SelIndex;
};

//____________________________________________________________________

class TMemoList:public TList
{
  private:
    HWND FHandle;
    string GBuf;
  protected:
    string &Get(int Index)
    {
       HI_RSTRING buf[4095];
       *(WORD *)buf = sizeof(buf);
       int Len = SendMessage(FHandle, EM_GETLINE,Index,(long)&buf);
       if( Len < 0 )
         GBuf = _his("");
       else
       {
         buf[Len] = 0;
         GBuf = buf;
       }
       return GBuf;
    }
  public:
    TMemoList(HWND Parent){ FHandle = Parent; }

    void Add(string &s)
    {
      Insert(Count(),s);
    }
    void Insert(int Index,string &s)
    {
      int SelStart = SendMessage(FHandle,EM_LINEINDEX,Index,0);
      if( SelStart < 0 )
      {
         SelStart = SendMessage(FHandle,EM_LINEINDEX,Index-1,0);
         SelStart += SendMessage(FHandle,EM_LINELENGTH,SelStart,0);
      }
      SendMessage(FHandle, EM_SETSEL, SelStart, SelStart);
      string buf;
      buf = s + string(_his("\r\n"));
      SendMessage(FHandle, EM_REPLACESEL, 0, (long)PChar(buf));

    }
    void Delete(int Index)
    {
      int SelStart = SendMessage(FHandle, EM_LINEINDEX, Index, 0);
      if( SelStart >= 0 )
      {
        int SelEnd = SendMessage(FHandle, EM_LINEINDEX, Index + 1, 0);
        if( SelEnd < 0 ) SelEnd = SelStart +
             SendMessage(FHandle, EM_LINELENGTH, SelStart, 0);
        SendMessage(FHandle, EM_SETSEL, SelStart, SelEnd);
        HI_STRING Empty = _his("");
        SendMessage(FHandle, EM_REPLACESEL, 0, (long)Empty);
       }
    }
    void Clear(){ SetWindowText(FHandle, _his("")); }
    int Count()
    {
      int Result = SendMessage(FHandle, EM_GETLINECOUNT, 0, 0);
      if( SendMessage(FHandle, EM_LINELENGTH, SendMessage(FHandle,
        EM_LINEINDEX, Result - 1, 0), 0) == 0) Result--;
      return Result;
    }
};

// ##TMemo
// ##TMemo.Body
class TMemo:public TWinControl
{
  private:
   bool LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam);
  public:
   TMemoList *Lines;
   TNotifyEvent *OnChange;

   TMemo(TWinControl *_Parent,int _Style);
   int GetSelStart(){ DWORD res; SendMessage(Handle,EM_GETSEL,(long)&res,0); return res;  }
   void SetSelStart(int Value){ SendMessage(Handle,EM_SETSEL,Value,Value);  }
   __declspec( property( put = SetSelStart,get = GetSelStart ) )int SelStart;
   _PROPERTY(int,SelLength,SetSelLength,GetSelLength);
   _PROPERTY(string,SelText,SetSelText,GetSelText);
};

//______________________________________________________________________

// ##TGroupBox
// ##TGroupBox.Body
class TGroupBox:public TWinControl
{
  private:
   bool LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam);
  public:
   TGroupBox(TWinControl *_Parent,string &Caption);
};

//______________________________________________________________________

// ##TPanel
// ##TPanel.Body
class TPanel:public TWinControl
{
  private:
   bool LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam);
  public:  
   TNotifyEvent *OnPaint;
   TNotifyEvent *OnMessage;
   
   TPanel(TWinControl *_Parent);
};
//############################################# WINCONTROL #####################################################

// ##TWinControl.Body
LRESULT __stdcall _WndProc(HWND Wnd,UINT Msg,WPARAM wParam,LPARAM lParam)
{
	TWinControl *wc;
	wc = (TWinControl *)GetWindowLong(Wnd,GWL_USERDATA);
	return wc->WndProc(Msg,wParam,lParam);
}

TWinControl::TWinControl()
{
   OnClick = NULL;
   OnMouseDown = NULL;
   OnMouseMove = NULL;
   OnMouseUp = NULL;
   OnKeyUp = NULL;
   OnKeyDown = NULL;
   OnSetFocus = NULL;
   OnKillFocus = NULL;
   OnSize = NULL;
   OnDblClick = NULL;
   OnMessage = NULL;
}

void TWinControl::InitFont()
{
   LOGFONT lf;
   ZeroMemory(&lf,sizeof(lf));
   lf.lfHeight = 14;
   lf.lfWeight = FW_NORMAL;
   lf.lfCharSet = RUSSIAN_CHARSET; //ANSI_CHARSET;
   lf.lfOutPrecision = OUT_DEFAULT_PRECIS;
   lf.lfClipPrecision =  CLIP_DEFAULT_PRECIS;
   lf.lfQuality  = DEFAULT_QUALITY;
   lf.lfPitchAndFamily = FF_DONTCARE | DEFAULT_PITCH;
   strCopy(lf.lfFaceName,_his("Times New Roman"));
   SetFont( CreateFontIndirect(&lf) );
}

void TWinControl::SetWndProc()
{
   OldWndProc = (WNDPROC)SetWindowLong(Handle,GWL_WNDPROC,(long)_WndProc);
   SetWindowLong(Handle,GWL_USERDATA,(long)this);
   InitFont();
   dc = GetDC(Handle);
   //SetBkColor(dc,255);
   //SetClassLong(Handle,-10,(long)CreateSolidBrush(255));
}

bool TWinControl::LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam)
{
  TCallStack *cs = OnMessage;
  while( cs )
  {
    if( CallCSProc(cs,Msg,wParam,lParam) )
    {
      Result = 0;
      return true;
    }
    cs = cs->Next;
  }
  switch( Msg )
  {
     case WM_CTLCOLOREDIT:
     case WM_CTLCOLORSTATIC:
     case WM_CTLCOLORBTN:
     case WM_CTLCOLORLISTBOX:
     case WM_CTLCOLORSCROLLBAR:
       Result = SendMessage((HWND)lParam,WM_SETCOLOR,wParam,0);
       return true;
     case WM_SETCOLOR:
       SetBkMode((HDC)wParam,TRANSPARENT);
       Result = (int)FColorBrush;
       return true;
     case WM_SETFOCUS:
       CallNotifyEvent(OnSetFocus,NULL);
       break;
     case WM_KILLFOCUS:
       CallNotifyEvent(OnKillFocus,NULL);
       break;
     case WM_KEYDOWN:
       CallNotifyEvent(OnKeyDown,(void *)wParam);
       return false;
     case WM_KEYUP:
       CallNotifyEvent(OnKeyUp,(void *)wParam);
       return false;
     case WM_SIZE:
       CallNotifyEvent(OnSize,NULL);
       return false;
     case WM_LBUTTONUP:
     case WM_RBUTTONUP:
       TMouseEvent me;
       me.x = LOWORD(lParam);
       me.y = HIWORD(lParam);
       me.btn = (Msg == WM_RBUTTONUP)?2:1;
       CallNotifyEvent(OnMouseUp,&me);
       return false;
     case WM_LBUTTONDOWN:
     case WM_RBUTTONDOWN:
       //TMouseEvent me;
       //MessageBox(NULL,L"ok",L"err",MB_OK);
       me.x = LOWORD(lParam);
       me.y = HIWORD(lParam);
       me.btn = (Msg == WM_RBUTTONDOWN)?2:1;
       CallNotifyEvent(OnMouseDown,&me);
       return false;
     case WM_LBUTTONDBLCLK:
       CallNotifyEvent(OnDblClick,NULL);
       return false;
     case WM_MOUSEMOVE:
       //TMouseEvent me;
       me.x = LOWORD(lParam);
       me.y = HIWORD(lParam);
       me.btn = wParam;
       CallNotifyEvent(OnMouseMove,&me);
       return false;

     /*
     case WM_SETTEXT:
       CallWindowProc(OldWndProc,Handle,Msg,wParam,lParam);
       CallNotifyEvent(OnChange,NULL);
       return true;
     */
  }
  return false;
}

void TWinControl::SetStyle(long Value)
{
   SetWindowLong(Handle,GWL_STYLE,Value);
   SetWindowPos(Handle,0,0,0,0,0,
                 SWP_NOACTIVATE|SWP_NOMOVE|SWP_NOSIZE|SWP_NOZORDER|SWP_FRAMECHANGED );
   Invalidate();
}

string TWinControl::GetCaption()
{
  int len = GetWindowTextLength(Handle)+1;
  HI_STRING buf = new HI_RSTRING[ len ];
  GetWindowText(Handle,buf,len);
  TString c;
  c = buf;
  delete buf;
  return c;
}

LRESULT TWinControl::WndProc(UINT Msg,WPARAM wParam,LPARAM lParam)
{
 int Result;
	if( LocalWndProc(Result,Msg,wParam,lParam) )
   return Result;
	else	return CallWindowProc(OldWndProc,Handle,Msg,wParam,lParam);
}

//############################################# FORM ###########################################################

// ##TForm.Body
int FormCount;

LRESULT __stdcall TmpWndProc(HWND Wnd,UINT Msg,WPARAM wParam,LPARAM lParam)
{
   return DefWindowProc(Wnd,Msg,wParam,lParam);
}

TForm::TForm(string &Caption,DWORD FStyle):TWinControl()
{
   WNDCLASS FWndClass;
   FormCount++;

   ZeroMemory(&FWndClass,sizeof(FWndClass));
   FWndClass.style = CS_HREDRAW | CS_VREDRAW;
   FWndClass.lpfnWndProc = TmpWndProc;
   FWndClass.hInstance = hInstance;
   FWndClass.hbrBackground = CreateSolidBrush(GetSysColor(COLOR_3DFACE));
   FWndClass.lpszClassName = _his("hiWindow");

   if( RegisterClass(&FWndClass) )
   {
      Handle = CreateWindow( FWndClass.lpszClassName,PChar(Caption),
                    FStyle, CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,
                    NULL,0,hInstance,NULL);
      SetWndProc();
   }
   else Handle = 0;
}

void TForm::SetBorderStyle(short Value)
{
   switch( Value )
   {
     case 0:
         Style &= ~(WS_CAPTION|WS_THICKFRAME); // none
         break;
     case 1:
         Style &= ~WS_THICKFRAME; // Single
         break;
     case 2:
         //Style &= (!(long)WS_CAPTION); // Single
         break; //Sizeble
     case 3:  //dlg
         Style &= ~(WS_THICKFRAME|WS_MAXIMIZEBOX|WS_MINIMIZEBOX);
         ExStyle |= WS_EX_DLGMODALFRAME|WS_EX_WINDOWEDGE;
         break;
     case 4:  // tool window
         Style &= ~(WS_THICKFRAME|WS_MAXIMIZEBOX|WS_MINIMIZEBOX);
         ExStyle |= WS_EX_TOOLWINDOW;
         break;
     case 5: //size tool window
         Style &= ~(WS_MAXIMIZEBOX|WS_MINIMIZEBOX);
         ExStyle |= WS_EX_TOOLWINDOW;
         break;
     case 6:
         Style &= ~(WS_CAPTION|WS_THICKFRAME);
         ExStyle |= WS_EX_DLGMODALFRAME;
         break;
     case 7:
         Style &= ~WS_CAPTION;
   }
}

bool TForm::LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam)
{
  bool ac;
  switch( Msg )
  {
    //case WM_SYSCOMMAND:
       //CallNotifyEvent(OnMouseUp,(void *)wParam);
    //   MessageBox(NULL,L"ok",L"err",MB_OK);
    //   return false;
    case WM_ACTIVATE:
       if( wParam > 0 )
         CallNotifyEvent(OnActivate,(void *)0);
       else if( wParam == 0 )CallNotifyEvent(OnActivate,(void *)1);
       break;
    case WM_ERASEBKGND:
      RECT r;
      GetWindowRect(Handle,&r);
      r.right -= r.left;
      r.bottom -= r.top;
      r.left = 0;
      r.top = 0;
      FillRect(dc,&r,FColorBrush);
      return true;
    case WM_DESTROY:
      PostQuitMessage(0);
      return true;
    case WM_CLOSE:
      ac = false;
      CallNotifyEvent(OnClose,&ac);
      Result = 0;
      return ac;
    case WM_HSCROLL:
    case WM_VSCROLL:
      if(lParam)
      {
        Result = SendMessage((HWND)lParam,WM_HSCROLL,wParam,0);
        return true;
      } return false;
    case WM_COMMAND:
      SendMessage((HWND)lParam,WM_COMMAND,HIWORD(wParam),0);
      return true;
  }
  return TWinControl::LocalWndProc(Result,Msg,wParam,lParam);
}

//############################################# BUTTON ###########################################################

// ##TButton.Body
TButton::TButton(TWinControl *_Parent, string &Caption):TWinControl()
{
 	Parent = _Parent;
 	Handle = CreateControl(Parent->Handle,_his("BUTTON"),Caption,0);
  SetWndProc();
}

bool TButton::LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam)
{
	 switch( Msg )
 	{
	   case WM_COMMAND:
      if( wParam == BN_CLICKED )
        CallNotifyEvent(OnClick,NULL);
      return true;
	 }
  return TWinControl::LocalWndProc(Result,Msg,wParam,lParam);
}

//############################################# EDIT ###########################################################

// ##TEdit.Body
TEdit::TEdit(TWinControl *_Parent, string &Caption):TWinControl()
{
   OnChange = NULL;
   Parent = _Parent;
   Handle = CreateControl(Parent->Handle,_his("EDIT"),Caption,ES_AUTOHSCROLL);
   SetWndProc();
}

bool TEdit::LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam)
{
	 switch( Msg )
 	{
	   case WM_COMMAND:
      if( wParam == EN_CHANGE )
        CallNotifyEvent(OnChange,NULL);
      return true;
	 }
   return TWinControl::LocalWndProc(Result,Msg,wParam,lParam);
}

//############################################# EDIT ###########################################################

// ##TLabel.Body
TLabel::TLabel(TWinControl *_Parent, string &Caption):TWinControl()
{
   Parent = _Parent;
   Handle = CreateControl(Parent->Handle,_his("STATIC"),Caption,0);
   SetWndProc();
}

bool TLabel::LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam)
{
	 switch( Msg )
 	{
	   case WM_COMMAND:
      //if( wParam == EN_CHANGE )
      //  CallNotifyEvent(OnChange,NULL);
      return true;
	 }
   return TWinControl::LocalWndProc(Result,Msg,wParam,lParam);
}

//############################################# RADIO ###########################################################

// ##TRadioButton.Body
TRadioButton::TRadioButton(TWinControl *_Parent, string &Caption):TWinControl()
{
 	Parent = _Parent;
 	Handle = CreateControl(Parent->Handle,_his("BUTTON"),Caption,BS_AUTORADIOBUTTON);
  SetWndProc();
}

bool TRadioButton::LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam)
{
	 switch( Msg )
 	{
	   case WM_COMMAND:
      if( wParam == BN_CLICKED )
        CallNotifyEvent(OnClick,NULL);
      return true;
	 }
  return TWinControl::LocalWndProc(Result,Msg,wParam,lParam);
}

//############################################# CHECKBOX ###########################################################

// ##TCheckBox.Body
TCheckBox::TCheckBox(TWinControl *_Parent, string &Caption):TWinControl()
{
 	Parent = _Parent;
 	Handle = CreateControl(Parent->Handle,_his("BUTTON"),Caption,BS_AUTOCHECKBOX);
  SetWndProc();
}

bool TCheckBox::LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam)
{
	 switch( Msg )
 	{
	   case WM_COMMAND:
      if( wParam == BN_CLICKED )
        CallNotifyEvent(OnClick,NULL);
      return true;
	 }
  return TWinControl::LocalWndProc(Result,Msg,wParam,lParam);
}

//############################################# SCROLLBAR ###########################################################

// ##TScrollBar.Body
TScrollBar::TScrollBar(TWinControl *_Parent,WORD _Kind):TWinControl()
{
 	Parent = _Parent;
  Handle = CreateControl(Parent->Handle,_his("SCROLLBAR"),string(_his("")),_Kind);
  SetWndProc();
  FMax = 100;
}

void TScrollBar::CreateWnd()
{

}

void TScrollBar::UpdateInfo()
{
   SCROLLINFO si;
   si.cbSize = sizeof(si);
   si.fMask = SIF_RANGE;
   si.nMax = FMax - FMin;
   si.nMin = 0;
   SetScrollInfo(Handle,SB_CTL,&si,false);
//   SetScrollRange(Handle,SB_CTL,FMin,FMax,false);
}

int TScrollBar::GetPosition()
{
   SCROLLINFO si;
   si.cbSize = sizeof(si);
   si.fMask = SIF_POS;
   GetScrollInfo(Handle,SB_CTL,&si);
   return si.nPos;
}

#define MAX(a,b) ((a)>(b))?(a):(b)
#define MIN(a,b) ((a)<(b))?(a):(b)

bool TScrollBar::LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam)
{

	 switch( Msg )
 	{
	   case WM_COMMAND:
      //if( wParam == BN_CLICKED )
      //  CallNotifyEvent(OnClick,NULL);
      return true;
    case WM_HSCROLL:
       int nPos;
       nPos = GetPosition();
       switch( LOWORD(wParam) )
       {
         case SB_LINERIGHT:
         case SB_BOTTOM: nPos++; break;
         case SB_ENDSCROLL:
             CallNotifyEvent(OnEndScroll,(void *)nPos);
             break;
         case SB_TOP:
         case SB_LINELEFT: nPos--; break;

         case SB_PAGELEFT: nPos -= 32; break;
         case SB_PAGERIGHT: nPos += 32; break;
         case SB_THUMBPOSITION: nPos = HIWORD(wParam); break;
         case SB_THUMBTRACK: nPos = HIWORD(wParam); break;
       }
       SetPosition(nPos);
       CallNotifyEvent(OnPosition,(void *)(GetPosition() + FMin));
       return false;
	 }
  return TWinControl::LocalWndProc(Result,Msg,wParam,lParam);
}
//############################################# TProgressBar ###########################################################

// ##TProgressBar.Body
TProgressBar::TProgressBar(TWinControl *_Parent,long Options):TWinControl()
{
  InitCommonControls();
 	Parent = _Parent;
 	Handle = CreateControlEx(Parent->Handle,_his("msctls_progress32"),Options);
  SetWndProc();
}

bool TProgressBar::LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam)
{
	 switch( Msg )
 	{
	 }
  return TWinControl::LocalWndProc(Result,Msg,wParam,lParam);
}

//############################################# TUpDown ###########################################################

// ##TUpDown.Body
TUpDown::TUpDown(TWinControl *_Parent,long Options):TWinControl()
{
  InitCommonControls();
 	Parent = _Parent;
 	Handle = CreateControlEx(Parent->Handle,_his("msctls_updown32"),Options);
  SetWndProc();
}

bool TUpDown::LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam)
{
	 switch( Msg )
 	{
    case WM_VSCROLL:
    case WM_HSCROLL:
     if( OnPosition )
      CallNotifyEvent(OnPosition,(void *)HIWORD(wParam));
     break;
	 }
  return TWinControl::LocalWndProc(Result,Msg,wParam,lParam);
}

//############################################# LISTBOX ###########################################################

// ##TListBox.Body
TListBox::TListBox(TWinControl *_Parent):TWinControl()
{
 	Parent = _Parent;
 	Handle = CreateControl(Parent->Handle,_his("LISTBOX"),Caption,WS_VSCROLL|LBS_NOINTEGRALHEIGHT|LBS_NOTIFY);
  SetWndProc();
  Lines = new TLBList(Handle);
}

bool TListBox::LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam)
{
	 switch( Msg )
 	{
    case WM_COMMAND:
      if( wParam == LBN_SELCHANGE )
        CallNotifyEvent(OnClick,NULL);
      break;
	 }
  return TWinControl::LocalWndProc(Result,Msg,wParam,lParam);
}
//############################################# MEMO ###########################################################

// ##TMemo.Body
TMemo::TMemo(TWinControl *_Parent,int _Style):TWinControl()
{
 	Parent = _Parent;
 	Handle = CreateControl(Parent->Handle,_his("EDIT"),Caption,ES_MULTILINE|_Style);
  SetWndProc();
  Lines = new TMemoList(Handle);
}

bool TMemo::LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam)
{
	 switch( Msg )
 	{
    case WM_COMMAND:
      if( wParam == EN_CHANGE )
      {
         Invalidate();
         CallNotifyEvent(OnChange,NULL);
       }
      break;
	 }
  return TWinControl::LocalWndProc(Result,Msg,wParam,lParam);
}

int TMemo::GetSelLength()
{
  DWORD res1,res2;
  SendMessage(Handle, EM_GETSEL, (long)&res1,(long)&res2);
  return res2 - res1;
}
void TMemo::SetSelLength(int Value)
{
  DWORD res1,res2;
  SendMessage(Handle, EM_GETSEL, (long)&res1,(long)&res2);
  res2 = res1 + Value;
  SendMessage(Handle, EM_SETSEL, res1, res2);
}

string TMemo::GetSelText()
{
  return Lines->Text.Copy(SelStart+1,SelLength);
}
void TMemo::SetSelText(string Value)
{
  SendMessage(Handle, EM_REPLACESEL, 0, (long)PChar(Value));
}


//############################################# GROUPBOX ###########################################################

// ##TGroupBox.Body
TGroupBox::TGroupBox(TWinControl *_Parent,string &Caption):TWinControl()
{
  Parent = _Parent;
  Handle = CreateControl(Parent->Handle,_his("BUTTON"),Caption,BS_GROUPBOX);
  SetWndProc();
}

bool TGroupBox::LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam)
{
	 //switch( Msg )
 	//{
	 //}
  return TWinControl::LocalWndProc(Result,Msg,wParam,lParam);
}

//############################################# PANEL ###########################################################

// ##TPanel.Body
TPanel::TPanel(TWinControl *_Parent):TWinControl()
{
  string s = _his("none");
  Parent = _Parent;
  OnMessage = NULL;
  Handle = CreateControl(Parent->Handle,_his("STATIC"),s,0);
  SetWndProc();
}

bool TPanel::LocalWndProc(int &Result,UINT Msg,WPARAM wParam,LPARAM lParam)
{
  int params[3];
//  switch( Msg ) {
//    default:
      params[0] = Msg;
      params[1] = wParam;
      params[2] = lParam;
      CallNotifyEvent(OnMessage, (void*)params);
//      break;      
//  }
  
  return TWinControl::LocalWndProc(Result,Msg,wParam,lParam);
}

//################################################################################################################

void Run(TWinControl *Form)
{
	 MSG Msg;
  while( GetMessage( &Msg,0,0,0 ) )
	 {
		  TranslateMessage( &Msg );
		  DispatchMessage( &Msg );
	 }
}

#endif
