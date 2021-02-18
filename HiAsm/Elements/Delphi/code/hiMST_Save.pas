unit hiMST_Save;

interface

uses
  Kol, Share, Debug, hiMTStrTbl, CodePages;
  
type
  THIMST_Save = class(TDebug)
    private
      FCharset: Integer;
      Stream: PStream;
      _Dlm: Char;
      
      procedure SetCharset(Value: Byte);
      procedure SaveToStream(var FS: PStream);
      procedure SetDlm(dlm: string);   
    public
      _prop_MSTControl: IMSTControl;

      _prop_FileName: string;
      _prop_SaveColProp: Boolean;
      _prop_SaveColumn: Boolean;
      _prop_SaveCheckBoxes: Boolean;
      _prop_OutBOM: Byte;

      _data_FileName: THI_Event;
      _event_onSave: THI_Event;
      _event_onSaveToStream: THI_Event;
      
      property _prop_Delimiter: string write SetDlm;
      property _prop_Charset: Byte write SetCharset;
      
      constructor Create;
      destructor Destroy; override;
      
      procedure _work_doSave(var _Data: TData; Index: Word);
      procedure _work_doSaveToStream(var _Data: TData; Index: Word);
      
      procedure _work_doDelimiter(var _Data: TData; Index: Word);
      procedure _work_doCharset(var _Data: TData; Index: Word);
      procedure _work_doOutBOM(var _Data: TData; Index: Word);
      
      procedure _var_Stream(var _Data: TData; Index: Word);
  end;

implementation

constructor THIMST_Save.Create;
begin
  inherited;
  Stream := NewMemoryStream;
  FCharset := DefaultCompilerCP;
  _prop_OutBOM := 1;
end;

destructor THIMST_Save.Destroy;
begin
  Stream.free;
  inherited;
end;

procedure THIMST_Save.SetDlm(dlm: string);
begin
  if dlm = '' then
    _Dlm := ' '
  else  
    _Dlm := dlm[1];
end;

procedure THIMST_Save.SetCharset(Value: Byte);
begin
  FCharset := OutCharsetPropText[Value];
end;


procedure THIMST_Save.SaveToStream(var FS: PStream);
var
  sControl: PControl;
  i: integer;
  s: string;
  d: PData;
  dt: TData;
  SList: PKOLStrList;
begin
  if not Assigned(_prop_MSTControl) then exit;
  sControl := _prop_MSTControl.ctrlpoint;
  
  SList := NewKOLStrList;
  dtNull(dt);
  
  if (_prop_MSTControl.clistcount <> 0) and _prop_SaveColumn then
  begin
    s := '';
    if _prop_SaveColProp then
      for i := 0 to _prop_MSTControl.clistcount - 1 do
        s := s + _prop_MSTControl.clistitems(i) + _Dlm
    else
      for i := 0 to _prop_MSTControl.clistcount - 1 do
        s := s + sControl.LVColText[i] + _Dlm;   
    deleteTail(s, 1);
    SList.Add(s);
  end;

  if sControl.Count <> 0 then
  begin
    for i := 0 to sControl.Count - 1 do
    begin
      dt := _prop_MSTControl.getstring(i);
      d := @dt;
      if _prop_SaveCheckBoxes then
        s := int2str(sControl.LVItemStateImgIdx[i] - 1) + _Dlm
      else   
        s := '';
      while (d <> nil) and not _IsNULL(d^) do
      begin
        s := s + Share.ToString(d^) + _Dlm;
        d := d.ldata;
      end;  
      deleteTail(s, 1);
      SList.Add(s);
    end;
  end;
  
  StrListSaveToStream(SList, Fs, FCharset, (_prop_OutBOM <> 0));
  SList.Free;
end; 

procedure THIMST_Save._work_doSave(var _Data: TData; Index: Word);
var
  Strm: PStream;
begin
  Strm := NewWriteFileStream(ReadString(_Data,_data_FileName,_prop_FileName));
  SaveToStream(Strm);
  Free_And_Nil(Strm);
  _hi_onEvent(_event_onSave);
end;

procedure THIMST_Save._work_doSaveToStream(var _Data: TData; Index: Word);
begin
  Stream.Size := 0;
  SaveToStream(Stream);
  Stream.Position := 0;
  _hi_onEvent(_event_onSaveToStream, Stream);
end;

procedure THIMST_Save._work_doDelimiter(var _Data: TData; Index: Word);
begin
  SetDlm(Share.ToString(_Data));
end;

procedure THIMST_Save._work_doCharset(var _Data: TData; Index: Word);
begin
  FCharset := ToInteger(_Data);
end;

procedure THIMST_Save._work_doOutBOM(var _Data: TData; Index: Word);
begin
  _prop_OutBOM := ToInteger(_Data) and 1;
end;

procedure THIMST_Save._var_Stream;
begin
  dtStream(_Data, Stream);
end;

end.