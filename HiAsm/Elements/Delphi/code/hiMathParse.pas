unit hiMathParse;

interface

{$I share.inc}

{$ifndef KOL3XX}
  {$define ERR_UNIT}
{$endif}

uses Kol,
     {$ifdef ERR_UNIT}err,{$endif}
     Share,Debug;

type
  THIMathParse = class(TDebug)
   private
    FDataCount:integer;
    Token,rToken:string;
    TokType:byte;
    Line:string;
    EPos,ELen,LPos:smallint;
    FResult:real;
    FDefault:real;
    AngleMode:real;
    Err:smallint;
    dt:TData;
    Args:array of real;
    flags:array of boolean;

    procedure SetCount(Value:integer);
    procedure SetLine(Value:string);
    procedure SetDefault(Value:real);
    procedure SetAngleMode(Value:byte);
    function CalcErrPos(Value:integer): string;

    procedure GetToken;
    procedure Parse;

    procedure Level0(var x:real); // ���������� ��������� (and or xor)
    procedure Level1(var x:real); // ���������� not, � ��������� (< > <= >= = <>))
    procedure Level2(var x:real); // ��������/���������
    procedure Level3(var x:real); // ���������/�������
    procedure Level4(var x:real); // ���������� � �������
    procedure Level5(var x:real); // �������� ��������� (& | ! << >>)
    procedure Level6(var x:real); // ���.�������� (~)����� (read, const, func), ��� �������� ()
    function ReadFunc(var x:real; f:string):boolean;
   public
    X:array of THI_Event;
    _event_onError:THI_Event;
    _event_onResult:THI_Event;
    _prop_ResultType:byte;
    _prop_ExtNames:integer;

    procedure _work_doCalc(var _Data:TData; Index:word);
    procedure _work_doMathStr(var _Data:TData; Index:word);
    procedure _work_doClear(var _Data:TData; Index:word);
    procedure _work_doAngleMode(var _Data:TData; Index:word);
    procedure _work_doDefault(var _Data:TData; Index:word);
    procedure _var_Result(var _Data:TData; Index:word);
    procedure _var_reCalc(var _Data:TData; Index:word);
    procedure _var_PosErr(var _Data:TData; Index:word);
    procedure _var_LenErr(var _Data:TData; Index:word);
    property _prop_DataCount:integer write SetCount;
    property _prop_MathStr:string write SetLine;
    property _prop_Default:real write SetDefault;
    property _prop_AngleMode:byte write SetAngleMode;
  end;

implementation

const
  TokErr    = 0;
  TokName   = 1;
  TokReal   = 2;
  TokNumber = 3;
  TokSymbol = 4;
  TokHex    = 5;
  TokArg    = 6;
  TokCmp    = 7;
  TokBin    = 8;

  serr      = 'MathParse Exception';
  s:array[0..1]of string =
    ('������ ���������� � �������� MathParser'#13#10'���������� � ������:������� - '
    ,'������ ���������� � �������� MathParser'#13#10'���������� � ������:������� - ');

function THIMathParse.CalcErrPos;
var nStr, nPos, i:integer;
begin
  nStr := 1; nPos := 1; i := 0;
  while i < Value do begin
    inc(nPos);
    if Line[i+1] = #13 then begin
      inc(nStr);
      nPos := 1;
      if Line[i+2] = #10 then inc(i);
    end;
    inc(i);
  end;
  Result := int2str(nStr) + ':' + int2str(nPos);
end;

procedure THIMathParse.SetLine;
begin
  Line := Value+#1; // �� ������ Value=nil... ��� FPC
end;

procedure THIMathParse.SetAngleMode;
begin
  if Value=0 then AngleMode :=1
  else AngleMode:=pi/180;
end;

procedure THIMathParse.SetDefault;
begin
  FDefault:=Value;
  FResult:=FDefault;
  ELen:= 0;
  EPos:=-1;
  Err :=-1;
end;

procedure THIMathParse._work_doDefault;
begin
  SetDefault(ToReal(_Data));
end;

procedure THIMathParse._work_doAngleMode;
begin
  SetAngleMode(ToInteger(_Data));
end;

procedure THIMathParse._work_doClear;
begin
  FResult:=FDefault;
  ELen:= 0;
  EPos:=-1;
  Err :=-1;
end;

procedure THIMathParse.SetCount;
begin
  SetLength(X,Value);
  SetLength(Args,Value);
  SetLength(Flags,Value);
  FDataCount := Value;
end;

procedure THIMathParse._work_doCalc;
begin
  dt := _Data; Parse;
  if Err < 0 then begin
    if _prop_ResultType<>0 then _hi_CreateEvent(_Data,@_event_onResult,FResult)
    else _hi_CreateEvent(_Data,@_event_onResult,integer(round(FResult)));
  end else begin
    if assigned(_event_onError.Event) then
      _hi_CreateEvent(_Data,@_event_onError,Err)
    else _debug(s[Err]+ CalcErrPos(EPos));
  end;
end;//_work_doCalc

procedure THIMathParse._var_reCalc;
begin
  dt := _Data; Parse;
  if Err < 0 then begin
    if _prop_ResultType<>0 then dtReal(_Data,FResult)
    else dtInteger(_Data, round(FResult));
  end else begin
    dtNULL(_Data);
    _Data.idata := Err;
    _Data.sdata := serr;
  end;
end;

procedure THIMathParse.Parse;
var i:integer; x:real;
begin
  for i:=0 to FDataCount-1 do Flags[i] := false;
  if Err>=0 then FResult:=FDefault;
  LPos := 1; Err := -1;
  {$ifdef ERR_UNIT}try{$endif}
    Level0(x);
    {$ifdef ERR_UNIT}if Err<0 then{$endif}
    if EPos+1<>length(Line) then Err:=0;
  {$ifdef ERR_UNIT}
  except on E:Exception do
    case E.Code of
      e_Custom: Err:=0;//SyntaxError
      else      Err:=1;//CalcError
    end;//case
  end;//except
  {$endif}
  if Err >= 0 then exit;
  ELen:= 0; EPos:=-1; FResult := x;
end;

procedure THIMathParse._work_doMathStr;
begin
  if _IsStr(_Data) then _prop_MathStr := Share.ToString(_Data);
end;

procedure THIMathParse._var_Result;
begin
  if Err>=0 then begin
    dtNULL(_Data);
    _Data.idata := Err;
    _Data.sdata := serr;
  end
  else if _prop_ResultType<>0 then dtReal(_Data,FResult)
  else dtInteger(_Data,Round(FResult));
end;

procedure THIMathParse._var_PosErr;
begin
  dtInteger(_Data,EPos);
end;

procedure THIMathParse._var_LenErr;
begin
  dtInteger(_Data,ELen);
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PARSE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

procedure THIMathParse.GetToken;
begin
  Token := ''; TokType := 0;
  while Line[LPos] in [' ',#9,#10,#13] do inc(LPos);
  EPos := LPos-1; ELen := 1; // ����� "����������� �������" ����� =1
  case Line[LPos] of
    'a'..'z','A'..'Z','_','�'..'�','�'..'�':
      begin
        repeat
          Token := Token + Line[LPos]; inc(LPos);
        until not(Line[LPos] in ['a'..'z','A'..'Z','_','�'..'�','�'..'�','0'..'9']);
        TokType := TokName;
      end;
    '.','$','0'..'9':
      if (Line[LPos]='$')or((Line[LPos]='0')and(Line[LPos+1]='x')) then begin
      // ��� ����
        if Line[LPos]<>'$' then inc(LPos);
        inc(LPos);
        while Line[LPos] in ['0'..'9','a'..'f','A'..'F'] do begin
          Token := Token + Line[LPos]; inc(LPos)
        end;
        if Token<>'' then TokType := TokHex;
      end else begin
        // ���� �� �����
        while Line[LPos] in ['0'..'9'] do begin
          Token := Token + Line[LPos]; inc(LPos)
        end;
        if Line[LPos]='.' then begin
        // ���� ���� ������� �����
          Token := Token + '.'; inc(LPos);
          while Line[LPos] in ['0'..'9'] do begin
            Token := Token + Line[LPos]; inc(LPos);
          end;
          if Token<>'.' then TokType := TokReal;
        end else TokType := TokNumber;
        // ���� �� ������� �������
        if (TokType<>0)and(Line[LPos] in ['e','E']) then begin
          Token := Token + Line[LPos]; inc(LPos);
          if Line[LPos] in ['+','-'] then begin
            Token := Token + Line[LPos]; inc(LPos);
          end;
          TokType := 0; // ������ �� �������������
          if Line[LPos] in ['0'..'9'] then begin
            TokType := TokReal;
            repeat Token := Token + Line[LPos]; inc(LPos)
            until not(Line[LPos] in ['0'..'9']);
          end;
        end;
      end;
    '%': // ������� ����
      begin
        inc(LPos);
        while Line[LPos] in ['0'..'9'] do begin
          Token := Token + Line[LPos]; inc(LPos);
        end;
        if Token<>'' then TokType := TokArg;
      end;
    '(',')',',','[',']','+','-','/','*','^','~':
      begin
        Token := Line[LPos]; inc(LPos); TokType := TokSymbol;
      end;
    '&','|','!':
      begin
        Token := Line[LPos]; inc(LPos); TokType := TokBin;
      end;
    '<','>','=':
      begin
        Token := Line[LPos]; inc(LPos);
        TokType := TokCmp;
        if Token = '<' then begin
          if Line[LPos] = '=' then begin
            Token := '{'; inc(LPos);
          end else
          if Line[LPos] = '>' then begin
            Token := '#'; inc(LPos);
          end else
          if Line[LPos] = '<' then begin
            Token := Token + Line[LPos]; inc(LPos);
            TokType := TokBin;
          end
        end else
        if Token = '>' then begin
          if Line[LPos] = '=' then begin
            Token := '}'; inc(LPos);
          end else
          if Line[LPos] = '>' then begin
            Token := Token + Line[LPos]; inc(LPos);
            TokType := TokBin;
          end
        end;
      end;
    else exit; // ELen=1, Token=''
  end;
  rToken := Token; // ��������� ����� ���������
  Token := LowerCase(Token);
  ELen := LPos-EPos-1;
end;

procedure THIMathParse.Level0;   // ���������� ��������� (and or xor)
var op:char; x2:real;
begin // ������ ��� ����
  Level1(x);{$ifndef ERR_UNIT}if Err>=0 then exit;{$endif}
  while (Token = 'and')or(Token = 'or')or(Token = 'xor')do begin
    op := Token[1];
    Level1(x2);{$ifndef ERR_UNIT}if Err>=0 then exit;{$endif}
    case op of
      'a': x := ord((x<>0)and(x2<>0));
      'o': x := ord((x<>0) or(x2<>0));
      'x': x := ord((x<>0)xor(x2<>0));
    end;
  end;
end;

procedure THIMathParse.Level1;  // ���������� not, � ��������� (< > <= >= = <>)
var n:boolean; op:char; x2,save:real;
begin // ������ ��� ����
  GetToken; n := Token = 'not';
  if n then GetToken;
  Level2(x);{$ifndef ERR_UNIT}if Err>=0 then exit;{$endif}
  if TokType=TokCmp then begin
    save := x; x := 1;
    repeat
      op := Token[1]; GetToken;
      Level2(x2);{$ifndef ERR_UNIT}if Err>=0 then exit;{$endif}
      case op of
        '<': x :=  x * ord(save< x2);
        '>': x :=  x * ord(save> x2);
        '{': x :=  x * ord(save<=x2);
        '}': x :=  x * ord(save>=x2);
        '=': x :=  x * ord(save= x2);
        '#': x :=  x * ord(save<>x2);
      end;
      save := x2;
    until TokType<>TokCmp;
  end;
  if n then x := ord(x=0);
end;

procedure THIMathParse.Level2;  // ��������/���������
var op:char; x2:real;
begin // ����� ��� ����
  op := ' ';
  if (Token = '-')or(Token = '+') then begin
    op := Token[1]; GetToken;
  end;
  Level3(x);{$ifndef ERR_UNIT}if Err>=0 then exit;{$endif}
  if op = '-' then x := -x;
  while (Token = '-')or(Token = '+') do begin
    op := Token[1]; GetToken;
    Level3(x2);{$ifndef ERR_UNIT}if Err>=0 then exit;{$endif}
    if op = '+' then x := x + x2
    else x := x - x2;
  end;
end;

procedure THIMathParse.Level3;   // ���������/�������
var op:char; x2:real;
begin // ����� ��� ����
  Level4(x);{$ifndef ERR_UNIT}if Err>=0 then exit;{$endif}
  while (Token='/')or(Token='*')or(Token='div')or(Token='mod')do begin
    op :=  Token[1]; GetToken;
    Level4(x2);{$ifndef ERR_UNIT}if Err>=0 then exit;{$endif}
    case op of
      '*': x := x*x2;
      '/': {$ifndef ERR_UNIT}if x2 = 0      then begin Err:=1;exit end else {$endif}
           x := x/x2;
      'd': {$ifndef ERR_UNIT}if round(x2)=0 then begin Err:=1;exit end else {$endif}
           x := round(x) div round(x2);
      else {$ifndef ERR_UNIT}if round(x2)=0 then begin Err:=1;exit end else {$endif}
           x := round(x) mod round(x2);
    end;
  end;
end;

procedure THIMathParse.Level4;   // ���������� � �������
var x2:real;
begin // ����� ��� ����
  Level5(x);{$ifndef ERR_UNIT}if Err>=0 then exit;{$endif}
  while (Token = '^') do begin
    GetToken; Level5(x2);
    {$ifndef ERR_UNIT}if Err>=0 then exit;
    if (round(x2)<>x2)and(x<=0) then begin Err:=1;exit end;{$endif}
    Power(x,x2);
  end;
end;

procedure THIMathParse.Level5;   //  �������� ��������� (& | ! << >>)
var op:char; x2:real;
begin // ����� ��� ����
  Level6(x);{$ifndef ERR_UNIT}if Err>=0 then exit;{$endif}
  while TokType = TokBin do begin
    op := Token[1]; GetToken;
    Level6(x2);{$ifndef ERR_UNIT}if Err>=0 then exit;{$endif}
    case op of
      '&': x := round(x)and round(x2);
      '|': x := round(x) or round(x2);
      '!': x := round(x)xor round(x2);
      '<': x := round(x)shl round(x2);
      '>': x := round(x)shr round(x2);
    end;
  end;
end;

function _IsBREAK(var dt:TData):boolean;
begin
  Result := (dt.data_type=data_break)or(dt.data_type=data_null);
end;

procedure THIMathParse.Level6; // ���.�������� (~), ����� (read, const, func), ��� �������� ()
var i,j:integer; Y:real;
    inv,noToken:boolean; //��������� ����� ��� �� ������
    Fd,FItem:TData;
    tmp:PData;
    Arr:PArray;
    Mtx:PMatrix;
begin // ����� ��� ����
  inv := Token='~'; if inv then GetToken; // ���.��������
  noToken := true;
  if TokType=TokArg then begin // ��� ����
    i := Str2Int(Token)-1;
    if i=-1 then x := FResult else // ���������� ���������
    if (i<FDataCount)and(i<>(_prop_ExtNames-1)) then begin
      GetToken;
      if Token = '[' then begin
      // ������ ������� ��� ������ (�� ���������� ����������)
        Level0(Y);{$ifndef ERR_UNIT}if Err>=0 then exit;{$endif}
        if Token <> ',' then begin
        // ���� ��� ������
          Arr := ReadArray(self.X[i]);
          if Arr=nil then
            {$ifdef ERR_UNIT}raise Exception.Create(e_Math_InvalidArgument,'');
            {$else} begin Err := 1; exit; end; {$endif}
          if Token <> ']' then
            {$ifdef ERR_UNIT}raise Exception.Create(e_Custom,'');
            {$else} begin Err := 0; exit; end; {$endif}
          dtReal(Fd,Y);
          if not Arr._Get(Fd,FItem) then
            {$ifdef ERR_UNIT}raise Exception.Create(e_Math_InvalidArgument,'');
            {$else} begin Err := 1; exit; end; {$endif}
          x := ToReal(FItem);
        end
        else begin
        // ���� ��� �������
          Mtx := ReadMatrix(self.X[i]);
          if Mtx=nil then
            {$ifdef ERR_UNIT}raise Exception.Create(e_Math_InvalidArgument,'');
            {$else} begin Err := 1; exit; end; {$endif}
          Level0(x); {$ifndef ERR_UNIT}if Err>=0 then exit;{$endif}
          if Token <> ']' then
            {$ifdef ERR_UNIT}raise Exception.Create(e_Custom,'');
            {$else} begin Err := 0; exit; end; {$endif}
          Fd:= Mtx._Get(round(Y),round(x));
          if _IsNull(Fd) then
            {$ifdef ERR_UNIT}raise Exception.Create(e_Math_InvalidArgument,'');
            {$else} begin Err := 1; exit; end; {$endif}
          x := ToReal(Fd);
        end
      end else
      if Token = '(' then begin
      // ������ ������� (���� ������ ���������)
        Level0(Y);{$ifndef ERR_UNIT}if Err>=0 then exit;{$endif}
        dtReal(Fd,Y);
        TRY
          while Token = ',' do begin  // ������� ���������� ����������
            Level0(Y);{$ifndef ERR_UNIT}if Err>=0 then exit;{$endif}
            dtReal(FItem,Y);
            AddMTData(@Fd, @FItem, tmp);
          end;
          FItem := Fd;
          if Token <> ')' then
            {$ifdef ERR_UNIT}raise Exception.Create(e_Custom,'');
            {$else} begin Err := 0; exit; end; {$endif}
          _ReadData(FItem,self.X[i]);
        FINALLY
          FreeData(@Fd);
        END;
        if _IsBREAK(FItem) then // ���: ���� ���� �� ���������, ���� - NULL
          {$ifdef ERR_UNIT}raise Exception.Create(e_Math_InvalidArgument,'');
          {$else} begin Err := 1; exit; end; {$endif}
        x := ToReal(FItem);
      end
      else begin
      // ������ ������ ������� ��������. � ���
        if not Flags[i] then begin
          Fd := ReadData(dt,self.X[i]);
          if _IsNULL(Fd) and (Fd.sdata=serr) then begin
            {$ifndef ERR_UNIT}Err := Fd.idata; exit;
            {$else}if Fd.idata>0 then raise Exception.Create(e_Math_InvalidArgument,'')
            else raise Exception.Create(e_Custom,'');
            {$endif}
          end;
          Args[i] := ToReal(Fd); // �������� ������ ��� ���������� ����
          Flags[i] := true;
        end;
        x := Args[i]; // ������ �� ����
        noToken := false; //��������� ����� ������, �� ��������� ��� '[', ���'('
      end
    end else // ������������ ����� ����
      {$ifdef ERR_UNIT}raise Exception.Create(e_Custom,'');
      {$else} begin Err := 0; exit; end; {$endif}
  end else
  if Token = '(' then begin
    // ��������� ��������
    Level0(x);{$ifndef ERR_UNIT} if Err>=0 then exit;{$endif}
    if Token <> ')' then
      {$ifdef ERR_UNIT}raise Exception.Create(e_Custom,'');
      {$else} begin Err := 0; exit; end; {$endif}
  end else
    case TokType of
    TokName: if ReadFunc(x, Token) then begin
      // ���������� ������� - ���������, ����� - �� ������
        {$ifndef ERR_UNIT}if Err>=0 then exit;{$endif}
      end else if (_prop_ExtNames>0)and(_prop_ExtNames<=FDataCount) then begin
      // ��� ��� � ��������� "������� ������������� �����"
        dtString(FItem,rToken);
        Fd := FItem;
        i := EPos; j := ELen; GetToken;
        noToken := Token = '(';
        TRY
          if noToken then begin  // ����������� ������� (���� ������ ���������)
            Level0(Y);{$ifndef ERR_UNIT} if Err>=0 then exit;{$endif}
            dtReal(FItem,Y);
            AddMTData(@Fd, @FItem, tmp);
            while Token = ',' do begin // ����������� ������� ���������� ����������
              Level0(Y); {$ifndef ERR_UNIT} if Err>=0 then exit; {$endif}
              dtReal(FItem,Y);
              AddMTData(@Fd, @FItem, tmp);
            end;
            FItem := Fd;
            if Token <> ')' then
              {$ifdef ERR_UNIT}raise Exception.Create(e_Custom,'');
              {$else} begin Err := 0; exit; end; {$endif}
          end;
          _ReadData(FItem,self.X[_prop_ExtNames-1]);
        FINALLY
          FreeData(@Fd);
        END;
        if _IsBREAK(FItem) then begin // ���: ���� ���� �� ���������, ���� - NULL
          EPos := i; ELen := j; // ���� - ����������� ���, �� ����������
          {$ifdef ERR_UNIT}raise Exception.Create(e_Custom,'');
          {$else} Err := 0; exit; {$endif}
        end;
        x := ToReal(FItem);
      end else // ��� ������ ����������
        {$ifdef ERR_UNIT}raise Exception.Create(e_Custom,'');
        {$else} begin Err := 0; exit; end; {$endif}
    // ������ ����� � ������ ��������
    TokReal,TokNumber: x := Str2Double(Token);
    TokHex: x:= Hex2Int(Token);
    else // ������, �� ������ ���� !!!
      {$ifdef ERR_UNIT}raise Exception.Create(e_Custom,'');
      {$else} begin Err := 0; exit; end; {$endif}
    end;
  if noToken then GetToken;
  if inv then x := not round(x); // ���.��������
end;


const FuncNames:array[1..40] of pchar = (
  'cos','sin','tg','ctg','arccos','arcsin','arctg','arcctg',       // 1..8
  'ch','sh','th','cth','arcch','arcsh','arcth','arccth',           // 9..16
  'lg','ln','exp','sqr','sqrt','abs','sign','odd','even',          //17..25
  'frac','trunc','round','floor','ceil','log','atan','min','max',  //26..34
  'and','or','xor','not','div','mod');  // KeyWords

function THIMathParse.ReadFunc;
var y:real; I:integer;
begin
  Result := True;
  if f = 'pi' then begin  x := pi;   exit end else
  if f = 'e'  then begin  x := digE; exit end;
  Result := false;
  for I := 1 to length(FuncNames) do
    if FuncNames[I]=f then begin Result := True;  break end;
  if not Result then exit;
  if I>34 then // �� ��������! ������������ ��������� ����� � �������� ����
    {$ifdef ERR_UNIT}raise Exception.Create(e_Custom,'');
    {$else} begin Err := 0; exit; end; {$endif}
  GetToken;
  if Token <> '(' then
    {$ifdef ERR_UNIT}raise Exception.Create(e_Custom,'');
    {$else} begin Err := 0; exit; end; {$endif}
  Level0(x);{$ifndef ERR_UNIT} if Err>=0 then exit;{$endif}
  if I >= 26 then begin // ������� ���� ����������
    if Token = ',' then begin
      Level0(y);{$ifndef ERR_UNIT}if Err>=0 then exit;{$endif}
    end else if I < 31 then y := 1 // frac, trunc, round, floor, ceil
    else
      {$ifdef ERR_UNIT}raise Exception.Create(e_Custom,'');
      {$else} begin Err := 0; exit; end; {$endif}
  // ������� ������� �� ���� ����������
    if I < 31 then begin // frac, trunc, round, floor, ceil
      if y<>0 then begin // y=0 ���� ������������, ���� �� ��� FPC
        x := x/y;
        case I of
          26: x := frac (x);
          27: x := trunc(x);
          28: x := round(x);
          29: if frac(x)<0 then x := trunc(x)-1 //floor
              else x := trunc(x);
          30: if frac(x)>0 then x := trunc(x)+1 //ceil
              else x := trunc(x);
        end;
        x := x*y;
      end else if I=26 then x := 0; // frac(x,0)=0, � ��������� =x (��� y=0)
    end else begin
      case I of
        31: {$ifndef ERR_UNIT}if (x<=0)or(y<=0) then begin Err:=1;exit;end else{$endif}
            x := LogN(x,y);
        32: x := ArcTan2(x,y)/AngleMode;
        33: if x > y then x := y; // min
        34: if x < y then x := y; // max
      end;
  // ��������� (� ������������) ������������� ��������� ��� min, max
      if I >= 33 then while Token = ',' do begin // ����� ����������
        Level0(y);{$ifndef ERR_UNIT}if Err>=0 then exit;{$endif}
        if I=33 then begin
          if x > y then x := y; // min
        end else
          if x < y then x := y; // max
      end;
    end;
  end else case I of
  // ������� ������ ���������
    1:  x := cos(x*AngleMode);
    2:  x := sin(x*AngleMode);
    3:  {$ifndef ERR_UNIT}if cos(x*AngleMode)=0 then begin Err:=1;exit;end else{$endif}
        x := Tan(x*AngleMode);
    4:  {$ifndef ERR_UNIT}if sin(x*AngleMode)=0 then begin Err:=1;exit;end else{$endif}
        x := CoTan(x*AngleMode);
    5:  {$ifndef ERR_UNIT}if (x>1)or(x<-1) then begin Err:=1;exit;end else{$endif}
        x := ArcTan2(sqrt(1-x*x),x)/AngleMode;
    6:  {$ifndef ERR_UNIT}if (x>1)or(x<-1) then begin Err:=1;exit;end else{$endif}
        x := ArcTan2(x,sqrt(1-x*x))/AngleMode;
    7:  x := ArcTan2(x,1)/AngleMode;
    8:  x := ArcTan2(1,x)/AngleMode;
    9:  begin y := exp(x); x := (y+1/y)/2 end;
    10: begin y := exp(x); x := (y-1/y)/2 end;
    11: begin y := exp(2*x); x := (y-1)/(y+1) end;
    12: {$ifndef ERR_UNIT}if x=0 then begin Err:=1;exit;end else{$endif}
        begin y := exp(2*x); x := (y+1)/(y-1) end;
    13: {$ifndef ERR_UNIT}if x<1 then begin Err:=1;exit;end else{$endif}
        x := LogN(digE,x+sqrt(x*x-1));
    14: x := LogN(digE,x+sqrt(x*x+1));
    15: {$ifndef ERR_UNIT}if (x>=1)or(x<=-1) then begin Err:=1;exit;end else{$endif}
        x := LogN(digE,(1+x)/(1-x))/2;
    16: {$ifndef ERR_UNIT}if (x<=1)and(x>=-1)then begin Err:=1;exit;end else{$endif}
        x := LogN(digE,(x+1)/(x-1))/2;
    17: {$ifndef ERR_UNIT}if x<=0 then begin Err:=1;exit;end else{$endif}
        x := LogN(10,x);
    18: {$ifndef ERR_UNIT}if x<=0 then begin Err:=1;exit;end else{$endif}
        x := LogN(digE,x);
    19: x := exp(x);
    20: x := sqr(x);
    21: {$ifndef ERR_UNIT}if x<0 then begin Err:=1;exit;end else{$endif}
        x := sqrt(x);
    22: if x<0 then x := -x;
    23: if x<0 then x := -1 else if x>0 then x:=1;
    24: x := ord(odd(round(x)));     {odd}
    25: x := ord(not odd(round(x))); {even}
  end;
  if Token <> ')' then
    {$ifdef ERR_UNIT}raise Exception.Create(e_Custom,'');
    {$else} begin Err := 0; exit; end; {$endif}
end;

end.
