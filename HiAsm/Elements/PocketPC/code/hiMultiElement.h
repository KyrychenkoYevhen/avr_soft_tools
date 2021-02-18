#ifndef _MULTIELEMENT_
#define _MULTIELEMENT_

#include "share.h"
//#include "hiEditMulti.h"

class THIMultiElement;

class THIEditMulti:public TDebug
{
   private:
     THIMultiElement *FParent;
   public:
     void *MainClass;

     THI_Event **Works;
     THI_Event **Vars;
     int _prop_Width;
     int _prop_Height;
     int _prop_VOffset;
     int _prop_HOffset;
     BYTE _prop_EventCount;
     BYTE _prop_DataCount;

     THIEditMulti(){}
     HI_WORK_LOC(THIEditMulti,OnEvent);
     HI_WORK_LOC(THIEditMulti,_Data);
     void SetWork(int value)
     {
        Works = (THI_Event**)new int[value];
     }
     void SetVar(int value)
     {
        Vars = (THI_Event**)new int[value];
     }
     __declspec( property( put = SetWork )) int _prop_WorkCount;
     __declspec( property( put = SetVar )) int _prop_VarCount;
     void SetParent(THIMultiElement *Value){ FParent = Value; }
};

/////////////////////////////////////////////////////////////////////////////

typedef THIEditMulti* TOnCreate(TWinControl *Control);

class THIMultiElement:public TDebug
{
   private:
     THIEditMulti *FChild;
     TOnCreate *FOnCreate;

     void CreateInstance();
   protected:
     TWinControl *FControl;
   public:
     bool _prop_FirstUsage;
     THI_Event **Events;
     THI_Event **Datas;

     THIMultiElement(TWinControl *Control){FControl = Control;}
     THIMultiElement(){} //temp
     ~THIMultiElement()
     {
        //delete MainClass; !!!!!!
     }
     void Init(){}
     void SetEvents(int value){ Events = EventArray(value); }
     void SetDatas(int value){ Datas = EventArray(value); }

     HI_WORK_LOC(THIMultiElement,doWork);
     HI_WORK_LOC(THIMultiElement,getVar);
     void SetCreateProc(TOnCreate *Value);
};

///////////////////////////////////////////////////////////////////////

void THIEditMulti::OnEvent(TData &_Data,WORD Index)
{
  _hi_CreateEvent(_Data,FParent->Events[Index],_Data);
}

void THIEditMulti::_Data(TData &_Data,WORD Index)
{
  _ReadData(_Data,FParent->Datas[Index]);
}

///////////////////////////////////////////////////////////////////////

void THIMultiElement::doWork(TData &_Data,WORD Index)
{
   CreateInstance();
   _hi_CreateEvent(_Data,FChild->Works[Index],_Data);
}

void THIMultiElement::getVar(TData &_Data,WORD Index)
{
   CreateInstance();
   _ReadData(_Data,FChild->Vars[Index]);
}

void THIMultiElement::SetCreateProc(TOnCreate *Value)
{
   FOnCreate = Value;
   if( !_prop_FirstUsage )
    CreateInstance();
}

void THIMultiElement::CreateInstance()
{
   if( !FChild )
   {
     FChild = FOnCreate(FControl);
     FChild->SetParent( this );
   }
}

#endif
