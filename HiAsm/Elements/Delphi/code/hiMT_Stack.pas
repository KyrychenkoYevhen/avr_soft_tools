unit hiMT_Stack; { ��������� MT_Stack (���� ����������� �������) ver 1.60 }

interface

uses Kol,Share,Debug;

type
  THIMT_Stack = class(TDebug)
   private
    FData:TData;
    FList:PList;
   public
    _prop_IgnorEmpty:boolean;
    _data_Data:THI_Event;
    _event_onPush:THI_Event;
    _event_onPop:THI_Event;
    _event_onEmpty:THI_Event;

    constructor Create;
    destructor Destroy; override;
    procedure _work_doPush(var _Data:TData; Index:word);
    procedure _work_doPop(var _Data:TData; Index:word);
    procedure _work_doClear(var _Data:TData; Index:word);
    procedure _var_Value(var _Data:TData; Index:word);
    procedure _var_Peek(var _Data:TData; Index:word);    
  end;

implementation

constructor THIMT_Stack.Create;
begin
  inherited;
  FList := newlist;
end;

destructor THIMT_Stack.Destroy;
var   i:integer;
begin
   for i := 0 to FList.Count-1 do begin 
      FreeData(PData(FList.Items[i]));
      dispose(PData(FList.Items[i]));
   end;
   FreeData(@FData);
   FList.Free;
   inherited;
end;

procedure THIMT_Stack._work_doPush;
var   dt:PData;
begin
   FreeData(@FData);
   FData := ReadMTData(_data,_data_Data);
   CopyData(@FData,@FData);                                 // �������� ������� ������
   new(dt);
   CopyData(dt,@FData);
   FList.Add(dt);
   _hi_CreateEvent_(_Data,@_event_onPush);
end;

procedure THIMT_Stack._work_doPop;
begin
   FreeData(@FData);
   dtNull(FData);
   if FList.Count > 0 then begin
      CopyData(@FData, PData(FList.Items[FList.Count-1]));  // �������� MT-����� �� ���������
      FreeData(PData(FList.Items[FList.Count-1]));          // ������� ���������� ���������
      dispose(PData(FList.Items[FList.Count-1]));           // �����������, ���������� ��� ��������, ������ 
      FList.Delete(FList.Count-1)                           // ������ ������ �� ��������
   end else if _prop_IgnorEmpty then begin
      _hi_CreateEvent(_Data,@_event_onEmpty);
      exit;
   end;
   _hi_CreateEvent(_Data,@_event_onPop, FData);
end;  

procedure THIMT_Stack._work_doClear;
var   i:integer;
begin
   for i := 0 to FList.Count-1 do begin 
      FreeData(PData(FList.Items[i]));
      dispose(PData(FList.Items[i]));
   end;
   FList.Clear;
   FreeData(@FData);
   dtNull(FData);    
end;

procedure THIMT_Stack._var_Value;
begin
   _Data := FData;
end;

procedure THIMT_Stack._var_Peek;
begin
   if FList.Count > 0 then
      _Data := PData(FList.Items[FList.Count-1])^
   else
      dtNull(_Data);
end;

end.
