unit hiEvents;

interface

uses
  Windows, Kol, Share, Debug;

type
  THIEvents = class(TDebug)
    private
      FEvent: THandle;
      procedure InitEvent;
    public
      _prop_Name: string;
      _prop_ManualReset: Boolean;
      
      destructor Destroy; override;

      procedure _work_doSet(var _Data: TData; Index: Word);
      procedure _work_doReset(var _Data: TData; Index: Word);
      procedure _work_doName(var _Data: TData; Index: Word);
      procedure _var_ObjHandle(var _Data: TData; Index: Word);
  end;

implementation

destructor THIEvents.Destroy;
begin
  CloseHandle(FEvent);
  inherited;
end;

procedure THIEvents.InitEvent;
begin
  FEvent := CreateEvent(nil, _prop_ManualReset, False, Pointer(_prop_Name));
end;

procedure THIEvents._work_doSet(var _Data: TData; Index: Word);
begin
  if FEvent = 0 then InitEvent;
  SetEvent(FEvent);
end;

procedure THIEvents._work_doReset(var _Data: TData; Index: Word);
begin
  if FEvent = 0 then InitEvent;
  ResetEvent(FEvent);
end;

procedure THIEvents._work_doName(var _Data: TData; Index: Word);
var
  S: string;
begin
  S := Share.ToString(_Data);
  if S <> _prop_Name then
  begin
    _prop_Name := S;
    // Объект будет создан позже при первой необходимости
    CloseHandle(FEvent);
    FEvent := 0;
  end;
end;

procedure THIEvents._var_ObjHandle(var _Data: TData; Index: Word);
begin
  if FEvent = 0 then InitEvent;
  dtInteger(_Data, FEvent);
end;

end.
