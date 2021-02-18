unit Exif; 

interface 

uses Windows, KOL, Share;

type
  TExif = class
    private
      FImageDesc          : String;     //Picture description
      FMake               : String;     //Camera manufacturer
      FModel              : String;     //Camere model
      FOrientation        : Byte;       //Image orientation - 1 normal 
      FOrientationDesk    : String;     //Image orientation description
      FCopyright          : String;     //Copyright
      FValid              : Boolean;    //Has valid Exif header 
      FDateTime           : String;     //Date and Time of Change 
      FDateTimeOriginal   : String;     //Original Date and Time
      FDateTimeDigitized  : String;     //Camshot Date and Time 
      FUserComments       : String;     //User Comments

      
      idfp                : Cardinal; 
      procedure Init; 
    public
      //***Объявить поле в public, обнулить в Init, прочитать в ReadFromFile***
      XResolution:real;
      YResolution:real;
      ResolutionUnit:byte;
      Software:String;
      Artist:String;
      //Exif IFD
      ExifVersion:String;
      //MakerNote:String;
      OffsetTime:String;
      OffsetTimeOriginal:String;
      OffsetTimeDigitized:String;
      SubSecTime:String;
      SubSecTimeOriginal:String;
      SubSecTimeDigitized:String;
      ExposureTime:real;
      FNumber:real;
      ExposureProgram:byte;
      //sensitivity-related tags
      SpectralSensitivity:String;
      PhotographicSensitivity:word; //ISOSpeedRating
      SensitivityType:byte;
      StandardOutputSensitivity:real; //По стандарту LongWord, но в hiasm оно приводится к integer, а нужно без знака
      RecommendedExposureIndex:real; //То же^
      ISOSpeed:real; //То же^
      ISOSpeedLatitudeyyy:real; //То же^
      ISOSpeedLatitudezzz:real; //То же^
      //
      ShutterSpeedValue:real;
      ApertureValue:real;
      BrightnessValue:real;
      ExposureBiasValue:real;
      MaxApertureValue:real;
      SubjectDistance:real;
      MeteringMode:byte;
      LightSource:byte;
      Flash:byte;
       FocalLength:real;
      FlashEnergy:real;
      FocalPlaneXResolution:real;
      FocalPlaneYResolution:real;
      FocalPlaneResolutionUnit:byte;
      ExposureIndex:real;
      SensingMethod:byte;
      FileSource:byte;
      ExposureMode:byte;
      WhiteBalance:byte;
      DigitalZoomRatio:real;
      FocalLengthIn35mmFilm:real;
      SceneCaptureType:byte;
      GainControl:byte;
      Contrast:byte;
      Saturation:byte;
      Sharpness:byte;
      SubjectDistanceRange:byte;
      //Tags Relating to shooting situation
      Temperature:real;
      Humidity:real;
      Pressure:real;
      WaterDepth:real;
      Acceleration:real;
      CameraElevationAngle:real;
      //
      ImageUniqueID:String;
      CameraOwnerName:String;
      BodySerialNumber:String;
      LensSpecification:String; //4 real!
      LensMake:String;
      LensModel:String;
      LensSerialNumber:String;

      constructor Create;
      procedure ReadFromFile(const FileName: AnsiString);

      property ImageDesc: String read FImageDesc; 
      property Make: String read FMake;
      property Model: String read FModel;
      property Orientation: Byte read FOrientation; 
      property OrientationDesk: String read FOrientationDesk; 
      property Copyright: String read FCopyright; 
      property Valid: Boolean read FValid; 
      property DateTime: String read FDateTime;
      property DateTimeOriginal: String read FDateTimeOriginal;
      property DateTimeDigitized: String read FDateTimeDigitized;
      property UserComments: String read FUserComments;
  end;

implementation

type 
  TMarker = record 
    Marker   : Word;      //Section marker 
    Len      : Word;      //Length Section (-2 байта имени маркера)
    Indefin  : Array [0..4] of AnsiChar; //Indefiner - "Exif" 00, "JFIF" 00 and ets 
    Pad      : AnsiChar;      //0x00 
  end; 

  TTag = record 
    TagID   : Word;       //Tag number 
    TagType : Word;       //Type tag 
    Count   : LongWord;   //tag length 
    OffSet  : LongWord;   //Offset / Value 
  end; 

  TIFDHeader = record 
    //pad          : Byte; //00h
    ByteOrder    : Word; //II (4D4D) or MM ($4D4D)
    i42          : Word; //2A00
    IFD0offSet   : LongWord; //0th offset IFD
    //Interoperabil: Byte; 
  end;

procedure TExif.Init; 
begin
  idfp := 0;

  FValid := False;
  FImageDesc := '';
  FMake := '';
  FModel := ''; 
  FOrientation := 1;
  FOrientationDesk := 'Normal';
  FDateTime := '';
  FCopyright := '';
  XResolution := 0;
  YResolution := 0;
  ResolutionUnit := 0;
  Software := '';
  Artist := '';

  ExifVersion := '';
  //MakerNote := '';
  FUserComments := '';
  FDateTimeOriginal := '';
  FDateTimeDigitized := '';
  OffsetTime := '';
  OffsetTimeOriginal := '';
  OffsetTimeDigitized := '';
  SubSecTime := '';
  SubSecTimeOriginal := '';
  SubSecTimeDigitized := '';
  ExposureTime := 0;
  FNumber := 0;
  ExposureProgram := 0;
  //sensitivity-related tags
  SpectralSensitivity := '';
  PhotographicSensitivity := 0;
  SensitivityType := 0;
  StandardOutputSensitivity := 0;
  RecommendedExposureIndex := 0;
  ISOSpeed := 0;
  ISOSpeedLatitudeyyy := 0;
  ISOSpeedLatitudezzz := 0;
  //
  ShutterSpeedValue := 0;
  ApertureValue := 0;
  BrightnessValue := 0;
  ExposureBiasValue := 0;
  MaxApertureValue := 0;
  SubjectDistance := 0;
  MeteringMode := 0;
  LightSource := 0;
  Flash := 0;
  FocalLength := 0;
  FlashEnergy := 0;
  FocalPlaneXResolution := 0;
  FocalPlaneYResolution := 0;
  FocalPlaneResolutionUnit := 0;
  ExposureIndex := 0;
  SensingMethod := 0;
  FileSource := 0;
  ExposureMode := 0;
  WhiteBalance := 0;
  DigitalZoomRatio := 0;
  FocalLengthIn35mmFilm := 0;
  SceneCaptureType := 0;
  GainControl := 0;
  Contrast := 0;
  Saturation := 0;
  Sharpness := 0;
  SubjectDistanceRange := 0;
  //Tags Relating to shooting situation
  Temperature := 0;
  Humidity := 0;
  Pressure := 0;
  WaterDepth := 0;
  Acceleration := 0;
  CameraElevationAngle := 0;
  //
  ImageUniqueID := '';
  CameraOwnerName := '';
  BodySerialNumber := '';
  LensSpecification := '';
  LensMake := '';
  LensModel := '';
  LensSerialNumber := '';
end; 

constructor TExif.Create; 
begin 
  Init;
end;

procedure TExif.ReadFromFile(const FileName: AnsiString); 
const
  ori: array[1..8] of String = ('Normal','Mirrored','Rotated 180','Rotated 180, mirrored','Rotated 90 left, mirrored','Rotated 90 right','Rotated 90 right, mirrored','Rotated 90 left');
var
  f: PStream;
  j: TMarker; 
  idf: TIFDHeader;
  off0: Cardinal; //Null Exif Offset
  tag: TTag;
  i: Integer;
  SOI: Word; //2 bytes SOI marker. FF D8 (Start Of Image)
  cntFld: Word;
  fp,n,d: LongWord;

  //Auxiliary functions
  function ISwap16(const w: Word): Word; //Convert Little-Endian <-> Big-Endian
  begin
    if idf.ByteOrder = $4D4D then Result := Lo(W)*$100 + Hi(W) else Result := W;
  end;
  
  function ISwap32(const Figure: LongWord): LongWord; //Convert Little-Endian <-> Big-Endian
  var arr:array [0..3] of Byte absolute Figure;
  begin
    if idf.ByteOrder = $4D4D then
      //Result := arr[0]*16777216 + arr[1]*65536 + arr[2]*256 + arr[3]
      Result := (arr[0] shl 24) or (arr[1] shl 16) or (arr[2] shl 8) or arr[3]
    else
      Result := Figure;
  end;
  
  function ReadRational(const Offset:LongWord; signed:boolean):real; //Rational: two LONGs (numerator and denominator).
  begin
    Result := 0;
    fp := f.Position;
    try
      f.Position := Offset;
      f.Read(n,4);
      f.Read(d,4);
      if d=0 then Result:=0 else //Division by zero!
        if signed then Result := integer(ISwap32(n)) / integer(ISwap32(d)) else Result := ISwap32(n)/ISwap32(d);
    except
    end;
    f.Position := fp;
  end;
  
  function ReadRationalD(const Offset:LongWord; signed:boolean):real; //Rational: two LONGs (numerator and denominator).
  begin
    Result := 0;
    fp := f.Position;
    try
      f.Position := Offset;
      f.Read(n,4);
      f.Read(d,4);
      if d=0 then Result:=0 else //Division by zero!
        if d=$FFFFFFFF then Result:=(-1)*$FFFFFFFF else //If the denominator is FFFFFFFF.H, unknown shall be indicated.
          if signed then Result := integer(ISwap32(n)) / integer(ISwap32(d)) else Result:=ISwap32(n)/ISwap32(d);
    except
    end;
    f.Position := fp;
  end;
  
  function GetShort(const Value: LongWord): Word; //Из 4-х байт добывает 2 первых для Short
  begin
    if idf.ByteOrder = $4D4D then Result := Value div $10000 else Result := Value mod $10000;
  end;
  
  function ReadAscii(const Offset, Count: LongWord): AnsiString;
  var
    L: Integer;
  begin
    Result := '';
    fp := f.Position;
    try
      if Count <= 4 then f.Position := f.Position-4 else f.Position := Offset;
      SetLength(Result, Count);
      f.Read(Result[1], Count);
      // Убираем конечные #0 (?)
      // TODO: проверить спецификацию EXIF. Практика показывает там только 0 или 1 #0 
      // - достаточно сделать SetLength(Result, Count-1)
      L := Count;
      while (L > 0) and (Result[L] = #0) do Dec(L);
      if L < Count then SetLength(Result, L);
    except
    end;
    f.Position := fp;
  end;
  //////

begin
  //if not FileExists(FileName) then exit;
  f := NewReadFileStream(FileName);
  if f.Handle = INVALID_HANDLE_VALUE then // Невозможно открыть файл. TODO: сообщать об ошибке
  begin
    f.Free;
    exit;
  end;
 
  Init;

  // TODO: заменить объёмные "if ... then ... end" на "if ... then goto finish"
  f.Read(SOI, 2);
  if SOI = $D8FF then
  begin
    f.Read(j, 10);

    while (Lo(j.Marker) = $FF) and (f.Position < f.Size-1) do //$FF - префикс маркера любого раздела, если его нет - мы на собственно jpg-данных или конец файла, так что скачем по ним
      if (Hi(j.Marker) = $E1) and (j.Indefin = 'Exif') then break
      else //Не APP1: например, $E0FF - APP0 (JFIF), $EEFF - Adobe...
      begin
        f.Position := f.Position - 8 + (Lo(j.Len)*$100 + Hi(j.Len)); //Skip (big-endian!)
        f.Read(j,10);
      end;

    if (j.Marker = $E1FF) and (j.Indefin = 'Exif') then  //If we found Exif Section. (APP1) j.Indefin = 'Exif'#0.
    begin
      FValid := True;
      off0 := f.Position; //0'th offset TIFF header
      f.Read(idf, 8);  //Read TIFF Header
      idf.IFD0offSet := ISwap32(idf.IFD0offSet);
      f.Position := off0 + idf.IFD0offSet; //Переходим от заголовка TIFF к 0-му IFD
      f.Read(cntFld, 2); //Кол-во полей в 0-м IFD
      cntFld := ISwap16(cntFld);
      //

      i := 0;
      repeat
        inc(i);
        f.Read(tag,12);
        tag.TagID := ISwap16(tag.TagID);
        //tag.TagType := ISwap16(tag.TagType); //Нигде не используется, незачем выполнять
        tag.Count := ISwap32(tag.Count);
        tag.OffSet := ISwap32(tag.OffSet);
        case tag.TagID of
          $0112:
            begin
              FOrientation := GetShort(tag.OffSet);
              if FOrientation in [1..8] then
                FOrientationDesk := ori[FOrientation]
              else
                FOrientationDesk:='Unknown';
            end;
          $011A: XResolution := ReadRational(tag.OffSet+off0, false);
          $011B: YResolution := ReadRational(tag.OffSet+off0, false);
          $0128: ResolutionUnit := GetShort(tag.OffSet); //2 - inches, 3 - centimeters
          $0132: FDateTime := ReadAscii(tag.OffSet+off0,tag.Count);
          $010E: FImageDesc := ReadAscii(tag.OffSet+off0,tag.Count);
          $010F: FMake := ReadAscii(tag.OffSet+off0,tag.Count);
          $0110: FModel := ReadAscii(tag.OffSet+off0,tag.Count);
          $0131: Software := ReadAscii(tag.OffSet+off0,tag.Count);
          $013B: Artist := ReadAscii(tag.OffSet+off0,tag.Count);
          $8298: 
            begin
              FCopyright := ReadAscii(tag.OffSet+off0, tag.Count);
              Replace(FCopyright, #0, #9)
            end; //photographer and editor copyright separate by NULL
          $8769: idfp := Tag.OffSet; //Read Exif IFD offset //
        end;
      until (i >= cntFld);

      //Exif IFD
      if idfp > 0 then
      begin
        f.Position := idfp + off0; //off0 - начало TIFF Header
        f.Read(cntFld,2);
        cntFld := ISwap16(cntFld);
        i := 0;
        repeat
          inc(i);
          f.Read(tag, 12);
          tag.TagID := ISwap16(tag.TagID);
          //tag.TagType := ISwap16(tag.TagType);
          tag.Count := ISwap32(tag.Count);
          tag.OffSet := ISwap32(tag.OffSet);
          case tag.TagID of
            $9000: ExifVersion := ReadAscii(f.Position-4,4); //В самом tag.OffSet значение типа "0231"
            //$927C - MakerNote. Для нек-ых произв. это целая IFD-секция (внутри Exif-IFD), теги в ней зависят от произв.
            $9286: FUserComments := ReadAscii(tag.OffSet+off0,tag.Count); //Первые 8 байт - всегда указатель на кодировку (по стандарту), остальные - сами данные
            $9003: FDateTimeOriginal := ReadAscii(tag.OffSet+off0,tag.Count);
            $9004: FDateTimeDigitized := ReadAscii(tag.OffSet+off0,tag.Count);
            $9010: OffsetTime := ReadAscii(tag.OffSet+off0,tag.Count); //offset from UTC
            $9011: OffsetTimeOriginal := ReadAscii(tag.OffSet+off0,tag.Count);
            $9012: OffsetTimeDigitized := ReadAscii(tag.OffSet+off0,tag.Count);
            $9290: SubSecTime := ReadAscii(tag.OffSet+off0,tag.Count); //Subseconds for time
            $9291: SubSecTimeOriginal := ReadAscii(tag.OffSet+off0,tag.Count);
            $9292: SubSecTimeDigitized := ReadAscii(tag.OffSet+off0,tag.Count);
            $829A: ExposureTime := ReadRational(tag.OffSet+off0, false);
            $829D: FNumber := ReadRational(tag.OffSet+off0, false);
            $8822: ExposureProgram := GetShort(tag.OffSet);
            //sensitivity-related tags
            $8824: SpectralSensitivity := ReadAscii(tag.OffSet+off0,tag.Count);
            $8827: PhotographicSensitivity := GetShort(tag.OffSet); //значение параметра, указанного в SensitivityType (ISOSpeedRatings)
            $8830: SensitivityType := GetShort(tag.OffSet); //какой из параметров ISO12232 записан в PhotographicSensitivity
            $8831: StandardOutputSensitivity := tag.OffSet;
            $8832: RecommendedExposureIndex := tag.OffSet;
            $8833: ISOSpeed := tag.OffSet;
            $8834: ISOSpeedLatitudeyyy := tag.OffSet;
            $8835: ISOSpeedLatitudezzz := tag.OffSet;
            //
            $9201: ShutterSpeedValue := ReadRational(tag.OffSet+off0, true); //Значение в единицах APEX
            $9202: ApertureValue := ReadRational(tag.OffSet+off0, false); //Значение в единицах APEX
            $9203: BrightnessValue := ReadRational(tag.OffSet+off0, true); //Значение в единицах APEX
            $9204: ExposureBiasValue := ReadRational(tag.OffSet+off0, true); //Значение в единицах APEX
            $9205: MaxApertureValue := ReadRational(tag.OffSet+off0, false); //Значение в единицах APEX
            $9206: SubjectDistance := ReadRational(tag.OffSet+off0, false); //0 - расст. неизвестно, $FFFFFFFF - бесконечность
            $9207: MeteringMode := GetShort(tag.OffSet);
            $9208: LightSource := GetShort(tag.OffSet);
            $9209: Flash := GetShort(tag.OffSet);
            $920A: FocalLength := ReadRational(tag.OffSet+off0, false);
            $A20B: FlashEnergy := ReadRational(tag.OffSet+off0, false);
            $A20E: FocalPlaneXResolution := ReadRational(tag.OffSet+off0, false);
            $A20F: FocalPlaneYResolution := ReadRational(tag.OffSet+off0, false);
            $A210: FocalPlaneResolutionUnit := GetShort(tag.OffSet);
            $A215: ExposureIndex := ReadRational(tag.OffSet+off0, false);
            $A217: SensingMethod := GetShort(tag.OffSet);
            $A300: FileSource := ord(ReadAscii(f.Position-4,1)[1]); //всегда в 1-м байте tag.OffSet-а
            $A402: ExposureMode := GetShort(tag.OffSet);
            $A403: WhiteBalance := GetShort(tag.OffSet);
            $A404: DigitalZoomRatio := ReadRational(tag.OffSet+off0, false);
            $A405: FocalLengthIn35mmFilm := GetShort(tag.OffSet);
            $A406: SceneCaptureType := GetShort(tag.OffSet);
            $A407: GainControl := GetShort(tag.OffSet);
            $A408: Contrast := GetShort(tag.OffSet);
            $A409: Saturation := GetShort(tag.OffSet);
            $A40A: Sharpness := GetShort(tag.OffSet);
            $A40C: SubjectDistanceRange := GetShort(tag.OffSet);
            //Tags Relating to shooting situation  //Если d=$FFFFFFFF, выдаёт -$FFFFFFFF (unknown)
            $9400: Temperature := ReadRationalD(tag.OffSet+off0, true);
            $9401: Humidity := ReadRationalD(tag.OffSet+off0, false);
            $9402: Pressure := ReadRationalD(tag.OffSet+off0, false);
            $9403: WaterDepth := ReadRationalD(tag.OffSet+off0, true);
            $9404: Acceleration := ReadRationalD(tag.OffSet+off0, false);
            $9405: CameraElevationAngle := ReadRationalD(tag.OffSet+off0, true);
            //
            $A420: ImageUniqueID := ReadAscii(tag.OffSet+off0,tag.Count);
            $A430: CameraOwnerName := ReadAscii(tag.OffSet+off0,tag.Count);
            $A431: BodySerialNumber := ReadAscii(tag.OffSet+off0,tag.Count);
            $A432: LensSpecification := Double2str(ReadRational(tag.OffSet+off0, false)) + '|' +
                        Double2str(ReadRational(tag.OffSet+off0+8, false)) + '|' +
                        Double2str(ReadRational(tag.OffSet+off0+16, false)) + '|' +
                        Double2str(ReadRational(tag.OffSet+off0+24, false));
            $A433: LensMake := ReadAscii(tag.OffSet+off0,tag.Count);
            $A434: LensModel := ReadAscii(tag.OffSet+off0,tag.Count);
            $A435: LensSerialNumber := ReadAscii(tag.OffSet+off0,tag.Count);
          end;
        until (i >= cntFld);
      end; //if idfp > 0

    end; //if (j.Marker = $E1FF) and (j.Indefin = 'Exif')
  end; //if SOI=$D8FF
  f.Free;
end;

end.
