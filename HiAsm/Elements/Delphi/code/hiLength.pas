unit hiLength;

interface

uses
  Kol, Share, Debug;

type
  ThiLength = class(TDebug)
    private
      FResult: Integer;
    public  
      _data_Str: THI_Event;
      _event_onLength: THI_Event;

      procedure _work_doLength(var _Data: TData; Index: Word);
      procedure _work_doBinaryLength(var _Data: TData; Index: Word);
      procedure _var_Result(var _Data: TData; Index: Word);
      procedure _var_CharSize(var _Data: TData; Index: Word);
  end;

implementation

procedure ThiLength._work_doLength(var _Data: TData; Index: Word);
begin
  FResult := Length(ReadString(_Data, _data_Str, ''));
  _hi_CreateEvent(_Data, @_event_onLength, FResult);
end;

procedure ThiLength._work_doBinaryLength(var _Data: TData; Index: Word);
begin
  {$ifdef UNICODE}
  FResult := BinaryLength(ReadString(_Data, _data_Str, ''));
  {$else}
  FResult := Length(ReadString(_Data, _data_Str, ''));
  {$endif}
  _hi_CreateEvent(_Data, @_event_onLength, FResult);
end;

procedure ThiLength._var_Result(var _Data: TData; Index: Word);
begin
  dtInteger(_Data, FResult);
end;

procedure ThiLength._var_CharSize(var _Data: TData; Index: Word);
begin
  dtInteger(_Data, SizeOf(Char))
end;


end.