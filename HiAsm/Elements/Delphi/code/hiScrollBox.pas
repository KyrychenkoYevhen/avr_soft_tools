unit hiScrollBox;

interface

uses Windows,Messages,Kol,Share,Win;

type
  THIScrollBox = class(THIWin)
   private
     procedure _OnScroll(Sender: PControl; Bar: TScrollerBar; ScrollCmd: DWORD; ThumbPos:DWORD);
   public
    _data_HScroll: THI_Event;
    _data_VScroll: THI_Event;
    _event_onHScroll: THI_Event;
    _event_onVScroll: THI_Event;
    _prop_BorderStyle:TEdgeStyle;
    constructor Create(Parent:PControl);
    procedure Init; override;
    procedure _work_doHScroll(var _Data:TData; Index:word);
    procedure _work_doVScroll(var _Data:TData; Index:word);
    procedure _var_HPos(var _Data:TData; Index:word);
    procedure _var_VPos(var _Data:TData; Index:word);
  end;

implementation

constructor THIScrollBox.Create(Parent:PControl);
begin
   inherited Create(Parent);
   //Control.Font.Create;
   //Control.Font.FontHeight := -11;
   //Control.ExStyle := 0;
end;

procedure THIScrollBox.Init;
begin
   Control := NewScrollBoxEx(FParent,_prop_BorderStyle);
   inherited;
   Control.onScroll := _OnScroll;
end;

procedure THIScrollBox._OnScroll;
begin
  if Bar = sbHorizontal then
    _hi_onEvent(_event_onHScroll)
  else
    _hi_onEvent(_event_onVScroll);    
end;

procedure THIScrollBox._work_doHScroll;
begin
   SetScrollPos(Control.Handle, SB_HORZ, ReadInteger(_Data,_data_HScroll), True);
   SendMessage(Control.Handle, WM_HSCROLL, SB_THUMBTRACK, 0);
end;

procedure THIScrollBox._work_doVScroll;
begin
   SetScrollPos(Control.Handle, SB_VERT, ReadInteger(_Data,_data_VScroll), True);
   SendMessage(Control.Handle, WM_VSCROLL, SB_THUMBTRACK, 0);
end;

procedure THIScrollBox._var_HPos;
var SI: TScrollInfo;
begin
   SI.cbSize := Sizeof(SI);
   SI.fMask := SIF_POS;
   GetScrollInfo(Control.Handle, SB_HORZ, SI);
   dtInteger(_Data,SI.nPos);
end;

procedure THIScrollBox._var_VPos;
var SI: TScrollInfo;
begin
   SI.cbSize := Sizeof(SI);
   SI.fMask := SIF_POS;
   GetScrollInfo(Control.Handle, SB_VERT, SI);
   dtInteger(_Data,SI.nPos);
end;

end.
