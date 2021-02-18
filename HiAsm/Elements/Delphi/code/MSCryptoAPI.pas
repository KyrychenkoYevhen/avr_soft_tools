unit MSCryptoAPI;

interface

uses
  Windows, KOL, Share;

//  Constants for HiAsm Components
const
  NO_ERROR                          =   0;
  ERROR_INVALID_PARAMETER           =   1;
  ERROR_INCORRECT_KEY               =   2;
  ERROR_ACQUIRE_CONTEXT             =   3;
  ERROR_GENERATION_KEY              =   4;
  ERROR_GENERATION_KEYPAIR          =   5;
  ERROR_GET_USER_KEY                =   6;
  ERROR_DERIVE_KEY                  =   7;
  ERROR_ENCRYPT                     =   8;
  ERROR_DECRYPT                     =   9;
  ERROR_CREATE_HASH                 =  10;
  ERROR_HASH_DATA                   =  11;
  ERROR_GET_HASH_PARAM              =  12;
  ERROR_SIGNED_HASH                 =  13;
  ERROR_EXPORT_KEYPAIR              =  14;
  ERROR_EXPORT_PUBLICKEY            =  15;
  ERROR_EXPORT_SESSIONKEY           =  16;
  ERROR_EXPORT_EXCHANGEKEY          =  17;
  ERROR_IMPORT_KEYPAIR              =  18;
  ERROR_IMPORT_PUBLICKEY            =  19;
  ERROR_IMPORT_SESSIONKEY           =  20;
  ERROR_IMPORT_EXCHANGEKEY          =  21;
  ERROR_WRONG_CONTAINER_NAME        =  22;
  ERROR_CREATE_CONTAINER            =  23;
  ERROR_DELETE_CONTAINER            =  24;
  ERROR_CONTAINER_NOT_EXISTS        =  25;
  ERROR_CONTAINER_ALREADY_EXISTS    =  26;
  ERROR_NO_CONTAINERS               =  27;
  ERROR_BUSY                        =  28;
  ERROR_OPEN_SRC_FILE               =  29;
  ERROR_OPEN_DST_FILE               =  30;

type
  HCRYPTPROV  = Cardinal;
  HCRYPTKEY   = Cardinal;
  ALG_ID      = Cardinal;
  PHCRYPTPROV = ^HCRYPTPROV;
  PHCRYPTKEY  = ^HCRYPTKEY;
  HCRYPTHASH  = Cardinal;
  PHCRYPTHASH = ^HCRYPTHASH;
  PLongWord   = ^LongWord;
  
  // Функция должна вернуть True для продолжения операции, либо False для прекращения
  TCryptProgressCallback = function (Count: NativeUInt): Boolean of object;
  
const
  ADVAPI32            = 'advapi32.dll';

  RSA384BIT_KEY       = $01800000;
  RSA512BIT_KEY       = $02000000;
  RSA1024BIT_KEY      = $04000000;
  RSA2048BIT_KEY      = $08000000;
  RSA4096BIT_KEY      = $10000000;
//  RSA8192BIT_KEY      = $20000000;
//  RSA16384BIT_KEY     = $40000000;

  // CryptGetProvParam
  PP_ENUMALGS            = 1;
  PP_ENUMCONTAINERS      = 2;
  PP_IMPTYPE             = 3;
  PP_NAME                = 4;
  PP_VERSION             = 5;
  PP_CONTAINER           = 6;
  PP_CHANGE_PASSWORD     = 7;
  PP_KEYSET_SEC_DESCR    = 8;  // get/set security descriptor of keyset
  PP_CERTCHAIN           = 9;  // for retrieving certificates from tokens
  PP_KEY_TYPE_SUBTYPE    = 10;
  PP_PROVTYPE            = 16;
  PP_KEYSTORAGE          = 17;
  PP_APPLI_CERT          = 18;
  PP_SYM_KEYSIZE         = 19;
  PP_SESSION_KEYSIZE     = 20;
  PP_UI_PROMPT           = 21;
  PP_ENUMALGS_EX         = 22;
  
  CRYPT_FIRST            = 1;
  CRYPT_NEXT             = 2;
  CRYPT_IMPL_HARDWARE    = 1;
  CRYPT_IMPL_SOFTWARE    = 2;
  CRYPT_IMPL_MIXED       = 3;
  CRYPT_IMPL_UNKNOWN     = 4;
  
  // CryptGetKeyParam
  KP_IV               = 1;
  KP_SALT             = 2;
  KP_PADDING          = 3;
  KP_MODE             = 4;
  KP_MODE_BITS        = 5;
  KP_PERMISSIONS      = 6;
  KP_ALGID            = 7;
  KP_BLOCKLEN         = 8;
  KP_KEYLEN           = 9;
  KP_SALT_EX          = $0a;
  KP_P                = $0b;
  KP_G                = $0c;
  KP_Q                = $0d;
  KP_X                = $0e;
  KP_Y                = $0f;
  KP_RA               = $10;
  KP_RB               = $11;
  KP_INFO             = $12;
  KP_EFFECTIVE_KEYLEN = $13;
  KP_SCHANNEL_ALG     = $14;
  KP_PUB_PARAMS       = $27;
  
  //KP_PERMISSIONS:
  CRYPT_ENCRYPT = 1;
  CRYPT_DECRYPT = 2;
  CRYPT_EXPORT  = 4;
  CRYPT_READ    = 8;
  CRYPT_WRITE   = 16;
  CRYPT_MAC     = 32;

  //KP_MODE:
  CRYPT_MODE_CBC     = 1;
  CRYPT_MODE_ECB     = 2;
  CRYPT_MODE_OFB     = 3; // MS провайдеры не поддерживают
  CRYPT_MODE_CFB     = 4;
  CRYPT_MODE_CTS     = 5;
  CRYPT_MODE_CBCI    = 6;
  CRYPT_MODE_CFBP    = 7;
  CRYPT_MODE_OFBP    = 8;
  CRYPT_MODE_CBCOFM  = 9;
  CRYPT_MODE_CBCOFMI = 10;


  // exported key blob definitions
  SIMPLEBLOB          = $1;
  PUBLICKEYBLOB       = $6;
  PRIVATEKEYBLOB      = $7;
  PLAINTEXTKEYBLOB    = $8;

  AT_KEYEXCHANGE      = 1;
  AT_SIGNATURE        = 2;

  CRYPT_USERDATA      = 1;

  CRYPT_BLOB_VER3     = $00000080;

  CALG_MD2            = 32769;
  CALG_MD4            = 32770;
  CALG_MD5            = 32771;
  CALG_SHA            = 32772;
  CALG_SHA_1          = 32772;
  CALG_SHA_256        = 32780;
  CALG_SHA_384        = 32781;
  CALG_SHA_512        = 32782;
  CALG_RC2            = 26114;
  CALG_RC4            = 26625;
  CALG_RC5            = 26125;
  CALG_DES            = 26113;
  CALG_3DES_112       = 26121;
  CALG_3DES           = 26115;
  CALG_DESX           = 26116;
  CALG_AES            = 26129;
  CALG_AES_128        = 26126;
  CALG_AES_192        = 26127;
  CALG_AES_256        = 26128;
  CALG_CYLINK_MEK     = 26124;
  CALG_RSA_KEYX       = 41984;
  CALG_RSA_SIGN       = 9216;

  HP_ALGID            = $0001; // Hash algorithm
  HP_HASHVAL          = $0002; // Hash value
  HP_HASHSIZE         = $0004; // Hash value size

  // dwFlags definitions for CryptAcquireContext
  CRYPT_VERIFYCONTEXT  = $F0000000;
  CRYPT_NEWKEYSET      = $00000008;
  CRYPT_DELETEKEYSET   = $00000010;
  CRYPT_MACHINE_KEYSET = $00000020;
  CRYPT_SILENT         = $00000040;

  // dwFlags definitions for CryptGetDefaultProvider
  CRYPT_MACHINE_DEFAULT = 1;
  CRYPT_USER_DEFAULT = 2;

  // dwFlag definitions for CryptGenKey
  CRYPT_EXPORTABLE     = $00000001;
  CRYPT_USER_PROTECTED = $00000002;
  CRYPT_CREATE_SALT    = $00000004;
  CRYPT_UPDATE_KEY     = $00000008;
  CRYPT_NO_SALT        = $00000010;
  CRYPT_PREGEN         = $00000040;
  CRYPT_RECIPIENT      = $00000010;
  CRYPT_INITIATOR      = $00000040;
  CRYPT_ONLINE         = $00000080;
  CRYPT_SF             = $00000100;
  CRYPT_CREATE_IV      = $00000200;
  CRYPT_KEK            = $00000400;
  CRYPT_DATA_KEY       = $00000800;

  // dwFlags definitions for CryptDeriveKey
  CRYPT_SERVER         = $00000400;

  PROV_RSA_FULL         = 1;
  PROV_RSA_SIG          = 2;
  PROV_DSS              = 3;
  PROV_FORTEZZA         = 4;
  PROV_MS_EXCHANGE      = 5;
  PROV_SSL              = 6;
  PROV_RSA_SCHANNEL     = 12;
  PROV_DSS_DH           = 13;
  PROV_EC_ECDSA_SIG     = 14;
  PROV_EC_ECNRA_SIG     = 15;
  PROV_EC_ECDSA_FULL    = 16;
  PROV_EC_ECNRA_FULL    = 17;
  PROV_DH_SCHANNEL      = 18;
  PROV_SPYRUS_LYNKS     = 20;
  PROV_RNG              = 21;
  PROV_INTEL_SEC        = 22;
  PROV_REPLACE_OWF      = 23;
  PROV_RSA_AES          = 24;

  MS_DEF_DH_SCHANNEL_PROV   = 'Microsoft DH Schannel Cryptographic Provider';
  MS_DEF_DSS_DH_PROV        = 'Microsoft Base DSS and Diffie-Hellman Cryptographic Provider';
  MS_DEF_DSS_PROV           = 'Microsoft Base DSS Cryptographic Provider';
  MS_DEF_PROV               = 'Microsoft Base Cryptographic Provider v1.0';
  MS_DEF_RSA_SCHANNEL_PROV  = 'Microsoft RSA Schannel Cryptographic Provider';
  MS_DEF_RSA_SIG_PROV       = 'Microsoft RSA Signature Cryptographic Provider';
  MS_ENH_DSS_DH_PROV        = 'Microsoft Enhanced DSS and Diffie-Hellman Cryptographic Provider';
  
  // См. ниже - корректный провайдер выбирается при запуске
  //MS_ENH_RSA_AES_PROV       = 'Microsoft Enhanced RSA and AES Cryptographic Provider'; // Vista+
  //MS_ENH_RSA_AES_PROV       = 'Microsoft Enhanced RSA and AES Cryptographic Provider (Prototype)'; // XP SP3
  
  MS_ENHANCED_PROV          = 'Microsoft Enhanced Cryptographic Provider v1.0';
  MS_SCARD_PROV             = 'Microsoft Base Smart Card Crypto Provider';
  MS_STRONG_PROV            = 'Microsoft Strong Cryptographic Provider';

function CryptAcquireContext(Prov: PHCRYPTPROV; Container: PChar; Provider: PChar; ProvType: LongWord; Flags: LongWord): LongBool; stdcall;
function CryptReleaseContext(hProv: HCRYPTPROV; dwFlags: LongWord): LongBool; stdcall;
function CryptGetProvParam(hProv: HCRYPTPROV; dwParam: LongWord; pbData: Pointer; pdwDataLen: PLongWord; dwFlags: LongWord): LongBool; stdcall;
function CryptGetDefaultProvider(dwProvType: LongWord; pdwReserved: Pointer; dwFlags: LongWord; pszProvName: PChar; pcbProvName: PLongWord): LongBool; stdcall;
function CryptGenKey(hProv: HCRYPTPROV; Algid: ALG_ID; dwFlags: LongWord; phKey: PHCRYPTKEY): LongBool; stdcall;
function CryptDestroyKey(hKey: HCRYPTKEY): LongBool; stdcall;
function CryptDuplicateKey(hKey: HCRYPTKEY; pdwReserved: PDWORD; dwFlags: LongWord; phKey: PHCRYPTKEY): LongBool; stdcall;
function CryptGetKeyParam(hKey: HCRYPTKEY; dwParam: LongWord; pbData: Pointer; pdwDataLen: PLongWord; dwFlags: LongWord): LongBool; stdcall;
function CryptSetKeyParam(hKey: HCRYPTKEY; dwParam: LongWord; pbData: Pointer; dwFlags: LongWord): LongBool; stdcall;
function CryptGetUserKey(hProv: HCRYPTPROV; dwKeySpec: LongWord; phUserKey: PHCRYPTKEY): LongBool; stdcall;
function CryptDeriveKey(Prov: HCRYPTPROV; Algid: ALG_ID; BaseData: HCRYPTHASH; Flags: LongWord; Key: PHCRYPTKEY): LongBool; stdcall;
function CryptExportKey(hKey: HCRYPTKEY; hExpKey: HCRYPTKEY; dwBlobType: LongWord; dwFlags: LongWord; pbData: Pointer; pdwDataLen: PLongWord): LongBool; stdcall;
function CryptImportKey(hProv: HCRYPTPROV; pbData: Pointer; dwDataLen: LongWord; hPubKey: HCRYPTKEY; dwFlags: LongWord; phKey: PHCRYPTKEY): LongBool; stdcall;

function CryptEncrypt(Key: HCRYPTKEY; Hash: HCRYPTHASH; Final: LongBool; Flags: LongWord; Data: Pointer; Len: PLongWord; BufLen: LongWord): LongBool; stdcall;
function CryptDecrypt(Key: HCRYPTKEY; Hash: HCRYPTHASH; Final: LongBool; Flags: LongWord; Data: Pointer; Len: PLongWord): LongBool; stdcall;

function CryptCreateHash(Prov: HCRYPTPROV; Algid: ALG_ID; Key: HCRYPTKEY; Flags: LongWord; Hash: PHCRYPTHASH): LongBool; stdcall;
function CryptHashData(Hash: HCRYPTHASH; Data: Pointer; DataLen: LongWord; Flags: LongWord): LongBool; stdcall;
function CryptGetHashParam(hHash: HCRYPTHASH; dwParam: LongWord; pbData: Pointer; pdwDataLen: PLongWord; dwFlags: LongWord): LongBool; stdcall;
function CryptSetHashParam(hHash: HCRYPTHASH; dwParam: LongWord; pbData: Pointer; dwFlags: LongWord): LongBool; stdcall;
function CryptSignHash(hHash: HCRYPTHASH; dwKeySpec: LongWord; sDescription: PChar; dwFlags: LongWord; pbSignature: Pointer; pdwSigLen: PLongWord): LongBool; stdcall;
function CryptVerifySignature(hHash: HCRYPTHASH; const pbSignature: Pointer; dwSigLen: LongWord; hPubKey: HCRYPTKEY; sDescription: PChar; dwFlags: LongWord): LongBool; stdcall;
function CryptDestroyHash(hHash: HCRYPTHASH): LongBool; stdcall;



// =============== Пользовательские функции =============== //

// Возвращает размер блока шифра в байтах для указанного ключа
function MSGetKeyBlockLen(hKey: HCRYPTKEY): Integer;
// Установить Init Vector для ключа
function MSSetKeyInitVector(hKey: HCRYPTKEY; InitVector: string): Boolean;
// Зашифровать строку
function MSEncryptString(hKey: HCRYPTKEY; var S: string): Boolean;
// Расшифровать строку
function MSDecryptString(hKey: HCRYPTKEY; var S: string): Boolean;
// Зашифровать Count байт из SrcStream и записать в DstStream.
// BufSize - размер буфера чтения.
// Возвращает в Count количество записанных в DstStream байт.
function MSEncryptStream(hKey: HCRYPTKEY; SrcStream, DstStream: PStream; var Count: NativeUInt; BufSize: LongWord; Progress: TCryptProgressCallback = nil): Boolean;
// Расшифровать Count байт из SrcStream и записать в DstStream.
function MSDecryptStream(hKey: HCRYPTKEY; SrcStream, DstStream: PStream; var Count: NativeUInt; BufSize: LongWord; Progress: TCryptProgressCallback = nil): Boolean;


var
  MS_ENH_RSA_AES_PROV: string;




implementation





const
  DEFAULT_BUFFER_SIZE = 32768;

function MSGetKeyBlockLen(hKey: HCRYPTKEY): Integer;
var
  L: LongWord;
begin
  Result := 0;
  L := SizeOf(Integer);
  CryptGetKeyParam(hKey, KP_BLOCKLEN, @Result, @L, 0); // Result - в битах
  Result := Result div 8;
end;

function MSSetKeyInitVector(hKey: HCRYPTKEY; InitVector: string): Boolean;
var
  BL, L: Integer;
  Buf: TBytes;
begin
  Result := True;
  
  BL := MSGetKeyBlockLen(hKey);
  if BL = 0 then exit;
  
  L := BinaryLength(InitVector);
  SetLength(Buf, BL);
  FillChar(Buf[L], BL-L, 0);
  if L > 0 then Move(InitVector[1], Buf[0], L);
  
  Result := CryptSetKeyParam(hKey, KP_IV, Pointer(Buf), 0);
end;

function MSEncryptString(hKey: HCRYPTKEY; var S: string): Boolean;
var
  L, BL, DestL: Integer;
begin
  L := BinaryLength(S);
  BL := MSGetKeyBlockLen(hKey);
  
  // Если шифр блочный - результирующая длина с дополнением должна быть кратной размеру блока
  if BL > 0 then
  begin
    DestL := (L div BL) * BL;
    // Если данные кратны размеру блока - нужно добавить ещё один блок для дополнения
    if DestL <= L then Inc(DestL, BL);
  end
  else
    DestL := L;
  
  SetLength(S, BinaryStrSize(DestL)); // Также уникализация строки для последующего inplace изменения
  
  Result := CryptEncrypt(hKey, 0, True, 0, Pointer(S), @L, DestL);
  if not Result then
  begin
    // Хоть размер и был подогнан выше, могли что-то не учесть (маловероятно)
    if GetLastError = ERROR_MORE_DATA then
    begin
      DestL := L;
      L := BinaryLength(S);
      SetLength(S, BinaryStrSize(DestL));
      Result := CryptEncrypt(hKey, 0, True, 0, Pointer(S), @L, DestL);
      if not Result then L := 0;
    end
    else
      L := 0;
  end;
  
  DestL := BinaryStrSize(L);
  if DestL <> Length(S) then SetLength(S, DestL);
  PadBinaryBuf(Pointer(S), L);
end;

function MSDecryptString(hKey: HCRYPTKEY; var S: string): Boolean;
var
  L, DestL: Integer;
begin
  L := Length(S);
  
  SetLength(S, L); // Уникализация строки для последующего inplace изменения
  
  L := BinaryLength(S);
  
  Result := CryptDecrypt(hKey, 0, True, 0, Pointer(S), @L);
  if not Result then L := 0; // Ошибка
  
  DestL := BinaryStrSize(L);
  if DestL <> Length(S) then SetLength(S, DestL);
  PadBinaryBuf(Pointer(S), L);
end;


function MSEncryptStream(hKey: HCRYPTKEY; SrcStream, DstStream: PStream; var Count: NativeUInt; BufSize: LongWord; Progress: TCryptProgressCallback = nil): Boolean;
var
  Buf: array of Byte;
  C, NeedR, NeedW, Total: NativeUInt;
  Final: Boolean;
begin
  Result := False;
  
  if BufSize = 0 then BufSize := DEFAULT_BUFFER_SIZE;
  
  if BufSize > Count then BufSize := Count;
  C := MSGetKeyBlockLen(hKey);
  if BufSize < C then BufSize := C;
  if C > 0 then
    BufSize := (BufSize div C) * C; // Кратно размеру блока
  
  SetLength(Buf, BufSize + C); // Запас на 1 блок больше
  
  Total := 0;
  
  NeedR := BufSize;
  repeat
    if Count < NeedR then NeedR := Count;
    
    C := SrcStream.Read(Buf[0], NeedR);
    Dec(Count, C);
    
    Final := (Count = 0) or (C < NeedR);

    if not CryptEncrypt(hKey, 0, Final, 0, Pointer(Buf), @C, Length(Buf)) then
    begin // Ошибка
      Count := Total;
      exit;
    end;
    
    // В C - сколько было помещено в буфер
    NeedW := C;
    C := DstStream.Write(Buf[0], NeedW);
    
    // В C - сколько было записано в файл
    Inc(Total, C);
    
    if C < NeedW then
    begin // Не удалось записать больше
      Count := Total;
      exit;
    end;
    
  until Final or (Assigned(Progress) and (not Progress(Total)));
  
  Result := True;
  Count := Total;
end;

function MSDecryptStream(hKey: HCRYPTKEY; SrcStream, DstStream: PStream; var Count: NativeUInt; BufSize: LongWord; Progress: TCryptProgressCallback = nil): Boolean;
var
  Buf: array of Byte;
  C, NeedR, NeedW, Total: NativeUInt;
  Final: Boolean;
begin
  Result := False;
  
  if BufSize = 0 then BufSize := DEFAULT_BUFFER_SIZE;
  
  if BufSize > Count then BufSize := Count;
  
  C := MSGetKeyBlockLen(hKey);
  if BufSize < C then BufSize := C;
  if C > 0 then
    BufSize := (BufSize div C) * C; // Кратно размеру блока
  
  SetLength(Buf, BufSize);
  
  Total := 0;
  
  NeedR := BufSize;
  repeat
    if Count < NeedR then NeedR := Count;
    
    C := SrcStream.Read(Buf[0], NeedR);
    Dec(Count, C);
    
    Final := (Count = 0) or (C < NeedR);

    if not CryptDecrypt(hKey, 0, Final, 0, Pointer(Buf), @C) then
    begin // Ошибка
      Count := Total;
      exit;
    end;
    
    // В C - сколько было помещено в буфер
    NeedW := C;
    C := DstStream.Write(Buf[0], NeedW);
    
    // В C - сколько было записано в файл
    Inc(Total, C);
    
    if C < NeedW then
    begin // Не удалось записать всё
      Count := Total;
      exit;
    end;
    
  until Final or (Assigned(Progress) and (not Progress(Total)));
  
  Result := True;
  Count := Total;
end;




{$ifdef UNICODE}
function CryptAcquireContext; external ADVAPI32 name 'CryptAcquireContextW';
function CryptGetDefaultProvider; external ADVAPI32 name 'CryptGetDefaultProviderW';
function CryptSignHash; external ADVAPI32 name 'CryptSignHashW';
function CryptVerifySignature; external ADVAPI32 name 'CryptVerifySignatureW';
{$else}
function CryptAcquireContext; external ADVAPI32 name 'CryptAcquireContextA';
function CryptGetDefaultProvider; external ADVAPI32 name 'CryptGetDefaultProviderA';
function CryptSignHash; external ADVAPI32 name 'CryptSignHashA';
function CryptVerifySignature; external ADVAPI32 name 'CryptVerifySignatureA';
{$endif}

function CryptReleaseContext; external ADVAPI32 name 'CryptReleaseContext';
function CryptGetProvParam; external ADVAPI32 name 'CryptGetProvParam';
function CryptGenKey; external ADVAPI32 name 'CryptGenKey';
function CryptDestroyKey; external ADVAPI32 name 'CryptDestroyKey';
function CryptDuplicateKey; external ADVAPI32 name 'CryptDuplicateKey';
function CryptGetKeyParam; external ADVAPI32 name 'CryptGetKeyParam';
function CryptSetKeyParam; external ADVAPI32 name 'CryptSetKeyParam';
function CryptGetUserKey; external ADVAPI32 name 'CryptGetUserKey';
function CryptDeriveKey; external ADVAPI32 name 'CryptDeriveKey';
function CryptExportKey; external ADVAPI32 name 'CryptExportKey';
function CryptImportKey; external ADVAPI32 name 'CryptImportKey';

function CryptEncrypt; external ADVAPI32 name 'CryptEncrypt';
function CryptDecrypt; external ADVAPI32 name 'CryptDecrypt';

function CryptCreateHash; external ADVAPI32 name 'CryptCreateHash';
function CryptHashData; external ADVAPI32 name 'CryptHashData';
function CryptGetHashParam; external ADVAPI32 name 'CryptGetHashParam';
function CryptSetHashParam; external ADVAPI32 name 'CryptSetHashParam';
function CryptDestroyHash; external ADVAPI32 name 'CryptDestroyHash';




procedure CheckProvider;
var
  S: string;
  L: LongWord;
begin
  L := 512 * SizeOf(Char);
  SetLength(S, L div SizeOf(Char));
  if CryptGetDefaultProvider(PROV_RSA_AES, nil, CRYPT_MACHINE_DEFAULT, Pointer(S), @L) then
    MS_ENH_RSA_AES_PROV := Copy(S, 1, (L div SizeOf(Char))-1);
end;

initialization
  CheckProvider;

end.