unit hiTranslator;

interface

uses Windows,Kol,Share;

type
  THITranslator = object
   private
    function readState:string;
    procedure LoadString(lst:PKOLStrList);
    procedure LoadListFromFile;
   public
    _prop_Lang:string;
    _prop_LangWords:PKOLStrListEx;
    _prop_Place:byte;
    _prop_Key:string;
    _prop_Section:string;
    _prop_Value:string;
    _prop_LangsDir:string;
    
    procedure Init;
  end;

implementation

function StringToKey(const value:string):HKEY;
begin
   if value = 'HKEY_CLASSES_ROOT' then
     Result := HKEY_CLASSES_ROOT
   else if value = 'HKEY_CURRENT_USER' then
     Result := HKEY_CURRENT_USER
   else if value = 'HKEY_LOCAL_MACHINE' then
     Result := HKEY_LOCAL_MACHINE
   else if value = 'HKEY_USERS' then
     Result := HKEY_USERS
   else if value = 'HKEY_CURRENT_CONFIG' then
     Result := HKEY_CURRENT_CONFIG
end;

function THITranslator.readState:string;
var
  key:HKEY;
  ini:PIniFile;
begin
   if _prop_Place = 0 then
    begin
      key := RegKeyOpenRead(StringToKey(_prop_Key), _prop_Section);
      Result := RegKeyGetStr(key, _prop_Value);
      RegKeyClose(key);
    end
   else
    begin
      ini := OpenIniFile(GetStartDir + _prop_Key);
      ini.section := _prop_Section;
      Result := Ini.ValueString(_prop_Value, '');
      ini.Free;
    end;
end;

procedure THITranslator.LoadString(lst:PKOLStrList);
var i:integer;
    s:string;
    Sources:PKOLStrList;
    Dests:PKOLStrList;
begin
   Sources := NewKOLStrList;
   Dests := NewKOLStrList;
   for i := 0 to lst.Count-1 do
     begin
       s := lst.items[i];
       Sources.Add(GetTok(s, '|')); 
       Dests.Add(s);
     end;
   Translator.SetTranslate(Sources, Dests);
end;

procedure THITranslator.LoadListFromFile;
var Lst:PDirList;
    flst:PKOLStrList;
    i:integer;
    lng:string;
begin
   lng := readState;
   Lst := NewDirList(GetStartDir + _prop_LangsDir, '*.lng', FILE_ATTRIBUTE_NORMAL);
   flst := NewKOLStrList;
   for i := 0 to Lst.Count-1 do
     if ExtractFileNameWOExt(lst.items[i].cFileName) = lng then
      begin
        flst.LoadFromFile(GetStartDir + _prop_LangsDir + '\' + lst.items[i].cFileName);
        LoadString(flst);
        break; 
      end; 
   Lst.free;
   flst.Free;
end;

procedure THITranslator.Init;
var
  Sources:PKOLStrList;
  Dests:PKOLStrList;
  i:integer;
begin
  if _prop_Lang = '' then
     LoadListFromFile
  else if readState = _prop_Lang then
   begin
      Sources := NewKOLStrList;
      Dests := NewKOLStrList;
      for i := 0 to _prop_LangWords.count-1 do
       begin
         Sources.Add(_prop_LangWords.Items[i]);
         Dests.Add(PChar(pointer(_prop_LangWords.Objects[i])));
       end;
      Translator.SetTranslate(Sources, Dests);
   end;
end;

end.
