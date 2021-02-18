unit If_arg;

interface

uses KOL, Share;

function Compare(Op1, Op2: TData; OpType: Byte): Boolean;

implementation

function Compare(Op1, Op2: TData; OpType: Byte): Boolean;
var
  i: Integer;
  r: Real;
  s: string;
begin
  Result := False;
  case _IsType(op1) of
    data_int:
      begin
        i := ToInteger(op2);
        case OpType of
         0: Result := op1.idata = i;
         1: Result := op1.idata < i;
         2: Result := op1.idata > i;
         3: Result := op1.idata <= i;
         4: Result := op1.idata >= i;
         5: Result := op1.idata <> i;
        end;
      end;
    data_str:
      begin
        s := Share.ToString(op2);
        case OpType of
         0: Result := op1.sdata = s;
         1: Result := AnsiCompareText(op1.sdata, s) < 0;
         2: Result := AnsiCompareText(op1.sdata, s) > 0;
         3: Result := AnsiCompareText(op1.sdata, s) <= 0;
         4: Result := AnsiCompareText(op1.sdata, s) >= 0;
         5: Result := op1.sdata <> s;
        end;
      end;
    data_real:
      begin
        r := ToReal(op2);
        case OpType of
         0: Result := op1.rdata = r;
         1: Result := op1.rdata < r;
         2: Result := op1.rdata > r;
         3: Result := op1.rdata <= r;
         4: Result := op1.rdata >= r;
         5: Result := op1.rdata <> r;
        end;        
      end;
    data_null: Result := _IsType(op2) = data_null;
  end;
end;

end.
