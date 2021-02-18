unit hiArrayFilterRepeats;

interface

uses
  Windows, Kol, {$ifdef KOL3XX} KOLadd, {$endif} Share, Debug;

type
  THIArrayFilterRepeats = class(TDebug)
  private
    ArrOut: PArray;
    ArrIn: PArray;
    PArr: PObj;

    function intFind(const V: NativeInt; var Index: Integer): Boolean;
    function realFind(const V: Real; var Index: Integer): Boolean;
    function GetArrayVal(Idx: Integer): TData;
    function _Count0: Integer;                                 // String
    function _Count1: Integer;                                 // Integer
    function _Count2: Integer;                                 // Real
    function _aGet0(var Item: TData; var Val: TData): Boolean; // String
    function _aGet1(var Item: TData; var Val: TData): Boolean; // Integer
    function _aGet2(var Item: TData; var Val: TData): Boolean; // Real
  public
    _prop_ArrayType: byte;
    _event_onFilter: THI_Event;
    _event_onEndFilter: THI_Event;
    _data_Array: THI_Event;

    destructor Destroy; override;

    procedure _work_doFilter0(var _Data: TData; Index: Word);  // String
    procedure _work_doFilter1(var _Data: TData; Index: Word);  // Integer
    procedure _work_doFilter2(var _Data: TData; Index: Word);  // Real
    procedure _var_ArrayFilter(var _Data: TData; Index: Word);
    procedure _var_Count(var _Data: TData; Index: Word);
  end;

implementation

type
  {$ifdef WIN64} // В 64-битной редакции - представление 64-битного Double как 64-битного Pointer-а
    RX = record
    case Byte of
      0: (RP: Pointer);
      1: (Rl: Real);
    end;
  {$else} // В 32-битной редакции - представление 64-битного Double как двух 32-битных Pointer-ов
    RX = record
    case Byte of
      0: (Lr, Hr: Pointer);
      1: (Rl: Real);
    end;
  {$endif}

destructor THIArrayFilterRepeats.Destroy;
begin
  if ArrOut <> nil then
    Dispose(ArrOut);
  PArr.Free;
  inherited;
end;

function THIArrayFilterRepeats.GetArrayVal(Idx: Integer): TData;
var
  Ind, Dt: TData;
begin
  Ind := _DoData(Idx);
  ArrIn._Get(Ind, Dt);
  Result := Dt;
end;

procedure THIArrayFilterRepeats._var_ArrayFilter(var _Data: TData; Index: Word);
begin
  if ArrOut = nil then dtNull(_Data)
  else dtArray(_Data, ArrOut);
end;

procedure THIArrayFilterRepeats._var_Count(var _Data: TData; Index: Word);
begin
  if ArrOut = nil then dtNull(_Data)
  else dtInteger(_Data, ArrOut._Count);
end;

//
// Нижеследующие методы для _prop_ArrayType = 0
// Случай массива строк: type(PArr) = PKOLStrList
//
procedure THIArrayFilterRepeats._work_doFilter0(var _Data: TData; Index: Word);
var
  I, J: Integer;
  S: string;
  P: PKOLStrList;
begin
  ArrIn := ReadArray(_data_Array);
  if (ArrIn = nil) or (ArrIn._Count = 0) then exit;
  
  if ArrOut = nil then
  begin
    PArr := NewKOLStrList;
    ArrOut := CreateArray(nil, _aGet0, _Count0, nil);
  end;
  
  P := PKOLStrList(PArr);
  P.Clear;
  
  for I := 0 to ArrIn._Count - 1 do
  begin
    S := Share.ToString(GetArrayVal(I));
    {$ifdef KOL3XX}
      if P.IndexOf(S) = -1 then
      begin
        P.Add(S);
        _hi_onEvent(_event_onFilter, S);
      end;
    {$else}
      if not P.Find(S, J) then
      begin
        P.Insert(J, S);
        _hi_onEvent(_event_onFilter, S);
      end;
    {$endif}
  end;
  
  _hi_CreateEvent_(_Data, @_event_onEndFilter);
end;

function THIArrayFilterRepeats._aGet0(var Item: TData; var Val: TData): Boolean;
var
  Index: Integer;
  P: PKOLStrList;
begin
  Index := ToIntIndex(Item);
  P := PKOLStrList(PArr);
  Result := (Index >= 0) and (Index < P.Count);
  if Result then dtString(Val, P.Items[Index]);
end;

function THIArrayFilterRepeats._Count0: Integer;
begin
  Result := PKOLStrList(PArr).Count;
end;

//
// Нижеследующие методы для _prop_ArrayType = 1
// Случай массива целых чисел: type(PArr) = PList
//
function THIArrayFilterRepeats.intFind(const V: NativeInt; var Index: Integer): Boolean;
var
  L, H, I: Integer;
  C: NativeInt;
begin
  Result := false;
  L := 0;
  H := PList(PArr).Count - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := NativeInt(PList(PArr).Items[I]) - V;
    if C < 0 then
      L := I + 1
    else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := true;
        L := I;
      end;
    end;
  end;
  Index := L;
end;

procedure THIArrayFilterRepeats._work_doFilter1(var _Data: TData; Index: Word);
var
  I, J: Integer;
  V: NativeInt;
  P: PList;
begin
  ArrIn := ReadArray(_data_Array);
  if (ArrIn = nil)or(ArrIn._Count = 0) then exit;
  if ArrOut = nil then
  begin
    PArr := NewList;
    ArrOut := CreateArray(nil, _aGet1, _Count1, nil);
  end;
  P := PList(PArr);
  P.Clear;
  for i := 0 to ArrIn._Count - 1 do
  begin
    V := ToInteger(GetArrayVal(i));
    if not intFind(V, j) then
    begin
      P.Insert(j, pointer(V));
      _hi_onEvent(_event_onFilter, V);
    end;
  end;
  _hi_CreateEvent_(_Data, @_event_onEndFilter);
end;

function THIArrayFilterRepeats._aGet1(var Item: TData; var Val: TData): Boolean;
var
  Index: Integer;
  P: PList;
begin
  Index := ToIntIndex(Item);
  P := PList(PArr);
  Result := (Index >= 0) and (Index < P.Count);
  if Result then dtInteger(Val, NativeInt(P.Items[Index]));
end;

function THIArrayFilterRepeats._Count1: Integer;
begin
  Result := PList(PArr).Count;
end;

//
// Нижеследующие методы для _prop_ArrayType = 2
// Случай массива дробных чисел: type(PArr) = PListEx
//
function THIArrayFilterRepeats.realFind(const V: Real; var Index: Integer): Boolean;
var
  L, H, I: Integer;
  CC: RX;
begin
  Result := false;
  L := 0;
  H := PListEx(PArr).Count - 1;
  
  while L <= H do
  begin
    I := (L + H) shr 1;
    {$ifdef WIN64}
    CC.RP := PListEx(PArr).Items[I];
    {$else}
    CC.Lr := PListEx(PArr).Items[I];
    CC.Hr := PListEx(PArr).ObjList.Items[I];
    {$endif}
    if CC.Rl < V then
      L := I + 1
    else
    begin
      H := I - 1;
      if CC.Rl = V then
      begin
        Result := true;
        L := I;
      end;
    end;
  end;
  
  Index := L;
end;

procedure THIArrayFilterRepeats._work_doFilter2(var _Data: TData; Index: Word);
var
  I, J: Integer;
  P: PListEx;
  V: RX; // просто Real
begin
  ArrIn := ReadArray(_data_Array);
  if (ArrIn = nil) or (ArrIn._Count = 0) then exit;
  
  if ArrOut = nil then
  begin
    PArr := NewListEx;
    ArrOut := CreateArray(nil, _aGet2, _Count2, nil);
  end;
  
  P := PListEx(PArr);
  P.Clear;
  
  for I := 0 to ArrIn._Count - 1 do
  begin
    V.Rl := ToReal(GetArrayVal(I));
    if not realFind(V.Rl, J) then
    begin
      {$ifdef WIN64}
      P.Insert(J, V.RP);
      {$else}
      P.InsertObj(J, V.Lr, V.Hr);
      {$endif}
      _hi_onEvent(_event_onFilter, V.Rl);
    end;
  end;
  
  _hi_CreateEvent_(_Data, @_event_onEndFilter);
end;

function THIArrayFilterRepeats._aGet2(var Item: TData; var Val: TData): Boolean;
var
  Index: Integer;
  P: PListEx;
  V: RX; // просто Real
begin
  Index := ToIntIndex(Item);
  P := PListEx(PArr);
  Result := (Index >= 0) and (Index < P.Count);
  if Result then
  begin
    {$ifdef WIN64}
      V.RP := P.Items[Index];
    {$else}
      V.Lr := P.Items[Index];
      V.Hr := P.ObjList.Items[Index];
    {$endif}
    dtReal(Val, V.Rl);
  end;
end;

function THIArrayFilterRepeats._Count2: Integer;
begin
  Result := PListEx(PArr).Count;
end;

end.
