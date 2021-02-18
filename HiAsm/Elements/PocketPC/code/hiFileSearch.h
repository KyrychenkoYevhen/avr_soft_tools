#include "share.h"
#include "hiStrMask.h"

class THIFileSearch:public TDebug
{
   private:
    int FCount;
    bool FStop;
    string FWorkExt;
    DWORD FSize;

    void Search(string &Dir);
    void OutFiles(string &Dir,string &Name);
   public:
    string _prop_Ext;
    string _prop_Dir;
    BYTE _prop_SubDir;
    bool _prop_FullName;
    BYTE _prop_Include;

    THI_Event *_data_Dir;
    THI_Event *_data_Ext;
    THI_Event *_event_onEndSearch;
    THI_Event *_event_onSearch;
    THI_Event *_event_onOtherFiles;

    HI_WORK_LOC(THIFileSearch,_work_doSearch);
    HI_WORK(_work_doStop){ _hie(THIFileSearch)->FStop = true; }
    HI_WORK(_var_Count){ CreateData(_Data,_hie(THIFileSearch)->FCount); }
    HI_WORK(_var_Size){ CreateData(_Data,(int)_hie(THIFileSearch)->FSize); }
};

////////////////////////////////////////////////////////////////

#define faReadOnly   0x00000001
#define faHidden     0x00000002
#define faSysFile    0x00000004
#define faVolumeID   0x00000008
#define faDirectory  0x00000010
#define faArchive    0x00000020
#define faAnyFile    0x0000003F

typedef struct
{
    int Time;
    int Size;
    int Attr;
    string Name;
    int ExcludeAttr;
    HANDLE FindHandle;
    WIN32_FIND_DATA FindData;
}TSearchRec;

void THIFileSearch::OutFiles(string &Dir,string &Name)
{
     string fn = Name;
     if( _prop_FullName )
        fn = Dir + fn;
     _hi_onEvent(_event_onSearch,fn);
}

void THIFileSearch::_work_doSearch(TData &_Data,WORD Index)
{
    string Dr = ReadString(_Data,_data_Dir,_prop_Dir);
    FWorkExt = ReadString(_Data,_data_Ext,_prop_Ext).Lower();
    if( Dr.Empty() ) return;
    if( Dr[Dr.Length()-1] != _his('\\') ) Dr += _his("\\");

    if( FWorkExt.Empty() )
      FWorkExt = _his("*");
    //else if FWorkExt[length(FWorkExt)] <> ';'  then
    //  FWorkExt := FWorkExt + ';';

    FCount = 0;
    FStop = false;
    Search(Dr);
    _hi_onEvent(_event_onEndSearch,FCount);
}

void FindClose(TSearchRec &F)
{
  if( F.FindHandle != INVALID_HANDLE_VALUE )
    FindClose(F.FindHandle);
}

int FindMatchingFile(TSearchRec &F)
{
    FILETIME LocalFileTime;

    while( F.FindData.dwFileAttributes & F.ExcludeAttr )
     if( !FindNextFile(F.FindHandle, &F.FindData) )
       return GetLastError();
    FileTimeToLocalFileTime(&F.FindData.ftLastWriteTime, &LocalFileTime);
    //FileTimeToDosDateTime(LocalFileTime,HIWORD(Time),LOWORD(Time));
    F.Size = F.FindData.nFileSizeLow;
    F.Attr = F.FindData.dwFileAttributes;
    F.Name = F.FindData.cFileName;

    return 0;
}

#define faSpecial faHidden|faSysFile|faVolumeID|faDirectory

int FindFirst(string &Path,int Attr,TSearchRec &F)
{
  F.ExcludeAttr = !(Attr & faSpecial);
  F.FindHandle = FindFirstFile(PChar(Path), &F.FindData);
  if( F.FindHandle != INVALID_HANDLE_VALUE )
    return FindMatchingFile(F);
  else  return GetLastError();
}

int FindNext(TSearchRec &F)
{
  if( FindNextFile(F.FindHandle, &F.FindData) )
    return FindMatchingFile(F);
  else return GetLastError();
}

void THIFileSearch::Search(string &Dir)
{
  TSearchRec SRec;

  DWORD n = FindFirst(Dir + _his("*.*"),faAnyFile,SRec);
  while( ( n == 0 )&& ( !FStop ) )
  {
     if( SRec.Name[0] != _his('.') )
      if( SRec.Attr & faDirectory )
      {
          if( _prop_Include > 0 )
            OutFiles(Dir,SRec.Name);
          if( _prop_SubDir == 0 )
            Search(Dir + SRec.Name + _his("\\"));
      }
      else if( StrCmp(SRec.Name.Lower(),FWorkExt) )
      {
          FSize = SRec.Size;
          FCount++;
          if( _prop_Include != 1 )
           OutFiles(Dir,SRec.Name);
      }
      else _hi_onEvent(_event_onOtherFiles,Dir + _his("\\") + SRec.Name);
     n = FindNext(SRec);
  }
  FindClose(SRec);
}
