unit hiImg_GDIFileProcessor;

interface

uses
  Windows, Messages, ActiveX,
  {$ifdef FPC_NEW}
  ComObj, Variants,
  {$else}
  KOLComObj,
  {$endif}
  Kol, Share, Debug, GDIPAPI, GDIPOBJ, GDIPUTIL;

const
  ImageTypes: array [0..4] of string = ('bmp', 'jpeg', 'gif', 'tiff', 'png');
  _FILE        = 0;
  _STREAM      = 1;
  _THUMBFILE   = 2;
  _THUMBSTREAM = 3;
type
  TStreamOwnership = (soReference, soOwned);

  TStreamAdapter = class(TInterfacedObject, IStream)
  private
    FStream: PStream;
    FOwnership: TStreamOwnership;
  public
    constructor Create(Stream: PStream; Ownership: TStreamOwnership = soReference);
    destructor Destroy; override;
    {$ifdef FPC_NEW}
    function Read(pv: Pointer; cb: DWORD; pcbRead: PDWORD): HResult; virtual; stdcall;
    function Write(pv: Pointer; cb: DWORD; pcbWritten: PDWORD): HResult; virtual; stdcall;
    function Seek(dlibMove: LargeUInt; dwOrigin: Longint; out libNewPosition: LargeUInt): HResult; virtual; stdcall;
    function SetSize(libNewSize: LargeUInt): HResult; virtual; stdcall;
    function CopyTo(stm: IStream; cb: LargeUInt; out cbRead: LargeUInt; out cbWritten: LargeUInt): HResult; virtual; stdcall;
    function LockRegion(libOffset: LargeUInt; cb: LargeUInt; dwLockType: Longint): HResult; virtual; stdcall;
    function UnlockRegion(libOffset: LargeUInt; cb: LargeUInt; dwLockType: Longint): HResult; virtual; stdcall;
    {$else}
    function Read(pv: Pointer; cb: Longint; pcbRead: PLongint): HResult; virtual; stdcall;
    function Write(pv: Pointer; cb: Longint; pcbWritten: PLongint): HResult; virtual; stdcall;
    function Seek(dlibMove: Largeint; dwOrigin: Longint; out libNewPosition: Largeint): HResult; virtual; stdcall;
    function SetSize(libNewSize: Largeint): HResult; virtual; stdcall;
    function CopyTo(stm: IStream; cb: Largeint; out cbRead: Largeint; out cbWritten: Largeint): HResult; virtual; stdcall;
    function LockRegion(libOffset: Largeint; cb: Largeint; dwLockType: Longint): HResult; virtual; stdcall;
    function UnlockRegion(libOffset: Largeint; cb: Largeint; dwLockType: Longint): HResult; virtual; stdcall;
    {$endif}
    function Commit(grfCommitFlags: Longint): HResult; virtual; stdcall;
    function Revert: HResult; virtual; stdcall;
    function Stat(out statstg: TStatStg; grfStatFlag: Longint): HResult; virtual; stdcall;
    function Clone(out stm: IStream): HResult; virtual; stdcall;
    property Stream: PStream read FStream;
    property StreamOwnership: TStreamOwnership read FOwnership write FOwnership;
  end;
  
type
 THIImg_GDIFileProcessor = class(TDebug)
   private
	 Width: integer;
	 Height: integer;
	 FWidth: integer;
	 FHeight: integer;
	 PixelFormat: string;
	 HDPI: integer;
	 VDPI: integer;
     Bitmap: PBitmap;
     Thumbnail: PBitmap;
     Frame: PBitmap;     
	 ThumbLoad: boolean;     
     SBitmap: PBitmap;
     Stream:PStream;      
     imgFileLoad : TGPImage;
     fCount: integer;
     sCount: integer;     
     fFrameGUID: TGUID;
	 ImgFormat : string;     

     procedure SaveTo(aFile, ftype: string; Method: byte; Fcompression: integer = 100);
     procedure LoadFrom(aFile : string; Method: byte);
     function GetParam(aFile : string; Method: byte): boolean;
   public
    _prop_Stream: PStream;
    _prop_SaveFormat: byte;
    _prop_FileName: string;
    _prop_FileNameNew: string;    
    _prop_Quality: integer;
    _prop_ThumbnailSize: integer;
    _prop_Digits: integer;
    _prop_Method: byte;    

    _data_SBitmap,
    _data_Stream,
    _data_FileName,
    _data_FileNameNew,
    _data_FrameIdx,
    _data_FileList: THI_Event;

    _event_onLoad,
    _event_onSave,
    _event_onConvert,
    _event_onGetParam,
    _event_onGetThumb,
    _event_onGetFrameIdx,
    _event_onCreateMultiTIFF,
    _event_onUnPackMultiFile: THI_Event;

     constructor Create;
     destructor Destroy; override;
     procedure _work_doLoadFrom(var _Data:TData; Index:word);
     procedure _work_doSaveTo(var _Data:TData; Index:word);
     procedure _work_doGetParamFrom(var _Data:TData; Index:word);
     procedure _work_doGetThumbFrom(var _Data:TData; Index:word);
     procedure _work_doConvert(var _Data:TData; Index:word);
     procedure _work_doGetFrameIdx(var _Data:TData; Index:word);	 
     procedure _work_doCreateMultiTIFF(var _Data:TData; Index:word);
     procedure _work_doUnPackMultiFile(var _Data:TData; Index:word);

     procedure _work_doSaveFormat(var _Data:TData; Index:word);
     procedure _work_doQuality(var _Data:TData; Index:word);
     procedure _work_doThumbnailSize(var _Data:TData; Index:word);
     procedure _work_doMethod(var _Data:TData; Index:word);     
     procedure _work_doDigits(var _Data:TData; Index:word);     

     procedure _var_Bitmap(var _Data:TData; Index:word);
     procedure _var_Thumbnail(var _Data:TData; Index:word);     
     procedure _var_FrameCount(var _Data:TData; Index:word);     
     procedure _var_FrameEndIdx(var _Data:TData; Index:word);     
     procedure _var_Frame(var _Data:TData; Index:word);
     procedure _var_FrameWidth(var _Data:TData; Index:word);
     procedure _var_FrameHeight(var _Data:TData; Index:word);	      
 end;

implementation

uses hiStr_Enum;

//==============================================================================

{ TStreamAdapter }

constructor TStreamAdapter.Create(Stream: PStream; Ownership: TStreamOwnership = soReference);
begin
  inherited Create;
  FStream := Stream;
  FOwnership := Ownership;
end;

destructor TStreamAdapter.Destroy;
begin
  if FOwnership = soOwned then
  begin
    FStream.Free;
    FStream := nil;
  end;
  inherited Destroy;
end;

{$ifdef FPC_NEW}
function TStreamAdapter.Read(pv: Pointer; cb: DWORD; pcbRead: PDWORD): HResult;
{$else}
function TStreamAdapter.Read(pv: Pointer; cb: Longint; pcbRead: PLongint): HResult;
{$endif}
var
  NumRead: Longint;
begin
  try
    if pv = Nil then
    begin
      Result := STG_E_INVALIDPOINTER;
      Exit;
    end;
    NumRead := FStream.Read(pv^, cb);
    if pcbRead <> Nil then pcbRead^ := NumRead;
    Result := S_OK;
  except
    Result := S_FALSE;
  end;
end;

{$ifdef FPC_NEW}
function TStreamAdapter.Write(pv: Pointer; cb: DWORD; pcbWritten: PDWORD): HResult;
{$else}
function TStreamAdapter.Write(pv: Pointer; cb: Longint; pcbWritten: PLongint): HResult;
{$endif}
var
  NumWritten: Longint;
begin
  try
    if pv = Nil then
    begin
      Result := STG_E_INVALIDPOINTER;
      Exit;
    end;
    NumWritten := FStream.Write(pv^, cb);
    if pcbWritten <> Nil then pcbWritten^ := NumWritten;
    Result := S_OK;
  except
    Result := STG_E_CANTSAVE;
  end;
end;

{$ifdef FPC_NEW}
function TStreamAdapter.Seek(dlibMove: LargeUInt; dwOrigin: Longint; out libNewPosition: LargeUInt): HResult;
{$else}
function TStreamAdapter.Seek(dlibMove: Largeint; dwOrigin: Longint; out libNewPosition: Largeint): HResult;
{$endif}
var
  NewPos: Integer;
begin
  try
    if (dwOrigin < STREAM_SEEK_SET) or (dwOrigin > STREAM_SEEK_END) then
    begin
      Result := STG_E_INVALIDFUNCTION;
      Exit;
    end;
    NewPos := FStream.Seek(LongInt(dlibMove), TMoveMethod(dwOrigin));
    if @libNewPosition <> nil then libNewPosition := NewPos;
    Result := S_OK;
  except
    Result := STG_E_INVALIDPOINTER;
  end;
end;

{$ifdef FPC_NEW}
function TStreamAdapter.SetSize(libNewSize: LargeUInt): HResult;
{$else}
function TStreamAdapter.SetSize(libNewSize: Largeint): HResult;
{$endif}
begin
  try
    FStream.Size := LongInt(libNewSize);
    if libNewSize <> FStream.Size then
      Result := E_FAIL
    else
      Result := S_OK;
  except
    Result := E_UNEXPECTED;
  end;
end;

{$ifdef FPC_NEW}
function TStreamAdapter.CopyTo(stm: IStream; cb: LargeUInt; out cbRead: LargeUInt; out cbWritten: LargeUInt): HResult;
{$else}
function TStreamAdapter.CopyTo(stm: IStream; cb: Largeint; out cbRead: Largeint; out cbWritten: Largeint): HResult;
{$endif}
const
  MaxBufSize = 1024 * 1024;  // 1mb
var
  Buffer: Pointer;
  BufSize, N, I: Integer;
  BytesRead, BytesWritten, W: LargeInt;
begin
  Result := S_OK;
  BytesRead := 0;
  BytesWritten := 0;
  try
    if cb > MaxBufSize then
      BufSize := MaxBufSize
    else
      BufSize := Integer(cb);
    GetMem(Buffer, BufSize);
    try
      while cb > 0 do
      begin
        if cb > MaxInt then
          I := MaxInt
        else
          I := cb;
        while I > 0 do
        begin
          if I > BufSize then N := BufSize else N := I;
          Inc(BytesRead, FStream.Read(Buffer^, N));
          W := 0;
          Result := stm.Write(Buffer, N, @W);
          Inc(BytesWritten, W);
          if (Result = S_OK) and (Integer(W) <> N) then Result := E_FAIL;
          if Result <> S_OK then Exit;
          Dec(I, N);
        end;
        Dec(cb, I);
      end;
    finally
      FreeMem(Buffer);
      if (@cbWritten <> nil) then cbWritten := BytesWritten;
      if (@cbRead <> nil) then cbRead := BytesRead;
    end;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TStreamAdapter.Commit(grfCommitFlags: Longint): HResult;
begin
  Result := S_OK;
end;

function TStreamAdapter.Revert: HResult;
begin
  Result := STG_E_REVERTED;
end;


{$ifdef FPC_NEW}
function TStreamAdapter.LockRegion(libOffset: LargeUInt; cb: LargeUInt; dwLockType: Longint): HResult;
{$else}
function TStreamAdapter.LockRegion(libOffset: Largeint; cb: Largeint; dwLockType: Longint): HResult;
{$endif}
begin
  Result := STG_E_INVALIDFUNCTION;
end;

{$ifdef FPC_NEW}
function TStreamAdapter.UnlockRegion(libOffset: LargeUInt; cb: LargeUInt; dwLockType: Longint): HResult;
{$else}
function TStreamAdapter.UnlockRegion(libOffset: Largeint; cb: Largeint; dwLockType: Longint): HResult;
{$endif}
begin
  Result := STG_E_INVALIDFUNCTION;
end;

function TStreamAdapter.Stat(out statstg: TStatStg; grfStatFlag: Longint): HResult;
begin
  Result := S_OK;
  try
    if (@statstg <> nil) then
      with statstg do
      begin
        dwType := STGTY_STREAM;
        cbSize := FStream.Size;
        mTime.dwLowDateTime := 0;
        mTime.dwHighDateTime := 0;
        cTime.dwLowDateTime := 0;
        cTime.dwHighDateTime := 0;
        aTime.dwLowDateTime := 0;
        aTime.dwHighDateTime := 0;
        grfLocksSupported := LOCK_WRITE;
      end;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TStreamAdapter.Clone(out stm: IStream): HResult;
begin
  Result := E_NOTIMPL;
end;

//==============================================================================

procedure GetMultuFrameInfo(GPImage:TGPImage; var Count: integer; var FrameGUID: TGUID);
var
  DimensionCount: Cardinal;
  DimensionIDs: array of TGUID;
begin
  DimensionCount:=GPImage.GetFrameDimensionsCount;
  SetLength(DimensionIDs, DimensionCount);
  GPImage.GetFrameDimensionsList(@DimensionIDs[0], DimensionCount);
  if not Assigned(DimensionIDs) then exit;
  if IsEqualGUID(DimensionIDs[0],FrameDimensionTime) then
    FrameGUID := FrameDimensionTime else  //����� ��������
  if IsEqualGUID(DimensionIDs[0],FrameDimensionResolution) then
    FrameGUID := FrameDimensionResolution else //����� � ������ �����������
  if IsEqualGUID(DimensionIDs[0],FrameDimensionPage) then
    FrameGUID := FrameDimensionPage; //����� ��������;
  Count := GPImage.GetFrameCount(DimensionIDs[0]);
end;

//==============================================================================

{function StringToWideString(const s: string): WideString;
var
  l: integer;
begin
  if s = '' then
    Result := ''
  else
  begin
    l := MultiByteToWideChar(CP_ACP, MB_PRECOMPOSED, PChar(s), -1, nil, 0);
    SetLength(Result, l - 1);
    if l > 1 then
      MultiByteToWideChar(CP_ACP, MB_PRECOMPOSED, PChar(s), -1, PWChar(Result), l - 1);
  end;
end;}

//==============================================================================

constructor THIImg_GDIFileProcessor.Create;
begin
  inherited;
  imgFileLoad := nil;
  Bitmap    := NewBitmap(0, 0);
  Thumbnail := NewBitmap(0, 0);
  Frame     := NewBitmap(0, 0);
  fCount    := 0;
  FWidth    := 0;
  FHeight   := 0;
end;

destructor THIImg_GDIFileProcessor.Destroy;
begin
  Bitmap.free;
  Thumbnail.free;
  Frame.free;
  if imgFileLoad <> nil then imgFileLoad.free;  
  inherited;
end;

procedure THIImg_GDIFileProcessor.LoadFrom(aFile : string; Method: byte);
var
  imgFileThumb : TGPImage; //����� GDI+ �������������� ��������� ������
  mem          : PStream;  //����� � ������, ������� ����� �������� ������
  aptr         : IStream;  //��������� ������� ����� ���������� ��� ������ TStreamAdapter
  aptrin       : IStream;  //��������� ������� ����� ���������� ��� ������ TStreamAdapter  
  encoderClsid : TGUID;    //GUID - ������ �����������
  n            : {$ifdef FPC_NEW}LargeUInt{$else}Largeint{$endif};
  sWidth       : integer;
  sHeight      : integer;
begin
  imgFileThumb := nil; 
  if imgFileLoad <> nil then imgFileLoad.free;;//���������� ���������� ����� �����������
  imgFileLoad := nil;
  fCount := 0;

  if not FileExists(aFile) and ((Method = _FILE) or (Method = _THUMBFILE)) then exit;

  if Method = _STREAM then
  begin
    Bitmap.Clear;
    aptrin := TStreamAdapter.Create(Stream, soReference) as IStream;
    aptrin.Seek(0, 0, n);  
    imgFileLoad := TGPImage.Create(aptrin);
    ThumbLoad := false;
  end
  else if Method = _THUMBSTREAM then
  begin
    Thumbnail.Clear;
    aptrin := TStreamAdapter.Create(Stream, soReference) as IStream;
    aptrin.Seek(0, 0, n);  
    imgFileThumb := TGPImage.Create(aptrin);
    sWidth := integer(imgFileThumb.GetWidth);
	sHeight := integer(imgFileThumb.GetHeight);  
	if sWidth > sHeight then  
      imgFileLoad := imgFileThumb.GetThumbnailImage(_prop_ThumbnailSize, _prop_ThumbnailSize * sHeight div sWidth)
    else if imgFileThumb.GetWidth < imgFileThumb.GetHeight then   
      imgFileLoad := imgFileThumb.GetThumbnailImage(_prop_ThumbnailSize * sWidth div sHeight, _prop_ThumbnailSize)
	else
      imgFileLoad := imgFileThumb.GetThumbnailImage(_prop_ThumbnailSize, _prop_ThumbnailSize);
    ThumbLoad := true;
  end    
  else if Method = _FILE then
  begin 
    Bitmap.Clear;
    imgFileLoad := TGPImage.Create(WideString(aFile));
    ThumbLoad := false;    
  end  
  else
  begin
    Thumbnail.Clear;
    imgFileThumb := TGPImage.Create(WideString(aFile));
    sWidth := integer(imgFileThumb.GetWidth);
	sHeight := integer(imgFileThumb.GetHeight);  
	if sWidth > sHeight then  
      imgFileLoad := imgFileThumb.GetThumbnailImage(_prop_ThumbnailSize, _prop_ThumbnailSize * sHeight div sWidth)
    else if imgFileThumb.GetWidth < imgFileThumb.GetHeight then   
      imgFileLoad := imgFileThumb.GetThumbnailImage(_prop_ThumbnailSize * sWidth div sHeight, _prop_ThumbnailSize)
	else
      imgFileLoad := imgFileThumb.GetThumbnailImage(_prop_ThumbnailSize, _prop_ThumbnailSize);
    ThumbLoad := true;
  end;
  GetMultuFrameInfo(imgFileLoad, fCount, fFrameGUID);
  mem  := NewMemoryStream;//������� �����
  aptr := TStreamAdapter.Create(mem, soReference) as IStream;
  //������� ����� �������, ������� ��� ������ ���������� ��������� ��� ������ ������ 
  //������ � ������ mem.
  GetEncoderClsid('image/bmp', encoderClsid);//�������� GUID �������
  imgFileLoad.Save(aptr, encoderClsid);//��������� ����������� � �����
  aptr.Seek(0, 0, n);//�������� ��������� ������ � ������.

  if (Method = _FILE) or (Method = _STREAM) then
    Bitmap.LoadFromStream(mem)//��������� ������ �� ������ � ������
  else
    Thumbnail.LoadFromStream(mem);//��������� ������ �� ������ � ������
  
  if imgFileThumb <> nil then imgFileThumb.free;//���������� ����� ������
  aptr   := nil;//����������� ���������
  aptrin := nil;//����������� ���������  
  mem.Free;//���������� ����� � ������.
end;

function THIImg_GDIFileProcessor.GetParam(aFile : string; Method: byte): boolean;
var
  imgFile      : TGPImage;
  aptrin       : IStream;  
  n            : {$ifdef FPC_NEW}LargeUInt{$else}Largeint{$endif};
  sFrameGUID   : TGUID;
begin
  Result := false;
  if not FileExists(aFile) and (Method = _FILE) then exit;

  if Method = _STREAM then
  begin
    aptrin := TStreamAdapter.Create(Stream, soReference) as IStream;
    aptrin.Seek(0, 0, n);
    imgFile := TGPImage.Create(aptrin);
  end  
  else
    imgFile := TGPImage.Create(WideString(aFile));
	   
  Width       := imgFile.GetWidth;
  Height      := imgFile.GetHeight;
  HDPI        := Round(imgFile.GetHorizontalResolution);  
  VDPI        := Round(imgFile.GetVerticalResolution);
  PixelFormat := PixelFormatString(imgFile.GetPixelFormat);
  Replace(PixelFormat, 'PixelFormat', '');
  GetMultuFrameInfo(imgFile, sCount, sFrameGUID);
  
  imgFormat := 'Undefined';
  
  imgFile.GetRAWFormat(sFrameGUID);
  
  if ISEqualGUID(sFrameGUID, ImageFormatUndefined) then imgFormat := 'Undefined' else
  if ISEqualGUID(sFrameGUID, ImageFormatMemoryBMP) then imgFormat := 'MemoryBMP' else
  if ISEqualGUID(sFrameGUID, ImageFormatBMP) then imgFormat := 'BMP' else
  if ISEqualGUID(sFrameGUID, ImageFormatEMF) then imgFormat := 'EMF' else
  if ISEqualGUID(sFrameGUID, ImageFormatWMF) then imgFormat := 'WMF' else  
  if ISEqualGUID(sFrameGUID, ImageFormatJPEG) then imgFormat := 'JPEG' else
  if ISEqualGUID(sFrameGUID, ImageFormatPNG) then imgFormat := 'PNG' else
  if ISEqualGUID(sFrameGUID, ImageFormatGIF) then imgFormat := 'GIF' else  
  if ISEqualGUID(sFrameGUID, ImageFormatTIFF) then imgFormat := 'TIFF' else
  if ISEqualGUID(sFrameGUID, ImageFormatEXIF) then imgFormat := 'EXIF' else
  if ISEqualGUID(sFrameGUID, ImageFormatIcon) then imgFormat := 'ICON' else  
    
  imgFile.free;
  aptrin := nil;  
  Result := true;
end;

procedure THIImg_GDIFileProcessor.SaveTo(aFile, ftype: string; Method: byte; Fcompression: integer = 100);
var
  imgFile          : TGPImage;
  mem              : PStream;
  aptr             : IStream;
  aptrout          : IStream;  
  encoderClsid     : TGUID;
  encoderParameters: TEncoderParameters;//������ ��������� �������� (� ������ ������ 
                                        //������������ ��� ���� ����� ������ ������ ������ jpeg)
  param            : ULONG;
begin
  mem     := NewMemoryStream;

  SBitmap.SaveToStream(mem);//��������� ������� ������ � �����
  mem.Seek(0, spBegin);//������������� ������� ������ � ������
  aptr    := TStreamAdapter.Create(mem, soReference) as IStream;

  if Method = _STREAM then
    aptrout := TStreamAdapter.Create(Stream, soReference) as IStream;
  
  imgFile := TGPImage.Create(aptr);
  GetEncoderClsid(WideString(ftype), encoderClsid);//�������� GUID ������� ��� ��������
  
  if ftype = 'image/jpeg' then//��� jpeg ������������� �������������� ���������
  begin
    encoderParameters.Count := 1;//������������� ����� ���� ��������
    encoderParameters.Parameter[0].Guid := EncoderQuality;//������� ������
    encoderParameters.Parameter[0].NumberOfValues := 1;
    encoderParameters.Parameter[0].Type_ := EncoderParameterValueTypeLong;//��� 
                                          //��������� ������ ����� (integer)
    param := Fcompression;                //��������� ��� ������������� �������� 
                                          //������
    encoderParameters.Parameter[0].Value := @param;
    if Method = _FILE then
      imgFile.Save(WideString(aFile), encoderClsid, @encoderParameters)//��� ������ ���������
                       //������ �������� �� � ������� Save ��� ���������� � ����
    else
      imgFile.Save(aptrout, encoderClsid, @encoderParameters);                     
  end
  else if Method = _FILE then
    imgFile.Save(WideString(aFile), encoderClsid) //���� ���������� ��������� ��������� �� 
                                      //encoderParameters ������ �� ��������.
  else
    imgFile.Save(aptrout, encoderClsid);  
                                      
  imgFile.Free;
  aptr    := nil;
  aptrout := nil;
  mem.Free;
end;

procedure THIImg_GDIFileProcessor._work_doLoadFrom;
begin
  if _prop_Method = 0 then
    LoadFrom(ReadString(_Data, _data_Filename, _prop_FileName), _FILE)
  else
  begin
    Stream := ReadStream(_Data, _data_Stream, _prop_Stream);
    if Stream = nil then exit; 
    LoadFrom('', _STREAM);
  end;
  _hi_onEvent(_event_onLoad, Bitmap); 
end;

procedure THIImg_GDIFileProcessor._work_doSaveTo;
begin
  SBitmap := ReadBitmap(_Data, _data_SBitmap);
  if SBitmap = nil then exit;

  if _prop_Method = 0 then
    SaveTo(ReadString(_Data, _data_FileName, _prop_FileName), 'image/' + ImageTypes[_prop_SaveFormat], _FILE, _prop_Quality)
  else
  begin  
    Stream := ReadStream(_Data, _data_Stream);
    if Stream = nil then exit;
    Stream.Size := 0;
    SaveTo('', 'image/' + ImageTypes[_prop_SaveFormat], _STREAM, _prop_Quality);
  end;
  _hi_onEvent(_event_onSave);
end;

procedure THIImg_GDIFileProcessor._work_doGetParamFrom;
var
  dt: TData;
  mt: PMT;
begin
  if _prop_Method = 0 then
  begin
    if not GetParam(ReadString(_Data, _data_Filename, _prop_FileName), _FILE) then exit;
  end  
  else
  begin
    Stream := ReadStream(_Data, _data_Stream, _prop_Stream);
    if Stream = nil then exit; 
    GetParam('', _STREAM);
  end;  
  dtInteger(dt, Width);
  mt := mt_make(dt);
  mt_int(mt, Height);
  mt_int(mt, HDPI);  
  mt_int(mt, VDPI);
  mt_string(mt, imgFormat);
  mt_string(mt, PixelFormat);
  mt_int(mt, sCount);
  _hi_onEvent_(_event_onGetParam, dt);
  mt_free(mt);
end;

procedure THIImg_GDIFileProcessor._work_doGetThumbFrom;
begin
  if _prop_Method = 0 then
    LoadFrom(ReadString(_Data, _data_Filename, _prop_FileName), _THUMBFILE)
  else
  begin
    Stream := ReadStream(_Data, _data_Stream, _prop_Stream);
    if Stream = nil then exit; 
    LoadFrom('', _THUMBSTREAM);  
  end;
  _hi_onEvent(_event_onGetThumb, Thumbnail);
end;

procedure THIImg_GDIFileProcessor._work_doGetFrameIdx;
var
  idx: integer;
  mem          : PStream;
  aptr         : IStream;
  encoderClsid : TGUID;
  n            : {$ifdef FPC_NEW}LargeUInt{$else}Largeint{$endif};
begin
  Frame.Clear;
  FWidth  := 0;
  FHeight := 0;

  if ThumbLoad or (imgFileLoad = nil) then exit;
  
  idx := max(0, min(fCount - 1, ReadInteger(_Data, _data_FrameIdx)));
  imgFileLoad.SelectActiveFrame(fFrameGUID, idx);
  FWidth  := imgFileLoad.GetWidth;
  FHeight := imgFileLoad.GetHeight;

  mem  := NewMemoryStream;
  aptr := TStreamAdapter.Create(mem, soReference) as IStream;
  GetEncoderClsid('image/bmp', encoderClsid);
  imgFileLoad.Save(aptr, encoderClsid);
  aptr.Seek(0, 0, n);
  Frame.LoadFromStream(mem);

  aptr    := nil;
  mem.Free;
  
  _hi_onEvent(_event_onGetFrameIdx, Frame);    
end;

procedure THIImg_GDIFileProcessor._work_doConvert;
var
  imgFile          : TGPImage;
  encoderClsid     : TGUID;
  encoderParameters: TEncoderParameters;
  ftype            : string;
  aFile            : string;
  aFileNew         : string;
  param            : ULONG;  
begin
  aFile    := ReadString(_Data, _data_FileName);
  aFileNew := ReadString(_Data, _data_FileNameNew);  

  if not FileExists(aFile) then exit;

  imgFile := TGPImage.Create(WideString(aFile));

  ftype := 'image/' + ImageTypes[_prop_SaveFormat]; 
  GetEncoderClsid(WideString(ftype), encoderClsid);
    
  if ftype = 'image/jpeg' then
  begin
    encoderParameters.Count := 1;
    encoderParameters.Parameter[0].Guid := EncoderQuality;
    encoderParameters.Parameter[0].NumberOfValues := 1;
    encoderParameters.Parameter[0].Type_ := EncoderParameterValueTypeLong; 
    param := _prop_Quality;
    encoderParameters.Parameter[0].Value := @param;
    imgFile.Save(WideString(aFileNew), encoderClsid, @encoderParameters);
  end
  else
    imgFile.Save(WideString(aFileNew), encoderClsid);
  _hi_onEvent(_event_onConvert);

  imgFile.free;
end;

procedure THIImg_GDIFileProcessor._work_doCreateMultiTIFF;
var
  imgFile          : TGPImage;
  imgFileAdd       : TGPImage;
  encoderClsid     : TGUID;
  encoderParameters: TEncoderParameters;
  param            : EncoderValue;
  aFile            : string;
  FList            : PKOLStrList;
  Status           : boolean;
  i                : integer;
begin
  Status := false;
  aFile := ReadString(_Data, _data_FileName);
  FList := NewKOLStrList;
  FList.Text := ReadString(_Data, _data_FileList);
TRY
  if Flist.Count = 0 then exit;
  for i := 0 to Flist.Count - 1 do
    if not FileExists(Flist.Items[i]) then exit;

  encoderParameters.Count := 1;
  encoderParameters.Parameter[0].Guid := EncoderSaveFlag;
  encoderParameters.Parameter[0].NumberOfValues := 1;
  encoderParameters.Parameter[0].Type_ := EncoderParameterValueTypeLong;
  encoderParameters.Parameter[0].Value := @param;
  
  imgFile := TGPImage.Create(WideString(Flist.Items[0]));
  GetEncoderClsid('image/tiff', encoderClsid);
  param := EncoderValueMultiFrame;
  imgFile.Save(WideString(aFile), encoderClsid, @encoderParameters);     

  for i := 1 to Flist.Count - 1 do
  begin
    imgFileAdd := TGPImage.Create(WideString(Flist.Items[i]));
    param := EncoderValueFrameDimensionPage;
    imgFile.SaveAdd(imgFileAdd, @encoderParameters);
    imgFileAdd.free;	       
  end;

  Status := true;
  imgFile.free;
  
FINALLY
  _hi_onEvent(_event_onCreateMultiTIFF, integer(Status));
  FList.free;
END;  
end;

procedure THIImg_GDIFileProcessor._work_doUnPackMultiFile;
var
  imgFile          : TGPImage;
  encoderClsid     : TGUID;
  encoderParameters: TEncoderParameters;
  ftype            : string;
  aFile            : string;     
  aFileNewWOExt    : string;
  aFileNew         : string;
  ext              : string;               
  param            : ULONG;
  hCount           : integer;
  hFrameGUID       : TGUID;
  i                : integer;

  function GetNumStr(num: integer): string;
  begin
    Result:= int2str(num);
    while Length(Result) < _prop_Digits do
      Result := '0' + Result;
    Result := '_' + Result;  
  end;   


begin
  aFile := ReadString(_Data, _data_FileName);
  if not FileExists(aFile) then exit;

  aFileNewWOExt := aFile; 
  rparse(aFileNewWOExt, '.');

  imgFile := TGPImage.Create(WideString(aFile));

  ext := ImageTypes[_prop_SaveFormat]; 
  ftype := 'image/' + ext; 

  SetLength(ext, 3);
  ext := '.' + ext;
   
  GetEncoderClsid(WideString(ftype), encoderClsid);
  GetMultuFrameInfo(imgFile, hCount, hFrameGUID);

  for i := 0 to hCount - 1 do
  begin
    aFileNew := aFileNewWOExt + GetNumStr(i + 1) + ext;
    imgFile.SelectActiveFrame(hFrameGUID, i);
    if ftype = 'image/jpeg' then
    begin
      encoderParameters.Count := 1;
      encoderParameters.Parameter[0].Guid := EncoderQuality;
      encoderParameters.Parameter[0].NumberOfValues := 1;
      encoderParameters.Parameter[0].Type_ := EncoderParameterValueTypeLong;
      param := _prop_Quality; 
      encoderParameters.Parameter[0].Value := @param;
      imgFile.Save(WideString(aFileNew), encoderClsid, @encoderParameters);
    end  
    else
      imgFile.Save(WideString(aFileNew), encoderClsid);  
  end;

  imgFile.free;
  _hi_onEvent(_event_onUnPackMultiFile);  
end;

procedure THIImg_GDIFileProcessor._work_doSaveFormat;
begin
  _prop_SaveFormat := max(0, min(4, ToInteger(_Data)));
end;

procedure THIImg_GDIFileProcessor._work_doQuality;
begin
  _prop_Quality := max(1, min(100, ToInteger(_Data)));
end;

procedure THIImg_GDIFileProcessor._work_doThumbnailSize;
begin
  _prop_ThumbnailSize := ToInteger(_Data);
end;

procedure THIImg_GDIFileProcessor._work_doMethod;
begin
  _prop_Method := max(0, min(1, ToInteger(_Data)));
end;

procedure THIImg_GDIFileProcessor._work_doDigits;
begin
  _prop_Digits := ToInteger(_Data);
end;

procedure  THIImg_GDIFileProcessor._var_Bitmap;
begin
  dtBitmap(_Data, Bitmap);
end;

procedure  THIImg_GDIFileProcessor._var_Thumbnail;
begin
  dtBitmap(_Data, Thumbnail);
end;

procedure  THIImg_GDIFileProcessor._var_FrameCount;
begin
  dtInteger(_Data, fCount);
end;

procedure  THIImg_GDIFileProcessor._var_FrameEndIdx;
begin
  dtInteger(_Data, fCount - 1);
end;

procedure  THIImg_GDIFileProcessor._var_Frame;
begin
  dtBitmap(_Data, Frame);
end;

procedure  THIImg_GDIFileProcessor._var_FrameWidth;
begin
  dtInteger(_Data, FWidth);
end;

procedure  THIImg_GDIFileProcessor._var_FrameHeight;
begin
  dtInteger(_Data, FHeight);
end;

end.