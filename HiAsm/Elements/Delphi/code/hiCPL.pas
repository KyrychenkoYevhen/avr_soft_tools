unit hiCPL;

interface

uses Windows, Kol, Share;

type
  TNewCPLInfo = record
    dwSize:        DWORD;   // similar to the commdlg
    dwFlags:       DWORD;
    dwHelpContext: DWORD;   // help context to use
    lData:         Longint; // user defined data
    hIcon:         HICON;   // icon to use, this is owned by CONTROL.EXE (may be deleted)
    szName:        array[0..31] of Char;    // short name
    szInfo:        array[0..63] of Char;    // long name (status line)
    szHelpFile:    array[0..127] of Char;   // path to help file to use
  end;
  PNewCPLInfo = ^TNewCPLInfo;
  
  THICPL = class
    private
    public
      _prop_Name: string;
      _prop_Info: string;
      _prop_Icon: HICON;

      _event_onExec: THI_Event;
      _event_onStart: THI_Event;

      procedure Exec;
      procedure SetInfo(var Info: PNewCPLInfo);
  end;

implementation

procedure THICPL.Exec;
begin
  _hi_OnEvent(_event_onExec);
end;

procedure THICPL.SetInfo(var Info: PNewCPLInfo);
begin
  EventOn;
  with Info^ do
  begin
    dwSize := SizeOf(TNewCPLInfo);
    dwFlags := 0;
    dwHelpContext := 0;
    lData := 0;
    hIcon := _prop_Icon;
    StrCopy(@szName, PChar(_prop_Name));
    StrCopy(@szInfo, PChar(_prop_Info));
    szHelpFile := '';
  end;
  _hi_OnEvent(_event_onStart);
end;

end.
