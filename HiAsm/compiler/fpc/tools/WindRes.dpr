program WindRes;

{$APPTYPE CONSOLE}

uses
  windows, KOL, ShellAPI;

  function PosEx(const SubStr, S: string; Offset: Cardinal = 1): Integer;
var
  I,X: Integer;
  Len, LenSubStr: Integer;
begin
  if Offset = 1 then
    Result := Pos(SubStr, S)
  else
  begin
    I := Offset;
    LenSubStr := Length(SubStr);
    Len := Length(S) - LenSubStr + 1;
    while I <= Len do
    begin
      if S[I] = SubStr[1] then
      begin
        X := 1;
        while (X < LenSubStr) and (S[I + X] = SubStr[X + 1]) do
          Inc(X);
        if (X = LenSubStr) then
        begin
          Result := I;
          exit;
        end;
      end;
      Inc(I);
    end;
    Result := 0;
  end;
end;

  procedure Replace(var Str:string;const substr,dest:string );
var p:integer;
begin
   p := Pos(substr,str);
   while p > 0 do
    begin
       Delete(str,p,length(substr));
       Insert(dest,Str,p);
       p := PosEx(substr,str,p + Length(dest));
    end;
end;

  function LogName: String;
  begin
    Result := GetStartDir + 'FakeWindRes_call.log';
  end;

  procedure Fake;
  var S, S2, _or, _res: String;
      I: Integer;
  begin
    S := CmdLine;

    I := pos( ' -o ', S );
    S := Trim( CopyEnd( S, I + 4 ) );
    I := pos( ' --include ', S );
    S2 := CopyEnd(s,i+11);
    delete(s,i,length(s));
    I := PosEx(' ',s,length(s) div 2 - 3);
    _or := copy(s,1,i-1);
    _res := CopyEnd(s,i+1);
    s := '-o "' + _or + '" "' + _res + '" --include "' + S2 + '"';

   //MessageBox(0,PChar(s),'3',mb_ok);

    ShellExecute( 0, nil, PChar( GetStartDir + 'windres0.exe' ),
                  PChar( S ), nil, SW_HIDE );
  end;

begin
  //UseInputOutput;
  Fake;
end.
