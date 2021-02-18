unit hiStrMask;

interface

uses
  Windows, KOL, Share, Debug;

type
  THIStrMask = class(TDebug)
    private
      FMask: string;
      procedure SetMask(Value: string);
    public
      _prop_CaseSensitive: Byte;

      _data_Str: THI_Event;
      _event_onTrue: THI_Event;
      _event_onFalse: THI_Event;
      
      property _prop_Mask: string write SetMask; // Свойство Mask должно стоять последним в ini!

      procedure _work_doCompare(var _Data: TData; Index: Word);
      procedure _work_doMask(var _Data: TData; Index: Word);
  end;

function StrCmp(Str, Msk: string): Boolean;

implementation

function _StrCmp(Str, Msk: PChar): Boolean;
begin
  while (Str^ <> #0) and (Msk^ <> #0) do
  begin
    if Msk^ = '*' then
    begin
      Result := _StrCmp(Str, Msk + 1);
      if Result then Exit;
    end
    else
    begin
      if Msk^ = '#' then
        Result := Str^ in ['0'..'9']
      else
        Result := (Msk^ = '?') or (Msk^ = Str^);
      
      if Result then
        Inc(Msk)
      else
        Exit;
    end;
    
    Inc(Str);
  end;
  
  while Msk^ = '*' do Inc(Msk);
  
  Result := (Str^ = #0) and (Msk^ = #0);
end;

function StrCmp(Str, Msk: string): Boolean;
begin
  Result := _StrCmp(PChar(Str), PChar(Msk));
end;

procedure THIStrMask._work_doCompare;
var
  Str: string;
begin
  Str := ReadString(_Data, _data_Str);
  _hi_CreateEvent(_Data, @_event_onFalse, Str);
  
  if (_prop_CaseSensitive = 1) then
  begin
    Str := AnsiLowerCase(Str);
  end;
  
  if _StrCmp(PChar(Str), PChar(FMask)) then
    _Data.Next := @_event_onTrue;
end;

procedure THIStrMask._work_doMask;
begin
  SetMask(Share.ToString(_Data));
end;

procedure THIStrMask.SetMask(Value: string);
begin
  FMask := Value;
  if (_prop_CaseSensitive = 1) then
    FMask := AnsiLowerCase(FMask);
end;

end.
