unit hiFormatStr;

interface

uses
  Kol, Share, Debug;

type
  THIFormatStr = class(TDebug)
    private
      FStr, FSubStr: string;
      FDataCount: Integer;
      function TestRep(P: Integer): Boolean;
      procedure SetCount(Value: Integer);
    public
      Str: array of THI_Event;
      _prop_Mask: string;

      _event_onFString: THI_Event;

      procedure _work_doString(var _Data: TData; Index: Word);
      procedure _work_doMask(var _Data: TData; Index: Word);
      procedure _var_FString(var _Data: TData; Index: Word);
      property _prop_DataCount: Integer write SetCount;
  end;

implementation

procedure THIFormatStr.SetCount;
begin
  SetLength(Str, Value);
  FDataCount := Value;
end;

function THIFormatStr.TestRep(P: Integer): Boolean;
begin
  Result := not (FStr[P + Length(FSubStr)] in ['0'..'9']);
end;

procedure THIFormatStr._work_doString(var _Data: TData; Index: Word);
var
  I: Integer;
begin
  FStr := _prop_Mask;
  Replace(FStr, '%%', #0);
  for I := 1 to FDataCount do
  begin
    FSubStr := '%' + Int2Str(I);
    Replace(FStr, FSubStr, #1 + ReadString(_Data, Str[I-1]), TestRep);
  end;
  Replace(FStr, #1, '');
  Replace(FStr, #0, '%');
  _hi_CreateEvent(_Data, @_event_onFString, FStr);
end;

procedure THIFormatStr._work_doMask(var _Data: TData; Index: Word);
begin
  _prop_Mask := Share.ToString(_Data);
end;

procedure THIFormatStr._var_FString(var _Data: TData; Index: Word);
begin
  dtString(_Data, FStr);
end;

end.
