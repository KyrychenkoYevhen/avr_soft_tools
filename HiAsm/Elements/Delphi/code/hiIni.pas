unit hiINI;

interface

uses Windows,Kol,Share,Debug;

type
   THIini = class(TDebug)
     private
      Ini: PIniFile;
      function Open(var _Data:TData;ifm: TIniFileMode): boolean;
     public
      _prop_FileName:string;
      _prop_Section:string;
      _prop_Key:string;
      _prop_Type:byte;

      _data_FileName:THI_Event;
      _data_Section:THI_Event;
      _data_Key:THI_Event;
      _data_Value:THI_Event;

     _event_onResult:THI_Event;
     _event_onSectionNames:THI_Event;
     _event_onSectionData:THI_Event;

     procedure _work_doRead(var _Data:TData; Index:word);
     procedure _work_doWrite(var _Data:TData; Index:word);
     procedure _work_doSectionNames(var _Data:TData; Index:word);
     procedure _work_doSectionData(var _Data:TData; Index:word);
     procedure _work_doDeleteKey(var _Data:TData; Index:word);
     procedure _work_doEraseSection(var _Data:TData; Index:word);
     procedure _work_doClearAll(var _Data:TData; Index:word);
   end;

implementation

function THIini.Open(var _Data:TData;ifm: TIniFileMode): boolean;
begin
  Ini := OpenIniFile(ReadFileName(ReadString(_Data,_data_FileName,_prop_FileName)));
  Ini.Section := ReadString(_Data,_data_Section,_prop_Section);
  Ini.Mode := ifm;
  Result := Ini.Section <> '';
end;

procedure THIini._work_doRead;
var
  key: string;
begin
  if Open(_Data,ifmRead) then
  begin
    key := ReadString(_Data,_data_Key,_prop_Key);
    if key <> '' then
    begin
      if _prop_Type = 0 then
        _hi_CreateEvent(_Data, @_event_onResult, Ini.ValueInteger(key,0))
      else
        _hi_CreateEvent(_Data, @_event_onResult, Ini.ValueString(key,''));
    end;
  end;
  Ini.Free;
end;

procedure THIini._work_doWrite;
var
  key: string;
begin
  if Open(_Data,ifmWrite) then
  begin
    key := ReadString(_Data,_data_Key,_prop_Key);
    if key <> '' then
    begin
      if _prop_Type = 0 then
        Ini.ValueInteger(key, ReadInteger(_Data,_data_Value,0))
      else
        Ini.ValueString(key, ReadString(_Data,_data_Value,''));
      Ini.ClearAll;  // ReCache
    end;
  end;
  Ini.Free;
end;

procedure THIini._work_doSectionNames;
var
  StrList: PKOLStrList;
  I: integer;
begin
  Open(_Data,ifmRead);
  StrList := NewKOLStrList;
  Ini.GetSectionNames(strList);
  Ini.Free;  
  for i := 0 to strList.Count-1 do
    _hi_OnEvent(_event_onSectionNames, strList.Items[i]);
  strList.free;
end;

procedure THIini._work_doSectionData;
var
  StrList: PKOLStrList;
  I: integer;
begin
  if Open(_Data,ifmRead) then
  begin
    StrList := NewKOLStrList;
    Ini.SectionData(strList);
    for i := 0 to strList.Count-1 do
      _hi_OnEvent(_event_onSectionData,strList.Items[i]);
    strList.free;
  end;  
  Ini.Free;
end;

procedure THIini._work_doDeleteKey;
var
  key: string;
begin
  if Open(_Data,ifmWrite) then
  begin
    key := ReadString(_Data,_data_Key,_prop_Key);
    if key <> '' then
    begin
      Ini.ClearKey(key);
      Ini.ClearAll; // ReCache
    end;  
  end;
  Ini.Free;
end;

procedure THIini._work_doEraseSection;
begin
  if Open(_Data,ifmWrite) then
  begin
    Ini.ClearSection;
    Ini.ClearAll; // ReCache
  end;  
  Ini.Free;
end;

//******************************************************************************
// Edit by nesco 26.10.2015
//******************************************************************************
//
procedure THIini._work_doClearAll;
var
  fn: string;
  iniFile: File;
begin
  fn := ReadString(_Data,_data_FileName,_prop_FileName);
  if fn = '' then exit; 
  AssignFile(iniFile, fn);
  ReWrite(iniFile);
  CloseFile(iniFile);
  Ini := OpenIniFile(fn);
  Ini.Mode := ifmWrite;
  Ini.ClearAll;  // ReCache
  Ini.Free;
end;

end.