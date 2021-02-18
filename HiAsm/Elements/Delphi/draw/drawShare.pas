unit drawShare;

interface

uses
  Windows, KOL;

type
  TParamRec = record
    Name: PChar; // Для Delphi исп. тип string, но в FPC даёт ошибку (структура строки отличается?)
    Value: Pointer;
    DataType: Byte;   // i s d c
    Buf: Pointer;
    Index: Byte;
  end;
  TParamRecArray = array[0..1024] of TParamRec;
  PParamRec = ^TParamRecArray;
  PPParamRec = ^TParamRec;
  
  TDrawTools = object
    public
      CreateBitmap: function (PRec: PPParamRec): Cardinal; cdecl;
      DrawBitmap: procedure (Bmp: Cardinal; DC: HDC; X, Y: integer); cdecl;
      DeleteBitmap: procedure (Bmp: Cardinal); cdecl;
      GetSizeBitmap: procedure (Bmp: Cardinal; var w, h: Cardinal); cdecl;
  end;
  PDrawTools = ^TDrawTools;

  function ColorRGB(c: Cardinal): Cardinal;
  function SearchParam(p: PParamRec; PropName: string): PPParamRec;

implementation

function SearchParam(p: PParamRec; PropName: string): PPParamRec;
var
  i: Integer;
begin
  Result := nil; 
  PropName := LowerCase(PropName);
  
  i := 0;
  while p^[i].Value <> nil do
  begin
    if LowerCase(p^[i].Name) = PropName then
    begin
      Result := @p^[i];
      Exit;
    end;
    Inc(i);
  end;
end;

function ColorRGB(c: Cardinal): Cardinal;
begin
  if c and $FF000000 > 0 then
    Result := GetSysColor(c and $FF)
  else
    Result := c;
end;

end.