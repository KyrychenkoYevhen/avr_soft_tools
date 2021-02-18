unit hiDataToFile;

interface

uses
  Kol, Share, Debug, CodePages;

type
  TdtProc = function (st: PStream; const Val: PData): TData of object;
  
  THIDataToFile = class(TDebug)
    private
      FCharset: Integer;
      
      procedure SetCharset(Value: Byte);
    public
      _prop_Type: TdtProc;
      _prop_OutBOM: Byte;
      _event_onGet: THI_Event;
      _data_Stream: THI_Event;
      
      property _prop_Charset: Byte write SetCharset;
      
      constructor Create;

      function dtByte(st: PStream; const Val: PData): TData;
      function dtWord(st: PStream; const Val: PData): TData;
      function dtCardinal(st: PStream; const Val: PData): TData;
      function dtInteger(st: PStream; const Val: PData): TData;
      function dtReal(st: PStream; const Val: PData): TData;
      function dtPString(st: PStream; const Val: PData): TData;
      function dtStringZ(st: PStream; const Val: PData): TData;
      function dtLines(st: PStream; const Val: PData): TData;

      procedure _work_doPut(var _Data: TData; Index: Word);
      procedure _work_doGet(var _Data: TData; Index: Word);
      procedure _work_doPosition(var _Data: TData; Index: Word);
      
      procedure _work_doCharset(var _Data: TData; Index: Word);
      
      procedure _var_Data(var _Data: TData; Index: Word);
      procedure _var_Position(var _Data: TData; Index: Word);
  end;

implementation

constructor THIDataToFile.Create;
begin
  inherited;
  FCharset := DefaultCompilerCP;
end;

procedure THIDataToFile.SetCharset(Value: Byte);
begin
  FCharset := OutCharsetProp[Value];
end;

procedure THIDataToFile._work_doPut(var _Data: TData; Index: Word);
var
  st: PStream;
begin
  st := ToStreamEvent(_data_Stream);
  if st <> nil then
    _prop_Type(st, @_Data);
end;

procedure THIDataToFile._work_doGet(var _Data: TData; Index: Word);
var
  st: PStream;
begin
  st := ToStreamEvent(_data_Stream);
  if st <> nil then
    _hi_CreateEvent(_Data, @_event_onGet, _prop_Type(st, nil));
end;

procedure THIDataToFile._work_doPosition(var _Data: TData; Index: Word);
var
  st: PStream;
begin
  st := ToStreamEvent(_data_Stream);
  if st <> nil then
    st.Position := ToInteger(_Data);
end;

procedure THIDataToFile._work_doCharset(var _Data: TData; Index: Word);
begin
  FCharset := ToInteger(_Data);
end;

procedure THIDataToFile._var_Data(var _Data: TData; Index: Word);
var
  st: PStream;
begin
  st := ToStreamEvent(_data_Stream);
  if st <> nil then
    _Data := _prop_Type(st, nil)
  else
    dtNull(_Data);
end;

procedure THIDataToFile._var_Position(var _Data: TData; Index: Word);
var
  st: PStream;
begin
  st := ToStreamEvent(_data_Stream);
  if st <> nil then
    Share.dtInteger(_Data, st.Position)
  else
    dtNull(_Data);
end;


function THIDataToFile.dtByte;
var
  b: byte;
begin
  if val = nil then
  begin
    st.Read(b, 1);
    Share.dtInteger(Result, b);
  end
  else
  begin
    b := ToInteger(val^);
    st.Write(b, 1);
  end;
end;

function THIDataToFile.dtWord;
var
  w: Word;
begin
  if val = nil then
  begin
    st.Read(w, 2);
    Share.dtInteger(Result, w);
  end
  else
  begin
    w := ToInteger(val^);
    st.Write(w, 2);
  end;
end;

function THIDataToFile.dtCardinal;
var
  c: Cardinal;
begin
  if val = nil then
  begin
    st.Read(c, 4);
    Share.dtInteger(Result, c);
  end
  else
  begin
    c := ToInteger(val^);
    st.Write(c, 4);
  end;
end;

function THIDataToFile.dtInteger;
var
 i: Integer;
begin
  if val = nil then
  begin
    st.Read(i, 4);
    Share.dtInteger(Result, i);
  end
  else
  begin
    i := ToInteger(val^);
    st.Write(i, 4);
  end;
end;

function THIDataToFile.dtReal;
var
  r: Real;
begin
  if val = nil then
  begin
    st.Read(r, SizeOf(Real));
    Share.dtReal(Result, r);
  end
  else
  begin
    r := ToReal(val^);
    st.Write(r, SizeOf(Real));
  end;
end;

function THIDataToFile.dtPString;
var
  S: string;
  Len: Word;
begin
  if val = nil then
  begin
    st.Read(Len, 2);
    if Len = 0 then exit;
    
    S := StreamReadString(st, Len, FCharset);
    if S = '' then exit;
    Share.dtString(Result, S);
  end
  else
  begin
    S := Share.ToString(val^);
    if (FCharset <> DefaultCompilerCP) and (FCharset <> CP_BINARY) then
      S := ConvertCharset(S, DefaultCompilerCP, FCharset);
      
    Len := BinaryLength(S);
    if st.Write(Len, 2) = 2 then st.Write(S[1], Len);
  end;
end;

function THIDataToFile.dtStringZ;
begin
  if val = nil then
  begin
   if st.Position < st.Size then
    Share.dtString(Result, StreamReadStringZ(st, FCharset));
  end
  else
    StreamWriteStringZ(st, Share.ToString(val^), FCharset, _prop_OutBOM <> 0);
end;

function THIDataToFile.dtLines;
begin
  if val = nil then
  begin
   if st.Position < st.Size then
    Share.dtString(Result, StreamReadLine(st, FCharset));
  end
  else
    StreamWriteLine(st, Share.ToString(val^), FCharset, _prop_OutBOM <> 0);
end;

end.
