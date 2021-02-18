unit hiMultiReplace;

interface

uses Windows, Kol, Share, Debug;

type
 THiMultiReplace = class(TDebug)
  private
    FMultiReplace: string;
    _Dlm, _End: Char;
    procedure SetDelimiter(Value: string);
    procedure SetEndSymbol(Value: string);
  public
    _prop_Mode:byte;
    _prop_ReplaceList: string;    
    _prop_EnterTag: string;

    _data_Text,
    _data_ReplaceList,
    _event_onResult: THI_Event;

    property _prop_Delimiter: string write SetDelimiter;
    property _prop_EndSymbol: string write SetEndSymbol;
        
    procedure _work_doMultiReplace0(var _Data:TData; index:word);
    procedure _work_doMultiReplace1(var _Data:TData; index:word);    
    procedure _work_doDelimiter(var _Data:TData; index:word);
    procedure _work_doEndSymbol(var _Data:TData; index:word);
    procedure _work_doEnterTag(var _Data:TData; index:word);             
    procedure _var_Result(var _Data:TData; index:word);
 end;

implementation

uses hiStr_Enum;

function Trim(Str: string): string;
var
  L: integer;
begin
  Result := Str;
  L := Length(Result);
  if L = 0 then exit;
  if Result[L] <> '\' then 
    while (L > 0) and (Result[L] <= ' ') do Dec(L)
  else
    Dec(L);
  SetLength(Result, L);
  if L = 0 then exit;
  L := 1;
  if Result[L] <> '\' then
    while (L <= Length(Result)) and (Str[L] <= ' ') do Inc(L)
  else
    Inc(L);
  Result := string(PChar(integer(@Result[1]) + L - 1));
end;

procedure Replace(var str: string; const substr, dest: string);
var
  p, r: integer;
  sb: string;
begin
  p := PosEx(substr, str);
  r := length(substr);
  while p > 0 do
  begin
    sb := CopyEnd(str, p + r);  
    SetLength(str, p - 1);
    str := str + dest + sb;
    p := p + Length(dest);
    p := PosEx(substr, str, p);
  end;
end;

procedure THiMultiReplace._work_doMultiReplace0;
var
  i: integer;
  s: string;
  FListFrom: PKOLStrList;
  FListTo: PKOLStrList;    
begin
  FMultiReplace := ReadString(_Data, _data_Text);
  s := ReadString(_Data, _data_ReplaceList, _prop_ReplaceList);

  Replace(s, _End + #13#10, _End);
  Replace(s, #13#10, _prop_EnterTag);  
  
  FListFrom := NewKOLStrList;
  FListTo := NewKOLStrList;
    
  while s <> '' do
  begin
    FListFrom.Add(trim(fparse(s, _Dlm)));
    FListTo.Add(trim(fparse(s, _End)));
  end;

  for i := 0 to FListFrom.count - 1 do
    Replace(FMultiReplace, FListFrom.Items[i], FListTo.Items[i]);
  Replace(FMultiReplace, _prop_EnterTag, #13#10); 
  
  FListFrom.free;
  FListTo.free;

  _hi_onEvent(_event_onResult, FMultiReplace);
end;

procedure THiMultiReplace._work_doMultiReplace1;
var
  i: integer;
  s: string;
  FListFrom: PKOLStrList;
  FListTo: PKOLStrList;
  FListMark: PKOLStrList;

  function Int2Mark(Value: integer): string;
  const
    arrsym: array[0..9] of char = (#1,#2,#3,#4,#5,#6,#11,#12,#14,#15);
  var
    s: string;
    i: integer;
  begin
    Result := _Dlm;
    s := Int2Str(Value);
    while Length(s) < 3 do s := '0' + s;
    for i := 1 to Length(s) do
      Result := Result + arrsym[ord(s[i]) - 48];
    Result := Result + _End;   
  end;
         
begin
  FMultiReplace := ReadString(_Data, _data_Text);
  s := ReadString(_Data, _data_ReplaceList, _prop_ReplaceList);

  Replace(s, _End + #13#10, _End);
  Replace(s, #13#10, _prop_EnterTag);  
  
  FListFrom := NewKOLStrList;
  FListTo := NewKOLStrList;
  FListMark := NewKOLStrList;  
    
  while s <> '' do
  begin
    FListFrom.Add(trim(fparse(s, _Dlm)));
    FListTo.Add(trim(fparse(s, _End)));
  end;

  for i := 0 to FListFrom.count - 1 do
    FlistMark.Add(Int2Mark(i));
  for i := 0 to FListFrom.count - 1 do
    Replace(FMultiReplace, FListFrom.Items[i], FListMark.Items[i]);
  for i := 0 to FListFrom.count - 1 do
    Replace(FMultiReplace, FListMark.Items[i], FListTo.Items[i]);
  Replace(FMultiReplace, _prop_EnterTag, #13#10); 
  
  FListFrom.free;
  FListTo.free;
  FListMark.free;

  _hi_onEvent(_event_onResult, FMultiReplace);
end;

procedure THiMultiReplace._var_Result;
begin
  dtString(_Data, FMultiReplace);
end;

procedure THiMultiReplace._work_doEnterTag;
begin
  _prop_EnterTag := Share.ToString(_Data);
end;

procedure THiMultiReplace._work_doDelimiter;
begin
  SetDelimiter(Share.ToString(_Data));
end;

procedure THiMultiReplace._work_doEndSymbol;
begin
  SetEndSymbol(Share.ToString(_Data));
end;

procedure THiMultiReplace.SetDelimiter;
begin
  _Dlm := (Value + #0)[1];
end;

procedure THiMultiReplace.SetEndSymbol;
begin
  _End := (Value + #0)[1];
end;

end.