#include <windows.h>
#include "..\..\CGTShare.h"
#include "share.h"

SHELLEXECUTEINFO si6;

extern "C" __declspec(dllexport) int buildGetParamsProc(TBuildParams &params)
{
  params.flags = CGMP_RUN;
  return(CG_SUCCESS);
}

extern "C" __declspec(dllexport) int buildMakePrj(TBuildMakePrjRec &params)
{
  TFileStream f(string((PChar)params.prjFilename), 0);
  f.Write(params.result, strlen((PChar)params.result));
  return CG_SUCCESS;
}

extern "C" __declspec(dllexport) int buildCompliteProc(TBuildCompliteRec &params)
{
  return CG_SUCCESS;
}

extern "C" __declspec(dllexport) int buildRunProc(TBuildRunRec &params)
{
  ZeroMemory(&si6, sizeof(SHELLEXECUTEINFO));
  si6.cbSize = sizeof(SHELLEXECUTEINFO);
  si6.fMask = SEE_MASK_NOCLOSEPROCESS;
  si6.nShow = SW_SHOWDEFAULT;
  si6.lpVerb = ("open");
  si6.lpFile = PChar(params.FileName);
  ShellExecuteEx(&si6);
  params.data = (void *)(si6.hProcess);
  while(WaitForSingleObject(si6.hProcess, -1) == WAIT_TIMEOUT) {
  }
  return CG_SUCCESS;
}

extern "C" __declspec(dllexport) int buildStopProc(TBuildRunRec &params)
{
  TerminateProcess((HANDLE)((int)params.data), 0);
  return CG_SUCCESS;
}


int WINAPI DllMain(HINSTANCE hInstance, DWORD fdReason, PVOID pvReserved)
{
  return 0;
}

// made by "HiAsm 4.4 build 185"
