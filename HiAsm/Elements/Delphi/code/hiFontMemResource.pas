unit hiFontMemResource;

interface

uses
  Windows, KOL, Messages, Share, Debug;

type
  THiFontMemResource = class(TDebug)
    private
      MemFontHandle: HFONT;
    public
      _prop_FontStream: PStream;

      _data_FontStream: THI_Event;
      _event_onAddFontMemResource: THI_Event;

      destructor Destroy; override;
      procedure _work_doAddFontMemResource(var _Data: TData; Index: Word);
      procedure _work_doRemoveFontMemResource(var _Data: TData; Index: Word);
  end;

  {$ifdef FPC_NEW}
  function AddFontMemResourceEx(p1: Pointer; p2: DWORD; p3: PDesignVector; p4: LPDWORD): THandle; stdcall;
    external 'gdi32.dll' name 'AddFontMemResourceEx';
  function RemoveFontMemResourceEx(p1: THandle): BOOL; stdcall; external 'gdi32.dll' name 'RemoveFontMemResourceEx';
  {$endif}


implementation

destructor THiFontMemResource.Destroy;
begin
  if MemFontHandle <> 0 then RemoveFontMemResourceEx(MemFontHandle);
  inherited;
end;

procedure THiFontMemResource._work_doRemoveFontMemResource;
begin
  if MemFontHandle <> 0 then RemoveFontMemResourceEx(MemFontHandle);
end;

procedure THiFontMemResource._work_doAddFontMemResource;
var
  St: PStream;
  FontCount: DWord;
begin
  St := ReadStream(_data, _data_FontStream, _prop_FontStream);
  if St = nil then exit;
  if MemFontHandle <> 0 then RemoveFontMemResourceEx(MemFontHandle);
  MemFontHandle := AddFontMemResourceEx(St.Memory, St.size, nil, @FontCount);
  _hi_onEvent(_event_onAddFontMemResource, FontCount);
end;

end.