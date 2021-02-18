unit hiDLL;

interface

uses Windows,Kol,Share,Debug;

type
  T_hi_dllInitProc = procedure(var _Data:TData; Index:word; DLL_Param:pointer);
  T_hi_dllProc = procedure (var Data:TData; Index:word;_Param:pointer);
  T_hi_DllInit = procedure (_onEvent,GetData:T_hi_dllProc; _Param:pointer; var DLL_Param:pointer);
  THIDLL = class(TDebug)
   private
     FECount,FDCount:PKOLStrList;
     //WP,VP:PKOLStrList;

     procedure SetEvent(const value:string);
     procedure SetData(const value:string);
     procedure SetWP(const value:string);
     procedure SetVP(const value:string);
   public
     _prop_Icon:HICON;
     _event_EventPoints:array of THI_Event;
     _data_DataPoints:array of THI_Event;

     DLL_Param:pointer; // ��������� ���� DLL ����� �������� ����������

     onEvent,GetData:T_hi_dllInitProc;

     constructor Create;
     procedure doWork(var Data:TData; Index:word);
     procedure GetVar(var Data:TData; Index:word);

     procedure _work_WorkPoints(var Data:TData; Index:word);
     procedure _var_VarPoints(var Data:TData; Index:word);

     property _prop_EventPoints:string write SetEvent;
     property _prop_DataPoints:string write SetData;
     property _prop_WorkPoints:string write SetWP;
     property _prop_VarPoints:string write SetVP;
  end;

implementation
   {
function THIDLL._OnEvent;
var Ind:integer;
begin
   Ind := ReadPointIndex(FECount,Args[0]);
   if(ind >= 0)and(Ind < FECount.Count)then
    _hi_OnEvent(_event_EventPoints[Ind],Args[1]^);
end;

function THIDLL._GetData;
var Ind:integer;
begin
   Ind := ReadPointIndex(FDCount,Args[0]);
   if(ind >= 0)and(Ind < FDCount.Count)then
    _ReadData(Result,_data_DataPoints[Ind]);
end;  }

constructor THIDLL.Create;
begin
  inherited;
  EventOn;
end;

procedure THIDLL.SetEvent;
begin
   FECount := NewKOLStrList;
   FECount.text := Value;
   SetLength(_event_EventPoints,FECount.Count);
   //_debug(Value);
end;

procedure THIDLL.SetData;
begin
   FDCount := NewKOLStrList;
   FDCount.text := Value;
   SetLength(_data_DataPoints,FDCount.Count);
end;

procedure THIDLL.SetWP;
begin
   //WP := NewKOLStrList;
   //WP.Text := Value;
end;

procedure THIDLL.SetVP;
begin
   //VP := NewKOLStrList;
   //VP.Text := Value;
end;

procedure THIDLL.doWork;
begin
   if Index < FECount.Count then
    _hi_OnEvent(_event_EventPoints[Index],Data);
   dtNull(Data);
   data.sdata := '';
end;

procedure THIDLL.GetVar;
begin
   if Index < FDCount.Count then
    _ReadData(Data,_data_DataPoints[Index]);
end;

procedure THIDLL._work_WorkPoints(var Data:TData; Index:word);
begin
   onEvent(Data,Index,DLL_Param);
end;

procedure THIDLL._var_VarPoints(var Data:TData; Index:word);
begin
   GetData(Data,Index,DLL_Param);
end;

end.

