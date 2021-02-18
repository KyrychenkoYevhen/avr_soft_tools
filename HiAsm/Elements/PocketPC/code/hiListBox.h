#include "WinList.h"

class THIListBox:public THIWinList
{
   private:
    //Arr:PArray;
    //procedure _OnKey( Sender: PControl; var Key: Longint; Shift: DWORD );
    static void _OnClick(void *ClassPointer,void *Param)
    {
      _hi_onEvent( _hie(THIListBox)->_event_onChange);
    }
    //procedure _arr_set(var Item:TData; var Val:TData);
    //function _arr_get(Var Item:TData; var Val:TData):boolean;
    //function _arr_count:integer;
   public:
    BYTE _prop_DataType;
    bool _prop_Sort;
    bool _prop_MultiSelect;

    THI_Event *_event_onKeyDown;
    THI_Event *_event_onClick;

    THIListBox(TWinControl *_Parent)
    {
      Control = new TListBox(_Parent);
      FList = ((TListBox*)Control)->Lines;
    }
    void Init();
    HI_WORK(_work_doSelect){ ((TListBox *)_hie(THIListBox)->Control)->SelIndex = ToInteger(_Data); }
    HI_WORK(_var_Index){ CreateData(_Data,((TListBox *)_hie(THIListBox)->Control)->SelIndex); }
    HI_WORK_LOC(THIListBox,_var_String)
    {
       CreateData(_Data,(*FList)[ (int)((TListBox *)Control)->SelIndex ]);
    }
    //procedure _var_SelectArray(var _Data:TData; Index:word);
};

//////////////////////////////////////////////////////////////////////////

void THIListBox::Init()
{
   THIWin::Init();
   SendMessage(Control->Handle,LB_SETHORIZONTALEXTENT, 200, 0);
   Control->OnClick = DoNotifyEvent(this,_OnClick);
}

/*
procedure THIListBox._work_doSelect;
var ind:integer;
begin
  ind := ToInteger(_Data);
   if(ind >= 0)and(ind < Control.Count)then
    begin
      if  _prop_MultiSelect then
       Control.ItemSelected[ind] := true
      else  Control.CurIndex := ind;
      _OnClick(Control);
    end
   else Control.CurIndex := -1;
end;
*/
/*
procedure THIListBox._var_Index;
begin
   _Data.Data_type := data_int;
   _Data.idata := Control.CurIndex;
end;
*/
/*
void THIListBox::_OnClick()
{
   if _prop_DataType = 1 then
     _hi_OnEvent(_event_onClick,Control.Items[Control.CurIndex])
   else  _hi_OnEvent(_event_onClick,Control.CurIndex);
}
*/
/*
procedure THIListBox._arr_set;
var ind:integer;
begin
   ind := ToIntIndex(Item);
   if(ind >=0 )and(ind < Control.Count)then
    Control.ItemSelected[ind] := ReadBool(Val);
end;

function THIListBox._arr_get;
var ind:integer;
begin
   ind := ToIntIndex(Item);
   Result := (ind >=0 )and(ind < Control.Count);
   if Result then
    begin
     Val.Data_type := data_int;
     Val.idata := byte(Control.ItemSelected[ind]);
    end;
end;

function THIListBox._arr_count;
var i:smallint;
begin
   Result := 0;
   for i := 0 to Control.Count-1 do
    if Control.ItemSelected[i] then
      inc(Result);
end;

procedure THIListBox._var_SelectArray;
begin
  if Arr = nil then
    Arr := CreateArray(_arr_set,_arr_get,_arr_count,nil);
  _Data.Data_type := data_array;
  _Data.idata := integer(Arr);
end;
*/
