unit hiWaitMultiple;

interface

uses
  Windows, Kol, Share, Debug;

type

  ThiWaitMultiple = class(TDebug)
    private
      FCount: Integer;
      procedure SetCount(Value: Integer);
    public
      _prop_Time: Integer;
      _prop_WaitFor: Integer;

      Handle: array of THI_Event;

      _event_onWait: THI_Event;
      _event_onTimeout: THI_Event;

      property _prop_Count: Integer write SetCount;
      procedure _work_doWait(var _Data: TData; Index: Word);
      procedure _work_doTime(var _Data: TData; Index: Word);
  end;


implementation

procedure ThiWaitMultiple.SetCount;
begin
  SetLength(Handle, Value);
  FCount := Value;
end;

procedure ThiWaitMultiple._work_doWait;
var
  I, C: Integer;
  H: THandle;
  Arr: array of THandle;
begin
  SetLength(Arr, FCount);
  
  C := 0;
  
  for I := 0 to FCount-1 do
  begin
    H := ToIntegerEvent(Handle[I]);
    if H <> 0 then
    begin
      Arr[C] := H;
      Inc(C);
    end;
  end;
  
  if C = 0 then Exit;
  
  I := WaitForMultipleObjects(C, @Arr[0], Bool(_prop_WaitFor), _prop_Time);

  if DWORD(I) = WAIT_TIMEOUT then
    _hi_CreateEvent(_Data, @_event_onTimeout)
  else
    _hi_CreateEvent(_Data, @_event_onWait, I);
end;

procedure ThiWaitMultiple._work_doTime(var _Data: TData; Index: Word);
begin
  _prop_Time := ToInteger(_Data);
end;

end.
