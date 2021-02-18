unit hidbMySQL_Exec;

interface

uses
  KOL, Share, Debug, MySQL;

type
  THIdbMySQL_Exec = class(TDebug)
    private
      
    public
      _prop_QueryText: string;
      _prop_UseName: Boolean;
      
      _data_dbHandle: THI_Event;
      _data_QueryText: THI_Event;
      _data_BlobData: THI_Event;
      
      _event_onError: THI_Event;
      _event_onResult: THI_Event;
      _event_onGetBlob: THI_Event;

      procedure _work_doExec(var _Data: TData; Index: Word);
  end;

implementation

uses
  hidbMySQL;



function GetBlobName(const S: AnsiString; Pos: Integer): string;
var
  C: AnsiChar;
  I: Integer;
begin
  I := Pos;
  repeat
    Inc(I);
    C := S[I];
  until ((C = ' ') or (C = ',') or (C = ')') or (C = #13) or (C = #0));
  Result := Copy(S, Pos+1, I-Pos-1);
end;

function AnsiCharPosEx(Search: AnsiChar; const S: AnsiString; Offset: Integer = 1): Integer;
var
  L: Integer;
  C: PAnsiChar;
begin
  L := Length(S);
  if (L = 0) or (Offset > L) then
  begin
    Result := 0;
    Exit;
  end;
  
  if Offset < 1 then Offset := 1;
  
  Result := Offset;
  Dec(Offset); // 0-based
  
  C := Pointer(S);
  Inc(C, Offset);
  Dec(L, Offset);
  
  while L > 0 do
  begin
    if C^ = Search then exit;
    Dec(L);
    Inc(C);
    Inc(Result);
  end;
  
  Result := 0;
end;




procedure THIdbMySQL_Exec._work_doExec(var _Data: TData; Index: Word);
var
  S, Query: AnsiString;
  N: string;
  I, Idx: Integer;
  
  MS: TMySQL;
  
  Buf: TBytes;
  BufSize: Integer;
  BlobStream: PStream;
begin
  MS := ReadObject(_Data, _data_dbHandle, MySQL_GUID);
  if MS <> nil then
  begin
    Query := MS.StringToMySQLStr(ReadString(_Data, _data_QueryText, _prop_QueryText));
	  Idx := 0;
    Buf := nil;
    
    I := AnsiCharPosEx(':', Query, 1);
    
    while I > 0 do
    begin
      N := GetBlobName(Query, I);
      if _prop_UseName then
        _hi_OnEvent(_event_onGetBlob, N)		
      else
        _hi_OnEvent(_event_onGetBlob, Idx);
        
      Inc(Idx);
      
      S := '';
      
      BlobStream := ReadStream(_Data, _data_BlobData, nil);
      if BlobStream <> nil then
      begin
        BufSize := BlobStream.Size;
        BlobStream.Position := 0;
        if BufSize > 0 then
        begin
          if BufSize > Length(Buf) then SetLength(Buf, BufSize);
          
          BufSize := BlobStream.Read(Buf[0], BufSize);
          BlobStream.Position := 0;
          
          S := MS.BlobToString(Pointer(Buf), BufSize);
        end;
      end;
      
      Query := Copy(Query, 1, I-1) + '''' + S + '''' + Copy(Query, I+Length(N)+1, Length(Query)-I);
      
      I := AnsiCharPosEx(':', Query, I+Length(S)+2);
    end;
    
    _hi_OnEvent(_event_onResult, MS.Execute(Pointer(Query), Length(Query)));
  end
  else
    _hi_OnEvent(_event_onError, 0);
end;

end.

