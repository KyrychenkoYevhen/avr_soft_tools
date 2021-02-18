#ifndef __WINLIST_H__
#define __WINLIST_H__

#include "win.h"
#include "basetools.h"

class THIWinList:public THIWin
{
   private:
    //Arr:PArray;
   protected:
    TList *FList;

    //procedure SetStrings(const Value:string); virtual;

    /*
    procedure _Set(var Item:TData; var Val:TData);
    function _Get(Var Item:TData; var Val:TData):boolean;
    function _Count:integer;
    procedure _Add(var Val:TData);
    */
   public:
    string _prop_FileName;
    BYTE _prop_AddType;
    bool _prop_SelectAdd;

    THI_Event *_data_FileName;
    THI_Event *_data_Str;
    THI_Event *_event_onChange;

    HI_WORK_LOC(THIWinList,_work_doAdd);
    HI_WORK_LOC(THIWinList,_work_doClear);
    HI_WORK_LOC(THIWinList,_work_doDelete);
    HI_WORK_LOC(THIWinList,_work_doText);
    HI_WORK_LOC(THIWinList,_work_doLoad);
    HI_WORK_LOC(THIWinList,_work_doSave);
    HI_WORK_LOC(THIWinList,_work_doAddDir);
    HI_WORK_LOC(THIWinList,_work_doReplace);
    HI_WORK_LOC(THIWinList,_work_doSort);

    HI_WORK(_var_Text){ CreateData(_Data,_hie(THIWinList)->FList->Text); }
    HI_WORK(_var_Count){ CreateData(_Data,_hie(THIWinList)->FList->Count()); }
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

//########################################################################

void THIWinList::_work_doAdd(TData &_Data,WORD Index)
{
   string s = ReadString(_Data,_data_Str,string(_his("")));
   if( _prop_AddType == 0 )
   {
       FList->Add(s);
       //if _prop_SelectAdd then
       //  Control.CurIndex := Control.Count-1;
   }
   else
   {
       FList->Insert(0,s);
       //if Control.Insert(0,s) = -1 then
       //  Control.Text := s + #13#10 + Control.Text;
       //if _prop_SelectAdd then
       //  Control.CurIndex := 0;
   }
   _hi_onEvent(_event_onChange);
}

void THIWinList::_work_doClear(TData &_Data,WORD Index)
{
   FList->Clear();
   _hi_onEvent(_event_onChange);
}

void THIWinList::_work_doDelete(TData &_Data,WORD Index)
{
  int Ind = ToIntIndex(_Data);
  if( (Ind >= 0)&&(Ind < FList->Count()) )
  {
    FList->Delete(Ind);
    //Control.DeleteLines(_data.idata,_data.idata);
    _hi_onEvent(_event_onChange);
  }
}

void THIWinList::_work_doText(TData &_Data,WORD Index)
{
   FList->Clear();
   FList->Text = ToString(_Data);
   _hi_onEvent(_event_onChange);
}

void THIWinList::_work_doLoad(TData &_Data,WORD Index)
{
   string fn;
   fn = ReadFileName(ReadString(_Data,_data_FileName,_prop_FileName));
   if( FileExists(fn) )
   {
     FList->Clear();
     FList->LoadFromFile(fn);
     _hi_onEvent(_event_onChange);
   }
}

void THIWinList::_work_doSave(TData &_Data,WORD Index)
{
   FList->SaveToFile(ReadString(_Data,_data_FileName,_prop_FileName));
}

void THIWinList::_work_doAddDir(TData &_Data,WORD Index)
{

}

void THIWinList::_work_doReplace(TData &_Data,WORD Index)
{
   int ind = ToIntIndex(_Data);
   _Data.data_type = data_null;
   if( (ind >= 0)&&(ind < FList->Count()) )
   {
     //FList[ind] = ReadString(_Data,_data_Str,string(_his("")));
     _hi_onEvent(_event_onChange);
   }
}

void THIWinList::_work_doSort(TData &_Data,WORD Index)
{

}

/*
procedure THIWinList._Set;
var ind:integer;
begin
   ind := ToIntIndex(Item);
   if(ind >= 0)and(ind < Control.Count)then
     Control.Items[ind] := ToString(Val);
end;

procedure THIWinList._Add;
begin
   Add(ToString(val));
end;

function THIWinList._Get;
var ind:integer;
begin
   ind := ToIntIndex(Item);
   if(ind >= 0)and(ind < Control.Count)then
     begin
        Result := true;
        Val.data_type := data_str;
        Val.sdata := Control.Items[ind];
     end
   else Result := false;
end;

function THIWinList._Count;
begin
   Result := Control.Count;
end;

procedure THIWinList._var_Array;
begin
   if Arr = nil then
    begin
     New(Arr);
     Arr._Set := _Set;
     Arr._Get := _Get;
     Arr._Count := _Count;
     Arr._Add := _Add;
    end;
   _Data.Data_type := data_array;
   _Data.idata := integer(Arr);
end;
*/

#endif
