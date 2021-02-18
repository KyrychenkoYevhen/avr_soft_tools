#include "share.h"
#include "shellapi.h"

class THIDir:public TDebug
{
   private:
    static string GetDir(int Index);
   public:
    HI_WORK(_work_doDir){ CreateDirectory(PChar(ToString(_Data)),NULL); }
    HI_WORK(_var_CurrentDir){ CreateData(_Data,GetStartDir()); }
    HI_WORK(_var_WindowsDir){ CreateData(_Data,string(_his("\\Windows\\"))); }
    HI_WORK(_var_TempDir){ CreateData(_Data,string(_his("\\Temp\\"))); };
    HI_WORK(_var_ProgramsDir){ CreateData(_Data,GetDir(CSIDL_PROGRAMS)); };
    HI_WORK(_var_StartUpDir){ CreateData(_Data,GetDir(CSIDL_STARTUP)); };
    HI_WORK(_var_StartMenuDir){ CreateData(_Data,string(_his("\\Windows\\Start Menu\\"))); }; //GetDir(CSIDL_STARTMENU)
    HI_WORK(_var_FavoritesDir){ CreateData(_Data,GetDir(CSIDL_FAVORITES)); };
    HI_WORK(_var_FontsDir){ CreateData(_Data,GetDir(CSIDL_FONTS)); };
    HI_WORK(_var_HistoryDir){ CreateData(_Data,string(_his("\\Windows\\History\\"))); };
    HI_WORK(_var_MyDocumentDir){ CreateData(_Data,string(_his("\\My Documents\\"))); };
};

////////////////////////////////////////////////////////////////////

string THIDir::GetDir(int Index)
{
      HI_RSTRING buf[MAX_PATH];
      SHGetSpecialFolderPath(ReadHandle,buf,Index,false);
      string res = string(buf) + _his("\\");
      return res;
}
