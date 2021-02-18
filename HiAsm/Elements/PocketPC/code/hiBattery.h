#include "share.h"

class THIBattery:public TDebug
{
   private:
   public:
    SYSTEM_POWER_STATUS_EX2 ps;

    HI_WORK(_work_doRefresh)
    {
      GetSystemPowerStatusEx2(&_hie(THIBattery)->ps,sizeof(SYSTEM_POWER_STATUS_EX2),true);
    }
    HI_WORK(_var_BatteryLifePercent)
    {
      CreateData(_Data,(int)_hie(THIBattery)->ps.BatteryLifePercent);
    }
    HI_WORK(_var_BatteryLifeTime)
    {
      CreateData(_Data,(int)_hie(THIBattery)->ps.BatteryLifeTime);
    }
    HI_WORK(_var_BatteryFullLifeTime)
    {
      CreateData(_Data,(int)_hie(THIBattery)->ps.BatteryFullLifeTime);
    }
    HI_WORK(_var_BackupBatteryLifePercent)
    {
      CreateData(_Data,(int)_hie(THIBattery)->ps.BackupBatteryLifePercent);
    }
    HI_WORK(_var_BackupBatteryLifeTime)
    {
      CreateData(_Data,(int)_hie(THIBattery)->ps.BackupBatteryLifeTime);
    }
    HI_WORK(_var_BackupBatteryFullLifeTime)
    {
      CreateData(_Data,(int)_hie(THIBattery)->ps.BackupBatteryFullLifeTime);
    }
    HI_WORK(_var_BatteryVoltage)
    {
      CreateData(_Data,(int)_hie(THIBattery)->ps.BatteryVoltage);
    }
    HI_WORK(_var_BatteryCurrent)
    {
      CreateData(_Data,(int)_hie(THIBattery)->ps.BatteryCurrent);
    }
    HI_WORK(_var_BatteryTemperature)
    {
      CreateData(_Data,(int)_hie(THIBattery)->ps.BatteryTemperature);
    }
    HI_WORK(_var_BackupBatteryVoltage)
    {
      CreateData(_Data,(int)_hie(THIBattery)->ps.BackupBatteryVoltage);
    }
    HI_WORK(_var_BatteryChemistry)
    {
      CreateData(_Data,(int)_hie(THIBattery)->ps.BatteryChemistry);
    }
};

///////////////////////////////////////////////////////////////////////////

