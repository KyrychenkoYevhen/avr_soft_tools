unit hiSoundBuffer;



interface

uses Windows, Kol, Share, Debug;

type

  TStreamEx = {$ifndef F_P}object{$else}class{$endif}(TStream)
    protected
      EvRead: THandle;
      NextSize: TStrmSize;
      CritSect: TRTLCriticalSection;
    public
      WriteTimeout: Integer;    
  end;
  PStreamEx = {$ifndef F_P}^{$endif}TStreamEx;
  
  
  

  THISoundBuffer = class(TDebug)
    private
      buf: PStreamEx;
      procedure SetSize(Value: Integer);
      procedure SetWriteTimeout(Value: Integer);
      
    public

      _data_Data: THI_Event;
      _event_onAdd: THI_Event;
      
      property _prop_Size: Integer write SetSize;
      property _prop_WriteTimeout: Integer write SetWriteTimeout;

      constructor Create;
      destructor Destroy; override;
      procedure _work_doAdd(var _Data: TData; Index: Word);
      procedure _work_doSize(var _Data: TData; Index: Word);
      procedure _var_Stream(var _Data: TData; Index: Word);
      procedure _var_FullState(var _Data: TData; Index: Word);
      procedure _var_Avail(var _Data: TData; Index: Word);
  end;

implementation

// Ручная установка позиции на этом типе потока не имеет смысла
function SeekStreamingBuffer(Strm: PStream; MoveTo: TStrmMove; MoveFrom: TMoveMethod): TStrmSize;
begin
  Result := PStreamEx(Strm).fData.fPosition;
end;

// Чтение Size возвращает количество данных, которые ещё не были прочитаны
// Это данные от текущей позиции до fSize, плюс от начала буфера до NextSize
function GetSizeStreamingBuffer(Strm: PStream): TStrmSize;
begin
  Result := PStreamEx(Strm).fData.fSize - PStreamEx(Strm).fData.fPosition + PStreamEx(Strm).NextSize;
end;


// Установка Size выделяет новую память указанного размера (по факту это изменение Capacity).
// В связи с реализацией установки Capacity в KOL.TStream, задавать непосредственно Capacity не следует
procedure SetSizeStreamingBuffer(Strm: PStream; NewSize: TStrmSize);
var 
  S: PStreamEx;
  M: Pointer;
  C: TStrmSize;
begin
  S := PStreamEx(Strm);
  
  EnterCriticalSection(S.CritSect);

  if S.fData.fCapacity <> NewSize then
  begin
    if S.fMemory = nil then
    begin
      if NewSize <> 0 then GetMem(S.fMemory, NewSize);
    end
    else
    begin
      if NewSize = 0 then
      begin
        FreeMem(S.fMemory);
        S.fMemory := nil;
        S.fData.fPosition := 0;
      end
      else
      begin
        GetMem(M, NewSize);
        C := S.Read(M^, NewSize); // Переносим существующие данные (кратное сэмплу количество)
        
        // Из-за округления мог ещё остаться 1 байт (для 2-байтового сэмпла), который тоже можем сохранить
        if C < NewSize then
        begin
          if S.fData.fPosition - S.fData.fSize > 0 then
          begin
            Byte(Pointer(NativeUInt(M) + C)^) := Byte(Pointer(NativeUInt(S.fMemory) + S.fData.fPosition)^);
            Inc(C);
          end
          else
          begin
            if S.NextSize > 0 then
            begin
              Byte(Pointer(NativeUInt(M) + C)^) := Byte(S.fMemory^);
              Inc(C);
            end;
          end;
        end;
        
        FreeMem(S.fMemory);
        S.fMemory := M;
        S.fData.fPosition := 0;
        S.fData.fSize := C;
        S.NextSize := 0;
      end;
    end;
    S.fData.fCapacity := NewSize;
  end;
  
  LeaveCriticalSection(S.CritSect);
end;

function ReadStreamingBuffer(Strm: PStream; var Buffer; Count: TStrmSize): TStrmSize;
var 
  S: PStreamEx;
  C: TStrmSize;
const
  SAMPLE_SIZE = 2;
begin
  Result := 0;
  
  S := PStreamEx(Strm);
    
  if (Count = 0) or (S.fMemory = nil) then Exit;
  
  EnterCriticalSection(S.CritSect);
  
  // Сколько можно прочитать (кратно размеру сэмпла)
  C := S.Size;
  if (C mod SAMPLE_SIZE) > 0 then
  begin
    C := (C div SAMPLE_SIZE) * SAMPLE_SIZE;
    if C < Count then Count := C; // Предполагается, что Count кратный сэмплу.
  end;
  
  // Считываем данные после текущей позиции
  C := S.fData.fSize - S.fData.fPosition;
  if C > Count then C := Count;
  
  if C > 0 then 
  begin
    Move(Pointer(NativeUInt(S.fMemory) + S.fData.fPosition)^, Buffer, C);
    Inc(S.fData.fPosition, C);
    Inc(Result, C);
    Dec(Count, C);
  end;
  
  // Если требуемое количество ещё не считано и есть данные на месте ранее прочитанных
  C := S.NextSize;
  if (Count > 0) and (C > 0) then
  begin
    if C > Count then C := Count;
    
    Move(S.fMemory^, Pointer(NativeUInt(@Buffer) + Result)^, C);
    
    S.fData.fPosition := C;
    S.fData.fSize := S.NextSize; // NextSize стаёт текущим размером
    S.NextSize := 0;
    
    Inc(Result, C);
  end;
  
  LeaveCriticalSection(S.CritSect);

  if Result > 0 then SetEvent(S.EvRead);
  
end;

function WriteStreamingBuffer(Strm: PStream; var Buffer; Count: TStrmSize): TStrmSize;
var 
  S: PStreamEx;
  C: TStrmSize;
begin
  Result := 0;

  S := PStreamEx(Strm);
  
  if S.fMemory = nil then Exit;
  

  while Count > 0 do
  begin
    
    EnterCriticalSection(S.CritSect);
    
    C := S.fData.fCapacity - S.fData.fSize;
    if C > Count then C := Count;
    
    if (S.NextSize = 0) and (C > 0) then // Запись после непрочитанных данных
    begin
      Move(Pointer(NativeUInt(@Buffer) + Result)^, Pointer(NativeUInt(S.fMemory) + S.fData.fSize)^, C);
      Inc(S.fData.fSize, C);
      Inc(Result, C);
      Dec(Count, C);
    end
    else  // Запись на место прочитанных данных
    begin
      C := S.fData.fPosition - S.NextSize;
      if C = 0 then // Ждем освобождения буфера
      begin
        ResetEvent(S.EvRead);
        
        LeaveCriticalSection(S.CritSect);
        
        // Ожидаем чтения данных из буфера, чтобы освободилось место под новые данные
        if (S.WriteTimeout <= 0) or (WaitForSingleObject(S.EvRead, S.WriteTimeout) = WAIT_TIMEOUT) then Exit;
        Continue;
      end
      else
      begin
        if C > Count then C := Count;
        Move(Pointer(NativeUInt(@Buffer) + Result)^, Pointer(NativeUInt(S.fMemory) + S.NextSize)^, C);
        Inc(S.NextSize, C);
        Inc(Result, C);
        Dec(Count, C);
      end;      
    end;
    
    LeaveCriticalSection(S.CritSect);   
  end;

end;


procedure CloseStreamingBuffer(Strm: PStream);
var 
  S: PStreamEx;
begin
  S := PStreamEx(Strm);
  //SetEvent(S.EvRead);
  CloseHandle(S.EvRead);
  DeleteCriticalSection(S.CritSect);
  if S.fMemory <> nil then
    FreeMem(S.fMemory);
end;


const 
  SBMethods: TStreamMethods =
    (
      fSeek: SeekStreamingBuffer;
      fGetSiz: GetSizeStreamingBuffer;
      fSetSiz: SetSizeStreamingBuffer;
      fRead: ReadStreamingBuffer;
      fWrite: WriteStreamingBuffer;
      fClose: CloseStreamingBuffer;
      fCustom: nil;
      fWait: nil;
    );

    
function NewStreamingBuffer: PStreamEx;
begin
  {$ifndef F_P}New(Result, Create);{$else}Result := PStreamEx.Create;{$endif}
  Move(SBMethods, Result.fMethods, Sizeof(SBMethods));
  Result.fPMethods := @Result.fMethods;
  
  
  Result.EvRead := CreateEvent(nil, True, False, nil);
  Result.NextSize := 0;
  Result.WriteTimeout := 0;
  InitializeCriticalSection(Result.CritSect);
end;





// ====== THISoundBuffer ====== //


constructor THISoundBuffer.Create;
begin
  inherited;
  buf := NewStreamingBuffer; 
end;

destructor THISoundBuffer.Destroy;
begin
  buf.free;
  inherited;
end;

procedure THISoundBuffer.SetSize(Value: Integer);
begin
  buf.Size := TStrmSize(Value);
end;

procedure THISoundBuffer.SetWriteTimeout(Value: Integer);
begin
  buf.WriteTimeout := Value;
end;

procedure THISoundBuffer._work_doAdd;
var 
  st: PStream;
  dt: TData;
  c: DWORD;
  M: Pointer;
begin
  dt := ReadData(_Data, _data_Data, nil);

  case dt.Data_type of
    data_str: buf.Write(dt.sdata[1], BinaryLength(dt.sdata));
    data_int: buf.Write(dt.idata, SizeOf(dt.idata));
    data_stream:
      begin
        st := PStream(dt.idata);
        if st <> nil then
        begin
          if st.Memory <> nil then
          begin
            //st.Position := 0; // Вероятно, не стоит сбрасывать позицию - пользователь (или отдельные типы потоков) может хотеть сам управлять этим
            buf.Write(st.Memory^, st.Size - st.Position);
          end
          else
          begin
            c := st.Size - st.Position;
            if c > buf.Capacity then c := buf.Capacity;
            st.Seek(c, spEnd);
            
            GetMem(M, c);
            c := st.Read(M^, c);
            buf.Write(M^, c);
            FreeMem(M);
          end;
        end;
      end;
  end;
  _hi_CreateEvent(_Data, @_event_onAdd);
end;


procedure THISoundBuffer._work_doSize;
begin
  buf.Size := ToInteger(_Data);
end;

procedure THISoundBuffer._var_Stream;
begin
  dtStream(_Data, buf);
end;

procedure THISoundBuffer._var_FullState;
begin
  dtInteger(_Data, Round((buf.Size/(buf.Capacity + 1))*100));
end;

procedure THISoundBuffer._var_Avail;
begin
  dtInteger(_Data, buf.Size);
end;

end.
