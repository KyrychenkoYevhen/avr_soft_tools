unit hiClipboardHook;

interface

uses Share,Windows,kol,Messages,Debug;

type
  THIClipboardHook = class(TDebug)
    private
      FNextViewerHandle: Integer;
      FEnable: boolean;
      Parent: PControl;
      OldMessage: TOnMessage;

      function onMessage(var Msg: TMsg; var Rslt: LRESULT): Boolean;
      procedure LoadBitmap;
      procedure Init;
    public
      _prop_DataStream: Byte;
      _prop_NextHook: Byte;

      _data_Text: THI_Event;
      _data_LockHook: THI_Event;
      _data_Handle: THI_Event;
      _event_onBitmap: THI_Event;
      _event_onChange: THI_Event;

      constructor Create(Control: PControl);
      procedure _work_doSetText(var _Data: TData; Index: Word);
      procedure _work_doPut(var _Data: TData; Index: Word);
  end;

implementation

constructor THIClipboardHook.Create;
begin
  inherited Create;
  Parent := Control;
  OldMessage := Control.OnMessage;
  Control.OnMessage := OnMessage;
  InitAdd(Init);
end;

procedure THIClipboardHook.Init;
begin
  FNextViewerHandle := SetClipboardViewer(Parent.Handle);
  FEnable := True
end;

procedure THIClipboardHook.LoadBitmap;
var
  BMP: PBitmap;
begin
  BMP := NewBitmap(0,0);
  BMP.PasteFromClipboard;
  _hi_OnEvent(_event_onBitmap, BMP);
  BMP.Free;
end;

function THIClipboardHook.onMessage(var Msg: TMsg; var Rslt: LRESULT): Boolean;
begin
  Result := True;
  case Msg.message of
    WM_DRAWCLIPBOARD:
      if FEnable then begin
        if IsClipboardFormatAvailable(CF_BITMAP) then LoadBitmap
        else
         if IsClipboardFormatAvailable(CF_TEXT) then
         begin
          if _prop_DataStream = 0 then
            _hi_OnEvent(_event_onChange)
          else
            _hi_OnEvent(_event_onChange,{$ifdef UNICODE}Clipboard2WText{$else}Clipboard2Text{$endif});
         end;
         
        if ReadInteger(_data_Empty, _data_LockHook, _prop_NextHook) = 0 then
        begin
          FEnable := false;
          Rslt := SendMessage(FNextViewerHandle, WM_DRAWCLIPBOARD, 0, 0);
          FEnable := True;
        end
        else
          Rslt := 0;
        
        Result := True;
        Exit;
      end;
    WM_DESTROY:
      begin
        FEnable := False;
        ChangeClipboardChain(Parent.Handle, FNextViewerHandle);
      end;
    WM_CHANGECBCHAIN:
      begin
        if msg.wParam = FNextViewerHandle then
        begin
          FNextViewerHandle := msg.lParam;
          Rslt := 0;
        end
        else
          Rslt := SendMessage(FNextViewerHandle, WM_CHANGECBCHAIN, msg.wParam, msg.lParam);
        
        Exit;
      end;
  end;
  Result := _hi_OnMessage(OldMessage, Msg, Rslt);
end;

procedure THIClipboardHook._work_doSetText;
begin
  FEnable := False;
  {$ifdef UNICODE}WText2Clipboard{$else}Text2Clipboard{$endif}(ReadString(_Data,_data_Text,''));
  FEnable := True;
end;

procedure THIClipboardHook._work_doPut;
var
  H: THandle;
begin
  FEnable := False;
  H := ReadInteger(_Data,_data_Handle,0);
  if H <> 0 then
    SetForegroundWindow(H);
  keybd_event(VK_CONTROL,0,0,0);
  keybd_event(86,0,0,0);
  keybd_event(86,0,KEYEVENTF_KEYUP,0);
  keybd_event(VK_CONTROL,0,KEYEVENTF_KEYUP,0);
  FEnable := True;
end;

end.
