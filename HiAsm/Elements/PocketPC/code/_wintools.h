/*

*/

#ifndef ___WINTOOLS_H_
#define ___WINTOOLS_H_

#include <windows.h>

HINSTANCE hInstance;

#ifndef UNICODE
   #define HI_STRING LPSTR
   #define HI_RSTRING char
   #define _his(s) s
   #define Format sprintf
   #define strCopy strcpy
#else
   #define HI_STRING USHORT *
   #define HI_RSTRING USHORT
   #define _his(s) _T(s)
   #define Format wsprintf
   #define strCopy wcscpy
#endif

//#define string HI_STRING
#define string TString
#define PChar(s) s.c_str()

inline void UtoA(USHORT *U,char *A,int Size)
{
  WideCharToMultiByte(CP_ACP,0,U,-1,A,Size,NULL,NULL);
}

inline void AtoU(char *A,USHORT **U)
{
  int len = MultiByteToWideChar(CP_ACP,0,A,-1,NULL,0);
  *U = new USHORT[len];
  MultiByteToWideChar(CP_ACP,0,A,-1,*U,len);
  (*U)[len-1] = 0;
}

inline int Length(HI_STRING Text)
{
     #ifndef UNICODE
       return strlen(Text);
     #else
       return wcslen(Text);
     #endif
}

class TString
{
  private:
   HI_STRING FBuf;
   int FLen;

   void SetText( HI_STRING Text)
   {
     #ifndef UNICODE
       int len = strlen(Text);
     #else
       int len = wcslen(Text);
     #endif
     if( len > FLen )
     {
       if(FBuf) delete FBuf;
       FLen = len;
       FBuf = new HI_RSTRING[FLen+1];
     }
     #ifndef UNICODE
       strcpy(FBuf,Text);
     #else
       wcscpy(FBuf,Text);
     #endif
   }
  public:
   TString(){ FBuf = new HI_RSTRING[1]; FBuf[0] = 0; FLen = 0;  /*MessageBox(NULL,L"ok",NULL,MB_OK);*/ }
   TString(HI_STRING Text)
   {
     //FBuf = NULL;
     //SetText(Text);
      #ifndef UNICODE
       FLen = strlen(Text);
      #else
       FLen = wcslen(Text);
      #endif
      FBuf = new HI_RSTRING[FLen+1];

      #ifndef UNICODE
       strcpy(FBuf,Text);
      #else
       wcscpy(FBuf,Text);
      #endif
   }
   TString(TString &c)
   {
      FLen = c.Length();
      FBuf = new HI_RSTRING[FLen+1];

     #ifndef UNICODE
       strcpy(FBuf,c.c_str());
     #else
       wcscpy(FBuf,c.c_str());
     #endif
   }
   ~TString(){ delete FBuf; /*MessageBox(NULL,L"del",NULL,MB_OK);*/ }
   HI_STRING c_str(){ return FBuf; }
   int Length(){ return FLen; }
   bool Empty(){ return FLen == 0; }
   string &Delete(int Start,int Count);
   string Copy(int Start,int Count);
   string &Replace(string &src,string &dest);
   string &Insert(int pos,string &dest);
   string GetTok(string &split);
   string &Upper()
   {
     #ifndef UNICODE
       FBuf = _strupr(FBuf);
     #else
       FBuf = _wcsupr(FBuf);
     #endif
     return *this;
   }
   string &Lower()
   {
     #ifndef UNICODE
       FBuf = _strlwr(FBuf);
     #else
       FBuf = _wcslwr(FBuf);
     #endif
     return *this;
   }
   int PosEx(string &Target,int Start);
   const TString& operator=(HI_STRING Text)
   {
     SetText(Text);
     return *this;
   }
   #ifdef UNICODE
   const TString& operator=(char *Text)
   {
     USHORT *buf;
     AtoU(Text,&buf);
     if(FBuf) delete FBuf;
     FBuf = buf;
     FLen = wcslen(buf);
     return *this;
   }
   #endif
   const TString& operator=(TString &Text)
   {
     SetText(Text.c_str());
     return *this;
   }
   bool operator ==(TString &Text)
   {
     #ifndef UNICODE
       return strcmp(FBuf,Text.c_str()) == 0;
     #else
       return wcscmp(FBuf,Text.c_str()) == 0;
     #endif
   }
   TString operator +(TString &Text)
   {
     TString s;
     s = *this;
     s += Text;
     return s;
   }
   TString operator +(HI_STRING Text)
   {
     return (*this + string(Text));
   }
   TString operator +(HI_RSTRING Text)
   {
     HI_RSTRING s[2];
     s[0] = Text;
     s[1] = 0;
     return (*this + string(s));
   }
   TString &operator +=(TString &Text)
   {
     HI_STRING buf = new HI_RSTRING[FLen + Text.Length()+1];
     #ifndef UNICODE
       strcpy(buf,FBuf);
       strcpy( (HI_STRING)((int)buf + FLen-1),Text.c_str());
     #else
       wcscpy(buf,FBuf);
       wcscpy( &buf[FLen],Text.c_str());
     #endif
     delete FBuf;
     FLen += Text.Length();
     FBuf = buf;
     return *this;
   }
   TString &operator +=(HI_STRING Text)
   {
      *this += string(Text);
      return *this;
   }
   HI_RSTRING operator[](int Index)
   {
      if( (Index >= 0) && (Index < FLen ) )
       return FBuf[Index];
      else return 0;
   }
};

string &TString::Delete(int Start,int Count)
{
   if( (Start > 0)&&(Start <= FLen) )
   {
      if(Count < 1)Count = 1;
      if(Count > FLen - Start + 1) Count = FLen - Start;
      #ifndef UNICODE
       strcpy(&FBuf[Start-1],&FBuf[Start+Count-1]);
      #else
       wcscpy(&FBuf[Start-1],&FBuf[Start+Count-1]);
      #endif
     FLen -= Count;
   }
   return *this;
}

string TString::Copy(int Start,int Count)
{
   if( (Start > 0)&&(Start <= FLen)&& Count )
   {
      if(Count < 1)Count = 1;
      if(Count > FLen - Start + 1) Count = FLen - Start;
      HI_STRING buf = new HI_RSTRING[Count+1];
      #ifndef UNICODE
       strncpy(buf,&FBuf[Start-1],Count);
      #else
       wcsncpy(buf,&FBuf[Start-1],Count);
      #endif
      buf[Count] = 0;
      string Res;
      Res = buf;
      delete buf;
      return Res;
   }
   else return string(_his(""));
}

string &TString::Insert(int pos,string &dest)
{
   if( pos < 0 ) pos = 0;
   if( pos > FLen ) pos = FLen;
   HI_STRING buf = new HI_RSTRING[FLen + dest.Length() + 1];
   #ifndef UNICODE
     strcpy(buf,FBuf);
     strcpy( (HI_STRING)((int)buf + pos),dest.c_str());
     strcpy( (HI_STRING)((int)buf + pos + dest.Length()),&FBuf[pos]);
   #else
     wcscpy(buf,FBuf);
     wcscpy( &buf[pos],dest.c_str());
     wcscpy( &buf[pos + dest.Length()],&FBuf[pos]);
   #endif
   delete FBuf;
   FLen += dest.Length();
   FBuf = buf;

   return *this;
}

string &TString::Replace(string &src,string &dest)
{
  int p = PosEx(src,1);
  while( p > 0 )
  {
     Delete(p,src.Length());
     Insert(p-1,dest);
     p = PosEx(src,p + dest.Length());
  }
  return *this;
}

int TString::PosEx(string &Target,int Start)
{
  HI_STRING buf = FBuf;
  if(Start <= FLen )
    buf = &buf[Start-1];
  else return 0;
  #ifdef UNICODE
   HI_STRING Res = wcsstr ( buf, Target.c_str() );
  #else
   HI_STRING Res = strstr ( buf, Target.c_str() );
  #endif
  if( Res )
    return Res - FBuf + 1;
  else return 0;
}

string TString::GetTok(string &split)
{
   int p = PosEx(split,1);
   if( p > 0 )
   {
      string Result = Copy(1,p-1);
      Delete(1,p);
      return Result;
   }
   else return *this;
}

/////////////////////////////////////////////////////////////////////

typedef struct
{
   string Name;
   BYTE  Size;
   BYTE  Style;
   int   Color;
   BYTE  CharSet;
} TFontRec, *PFontRec;

HFONT FontRecToFont(TFontRec &FontRec)
{
   LOGFONT fnt;
   ZeroMemory(&fnt,sizeof(fnt));
   fnt.lfHeight = FontRec.Size + 6;
   fnt.lfWidth = FontRec.Size / 2 + 1; //FW_NORMAL

   if( FontRec.Style & 1 )
     fnt.lfWeight = FW_BOLD;
   if( FontRec.Style & 2 )
     fnt.lfItalic = 1;
   if( FontRec.Style & 4 )
     fnt.lfUnderline = 1;
   if( FontRec.Style & 8 )
     fnt.lfStrikeOut = 1;

   strCopy(fnt.lfFaceName,FontRec.Name.c_str());
   return CreateFontIndirect(&fnt);
}

#ifndef WS_OVERLAPPEDWINDOW
 #define WS_OVERLAPPEDWINDOW (WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX)
#endif

#ifndef WS_POPUPWINDOW
 #define WS_POPUPWINDOW (WS_POPUP | WS_BORDER | WS_SYSMENU)
#endif

#ifndef WS_CHILDWINDOW
 #define WS_CHILDWINDOW (WS_CHILD)
#endif

//******************
typedef void TNotifyMethod(void *ClassPointer,void *Param);

typedef struct
{
  TNotifyMethod *Method;
  void *ClassPointer;
}TNotifyEvent;

TNotifyEvent *DoNotifyEvent(void *ClassPointer,TNotifyMethod *Method)
{
   TNotifyEvent *Event = new TNotifyEvent;
   Event->Method = Method;
   Event->ClassPointer = ClassPointer;
   return Event;
}

#define CallNotifyEvent(Event,Param) if(Event) Event->Method(Event->ClassPointer,Param)
//******************

HWND CreateControl(HWND WndParent,HI_STRING ClassName,string &Caption,long Style )
{
   return CreateWindow(ClassName,PChar(Caption),WS_CHILD | WS_TABSTOP | Style,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,WndParent,0,hInstance,NULL);
}

HWND CreateControlEx(HWND WndParent,HI_STRING ClassName,long Style )
{
   return CreateWindowEx(0,ClassName,NULL,WS_CHILD | WS_TABSTOP | Style,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,WndParent,0,hInstance,NULL);
}

string GetStartDir()
{
   HI_RSTRING buf[1024];
   buf[ GetModuleFileName(hInstance,buf,1024) ] = 0;
   int i = Length(buf)-1;
   while( buf[i] != _his('\\') ) i--;
   buf[i+1] = 0;
   //MessageBox(NULL,buf,L"OK",MB_OK);
   return string(buf);
}

int FileSize(string &fn)
{
   HANDLE f = CreateFile(PChar(fn),GENERIC_READ,FILE_SHARE_READ,NULL,OPEN_EXISTING,0,NULL);
   int Res = GetFileSize(f,NULL);
   CloseHandle(f);
   return Res;
}

bool FileExists(string Name)
{
  int Code;
  Code = GetFileAttributes(PChar(Name));
  return (Code != -1);// && (FILE_ATTRIBUTE_DIRECTORY & Code == 0);
}

#define ToRGB(Value) ((Value&0x80000000)?GetSysColor(Value&0xFF|SYS_COLOR_INDEX_FLAG):Value)

#endif
