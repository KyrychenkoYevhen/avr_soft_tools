unit hiConvertorEx;

interface

uses Windows, Kol, Share, Debug;

type
  ThiConvertorEx = class(TDebug)
    private
      FRsltStr: string;
      FRsltInt: Integer;
      FRsltReal: Real;
    public
      _prop_Mode: Byte;
      _prop_Digits: Integer;
      _prop_Width: Integer;
      _prop_Decimals: Integer;        
      _prop_SymbolFill: string;
      _prop_DirectFill: function (const S: string): string of object;
      _prop_Word_1: string;
      _prop_Word_2: string;
      _prop_Word_5: string;

      _data_Data: THI_Event;
      _event_onResult: THI_Event;
      
      function Forward(const S: string): string;
      function Reverse(const S: string): string;
      
      procedure _work_doConvert0(var _Data: TData; Index: Word); //IntToStr
      procedure _work_doConvert1(var _Data: TData; Index: Word); //StrToInt
      procedure _work_doConvert2(var _Data: TData; Index: Word); //RealToInt
      procedure _work_doConvert3(var _Data: TData; Index: Word); //CharToInt
      procedure _work_doConvert4(var _Data: TData; Index: Word); //IntToChar
      procedure _work_doConvert5(var _Data: TData; Index: Word); //HexToInt
      procedure _work_doConvert6(var _Data: TData; Index: Word); //IntToHex
      procedure _work_doConvert7(var _Data: TData; Index: Word); //BinToInt
      procedure _work_doConvert8(var _Data: TData; Index: Word); //IntToBin
      procedure _work_doConvert9(var _Data: TData; Index: Word); //RealToStr
      procedure _work_doConvert10(var _Data: TData; Index: Word); //StrToReal
      procedure _work_doConvert11(var _Data: TData; Index: Word); //IntToRom
      procedure _work_doConvert12(var _Data: TData; Index: Word); //RomToInt
      procedure _work_doConvert13(var _Data: TData; Index: Word); //StrToTri
      procedure _work_doConvert14(var _Data: TData; Index: Word); //StrToWrd
      procedure _work_doConvert15(var _Data: TData; Index: Word); //NumToFStr    
      procedure _work_doConvert16(var _Data: TData; Index: Word); //VKeyToChar    
      procedure _var_Var(var _Data: TData; Index: Word);
  end;
  
implementation

function ThiConvertorEx.Forward(const S: string): string;
var
  L: Integer;
begin
  L := Length(S);
  if L < _prop_Digits then
    Result := StringOfChar(_prop_SymbolFill[1], _prop_Digits - L) + S
  else
    Result := S;
end;

function ThiConvertorEx.Reverse(const S: string): string;
var
  L: Integer;
begin
  L := Length(S);
  if L < _prop_Digits then
    Result := S + StringOfChar(_prop_SymbolFill[1], _prop_Digits - L)
  else
    Result := S;
end;

procedure ThiConvertorEx._work_doConvert0; //IntToStr
begin
  FRsltStr := Int2Str(ReadInteger(_Data, _data_Data, 0));
  if _prop_SymbolFill <> '' then FRsltStr := _prop_DirectFill(FRsltStr);
  _hi_CreateEvent(_Data, @_event_onResult, FRsltStr);
end;

procedure ThiConvertorEx._work_doConvert1;  //StrToInt
begin
  FRsltInt := Str2Int(ReadString(_Data, _data_Data));
  _hi_CreateEvent(_Data, @_event_onResult, FRsltInt);
end;

procedure ThiConvertorEx._work_doConvert2;  //RealToInt
begin
  FRsltInt := Integer(Round(ReadReal(_Data, _data_Data)));
  _hi_CreateEvent(_Data, @_event_onResult, FRsltInt);
end;

procedure ThiConvertorEx._work_doConvert3;  //CharToInt
begin
  FRsltStr:= ReadString(_Data,_data_Data);
  if FRsltStr = '' then FRsltInt := 0 else FRsltInt := Ord(FRsltStr[1]);
  _hi_CreateEvent(_Data, @_event_onResult, FRsltInt);
end;

procedure ThiConvertorEx._work_doConvert4;  //IntToChar
begin
  FRsltStr:= Char(ReadInteger(_Data, _data_Data));
  _hi_CreateEvent(_Data, @_event_onResult, FRsltStr);
end;

procedure ThiConvertorEx._work_doConvert5;  //HexToInt
begin
  FRsltInt := Hex2Int(ReadString(_Data, _data_Data));
  _hi_CreateEvent(_Data, @_event_onResult, FRsltInt);
end;

procedure ThiConvertorEx._work_doConvert6;  //IntToHex
begin
  FRsltStr := Int2Hex(ReadInteger(_Data, _data_Data), _prop_Digits);
  _hi_CreateEvent(_Data, @_event_onResult, FRsltStr);
end;

procedure ThiConvertorEx._work_doConvert7;  //BinToInt
var
  ln: Integer;
begin
  FRsltStr := ReadString(_Data, _data_Data);
  FRsltInt := 0;
  for ln := 1 to Length(FRsltStr) do
    if not (FRsltStr[ln] in ['0','1']) then break
    else FRsltInt := FRsltInt shl 1 + Ord(FRsltStr[ln]) - 48;
  _hi_CreateEvent(_Data, @_event_onResult, FRsltInt);
end;

procedure ThiConvertorEx._work_doConvert8;  //IntToBin
var
  Value: Cardinal;
  dig: Integer;
begin
  FRsltStr := '';
  dig := _prop_Digits;
  Value := ReadInteger(_Data,_data_Data);
  repeat 
    FRsltStr := Char(Value and 1 + 48) + FRsltStr;
    Value := Value shr 1;
    dec(dig);
  until (Value = 0) and (dig <= 0);
  _hi_CreateEvent(_Data, @_event_onResult, FRsltStr);
end;

procedure ThiConvertorEx._work_doConvert9;  //RealToStr
begin
  FRsltStr := Double2Str(ReadReal(_Data, _data_Data));
  _hi_CreateEvent(_Data, @_event_onResult, FRsltStr);
end;

procedure ThiConvertorEx._work_doConvert10; //StrToReal
begin
  FRsltReal:= Str2Double(ReadString(_Data, _data_Data));
  _hi_CreateEvent(_Data, @_event_onResult, FRsltReal);
end;

procedure ThiConvertorEx._work_doConvert11; //IntToRom
const
  Romans: array[1..13] of string =   ('I', 'IV', 'V', 'IX', 'X', 'XL', 'L', 'XC', 'C', 'CD', 'D', 'CM', 'M');
  Arabics: array[1..13] of Integer = (1, 4, 5, 9, 10, 40, 50, 90, 100, 400, 500, 900, 1000);
var
  i: Integer;
  Decimal: Integer;
begin
  Decimal := ReadInteger(_Data, _data_Data);
  FRsltStr := '';
  if Decimal <= 3999 then
    for i := 13 downto 1 do
      while ( Decimal >= Arabics[i] ) do
      begin
        Decimal := Decimal - Arabics[i];
        FRsltStr := FRsltStr + Romans[i];
      end;
  _hi_CreateEvent(_Data, @_event_onResult, FRsltStr);
end;


procedure ThiConvertorEx._work_doConvert12; //RomToInt
const
  Romans: array[1..25] of string =   ('I', 'IV', 'V', 'IX', 'X', 'XL', 'VL' ,'IL' ,'L', 'XC', 'VC', 'IC', 'C', 'CD', 'LD', 'XD', 'VD', 'ID', 'D', 'CM', 'LM', 'XM', 'VM', 'IM', 'M');
  Arabics: array[1..25] of Integer = (1, 4, 5, 9, 10, 40, 45, 49, 50, 90, 95, 99, 100, 400, 450, 490, 495, 499, 500, 900, 950, 990, 995, 999, 1000);
var
  l, p: Integer;
 begin
  FRsltStr := ReadString(_Data,_data_Data);
  FRsltInt := 0;
  l := 25;
  p := 1;
  while p <= Length(FRsltStr) do
  begin
    while Copy(FRsltStr, p, Length(Romans[l])) <> Romans[l] do
    begin
      Dec(l);
      if l = 0 then exit;
    end;
    FRsltInt := FRsltInt + Arabics[l];
    p := p + Length(Romans[l]);
  end;
  _hi_CreateEvent(_Data, @_event_onResult, FRsltInt);
end;

procedure ThiConvertorEx._work_doConvert13; //StrToTri
var
  i: Integer;
  m, f, s, str: string;
begin
  str := ReadString(_Data, _data_Data);
  Replace(str, ' ', '');
  m := '';
  f := '';
  try
    if str = '' then exit;
    if (str[1] = '-') then
    begin
      Delete(str, 1, 1);
      if (str = '') then exit
      else m := '- ';
    end; 
    s := str;
    for i := 1 to Length(s) do
      if s[i] = '.' then
      begin
         str := GetTok(s, '.');
         f := '.' + s;
         break;
      end;
    i := Length(str) - 2;
    while i >= 2 do
    begin
      if (str[1] = '-') and (i < 3) then break; 
      Insert(' ', str, i);
      Dec(i, 3);
    end;
  finally 
    FRsltStr :=  m + str + f;
    _hi_CreateEvent(_Data, @_event_onResult, FRsltStr);
  end;
end;


procedure ThiConvertorEx._work_doConvert14; //StrToWrd
var
  j, l: Integer;
  f, s, str :string;
begin
  str := ReadString(_Data, _data_Data);
  try
    if str = '' then exit;
    if (str[1] = '-') then
    begin
      if (str[2] <> ' ') then Insert(' ',str,2);
    end; 
    s := str;
    f := ' ';
    for j := 0 to Length(s) do 
      if s[j] = '.' then
      begin
        str := GetTok(s, '.');
        f := '.' + s + ' ';
        break;
      end;   

    l := Length(str);
    if f <> ' ' then
      s := f + _prop_Word_2      
    else if (str[l-1] = '1') then // for 10..19
      s := f + _prop_Word_5
    else
      case str[l] of
        '1': s := f + _prop_Word_1;
        '2'..'4': s := f + _prop_Word_2
        else  s := f + _prop_Word_5; 
      end;
  finally
    FRsltStr := str + s;
    _hi_CreateEvent(_Data, @_event_onResult,FRsltStr);
  end;
end;

procedure ThiConvertorEx._work_doConvert15; //NumToFStr
begin
  Str(ReadReal(_Data, _data_Data):_prop_Width:_prop_Decimals, FRsltStr);
  _hi_CreateEvent(_Data, @_event_onResult, FRsltStr);
end;

procedure ThiConvertorEx._work_doConvert16; //VKeyToChar
var
  Key: Word;
  keyboardState: TKeyboardState;
begin
  key := ReadInteger(_Data,_data_Data);
  GetKeyboardState(keyboardState) ;

  SetLength(FRsltStr, 2);
  case ToAscii(key, MapVirtualKey(key, 0), keyboardState, @FRsltStr[1], 0) of
    1: SetLength(FRsltStr, 1);
    2: ;
    else
      FRsltStr := '';
  end;
  _hi_CreateEvent(_Data, @_event_onResult, FRsltStr);
end;

procedure ThiConvertorEx._var_Var;
begin
  case _prop_Mode of
    0,4,6,8,9,11,13,14,15,16: dtString(_Data, FRsltStr);
    1,2,3,5,7,12: dtInteger(_Data, FRsltInt);
    10: dtReal(_Data, FRsltReal);
  end;  
end;

end.
