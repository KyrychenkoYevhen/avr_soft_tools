unit hiMST_SelectRow;

interface
     
uses Kol, Share, Debug, hiMTStrTbl;

type
  THIMST_SelectRow = class(TDebug)
  private
    FAutoMakeVisible: boolean;
  public
    _prop_MSTControl: IMSTControl;
    _prop_IndexSelect: integer;    
    _prop_ModeMakeVisible: byte;

    _data_IndexSelect: THI_Event;
    _event_onSelectRow: THI_Event;
    
    property _prop_AutoMakeVisible: boolean write FAutoMakeVisible;

    procedure _work_doAutoMakeVisible(var _Data: TData; Index: word);
    procedure _work_doSelect(var _Data: TData; Index: word);
    procedure _work_doSelectAll(var _Data: TData; Index: word);
    procedure _work_doSelectInvert(var _Data: TData; Index: word);
    procedure _work_doEnsureVisible(var _Data: TData; Index: word);
    procedure _work_doSetFocus(var _Data: TData; Index: word);
    procedure _work_doSelEndStr(var _Data: TData; Index: word);
    procedure _work_doSelectOut(var _Data: TData; Index: word);    
    procedure _var_Count(var _Data: TData; Index: word);
    procedure _var_EndIdx(var _Data: TData; Index: word);
    procedure _var_Index(var _Data: TData; Index: word);
    procedure _var_Select(var _Data: TData; Index: word);

  end;

implementation

// �������� ������ �������
// ARG(IndexRow)
//
procedure THIMST_SelectRow._work_doSelect;
var
  ind, begitm: integer;
  sControl: PControl;
begin
  if not Assigned(_prop_MSTControl) then exit;
  sControl := _prop_MSTControl.ctrlpoint;

  ind := ReadInteger(_Data, _data_IndexSelect, _prop_IndexSelect);
  if (sControl.LVItemState[ind] = [lvisSelect]) or (sControl.Count = 0) then exit;
  
  if (lvoMultiSelect in sControl.LVOptions) then
    sControl.LVItemState[ind] := [lvisSelect, lvisFocus] 
  else
    sControl.LVCurItem := ind;
  if FAutoMakeVisible then
  begin
    if (_prop_MSTControl.style = lvsDetail) or (_prop_MSTControl.style = lvsDetailNoHeader) then
      case _prop_ModeMakeVisible of
        1: begin
             begitm:= ind + sControl.LVPerPage;
             if begitm > sControl.Count - 1 then begitm := sControl.Count - 1;
             ind := begitm - sControl.LVPerPage;
             sControl.LVMakeVisible(begitm, false);
           end;
        2: begin 
             begitm := ind + sControl.LVPerPage div 2;
             if begitm > sControl.Count - 1 then begitm := sControl.Count - 1;
             ind := begitm - sControl.LVPerPage;
             if ind < 0 then ind := 0;
             sControl.LVMakeVisible(begitm, false);
           end;
        3: begin
             begitm := ind - sControl.LVPerPage;
             if begitm < 0 then begitm := 0;
             sControl.LVMakeVisible(begitm, false);
           end;
      end; 
    sControl.LVMakeVisible(ind, false);
  end;
  _hi_onEvent(_event_onSelectRow);
end;

// ������ ������� ������
// ARG(IndexRow)
//
procedure THIMST_SelectRow._work_doEnsureVisible;
var
  sControl: PControl;
begin
  if not Assigned(_prop_MSTControl) then exit;
  sControl := _prop_MSTControl.ctrlpoint;
  if FAutoMakeVisible then exit;
  sControl.LVMakeVisible(ToInteger(_Data), false);
end;

// �������� � ���������� ��������� ������ ������� ��� AutoMakeVisible=True
//
procedure THIMST_SelectRow._work_doSelEndStr;
var
  sControl: PControl;
begin
  if not Assigned(_prop_MSTControl) then exit;
  sControl := _prop_MSTControl.ctrlpoint;
  if not FAutoMakeVisible or (sControl.Count = 0) then exit;
  sControl.LVCurItem:= sControl.Count - 1;
  sControl.LVMakeVisible(sControl.Count - 1, true);
  _hi_onEvent(_event_onSelectRow);  
end;

// �������� ��� ������ �������
//
procedure THIMST_SelectRow._work_doSelectAll;
var
  sControl: PControl;
begin
  if not Assigned(_prop_MSTControl) then exit;
  sControl := _prop_MSTControl.ctrlpoint;
  if (sControl.LVSelCount = sControl.Count) or (sControl.Count = 0) or not (lvoMultiSelect in sControl.LVOptions) then exit;
  sControl.LVSelectAll;
  sControl.LVItemState[sControl.Count - 1] := [lvisSelect, lvisFocus];
  _hi_onEvent(_event_onSelectRow);    
end;

// ����������� ��������� ������ �������
//
procedure THIMST_SelectRow._work_doSelectInvert;
var
  sControl: PControl;
  i: integer;
begin
  if not Assigned(_prop_MSTControl) then exit;
  sControl := _prop_MSTControl.ctrlpoint;
  if (sControl.Count = 0) or not(lvoMultiSelect in sControl.LVOptions) then exit;
  for i := 0 to sControl.Count - 1 do
    if sControl.LVItemState[i] = [] then
      sControl.LVItemState[i] := [lvisSelect, lvisFocus]
    else
      sControl.LVItemState[i] := [];
  _hi_onEvent(_event_onSelectRow); 
end;

// ������� ��������� �� ����� �������
//
procedure THIMST_SelectRow._work_doSelectOut;
var
  sControl: PControl;
begin
  if not Assigned(_prop_MSTControl) then exit;
  sControl := _prop_MSTControl.ctrlpoint;
  if sControl.LVSelCount = 0 then exit;
  sControl.LVCurItem := -1;
  _hi_onEvent(_event_onSelectRow);    
end;

// �������� ��������� ������,
// ��� ������ - ��� ����� MT-��������� �� ���������� ������ �������
//
procedure THIMST_SelectRow._var_Select;
var
  sControl: PControl;
begin
  if not Assigned(_prop_MSTControl) then exit;
  sControl := _prop_MSTControl.ctrlpoint;
  if sControl.LVCurItem = -1 then
     dtNull(_Data)
   else
     _Data := _prop_MSTControl.getstring(sControl.LVCurItem); 
end;

// �������� ������ ���������� ������
//
procedure THIMST_SelectRow._var_Index;
var
  sControl: PControl;
begin
  if not Assigned(_prop_MSTControl) then exit;
  sControl := _prop_MSTControl.ctrlpoint;
  dtInteger(_Data, sControl.CurIndex);
end;

// �������� ���������� ����� � �������
//
procedure THIMST_SelectRow._var_Count;
var
  sControl: PControl;
begin
  if not Assigned(_prop_MSTControl) then exit;
  sControl := _prop_MSTControl.ctrlpoint;
  dtInteger(_Data, sControl.Count);
end;

// �������� ������ ��������� ������ � �������
//
procedure THIMST_SelectRow._var_EndIdx;
var
  sControl: PControl;
begin
  if not Assigned(_prop_MSTControl) then exit;
  sControl := _prop_MSTControl.ctrlpoint;
  dtInteger(_Data, sControl.Count - 1);
end;

// ������������� ����� �� ��������
//
procedure THIMST_SelectRow._work_doSetFocus;
begin
  if not Assigned(_prop_MSTControl) then exit;
  _prop_MSTControl.setfocus(_Data, 0);
end;

procedure THIMST_SelectRow._work_doAutoMakeVisible;
begin
  FAutoMakeVisible := ReadBool(_Data);
end;

end.