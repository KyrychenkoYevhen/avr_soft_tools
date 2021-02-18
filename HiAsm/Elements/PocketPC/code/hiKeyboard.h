#include "share.h"

class  THIKeyboard:public TDebug
{
   private:
    //_Arr:PArray;
    // function _Count:integer;
    // procedure _Write(var Item:TData; var Val:TData);
    // function _Read(Var Item:TData; var Val:TData):boolean;
   public:
    int _prop_Key;
    THI_Event *_data_Key;
    THI_Event *_event_onReadKey;

    HI_WORK_LOC(THIKeyboard,_work_doReadKey)
    {
      _hi_CreateEvent(_Data,_event_onReadKey,(BYTE)(GetKeyState(ReadInteger(_Data,_data_Key,_prop_Key)) < 0));
    }
    //procedure _var_Keys(var _Data:TData; Index:word);
};

///////////////////////////////////////////////////////////////////////////

/*
procedure THIKeyboard._Write;
var Keys:TKeyboardState;
   ind:integer;
begin
   GetKeyboardState(keys);
   ind := ToInteger(Item);
   if ind in [0..255] then
    begin
      Keys[ind] := byte(ReadBool(Val));
      SetKeyboardState(Keys);
    end;
end;

function THIKeyboard._Count;
begin
   Result := 256;
end;

function THIKeyboard._Read;
var ind:integer;
begin
   ind := ToInteger(Item);
   Result := ind in [0..255];
   if Result then
     begin
       Val.Data_type := data_int;
       Val.idata := byte(GetKeyState(ind) < 0);
     end;
end;

procedure THIKeyboard._var_Keys;
begin
   if _Arr = nil then
    _Arr := CreateArray(_Write,_Read,_Count,nil);
   _data.Data_type := data_array;
   _Data.Data_type := integer(_Arr);
end;
*/
