unit hiStrCat;

interface

uses
  Kol, Share, Debug;

type
  THIStrCat = class(TDebug)
    private
      R: string;
    public
    _prop_Str1: string;
    _prop_Str2: string;

    _data_Str2: THI_Event;
    _data_Str1: THI_Event;
    _event_onStrCat: THI_Event;

    procedure _work_doStrCat(var _Data: TData; Index: Word);
    procedure _work_doConcatBinary(var _Data: TData; Index: Word);
    procedure _work_doClear(var _Data: TData; Index: Word);
    procedure _var_Result(var _Data: TData; Index: Word);
  end;

  function ConcatBinaryStr(const S1, S2: string): string;

implementation


function ConcatBinaryStr(const S1, S2: string): string;
var
  L1, L2, LR: Integer;
  P: Pointer;
begin
  L1 := BinaryLength(S1);
  L2 := BinaryLength(S2);
  LR := L1 + L2;
  if LR = 0 then Exit;
  
  SetLength(Result, BinaryStrSize(LR));
  P := Pointer(Result);
  Move(Pointer(S1)^, P^, L1);
  Inc(NativeUInt(P), L1);
  Move(Pointer(S2)^, P^, L2);
  PadBinaryBuf(Pointer(Result), LR);
end;

procedure THIStrCat._work_doStrCat;
var
  S1, S2: string;
begin
  S1 := ReadString(_Data, _data_Str1, _prop_Str1);
  S2 := ReadString(_Data, _data_Str2, _prop_Str2);
  R := S1 + S2; 
  _hi_CreateEvent(_data, @_event_onStrCat, R);
end;

procedure THIStrCat._work_doConcatBinary;
var
  S1, S2: string;
begin
  S1 := ReadString(_Data, _data_Str1, _prop_Str1);
  S2 := ReadString(_Data, _data_Str2, _prop_Str2);
  {$ifdef UNICODE}
    R := ConcatBinaryStr(S1, S2);
  {$else}
    R := S1 + S2; 
  {$endif}
  _hi_CreateEvent(_data, @_event_onStrCat, R);
end;

procedure THIStrCat._work_doClear;
begin
  R := '';
end;

procedure THIStrCat._var_Result;
begin
  dtString(_Data, R);
end;

end.
