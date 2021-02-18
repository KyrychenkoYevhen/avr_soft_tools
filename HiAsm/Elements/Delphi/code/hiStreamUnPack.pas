unit hiStreamUnPack;

interface

uses
  Kol, Share, Debug;

type
  THIStreamUnPack = class(TDebug)
    private
      FObjs: PList;
      FCount: Integer;
      Datas: array of TData;
      
      procedure FreeList;
      procedure SetDataCount(const Text: string); 
    public
      Stream: THI_Event;
      onUnPack: THI_Event;

      property _prop_DataCount: string write SetDataCount;
      
      constructor Create;
      destructor Destroy; override;
      
      procedure doUnPack(var _Data: TData; Index: Word);
      procedure _var_DataCount(var _Data: TData; Index: Word);
  end;

implementation

constructor THIStreamUnPack.Create;
begin
  inherited;
  FObjs := NewList;
end;

destructor THIStreamUnPack.Destroy;
begin
  FreeList;
  FObjs.Free;
  inherited;
end;

procedure THIStreamUnPack.SetDataCount(const Text: string);
var
  lst: PKOLStrList;
begin
  lst := NewKOLStrList;
  lst.Text := Text;
  FCount := lst.Count;
  SetLength(Datas, FCount);
  lst.Free;
end;

procedure THIStreamUnPack.FreeList;
var
  i: Integer;
begin
  for i := 0 to FObjs.Count-1 do
    PObj(FObjs.Items[i]).Free; 
  FObjs.Clear;
end;

procedure THIStreamUnPack.doUnPack(var _Data: TData; Index: Word);
var
  st:PStream;
  i, id: Integer;
  sd: string;
  rd: Real;
  bd: PBitmap;
  b: Byte;
  s1: PStream;
begin
  FreeList;
  st := ReadStream(_Data, Stream);
  if st = nil then Exit;
  
  for i := 0 to FCount-1 do
  begin
    st.Read(b, SizeOf(b));
    case b of
      data_int:
        begin
          st.Read(id, SizeOf(id)); 
          dtInteger(Datas[i], id);
        end;
      data_str:
        begin
          id := 0;
          st.Read(id, SizeOf(id));
          id := id div SizeOf(Char);
          SetLength(sd, id);
          st.Read(sd[1], id * SizeOf(Char));
          dtString(Datas[i], sd);
        end;
      data_real:
        begin
          st.Read(rd, SizeOf(rd)); 
          dtReal(Datas[i], rd);
        end;
      data_bitmap: 
        begin
          bd := NewBitmap(0,0);
          bd.LoadFromStream(st);
          FObjs.Add(bd);
          dtBitmap(Datas[i], bd);
        end;
      data_stream: 
        begin
          s1 := NewMemoryStream;
          st.Read(id, SizeOf(id));
          Stream2Stream(s1, st, id);
          FObjs.Add(s1);
          s1.Position := 0;
          dtStream(Datas[i], s1);
        end;  
    end;
  end; 
  _hi_onEvent(onUnPack, st);
end;

procedure THIStreamUnPack._var_DataCount(var _Data: TData; Index: Word);
begin
  _Data := Datas[Index];
end;

end.
