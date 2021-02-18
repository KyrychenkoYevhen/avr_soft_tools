#include "hiImg_share.h"

class THIImg_Point:public THIImg_Share
{
   private:
    //FMatr:PMatrix;
    //procedure _Set(x,y:integer; var Val:TData);
    //function _Get(x,y:integer):TData;
    //function _Rows:integer;
    //function _Cols:integer;
   protected:
    void MainDraw(TData &_Data,HDC dc);
   public:
    int _prop_X;
    int _prop_Y;

    THI_Event *_data_X;
    THI_Event *_data_Y;

    //procedure _var_Pixels(var _Data:TData; Index:word);
};

/////////////////////////////////////////////////////////////////////////////

void THIImg_Point::MainDraw(TData &_Data,HDC dc)
{
   int x = ReadInteger(_Data,_data_X,_prop_X);
   int y = ReadInteger(_Data,_data_Y,_prop_Y);

   SetPixel(dc,x,y,ReadColor(_Data,_data_Color,_prop_Color));
}

/*
procedure THIImg_Point._Set;
var dt:TData;
    dc:HDC;
    Wnd:HWND;
begin
    dt := ReadData(Val,_data_Bitmap,nil);
    if _IsBitmap(dt) then
      begin
        if(x >= 0)and(x < PBitmap(dt.idata).Width)and(y >=0)and(y < PBitmap(dt.idata).Height)then
         PBitmap(dt.idata).Pixels[x,y] := ReadInteger(Val,_data_Color,_prop_Color)
      end
    else
     begin
      Wnd := ToInteger(dt);
      DC := getdc(wnd);
      SetPixel(DC,x,y,ReadInteger(Val,_data_Color,_prop_Color));
      ReleaseDC(wnd,dc);
     end;
end;

function THIImg_Point._Get;
var dt:TData;
    dc:HDC;
    Wnd:HWND;
begin
    dt.Data_type := data_null;
    dt := ReadData(dt,_data_Bitmap,nil);
    Result.Data_type := data_int;
    if _IsBitmap(dt) then
      begin
        if(x >= 0)and(x < PBitmap(dt.idata).Width)and(y >=0)and(y < PBitmap(dt.idata).Height)then
         Result.idata := PBitmap(dt.idata).Pixels[x,y]
      end
    else
     begin
      Wnd := ToInteger(dt);
      DC := getdc(wnd);
      Result.idata := GetPixel(ToInteger(dt),x,y);
      ReleaseDC(wnd,dc);
     end;
end;

function THIImg_Point._Rows;
var dt:TData;
    r:trect;
begin
    dt.Data_type := data_null;
    dt := ReadData(dt,_data_Bitmap,nil);
    if _IsBitmap(dt) then
      Result := PBitmap(dt.idata).Height
    else
     begin
      GetClientRect(ToInteger(dt),r);
      Result := r.Bottom - r.Top;
     end;
end;

function THIImg_Point._Cols;
var dt:TData;
    r:trect;
begin
    dt.Data_type := data_null;
    dt := ReadData(dt,_data_Bitmap,nil);
    if _IsBitmap(dt) then
      Result := PBitmap(dt.idata).Width
    else
     begin
      GetClientRect(ToInteger(dt),r);
      Result := r.Right - r.Left;
     end;
end;

procedure THIImg_Point._var_Pixels(var _Data:TData; Index:word);
begin
    if FMatr = nil then
      FMatr := CreateMatrix(_Set,_Get,_Cols,_Rows);
    _data := _dodata(FMatr);  
end;
*/
