unit hiMemo;

interface

uses
  Kol, Share, EWinList, Windows, Messages;

type
  THIMemo = class(THIEWinList)
    private
      procedure _OnChange(Obj: PObj);
      function Add(const Text: string): Integer; override;
      //procedure SetStrings(const Value:string); override;
      procedure SaveToList; override;
      
    protected
      procedure Select(idx: Integer); override;
      procedure _Set(var Item: TData; var Val: TData); override;
      
    public
    _prop_ScrollBars:byte;
    _prop_ReadOnly:byte;
    _prop_Strings:string;

    procedure Init; override;
    procedure _work_doEnsureVisible(var _Data: TData; Index: Word);
    //procedure _work_doKeyBack(var _Data: TData; Index: Word);
  end;

implementation

procedure THIMemo._Set(var Item:TData; var Val:TData);
var
  Ind: Integer;
begin
  Ind := ToIntIndex(Item);
  if (Ind < 0) or (Ind >= Control.Count) then Exit;
  if Ind < Control.Count-1 then
    Control.Items[Ind] := Share.ToString(Val) + #13#10
  else
    Control.Items[Ind] := Share.ToString(Val);
end;

procedure THIMemo.Select(idx: Integer);
var
  Strt: Integer;
begin
  with Control{$ifndef F_P}^{$endif} do
  begin
    Strt := Item2Pos(Idx);
    SelStart := Strt;
    SelLength := Item2Pos(Idx + 1) - Strt;
  end;
end;

function THIMemo.Add(const Text: string): Integer;
begin
  if (Control.Count > 0) and (Control.Items[Control.Count-1] <> '') then
    Control.Add(#13#10);
  
  //Result := Control.Add(Text);
  if Text <> '' then
    Result := Control.Add(Text)
  else
    Result := Control.Add(#13#10);
  //inherited;
end;

procedure THIMemo._work_doEnsureVisible(var _Data: TData; Index: Word);
begin
  Control.Perform(EM_SCROLLCARET, 0, 0);
end;

{procedure THIMemo.SetStrings;
begin
  Control.Text := Value;
end;}

procedure THIMemo.SaveToList;
begin
  FList.Text := Control.Text;
end;

procedure THIMemo.Init;
var
  Flags: TEditOptions;
begin
  Flags := [eoMultiline,eoNoHideSel,eoNoVScroll,eoNoHScroll];
  case _prop_ScrollBars of
    0: ;
    1: Exclude(Flags,eoNoHScroll);
    2: Exclude(Flags,eoNoVScroll);
    3:
      begin
        Exclude(Flags,eoNoHScroll);
        Exclude(Flags,eoNoVScroll);
      end;
  end;
  if _prop_ReadOnly = 0 then
    Include(Flags,eoReadonly);

  //Control := NewRichEdit(FParent,Flags);
  Control := NewEditbox(FParent,Flags);

  Control.OnChange := _OnChange;

  inherited;
  if _prop_Ctl3D = 1 then Control.Ctl3D := False;
  
  Control.Text := _prop_Strings;
  Control.SubClassName := 'obj_MemoControl';
end;

procedure THIMemo._OnChange;
begin
  _hi_OnEvent(_event_onChange, Control.Text);
end;

{procedure THIMemo._work_doKeyBack(var _Data: TData; Index: Word);
begin
  Back := ToInteger(_Data);
end;}

end.