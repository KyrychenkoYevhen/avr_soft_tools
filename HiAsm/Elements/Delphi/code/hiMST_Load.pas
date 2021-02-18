unit hiMST_Load;

interface

uses
  Kol, Share, Debug, hiMTStrTbl, CodePages;

type
  THIMST_Load = class(TDebug)
  private
    FCharset: Integer;
    _Dlm: Char;
    procedure SetCharset(Value: Byte);
    procedure LoadFromStream(var FS: PStream);
    procedure SetDlm(dlm: string);    
  public
    _prop_MSTControl: IMSTControl;

    _prop_FileName: string;
    _prop_ColNameHeader: boolean;
    _prop_LoadCheckBoxes: boolean;      

    _data_FileName,
    _data_Stream,
    _event_onLoad,
    _event_onLoadFromStream: THI_Event;
    
    property _prop_Delimiter: string write SetDlm;
    property _prop_Charset: Byte write SetCharset;
    
    constructor Create;
    
    procedure _work_doLoad(var _Data: TData; Index: Word);
    procedure _work_doLoadFromStream(var _Data: TData; Index: Word);
    procedure _work_doDelimiter(var _Data: TData; Index: Word);
    procedure _work_doCharset(var _Data: TData; Index: Word);

  end;

implementation

constructor THIMST_Load.Create;
begin
  inherited;
  FCharset := DefaultCompilerCP;
end;

procedure THIMST_Load.SetCharset(Value: Byte);
begin
  FCharset := InCharsetPropText[Value];
end;

procedure THIMST_Load.SetDlm(dlm: string);
begin
  if dlm = '' then
    _Dlm := ' '
  else  
    _Dlm := dlm[1];
end;

procedure THIMST_Load.LoadFromStream(var FS: PStream);
var
  St: string;
  i, chk: integer;
  d: PData;
  dp, dt: TData;
  SList: PKOLStrList;
  sControl: PControl;  
begin
  if not Assigned(_prop_MSTControl) then exit;
  sControl := _prop_MSTControl.ctrlpoint; 
  if (Fs = nil) or (Fs.Size = 0) then exit;

  SList := NewKOLStrList;
  chk := 0;

TRY
  Fs.Position := 0;
  StrListLoadFromStream(SList, Fs, Fs.Size, FCharset);

  if SList.Count = 0 then exit;
  d := @dt;

// Первая строка
  St := SList.Items[0] + _Dlm;
  if _prop_LoadCheckBoxes and (St <> '') and not _prop_ColNameHeader then
    chk := str2int(GetTok(St, _Dlm)) + 1; 
  while St <> '' do
  begin   
    dtString(d^, GetTok(St, _Dlm));
    if St <> '' then
    begin
      new(d.ldata);
      d := d.ldata;
    end;    
  end;
  dp := dt;
  if _prop_ColNameHeader then
    _prop_MSTControl.addcols(dp)
  else
  begin
    _prop_MSTControl.actionitm(dp, ITM_ADD);
    sControl.LVItemStateImgIdx[0] := chk;
  end;  
  freedata(@dt);  
  SList.delete(0);

  if SList.Count = 0 then exit; 

// Следующие строки
  for i := 0 to SList.Count - 1 do
  begin 
    d := @dt;
    St := SList.Items[i] + _Dlm; 

    if _prop_LoadCheckBoxes and (St <> '') then
      chk := str2int(GetTok(St, _Dlm)) + 1; 
      
    while St <> '' do
    begin   
      dtString(d^, GetTok(St, _Dlm));
      if St <> '' then
      begin
        new(d.ldata);
        d := d.ldata;
      end;    
    end;
    dp := dt;
    _prop_MSTControl.actionitm(dp, ITM_ADD);    
    freedata(@dt);
    if _prop_ColNameHeader then
      sControl.LVItemStateImgIdx[i] := chk
    else
      sControl.LVItemStateImgIdx[i + 1] := chk;
  end;  
FINALLY
  SList.free;
END;  
end;

procedure THIMST_Load._work_doLoad(var _Data: TData; Index: Word);
var
  Strm: PStream;
begin
  Strm := NewReadFileStream(ReadString(_Data,_data_FileName,_prop_FileName));
  LoadFromStream(Strm);
  Free_And_Nil(Strm);
  _hi_onEvent(_event_onLoad);
end;

procedure THIMST_Load._work_doLoadFromStream(var _Data: TData; Index: Word);
var
  Strm: PStream;
begin
  Strm := ReadStream(_Data, _data_Stream, nil);
  LoadFromStream(Strm);  
  _hi_onEvent(_event_onLoadFromStream);
end;

procedure THIMST_Load._work_doDelimiter(var _Data: TData; Index: Word);
begin
  SetDlm(Share.ToString(_Data));
end;

procedure THIMST_Load._work_doCharset(var _Data: TData; Index: Word);
begin
  FCharset := ToInteger(_Data);
end;

end.