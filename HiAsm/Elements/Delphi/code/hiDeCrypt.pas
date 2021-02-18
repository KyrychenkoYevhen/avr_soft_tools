unit hiDeCrypt;

interface

uses
  Windows, KOL, Share, Debug, MSCryptoAPI;

type
  ThiDeCrypt = class(TDebug)
    private
      FResult: string;
      FLastPassword: string;
      FhProvider: HCRYPTPROV;
      FhKey: HCRYPTKEY;
      FProcessing: Boolean;
      FAbort: Boolean;
      
      function PrepareKey(const Password: string; Alg: LongWord): Integer;
      procedure ResetKey;
      procedure DeCrypt_MS_String(var _Data: TData; Alg: LongWord; ProvType: LongWord);
      procedure DeCrypt_MS_Stream(var _Data: TData; Alg: LongWord; ProvType: LongWord);
      procedure DeCrypt_MS_File(var _Data: TData; Alg: LongWord; ProvType: LongWord);
      function ProgressCallback(Count: NativeUInt): Boolean;
    public
      _prop_BufferSize: Integer;
      _prop_Key: string;
      _prop_InitVector: string;
      _prop_Mode: Byte;
      _prop_HashMode: Byte;
      _prop_BlockMode: Byte;

      _data_Count: THI_Event;
      _data_DataCrypt: THI_Event;
      _data_DstFileName: THI_Event;
      _data_DstStream: THI_Event;
      _data_Key: THI_Event;
      _data_SrcFileName: THI_Event;
      _data_SrcStream: THI_Event;
      
      _event_onDecrypt: THI_Event;
      _event_onError: THI_Event;
      _event_onProgress: THI_Event;
      
      destructor Destroy; override;
      
      procedure _work_doDecrypt0(var _Data: TData; Index: Word);  // RC2
      procedure _work_doDecrypt1(var _Data: TData; Index: Word);  // RC4
      procedure _work_doDecrypt2(var _Data: TData; Index: Word);  // DES56
      procedure _work_doDecrypt3(var _Data: TData; Index: Word);  // 3DES112
      procedure _work_doDecrypt4(var _Data: TData; Index: Word);  // 3DES168
      procedure _work_doDecrypt5(var _Data: TData; Index: Word);  // AES128
      procedure _work_doDecrypt6(var _Data: TData; Index: Word);  // AES192
      procedure _work_doDecrypt7(var _Data: TData; Index: Word);  // AES256
      procedure _work_doDecrypt8(var _Data: TData; Index: Word);  // CYLINK_MEK
      
      procedure _work_doDecryptFile0(var _Data: TData; Index: Word);
      procedure _work_doDecryptFile1(var _Data: TData; Index: Word);
      procedure _work_doDecryptFile2(var _Data: TData; Index: Word);
      procedure _work_doDecryptFile3(var _Data: TData; Index: Word);
      procedure _work_doDecryptFile4(var _Data: TData; Index: Word);
      procedure _work_doDecryptFile5(var _Data: TData; Index: Word);
      procedure _work_doDecryptFile6(var _Data: TData; Index: Word);
      procedure _work_doDecryptFile7(var _Data: TData; Index: Word);
      procedure _work_doDecryptFile8(var _Data: TData; Index: Word);
      
      procedure _work_doDecryptStream0(var _Data: TData; Index: Word);
      procedure _work_doDecryptStream1(var _Data: TData; Index: Word);
      procedure _work_doDecryptStream2(var _Data: TData; Index: Word);
      procedure _work_doDecryptStream3(var _Data: TData; Index: Word);
      procedure _work_doDecryptStream4(var _Data: TData; Index: Word);
      procedure _work_doDecryptStream5(var _Data: TData; Index: Word);
      procedure _work_doDecryptStream6(var _Data: TData; Index: Word);
      procedure _work_doDecryptStream7(var _Data: TData; Index: Word);
      procedure _work_doDecryptStream8(var _Data: TData; Index: Word);
      
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

destructor ThiDeCrypt.Destroy;
begin
  if FhKey <> 0 then CryptDestroyKey(FhKey);
  if FhProvider <> 0 then CryptReleaseContext(FhProvider, 0);
  inherited;
end;

function ThiDeCrypt.PrepareKey(const Password: string; Alg: LongWord): Integer;
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

procedure ThiDeCrypt.ResetKey;
begin
  CryptDestroyKey(FhKey);
  FhKey := 0;
end;

procedure ThiDeCrypt.DeCrypt_MS_String(var _Data: TData; Alg: LongWord; ProvType: LongWord);
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
  
  S := ReadString(_Data, _data_DataCrypt);
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
  
  if MSDecryptString(FhKey, FResult) then
  begin
    Err := NO_ERROR;
    _hi_CreateEvent(_Data, @_event_onDecrypt, FResult);
  end
  else
    Err := ERROR_ENCRYPT;
  
finish:
  if Err <> NO_ERROR then
    _hi_CreateEvent(_Data, @_event_onError, Err);
  FProcessing := False;
end;

procedure ThiDeCrypt.DeCrypt_MS_Stream(var _Data: TData; Alg: LongWord; ProvType: LongWord);
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
  
  if MSDecryptStream(FhKey, Src, Dst, Count, _prop_BufferSize, ProgressCallback) then
  begin
    Err := NO_ERROR;
    {$ifndef WIN64}R := Count;{$endif}
    if not FAbort then
      _hi_CreateEvent(_Data, @_event_onDecrypt, {$ifndef WIN64}R{$else}Count{$endif})
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

procedure ThiDeCrypt.DeCrypt_MS_File(var _Data: TData; Alg: LongWord; ProvType: LongWord);
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
  if MSDecryptStream(FhKey, Src, Dst, Count, _prop_BufferSize, ProgressCallback) then
  begin
    Err := NO_ERROR;
    if not FAbort then
    begin
      Fn := ''; // Не удалять файл
      {$ifndef WIN64}R := Count;{$endif}
      _hi_CreateEvent(_Data, @_event_onDecrypt, {$ifndef WIN64}R{$else}Count{$endif});
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

function ThiDeCrypt.ProgressCallback(Count: NativeUInt): Boolean;
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

// ------------ Decrypt string ------------ //

procedure ThiDeCrypt._work_doDecrypt0; // RC2
begin
  DeCrypt_MS_String(_Data, CALG_RC2, PROV_RSA_FULL);
end;

procedure ThiDeCrypt._work_doDecrypt1; // RC4
begin
  DeCrypt_MS_String(_Data, CALG_RC4, PROV_RSA_FULL);
end;

procedure ThiDeCrypt._work_doDecrypt2; // DES56
begin
  DeCrypt_MS_String(_Data, CALG_DES, PROV_RSA_FULL);
end;

procedure ThiDeCrypt._work_doDecrypt3; // 3DES112
begin
  DeCrypt_MS_String(_Data, CALG_3DES_112, PROV_RSA_FULL);
end;

procedure ThiDeCrypt._work_doDecrypt4; // 3DES168
begin
  DeCrypt_MS_String(_Data, CALG_3DES, PROV_RSA_FULL);
end;

procedure ThiDeCrypt._work_doDecrypt5; // AES128
begin
  DeCrypt_MS_String(_Data, CALG_AES_128, PROV_RSA_AES);
end;

procedure ThiDeCrypt._work_doDecrypt6; // AES192
begin
  DeCrypt_MS_String(_Data, CALG_AES_192, PROV_RSA_AES);
end;

procedure ThiDeCrypt._work_doDecrypt7; // AES256
begin
  DeCrypt_MS_String(_Data, CALG_AES_256, PROV_RSA_AES);
end;

procedure ThiDeCrypt._work_doDecrypt8; // CYLINK_MEK
begin
  DeCrypt_MS_String(_Data, CALG_CYLINK_MEK, PROV_DH_SCHANNEL);
end;


// ------------ Decrypt file ------------ //

procedure ThiDeCrypt._work_doDecryptFile0; // RC2
begin
  DeCrypt_MS_File(_Data, CALG_RC2, PROV_RSA_FULL);
end;

procedure ThiDeCrypt._work_doDecryptFile1; // RC4
begin
  DeCrypt_MS_File(_Data, CALG_RC4, PROV_RSA_FULL);
end;

procedure ThiDeCrypt._work_doDecryptFile2; // DES56
begin
  DeCrypt_MS_File(_Data, CALG_DES, PROV_RSA_FULL);
end;

procedure ThiDeCrypt._work_doDecryptFile3; // 3DES112
begin
  DeCrypt_MS_File(_Data, CALG_3DES_112, PROV_RSA_FULL);
end;

procedure ThiDeCrypt._work_doDecryptFile4; // 3DES168
begin
  DeCrypt_MS_File(_Data, CALG_3DES, PROV_RSA_FULL);
end;

procedure ThiDeCrypt._work_doDecryptFile5; // AES128
begin
  DeCrypt_MS_File(_Data, CALG_AES_128, PROV_RSA_AES);
end;

procedure ThiDeCrypt._work_doDecryptFile6; // AES192
begin
  DeCrypt_MS_File(_Data, CALG_AES_192, PROV_RSA_AES);
end;

procedure ThiDeCrypt._work_doDecryptFile7; // AES256
begin
  DeCrypt_MS_File(_Data, CALG_AES_256, PROV_RSA_AES);
end;

procedure ThiDeCrypt._work_doDecryptFile8; // CYLINK_MEK
begin
  DeCrypt_MS_File(_Data, CALG_CYLINK_MEK, PROV_DH_SCHANNEL);
end;


// ------------ Decrypt stream ------------ //

procedure ThiDeCrypt._work_doDecryptStream0; // RC2
begin
  DeCrypt_MS_Stream(_Data, CALG_RC2, PROV_RSA_FULL);
end;

procedure ThiDeCrypt._work_doDecryptStream1; // RC4
begin
  DeCrypt_MS_Stream(_Data, CALG_RC4, PROV_RSA_FULL);
end;

procedure ThiDeCrypt._work_doDecryptStream2; // DES56
begin
  DeCrypt_MS_Stream(_Data, CALG_DES, PROV_RSA_FULL);
end;

procedure ThiDeCrypt._work_doDecryptStream3; // 3DES112
begin
  DeCrypt_MS_Stream(_Data, CALG_3DES_112, PROV_RSA_FULL);
end;

procedure ThiDeCrypt._work_doDecryptStream4; // 3DES168
begin
  DeCrypt_MS_Stream(_Data, CALG_3DES, PROV_RSA_FULL);
end;

procedure ThiDeCrypt._work_doDecryptStream5; // AES128
begin
  DeCrypt_MS_Stream(_Data, CALG_AES_128, PROV_RSA_AES);
end;

procedure ThiDeCrypt._work_doDecryptStream6; // AES192
begin
  DeCrypt_MS_Stream(_Data, CALG_AES_192, PROV_RSA_AES);
end;

procedure ThiDeCrypt._work_doDecryptStream7; // AES256
begin
  DeCrypt_MS_Stream(_Data, CALG_AES_256, PROV_RSA_AES);
end;

procedure ThiDeCrypt._work_doDecryptStream8; // CYLINK_MEK
begin
  DeCrypt_MS_Stream(_Data, CALG_CYLINK_MEK, PROV_DH_SCHANNEL);
end;



procedure ThiDeCrypt._work_doAbort;
begin
  FAbort := True;
end;

procedure ThiDeCrypt._work_doInitVector;
begin
  _prop_InitVector := Share.ToString(_Data);
  if FhKey <> 0 then MSSetKeyInitVector(FhKey, _prop_InitVector);
end;

procedure ThiDeCrypt._var_Result;
begin
  dtString(_Data, FResult);
end;

end.