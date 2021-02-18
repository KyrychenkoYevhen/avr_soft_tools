#include "share.h"

class THIMath
{
   private:
    bool _Err;
    float Res;
    float Def;
    float AngleMode;
   public:
    BYTE _prop_OpType;
    float _prop_Op1;
    float _prop_Op2;
    BYTE _prop_ResultType;

    THI_Event *_event_onResult;
    THI_Event *_event_onError;
    THI_Event *_data_Op1;
    THI_Event *_data_Op2;

    HI_WORK_LOC(THIMath,_work_doOperation0 );
    HI_WORK_LOC(THIMath, _work_doOperation1 );
    HI_WORK_LOC(THIMath, _work_doOperation2 );
    HI_WORK_LOC(THIMath, _work_doOperation3 );
    HI_WORK_LOC(THIMath, _work_doOperation4 );
    HI_WORK_LOC(THIMath, _work_doOperation5 );
    HI_WORK_LOC(THIMath, _work_doOperation6 );
    HI_WORK_LOC(THIMath, _work_doOperation7 );
    HI_WORK_LOC(THIMath, _work_doOperation8 );
    HI_WORK_LOC(THIMath, _work_doOperation9 );
    HI_WORK_LOC(THIMath, _work_doOperation10);
    HI_WORK_LOC(THIMath, _work_doOperation11);
    HI_WORK_LOC(THIMath, _work_doOperation12);
    HI_WORK_LOC(THIMath, _work_doOperation13);
    HI_WORK_LOC(THIMath, _work_doOperation14);
    HI_WORK_LOC(THIMath, _work_doOperation15);
    HI_WORK_LOC(THIMath, _work_doOperation16);
    HI_WORK_LOC(THIMath, _work_doOperation17);
    HI_WORK_LOC(THIMath, _work_doOperation18);
    HI_WORK_LOC(THIMath, _work_doOperation19);
    HI_WORK_LOC(THIMath, _work_doOperation20);
    HI_WORK_LOC(THIMath, _work_doOperation21);
    HI_WORK_LOC(THIMath, _work_doOperation22);
    HI_WORK_LOC(THIMath, _work_doOperation23);
    HI_WORK_LOC(THIMath, _work_doOperation24);
    HI_WORK_LOC(THIMath, _work_doOperation25);
    HI_WORK_LOC(THIMath, _work_doOperation26);
    HI_WORK_LOC(THIMath, _work_doOperation27);
    HI_WORK_LOC(THIMath, _work_doOperation28);
    HI_WORK_LOC(THIMath, _work_doOperation29);
    HI_WORK_LOC(THIMath, _work_doOperation30);
    HI_WORK_LOC(THIMath, _work_doOperation31);
    HI_WORK_LOC(THIMath, _work_doOperation32);
    HI_WORK_LOC(THIMath, _work_doOperation33);
    HI_WORK_LOC(THIMath, _work_doOperation34);
    HI_WORK_LOC(THIMath, _work_doOperation35);
    HI_WORK_LOC(THIMath, _work_doOperation36);
    HI_WORK_LOC(THIMath, _work_doOperation37);
    HI_WORK_LOC(THIMath, _work_doOperation38);
    HI_WORK_LOC(THIMath, _work_doOperation39);
    HI_WORK_LOC(THIMath, _work_doClear);
    HI_WORK_LOC(THIMath, _var_Result);

    void SetDefault(float Value);
    void SetAngleMode(BYTE Value);

    __declspec( property( put = SetDefault ) ) float _prop_Default;
    __declspec( property( put = SetAngleMode ) ) BYTE _prop_AngleMode;
};

//#############################################################################

#define digE 2.718281828459045
#define Round(x) (int)x
#define pi 3.1415

void THIMath::SetDefault(float Value)
{
  Def = Value;
  Res = Def;
  _Err = false;
}

void THIMath::SetAngleMode(BYTE Value)
{
  if( Value == 0 ) AngleMode = 1;
  else AngleMode = pi/180;
}

void THIMath::_work_doClear(TData &_Data,WORD Index)
{
  Res = Def;
  _Err = false;
}

void THIMath::_var_Result(TData &_Data,WORD Index)
{
  if( _Err ) _Data.data_type = data_null;
  else if( _prop_ResultType == 0 )
  {
    CreateData(_Data,(int)Res);
  }
  else
  {
    CreateData(_Data,Res);
  }
}

void THIMath::_work_doOperation0(TData &_Data,WORD Index) //{+}
{
  float op1 = ReadReal(_Data,_data_Op1,_prop_Op1);
  Res = ReadReal(_Data,_data_Op2,_prop_Op2);
  _Err = false;
  Res += op1;
  if( _prop_ResultType == 0 )
    _hi_onEvent(_event_onResult,(int)Res);
  else _hi_onEvent(_event_onResult,Res);
}

void THIMath::_work_doOperation1(TData &_Data,WORD Index) //{-}
{
  float op1 = ReadReal(_Data,_data_Op1,_prop_Op1);
  Res = ReadReal(_Data,_data_Op2,_prop_Op2);
  _Err = false;
  Res = op1 - Res;
  if( _prop_ResultType == 0 )
    _hi_onEvent(_event_onResult,(int)Res);
  else _hi_onEvent(_event_onResult,Res);
}

void THIMath::_work_doOperation2(TData &_Data,WORD Index) //{*}
{
  float op1 = ReadReal(_Data,_data_Op1,_prop_Op1);
  Res = ReadReal(_Data,_data_Op2,_prop_Op2);
  _Err = false;
  Res *= op1;
  if( _prop_ResultType == 0 )
    _hi_onEvent(_event_onResult,(int)Res);
  else _hi_onEvent(_event_onResult,Res);
}

void THIMath::_work_doOperation3(TData &_Data,WORD Index) //{/}
{
  float op1 = ReadReal(_Data,_data_Op1,_prop_Op1);
  Res = ReadReal(_Data,_data_Op2,_prop_Op2);
  _Err = Res == 0;
  if( _Err )
  {
    Res = Def;
    _hi_onEvent(_event_onError);
  }
  else
  {
    Res = op1 / Res;
    if( _prop_ResultType == 0 )
    _hi_onEvent(_event_onResult,(int)Res);
    else _hi_onEvent(_event_onResult,Res);
  }
}

void THIMath::_work_doOperation4(TData &_Data,WORD Index) //{and}
{
  float op1 = ReadReal(_Data,_data_Op1,_prop_Op1);
  Res = ReadReal(_Data,_data_Op2,_prop_Op2);
  _Err = false;
  Res = (int)op1 & (int)Res;
  if( _prop_ResultType == 0 )
    _hi_onEvent(_event_onResult,(int)Res);
  else _hi_onEvent(_event_onResult,Res);
}

void THIMath::_work_doOperation5(TData &_Data,WORD Index) //{or}
{
  float op1 = ReadReal(_Data,_data_Op1,_prop_Op1);
  Res = ReadReal(_Data,_data_Op2,_prop_Op2);
  _Err = false;
  Res = (int)op1 | (int)Res;
  if( _prop_ResultType == 0 )
    _hi_onEvent(_event_onResult,(int)Res);
  else _hi_onEvent(_event_onResult,Res);
}

void THIMath::_work_doOperation6(TData &_Data,WORD Index) //{xor}
{
  float op1 = ReadReal(_Data,_data_Op1,_prop_Op1);
  Res = ReadReal(_Data,_data_Op2,_prop_Op2);
  _Err = false;
  Res = (int)op1 ^ (int)Res;
  if( _prop_ResultType == 0 )
    _hi_onEvent(_event_onResult,Round(Res));
  else _hi_onEvent(_event_onResult,Res);
}

void THIMath::_work_doOperation7(TData &_Data,WORD Index) //{div}
{
  float op1 = ReadReal(_Data,_data_Op1,_prop_Op1);
  int op2 = Round(ReadReal(_Data,_data_Op2,_prop_Op2));
  _Err = op2 == 0;
  if( _Err )
  {
    Res = Def;
    _hi_onEvent(_event_onError);
  }
  else {
    Res = Round(op1) / op2;
    if( _prop_ResultType == 0 )
    _hi_onEvent(_event_onResult,Round(Res));
    else _hi_onEvent(_event_onResult,Res);
  }
}

void THIMath::_work_doOperation8(TData &_Data,WORD Index) //{mod}
{
  float op1 = ReadReal(_Data,_data_Op1,_prop_Op1);
  int op2 = Round(ReadReal(_Data,_data_Op2,_prop_Op2));
  _Err = op2 == 0;
  if( _Err )
  {
    Res = Def;
    _hi_onEvent(_event_onError);
  }
  else
  {
    Res = Round(op1) % op2;
    if( _prop_ResultType == 0 )
    _hi_onEvent(_event_onResult,Round(Res));
    else _hi_onEvent(_event_onResult,Res);
  }
}

void THIMath::_work_doOperation9(TData &_Data,WORD Index) //{shl}
{
  float op1 = ReadReal(_Data,_data_Op1,_prop_Op1);
  Res = ReadReal(_Data,_data_Op2,_prop_Op2);
  _Err = false;
  Res = Round(op1) << Round(Res);
  if( _prop_ResultType == 0 )
    _hi_onEvent(_event_onResult,Round(Res));
  else _hi_onEvent(_event_onResult,Res);
}

void THIMath::_work_doOperation10(TData &_Data,WORD Index) //{shr}
{
  float op1 = ReadReal(_Data,_data_Op1,_prop_Op1);
  Res = ReadReal(_Data,_data_Op2,_prop_Op2);
  _Err = false;
  Res = Round(op1) >> Round(Res);
  if( _prop_ResultType == 0 )
    _hi_onEvent(_event_onResult,Round(Res));
  else _hi_onEvent(_event_onResult,Res);
}
/*
function Power(var X, Exponent: real):boolean;
{
  Result = true;               { 0**n = 0, n > 0 }
  if( Exponent = 0.0 )
    X = 1.0                    { n**0 = 1 }
  else if( (X = 0.0) ) {
    if( (Exponent < 0.0) ) Result = false }
  else if( (Frac(Exponent)=0.0)and(System.Abs(Exponent)<=MaxInt) )
    X = IntPower(X, Integer(Trunc(Exponent)))
  else if( (X > 0.0) ) X = Exp(Exponent*Ln(X))
  else Result = false
}
*/

void THIMath::_work_doOperation11(TData &_Data,WORD Index) //{X^Y}
{
  /*
  float op1 = ReadReal(_Data,_data_Op1,_prop_Op1);
  Res = ReadReal(_Data,_data_Op2,_prop_Op2);
  _Err = false;
  if( _Err )
  {
    Res = Def;
    _hi_onEvent(_event_onError);
  }
  else
  {
    Res = op1**Res;
    if( _prop_ResultType == 0 )
       _hi_onEvent(_event_onResult,Round(Res));
    else _hi_onEvent(_event_onResult,Res);
  }
  */
}

void THIMath::_work_doOperation12(TData &_Data,WORD Index) //{cos}
{
  Res = ReadReal(_Data,_data_Op1,_prop_Op1);
  _Err = false;
  Res = cos(Res*AngleMode);
  if( _prop_ResultType == 0 )
    _hi_onEvent(_event_onResult,Round(Res));
  else _hi_onEvent(_event_onResult,Res);
}

void THIMath::_work_doOperation13(TData &_Data,WORD Index) //{sin}
{
  Res = ReadReal(_Data,_data_Op1,_prop_Op1);
  _Err = false;
  Res = sin(Res*AngleMode);
  if( _prop_ResultType == 0 )
    _hi_onEvent(_event_onResult,Round(Res));
  else _hi_onEvent(_event_onResult,Res);
}

void THIMath::_work_doOperation14(TData &_Data,WORD Index) //{tg}
{
  float op1 = ReadReal(_Data,_data_Op1,_prop_Op1);
  Res = cos(op1*AngleMode);
  _Err = Res == 0;
  if( _Err )
  {
    Res=Def;
    _hi_onEvent(_event_onError);
  }
  else {
    Res = sin(op1*AngleMode)/Res;
    if( _prop_ResultType == 0 )
    _hi_onEvent(_event_onResult,Round(Res));
    else _hi_onEvent(_event_onResult,Res);
  }
}

void THIMath::_work_doOperation15(TData &_Data,WORD Index) //{ctg}
{
  float op1 = ReadReal(_Data,_data_Op1,_prop_Op1);
  Res = sin(op1*AngleMode);
  _Err = Res==0;
  if( _Err )
  {
    Res=Def;
    _hi_onEvent(_event_onError);
   }
  else {
    Res = cos(op1*AngleMode)/Res;
    if( _prop_ResultType == 0 )
    _hi_onEvent(_event_onResult,Round(Res));
    else _hi_onEvent(_event_onResult,Res);
  }
}

void THIMath::_work_doOperation16(TData &_Data,WORD Index) //{arccos}
{
  /*
  Res = ReadReal(_Data,_data_Op1,_prop_Op1);
  _Err = (Res>1)or(Res<-1);
  if( _Err )
  {
    Res=Def;
    _hi_onEvent(_event_onError)
  }
  else
  {
    Res = ArcTan2(sqrt(1-Res*Res),Res)/AngleMode;
    if( _prop_ResultType = 0 )
    _hi_onEvent(_event_onResult,integer(Round(Res)))
    else _hi_onEvent(_event_onResult,Res)
  }
  */
}

void THIMath::_work_doOperation17(TData &_Data,WORD Index) //{arcsin}
{
  /*
  Res = ReadReal(_Data,_data_Op1,_prop_Op1);
  _Err = (Res>1)or(Res<-1);
  if( _Err ) {
    Res=Def;
    _hi_onEvent(_event_onError)
   }
  else {
    Res = ArcTan2(Res,sqrt(1-Res*Res))/AngleMode;
    if( _prop_ResultType = 0 )
    _hi_onEvent(_event_onResult,integer(Round(Res)))
    else _hi_onEvent(_event_onResult,Res)
  }
  */
}

void THIMath::_work_doOperation18(TData &_Data,WORD Index) //{atan}
{
   /*
  op1 = ReadReal(_Data,_data_Op1,_prop_Op1);
  Res = ReadReal(_Data,_data_Op2,_prop_Op2);
  _Err=false;
  Res = ArcTan2(op1,Res)/AngleMode;
  if( _prop_ResultType = 0 )
    _hi_onEvent(_event_onResult,integer(Round(Res)))
  else _hi_onEvent(_event_onResult,Res);
  */
}

void THIMath::_work_doOperation19(TData &_Data,WORD Index) //{ch}
{
  Res = ReadReal(_Data,_data_Op1,_prop_Op1);
  Res = exp(Res);
  _Err = false;
  Res = (Res+1/Res)/2;
  if( _prop_ResultType == 0 )
    _hi_CreateEvent(_Data,_event_onResult,(int)Res);
  else _hi_CreateEvent(_Data,_event_onResult,Res);
}

void THIMath::_work_doOperation20(TData &_Data,WORD Index) //{sh}
{
  Res = ReadReal(_Data,_data_Op1,_prop_Op1);
  Res = exp(Res);
  _Err = false;
  Res = (Res-1/Res)/2;
  if( _prop_ResultType == 0 )
    _hi_CreateEvent(_Data,_event_onResult,(int)Res);
  else _hi_CreateEvent(_Data,_event_onResult,Res);
}

void THIMath::_work_doOperation21(TData &_Data,WORD Index) //{th}
{
  Res = ReadReal(_Data,_data_Op1,_prop_Op1);
  Res = exp(2*Res);
  _Err = false;
  Res = (Res-1)/(Res+1);
  if( _prop_ResultType == 0 )
    _hi_CreateEvent(_Data,_event_onResult,(int)Res);
  else _hi_CreateEvent(_Data,_event_onResult,Res);
}

void THIMath::_work_doOperation22(TData &_Data,WORD Index) //{cth}
{
  /*
  Res = ReadReal(_Data,_data_Op1,_prop_Op1);
  _Err = Res=0;
  if( _Err ) {
    Res=Def;
    _hi_onEvent(_event_onError)
   }
  else {
    Res = exp(2*Res);
    Res = (Res+1)/(Res-1);
    if( _prop_ResultType = 0 )
      _hi_onEvent(_event_onResult,integer(Round(Res)))
    else _hi_onEvent(_event_onResult,Res)
  }
  */
}

void THIMath::_work_doOperation23(TData &_Data,WORD Index) //{arcch}
{
  /*
  Res = ReadReal(_Data,_data_Op1,_prop_Op1);
  _Err = Res<1;
  if( _Err ) {
    Res=Def;
    _hi_onEvent(_event_onError)
   }
  else {
    Res = LogN(digE,Res+sqrt(Res*Res-1));
    if( _prop_ResultType = 0 )
    _hi_onEvent(_event_onResult,integer(Round(Res)))
    else _hi_onEvent(_event_onResult,Res)
  }
  */
}

void THIMath::_work_doOperation24(TData &_Data,WORD Index) //{arcsh}
{
  /*
  Res = ReadReal(_Data,_data_Op1,_prop_Op1);
  _Err=false;
  Res = LogN(digE,Res+sqrt(Res*Res+1));
  if( _prop_ResultType = 0 )
    _hi_onEvent(_event_onResult,integer(Round(Res)))
  else _hi_onEvent(_event_onResult,Res);
  */
}

void THIMath::_work_doOperation25(TData &_Data,WORD Index) //{arcth}
{
  /*
  Res = ReadReal(_Data,_data_Op1,_prop_Op1);
  _Err = (Res>=1)or(Res<=-1);
  if( _Err ) {
    Res=Def;
    _hi_onEvent(_event_onError)
   }
  else {
    Res = LogN(digE,(1+Res)/(1-Res))/2;
    if( _prop_ResultType = 0 )
    _hi_onEvent(_event_onResult,integer(Round(Res)))
    else _hi_onEvent(_event_onResult,Res)
  }
  */
}

void THIMath::_work_doOperation26(TData &_Data,WORD Index) //{arccth}
{
  /*
  Res = ReadReal(_Data,_data_Op1,_prop_Op1);
  _Err = (Res<=1)and(Res>=-1);
  if( _Err ) {
    Res=Def;
    _hi_onEvent(_event_onError)
   }
  else {
    Res = LogN(digE,(Res+1)/(Res-1))/2;
    if( _prop_ResultType = 0 )
    _hi_onEvent(_event_onResult,integer(Round(Res)))
    else _hi_onEvent(_event_onResult,Res)
  }
  */
}

void THIMath::_work_doOperation27(TData &_Data,WORD Index) //{log}
{
  /*
  op1 = ReadReal(_Data,_data_Op1,_prop_Op1);
  Res = ReadReal(_Data,_data_Op2,_prop_Op2);
  _Err = (op1<=0)or(Res<=0);
  if( _Err ) {
    Res=Def;
    _hi_onEvent(_event_onError)
   }
  else {
    Res = LogN(op1,Res);
    if( _prop_ResultType = 0 )
    _hi_onEvent(_event_onResult,integer(Round(Res)))
    else _hi_onEvent(_event_onResult,Res)
  }
  */
}

void THIMath::_work_doOperation28(TData &_Data,WORD Index) //{lg}
{
  /*
  Res = ReadReal(_Data,_data_Op1,_prop_Op1);
  _Err = Res<=0;
  if( _Err ) {
    Res=Def;
    _hi_onEvent(_event_onError)
   }
  else {
    Res = LogN(10,Res);
    if( _prop_ResultType = 0 )
    _hi_onEvent(_event_onResult,integer(Round(Res)))
    else _hi_onEvent(_event_onResult,Res)
  }
  */
}

void THIMath::_work_doOperation29(TData &_Data,WORD Index) //{ln}
{
  /*
  Res = ReadReal(_Data,_data_Op1,_prop_Op1);
  _Err = Res<=0;
  if( _Err ) {
    Res=Def;
    _hi_onEvent(_event_onError)
   }
  else {
    Res = LogN(digE,Res);
    if( _prop_ResultType = 0 )
    _hi_onEvent(_event_onResult,integer(Round(Res)))
    else _hi_onEvent(_event_onResult,Res)
  }
  */
}

void THIMath::_work_doOperation30(TData &_Data,WORD Index) //{exp}
{
  Res = ReadReal(_Data,_data_Op1,_prop_Op1);
  _Err = false;
  Res = exp(Res);
  if( _prop_ResultType == 0 )
    _hi_CreateEvent(_Data,_event_onResult,(int)Res);
  else _hi_CreateEvent(_Data,_event_onResult,Res);
}

void THIMath::_work_doOperation31(TData &_Data,WORD Index) //{sqr}
{
  Res = ReadReal(_Data,_data_Op1,_prop_Op1);
  _Err = false;
  Res *= Res;
  if( _prop_ResultType == 0 )
    _hi_CreateEvent(_Data,_event_onResult,(int)Res);
  else _hi_CreateEvent(_Data,_event_onResult,Res);
}

void THIMath::_work_doOperation32(TData &_Data,WORD Index) //{sqrt}
{
  Res = ReadReal(_Data,_data_Op1,_prop_Op1);
  _Err = Res < 0;
  if( _Err )
  {
    Res = Def;
    _hi_CreateEvent(_Data,_event_onError);
   }
  else {
    Res = sqrt(Res);
    if( _prop_ResultType == 0 )
    _hi_CreateEvent(_Data,_event_onResult,(int)Res);
    else _hi_CreateEvent(_Data,_event_onResult,Res);
  }
}

void THIMath::_work_doOperation33(TData &_Data,WORD Index) //{abs}
{
  Res = ReadReal(_Data,_data_Op1,_prop_Op1);
  _Err = false;
  if( Res < 0 ) Res = -Res;
  if( _prop_ResultType == 0 )
    _hi_CreateEvent(_Data,_event_onResult,(int)Res);
  else _hi_CreateEvent(_Data,_event_onResult,Res);
}

void THIMath::_work_doOperation34(TData &_Data,WORD Index) //{sign}
{
  Res = ReadReal(_Data,_data_Op1,_prop_Op1);
  _Err = false;
  if( Res < 0 ) Res = -1;
  else if( Res > 0 ) Res = 1;

  if( _prop_ResultType == 0 )
    _hi_CreateEvent(_Data,_event_onResult,(int)Res);
  else _hi_CreateEvent(_Data,_event_onResult,Res);
}

void THIMath::_work_doOperation35(TData &_Data,WORD Index) //{round}
{
  float op1 = ReadReal(_Data,_data_Op1,_prop_Op1);
  Res = ReadReal(_Data,_data_Op2,_prop_Op2);
  _Err = Res==0;
  if( _Err ) {
    Res=Def;
    _hi_onEvent(_event_onError);
   }
  else {
    Res = (Round((op1/Res)))*Res;
    if( _prop_ResultType == 0 )
    _hi_onEvent(_event_onResult,Round(Res));
    else _hi_onEvent(_event_onResult,Res);
  }
}

void THIMath::_work_doOperation36(TData &_Data,WORD Index) //{frac}
{
  /*
  op1 = ReadReal(_Data,_data_Op1,_prop_Op1);
  Res = ReadReal(_Data,_data_Op2,_prop_Op2);
  _Err = Res=0;
  if( _Err ) {
    Res=Def;
    _hi_onEvent(_event_onError)
   }
  else {
    Res = frac(op1/Res)*Res;
    if( _prop_ResultType = 0 )
    _hi_onEvent(_event_onResult,integer(Round(Res)))
    else _hi_onEvent(_event_onResult,Res)
  }
  */
}

void THIMath::_work_doOperation37(TData &_Data,WORD Index) //{trunc}
{
  /*
  op1 = ReadReal(_Data,_data_Op1,_prop_Op1);
  Res = ReadReal(_Data,_data_Op2,_prop_Op2);
  _Err = Res=0;
  if( _Err ) {
    Res=Def;
    _hi_onEvent(_event_onError)
   }
  else {
    Res = trunc(op1/Res)*Res;
    if( _prop_ResultType = 0 )
    _hi_onEvent(_event_onResult,integer(Round(Res)))
    else _hi_onEvent(_event_onResult,Res)
  }
  */
}

void THIMath::_work_doOperation38(TData &_Data,WORD Index) //{min}
{
  float op1 = ReadReal(_Data,_data_Op1,_prop_Op1);
  Res = ReadReal(_Data,_data_Op2,_prop_Op2);
  _Err=false;
  if( op1<Res ) Res=op1;
  if( _prop_ResultType == 0 )
    _hi_onEvent(_event_onResult,Round(Res));
  else _hi_onEvent(_event_onResult,Res);
}

void THIMath::_work_doOperation39(TData &_Data,WORD Index) //{max}
{
  float op1 = ReadReal(_Data,_data_Op1,_prop_Op1);
  Res = ReadReal(_Data,_data_Op2,_prop_Op2);
  _Err=false;
  if( op1>Res ) Res=op1;
  if( _prop_ResultType == 0 )
    _hi_onEvent(_event_onResult,Round(Res));
  else _hi_onEvent(_event_onResult,Res);
}
