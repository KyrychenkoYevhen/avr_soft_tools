unit hiJpeg;

interface

{define gdip}

uses
  {$ifdef gdip}
  GDIPOBJ,GDIPUTIL,
  {$else}
  {$ifdef FPC}JpegObjFPC{$else}JpegObj{$endif},
  {$endif}
  Kol,Share,Debug,Exif;

type
  THIJpeg = class(TDebug)
  private
    exif:TExif;
    {$ifdef gdip}
    Jpg:TGPImage;
    {$else}
    Jpg:pjpeg;
    {$endif}
    procedure SetJpeg(Value:PStream);
  public
    _prop_Quality: integer;
    _data_FileName: THI_Event;
    _data_Stream: THI_Event;
    _data_Quality: THI_Event;
    _event_onBitmap: THI_Event;

    constructor Create;
    destructor Destroy; override;
    
    property _prop_Jpeg: PStream write SetJpeg;
    
    procedure _work_doLoad(var _Data: TData; Index: Word);
    procedure _work_doSave(var _Data: TData; Index: Word);
    procedure _work_doLoadFromStream(var _Data: TData; Index: Word);
    procedure _work_doSaveToStream(var _Data: TData; Index: Word);
    procedure _work_doLoadFromBitmap(var _Data: TData; Index: Word);
    procedure _work_doBitmap(var _Data: TData; Index: Word);
    procedure _work_doReadTags(var _Data: TData; Index: Word);
    
    procedure _var_ExifMT(var _Data: TData; Index: Word);
    procedure _var_ExifValid(var _Data: TData; Index: Word);
    procedure _var_idDescription(var _Data: TData; Index: Word);
    procedure _var_idMake(var _Data: TData; Index: Word);
    procedure _var_idModel(var _Data: TData; Index: Word);
    procedure _var_idSoftware(var _Data: TData; Index: Word);
    procedure _var_idArtist(var _Data: TData; Index: Word);
    procedure _var_idOrientation(var _Data: TData; Index: Word);
    procedure _var_idOrientationN(var _Data: TData; Index: Word);
    procedure _var_idDateTime(var _Data: TData; Index: Word);
    procedure _var_idCopyright(var _Data: TData; Index: Word);
    procedure _var_idExifVersion(var _Data: TData; Index: Word);
    procedure _var_idUserComments(var _Data: TData; Index: Word);
    procedure _var_idDateTimeOriginal(var _Data: TData; Index: Word);
    procedure _var_idDateTimeDigitized(var _Data: TData; Index: Word);
    procedure _var_idOffsetTime(var _Data: TData; Index: Word);
    procedure _var_idOffsetTimeOriginal(var _Data: TData; Index: Word);
    procedure _var_idOffsetTimeDigitized(var _Data: TData; Index: Word);
    procedure _var_idSubSecTime(var _Data: TData; Index: Word);
    procedure _var_idSubSecTimeOriginal(var _Data: TData; Index: Word);
    procedure _var_idSubSecTimeDigitized(var _Data: TData; Index: Word);
    procedure _var_idExposureTime(var _Data: TData; Index: Word);
    procedure _var_idFNumber(var _Data: TData; Index: Word);
    procedure _var_idExposureProgram(var _Data: TData; Index: Word);
    procedure _var_idSpectralSensitivity(var _Data: TData; Index: Word);
    procedure _var_idPhotographicSensitivity(var _Data: TData; Index: Word);
    procedure _var_idSensitivityType(var _Data: TData; Index: Word);
    procedure _var_idStandardOutputSensitivity(var _Data: TData; Index: Word);
    procedure _var_idRecommendedExposureIndex(var _Data: TData; Index: Word);
    procedure _var_idISOSpeed(var _Data: TData; Index: Word);
    procedure _var_idISOSpeedLatitudeyyy(var _Data: TData; Index: Word);
    procedure _var_idISOSpeedLatitudezzz(var _Data: TData; Index: Word);
    procedure _var_idShutterSpeedValue(var _Data: TData; Index: Word);
    procedure _var_idApertureValue(var _Data: TData; Index: Word);
    procedure _var_idBrightnessValue(var _Data: TData; Index: Word);
    procedure _var_idExposureBiasValue(var _Data: TData; Index: Word);
    procedure _var_idMaxApertureValue(var _Data: TData; Index: Word);
    procedure _var_idSubjectDistance(var _Data: TData; Index: Word);
    procedure _var_idMeteringMode(var _Data: TData; Index: Word);
    procedure _var_idLightSource(var _Data: TData; Index: Word);
    procedure _var_idFlash(var _Data: TData; Index: Word);
    procedure _var_idFocalLength(var _Data: TData; Index: Word);
    procedure _var_idFlashEnergy(var _Data: TData; Index: Word);
    procedure _var_idFocalPlaneXResolution(var _Data: TData; Index: Word);
    procedure _var_idFocalPlaneYResolution(var _Data: TData; Index: Word);
    procedure _var_idFocalPlaneResolutionUnit(var _Data: TData; Index: Word);
    procedure _var_idExposureIndex(var _Data: TData; Index: Word);
    procedure _var_idSensingMethod(var _Data: TData; Index: Word);
    procedure _var_idFileSource(var _Data: TData; Index: Word);
    procedure _var_idExposureMode(var _Data: TData; Index: Word);
    procedure _var_idWhiteBalance(var _Data: TData; Index: Word);
    procedure _var_idDigitalZoomRatio(var _Data: TData; Index: Word);
    procedure _var_idFocalLengthIn35mmFilm(var _Data: TData; Index: Word);
    procedure _var_idSceneCaptureType(var _Data: TData; Index: Word);
    procedure _var_idGainControl(var _Data: TData; Index: Word);
    procedure _var_idContrast(var _Data: TData; Index: Word);
    procedure _var_idSaturation(var _Data: TData; Index: Word);
    procedure _var_idSharpness(var _Data: TData; Index: Word);
    procedure _var_idSubjectDistanceRange(var _Data: TData; Index: Word);
    procedure _var_idTemperature(var _Data: TData; Index: Word);
    procedure _var_idHumidity(var _Data: TData; Index: Word);
    procedure _var_idPressure(var _Data: TData; Index: Word);
    procedure _var_idWaterDepth(var _Data: TData; Index: Word);
    procedure _var_idAcceleration(var _Data: TData; Index: Word);
    procedure _var_idCameraElevationAngle(var _Data: TData; Index: Word);
    procedure _var_idImageUniqueID(var _Data: TData; Index: Word);
    procedure _var_idCameraOwnerName(var _Data: TData; Index: Word);
    procedure _var_idBodySerialNumber(var _Data: TData; Index: Word);
    procedure _var_idLensSpecification(var _Data: TData; Index: Word);
    procedure _var_idLensMake(var _Data: TData; Index: Word);
    procedure _var_idLensModel(var _Data: TData; Index: Word);
    procedure _var_idLensSerialNumber(var _Data: TData; Index: Word);
    procedure _var_Width(var _Data: TData; Index: Word);
    procedure _var_Height(var _Data: TData; Index: Word); 
  end;

implementation

constructor THIJpeg.Create;
begin
   inherited;
   {$ifdef gdip}
   jpg := TGPImage.Create;
   {$else}
   jpg := NewJpeg;
   {$endif}
end;

destructor THIJpeg.Destroy;
begin
   jpg.Free;
   if Assigned(exif) then
    exif.Destroy;
   inherited;
end;

procedure THIJpeg._work_doLoad;
var fn:string;
begin
   fn := ReadFileName( ReadString(_data,_data_FileName,'') );
   if FileExists(fn) then
     {$ifdef gdip}
     jpg.FromFile(fn);
     {$else}
     jpg.LoadFromFile(fn);
     {$endif}
end;

procedure THIJpeg._work_doSave;
var fn:string;
    {$ifdef gdip}
    encoderClsid: TGUID;
    {$endif}
begin
   fn := ReadFileName( ReadString(_data,_data_FileName,'') );
   {$ifdef gdip}
   GetEncoderClsid('image/jpeg', encoderClsid);
   jpg.Save(fn,encoderClsid);
   {$else}
   jpg.SaveToFile(fn);
   {$endif}
end;

procedure THIJpeg._work_doLoadFromStream;
var st:PStream;
begin
   st := ReadStream(_data,_data_Stream,nil);
   if st <> nil then
    {$ifdef gdip}
    {$else}
    jpg.LoadFromStream(st);
    {$endif}
end;

procedure THIJpeg._work_doSaveToStream;
var st:PStream;
begin
   st := ReadStream(_data,_data_Stream,nil);
   if st <> nil then
    {$ifdef gdip}
    {$else}
    jpg.SaveToStream(st);
    {$endif}
end;

procedure THIJpeg._work_doLoadFromBitmap;
begin
   {$ifdef gdip}
   {$else}
   jpg.Bitmap := ReadBitmap(_Data,NULL,nil);
   jpg.CompressionQuality := ReadInteger(_Data,_data_Quality,_prop_Quality);
   if jpg.Bitmap <> nil then
    jpg.Compress;
   {$endif}
end;

procedure THIJpeg._work_doBitmap;
begin
   {$ifdef gdip}
   {$else}
   if jpg.Bitmap <> nil then
    begin
     jpg.DIBNeeded;
     _hi_OnEvent(_event_onBitmap,jpg.bitmap);
    end;
   {$endif}
end;

procedure THIJpeg.SetJpeg;
begin
   {$ifdef gdip}

   {$else}
   jpg.LoadFromStream(Value);
   Value.Free;
   {$endif}
end;

procedure THIJpeg._work_doReadTags;
begin
   if not Assigned(exif) then
     exif := TExif.Create;
   exif.ReadFromFile(ReadString(_data,_data_FileName,''));
end;


//EXIF
procedure THIJpeg._var_ExifValid;
begin
  dtInteger(_Data,integer(exif.Valid));
end;

procedure THIJpeg._var_idDescription;
begin
  dtString(_Data,exif.ImageDesc);
end;

procedure THIJpeg._var_idMake;
begin
  dtString(_Data,exif.Make);
end;

procedure THIJpeg._var_idModel;
begin
  dtString(_Data,exif.Model);
end;

procedure THIJpeg._var_idSoftware;
begin
  dtString(_Data,exif.Software);
end;

procedure THIJpeg._var_idArtist;
begin
  dtString(_Data,exif.Artist);
end;

procedure THIJpeg._var_idOrientation;
begin
  dtString(_Data,exif.OrientationDesk);
end;

procedure THIJpeg._var_idOrientationN;
begin
  dtInteger(_Data,exif.Orientation);
end;

procedure THIJpeg._var_idDateTime;
begin
  dtString(_Data,exif.DateTime);
end;

procedure THIJpeg._var_idCopyright;
begin
  dtString(_Data,exif.Copyright);
end;

procedure THIJpeg._var_idExifVersion;
begin
  dtString(_Data,exif.ExifVersion);
end;

procedure THIJpeg._var_idUserComments;
begin
  dtString(_Data,exif.UserComments);
end;

procedure THIJpeg._var_idDateTimeOriginal;
begin
  dtString(_Data,exif.DateTimeOriginal);
end;

procedure THIJpeg._var_idDateTimeDigitized;
begin
  dtString(_Data,exif.DateTimeDigitized);
end;

procedure THIJpeg._var_idOffsetTime;
begin
  dtString(_Data,exif.OffsetTime);
end;

procedure THIJpeg._var_idOffsetTimeOriginal;
begin
  dtString(_Data,exif.OffsetTimeOriginal);
end;

procedure THIJpeg._var_idOffsetTimeDigitized;
begin
  dtString(_Data,exif.OffsetTimeDigitized);
end;

procedure THIJpeg._var_idSubSecTime;
begin
  dtString(_Data,exif.SubSecTime);
end;

procedure THIJpeg._var_idSubSecTimeOriginal;
begin
  dtString(_Data,exif.SubSecTimeOriginal);
end;

procedure THIJpeg._var_idSubSecTimeDigitized;
begin
  dtString(_Data,exif.SubSecTimeDigitized);
end;

procedure THIJpeg._var_idExposureTime;
begin
  dtReal(_Data,exif.ExposureTime);
end;

procedure THIJpeg._var_idFNumber;
begin
  dtReal(_Data,exif.FNumber);
end;

procedure THIJpeg._var_idExposureProgram;
begin
  dtInteger(_Data,exif.ExposureProgram);
end;

procedure THIJpeg._var_idSpectralSensitivity;
begin
  dtString(_Data,exif.SpectralSensitivity);
end;

procedure THIJpeg._var_idPhotographicSensitivity;
begin
  dtInteger(_Data,exif.PhotographicSensitivity);
end;

procedure THIJpeg._var_idSensitivityType;
begin
  dtInteger(_Data,exif.SensitivityType);
end;

procedure THIJpeg._var_idStandardOutputSensitivity;
begin
  dtReal(_Data,exif.StandardOutputSensitivity);
  //По стандарту LongWord, но в hiasm оно приводится к integer, а нужно без знака
end;

procedure THIJpeg._var_idRecommendedExposureIndex;
begin
  dtReal(_Data,exif.RecommendedExposureIndex);
  //То же^
end;

procedure THIJpeg._var_idISOSpeed;
begin
  dtReal(_Data,exif.ISOSpeed);
  //То же^
end;

procedure THIJpeg._var_idISOSpeedLatitudeyyy;
begin
  dtReal(_Data,exif.ISOSpeedLatitudeyyy);
  //То же^
end;

procedure THIJpeg._var_idISOSpeedLatitudezzz;
begin
  dtReal(_Data,exif.ISOSpeedLatitudezzz);
  //То же^
end;

procedure THIJpeg._var_idShutterSpeedValue;
begin
  dtReal(_Data,exif.ShutterSpeedValue);
end;

procedure THIJpeg._var_idApertureValue;
begin
  dtReal(_Data,exif.ApertureValue);
end;

procedure THIJpeg._var_idBrightnessValue;
begin
  dtReal(_Data,exif.BrightnessValue);
end;

procedure THIJpeg._var_idExposureBiasValue;
begin
  dtReal(_Data,exif.ExposureBiasValue);
end;

procedure THIJpeg._var_idMaxApertureValue;
begin
  dtReal(_Data,exif.MaxApertureValue);
end;

procedure THIJpeg._var_idSubjectDistance;
begin
  dtReal(_Data,exif.SubjectDistance);
end;

procedure THIJpeg._var_idMeteringMode;
begin
  dtInteger(_Data,exif.MeteringMode);
end;

procedure THIJpeg._var_idLightSource;
begin
  dtInteger(_Data,exif.LightSource);
end;

procedure THIJpeg._var_idFlash;
begin
  dtInteger(_Data,exif.Flash);
end;

procedure THIJpeg._var_idFocalLength;
begin
  dtReal(_Data,exif.FocalLength);
end;

procedure THIJpeg._var_idFlashEnergy;
begin
  dtReal(_Data,exif.FlashEnergy);
end;

procedure THIJpeg._var_idFocalPlaneXResolution;
begin
  dtReal(_Data,exif.FocalPlaneXResolution);
end;

procedure THIJpeg._var_idFocalPlaneYResolution;
begin
  dtReal(_Data,exif.FocalPlaneYResolution);
end;

procedure THIJpeg._var_idFocalPlaneResolutionUnit;
begin
  dtInteger(_Data,exif.FocalPlaneResolutionUnit);
end;

procedure THIJpeg._var_idExposureIndex;
begin
  dtReal(_Data,exif.ExposureIndex);
end;

procedure THIJpeg._var_idSensingMethod;
begin
  dtInteger(_Data,exif.SensingMethod);
end;

procedure THIJpeg._var_idFileSource;
begin
  dtInteger(_Data,exif.FileSource);
end;

procedure THIJpeg._var_idExposureMode;
begin
  dtInteger(_Data,exif.ExposureMode);
end;

procedure THIJpeg._var_idWhiteBalance;
begin
  dtInteger(_Data,exif.WhiteBalance);
end;

procedure THIJpeg._var_idDigitalZoomRatio;
begin
  dtReal(_Data,exif.DigitalZoomRatio);
end;

procedure THIJpeg._var_idFocalLengthIn35mmFilm;
begin
  dtReal(_Data,exif.FocalLengthIn35mmFilm);
end;

procedure THIJpeg._var_idSceneCaptureType;
begin
  dtInteger(_Data,exif.SceneCaptureType);
end;

procedure THIJpeg._var_idGainControl;
begin
  dtInteger(_Data,exif.GainControl);
end;

procedure THIJpeg._var_idContrast;
begin
  dtInteger(_Data,exif.Contrast);
end;

procedure THIJpeg._var_idSaturation;
begin
  dtInteger(_Data,exif.Saturation);
end;

procedure THIJpeg._var_idSharpness;
begin
  dtInteger(_Data,exif.Sharpness);
end;

procedure THIJpeg._var_idSubjectDistanceRange;
begin
  dtInteger(_Data,exif.SubjectDistanceRange);
end;

procedure THIJpeg._var_idTemperature;
begin
  dtReal(_Data,exif.Temperature);
end;

procedure THIJpeg._var_idHumidity;
begin
  dtReal(_Data,exif.Humidity);
end;

procedure THIJpeg._var_idPressure;
begin
  dtReal(_Data,exif.Pressure);
end;

procedure THIJpeg._var_idWaterDepth;
begin
  dtReal(_Data,exif.WaterDepth);
end;

procedure THIJpeg._var_idAcceleration;
begin
  dtReal(_Data,exif.Acceleration);
end;

procedure THIJpeg._var_idCameraElevationAngle;
begin
  dtReal(_Data,exif.CameraElevationAngle);
end;

procedure THIJpeg._var_idImageUniqueID;
begin
  dtString(_Data,exif.ImageUniqueID);
end;

procedure THIJpeg._var_idCameraOwnerName;
begin
  dtString(_Data,exif.CameraOwnerName);
end;

procedure THIJpeg._var_idBodySerialNumber;
begin
  dtString(_Data,exif.BodySerialNumber);
end;

procedure THIJpeg._var_idLensSpecification;
begin
  dtString(_Data,exif.LensSpecification);
end;

procedure THIJpeg._var_idLensMake;
begin
  dtString(_Data,exif.LensMake);
end;

procedure THIJpeg._var_idLensModel;
begin
  dtString(_Data,exif.LensModel);
end;

procedure THIJpeg._var_idLensSerialNumber;
begin
  dtString(_Data,exif.LensSerialNumber);
end;

procedure THIJpeg._var_ExifMT;
var
  mt: PMT;
  dt: TData;
begin
  dtNull(_Data);
  if not exif.Valid then exit;
  dtString(dt, exif.ImageDesc);
  mt := mt_make(dt);
  mt_string(mt,exif.Make);
  mt_string(mt,exif.Model);
  mt_string(mt,exif.Software);
  mt_string(mt,exif.Artist);
  mt_string(mt,exif.OrientationDesk);
  mt_int(mt,exif.Orientation);
  mt_string(mt,exif.DateTime);
  mt_string(mt,exif.Copyright);
  mt_string(mt,exif.ExifVersion);
  mt_string(mt,exif.UserComments);
  mt_string(mt,exif.DateTimeOriginal);
  mt_string(mt,exif.DateTimeDigitized);
  mt_string(mt,exif.OffsetTime);
  mt_string(mt,exif.OffsetTimeOriginal);
  mt_string(mt,exif.OffsetTimeDigitized);
  mt_string(mt,exif.SubSecTime);
  mt_string(mt,exif.SubSecTimeOriginal);
  mt_string(mt,exif.SubSecTimeDigitized);
  mt_real(mt,exif.ExposureTime);
  mt_real(mt,exif.FNumber);
  mt_int(mt,exif.ExposureProgram);
  mt_string(mt,exif.SpectralSensitivity);
  mt_int(mt,exif.PhotographicSensitivity);
  mt_int(mt,exif.SensitivityType);
  mt_real(mt,exif.StandardOutputSensitivity);
  mt_real(mt,exif.RecommendedExposureIndex);
  mt_real(mt,exif.ISOSpeed);
  mt_real(mt,exif.ISOSpeedLatitudeyyy);
  mt_real(mt,exif.ISOSpeedLatitudezzz);
  mt_real(mt,exif.ShutterSpeedValue);
  mt_real(mt,exif.ApertureValue);
  mt_real(mt,exif.BrightnessValue);
  mt_real(mt,exif.ExposureBiasValue);
  mt_real(mt,exif.MaxApertureValue);
  mt_real(mt,exif.SubjectDistance);
  mt_int(mt,exif.MeteringMode);
  mt_int(mt,exif.LightSource);
  mt_int(mt,exif.Flash);
  mt_real(mt,exif.FocalLength);
  mt_real(mt,exif.FlashEnergy);
  mt_real(mt,exif.FocalPlaneXResolution);
  mt_real(mt,exif.FocalPlaneYResolution);
  mt_int(mt,exif.FocalPlaneResolutionUnit);
  mt_real(mt,exif.ExposureIndex);
  mt_int(mt,exif.SensingMethod);
  mt_int(mt,exif.FileSource);
  mt_int(mt,exif.ExposureMode);
  mt_int(mt,exif.WhiteBalance);
  mt_real(mt,exif.DigitalZoomRatio);
  mt_real(mt,exif.FocalLengthIn35mmFilm);
  mt_int(mt,exif.SceneCaptureType);
  mt_int(mt,exif.GainControl);
  mt_int(mt,exif.Contrast);
  mt_int(mt,exif.Saturation);
  mt_int(mt,exif.Sharpness);
  mt_int(mt,exif.SubjectDistanceRange);
  mt_real(mt,exif.Temperature);
  mt_real(mt,exif.Humidity);
  mt_real(mt,exif.Pressure);
  mt_real(mt,exif.WaterDepth);
  mt_real(mt,exif.Acceleration);
  mt_real(mt,exif.CameraElevationAngle);
  mt_string(mt,exif.ImageUniqueID);
  mt_string(mt,exif.CameraOwnerName);
  mt_string(mt,exif.BodySerialNumber);
  mt_string(mt,exif.LensSpecification);
  mt_string(mt,exif.LensMake);
  mt_string(mt,exif.LensModel);
  mt_string(mt,exif.LensSerialNumber);
  CopyData(@_Data, @dt);
  mt_free(mt);
end;
//End of Exif


procedure THIJpeg._var_Width;
begin
  {$ifdef gdip}
    dtInteger(_Data,jpg.GetWidth);
  {$else}
    dtInteger(_Data,jpg.Width);
  {$endif}
end;

procedure THIJpeg._var_Height;
begin
  {$ifdef gdip}
    dtInteger(_Data,jpg.GetHeight);
  {$else}
    dtInteger(_Data,jpg.Height);
  {$endif}
end;


{
procedure THIJpeg._var_Jpeg;
begin
   _data.Data_type := data_jpeg;
   _data.idata := integer(jpg);
end;
}
end.
