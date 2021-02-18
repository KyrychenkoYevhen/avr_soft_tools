unit hiCopy;

interface

uses
  Kol, Share, Debug;

type
  ThiCopy = class(TDebug)
    private
    public
      _prop_Position: Integer;
      _prop_Count: Integer;
      _prop_Direction: Byte;

      _data_Count: THI_Event;
      _data_Position: THI_Event;
      _data_Str: THI_Event;
      _event_onCopy: THI_Event;

      procedure _work_doCopy(var _Data: TData; Index: Word);
      procedure _work_doCopyBinary(var _Data: TData; Index: Word);
  end;

implementation

procedure ThiCopy._work_doCopy(var _Data: TData; Index: Word);
var
  Str: string;
  Pos, Count: Integer;
begin
  Str := ReadString(_Data, _data_Str, '');
  Pos := ReadInteger(_Data, _data_Position, _prop_Position); 
  Count := ReadInteger(_Data, _data_Count, _prop_Count);
  
  if _prop_Direction = 1 then
    Pos := Length(Str) - Count - Pos + 2;
  
  // Если позиция отрицательная - уменьшаем Count (?)
  if Pos <= 0 then
  begin 
    Inc(Count, Pos-1);
    Pos := 1;
  end;
  
  _hi_CreateEvent(_Data, @_event_onCopy, Copy(Str, Pos, Count));
end;

procedure ThiCopy._work_doCopyBinary(var _Data: TData; Index: Word);
{$ifdef UNICODE}
var
  Str, Rslt: string;
  Pos, Count, L: Integer;
begin
  Rslt := '';
  Str := ReadString(_Data, _data_Str, '');
  Pos := ReadInteger(_Data, _data_Position, _prop_Position); 
  Count := ReadInteger(_Data, _data_Count, _prop_Count);
  
  
  L := BinaryLength(Str);
  if Pos < 1 then Pos := 1;
  Dec(Pos); // Работаем с 0-based индексом
  if Count > (L - Pos) then Count := L - Pos;
  
  if _prop_Direction = 1 then
    Pos := L - Count - Pos;
  
  if (Count > 0) and (Pos < L) then
  begin 
    SetLength(Rslt, BinaryStrSize(Count));
    Move(Pointer(NativeInt(Pointer(Str)) + Pos)^, Rslt[1], Count);
    PadBinaryBuf(Pointer(Rslt), Count);
  end;
  
  _hi_CreateEvent(_Data, @_event_onCopy, Rslt);
end;
{$else}
begin
  _work_doCopy(_Data, Index);
end;
{$endif}

end.
