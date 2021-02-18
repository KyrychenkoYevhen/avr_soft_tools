#include "share.h"
#include "basetools.h"

class  THIStrList:public TDebug
{
   private:
    TStrList *FList;
    //PArray Arr;

    //procedure _Set(var Item:TData; var Val:TData);
    //function _Get(Var Item:TData; var Val:TData):boolean;
    //function _Count:integer;
    //procedure _Add(var Val:TData);
   public:
    string _prop_FileName;

    THI_Event *_data_FileName;
    THI_Event *_data_Str;
    THI_Event *_event_onChange;

    THIStrList(){ FList = new TStrList(); }
    HI_WORK_LOC(THIStrList,_work_doAdd);
    HI_WORK_LOC(THIStrList,_work_doClear);
    HI_WORK_LOC(THIStrList,_work_doDelete);
    HI_WORK_LOC(THIStrList,_work_doText);
    HI_WORK_LOC(THIStrList,_work_doLoad);
    HI_WORK_LOC(THIStrList,_work_doSave);
    HI_WORK_LOC(THIStrList,_work_doSort);

    HI_WORK(_var_Text){ CreateData(_Data,_hie(THIStrList)->FList->Text); }
    HI_WORK(_var_Count){ CreateData(_Data,_hie(THIStrList)->FList->Count()); }
    HI_WORK(_var_Array){}

    void SetText(HI_STRING Value)
    {
       #ifdef UNICODE
         HI_STRING rbuf;
         AtoU((char *)Value,&rbuf);
         //MessageBox(NULL,L"ok",rbuf,MB_OK);
         FList->Text = string(rbuf);
         delete rbuf;
       #else
         FList->Text = string(Value);
       #endif
    }
    __declspec( property( put = SetText ) ) HI_STRING _prop_Strings;
};

//////////////////////////////////////////////////////////////////////////

void THIStrList::_work_doAdd(TData &_Data,WORD Index)
{
   FList->Add(ReadString(_Data,_data_Str,string(_his(""))));
   _hi_onEvent(_event_onChange);
}

void THIStrList::_work_doClear(TData &_Data,WORD Index)
{
   FList->Clear();
   _hi_onEvent(_event_onChange);
}

void THIStrList::_work_doDelete(TData &_Data,WORD Index)
{
   int ind = ToIntIndex(_Data);
   if( (ind >= 0) && (ind < FList->Count()) )
   {
      FList->Delete(ind);
      _hi_onEvent(_event_onChange);
   }
}

void THIStrList::_work_doText(TData &_Data,WORD Index)
{
   //FList->Text := ReadString(_Data,_data_str,'');
   _hi_onEvent(_event_onChange);
}

void THIStrList::_work_doLoad(TData &_Data,WORD Index)
{
   string fn = ReadString(_Data,_data_FileName,_prop_FileName);
   if( FileExists(fn) )
   {
      FList->LoadFromFile(fn);
      _hi_onEvent(_event_onChange);
   }
}

void THIStrList::_work_doSave(TData &_Data,WORD Index)
{
   string fn = ReadString(_Data,_data_FileName,_prop_FileName);
   FList->SaveToFile(fn);
}


/*
procedure THIStrList._Set;
var ind:integer;
begin
   ind := ToIntIndex(Item);
   if(ind >= 0)and(ind < FList.Count)then
     FList.Items[ind] := ToString(Val);
end;

procedure THIStrList._Add;
begin
   FList.Add(ToString(val));
end;

function THIStrList._Get;
var ind:integer;
begin
   ind := ToIntIndex(Item);
   if(ind >= 0)and(ind < FList.Count)then
     begin
        Result := true;
        Val.data_type := data_str;
        Val.sdata := FList.Items[ind];
     end
   else Result := false;
end;

function THIStrList._Count;
begin
   Result := FList.Count;
end;

procedure THIStrList._var_Array;
{
   if( !Arr )
     Arr = CreateArray(_Set, _Get, _Count, _Add);
   CreateData(_Data,Arr);
} */
