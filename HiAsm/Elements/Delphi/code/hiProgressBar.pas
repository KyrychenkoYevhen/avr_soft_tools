unit hiProgressBar;

interface

uses
  Windows, Messages, Kol, Share, Win;

const
  PBS_MARQUEE = $08;

  PBM_SETMARQUEE = WM_USER + 10;
  PBM_SETSTATE = WM_USER + 16;
  PBM_GETSTATE = WM_USER + 17;

type
  THIProgressBar = class(THIWin)
    private

    public
      _prop_Kind: Byte;
      _prop_Smooth: Boolean;
      _prop_Max: Integer;
      _prop_ProgressColor: TColor;
      _prop_State: Integer;

      procedure Init; override;

      procedure _work_doPosition(var _Data: TData; Index: Word);
      procedure _work_doStateProgress(var _Data: TData; Index: Word);
      procedure _work_doStateMarquee(var _Data: TData; Index: Word);
      procedure _work_doMax(var _Data: TData; Index: Word);
      procedure _var_Position(var _Data: TData; Index: Word);
  end;

implementation

procedure THIProgressBar.Init;
var
  Opts: TProgressbarOptions;
begin
  Opts := [];
  if _prop_Kind = 1 then
    Opts := [pboVertical];
  if _prop_Smooth then
    Include(Opts, pboSmooth);
  Control := NewProgressbarEx(FParent, Opts);
  Control.MaxProgress := _prop_Max;
  Control.ProgressColor := _prop_ProgressColor;
  Control.Transparent := False;

  if _prop_Ctl3D = 1 then
    Control.ExStyle := 0;
  
  {$ifdef KOL3XX}
  if _prop_Ctl3D = 0 then _prop_Ctl3D := 2; // Предотвращаем установку при _prop_Ctl3D = False
  {$endif}
  
  inherited;
end;

procedure THIProgressBar._work_doPosition;
begin
  Control.Progress := ToInteger(_Data);
end;

procedure THIProgressBar._work_doMax;
begin
  Control.MaxProgress := ToInteger(_Data);
end;

procedure THIProgressBar._var_Position;
begin
  dtInteger(_Data, Control.Progress);
end;

procedure THIProgressBar._work_doStateProgress;
var
  wnd: HWnd;
begin
  wnd := Control.GetWindowHandle;
  _prop_State := max(1, min(ToInteger(_Data), 3));
  if (GetWindowLong (wnd, GWL_STYLE)) and PBS_MARQUEE = 0 then
    Control.Perform(PBM_SETSTATE, _prop_State, 0);
end;

procedure THIProgressBar._work_doStateMarquee;
var
  wnd: HWnd;
begin
  wnd := Control.GetWindowHandle;
  if ReadBool(_Data) then
  begin
    Control.Perform(PBM_SETSTATE, 1, 0);
    SetWindowLong (wnd, GWL_STYLE, (GetWindowLong (wnd, GWL_STYLE) or PBS_MARQUEE));
    Control.Perform(PBM_SETMARQUEE, 1, 0);    
  end
  else
  begin
    Control.Perform(PBM_SETMARQUEE, 0, 0);
    SetWindowLong (wnd, GWL_STYLE, (GetWindowLong (wnd, GWL_STYLE) and not PBS_MARQUEE));
    Control.Perform(PBM_SETSTATE, _prop_State, 0);
  end;
end;

end.
