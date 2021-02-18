unit hiBASS_StreamCreateURL;

interface

uses
  Kol, Share, Debug, BASS;

type
  THIBASS_StreamCreateURL = class(TDebug)
    private
      FHandle: HSTREAM;
      FSync: HSYNC;
    public
      _prop_URL: string;
      _prop_Flags: Integer;
      _prop_Name: string;
      _prop_ParsePlayList: Boolean;

      _data_URL: THI_Event;
      _event_onError: THI_Event;
      _event_onMeta: THI_Event;
      _event_onStatus: THI_Event;
      _event_onCreate: THI_Event;

      procedure _work_doCreate(var _Data: TData; Index: Word);
      procedure _work_doDestroy(var _Data: TData; Index: Word);
      function getInterfaceBassHandle: Pointer;
  end;

implementation

function THIBASS_StreamCreateURL.getInterfaceBassHandle: Pointer;
begin
  Result := @FHandle;
end;

procedure SyncProc(handle: HSYNC; channel: DWORD; data: DWORD; user: Pointer); stdcall;
begin
  _hi_onEvent(THIBASS_StreamCreateURL(user)._event_onMeta);
end;

procedure DLProc(buffer: Pointer; len: DWORD; user: Pointer); stdcall;
begin
  // len = 0 - значит получили теги (по BASS_STREAM_STATUS),
  // иначе очередная порция загруженных данных
  if (buffer <> nil) and (len = 0) then 
    _hi_onEvent(THIBASS_StreamCreateURL(user)._event_onStatus, string(PAnsiChar(buffer)));
end;

procedure THIBASS_StreamCreateURL._work_doCreate;
var
  URL: string;
  Proc: DOWNLOADPROC;
begin         
  URL := ReadString(_Data, _data_URL, _prop_URL);
  
  if FHandle <> 0 then
  begin
    BASS_ChannelRemoveSync(FHandle, FSync);
    BASS_StreamFree(FHandle);
  end;
  
  if _prop_ParsePlayList then
    BASS_SetConfig(BASS_CONFIG_NET_PLAYLIST, 1);
  
  if Assigned(_event_onStatus.event) then Proc := @DLProc else Proc := nil;
  
  FHandle := BASS_StreamCreateURL(PChar(URL), 0, _prop_Flags or BASS_STREAM_STATUS {$ifdef UNICODE}or BASS_UNICODE{$endif}, Proc, Self);
  
  if FHandle = 0 then
    _hi_CreateEvent(_Data, @_event_onError, BASS_ErrorGetCode())
  else 
  begin
    FSync := BASS_ChannelSetSync(FHandle, BASS_SYNC_MIXTIME or BASS_SYNC_META, 0, SyncProc, Self);
    _hi_CreateEvent(_Data, @_event_onCreate);
  end;
end;

procedure THIBASS_StreamCreateURL._work_doDestroy;
begin
  BASS_StreamFree(FHandle);
  FHandle := 0;
end;

end.
