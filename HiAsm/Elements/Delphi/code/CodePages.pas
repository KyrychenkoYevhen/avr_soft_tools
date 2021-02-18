// =========================================== //
//                                             //
//  ������� ������ �� �������� � �����������   //
//              ������ 2018-04-24              //
//                                             //
//               ������  HiAsm                 //
//               www.hiasm.com                 //
//                                             //
//             �����: Netspirit                //
//         E-mail: netspirit@meta.ua           //
//                                             //
// =========================================== //

unit CodePages;

interface

uses
  Windows, KOL, Share;

type
  TBOMType = (btNone, btUTF16LE, btUTF16BE, btUTF8);
  
const

  {
    CP_ACP     = 0;     // default to ANSI code page
    CP_OEMCP   = 1;     // default to OEM (console) code page
    CP_UTF16   = 1200;  // utf-16
    CP_UTF16BE = 1201;  // unicodeFFFE, �������������� ��� CP_UTF16, � ������������� ���� ��������.
    CP_UTF7    = 65000; // utf-7
    CP_UTF8    = 65001; // utf-8
    CP_ASCII   = 20127; // us-ascii
    CP_KOI8R   = 20866; // Russian KOI8-R
    CP_KOI8U   = 21866; // Ukrainian KOI8-U
    CP_NONE    = $FFFF; // rawbytestring encoding
  }

{$ifndef FPC_NEW}
  CP_UTF16 = 1200;
{$endif}
  
  DefaultCompilerCP = {$ifdef UNICODE}CP_UTF16{$else}CP_ACP{$endif};


  CP_KOI8R = 20866;
  CP_KOI8U = 21866;
  
  // �� �������� �������������� ������� ��������� Windows.
  // �������������� ��� CP_UTF16, � ������������� ���� ��������.
  CP_UTF16BE = 1201;
  
  CP_AUTO_DETECT = 9; // �������, ���� ����������� �������� � ������������ ��������� ����������
  CP_BINARY = $FFFF; // CP_NONE;
  
  UTF8SigLen = 3;



var
  BOM: WideChar = #$FEFF; // Little-endian, � ����� ��������� ��� $FF $FE
  AnsiBOM: AnsiString = #$FF#$FE;
  
  BOM_BE: WideChar = #$FFFE;
  AnsiBOM_BE: AnsiString = #$FE#$FF;
  
  UTF8_SIGNATURE: AnsiString = #$EF#$BB#$BF;
  
  {$ifdef UNICODE}
    StrTermZeroW: string = #$0000;
    StrTermZeroA: string = #0000#0003; // 1 ����, ������ $0 � ������� binary string
    
    StrTermEOL_W: string = #$000D#$000A;
    StrTermEOL_W_BE: string = #$0D00#$0A00;
    StrTermEOL_A: string = #$0A0D; // 2 �����, ������ $0D$0A
  {$else}
    StrTermZeroW: string = #0#0;
    StrTermZeroA: string = #0;
    
    StrTermEOL_W: string = #$0D#$00#$0A#$00;
    StrTermEOL_W_BE: string = #$00#$0D#$00#$0A;
    StrTermEOL_A: string = #$0D#$0A;
  {$endif}

  
const
  CodePageByBOM: array [TBOMType] of Word = (CP_ACP, CP_UTF16, CP_UTF16BE, CP_UTF8);
  
  
  InCharsetPropText: array [0..4] of Integer =
  (
    DefaultCompilerCP, // Compiler
    CP_AUTO_DETECT,    // Detect
    CP_ACP,
    CP_UTF16,
    CP_UTF8
  );
  
  OutCharsetPropText: array [0..3] of Integer =
  (
    DefaultCompilerCP, // Compiler
    CP_ACP,
    CP_UTF16,
    CP_UTF8
  );
  
  InCharsetProp: array [0..5] of Integer =
  (
    DefaultCompilerCP, // Compiler
    CP_AUTO_DETECT,    // Detect
    CP_BINARY, // Binary data as string
    CP_ACP,
    CP_UTF16,
    CP_UTF8
  );
  
  OutCharsetProp: array [0..4] of Integer =
  (
    DefaultCompilerCP, // Compiler
    CP_BINARY, // Binary data as string
    CP_ACP,
    CP_UTF16,
    CP_UTF8 
  );


  procedure SwapByteOrder(SrcBuf, DstBuf: PWideChar; BufLen: DWord); overload; // BufLen - � ������
  procedure SwapByteOrder(Buffer: PWideChar; BufLen: DWord); overload; // BufLen - � ������
  procedure SwapByteOrder(var S: WideString); overload;

  function DetectBOM(Buf: Pointer; BufLen: DWord; OutBOMLen: PDWord): TBOMType; overload;
  function DetectBOM(Stream: PStream; OutBOMLen: PDWord): TBOMType; overload;
  
  // ���������� ��������� ������ � ������ �� BOM
  function DetectCodePage(Buf: Pointer; BufLen: DWord; OutBOMLen: PDWord): Integer; overload;
  // ���������� ��������� ������ �� BOM. �������� ������ ��� Position=0.
  // ��������� Position ����������.
  // TODO: ���������� ��� ����� �������, �������� �� 0?
  function DetectCodePage(Stream: PStream; OutBOMLen: PDWord): Integer; overload;
  
  
  // �������� ������ AnsiString � binary string ��� �������������� 
  function AnsiStringAsBinaryString(const S: AnsiString): WideString;
  function BinaryStringAsAnsiString(const S: WideString): AnsiString;

  // ������������� ������, ������ ��� �����������, � ��������� ��������� � ��������� � �����
  // OutBOM - �������� ����� BOM
  // �������������� ����� CP_BINARY.
  function StringToBuf(const S: string; TargetCP: Integer; OutBOM: Boolean = False): TBytes;
  
  // ������������� ������ � ��������� ��������� �� ������ � ������, ������ ��� �����������
  // DiscardBOM - ��������� BOM, ���� ������������.
  // ���� �������������� ������ �� � ������ �����, BOM ������ �������� ������ ������ (� CP_UTF16 BOM_BE - �� �������� ������)
  // �������������� CP_AUTO_DETECT, CP_BINARY
  function BufToString(Buf: Pointer; BufLen: DWord; SourceCP: Integer; DiscardBOM: Boolean = True): string;

  // ����� ��������� ������. � ������ UNICODE S � ������������ ��������� SourceCP ������ ���� "binary string" (� �����������).
  // ��� TargetCP<>CP_UTF16 ��������� ����� �������� "binary string"
  // CP_AUTO_DETECT �� ��������������
  function ConvertCharset(const S: string; SourceCP, TargetCP: Integer; RemoveInBOM: Boolean = False; OutBOM: Boolean = False): string;
  
  // ��������� ������ �� ������� ������� ������.
  // �������������� CP_AUTO_DETECT (��� Position=0), CP_BINARY.
  // DiscardBOM - ��� Position=0 ��������� BOM, ���� ������������.
  function StreamReadString(Stream: PStream; RawLen: DWord; SourceCP: Integer = DefaultCompilerCP; DiscardBOM: Boolean = True): string;
  // ��������� �������� ������ �� ������ � ��������� � ������
  function StreamReadBinary(Stream: PStream; RawLen: DWord): string;
  // �������� ������ � ������� ������� ������.
  // �������������� CP_BINARY.
  // OutBOM - �������� BOM ��� Position=0.
  function StreamWriteString(Stream: PStream; const S: string; TargetCP: Integer = DefaultCompilerCP; OutBOM: Boolean = True): Boolean;
  
  // ��������� ���������� �� ������� ������� ������ � ������, ���� �� ����� 
  // ��������� ��������� ������������ ��� ����� ������
  // ������� � ������ ����� ����������� �� ����� ���������� ������������ ��� 
  // �� ��������� ���� ����� ��������� ������
  function StreamReadStringBeforeTerm(Stream: PStream; Term: Pointer; TermLen: Integer): AnsiString; overload;
  // �� ��, � ��������������� ���������. BOM �������������.
  function StreamReadStringBeforeTerm(Stream: PStream; Term: string; SourceCP: Integer): string; overload;
  
  // ��������� ������, �������������� #0 (��� #0#0 � ����������� �� SourceCP) �� ������� ������� ������.
  function StreamReadStringZ(Stream: PStream; SourceCP: Integer): string;
  // ��������� ������, �������������� #13#10 (��� #0013#0010 � ����������� �� SourceCP) �� ������� ������� ������.
  function StreamReadLine(Stream: PStream; SourceCP: Integer): string;
  
  // �������� ������ � ���������� �� #0 (��� #0#0 � ����������� �� TargetCP) � ������� ������� ������.
  // OutBOM - ������� BOM, ���� ������ ������������ � ������ ������ (Position=0)
  function StreamWriteStringZ(Stream: PStream; const S: string; TargetCP: Integer; OutBOM: Boolean = True): Boolean;
  // �������� ������ � ���������� �� #13#10 (��� #0013#0010 � ����������� �� TargetCP) � ������� ������� ������.
  function StreamWriteLine(Stream: PStream; const S: string; TargetCP: Integer; OutBOM: Boolean = True): Boolean;
  
  // ���������� ������ ����� � ������������ ���������
  function StrListSaveToStream(StrList: PKOLStrList; Stream: PStream; TargetCP: Integer = DefaultCompilerCP; OutBOM: Boolean = True): Boolean;
  function StrListSaveToFile(StrList: PKOLStrList; const FileName: string; TargetCP: Integer = DefaultCompilerCP; OutBOM: Boolean = True; Append: Boolean = False): Boolean;
  
  // �������� ������ �� ������� ������� ������.
  // ��� Append = True ����� ���������� ����������� � ����� ������, ����� ������ ����������.
  function StrListLoadFromStream(StrList: PKOLStrList; Stream: PStream; RawLen: DWord; SourceCP: Integer = DefaultCompilerCP; Append: Boolean = False): Boolean;
  // �������� ������ �� �����.
  function StrListLoadFromFile(StrList: PKOLStrList; const FileName: string; SourceCP: Integer = DefaultCompilerCP; Append: Boolean = False): Boolean;





implementation


function BSwap(const x: Word): Word; assembler; {$ifdef FPC64} nostackframe; {$endif} overload;
asm
  {$ifdef WIN64}
  mov eax, ecx
  {$endif}
  {bswap eax
  shr eax, 16} 
  // ���:
  xchg al, ah 
end;

// TODO: ���������� ��������� �� ����������
procedure SwapByteOrder(SrcBuf, DstBuf: PWideChar; BufLen: DWord); overload;  // BufLen - � ������
begin
  while BufLen >= SizeOf(WideChar) do
  begin
    DstBuf^ := WideChar(BSwap(Word(SrcBuf^)));
    Inc(SrcBuf);
    Inc(DstBuf);
    Dec(BufLen, SizeOf(WideChar));
  end;
end;

procedure SwapByteOrder(Buffer: PWideChar; BufLen: DWord); overload;  // BufLen - � ������
begin
  while BufLen >= SizeOf(WideChar) do
  begin
    Buffer^ := WideChar(BSwap(Word(Buffer^)));
    Inc(Buffer);
    //Word(Buffer^) := BSwap(Word(Buffer^));
    //Inc(NativeUInt(Buffer), SizeOf(WideChar));
    Dec(BufLen, SizeOf(WideChar));
  end;
end;

procedure SwapByteOrder(var S: WideString); overload;
begin
  // ������������ ������
  {$ifdef VER120}
  SetLength(S, Length(S)); // Delphi 4 �� ����� UniqueString(<WideString>)
  {$else}
  UniqueString(S);
  {$endif}
  
  SwapByteOrder(PWideChar(S), Length(S) * SizeOf(WideChar));
end;





function DetectBOM(Buf: Pointer; BufLen: DWord; OutBOMLen: PDWord): TBOMType;
var
  L: DWord;
label
  finish;
begin
  Result := btNone;
  L := 0;
  
  if BufLen >= SizeOf(WideChar) then
  begin
    if WideChar(Buf^) = BOM then
    begin
      Result := btUTF16LE;
      L := SizeOf(WideChar);
      goto finish;
    end;

    if WideChar(Buf^) = BOM_BE then
    begin
      Result := btUTF16BE;
      L := SizeOf(WideChar);
      goto finish;
    end;
  end;
  
  if (BufLen >= UTF8SigLen) and CompareMem(Pointer(UTF8_SIGNATURE), Buf, UTF8SigLen) then
  begin
    Result := btUTF8;
    L := UTF8SigLen;
  end;
  
finish:
  if OutBOMLen <> nil then OutBOMLen^ := L;
end;

function DetectBOM(Stream: PStream; OutBOMLen: PDWord): TBOMType;
var
  Buf: array[0..UTF8SigLen-1] of Byte;
  R: DWord;
begin
  R := Stream.Read(Buf, UTF8SigLen);
  Result := DetectBOM(@Buf, R, OutBOMLen);
  //Stream.Seek(-(R - OutBOMLen^), spCurrent); // ��������� ������� � ������ �� ����� BOM (��� ��������������)
  Stream.Seek(-R, spCurrent); // �������������� �������
end;

function DetectCodePage(Buf: Pointer; BufLen: DWord; OutBOMLen: PDWord): Integer;
var
  BT: TBOMType;
begin
  BT := DetectBOM(Buf, BufLen, OutBOMLen);
  
  // TODO: ����������� ��������� �� ����� ����������� ����������
  
  // UTF-16 �� BOM
  // UTF-8 �� ���������, ����� ANSI
  Result := CodePageByBOM[BT];
end;

function DetectCodePage(Stream: PStream; OutBOMLen: PDWord): Integer;
var
  BT: TBOMType;
begin
  if Stream.Position <> 0 then // BOM ������ � ������ ������
  begin
    BT := btNone;
    if OutBOMLen <> nil then OutBOMLen^ := 0;
  end
  else
    BT := DetectBOM(Stream, OutBOMLen);
  
  Result := CodePageByBOM[BT];
end;

function AnsiStringAsBinaryString(const S: AnsiString): WideString;
var
  L, CharL: DWord;
  W: Word;
begin
  Result := '';
  if S = '' then Exit;
  L := Length(S);
  
  CharL := L div SizeOf(WideChar);
  
  // =1, ���� ������ ��������� 2, ����� =0
  W := L mod SizeOf(WideChar);
  
  // + ���� ������ ���������� � ��� ���� ������ ��� ��������� ����
  Inc(CharL, W + 1);
  
  Inc(W, SizeOf(WideChar)); // 0||1 + 2 = ���������� ���� ����������  
  
  SetLength(Result, CharL);
  
  Move(Pointer(S)^, Result[1], L);
  Result[CharL] := WideChar(W); // 2 ����� ����������
end;

function BinaryStringAsAnsiString(const S: WideString): AnsiString;
var
  L, CharL: DWord;
  W: Word;
begin
  Result := '';
  if S = '' then Exit;
  CharL := Length(S);
  L := CharL * SizeOf(WideChar); // � ������
  
  // ���� ��������� ������ ����� #2 ��� #3 - ������, ��� ����������
  // �������� ������ (�� ����������� � ����� ��������� �������).
  // ��������� ������ �������� ������ � ������ ��� ����������.
  W := Word(S[CharL]);
  if W in [2, 3] then Dec(L, W); // W = 2-3 ����� ����������
  
  if L > 0 then
  begin
    SetLength(Result, L);
    Move(Pointer(S)^, Result[1], L);
  end;
end;

function StringToBuf(const S: string; TargetCP: Integer; OutBOM: Boolean = False): TBytes;
{$ifdef UNICODE}
var
  L, DestL: DWord;
begin
  Result := nil;
  L := Length(S);
  if L = 0 then Exit;
  
  if (TargetCP = CP_UTF16) or (TargetCP = CP_UTF16BE) then
  begin
    if IsBinaryString(S) then Dec(L); // UTF-16 � ����� binary string
    
    DestL := L * SizeOf(WideChar);
    
    if (OutBOM) and (not (DetectBOM(Pointer(S), DestL, nil) in [btUTF16LE, btUTF16BE])) then
    begin
      SetLength(Result, DestL + SizeOf(WideChar));
      Move(S[1], Result[SizeOf(WideChar)], DestL);
      PWideChar({@Result[0]} Result)^ := BOM;
    end
    else
    begin
      SetLength(Result, DestL);
      Move(S[1], Result[0], DestL);
    end;
    
    if TargetCP = CP_UTF16BE then SwapByteOrder(Pointer(Result), Length(Result));
    
    Exit;
  end;
  
  if TargetCP = CP_BINARY then
  begin
    DestL := BinaryLength(S);
    SetLength(Result, DestL);
    Move(S[1], Result[0], DestL);
    Exit;
  end;
  
  DestL := WideCharToMultiByte(TargetCP, 0, Pointer(S), L, nil, 0, nil, nil);
  if DestL = 0 then Exit;
  
  if (TargetCP = CP_UTF8) and (OutBOM) then
  begin
    SetLength(Result, DestL + UTF8SigLen);
    
    if WideCharToMultiByte(TargetCP, 0, Pointer(S), L, @Result[UTF8SigLen], DestL, nil, nil) = 0 then
      Result := nil // Error  
    else
      Move(UTF8_SIGNATURE[1], Result[0], UTF8SigLen);
  end
  else
  begin
    SetLength(Result, DestL);
    if WideCharToMultiByte(TargetCP, 0, Pointer(S), L, Pointer(Result), DestL, nil, nil) = 0 then
      Result := nil; // Error      
  end;
end;
{$else}
var
  L, DestL: DWord;
  TmpWS: WideString;
begin
  Result := nil;
  
  L := Length(S);
  if L = 0 then Exit;
  
  if (TargetCP = CP_ACP) or (TargetCP = CP_BINARY) or (TargetCP = DefaultSystemCodePage) then
  begin
    SetLength(Result, L);
    Move(S[1], Result[0], L);
    Exit;
  end;

  // ����� ��������� AnsiString ���������� � ��� ������: ������� � ������, ����� �� ������� � ������� ���������  
  
  if (TargetCP = CP_UTF16) or (TargetCP = CP_UTF16BE) then // � ���� ������ ����� � ���� �����
  begin
    DestL := MultiByteToWideChar(CP_ACP, 0, Pointer(S), L, nil, 0);
    if DestL = 0 then Exit;
    
    if OutBOM then
    begin
      SetLength(Result, (DestL + 1) * SizeOf(WideChar));
      if MultiByteToWideChar(CP_ACP, 0, Pointer(S), L, @Result[SizeOf(BOM)], DestL) = 0 then
        Result := nil // Error
      else
        PWideChar(Pointer(Result))^ := BOM;
    end
    else
    begin
      SetLength(Result, DestL * SizeOf(WideChar));
      if MultiByteToWideChar(CP_ACP, 0, Pointer(S), L, Pointer(Result), DestL) = 0 then
        Result := nil; // Error
    end;
    
    if TargetCP = CP_UTF16BE then SwapByteOrder(Pointer(Result), Length(Result));
    
    Exit;
  end;
  
  // 1) � ������
 
  //TmpWS := AnsiStringToWideString(S, CP_ACP);
  TmpWS := S; // ���������� ������������� �������������
  
  // 2) � �������� ���������
  L := Length(TmpWS);
  if L = 0 then Exit;   
  
  DestL := WideCharToMultiByte(TargetCP, 0, Pointer(TmpWS), L, nil, 0, nil, nil);
  if DestL = 0 then Exit;
  
  if (TargetCP = CP_UTF8) and (OutBOM) then
  begin
    SetLength(Result, DestL + UTF8SigLen);
    if WideCharToMultiByte(TargetCP, 0, Pointer(TmpWS), L, @Result[UTF8SigLen], DestL, nil, nil) = 0 then
      Result := nil // Error
    else
      Move(UTF8_SIGNATURE[1], Result[0], UTF8SigLen);
  end
  else
  begin
    SetLength(Result, DestL);
    if WideCharToMultiByte(TargetCP, 0, Pointer(TmpWS), L, Pointer(Result), DestL, nil, nil) = 0 then
      Result := nil; // Error
  end;

end;
{$endif}


function BufToString(Buf: Pointer; BufLen: DWord; SourceCP: Integer; DiscardBOM: Boolean = True): string;
{$ifdef UNICODE}
var
  DestL, dwFlags: DWord;
begin 
  if SourceCP = CP_AUTO_DETECT then
  begin
    SourceCP := DetectCodePage(Buf, BufLen, @DestL);
    // ���������� BOM (������ - � DestL)
    if DiscardBOM then
    begin
      Inc(NativeUInt(Buf), DestL);
      Dec(BufLen, DestL);
      DiscardBOM := False; // ����� ���� �� ���������
    end;
  end;
  
  Result := '';
  if BufLen = 0 then Exit;
  
  case SourceCP of
    CP_UTF16, CP_UTF16BE:
      begin
        DestL := BufLen div SizeOf(WideChar); 
        if DestL = 0 then Exit;

        // ���������� � ������ BOM //
        // �� ������ ���������: ��� �������������� ������������� ����� BOM_LE ��� CP_UTF16BE � BOM_BE ��� CP_UTF16.
        // ����� ����� ��� ��� ��������� SourceCP.
        if (DiscardBOM) and ((WideChar(Buf^) = BOM) or (WideChar(Buf^) = BOM_BE)) then
        begin
          Inc(NativeUInt(Buf), SizeOf(WideChar));
          Dec(DestL);
          if DestL = 0 then Exit; 
        end;
        // ====================== //
        
        BufLen := DestL * SizeOf(WideChar); // �������� ��������� ��������
        SetLength(Result, DestL);
        Move(Buf^, Result[1], BufLen);
        if SourceCP = CP_UTF16BE then SwapByteOrder(Pointer(Result), BufLen);
      end;
    CP_BINARY:
      Result := BufToBinaryStr(Buf, BufLen);
    else
      begin
        if SourceCP = CP_UTF8 then
        begin
          dwFlags := 0;
          // ���������� � ������ ��������� //
          if (DiscardBOM) and (BufLen >= UTF8SigLen) and CompareMem(Pointer(UTF8_SIGNATURE), Buf, UTF8SigLen) then
          begin
            Inc(NativeUInt(Buf), UTF8SigLen);
            Dec(BufLen, UTF8SigLen);
            if BufLen = 0 then Exit;
          end;
          // ====================== //
        end
        else
          dwFlags := MB_PRECOMPOSED;
        
        // ��������������� ����������� ������ ����� ���������� (���������)
        //DestL := MultiByteToWideChar(SourceCP, dwFlags, Buf, BufLen, nil, 0);
        //if DestL = 0 then Exit; 
        
        // ��������� � ��������������� �������
        {DestL := BufLen;
        SetLength(Result, DestL);
        DestL := MultiByteToWideChar(SourceCP, dwFlags, Buf, BufLen, Pointer(Result), DestL);}
        
        // ������������:
        SetLength(Result, BufLen);
        DestL := MultiByteToWideChar(SourceCP, dwFlags, Buf, BufLen, Pointer(Result), BufLen);
        
        if DestL <> BufLen then SetLength(Result, DestL); // ������������� ��������
      end;
  end;
end;
{$else}
var
  DestL, dwFlags: DWord;
  TmpWS: WideString;
begin
  if SourceCP = CP_AUTO_DETECT then
  begin
    SourceCP := DetectCodePage(Buf, BufLen, @DestL);
    // ���������� BOM (������ - � DestL)
    if DiscardBOM then
    begin
      Inc(NativeUInt(Buf), DestL);
      Dec(BufLen, DestL);
      DiscardBOM := False; // ����� ���� �� ���������
    end;
  end;
  
  Result := '';
  if BufLen = 0 then Exit;
  
  if (SourceCP = DefaultSystemCodePage) or
     (SourceCP = CP_ACP) or 
     (SourceCP = CP_BINARY)
  then
  begin
    SetLength(Result, BufLen);
    Move(Buf^, Result[1], BufLen);
    Exit;
  end;
  

  // ����� ��������� AnsiString ���������� � ��� ������: ������� � ������, ����� �� ������� � ������� ���������
  
  // 1) � ������
  
  // ���������� � ������ BOM //
  if (DiscardBOM) and ((SourceCP = CP_UTF16) or (SourceCP = CP_UTF16BE)) then
  begin
    if BufLen < SizeOf(WideChar) then Exit;
    if (WideChar(Buf^) = BOM) or (WideChar(Buf^) = BOM_BE) then
    begin
      Inc(NativeUInt(Buf), SizeOf(WideChar));
      Dec(BufLen, SizeOf(WideChar));
      if BufLen < SizeOf(WideChar) then Exit; 
    end;  
  end;
  // ====================== //
  
  if SourceCP = CP_UTF16 then // ���� ��� � ������� - ����������
  begin
    BufLen := BufLen div SizeOf(WideChar); // In WideChar's
    //if BufLen = 0 then Exit; // ����������� ����
  end
  else
  begin
    if SourceCP = CP_UTF16BE then
    begin
      DestL := BufLen div SizeOf(WideChar);
      BufLen := DestL * SizeOf(WideChar); // ����������
      SetLength(TmpWS, DestL);
      Move(Buf^, TmpWS[1], BufLen);
      SwapByteOrder(Pointer(TmpWS), BufLen);
      Buf := Pointer(TmpWS);
      BufLen := DestL; // In WideChar's
    end
    else
    begin
      if SourceCP = CP_UTF8 then
      begin
        dwFlags := 0;
        // ���������� � ������ ��������� //
        if (DiscardBOM) and (BufLen >= UTF8SigLen) and CompareMem(Pointer(UTF8_SIGNATURE), Buf, UTF8SigLen) then
        begin
          Inc(NativeUInt(Buf), UTF8SigLen);
          Dec(BufLen, UTF8SigLen);
          if BufLen = 0 then Exit;
        end;
        // ====================== //
      end
      else
        dwFlags := MB_PRECOMPOSED;
        
      {DestL := MultiByteToWideChar(SourceCP, dwFlags, Buf, BufLen, nil, 0);
      if DestL = 0 then Exit;

      SetLength(TmpWS, DestL);
      if MultiByteToWideChar(SourceCP, dwFlags, Buf, BufLen, Pointer(TmpWS), DestL) = 0 then Exit;}
      SetLength(TmpWS, BufLen);
      DestL := MultiByteToWideChar(SourceCP, dwFlags, Buf, BufLen, Pointer(TmpWS), BufLen);
      if DestL = 0 then Exit;
      //if DestL = BufLen then SetLength(TmpWS, DestL);
      
      Buf := Pointer(TmpWS);
      BufLen := DestL; // In WideChar's
    end;
  end;
  
  if BufLen = 0 then Exit;
  
  // 2) � �������� ���������
  DestL := WideCharToMultiByte(CP_ACP, 0, Buf, BufLen, nil, 0, nil, nil);
  if DestL = 0 then Exit;

  SetLength(Result, DestL);
  if WideCharToMultiByte(CP_ACP, 0, Buf, BufLen, Pointer(Result), DestL, nil, nil) = 0 then
    Result := ''; // Error

end;
{$endif}


// �������� BOM, ���� �����������
function AddBOMToStr(const S: string; TargetCP: Integer): string;
var
  TmpCP: Integer;
  L: DWord;
  {$ifdef UNICODE}Buf: Pointer; DestL: DWord;{$endif}
begin
  Result := '';
  
  L := BinaryLength(S);
  TmpCP := CodePageByBOM[DetectBOM(Pointer(S), L, nil)];
 
  if (TmpCP = CP_ACP) or // BOM �����������
    (TmpCP <> TargetCP) // BOM �� ������������� �������� ��������� - �������, ��� �����������
  then
  begin
    // ���������
    case TargetCP of
      CP_UTF16: Result := {$ifdef UNICODE}BOM{$else}AnsiBOM{$endif} + S;
      CP_UTF16BE: Result := {$ifdef UNICODE}BOM_BE{$else}AnsiBOM_BE{$endif} + S;
      CP_UTF8:
        begin
          {$ifdef UNICODE}
          DestL := BinaryStrSize(L + UTF8SigLen);
          SetLength(Result, DestL);
          Buf := Pointer(Result);
          Move(UTF8_SIGNATURE, Buf^, UTF8SigLen);
          Inc(NativeUInt(Buf), UTF8SigLen);
          Move(S[1], Buf^, L);
          PadBinaryBuf(Pointer(Result), (L + UTF8SigLen));
          {$else}
          Result := UTF8_SIGNATURE + S;
          {$endif}
        end;
    end;
  end
  else
    Result := S;
end;

// ������ BOM, ���� ������������
function RemoveBOMFromStr(const S: string; TargetCP: Integer): string;
var
  TmpCP: Integer;
  L{$ifdef UNICODE}, DestL{$endif}: DWord;
begin
  Result := '';
  
  L := BinaryLength(S);
  TmpCP := CodePageByBOM[DetectBOM(Pointer(S), L, nil)];
  
  if TmpCP = TargetCP then // BOM ������������
  begin
    // �������
    case TargetCP of
      CP_UTF16, CP_UTF16BE: Result := Copy(S, {$ifdef UNICODE}2{$else}3{$endif}, L);
      CP_UTF8:
        begin
          Dec(L, UTF8SigLen);
          if L = 0 then Exit; // ������ ������� ������ �� UTF8_SIGNATURE
          {$ifdef UNICODE}
          DestL := BinaryStrSize(L);
          SetLength(Result, DestL);
          
          Move(Pointer(NativeUInt(Pointer(S)) + UTF8SigLen)^, Result[1], L);
          PadBinaryBuf(Pointer(Result), L);
          {$else}
          Result := Copy(S, UTF8SigLen+1, L);
          {$endif}
        end;
    end;
  end
  else
    Result := S;
end;

function ConvertCharset(const S: string; SourceCP, TargetCP: Integer; RemoveInBOM: Boolean = False; OutBOM: Boolean = False): string;
{$ifdef UNICODE}
var
  BufLen, DestL, dwFlags: DWord;
  Buf: Pointer;
  TmpUS: string;
begin
  if (SourceCP = TargetCP) then
  begin
    if IsBinaryString(S) then
      Result := Copy(S, 1, Length(S)-1)
    else
      Result := S;
    
    if OutBOM then // �������� BOM, ���� �����������
      Result := AddBOMToStr(Result, TargetCP)
    else
      if RemoveInBOM then // ������ BOM, ���� ������������
        Result := RemoveBOMFromStr(Result, TargetCP);
      
    Exit;
  end;
  
  Result := '';
  TmpUS := '';
  
  Buf := Pointer(S);
  BufLen := BinaryLength(S); // ������������ ���������, ����. � Unicode-������
  
  if RemoveInBOM and (DetectCodePage(Buf, BufLen, @DestL) = SourceCP) then
  begin
    Inc(NativeUInt(Buf), DestL);
    Dec(BufLen, DestL);
  end;
  
  // ����� ��������� AnsiString ���������� � ��� ������: ������� � ������,
  // ����� �� ������� � ������� ���������
  
  // 1) � ������
  if SourceCP = CP_UTF16 then // ���� ��� � ������� - ����������
  begin
    BufLen := BufLen div SizeOf(WideChar); // In WideChar's
    
  end
  else
  begin
    TmpUS := BufToString(Buf, BufLen, SourceCP, False); // DiscardBOM=False, ��� ��� ���� ���������

    Buf := Pointer(TmpUS);
    BufLen := Length(TmpUS); // In WideChar's
  end;
  
  
  // 2) � �������� ���������
  if BufLen > 0 then
  begin
    case TargetCP of
      CP_UTF16:
        begin
          Result := TmpUS;
        end;
      CP_UTF16BE:
        begin
          // ������ � CP_UTF16BE ������ ���� binary string, ��� ��� � ����� CP_UTF16BE ����� ���� ������
          // ����������, ��� ������� � ������������� ��������� ��� ���������� ������ �� �������
          DestL := BufLen + 1;
          SetLength(Result, DestL);
          Result[DestL] := #$0002;
          SwapByteOrder(Buf, Pointer(Result), BufLen * SizeOf(WideChar));
        end;
      else
        begin
          DestL := WideCharToMultiByte(TargetCP, 0, Buf, BufLen, nil, 0, nil, nil);
          if DestL > 0 then
          begin
            SetLength(Result, BinaryStrSize(DestL)); // DestL - � ������, ��������� � WideChar's � �����������
            if WideCharToMultiByte(TargetCP, 0, Buf, BufLen, Pointer(Result), DestL, nil, nil) = 0 then
            begin
              Result := ''; // Error
              //Exit;
            end
            else // ���������
              PadBinaryBuf(Pointer(Result), DestL);
          end;
        end;
    end;
  end;
  
  // �������� BOM, ���� �����
  // TODO: �������� ������� ����������� Result
  if OutBOM then Result := AddBOMToStr(Result, TargetCP);
end;
{$else}
var
  BufLen, DestL, dwFlags: DWord;
  TmpWS: WideString;
  Buf: Pointer;
  TmpCP: Integer;
begin
  
  if (SourceCP = TargetCP) then
  begin
    if OutBOM then // �������� BOM, ���� �����������
    begin
      Result := AddBOMToStr(S, TargetCP);
    end
    else
      if RemoveInBOM then // ������ BOM, ���� ������������
      begin
        Result := RemoveBOMFromStr(S, TargetCP);
      end
      else
        Result := S;
    Exit;
  end;
  
  Result := '';
  if S = '' then Exit;
  
  Buf := Pointer(S);
  BufLen := Length(S);
  
  if RemoveInBOM then
  begin
    TmpCP := CodePageByBOM[DetectBOM(Buf, BufLen, @DestL)];
    if TmpCP = SourceCP then
    begin
      Inc(NativeUInt(Buf), DestL);
      Dec(BufLen, DestL);
      if BufLen = 0 then Exit;
    end;
  end;
  
  
  // ����� ��������� AnsiString ���������� � ��� ������: ������� � ������, ����� �� ������� � ������� ���������
  
  // 1) � ������
  if (SourceCP = CP_UTF16) or (SourceCP = CP_UTF16BE) then // ���� ��� � ������� - ����������
  begin
    DestL := BufLen div SizeOf(WideChar); // In WideChar's
    BufLen := DestL * SizeOf(WideChar); // ����������
    
    if (TargetCP = CP_UTF16) or (TargetCP = CP_UTF16BE) then // � Unicode - �������� ������� ����������� 
    begin
      SetLength(Result, BufLen);
      if TargetCP = CP_UTF16BE then
        SwapByteOrder(Buf, Pointer(Result), BufLen)
      else
        Move(Buf^, Result[1], BufLen);
      
      // �������� BOM
      // TODO: �������� ������� ����������� Result
      if OutBOM then Result := AddBOMToStr(Result, TargetCP);
      Exit;
    end;
    
    if SourceCP = CP_UTF16BE then
    begin
      SetLength(TmpWS, DestL);
      SwapByteOrder(Buf, Pointer(TmpWS), BufLen);
      Buf := Pointer(TmpWS);
    end;
    
    BufLen := DestL; // In WideChar's
  end
  else
  begin
    if SourceCP = CP_UTF8 then
      dwFlags := 0
    else
      dwFlags := MB_PRECOMPOSED;
    
    // ��������������� ����������� ������ ����� (���������)
    //DestL := MultiByteToWideChar(SourceCP, dwFlags, Buf, BufLen, nil, 0);
    //if DestL = 0 then Exit;
    // ��������� � ��������������� �������
    DestL := BufLen;
    
    
    if (TargetCP = CP_UTF16) or (TargetCP = CP_UTF16BE) then // � Unicode - �������� ������� �����������
    begin
      SetLength(Result, DestL * SizeOf(WideChar));
      DestL := MultiByteToWideChar(SourceCP, dwFlags, Buf, BufLen, Pointer(Result), DestL);
      if DestL <> BufLen then SetLength(Result, DestL * SizeOf(WideChar));
      
      if TargetCP = CP_UTF16BE then SwapByteOrder(Pointer(Result), Length(Result));
      
      // �������� BOM
      // TODO: �������� ������� ����������� Result
      if OutBOM then Result := AddBOMToStr(Result, TargetCP);
      
      Exit;
    end;
    
    SetLength(TmpWS, DestL);
    DestL := MultiByteToWideChar(SourceCP, dwFlags, Buf, BufLen, Pointer(TmpWS), DestL);
    if DestL = 0 then Exit;
    Buf := Pointer(TmpWS);
    BufLen := DestL; // In WideChar's
  end;
  
  if BufLen > 0 then
  begin
    // 2) � �������� ���������
    DestL := WideCharToMultiByte(TargetCP, 0, Buf, BufLen, nil, 0, nil, nil);
    
    if DestL > 0 then
    begin
      SetLength(Result, DestL);
      if WideCharToMultiByte(TargetCP, 0, Buf, BufLen, Pointer(Result), DestL, nil, nil) = 0 then
        Result := ''; // Error
    end;
  end;
  
  // �������� BOM
  if OutBOM then
    Result := AddBOMToStr(Result, TargetCP);
end;
{$endif}


function StreamReadString(Stream: PStream; RawLen: DWord; SourceCP: Integer = DefaultCompilerCP; DiscardBOM: Boolean = True): string;
{$ifdef UNICODE}
var
  Buf: TBytes;
  DestL, R: DWord;
begin 
  Result := '';
  
  if SourceCP = CP_AUTO_DETECT then
  begin
    SourceCP := DetectCodePage(Stream, @DestL);
    // ���������� BOM (������ - � DestL)
    if DiscardBOM then
    begin
      Stream.Seek(DestL, spCurrent);
      Dec(RawLen, DestL);
      DiscardBOM := False; // ����� ���� �� ���������
    end;
  end;
  
  if RawLen = 0 then Exit;
  
  if SourceCP = CP_BINARY then
  begin
    DestL := BinaryStrSize(RawLen);
    SetLength(Result, DestL);
    R := Stream.Read(Result[1], RawLen);
    R := PadBinaryBuf(Pointer(Result), R);
    if R < DestL then SetLength(Result, R); // ���� ��������� ������, ��� ����������. R - � �������� ����� PadBinaryBuf()
    Exit;
  end;
  
  if (SourceCP = CP_UTF16) or (SourceCP = CP_UTF16BE) then // �������� ������� ����������� �� BufToString()
  begin
    // ���������� � ������� BOM //
    if (DiscardBOM) and (CodePageByBOM[DetectBOM(Stream, @DestL)] = SourceCP) then
    begin
      Stream.Seek(DestL, spCurrent);
      Dec(RawLen, DestL);
    end;
    
    DestL := RawLen div SizeOf(WideChar);
    if DestL = 0 then Exit;
    // ====================== //
    
    SetLength(Result, DestL);
    RawLen := DestL * SizeOf(WideChar); // ���������� ���������� ����������
    
    R := Stream.Read(Result[1], RawLen);
    if R < RawLen then // ��������� ������, ��� ����������
      SetLength(Result, R div SizeOf(WideChar)); 
    
    if SourceCP = CP_UTF16BE then SwapByteOrder(Pointer(Result), Length(Result) * SizeOf(WideChar));
  end
  else
  begin
    SetLength(Buf, RawLen);
    R := Stream.Read(Buf[0], RawLen);
    Result := BufToString(@Buf[0], R, SourceCP, DiscardBOM);
  end;
end;
{$else}
var
  Buf: TBytes;
  R: DWord;
begin
  Result := '';
  
  if RawLen = 0 then Exit;
  
  if (SourceCP = CP_ACP) or
     (SourceCP = CP_BINARY) or
     (SourceCP = DefaultSystemCodePage)
  then
  begin
    SetLength(Result, RawLen);
    R := Stream.Read(Result[1], RawLen);
    if R < RawLen then // ��������� ������, ��� ����������
      SetLength(Result, R); 
  end
  else
  begin
    SetLength(Buf, RawLen);
    R := Stream.Read(Buf[0], RawLen);
    Result := BufToString(Pointer(Buf), R, SourceCP, DiscardBOM);
  end;
end;
{$endif}

function StreamReadBinary(Stream: PStream; RawLen: DWord): string;
var
  DestL, R: DWord;
begin
  DestL := BinaryStrSize(RawLen);
  SetLength(Result, DestL);
  R := Stream.Read(Result[1], RawLen);
  R := PadBinaryBuf(Pointer(Result), R);
  if R < DestL then SetLength(Result, R); // ���� ��������� ������, ��� ����������. R - � �������� ����� PadBinaryBuf()
end;

function StreamWriteString(Stream: PStream; const S: string; TargetCP: Integer = DefaultCompilerCP; OutBOM: Boolean = True): Boolean;
var
  Buf: Pointer;
  BufLen: DWord;
  Tmp: TBytes;
begin
  Result := True;
  {$ifdef VER120}Tmp := nil;{$endif} // Warning � Delphi 4
  
  if S = '' then Exit;
  
  OutBOM := OutBOM and (Stream.Position = 0);
  
  if (TargetCP = DefaultCompilerCP) or (TargetCP = CP_BINARY) then
  begin
    Buf := Pointer(S);
    //BufLen := Length(S) * SizeOf(Char);
    BufLen := BinaryLength(S);
    
    // ��� UNICODE DefaultCompilerCP=CP_UTF16 - ����������� BOM, ���� ����
    {$ifdef UNICODE}
    if (OutBOM) and (TargetCP = CP_UTF16) and (DetectBOM(Buf, BufLen, nil) <> btUTF16LE) then
    begin
      Result := (Stream.Write(BOM, SizeOf(WideChar)) = SizeOf(WideChar));
      if not Result then Exit;
    end;
    {$endif}
  end
  else
  begin
    Tmp := StringToBuf(S, TargetCP, OutBOM);
    if Tmp = nil then
    begin
      Result := False;
      Exit;
    end;
    
    Buf := Pointer(Tmp); // @Tmp[0]
    BufLen := Length(Tmp);
  end;
  
  Result := (Stream.Write(Buf^, BufLen) = BufLen); 
end;

function StreamReadStringBeforeTerm(Stream: PStream; Term: Pointer; TermLen: Integer): AnsiString; overload;
const
  PRELOAD_SIZE = 64*1024;
var
  NeedR, R, CurL, SearchI, SearchL: DWord;
  Offset: Integer;
  MaxLen: DWord;
begin
  Result := '';
  
  MaxLen := Stream.Size - Stream.Position;
  if MaxLen = 0 then exit; // ����� ������
  
  // ��� Memory-������� ���� � ������:
  if Stream.Memory <> nil then
  begin
    if TermLen < 1 then
      Offset := -1
    else
      Offset := PosBuf(Pointer(NativeUInt(Stream.Memory) + Stream.Position), MaxLen, Term, TermLen);
      
    if Offset > -1 then // �������
      NeedR := DWord(Offset) // ��������� � ������ �� �� ��������� ������
    else
      NeedR := MaxLen; // �� ������� - ��������� �� ����� ������
    
    if NeedR > 0 then
    begin
      SetLength(Result, NeedR);
      {R :=} Stream.Read(Result[1], NeedR);
      //if R < NeedR then SetLength(Result, R); // ���� �� ���?      
    end;
   
    // �������� ������� ����� ��������� ������, ���� ���� �������,
    // ����� � ��� ������� ����������� � �����
    if Offset > -1 then   
      Stream.Seek(TermLen, spCurrent);      
    
    exit;
  end;
  
  // ��� �������� ������� ��������� �������� � ������ �������
  
  if (Term = nil) or (TermLen < 1) then
  begin
    NeedR := MaxLen;
    SetLength(Result, NeedR);
    R := Stream.Read(Result[1], NeedR);
    if R < NeedR then SetLength(Result, R); // ��������� ������, ��� ������
    exit;
  end;
  
  CurL := 0;
  
  // ����� �� ��������� ����� � ��� ������������� � ������ ������
  SearchI := 1; // ������ � ������, � �������� ���� ������
  SearchL := 0; // ����� ������ ��� ������
  
  while CurL < MaxLen do
  begin
    NeedR := MaxLen - CurL;
    if NeedR > PRELOAD_SIZE then NeedR := PRELOAD_SIZE;
    
    SetLength(Result, CurL + NeedR);
    
    R := Stream.Read(Result[CurL+1], NeedR);
    
    Inc(CurL, R); 
    
    // ����� �� ����� ����������� ������
    if R > 0 then
    begin
    
      // ����� �� ����� ������
      {Offset := PosBuf(@Result[1], CurL, Term, TermLen);
      if Offset > -1 then // �������
      begin
        // 1) ��������� �������� ����� Result
        SetLength(Result, Offset);
        
        // 2) ��������� ��������� ���� ������� ������� � ������ "�� ����� �����������"
        // 3) ������� ������� � ���������
        Stream.Seek(-(CurL - DWord(Offset + TermLen)), spCurrent);
        break; 
      end;}
      
      // ����� � ��������� �������������� �� ���������� ������� ������
      Inc(SearchL, R);
      Offset := PosBuf(@Result[SearchI], SearchL, Term, TermLen);
      if Offset > -1 then // �������
      begin
        Offset := DWord(Offset) + SearchI - 1; // ������������� �� ������ ������
        // 1) ���������� �������� ����� Result
        SetLength(Result, Offset);
        // 2) ������� ������� � ������ "�� ����� �����������" � ���������
        Stream.Seek(-(CurL - DWord(Offset + TermLen)), spCurrent);
        break; 
      end;
      
      // �� �������
      
      // ������� � ������ ���������� ������ � ����� ������
      if CurL > DWord(TermLen) then
      begin
        SearchI := CurL - DWord(TermLen) + 2;
        
        if SearchI > CurL then
          SearchL := 0
        else
          SearchL := CurL - SearchI + 1; 
      end;
      
    end;
    
    if R < NeedR then // ������ ������
    begin
      SetLength(Result, CurL);
      break;
    end;
  end;
  
end;

function StreamReadStringBeforeTerm(Stream: PStream; Term: string; SourceCP: Integer): string; overload;
var
  A: AnsiString;
begin
  A := StreamReadStringBeforeTerm(Stream, Pointer(Term), BinaryLength(Term));
  {$ifndef UNICODE}
  if (SourceCP = DefaultCompilerCP) or (SourceCP = DefaultSystemCodePage) or (SourceCP = CP_BINARY) then
    Result := A
  else
  {$endif}
    Result := BufToString(Pointer(A), Length(A), SourceCP, True);
end;

function StreamReadStringZ(Stream: PStream; SourceCP: Integer): string;
var
  Term: string;
begin
  if (SourceCP = CP_UTF16) or (SourceCP = CP_UTF16BE) then
    Term := StrTermZeroW
  else
    Term := StrTermZeroA;
  Result := StreamReadStringBeforeTerm(Stream, Term, SourceCP);
end;

function StreamReadLine(Stream: PStream; SourceCP: Integer): string;
var
  Term: string;
begin
  if SourceCP = CP_UTF16 then
    Term := StrTermEOL_W
  else if SourceCP = CP_UTF16BE then
    Term := StrTermEOL_W_BE
  else
    Term := StrTermEOL_A;
  
  Result := StreamReadStringBeforeTerm(Stream, Term, SourceCP);
end;

function StreamWriteStringZ(Stream: PStream; const S: string; TargetCP: Integer; OutBOM: Boolean = True): Boolean;
var
  Term: string;
  L: DWord;
begin
  Result := StreamWriteString(Stream, S, TargetCP, OutBOM);
  if Result then
  begin
    if (TargetCP = CP_UTF16) or (TargetCP = CP_UTF16BE) then
      Term := StrTermZeroW
    else
      Term := StrTermZeroA;
    
    L := BinaryLength(Term);
    Result := (Stream.Write(Pointer(Term)^, L) = L);
  end;
end;

function StreamWriteLine(Stream: PStream; const S: string; TargetCP: Integer; OutBOM: Boolean = True): Boolean;
var
  Term: string;
  L: DWord;
begin
  Result := StreamWriteString(Stream, S, TargetCP, OutBOM);
  if Result then
  begin
    if TargetCP = CP_UTF16 then
      Term := StrTermEOL_W
    else if TargetCP = CP_UTF16BE then
      Term := StrTermEOL_W_BE
    else
      Term := StrTermEOL_A;
    
    L := BinaryLength(Term);
    Result := (Stream.Write(Pointer(Term)^, L) = L);
  end;
end;



function StrListSaveToStream(StrList: PKOLStrList; Stream: PStream; TargetCP: Integer = DefaultCompilerCP; OutBOM: Boolean = True): Boolean;
var
  S: string;
begin
  S := StrList.Text;
  Result := StreamWriteString(Stream, S, TargetCP, OutBOM);
end;


function StrListSaveToFile(StrList: PKOLStrList; const FileName: string; TargetCP: Integer = DefaultCompilerCP; OutBOM: Boolean = True; Append: Boolean = False): Boolean;
var
  Stream: PStream;
  Flags: DWORD;
begin
  Flags := ofOpenWrite or ofShareDenyWrite;
  
  if Append then
    Flags := Flags or ofOpenAlways
  else
    Flags := Flags or ofCreateAlways;
  
  Stream := NewFileStream(FileName, Flags);
  
  if Stream.Handle = INVALID_HANDLE_VALUE then
  begin
    Result := False;
    Stream.Free;
    Exit;
  end;
  
  if (Append) and (Stream.Size > 0) and (StrList.Count > 0) then
  begin
    // ��������� \r\n ����� ������������� ����������� �����
    Stream.Seek(1, spEnd);
    Result := StreamWriteString(Stream, #13#10, TargetCP, OutBOM);
    if not Result then
    begin
      Stream.Free;
      Exit;
    end;
  end;
  
  Result := StrListSaveToStream(StrList, Stream, TargetCP, OutBOM);
  
  Stream.Free;
end;

function StrListLoadFromStream(StrList: PKOLStrList; Stream: PStream; RawLen: DWord; SourceCP: Integer = DefaultCompilerCP; Append: Boolean = False): Boolean;
var
  S: string;
begin
  S := StreamReadString(Stream, RawLen, SourceCP, True);
  if Append and (StrList.Count > 0) then
    StrList.Text := StrList.Text + #13#10 + S // TODO: ���� ����������� ��������������?
  else
    StrList.Text := S;
  
  Result := S <> '';
end;

function StrListLoadFromFile(StrList: PKOLStrList; const FileName: string; SourceCP: Integer = DefaultCompilerCP; Append: Boolean = False): Boolean;
var
  Stream: PStream;
begin
  Result := False;
  Stream := NewFileStream(FileName, ofOpenRead or ofOpenExisting or ofShareDenyWrite);
  
  if Stream.Handle <> INVALID_HANDLE_VALUE then
  begin
    Result := StrListLoadFromStream(StrList, Stream, Stream.Size, SourceCP, Append);
  end;
  
  Stream.Free;
end;

end.