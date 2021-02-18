unit SHA;
{(C) Coban (alex@ritlabs.com)}

{$ifndef WIN64}
  {$define USE_ASM} //Remove this line to use pascal instead of assembler
{$endif}

interface

uses
  CryptoUtils;

type

  PSHA512Ctx = ^TSHA512Ctx;
  TSHA512Ctx = record
    state: array[0..7] of Int64;
    length, curlen: Int64;
    buf: array[0..127] of Byte;
  end;

  PSHA256Ctx = ^TSHA256Ctx;
  TSHA256Ctx = record
    state: array[0..7] of LongWord;
    length, curlen: LongWord;
    buf: array[0..63] of Byte;
  end;

  procedure SHA384Init(var md: TSHA512Ctx);
  procedure SHA512Init(var md: TSHA512Ctx);
  procedure SHA512Update(var md: TSHA512Ctx; buf: Pointer; len: LongWord);
  function SHA512Final(var md: TSHA512Ctx; sz: Word): string;

  procedure SHA1Init(var md: TSHA256Ctx);
  procedure SHA256Init(var md: TSHA256Ctx);
  procedure SHA256Update(var md: TSHA256Ctx; buf: Pointer; len: LongWord; sz: Word);
  function SHA256Final(var md: TSHA256Ctx; sz: Word): string;

implementation

const
  cnstK256: array[0..63] of LongWord =
  ( $428a2f98, $71374491, $b5c0fbcf, $e9b5dba5, $3956c25b, $59f111f1, $923f82a4, $ab1c5ed5,
    $d807aa98, $12835b01, $243185be, $550c7dc3, $72be5d74, $80deb1fe, $9bdc06a7, $c19bf174,
    $e49b69c1, $efbe4786, $0fc19dc6, $240ca1cc, $2de92c6f, $4a7484aa, $5cb0a9dc, $76f988da,
    $983e5152, $a831c66d, $b00327c8, $bf597fc7, $c6e00bf3, $d5a79147, $06ca6351, $14292967,
    $27b70a85, $2e1b2138, $4d2c6dfc, $53380d13, $650a7354, $766a0abb, $81c2c92e, $92722c85,
    $a2bfe8a1, $a81a664b, $c24b8b70, $c76c51a3, $d192e819, $d6990624, $f40e3585, $106aa070,
    $19a4c116, $1e376c08, $2748774c, $34b0bcb5, $391c0cb3, $4ed8aa4a, $5b9cca4f, $682e6ff3,
    $748f82ee, $78a5636f, $84c87814, $8cc70208, $90befffa, $a4506ceb, $bef9a3f7, $c67178f2
  );
  
  cnstK512: array[0..79] of Int64 = (
    $428A2F98D728AE22, $7137449123EF65CD, $B5C0FBCFEC4D3B2F, $E9B5DBA58189DBBC,
    $3956C25BF348B538, $59F111F1B605D019, $923F82A4AF194F9B, $AB1C5ED5DA6D8118,
    $D807AA98A3030242, $12835B0145706FBE, $243185BE4EE4B28C, $550C7DC3D5FFB4E2,
    $72BE5D74F27B896F, $80DEB1FE3B1696B1, $9BDC06A725C71235, $C19BF174CF692694,
    $E49B69C19EF14AD2, $EFBE4786384F25E3, $0FC19DC68B8CD5B5, $240CA1CC77AC9C65,
    $2DE92C6F592B0275, $4A7484AA6EA6E483, $5CB0A9DCBD41FBD4, $76F988DA831153B5,
    $983E5152EE66DFAB, $A831C66D2DB43210, $B00327C898FB213F, $BF597FC7BEEF0EE4,
    $C6E00BF33DA88FC2, $D5A79147930AA725, $06CA6351E003826F, $142929670A0E6E70,
    $27B70A8546D22FFC, $2E1B21385C26C926, $4D2C6DFC5AC42AED, $53380D139D95B3DF,
    $650A73548BAF63DE, $766A0ABB3C77B2A8, $81C2C92E47EDAEE6, $92722C851482353B,
    $A2BFE8A14CF10364, $A81A664BBC423001, $C24B8B70D0F89791, $C76C51A30654BE30,
    $D192E819D6EF5218, $D69906245565A910, $F40E35855771202A, $106AA07032BBD1B8,
    $19A4C116B8D2D0C8, $1E376C085141AB53, $2748774CDF8EEB99, $34B0BCB5E19B48A8,
    $391C0CB3C5C95A63, $4ED8AA4AE3418ACB, $5B9CCA4F7763E373, $682E6FF3D6B2B8A3,
    $748F82EE5DEFB2FC, $78A5636F43172F60, $84C87814A1F0AB72, $8CC702081A6439EC,
    $90BEFFFA23631E28, $A4506CEBDE82BDE9, $BEF9A3F7B2C67915, $C67178F2E372532B,
    $CA273ECEEA26619C, $D186B8C721C0C207, $EADA7DD6CDE0EB1E, $F57D4F7FEE6ED178,
    $06F067AA72176FBA, $0A637DC5A2C898A6, $113F9804BEF90DAE, $1B710B35131C471B,
    $28DB77F523047D84, $32CAAB7B40C72493, $3C9EBE0A15C9BEBC, $431D67C49C100D4C,
    $4CC5D4BECB3E42B6, $597F299CFC657E2A, $5FCB6FAB3AD6FAEC, $6C44198C4A475817
  );

function Ch(x, y, z: Int64): Int64;
begin
  Result := (x and y) xor ((not x) and z);
end;

function Maj(x, y, z: Int64): Int64;
begin
  Result := (x and y) xor (x and z) xor (y and z);
end;

function Sigma0(x: Int64): Int64;
begin
  Result := (ror64(x, 28) xor ror64(x, 34) xor ror64(x, 39));
end;

function Sigma1(x: Int64): Int64;
begin
  Result := (ror64(x, 14) xor ror64(x, 18) xor ror64(x, 41));
end;

{$ifdef VER120}
function shr64(const a: Int64; b: Byte): Int64;
begin
  Result := a shr b;
end;
{$endif}

function Gamma0(x: Int64): Int64;
begin
  Result := (ror64(x, 1) xor ror64(x, 8) xor {$ifdef VER120}shr64(x, 7){$else}(x shr 7){$endif});
end;

function Gamma1(x: Int64): Int64;
begin
  Result := (ror64(x, 19) xor ror64(x, 61) xor {$ifdef VER120}shr64(x, 6){$else}(x shr 6){$endif});
end;

{$ifdef USE_ASM}
function Ch256(x, y, z: LongWord): LongWord; assembler;
asm
  and   edx,eax
  not   eax
  and   eax,ecx
  xor   eax,edx
end;
{$else}
function Ch256(x, y, z: LongWord): LongWord;
begin
  Result := (x and y) xor ((not x) and z);
end;
{$endif}

{$ifdef USE_ASM}
function Maj256(x, y, z: LongWord): LongWord; assembler;
asm
  push  ecx
  and   ecx,eax
  and   eax,edx
  xor   eax,ecx
  pop   ecx
  and   edx,ecx
  xor   eax,edx
end;
{$else}
function Maj256(x, y, z: LongWord): LongWord;
begin
  Result := (x and y) xor (x and z) xor (y and z);
end;
{$endif}

function E0256(x: LongWord): LongWord;
begin
  Result := ror(x, 2) xor ror(x, 13) xor ror(x, 22);
end;

function E1256(x: LongWord): LongWord;
begin
  Result := ror(x, 6) xor ror(x, 11) xor ror(x, 25);
end;

function F0256(x: LongWord): LongWord;
begin
  Result := ror(x, 7) xor ror(x, 18) xor (x shr 3);
end;

function F1256(x: LongWord): LongWord;
begin
  Result := ror(x, 17) xor ror(x, 19) xor (x shr 10);
end;

function ft1(t: Byte; x, y, z: LongWord): LongWord;
begin
  case t of
    0..19: Result := (x and y) or ((not x) and z);
    20..39: Result := x xor y xor z;
    40..59: Result := (x and y) or (x and z) or (y and z);
  else
    Result := x xor y xor z;
  end;
end;

{$ifdef USE_ASM}
function Kt1(t: Byte): LongWord; assembler;
asm
  cmp   al,19
  jg    @@1
  mov   eax,5a827999h
  jmp   @@end
@@1:
  cmp   al,39
  jg    @@2
  mov   eax,6ed9eba1h
  jmp   @@end
@@2:
  cmp   al,59
  jg    @@3
  mov   eax,8f1bbcdch
  jmp   @@end
@@3:
  mov   eax,0ca62c1d6h
@@end:
end;
{$else}
function Kt1(t: Byte): LongWord;
begin
  case t of
    0..19: Result := $5a827999;
    20..39: Result := $6ed9eba1;
    40..59: Result := $8f1bbcdc;
  else
    Result := $ca62c1d6
  end;
end;
{$endif}

procedure sha1_compress(var md: TSHA256Ctx);
var
  S: array[0..4] of LongWord;
  W: array[0..79] of LongWord;
  i, t: LongWord;
begin
  Move(md.state, S, SizeOf(S));
  for i := 0 to 15 do
    W[i] := Endian(PLongWord(NativeUInt(@md.buf) + i * 4)^);
  for i := 16 to 79 do
    W[i] := rol(W[i - 3] xor W[i - 8] xor W[i - 14] xor W[i - 16], 1);
    for i := 0 to 79 do
    begin
      t := rol(S[0], 5) + ft1(i, S[1], S[2], S[3]) + S[4] + Kt1(i) + W[i];
      S[4] := S[3];
      S[3] := S[2];
      S[2] := rol(S[1], 30);
      S[1] := S[0];
      S[0] := t;
    end;
  for i := 0 to 4 do
    md.state[i] := md.state[i] + S[i];
end;

procedure sha256_compress(var md: TSHA256Ctx);
var
  S: array[0..7] of LongWord;
  W: array[0..63] of LongWord;
  t1, t2: LongWord;
  i: LongWord;
begin
  Move(md.state, S, SizeOf(S));
  for i := 0 to 15 do
    W[i] := Endian(PLongWord(NativeUInt(@md.buf) + i * 4)^);
  for i := 16 to 63 do
    W[i] := F1256(W[i - 2]) + W[i - 7] + F0256(W[i - 15]) + W[i - 16];
  for i := 0 to 63 do
  begin
    t1 := S[7] + E1256(S[4]) + Ch256(S[4], S[5], S[6]) + cnstK256[i] + W[i];
    t2 := E0256(S[0]) + Maj256(S[0], S[1], S[2]);
    S[7] := S[6];
    S[6] := S[5];
    S[5] := S[4];
    S[4] := S[3] + t1;
    S[3] := S[2];
    S[2] := S[1];
    S[1] := S[0];
    S[0] := t1 + t2;
  end;
  for i := 0 to 7 do
    md.state[i] := md.state[i] + S[i];
end;

procedure sha512_compress(var md: TSHA512Ctx);
var
  S: array[0..7] of Int64;
  W: array[0..79] of Int64;
  t0, t1: Int64;
  i: LongWord;
begin
  Move(md.state, S, 64);
  for i := 0 to 15 do
    W[i] := Endian64(PInt64(NativeUInt(@md.buf) + i * 8)^);
  for i := 16 to 79 do
    W[i] := Gamma1(W[i - 2]) + W[i - 7] + Gamma0(W [i - 15]) + W[i - 16];
  for i := 0 to 79 do
  begin
    t0 := S[7] + Sigma1 (S[4]) + Ch (S[4], S[5], S[6]) + cnstK512[i] + W[i];
    t1 := Sigma0 (S[0]) + Maj(S[0], S[1], S[2]);
    S[7] := S[6];
    S[6] := S[5];
    S[5] := S[4];
    S[4] := S[3] + t0;
    S[3] := S[2];
    S[2] := S[1];
    S[1] := S[0];
    S[0] := t0 + t1;
  end;
  for i := 0 to 7 do
    Inc(md.state[i], S[i]);
end;

procedure SHA1Init(var md: TSHA256Ctx);
begin
  md.curlen := 0; md.length := 0;
  md.state[0] := $67452301;
  md.state[1] := $efcdab89;
  md.state[2] := $98badcfe;
  md.state[3] := $10325476;
  md.state[4] := $c3d2e1f0;
end;

procedure SHA256Init(var md: TSHA256Ctx);
begin
  md.curlen := 0; md.length := 0;
  md.state[0] := $6a09e667;
  md.state[1] := $bb67ae85;
  md.state[2] := $3c6ef372;
  md.state[3] := $a54ff53a;
  md.state[4] := $510e527f;
  md.state[5] := $9b05688c;
  md.state[6] := $1f83d9ab;
  md.state[7] := $5be0cd19;
end;

procedure SHA384Init(var md: TSHA512Ctx);
begin
  md.curlen := 0; md.length := 0;
  md.state[0] := $cbbb9d5dc1059ed8;
  md.state[1] := $629a292a367cd507;
  md.state[2] := $9159015a3070dd17;
  md.state[3] := $152fecd8f70e5939;
  md.state[4] := $67332667ffc00b31;
  md.state[5] := $8eb44a8768581511;
  md.state[6] := $db0c2e0d64f98fa7;
  md.state[7] := $47b5481dbefa4fa4;
end;

procedure SHA512Init(var md: TSHA512Ctx);
begin
  md.curlen := 0; md.length := 0;
  md.state[0] := $6a09e667f3bcc908;
  md.state[1] := $bb67ae8584caa73b;
  md.state[2] := $3c6ef372fe94f82b;
  md.state[3] := $a54ff53a5f1d36f1;
  md.state[4] := $510e527fade682d1;
  md.state[5] := $9b05688c2b3e6c1f;
  md.state[6] := $1f83d9abfb41bd6b;
  md.state[7] := $5be0cd19137e2179;
end;

procedure SHA256Update(var md: TSHA256Ctx; buf: Pointer; len: LongWord; sz: Word);
begin
  while (len > 0) do
  begin
    md.buf[md.curlen] := PByte(buf)^;
    Inc(md.curlen);
    buf := pointer(NativeUInt(buf) + 1);
    if (md.curlen = 64) then
    begin
      if sz = 256 then
        sha256_compress(md)
      else
        sha1_compress(md);
      Inc(md.length, 512);
      md.curlen := 0;
    end;
    Dec(len);
  end;
end;

procedure SHA512Update(var md: TSHA512Ctx; buf: Pointer; len: LongWord);
begin
  while (len > 0) do
  begin
    md.buf[md.curlen] := PByte(buf)^;
    md.curlen := md.curlen + 1; buf := pointer(NativeUInt(buf) + 1);
    if (md.curlen = 128) then
    begin
      sha512_compress(md);
      md.length := md.length + 1024;
      md.curlen := 0;
    end;
    Dec(len);
  end;
end;

function SHA512Final(var md: TSHA512Ctx; sz: Word): String;
var
  i: LongWord;
begin
  Inc(md.length, md.curlen shl 3);
  md.buf[md.curlen] := $80;
  Inc(md.curlen);
  if (md.curlen >= 112) then
  begin
    while md.curlen < 128 do
    begin
      md.buf[md.curlen] := 0;
      Inc(md.curlen);
    end;
    sha512_compress(md);
    md.curlen := 0;
  end;
  while md.curlen < 112 do
  begin
    md.buf[md.curlen] := 0;
    Inc(md.curlen);
  end;
  for i := 112 to 119 do
    md.buf[i] := 0;
  for i := 120 to 127 do
    md.buf[i] := (md.length shr ((127 - i) * 8)) and $FF;
  sha512_compress(md);
  Result := '';
  if sz = 384 then
    for i := 0 to 5 do
      Result := Result + IntToHex(md.state[i], 16)
  else
    for i := 0 to 7 do
      Result := Result + IntToHex(md.state[i], 16)
end;

function SHA256Final(var md: TSHA256Ctx; sz: Word): String;
var
  i: LongWord;
begin
  Inc(md.length, md.curlen shl 3);
  md.buf[md.curlen] := $80;
  Inc(md.curlen);
  if (md.curlen >= 56) then
  begin
    while md.curlen < 64 do
    begin
      md.buf[md.curlen] := 0;
      Inc(md.curlen);
    end;
    if sz = 256 then
      sha256_compress(md)
    else
      sha1_compress(md);
    md.curlen := 0;
  end;
  while md.curlen < 56 do
  begin
    md.buf[md.curlen] := 0;
    Inc(md.curlen);
  end;
  for i := 56 to 59 do
    md.buf[i] := 0;
  for i := 60 to 63 do
    md.buf[i] := (md.length shr ((63 - i) * 8)) and $FF;

  if sz = 256 then
    sha256_compress(md)
  else
    sha1_compress(md);

  Result := '';
  if sz = 256 then
    for i := 0 to 7 do
      Result := Result + IntToHex(md.state[i], 8)
  else
    for i := 0 to 4 do
      Result := Result + IntToHex(md.state[i], 8);
end;

end.