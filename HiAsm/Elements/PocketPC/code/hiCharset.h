#ifndef __HICHARSET_H_
#define __HICHARSET_H_

#include "share.h"

class THICharset:public TDebug
{
   private:
   public:
    BYTE _prop_Type;
    THI_Event *_data_Text;
    THI_Event *_event_onCharset;

    HI_WORK_LOC(THICharset,_work_doCharset0);//##ANSI_UTF8
    HI_WORK_LOC(THICharset,_work_doCharset1);//##UTF8_ANSI
    HI_WORK_LOC(THICharset,_work_doCharset2);//##UTF8_UNICODE
    HI_WORK_LOC(THICharset,_work_doCharset3);//##UNICODE_UTF8
    HI_WORK_LOC(THICharset,_work_doCharset4);//##ANSI_UNICODE
    HI_WORK_LOC(THICharset,_work_doCharset5);//##UNICODE_ANSI
};

///////////////////////////////////////////////////////////////////////////////

string CodePage1ToCodePage2(char *s, int CodePage1, int CodePage2)
{
   int BufLen = MultiByteToWideChar(CodePage1, 0, s, -1, NULL, 0);
   if(BufLen < 1) return string(SNULL);

   HI_STRING buffer = new HI_RSTRING[BufLen + 2];
   MultiByteToWideChar(CodePage1, 0, s, -1, buffer, BufLen);
   BufLen = WideCharToMultiByte(CodePage2,0,buffer,-1,NULL,0,NULL,NULL);
   string res = string(L"none");
   if(BufLen > 1) {
      char *Result = new char[BufLen + 1];
      WideCharToMultiByte(CodePage2,0,buffer,-1,Result,BufLen,NULL,NULL);
      res = string((HI_STRING)Result);
      delete Result;
   }
   delete buffer;
   
   return res;
}

void THICharset::_work_doCharset0(TData &_Data,WORD Index)//##ANSI_UTF8
{
   _hi_onEvent(_event_onCharset,CodePage1ToCodePage2((char*)PChar(ReadString(_Data,_data_Text,SNULL)), CP_ACP, CP_UTF8));
}

void THICharset::_work_doCharset1(TData &_Data,WORD Index)//##UTF8_ANSI
{
   _hi_onEvent(_event_onCharset,CodePage1ToCodePage2((char*)PChar(ReadString(_Data,_data_Text,SNULL)), CP_UTF8, CP_ACP));
}

void THICharset::_work_doCharset2(TData &_Data,WORD Index)//##UTF8_UNICODE
{
   string s = ReadString(_Data,_data_Text,SNULL); 
   char *c = (char*)PChar(s);
   int len = MultiByteToWideChar(CP_UTF8,0,c,-1,NULL,0);
   USHORT *U = new USHORT[len+1];
   MultiByteToWideChar(CP_UTF8,0,c,-1,U,len);
   U[len] = 0;
   _hi_onEvent(_event_onCharset, string(U));
   delete U;
}

//   MessageBox(NULL, PChar(IntToStr(strlen(buf))), PChar(IntToStr(strlen("Edit7777Edit7777899"))), MB_OK);

void THICharset::_work_doCharset3(TData &_Data,WORD Index)//##UNICODE_UTF8
{
   string s = ReadString(_Data,_data_Text,SNULL);
   int l = WideCharToMultiByte(CP_UTF8,0,PChar(s),-1,NULL,0,NULL,NULL);
   int rl = l + l % 1 + 2;
   char *buf = new char[rl];
   WideCharToMultiByte(CP_UTF8,0,PChar(s),-1,buf,l,NULL,NULL);
   buf[rl-2] = '\0';
   buf[rl-1] = '\0';
   string res((HI_STRING)buf);
   _hi_onEvent(_event_onCharset, res);
   delete buf; 
}

void THICharset::_work_doCharset4(TData &_Data,WORD Index)//##ANSI_UNICODE
{
   char *c = (char*)PChar(ReadString(_Data,_data_Text,SNULL));                                                
   HI_STRING rbuf;
   AtoU(c,&rbuf); 
   _hi_onEvent(_event_onCharset,string(rbuf));
   delete rbuf;
}

void THICharset::_work_doCharset5(TData &_Data,WORD Index)//##UNICODE_ANSI
{
   string s = ReadString(_Data,_data_Text,SNULL);
   int l = WideCharToMultiByte(CP_ACP,0,PChar(s),-1,NULL,0,NULL,NULL);
   int rl = l + l % 1 + 2;
   char *buf = new char[rl];
   WideCharToMultiByte(CP_ACP,0,PChar(s),-1,buf,l,NULL,NULL);
   buf[rl-2] = '\0';
   buf[rl-1] = '\0';
   _hi_onEvent(_event_onCharset,string((HI_STRING)buf));
   delete buf;
}

#endif
