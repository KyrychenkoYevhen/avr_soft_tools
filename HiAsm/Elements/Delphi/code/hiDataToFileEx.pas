unit hiDataToFileEx;

interface

uses
  Kol, Share, Debug, CodePages;

type

  TdtProc = function (st: PStream; const Val: PData): TData of object;
  
  THIDataToFileEx = class(TDebug)
    private
      FCharset: Integer;
      
      procedure SetCharset(Value: Byte);
    public
      _prop_Type: TdtProc;
      _prop_DataSize: Integer;
      _prop_Signed: Boolean;
      _prop_BigEndian: Boolean;
      _prop_OutBOM: Byte;

      _data_Stream: THI_Event;
      _event_onGet: THI_Event;
      _event_onWrError: THI_Event;
      _event_onRdError: THI_Event;
      
      property _prop_Charset: Byte write SetCharset;
      
      constructor Create;

      procedure Reverse(p: Pointer);
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
      procedure _var_Size(var _Data: TData; Index: Word);
  end;

implementation

type
  dw = Cardinal;

constructor THIDataToFileEx.Create;
begin
  inherited;
  FCharset := DefaultCompilerCP;
end;

procedure THIDataToFileEx.SetCharset(Value: Byte);
begin
  FCharset := OutCharsetProp[Value];
end;

procedure THIDataToFileEx._work_doPut;
var
  st: PStream;
begin
  st := ReadStream(_Data, _data_Stream);
  if (st <> nil) and not _isNull(_prop_Type(st, @_Data)) then exit;
  _hi_CreateEvent(_Data, @_event_onWrError);
end;

procedure THIDataToFileEx._work_doGet;
var
  st: PStream;
begin
  st := ReadStream(_Data, _data_Stream);
  if st <> nil then
  begin 
    _Data := _prop_Type(st, nil);
    if not _isNull(_Data) then
    begin 
      _hi_CreateEvent_(_Data, @_event_onGet);
      exit;
    end;
  end;
  _hi_CreateEvent(_Data,@_event_onRdError);
end;

procedure THIDataToFileEx._work_doPosition;
var
  st: PStream;
  i: Integer;
begin
  st := ReadStream(_Data, _data_Stream);
  if st <> nil then
  begin
    i := ToInteger(_Data);
    if i < 0 then i := 0; 
    st.Position := i;
  end;
end;


procedure THIDataToFileEx._work_doCharset(var _Data: TData; Index: Word);
begin
  FCharset := ToInteger(_Data);
end;

procedure THIDataToFileEx._var_Data;
var
  st: PStream;
begin
  st := ReadStream(_Data, _data_Stream);
  dtNull(_Data);
  if st <> nil then _Data := _prop_Type(st,nil);
end;

procedure THIDataToFileEx._var_Position;
var
  st: PStream;
begin
  st := ReadStream(_Data,_data_Stream);
  if st <> nil then
    Share.dtInteger(_Data, st.Position)
  else
    dtNull(_Data);
end;

procedure THIDataToFileEx._var_Size;
var
  st: PStream;
begin
  st := ReadStream(_Data, _data_Stream);
  if st <> nil then
    Share.dtInteger(_Data, st.Size)
  else
    dtNull(_Data);
end;

procedure THIDataToFileEx.Reverse;
var
  pb, pe: ^Byte;
  B: Byte;
begin
  pb := p;
  pe := pb;
  Inc(pe, _prop_DataSize-1); 
  while NativeUInt(pb) < NativeUInt(pe) do
  begin
    b := pb^;
    pb^ := pe^;
    pe^ := b;
    Inc(pb);
    Dec(pe);
  end;
end;

function THIDataToFileEx.dtInteger;
var
  i, j: Int64;
begin
  dtNull(Result);
  if (_prop_DataSize >= 9) or (_prop_DataSize < 1) then exit;
  if val = nil then //чтение из Stream
  begin
    i := 0;
    if st.Read(i, _prop_DataSize) <> dw(_prop_DataSize) then exit;
    if _prop_BigEndian then Reverse(@i);
    if _prop_Signed then
    begin
      j := (int64(1) shl (_prop_DataSize*8));
      if ((j shr 1) and i) <> 0 then Dec(i, j);
    end; 
    if (i <= MAXINT) and (i >= -MAXINT-1) then
      Share.dtInteger(Result, i)
    else
      Share.dtReal(Result, i);
  end
  else //запись в Stream
  begin
    if _prop_DataSize < 5 then
      i := ToInteger(val^)
    else
      i := Round(ToReal(val^));
    if _prop_BigEndian then Reverse(@i);
    if st.Write(i, _prop_DataSize) <> dw(_prop_DataSize) then exit;
    Share.dtInteger(Result, _prop_DataSize);
  end;
end;

function THIDataToFileEx.dtReal;
type
  rx = record 
    case Byte of 
      0:(fl: Single); 
      1:(db: Real); 
      2:(ex: Extended); 
  end;
var
  r: rx;
begin
  dtNull(Result);
  if not(_prop_DataSize in [4,8,10]) then exit; 
  if val = nil then //чтение из Stream
  begin
      if st.Read(r, _prop_DataSize) <> dw(_prop_DataSize) then exit;
      if _prop_BigEndian then Reverse(@r);
      case _prop_DataSize of
        4: Share.dtReal(Result, r.fl);
        8: Share.dtReal(Result, r.db);
        else
          Share.dtReal(Result, r.ex);
      end;
  end
  else //запись в Stream
  begin
    case _prop_DataSize of
      4: r.fl := ToReal(val^);
      8: r.db := ToReal(val^);
      else
        r.ex := ToReal(val^);
    end;
    if _prop_BigEndian then Reverse(@r);
    if st.Write(r, _prop_DataSize) <> dw(_prop_DataSize) then exit;
    Share.dtInteger(Result, _prop_DataSize);
  end;
end;

function THIDataToFileEx.dtPString;
var
  S: string;
  Len: Cardinal;
begin
  _prop_Signed := False;
  if val = nil then //чтение из Stream
  begin
    Result := dtInteger(st, nil);
    if _isNull(Result) then exit;
    Len := ToInteger(Result);
    dtNull(Result);
    if Len = 0 then exit;
    S := StreamReadString(st, Len, FCharset);
    if S = '' then exit;
    Share.dtString(Result, S);
  end
  else //запись в Stream
  begin
    S := Share.ToString(val^);
    
    if (FCharset <> DefaultCompilerCP) and (FCharset <> CP_BINARY) then
      S := ConvertCharset(S, DefaultCompilerCP, FCharset);
    
    Len := BinaryLength(S);
    Share.dtInteger(Result, Integer(Len));
    Result := dtInteger(st, @Result);
    if _isNull(Result) then exit;
    if st.Write(S[1], Len) <> dw(Len) then dtNull(Result);
  end;
end;

function THIDataToFileEx.dtStringZ;
var
  S: string;
  OldPos: NativeUInt;
begin
  dtNull(Result);
  if val = nil then
  begin 
    if st.Position < st.Size then
      Share.dtString(Result, StreamReadStringZ(st, FCharset));
  end
  else
  begin 
    S := Share.ToString(val^);
    OldPos := st.Position;
    if StreamWriteStringZ(st, S, FCharset, _prop_OutBOM <> 0) then 
       Share.dtInteger(Result, (st.Position - OldPos));
  end;
end;

function THIDataToFileEx.dtLines;
var
  S: string;
  OldPos: NativeUInt;
begin
  dtNull(Result);
  if val = nil then
  begin 
    if st.Position < st.Size then
       Share.dtString(Result, StreamReadLine(st, FCharset));
  end
  else
  begin 
    S := Share.ToString(val^);
    OldPos := st.Position;
    if StreamWriteLine(st, S, FCharset, _prop_OutBOM <> 0) then 
       Share.dtInteger(Result, (st.Position - OldPos));
  end;
end;

end.
