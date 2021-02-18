unit hiSIDConvertor;

interface

uses
  Windows, Kol, Share, Debug;

type
  THISIDConvertor = class(TDebug)
    private
    public
      _prop_Mode: Byte;

      _data_Data: THI_Event;
      _event_onConvert: THI_Event;

    procedure _work_doConvert0(var _Data: TData; Index: Word);
    procedure _work_doConvert1(var _Data: TData; Index: Word);
  end;

implementation

uses
  hiFSOwner;

type
  PPChar = ^PChar; 

function ConvertSidToStringSid(SID:PSID; var pStringSID:PChar):LongBool; stdcall;
  external 'advapi32.dll' name {$ifdef UNICODE}'ConvertSidToStringSidW'{$else}'ConvertSidToStringSidA'{$endif};
function ConvertStringSidToSid(StringSid:PChar; var Sid:PSID):LongBool; stdcall;
  external 'advapi32.dll' name {$ifdef UNICODE}'ConvertStringSidToSidW'{$else}'ConvertStringSidToSidA'{$endif};

procedure THISIDConvertor._work_doConvert0;
var
  sid: PSID;
  dt: TData;
  sd: PChar;
begin
  dt := ReadData(_Data,_data_Data,nil);
  if _IsObject(dt, SID_GUID) then
  begin    
    sid := PSID(ToObject(dt));
    sd := nil;
    ConvertSidToStringSid(sid, sd);
    _hi_onEvent(_event_onConvert, string(sd));
    LocalFree(HLOCAL(sd));
  end;
end;

procedure THISIDConvertor._work_doConvert1;
var
  s: string;
  sid: PSID;
begin
  s := ReadString(_Data, _data_Data, '');
  ConvertStringSidToSid(PChar(s), sid);
  dtObject(_Data, SID_GUID, sid); 
  _hi_onEvent(_event_onConvert, _Data);
  LocalFree(HLOCAL(sid));    
end;

end.
