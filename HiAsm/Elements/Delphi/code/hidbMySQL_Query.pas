unit hidbMySQL_Query;

interface

uses
  KOL, Share, Debug, MySQL;

type
  THIdbMySQL_Query = class(TDebug)
    private
      FMatrix: TMatrix;
      FFieldsArr: PArray;
      MS: TMySQL;
      OldY: Integer;
      BlobStream: PStream;

      procedure MSet(x, y: Integer; var Val: TData);
      function MGet(x, y: Integer): TData;
      function MRows: Integer;
      function MCols: Integer;

      function _Get(var Item: TData; var Val: TData): Boolean;
      function _Count: Integer;
    public
      _prop_BlobIndex: Integer;
      
      _data_dbHandle: THI_Event;
      _data_QueryText: THI_Event;
      _data_BlobIndex: THI_Event;
      
      _event_onError: THI_Event;
      _event_onResult: THI_Event;

      constructor Create;
      destructor Destroy; override;
      
      procedure _work_doQuery(var _Data: TData; Index: Word);
      procedure _work_doReadRow(var _Data: TData; Index: Word);
      
      procedure _var_Rows(var _Data: TData; Index: Word);
      procedure _var_Fields(var _Data: TData; Index: Word);
      procedure _var_RCount(var _Data: TData; Index: Word);
      procedure _var_FCount(var _Data: TData; Index: Word);
      procedure _var_Blob(var _Data: TData; Index: Word);
  end;

implementation

uses
  hidbMySQL;

constructor THIdbMySQL_Query.Create;
begin
  inherited;
  FMatrix._Set := MSet;
  FMatrix._Get := MGet;
  FMatrix._Rows := MRows;
  FMatrix._Cols := MCols;
  BlobStream := NewMemoryStream;
end;

destructor THIdbMySQL_Query.Destroy;
begin
  if FFieldsArr <> nil then Dispose(FFieldsArr);
  BlobStream.Free;
  inherited; 
end;

function THIdbMySQL_Query.MRows: Integer;
begin
  if MS <> nil then
    Result := MS.RecordCount
  else
    Result := 0;
end;

function THIdbMySQL_Query.MCols: Integer;
begin
  if MS <> nil then
    Result := MS.FieldCount
  else
    Result := 0;
end;

procedure THIdbMySQL_Query.MSet(x, y: Integer; var Val: TData);
begin

end;

function THIdbMySQL_Query.MGet(x, y: Integer): TData;
begin
  dtString(Result, '');
  if MS = nil then exit;

  if (x >= 0) and (x < MS.FieldCount) and (y >= 0) and (y < MS.RecordCount) then
  begin
    if y <> OldY then
    begin
      if y < OldY then
      begin
        MS.FindFirst;
        OldY := 0;
      end;
      {repeat
        MS.FindNext;
        Inc(OldY);
      until y = OldY;}
      // ------------ Исправил 3042 09.10.2017 ------------
      while OldY < y do 
      begin
        MS.FindNext;
        Inc(OldY);
      end;
      //
    end;
    dtString(Result, MS.Values[x]);
  end;
end;

procedure THIdbMySQL_Query._work_doQuery;
var
  Text: string;
begin
  MS := ReadObject(_Data, _data_dbHandle, MySQL_GUID);
  if MS <> nil then
  begin
    Text := ReadString(_data, _data_QueryText, '');
    MS.Query(Text);
    MS.FindFirst;
    OldY := 0;
    _hi_OnEvent(_event_onResult);
  end
  else
    _hi_OnEvent(_event_onError, 0);
end;

procedure THIdbMySQL_Query._work_doReadRow;
begin

end;

procedure THIdbMySQL_Query._var_Rows;
begin
  dtMatrix(_Data, @FMatrix);
end;


function THIdbMySQL_Query._Get(var Item: TData; var Val: TData): Boolean;
var 
  Idx: Integer;
begin
  Idx := ToIntIndex(Item);
  if (MS <> nil) and (Idx >= 0) and (Idx < MS.FieldCount) then
    dtString(Val, MS.Fields[Idx])
  else
    dtNull(Val);
  Result := _IsStr(Val);
end;

function THIdbMySQL_Query._Count: Integer;
begin
  if MS <> nil then
    Result := MS.FieldCount
  else
    Result := 0;
end;

procedure THIdbMySQL_Query._var_Fields;
begin
  if FFieldsArr = nil then
    FFieldsArr := CreateArray(nil, _Get, _Count, nil);
  dtArray(_Data, FFieldsArr);
end;

procedure THIdbMySQL_Query._var_RCount;
begin
  if MS <> nil then
    dtInteger(_Data, MS.RecordCount)
  else
    dtNull(_Data);
end;

procedure THIdbMySQL_Query._var_FCount;
begin
  if MS <> nil then
    dtInteger(_Data, MS.FieldCount)
  else
    dtNull(_Data);
end;

procedure THIdbMySQL_Query._var_Blob;
var 
  P: Pointer;
begin
  if MS <> nil then
  begin
    P := MS.Blob[ReadInteger(_Data, _data_BlobIndex, _prop_BlobIndex)];
    if P <> nil then
	  begin 
	    BlobStream.Size := 0;
      BlobStream.Write(P^, MS.BlobSize);
      BlobStream.Position := 0;
      dtStream(_Data, BlobStream);
	  end
	  else
      dtNull(_Data);
  end
  else
    dtNull(_Data);
end;


end.
