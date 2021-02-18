unit hiStreamConvertor;

interface

uses
  Windows, Kol, Share, Debug, CodePages;

type
  THIStreamConvertor = class(TDebug)
    private
      FCharset: Integer;
      
      procedure SetCharset(Value: Byte);
    public
      _prop_Mode: Byte;
      _prop_Symbol: string;
      _prop_InBOM: Byte;
      _prop_OutBOM: Byte;
      
      _data_Data: THI_Event;
      _event_onResult: THI_Event;
      
      property _prop_Charset: Byte write SetCharset;
      
      constructor Create;

      function Str2ASCII(const S: string; const Repl: Char): string;
      procedure _work_doConvert0(var _Data: TData; Index: Word); //StreamToHex
      procedure _work_doConvert1(var _Data: TData; Index: Word); //HexToStream
      procedure _work_doConvert2(var _Data: TData; Index: Word); //StringToHex
      procedure _work_doConvert3(var _Data: TData; Index: Word); //HexToString
      procedure _work_doConvert4(var _Data: TData; Index: Word); //StreamToASCII
      procedure _work_doConvert5(var _Data: TData; Index: Word); //StrToASCII
      procedure _work_doConvert6(var _Data: TData; Index: Word); //StreamToStr
      procedure _work_doConvert7(var _Data: TData; Index: Word); //StrToStream
      
      procedure _work_doCharset(var _Data: TData; Index: Word);
      procedure _work_doInBOM(var _Data: TData; Index: Word);
      procedure _work_doOutBOM(var _Data: TData; Index: Word);
  end;
  
  
  
  
  function Str2Hex(const S: string): string; overload;
  // TargetCP - преобразовать строку в указанную кодировку перед конвертацией
  function Str2Hex(const S: string; TargetCP: Integer; OutBOM: Boolean): string; overload;
  
  // До первого не-HEX символа
  function Hex2Str(const S: string): string; overload;
  // SourceCP - кодировка исходных данных, будут преобразованы в DefaultCompilerCP
  function Hex2Str(const S: string; SourceCP: Integer; DiscardBOM: Boolean): string; overload;
  
  // Любые не-HEX символы пропускаются
  function Hex2Str2(const S: string): string; overload;
  function Hex2Str2(const S: string; SourceCP: Integer; DiscardBOM: Boolean): string; overload;
  

  
  // Преобразовывает байты из Buffer в их двухсимвольное HEX-представление
  // и помещает результат в буфер Text. Размер буфера Text должен быть BufSize*2
  procedure Bin2Hex(Buffer: Pointer; Text: PChar; BufSize: Integer);
  
  // Преобразовывает двухсимвольное HEX-представление байтов из Text
  // в их двоичное значение и помещает результат в Buffer.
  // BufSize должен быть не меньше Length(Text) div 2
  // Преобразование останавливается при обнаружении первого не-HEX символа в Text
  // Возвращает количество записанных в Buffer байт  
  function Hex2Bin(Text: PChar; Buffer: Pointer; BufSize: Integer): Integer;
  
  
  // Аналогично Hex2Bin, но допускается наличие любых символов в Text
  //  - не-HEX символы будут пропущены.
  // Параметр TextSize указывает количество символов в Text
  // Размер Buffer должен быть не меньше TextSize div 2
  // Возвращает количество записанных в Buffer байт
  function Hex2Bin2(Text: PChar; Buffer: Pointer; TextSize: Integer): Integer;
  

const
  HexChars: array[0..15] of Char = '0123456789ABCDEF';
  

implementation


const 
  Convert: array['0'..'f'] of ShortInt =
    ( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,-1,-1,-1,-1,-1,-1,
     -1,10,11,12,13,14,15,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,10,11,12,13,14,15);

procedure Bin2Hex(Buffer: Pointer; Text: PChar; BufSize: Integer);
var
  I: Integer;
begin
  for I := 0 to BufSize - 1 do
  begin
    Text[0] := HexChars[Byte(Buffer^) shr 4];
    Text[1] := HexChars[Byte(Buffer^) and $F];
    Inc(Text, 2);
    Inc(NativeUInt(Buffer));
  end;
end;

function Hex2Bin(Text: PChar; Buffer: Pointer; BufSize: Integer): Integer;
var
  I: Integer;
begin
  I := BufSize;
  while I > 0 do
  begin
    // Быстрее, но символы между '9' и 'A', и 'F' и 'a' не считаются ошибочными
    //if not (Text[0] in ['0'..'f']) or not (Text[1] in ['0'..'f']) then Break;
    
    if not (Text[0] in ['0'..'9','A'..'F','a'..'f']) or
       not (Text[1] in ['0'..'9','A'..'F','a'..'f'])
    then
      Break;
      
    Byte(Buffer^) := (Convert[Text[0]] shl 4) or Convert[Text[1]];
    Inc(NativeUInt(Buffer));
    Inc(Text, 2);
    Dec(I);
  end;
  Result := BufSize - I;
end;

function Hex2Bin2(Text: PChar; Buffer: Pointer; TextSize: Integer): Integer;
var
  B: SmallInt;
  C: Char;
  FirstHalf: Boolean;
begin
  Result := 0;
  B := 0;
  FirstHalf := True;
  while TextSize > 0 do
  begin
    C := Text[0];
    if (C in ['0'..'9','a'..'f','A'..'F']) then
    begin
      if FirstHalf then
      begin
        B := Convert[C] shl 4;
        FirstHalf := False;
      end
      else
      begin
        B := B or Convert[C];
        FirstHalf := True;
        SmallInt(Buffer^) := B;
        Inc(NativeUInt(Buffer));
        Inc(Result);
      end;
    end;
    Inc(Text);
    Dec(TextSize);
  end;
  // Последний непарный HEX-символ не будет учтен
end;

function Str2Hex(const S: string): string;
var
  Len: Integer;
begin
  Len := BinaryLength(S);
  SetLength(Result, Len * 2);
  Bin2Hex(Pointer(S), Pointer(Result), Len);
end;

function Str2Hex(const S: string; TargetCP: Integer; OutBOM: Boolean): string;
var
  Len: Integer;
  {$ifdef UNICODE}TmpL: DWord;{$endif}
  Buf: TBytes;
begin
  {$ifdef VER120}Buf := nil;{$endif} // Warning Delphi 4
  if (TargetCP = DefaultCompilerCP) or (TargetCP = CP_BINARY) {$ifndef UNICODE}or (TargetCP = DefaultSystemCodePage){$endif} then
  begin
    Len := BinaryLength(S);
    SetLength(Result, Len * 2);
    Bin2Hex(Pointer(S), Pointer(Result), Len);
    // При UNICODE DefaultCompilerCP=CP_UTF16 - прописываем BOM, если надо
    {$ifdef UNICODE}
    if (OutBOM) and (TargetCP = CP_UTF16) and (DetectBOM(Pointer(S), Len, @TmpL) <> btUTF16LE) then
    begin
      Result := 'FFFE' + Result;
    end;
    {$endif}
  end
  else
  begin
    Buf := StringToBuf(S, TargetCP, OutBOM);
    Len := Length(Buf);
    SetLength(Result, Len * 2);
    Bin2Hex(Pointer(Buf), Pointer(Result), Len);
  end;
end;

function Hex2Str(const S: string): string;
var
  L, LBuf: Integer;
begin
  L := Length(S);
  LBuf := L div 2;
  {$ifdef UNICODE}Dec(LBuf, (LBuf and 1));{$endif} // Если подана неполная HEX-строка - округляем
  SetLength(Result, LBuf div SizeOf(Char));
  L := Hex2Bin(Pointer(S), Pointer(Result), LBuf);
  if L <> LBuf then SetLength(Result, L div SizeOf(Char));
end;

function Hex2Str(const S: string; SourceCP: Integer; DiscardBOM: Boolean): string;
var
  LBuf: Integer;
  {$ifdef UNICODE}DestL: Integer;{$endif}
  Buf: TBytes;
begin
  if (SourceCP = DefaultCompilerCP) {$ifndef UNICODE}or (SourceCP = CP_BINARY) or (SourceCP = DefaultSystemCodePage){$endif} then
  begin
    Result := Hex2Str(S);
    {$ifdef UNICODE}
      if (DiscardBOM) and (SourceCP = CP_UTF16) and (DetectBOM(Pointer(Result), ByteLength(Result), nil) = btUTF16LE) then
      begin
        Result := Copy(Result, 2, Length(Result){-1});
      end;
    {$endif}
  end
  else
    {$ifdef UNICODE}
    if SourceCP = CP_BINARY then
    begin
      LBuf := Length(S) div 2;
      DestL := BinaryStrSize(LBuf); // Размер строки в символах для LBuf байт
      SetLength(Result, DestL);
      LBuf := Hex2Bin(Pointer(S), Pointer(Result), LBuf);
      // LBuf содержит длину исходных данных в байтах.
      // Формируем строку с дополнением, после чего
      // LBuf содержит длину результ. строки в символах
      LBuf := PadBinaryBuf(Pointer(Result), LBuf);
      // Подгоняем размер строки
      if LBuf <> DestL then SetLength(Result, LBuf);
    end
    else
    {$endif}
    begin
      LBuf := Length(S) div 2;
      SetLength(Buf, LBuf);
      LBuf := Hex2Bin(Pointer(S), Pointer(Buf), LBuf);
      Result := BufToString(Pointer(Buf), LBuf, SourceCP, DiscardBOM);    
    end;
end;

function Hex2Str2(const S: string): string;
var
  L, LBuf: Integer;
begin
  L := Length(S);
  LBuf := L div 2;
  SetLength(Result, LBuf div SizeOf(Char));
  L := Hex2Bin2(Pointer(S), Pointer(Result), L);
  if L <> LBuf then SetLength(Result, L div SizeOf(Char));
end;

function Hex2Str2(const S: string; SourceCP: Integer; DiscardBOM: Boolean): string;
var
  LBuf: Integer;
  {$ifdef UNICODE}DestL: Integer;{$endif}
  Buf: TBytes;
begin
  if (SourceCP = DefaultCompilerCP) {$ifndef UNICODE}or (SourceCP = CP_BINARY) or (SourceCP = DefaultSystemCodePage){$endif} then
  begin
    Result := Hex2Str2(S);
    {$ifdef UNICODE}
      if (DiscardBOM) and (SourceCP = CP_UTF16) and (DetectBOM(Pointer(Result), ByteLength(Result), nil) = btUTF16LE) then
      begin
        Result := Copy(Result, 2, Length(Result){-1});
      end;
    {$endif}
  end
  else
    {$ifdef UNICODE}
    if SourceCP = CP_BINARY then // Избегаем лишнего копирования по BufToString()
    begin
      LBuf := Length(S) div 2;
      DestL := BinaryStrSize(LBuf);
      SetLength(Result, DestL);
      LBuf := Hex2Bin2(Pointer(S), Pointer(Result), LBuf);
      LBuf := PadBinaryBuf(Pointer(Result), LBuf);
      if LBuf <> DestL then SetLength(Result, LBuf);
    end
    else
    {$endif}
    begin
      LBuf := Length(S) div 2;
      SetLength(Buf, LBuf);
      LBuf := Hex2Bin2(Pointer(S), Pointer(Buf), LBuf);
      Result := BufToString(Pointer(Buf), LBuf, SourceCP, DiscardBOM);    
    end;
end;





constructor THIStreamConvertor.Create;
begin
  inherited;
  FCharset := DefaultCompilerCP;
  _prop_InBOM := 1;
  _prop_OutBOM := 0;
end;

procedure THIStreamConvertor.SetCharset(Value: Byte);
begin
  FCharset := InCharsetProp[Value];
end;



function THIStreamConvertor.Str2ASCII(const S: string; const Repl: Char): string;
var
  I, Len, P: Integer;
begin
  I := 0;
  P := 0;
  Len := Length(S);
  SetLength(Result, Len);
  
  while P < len do
  begin
    Inc(P);
    Inc(I);
    if S[P] >= ' ' then Result[I] := S[P]
    else
      if Repl > #0 then Result[I] := Repl
      else Dec(I);
  end;
  
  SetLength(Result, I);
end;

procedure THIStreamConvertor._work_doConvert0(var _Data: TData; Index: Word); //StreamToHex
var
  S: string;
  Buf: TBytes;
  St: PStream;
  Len: DWord;
begin
  St := ReadStream(_data, _data_Data);
  if St = nil then Exit;
  
  Len := St.Size;
  if Len > 0 then
  begin
    St.Position := 0;
    SetLength(Buf, Len);
    Len := St.Read(Buf[0], Len);
    SetLength(S, Len*2);
    Bin2Hex(Pointer(Buf), Pointer(S), Len);
  end;
  
  _hi_CreateEvent(_Data, @_event_onResult, S);
end;

procedure THIStreamConvertor._work_doConvert1(var _Data: TData; Index: Word); //HexToStream
var
  S: string;
  St: PStream;
  Buf: TBytes;
  Len: Integer;
begin
  S := ReadString(_Data, _data_Data);
  Len := Length(S);
  St := NewMemoryStream;
  if Len >= 2 then
  begin
    Len := Len div 2;
    SetLength(Buf, Len);
    Len := Hex2Bin(Pointer(S), Pointer(Buf), Len);
    St.Write(Buf[0], Len);
    St.Position := 0;
  end;
  _hi_OnEvent(_event_onResult, St);
  St.Free;
end;

procedure THIStreamConvertor._work_doConvert2(var _Data: TData; Index: Word); //StringToHex
var
  C: Integer;
begin
  C := FCharset;
  if C = CP_AUTO_DETECT then C := DefaultCompilerCP;
  _hi_CreateEvent(_Data, @_event_onResult, Str2Hex(ReadString(_Data, _data_Data), C, _prop_OutBOM <> 0));
end;

procedure THIStreamConvertor._work_doConvert3(var _Data: TData; Index: Word); //HexToString
begin
  _hi_OnEvent(_event_onResult, Hex2Str(ReadString(_Data, _data_Data), FCharset, _prop_InBOM <> 0));
end;

procedure THIStreamConvertor._work_doConvert4(var _Data: TData; Index: Word); //StreamToASCII
{$ifdef UNICODE}
begin
  MessageBox(0, PChar('Mode=StreamToASCII not supported in UNICODE compiler.'), PChar('StreamConvertor'), MB_OK + MB_ICONWARNING);
end;
{$else}
var
  S: string;
  St: PStream;
  len: integer;
begin
  St := ReadStream(_data,_data_Data);
  if St = nil then Exit;
  len := St.Size;
  St.Position := 0;
  SetLength(S, len);
  if len > 0 then St.Read(S[1], len);
  _hi_CreateEvent(_Data, @_event_onResult, Str2ASCII(S, (_prop_Symbol+#0)[1]));
end;
{$endif}

procedure THIStreamConvertor._work_doConvert5(var _Data: TData; Index: Word); //StrToASCII
{$ifdef UNICODE}
begin
  MessageBox(0, PChar('Mode=StrToASCII not supported in UNICODE compiler.'), PChar('StreamConvertor'), MB_OK + MB_ICONWARNING);
end;
{$else}
begin
  _hi_CreateEvent(_Data, @_event_onResult, Str2ASCII(ReadString(_Data, _data_Data), (_prop_Symbol+#0)[1]));
end;
{$endif}

procedure THIStreamConvertor._work_doConvert6(var _Data: TData; Index: Word); //StreamToStr
var
  S: string;
  St: PStream;
begin
  St := ReadStream(_data, _data_Data);
  if St = nil then Exit;
  
  St.Position := 0;
  S := StreamReadString(St, St.Size, FCharset, _prop_InBOM <> 0);
  _hi_CreateEvent(_Data, @_event_onResult, S);
end;

procedure THIStreamConvertor._work_doConvert7(var _Data: TData; Index: Word); //StrToStream
var
  S: string;
  St: PStream;
  C: Integer;
begin
  C := FCharset;
  if C = CP_AUTO_DETECT then C := DefaultCompilerCP;
  
  S := ReadString(_Data, _data_Data);
  St := NewMemoryStream;
  StreamWriteString(St, S, C, _prop_OutBOM <> 0);
  St.Position := 0;
  _hi_OnEvent(_event_onResult, St);
  St.Free;
end;

procedure THIStreamConvertor._work_doCharset(var _Data: TData; Index: Word);
begin
  FCharset := ToInteger(_Data);
end;

procedure THIStreamConvertor._work_doInBOM(var _Data: TData; Index: Word);
begin
  _prop_InBOM := ToInteger(_Data) and 1;
end;

procedure THIStreamConvertor._work_doOutBOM(var _Data: TData; Index: Word);
begin
  _prop_OutBOM := ToInteger(_Data) and 1;
end;

end.
