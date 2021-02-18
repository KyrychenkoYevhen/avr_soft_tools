unit hiMainForm;

interface

{$I share.inc}

uses Windows,Kol,Share,Win,Messages, hiTransparentManager{,KOLMHToolTip};

type
  THIPosition = procedure of object;
 
 THIMainForm = class(THIWin)
   private
     IsMain, Showed: Boolean;
     hRegion: HRGN;
     CurForm:PControl;
     sTransparentManager: ITransparentManager;

     procedure SetCaption(const Value:string);
     procedure SetBorderStyle(Value:byte);
     procedure SetWindowsState(Value:byte);
     procedure SetTaskBar(Value:byte);
     procedure SetIcon(value:HICON);
     procedure SetPicture(Value:HBITMAP);
     procedure SetAlphaBlendValue(Value:byte);

     procedure Load;

     function _OnClose( Sender: PObj; Accept: Boolean ):boolean;
     procedure _OnQueryEndSession(Sender: PObj; var Accept: Boolean);     
     procedure _OnPaint( Sender: PControl; DC: HDC );
     procedure SetCustomTransparent(Value: ITransparentManager);
     // ���������� � �������������� ��������� � �������� ����� � ini/������
     procedure LoadPosition;
     procedure SavePosition;
     procedure SaveLoadFromReg(IsSave: Boolean);
     procedure SaveLoadFromIni(IsSave: Boolean);
   protected  
     procedure _onMouseDown(Sender: PControl; var Mouse: TMouseEventData); override;
     function  _onMessage( var Msg: TMsg; var Rslt: LRESULT ): Boolean; override;
     procedure _onShow(Obj:PObj); override;
   public

     BitMap: PBitMap;

     _prop_FormFastening:IControlManager;

     _prop_ShiftLeft:integer;
     _prop_ShiftTop:integer;

     _prop_DragForm:boolean;
     _prop_AlphaBlendValue:byte;
     _prop_WindowsState:byte;
     //_prop_SavePosition:procedure(State:boolean) of object;
     _prop_SavePosName:string;
     _prop_ShowIcon:boolean;
     _prop_ClientSize:boolean;
     _prop_Position: THIPosition;
     _prop_TransparentColor:TColor;
     _prop_OffsetShift:boolean;     

     _data_Close:THI_Event;
     _data_QueryEndSession:THI_Event;
     _event_onQueryEndSession:THI_Event;     
     _event_onClick:THI_Event;
     _event_onActivate:THI_Event;
     _event_onDeactivate:THI_Event;
     _event_onCreate:THI_Event;
     _event_onClose:THI_Event;

     constructor Create(Parent:PControl);
     destructor Destroy; override;
     procedure Init; override;
     procedure Start;

     procedure poNone;
     procedure poScreenCenter;
     procedure poOwnerForm;
     procedure poOwnerCenter;
     procedure poMainCenter;
     
     procedure _work_doCaption(var Data:TData; Index:word);
     procedure _work_doRestore(var Data:TData; Index:word);
     procedure _work_doMinimize(var Data:TData; Index:word);
     procedure _work_doAlphaBlendValue(var Data:TData; Index:word);
     procedure _work_doClose(var Data:TData; Index:word);
     procedure _work_doVisible(var Data:TData; Index:word);
     procedure _work_doPicture(var Data:TData; Index:word);
     procedure _work_doFlashWindow(var _Data:TData; Index:word);
     procedure _work_doIcon(var _Data:TData; Index:word);
     procedure _work_doShiftLeft(var _Data:TData; Index:word);
     procedure _work_doShiftTop(var _Data:TData; Index:word);
     procedure _work_doShadow(var _Data:TData; Index:word);
     procedure _work_doIconInTaskBar(var _Data:TData; Index:word);

     procedure _work_doBorderStyle(var _Data:TData; Index:word);
     procedure _work_doShowModal(var _Data:TData; Index:word);
     procedure _work_doPlaceInTaskBar(var _Data:TData; Index:word);
     procedure _var_SizeHeader(var Data:TData; Index:word);
     procedure _var_SizeBorder(var Data:TData; Index:word);

     property _prop_Caption:string write SetCaption;
     property _prop_Icon:HICON write SetIcon;
     property _prop_TaskBar:byte write SetTaskBar;
     property _prop_Picture:HBITMAP write SetPicture;
     property _prop_BorderStyle:byte write SetBorderStyle;
     property _prop_TransparentManager:ITransparentManager write SetCustomTransparent;
 end;

function CreateCoolControl(Handle:cardinal; BitMap:PBitMap; tr:TColor = clWhite): HRGN;

implementation

uses hiRGN_OutlinePicture;

var
  FormList: PKOLStrListEx;
  WM_INNERMESSAGE: DWord;

function SetLayeredWindowAttributes( hwnd: Integer; crKey: TColor; bAlpha: Byte; dwFlags: DWORD ): Boolean;
                                     stdcall; external 'User32.dll' name 'SetLayeredWindowAttributes';

function UpdateLayeredWindow( hwnd: HWND; hdcDst: HDC; pptDst: PPoint; psize: PSize;
                              hdcSrc: HDC; pptSrc: PPoint; crKey: TColor;
                              blend: PBlendFunction; dwFlags: Dword): Boolean;
                              stdcall; external 'User32.dll' name 'UpdateLayeredWindow';
                              
procedure THIMainForm.SetCustomTransparent;
begin
  sTransparentManager := Value;
  if not (Assigned(Control) and (sTransparentManager <> nil)) then exit;
  sTransparentManager.settransparent(Control);
  sTransparentManager.setaeromode(Control);  
end;


procedure THIMainForm._OnQueryEndSession;
begin
  _hi_OnEvent(_event_onQueryEndSession);
  Accept := (ToIntegerEvent(_data_QueryEndSession) = 0);
end;

constructor THIMainForm.Create;
begin
   {$ifdef SUPER_PARENT}if Parent<>nil then Parent := Parent.ParentForm;{$endif}
   inherited Create(Parent);
   if not Assigned(Applet) then
    begin
     Applet := NewApplet('');
     IsMain := true;
     Applet.OnQueryEndSession := _OnQueryEndSession;
    end
   else IsMain := false;
   if FParent = nil then Control := NewForm(Applet,'Form')
   else Control := NewForm(FParent,'Form');
   with Control{$ifndef F_P}^{$endif} do
    begin
       Visible:=false;
       onShow := _onShow;
       Border := 0;
    end;
   InitAdd(Load);
   BitMap := NewBitmap(0,0);
end;

destructor THIMainForm.Destroy;
begin
  DeleteObject(hRegion);
  Bitmap.Free;
  if FormList.IndexOfObj(Pointer(Control.Handle)) <> -1 then
    FormList.Delete(FormList.IndexOfObj(Pointer(Control.Handle)));
  inherited;
end;

procedure THIMainForm._work_doFlashWindow;
begin
  if isMain then
    FlashWindow(Applet.Handle,true)
  else
    FlashWindow(Control.Handle,true);
end;

procedure THIMainForm._work_doIcon;
begin
   if _IsIcon(_data) then
    begin
      Control.Icon := ToIcon(_data).handle;
      if isMain then
       Applet.Icon := Control.Icon;
    end;
end;

procedure THIMainForm._work_doBorderStyle;
begin
  SetBorderStyle(ToInteger(_Data));
end;

function THIMainForm._onClose;
var i:integer;
    p:PControl;
begin
   Result := true;

   if Accept and(ToIntegerEvent(_data_Close)<>0) then exit;
   for i := 0 to Control.ChildCount-1 do
     with Control.Children[i]{$ifndef F_P}^{$endif} do
       if isForm then Perform(WM_CLOSE,0,1);
   if CurForm <> nil then
     PostMessage(CurForm.Handle,WM_ACTIVATE,WA_ACTIVE,0 );
   CurForm := nil;
   
   if isMain then
    begin
     Result := false;
     _hi_OnEvent(_event_onClose);
//     EventOff;
    end
   else
    begin
     p := FParent;
     {$ifndef SUPER_PARENT}
     while not p.isForm do p := p.Parent;
     {$endif}
     if p.ModalForm <> Control then
       Control.Hide
     else Control.ModalResult := -1;
    end;
  SavePosition;
  Showed := False;
end;

function THIMainForm._onMessage;
var
  sControl: PControl;
  i: integer;
  Pt: TPoint;
  OffsetLeft: integer;
  OffsetTop: integer;  
//  acc: boolean;
begin
   Result := false;
   if (Msg.message = WM_INNERMESSAGE) and not isMain and
      (_prop_FormFastening <> nil){ and isWindowVisible(Control.Handle)} then
   begin
     sControl := _prop_FormFastening.ctrlpoint;
     if _prop_OffsetShift then
     begin
       Pt.x := 0; Pt.y := 0;
       ClientToScreen(sControl.Handle, Pt);
       OffsetTop := Pt.Y - sControl.Top;  
       OffsetLeft := Pt.X - sControl.Left;
     end
     else
     begin
       OffsetTop := 0;  
       OffsetLeft := 0;
     end;
     MoveWindow(Control.Handle, sControl.Left + _prop_ShiftLeft + OffsetLeft,
	            sControl.Top + _prop_ShiftTop + OffsetTop, Control.Width, Control.Height, true);
   end             
   else
     case Msg.message of
       WM_ERASEBKGND: 
         if not Bitmap.Empty then begin
           Result := true;
           Rslt := 1;
         end;
       WM_ACTIVATE:
         if Msg.WParam > 0 then _hi_OnEvent(_event_onActivate)
         else if Msg.WParam = 0 then _hi_OnEvent(_event_onDeActivate);
       WM_CLOSE: Result := _onClose(Control,(Msg.lParam=0));
       WM_SIZE:
         begin
           if isMain and Assigned(Applet) then Applet.Width := Control.Width;
           if _prop_Name <> '' then  
             for i := 0 to FormList.Count - 1 do
               PostMessage(FormList.Objects[i], WM_INNERMESSAGE, 0, 0);
         end;
       WM_MOVE:
         begin
           if isMain and Assigned(Applet) then
             Applet.SetPosition(Control.Left,Control.Top);
//           if _prop_Name <> '' then  
             for i := 0 to FormList.Count - 1 do
               PostMessage(FormList.Objects[i], WM_INNERMESSAGE, 0, 0);
           _hi_OnEvent(_event_onMove);
         end;
     end;
   Result := Result or inherited _onMessage(Msg,Rslt);
end;

procedure THIMainForm.SetCaption;
begin
   Control.Caption := Value;
   if IsMain and Assigned(Applet) then
     Applet.Caption := Value;
end;

procedure THIMainForm.SetBorderStyle;
begin
  if Value > Cardinal(Length(BorderStyle_Set)) then exit;
  with Control{$ifndef F_P}^{$endif} do
   begin
    GetWindowHandle;
    //BorderStyle_Set, *_Mask, *_ExSet, *_ExMask � ����� Win.pas
    Style   := BorderStyle_Set[Value]or(BorderStyle_Mask and Style);
    ExStyle := BorderStyle_ExSet[Value]or(BorderStyle_ExMask and ExStyle);
   end;
end;

procedure THIMainForm.SetWindowsState;
begin
   case Value of
    0:;
    1: Control.WindowState := wsMinimized;
    2: Control.WindowState := wsMaximized;
   end;
end;

procedure THIMainForm.SetTaskBar;
begin
  if IsMain then
   if (Value = 1)and Assigned(Applet) then
     Applet.ExStyle :={ Applet.ExStyle or} WS_EX_DLGMODALFRAME or WS_EX_TOOLWINDOW;
end;

procedure THIMainForm.SetIcon;
begin
   if isMain and Assigned(Applet) then
    Applet.Icon := Value;
   if Value = 0 then Value := FParent.Icon;
   Control.Icon := Value;
end;

procedure THIMainForm._OnPaint;
begin
  if (not BitMap.Empty) and (BitMap.PixelFormat <> pf1bit) then BitMap.Draw(DC,0,0);
end;

function CreateCoolControl;
begin
  Result := OutlinePicture(Bitmap, tr);
  SetWindowRgn(Handle, Result, True);
end;

procedure THIMainForm.SetPicture;
begin
  BitMap.Handle := Value;
  hRegion := CreateCoolControl(Control.GetWindowHandle, Bitmap, _prop_TransparentColor);  
end;

procedure THIMainForm.SetAlphaBlendValue;
begin
   Control.AlphaBlend := Value;
end;

procedure THIMainForm._onMouseDown;
begin
   if _prop_DragForm then
    begin
     ReleaseCapture;
     Control.Perform(WM_SYSCOMMAND, $F012, 0);
    end;
   inherited;
end;

procedure THIMainForm._onShow;
begin
  if not Showed then // ��������������� ������� ������ ��� ������ OnShow
  begin
    SetWindowsState(_prop_WindowsState);
    LoadPosition;
    Showed := True;
  end;
//  _hi_OnEvent(_event_onShow);
  inherited;
end;

procedure THIMainForm.Load;
begin
  _hi_OnEvent(_event_onCreate);
  Control.Visible := _prop_Visible;
end;

procedure THIMainForm.Init;
var
  V: Boolean;
begin
  V := _prop_Visible;
  _prop_Visible := False;

  if not isMain then
    FormList.AddObject('', Control.Handle);

  inherited;
  
  //LoadPosition;
  _prop_Visible := V;
  
  SetAlphaBlendValue(_prop_AlphaBlendValue);
  if _prop_ClientSize then
    Control.SetClientSize(_prop_Width, _prop_Height);
  Control.OnPaint := _OnPaint;
  Control.Tag := Longint(Self);
end;

procedure THIMainForm.Start;
begin
  if Assigned(Applet) then
    Applet.Visible := _prop_Visible;
  EventOn;
  InitDo;
end;

procedure THIMainForm.LoadPosition;
begin
  if _prop_SavePosName = '' then
    _prop_Position() // �������� �� ini/������� �� ������� - ���������� _prop_Position
  else
    if Pos('.ini\',_prop_SavePosName) = 0 then
      SaveLoadFromReg(False) // �������� �� �������
    else
      SaveLoadFromIni(False); // �������� �� ini
end;

procedure THIMainForm.SavePosition;
begin
  if _prop_SavePosName = '' then Exit; // ���������� �� �������

  if Pos('.ini\',_prop_SavePosName) = 0 then
    SaveLoadFromReg(True) // ���������� � ������
  else
    SaveLoadFromIni(True); // ���������� � ini
end;

procedure THIMainForm.SaveLoadFromReg(IsSave: Boolean);
var
  pKey: HKey;
  dwType, Sz, Tmp: Integer;
begin
  if IsSave then
  begin
    if RegCreateKeyEx(HKEY_CURRENT_USER, PChar('Software\' + _prop_SavePosName), 0, nil,
       REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, nil, pKey, nil) = ERROR_SUCCESS
    then
    begin
      Tmp := Control.Left;   RegSetValueEx(pKey, PChar('Left'),   0, REG_DWORD, @Tmp, SizeOf(Integer));
      Tmp := Control.Top;    RegSetValueEx(pKey, PChar('Top'),    0, REG_DWORD, @Tmp, SizeOf(Integer));
      Tmp := Control.Height; RegSetValueEx(pKey, PChar('Height'), 0, REG_DWORD, @Tmp, SizeOf(Integer));
      Tmp := Control.Width;  RegSetValueEx(pKey, PChar('Width'),  0, REG_DWORD, @Tmp, SizeOf(Integer));
      RegCloseKey(pKey);
    end;
  end
  else
  begin
    _prop_Position(); // ������� ���������� _prop_Position, ����� ����������� ���������� �� �������
    if RegOpenKeyEx(HKEY_CURRENT_USER, PChar('Software\'+_prop_SavePosName), 0, KEY_READ, pKey) = ERROR_SUCCESS
    then
    begin
      Sz := SizeOf(Integer);
      dwType := REG_DWORD;
      if RegQueryValueEx(pKey, 'Left', nil, @dwType, PByte(@Tmp), @Sz) = ERROR_SUCCESS
      then Control.Left := Tmp;
      if RegQueryValueEx(pKey, 'Top', nil, @dwType, PByte(@Tmp), @Sz) = ERROR_SUCCESS
      then Control.Top := Tmp;
      if RegQueryValueEx(pKey, 'Height', nil, @dwType, PByte(@Tmp), @Sz) = ERROR_SUCCESS
      then Control.Height := Tmp;
      if RegQueryValueEx(pKey, 'Width', nil, @dwType, PByte(@Tmp), @Sz) = ERROR_SUCCESS
      then Control.Width := Tmp;
      RegCloseKey(pKey);
    end;
  end;
end;

procedure THIMainForm.SaveLoadFromIni(IsSave: Boolean);
var
  Ini: PIniFile;
  P: Integer;
begin
  P := Pos('.ini\', _prop_SavePosName);
  Ini := OpenIniFile(GetStartDir + Copy(_prop_SavePosName, 1, P+3));
  Ini.Section := Copy(_prop_SavePosName, P+5, MAXINT);
  with Control{$ifndef F_P}^{$endif} do
  begin
    if IsSave then
    begin
      Ini.Mode := ifmWrite;
      Ini.ValueInteger('Left', Left);
      Ini.ValueInteger('Top', Top);
      Ini.ValueInteger('Width', Width);
      Ini.ValueInteger('Height', Height);
    end
    else
    begin
      _prop_Position(); // ������� ���������� _prop_Position, ����� ����������� ���������� �� ini
      Ini.Mode := ifmRead;
      Left := Ini.ValueInteger('Left', Left);
      Top := Ini.ValueInteger('Top', Top);
      Width := Ini.ValueInteger('Width', Width);
      Height := Ini.ValueInteger('Height', Height);
    end;
  end;
  Ini.Free;
end;

procedure THIMainForm.poNone;
begin

end;

procedure THIMainForm.poScreenCenter;
begin
  Control.Left := (ScreenWidth - Control.Width) div 2;
  Control.Top := (ScreenHeight - Control.Height) div 2;
end;

procedure THIMainForm.poOwnerForm;
begin
  if Control.Parent = nil then exit;
  Control.Left := Control.Parent.Left + _prop_Left;
  Control.Top := Control.Parent.Top + _prop_Top;
end;
  
procedure THIMainForm.poOwnerCenter;
begin
  if Control.Parent = nil then exit;
  
  Control.Left := Control.Parent.Left + (Control.Parent.Width - Control.Width) div 2;
  Control.Top := Control.Parent.Top + (Control.Parent.Height - Control.Height) div 2;
end;

// TODO: ������� ����������, ���� ��������� ������ ��������� THIMainForm?
function GetMainForm(C: PControl): PControl;
begin
  if (C = nil) or (C.Parent = nil) or (C.Parent = Applet) then
    Result := C
  else
    Result := GetMainForm(C.Parent);
end;

procedure THIMainForm.poMainCenter;
var
  MForm: PControl;
begin
  MForm := GetMainForm(Control);
  if MForm <> nil then
  begin
    Control.Left := MForm.Left + (MForm.Width - Control.Width) div 2;
    Control.Top := MForm.Top + (MForm.Height - Control.Height) div 2;
  end;
end;

procedure THIMainForm._work_doCaption;
var Str:string;
begin
  Str := Share.ToString(Data);
  SetWindowText( Control.Handle, @Str[ 1 ] );
end;

procedure THIMainForm._work_doRestore;
begin
  Applet.WindowState := wsNormal;
end;

procedure THIMainForm._work_doMinimize;
begin
//  Applet.WindowState := wsMinimized;
  PostMessage( Applet.Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);  
end;

procedure THIMainForm._work_doAlphaBlendValue;
begin
  Control.AlphaBlend := ToInteger(Data);
end;

procedure THIMainForm._work_doClose;
begin
  SavePosition;
  Showed := False;
  Control.Perform(WM_CLOSE,0,1);
end;

procedure THIMainForm._work_doVisible;
begin
  _prop_Visible := ReadBool(Data);
  if not _prop_Visible then begin
    Control.Hide;
    if isMain then
      Applet.Hide;
    if CurForm <> nil then
      PostMessage(CurForm.Handle,WM_ACTIVATE,WA_ACTIVE,0 );
    CurForm := nil;
  end else begin
    CurForm := Applet.ActiveControl;
    Control.Show;
    if isMain then
      Applet.show;
  end
end;

procedure THIMainForm._work_doShowModal;
var p:PControl;
begin
  p := Control.Parent;
  {$ifndef SUPER_PARENT}
  while not p.isForm do p := p.Parent;
  {$endif}
  Control.ShowModalParented(p);
end;

procedure THIMainForm._work_doPicture;
var bmp:PBitmap;
begin
   bmp := ToBitmap(Data);
   if bmp <> nil then
    begin
     BitMap.Assign(bmp);
     DeleteObject(hRegion);
     hRegion := CreateCoolControl(Control.GetWindowHandle, bmp, _prop_TransparentColor);
     Control.Invalidate;
    end;
end;

procedure THIMainForm._work_doPlaceInTaskBar(var _Data:TData; Index:word);
begin
  Control.ExStyle := Control.ExStyle or WS_EX_APPWINDOW; 
end;

procedure THIMainForm._var_SizeHeader;
var
  Pt: TPoint;
begin
   Pt.x := 0; Pt.y := 0;
   ClientToScreen(Control.Handle, Pt);
   dtInteger(Data, Pt.Y - Control.Top);
end;

procedure THIMainForm._var_SizeBorder;
var
  Pt: TPoint;
begin
   Pt.x := 0; Pt.y := 0;
   ClientToScreen(Control.Handle, Pt);
   dtInteger(Data, Pt.X - Control.Left);
end;

procedure THIMainForm._work_doShiftLeft;
begin
  _prop_ShiftLeft := ToInteger(_Data);
  Control.Perform(WM_INNERMESSAGE,0,0);
end;

procedure THIMainForm._work_doShiftTop;
begin
  _prop_ShiftTop := ToInteger(_Data);
  Control.Perform(WM_INNERMESSAGE,0,0);
end;

procedure THIMainForm._work_doShadow;
const
  CS_DROPSHADOW = $00020000;
var
  en: boolean;
  wnd: HWnd;
begin
  en := ReadBool(_Data);
  Wnd := Control.GetWindowHandle;
  if en then
    SetClassLong(Wnd, GCL_STYLE, GetWindowLong(Wnd, GCL_STYLE) or CS_DROPSHADOW)
  else
    SetClassLong(Wnd, GCL_STYLE, GetWindowLong(Wnd, GCL_STYLE) and not CS_DROPSHADOW)    
end;

procedure THIMainForm._work_doIconInTaskBar;
begin
  if Assigned(Applet) then
    if ReadBool(_Data) then
      ShowWindow(Applet.Handle, SW_SHOW)
    else
      ShowWindow(Applet.Handle, SW_HIDE);
end;

initialization
  FormList := NewKOLStrListEx;
  WM_INNERMESSAGE := RegisterWindowMessage('inner message');
finalization
  FormList.free;

end.