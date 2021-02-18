unit hiBASS_ChannelEnumTags;

interface

uses
  Kol, Share, Debug, BASS;

type
  THIBASS_ChannelEnumTags = class(TDebug)
    private
    public
      _prop_Type: Byte;
      _prop_Charset: Byte;
      _prop_Channel: ^Cardinal;

      _event_onEndEnum: THI_Event;
      _event_onEnumTags: THI_Event;

    procedure _work_doEnumTags(var _Data: TData; Index: Word);
    procedure _work_doCharset(var _Data: TData; Index: Word);
  end;

implementation


procedure THIBASS_ChannelEnumTags._work_doEnumTags;
var
  T: PAnsiChar;
  AStr: AnsiString;
  S: string;
begin
  T := PAnsiChar(BASS_ChannelGetTags(_prop_Channel^, _prop_Type));
  if T <> nil then
  begin
    while T^ <> #0 do
    begin
      AStr := T;
      if _prop_Charset = 1 then S := UTF8ToString(AStr) else S := AStr;
      _hi_onEvent(_event_onEnumTags, S);
      Inc(T, Length(AStr)+1);
    end; 
  end;
  _hi_CreateEvent(_Data, @_event_onEndEnum);   
end;

// Экономится лишнее перемещение по AStr := T;
{procedure THIBASS_ChannelEnumTags._work_doEnumTags;
var
  T: PAnsiChar;
  L: Cardinal;
  S: string;
begin
  T := PAnsiChar(BASS_ChannelGetTags(_prop_Channel^, _prop_Type));
  if T <> nil then
  begin
    while True do
    begin
      L := KOL.StrLen(T);
      if L = 0 then break;
      
      if _prop_Charset = 1 then S := BufToString(T, L, CP_UTF8) else S := BufToString(T, L, CP_ACP);
      _hi_onEvent(_event_onEnumTags, S);
      Inc(T, L+1);
    end; 
  end;
  _hi_CreateEvent(_Data, @_event_onEndEnum);   
end;}

procedure THIBASS_ChannelEnumTags._work_doCharset;
begin
  _prop_Charset := ToInteger(_Data);
  _prop_Charset := _prop_Charset and 1;
end;

end.
