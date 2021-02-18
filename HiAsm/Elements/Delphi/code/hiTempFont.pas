unit HiTempFont;

interface

uses Windows,Messages,kol,Share,Debug;

type
 THiTempFont = class(TDebug)
   private
     fFontFile:string;
     fFontName:string;
     FInSendMessage:boolean;
     procedure InstallfromStream(St:PStream);
     procedure RemoveFont(FileName:string);
   public
    _prop_FileName:string;
    _prop_Prefix:string;
    _prop_FontStream:PStream;
    
    _data_FontStream: THI_Event;
    _data_FileName: THI_Event;
    _data_TempFName: THI_Event;
    _event_onInstall: THI_Event;

    property _prop_InSendMessage: boolean write FInSendMessage;
    constructor Create;
    destructor Destroy; override;
    procedure _work_doInstall(var _Data:TData; Index:word);
    procedure _work_doInstallfromStream(var _Data:TData; Index:word);
    procedure _work_doUnInstall(var _Data:TData; Index:word);
    procedure _work_doUnInstallByFileName(var _Data:TData; Index:word);
    procedure _work_doInSendMessage(var _Data:TData; Index:word);    
    procedure _var_FontName(var _Data:TData; Index:word);
    procedure _var_TempFileName(var _Data:TData; Index:word);
 end;



implementation


function GetFontResourceInfoW (FontPath: PWideChar; var BufSize: DWORD;
                              FontName: PWideChar; dwFlags: DWORD): DWORD; stdcall; external 'gdi32.dll';





function GetFontName(FontFileA: string): string;
var
  FontFileW: WideString;
  FontNameW: WideString;
  FontNameSize: DWORD;
begin
  Result := '';
  FontFileW := FontFileA;
  FontNameSize := 1024;
  SetLength(FontNameW, FontNameSize);
  GetFontResourceInfoW(Pointer(FontFileW), FontNameSize, Pointer(FontNameW), 1);
  SetLength(FontNameW, FontNameSize);
  Result := FontNameW;
end;

constructor THiTempFont.Create;
begin
  inherited;
end;

destructor THiTempFont.Destroy;
begin
   RemoveFont(fFontFile);
   inherited;
end;

procedure THiTempFont.RemoveFont;
begin
   if (FileName <> '') and FileExists(FileName) then begin
      RemoveFontResource(PChar(FileName));
      if FInSendMessage then SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
      DeleteFiles(PChar(FileName));
   end;
end;

procedure THiTempFont._work_doUnInstall;
begin
   RemoveFont(fFontFile);
   fFontFile := '';
   fFontName := '';
end;

procedure THiTempFont._work_doUnInstallByFileName;
var   s:string;
begin
   s := ReadString(_Data,_data_TempFName);
   if s = fFontFile then begin
      fFontFile := '';
      fFontName := '';
   end;      
   RemoveFont(s);
end;

procedure THiTempFont.InstallfromStream;
var   FontStream: PStream;
      sfnt:integer;
begin
   if (St = nil) or (St.Size = 0) or (WinVer < wvNT) then exit;
   RemoveFont(fFontFile);
   fFontFile := '';
   fFontName := '';
   St.Position := 0;
   fFontFile := CreateTempFile( GetTempDir, _prop_Prefix);
   FontStream := NewWriteFileStream(fFontFile);
   Stream2Stream(FontStream, St, St.Size);
   free_and_nil(FontStream);
   if not FileExists(fFontFile) then exit;  
   sfnt := AddFontResource(PChar(fFontFile));
   if sfnt <> 0 then begin 
      fFontName := GetFontName(fFontFile);
      if FInSendMessage then SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
   end;   
   _hi_onEvent(_event_onInstall, sfnt);
end;

procedure THiTempFont._work_doInstall;
var   len: dword;
      fn: pchar;
      s, s1: string;
      FontStream: PStream;
begin
   s1 := ReadString(_Data, _data_FileName, _prop_FileName); 
   len := GetFullPathName(@s1[1],0,nil,fn);
   setlength(s,len-1);
   GetFullPathName(@s1[1], len, @s[1], fn);
   FontStream := NewReadFileStream(s);
   InstallfromStream(FontStream);
   free_and_nil(FontStream);
end;

procedure THiTempFont._work_doInstallfromStream;
var   FontStream: PStream;
begin
   FontStream := ReadStream(_data, _data_FontStream, _prop_FontStream);
   InstallfromStream(FontStream);
end;

procedure THiTempFont._var_FontName;
begin
   dtString(_Data, fFontName);
end;

procedure THiTempFont._var_TempFileName;
begin
   dtString(_Data, fFontFile);
end;

procedure THiTempFont._work_doInSendMessage;
begin
   FInSendMessage := ReadBool(_Data);
end;

end.