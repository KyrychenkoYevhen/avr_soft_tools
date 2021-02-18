unit hiDriveBox; {* ��������� ��� ������ ������.}
interface

{$I share.inc}

uses Windows,Messages,ShellApi,MMSystem,Kol,Share,Win,hiBoxDrawManager;

const
  dspc = #32 + #32;
  IMAGE_SIZE  = 16;

type
  THIDriveBox = class(THIWin)
    private
      IL: PImageList;
      Timer1: PTimer;
      VolList: PKOLStrList;
      UpdDB: Boolean;
      DrvIdx: Integer;
      FSelTextColor: TColor;
      FSelBackColor: TColor;
      fBoxDrawManager:IBoxDrawManager;    
 
      procedure ChangeLabel(Sender: PObj);
      function GetDriveName: string;
      procedure SetDriveName(const Value: string);

      procedure _OnChange(Obj:PObj);
      function  OnMeasureItem( Sender: PObj; Idx: Integer ):Integer;
      function OldOnDrawItem(Sender: PObj; DC: HDC; const Rect: TRect;
                             ItemIdx: Integer; DrawAction: TDrawAction;
                             ItemState: TDrawState): Boolean;
      function NewOnDrawItem(Sender: PObj; DC: HDC; const Rect: TRect;
                             ItemIdx: Integer; DrawAction: TDrawAction;
                             ItemState: TDrawState): Boolean;
      procedure SetInitBoxDrawManager(value:IBoxDrawManager);                           

  public
      _prop_Disk:string;
      _data_DefaultDisk:THI_Event;
      _event_onSelect:THI_Event;
      _event_onUnReadable:THI_Event;      
      _prop_ItemHeight:integer;
      _prop_BackSlash:boolean;
      _prop_UpperCharInBox:boolean;
      _prop_AutoSetDisk:boolean;            

      property DriveName: string read GetDriveName write SetDriveName;
      {* <0>/<1> ������� ����.
      |<br>'*' - ������������� ���� GetStartDir.}
      procedure OpenDriveBox;
      procedure UpdateDriveBox;

      destructor Destroy; override;
      procedure Init; override;
      procedure _work_doLabel(var _Data:TData; Index:word);
      procedure _work_doDisk(var _Data:TData; Index:word);    
      procedure _var_Label(var _Data:TData; Index:word);
      procedure _var_Disk(var _Data:TData; Index:word);
      property _prop_BoxDrawManager:IBoxDrawManager read fBoxDrawManager write SetInitBoxDrawManager; 
  end;

implementation

var
  DriveBoxs: PList; // ������ � ����������� �� BAPDriveBox'�

const
  WM_DEVICECHANGE = $0219;

type
  _DEV_BROADCAST_HDR = record // Device broadcast header
    dbch_size: DWORD;
    dbch_devicetype: DWORD;
    dbch_reserved: DWORD;
  end;
  DEV_BROADCAST_HDR = _DEV_BROADCAST_HDR;
  PDEV_BROADCAST_HDR = ^DEV_BROADCAST_HDR;

// The following messages are for WM_DEVICECHANGE. The immediate list
// is for the wParam. ALL THESE MESSAGES PASS A POINTER TO A STRUCT
// STARTING WITH A DWORD SIZE AND HAVING NO POINTER IN THE STRUCT.

const
  DBT_DEVICEARRIVAL        = $8000; // system detected a new device
  DBT_DEVICEREMOVECOMPLETE = $8004; // device is gone

  DBT_APPYBEGIN = 0;
  DBT_DEVTYP_VOLUME = $00000002; // logical volume

  DBTF_MEDIA = $0001; // media comings and goings
  DBTF_NET   = $0002; // network volume

type
  _DEV_BROADCAST_VOLUME = record
    dbcv_size: DWORD;
    dbcv_devicetype: DWORD;
    dbcv_reserved: DWORD;
    dbcv_unitmask: DWORD;
    dbcv_flags: WORD;
  end;
  DEV_BROADCAST_VOLUME  = _DEV_BROADCAST_VOLUME;
  PDEV_BROADCAST_VOLUME = ^DEV_BROADCAST_VOLUME;

(* Finds the first valid drive letter from a mask of drive letters *)

function FirstDriveFromMask(unitmask: Longint): Char;
var  DriveLetter: Shortint;
begin
  DriveLetter := Byte('a');
  while (unitmask and 1) = 0 do
  begin
    unitmask := unitmask shr 1;
    Inc(DriveLetter);
  end;
  Result := Char(DriveLetter);
end;

(* NOT REMOVABLE AND NOT CD/DVD *)

function FixedDrive(Drv: Char): Boolean;
begin
  case GetDriveType(PChar(Drv + ':\')) of
    DRIVE_REMOVABLE, DRIVE_CDROM: Result := false;
  else
    Result := true;
  end;
end;

(* ���������� ������ *)

function DriveReady(Drv: Char): Boolean;
var  NotUsed: DWord;
begin
  Result := GetVolumeInformation(PChar(Drv + ':\'), nil, 0, nil, NotUsed, NotUsed, nil, 0);
end;

(* �������� ����� ����� *)

function GetLabelDisk(Drv: Char; VolReal: Boolean): string;
var
  WinVer: Byte;
  DriveType, NotUsed: DWORD;
  SFI: TSHFileInfo;
  L: Integer;

  function DisplayName(sDrv: Char): string;
  var
    I, K: Integer;
  begin
    FillChar(SFI, SizeOf(SFI), 0);
    SHGetFileInfo(PChar(sDrv + ':\'), 0, SFI, SizeOf(SFI), SHGFI_DISPLAYNAME);
    Result := SFI.szDisplayName;
    // � Win9x, Me - ��� ����� ����� -> #32 + (x:)
    // � WinNT 5.x - ��� ����� ����� -> �������� ���������� + #32 + (x:)

    // ���� ������ '(' � �����. ��������� - ��, ��� �����.
    K := Length(Result);
    if K = 0 then Exit;
    
    I := K;
    while I <= K do
    begin
      if Result[I] = '(' then Break;
      Dec(I);
    end;
    
    if I > 0 then
      Result := TrimRight(Copy(Result, 1, I-1))
    else
      Result := '';
  end;

begin
  Result := '';
  WinVer := LoByte(LoWord(GetVersion));
  DriveType := GetDriveType(PChar(Drv + ':\'));

  if (WinVer <= 4) and (DriveType <> DRIVE_REMOVABLE) or VolReal then
  begin // Win9x, Me, NT <= 4.0
    L := MAX_PATH;
    SetLength(Result, L);
    GetVolumeInformation(PChar(Drv + ':\'), @Result[1], L, nil, NotUsed, NotUsed, nil, 0);
    while (L > 0) and (Result[L] = ' ') do Dec(L);
    SetLength(Result, L);
    if VolReal and (WinVer >= 5) and (Result <> '') and (DriveType <> DRIVE_REMOVABLE) then // Win2k, XP � ����
      Result := DisplayName(Drv)
    else if (Result = '') and (not VolReal) then
      Result := '<none>';
  end
  else
    Result := DisplayName(Drv);
end;

(* �������� ��������� ����� ����� *)

procedure WaitLabelChange(Drv: Char; Str: string);
var  st1, st2: string;
begin
  st1 := TrimLeft(Str);
  st2 := st1;
  while st1 = st2 do
    st2 := GetLabelDisk(Drv, FALSE);
end;

(* ����� DropList *)

procedure NewDroppedList(Ctl: PControl);
var
  WD, Idx: Integer;
  Vol: string;
  D: THIDriveBox;
begin
  D := THIDriveBox(Ctl.Tag);
  WD := 0;
  for Idx := 0 to Ctl.Count - 1 do
  begin
    D.VolList.Items[Idx] := dspc + GetLabelDisk(Ctl.Items[Idx][3], False);
    Vol := Ctl.Items[Idx] + D.VolList.Items[Idx];
    if WD < Ctl.Canvas.TextWidth(Vol) then
      WD := Ctl.Canvas.TextWidth(Vol);
  end;
  Inc(WD, 26);

  if Ctl.Count > 12 then
    Inc(WD, GetSystemMetrics(SM_CXVSCROLL));
  if fsItalic in Ctl.Font.FontStyle then
    if not Ctl.Font.IsFontTrueType then
      Inc(WD, 2);
  Ctl.Perform(CB_SETDROPPEDWIDTH, WD, 0);
end;

(* ���������� ������� *)

function WndProcDrive(Ctl: PControl; var Msg: TMsg; var Rslt: LRESULT): Boolean;
var
  Drv: Char;
  D: THIDriveBox;
begin
  D := THIDriveBox(Ctl.Tag);
  Result := False;

  case Msg.message of
    CM_COMMAND:
      case HIWORD(Msg.wParam) of
        CBN_DROPDOWN: // ��������� ������ DropList'� � ��������� ����� ������
        begin
          D.DrvIdx := Ctl.CurIndex;
          NewDroppedList(Ctl);
        end;

        CBN_SELENDOK: // ������ �������
        begin
          D.Timer1.Enabled := False;
          Drv := Ctl.Items[Ctl.CurIndex][3];

          //== �������� CD/DVD
          if (GetDriveType(PChar(Drv + ':\')) = DRIVE_CDROM) and (not DriveReady(Drv)) then
          begin
            Ctl.Perform(CB_SHOWDROPDOWN, 0, 0);
            if DriveReady(Drv) then
              if GetLabelDisk(Drv, True) <> '' then
                WaitLabelChange(Drv, D.VolList.Items[Ctl.CurIndex])
          end;
          if not DriveReady(Drv) then
            exit
          else  
            D.SetDriveName(Drv);
        end;
      end; // case HiWord

    WM_KEYDOWN: // ������� ������
    begin
      case Msg.wParam of
        $01..$20, $29..$40, $5B..$FE: Exit;
      end;

      if Ctl.DroppedDown then exit;
      Ctl.Perform(CB_SHOWDROPDOWN, 1, 0);
      Result := True;
    end;
  end;  // case Msg
end;

//
//------------------------------------------------------------------------------
//
//

(* ���������� WM_DEVICECHANGE *)

function WndProcDriveChange(sControl: PControl; var Msg: TMsg; var Rslt: LRESULT): Boolean;
var Drv: Char;
    Idx: Integer;
    D: THIDriveBox;
    Ctl: PControl;
    pDevBroadcastHdr: PDEV_BROADCAST_HDR;
    pDevBroadcastVolume: PDEV_BROADCAST_VOLUME;
begin
  Result := False;


  for Idx := 0 to DriveBoxs.Count - 1 do
  begin
    Ctl := DriveBoxs.Items[Idx];
    D := THIDriveBox(Ctl.Tag);

    pDevBroadcastHdr := nil;   
    if Msg.message = WM_DEVICECHANGE then
      pDevBroadcastHdr := PDEV_BROADCAST_HDR(Msg.lParam);
      case Msg.wParam of
        DBT_DEVICEARRIVAL: //== ���������� ����������
          if pDevBroadcastHdr.dbch_devicetype = DBT_DEVTYP_VOLUME then
          begin
            pDevBroadcastVolume := PDEV_BROADCAST_VOLUME(Msg.lParam);
            if (pDevBroadcastVolume.dbcv_flags and DBTF_MEDIA) = 1 then
              Ctl.Perform(CB_SHOWDROPDOWN, 0, 0)
            else // ���������� ����������, � �� �������� CD/DVD
              D.UpdateDriveBox;
          end;

        DBT_DEVICEREMOVECOMPLETE: //== �������� ����������
        begin
          pDevBroadcastVolume := PDEV_BROADCAST_VOLUME(Msg.lParam);
          if pDevBroadcastHdr.dbch_devicetype = DBT_DEVTYP_VOLUME then
            if (pDevBroadcastVolume.dbcv_flags and DBTF_MEDIA) = 1 then
            begin // �������� CD/DVD �� ����������
              Ctl.Perform(CB_SHOWDROPDOWN, 0, 0);
              Drv := Ctl.Items[Ctl.CurIndex][3];
              if FirstDriveFromMask(pDevBroadcastVolume.dbcv_unitmask) = Drv then
                D.SetDriveName(#99);
            end
            else // ������� ���������� �� �������
              D.UpdateDriveBox;
        end;
      end; // case
  end;    
end;

(* �������� ����� *)

procedure THIDriveBox.UpdateDriveBox;
var  Ch, Drv: Char;
     DrivesMask: Integer;
begin
  Timer1.Enabled := False;
  UpdDB := True;

  if Control.Count > 0 then
  begin
    Drv := Control.Items[Control.CurIndex][3];
    VolList.Clear;
    Control.Clear;
  end
  else
    Drv := '*'; // ���� �� ���������

  DrivesMask := GetLogicalDrives;

  for Ch := 'a' to 'z' do
  begin
    if LongBool(DrivesMask and 1) then
    begin
      if _prop_UpperCharInBox then
        Control.Add('[-' + UpperCase(Ch) + '-]')
      else
        Control.Add('[-' + Ch + '-]');
      VolList.Add('');
    end;
    DrivesMask := DrivesMask shr 1;
  end;

  UpdDB := False;
  SetDriveName(Drv);
  Control.Invalidate;
end;

(* ��������� ����� *)

procedure THIDriveBox.SetDriveName;
var  Retry, Err: Boolean;
     Drv: string;
begin
  if Value = '' then exit;
  Timer1.Enabled := False;

  if (Value = '*') then
    Drv := GetStartDir[1]
  else
    Drv := Value[1];
  Drv := UpperCase(Drv) + ':';
  repeat
    Err := False;
    Retry := False;
    if DriveReady(Drv[1]) then
      Control.CurIndex := Control.SearchFor(Drv[1], 0, True)
    else
      Err := True;
  until not Retry;

  if Err then
  begin
    if DriveReady(Control.Items[DrvIdx][3]) then
      Control.CurIndex := DrvIdx
    else
    begin // ��� �������� �������� ������
      Drv := #99 + ':';
      Control.CurIndex := Control.SearchFor(Drv[1], 0, True);
    end;
  end  
  else
    Control.CurIndex := Control.SearchFor(Drv[1], 0, True);
  VolList.Items[Control.CurIndex] := dspc + GetLabelDisk(Drv[1], False);
  if FixedDrive(Drv[1]) then Timer1.Enabled := true;
end;

function THIDriveBox.GetDriveName;
begin
  Result := UpperCase(Control.Items[Control.CurIndex][3]) + ':';
  if _prop_BackSlash then
    Result := Result + '\';
end;

(* ������� DriveBox *)

procedure THIDriveBox.OpenDriveBox;
begin
  Control.Perform(WM_LBUTTONDOWN, 0, 0);
  Control.Perform(WM_LBUTTONUP, 0, 0);
end;

(* ���������� NewOnDrawItem *)

function THIDriveBox.NewOnDrawItem;
var  Ico: Integer;
     cbRect: TRect;
     fControl: PControl; 
begin
  Result := False;
  if UpdDB then exit;

  fControl := PControl(Sender); 
  Ico := FileIconSystemIdx(PControl(Sender).Items[ItemIdx][3] + ':\');
  IL.BkColor := Control.Color;
  IL.DrawingStyle := [dsTransparent];

  Result := _prop_BoxDrawManager.draw(Sender, DC, Rect, ItemIdx, ItemState, false, fControl.Font.Handle, fControl.Items[ItemIdx] + VolList.Items[ItemIdx]);

  cbRect := Rect;

  with cbRect do
    begin
      Top:= Top + (Bottom - Top - IMAGE_SIZE) div 2;
      Left:= _prop_BoxDrawManager.shift;
      if (odsComboboxEdit in ItemState) then inc(Left);
      Bottom:= Top + IMAGE_SIZE; 
      Right:= Left + IMAGE_SIZE;
    end;  
  IL.StretchDraw(Ico, DC, cbRect);
end;

(* ���������� OldOnDrawItem *)

function THIDriveBox.OldOnDrawItem;
var  Ico: Integer;
     cbRect, icRect: TRect;
     fControl: PControl; 
begin
  Result := False;
  if UpdDB then exit;

  fControl := PControl(Sender); 
  icRect := Rect;
  cbRect := Rect;
  cbRect.Left := 20;
  Ico := FileIconSystemIdx(fControl.Items[ItemIdx][3] + ':\');
  IL.BkColor := Control.Color;
  IL.DrawingStyle := [dsTransparent];
    
  if (odsSelected in ItemState) then
  begin  //== Selected Item
    fControl.Canvas.Brush.Color := FSelBackColor;
    SetTextColor(DC, Color2RGB(FSelTextColor));
    SetBkMode(DC, fControl.Font.Color);
  end
  else begin //== Normal Item
    fControl.Canvas.Brush.Color := PControl(Sender).Color;
    SetTextColor(DC, fControl.Font.Color)
  end;
  FillRect(DC, Rect, fControl.Canvas.Brush.Handle);


  with icRect do
  begin
    Top:= Top + (Bottom - Top - IMAGE_SIZE) div 2;
    if (odsComboboxEdit in ItemState) then //== Draw Icon in Edit
    begin
      Left:= 3;
      //Inc(cbRect.Left);
    end
    else //== Draw Icon in DropList
      Left:= 3;
      
    Bottom:= Top + IMAGE_SIZE; 
    Right:= Left + IMAGE_SIZE;
  end;   
  IL.StretchDraw(Ico, DC, icRect);
  Inc(cbRect.Left, 2); // ������ ������ �� ������
  
  {if (odsComboboxEdit in ItemState) then
  begin //== Draw Icon in Edit
    icRect.Top := 5;
    icRect.Left := 3; // ����� ��������� ������ = 16
    icRect.Right := 19;
    IL.StretchDraw(Ico, DC, icRect);
    Inc(cbRect.Left);    
  end
  else 
  begin //== Draw Icon in DropList
    icRect.Left := 2; // ����� ��������� ������ = 16
    icRect.Right := 18;
    IL.StretchDraw(Ico, DC, icRect);  
  end;}

  DrawText(DC, PChar(fControl.Items[ItemIdx] + VolList.Items[ItemIdx]),
           -1, cbRect, DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
end;

(* ���������� ������� *)

procedure THIDriveBox.ChangeLabel;
var  Drv: Char;
begin
  Drv := Control.Items[Control.CurIndex][3];
  if TrimLeft(VolList.Items[Control.CurIndex]) <> GetLabelDisk(Drv, False) then
  begin
    VolList.Items[Control.CurIndex] := dspc + GetLabelDisk(Drv, False);
    Control.Invalidate;
  end;
end;

destructor THIDriveBox.Destroy;
begin
  Timer1.Enabled := False;
//  Timer1.free;
{$ifndef F_P}
   Timer1.Free;
{$endif}
  IL.free;
  VolList.free;
  DriveBoxs.Remove(Control);
  if (@WndProcDriveChange <> nil) and (Applet <> nil) then
    Applet.DetachProc(WndProcDriveChange);
  inherited;
end;

procedure THIDriveBox.Init;
begin
  Control := NewCombobox(FParent, [coReadOnly, coOwnerDrawFixed]);
  if ManFlags and $04 > 0 then
  begin
    Control.OnMeasureItem:= OnMeasureItem;
    Control.OnDrawItem := NewOnDrawItem; 
  end
  else
    Control.OnDrawItem := OldOnDrawItem;
  {$ifdef KOL3XX}Control.OnMeasureItem:= OnMeasureItem;{$endif}

  DriveBoxs.Add(Control);

  IL := NewImageList(nil);
  IL.LoadSystemIcons(True);
  VolList := NewKOLStrList;
  FSelTextColor := clMenuText;
  FSelBackColor := clBtnFace;
  Timer1 := NewTimer(1000);
  Timer1.OnTimer := ChangeLabel;

  Control.Tag := LongInt(Self);
  Control.AttachProc(WndProcDrive);
  if Applet <> nil then // WM_DEVICECHANGE
    Applet.AttachProc(WndProcDriveChange);
  Control.OnSelChange := _OnChange;
  inherited;
  UpdateDriveBox;
  if _prop_AutoSetDisk then
    DriveName := Copy(_prop_Disk,1,1); 
end;

procedure THIDriveBox.SetInitBoxDrawManager;
begin
  if value <> nil then
    fBoxDrawManager := value;
end;

procedure THIDriveBox._OnChange;
begin
  if DriveReady(Control.Items[Control.CurIndex][3]) then
    _hi_OnEvent(_event_onSelect, DriveName)
  else  
    _hi_OnEvent(_event_onUnReadable, DriveName);
end;

procedure THIDriveBox._work_doLabel;
begin
  SetVolumeLabel(PChar(DriveName + '\'), PChar(Share.ToString(_Data)));
end;

procedure THIDriveBox._work_doDisk;
begin
  DriveName := Copy(ReadString(_Data,_data_DefaultDisk,_prop_Disk),1,1);
  Control.InvaliDate;
end;

procedure THIDriveBox._var_Label;
begin
  dtString(_Data, GetLabelDisk(Control.Items[Control.CurIndex][3], True));
end;

procedure THIDriveBox._var_Disk;
begin
  dtString(_Data, DriveName);
end;

function THIDriveBox.OnMeasureItem;
begin
  Result := _prop_ItemHeight;
end;

initialization
  DriveBoxs := NewList;

finalization
  DriveBoxs.free;
  
end.