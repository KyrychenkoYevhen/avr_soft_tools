#include "share.h"

class THIConvertor:public TDebug
{
   private:
   public:
    BYTE _prop_Mode;
    int _prop_Digits;
    THI_Event *_data_Data;
    THI_Event *_event_onResult;

    HI_WORK_LOC(THIConvertor,_work_doConvert0);//##IntToStr
    HI_WORK_LOC(THIConvertor,_work_doConvert1);//##StrToInt
    HI_WORK_LOC(THIConvertor,_work_doConvert2);//##RealToInt
    HI_WORK_LOC(THIConvertor,_work_doConvert3);//##CharToInt
    HI_WORK_LOC(THIConvertor,_work_doConvert4);//##IntToChar
    HI_WORK_LOC(THIConvertor,_work_doConvert5);//##HexToInt
    HI_WORK_LOC(THIConvertor,_work_doConvert6);//##IntToHex
    HI_WORK_LOC(THIConvertor,_work_doConvert7);//##BinToInt
    HI_WORK_LOC(THIConvertor,_work_doConvert8);//##IntToBin
    HI_WORK_LOC(THIConvertor,_work_doConvert9);//##RealToStr
    HI_WORK_LOC(THIConvertor,_work_doConvert10);//##StrToReal
    HI_WORK_LOC(THIConvertor,_work_doConvert11);//##StreamToStr
    HI_WORK_LOC(THIConvertor,_work_doConvert12);//##StrToStream
};

//function Hex2Int(st:string):integer;

///////////////////////////////////////////////////////////////////////////////

void THIConvertor::_work_doConvert0(TData &_Data,WORD Index)//##IntToStr
{
  _hi_CreateEvent(_Data,_event_onResult,IntToStr(ReadInteger(_Data,_data_Data,0)));
}

void THIConvertor::_work_doConvert1(TData &_Data,WORD Index)//##StrToInt
{
  _hi_CreateEvent(_Data,_event_onResult,StrToInt(ReadString(_Data,_data_Data,SNULL)));
}

void THIConvertor::_work_doConvert2(TData &_Data,WORD Index)//##RealToInt
{
  _hi_CreateEvent(_Data,_event_onResult,(int)ReadReal(_Data,_data_Data,0));
}

void THIConvertor::_work_doConvert3(TData &_Data,WORD Index)//##CharToInt
{
  string s = ReadString(_Data,_data_Data,SNULL);
  int b;
  if( s.Empty() ) b = 0;
  else b = (int)s[0];
  _hi_CreateEvent(_Data,_event_onResult,b);
}

void THIConvertor::_work_doConvert4(TData &_Data,WORD Index)//##IntToChar
{
  HI_RSTRING buf[2];
  buf[0] = ReadInteger(_Data,_data_Data,0);
  buf[1] = 0;
  _hi_CreateEvent(_Data,_event_onResult,string(buf));
}

int HexToInt(string st)
{
   st = st.Lower();
   char *buf;
   #ifdef UNICODE
    buf = new char[st.Length()+1];
    UtoA(st.c_str(),buf,st.Length());
   #else
    buf = st.c_str();
   #endif
   int Result = 0;
   for(int i = 0; i < st.Length(); i++)
    if( (buf[i] >= '0')&&(buf[i] <= '9') )
      Result = (Result << 4) + (buf[i] - '0');
    else if( (buf[i] >= 'a')&&(buf[i] <= 'f') )
      Result = (Result << 4) + (buf[i] - 'a' + 10);
    else break;
   #ifdef UNICODE
    delete buf;
   #endif
   return Result;
}

string IntToHex(int Value,int Dig)
{
  HI_STRING k = _his("0123456789abcdef");
  string s;

  HI_RSTRING buf[10];
  buf[9] = 0;
  int ind = 8;
  while( Value )
  {
     buf[ind--] = k[Value & 0xf];
     Value = Value >> 4;
  }
  while( ind &&(8 - ind < Dig) )
   buf[ind--] = _his('0');

  return string(&buf[ind+1]);
}

void THIConvertor::_work_doConvert5(TData &_Data,WORD Index)//##HexToInt
{
  _hi_CreateEvent(_Data,_event_onResult,HexToInt(ReadString(_Data,_data_Data,SNULL)));
}

void THIConvertor::_work_doConvert6(TData &_Data,WORD Index)//##IntToHex
{
  _hi_CreateEvent(_Data,_event_onResult,IntToHex(ReadInteger(_Data,_data_Data,0),_prop_Digits));
}

void THIConvertor::_work_doConvert7(TData &_Data,WORD Index)//##BinToInt
{
  string st = ReadString(_Data,_data_Data,string(_his("")));
  int bin = 0;
  for(int i = 0; i < st.Length();i++)
   if( (st[i] < _his('0'))||(st[i] > _his('1'))) break;
   else bin = (bin << 1) | ((st[i] == _his('1'))?1:0);

  _hi_CreateEvent(_Data,_event_onResult,bin);
}

void THIConvertor::_work_doConvert8(TData &_Data,WORD Index)//##IntToBin
{
  int Value = ReadInteger(_Data,_data_Data,0);

  string s;

  HI_RSTRING buf[2];
  if( Value == 0 ) s = string(_his("0\0"));

  buf[1] = 0;
  while( Value > 0 )
  {
     buf[0] = (Value & 1)?_his('1'):_his('0');
     s = string(buf) + s;
     Value = Value >> 1;
  }
  _hi_CreateEvent(_Data,_event_onResult,s);
}

void THIConvertor::_work_doConvert9(TData &_Data,WORD Index)//##RealToStr
{
  _hi_CreateEvent(_Data,_event_onResult,FloatToStr(ReadReal(_Data,_data_Data,0)));
}

void THIConvertor::_work_doConvert10(TData &_Data,WORD Index)//##StrToReal
{
  _hi_CreateEvent(_Data,_event_onResult,StrToFloat(ReadString(_Data,_data_Data,SNULL)));
}

void THIConvertor::_work_doConvert11(TData &_Data,WORD Index)//##StreamToStr
{
  TStream *St = ReadStream(_Data,_data_Data,NULL);
  if( !St ) return;
  int len = St->Size();
  string s(_his(""));
  if(len) {
     char *buf = new char[len];
     St->SetPosition(0);
     St->Read(buf,len);
     #ifdef UNICODE
     USHORT *ubuf = NULL;
     AtoU(buf, &ubuf);
     s = ubuf;
     delete ubuf;
     #else
     s = buf;
     #endif
  }
  _hi_CreateEvent(_Data,_event_onResult, s);
}

void THIConvertor::_work_doConvert12(TData &_Data,WORD Index)//##StrToStream
{
  string S = ReadString(_Data,_data_Data,SNULL);
  TMemoryStream *St = new TMemoryStream();
  //len := Length(S);
  //St.Write(s[1],len);
  //St.Position := 0;
  _hi_onEvent(_event_onResult,St);
  delete St;
}
