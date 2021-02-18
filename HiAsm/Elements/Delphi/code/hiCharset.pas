unit hiCharset;

interface

uses
  Windows, Kol, Share, Debug, CodePages;


type

  THICharset = class(TDebug)
    private
      FCharset: Integer;
      
      procedure SetCharset(Value: Byte);
    public
      _prop_Type: Byte;
      _prop_OutTypeUnicode: Byte;
      _prop_InTypeUnicode: Byte;
      _prop_URLMode: Byte;
      
      _prop_CodePage1: Integer;
      _prop_CodePage2: Integer;    

      _data_Text: THI_Event;
      _data_CodePage1: THI_Event;
      _data_CodePage2: THI_Event;    
      
      _event_onCharset: THI_Event;
      _event_onEnumCP: THI_Event;
      _event_onError: THI_Event;
      
      property _prop_Charset: Byte write SetCharset;
      
      constructor Create;
      
      procedure _work_doCharset0(var _Data: TData; Index: Word); // DOS->Str
      procedure _work_doCharset1(var _Data: TData; Index: Word); // Str->DOS
      procedure _work_doCharset2(var _Data: TData; Index: Word); // EN->RU
      procedure _work_doCharset3(var _Data: TData; Index: Word); // KOI8r->Str
      procedure _work_doCharset4(var _Data: TData; Index: Word); // BASE64->Str
      procedure _work_doCharset5(var _Data: TData; Index: Word); // Str->BASE64
      procedure _work_doCharset6(var _Data: TData; Index: Word); // Str->UTF8
      procedure _work_doCharset7(var _Data: TData; Index: Word); // UTF8->Str
      procedure _work_doCharset8(var _Data: TData; Index: Word); // CP1->CP2
      procedure _work_doCharset9(var _Data: TData; Index: Word); // UNICODE->Str
      procedure _work_doCharset10(var _Data: TData; Index: Word); // Str->UNICODE
      procedure _work_doCharset11(var _Data: TData; Index: Word); // URL->Str
      procedure _work_doCharset12(var _Data: TData; Index: Word); // Str->URL
      procedure _work_doCharset13(var _Data: TData; Index: Word); // ANSI->Str
      procedure _work_doCharset14(var _Data: TData; Index: Word); // Str->ANSI
      procedure _work_doEnumCP(var _Data: TData; Index: Word);
      
      procedure _work_doCharset(var _Data: TData; Index: Word);
      
      procedure _var_ActiveCP(var _Data: TData; Index: Word);
      procedure _var_CompilerCP(var _Data: TData; Index: Word);
  end;

{$ifndef FPC_NEW}
  TCPInfoExA = record
    MaxCharSize    : UINT;
    DefaultChar    : array[0..(MAX_DEFAULTCHAR)-1] of BYTE;
    LeadByte       : array[0..(MAX_LEADBYTES)-1] of BYTE;
    DefaultUnicode : WCHAR;
    CodePage       : UINT;
    CodePageName   : array[0..(MAX_PATH)-1] of CHAR;
  end;
  TCPInfoEx = TCPInfoExA;

  function GetCPInfoEx(Codepage:UINT; dwFlags:DWORD; var CPInfoEx:TCPINFOEXA): LongBool; stdcall;
    external 'kernel32.dll' name 'GetCPInfoExA';
{$endif}

// Преобразовывает строку в Base64
function Base64_Code(const S: string): string; overload;
function Base64_Code(const S: string; TargetCP: Integer): string; overload;

// Преобразовывает строку из Base64 в оригинальный вид
// Если исходная строка непустая, а результат - пустая,
// значит, ошибка декодирования 
function Base64_Decode(const S: string): string; overload;
function Base64_Decode(const S: string; SourceCP: Integer): string; overload;

// Функция возвращает размер выходного буфера
// для заданного размера входного буфера при кодировании в Base64 
function TextSizeForBase64Enc(const DataSize: DWord): DWord;

// Функция возвращает размер выходного буфера
// для заданного размера входного буфера при декодировании в Base64
// Возвращает 0, если размер входного буфера некратный 4 или равен 0
function BufSizeForBase64Dec(const TextSize: DWord): DWord;

// Преобразование в Base64 данных в буфере Buffer
// и занесение результата в буфер Text.
// Возвращает количество данных, записанных в Text.
// Размер Text должен быть не меньше (BufSize * 4) div 3 
function BinToBase64(Buffer: Pointer; Text: PChar; BufSize: DWord): DWord;

// Преобразование в оригинальный вид из Base64 
// данных в буфере Text и занесение результата в буфер Buffer.
// Возвращает количество данных, записанных в Buffer, или 0,
// если TextSize некратный 4 или недопустимый символ в Text.
// Размер Buffer не меньше (TextSize div 4) * 3 
// TextSize должно быть кратно 4
function Base64ToBin(Text: PChar; Buffer: Pointer; TextSize: DWord): DWord;




function URLEncode(const S: string; URLMode: Byte): string; overload;
function URLEncode(const S: string; URLMode: Byte; TargetCP: Integer): string; overload;

function URLDecode(const S: string): AnsiString; overload;
function URLDecode(const S: string; SourceCP: Integer): string; overload;



implementation



// ====================================================== //
//  Реализация кодирования/декодирования данных в Base64  //
//                 Автор: Netspirit                       //
//             Редакция от 26.01.2018                     //
// ====================================================== //
  
const  
  // Алфавит Base64
  Base64Chars: array [0..63] of Char = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';  

var
  // Таблица индексов для декодирования Base64
  Base64Indexes: array [0..255] of Byte;

function TextSizeForBase64Enc(const DataSize: DWord): DWord;
begin
  Result := DataSize div 3;
  if Result * 3 <> DataSize then Inc(Result);
  Result := Result * 4;
end;

function BufSizeForBase64Dec(const TextSize: DWord): DWord;
begin
  if TextSize mod 4 <> 0 then
    Result := 0
  else
    Result := TextSize div 4 * 3;
end;

// Процедура заполняет таблицу индексов для декодера Base64.
// В Base64Indexes по смещению [Буква] содержится индекс
// этой (Буквы) в алфавите Base64Chars.
// Символы, не входящие в алфавит Base64 при заполнении будут иметь индекс 255.
// Ищется индекс входящего символа по таблице, символ не входящий в алфавит
// имеет индекс 255 и считается ошибочным

procedure FillBase64DecodeTable;
var
  I: Integer;
begin
  FillChar(Base64Indexes[0], Length(Base64Indexes), 255);
  for I := 0 to High(Base64Chars) do
    Base64Indexes[Byte(Base64Chars[I])] := I;
end;

function BinToBase64(Buffer: Pointer; Text: PChar; BufSize: DWord): DWord;
var
  I: DWord;
  B: DWord;
  L: DWord;
begin
  Result := 0;
  I := 0;
  L := (BufSize div 3) * 3;
  while I < L do
  begin
    B :=
      (PByte(Buffer)^ shl 16) or
      (PByte(NativeUInt(Buffer) + 1)^ shl 8) or
      (PByte(NativeUInt(Buffer) + 2)^);
    
    Text[Result] := Base64Chars[(B shr 18) and 63];
    Text[Result + 1] := Base64Chars[(B shr 12) and 63];
    Text[Result + 2] := Base64Chars[(B shr 6) and 63];
    Text[Result + 3] := Base64Chars[B and 63];
    
    Inc(Result, 4);
    Inc(NativeUInt(Buffer), 3);
    Inc(I, 3);
  end;
  
  //=====================================================================//
  // Исходные данные нужно дополнить 0-ми до кратных 3-м                 //
  // Результирующий текст нужно дополнить символом "=" до кратного 4-м   //
  //=====================================================================//

  I := BufSize mod 3;
  if I <> 0 then
  begin
    B := PByte(Buffer)^ shl 16; // I = 1 или 2. B = $00xx0000
    if I = 2 then B := B or (PByte(NativeUInt(Buffer) + 1)^ shl 8); // I = 2 - так должно быть! B = $00xxyy00
    
    // I = 1 или 2:
    Text[Result] := Base64Chars[(B shr 18) and 63];
    Text[Result + 1] := Base64Chars[(B shr 12) and 63];
    
    if I = 2 then
      Text[Result + 2] := Base64Chars[(B shr 6) and 63]
    else
      Text[Result + 2] := '=';
      
    Text[Result + 3] := '=';
    
    // При I = 1 Text[0..3] = 'AB=='
    // При I = 2 Text[0..3] = 'ABC='
    
    Inc(Result, 4);
  end;
end;

function Base64ToBin(Text: PChar; Buffer: Pointer; TextSize: DWord): DWord;
var
  I, L: DWord;
  B0, B1, B2, B3: Byte;
begin
  Result := 0;
  if (TextSize = 0) or (TextSize mod 4 <> 0) then Exit;
  I := 0;
  L := TextSize - 4;
  while I < L do
  begin
    B0 := Base64Indexes[Byte(Text[I])];
    B1 := Base64Indexes[Byte(Text[I + 1])];
    B2 := Base64Indexes[Byte(Text[I + 2])]; 
    B3 := Base64Indexes[Byte(Text[I + 3])];
    
    if (B0 = 255) or (B1 = 255) or (B2 = 255) or (B3 = 255) // Недопустимый символ
    then 
    begin
      Result := 0;
      Exit;
    end;
    
    PByte(Buffer)^ := Byte((B0 shl 2) or (B1 shr 4));
    Inc(NativeUInt(Buffer));
    PByte(Buffer)^ := Byte((B1 shl 4) or (B2 shr 2));
    Inc(NativeUInt(Buffer));
    PByte(Buffer)^ := Byte((B2 shl 6) or (B3));
    Inc(NativeUInt(Buffer));
    
    Inc(Result, 3);
    Inc(I, 4);
  end;
  
  //=============================================================//
  // Если исходный текст оканчивается на 1-2 символа "=",        //
  // в результирующие данные не добавляется последние 1-2 байта  //
  //=============================================================//
  
  B0 := Base64Indexes[Byte(Text[I])];
  B1 := Base64Indexes[Byte(Text[I + 1])];
  
  if (B0 = 255) or (B1 = 255) // Недопустимый символ
  then 
  begin
    Result := 0;
    Exit;
  end;
  
  PByte(Buffer)^ := Byte((B0 shl 2) or (B1 shr 4));
  Inc(Result);
  
  if Text[I + 2] <> '=' then
  begin 
    B2 := Base64Indexes[Byte(Text[I + 2])];
    if (B2 = 255) // Недопустимый символ
    then 
    begin
      Result := 0;
      Exit;
    end;
    Inc(NativeUInt(Buffer));
    PByte(Buffer)^ := Byte((B1 shl 4) or (B2 shr 2));
    Inc(Result);
    
    if Text[I + 3] <> '=' then
    begin
      B3 := Base64Indexes[Byte(Text[I + 3])];
      if (B3 = 255) // Недопустимый символ
      then 
      begin
        Result := 0;
        Exit;
      end;
      Inc(NativeUInt(Buffer));
      PByte(Buffer)^ := Byte((B2 shl 6) or (B3));
      Inc(Result);
    end;
  end;
end;

// Преобразовывает строку в Base64
function Base64_Code(const S: string): string;
var
  L: DWord;
begin
  L := BinaryLength(S);
  if L = 0 then Exit;
  
  SetLength(Result, TextSizeForBase64Enc(L));
  BinToBase64(Pointer(S), Pointer(Result), L);
end;

function Base64_Code(const S: string; TargetCP: Integer): string;
var
  L: DWord;
  Buf: TBytes;
  P: Pointer;
begin
  {$ifdef VER120}Buf := nil; {$endif} // Warning в Delphi 4
  if (TargetCP = DefaultCompilerCP) or (TargetCP = CP_BINARY) then
  begin
    L := BinaryLength(S);
    P := Pointer(S);
  end
  else
  begin
    Buf := StringToBuf(S, TargetCP, False);
    L := Length(Buf);
    P := Pointer(Buf);
  end;
  
  if L = 0 then Exit;
  
  SetLength(Result, TextSizeForBase64Enc(L));
  BinToBase64(P, Pointer(Result), L);
end;

// Преобразовывает строку из Base64 в оригинальный вид
// Если исходная строка непустая, а результат - пустая,
// значит, ошибка декодирования 
function Base64_Decode(const S: string): string;
var
  L, C: DWord;
begin
  L := Length(S);
  C := BufSizeForBase64Dec(L); // Исходная строка должна быть кратной 4
  if C = 0 then Exit;
  
  // Чтобы избежать лишней подгонки размера строки,
  // заранее определяем точный размер результата
  if S[L-1] = '=' then Dec(C, 2)
  else if S[L] = '=' then Dec(C);
  
  // Base64-строка только в родной кодировке
  {$ifdef UNICODE}
    Inc(C, C and 1); // Округление в большую сторону
  {$endif}
  
  SetLength(Result, C div SizeOf(Char));
  L := Base64ToBin(Pointer(S), Pointer(Result), L);
  if L <> C then SetLength(Result, L div SizeOf(Char)); // После предыдущей подгонки L <> C только в случае ошибки (L = 0)
end;

function Base64_Decode(const S: string; SourceCP: Integer): string;
var
  L, C: DWord;
begin
  L := Length(S);
  C := BufSizeForBase64Dec(L); // Исходная строка должна быть кратной 4
  if C = 0 then Exit;
  
  // Чтобы избежать лишней подгонки размера строки,
  // заранее определяем точный размер результата
  if S[L-1] = '=' then Dec(C, 2)
  else if S[L] = '=' then Dec(C);

  {$ifdef UNICODE}
    Inc(C, C and 1); // Округление в большую сторону
  {$endif}
  
  SetLength(Result, C div SizeOf(Char));
  L := Base64ToBin(Pointer(S), Pointer(Result), L);
  if L = 0 then // Ошибка
  begin
    Result := '';
    Exit;
  end;
  
  if (SourceCP = DefaultCompilerCP) {$ifndef UNICODE}or (SourceCP = CP_BINARY){$endif}
  then
    Exit;
  
  Result := BufToString(Pointer(Result), L, SourceCP, False);
end;

// ====================================================== //



// ================ URL encoding / decoding ================ //

function URLEncodeBin(Buf: Pointer; BufLen: DWord; URLMode: Byte): string;
var
  i, idx, len: Integer;
  C: AnsiChar;

  function DigitToHex(Digit: Integer): Char;
  begin
    case Digit of
      0..9: Result := Chr(Digit + Ord('0'));
      10..15: Result := Chr(Digit - 10 + Ord('A'));
    else
      Result := '0';
    end;
  end; // DigitToHex

begin
  if BufLen = 0 then Exit;
  
  // Подсчет итогового размера
  len := 0;
  if URLMode = 0 then
  begin
    for i := 0 to BufLen-1 do
    begin
      C := PAnsiChar(NativeUInt(Buf) + DWord(i))^;
      if (((C >= '0') and (C <= '9')) or
         ((C >= 'A') and (C <= 'Z')) or
         ((C >= 'a') and (C <= 'z')) or (C = ' ') or
         (C = '_') or (C = '*') or (C = '-') or (C = '.'))
      then
        Inc(len)
      else
        Inc(len, 3);
    end;
  end
  else
    len := BufLen * 3;
  
  SetLength(Result, len);
  
  idx := 1;
  for i := 0 to BufLen-1 do
  begin
    C := PAnsiChar(Buf)^;
    if (C = ' ') and (URLMode = 0) then
    begin
      Result[idx] := '+';
      idx := idx + 1;
    end
    else
      if (((C >= '0') and (C <= '9')) or
         ((C >= 'A') and (C <= 'Z')) or
         ((C >= 'a') and (C <= 'z')) or
         (C = '_') or (C = '*') or (C = '-') or (C = '.')) and
         (URLMode = 0)
      then
      begin
        Result[idx] := Char(C);
        idx := idx + 1;
      end
      else
      begin
        Result[idx] := '%';
        //Result[idx + 1] := DigitToHex(Ord(C) div 16);
        //Result[idx + 2] := DigitToHex(Ord(C) mod 16);
        Result[idx + 1] := DigitToHex(Ord(C) shr 4);
        Result[idx + 2] := DigitToHex(Ord(C) and $0F);
        idx := idx + 3;
      end;
    Inc(NativeUInt(Buf));
  end;
end;


function URLEncode(const S: string; URLMode: Byte): string;
begin
  Result := URLEncodeBin(Pointer(S), BinaryLength(S), URLMode);
end;

function URLEncode(const S: string; URLMode: Byte; TargetCP: Integer): string;
var
  Buf: TBytes;
begin
  {$ifdef VER120}Buf := nil; {$endif} // Warning в Delphi 4
  if (TargetCP = DefaultCompilerCP) or (TargetCP = CP_BINARY) {$ifndef UNICODE} or (TargetCP = DefaultSystemCodePage){$endif} then
    Result := URLEncodeBin(Pointer(S), BinaryLength(S), URLMode)
  else
  begin
    Buf := StringToBuf(S, TargetCP, False);
    Result := URLEncodeBin(Pointer(Buf), Length(Buf), URLMode);
  end;
end;




function URLDecode(const S: string): AnsiString;
var
  i, idx, len, n_coded: Integer;
  
  function WebHexToInt(HexChar: Char): Integer;
  begin
    if HexChar < '0' then
      Result := Ord(HexChar) + 256 - Ord('0')
    else
      if HexChar <= Chr(Ord('A') - 1) then
        Result := Ord(HexChar) - Ord('0')
      else
        if HexChar <= Chr(Ord('a') - 1) then
          Result := Ord(HexChar) - Ord('A') + 10
        else
          Result := Ord(HexChar) - Ord('a') + 10;
  end;
  
begin
  len := 0;
  n_coded := 0;
  for i := 1 to Length(S) do
    if n_coded >= 1 then
    begin
      n_coded := n_coded + 1;
      if n_coded >= 3 then
      n_coded := 0;
    end
    else
    begin
      len := len + 1;
      if S[i] = '%' then
        n_coded := 1;
    end;
  SetLength(Result, len);
  
  idx := 0;
  n_coded := 0;
  
  for i := 1 to Length(S) do
  begin
    if n_coded >= 1 then
    begin
      n_coded := n_coded + 1;
        if n_coded >= 3 then
        begin
          Result[idx] := AnsiChar(((WebHexToInt(S[i - 1]) shl 4) or WebHexToInt(S[i])) {and $FF});
          n_coded := 0;
        end;
    end
    else
    begin
      idx := idx + 1;
      if S[i] = '%' then
        n_coded := 1;
      if S[i] = '+' then
        Result[idx] := ' '
      else
        Result[idx] := AnsiChar(S[i]);
    end;
  end;
end;

function URLDecode(const S: string; SourceCP: Integer): string;
var
  AnsiS: AnsiString;
begin
  AnsiS := URLDecode(S);
  {$ifdef UNICODE}
    Result := BufToString(Pointer(AnsiS), Length(AnsiS), SourceCP, False);
  {$else}
    if (SourceCP = DefaultCompilerCP) or (SourceCP = DefaultSystemCodePage) or (SourceCP = CP_BINARY) then
      Result := AnsiS
    else
      Result := BufToString(Pointer(AnsiS), Length(AnsiS), SourceCP, False);
  {$endif}
end;

// ====================================================== //




constructor THICharset.Create;
begin
  inherited;
  FCharset := DefaultCompilerCP;
end;

procedure THICharset.SetCharset(Value: Byte);
begin
  FCharset := OutCharsetProp[Value];
end;

procedure THICharset._work_doCharset0; // DOS->Str
begin
  _hi_CreateEvent(_Data, @_event_onCharset, ConvertCharset(ReadString(_Data, _data_Text, ''),
                  CP_OEMCP, DefaultCompilerCP));
end;

procedure THICharset._work_doCharset1; // Str->DOS
begin
  _hi_CreateEvent(_Data, @_event_onCharset, ConvertCharset(ReadString(_Data, _data_Text, ''),
                  DefaultCompilerCP, CP_OEMCP));
end;

procedure THICharset._work_doCharset2; // EN->RU
const en:string = 'qwertyuiop[]asdfghjkl;''zxcvbnm,./QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>?';
      ru:string = 'йцукенгшщзхъфывапролджэячсмитьбю.ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ,';
var i,p:cardinal;
    Result:string;
begin
   Result := ReadString(_Data, _data_Text, '');
   if Result <> '' then
    for i := 1 to Length(Result) do
     begin
        p := pos(Result[i],en);
        if p > 0 then
         Result[i] := ru[p];
     end;
   _hi_CreateEvent(_Data, @_event_onCharset,Result);
end;

procedure THICharset._work_doCharset3; // KOI8->Str
begin
  _hi_CreateEvent(_Data, @_event_onCharset, ConvertCharset(ReadString(_Data, _data_Text, ''),
                  CP_KOI8R, DefaultCompilerCP));
end;

procedure THICharset._work_doCharset4; // BASE64->Str
var
  S1, S2: string;
begin
  S1 := ReadString(_Data, _data_Text, '');
  S2 := Base64_Decode(S1, FCharset);
  if (S1 <> '') and (S2 = '') then
    _hi_CreateEvent(_Data, @_event_onError)
  else
    _hi_CreateEvent(_Data, @_event_onCharset, S2);
end;

procedure THICharset._work_doCharset5; // Str->BASE64
var
  C: Integer;
begin
  C := FCharset;
  if C = CP_AUTO_DETECT then C := DefaultCompilerCP;
  _hi_CreateEvent(_Data, @_event_onCharset, Base64_Code(ReadString(_Data, _data_Text, ''), C));
end;

procedure THICharset._work_doCharset6; // Str->UTF8
begin
  _hi_CreateEvent(_Data, @_event_onCharset, ConvertCharset(ReadString(_Data, _data_Text, ''),
              DefaultCompilerCP, CP_UTF8));
end;

procedure THICharset._work_doCharset7; // UTF8->Str
begin
  _hi_CreateEvent(_Data, @_event_onCharset, ConvertCharset(ReadString(_Data, _data_Text, ''),
              CP_UTF8, DefaultCompilerCP));
end;

procedure THICharset._work_doCharset8; // CP1->CP2
begin
  _hi_CreateEvent(_Data, @_event_onCharset, ConvertCharset(ReadString(_Data, _data_Text, ''),
                ReadInteger(_Data, _data_CodePage1, _prop_CodePage1),
                ReadInteger(_Data, _data_CodePage2, _prop_CodePage2)));
end;

procedure THICharset._work_doCharset9; // UNICODE->Str
var
  CPage: Integer;
  S: string;
begin
  S := ReadString(_Data, _data_Text, '');
  
  CPage := DetectCodePage(Pointer(S), BinaryLength(S), nil);
  if (CPage <> CP_UTF16) and (CPage <> CP_UTF16BE) then
  begin
    if _prop_InTypeUnicode = 0 then // Little-Endian
      CPage := CP_UTF16
    else
      CPage := CP_UTF16BE;
  end;
  
  _hi_CreateEvent(_Data, @_event_onCharset, ConvertCharset(S, CPage, DefaultCompilerCP, True, False));
end;

procedure THICharset._work_doCharset10; // Str->UNICODE
var
  OutBOM: Boolean;
  CPage: Integer;
  S: string;
begin
  S := ReadString(_Data, _data_Text, '');
  OutBOM := (_prop_OutTypeUnicode > 1); // 2,3
  if (_prop_OutTypeUnicode = 0) or (_prop_OutTypeUnicode = 2) then // Little-Endian
    CPage := CP_UTF16
  else
    CPage := CP_UTF16BE;
  
  _hi_CreateEvent(_Data, @_event_onCharset, ConvertCharset(S, DefaultCompilerCP, CPage, False, OutBOM));
end;

procedure THICharset._work_doCharset11; // URL->Str
begin
  _hi_CreateEvent(_Data, @_event_onCharset, URLDecode(ReadString(_Data, _data_Text, ''), FCharset));
end;

procedure THICharset._work_doCharset12; // Str->URL
var
  C: Integer;
begin
  C := FCharset;
  if C = CP_AUTO_DETECT then C := DefaultCompilerCP;
  _hi_CreateEvent(_Data, @_event_onCharset, URLEncode(ReadString(_Data, _data_Text, ''), _prop_URLMode, C));
end;

procedure THICharset._work_doCharset13; // ANSI->Str
begin
  {$ifdef UNICODE}
  _hi_CreateEvent(_Data, @_event_onCharset, ConvertCharset(ReadString(_Data, _data_Text, ''),
                  CP_ACP, CP_UTF16));
  {$else}
  _hi_CreateEvent(_Data, @_event_onCharset, ReadString(_Data, _data_Text, ''));
  {$endif}
end;

procedure THICharset._work_doCharset14; // Str->ANSI
begin
  {$ifdef UNICODE}
  _hi_CreateEvent(_Data, @_event_onCharset, ConvertCharset(ReadString(_Data, _data_Text, ''),
                  CP_UTF16, CP_ACP));
  {$else}
  _hi_CreateEvent(_Data, @_event_onCharset, ReadString(_Data, _data_Text, ''));
  {$endif}
end;





var
  AvailCodePages: array of TCPInfoEx;

threadvar
  TmpIdx: Integer;
  
function EnumCodePagesProc(CodePageID: PChar): Integer; stdcall;
var
  Cid: Integer;
  CPI: TCPInfoEx;
begin
  Result := 1;
  
  Cid := Str2Int({'$' +} CodePageID);
  if not GetCPInfoEx(Cid, 0, CPI) then Exit;


  if TmpIdx >= Length(AvailCodePages) then
    SetLength(AvailCodePages, TmpIdx + 100); // Увеличение массива с запасом

  AvailCodePages[TmpIdx] := CPI;
  Inc(TmpIdx);
end;
 
procedure ReadCodePages;
begin
  if AvailCodePages <> nil then Exit;
  
  SetLength(AvailCodePages, 150);
  TmpIdx := 0;  
  
  EnumSystemCodePages(@EnumCodePagesProc, CP_INSTALLED);
  
  // Подгоняется размер (в TmpIdx - количество заполненных элементов)
  SetLength(AvailCodePages, TmpIdx);
end;

procedure THICharset._work_doEnumCP;
var
  I: Integer;
  OutDT, TmpDT: TData;
begin
  ReadCodePages;
  
  for I := 0 to Length(AvailCodePages) - 1 do
  begin
    with AvailCodePages[I] do 
    begin
      dtString(OutDT, CodePageName);
      dtInteger(TmpDT, CodePage);
    end;
    OutDT.ldata := @TmpDT;  
    _hi_OnEvent(_event_onEnumCP, OutDT);
  end;  
end;

procedure THICharset._work_doCharset(var _Data: TData; Index: Word);
begin
  FCharset := ToInteger(_Data);
end;


procedure THICharset._var_ActiveCP(var _Data: TData; Index: Word);
begin
  dtInteger(_Data, DefaultSystemCodePage);
end;

procedure THICharset._var_CompilerCP(var _Data: TData; Index: Word);
begin
  dtInteger(_Data, DefaultCompilerCP);
end;

initialization
  FillBase64DecodeTable;

end.
