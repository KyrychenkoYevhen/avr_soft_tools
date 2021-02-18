#ifndef __SHARE_H_
#define __SHARE_H_

#include "basetools.h"

#define nil NULL
#define SNULL string(_his(""))
#define True true
#define False false

#define data_null 0
#define data_int  1
#define data_str  2
#define data_real 3
#define data_stream 10
#define data_bitmap 11

HWND ReadHandle = NULL;

//флаг запрета прохода всех событий
bool EventEnabled = false;

struct TData;
typedef void TMethod(void *ClassPointer,TData &_Data,USHORT Index);

typedef struct
{
  TMethod *Method;
  USHORT Index;
  void *ClassPointer;
}THI_Event;

struct TData
{
  BYTE data_type;
  int idata;
  string sdata;
  float rdata;
  THI_Event *Next;
  TData &operator =(TData &_Data);
};

TData &TData::operator =(TData &_Data)
{
  data_type = _Data.data_type;
  idata = _Data.idata;
  rdata = _Data.rdata;
  sdata = _Data.sdata;
  return *this;
}

class TDebug
{
};

THI_Event *_DoEvent(void *ClassPointer, TMethod *Method,USHORT Index)
{
   THI_Event *Event = new THI_Event;
   Event->Method = Method;
   Event->Index = Index;
   Event->ClassPointer = ClassPointer;
   return Event;
}
#define _hie(type) ((type *)ClassPointer)
#define HI_WORK(Method) static void Method(void *ClassPointer,TData &_Data,USHORT Index)
#define HI_WORK_CLASS(Class,Method) void Class::Method(void *ClassPointer,TData &_Data,USHORT Index)
#define HI_WORK_LOC(Class,Method) HI_WORK(Method) { ((Class *)ClassPointer)->Method(_Data,Index); } void Method(TData &_Data,USHORT Index)

////////////// CreateData ///////////////

inline void CreateData(TData &Dest,TData &Value)
{
  Dest.data_type = Value.data_type;
  Dest.idata = Value.idata;
  Dest.rdata = Value.rdata;
  Dest.sdata = Value.sdata;
}

inline void CreateData(TData &Dest, int Value)
{
  Dest.data_type = data_int;
  Dest.idata = Value;
}

inline void CreateData(TData &Dest, string &Value)
{
  Dest.data_type = data_str;
  Dest.sdata = Value;
}

inline void CreateData(TData &Dest, float Value)
{
  Dest.data_type = data_real;
  Dest.rdata = Value;
}

inline void CreateData(TData &Dest, TStream *Value)
{
  Dest.data_type = data_stream;
  Dest.idata = (int)Value;
}

////////////// _hi_onEvent ///////////////

void _hi_onEvent_Empty(THI_Event *Event,TData &_Data);

typedef void T_hi_onEvent(THI_Event *Event,TData &_Data);
T_hi_onEvent *_hi_onEvent_proc = _hi_onEvent_Empty;

#define EventOn  _hi_onEvent_proc = _hi_onEvent_Full
#define EventOff _hi_onEvent_proc = _hi_onEvent_Empty

void _hi_onEvent_Empty(THI_Event *Event,TData &_Data)
{
}

void _hi_onEvent_Full(THI_Event *Event,TData &_Data)
{
   while( Event )
   {
       Event->Method(Event->ClassPointer,_Data,Event->Index);
       if( (_Data.data_type & 0x80) == 0 ) break;
       _Data.data_type -= 0x80;
       Event = _Data.Next;
   }
}

inline void _hi_onEvent(THI_Event *Event,TData &_Data)
{
  _hi_onEvent_proc(Event,_Data);
}

inline void _hi_onEvent(THI_Event *Event,int Value)
{
  TData dt;
  CreateData(dt,Value);
  _hi_onEvent(Event,dt);
}

inline void _hi_onEvent(THI_Event *Event,string &Value)
{
  TData dt;
  CreateData(dt,Value);
  _hi_onEvent(Event,dt);
}

inline void _hi_onEvent(THI_Event *Event,float Value)
{
  TData dt;
  CreateData(dt,Value);
  _hi_onEvent(Event,dt);
}

inline void _hi_onEvent(THI_Event *Event,TStream *Value)
{
  TData dt;
  CreateData(dt,Value);
  _hi_onEvent(Event,dt);
}

inline void _hi_onEvent(THI_Event *Event)
{
  if(Event)
  {
    TData dt;
    dt.data_type = data_null;
    _hi_onEvent(Event,dt);
  }
}

void _ReadData(TData &_Data,THI_Event *Event)
{
   if( Event )
     _hi_onEvent(Event,_Data);
   else _Data.data_type = data_null;
}

////////////// _hi_CreateEvent /////////////// 

inline void  _hi_CreateEvent (TData& _Data, THI_Event* Event) 
{ 
  _Data.data_type = data_null + 0x80; 
  _Data.Next = Event;
} 

inline void _hi_CreateEvent(TData& _Data, THI_Event* Event, TData &Data)
{ 
  _Data = Data; 
  _Data.data_type += 0x80; 
  _Data.Next = Event;
} 

inline void _hi_CreateEvent(TData& _Data, THI_Event* Event, int Data) 
{ 
  _Data.data_type = data_int + 0x80; 
  _Data.idata = Data; 
  _Data.Next = Event;
} 

inline void _hi_CreateEvent(TData& _Data, THI_Event* Event, float Data) 
{ 
  _Data.data_type = data_real + 0x80; 
  _Data.rdata = Data; 
  _Data.Next = Event;
} 

inline void _hi_CreateEvent(TData& _Data, THI_Event* Event, string &Data)
{ 
  _Data.data_type = data_str + 0x80; 
  _Data.sdata = Data; 
  _Data.Next = Event;
}

inline void _hi_CreateEvent(TData& _Data, THI_Event* Event, TStream *Data)
{ 
  _Data.data_type = data_stream + 0x80;
  _Data.idata = (int)Data;
  _Data.Next = Event;
}

/////////////////////////////////////

#define _debug(Value) MessageBox(NULL,_his(Value),NULL,MB_OK)

inline TData _DoData(string &Text)
{
  TData dt;// = new TData;
  dt.data_type = data_str;
  dt.sdata = Text;
  return dt;
}

inline TData _DoData(HI_STRING Text)
{
  TData dt;// = new TData;
  dt.data_type = data_str;
  dt.sdata = Text;
  return dt;
}

inline TData _DoData(int Value)
{
  TData dt;// = new TData;
  dt.data_type = data_int;
  dt.idata = Value;
  return dt;
}

inline TData _DoData(float Value)
{
  TData dt;// = new TData;
  dt.data_type = data_real;
  dt.rdata = Value;
  return dt;
}

string IntToStr(int Value)
{
  string c;
  HI_RSTRING its_buf[10];
  #ifdef UNICODE
   _itow(Value,its_buf,10);
  #else
   _itoa(Value,its_buf,10);
  #endif
  c = its_buf;
  return c;
}

int StrToInt(string &Value)
{
  #ifdef UNICODE
   return _wtoi(PChar(Value));
  #else
   return atoi(PChar(Value));
  #endif
}

float StrToFloat(string Value)
{
  #ifdef UNICODE
   char buf[30];
   WideCharToMultiByte(CP_ACP,0,PChar(Value),-1,buf,30,NULL,NULL);
   return atof(buf);
  #else
   return atof(PChar(Value));
  #endif
}

string FloatToStr(float Value)
{
  string c;
  HI_RSTRING its_buf[10];
  #ifdef UNICODE
   swprintf(its_buf,_his("%f"),Value);
   int i = wcslen(its_buf)-1;
   while( (its_buf[i] == L'0')&&(its_buf[i-1] != L'.') ) its_buf[i--] = 0;
  #else
   sprintf(its_buf,_his("%f"),Value);
  #endif
  c = its_buf;
  return c;
}

string ToString(TData &_Data)
{
    switch( _Data.data_type )
    {
      case data_int:  return IntToStr(_Data.idata);
      case data_str:  return _Data.sdata;
      case data_real: return FloatToStr(_Data.rdata);
      default: string c; return c;
    }
}

int ToInteger(TData &_Data)
{
    switch( _Data.data_type )
    {
      case data_int:  return _Data.idata;
      case data_str:  return StrToInt(_Data.sdata);
      case data_real: return (int)_Data.rdata;
      default: return 0;
    }
}

float ToReal(TData &_Data)
{
    switch( _Data.data_type )
    {
      case data_int:  return _Data.idata;
      case data_str:  return StrToFloat(_Data.sdata);
      case data_real: return _Data.rdata;
      default: return 0;
    }
}

inline TStream *ToStream(TData &_Data)
{
    if( _Data.data_type == data_stream )
     return (TStream *)_Data.idata;
    else return NULL;
}

int ToIntIndex(TData &Data)
{
   switch( Data.data_type )
   {
      case data_int : return Data.idata;
      case data_real: return (int)Data.rdata;
      case data_str:
       {
         int Result;
         Result = StrToInt(Data.sdata);
         if( !Data.sdata.Length() ) //|| ( !Result &&(Data.sdata[1] != "0")then
           return -1;
         else return Result;
       }
      default: return -1;
   }
}

int ReadInteger(TData &_Data,THI_Event *Event,int Def)
{
   int Result;
   if(Event)
   {
     TData dt;
     dt.data_type = data_null;
     _hi_onEvent(Event,dt);
     Result = ToInteger(dt);
   }
   else if( !Def && _Data.data_type )
   {
      Result = ToInteger(_Data);
      _Data.data_type = data_null;
   }
   else Result = Def;
   return Result;
}

string ReadString(TData &_Data,THI_Event *Event,string &Def)
{
   if (Event)
   {
      TData dt;
      dt.data_type = data_null;
      _hi_onEvent(Event,dt);
      return ToString(dt);
   }
   else if( Def.Empty() && _Data.data_type )
   {
      string Result = ToString(_Data);
      //TData dt;
      //CreateData(dt,_Data);
      _Data.data_type = data_null;
      return Result;
   }
   else return Def;
}

float ReadReal(TData &_Data,THI_Event *Event,float Def)
{
   float Result;
   if(Event)
   {
     TData dt;
     dt.data_type = data_null;
     _hi_onEvent(Event,dt);
     Result = ToReal(dt);
   }
   else if( !Def && _Data.data_type )
   {
      Result = ToReal(_Data);
      _Data.data_type = data_null;
   }
   else Result = Def;
   return Result;
}

bool ReadBool(TData &_Data)
{
   if( _Data.data_type == data_int )
     return (_Data.idata != 0);
   else return true;
}

int ReadColor(TData &_Data,THI_Event *Event,int Def)
{
  int i = ReadInteger(_Data,Event,Def);
  return ToRGB(i);
}

TData ReadData(TData &_Data,THI_Event *Event,TData *Def)
{
   TData Result;
   if(Event)
   {
     Result.data_type = data_null;
     _hi_onEvent(Event,Result);
   }
   else if( !Def ||( Def->data_type == data_null ) )
   {
     Result = _Data;
     _Data.data_type = data_null;
   }
   else
    if(!Def)
      Result.data_type = data_null;
    else Result = *Def;
   return Result;
}

TStream *ReadStream(TData &_Data,THI_Event *Event,TStream *Def)
{
   if(Event)
   {
      TData dt;
      dt.data_type = data_null;
      _hi_onEvent(Event,dt);
      if( dt.data_type == data_stream )
        return (TStream *)dt.idata;
      else return NULL;
   }
   else if( !Def &&(_Data.data_type == data_stream) )
   {
      TStream *Result = (TStream *)_Data.idata;
      _Data.data_type = 0;
      return Result;
   }
   else return Def;
}

string ReadFileName(string &fn)
{
   //Result := WinDirs(FName);
   if( FileExists( GetStartDir() + fn) )
     return GetStartDir() + fn;
   else return fn;
}


///////////////////////////////////////////////////////////////////////////

#define _IsStream(d) (d.data_type == data_stream)
#define _IsBitmap(d) (d.data_type == data_bitmap)

///////////////////////////////////////////////////////////////////////////

bool operator ==(TData &op1,TData &op2)
{
  if( op1.data_type == op2.data_type )
  {
    switch(op1.data_type)
    {
      case data_null: return true;
      case data_int : return op1.idata == op2.idata;
      case data_real: return op1.rdata == op2.rdata;
      case data_str : return op1.sdata == op2.sdata;
      default: return false;
    }
  }
  else return false;
}

///////////////////////////////////////////////////////////////////////////

class TInitMan
{
  private:
   TNotifyEvent **Items;
   int Count;
  public:
   void Add(TNotifyEvent *Proc)
   {
     Items = (TNotifyEvent **)realloc(Items,sizeof(void *)*(Count+1));
     Items[Count++] = Proc;
   }
   void Init()
   {
     for(int i = 0; i < Count; i++)
      CallNotifyEvent(Items[i],NULL);
   }
}InitMan;

///////////////////////////////////////////////////////////////////////////

LPVOID LoadResData(string &Data)
{
   HRSRC Res = FindResource(hInstance,PChar(Data),_his("#100"));
   HGLOBAL hResource = LoadResource(hInstance,Res);
   LPVOID Result = LockResource(hResource);
   //FreeResource(hResource);
   return Result;
}

#define NewMemoryStream new TMemoryStream()

TMemoryStream *LoadResStream(string &Data)
{
   TMemoryStream *Result = new TMemoryStream();

   HRSRC hRes = FindResource(hInstance,PChar(Data),_his("#100"));
   HGLOBAL hResource = LoadResource(hInstance,hRes);
   int Size = SizeofResource(hInstance,hRes);
   void *p = LockResource(hResource);
   Result->Write(p,Size);
   Result->Position = 0;
   //FreeResource(hResource);
   return Result;
}

TFontRec hiCreateFont(string Name,BYTE Size, BYTE Style,int Color,BYTE CharSet)
{
   TFontRec Result;
   Result.Name = Name;
   Result.Size = Size;
   Result.Style = Style;
   Result.Color = Color;
   Result.CharSet = CharSet;
   return Result;
}

#define EventArray(Value) (THI_Event **)new int[Value]

#endif
