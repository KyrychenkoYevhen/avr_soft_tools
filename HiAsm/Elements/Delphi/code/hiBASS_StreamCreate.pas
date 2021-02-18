unit hiBASS_StreamCreate;

interface

uses Kol,Share,Debug,bass;

type
  THIBASS_StreamCreate = class(TDebug)
   private
    FHandle: HSTREAM;
   public
    _prop_Freq: Integer;
    _prop_Channels: Integer;
    _prop_Flags: Cardinal;
    _prop_Name: string;
    _prop_DataType: Byte;

    _data_Data: THI_Event;
    _event_onError: THI_Event;
    _event_onCreate: THI_Event;
    
    _event_onBeforeRead: THI_Event;
    _event_onAfterRead: THI_Event;

    procedure _work_doCreate(var _Data: TData; Index: Word);
    procedure _work_doDestroy(var _Data: TData; Index: Word);
    function getInterfaceBassHandle: Pointer;
    function ReadNextData(Buffer: Pointer; BufLen: DWORD): DWORD;
  end;

implementation

function ReadCallback(Handle: HSTREAM; Buffer: Pointer; BufLen: DWORD; UserData: DWORD): DWORD; stdcall;
begin
  Result := THIBASS_StreamCreate(UserData).ReadNextData(Buffer, BufLen);
end;




function THIBASS_StreamCreate.getInterfaceBassHandle: Pointer;
begin
  Result := @FHandle;
end;

function THIBASS_StreamCreate.ReadNextData(Buffer: Pointer; BufLen: DWORD): DWORD;
var 
  st: PStream;
  buf: ^WORD; // Для 16-битных сэмплов
const
  SAMPLE_SIZE = 2; // Размер сэмпла в байтах
begin
  Result := 0;
  
  if Assigned(_event_onBeforeRead.Event) then
    _hi_OnEvent(_event_onBeforeRead, Integer(BufLen));
  
  if _prop_DataType = 0 then
  begin
    buf := Buffer;
    while BufLen >= SAMPLE_SIZE do
    begin
      buf^ := ToIntegerEvent(_data_Data);
      Inc(buf);
      Dec(BufLen, SAMPLE_SIZE);
      Inc(Result, SAMPLE_SIZE);
    end;
  end
  else 
  begin
    st := ToStreamEvent(_data_Data);
    if st <> nil then
      Result := st.Read(Buffer^, BufLen);
  end;
  
  if Assigned(_event_onAfterRead.Event) then
    _hi_OnEvent(_event_onAfterRead, Integer(Result));
end;

procedure THIBASS_StreamCreate._work_doCreate;
begin
  FHandle := BASS_StreamCreate(_prop_Freq, _prop_Channels, _prop_Flags, @ReadCallback, Self);
  if FHandle = 0 then
    _hi_CreateEvent(_Data, @_event_onError, BASS_ErrorGetCode())
  else 
    _hi_CreateEvent(_Data, @_event_onCreate);
end;

procedure THIBASS_StreamCreate._work_doDestroy;
begin
  BASS_StreamFree(FHandle);
  FHandle := 0;
end;

end.
