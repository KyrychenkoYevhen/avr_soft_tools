#include "share.h" 


class THIBTTools: public TDebug
{ 
  private: 
  public: 
   HI_WORK_LOC(THIBTTools,_work_doEnabled);
};

////////////////////////////////////////////////////////////////

// CBt_projDlg message handlers
// 0 -- off, 1 -- on, -1 -- does not exist 
int GetWidcommStatus()  
{
   HKEY hMainKey = NULL; 
   // Check connection existance 
   if (RegOpenKeyEx(HKEY_LOCAL_MACHINE, L"SOFTWARE\\Widcomm\\BtConfig\\General", 0, KEY_ALL_ACCESS, &hMainKey) == ERROR_SUCCESS)  
   {
      DWORD dwTmp = 0; 
      DWORD dwSize = 4; 
      DWORD dwRes = 0; 
      if ((RegQueryValueEx(hMainKey, L"StackMode", NULL, &dwRes, (BYTE*)&dwTmp, &dwSize) != ERROR_SUCCESS) || (dwRes != REG_DWORD))  
         dwTmp = 0; 
       
      RegCloseKey(hMainKey); 
      if (dwTmp == 0) return 0; 
   }
   else return -1; 
   return 1; 
}

void WidcommConnect(bool _bConnect)
{
  HWND hWnd = FindWindow(_his("WCE_BTTRAY"), _his("Bluetooth Console"));
  SendMessage(hWnd, WM_COMMAND, (_bConnect)?0x01002:0x01001, 0);
  /*
  if (_bConnect)
  {
    int iStatus = GetWidcommStatus();
    if (iStatus == -1)
    {
      return -1;
    }
    HWND hWnd = FindWindow(L"WCE_BTTRAY", L"Bluetooth Console");
    if (hWnd == NULL) return -2;
    if (iStatus == 0)
    {
      SendMessage(hWnd, WM_COMMAND, 0x01002, 0);
      for (int i=0; i<50; i++)
      {
        if (GetWidcommStatus() == 1) break;
        Sleep(100);
        if (i > 35) return -3;
      }
    }
    return 0;
  }
  else
  {
    if (GetWidcommStatus() == 1)
    {
       HWND hWnd = FindWindow(L"WCE_BTTRAY", L"Bluetooth Console");
       SendMessage(hWnd, WM_COMMAND, 0x01001, 0);
    }
    return 0;
  }
  return 0;
  */
}

void THIBTTools::_work_doEnabled(TData &_Data,WORD Index)
{
   WidcommConnect(ReadBool(_Data));
}
