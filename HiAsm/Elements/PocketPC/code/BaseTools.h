///////////////////////////////////////////////////////////////////////
//            -----    HiAsm for PocketPC    -----                   //
//      Альтернативная библиотека классов работы со строками         //
//         и потоками                            Create by Dilma     //
///////////////////////////////////////////////////////////////////////

/*
   ##TList
   ##TStrList
   ##TStream
   ##TFileStream
   ##TMemoryStream
*/

#ifndef __BASETOOLS_H__
#define __BASETOOLS_H__

#include "_wintools.h"

// ##TList
class TList
{
  protected:
    virtual string &Get(int Index) = 0;
  public:
    virtual void Add(string &s) = 0;
    virtual void Insert(int Index,string &s) = 0;
    virtual void Delete(int Index) = 0;
    virtual void Clear() = 0;
    virtual void LoadFromFile(string &FName);
    virtual void SaveToFile(string &FName);
    virtual int Count() = 0;

    virtual void SetText(string &Value);
    virtual string GetText();
    __declspec( property( put = SetText,get = GetText ) )string Text;

    string &operator[](int Index){ if((Index >= 0)&&(Index < Count())) return Get(Index); }
};

void TList::LoadFromFile(string &FName)
{
   string fn;
   fn = FName;
   #ifdef UNICODE
    FILE *f = _wfopen(PChar(fn),_his("r"));
   #else
    FILE *f = fopen(PChar(fn),_his("r"));
   #endif
   if( f )
   {
      int pos = FileSize(fn);
      char *buf = new char[pos+1];
      fread(buf,1,pos,f);
      buf[pos] = '\0';
      
      #ifdef UNICODE
       HI_STRING rbuf;
       AtoU(buf,&rbuf);
       SetText( string(rbuf) );
       delete rbuf;
      #else
       SetText( string(buf) );
      #endif
      delete buf;
   }
   fclose(f);
}

void TList::SaveToFile(string &FName)
{
   string fn;
   fn = GetStartDir() + FName;
   #ifdef UNICODE
    FILE *f = _wfopen(PChar(fn),_his("w"));
   #else
    FILE *f = fopen(PChar(fn),_his("w"));
   #endif
   if( f )
   {
      for(int i = 0; i < Count(); i++)
      {
        #ifdef UNICODE
         fputws(PChar(Get(i)),f);
         fputws(_his("\n"),f);
        #else
         fputs(PChar(Get(i)),f);
         fputs(_his("\n"),f);
        #endif
      }
   }
   fclose(f);
}

string TList::GetText()
{
   if( !Count() ) return string(_his(""));
   string s;
   string p = _his("\r\n");
   for(int i = 0; i < Count(); i++)
     s += Get(i) + p;
   return s;
}

void TList::SetText(string &Value)
{
   HI_STRING buf = Value.c_str();
   buf[Value.Length() - 1];
   HI_STRING start;
   start = buf;
   while( *buf )
   {
     buf++;
     if( *buf == _his('\n') )
     {
        HI_STRING k = buf;
        if( (k != start)&& k-- && ( *k == _his('\r') ) )
          *k = 0;
        else
        {
          k = NULL;
          *buf = 0;
        }
        Add(string(start));
        if( k )
        {
          *k = _his('\r');
        }
        else  *buf = _his('\n');
        buf++;
        start = buf;
     }
   }
   if( start != buf )
     Add(string(start));
}

///////////////////////////////////////////////////////////////////

// ##TStrList
class TStrList:public TList
{
  private:
    string **FItems;
    int FCount;
    int FAllocate;
  protected:
    string &Get(int Index);
  public:
    void Add(string &s);
    void Insert(int Index,string &s);
    void Delete(int Index);
    void Clear();
    int Count(){ return FCount; }
};

void TStrList::Add(string &s)
{
   if( !FCount )
   {
     FAllocate = 10;
     FItems = (string **)malloc( FAllocate*sizeof(string *));
   }
   else if( FCount == FAllocate )
   {
     FAllocate = 1.1*FCount;
     string **Items = (string **)new int[FAllocate];
     for(int i = 0; i < FCount; i++)
      Items[i] = FItems[i];
     delete FItems;
     FItems = Items;
   }
   FItems[FCount] = new string();
   *FItems[FCount++] = s;
}

string &TStrList::Get(int Index)
{
  return *FItems[Index];
}

void TStrList::Insert(int Index,string &s)
{
   Add(s);
   string *tmp;
   tmp = FItems[FCount-1];
   for(int i = Index; i < FCount-1; i++)
     FItems[i+1] = FItems[i];
   FItems[Index] = tmp;
}

void TStrList::Delete(int Index)
{
   delete FItems[Index];
   for(int i = Index; i < FCount-1; i++)
     FItems[i] = FItems[i+1];
   FCount--;
}

void TStrList::Clear()
{
   for(int i = 0; i < FCount; i++)
    delete FItems[i];
   delete FItems;
   FCount = 0;
   FAllocate = 0;
}

///////////////////////////////////////////////////////////////////

// ##TStream
class TStream
{
  protected:
  public:
   virtual int Read(void *buf,int Size) = 0;
   virtual int Write(void *buf,int Size) = 0;
   virtual int Size() = 0;
   virtual int GetPosition() = 0;
   virtual void SetPosition(int Value) = 0;
   virtual void CopyFrom(TStream *Stream);
   __declspec( property( put = SetPosition, get = GetPosition )) int Position;
};

// ##TFileStream
class TFileStream:public TStream
{
  private:
   FILE *f;
   int FSize;
  protected:
  public:
   TFileStream(string &FileName,string &Mode);
   ~TFileStream(){ fclose(f); }
   int Read(void *buf,int Size){ return fread(buf,1,Size,f); }
   int Write(void *buf,int Size){ return fwrite(buf,1,Size,f); }
   int Size() { return FSize; }
   int GetPosition();
   void SetPosition(int Value){ __int64 p = Value; fsetpos(f,&p); }
};

// ##TMemoryStream
class TMemoryStream:public TStream
{
  protected:
   int FPosition;
   int FAllocate;
   int FSize;
  public:
   void *Memory;

   TMemoryStream() { FSize = FAllocate = FPosition = 0; Memory = NULL; }
   int Read(void *buf,int Size);
   int Write(void *buf,int Size);
   int Size(){ return FSize; }
   int GetPosition(){ return FPosition; }
   void Clear(){ delete Memory; Memory = NULL; FSize = FAllocate = FPosition = 0; }
   void SetPosition(int Value){ FPosition = (Value > FSize)?FSize:Value; }
};

//________________________________________________________________________

void TStream::CopyFrom(TStream *Stream)
{
  Stream->Position = 0;
  char buf[4096];
  while( Stream->Position < Stream->Size() )
    Write(buf,Stream->Read(buf,4096));
}

//________________________________________________________________________

TFileStream::TFileStream(string &FileName,string &Mode)
{
  FSize = FileSize(FileName);
  #ifdef UNICODE
   f = _wfopen(PChar(FileName),PChar(Mode));
  #else
   f = fopen(PChar(FileName),PChar(Mode));
  #endif
}
                     
int TFileStream::GetPosition()
{
  fpos_t pos;
  fgetpos(f,&pos);
  return pos;
}

/*
int TFileStream::Size()
{
  fseek(f, 0, SEEK_END); 
  int p = GetPosition();
  fseek(f, 0, SEEK_SET);
  return p;
}
*/

/////////////////////

int TMemoryStream::Read(void *buf,int Size)
{
  if( (FPosition == FSize)|| (!Memory) ) return 0;
  int RSize;
  RSize = (Size <= FSize - FPosition)?Size:(FSize - FPosition);
  memcpy(buf,(void *)( (int)Memory + FPosition),RSize);
  FPosition += RSize;
  return RSize;
}

int TMemoryStream::Write(void *buf,int Size)
{
  int NSize = (FPosition + Size > FSize)?(FPosition + Size):FSize;

  if(FAllocate < NSize)
  {
    FAllocate = 1.5*NSize;

    if(Memory)
    {
      void *tmp = Memory;
      Memory = new char[FAllocate];
      memcpy(Memory,tmp,FSize);
      delete tmp;
    }
    else
      Memory = new char[FAllocate];
  }
  FSize = NSize;

  memcpy((void *)((int)Memory + FPosition),buf,Size);
  FPosition += Size;
  return Size;
}

#endif
