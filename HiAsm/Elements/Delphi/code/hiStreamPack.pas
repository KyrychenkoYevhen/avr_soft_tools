unit hiStreamPack;

interface

uses
  Kol, Share, Debug;

type
  THIStreamPack = class(TDebug)
    private
      st: PStream;
      procedure SetDataCount(const Text: string);
    public
      _data_DataCount:array of THI_Event;
      onPack: THI_Event;

      property _prop_DataCount: string write SetDataCount;
      
      constructor Create;
      destructor Destroy; override;
      
      procedure doPack(var _Data: TData; Index: Word);
      procedure ResultStream(var _Data: TData; Index: Word);
  end;

implementation

constructor THIStreamPack.Create;
begin
  inherited;
  st := NewMemoryStream;
end;

destructor THIStreamPack.Destroy;
begin
  st.Free;
  inherited;
end;

procedure THIStreamPack.SetDataCount(const Text: string);
var
  lst: PKOLStrList;
begin
  lst := NewKOLStrList;
  lst.Text := Text;
  SetLength(_data_DataCount, lst.Count);
  lst.Free;
end;

procedure THIStreamPack.doPack(var _Data: TData; Index: Word);
var
  i, id: Integer;
  sd: string;
  rd: Real;
  bd: PBitmap;
  dt: TData;
  s1: PStream;
begin
  st.Size := 0;
  for i := 0 to High(_data_DataCount) do
  begin
    dt := ReadData(_data, _data_DataCount[i]);
    st.Write(dt.data_type, SizeOf(dt.data_type));
    case dt.data_type of
      data_int: 
        begin 
          id := ToInteger(dt);
          st.Write(id, SizeOf(id));
        end;
      data_real:
        begin
          rd := ToReal(dt);
          st.Write(rd, SizeOf(rd));             
        end;
      data_str:
        begin
          sd := Share.ToString(dt);
          id := Length(sd) * SizeOf(Char);
          st.Write(id, SizeOf(id));
          if id > 0 then
            st.Write(sd[1], id);
        end;
      data_bitmap:
        begin
          bd := ToBitmap(dt);
          if bd <> nil then
            bd.SaveToStream(st);
        end;
      data_stream:
        begin
          s1 := ToStream(dt);
          s1.Position := 0;
          id := s1.Size;
          st.Write(id, SizeOf(id));
          Stream2Stream(st, s1, s1.Size);
        end;
    end;  
  end;
  //st.Position := 0;
  _hi_onEvent(onPack, st);  
end;

procedure THIStreamPack.ResultStream(var _Data: TData; Index: Word);
begin
  dtStream(_Data, st);
end;

end.
