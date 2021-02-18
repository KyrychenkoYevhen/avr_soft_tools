unit hiRGN_Rotate;

interface

uses Windows,Kol,Share,Debug;

type
  THIRGN_Rotate = class(TDebug)
   private
    FRegion:HRGN;
   public
    _prop_Angle:integer;
    _prop_Mode:byte; 
    
    _data_Angle:THI_Event;
    _data_Region:THI_Event;
    _event_onRotate:THI_Event;

    destructor Destroy; override;
    procedure _work_doRotate(var _Data:TData; Index:word);
    procedure _work_doClear(var _Data:TData; Index:word);
    procedure _work_doMode(var _Data: TData; Index: Word);
    procedure _var_Result(var _Data:TData; Index:word);
  end;

implementation

destructor THIRGN_Rotate.Destroy;
begin
    DeleteObject(FRegion);
    inherited;
end;

procedure THIRGN_Rotate._work_doRotate;
var r: TRect;
    rgn: HRGN;
    Size: DWORD;
    wXFORM: XFORM;
    a: integer;
    RgnData: PRgnData;
begin
    rgn := ReadInteger(_Data, _data_Region);   
    a := ReadInteger(_Data, _data_Angle,_prop_Angle);  
    if rgn = 0 then exit;
    if a = 0 then
     begin
      DeleteObject(FRegion);
      FRegion := CreateRectRgn(0, 0, 0, 0);
      CombineRgn(FRegion, rgn, 0, RGN_Copy);
      _hi_onEvent(_event_onRotate, integer(FRegion));
      exit;
     end; 
    GetRgnBox(rgn, r);                                     // �������� ������������� �������
    case _prop_Mode of
     0: begin                                              // �����
         r.Left :=r.Left + (r.Right -r.Left) div 2;
         r.Top :=  r.Top + (r.Bottom-r.Top) div 2;
        end;
     2: r.Left := r.Left+(r.Right -r.Left);                // ������ ������� ����
     3: begin                                              // ������ ������ ����
         r.Left := r.Left+(r.Right -r.Left);
         r.Top := r.Top +(r.Bottom-r.Top);
        end;
     4: r.Top := r.Top +(r.Bottom-r.Top);                  // ����� ������ ����
    end;
    OffsetRgn(rgn, -r.Left, -r.Top);                       // ��������� ������ 
    FillChar(wXFORM, SizeOf(wXFORM), #0);                  // ��������� ��������� XFORM
    wXFORM.eM11 := Cos(a/180*pi);
    wXFORM.eM12 := -Sin(a/180*pi);
    wXFORM.eM21 := -wXFORM.eM12;
    wXFORM.eM22 := wXFORM.eM11;
    Size := GetRegionData(rgn, 0, nil);                    // �������� ������ ������ ��� �������
    GetMem(RgnData, SizeOf(RGNDATA) * Size);               // �������� ������ ��� ������ �������
    GetRegionData(rgn, Size, RgnData);                     // ������ ������� ��������� � ���������� ������
    DeleteObject(FRegion);                                 // ������� ����� ��������� ������
    FRegion := ExtCreateRegion(@wXFORM, Size, RgnData^);   // ������� ������ ��������� ������ ������� � ��������� XFORM
    OffsetRgn(rgn, r.Left, r.Top);                         // ������ ������������ � �������� ���������
    OffsetRgn(FRegion, r.Left, r.Top);                     // ��������� ������ ���������� � ��������� ��������� �������
    FreeMem(RgnData);                                      // ����������� ������ ������ �������
    _hi_onEvent(_event_onRotate, integer(FRegion));
end;

procedure THIRGN_Rotate._work_doClear;
begin
    DeleteObject(FRegion);
    FRegion := 0;
end;

procedure  THIRGN_Rotate._work_doMode;
begin
    _prop_Mode := ToInteger(_Data);
    if (_prop_Mode < 0) or (_prop_Mode > 4) then
     _prop_Mode := 0;
end;

procedure THIRGN_Rotate._var_Result;
begin
    dtInteger(_Data, FRegion);
end;

end.