unit hiStrList;

interface

uses
  Kol, Share, Debug, CodePages;

type
  THIStrList = class(TDebug)
    private
      FList: PKOLStrList;
      Arr: PArray;
      FIndex: Integer;
      FString: string;
      FInCharset: Integer;
      FOutCharset: Integer;
      
      procedure SetInCharset(Value: Byte);
      procedure SetOutCharset(Value: Byte);
      procedure SetText(const Value: string);
      
      procedure _Set(var Item: TData; var Val: TData);
      function _Get(var Item: TData; var Val: TData): Boolean;
      function _Count: Integer;
      procedure _Add(var Val: TData);
   
    public
      _prop_FileName: string;
      _prop_AddType: Byte;
      _prop_OutBOM: Byte;

      _data_FileName: THI_Event;
      _data_Str: THI_Event;
      _data_StrToFind: THI_Event;
      _data_IdxToSelect: THI_Event;
      _data_IdxCur: THI_Event;
      _data_IdxNew: THI_Event;
      _data_Idx1: THI_Event;
      _data_Idx2: THI_Event;
      _data_Stream: THI_Event;
      
      _event_onChange: THI_Event;
      _event_onGetIndex: THI_Event;
      _event_onGetString: THI_Event;
      
      property _prop_InCharset: Byte write SetInCharset;
      property _prop_OutCharset: Byte write SetOutCharset;
      property _prop_Strings: string write SetText;

      constructor Create;
      destructor Destroy; override;
      
      procedure _work_doAdd0(var _Data: TData; Index: Word);
      procedure _work_doAdd1(var _Data: TData; Index: Word);    
      procedure _work_doClear(var _Data: TData; Index: Word);
      procedure _work_doDelete(var _Data: TData; Index: Word);
      procedure _work_doReplace(var _Data: TData; Index: Word);
      procedure _work_doMove(var _Data: TData; Index: Word);
      procedure _work_doSwap(var _Data: TData; Index: Word);        
      procedure _work_doText(var _Data: TData; Index: Word);
      procedure _work_doLoad(var _Data: TData; Index: Word);
      procedure _work_doSave(var _Data: TData; Index: Word);
      procedure _work_doLoadFromStream(var _Data: TData; Index: Word);
      procedure _work_doSaveToStream(var _Data: TData; Index: Word);
      procedure _work_doAppend(var _Data: TData; Index: Word);
      procedure _work_doAppendText(var _Data: TData; Index: Word);    
      procedure _work_doSort(var _Data: TData; Index: Word);
      procedure _work_doInsert(var _Data: TData; Index: Word);
      procedure _work_doGetIndex(var _Data: TData; Index: Word);
      procedure _work_doGetString(var _Data: TData; Index: Word);
      
      procedure _work_doInCharset(var _Data: TData; Index: Word);
      procedure _work_doOutCharset(var _Data: TData; Index: Word);
      procedure _work_doOutBOM(var _Data: TData; Index: Word);
      
      procedure _var_Text(var _Data: TData; Index: Word);
      procedure _var_Count(var _Data: TData; Index: Word);
      procedure _var_EndIdx(var _Data: TData; Index: Word);    
      procedure _var_Array(var _Data: TData; Index: Word);
      procedure _var_Index(var _Data: TData; Index: Word);
      procedure _var_String(var _Data: TData; Index: Word);
  end;

implementation

constructor THIStrList.Create;
begin
  inherited Create;
  FList := NewKOLStrList;
  FIndex := -1;
  
  FInCharset := DefaultCompilerCP;
  FOutCharset := DefaultCompilerCP;
  _prop_OutBOM := 1;
end;

destructor THIStrList.Destroy;
begin
  FList.Free;
  if Arr <> nil then Dispose(Arr);
  inherited Destroy;
end;

procedure THIStrList.SetInCharset(Value: Byte);
begin
  FInCharset := InCharsetPropText[Value];
end;

procedure THIStrList.SetOutCharset(Value: Byte);
begin
  FOutCharset := OutCharsetPropText[Value];
end;

procedure THIStrList.SetText(const Value: string);
begin
  //Flist.Text := Value; // Почему?
  FList.SetText(Value{$ifndef UNICODE}, False{$endif});
end;

procedure THIStrList._work_doAdd0(var _Data: TData; Index: Word);
begin
  FList.Add(ReadString(_Data, _data_Str, ''));
  _hi_CreateEvent(_Data, @_event_onChange);
end;

procedure THIStrList._work_doAdd1(var _Data: TData; Index: Word);
begin
  FList.Insert(0,ReadString(_Data, _data_Str, ''));
  _hi_CreateEvent(_Data, @_event_onChange);
end;

procedure THIStrList._work_doClear(var _Data: TData; Index: Word);
begin
  FList.Clear;
  _hi_CreateEvent(_Data, @_event_onChange);
end;

procedure THIStrList._work_doDelete(var _Data: TData; Index: Word);
var
  Ind: Integer;
begin
  Ind := ToIntIndex(_Data);
  if (Ind < 0) or (Ind > FList.Count - 1) then Exit;
  FList.Delete(Ind);
  _hi_CreateEvent(_Data, @_event_onChange);
end;

procedure THIStrList._work_doInsert(var _Data: TData; Index: Word);
var
  Ind: Integer;
begin
  Ind := ToIntIndex(_Data);
  if (Ind < -1) or (Ind > FList.Count) then Exit;
  if Ind = -1 then Ind := FList.Count; 
  FList.Insert(Ind, ReadString(_Data, _data_Str, ''));
  _hi_CreateEvent(_Data, @_event_onChange);
end;

procedure THIStrList._work_doReplace(var _Data: TData; Index: Word);
var
  Ind: Integer;
begin
  Ind := ToIntIndex(_Data);
  if (Ind < 0) or (Ind > FList.Count - 1) then Exit;
  FList.Delete(Ind);
  FList.Insert(Ind, ReadString(_Data, _data_Str, ''));   
  _hi_CreateEvent(_Data, @_event_onChange);
end;

procedure THIStrList._work_doMove(var _Data: TData; Index: Word);
var
  Ind1, Ind2 :integer;
begin
  Ind1 := ReadInteger(_Data, _data_IdxCur);
  Ind2 := ReadInteger(_Data, _data_IdxNew);
  if (Ind1 < 0) or (Ind1 > FList.Count - 1) or (Ind2 < 0) or (Ind2 > FList.Count - 1) then Exit;
  FList.Move(Ind1, Ind2);
  _hi_CreateEvent(_Data, @_event_onChange);
end;

procedure THIStrList._work_doSwap(var _Data: TData; Index: Word);
var
  Ind1, Ind2 :integer;
begin
  Ind1 := ReadInteger(_Data, _data_Idx1);
  Ind2 := ReadInteger(_Data, _data_Idx2);
  if (Ind1 < 0) or (Ind1 > FList.Count - 1) or (Ind2 < 0) or (Ind2 > FList.Count - 1) then Exit;
  FList.Swap(Ind1, Ind2);
  _hi_CreateEvent(_Data, @_event_onChange);
end;

procedure THIStrList._work_doText(var _Data: TData; Index: Word);
begin
  //FList.Text := ReadString(_Data,_data_Str,'');
  FList.SetText(ReadString(_Data,_data_Str){$ifndef UNICODE}, False{$endif});
  _hi_CreateEvent(_Data, @_event_onChange);
end;

procedure THIStrList._work_doLoad(var _Data: TData; Index: Word);
var
  FN: string;
begin
  FN := ReadString(_Data, _data_FileName, _prop_FileName);
  
  if StrListLoadFromFile(FList, FN, FInCharset) then
    _hi_CreateEvent(_Data, @_event_onChange);
end;

procedure THIStrList._work_doSave(var _Data: TData; Index: Word);
var
  FN: string;
begin
  FN := ReadString(_Data, _data_FileName, _prop_FileName);
  StrListSaveToFile(FList, FN, FOutCharset, (_prop_OutBOM <> 0));
end;

procedure THIStrList._work_doLoadFromStream(var _Data: TData; Index: Word);
var
  st: PStream;
begin
  st := ReadStream(_Data, _data_Stream);
  if st = nil then Exit;
  StrListLoadFromStream(FList, st, (st.Size - st.Position), FInCharset);
  _hi_CreateEvent(_Data, @_event_onChange);
end;

procedure THIStrList._work_doSaveToStream(var _Data: TData; Index: Word);
var
  st: PStream;
begin
  st := ReadStream(_Data, _data_Stream);
  if st = nil then Exit;
  
  StrListSaveToStream(FList, st, FOutCharset, (_prop_OutBOM <> 0));
end;

procedure THIStrList._work_doAppend(var _Data: TData; Index: Word);
var
  FN: string;
begin
  FN := ReadString(_Data, _data_FileName, _prop_FileName);
  StrListSaveToFile(FList, FN, FOutCharset, (_prop_OutBOM <> 0), True);
end;

procedure THIStrList._work_doAppendText(var _Data: TData; Index: Word);
begin
  {$ifdef UNICODE}
    // KOL.TWStrList.SetText нет дополнительного параметра для добавления
    FList.Text := FList.Text + ReadString(_Data, _data_Str);
  {$else}
  FList.SetText(ReadString(_Data, _data_Str), True);
  {$endif}
  
  _hi_CreateEvent(_Data, @_event_onChange);   
end;

procedure THIStrList._work_doGetIndex(var _Data: TData; Index: Word);
begin
  FIndex := FList.IndexOf(ReadString(_Data, _data_StrToFind)); 
  FString := FList.Items[FIndex];
  _hi_CreateEvent(_Data, @_event_onGetIndex, FIndex);
end;

procedure THIStrList._work_doGetString(var _Data: TData; Index: Word);
begin
  FIndex := ReadInteger(_Data, _data_IdxToSelect);
  FString := FList.Items[FIndex];     
  if (FIndex < 0) or (FIndex >= Flist.Count) then FIndex := -1;
  _hi_CreateEvent(_Data, @_event_onGetString, FString);
end;

procedure THIStrList._work_doSort(var _Data: TData; Index: Word);
begin
  FList.Sort(false);
end;


procedure THIStrList._work_doInCharset(var _Data: TData; Index: Word);
begin
  FInCharset := ToInteger(_Data);
end;

procedure THIStrList._work_doOutCharset(var _Data: TData; Index: Word);
begin
  FOutCharset := ToInteger(_Data);
end;

procedure THIStrList._work_doOutBOM(var _Data: TData; Index: Word);
begin
  _prop_OutBOM := ToInteger(_Data) and 1;
end;


procedure THIStrList._var_Text(var _Data: TData; Index: Word);
begin
  dtString(_Data,FList.Text);
end;

procedure THIStrList._var_Count(var _Data: TData; Index: Word);
begin
  dtInteger(_Data,FList.Count);
end;

procedure THIStrList._var_EndIdx(var _Data: TData; Index: Word);
begin
  dtInteger(_Data, FList.Count - 1);
end;

procedure THIStrList._var_Index(var _Data: TData; Index: Word);
begin
  dtInteger(_Data,FIndex);
end;

procedure THIStrList._var_String(var _Data: TData; Index: Word);
begin
  dtString(_Data,FString);
end;

procedure THIStrList._var_Array(var _Data: TData; Index: Word);
begin
  if Arr = nil then Arr := CreateArray(_Set, _Get, _Count, _Add);
  dtArray(_Data,Arr);
end;

procedure THIStrList._Set(var Item: TData; var Val: TData);
var
  Ind: Integer;
begin
  Ind := ToIntIndex(Item);
  if (Ind >= 0) and (Ind < FList.Count) then
    FList.Items[Ind] := Share.ToString(Val);
end;

procedure THIStrList._Add(var Val: TData);
begin
  FList.Add(Share.ToString(Val));
end;

function THIStrList._Get(var Item: TData; var Val: TData): Boolean;
var
  Ind: Integer;
begin
  Ind := ToIntIndex(Item);
  if (Ind >= 0) and (Ind < FList.Count) then
  begin
    Result := True;
    dtString(Val, FList.Items[Ind]);
  end
  else
    Result := False;
end;

function THIStrList._Count: Integer;
begin
  Result := FList.Count;
end;

end.