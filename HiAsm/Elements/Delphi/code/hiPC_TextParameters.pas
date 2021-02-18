unit hiPC_TextParameters;

interface

uses Kol, Share, Debug, hiDocumentTemplate, hiPrint_Text, PrintController;

type
  THIPC_TextParameters = class(TPrintController)
   private
   public
    _prop_Parameters: string;
    _prop_Delimiter: string;
    _data_Parameters:THI_Event;
    _event_onSet:THI_Event;
    _event_onEnum:THI_Event;
    _event_onEndEnum:THI_Event;

    procedure _work_doSet(var _Data:TData; Index:word);
    procedure _work_doEnum(var _Data:TData; Index:word);    
  end;

implementation

uses hiStr_Enum;

(* <Name>|
   <Text>|
   <X>,<Y>,<Width>,<Height>|
   <Name>,<Size>,<Style>,<Color>,<CharSet>|
   <Style>,<Size>,<Color>|
   <Style>,<Color>|
   <Vertical>,<Horizontal>|
   <Left>,<Top>,<Right>,<Bottom> *)

procedure THIPC_TextParameters._work_doSet;
var
  ss: string;
  se: string;
  sp: string;
  i: integer;
  FontName: string;
  FontSize: byte;
  FontStyle: byte;
  FontColor: TColor;
  FontCharSet: byte;
  FrameColor, BackColor: TColor;
  ParamList: PKOLStrList;  
begin
  ParamList := NewKOLStrList;
  ParamList.text := ReadString(_Data, _data_Parameters, _prop_Parameters);
TRY
  if (ParamList.Count = 0) or (_prop_Delimiter = '') then exit;
  for i := 0 to ParamList.Count - 1 do
  begin
    ss := ParamList.Items[i]; 

    (* Name *)

    se := fparse(ss, '|');
    FItem := _prop_Document.getItem(se);
    if (FItem = nil) or (ss = '') then continue;
    
    (* Text *)

    THIPrint_Text(FItem)._prop_Text := fparse(ss, '|');
    if ss = '' then continue;
    
    (* Position - <X>,<Y>,<Width>,<Height> *)

    se := fparse(ss, '|');
    if se <> '' then
    begin
      (* X *)
      sp := fparse(se, _prop_Delimiter[1]);
      if sp <> '' then TDocItem(FItem)._prop_X := str2int(sp);
      if se <> '' then
      begin
        (* Y *)
        sp := fparse(se, _prop_Delimiter[1]);
        if sp <> '' then TDocItem(FItem)._prop_Y := str2int(sp);
        if se <> '' then
        begin
          (* Width *)
          sp := fparse(se, _prop_Delimiter[1]);
          if sp <> '' then TDocItem(FItem)._prop_Width := str2int(sp);
          if se <> '' then
          begin
            (* Height *)
            sp := fparse(se, _prop_Delimiter[1]);
            if sp <> '' then  TDocItem(FItem)._prop_Height := str2int(sp);
          end;              
        end;              
      end;             
    end;
    if ss = '' then continue;

    (* Font - <Name>,<Size>,<Style>,<Color>,<CharSet> *)

    se := fparse(ss, '|');
    if se <> '' then
    begin
      FontName := THIPrint_Text(FItem)._prop_Font.Name;    
      FontSize := THIPrint_Text(FItem)._prop_Font.Size;
      FontStyle := THIPrint_Text(FItem)._prop_Font.Style;
      FontColor := THIPrint_Text(FItem)._prop_Font.Color;
      FontCharSet := THIPrint_Text(FItem)._prop_Font.CharSet;              
      (* FontName *)
      sp := fparse(se, _prop_Delimiter[1]);
      if sp <> '' then FontName := sp;
      if se <> '' then
      begin
        (* FontSize *)
        sp := fparse(se, _prop_Delimiter[1]);
        if sp <> '' then FontSize := byte(str2int(sp));
        if se <> '' then
        begin
          (* FontStyle *)
          sp := fparse(se, _prop_Delimiter[1]);
          if sp <> '' then FontStyle := byte(str2int(sp));
          if se <> '' then
          begin
            (* FontColor *)
            sp := fparse(se, _prop_Delimiter[1]);
            if sp <> '' then FontColor := str2int(sp);
            if se <> '' then
            begin
              (* FontCharSet *)
              sp := fparse(se, _prop_Delimiter[1]);
              if sp <> '' then FontCharSet := byte(str2int(sp));          
            end;              
          end;              
        end;              
      end;             
      THIPrint_Text(FItem)._prop_Font :=  hiCreateFont(FontName, FontSize, FontStyle, FontColor, FontCharSet);
    end;
    if ss = '' then continue;
    
    (* Frame - <Style>,<Size>,<Color> *)

    se := fparse(ss, '|');
    if se <> '' then
    begin
      FrameColor := THIPrint_Text(FItem)._prop_FrameColor;
      (* Style *)
      sp := fparse(se, _prop_Delimiter[1]);
      if sp <> '' then THIPrint_Text(FItem)._prop_FrameStyle := str2int(sp);
      if se <> '' then
      begin
        (* Size *)
        sp := fparse(se, _prop_Delimiter[1]);
        if sp <> '' then THIPrint_Text(FItem)._prop_FrameSize := str2int(sp);
        if se <> '' then
        begin
          (* Color *)
          sp := fparse(se, _prop_Delimiter[1]);
          if sp <> '' then FrameColor := str2int(sp);
        end;              
      end;
      THIPrint_Text(FItem)._prop_FrameColor := FrameColor;             
    end;
    if ss = '' then continue;

    (* Background - <Style>,<Color> *)

    se := fparse(ss, '|');
    if se <> '' then
    begin
      BackColor := THIPrint_Text(FItem)._prop_BackColor;
      (* Style *)
      sp := fparse(se, _prop_Delimiter[1]);
      if sp <> '' then THIPrint_Text(FItem)._prop_BackStyle := str2int(sp);
      if se <> '' then
      begin
        (* Color *)
        sp := fparse(se, _prop_Delimiter[1]);
        if sp <> '' then BackColor := str2int(sp);
      end;
      THIPrint_Text(FItem)._prop_BackColor := BackColor;              
    end;
    if ss = '' then continue;

    (* Align - <Vertical>,<Horizontal> *)

    se := fparse(ss, '|');
    if se <> '' then
    begin
      (* Vertical *)
      sp := fparse(se, _prop_Delimiter[1]);
      if sp <> '' then THIPrint_Text(FItem)._prop_Vertical := str2int(sp);
      if se <> '' then
      begin
        (* Horizontal *)
        sp := fparse(se, _prop_Delimiter[1]);
        if sp <> '' then THIPrint_Text(FItem)._prop_Horizontal := str2int(sp);
      end;             
    end;
    if ss = '' then continue;

    (* Margin - <Left>,<Top>,<Right>,<Bottom> *)

    se := fparse(ss, '|');
    if se <> '' then
    begin
      (* Left *)
      sp := fparse(se, _prop_Delimiter[1]);
      if sp <> '' then THIPrint_Text(FItem)._prop_Left := str2int(sp);
      if se <> '' then
      begin
        (* Top *)
        sp := fparse(se, _prop_Delimiter[1]);
        if sp <> '' then THIPrint_Text(FItem)._prop_Top := str2int(sp);
        if se <> '' then
        begin
          (* Right *)
          sp := fparse(se, _prop_Delimiter[1]);
          if sp <> '' then THIPrint_Text(FItem)._prop_Right := str2int(sp);
          if se <> '' then
          begin
            (* Left *)
            sp := fparse(se, _prop_Delimiter[1]);
            if sp <> '' then  THIPrint_Text(FItem)._prop_Bottom := str2int(sp);
          end;              
        end;              
      end;             
    end;
  end;  
FINALLY
  ParamList.free;
  _hi_onEvent(_event_onSet);
END;  
end;

procedure THIPC_TextParameters._work_doEnum;
var
  i: integer;
  Parameters: string;
begin
  for i := 0 to _prop_Document.getItemCount() - 1 do
  begin
    FItem := _prop_Document.getItemIdx(i);
    if (TDocItem(FItem)._NameType = _TEXT) and (TDocItem(FItem)._prop_Name <> '') then 
    begin
      Parameters := TDocItem(FItem)._prop_Name +
      '|' + THIPrint_Text(FItem)._prop_Text +
      '|' + int2str(TDocItem(FItem)._prop_X) +
      _prop_Delimiter[1] + int2str(TDocItem(FItem)._prop_Y) +
      _prop_Delimiter[1] + int2str(TDocItem(FItem)._prop_Width) +
      _prop_Delimiter[1] + int2str(TDocItem(FItem)._prop_Height) +
      '|' + THIPrint_Text(FItem)._prop_Font.Name +
      _prop_Delimiter[1] + int2str(THIPrint_Text(FItem)._prop_Font.Size) +
      _prop_Delimiter[1] + int2str(THIPrint_Text(FItem)._prop_Font.Style) +
      _prop_Delimiter[1] + int2str(THIPrint_Text(FItem)._prop_Font.Color) +
      _prop_Delimiter[1] + int2str(THIPrint_Text(FItem)._prop_Font.CharSet) +
      '|' + int2str(THIPrint_Text(FItem)._prop_FrameStyle) +
      _prop_Delimiter[1] + int2str(THIPrint_Text(FItem)._prop_FrameSize) +
      _prop_Delimiter[1] + int2str(THIPrint_Text(FItem)._prop_FrameColor) +
      '|' + int2str(THIPrint_Text(FItem)._prop_BackStyle) +
      _prop_Delimiter[1] + int2str(THIPrint_Text(FItem)._prop_BackColor) +
      '|' + int2str(THIPrint_Text(FItem)._prop_Vertical) +
      _prop_Delimiter[1] + int2str(THIPrint_Text(FItem)._prop_Horizontal) +
      '|' + int2str(THIPrint_Text(FItem)._prop_Left) +
      _prop_Delimiter[1] + int2str(THIPrint_Text(FItem)._prop_Top) +
      _prop_Delimiter[1] + int2str(THIPrint_Text(FItem)._prop_Right) +
      _prop_Delimiter[1] + int2str(THIPrint_Text(FItem)._prop_Bottom);                                           
      _hi_onEvent(_event_onEnum, Parameters);
    end;  
  end;
  _hi_onEvent(_event_onEndEnum);
end;

end.