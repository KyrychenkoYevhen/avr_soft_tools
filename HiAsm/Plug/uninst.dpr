program uninst;

{$R uninst.res}

uses kol,Windows;

var fn:string;

procedure Del(const FilePath:string);
var
  DList:PDirList;
  i:integer;
begin
   DList := NewDirList(FilePath,'*.*',0);
   for i := 0 to DList.Count-1 do
    if DList.IsDirectory[i] then
      begin
        Del(FilePath + DList.Names[i] + '\');
        RmDir(FilePath + DList.Names[i]);
      end
    else DeleteFile(PChar(FilePath + DList.Names[i]));
      //MessageBox(0,PChar(DList.Names[i]),'',MB_OK);
end;

procedure ClearReg;
type TProc = procedure;
var id:cardinal;
begin
  if FileExists(GetStartDir + 'PLUG\SHAInfo.dll') then
   begin
      id := LoadLibrary(PChar(GetStartDir + 'PLUG\SHAInfo.dll'));
      TProc(GetProcAddress(id,'DllUnregisterServer'));
      FreeLibrary(id);
   end;
end;

const Names:array[1..3] of string = ('haf','sha','bsp');
var i:byte;

begin
  SetLength(fn,MAX_PATH+1);
  SetLength(fn,WIndows.GetModuleFileName(HInstance,PChar(@fn[1]),MAX_PATH));

  //MessageBox(0,PChar(),'',MB_OK);
  if ParamStr(1) = '/u' then
   if MessageBox(0,'Uninstall HiAsm','Are you sure?',MB_YESNO) = 6 then
     begin
       ClearReg;
       Del(ExtractFilePath(fn));
       RegDeleteKey(HKEY_LOCAL_MACHINE,'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\HiAsm');
       for i := 1 to 3 do
        begin
         RegDeleteKey(HKEY_CLASSES_ROOT,PChar('.' + Names[i]));
         RegDeleteKey(HKEY_CLASSES_ROOT,PChar(Names[i] + 'file'));
        end;
       RegDeleteKey(HKEY_CURRENT_USER,'Software\HiAsm');
     end;
end.
