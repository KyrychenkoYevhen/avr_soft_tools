unit hiBASS_StreamCreateFile;

interface

uses
  Kol, Share, Debug, BASS;

type
  THIBASS_StreamCreateFile = class(TDebug)
    private
      FHandle: HSTREAM;
      FSync: HSYNC;
    public
      _prop_FileName: string;
      _prop_Flags: Integer;
      _prop_Name: string;

      _data_FileName: THI_Event;
      _event_onCreate: THI_Event;
      _event_onEndPlay: THI_Event;
      _event_onError: THI_Event;

      procedure _work_doCreate(var _Data: TData; Index: Word);
      procedure _work_doDestroy(var _Data: TData; Index: Word);
      function getInterfaceBassHandle: Pointer;
  end;

implementation

function THIBASS_StreamCreateFile.getInterfaceBassHandle: Pointer;
begin
  Result := @FHandle;
end;

procedure SyncProc(handle: HSYNC; channel: DWORD; data: DWORD; user: Pointer); stdcall;
begin
  _hi_onEvent(THIBASS_StreamCreateFile(user)._event_onEndPlay);
end;

procedure THIBASS_StreamCreateFile._work_doCreate;
var
  FN: string;
begin         
  FN := ReadString(_Data, _data_FileName, _prop_FileName);
  if FHandle <> 0 then
  begin
    BASS_ChannelRemoveSync(FHandle, FSync);
    BASS_StreamFree(FHandle);
  end;
  
  FHandle := BASS_StreamCreateFile(False, PChar(FN), 0, 0, _prop_Flags {$ifdef UNICODE}or BASS_UNICODE{$endif});
  if FHandle = 0 then
    _hi_CreateEvent(_Data, @_event_onError, BASS_ErrorGetCode())
  else 
  begin
    FSync := BASS_ChannelSetSync(FHandle, BASS_SYNC_MIXTIME or BASS_SYNC_END, 0, SyncProc, Self);
    _hi_CreateEvent(_Data, @_event_onCreate);
  end;  
end;

procedure THIBASS_StreamCreateFile._work_doDestroy;
begin
  BASS_StreamFree(FHandle);
  FHandle := 0;
end;

end.
