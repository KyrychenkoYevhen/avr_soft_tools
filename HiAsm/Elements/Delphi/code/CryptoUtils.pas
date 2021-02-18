unit CryptoUtils;
{(C) Coban (alex@ritlabs.com)}

interface

type

{$ifndef FPC_NEW}
  NativeUInt = LongWord;
{$endif}

  PInt64Array = ^TInt64Array;
  TInt64Array = array[0..0] of Int64;

  PDWordArray = ^TDWordArray;
  TDWordArray = array[0..0] of LongWord;

  PByteArray = ^TByteArray;
  TByteArray = array[0..0] of Byte;

  PByte = ^Byte;
  PLongWord = ^LongWord;

  function IntToHex(Int: Int64; IntSize: Byte): String;
  function ROR(x: LongWord; y: Byte): LongWord;
  function ROL(x: LongWord; y: Byte): LongWord;
  function ror64(x: Int64; y: Byte): Int64;
  function Endian(X: LongWord): LongWord;
  function Endian64(X: Int64): Int64;

implementation

const
  HexChars: array[0..15] of Char = ('0', '1', '2', '3', '4', '5',
                                    '6', '7', '8', '9', 'A', 'B',
                                    'C', 'D', 'E', 'F');

function IntToHex(Int: Int64; IntSize: Byte): String;
var
  n: Byte;
begin
  Result := '';
  for n := 0 to IntSize - 1 do
  begin
    Result := HexChars[Int and $F] + Result;
    Int := Int shr $4;
  end;
end;

function ROL(x: LongWord; y: Byte): LongWord; assembler; {$ifdef FPC64} nostackframe; {$endif}
asm
  // EAX = x in 32bit
  
  {$ifdef WIN64}
  //mov eax, x
  mov eax, ecx // ECX = x in 64bit
  {$endif}
  
  //mov ecx, y
  mov ecx, edx // EDX = y // TODO: save/restore ECX?
  rol eax, cl
end;

function ROR(x: LongWord; y: Byte): LongWord; assembler; {$ifdef FPC64} nostackframe; {$endif}
asm
  // EAX = x in 32bit
  
  {$ifdef WIN64}
  //mov eax, x
  mov eax, ecx // ECX = x in 64bit
  {$endif}
  
  //mov ecx, y
  mov ecx, edx // EDX = y // TODO: save/restore ECX?
  ror eax, cl
end;

function ror64(x: Int64; y: Byte): Int64; {$ifdef WIN64}inline;{$endif}
begin
  Result := (x shr y) or (x shl (64 - y));
end;

function Endian(X: LongWord): LongWord; assembler; {$ifdef FPC64} nostackframe; {$endif}
asm
  {$ifdef WIN64}
  mov eax, ecx // ECX = x in 64bit
  {$endif}
  bswap eax
end;

{$ifdef WIN64}

function Endian64(X: Int64): Int64; assembler; {$ifdef FPC64} nostackframe; {$endif}
asm
  mov rax, rcx // RCX = x
  bswap rax
end;
//Result := (Int64(Endian(LongWord(X))) shl 32) or (Endian(LongWord(X shr 32)));

{$else}

function Endian64(X: Int64): Int64;
type
  Ti64 = packed record
    Lo, Hi: LongWord;
  end;
begin
  Ti64(Result).Lo := Endian(Ti64(X).Hi);
  Ti64(Result).Hi := Endian(Ti64(X).Lo);
end;

{$endif}

end.

