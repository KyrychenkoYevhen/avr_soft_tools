unit hiConvertor;  { компонент Convertor ver 1.20 }

interface

uses
  {$ifdef UNICODE}Windows,{$endif} Kol, Share, Debug;

type
  THIConvertor = class(TDebug)
    private
    public
      _prop_Mode: Byte;
      _prop_Digits: Integer;
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
      procedure _work_doConvert11(var _Data: TData; Index: Word); //StreamToStr
      procedure _work_doConvert12(var _Data: TData; Index: Word); //StrToStream
      procedure _work_doConvert13(var _Data: TData; Index: Word); //IntToRom
      procedure _work_doConvert14(var _Data: TData; Index: Word); //RomToInt
      procedure _work_doConvert15(var _Data: TData; Index: Word); //StrToTri
      procedure _work_doConvert16(var _Data: TData; Index: Word); //StrToWrd
  end;

function Hex2Int(st: string): Integer;

implementation

function THIConvertor.Forward(const S: string): string;
var
  L: Integer;
begin
  L := Length(S);
  if L < _prop_Digits then
    Result := S + StringOfChar(_prop_SymbolFill[1], L - _prop_Digits)
  else
    Result := S;
end;

function THIConvertor.Reverse(const S: string): string;
var
  L: Integer;
begin
  L := Length(S);
  if L < _prop_Digits then
    Result := S + StringOfChar(_prop_SymbolFill[1], L - _prop_Digits)
  else
    Result := S;
end;

procedure THIConvertor._work_doConvert0(var _Data: TData; Index: Word); //IntToStr
var
  S: string;
begin
  S := Int2Str(ReadInteger(_Data, _data_Data, 0));
  if _prop_SymbolFill <> '' then S := _prop_DirectFill(S);
  _hi_CreateEvent(_Data, @_event_onResult, S);
end;

procedure THIConvertor._work_doConvert1(var _Data: TData; Index: Word); //StrToInt
begin
  _hi_CreateEvent(_Data, @_event_onResult, Str2Int(ReadString(_Data, _data_Data)));
end;

procedure THIConvertor._work_doConvert2(var _Data: TData; Index: Word); //RealToInt
begin
  _hi_CreateEvent(_Data, @_event_onResult, Integer(Round(ReadReal(_Data, _data_Data))));
end;

procedure THIConvertor._work_doConvert3(var _Data: TData; Index: Word); //CharToInt
var
  S: string;
  C: Integer;
begin
  S := ReadString(_Data, _data_Data);
  if S = '' then C := 0 else C := Ord(S[1]);
  
  _hi_CreateEvent(_Data, @_event_onResult, C);
end;

procedure THIConvertor._work_doConvert4(var _Data: TData; Index: Word); //IntToChar
begin
  _hi_CreateEvent(_Data, @_event_onResult, Char(ReadInteger(_Data, _data_Data)));
end;

function Hex2Int(st: string): Integer;
var
  i, ln: Integer;
begin
  st := LowerCase(st);
  Result := 0;
  ln := Length(st);
  for i := 1 to ln do
    case st[i] of
      '0'..'9': Result := Result shl 4 + Ord(st[i]) - 48;
      'a'..'f': Result := Result shl 4 + Ord(st[i]) - 87;
      else
        break;
  end;
end;

procedure THIConvertor._work_doConvert5(var _Data: TData; Index: Word); //HexToInt
begin
  _hi_CreateEvent(_Data, @_event_onResult, Hex2Int(ReadString(_Data, _data_Data)));
end;

procedure THIConvertor._work_doConvert6(var _Data: TData; Index: Word); //IntToHex
begin
  _hi_CreateEvent(_Data, @_event_onResult, Int2Hex(ReadInteger(_Data,_data_Data), _prop_Digits));
end;

procedure THIConvertor._work_doConvert7(var _Data: TData; Index: Word); //BinToInt
var
  i, bin, ln: Integer;
  st: string;
begin
  st := ReadString(_Data, _data_Data);
  bin := 0;
  ln := Length(st);
  for i := 1 to ln do
    if not (st[i] in ['0','1']) then break
    else bin := bin shl 1 + Ord(st[i]) - 48;
  _hi_CreateEvent(_Data, @_event_onResult, bin);
end;

procedure THIConvertor._work_doConvert8(var _Data: TData; Index: Word); //IntToBin
var
  Value: Cardinal;
  dig: Integer;
  s: string;
begin
  s := '';
  dig := _prop_Digits;
  Value := ReadInteger(_Data, _data_Data);
  repeat 
    s := Char(Value and 1 + 48) + s;
    Value := Value shr 1;
    Dec(dig);
  until (Value = 0) and (dig <= 0);
  _hi_CreateEvent(_Data, @_event_onResult, s);
end;

procedure THIConvertor._work_doConvert9(var _Data: TData; Index: Word); //RealToStr
begin
  _hi_CreateEvent(_Data,@_event_onResult, Double2Str(ReadReal(_Data, _data_Data)));
end;

procedure THIConvertor._work_doConvert10(var _Data: TData; Index: Word); //StrToReal
begin
  _hi_CreateEvent(_Data,@_event_onResult, Str2Double(ReadString(_Data, _data_Data)));
end;

procedure THIConvertor._work_doConvert11(var _Data: TData; Index: Word); //StreamToStr
{$ifdef UNICODE}
begin
  MessageBox(0, PChar('Mode=StreamToStr not supported in UNICODE compiler.'#13#10'Use StreamConvertor instead.'), PChar('Convertor'), MB_OK + MB_ICONWARNING);
end;
{$else}
var
  S: string;
  St: PStream;
  len: Cardinal;
begin
  St := ReadStream(_Data, _data_Data);
  if St = nil then Exit;
  St.Position := 0;
  len := St.Size;
  SetLength(S, len);
  if len > 0 then St.Read(S[1], len);
  _hi_CreateEvent(_Data, @_event_onResult, S);
end;
{$endif}

procedure THIConvertor._work_doConvert12(var _Data: TData; Index: Word); //StrToStream
{$ifdef UNICODE}
begin
  MessageBox(0, PChar('Mode=StrToStream not supported in UNICODE compiler.'#13#10'Use StreamConvertor instead.'), PChar('Convertor'), MB_OK + MB_ICONWARNING);
end;
{$else}
var
  S: string;
  St: PStream;
  len: Cardinal;
begin
  S := ReadString(_Data,_data_Data);
  St := NewMemoryStream;
  len := Length(S);
  if len > 0 then St.Write(s[1], len);
  St.Position := 0;
  _hi_OnEvent(_event_onResult, St);
  St.free;
end;
{$endif}

procedure THIConvertor._work_doConvert13(var _Data: TData; Index: Word); //IntToRom (Standard Algorithm -- Input <= 3999)
const
  Romans: array[1..13] of string =   ('I', 'IV', 'V', 'IX', 'X', 'XL', 'L', 'XC', 'C', 'CD', 'D', 'CM', 'M');
  Arabics: array[1..13] of Integer = (1, 4, 5, 9, 10, 40, 50, 90, 100, 400, 500, 900, 1000);
var
  i: Integer;
  str: string;
  Decimal: Integer;
begin
  Decimal := ReadInteger(_Data, _data_Data);
  str := '';
  if Decimal <= 3999 then
    for i := 13 downto 1 do
      while (Decimal >= Arabics[i]) do
      begin
        Decimal := Decimal - Arabics[i];
        str := str + Romans[i];
      end;
  _hi_CreateEvent(_Data, @_event_onResult, str);
end;

procedure THIConvertor._work_doConvert14(var _Data: TData; Index: Word); //RomToInt (Extended Algorithm)
const
  Romans: array[1..25] of string =   ('I', 'IV', 'V', 'IX', 'X', 'XL', 'VL' ,'IL' ,'L', 'XC', 'VC', 'IC', 'C', 'CD', 'LD', 'XD', 'VD', 'ID', 'D', 'CM', 'LM', 'XM', 'VM', 'IM', 'M');
  Arabics: array[1..25] of Integer = (1, 4, 5, 9, 10, 40, 45, 49, 50, 90, 95, 99, 100, 400, 450, 490, 495, 499, 500, 900, 950, 990, 995, 999, 1000);
var
  i, p: Integer;
  str: string;
  Decimal: Integer;
begin
  str := ReadString(_Data,_data_Data);
  Decimal := 0;
  i := 25;
  p := 1;
  while p <= Length(str) do
  begin
    while Copy(str, p, Length(Romans[i])) <> Romans[i] do
    begin
      Dec(i);
      if i = 0 then exit;
    end;
    Decimal := Decimal + Arabics[i];
    p := p + Length(Romans[i]);
  end;
  _hi_CreateEvent(_Data, @_event_onResult, Decimal);
end;

procedure THIConvertor._work_doConvert15(var _Data: TData; Index: Word); //StrToTri
var
  i: Integer;
  m, f, s, str: string;
begin
  str := ReadString(_Data,_data_Data);
  Replace(str, ' ','');
  m := '';
  f := '';
  try
    if str = '' then exit;
    if (str[1] = '-') then
    begin
      Delete(str,1,1);
      if (str = '') then exit
      else m := '- ';
    end; 
    s := str;
    for i:=1 to Length(s) do
      if s[i] = '.' then
      begin
         str := GetTok(s,'.');
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
    _hi_CreateEvent(_Data,@_event_onResult, m + str + f);
  end;
end;

procedure THIConvertor._work_doConvert16(var _Data: TData; Index: Word); //StrToWrd
var
  j, l: Integer;
  f, s, str: string;
begin
  str := ReadString(_Data, _data_Data);
  try
    if str = '' then exit;
    if (str[1] = '-') then
    begin
      if (str[2] <> ' ') then Insert(' ', str, 2);
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
    begin
      case str[l] of
        '1': s := f + _prop_Word_1;
        '2'..'4': s := f + _prop_Word_2
        else  s := f + _prop_Word_5; 
      end;
    end;
  finally
    _hi_CreateEvent(_Data, @_event_onResult, str + s);
  end;
end;

end.