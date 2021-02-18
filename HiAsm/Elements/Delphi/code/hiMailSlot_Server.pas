unit hiMailSlot_Server;

interface

{$I share.inc}

uses
  Windows, Kol, Share, Debug;

type
  THIMailSlot_Server = class(TDebug)
    private
      ms: THandle;
      lol: string;
      th: PThread;
      str: string;
      function _OnExec(Sender: PThread): NativeInt;
      procedure Stop;
      procedure SyncExec;
    public
      _prop_Name: string;
      _prop_TimeOut: Integer;
      _data_Name: THI_Event;

      _event_onStatus: THI_Event;
      _event_onRead: THI_Event;

      destructor Destroy; override;
      procedure _work_doCreate(var _Data: TData; Index: Word);
      procedure _work_doDestroy(var _Data: TData; Index: Word);
  end;

implementation

destructor THIMailSlot_Server.Destroy;
begin
  Stop;
  inherited;
end;

procedure THIMailSlot_Server._work_doCreate;
begin
  if not Assigned(th) then
  begin
    lol:= ReadString(_Data,_data_Name,_prop_Name);
    ms := CreateMailslot(PChar('\\.\mailslot\'+lol), 0, _prop_TimeOut, nil);
    if ms = INVALID_HANDLE_VALUE then
      _hi_OnEvent(_event_onStatus, 0)
    else
    begin
      _hi_OnEvent(_event_onStatus,1);
      SetLength(str, MAXWORD);
      {$ifdef F_P}
      th := NewThreadforFPC;
      {$else}
      th := NewThread;
      {$endif}
      th.OnExecute := _OnExec;
      th.Resume;
    end;
  end;
end;

function THIMailSlot_Server._OnExec;
var
  nBytesRead: Cardinal;
begin
  while not Sender.Terminated do
  begin
    if ReadFile(ms, str[1], MAXWORD*SizeOf(Char), nBytesRead, nil) then
    begin
      SetLength(str, nBytesRead);
      Sender.Synchronize(SyncExec);
      SetLength(str, MAXWORD);
    end;
  end;
  Result := 0;
end;

procedure THIMailSlot_Server.SyncExec;
begin
  _hi_OnEvent(_event_onRead, str);
end;

procedure THIMailSlot_Server.Stop;
begin
  if th <> nil then
  begin
    CloseHandle(ms);
    th.Free;
    th := nil;
  end;
end;

procedure THIMailSlot_Server._work_doDestroy;
begin
  Stop;
end;

end.
