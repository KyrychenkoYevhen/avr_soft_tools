// Made by nesco
//
unit hiTableToRTF;

interface

uses
  Windows, KOL, Share, Debug;

type

  THiTableToRTF = class(TDebug)
    private
      rtfTable: string;
    public
      _data_StringTable: THI_Event;
      _event_onTableToRTF: THI_Event;
      procedure _work_doTableToRTF(var _Data: TData; Index: Word);
      procedure _var_RTFTable(var _Data: TData; Index: Word);
 end;

implementation

function RTFEncode(Text: string): string;
var
  i: Integer;
  C: Char;
begin
  Result := '';
  if Text = '' then exit;
  for i := 1 to Length(Text) do
  begin
    C := Text[i];
    if Ord(C) > 127 then
      {$ifdef UNICODE}
      Result := Result + '\u' + Int2Str(SmallInt(C)) + '?'
      {$else}
      Result := Result + '\''' + LowerCase(Int2Hex(Ord(C), 2))
      {$endif}
    else
      if C in ['\', '{', '}'] then
        Result := Result + '\' + C
      else
        Result := Result + C;
  end;
end;

procedure THiTableToRTF._work_doTableToRTF;
var
  sControl: PControl;
  Kx : Real;
  CellMargin: string;
  FontSize: string;
  IncCellWidth: Integer;
  Col, Row: Integer;
  fFrom: TRGB;
begin
  sControl := ReadControl(_data_StringTable, 'StringTable');
  if not Assigned(sControl) then exit;
  
  Kx := 1440 / GetDeviceCaps(sControl.Canvas.Handle, LOGPIXELSX);
  CellMargin := Int2Str(Round(Int(2 * Kx)));
  FontSize := Int2Str(Round(2 * ((sControl.Font.FontHeight * -72) - 36) / GetDeviceCaps(sControl.Canvas.Handle,LOGPIXELSY)));
  
  rtfTable :=  '{\rtf1\ansi'{$ifndef UNICODE}+'\ansicpg'+Int2Str(DefaultSystemCodePage){$endif}+#13#10 + '{\*\generator RTF-table 1.05;}'#13#10 +
               '{\fonttbl{\f0\fcharset' + Int2Str(sControl.Font.FontCharset) + '\fname ' + sControl.Font.FontName + ';}}'#13#10;

  fFrom := TRGB(Color2RGB(clSilver));
  rtfTable := rtfTable + '{\colortbl ;\red' + Int2Str(fFrom.R) + '\green' + Int2Str(fFrom.G) +
                         '\blue' + Int2Str(fFrom.B) + ';}' + #13#10;

  rtfTable := rtfTable + '\trowd\f0\fs' + FontSize + '\trgaph' + CellMargin + 
                        '\trbrdrt\brdrs\brdrw10\trbrdrl\brdrs\brdrw10\trbrdrb\brdrs\brdrw10\trbrdrr\brdrs\brdrw10'#13#10;

  IncCellWidth := 0;
  for Col := 0 to sControl.LVColCount - 1 do begin
    IncCellWidth := Round(Int(IncCellWidth + sControl.LVColWidth[Col] * Kx));
    rtfTable := rtfTable + '\clcbpat1\clbrdrt\brdrw15\brdrs\clbrdrl\brdrw15\brdrs\clbrdrb\brdrw15\brdrs\clbrdrr\brdrw15\brdrs\cellx' + Int2Str(IncCellWidth) + #13#10;
  end;
  rtfTable := rtfTable + '\pard'#13#10 + '\intbl\highlight1\b'#13#10; 

  for Col := 0 to sControl.LVColCount - 1 do
    rtfTable := rtfTable + RTFEncode(sControl.LVColText[Col]) + '\cell'#13#10;
  rtfTable := rtfTable + '\highlight0\b0\row'#13#10;
  
  for Row := 0 to sControl.LVCount - 1 do
  begin
    rtfTable := rtfTable + '\trowd\f0\fs' + FontSize + '\trgaph' + CellMargin + 
                           '\trbrdrt\brdrs\brdrw10\trbrdrl\brdrs\brdrw10\trbrdrb\brdrs\brdrw10\trbrdrr\brdrs\brdrw10'#13#10;

    IncCellWidth := 0;
    for Col := 0 to sControl.LVColCount - 1 do begin
      IncCellWidth := Round(Int(IncCellWidth + sControl.LVColWidth[Col] * Kx));
      rtfTable := rtfTable + '\clbrdrt\brdrw15\brdrs\clbrdrl\brdrw15\brdrs\clbrdrb\brdrw15\brdrs\clbrdrr\brdrw15\brdrs\cellx' + Int2Str(IncCellWidth) + #13#10;
    end;
    rtfTable := rtfTable + '\pard'#13#10; 

    rtfTable := rtfTable + '\intbl'#13#10;
    for Col := 0 to sControl.LVColCount - 1 do
      rtfTable := rtfTable + RTFEncode(sControl.LVItems[Row, Col]) + '\cell'#13#10;
    rtfTable := rtfTable + '\row'#13#10;
  end;
  rtfTable := rtfTable + '}';

  _hi_OnEvent(_event_onTableToRTF, rtfTable);
end;

procedure THiTableToRTF._var_RTFTable;
begin
  dtString(_Data, rtfTable);
end;

end.