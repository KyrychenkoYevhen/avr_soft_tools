unit hiSplitter;

interface

uses Windows, Kol, Share, Win;

type
  THISplitter = class(THIWin)
   private
   public
    _prop_ResizeStyle:byte;
    _prop_Beveled:byte;

    procedure Init; override;
  end;

implementation

procedure THISplitter.Init;
begin
   Control := NewSplitter(FParent,0,0);
   inherited;

   if _prop_Beveled = 1 then
    //Control.Style := Control.Style and not SS_SUNKEN and not WS_BORDER
    Control.ExStyle := 0;
   //else Control.Style := Control.Style or SS_SUNKEN;

   if _prop_Align in [caTop,caBottom] then
     Control.CursorLoad(0, MakeIntResource(crSizeNS))
   else
     Control.CursorLoad(0, MakeIntResource(crSizeWE));
end;

end.