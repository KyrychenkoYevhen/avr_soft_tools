unit hiEnCrypt;

interface

uses
  Windows, KOL, Share, Debug, MSCryptoAPI;

type
  ThiEnCrypt = class(TDebug)
    private
      FResult: string;
      FLastPassword: string;
      FhProvider: HCRYPTPROV;
      FhKey: HCRYPTKEY;
      FProcessing: Boolean;
      FAbort: Boolean;
      
      function PrepareKey(const Password: string; Alg: LongWord): Integer;
      procedure ResetKey;
      procedure EnCrypt_MS_String(var _Data: TData; Alg: LongWord; ProvType: LongWord);
      procedure EnCrypt_MS_Stream(var _Data: TData; Alg: LongWord; ProvType: LongWord);
      procedure EnCrypt_MS_File(var _Data: TData; Alg: LongWord; ProvType: LongWord);
      function ProgressCallback(Count: NativeUInt): Boolean;
    public
      _prop_BufferSize: Integer;
      _prop_Key: string;
      _prop_InitVector: string;
      _prop_Mode: Byte;
      _prop_HashMode: Byte;
      _prop_BlockMode: Byte;

      _data_Count: THI_Event;
      _data_Data: THI_Event;
      _data_DstFileName: THI_Event;
      _data_DstStream: THI_Event;
      _data_Key: THI_Event;
      _data_SrcFileName: THI_Event;
      _data_SrcStream: THI_Event;
      
      _event_onEncrypt: THI_Event;
      _event_onError: THI_Event;
      _event_onProgress: THI_Event;
      
      destructor Destroy; override;
      
      procedure _work_doEncrypt0(var _Data: TData; Index: Word);  // RC2
      procedure _work_doEncrypt1(var _Data: TData; Index: Word);  // RC4
      procedure _work_doEncrypt2(var _Data: TData; Index: Word);  // DES56
      procedure _work_doEncrypt3(var _Data: TData; Index: Word);  // 3DES112
      procedure _work_doEncrypt4(var _Data: TData; Index: Word);  // 3DES168
      procedure _work_doEncrypt5(var _Data: TData; Index: Word);  // AES128
      procedure _work_doEncrypt6(var _Data: TData; Index: Word);  // AES192
      procedure _work_doEncrypt7(var _Data: TData; Index: Word);  // AES256
      procedure _work_doEncrypt8(var _Data: TData; Index: Word);  // CYLINK_MEK
      
      procedure _work_doEncryptFile0(var _Data: TData; Index: Word);
      procedure _work_doEncryptFile1(var _Data: TData; Index: Word);
      procedure _work_doEncryptFile2(var _Data: TData; Index: Word);
      procedure _work_doEncryptFile3(var _Data: TData; Index: Word);
      procedure _work_doEncryptFile4(var _Data: TData; Index: Word);
      procedure _work_doEncryptFile5(var _Data: TData; Index: Word);
      procedure _work_doEncryptFile6(var _Data: TData; Index: Word);
      procedure _work_doEncryptFile7(var _Data: TData; Index: Word);
      procedure _work_doEncryptFile8(var _Data: TData; Index: Word);
      
      procedure _work_doEncryptStream0(var _Data: TData; Index: Word);
      procedure _work_doEncryptStream1(var _Data: TData; Index: Word);
      procedure _work_doEncryptStream2(var _Data: TData; Index: Word);
      procedure _work_doEncryptStream3(var _Data: TData; Index: Word);
      procedure _work_doEncryptStream4(var _Data: TData; Index: Word);
      procedure _work_doEncryptStream5(var _Data: TData; Index: Word);
      procedure _work_doEncryptStream6(var _Data: TData; Index: Word);
      procedure _work_doEncryptStream7(var _Data: TData; Index: Word);
      procedure _work_doEncryptStream8(var _Data: TData; Index: Word);
      
      procedure _work_doAbort(var _Data: TData; Index: Word);
      procedure _work_doInitVector(var _Data: TData; Index: Word);

      procedure _var_Result(var _Data: TData; Index: Word);
  end;

implementation



const
  BlockModeProp: array [0..3] of LongWord =
  (
    CRYPT_MODE_CBC,
    CRYPT_MODE_ECB,
    CRYPT_MODE_CFB,
    CRYPT_MODE_CTS
  );

destructor ThiEnCrypt.Destroy;
begin
  if FhKey <> 0 then CryptDestroyKey(FhKey);
  if FhProvider <> 0 then CryptReleaseContext(FhProvider, 0);
  inherited;
end;

function ThiEnCrypt.PrepareKey(const Password: string; Alg: LongWord): Integer;
var
  hHash: HCRYPTHASH;
  HashAlg: LongWord;
begin
  Result := NO_ERROR;
  
  if FhKey <> 0 then
  begin
    if Password = FLastPassword then Exit;
    CryptDestroyKey(FhKey);
    FhKey := 0;
  end;
  
  FLastPassword := Password;
  
  hHash := 0;
  {case _prop_HashMode of
    0: HashAlg := CALG_MD5;
    1: HashAlg := CALG_SHA;
    else
      HashAlg := CALG_SHA;            
  end;}
  if _prop_HashMode = 0 then HashAlg := CALG_MD5 else HashAlg := CALG_SHA;
  
  if FhProvider <> 0 then
  begin
    if CryptCreateHash(FhProvider, HashAlg, 0, 0, @hHash) then
    begin
      if CryptHashData(hHash, Pointer(Password), BinaryLength(Password), 0) then
      begin
        if CryptDeriveKey(FhProvider, Alg, hHash, 0, @FhKey) then
        begin
          if _prop_InitVector <> '' then MSSetKeyInitVector(FhKey, _prop_InitVector);
          CryptSetKeyParam(FhKey, KP_MODE, @BlockModeProp[_prop_BlockMode], 0);
        end
        else
          Result := ERROR_DERIVE_KEY;
      end    
      else
        Result := ERROR_HASH_DATA;
        
      CryptDestroyHash(hHash);
    end      
    else
      Result := ERROR_CREATE_HASH;
  end
  else
    Result := ERROR_ACQUIRE_CONTEXT;
end;

procedure ThiEnCrypt.ResetKey;
begin
  CryptDestroyKey(FhKey);
  FhKey := 0;
end;

procedure ThiEnCrypt.EnCrypt_MS_String(var _Data: TData; Alg: LongWord; ProvType: LongWord);
var
  S: string;
  Pass: string;
  Err: Integer;
label
  finish;
begin
  if FProcessing then
  begin
    _hi_CreateEvent(_Data, @_event_onError, ERROR_BUSY);
    exit; 
  end;
  
  FProcessing := True;
  
  FResult := '';
  
  S := ReadString(_Data, _data_Data);
  Pass := ReadString(_Data, _data_Key, _prop_Key);

  if FhProvider = 0 then
  begin
    if not CryptAcquireContext(@FhProvider, nil, nil, ProvType, CRYPT_VERIFYCONTEXT) then
    begin
      Err := ERROR_ACQUIRE_CONTEXT;
      goto finish;
    end;
  end;
  
  Err := PrepareKey(Pass, Alg);
  if Err <> NO_ERROR then goto finish;
  
  FResult := S;
  
  if MSEncryptString(FhKey, FResult) then
  begin
    Err := NO_ERROR;
    _hi_CreateEvent(_Data, @_event_onEncrypt, FResult);
  end
  else
    Err := ERROR_ENCRYPT;
  
finish:
  if Err <> NO_ERROR then
    _hi_CreateEvent(_Data, @_event_onError, Err);
  FProcessing := False;
end;

procedure ThiEnCrypt.EnCrypt_MS_Stream(var _Data: TData; Alg: LongWord; ProvType: LongWord);
var
  Src, Dst: PStream;
  Count: NativeUInt;
  {$ifndef WIN64}R: Real;{$endif}
  Pass: string;
  Err: Integer;
label
  finish;
begin
  if FProcessing then
  begin
    _hi_CreateEvent(_Data, @_event_onError, ERROR_BUSY);
    exit; 
  end;
  
  FProcessing := True;
  FAbort := False;
  FResult := '';
  
  Pass := ReadString(_Data, _data_Key, _prop_Key);
  Src := ReadStream(_Data, _data_SrcStream);
  Dst := ReadStream(_Data, _data_DstStream);
  {$ifdef WIN64}
  Count := ReadInteger(_Data, _data_Count, 0);
  {$else}
  Count := Trunc(ReadReal(_Data, _data_Count, 0));
  {$endif}
  
  if Src = nil then 
  begin
    Err := ERROR_OPEN_SRC_FILE;
    goto finish;
  end;
  
  if Dst = nil then 
  begin
    Err := ERROR_OPEN_DST_FILE;
    goto finish;
  end;
  
  if FhProvider = 0 then
  begin
    if not CryptAcquireContext(@FhProvider, nil, nil, ProvType, CRYPT_VERIFYCONTEXT) then
    begin
      Err := ERROR_ACQUIRE_CONTEXT;
      goto finish;
    end;
  end;
  
  Err := PrepareKey(Pass, Alg);
  if Err <> NO_ERROR then goto finish;
  
  if MSEncryptStream(FhKey, Src, Dst, Count, _prop_BufferSize, ProgressCallback) then
  begin
    Err := NO_ERROR;
    {$ifndef WIN64}R := Count;{$endif}
    if not FAbort then
      _hi_CreateEvent(_Data, @_event_onEncrypt, {$ifndef WIN64}R{$else}Count{$endif})
    else
      ResetKey;
  end
  else
  begin
    // Сброс состояния ключа, если при шифровании/дешифровании не было использовано Final
    ResetKey;
    
    Err := ERROR_ENCRYPT;
  end;
  
finish:
  if Err <> NO_ERROR then
    _hi_CreateEvent(_Data, @_event_onError, Err);
  FProcessing := False;
end;

procedure ThiEnCrypt.EnCrypt_MS_File(var _Data: TData; Alg: LongWord; ProvType: LongWord);
var 
  Src, Dst: PStream;
  Count: NativeUInt;
  {$ifndef WIN64}R: Real;{$endif}
  Pass, Fn: string;
  Err: Integer;
label
  finish;
begin
  if FProcessing then
  begin
    _hi_CreateEvent(_Data, @_event_onError, ERROR_BUSY);
    exit; 
  end;
  
  FProcessing := True;
  FAbort := False;
  FResult := '';

  Src := nil;
  Dst := nil;
  
  
  Pass := ReadString(_Data, _data_Key, _prop_Key);
  
  if FhProvider = 0 then
  begin
    if not CryptAcquireContext(@FhProvider, nil, nil, ProvType, CRYPT_VERIFYCONTEXT) then
    begin
      Err := ERROR_ACQUIRE_CONTEXT;
      goto finish;     
    end;
  end;
  
  Err := PrepareKey(Pass, Alg);
  if Err <> NO_ERROR then goto finish;
  
  Src := NewReadFileStream(ReadString(_Data, _data_SrcFileName, ''));
  if Src.Handle = INVALID_HANDLE_VALUE then
  begin
    Err := ERROR_OPEN_SRC_FILE;
    goto finish;
  end;
  
  Fn := ReadString(_Data, _data_DstFileName, '');
  Dst := NewFileStream(Fn, ofOpenWrite or ofCreateAlways or ofShareDenyWrite);
  if Dst.Handle = INVALID_HANDLE_VALUE then
  begin
    Fn := '';
    Err := ERROR_OPEN_DST_FILE;
    goto finish;
  end;
  
  Count := Src.Size;
  if MSEncryptStream(FhKey, Src, Dst, Count, _prop_BufferSize, ProgressCallback) then
  begin
    Err := NO_ERROR;
    if not FAbort then
    begin
      Fn := ''; // Не удалять файл
      {$ifndef WIN64}R := Count;{$endif}
      _hi_CreateEvent(_Data, @_event_onEncrypt, {$ifndef WIN64}R{$else}Count{$endif});
    end
    else
      ResetKey;
  end
  else
  begin
    ResetKey;
    Err := ERROR_ENCRYPT;
  end;
  
finish:
  Src.Free; // Src, Dst обязательно выше должны быть проинициализированы (nil)
  Dst.Free;
  
  if Err <> NO_ERROR then
    _hi_CreateEvent(_Data, @_event_onError, Err);
  
  if Fn <> '' then DeleteFile(PChar(Fn)); // Удалить созданный нами файл в случае ошибки или отбоя
  
  FProcessing := False;
end;

function ThiEnCrypt.ProgressCallback(Count: NativeUInt): Boolean;
{$ifndef WIN64}
var
  R: Real;
{$endif}
begin
  {$ifndef WIN64}R := Count;{$endif}
  if not FAbort then // Предотвращение лишнего появления onProgress после doAbort
    _hi_OnEvent(_event_onProgress, {$ifndef WIN64}R{$else}Count{$endif});
  Result := not FAbort;
end;

// ------------ Encrypt string ------------ //

procedure ThiEnCrypt._work_doEncrypt0; // RC2
begin
  EnCrypt_MS_String(_Data, CALG_RC2, PROV_RSA_FULL);
end;

procedure ThiEnCrypt._work_doEncrypt1; // RC4
begin
  EnCrypt_MS_String(_Data, CALG_RC4, PROV_RSA_FULL);
end;

procedure ThiEnCrypt._work_doEncrypt2; // DES56
begin
  EnCrypt_MS_String(_Data, CALG_DES, PROV_RSA_FULL);
end;

procedure ThiEnCrypt._work_doEncrypt3; // 3DES112
begin
  EnCrypt_MS_String(_Data, CALG_3DES_112, PROV_RSA_FULL);
end;

procedure ThiEnCrypt._work_doEncrypt4; // 3DES168
begin
  EnCrypt_MS_String(_Data, CALG_3DES, PROV_RSA_FULL);
end;

procedure ThiEnCrypt._work_doEncrypt5; // AES128
begin
  EnCrypt_MS_String(_Data, CALG_AES_128, PROV_RSA_AES);
end;

procedure ThiEnCrypt._work_doEncrypt6; // AES192
begin
  EnCrypt_MS_String(_Data, CALG_AES_192, PROV_RSA_AES);
end;

procedure ThiEnCrypt._work_doEncrypt7; // AES256
begin
  EnCrypt_MS_String(_Data, CALG_AES_256, PROV_RSA_AES);
end;

procedure ThiEnCrypt._work_doEncrypt8; // CYLINK_MEK
begin
  EnCrypt_MS_String(_Data, CALG_CYLINK_MEK, PROV_DH_SCHANNEL);
end;


// ------------ Encrypt file ------------ //

procedure ThiEnCrypt._work_doEncryptFile0; // RC2
begin
  EnCrypt_MS_File(_Data, CALG_RC2, PROV_RSA_FULL);
end;

procedure ThiEnCrypt._work_doEncryptFile1; // RC4
begin
  EnCrypt_MS_File(_Data, CALG_RC4, PROV_RSA_FULL);
end;

procedure ThiEnCrypt._work_doEncryptFile2; // DES56
begin
  EnCrypt_MS_File(_Data, CALG_DES, PROV_RSA_FULL);
end;

procedure ThiEnCrypt._work_doEncryptFile3; // 3DES112
begin
  EnCrypt_MS_File(_Data, CALG_3DES_112, PROV_RSA_FULL);
end;

procedure ThiEnCrypt._work_doEncryptFile4; // 3DES168
begin
  EnCrypt_MS_File(_Data, CALG_3DES, PROV_RSA_FULL);
end;

procedure ThiEnCrypt._work_doEncryptFile5; // AES128
begin
  EnCrypt_MS_File(_Data, CALG_AES_128, PROV_RSA_AES);
end;

procedure ThiEnCrypt._work_doEncryptFile6; // AES192
begin
  EnCrypt_MS_File(_Data, CALG_AES_192, PROV_RSA_AES);
end;

procedure ThiEnCrypt._work_doEncryptFile7; // AES256
begin
  EnCrypt_MS_File(_Data, CALG_AES_256, PROV_RSA_AES);
end;

procedure ThiEnCrypt._work_doEncryptFile8; // CYLINK_MEK
begin
  EnCrypt_MS_File(_Data, CALG_CYLINK_MEK, PROV_DH_SCHANNEL);
end;


// ------------ Encrypt stream ------------ //

procedure ThiEnCrypt._work_doEncryptStream0; // RC2
begin
  EnCrypt_MS_Stream(_Data, CALG_RC2, PROV_RSA_FULL);
end;

procedure ThiEnCrypt._work_doEncryptStream1; // RC4
begin
  EnCrypt_MS_Stream(_Data, CALG_RC4, PROV_RSA_FULL);
end;

procedure ThiEnCrypt._work_doEncryptStream2; // DES56
begin
  EnCrypt_MS_Stream(_Data, CALG_DES, PROV_RSA_FULL);
end;

procedure ThiEnCrypt._work_doEncryptStream3; // 3DES112
begin
  EnCrypt_MS_Stream(_Data, CALG_3DES_112, PROV_RSA_FULL);
end;

procedure ThiEnCrypt._work_doEncryptStream4; // 3DES168
begin
  EnCrypt_MS_Stream(_Data, CALG_3DES, PROV_RSA_FULL);
end;

procedure ThiEnCrypt._work_doEncryptStream5; // AES128
begin
  EnCrypt_MS_Stream(_Data, CALG_AES_128, PROV_RSA_AES);
end;

procedure ThiEnCrypt._work_doEncryptStream6; // AES192
begin
  EnCrypt_MS_Stream(_Data, CALG_AES_192, PROV_RSA_AES);
end;

procedure ThiEnCrypt._work_doEncryptStream7; // AES256
begin
  EnCrypt_MS_Stream(_Data, CALG_AES_256, PROV_RSA_AES);
end;

procedure ThiEnCrypt._work_doEncryptStream8; // CYLINK_MEK
begin
  EnCrypt_MS_Stream(_Data, CALG_CYLINK_MEK, PROV_DH_SCHANNEL);
end;




procedure ThiEnCrypt._work_doAbort;
begin
  FAbort := True;
end;

procedure ThiEnCrypt._work_doInitVector;
begin
  _prop_InitVector := Share.ToString(_Data);
  if FhKey <> 0 then MSSetKeyInitVector(FhKey, _prop_InitVector);
end;

procedure ThiEnCrypt._var_Result;
begin
  dtString(_Data, FResult);
end;

end.