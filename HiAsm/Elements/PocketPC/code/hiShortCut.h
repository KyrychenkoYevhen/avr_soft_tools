#include "share.h"
#include "shellapi.h"

class THIShortCut:public TDebug
{
   private:
   public:
    string _prop_FileName;
    string _prop_ShortcutName;

    THI_Event *_event_onCreate;

    THI_Event *_data_FileName;
    THI_Event *_data_ShortcutName;

    HI_WORK_LOC(THIShortCut,_work_doCreate);
};

////////////////////////////////////////////////////////////

void THIShortCut::_work_doCreate(TData &_Data, WORD Index)
{
  string sn = ReadString(_Data,_data_ShortcutName,_prop_ShortcutName);
  string fn = string(_his("\"")) + ReadFileName(ReadString(_Data,_data_FileName,_prop_FileName)) + string(_his("\""));
  SHCreateShortcut( PChar(sn),PChar(fn) );
  _hi_onEvent(_event_onCreate);
}
