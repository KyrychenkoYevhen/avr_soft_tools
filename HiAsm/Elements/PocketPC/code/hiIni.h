#include "share.h"
#include "IniFile.h"

class THIini:public TDebug
{
     private:
      TIniFile *Ini;

      void Open(TData &_Data)
      {
        Ini = new TIniFile(ReadFileName(ReadString(_Data,_data_FileName,_prop_FileName)));
      }
      void Close(){ delete Ini; }
     public:
      string _prop_FileName;
      string _prop_Section;
      string _prop_Key;
      BYTE _prop_Type;

      THI_Event *_data_FileName;
      THI_Event *_data_Section;
      THI_Event *_data_Key;
      THI_Event *_data_Value;

     THI_Event *_event_onResult;

     HI_WORK_LOC( _work_doRead);
     procedure _work_doWrite(var _Data:TData; Index:word);
     procedure _work_doDeleteKey(var _Data:TData; Index:word);
     procedure _work_doEraseSection(var _Data:TData; Index:word);
     procedure _work_doClearAll(var _Data:TData; Index:word);
};

//////////////////////////////////////////////////////////////////

void THIini::_work_doRead()
{
   Open(_Data);
   if( _prop_Type == 0 )
    _hi_onEvent(_event_onResult,
      Ini->ReadInt(ReadString(_Data,_data_Key,_prop_Key),0));
   else
     _hi_onEvent(_event_onResult,
      Ini->ReadStr(ReadString(_Data,_data_Key,_prop_Key),''));
   Close();
}

procedure THIini._work_doWrite;
begin
   Open(_Data,ifmWrite);
   if _prop_Type = 0 then
     Ini.ValueInteger(ReadString(_Data,_data_Key,_prop_Key),
                     ReadInteger(_Data,_data_Value,0))
   else
     Ini.ValueString(ReadString(_Data,_data_Key,_prop_Key),
                     ReadString(_Data,_data_Value,''));
   Close;
end;

procedure THIini._work_doDeleteKey;
begin
   Open(_Data,ifmWrite);
   Ini.ClearKey(ReadString(_Data,_data_Key,_prop_Key));
   Close;
end;

procedure THIini._work_doEraseSection;
begin
   Open(_Data,ifmWrite);
   Ini.ClearSection;
   Close;
end;

procedure THIini._work_doClearAll;
begin
   Open(_Data,ifmWrite);
   Ini.ClearAll;
   Close;
end;

end.
