#ifndef __REGISTRY_H_
#define __REGISTRY_H_

#include "share.h"

class THIRegistry:public TDebug
{
   private:
   public:
    string _prop_Data;
    string _prop_Key;
    string _prop_Value;
    int _prop_HKey;
    int _prop_DataType;
    bool _prop_NotEmpty;

    THI_Event *_data_Data;
    THI_Event *_data_Key;
    THI_Event *_data_Value;
    THI_Event *_event_onRead;

    THIRegistry() { _data_Data = _data_Key = _data_Value = _event_onRead = NULL; }
    HI_WORK_LOC(THIRegistry,_work_doWrite);
    HI_WORK_LOC(THIRegistry,_work_doRead);
};

///////////////////////////////////////////////////////////////

const HKEY _HKey[4] = {HKEY_CLASSES_ROOT,HKEY_CURRENT_USER,HKEY_LOCAL_MACHINE,HKEY_USERS};
const int _RTypes[3] = {REG_DWORD, REG_SZ, REG_SZ};

bool OpenKey(HKEY root, string key, bool CanCreate, HKEY *reg) {
   ULONG disp = 0;
   HKEY TempKey = 0;
   int Access = 0;
   
   if(CanCreate)
     return RegCreateKeyEx(root, PChar(key), 0, NULL, REG_OPTION_NON_VOLATILE, Access, NULL, reg, &disp) == ERROR_SUCCESS;
   else
     return RegOpenKeyEx(root, PChar(key), 0, Access, reg) == ERROR_SUCCESS;
}

void THIRegistry::_work_doWrite(TData &_Data,WORD Index)
{
    string dt = ReadString(_Data,_data_Data,_prop_Data);
    string key = ReadString(_Data,_data_Key,_prop_Key);
    string value = ReadString(_Data,_data_Value,_prop_Value);
    
    HKEY reg = NULL;

    if(OpenKey(_HKey[_prop_HKey], key, true, &reg)) {
       unsigned char *Buffer;
       int BufSize;
       int ival;
       string sval;
       
       switch(_prop_DataType) {
          case 0:
             ival = StrToInt(dt);
             Buffer = (unsigned char *)&ival;
             BufSize = sizeof(ival);
             break;
          case 1:
          case 2:
             Buffer = (unsigned char *)PChar(dt);
             #ifdef UNICODE
             BufSize = dt.Length()*2;
             #else
             BufSize = dt.Length();
             #endif 
             break;              
       }
       RegSetValueEx(reg, PChar(value), 0, _RTypes[_prop_DataType], Buffer, BufSize);
       RegCloseKey(reg);
    }
}

int GetDataSize(HKEY key, string &value) {
  ULONG DataType;
  ULONG len;
  RegQueryValueEx(key, PChar(value), NULL, &DataType, NULL, &len);
  return len; 
}

void THIRegistry::_work_doRead(TData &_Data,WORD Index)
{
    string key = ReadString(_Data,_data_Key,_prop_Key);
    string value = ReadString(_Data,_data_Value,_prop_Value);
    
    HKEY reg = NULL;

    string val = _his("");
    if(OpenKey(_HKey[_prop_HKey], key, false, &reg)) {
       ULONG BufSize = GetDataSize(reg, value);
       unsigned char *Buffer = new unsigned char[BufSize];
       ULONG DataType = 0;
       
       if(RegQueryValueEx(reg, PChar(value), NULL, &DataType, Buffer, &BufSize) == ERROR_SUCCESS) {
          switch(DataType) {
            case REG_SZ:
            case REG_EXPAND_SZ:
               val = (HI_STRING)Buffer;
               break;
            case REG_DWORD:
               val = IntToStr(*(int*)Buffer);
               break;
          }
          _hi_onEvent(_event_onRead, val);
       }
       else if(_prop_NotEmpty)
         _hi_onEvent(_event_onRead, val);
       RegCloseKey(reg);
    }
}
#endif
