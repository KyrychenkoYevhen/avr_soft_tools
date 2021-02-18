#include "share.h"

typedef TData TdtProc (TStream *st, TData *Val);

class THIDataToFile:public TDebug
{
   public:
    TdtProc *_prop_Type;
    THI_Event *_event_onGet;
    THI_Event *_data_Stream;

    HI_WORK_LOC(THIDataToFile,_work_doPut);
    HI_WORK_LOC(THIDataToFile,_var_Data);
    HI_WORK_LOC(THIDataToFile,_work_doGet);
};

///////////////////////////////////////////////////////////////////////////

void THIDataToFile::_work_doPut(TData &_Data, WORD Index)
{
   TData dt;
   dt.data_type = data_null;
   TStream *st = ReadStream(dt,_data_Stream,NULL);
   if( st )
     _prop_Type(st,&_Data);
}

void THIDataToFile::_var_Data(TData &_Data, WORD Index)
{
   TData dt;
   dt.data_type = data_null;
   TStream *st = ReadStream(dt,_data_Stream,NULL);
   if( st )
     _Data = _prop_Type(st,NULL);
}

void THIDataToFile::_work_doGet(TData &_Data, WORD Index)
{
   TData dt;
   _var_Data(dt,0);
   _hi_CreateEvent(_Data,_event_onGet,dt);
}

TData dtByte(TStream *st,TData *val)
{
   TData Result;
   BYTE b;
   if( !val )
   {
      st->Read(&b,1);
      CreateData(Result,(int)b);
   }
   else
   {
      b = ToInteger(*val);
      st->Write(&b,1);
   }
   return Result;
}

TData dtWord(TStream *st,TData *val)
{
   TData Result;
   WORD b;
   if( !val )
   {
      st->Read(&b,2);
      CreateData(Result,(int)b);
   }
   else
   {
      b = ToInteger(*val);
      st->Write(&b,2);
   }
   return Result;
}

TData dtCardinal(TStream *st,TData *val)
{
   TData Result;
   long b;
   if( !val )
   {
      st->Read(&b,4);
      CreateData(Result,(int)b);
   }
   else
   {
      b = ToInteger(*val);
      st->Write(&b,4);
   }
   return Result;
}

TData dtInteger(TStream *st,TData *val)
{
   TData Result;
   int b;
   if( !val )
   {
      st->Read(&b,4);
      CreateData(Result,b);
   }
   else
   {
      b = ToInteger(*val);
      st->Write(&b,4);
   }
   return Result;
}

TData dtReal(TStream *st,TData *val)
{
   TData Result;
   float b;
   if( !val )
   {
      st->Read(&b,sizeof(float));
      CreateData(Result,b);
   }
   else
   {
      b = ToReal(*val);
      st->Write(&b,sizeof(float));
   }
   return Result;
}

TData dtPString(TStream *st,TData *val)
{
   TData Result;
   WORD len;
   string s;
   if( !val )
   {
      st->Read(&len,2);
      if( len )
      {
       char *buf = new char[len];
       st->Read(buf,len);
       s = buf;
       delete buf;
      }
      CreateData(Result,s);
   }
   else
   {
      s = ToString(*val);
      len = s.Length();
      st->Write(&len,2);
      st->Write(s.c_str(),len);
   }
   return Result;
}

TData dtAnsiString(TStream *st,TData *val)
{
   TData Result;
   //Result.Data_type := data_str;
   //if val = nil then
   //  Result.sdata := st.ReadStrZ
   //else  st.WriteStrZ(ToString(val^));
   return Result;
}

TData dtLines(TStream *st,TData *val)
{
   TData Result;
   //Result.Data_type := data_str;
   //if val = nil then
   //  Result.sdata := st.ReadStr
   //else  st.WriteStr(ToString(val^));
   return Result;
}
