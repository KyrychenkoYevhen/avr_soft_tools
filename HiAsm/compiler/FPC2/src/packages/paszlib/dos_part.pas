unit dos_part;

// Часть dos.pp, используемая в gzio.pp

interface

uses windows;

{$I filerec.inc}

threadvar
  DosError : integer;

procedure GetFAttr(var f; var attr: word);


implementation

procedure getfattr(var f;var attr : word);
var
   l : longint;
   s : RawByteString;
begin
  doserror:=0;
  s:=ToSingleByteFileSystemEncodedFileName(filerec(f).name);
  l:=GetFileAttributes(pchar(s));
  if l=longint($ffffffff) then
   begin
     doserror:=getlasterror;
     attr:=0;
   end
  else
   attr:=l and $ffff;
end;

end.

