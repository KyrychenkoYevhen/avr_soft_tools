#ifndef __HITIMER_H_
#define __HITIMER_H_

#include <Windows.h>
#include "Share.h"

class  THITimer
{
   private:
    int FTimer;
    int AutoStop;
    int AutoStopDEF;

    void Start();
    void Stop();

    void OnStop();
   public:
    int _prop_Interval;

    THI_Event *_event_onTimer;
    THI_Event *_event_onStop;

    ~THITimer(){ Stop(); }
    void OnTimer();
    void SetAutoStop(int Value);
    __declspec( property( put = SetAutoStop ) )int _prop_AutoStop;
    void SetEnable(bool Value);
    __declspec( property( put = SetEnable ) )bool _prop_Enable;
    HI_WORK_LOC(THITimer,_work_doTimer);
    HI_WORK_LOC(THITimer,_work_doStop);
    HI_WORK_LOC(THITimer,_work_doInterval);
    HI_WORK_LOC(THITimer,_work_doAutoStop);
};

//#############################################################################

void __stdcall TimerProc(HWND hwnd,UINT uMsg,UINT idEvent,DWORD dwTime)
{
  ((THITimer *)idEvent)->OnTimer();
  //return 0;
}

void THITimer::OnTimer()
{
   _hi_onEvent(_event_onTimer);

   if( AutoStop == 1)
     OnStop();
   else if( AutoStop > 1 )
     AutoStop--;
}

void THITimer::Start()
{
   if(FTimer) Stop();
   FTimer = SetTimer(ReadHandle,(long)this,_prop_Interval,TimerProc);
}

void THITimer::Stop()
{
   KillTimer(ReadHandle,FTimer);
   FTimer = 0;
}

void THITimer::_work_doTimer(TData &_Data,USHORT Index)
{
   AutoStop = AutoStopDEF;
   Start();
}

void THITimer::_work_doStop(TData &_Data,USHORT Index)
{
   OnStop();
}

void THITimer::_work_doInterval(TData &_Data,USHORT Index)
{
   Stop();
   _prop_Interval = ToInteger(_Data);
   Start();
}

void THITimer::_work_doAutoStop(TData &_Data,USHORT Index)
{
   AutoStopDEF = ToInteger(_Data);
   AutoStop = AutoStopDEF;
}

void THITimer::SetEnable(bool Value)
{
   if(Value)
     Start();
}

void THITimer::SetAutoStop(int Value)
{
   AutoStop = Value;
   AutoStopDEF = Value;
}

void THITimer::OnStop()
{
   Stop();
   _hi_onEvent(_event_onStop);
}

#endif
