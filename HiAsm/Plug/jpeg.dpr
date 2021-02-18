library jpeg;

uses
  kol,
  JpegObj;

procedure LoadKOLBmp(var p:PJpeg; St:PStream; var w,h:word); export;
begin
   st.Position := 0;
   p := NewJpeg;
   p.LoadFromStream(st);
   p.DIBNeeded;
   W := p.Width;
   H := p.Height;
end;

procedure LoadBuf(var p:PJpeg; Buf:pointer; Size:cardinal; var w,h:word); export;
var st:PStream;
begin
   st := NewMemoryStream;
   st.Write(buf^,Size);
   LoadKOLBmp(p,st,w,h);
   st.Free;
end;

procedure Load(var p:PJpeg; FileName:PChar; var w,h:word); export;
begin
   p := NewJpeg;
   p.LoadFromFile(FileName);
   p.DIBNeeded;
   W := p.Width;
   H := P.Height;
end;

procedure Flush(p:PJpeg; DC:cardinal); export;
begin
   p.Draw(DC,0,0);
   p.Free;
end;

exports
    Load,LoadBuf,Flush,LoadKOLBmp;

begin
end.
 