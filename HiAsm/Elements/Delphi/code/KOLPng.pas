{Portable Network Graphics for Key Objects Library adaptation
 by Kladov Vladimir 29-Sep-2002 ( bonanzas@xcl.cjb.net, http://xcl.cjb.net )
 from source of TPngImage
 by Gustavo Huffenbacher Daud ( gubadaud@terra.com.br, pngdelphi.sourceforge.net ) }

unit KOLPng;
{* PNG - Portable Network Graphics format support for KOL.
   version from 31-May-2003 }

{$IFNDEF FPC}
  {.$I KOLDEF.INC}
{$ENDIF}
{$IFDEF EXTERNAL_DEFINES}
        {$INCLUDE EXTERNAL_DEFINES.INC}
{$ENDIF EXTERNAL_DEFINES}

interface

{Triggers avaliable}

{.$DEFINE CheckCRC}               //Enables CRC checking
{.$DEFINE PartialTransparentDraw} //Draws partial transparent images
{$IFDEF WIN64}
  {$DEFINE PAS_PNG}
{$ENDIF}

{$RANGECHECKS OFF} {$J+}
{$IFNDEF PAS_VERSION}
  {$IFNDEF PAS_PNG}
    {$DEFINE ASM_VERSION}
  {$ENDIF}
{$ENDIF}

{$IFDEF ASM_VERSION}
  {$IFNDEF PNG_NOMMX}
//    {$DEFINE PNG_MMX}
  {$ENDIF}
{$ENDIF}

uses
  Windows, KOL, {$IFDEF FPC}paszlib{$ELSE}KOLZlib{$ENDIF} {$IFDEF PNG_MMX}, Mmx {$ENDIF};

const
  {Avaliable PNG filters for mode 0}
  FILTER_NONE    = 0;
  FILTER_SUB     = 1;
  FILTER_UP      = 2;
  FILTER_AVERAGE = 3;
  FILTER_PAETH   = 4;

  {Avaliable color modes for PNG}
  COLOR_GRAYSCALE      = 0;
  COLOR_RGB            = 2;
  COLOR_PALETTE        = 3;
  COLOR_GRAYSCALEALPHA = 4;
  COLOR_RGBALPHA       = 6;


{$IFNDEF FPC}
  {$ifdef win64}
    NativeInt = Int64;
    NativeUInt = UInt64;
  {$else}
    NativeInt = Integer;
    NativeUInt = Cardinal;
  {$endif}
{$ENDIF}



{Error types}
type
  TPngError = ( ErrOK, ErrInvalidCRC, ErrInvalidIHDR, ErrSizeExceeds, ErrUnknownCompression,
            ErrUnknownInterlace, ErrInvalidPalette, ErrMissingMultipleIDAT,
            ErrZLibError, ErrInvalidHeader, ErrUnexpectedEnd, ErrIHDRNotFirst,
            ErrUnknownCriticalChunk, ErrNoImageData );

  TOnPngProgress = function( Sender: PObj; Pass, MaxPass: Integer; Progress: Integer ): Boolean of object;
  TOnGetRow = procedure( Sender: PObj; Row: Integer; var W, H: Integer; var Dta, Trans: PByte;
    var Stop: Boolean ) of object;

  TPngScale = ( psFullImage, psHalfSize, psQuarterSize, psEightsSize );

type
  {Same as TBitmapInfo but with allocated space for}
  {palette entries}
  TMAXBITMAPINFO = packed record
    bmiHeader: TBitmapInfoHeader;
    bmiColors: packed array[0..255] of TRGBQuad;
  end;

  {Transparency mode for pngs}
  TPNGTransparencyMode = (ptmNone, ptmBit, ptmPartial);
  {Access to a rgb pixel}
  pRGBPixel = ^TRGBPixel;
  TRGBPixel = packed record
    B, G, R: Byte;
  end;

  {Pointer to an array of bytes type}
  TByteArray = array[Word] of Byte;
  PByteArray = ^TByteArray;

  {Forward}
  PPngObject = ^TPngObject;
  //TPNGObject = object;
  pPointerArray = ^TPointerArray;
  TPointerArray = array[Word] of Pointer;

  {Chunk name object}
  TChunkName = array[0..3] of AnsiChar;

  {Forward declaration}
  PChunk = ^TChunk;
  PChunkIEND = PChunk;

  {Forward}
  PChunkIHDR = ^TChunkIHDR;

  {Interlace method}
  TInterlaceMethod = (imNone, imAdam7);
  {Compression level type}
  TCompressionLevel = 0..9;
  {Filters type}
  TFilter = (pfNone, pfSub, pfUp, pfAverage, pfPaeth);
  TFilters = set of TFilter;

  {Png implementation object}
  TPngObject = object( TObj )
  private
   //- fix: HiAsm 
    fOldBitmapData:record
       fDIBBits:Pointer;
       fWidth:cardinal;
       fHeight:cardinal;
       fScanLineSize:cardinal;
       fDibSize:cardinal;
    end;
    //- fix: HiAsm 
    fOnProgress: TOnPngProgress;
    fScale: TPngScale;
    fOnGetRow: TOnGetRow;
    function GetScaledHeight: Integer;
    function GetScaledWidth: Integer;
  protected
    FError: TPngError;
    FErrorOnInvalidCRC: Boolean;
    {Gamma table values}
    GammaTable, InverseGamma: array[Byte] of Byte;
    procedure InitializeGamma;
  protected
    {Filters to test to encode}
    fFilters: TFilters;
    {Compression level for ZLIB}
    fCompressionLevel: TCompressionLevel;
    {Maximum size for IDAT chunks}
    fMaxIdatSize: DWORD;
    {Returns if image is interlaced}
    fInterlaceMethod: TInterlaceMethod;
    {Chunks object}
    fChunkList: PList;
    {Clear all chunks in the list}
    procedure ClearChunks;
    {Returns if header is present}
    function HeaderPresent: Boolean;
    {Returns linesize and byte offset for pixels}
    procedure GetPixelInfo(var LineSize, Offset: DWORD);
    procedure SetMaxIdatSize(const Value: DWORD);
    function GetAlphaScanline(const LineIndex: Integer): PByteArray;
    function GetScanline(const LineIndex: Integer): Pointer;
    function GetTransparencyMode: TPNGTransparencyMode;
    function GetTransparentColor: TColor;
    procedure SetTransparentColor(const Value: TColor);
  protected
    {Returns image as Bitmap}
    fBitmap: PBitmap;
    function GetBitmap: PBitmap;
    {Returns image width and height}
    function GetWidth: Integer;
    function GetHeight: Integer;
    {Assigns from another TPNGObject}
    procedure AssignPNG(Source: PPNGObject);
    {Returns if the image is empty}
    function GetEmpty: Boolean;
    {Used with property Header}
    function GetHeader: PChunkIHDR;
    {Mainly internal}
    function ChunkByName( const AName: TChunkName ): Pointer;
    function CreateChunkByName( const AName: TChunkName ): Pointer;
  public
    {Generates alpha information}
    procedure CreateAlpha;
    {Removes the image transparency}
    procedure RemoveTransparency;
    {Transparent color}
    property TransparentColor: TColor read GetTransparentColor write
      SetTransparentColor;
    {Add text chunk, TChunkTEXT}
    procedure AddtEXt(const Keyword, Text: AnsiString);
    {Saves to clipboard}
    function CopyToClipboard: Boolean;
    function PasteFromClipboard: Boolean;
    {Returns a scanline from png}
    property Scanline[const Index: Integer]: Pointer read GetScanline;
    property AlphaScanline[const Index: Integer]: PByteArray read GetAlphaScanline;
    {Returns pointer to the header}
    property Header: PChunkIHDR read GetHeader;
    {Returns the transparency mode used by this png}
    property TransparencyMode: TPNGTransparencyMode read GetTransparencyMode;
    {Assigns from a windows bitmap handle}
    procedure AssignHandle(Handle: HBitmap; Transparent: Boolean;
      TranColor: ColorRef);
    procedure AssignDib( DibHeader: pBitmapInfo; DibData: Pointer; Transparent: Boolean;
      TranColor: ColorRef );
    {Returns image as bitmap}
    property Bitmap: PBitmap read GetBitmap;
    {Draws the image into a canvas}
    function Draw(DC: HDC; X, Y: Integer): Boolean;
    procedure DrawTransparent( DC: HDC; X, Y, maxX, maxY: Integer; TranColor: TColor );
    function StretchDraw( DC: HDC; const Rect: TRect ): Boolean;
    {--not use, incorrectly defined--}
    procedure StretchDrawTransparent( DC: HDC; const Rect: TRect; TranColor: TColor );
    {Draws using partial transparency}
    procedure DrawPartialTrans(DC: HDC; Rect: TRect);
    {Width and height properties}
    property Width: Integer read GetWidth;
    property Height: Integer read GetHeight;
    {Scaling down while loading}
    property Scale: TPngScale read fScale write fScale;
    property ScaledWidth: Integer read GetScaledWidth;
    property ScaledHeight: Integer read GetScaledHeight;
    {Returns if the image is interlaced}
    property InterlaceMethod: TInterlaceMethod read fInterlaceMethod
      write fInterlaceMethod;
    {Filters to test to encode}
    property Filters: TFilters read fFilters write fFilters;
    {Maximum size for IDAT chunks, default and minimum is 65536}
    property MaxIdatSize: DWORD read fMaxIdatSize write SetMaxIdatSize;
    {Property to return if the image is empty or not}
    property Empty: Boolean read GetEmpty;
    {Compression level}
    property CompressionLevel: TCompressionLevel read fCompressionLevel
      write fCompressionLevel;
    {Access to the chunk list}
    property Chunks: PList read fChunkList;
    {Object being created and destroyed}
    destructor Destroy; virtual;
    function LoadFromFile(const Filename: string): Boolean;
    procedure SaveToFile(const Filename: string);
    function LoadFromStream(Stream: PStream): Boolean;
    procedure SaveToStream(Stream: PStream);
    {Loading the image from resources}
    procedure LoadFromResourceName(Instance: HInst; const AName: string);
    procedure LoadFromResourceID(Instance: HInst; ResID: Integer);
    {Error handling}
    Property Error: TPngError read FError;
    Property ErrorOnInvalidCRC: Boolean read FErrorOnInvalidCRC write FErrorOnInvalidCRC;
    {Progress}
    property OnProgress: TOnPngProgress read fOnProgress write fOnProgress;
    property OnGetRow: TOnGetRow read fOnGetRow write fOnGetRow;
  end;

  {Base chunk object}
  TChunk = object(TObj)
  protected
    {Contains data}
    fData: Pointer;
    fDataSize: DWORD;
    {Stores owner}
    fOwner: PPngObject;
    {Returns pointer to the TChunkIHDR}
    function GetHeader: PChunkIHDR;
    {Used with property index}
    function GetIndex: Integer;
  protected
    fChnkName: AnsiString;
    {Should return chunk name}
  public
    {Returns index from list}
    property Index: Integer read GetIndex;
    {Returns pointer to the TChunkIHDR}
    property Header: PChunkIHDR read GetHeader;
    {Resize the data}
    procedure ResizeData(const NewSize: DWORD);
    {Returns data and size}
    property Data: Pointer read fData;
    property DataSize: DWORD read fDataSize;
    {Returns owner}
    property Owner: PPngObject read fOwner;
    {Being destroyed/created}
    constructor Create(AOwner: PPngObject);
    destructor Destroy; virtual;
    {Returns chunk class/name}
    property ChnkName: AnsiString read fChnkName;
    {Loads the chunk from a stream}
    function LoadFromStream(Stream: PStream; const ChunkName: TChunkName;
      Size: Integer): Boolean;
    {Saves the chunk to a stream}
    function SaveToStream(Stream: PStream): Boolean;
  end;

  {IHDR data}
  PIHDRData = ^TIHDRData;
  TIHDRData = packed record
    Width, Height: Integer;
    BitDepth,
    ColorType,
    CompressionMethod,
    FilterMethod,
    InterlaceMethod: Byte;
  end;

  {Information header chunk}
  TChunkIHDR = object(TChunk)
  protected
    {Current image}
    ImageHandle: HBitmap;
    ImageDC: HDC;

    {Output windows bitmap}
    HasPalette: Boolean;
  public
    BitmapInfo: TMaxBitmapInfo;
  protected
    BytesPerRow: Integer;
    {Stores the image bytes}
    ImageData: Pointer;
    ImageAlpha: Pointer;

    {Contains all the ihdr data}
    IHDRData: TIHDRData;
    {Resizes the image data to fill the color type, bit depth, }
    {width and height parameters}
    procedure PrepareImageData;
    {Release allocated ImageData memory}
    procedure FreeImageData;
  public
    {Properties}
    property Width: Integer read IHDRData.Width write IHDRData.Width;
    property Height: Integer read IHDRData.Height write IHDRData.Height;
    property BitDepth: Byte read IHDRData.BitDepth write IHDRData.BitDepth;
    property ColorType: Byte read IHDRData.ColorType write IHDRData.ColorType;
    property CompressionMethod: Byte read IHDRData.CompressionMethod
      write IHDRData.CompressionMethod;
    property FilterMethod: Byte read IHDRData.FilterMethod
      write IHDRData.FilterMethod;
    property InterlaceMethod: Byte read IHDRData.InterlaceMethod
      write IHDRData.InterlaceMethod;
    {Destructor/constructor}
    constructor Create(AOwner: PPngObject);
    destructor Destroy; virtual;
  end;

  {Gamma chunk}
  PChunkGAMA = ^TChunkGAMA;
  TChunkgAMA = object(TChunk)
  protected
    {Returns/sets the value for the gamma chunk}
    function GetValue: DWORD;
    procedure SetValue(const Value: DWORD);
  public
    {Returns/sets gamma value}
    property Gamma: DWORD read GetValue write SetValue;
    {Being created}
    constructor Create(AOwner: PPngObject);
  end;

  {ZLIB Decompression extra information}
  {$IFDEF FPC}
  TZStreamRec = TZStream; // From paszlib
  {$ENDIF}
  TZStreamRec2 = packed record
    {From ZLIB}
    ZLIB: TZStreamRec;
    {Additional info}
    Data: Pointer;
    fStream: PStream;
  end;

  {Palette chunk}
  PChunkPLTE = ^TChunkPLTE;
  TChunkPLTE = object(TChunk)
  protected
    {Number of items in the palette}
    fCount: Integer;
    {Contains the palette handle}
    function GetPaletteItem(Idx: Byte): TRGBQuad;
  public
    {Returns the color for each item in the palette}
    property Item[Index: Byte]: TRGBQuad read GetPaletteItem;
    {Returns the number of items in the palette}
    property Count: Integer read fCount;
  end;

  {Transparency information}
  PChunktRNS = ^TChunktRNS;
  TChunktRNS = object(TChunk)
  protected
    fBitTransparency: Boolean;
    function GetTransparentColor: ColorRef;
    {Returns the transparent color}
    procedure SetTransparentColor(const Value: ColorRef);
  public
    {Palette values for transparency}
    PaletteValues: array[Byte] of Byte;
    {Returns if it uses bit transparency}
    property BitTransparency: Boolean read fBitTransparency;
    {Returns the transparent color}
    property TransparentColor: ColorRef read GetTransparentColor write
      SetTransparentColor;
  end;

  {Actual image information}
  PChunkIDAT = ^TChunkIDAT;
  TChunkIDAT = object(TChunk)
  protected
    {Holds another pointer to the TChunkIHDR}
    //Header: PChunkIHDR;
    {Stores temporary image width and height}
    ImageWidth, ImageHeight: Integer;
    ShiftScale: Integer;
    {Size in bytes of each line and offset}
    Row_Bytes, Offset : DWORD;
    {Contains data for the lines}
    Encode_Buffer: array[0..5] of PByteArray;
    Row_Buffer: array[Boolean] of PByteArray;
    {Variable to invert the Row_Buffer used}
    RowUsed: Boolean;
    {Ending position for the current IDAT chunk}
    EndPos: Integer;
    {Filter the current line}
    procedure FilterRow;
    {Filter to encode and returns the best filter}
    function FilterToEncode: Byte;
    {Reads ZLIB compressed data}
    function IDATZlibRead(var ZLIBStream: TZStreamRec2; Buffer: Pointer;
      Count: Integer; var AEndPos: Integer; var crcfile: DWORD): Integer;
    {Compress and writes IDAT data}
    procedure IDATZlibWrite(var ZLIBStream: TZStreamRec2; Buffer: Pointer;
      const Length: DWORD);
    procedure FinishIDATZlib(var ZLIBStream: TZStreamRec2);
    {Prepares the palette}
    procedure PreparePalette;
  protected
    {Decode interlaced image}
    procedure DecodeInterlacedAdam7(Stream: PStream;
      var ZLIBStream: TZStreamRec2; const Size: Integer; var crcfile: DWORD);
    {Decode non interlaced imaged}
    procedure DecodeNonInterlaced(Stream: PStream;
      var ZLIBStream: TZStreamRec2; const Size: Integer;
      var crcfile: DWORD);
  protected
    {Encode non interlaced images}
    procedure EncodeNonInterlaced(Stream: PStream;
      var ZLIBStream: TZStreamRec2);
    {Encode interlaced images}
    procedure EncodeInterlacedAdam7(Stream: PStream;
      var ZLIBStream: TZStreamRec2);
  protected
    {Memory copy methods to decode}
    procedure CopyNonInterlacedRGB8(Src, Dest, Trans: PByte);
    procedure CopyNonInterlacedRGB16(Src, Dest, Trans: PByte);
    procedure CopyNonInterlacedPalette148(Src, Dest, Trans: PByte);
    procedure CopyNonInterlacedPalette2(Src, Dest, Trans: PByte);
    procedure CopyNonInterlacedGray2(Src, Dest, Trans: PByte);
    procedure CopyNonInterlacedGrayscale16(Src, Dest, Trans: PByte);
    procedure CopyNonInterlacedRGBAlpha8(Src, Dest, Trans: PByte);
    procedure CopyNonInterlacedRGBAlpha16(Src, Dest, Trans: PByte);
    procedure CopyNonInterlacedGrayscaleAlpha8(Src, Dest, Trans: PByte);
    procedure CopyNonInterlacedGrayscaleAlpha16(Src, Dest, Trans: PByte);
    procedure CopyInterlacedRGB8(const Pass: Byte; Src, Dest, Trans: PByte);
    procedure CopyInterlacedRGB16(const Pass: Byte; Src, Dest, Trans: PByte);
    procedure CopyInterlacedPalette148(const Pass: Byte; Src, Dest, Trans: PByte);
    procedure CopyInterlacedPalette2(const Pass: Byte; Src, Dest, Trans: PByte);
    procedure CopyInterlacedGray2(const Pass: Byte; Src, Dest,  Trans: PByte);
    procedure CopyInterlacedGrayscale16(const Pass: Byte; Src, Dest, Trans: PByte);
    procedure CopyInterlacedRGBAlpha8(const Pass: Byte; Src, Dest, Trans: PByte);
    procedure CopyInterlacedRGBAlpha16(const Pass: Byte; Src, Dest, Trans: PByte);
    procedure CopyInterlacedGrayscaleAlpha8(const Pass: Byte; Src, Dest, Trans: PByte);
    procedure CopyInterlacedGrayscaleAlpha16(const Pass: Byte; Src, Dest, Trans: PByte);
  protected
    {Memory copy methods to encode}
    procedure EncodeNonInterlacedRGB8(Src, Dest, Trans: PByte);
    procedure EncodeNonInterlacedRGB16(Src, Dest, Trans: PByte);
    procedure EncodeNonInterlacedGrayscale16(Src, Dest, Trans: PByte);
    procedure EncodeNonInterlacedPalette148(Src, Dest, Trans: PByte);
    procedure EncodeNonInterlacedRGBAlpha8(Src, Dest, Trans: PByte);
    procedure EncodeNonInterlacedRGBAlpha16(Src, Dest, Trans: PByte);
    procedure EncodeNonInterlacedGrayscaleAlpha8(Src, Dest, Trans: PByte);
    procedure EncodeNonInterlacedGrayscaleAlpha16(Src, Dest, Trans: PByte);
    procedure EncodeInterlacedRGB8(const Pass: Byte; Src, Dest, Trans: PByte);
    procedure EncodeInterlacedRGB16(const Pass: Byte; Src, Dest, Trans: PByte);
    procedure EncodeInterlacedPalette148(const Pass: Byte; Src, Dest, Trans: PByte);
    procedure EncodeInterlacedGrayscale16(const Pass: Byte; Src, Dest, Trans: PByte);
    procedure EncodeInterlacedRGBAlpha8(const Pass: Byte;Src,Dest,Trans: PByte);
    procedure EncodeInterlacedRGBAlpha16(const Pass:Byte; Src,Dest,Trans: PByte);
    procedure EncodeInterlacedGrayscaleAlpha8(const Pass: Byte; Src, Dest, Trans: PByte);
    procedure EncodeInterlacedGrayscaleAlpha16(const Pass: Byte; Src, Dest, Trans: PByte);
  end;

  {Image last modification chunk}
  PChunkTIME = ^TChunktIME;
  TChunktIME = object(TChunk)
  protected
    {Holds the variables}
    fYear: Word;
    fMonth, fDay, fHour, fMinute, fSecond: Byte;
  public
    {Returns/sets variables}
    property Year: Word read fYear write fYear;
    property Month: Byte read fMonth write fMonth;
    property Day: Byte read fDay write fDay;
    property Hour: Byte read fHour write fHour;
    property Minute: Byte read fMinute write fMinute;
    property Second: Byte read fSecond write fSecond;
  end;

  {Textual data}
  PChunkTEXT = ^TChunkTEXT;
  TChunktEXt = object(TChunk)
  protected
    fKeyword, fText: AnsiString;
  public
    destructor Destroy; virtual;
    {Keyword and text}
    property Keyword: AnsiString read fKeyword write fKeyword;
    property Text: AnsiString read fText write fText;
  end;

{Registers a New chunk class}
//procedure RegisterChunk(ChunkClass: TChunkClass);

{Calculates crc}
function update_crc(crc: DWORD; buf: PByteArray; len: Integer): DWORD;
{Invert bytes using assembly}
function ByteSwap(a: LongWord): LongWord;

function NewPngObject: PPngObject;

function BytesForPixels(const Pixels: Integer; const ColorType,
  BitDepth: Byte): Integer;

var CountFilters: array[ TFilter ] of Integer;

implementation

var
  //ChunkClasses: TPngPointerList;
  {Table of CRCs of all 8-bit messages}
  crc_table: array[0..255] of DWORD;
  {Flag: has the table been computed? Initially False}
  crc_table_computed: Boolean;
  {$IFDEF PNG_MMX}
  mmxSupported: Boolean;
  {$ENDIF}

type
  TChunkType = ( ctCommon, ctIHDR, ctIEND, ctIDAT, ctPLTE,
             ctgAMA, ctTRNS, cttEXt, cttIME );
  TLoadProc = function( Chunk: Pointer; Strm: PStream; const ChunkName: TChunkName;
            Size: Integer): Boolean;
  TSaveProc = function( Chunk: Pointer; Strm: PStream ): Boolean;
  TLoadArray = array[ TChunkType ] of TLoadProc;
  TSaveArray = array[ TChunkType ] of TSaveProc;

function IHDR_Load( Chunk: Pointer; Stream: PStream; const ChunkName: TChunkName;
         Size: Integer ): Boolean; forward;
function IDAT_Load( Chunk: Pointer; Stream: PStream; const ChunkName: TChunkName;
         Size: Integer ): Boolean; forward;
function PLTE_Load( Chunk: Pointer; Stream: PStream; const ChunkName: TChunkName;
         Size: Integer ): Boolean; forward;
function gAMA_Load( Chunk: Pointer; Stream: PStream; const ChunkName: TChunkName;
         Size: Integer ): Boolean; forward;
function TRNS_Load( Chunk: Pointer; Stream: PStream; const ChunkName: TChunkName;
         Size: Integer ): Boolean; forward;
function tEXt_Load( Chunk: Pointer; Stream: PStream; const ChunkName: TChunkName;
         Size: Integer ): Boolean; forward;
function tIME_Load( Chunk: Pointer; Stream: PStream; const ChunkName: TChunkName;
         Size: Integer ): Boolean; forward;
function IHDR_Save( Chunk: Pointer; Stream: PStream ): Boolean; forward;
function IDAT_Save( Chunk: Pointer; Stream: PStream ): Boolean; forward;
function PLTE_Save( Chunk: Pointer; Stream: PStream ): Boolean; forward;
function TRNS_Save( Chunk: Pointer; Stream: PStream ): Boolean; forward;
function tEXt_Save( Chunk: Pointer; Stream: PStream ): Boolean; forward;
function tIME_Save( Chunk: Pointer; Stream: PStream ): Boolean; forward;

function ChunkTypeByName( const Name: AnsiString ): TChunkType;
const ChunkNames: array[ TChunkType ] of AnsiString = ( '', 'IHDR', 'IEND', 'IDAT',
      'PLTE', 'gAMA', 'TRNS', 'tEXt', 'tIME' );
var I: TChunkType;
begin
  for I := High( TChunkType ) downto Succ( Low( TChunkType ) ) do
    if Name = ChunkNames[ I ] then
    begin
      Result := I; Exit;
    end;
  Result := ctCommon;
end;

{Draw transparent image using transparent color}
procedure DrawTransparentBitmap(dc: HDC; srcBits: Pointer;
  var srcHeader: TBitmapInfoHeader;
  srcBitmapInfo: pBitmapInfo; Rect: TRect; cTransparentColor: COLORREF);
var
  cColor:   COLORREF;
  bmAndBack, bmAndObject, bmAndMem: HBITMAP;
  bmBackOld, bmObjectOld, bmMemOld: HBITMAP;
  hdcMem, hdcBack, hdcObject, hdcTemp: HDC;
  ptSize, orgSize: TPOINT;
  OldBitmap, DrawBitmap: HBITMAP;
begin
  hdcTemp := CreateCompatibleDC(dc);
  // Select the bitmap
  DrawBitmap := CreateDIBitmap(dc, srcHeader, CBM_INIT, srcBits, srcBitmapInfo^,
    DIB_RGB_COLORS);
  OldBitmap := SelectObject(hdcTemp, DrawBitmap);

  // Sizes
  OrgSize.x := abs(srcHeader.biWidth);
  OrgSize.y := abs(srcHeader.biHeight);
  ptSize.x := Rect.Right - Rect.Left;        // Get width of bitmap
  ptSize.y := Rect.Bottom - Rect.Top;        // Get height of bitmap

  // Create some DCs to hold temporary data.
  hdcBack  := CreateCompatibleDC(dc);
  hdcObject := CreateCompatibleDC(dc);
  hdcMem   := CreateCompatibleDC(dc);

  // Create a bitmap for each DC. DCs are required for a number of
  // GDI functions.

  // Monochrome DCs
  bmAndBack  := CreateBitmap(ptSize.x, ptSize.y, 1, 1, nil);
  bmAndObject := CreateBitmap(ptSize.x, ptSize.y, 1, 1, nil);

  bmAndMem   := CreateCompatibleBitmap(dc, ptSize.x, ptSize.y);

  // Each DC must select a bitmap object to store pixel data.
  bmBackOld  := SelectObject(hdcBack, bmAndBack);
  bmObjectOld := SelectObject(hdcObject, bmAndObject);
  bmMemOld   := SelectObject(hdcMem, bmAndMem);

  // Set the background color of the source DC to the color.
  // contained in the parts of the bitmap that should be transparent
  cColor := SetBkColor(hdcTemp, cTransparentColor);

  // Create the object mask for the bitmap by performing a BitBlt
  // from the source bitmap to a monochrome bitmap.
  StretchBlt(hdcObject, 0, 0, ptSize.x, ptSize.y, hdcTemp, 0, 0,
    orgSize.x, orgSize.y, SRCCOPY);

  // Set the background color of the source DC back to the original
  // color.
  SetBkColor(hdcTemp, cColor);

  // Create the inverse of the object mask.
  BitBlt(hdcBack, 0, 0, ptSize.x, ptSize.y, hdcObject, 0, 0,
       NOTSRCCOPY);

  // Copy the background of the main DC to the destination.
  BitBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, dc, Rect.Left, Rect.Top,
       SRCCOPY);

  // Mask out the places where the bitmap will be placed.
  BitBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, hdcObject, 0, 0, SRCAND);

  // Mask out the transparent colored pixels on the bitmap.
//  BitBlt(hdcTemp, 0, 0, ptSize.x, ptSize.y, hdcBack, 0, 0, SRCAND);
  StretchBlt(hdcTemp, 0, 0, OrgSize.x, OrgSize.y, hdcBack, 0, 0,
    PtSize.x, PtSize.y, SRCAND);

  // XOR the bitmap with the background on the destination DC.
  StretchBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, hdcTemp, 0, 0,
    OrgSize.x, OrgSize.y, SRCPAINT);

  // Copy the destination to the screen.
  BitBlt(dc, Rect.Left, Rect.Top, ptSize.x, ptSize.y, hdcMem, 0, 0,
       SRCCOPY);

  // Delete the memory bitmaps.
  DeleteObject(SelectObject(hdcBack, bmBackOld));
  DeleteObject(SelectObject(hdcObject, bmObjectOld));
  DeleteObject(SelectObject(hdcMem, bmMemOld));
  DeleteObject(SelectObject(hdcTemp, OldBitmap));

  // Delete the memory DCs.
  DeleteDC(hdcMem);
  DeleteDC(hdcBack);
  DeleteDC(hdcObject);
  DeleteDC(hdcTemp);
end;

{Make the table for a fast CRC.}
procedure make_crc_table;
var
  c: DWORD;
  n, k: Integer;
begin

  {fill the crc table}
  for n := 0 to 255 do
  begin
    c := DWORD(n);
    for k := 0 to 7 do
    begin
      if Boolean(c and 1) then
        c := $edb88320 xor (c shr 1)
      else
        c := c shr 1;
    end;
    crc_table[n] := c;
  end;

  {The table has already being computated}
  crc_table_computed := True;
end;

{Update a running CRC with the bytes buf[0..len-1]--the CRC
 should be initialized to all 1's, and the transmitted value
 is the 1's complement of the final running CRC (see the
 crc() routine below)).}
function update_crc(crc: DWORD; buf: PByteArray; len: Integer): DWORD;
var
  c: DWORD;
  n: Integer;
begin
  c := crc;

  {Create the crc table in case it has not being computed yet}
  if not crc_table_computed then make_crc_table;

  {Update}
  for n := 0 to len - 1 do
    c := crc_table[(c XOR buf^[n]) and $FF] XOR (c shr 8);

  {Returns}
  Result := c;
end;

{Calculates the paeth predictor}
function PaethPredictor(a, b, c: Byte): Byte;
var
  pa, pb, pc: Integer;
begin
  { a = left, b = above, c = upper left }
  pa := abs(Integer( b ) - Integer( c ));      { distances to a, b, c }
  pb := abs(Integer( a ) - Integer( c ));      { distances to a, b, c }
  pc := abs(Integer( a + b ) - Integer( c ) * 2);

  { return nearest of a, b, c, breaking ties in order a, b, c }
  if (pa <= pb) and (pa <= pc) then
    Result := a
  else
    if pb <= pc then
      Result := b
    else
      Result := c;
end;

{Invert bytes using assembly}
function ByteSwap(a: LongWord): LongWord; assembler; {$ifdef FPC64}nostackframe;{$endif}
asm
  {$ifdef WIN64}
  mov eax, ecx  // ECX = a in 64-bit
  {$endif}
  bswap eax
end;

{Calculates number of bytes for the number of pixels using the}
{color mode in the paramenter}
function BytesForPixels(const Pixels: Integer; const ColorType,
  BitDepth: Byte): Integer;
begin
  case ColorType of
    {Palette and grayscale contains a single value, for palette}
    {an value of size 2^bitdepth pointing to the palette index}
    {and grayscale the value from 0 to 2^bitdepth with color intesity}
    COLOR_GRAYSCALE, COLOR_PALETTE:
      Result := (Pixels * BitDepth + 7) div 8;
    {RGB contains 3 values R, G, B with size 2^bitdepth each}
    COLOR_RGB:
      Result := (Pixels * BitDepth * 3) div 8;
    {Contains one value followed by alpha value booth size 2^bitdepth}
    COLOR_GRAYSCALEALPHA:
      Result := (Pixels * BitDepth * 2) div 8;
    {Contains four values size 2^bitdepth, Red, Green, Blue and alpha}
    COLOR_RGBALPHA:
      Result := (Pixels * BitDepth * 4) div 8;
    else
      Result := 0;
  end {case ColorType}
end;

{TChunk implementation}

{Resizes the data}
procedure TChunk.ResizeData(const NewSize: DWORD);
begin
  fDataSize := NewSize;
  ReallocMem(fData, NewSize + 1);
end;

{Returns index from list}
function TChunk.GetIndex: Integer;
begin
  Result := Owner.Chunks.IndexOf( @Self );
end;

{Returns pointer to the TChunkIHDR}
function TChunk.GetHeader: PChunkIHDR;
begin
  Result := Owner.Chunks.Items[0];
end;

{Chunk being created}
constructor TChunk.Create(AOwner: PPngObject);
begin
  {Ancestor create}
  inherited Create;

  {Initialize data holder}
  GetMem(fData, 1);
  fDataSize := 0;
  {Record owner}
  fOwner := AOwner;
end;

{Chunk being destroyed}
destructor TChunk.Destroy;
begin
  fChnkName := '';
  {Free data holder}
  FreeMem(fData); //, fDataSize + 1);
  {Let ancestor destroy}
  inherited Destroy;
end;

{Returns the chunk name}
{Saves the chunk to the stream}
function TChunk.SaveToStream(Stream: PStream): Boolean;
var
  ChunkSize, ChunkCRC: DWORD;
  NameBuf: TChunkName;
begin
  {First, write the size for the following data in the chunk}
  ChunkSize := ByteSwap(DataSize);
  Stream.Write(ChunkSize, 4);
  {The chunk name}
  Move( ChnkName[ 1 ], NameBuf[ 0 ], 4 );
  Stream.Write( NameBuf[ 0 ], 4 );
  {If there is data for the chunk, write it}
  if DataSize > 0 then Stream.Write(Data^, DataSize);
  {Calculates and write CRC}
  ChunkCRC := update_crc($ffffffff, @NameBuf[0], 4);
  ChunkCRC := ByteSwap(update_crc(ChunkCRC, Data, DataSize) xor $ffffffff);
  Stream.Write(ChunkCRC, 4);

  {Returns that everything went ok}
  Result := True;
end;


{Loads the chunk from a stream}
function TChunk.LoadFromStream(Stream: PStream; const ChunkName: TChunkName;
  Size: Integer): Boolean;
var
  CheckCRC: DWORD;
  RightCRC: DWORD;
begin
  {Copies data from source}
  ResizeData(Size);
  if Size > 0 then Stream.Read(fData^, Size);
  {Reads CRC}
  Stream.Read(CheckCRC, 4);
  CheckCrc := ByteSwap(CheckCRC);

  {Check if crc readed is valid}
    RightCRC := update_crc($ffffffff, @ChunkName[0], 4);
    RightCRC := update_crc(RightCRC, fData, Size) xor $ffffffff;
    Result := RightCRC = CheckCrc;

  {Handle CRC error}
  if not Result and Owner.FErrorOnInvalidCRC then
  begin
    {In case it coult not load chunk}
    Owner.FError := ErrInvalidCRC;
    exit;
  end
  else
    Result := True;
end;

{TChunktIME implementation}

{Chunk being loaded from a stream}
function tIME_Load(Chunk: Pointer; Stream: PStream;
  const ChunkName: TChunkName; Size: Integer): Boolean;
begin
  {Let ancestor load the data}
  Result := PChunk(Chunk).LoadFromStream(Stream, ChunkName, Size);
  if not Result or (Size <> 7) then exit; {Size must be 7}

  {Reads data}
  with PChunkTIME(Chunk)^ do
  begin
    fYear := PWord(Data)^;
    fMonth := PByte(NativeInt(Data) + 2)^;
    fDay := PByte(NativeInt(Data) + 3)^;
    fHour := PByte(NativeInt(Data) + 4)^;
    fMinute := PByte(NativeInt(Data) + 5)^;
    fSecond := PByte(NativeInt(Data) + 6)^;
  end;
end;

{Saving the chunk to a stream}
function tIME_Save(Chunk: Pointer; Stream: PStream): Boolean;
begin
  with PChunkTIME(Chunk)^ do
  begin
    {Update data}
    ResizeData(7);  {Make sure the size is 7}
    PWord(Data)^ := Year;
    PByte(NativeInt(Data) + 2)^ := Month;
    PByte(NativeInt(Data) + 3)^ := Day;
    PByte(NativeInt(Data) + 4)^ := Hour;
    PByte(NativeInt(Data) + 5)^ := Minute;
    PByte(NativeInt(Data) + 6)^ := Second;

    {Let inherited save data}
    Result := SaveToStream(Stream);
  end;
end;

{TChunktEXt implementation}

{Loading the chunk from a stream}
function tEXt_Load(Chunk: Pointer; Stream: PStream;
  const ChunkName: TChunkName; Size: Integer): Boolean;
begin
  {Load data from stream and validate}
  Result := PChunk(Chunk).LoadFromStream(Stream, ChunkName, Size);
  if not Result or (Size < 3) then exit;
  {Get text}
  with PChunkTEXT(Chunk)^ do
  begin
    fKeyword := PAnsiChar(Data); // 'keyword' is #0-terminated
    SetLength(fText, Size - Length(fKeyword) - 1);
    // Skip 'keyword' and trailing #0
    CopyMemory(Pointer(fText), Pointer(NativeInt(Data) + Length(fKeyword) + 1),
      Length(fText));
    //Move(Pointer(NativeInt(Data) + Length(fKeyword) + 1)^, fText[1], Length(fText));
  end;
end;

{Saving the chunk to a stream}
function tEXt_Save(Chunk: Pointer; Stream: PStream): Boolean;
begin
  with PChunkTEXT(Chunk)^ do
  begin
    {Size is length from keyword, plus a null character to divide}
    {plus the length of the text}
    ResizeData(Length(fKeyword) + 1 + Length(fText));
    FillChar(Data^, DataSize, #0);
    {Copy data}
    if Keyword <> '' then
      CopyMemory(Data, @fKeyword[1], Length(Keyword));
    if Text <> '' then
      CopyMemory(Pointer(NativeInt(Data) + Length(Keyword) + 1), @fText[1],
        Length(Text));
    {Let ancestor calculate crc and save}
    Result := SaveToStream(Stream);
  end;
end;


{TChunkIHDR implementation}

{Chunk being created}
constructor TChunkIHDR.Create(AOwner: PPngObject);
begin
  {Call inherited}
  inherited Create(AOwner);
  {Prepare pointers}
  ImageHandle := 0;
  ImageDC := 0;
end;

{Chunk being destroyed}
destructor TChunkIHDR.Destroy;
begin
  {Free memory}
  FreeImageData();

  {Calls TChunk destroy}
  inherited Destroy;
end;

{Release allocated image data}
procedure TChunkIHDR.FreeImageData;
begin
  {Free old image data}
  if ImageHandle <> 0  then DeleteObject(ImageHandle);
  if ImageDC     <> 0  then DeleteDC(ImageDC);
  if ImageAlpha <> nil then FreeMem(ImageAlpha);
  ImageHandle := 0;
  ImageDC := 0;
  ImageAlpha := nil;
  ImageData := nil;
end;

{Chunk being loaded from a stream}
function IHDR_Load(Chunk: Pointer; Stream: PStream; const ChunkName: TChunkName;
  Size: Integer): Boolean;
begin
  {Let TChunk load it}
  Result := PChunk(Chunk).LoadFromStream(Stream, ChunkName, Size);
  if not Result then Exit;
  
  with PChunkIHDR(Chunk)^ do
  begin
    {Now check values}
    {Note: It's recommended by png specification to make sure that the size}
    {must be 13 bytes to be valid, but some images with 14 bytes were found}
    {which could be loaded by internet explorer and other tools}
    if (fDataSize < SizeOf(TIHdrData)) then
    begin
      {Ihdr must always have at least 13 bytes}
      Result := False;
      Owner.FError := ErrInvalidIHDR;
      exit;
    end;

    {Everything ok, reads IHDR}
    IHDRData := PIHDRData(fData)^;

    IHDRData.Width := ByteSwap(IHDRData.Width);
    IHDRData.Height := ByteSwap(IHDRData.Height);

    {The width and height must not be larger than 65535 pixels}
    if (IHDRData.Width > High(Word)) or (IHDRData.Height > High(Word)) then
    begin
      Result := False;
      Owner.FError := ErrSizeExceeds;
      exit;
    end;

    {Compression method must be 0 (inflate/deflate)}
    if (IHDRData.CompressionMethod <> 0) then
    begin
      Result := False;
      Owner.FError := ErrUnknownCompression;
      exit;
    end;

    {Interlace must be either 0 (none) or 7 (adam7)}
    if (IHDRData.InterlaceMethod <> 0) and (IHDRData.InterlaceMethod <> 1) then
    begin
      Result := False;
      Owner.FError := ErrUnknownInterlace;
      exit;
    end;

    {Updates owner properties}
    Owner.InterlaceMethod := TInterlaceMethod(IHDRData.InterlaceMethod);

    {Prepares data to hold image}
    PrepareImageData();
  end;
end;

{Saving the IHDR chunk to a stream}
function IHDR_Save(Chunk: Pointer; Stream: PStream): Boolean;
begin
  with PChunkIHDR(Chunk)^ do
  begin
    {Ignore 2 bits images}
    if BitDepth = 2 then BitDepth := 4;

    {It needs to do is update the data with the IHDR data}
    {structure containing the write values}
    ResizeData(SizeOf(TIHDRData));
    PIHDRData(fData)^ := IHDRData;
    {..ByteSwap 4 byte types}
    PIHDRData(fData)^.Width := ByteSwap(PIHDRData(fData)^.Width);
    PIHDRData(fData)^.Height := ByteSwap(PIHDRData(fData)^.Height);
    {..update interlace method}
    PIHDRData(fData)^.InterlaceMethod := Byte(Owner.InterlaceMethod);
    {..and then let the ancestor SaveToStream do the hard work}
    Result := SaveToStream(Stream);
  end;
end;

{Resizes the image data to fill the color type, bit depth, }
{width and height parameters}
procedure TChunkIHDR.PrepareImageData();

  {Set the bitmap info}
  procedure SetInfo(const Bitdepth: Integer; const Palette: Boolean);
  begin

    {Copy if the bitmap contain palette entries}
    HasPalette := Palette;
    {Initialize the structure with zeros}
    FillChar(BitmapInfo, SizeOf(BitmapInfo), #0);
    {Fill the strucutre}
    with BitmapInfo.bmiHeader do
    begin
      biSize := SizeOf(TBitmapInfoHeader);
      biHeight := Height;
      biWidth := Width;
      if Owner.Scale <> psFullImage then
      begin
        biHeight := Owner.ScaledHeight;
        biWidth := Owner.ScaledWidth;
      end;
      biPlanes := 1;
      biBitCount := BitDepth;
      biCompression := BI_RGB;
    end {with BitmapInfo.bmiHeader}
  end;
begin
  {Prepare bitmap info header}
  FillChar(BitmapInfo, SizeOf(TMaxBitmapInfo), #0);
  {Release old image data}
  FreeImageData();

  {Obtain number of bits for each pixel}
  case ColorType of
    COLOR_GRAYSCALE, COLOR_PALETTE, COLOR_GRAYSCALEALPHA:
      case BitDepth of
        {These are supported by windows}
        1, 4, 8: SetInfo(BitDepth, True);
        {2 bits for each pixel is not supported by windows bitmap}
        2      : SetInfo(4, True);
        {Also 16 bits (2 bytes) for each pixel is not supported}
        {and should be transormed into a 8 bit grayscale}
        16     : SetInfo(8, True);
      end;
    {Only 1 byte (8 bits) is supported}
    COLOR_RGB, COLOR_RGBALPHA:  SetInfo(24, False);
  end {case ColorType};
  {Number of bytes for each scanline}
  BytesPerRow := (((BitmapInfo.bmiHeader.biBitCount * Owner.ScaledWidth) + 31)
    and not 31) div 8;

  if not Assigned( Owner.OnGetRow ) then
  begin
    {Build array for alpha information, if necessary}
    if (ColorType = COLOR_RGBALPHA) or (ColorType = COLOR_GRAYSCALEALPHA) then
    begin
      ImageAlpha := AllocMem( Integer(Owner.ScaledWidth) * Integer(Owner.ScaledHeight) );
      // (with zero memory)
    end;

    {Creates the image to hold the data, CreateDIBSection does a better}
    {work in allocating necessary memory}
    ImageDC := CreateCompatibleDC(0);
    ImageHandle := CreateDIBSection(ImageDC, pBitmapInfo(@BitmapInfo)^,
      DIB_RGB_COLORS, ImageData, 0, 0);

    {Build array and allocate bytes for each row}
    ZeroMemory(ImageData, BytesPerRow * Integer(Owner.ScaledHeight));
  end;
end;

{TChunktRNS implementation}

{Sets the transpararent color}
procedure TChunktRNS.SetTransparentColor(const Value: ColorRef);
var
  i: Byte;
  LookColor: TRGBQuad;
begin
  {Clears the palette values}
  FillChar(PaletteValues, SizeOf(PaletteValues), #0);
  {Sets that it uses bit transparency}
  fBitTransparency := True;


  {Depends on the color type}
  with Header^ do
    case ColorType of
      COLOR_GRAYSCALE:
      begin
        Self.ResizeData(BitDepth div 8);
        PaletteValues[0] := GetRValue(Value);
      end;
      COLOR_RGB:
      begin
        Self.ResizeData((BitDepth div 8) * 3);
        PaletteValues[0] := GetRValue(Value);
        PaletteValues[1*(BitDepth div 8)] := GetGValue(Value);
        PaletteValues[2*(BitDepth div 8)] := GetBValue(Value);
      end;
      COLOR_PALETTE:
      begin
        {Creates a RGBQuad to search for the color}
        LookColor.rgbRed := GetRValue(Value);
        LookColor.rgbGreen := GetGValue(Value);
        LookColor.rgbBlue := GetBValue(Value);
        {Look in the table for the entry}
        for i := 0 to 255 do
          if CompareMem(@BitmapInfo.bmiColors[i], @LookColor, 3) then
            Break;
        {Fill the transparency table}
        FillChar(PaletteValues, i, #255);
        Self.ResizeData(i + 1)

      end
    end {case / with};

end;

{Returns the transparent color for the image}
function TChunktRNS.GetTransparentColor: ColorRef;
var
  PaletteChunk: PChunkPLTE;
  i: Integer;
begin
  Result := 0; {Default: Unknown transparent color}

  {Depends on the color type}
  with Header^ do
    case ColorType of
      COLOR_GRAYSCALE: Result := RGB(PaletteValues[0], PaletteValues[0],
        PaletteValues[0]);
      COLOR_RGB:
        if BitDepth = 8 then
          Result := RGB(PaletteValues[0], PaletteValues[1], PaletteValues[2])
        else
          Result := RGB(PaletteValues[0], PaletteValues[2], PaletteValues[4]);
      COLOR_PALETTE:
      begin
        {Obtains the palette chunk}
        PaletteChunk := Pointer( Owner.ChunkByName('PLTE') );

        {Looks for an entry with 0 transparency meaning that it is the}
        {full transparent entry}
        for i := 0 to Self.DataSize - 1 do
          if PaletteValues[i] = 0 then
            with PaletteChunk.GetPaletteItem(i) do
            begin
              Result := RGB(rgbRed, rgbGreen, rgbBlue);
              break
            end
      end {COLOR_PALETTE}
    end {case Header.ColorType};
end;

{Saving the chunk to a stream}
function tRNS_Save(Chunk: Pointer; Stream: PStream): Boolean;
begin
  with PChunktRNS(Chunk)^ do
  begin
    {Copy palette into data buffer}
    if DataSize <= 256 then
      CopyMemory(fData, @PaletteValues[0], DataSize);

    Result := SaveToStream(Stream);
  end;
end;

{Loads the chunk from a stream}
function tRNS_Load(Chunk: Pointer; Stream: PStream; const ChunkName: TChunkName;
  Size: Integer): Boolean;
var
  i, Differ255: Integer;
begin
  {Let inherited load}
  Result := PChunk(Chunk).LoadFromStream(Stream, ChunkName, Size);

  if not Result then Exit;

  with PChunktRNS(Chunk)^ do
  begin
    {Make sure size is correct}
    if Size > 256 then
    begin
      Result := False;
      Owner.FError := ErrInvalidPalette;
      exit;
    end;

    {The unset items should have value 255}
    FillChar(PaletteValues[0], 256, #255);
    {Copy the other values}
    CopyMemory(@PaletteValues[0], fData, Size);

    {Create the mask if needed}
    case Header.ColorType of
      {Mask for grayscale and RGB}
      COLOR_RGB, COLOR_GRAYSCALE: fBitTransparency := True;
      COLOR_PALETTE:
      begin
        Differ255 := 0; {Count the entries with a value different from 255}
        {Tests if it uses bit transparency}
        for i := 0 to Size - 1 do
          if PaletteValues[i] <> 255 then Inc(Differ255);

        {If it has one value different from 255 it is a bit transparency}
        fBitTransparency := (Differ255 = 1);
      end {COLOR_PALETTE}
    end {case Header.ColorType};
  end;
end;

{ZLIB support}

const
  ZLIBAllocate = High(Word);

{Initializes ZLIB for decompression}
function ZLIBInitInflate(Stream: PStream): TZStreamRec2;
begin
  {Fill record}
  FillChar(Result, SizeOf(TZStreamRec2), #0);

  {Set internal record information}
  with Result do
  begin
    GetMem(Data, ZLIBAllocate);
    fStream := Stream;
  end;

  {Init decompression}
  InflateInit_(Result.zlib, zlib_version, SizeOf(TZStreamRec));
end;

{Initializes ZLIB for compression}
function ZLIBInitDeflate(Stream: PStream;
  Level: TCompressionlevel; Size: DWORD): TZStreamRec2;
begin
  {Fill record}
  FillChar(Result, SizeOf(TZStreamRec2), #0);

  {Set internal record information}
  with Result, ZLIB do
  begin
    GetMem(Data, Size);
    fStream := Stream;
    next_out := Data;
    avail_out := Size;
  end;

  {Inits compression}
  deflateInit_(Result.zlib, Level, zlib_version, SizeOf(TZStreamRec));
end;

{Terminates ZLIB for compression}
procedure ZLIBTerminateDeflate(var ZLIBStream: TZStreamRec2);
begin
  {Terminates decompression}
  DeflateEnd(ZLIBStream.zlib);
  {Free internal record}
  FreeMem(ZLIBStream.Data); //, ZLIBAllocate);
end;

{Terminates ZLIB for decompression}
procedure ZLIBTerminateInflate(var ZLIBStream: TZStreamRec2);
begin
  {Terminates decompression}
  InflateEnd(ZLIBStream.zlib);
  {Free internal record}
  FreeMem(ZLIBStream.Data); //, ZLIBAllocate);
end;

{Prepares the image palette}
procedure TChunkIDAT.PreparePalette;
var
  Entries: Word;
  j      : Integer;
begin
  {In case the image uses grayscale, build a grayscale palette}
  with Header^ do
    if (ColorType = COLOR_GRAYSCALE) or (ColorType = COLOR_GRAYSCALEALPHA) then
    begin
      {Calculate total number of palette entries}
      Entries := (1 shl Byte(BitmapInfo.bmiHeader.biBitCount));

      for j := 0 to Entries - 1 do
        with BitmapInfo.bmiColors[j] do
        begin
          {Calculate each palette entry}
          rgbRed := fOwner.GammaTable[MulDiv(j, 255, Entries - 1)];
          rgbGreen := rgbRed;
          rgbBlue := rgbRed;
        end; {with BitmapInfo.bmiColors[j]}
    end; {if ColorType = COLOR_GRAYSCALE..., with Header}
end;

{Reads from ZLIB}
function TChunkIDAT.IDATZlibRead(var ZLIBStream: TZStreamRec2;
  Buffer: Pointer; Count: Integer; var AEndPos: Integer;
  var crcfile: DWORD): Integer;
var
  ProcResult : Integer;
  IDATHeader : array[0..3] of AnsiChar;
  IDATCRC    : DWORD;
begin
  {Uses internal record pointed by ZLIBStream to gather information}
  with ZLIBStream, ZLIBStream.zlib do
  begin
    {Set the buffer the zlib will read into}
    next_out := Buffer;
    avail_out := Count;

    {Decode until it reach the Count variable}
    while avail_out > 0 do
    begin
      {In case it needs more data and it's in the end of a IDAT chunk,}
      {it means that there are more IDAT chunks}
      if (fStream.Position = DWORD( AEndPos )) and (avail_out > 0) and
        (avail_in = 0) then
      begin
        {End this chunk by reading and testing the crc value}
        fStream.Read(IDATCRC, 4);

        if Owner.FErrorOnInvalidCRC then
          if crcfile xor $ffffffff <> DWORD(ByteSwap(IDATCRC)) then
          begin
            Result := -1;
            Owner.FError := ErrInvalidCRC;
            exit;
          end;

        {Start reading the next chunk}
        fStream.Read(AEndPos, 4);        {Reads next chunk size}
        fStream.Read(IDATHeader[0], 4); {Next chunk header}
        {It must be a IDAT chunk since image data is required and PNG}
        {specification says that multiple IDAT chunks must be consecutive}
        if IDATHeader <> 'IDAT' then
        begin
          Owner.FError := ErrMissingMultipleIDAT;
          result := -1;
          exit;
        end;

        {Calculate chunk name part of the crc}
        crcfile := update_crc($ffffffff, @IDATHeader[0], 4);

        AEndPos := fStream.Position + DWORD( ByteSwap(EndPos) );
      end;


      {In case it needs compressed data to read from}
      if avail_in = 0 then
      begin
        {In case it's trying to read more than it is avaliable}
        if fStream.Position + DWORD( ZLIBAllocate ) > DWORD( AEndPos ) then
          avail_in := fStream.Read(Data^, DWORD( AEndPos ) - fStream.Position)
         else
          avail_in := fStream.Read(Data^, ZLIBAllocate);
        {Update crc}
        crcfile := update_crc(crcfile, Data, avail_in);

        {In case there is no more compressed data to read from}
        if avail_in = 0 then
        begin
          Result := Count - avail_out;
          Exit;
        end;

        {Set next buffer to read and record current position}
        next_in := Data;

      end {if avail_in = 0};

      ProcResult := inflate(zlib, 0);

      {In case the result was not sucessfull}
      if (ProcResult < 0) then
      begin
        Result := -1;
        Owner.FError := ErrZLibError;
        exit;
      end;

    end {while avail_out > 0};

  end {with};

  {If everything gone ok, it returns the count bytes}
  Result := Count;
end;

{TChunkIDAT implementation}

const
  {Adam 7 interlacing values}
  RowStart: array[0..6] of Integer = (0, 0, 4, 0, 2, 0, 1);
  ColumnStart: array[0..6] of Integer = (0, 4, 0, 2, 0, 1, 0);
  RowIncrement: array[0..6] of Integer = (8, 8, 8, 4, 4, 2, 2);
  ColumnIncrement: array[0..6] of Integer = (8, 8, 4, 4, 2, 2, 1);
  MaxPass: array[TPngScale] of Integer = (6,4,2,0);

{Copy interlaced images with 1 byte for R, G, B}
procedure TChunkIDAT.CopyInterlacedRGB8(const Pass: Byte; Src, Dest, Trans: PByte);
var
  Col, incDest, incCol: Integer;
  {$IFDEF ASM_VERSION}
  iW: Integer;
  GTable: Pointer;
  {$ENDIF}
begin
  Col := ColumnStart[Pass] shr ShiftScale;
  Dest := PByte(NativeInt(Dest) + Col * 3);
  incDest := (ColumnIncrement[Pass] shr ShiftScale) * 3 - 3;
  incCol := ColumnIncrement[Pass] shr ShiftScale;
  {$IFDEF ASM_VERSION}
  iW := ImageWidth - Col;
  GTable := @ fOwner.GammaTable[ 0 ];
  asm
    PUSH ESI
    PUSH EDI
    PUSH EBX
    MOV  ESI, [Src]
    MOV  EDI, [Dest]
    MOV  EBX, [GTable]
    MOV  ECX, [iW]
  @@loop:
    XOR  EAX, EAX
    LODSB
    MOV  DH, [EBX+EAX]
    BSWAP EDX
    LODSB
    MOV  DH, [EBX+EAX]
    LODSB
    MOV  DL, [EBX+EAX]
    XCHG EAX, EDX
    STOSW
    SHR  EAX, 16
    STOSB
    ADD  EDI, [incDest]
    SUB  ECX, [incCol]
    JG   @@loop
    POP  EBX
    POP  EDI
    POP  ESI
  end;
  {$ELSE}
  {Get first column and enter in loop}
  repeat
    {Copy this row}
    Dest^ := fOwner.GammaTable[PByte(NativeInt(Src) + 2)^]; Inc(Dest);
    Dest^ := fOwner.GammaTable[PByte(NativeInt(Src) + 1)^]; Inc(Dest);
    Dest^ := fOwner.GammaTable[PByte(NativeInt(Src)    )^]; Inc(Dest);

    {Move to next column}
    Inc(Src, 3);
    Inc(Dest, incDest);
    Inc(Col, incCol);
  until Col >= ImageWidth;
  {$ENDIF}
end;

{Copy interlaced images with 2 bytes for R, G, B}
procedure TChunkIDAT.CopyInterlacedRGB16(const Pass: Byte; Src, Dest, Trans: PByte);
var
  Col, incDest, incCol: Integer;
  {$IFDEF ASM_VERSION}
  iW: Integer;
  GTable: Pointer;
  {$ENDIF}
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass] shr ShiftScale;
  Dest := PByte(NativeInt(Dest) + Col * 3);
  incDest := (ColumnIncrement[Pass] shr ShiftScale) * 3 - 3;
  incCol := ColumnIncrement[Pass] shr ShiftScale;
  {$IFDEF ASM_VERSION}
  iW := ImageWidth - Col;
  GTable := @ fOwner.GammaTable[ 0 ];
  asm
    PUSH ESI
    PUSH EDI
    PUSH EBX
    MOV  ESI, [Src]
    MOV  EDI, [Dest]
    MOV  EBX, [GTable]
    MOV  ECX, [iW]
  @@loop:
    XOR  EAX, EAX
    LODSB
    MOV  DH, [EBX+EAX]
    INC  ESI
    BSWAP EDX
    LODSB
    MOV  DH, [EBX+EAX]
    INC  ESI
    LODSB
    MOV  DL, [EBX+EAX]
    INC  ESI
    XCHG EAX, EDX
    STOSW
    SHR  EAX, 16
    STOSB
    ADD  EDI, [incDest]
    SUB  ECX, [incCol]
    JG   @@loop
    POP  EBX
    POP  EDI
    POP  ESI
  end;
  {$ELSE}
  repeat
    {Copy this row}
    Dest^ := Owner.GammaTable[PByte(NativeInt(Src) + 4)^]; Inc(Dest);
    Dest^ := Owner.GammaTable[PByte(NativeInt(Src) + 2)^]; Inc(Dest);
    Dest^ := Owner.GammaTable[PByte(NativeInt(Src)    )^]; Inc(Dest);

    {Move to next column}
    Inc(Src, 6);
    Inc(Dest, incDest);
    Inc(Col, incCol);
  until Col >= ImageWidth;
  {$ENDIF}
end;

{Copy ímages with palette using bit depths 1, 4 or 8}
procedure TChunkIDAT.CopyInterlacedPalette148(const Pass: Byte; Src, Dest, Trans: PByte);
const
  BitTable: array[1..8] of Integer = ($1, $3, 0, $F, 0, 0, 0, $FF);
  StartBit: array[1..8] of Integer = (7 , 0 , 0, 4,  0, 0, 0, 0);
  ShiftBitDepthTable: array[1..8] of Integer = (0, 1, 0, 2, 0, 0, 0, 3);
var
  CurBit, Col: Integer;
  Dest2: PByte;
  BitMask, BitStart, BitDepth, incCol, ShiftBitDepth: Integer;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass] shr ShiftScale;
  //Dest := PByte(NativeInt(Dest) + Col);
  incCol := ColumnIncrement[Pass] shr ShiftScale;
  BitDepth := Header.BitDepth;
  BitMask := BitTable[BitDepth];
  BitStart := StartBit[BitDepth];
  ShiftBitDepth := ShiftBitDepthTable[ BitDepth ];
  repeat
    {Copy data}
    CurBit := BitStart;
    repeat
      {Adjust pointer to pixel byte bounds}
      Dest2 := PByte(NativeInt(Dest) + (Col shl ShiftBitDepth) shr 3);
      {Copy data}
      Dest2^ := Dest2^ or
        ( ((Src^ shr CurBit) and BitMask)
          shl (BitStart - ((Col shl ShiftBitDepth) and 7)));

      {Move to next column}
      Inc(Col, incCol);
      {Will read next bits}
      Dec(CurBit, BitDepth);
    until CurBit < 0;

    {Move to next byte in source}
    Inc(Src);
  until Col >= ImageWidth;
end;

{Copy ímages with palette using bit depth 2}
procedure TChunkIDAT.CopyInterlacedPalette2(const Pass: Byte; Src, Dest, Trans: PByte);
var
  CurBit, Col: Integer;
  Dest2: PByte;
  incCol: Integer;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass] shr ShiftScale;
  incCol := ColumnIncrement[Pass] shr ShiftScale;
  repeat
    {Copy data}
    CurBit := 6;
    repeat
      {Adjust pointer to pixel byte bounds}
      Dest2 := PByte(NativeInt(Dest) + (Col shr 1));
      {Copy data}
      Dest2^ := Dest2^ or (((Src^ shr CurBit) and $3)
         shl (4 - (Col shl 2) mod 8));
      {Move to next column}
      Inc(Col, incCol);
      {Will read next bits}
      Dec(CurBit, 2);
    until CurBit < 0;

    {Move to next byte in source}
    Inc(Src);
  until Col >= ImageWidth;
end;

{Copy ímages with grayscale using bit depth 2}
procedure TChunkIDAT.CopyInterlacedGray2(const Pass: Byte; Src, Dest, Trans: PByte);
var
  CurBit, Col, incCol: Integer;
  Dest2: PByte;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass] shr ShiftScale;
  incCol := ColumnIncrement[Pass] shr ShiftScale;
  repeat
    {Copy data}
    CurBit := 6;
    repeat
      {Adjust pointer to pixel byte bounds}
      Dest2 := PByte(NativeInt(Dest) + Col div 2);
      {Copy data}
      Dest2^ := Dest2^ or ((((Src^ shr CurBit) shl 2) and $F)
         shl (4 - (Col shl 2) mod 8));
      {Move to next column}
      Inc(Col, incCol);
      {Will read next bits}
      Dec(CurBit, 2);
    until CurBit < 0;

    {Move to next byte in source}
    Inc(Src);
  until Col >= ImageWidth;
end;

{Copy ímages with palette using 2 bytes for each pixel}
procedure TChunkIDAT.CopyInterlacedGrayscale16(const Pass: Byte; Src, Dest, Trans: PByte);
var
  Col, incColDest: Integer;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass] shr ShiftScale;
  Dest := PByte(NativeInt(Dest) + Col);
  incColDest := ColumnIncrement[Pass] shr ShiftScale;
  repeat
    {Copy this row}
    Dest^ := Src^; //Inc(Dest);

    {Move to next column}
    Inc(Src, 2);
    Inc(Dest, incColDest);
    Inc(Col, incColDest);
  until Col >= ImageWidth;
end;

{Decodes interlaced RGB alpha with 1 byte for each sample}
procedure TChunkIDAT.CopyInterlacedRGBAlpha8(const Pass: Byte; Src, Dest, Trans: PByte);
var
  Col, incDest, incTrans, incCol: Integer;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass] shr ShiftScale;
  Dest := PByte(NativeInt(Dest) + Col * 3);
  Trans := PByte(NativeInt(Trans) + Col);
  incDest := (ColumnIncrement[Pass] shr ShiftScale) * 3 - 2;
  incTrans := ColumnIncrement[Pass] shr ShiftScale;
  incCol := ColumnIncrement[Pass] shr ShiftScale;
  repeat
    {Copy this row and alpha value}
    Trans^ := PByte(NativeInt(Src) + 3)^;
    Dest^  := fOwner.GammaTable[PByte(NativeInt(Src) + 2)^]; Inc(Dest);
    Dest^  := fOwner.GammaTable[PByte(NativeInt(Src) + 1)^]; Inc(Dest);
    Dest^  := fOwner.GammaTable[PByte(NativeInt(Src)    )^]; //Inc(Dest);

    {Move to next column}
    Inc(Src, 4);
    Inc(Dest, incDest);
    Inc(Trans, incTrans);
    Inc(Col, incCol);
  until Col >= ImageWidth;
end;

{Decodes interlaced RGB alpha with 2 bytes for each sample}
procedure TChunkIDAT.CopyInterlacedRGBAlpha16(const Pass: Byte; Src, Dest, Trans: PByte);
var
  Col, incDest, incTrans, incCol: Integer;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass] shr ShiftScale;
  Dest := PByte(NativeInt(Dest) + Col * 3);
  Trans := PByte(NativeInt(Trans) + Col);
  incDest := (ColumnIncrement[Pass] shr ShiftScale) * 3 - 2;
  incTrans := ColumnIncrement[Pass] shr ShiftScale;
  incCol := ColumnIncrement[Pass] shr ShiftScale;
  repeat
    {Copy this row and alpha value}
    Trans^ := PByte(NativeInt(Src) + 6)^;
    Dest^  := fOwner.GammaTable[PByte(NativeInt(Src) + 4)^]; Inc(Dest);
    Dest^  := fOwner.GammaTable[PByte(NativeInt(Src) + 2)^]; Inc(Dest);
    Dest^  := fOwner.GammaTable[PByte(NativeInt(Src)    )^]; //Inc(Dest);

    {Move to next column}
    Inc(Src, 8);
    Inc(Dest, incDest);
    Inc(Trans, incTrans);
    Inc(Col, incCol);
  until Col >= ImageWidth;
end;

{Decodes 8 bit grayscale image followed by an alpha sample}
procedure TChunkIDAT.CopyInterlacedGrayscaleAlpha8(const Pass: Byte; Src, Dest, Trans: PByte);
var
  Col, incDest, incTrans, incCol: Integer;
begin
  {Get first column, pointers to the data and enter in loop}
  Col := ColumnStart[Pass] shr ShiftScale;
  Dest := PByte(NativeInt(Dest) + Col);
  Trans := PByte(NativeInt(Trans) + Col);
  incDest := ColumnIncrement[Pass] shr ShiftScale;
  incTrans := ColumnIncrement[Pass] shr ShiftScale;
  incCol := ColumnIncrement[Pass] shr ShiftScale;

  repeat
    {Copy this grayscale value and alpha}
    Dest^ := Src^;  Inc(Src);
    Trans^ := Src^; Inc(Src);

    {Move to next column}
    Inc(Dest, incDest);
    Inc(Trans, incTrans);
    Inc(Col, incCol);
  until Col >= ImageWidth;
end;

{Decodes 16 bit grayscale image followed by an alpha sample}
procedure TChunkIDAT.CopyInterlacedGrayscaleAlpha16(const Pass: Byte; Src, Dest, Trans: PByte);
var
  Col, incDest, incTrans, incCol: Integer;
begin
  {Get first column, pointers to the data and enter in loop}
  Col := ColumnStart[Pass] shr ShiftScale;
  Dest := PByte(NativeInt(Dest) + Col);
  Trans := PByte(NativeInt(Trans) + Col);
  incDest := ColumnIncrement[Pass] shr ShiftScale;
  incTrans := ColumnIncrement[Pass] shr ShiftScale;
  incCol := ColumnIncrement[Pass] shr ShiftScale;

  repeat
    {Copy this grayscale value and alpha, transforming 16 bits into 8}
    Dest^ := Src^;  Inc(Src, 2);
    Trans^ := Src^; Inc(Src, 2);

    {Move to next column}
    Inc(Dest, incDest);
    Inc(Trans, incTrans);
    Inc(Col, incCol);
  until Col >= ImageWidth;
end;

{Decodes an interlaced image}
procedure TChunkIDAT.DecodeInterlacedAdam7(Stream: PStream;
  var ZLIBStream: TZStreamRec2; const Size: Integer; var crcfile: DWORD);
var
  CurrentPass: Byte;
  PixelsThisRow: Integer;
  CurrentRow, CurOutRow: Integer;
  Trans, Dta: PByte;
  CopyProc: procedure(const Pass: Byte; Src, Dest, Trans: PByte) of object;
  progress: Integer;
  W, H: Integer;
  Stop: Boolean;
begin

  CopyProc := nil; {Initialize}
  {Determine method to copy the image data}
  case Header.ColorType of
    {R, G, B values for each pixel}
    COLOR_RGB:
      case Header.BitDepth of
        8:  CopyProc := CopyInterlacedRGB8;
       16:  CopyProc := CopyInterlacedRGB16;
      end {case Header.BitDepth};
    {Palette}
    COLOR_PALETTE, COLOR_GRAYSCALE:
      case Header.BitDepth of
        1, 4, 8: CopyProc := CopyInterlacedPalette148;
        2      : if Header.ColorType = COLOR_PALETTE then
                   CopyProc := CopyInterlacedPalette2
                 else
                   CopyProc := CopyInterlacedGray2;
        16     : CopyProc := CopyInterlacedGrayscale16;
      end;
    {RGB followed by alpha}
    COLOR_RGBALPHA:
      case Header.BitDepth of
        8:  CopyProc := CopyInterlacedRGBAlpha8;
       16:  CopyProc := CopyInterlacedRGBAlpha16;
      end;
    {Grayscale followed by alpha}
    COLOR_GRAYSCALEALPHA:
      case Header.BitDepth of
        8:  CopyProc := CopyInterlacedGrayscaleAlpha8;
       16:  CopyProc := CopyInterlacedGrayscaleAlpha16;
      end;
  end {case Header.ColorType};

  {Prepare ShiftScale}
  case Owner.Scale of
    psHalfSize   : ShiftScale := 1;
    psQuarterSize: ShiftScale := 2;
    psEightsSize : ShiftScale := 3;
    else           ShiftScale := 0;
  end;

  {Adam7 method has 7 passes to make the final image}
  for CurrentPass := 0 to MaxPass[fOwner.fScale] do
  begin
    if Assigned( Owner.fOnProgress ) then
    begin
      progress := CurrentPass * 100 div (MaxPass[fOwner.fScale]+1);
      if not Owner.fOnProgress( Owner, CurrentPass, MaxPass[fOwner.fScale], progress ) then
        break;
    end;
    {Calculates the number of pixels and bytes for this pass row}
    PixelsThisRow := (Owner.Width - (ColumnStart[CurrentPass]) +
      (ColumnIncrement[CurrentPass]) - 1)
      div (ColumnIncrement[CurrentPass]);
    Row_Bytes := BytesForPixels(PixelsThisRow, Header.ColorType,
      Header.BitDepth);
    {Clear buffer for this pass}
    ZeroMemory(Row_Buffer[not RowUsed], Row_Bytes);

    {Get current row index}
    CurrentRow := RowStart[CurrentPass];
    CurOutRow := CurrentRow shr ShiftScale;
    {Get a pointer to the current row image data}
    if not Assigned( Owner.OnGetRow ) then
    begin
      Dta := PByte(NativeInt(Header.ImageData) + Header.BytesPerRow *
        (ImageHeight - 1 - CurOutRow));
      Trans := PByte(NativeInt(Header.ImageAlpha) + ImageWidth * CurOutRow);
    end;

    if Row_Bytes > 0 then {There must have bytes for this interlaced pass}
      while CurrentRow < Owner.Height do
      begin
        if Assigned( Owner.fOnProgress ) then
        begin
          if MaxPass[fOwner.fScale] > 0 then
          progress := Round( CurrentPass * 100 / (MaxPass[fOwner.fScale]+1) +
                             CurrentRow * 100 / ImageHeight / (MaxPass[fOwner.fScale]+1) )
          else progress := CurrentRow * 100 div (ImageHeight-1);
          if not Owner.fOnProgress( Owner, CurrentPass, MaxPass[fOwner.fScale], progress ) then
            break;
        end;
        {Reads this line and filter}
        if IDATZlibRead(ZLIBStream, @Row_Buffer[RowUsed][0], Row_Bytes + 1,
          EndPos, CRCFile) = 0 then break;

        FilterRow;
        {Copy image data}
        if CurOutRow < ImageHeight then
        begin
          if Assigned(Owner.OnGetRow) then
          begin
            W := Owner.Width;
            H := Owner.Height;
            Stop := False;
            Owner.OnGetRow(Owner, CurrentRow, W, H, Dta, Trans, Stop);
            if Stop then Exit;
          end;
          CopyProc(CurrentPass, @Row_Buffer[RowUsed][1], Dta, Trans);
          if Assigned(Owner.OnGetRow) then
          begin
            W := -Owner.Width;
            H := Owner.Height;
            Stop := False;
            Owner.OnGetRow( Owner, CurrentRow, W, H, Dta, Trans, Stop );
            if Stop then Exit;
          end;
        end;

        {Use the other RowBuffer item}
        RowUsed := not RowUsed;

        {Move to the next row}
        Inc(CurrentRow, RowIncrement[CurrentPass]);
        Inc(CurOutRow, RowIncrement[CurrentPass] shr ShiftScale);
        {Move pointer to the next line}
        Dec(Dta, (RowIncrement[CurrentPass] shr ShiftScale) * Header.BytesPerRow);
        Inc(Trans, (RowIncrement[CurrentPass] shr ShiftScale) * ImageWidth);
      end {while CurrentRow < ImageHeight};

  end {for CurrentPass};

end;

{Copy 8 bits RGB image}
procedure TChunkIDAT.CopyNonInterlacedRGB8(Src, Dest, Trans: PByte);
var
  I {$IFDEF ASM_VERSION}, incSrc {$ENDIF}: Integer;
begin
  {$IFDEF ASM_VERSION}
  I := ImageWidth;
  incSrc := 3 shl ShiftScale - 4;
  asm
    PUSH ESI
    PUSH EDI
    PUSH EBP
    MOV  ESI, [Src]
    MOV  EDI, [Dest]
    MOV  ECX, [I]
    MOV  EBP, [incSrc]
  @@loop:
    LODSD
    BSWAP EAX
    ADD  ESI, EBP
    SHR  EAX, 8
    STOSW
    SHR  EAX, 16
    STOSB
    LOOP @@loop
    POP  EBP
    POP  EDI
    POP  ESI
  end;
  {$ELSE}
  for I := 1 to ImageWidth do
  begin
    {Copy pixel values}
    Dest^ := fOwner.GammaTable[PByte(NativeInt(Src) + 2)^]; Inc(Dest);
    Dest^ := fOwner.GammaTable[PByte(NativeInt(Src) + 1)^]; Inc(Dest);
    Dest^ := fOwner.GammaTable[PByte(NativeInt(Src)    )^]; Inc(Dest);
    {Move to next pixel}
    Inc(Src, 3 shl ShiftScale);
  end; {for I}
  {$ENDIF}
end;

{Copy 16 bits RGB image}
procedure TChunkIDAT.CopyNonInterlacedRGB16(Src, Dest, Trans: PByte);
var
  I, incSrc: Integer;
  {$IFDEF ASM_VERSION}
  GTable: Pointer;
  {$ENDIF}
begin
  {$IFDEF ASM_VERSION}
  I := ImageWidth;
  GTable := @ fOwner.GammaTable[0];
  incSrc := 6 shl ShiftScale - 5;
  asm
    PUSH ESI
    PUSH EDI
    PUSH EBX
    PUSH EBP
    MOV  ESI, [Src]
    MOV  EDI, [Dest]
    MOV  EBX, [GTable]
    MOV  ECX, [I]
    MOV  EBP, [incSrc]
    XOR  EAX, EAX
  @@loop:
    LODSB
    MOV  DH, [EBX+EAX]
    INC  ESI
    BSWAP EDX
    LODSB
    MOV  DH, [EBX+EAX]
    INC  ESI
    LODSB
    MOV  DL, [EBX+EAX ]
    ADD  ESI, EBP
    XCHG EAX, EDX
    STOSW
    SHR  EAX, 16
    STOSB
    XCHG EAX, EDX
    LOOP @@loop
    POP  EBP
    POP  EBX
    POP  EDI
    POP  ESI
  end;
  {$ELSE}
  incSrc := 6 shl ShiftScale;
  for I := 1 to ImageWidth do
  begin
    //Since windows does not supports (perhaps it does ?) 2 bytes for
    //each R, G, B value, the method will read only 1 byte from it
    {Copy pixel values}
    Dest^ := fOwner.GammaTable[PByte(NativeInt(Src) + 4)^]; Inc(Dest);
    Dest^ := fOwner.GammaTable[PByte(NativeInt(Src) + 2)^]; Inc(Dest);
    Dest^ := fOwner.GammaTable[PByte(NativeInt(Src)    )^]; Inc(Dest);
    {Move to next pixel}
    Inc(Src, incSrc);
  end; {for I}
  {$ENDIF}
end;

{Copy types using palettes (1, 4 or 8 bits per pixel)}
procedure TChunkIDAT.CopyNonInterlacedPalette148(Src, Dest, Trans: PByte);
var
  I, incSrc: Integer;
begin
  {It's simple as copying the data}
  if ShiftScale = 0 then
    //CopyMemory(Dest, Src, Row_Bytes)
    Move(Src^, Dest^, Row_Bytes)
  else
  {$IFDEF ASM_VERSION}
  begin
    I := ImageWidth * (Header.BitDepth div 8);
    incSrc := 1 shl ShiftScale - 1;
    asm
      PUSH ESI
      PUSH EDI
      PUSH EBP
      MOV  ESI, [Src]
      MOV  EDI, [Dest]
      MOV  ECX, [I]
      MOV  EBP, [incSrc]
    @@loop:
      MOVSB
      ADD  ESI, EBP
      LOOP @@loop
      POP  EBP
      POP  EDI
      POP  ESI
    end;
  end
  {$ELSE}
  begin
    incSrc := 1 shl ShiftScale;
    for I := 1 to ImageWidth * (Header.BitDepth div 8) do
    begin
      Dest^ := Src^; Inc(Dest);
      {Move to next pixel}
      Inc(Src, incSrc);
    end; {for I}
  end;
  {$ENDIF}
end;

{Copy grayscale types using 2 bits for each pixel}
procedure TChunkIDAT.CopyNonInterlacedGray2(Src, Dest, Trans: PByte);
var
  i: Integer;
begin
  {2 bits is not supported, this routine will converted into 4 bits}
  for i := 1 to Row_Bytes do
  begin
    Dest^ := ((Src^ shr 2) and $F) or (Src^ and $F0); Inc(Dest);
    Dest^ := ((Src^ shl 2) and $F) or ((Src^ shl 4) and $F0); Inc(Dest);
    Inc(Src, 1 shl ShiftScale);
  end {for i}
end;

{Copy types using palette with 2 bits for each pixel}
var
  Palette2_To_Palette4_Initialized: Boolean;
  Palette2_To_Palette4: array[0..255] of Word;

procedure Init_Palette2_To_Palette4;
var
  i: Integer;
begin
  Palette2_To_Palette4_Initialized := True;
  for i := 0 to 255 do
  begin
    Palette2_To_Palette4[ i ] := (i shr 4) and 3 or (i shr 2) and $30 or
                          ( ( (i and 3) or (i shl 2) and $30 ) shl 8);
  end;
end;


procedure TChunkIDAT.CopyNonInterlacedPalette2(Src, Dest, Trans: PByte);
var
  I {$IFDEF ASM_VERSION}, incSrc {$ENDIF}: Integer;
begin
  {$IFDEF ASM_VERSION}
  if not Palette2_To_Palette4_Initialized then
    Init_Palette2_To_Palette4;
  I := Row_Bytes;
  incSrc := 1 shl ShiftScale - 1;
  asm
    PUSH ESI
    PUSH EDI
    PUSH EBX
    PUSH EBP
    MOV  ESI, [Src]
    MOV  EDI, [Dest]
    MOV  ECX, [I]
    LEA  EBX, [Palette2_To_Palette4]
    MOV  EBP, [incSrc]
  @@loop:
    XOR  EAX, EAX
    LODSB
    MOV  AX, word ptr [EBX+EAX*2]
    STOSW
    ADD  ESI, EBP
    LOOP @@loop
    POP  EBP
    POP  EDI
    POP  EBX
    POP  ESI
  end;
  {$ELSE}
  {2 bits is not supported, this routine will converted into 4 bits}
  for i := 1 to Row_Bytes do
  begin
    Dest^ := ((Src^ shr 4) and $3) or ((Src^ shr 2) and $30); Inc(Dest);
    Dest^ := (Src^ and $3) or ((Src^ shl 2) and $30); Inc(Dest);
    Inc(Src, 1 shl ShiftScale);
  end; {for i}
  {$ENDIF}
end;

{Copy grayscale images with 16 bits}
procedure TChunkIDAT.CopyNonInterlacedGrayscale16(Src, Dest, Trans: PByte);
var
  I {$IFDEF ASM_VERSION}, incSrc{$ENDIF}: Integer;
begin
  {$IFDEF ASM_VERSION}
  I := ImageWidth;
  incSrc := 2 shl ShiftScale - 1;
  asm
    PUSH ESI
    PUSH EDI
    PUSH EBP
    MOV  ESI, [Src]
    MOV  EDI, [Dest]
    MOV  ECX, [I]
    MOV  EBP, [incSrc]
  @@loop:
    MOVSB
    ADD  ESI, EBP
    LOOP @@loop
    POP  EBP
    POP  EDI
    POP  ESI
  end;
  {$ELSE}
  for I := 1 to ImageWidth do
  begin
    {Windows does not supports 16 bits for each pixel in grayscale}
    {mode, so reduce to 8}
    Dest^ := Src^; Inc(Dest);
    {Move to next pixel}
    Inc(Src, 2 shl ShiftScale);
  end; {for I}
  {$ENDIF}
end;

{Copy 8 bits per sample RGB images followed by an alpha byte}
procedure TChunkIDAT.CopyNonInterlacedRGBAlpha8(Src, Dest, Trans: PByte);
var
  I: Integer;
  {$IFDEF ASM_VERSION}
  incSrc: Integer;
  GTable: Pointer;
  {$ENDIF}
begin
  {$IFDEF ASM_VERSION}
  if not Palette2_To_Palette4_Initialized then
    Init_Palette2_To_Palette4;
  I := ImageWidth;
  GTable := @ fOwner.GammaTable[0];
  incSrc := (4 shl ShiftScale) - 4;
  asm
    PUSH ESI
    PUSH EDI
    PUSH EBX
    PUSH EBP
    MOV  ESI, [Src]
    MOV  EDI, [Dest]
    MOV  ECX, [I]
    SHL  ECX, 8
    MOV  EBX, [GTable]
    MOV  CL,  byte ptr [incSrc]
    MOV  EBP, [Trans]
  @@loop:
    XOR  EAX, EAX
    LODSB
    MOV  DH, [EBX+EAX]
    BSWAP EDX
    LODSB
    MOV  DH, [EBX+EAX]
    LODSB
    MOV  DL, [EBX+EAX]
    MOV  EAX, EDX
    STOSW
    SHR  EAX, 16
    STOSB
    LODSB
    MOV  [EBP], AL
    INC  EBP
    MOVZX EAX, CL
    ADD  ESI, EAX
    SUB  ECX, 256
    MOV  EAX, ECX
    SHR  EAX, 8
    JNZ  @@loop
    POP  EBP
    POP  EBX
    POP  EDI
    POP  ESI
  end;
  {$ELSE}
  for I := 1 to ImageWidth do
  begin
    {Copy pixel values and transparency}
    Trans^ := PByte(NativeInt(Src) + 3)^; Inc(Trans);
    Dest^  := fOwner.GammaTable[PByte(NativeInt(Src) + 2)^]; Inc(Dest);
    Dest^  := fOwner.GammaTable[PByte(NativeInt(Src) + 1)^]; Inc(Dest);
    Dest^  := fOwner.GammaTable[PByte(NativeInt(Src)    )^]; Inc(Dest);
    {Move to next pixel}
    Inc(Src, 4 shl ShiftScale);
  end; {for I}
  {$ENDIF}
end;

{Copy 16 bits RGB image with alpha using 2 bytes for each sample}
procedure TChunkIDAT.CopyNonInterlacedRGBAlpha16(Src, Dest, Trans: PByte);
var
  I: Integer;
  {$IFDEF ASM_VERSION}
  incSrc: Integer;
  GTable: Pointer;
  {$ENDIF}
begin
  {$IFDEF ASM_VERSION}
  if not Palette2_To_Palette4_Initialized then
    Init_Palette2_To_Palette4;
  I := ImageWidth;
  GTable := @ fOwner.GammaTable[0];
  incSrc := 8 shl ShiftScale + 1;
  asm
    PUSH ESI
    PUSH EDI
    PUSH EBX
    PUSH EBP
    MOV  ESI, [Src]
    MOV  EDI, [Dest]
    MOV  ECX, [I]
    SHL  ECX, 8
    LEA  EBX, [GTable]
    MOV  CL,  byte ptr [incSrc]
    MOV  EBP, [Trans]
  @@loop:
    XOR  EAX, EAX
    LODSB
    MOV  DH, [EBX+EAX]
    INC  ESI
    BSWAP EDX
    LODSB
    MOV  DH, [EBX+EAX]
    INC  ESI
    LODSB
    MOV  DL, [EBX+EAX]
    INC  ESI
    MOV  EAX, EDX
    STOSW
    SHR  EAX, 16
    STOSB
    LODSB
    MOV  [EBP], AL
    INC  EBP
    MOVZX EAX, CL
    ADD  ESI, EAX
    SUB  ECX, 256
    MOV  EAX, ECX
    SHR  EAX, 8
    JNZ  @@loop
    POP  EBP
    POP  EDI
    POP  EBX
    POP  ESI
  end;
  {$ELSE}
  for I := 1 to ImageWidth do
  begin
    //Copy rgb and alpha values (transforming from 16 bits to 8 bits)
    {Copy pixel values}
    Trans^ := PByte(NativeInt(Src) + 6)^; Inc(Trans);
    Dest^  := fOwner.GammaTable[PByte(NativeInt(Src) + 4)^]; Inc(Dest);
    Dest^  := fOwner.GammaTable[PByte(NativeInt(Src) + 2)^]; Inc(Dest);
    Dest^  := fOwner.GammaTable[PByte(NativeInt(Src)    )^]; Inc(Dest);
    {Move to next pixel}
    Inc(Src, 8 shl ShiftScale);
  end {for I}
  {$ENDIF}
end;

{Copy 8 bits per sample grayscale followed by alpha}
procedure TChunkIDAT.CopyNonInterlacedGrayscaleAlpha8(Src, Dest, Trans: PByte);
var
  I{$IFDEF ASM_VERSION}, incSrc{$ENDIF}: Integer;
begin
  {$IFDEF ASM_VERSION}
  I := ImageWidth;
  incSrc := 2 shl ShiftScale - 1;
  asm
    PUSH ESI
    PUSH EDI
    PUSH EBX
    PUSH EBP
    MOV  ESI, [Src]
    MOV  EDI, [Dest]
    MOV  EBX, [Trans]
    MOV  ECX, [I]
    MOV  EBP, [incSrc]
  @@loop:
    LODSW
    STOSB
    MOV  [EBX], AH
    ADD  ESI, EBP
    INC  EBX
    LOOP @@loop
    POP  EBP
    POP  EBX
    POP  EDI
    POP  ESI
  end;
  {$ELSE}
  for I := 1 to ImageWidth do
  begin
    {Copy alpha value and then gray value}
    Dest^  := Src^;  Inc(Src);
    Trans^ := Src^;  Inc(Src, (2 shl ShiftScale) - 1);
    Inc(Dest); Inc(Trans);
  end;
  {$ENDIF}
end;

{Copy 16 bits per sample grayscale followed by alpha}
procedure TChunkIDAT.CopyNonInterlacedGrayscaleAlpha16(Src, Dest, Trans: PByte);
var
  I {$IFDEF ASM_VERSION}, incSrc{$ENDIF}: Integer;
begin
  {$IFDEF ASM_VERSION}
  I := ImageWidth;
  incSrc := 4 shl ShiftScale - 4;
  asm
    PUSH ESI
    PUSH EDI
    PUSH EBX
    PUSH EBP
    MOV  ESI, [Src]
    MOV  EDI, [Dest]
    MOV  EBX, [Trans]
    MOV  ECX, [I]
    MOV  EBP, [incSrc]
  @@loop:
    LODSD
    STOSB
    SHR  EAX, 16
    MOV  [EBX], AL
    ADD  ESI, EBP
    INC  EBX
    LOOP @@loop
    POP  EBP
    POP  EBX
    POP  EDI
    POP  ESI
  end;
  {$ELSE}
  for I := 1 to ImageWidth do
  begin
    {Copy alpha value and then gray value}
    Dest^  := Src^;  Inc(Src, 2);
    Trans^ := Src^;  Inc(Src, (4 shl ShiftScale) - 2);
    Inc(Dest); Inc(Trans);
  end;
  {$ENDIF}
end;

{Decode non interlaced image}
procedure TChunkIDAT.DecodeNonInterlaced(Stream: PStream;
  var ZLIBStream: TZStreamRec2; const Size: Integer; var crcfile: DWORD);
var
  j, y: Integer;
  Trans, Dta: PByte;
  CopyProc: procedure(Src, Dest, Trans: PByte) of object;
  W, H: Integer;
  Stop: Boolean;
begin
  CopyProc := nil; {Initialize}
  {Determines the method to copy the image data}
  case Header.ColorType of
    {R, G, B values}
    COLOR_RGB:
      case Header.BitDepth of
        8: CopyProc := CopyNonInterlacedRGB8;
       16: CopyProc := CopyNonInterlacedRGB16;
      end;
    {Types using palettes}
    COLOR_PALETTE, COLOR_GRAYSCALE:
      case Header.BitDepth of
        1, 4, 8: CopyProc := CopyNonInterlacedPalette148;
        2      : if Header.ColorType = COLOR_PALETTE then
                   CopyProc := CopyNonInterlacedPalette2
                 else
                   CopyProc := CopyNonInterlacedGray2;
        16     : CopyProc := CopyNonInterlacedGrayscale16;
      end;
    {R, G, B followed by alpha}
    COLOR_RGBALPHA:
      case Header.BitDepth of
        8  : CopyProc := CopyNonInterlacedRGBAlpha8;
       16  : CopyProc := CopyNonInterlacedRGBAlpha16;
      end;
    {Grayscale followed by alpha}
    COLOR_GRAYSCALEALPHA:
      case Header.BitDepth of
        8  : CopyProc := CopyNonInterlacedGrayscaleAlpha8;
       16  : CopyProc := CopyNonInterlacedGrayscaleAlpha16;
      end;
  end;

  {Prepare ShiftScale}
  case Owner.Scale of
    psHalfSize   : ShiftScale := 1;
    psQuarterSize: ShiftScale := 2;
    psEightsSize : ShiftScale := 3;
    else           ShiftScale := 0;
  end;

  {Get the image data pointer}
  if not Assigned(Owner.OnGetRow) then
  begin
    NativeInt(Dta) := NativeInt(Header.ImageData) +
      Header.BytesPerRow * (ImageHeight - 1);
    Trans := Header.ImageAlpha;
  end;
  {Reads each line}
  j := 0;
  for y := 0 to Owner.Height - 1 do
  begin
    if Assigned(Owner.fOnProgress) then
    begin
      if not Owner.fOnProgress(Owner, 0, 0, j * 100 div Integer(Max(1, Owner.Height-1))) then
        break;
    end;
    {Read this line Row_Buffer[RowUsed][0] if the filter type for this line}
    if IDATZlibRead(ZLIBStream, @Row_Buffer[RowUsed][0], Row_Bytes + 1, EndPos,
      CRCFile) = 0 then break;

    {Filter the current row}
    FilterRow;
    if y and ((1 shl ShiftScale)-1) = 0 then
    begin
      {Copies non interlaced row to image}
      if j < ImageHeight then
      begin
        if Assigned( Owner.OnGetRow ) then
        begin
          W := Owner.Width;
          H := Owner.Height;
          Stop := False;
          Owner.OnGetRow(Owner, y, W, H, Dta, Trans, Stop);
          if Stop then Exit;
        end;
        CopyProc(@Row_Buffer[RowUsed][1], Dta, Trans);
        if Assigned( Owner.OnGetRow ) then
        begin
          W := -Owner.Width;
          H := Owner.Height;
          Stop := False;
          Owner.OnGetRow(Owner, y, W, H, Dta, Trans, Stop);
          if Stop then Exit;
        end;
      end;
      Inc(j);

      {Invert line used}
      Dec(Dta, Header.BytesPerRow);
      Inc(Trans, ImageWidth);
    end;
    RowUsed := not RowUsed;
  end {for I};
end;

{procedure LogPaeth1(pp, a, b, c: Integer); stdcall;
begin
  LogFileOutput( GetStartDir + 'log_paet_asm.txt', Int2Str( pp ) + '<-' +
    Int2Str( a ) + ',' + Int2Str( b ) + ',' + Int2Str( c ) );
end;

procedure LogPaethAsm;
asm
  PUSH EAX
  PUSH EDX
  MOVZX EAX, AL
  MOV   EDX, EBX
  MOVZX EDX, BL
  PUSH  EDX
  MOV   EDX, EBX
  SHR   EDX, 16
  MOVZX EDX, DL
  PUSH  EDX
  MOVZX EDX, BH
  PUSH  EDX
  PUSH  EAX
  CALL  LogPaeth1
  POP  EDX
  POP  EAX
end;}

{$IFDEF PAETH_TABLE}  // Don't use it! Just to test performance
                      // and it is proved WORSTER then direct calculation!
var
  PaethTableInitialized: Boolean;
  PaethTable: PByte;

procedure InitPaethTable;
var
  P: PByte;
  a, b: Byte;
  V: Byte;
  i, c: Integer;
  pa, pb, pc: Integer;
begin
  PaethTableInitialized := True;
  GetMem( PaethTable, 256 * 256 * 256 div 4 );
  P := PaethTable;
  for a := 0 to 255 do
   for b := 0 to 255 do
   begin
     c := 0;
     while c <= 255-3 do
     begin
       V := 0;
       for i := 0 to 3 do
       begin
         pa := abs( b - c );
         pb := abs( a - c );
         pc := abs( a + b - 2*c );
         V := V shr 2;
         if (pa <= pb) and (pa <= pc) then
           V := V or $C0
         else
           if (pb <= pc) then V := V or $80
                         else V := V or $40;
         Inc( c );
       end;
       P^ := V; Inc( P );
     end;
   end;
end;
{$ENDIF}

{Filter the current line}
procedure TChunkIDAT.FilterRow;
var
  Col: DWORD;
  Offs : Integer;
  p1, p2 : PByteArray;
  {$IFDEF ASM_VERSION}
  Src, Dst: PByte;
  CntBytes: Integer;
  {$IFDEF SMALLEST_CODE}
  Src2: PByte;
  {$ENDIF}
  {$ELSE}
  {$IFDEF PAS_PNG}
  {$ELSE}
    vv, aboveleft: Integer;
    above, left: Integer;
  {$ENDIF}
  pp: Byte;
  {$ENDIF}
begin
  {Test the filter}
  case Row_Buffer[RowUsed]^[0] of
    {No filtering for this line}
    FILTER_NONE:
      begin
        {$IFDEF COUNT_FILTER}
        Inc( CountFilters[ pfNone ] );
        {$ENDIF}
      end;
    {AND 255 serves only to never let the result be larger than one byte}
    {Sub filter}
    FILTER_SUB:
      begin
        {$IFDEF COUNT_FILTER}
        Inc( CountFilters[ pfSub ] );
        {$ENDIF}
        
        {p1 := @Row_Buffer[RowUsed][Offset + 1];
        Offs := -Offset; // Negative 'Offs' FPC64 don't like
        for Col := Offset + 1 to Row_Bytes do
        begin
          p1[0] := (p1[0] + p1[Offs]); // and 255;
          Inc(PByte(p1));
        end;}
        
        // Offset = Bytes Per Pixel (e.g. 4)
        p1 := Row_Buffer[RowUsed]; // p1[0] = <filter> (above in 'case')
        for Col := Offset + 1 to Row_Bytes - 1 do
        begin
          p1[Col] := (p1[Col] + p1[Col - Offset]); // and 255;
        end;
      end;
    {Up filter}
    FILTER_UP:
      begin
        {$IFDEF COUNT_FILTER}
        Inc( CountFilters[ pfUp ] );
        {$ENDIF}
        {$IFDEF PNG_MMX}
        if mmxSupported then
        begin
          Src := @Row_Buffer[not RowUsed][0];
          Dst := @Row_Buffer[RowUsed][0];
          CntBytes := (Row_Bytes + 8) shr 3;
          asm
            MOV  EDX, [Dst]
            MOV  EAX, [Src]
            SUB  EAX, EDX
            MOV  ECX, [CntBytes]
            movq mm0, qword ptr [EDX+EAX]
            psrlq mm0, 8
            psllq mm0, 8
            jmp  @@1
          @@loop:
            movq mm0, qword ptr [EDX+EAX]
          @@1:
            movq mm1, qword ptr [EDX]
            paddb mm0, mm1
            movq qword ptr [EDX], mm0
            ADD  EDX, 8
            LOOP @@loop
            emms
          end;
        end
        else
        {$ENDIF}
        begin
          p1 := @Row_Buffer[RowUsed][1];
          p2 := @Row_Buffer[not RowUsed][1];
          for Col := 1 to Row_Bytes do
          begin
            p1[0] := (p1[0] + p2[0]); // and 255;
            Inc(PByte(p1)); Inc(PByte(p2));
          end;
        end;
      end;
    {Average filter}
    FILTER_AVERAGE:
      begin
        {$IFDEF COUNT_FILTER}
        Inc( CountFilters[ pfAverage ] );
        {$ENDIF}

        p1 := @Row_Buffer[RowUsed][1];
        p2 := @Row_Buffer[not RowUsed][1];
        {for Col := 0 to Offset-1 do
        begin
          p1[0] := (p1[0] + p2[0] div 2); // and 255;
          Inc(PByte(p1)); Inc(PByte(p2));
        end;
        Offs := -Offset;
        for Col := Offset to Row_Bytes-1 do
        begin
          p1[0] := (p1[0] + ( p1[Offs] + p2[0] ) div 2); // and 255;
          //cur =    (cur +   ( left +     above) div 2) and 255;
          Inc(PByte(p1)); Inc(PByte(p2));
        end;}
        
        for Col := 0 to Offset-1 do
        begin
          p1[Col] := (p1[Col] + p2[Col] div 2); // and 255;
        end;
        
        for Col := Offset to Row_Bytes-1 do
        begin
          p1[Col] := (p1[Col] + ( p1[Col-Offset] + p2[Col] ) div 2); // and 255;
        end;
      end;
    {Paeth filter}
    FILTER_PAETH:
      begin
        {$IFDEF COUNT_FILTER}
        Inc( CountFilters[ pfPaeth ] );
        {$ENDIF}
        {$IFDEF ASM_VERSION}
          {$IFDEF PAETH_TABLE}
            if not PaethTableInitialized then
              InitPaethTable;
          {$ENDIF}
          Offs := Offset;
          CntBytes := Offs;
          Dst := @Row_Buffer[RowUsed][1];
          Src := @Row_Buffer[not RowUsed][1];  // above
          //Src1 := @row_buffer[RowUsed][1]; // left
          //Src2 := @row_buffer[not RowUsed][0]; //aboveleft
          Col := Row_Bytes - DWORD( Offs );
          asm
            PUSH  ESI
            PUSH  EDI
            PUSH  EBX
            MOV   ESI, [Src]
            MOV   EDI, [Dst]
            MOV   ECX, [CntBytes]
            JECXZ @@Do_loop2
          @@loop1:
            LODSB
            ADD   AL, [EDI]
            STOSB
            LOOP  @@loop1
          @@Do_loop2:
            PUSH EBP
            //XOR  EBX, EBX
            MOV  EBX, [Offs]
            NEG  EBX
            MOV  EBP, [Col]
            {$IFDEF PAETH_TABLE}
            MOV  EDX, [PaethTable]
            nop
            {$ELSE}
            nop
            nop
            nop
            {$ENDIF}
          @@loop2:
            {$IFDEF PAETH_TABLE}
            XOR  EAX, EAX
            MOV  AH, [EDI+EBX]
            LODSB
            SHL  EAX, 8
            MOV  AL, [ESI+EBX-1]

            {MOV  DL, AH
            MOV  CL, AL
            SHR  EAX, 16
            CALL PaethPredictor
            MOV  CL, AL}

            MOV  ECX, EAX
            SHL  ECX, 8
            MOV  CL, CH
            SHR  EAX, 2
            MOV  AL, byte ptr [EDX+EAX]
            AND  CL, 3
            ADD  CL, CL
            SHR  AL, CL
            AND  AL, 3
            SHL  AL, 3
            MOV  CL, AL
            SHR  ECX, CL

            {$ELSE}
            MOV  DH, [EDI+EBX]
            XOR  EAX, EAX
            MOV  DL, [ESI+EBX]
            LODSB

            // paeth filter( DH, AL, DL ):
            {PUSH ECX
            MOV ECX, EDX
            MOV DL, AL
            MOV AL, DH
            CALL PaethPredictor
            POP  ECX}

            PUSH ESI
            PUSH EDI
            MOV  ECX, EDX
            SHL  ECX, 16
            MOV  CH, AL  // ECX = [a][c][b][?]

            MOV  ESI, EAX // ESI = b
            MOVZX EDI, DL // EDI = c
            NEG  EDI      // EDI = -c
            MOVZX EAX, DH // EAX = a
            ADD  ESI, EAX
            LEA  ESI, [ESI+EDI*2] // ESI = a+b-2c
            ADD  EAX, EDI // EAX = a-c
            CDQ
            XOR  EAX, EDX
            SUB  EAX, EDX // EAX = |a-c| = pb
            XCHG EAX, ESI // ESI = pb, EAX = a+b-2c
            CDQ
            XOR  EAX, EDX
            SUB  EAX, EDX // EAX = |a+b-2c| = pc
            XCHG EDI, EAX // EDI = pc, EAX = -c
            MOVZX EDX, CH // EDX = b
            ADD  EAX, EDX // EAX = b-c
            CDQ
            XOR  EAX, EDX
            SUB  EAX, EDX // EAX = |b-c| = pa
            // EAX = pa , ESI = pb , EDI = pc

            CMP  EAX, ESI // pa <= pb ?
            JA   @@1
            CMP  EAX, EDI // pa <= pc ?
            MOV  CL, 24
            JBE  @@2

          @@1:
            MOV  CL, 8
            CMP  ESI, EDI
            JBE  @@2
            MOV  CL, 16
          @@2:
            SHR  ECX, CL
            POP EDI
            POP ESI
            {$ENDIF}

            ADD  [EDI], CL
            //ADD  [EDI], AL
            INC  EDI

            DEC  EBP
            JNZ  @@loop2

            POP  EBP
            POP  EBX
            POP  EDI
            POP  ESI
          end;
        {$ELSE}
        
          {$IFDEF PAS_PNG}////////////////////////////////////////
            {Initialize}
            
            p1 := @Row_Buffer[RowUsed][1];
            p2 := @Row_Buffer[not RowUsed][1];
            
            {for Col := 0 to Offset-1 do
            begin
              pp := p2[0]; // PaethPredictor(0, p2[0], 0);
              p1[0] := (pp + p1[0]); // and 255;
              Inc(PByte(p1)); Inc(PByte(p2));
            end;
            
            Offs := -Offset;
            for Col := Offset to Row_Bytes-1 do
            begin
              pp := PaethPredictor(p1[Offs], // left
                                    p2[0], // above
                                    p2[Offs]); // above-left
              p1[0] := (pp + p1[0]) and 255;
              Inc(PByte(p1)); Inc(PByte(p2));
            end;}
            
            for Col := 0 to Offset-1 do
            begin
              pp := p2[Col]; // PaethPredictor(0, p2[Col], 0);
              p1[Col] := (pp + p1[Col]); // and 255;
            end;
            
            for Col := Offset to Row_Bytes-1 do
            begin
              pp := PaethPredictor(p1[Col-Offset], // left
                                   p2[Col], // above
                                   p2[Col-Offset]); // above-left
              p1[Col] := (pp + p1[Col]); // and 255;
            end;
            
          {$ELSE}/////////////////////////////////////////////////
            {Initialize}
            left := 0;
            aboveleft := 0;
            {Test each byte}
            for Col := 1 to Row_Bytes do
            begin
              {Obtains above pixel}
              above := Row_Buffer[not RowUsed][Col];
              {Obtains left and top-left pixels}
              if (col - 1 >= offset) Then
              begin
                left := row_buffer[RowUsed][col - offset];
                aboveleft := row_buffer[not RowUsed][col - offset];
              end;

              {Obtains current pixel and paeth predictor}
              vv := row_buffer[RowUsed][Col];
              pp := PaethPredictor(left, above, aboveleft);

              {$IFDEF DEBUG_PAETH}
              LogFileOutput( GetStartDir + 'paeth_log.txt',
                Int2Str( pp ) + ' <- ' + Int2Str( left ) + ',' +
                Int2Str( above ) + ',' + Int2Str( aboveleft ) );
              {$ENDIF}

              {Calculates}
              Row_Buffer[RowUsed][Col] := (pp + vv) and $FF;
            end {for};
          {$ENDIF}
        {$ENDIF}
      end;
  end {case};
end;

{Reads the image data from the stream}
function IDAT_Load(Chunk: Pointer; Stream: PStream; const ChunkName: TChunkName;
  Size: Integer): Boolean;
var
  ZLIBStream: TZStreamRec2;
  CRCCheck,
  CRCFile: DWORD;
  Hdr: PChunkIHDR;
begin
  with PChunkIDAT(Chunk)^ do
  begin
    {Get pointer to the header chunk}
    Hdr := Owner.Header;
    {Build palette if necessary}
    if Hdr.HasPalette then PreparePalette();

    {Copy image width and height}
    ImageWidth := Hdr.Width;
    ImageHeight := Hdr.Height;
    if Owner.Scale <> psFullImage then
    begin
      ImageWidth := Owner.ScaledWidth;
      ImageHeight := Owner.ScaledHeight;
    end;

    {Initialize to calculate CRC}
    CRCFile := update_crc($ffffffff, @ChunkName[0], 4);

    Owner.GetPixelInfo(Row_Bytes, Offset); {Obtain line information}
    ZLIBStream := ZLIBInitInflate(Stream);  {Initializes decompression}

    {Calculate ending position for the current IDAT chunk}
    EndPos := Stream.Position + DWORD( Size );

    {Allocate memory}
    GetMem(Row_Buffer[False], Row_Bytes + 12);
    GetMem(Row_Buffer[True], Row_Bytes + 12);
    ZeroMemory(Row_Buffer[False], Row_bytes + 1);
    {Set the variable to alternate the Row_Buffer item to use}
    RowUsed := True;

    {Call special methods for the different interlace methods}
    case Owner.InterlaceMethod of
      imNone:  DecodeNonInterlaced(stream, ZLIBStream, Size, crcfile);
      imAdam7: DecodeInterlacedAdam7(stream, ZLIBStream, size, crcfile);
    end;

    {Free memory}
    ZLIBTerminateInflate(ZLIBStream); {Terminates decompression}
    FreeMem(Row_Buffer[False]); //, Row_Bytes + 1);
    FreeMem(Row_Buffer[True]); //, Row_Bytes + 1);

    {Now checks CRC}
    Stream.Read(CRCCheck, 4);
    if Owner.FErrorOnInvalidCRC then
    begin
      CRCFile := CRCFile xor $ffffffff;
      CRCCheck := ByteSwap(CRCCheck);
      Result := CRCCheck = CRCFile;

      {Handle CRC error}
      if not Result then
      begin
        {In case it coult not load chunk}
        Owner.FError := ErrInvalidCRC;
        exit;
      end;
    end
    else
      Result := True;
  end;
end;

const
  IDATHeader: TChunkName = ('I', 'D', 'A', 'T');
  BUFFER = 5;


{Saves the IDAT chunk to a stream}
function IDAT_Save(Chunk: Pointer; Stream: PStream): Boolean;
var
  ZLIBStream : TZStreamRec2;
  Hdr: PChunkIHDR;
begin
  with PChunkIDAT( Chunk )^ do
  begin
    {Get pointer to the header chunk}
    Hdr := Owner.Header;
    {Copy image width and height}
    ImageWidth := Hdr.Width;
    ImageHeight := Hdr.Height;
    Owner.GetPixelInfo(Row_Bytes, Offset); {Obtain line information}

    {Allocate memory}
    GetMem(Encode_Buffer[BUFFER], Row_Bytes);
    ZeroMemory(Encode_Buffer[BUFFER], Row_Bytes);
    {Allocate buffers for the filters selected}
    {Filter none will always be calculated to the other filters to work}
    GetMem(Encode_Buffer[FILTER_NONE], Row_Bytes);
    ZeroMemory(Encode_Buffer[FILTER_NONE], Row_Bytes);
    if pfSub in Owner.Filters then
      GetMem(Encode_Buffer[FILTER_SUB], Row_Bytes);
    if pfUp in Owner.Filters then
      GetMem(Encode_Buffer[FILTER_UP], Row_Bytes);
    if pfAverage in Owner.Filters then
      GetMem(Encode_Buffer[FILTER_AVERAGE], Row_Bytes);
    if pfPaeth in Owner.Filters then
      GetMem(Encode_Buffer[FILTER_PAETH], Row_Bytes);

    {Initialize ZLIB}
    ZLIBStream := ZLIBInitDeflate(Stream, Owner.fCompressionLevel,
      Owner.MaxIdatSize);
    {Write data depending on the interlace method}
    case Owner.InterlaceMethod of
      imNone: EncodeNonInterlaced(stream, ZLIBStream);
      imAdam7: EncodeInterlacedAdam7(stream, ZLIBStream);
    end;
    {Terminates ZLIB}
    ZLIBTerminateDeflate(ZLIBStream);

    {Release allocated memory}
    FreeMem(Encode_Buffer[BUFFER]); //, Row_Bytes);
    FreeMem(Encode_Buffer[FILTER_NONE]); //, Row_Bytes);
    if pfSub in Owner.Filters then
      FreeMem(Encode_Buffer[FILTER_SUB]); //, Row_Bytes);
    if pfUp in Owner.Filters then
      FreeMem(Encode_Buffer[FILTER_UP]); //, Row_Bytes);
    if pfAverage in Owner.Filters then
      FreeMem(Encode_Buffer[FILTER_AVERAGE]); //, Row_Bytes);
    if pfPaeth in Owner.Filters then
      FreeMem(Encode_Buffer[FILTER_PAETH]); //, Row_Bytes);

    {Everything went ok}
    Result := True;
  end;
end;

{Writes the IDAT using the settings}
procedure WriteIDAT(Stream: PStream; Data: Pointer; const Length: DWORD);
var
  ChunkLen, CRC: DWORD;
begin
  {Writes IDAT header}
  ChunkLen := ByteSwap(Length);
  Stream.Write(ChunkLen, 4);                      {Chunk length}
  Stream.Write(IDATHeader[0], 4);                 {Idat header}
  CRC := update_crc($ffffffff, @IDATHeader[0], 4); {Crc part for header}

  {Writes IDAT data and calculates CRC for data}
  Stream.Write(Data^, Length);
  CRC := ByteSwap(update_crc(CRC, Data, Length) xor $ffffffff);
  {Writes final CRC}
  Stream.Write(CRC, 4);
end;

{Compress and writes IDAT chunk data}
procedure TChunkIDAT.IDATZlibWrite(var ZLIBStream: TZStreamRec2;
  Buffer: Pointer; const Length: DWORD);
begin
  with ZLIBStream, ZLIBStream.ZLIB do
  begin
    {Set data to be compressed}
    next_in := Buffer;
    avail_in := Length;

    {Compress all the data avaliable to compress}
    while avail_in > 0 do
    begin
      deflate(ZLIB, Z_NO_FLUSH);

      {The whole buffer was used, save data to stream and restore buffer}
      if avail_out = 0 then
      begin
        {Writes this IDAT chunk}
        WriteIDAT(fStream, Data, ZLIBAllocate);
        
        {Restore buffer}
        next_out := Data;
        avail_out := ZLIBAllocate;
      end {if avail_out = 0};

    end {while avail_in};

  end {with ZLIBStream, ZLIBStream.ZLIB}
end;

{Finishes compressing data to write IDAT chunk}
procedure TChunkIDAT.FinishIDATZlib(var ZLIBStream: TZStreamRec2);
begin
  with ZLIBStream, ZLIBStream.ZLIB do
  begin
    {Set data to be compressed}
    next_in := nil;
    avail_in := 0;

    while deflate(ZLIB,Z_FINISH) <> Z_STREAM_END do
    begin
      {Writes this IDAT chunk}
      WriteIDAT(fStream, Data, ZLIBAllocate - avail_out);
      {Re-update buffer}
      next_out := Data;
      avail_out := ZLIBAllocate;
    end;

    if avail_out < ZLIBAllocate then
      {Writes final IDAT}
      WriteIDAT(fStream, Data, ZLIBAllocate - avail_out);

  end {with ZLIBStream, ZLIBStream.ZLIB};
end;

{Copy memory to encode RGB image with 1 byte for each color sample}
procedure TChunkIDAT.EncodeNonInterlacedRGB8(Src, Dest, Trans: PByte);
var
  I: Integer;
begin
  for I := 1 to ImageWidth do
  begin
    {Copy pixel values}
    Dest^ := fOwner.InverseGamma[PByte(NativeInt(Src) + 2)^]; Inc(Dest);
    Dest^ := fOwner.InverseGamma[PByte(NativeInt(Src) + 1)^]; Inc(Dest);
    Dest^ := fOwner.InverseGamma[PByte(NativeInt(Src)    )^]; Inc(Dest);
    {Move to next pixel}
    Inc(Src, 3);
  end {for I}
end;

{Copy memory to encode RGB images with 16 bits for each color sample}
procedure TChunkIDAT.EncodeNonInterlacedRGB16(Src, Dest, Trans: PByte);
var
  I: Integer;
begin
  for I := 1 to ImageWidth do
  begin
    //Now we copy from 1 byte for each sample stored to a 2 bytes (or 1 word)
    //for sample
    {Copy pixel values}
    PWord(Dest)^ := fOwner.InverseGamma[PByte(NativeInt(Src) + 2)^]; Inc(Dest, 2);
    PWord(Dest)^ := fOwner.InverseGamma[PByte(NativeInt(Src) + 1)^]; Inc(Dest, 2);
    PWord(Dest)^ := fOwner.InverseGamma[PByte(NativeInt(Src)    )^]; Inc(Dest, 2);
    {Move to next pixel}
    Inc(Src, 3);
  end {for I};
end;

{Copy memory to encode types using palettes (1, 4 or 8 bits per pixel)}
procedure TChunkIDAT.EncodeNonInterlacedPalette148(Src, Dest, Trans: PByte);
begin
  {It's simple as copying the data}
  CopyMemory(Dest, Src, Row_Bytes);
end;

{Copy memory to encode grayscale images with 2 bytes for each sample}
procedure TChunkIDAT.EncodeNonInterlacedGrayscale16(Src, Dest, Trans: PByte);
var
  I: Integer;
begin
  for I := 1 to ImageWidth do
  begin
    //Now we copy from 1 byte for each sample stored to a 2 bytes (or 1 word)
    //for sample
    PWord(Dest)^ := Src^; Inc(Dest, 2);
    {Move to next pixel}
    Inc(Src);
  end {for I};
end;

{Encode images using RGB followed by an alpha value using 1 byte for each}
procedure TChunkIDAT.EncodeNonInterlacedRGBAlpha8(Src, Dest, Trans: PByte);
var
  i: Integer;
begin
  {Copy the data to the destination, including data from Trans Pointer}
  for i := 1 to ImageWidth do
  begin
    Dest^ := Owner.InverseGamma[PByte(NativeInt(Src) + 2)^]; Inc(Dest);
    Dest^ := Owner.InverseGamma[PByte(NativeInt(Src) + 1)^]; Inc(Dest);
    Dest^ := Owner.InverseGamma[PByte(NativeInt(Src)    )^]; Inc(Dest);
    Dest^ := Trans^; Inc(Dest);
    Inc(Src, 3); Inc(Trans);
  end {for i};
end;

{Encode images using RGB followed by an alpha value using 2 byte for each}
procedure TChunkIDAT.EncodeNonInterlacedRGBAlpha16(Src, Dest, Trans: PByte);
var
  i: Integer;
begin
  {Copy the data to the destination, including data from Trans Pointer}
  for i := 1 to ImageWidth do
  begin
    PWord(Dest)^ := Owner.InverseGamma[PByte(NativeInt(Src) + 2)^]; Inc(Dest, 2);
    PWord(Dest)^ := Owner.InverseGamma[PByte(NativeInt(Src) + 1)^]; Inc(Dest, 2);
    PWord(Dest)^ := Owner.InverseGamma[PByte(NativeInt(Src)    )^]; Inc(Dest, 2);
    PWord(Dest)^ := Trans^; Inc(Dest, 2);
    Inc(Src, 3); Inc(Trans);
  end {for i};
end;

{Encode grayscale images followed by an alpha value using 1 byte for each}
procedure TChunkIDAT.EncodeNonInterlacedGrayscaleAlpha8(Src, Dest, Trans: PByte);
var
  i: Integer;
begin
  {Copy the data to the destination, including data from Trans Pointer}
  for i := 1 to ImageWidth do
  begin
    Dest^ := Src^; Inc(Dest);
    Dest^ := Trans^; Inc(Dest);
    Inc(Src); Inc(Trans);
  end {for i};
end;

{Encode grayscale images followed by an alpha value using 2 byte for each}
procedure TChunkIDAT.EncodeNonInterlacedGrayscaleAlpha16(Src, Dest, Trans: PByte);
var
  i: Integer;
begin
  {Copy the data to the destination, including data from Trans pointer}
  for i := 1 to ImageWidth do
  begin
    PWord(Dest)^ := Src^;    Inc(Dest, 2);
    PWord(Dest)^ := Trans^;  Inc(Dest, 2);
    Inc(Src); Inc(Trans);
  end {for i};
end;

{Encode non interlaced images}
procedure TChunkIDAT.EncodeNonInterlaced(Stream: PStream;
  var ZLIBStream: TZStreamRec2);
var
  {Current line}
  j: Integer;
  {Pointers to image data}
  Dta, Trans: PByte;
  {Filter used for this line}
  Filter: Byte;
  {Method which will copy the data into the buffer}
  CopyProc: procedure(Src, Dst, Trans: PByte) of object;
  W, H: Integer;
  Stop: Boolean;
begin
  CopyProc := nil;  {Initialize to avoid warnings}
  {Defines the method to copy the data to the buffer depending on}
  {the image parameters}
  case Header.ColorType of
    {R, G, B values}
    COLOR_RGB:
      case Header.BitDepth of
        8: CopyProc := EncodeNonInterlacedRGB8;
       16: CopyProc := EncodeNonInterlacedRGB16;
      end;
    {Palette and grayscale values}
    COLOR_GRAYSCALE, COLOR_PALETTE:
      case Header.BitDepth of
        1, 4, 8: CopyProc := EncodeNonInterlacedPalette148;
             16: CopyProc := EncodeNonInterlacedGrayscale16;
      end;
    {RGB with a following alpha value}
    COLOR_RGBALPHA:
      case Header.BitDepth of
          8: CopyProc := EncodeNonInterlacedRGBAlpha8;
         16: CopyProc := EncodeNonInterlacedRGBAlpha16;
      end;
    {Grayscale images followed by an alpha}
    COLOR_GRAYSCALEALPHA:
      case Header.BitDepth of
        8:  CopyProc := EncodeNonInterlacedGrayscaleAlpha8;
       16:  CopyProc := EncodeNonInterlacedGrayscaleAlpha16;
      end;
  end {case Header.ColorType};

  {Get the image data pointer}
  Stop := False;
  if Assigned( Owner.OnGetRow ) then
  begin
    Owner.OnGetRow(Owner, 0, W, H, Dta, Trans, Stop);
  end
    else
  begin
    W := ImageWidth;
    H := ImageHeight;
    NativeInt(Dta) := NativeInt(Header.ImageData) +
      Header.BytesPerRow * (ImageHeight - 1);
    Trans := Header.ImageAlpha;
  end;

  {Writes each line}
  if not Stop then
  begin
    for j := 0 to H - 1 do
    begin
      {Copy data into buffer}
      CopyProc(Dta, @Encode_Buffer[BUFFER][0], Trans);
      {Filter data}
      Filter := FilterToEncode;

      {Compress data}
      IDATZlibWrite(ZLIBStream, @Filter, 1);
      IDATZlibWrite(ZLIBStream, @Encode_Buffer[Filter][0], Row_Bytes);

      {Adjust pointers to the actual image data}
      if j < H-1 then
      begin
        if Assigned(Owner.OnGetRow) then
        begin
          Owner.OnGetRow(Owner, j+1, W, H, Dta, Trans, Stop);
          if Stop then break;
        end
        else
        begin
          Dec(Dta, Header.BytesPerRow);
          Inc(Trans, ImageWidth);
        end;
      end;
    end;
  end;

  {Compress and finishes copying the remaining data}
  FinishIDATZlib(ZLIBStream);
end;

{Copy memory to encode interlaced images using RGB value with 1 byte for}
{each color sample}
procedure TChunkIDAT.EncodeInterlacedRGB8(const Pass: Byte; Src, Dest, Trans: PByte);
var
  Col: Integer;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass];
  Src := PByte(NativeInt(Src) + Col * 3);
  repeat
    {Copy this row}
    Dest^ := fOwner.InverseGamma[PByte(NativeInt(Src) + 2)^]; Inc(Dest);
    Dest^ := fOwner.InverseGamma[PByte(NativeInt(Src) + 1)^]; Inc(Dest);
    Dest^ := fOwner.InverseGamma[PByte(NativeInt(Src)    )^]; Inc(Dest);

    {Move to next column}
    Inc(Src, ColumnIncrement[Pass] * 3);
    Inc(Col, ColumnIncrement[Pass]);
  until Col >= ImageWidth;
end;

{Copy memory to encode interlaced RGB images with 2 bytes each color sample}
procedure TChunkIDAT.EncodeInterlacedRGB16(const Pass: Byte; Src, Dest, Trans: PByte);
var
  Col: Integer;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass];
  Src := Pointer(NativeInt(Src) + Col * 3);
  repeat
    {Copy this row}
    PWord(Dest)^ := Owner.InverseGamma[PByte(NativeInt(Src) + 2)^]; Inc(Dest, 2);
    PWord(Dest)^ := Owner.InverseGamma[PByte(NativeInt(Src) + 1)^]; Inc(Dest, 2);
    PWord(Dest)^ := Owner.InverseGamma[PByte(NativeInt(Src)    )^]; Inc(Dest, 2);

    {Move to next column}
    Inc(Src, ColumnIncrement[Pass] * 3);
    Inc(Col, ColumnIncrement[Pass]);
  until Col >= ImageWidth;
end;

{Copy memory to encode interlaced images using palettes using bit depths}
{1, 4, 8 (each pixel in the image)}
procedure TChunkIDAT.EncodeInterlacedPalette148(const Pass: Byte; Src, Dest, Trans: PByte);
const
  BitTable: array[1..8] of Integer = ($1, $3, 0, $F, 0, 0, 0, $FF);
  StartBit: array[1..8] of Integer = (7 , 0 , 0, 4,  0, 0, 0, 0);
var
  CurBit, Col: Integer;
  Src2: PByte;
begin
  {Clean the line}
  FillChar(Dest^, Row_Bytes, #0);
  {Get first column and enter in loop}
  Col := ColumnStart[Pass];
  with Header.BitmapInfo.bmiHeader do
    repeat
      {Copy data}
      CurBit := StartBit[biBitCount];
      repeat
        {Adjust pointer to pixel byte bounds}
        Src2 := PByte(NativeInt(Src) + (biBitCount * Col) div 8);
        {Copy data}
        Dest^ := Dest^ or
          (((Src2^ shr (StartBit[Header.BitDepth] - (biBitCount * Col)
            mod 8))) and (BitTable[biBitCount])) shl CurBit;

        {Move to next column}
        Inc(Col, ColumnIncrement[Pass]);
        {Will read next bits}
        Dec(CurBit, biBitCount);
      until CurBit < 0;

      {Move to next byte in source}
      Inc(Dest);
    until Col >= ImageWidth;
end;

{Copy to encode interlaced grayscale images using 16 bits for each sample}
procedure TChunkIDAT.EncodeInterlacedGrayscale16(const Pass: Byte; Src, Dest, Trans: PByte);
var
  Col: Integer;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass];
  Src := PByte(NativeInt(Src) + Col);
  repeat
    {Copy this row}
    PWord(Dest)^ := Src^; Inc(Dest, 2);

    {Move to next column}
    Inc(Src, ColumnIncrement[Pass]);
    Inc(Col, ColumnIncrement[Pass]);
  until Col >= ImageWidth;
end;

{Copy to encode interlaced rgb images followed by an alpha value, all using}
{one byte for each sample}
procedure TChunkIDAT.EncodeInterlacedRGBAlpha8(const Pass: Byte; Src, Dest, Trans: PByte);
var
  Col: Integer;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass];
  Src := PByte(NativeInt(Src) + Col * 3);
  Trans := PByte(NativeInt(Trans) + Col);
  repeat
    {Copy this row}
    Dest^ := Owner.InverseGamma[PByte(NativeInt(Src) + 2)^]; Inc(Dest);
    Dest^ := Owner.InverseGamma[PByte(NativeInt(Src) + 1)^]; Inc(Dest);
    Dest^ := Owner.InverseGamma[PByte(NativeInt(Src)    )^]; Inc(Dest);
    Dest^ := Trans^; Inc(Dest);

    {Move to next column}
    Inc(Src, ColumnIncrement[Pass] * 3);
    Inc(Trans, ColumnIncrement[Pass]);
    Inc(Col, ColumnIncrement[Pass]);
  until Col >= ImageWidth;
end;

{Copy to encode interlaced rgb images followed by an alpha value, all using}
{two byte for each sample}
procedure TChunkIDAT.EncodeInterlacedRGBAlpha16(const Pass: Byte; Src, Dest, Trans: PByte);
var
  Col: Integer;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass];
  Src := PByte(NativeInt(Src) + Col * 3);
  Trans := PByte(NativeInt(Trans) + Col);
  repeat
    {Copy this row}
    PWord(Dest)^ := PByte(NativeInt(Src) + 2)^; Inc(Dest, 2);
    PWord(Dest)^ := PByte(NativeInt(Src) + 1)^; Inc(Dest, 2);
    PWord(Dest)^ := PByte(NativeInt(Src)    )^; Inc(Dest, 2);
    PWord(Dest)^ := Trans^; Inc(Dest, 2);

    {Move to next column}
    Inc(Src, ColumnIncrement[Pass] * 3);
    Inc(Trans, ColumnIncrement[Pass]);
    Inc(Col, ColumnIncrement[Pass]);
  until Col >= ImageWidth;
end;

{Copy to encode grayscale interlaced images followed by an alpha value, all}
{using 1 byte for each sample}
procedure TChunkIDAT.EncodeInterlacedGrayscaleAlpha8(const Pass: Byte; Src, Dest, Trans: PByte);
var
  Col: Integer;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass];
  Src := PByte(NativeInt(Src) + Col);
  Trans := PByte(NativeInt(Trans) + Col);
  repeat
    {Copy this row}
    Dest^ := Src^;   Inc(Dest);
    Dest^ := Trans^; Inc(Dest);

    {Move to next column}
    Inc(Src, ColumnIncrement[Pass]);
    Inc(Trans, ColumnIncrement[Pass]);
    Inc(Col, ColumnIncrement[Pass]);
  until Col >= ImageWidth;
end;

{Copy to encode grayscale interlaced images followed by an alpha value, all}
{using 2 bytes for each sample}
procedure TChunkIDAT.EncodeInterlacedGrayscaleAlpha16(const Pass: Byte; Src, Dest, Trans: PByte);
var
  Col: Integer;
begin
  {Get first column and enter in loop}
  Col := ColumnStart[Pass];
  Src := PByte(NativeInt(Src) + Col);
  Trans := PByte(NativeInt(Trans) + Col);
  repeat
    {Copy this row}
    PWord(Dest)^ := Src^; Inc(Dest, 2);
    PWord(Dest)^ := Trans^; Inc(Dest, 2);

    {Move to next column}
    Inc(Src, ColumnIncrement[Pass]);
    Inc(Trans, ColumnIncrement[Pass]);
    Inc(Col, ColumnIncrement[Pass]);
  until Col >= ImageWidth;
end;

{Encode interlaced images}
procedure TChunkIDAT.EncodeInterlacedAdam7(Stream: PStream;
  var ZLIBStream: TZStreamRec2);
var
  CurrentPass, Filter: Byte;
  PixelsThisRow: Integer;
  CurrentRow: Integer;
  Trans, Dta: PByte;
  CopyProc: procedure(const Pass: Byte; Src, Dest, Trans: PByte) of object;
  Stop: Boolean;
  W, H: Integer;
begin
  CopyProc := nil;  {Initialize to avoid warnings}
  {Defines the method to copy the data to the buffer depending on}
  {the image parameters}
  case Header.ColorType of
    {R, G, B values}
    COLOR_RGB:
      case Header.BitDepth of
        8: CopyProc := EncodeInterlacedRGB8;
       16: CopyProc := EncodeInterlacedRGB16;
      end;
    {Grayscale and palette}
    COLOR_PALETTE, COLOR_GRAYSCALE:
      case Header.BitDepth of
        1, 4, 8: CopyProc := EncodeInterlacedPalette148;
             16: CopyProc := EncodeInterlacedGrayscale16;
      end;
    {RGB followed by alpha}
    COLOR_RGBALPHA:
      case Header.BitDepth of
          8: CopyProc := EncodeInterlacedRGBAlpha8;
         16: CopyProc := EncodeInterlacedRGBAlpha16;
      end;
    COLOR_GRAYSCALEALPHA:
    {Grayscale followed by alpha}
      case Header.BitDepth of
          8: CopyProc := EncodeInterlacedGrayscaleAlpha8;
         16: CopyProc := EncodeInterlacedGrayscaleAlpha16;
      end;
  end {case Header.ColorType};

  {Compress the image using the seven passes for ADAM 7}
  Stop := False;
  for CurrentPass := 0 to 6 do
  begin
    {Calculates the number of pixels and bytes for this pass row}
    PixelsThisRow := (ImageWidth - ColumnStart[CurrentPass] +
      ColumnIncrement[CurrentPass] - 1) div ColumnIncrement[CurrentPass];
    Row_Bytes := BytesForPixels(PixelsThisRow, Header.ColorType,
      Header.BitDepth);
    ZeroMemory(Encode_Buffer[FILTER_NONE], Row_Bytes);

    {Get current row index}
    CurrentRow := RowStart[CurrentPass];
    {Get a pointer to the current row image data}
    Stop := False;
    if Assigned( Owner.OnGetRow ) then
    begin
      Owner.OnGetRow(Owner, CurrentRow, W, H, Dta, Trans, Stop);
    end
      else
    begin
      W := ImageWidth;
      H := ImageHeight;
      Dta := PByte(NativeInt(Header.ImageData) + Header.BytesPerRow *
        (ImageHeight - 1 - CurrentRow));
      Trans := PByte(NativeInt(Header.ImageAlpha) + ImageWidth * CurrentRow);
    end;

    {Process all the image rows}
    if (Row_Bytes > 0) and not Stop then
      while CurrentRow < ImageHeight do
      begin
        {Copy data into buffer}
        CopyProc(CurrentPass, Dta, @Encode_Buffer[BUFFER][0], Trans);
        {Filter data}
        Filter := FilterToEncode;

        {Compress data}
        IDATZlibWrite(ZLIBStream, @Filter, 1);
        IDATZlibWrite(ZLIBStream, @Encode_Buffer[Filter][0], Row_Bytes);

        {Move to the next row}
        Inc(CurrentRow, RowIncrement[CurrentPass]);
        {Move pointer to the next line}
        if CurrentRow < ImageHeight then
        begin
          Owner.OnGetRow(Owner, CurrentRow, W, H, Dta, Trans, Stop);
          if Stop then break;
        end
          else
        begin
          Dec(Dta, RowIncrement[CurrentPass] * Header.BytesPerRow);
          Inc(Trans, RowIncrement[CurrentPass] * ImageWidth);
        end;
      end {while CurrentRow < ImageHeight}

  end {CurrentPass};

  {Compress and finishes copying the remaining data}
  FinishIDATZlib(ZLIBStream);
end;

{Filters the row to be encoded and returns the best filter}
function TChunkIDAT.FilterToEncode: Byte;
var
  Run, LongestRun, ii, jj: DWORD;
  Last, Above, LastAbove: Byte;
begin
  {Selecting more filters using the Filters property from TPngObject}
  {increases the chances to the file be much smaller, but decreases}
  {the performace}

  {This method will creates the same line data using the different}
  {filter methods and select the best}

  {Sub-filter}
  if pfSub in Owner.Filters then
    for ii := 0 to Row_Bytes - 1 do
    begin
      {There is no previous pixel when it's on the first pixel, so}
      {set last as zero when in the first}
      if (ii >= Offset) then
        last := Encode_Buffer[BUFFER]^[ii - Offset]
      else
        last := 0;
      Encode_Buffer[FILTER_SUB]^[ii] := Encode_Buffer[BUFFER]^[ii] - last;
    end;

  {Up filter}
  if pfUp in Owner.Filters then
    for ii := 0 to Row_Bytes - 1 do
      Encode_Buffer[FILTER_UP]^[ii] := Encode_Buffer[BUFFER]^[ii] -
        Encode_Buffer[FILTER_NONE]^[ii];

  {Average filter}
  if pfAverage in Owner.Filters then
    for ii := 0 to Row_Bytes - 1 do
    begin
      {Get the previous pixel, if the current pixel is the first, the}
      {previous is considered to be 0}
      if (ii >= Offset) then
        last := Encode_Buffer[BUFFER]^[ii - Offset]
      else
        last := 0;
      {Get the pixel above}
      above := Encode_Buffer[FILTER_NONE]^[ii];

      {Calculates formula to the average pixel}
      Encode_Buffer[FILTER_AVERAGE]^[ii] := Encode_Buffer[BUFFER]^[ii] -
        (above + last) div 2 ;
    end;

  {Paeth filter (the slower)}
  if pfPaeth in Owner.Filters then
  begin
    {Initialize}
    last := 0;
    lastabove := 0;
    for ii := 0 to Row_Bytes - 1 do
    begin
      {In case this pixel is not the first in the line obtains the}
      {previous one and the one above the previous}
      if (ii >= Offset) then
      begin
        last := Encode_Buffer[BUFFER]^[ii - Offset];
        lastabove := Encode_Buffer[FILTER_NONE]^[ii - Offset];
      end;
      {Obtains the pixel above}
      above := Encode_Buffer[FILTER_NONE]^[ii];
      {Calculate paeth filter for this byte}
      Encode_Buffer[FILTER_PAETH]^[ii] := Encode_Buffer[BUFFER]^[ii] -
        PaethPredictor(last, above, lastabove);
    end;
  end;

  {Now calculates the same line using no filter, which is necessary}
  {in order to have data to the filters when the next line comes}
  CopyMemory(@Encode_Buffer[FILTER_NONE]^[0],
    @Encode_Buffer[BUFFER]^[0], Row_Bytes);

  {If only filter none is selected in the filter list, we don't need}
  {to proceed and further}
  if (Owner.Filters = [pfNone]) or (Owner.Filters = []) then
  begin
    Result := FILTER_NONE;
    exit;
  end {if (Owner.Filters = [pfNone...};

  {Check which filter is the best by checking which has the larger}
  {sequence of the same byte, since they are best compressed}
  LongestRun := 0; Result := FILTER_NONE;
  for ii := FILTER_NONE to FILTER_PAETH do
    {Check if this filter was selected}
    if TFilter(ii) in Owner.Filters then
    begin
      Run := 0;
      {Check if it's the only filter}
      if Owner.Filters = [TFilter(ii)] then
      begin
        Result := ii;
        exit;
      end;

      {Check using a sequence of four bytes}
      for jj := 2 to Row_Bytes - 1 do
        if (Encode_Buffer[ii]^[jj] = Encode_Buffer [ii]^[jj-1]) or
            (Encode_Buffer[ii]^[jj] = Encode_Buffer [ii]^[jj-2]) then
          Inc(Run);  {Count the number of sequences}

      {Check if this one is the best so far}
      if (Run > LongestRun) then
      begin
        Result := ii;
        LongestRun := Run;
      end {if (Run > LongestRun)};

    end {if TFilter(ii) in Owner.Filters};
end;

{TChunkPLTE implementation}

{Returns an item in the palette}
function TChunkPLTE.GetPaletteItem(Idx: Byte): TRGBQuad;
begin
  {Test if item is valid, if not return 0}
  if Idx >= Count then
  begin
    Result.rgbBlue := 0;
    Result.rgbGreen := 0;
    Result.rgbRed := 0;
    Result.rgbReserved := 0;
  end
  else
    {Returns the item}
    Result := Header.BitmapInfo.bmiColors[Idx];
end;

{Loads the palette chunk from a stream}
function PLTE_Load(Chunk: Pointer; Stream: PStream;
  const ChunkName: TChunkName; Size: Integer): Boolean;
type
  pPalEntry = ^PalEntry;
  PalEntry = record r, g, b: Byte end;
var
  j       : Integer;
  PalColor: pPalEntry;
begin
  {Let ancestor load data and check CRC}
  Result := PChunk( Chunk ).LoadFromStream(Stream, ChunkName, Size);
  if not Result then exit;

  with PChunkPLTE( Chunk )^ do
  begin
    {This chunk must be divisible by 3 in order to be valid}
    if (Size mod 3 <> 0) or (Size div 3 > 256) then
    begin
      {Raise error}
      Result := False;
      Owner.FError := ErrInvalidPalette;
      exit;
    end {if Size mod 3 <> 0};

    {Fill array with the palette entries}
    fCount := Size div 3;
    PalColor := Data;
    for j := 0 to fCount - 1 do
      with Header.BitmapInfo.bmiColors[j] do
      begin
        rgbRed  :=  Owner.GammaTable[PalColor.r];
        rgbGreen := Owner.GammaTable[PalColor.g];
        rgbBlue :=  Owner.GammaTable[PalColor.b];
        rgbReserved := 0;
        Inc(PalColor); {Move to next palette entry}
      end;
  end;
end;

{Saves the PLTE chunk to a stream}
function PLTE_Save(Chunk: Pointer; Stream: PStream): Boolean;
var
  J: Integer;
  DataPtr: PByte;
begin
  with PChunkPLTE( Chunk )^ do
  begin
    {Adjust size to hold all the palette items}
    ResizeData(fCount * 3);
    {Copy pointer to data}
    DataPtr := fData;

    {Copy palette items}
    with Header^ do
      for j := 0 to fCount - 1 do
        with BitmapInfo.bmiColors[j] do
        begin
          DataPtr^ := Owner.InverseGamma[rgbRed]; Inc(DataPtr);
          DataPtr^ := Owner.InverseGamma[rgbGreen]; Inc(DataPtr);
          DataPtr^ := Owner.InverseGamma[rgbBlue]; Inc(DataPtr);
        end {with BitmapInfo};

    {Let ancestor do the rest of the work}
    Result := SaveToStream(Stream);
  end;
end;

{TChunkgAMA implementation}

{Gamma chunk being created}
constructor TChunkgAMa.Create(AOwner: PPngObject);
begin
  {Call ancestor}
  inherited Create(AOwner);
  Gamma := 1;  {Initial value}
end;

{Returns gamma value}
function TChunkgAMA.GetValue: DWORD;
begin
  {Make sure that the size is four bytes}
  if DataSize <> 4 then
  begin
    {Adjust size and returns 1}
    ResizeData(4);
    Result := 1;
  end
  {If it's right, read the value}
  else Result := DWORD(ByteSwap(PDWORD(Data)^))
end;

function Power(Base, Exponent: Extended): Extended;
begin
  if Exponent = 0.0 then
    Result := 1.0               {Math rule}
  else if (Base = 0) or (Exponent = 0) then Result := 0
  else
    Result := Exp(Exponent * Ln(Base));
end;


{Loading the chunk from a stream}
function gAMA_Load(Chunk: Pointer; Stream: PStream;
  const ChunkName: TChunkName; Size: Integer): Boolean;
var
  i: Integer;
  Value: DWORD;
begin
  {Call ancestor and test if it went ok}
  Result := PChunk(Chunk).LoadFromStream(Stream, ChunkName, Size);
  if not Result then exit;

  with PChunkGAMA(Chunk)^ do
  begin
    Value := Gamma;
    {Build gamma table and inverse table for saving}
    if Value <> 0 then
      with Owner^ do
        for i := 0 to 255 do
        begin
          GammaTable[I] := Round(Power((I / 255), 1 /
            (Value / 100000 * 2.2)) * 255);
          InverseGamma[Round(Power((I / 255), 1 /
            (Value / 100000 * 2.2)) * 255)] := I;
        end
  end;
end;

function TPngObject.GetScaledHeight: Integer;
var
  i: Integer;
begin
  Result := Height;
  case Scale of
    psHalfSize   : i := 2;
    psQuarterSize: i := 4;
    psEightsSize : i := 8;
    else Exit;
  end;
  Result := Result div i;
end;

function TPngObject.GetScaledWidth: Integer;
var
  i: Integer;
begin
  Result := Width;
  case Scale of
    psHalfSize   : i := 2;
    psQuarterSize: i := 4;
    psEightsSize : i := 8;
    else Exit;
  end;
  Result := Result div i;
end;

{Sets the gamma value}
procedure TChunkgAMA.SetValue(const Value: DWORD);
begin
  {Make sure that the size is four bytes}
  if DataSize <> 4 then ResizeData(4);
  {If it's right, set the value}
  PDWORD(Data)^ := ByteSwap(Value);
end;

{TPngObject implementation}

type
  PCrackBitmap = ^TCrackBitmap;
  TCrackBitmap = object( TBitmap )
  end;

{Clear all the chunks in the list}
procedure TPngObject.ClearChunks;
var
  i: Integer;
begin
  //- fix: HiAsm 
  if fBitmap <> nil then    
   begin
     PCrackBitmap(fBitmap).fDIBBits := fOldBitmapData.fDIBBits;
     PCrackBitmap(fBitmap).fWidth := fOldBitmapData.fWidth;
     PCrackBitmap(fBitmap).fHeight := fOldBitmapData.fHeight;
     PCrackBitmap(fBitmap).fScanLineSize := fOldBitmapData.fScanLineSize;
     PCrackBitmap(fBitmap).fDibSize := fOldBitmapData.fDibSize;
     Free_And_Nil( fBitmap );
   end;
  //- fix: HiAsm 
  {Initialize gamma}
  InitializeGamma();
  {Free all the objects and memory (0 chunks Bug fixed by Noel Sharpe)}
  for i := 0 to Chunks.Count - 1 do
    PObj( Chunks.Items[i] ).Free;
  Chunks.Clear;
end;

{Portable Network Graphics object being created}
function NewPngObject: PPngObject;
begin
  {Let it be created}
  New( Result, Create );

  with Result^ do
  begin
    {Initial properties}
    fFilters := [pfSub];
    fCompressionLevel := 7;
    fInterlaceMethod := imNone;
    fMaxIdatSize := High(Word);
    {Create chunklist object}
    fChunkList := NewList;
  end;
end;

{Portable Network Graphics object being destroyed}
destructor TPngObject.Destroy;
begin
  {Free object list}
  ClearChunks;
  fChunkList.Free;

  {Call ancestor destroy}
  inherited Destroy;
end;

{Returns linesize and byte offset for pixels}
procedure TPngObject.GetPixelInfo(var LineSize, Offset: DWORD);
begin
  {There must be an Header chunk to calculate size}
  if HeaderPresent then
  begin
    {Calculate number of bytes for each line}
    LineSize := BytesForPixels(Header.Width, Header.ColorType, Header.BitDepth);

    {Calculates byte offset}
    Case Header.ColorType of
      {Grayscale}
      COLOR_GRAYSCALE:
        If Header.BitDepth = 16 Then
          Offset := 2
        Else
          Offset := 1 ;
      {It always smaller or equal one byte, so it occupes one byte}
      COLOR_PALETTE:
        offset := 1;
      {It might be 3 or 6 bytes}
      COLOR_RGB:
        offset := 3 * Header.BitDepth Div 8;
      {It might be 2 or 4 bytes}
      COLOR_GRAYSCALEALPHA:
        offset := 2 * Header.BitDepth Div 8;
      {4 or 8 bytes}
      COLOR_RGBALPHA:
        offset := 4 * Header.BitDepth Div 8;
      else
        Offset := 0;
      End ;

  end
  else
  begin
    {In case if there isn't any Header chunk}
    Offset := 0;
    LineSize := 0;
  end;

end;

{Returns image height}
function TPngObject.GetHeight: Integer;
begin
  {There must be a Header chunk to get the size, otherwise returns 0}
  if HeaderPresent then
    Result := Header.Height
  else Result := 0;
end;

{Returns image width}
function TPngObject.GetWidth: Integer;
begin
  {There must be a Header chunk to get the size, otherwise returns 0}
  if HeaderPresent then
    Result := Header.Width
  else Result := 0;
end;

{Returns if the image is empty}
function TPngObject.GetEmpty: Boolean;
begin
  Result := (Chunks.Count = 0);
end;

{Set the maximum size for IDAT chunk}
procedure TPngObject.SetMaxIdatSize(const Value: DWORD);
begin
  {Make sure the size is at least 65535}
  if Value < High(Word) then
    fMaxIdatSize := High(Word) else fMaxIdatSize := Value;
end;

{Creates a file stream reading from the filename in the parameter and load}
function TPngObject.LoadFromFile(const Filename: string): Boolean;
var FileStream: PStream;
begin
  FileStream := NewReadFileStream(Filename);
  Result := LoadFromStream(FileStream);
  FileStream.Free;
end;

{Saves the current png image to a file}
procedure TPngObject.SaveToFile(const Filename: string);
var FileStream: PStream;
begin
  FileStream := NewWriteFileStream(Filename);
  SaveToStream(FileStream);
  FileStream.Free;
end;

{Returns pointer to the chunk TChunkIHDR which should be the first}
function TPngObject.GetHeader: PChunkIHDR;
begin
  {If there is a TChunkIHDR returns it, otherwise returns nil}
  if (Chunks.Count > 0) {and (Chunks.Items[0] is TChunkIHDR)} then
    Result := Pointer( Chunks.Items[0] )
  else
  begin
    {No header, throw error message}
    Result := nil
  end
end;

{Draws using partial transparency}
procedure TPngObject.DrawPartialTrans(DC: HDC; Rect: TRect);
type
  {Access to pixels}
  TPixelLine = array[Word] of TRGBQuad;
  PPixelLine = ^TPixelLine;
const
  {Structure used to create the bitmap}
  BitmapInfoHeader: TBitmapInfoHeader =
    (biSize: SizeOf(TBitmapInfoHeader);
     biWidth: 100;
     biHeight: 100;
     biPlanes: 1;
     biBitCount: 32;
     biCompression: BI_RGB;
     biSizeImage: 0;
     biXPelsPerMeter: 0;
     biYPelsPerMeter: 0;
     biClrUsed: 0;
     biClrImportant: 0);
var
  {Buffer bitmap creation}
  BitmapInfo  : TBitmapInfo;
  BufferDC    : HDC;
  BufferBits  : Pointer;
  OldBitmap,
  BufferBitmap: HBitmap;

  {Transparency/palette chunks}
  TransparencyChunk: PChunktRNS;
  PaletteChunk: PChunkPLTE;
  TransValue, PaletteIndex: Byte;
  CurBit: Integer;
  Data: PByte;

  {Buffer bitmap modification}
  BytesPerRowDest,
  BytesPerRowSrc,
  BytesPerRowAlpha: Integer;
  ImageSource,
  AlphaSource : PByteArray;
  ImageData   : PPixelLine;
  i, j        : Integer;
begin
  {Prepare to create the bitmap}
  FillChar(BitmapInfo, SizeOf(BitmapInfo), #0);
  BitmapInfoHeader.biWidth := Header.Width;
  BitmapInfoHeader.biHeight := -1 * Header.Height;
  BitmapInfo.bmiHeader := BitmapInfoHeader;

  {Create the bitmap which will receive the background, the applied}
  {alpha blending and then will be painted on the background}
  BufferDC := CreateCompatibleDC(0);
  {In case BufferDC could not be created}
  if (BufferDC = 0) then //RaiseError(EPNGOutMemory, EPNGOutMemoryText);
                         Exit;
  BufferBitmap := CreateDIBSection(BufferDC, BitmapInfo, DIB_RGB_COLORS,
    BufferBits, 0, 0);
  {In case buffer bitmap could not be created}
  if (BufferBitmap = 0) or (BufferBits = Nil) then
  begin
    if BufferBitmap <> 0 then DeleteObject(BufferBitmap);
    DeleteDC(BufferDC);
    //RaiseError(EPNGOutMemory, EPNGOutMemoryText);
    Exit;
  end;

  {Selects new bitmap and release old bitmap}
  OldBitmap := SelectObject(BufferDC, BufferBitmap);

  {Draws the background on the buffer image}
  StretchBlt(BufferDC, 0, 0, Header.Width, Header.height, DC, Rect.Left,
    Rect.Top, Header.Width, Header.Height, SRCCOPY);

  {Obtain number of bytes for each row}
  BytesPerRowAlpha := Header.Width;
  BytesPerRowDest := (((BitmapInfo.bmiHeader.biBitCount * Width) + 31)
    and not 31) div 8; {Number of bytes for each image row in destination}
  BytesPerRowSrc := (((Header.BitmapInfo.bmiHeader.biBitCount * Header.Width) +
    31) and not 31) div 8; {Number of bytes for each image row in source}

  {Obtains image pointers}
  ImageData := BufferBits;
  AlphaSource := Header.ImageAlpha;
  NativeInt(ImageSource) := NativeInt(Header.ImageData) +
    Header.BytesPerRow * NativeInt(Header.Height - 1);

  case Header.BitmapInfo.bmiHeader.biBitCount of
    {R, G, B images}
    24:
      for j := 1 to Header.Height do
      begin
        {Process all the pixels in this line}
        for i := 0 to Header.Width - 1 do
          with ImageData[i] do
          begin
            rgbRed := (255+ImageSource[2+i*3] * AlphaSource[i] + rgbRed * (255 -
              AlphaSource[i])) shr 8;
            rgbGreen := (255+ImageSource[1+i*3] * AlphaSource[i] + rgbGreen *
              (255 - AlphaSource[i])) shr 8;
            rgbBlue := (255+ImageSource[i*3] * AlphaSource[i] + rgbBlue *
             (255 - AlphaSource[i])) shr 8;
          end;

        {Move pointers}
        NativeInt(ImageData) := NativeInt(ImageData) + BytesPerRowDest;
        NativeInt(ImageSource) := NativeInt(ImageSource) - BytesPerRowSrc;
        NativeInt(AlphaSource) := NativeInt(AlphaSource) + BytesPerRowAlpha;
      end;
    {Palette images with 1 byte for each pixel}
    1,4,8: if Header.ColorType = COLOR_GRAYSCALEALPHA then
      for j := 1 to Header.Height do
      begin
        {Process all the pixels in this line}
        for i := 0 to Header.Width - 1 do
          with ImageData[i], Header.BitmapInfo do
          begin
            rgbRed := (255 + ImageSource[i] * AlphaSource[i] +
              rgbRed * (255 - AlphaSource[i])) shr 8;
            rgbGreen := (255 + ImageSource[i] * AlphaSource[i] +
              rgbGreen * (255 - AlphaSource[i])) shr 8;
            rgbBlue := (255 + ImageSource[i] * AlphaSource[i] +
              rgbBlue * (255 - AlphaSource[i])) shr 8;
          end;

        {Move pointers}
        NativeInt(ImageData) := NativeInt(ImageData) + BytesPerRowDest;
        NativeInt(ImageSource) := NativeInt(ImageSource) - BytesPerRowSrc;
        NativeInt(AlphaSource) := NativeInt(AlphaSource) + BytesPerRowAlpha;
      end
    else {Palette images}
    begin
      {Obtain pointer to the transparency chunk}
      TransparencyChunk := ChunkByName('tRNS');
      PaletteChunk := ChunkByName('PLTE');

      for j := 1 to Header.Height do
      begin
        {Process all the pixels in this line}
        i := 0; Data := @ImageSource[0];
        repeat
          CurBit := 0;

          repeat
            {Obtains the palette index}
            case Header.BitDepth of
              1: PaletteIndex := (Data^ shr (7-(I Mod 8))) and 1;
            2,4: PaletteIndex := (Data^ shr ((1-(I Mod 2))*4)) and $0F;
             else PaletteIndex := Data^;
            end;

            {Updates the image with the new pixel}
            with ImageData[i] do
            begin
              TransValue := TransparencyChunk.PaletteValues[PaletteIndex];
              rgbRed := (255 + PaletteChunk.Item[PaletteIndex].rgbRed *
                 TransValue + rgbRed * (255 - TransValue)) shr 8;
              rgbGreen := (255 + PaletteChunk.Item[PaletteIndex].rgbGreen *
                 TransValue + rgbGreen * (255 - TransValue)) shr 8;
              rgbBlue := (255 + PaletteChunk.Item[PaletteIndex].rgbBlue *
                 TransValue + rgbBlue * (255 - TransValue)) shr 8;
            end;

            {Move to next data}
            Inc(i); Inc(CurBit, Header.BitmapInfo.bmiHeader.biBitCount);
          until CurBit >= 8;
          {Move to next source data}
          Inc(Data);
        until i >= Integer(Header.Width);

        {Move pointers}
        NativeInt(ImageData) := NativeInt(ImageData) + BytesPerRowDest;
        NativeInt(ImageSource) := NativeInt(ImageSource) - BytesPerRowSrc;
      end
    end {Palette images}
  end {case Header.BitmapInfo.bmiHeader.biBitCount};

  {Draws the new bitmap on the foreground}
  StretchBlt(DC, Rect.Left, Rect.Top, Header.Width, Header.Height, BufferDC,
    0, 0, Header.Width, Header.Height, SRCCOPY);

  {Free bitmap}
  SelectObject(BufferDC, OldBitmap);
  DeleteObject(BufferBitmap);
  DeleteDC(BufferDC);
end;

{Draws the image into a canvas}
function TPngObject.Draw(DC: HDC; X, Y: Integer): Boolean;
var
  Hdr: PChunkIHDR;
begin
  Result := False;
  {Quit in case there is no header, otherwise obtain it}
  Hdr := Header;
  if Hdr = nil then Exit;

  Result := True;
  if 0 = StretchDiBits(DC, X, Y, {Hdr.Width} ScaledWidth, {Hdr.Height} ScaledHeight, 0, 0,
    ScaledWidth, ScaledHeight, Hdr.ImageData,
    pBitmapInfo(@Hdr.BitmapInfo)^, DIB_RGB_COLORS, SRCCOPY) then
  begin
    if 0 = SetDibitsToDevice( DC, X, Y, {Hdr.Width} ScaledWidth, {Hdr.Height} ScaledHeight, 0, 0, 0,
      {Hdr.Height} ScaledHeight, Pointer( Integer( Hdr.ImageData ) + (Hdr.Height-1) * Hdr.BytesPerRow ),
      pBitmapInfo( @Hdr.BitmapInfo )^, DIB_RGB_COLORS ) then
    begin
      Result := False;
      asm
        nop
      end;
    end;
  end;
end;

procedure TPngObject.DrawTransparent(DC: HDC; X, Y, maxX, maxY: Integer;
  TranColor: TColor);
var
  Hdr: PChunkIHDR;
begin
  {Quit in case there is no header, otherwise obtain it}
  Hdr := Header;
  if Hdr = nil then Exit;

  {Copy the data to the canvas}
  case Self.TransparencyMode of
    ptmPartial:
      DrawPartialTrans(DC, MakeRect( X, Y, min( X + Width, maxX ), min( Y + Height, maxY ) ));
    else DrawTransparentBitmap(DC,
      Hdr.ImageData, Hdr.BitmapInfo.bmiHeader,
      pBitmapInfo(@Header.BitmapInfo), MakeRect( X, Y, min( X + Width, maxX ), min( Y + Height, maxY ) ),
      Color2RGB(TranColor))
  end {case}
end;

function TPngObject.StretchDraw(DC: HDC; const Rect: TRect): Boolean;
var
  Hdr: PChunkIHDR;
begin
  Result := False;
  {Quit in case there is no header, otherwise obtain it}
  Hdr := Header;
  if Hdr = nil then Exit;
  if (Rect.Right - Rect.Left = Hdr.Width) and
     (Rect.Bottom - Rect.Top = Hdr.Height) then
  begin
    Result := Draw( DC, Rect.Left, Rect.Top );
    if Result then
      Exit;
  end;
  Result := Hdr.Height = StretchDiBits(DC, Rect.Left,
    Rect.Top, Rect.Right - Rect.Left, Rect.Bottom - Rect.Top, 0, 0,
    ScaledWidth, ScaledHeight, Hdr.ImageData,
    pBitmapInfo(@Hdr.BitmapInfo)^, DIB_RGB_COLORS, SRCCOPY)
end;

procedure TPngObject.StretchDrawTransparent(DC: HDC; const Rect: TRect;
  TranColor: TColor);
var
  Hdr: PChunkIHDR;
begin
  {Quit in case there is no header, otherwise obtain it}
  Hdr := Header;
  if Hdr = nil then Exit;

  case Self.TransparencyMode of
    ptmPartial:
      DrawPartialTrans(DC, Rect);
    else // ptmBit:
      DrawTransparentBitmap(DC,
          Hdr.ImageData, Hdr.BitmapInfo.bmiHeader,
          pBitmapInfo(@Header.BitmapInfo), Rect,
          Color2RGB(TranColor));
  end;
end;

{Characters for the header}
const
  PngHeader: array[0..7] of AnsiChar = (#137, #80, #78, #71, #13, #10, #26, #10);

{Loads the image from a stream of data}
function TPngObject.LoadFromStream(Stream: PStream): Boolean;
const
  ChunkLoadArray: TLoadArray = ( nil, IHDR_Load, nil, IDAT_Load,
                  PLTE_Load, gAMA_Load, TRNS_Load, tEXt_Load, tIME_Load );
var
  Hdr: array[0..7] of AnsiChar;
  HasIDAT: Boolean;

  {Chunks reading}
  ChunkLength: DWORD;
  ChunkName  : TChunkName;

  Chunk: PChunk;
  CType: TChunkType;
  Start: DWORD;
begin
  FError := ErrOK;
  Result := False;

  Start := Stream.Position;

  {Initialize before start loading chunks}
  ClearChunks();
  {Reads the header}
  Stream.Read(Hdr[0], 8);

  {Test if the header matches}
  if Hdr <> PngHeader then
  begin
    FError := ErrInvalidHeader;
    Exit;
  end;

  HasIDAT := False;
  {Load chunks}
  repeat
    if Assigned( fOnProgress ) then
    begin
      if not OnProgress( @ Self, 0, 0,
         (Stream.Position - Start) * 100 div (Stream.Size - Start) ) then
         break;
    end;

    {Reads chunk length and invert since it is in network order}
    {also checks the Read method return, if it returns 0, it}
    {means that no bytes was readed, probably because it reached}
    {the end of the file}
    if Stream.Read(ChunkLength, 4) < 4 then
    begin
      {In case it found the end of the file here}
      FError := ErrUnexpectedEnd;
      Result := HeaderPresent and (ChunkByName( 'IDAT' ) <> nil);
      Exit;
    end;

    ChunkLength := ByteSwap(ChunkLength);
    {Reads chunk name}
    Stream.Read(Chunkname, 4);

    {Here we check if the first chunk is the Header which is necessary}
    {to the file in order to be a valid Portable Network Graphics image}
    if (Chunks.Count = 0) and (ChunkName <> 'IHDR') then
    begin
      FError := ErrIHDRNotFirst;
      exit;
    end;

    {Has a previous IDAT}
    if (HasIDAT and (ChunkName = 'IDAT')) or (ChunkName = 'cHRM') then
    begin
      Stream.Position := Stream.Position + ChunkLength + 4;
      Continue;
    end;
    {Tell it has an IDAT chunk}
    if ChunkName = 'IDAT' then HasIDAT := True;

    {Creates object for this chunk}

    Chunk := CreateChunkByName( ChunkName );

    {Check if the chunk is unknown and this is critical}
      if Chunk = nil then
      begin
        FError := ErrUnknownCriticalChunk;
        Exit;
      end;

    {Loads it}
    CType := ChunkTypeByName( ChunkName );
    if Assigned( ChunkLoadArray[ CType ] ) then
    begin
      if not ChunkLoadArray[ CType ]( Chunk, Stream, ChunkName, ChunkLength )
      then
        break;

      if HasIDAT and (Scale <> psFullImage)
      then
        break;
    end
    else
    begin
      if not Chunk.LoadFromStream( Stream, ChunkName, ChunkLength )
      then
        break;
    end;

  {Terminates when it reaches the IEND chunk}
  until (ChunkName = 'IEND');

  {Check if there is data}
  if not HasIDAT then
  begin
    FError := ErrNoImageData;
    Exit;
  end;

  Result := True;
end;

{Saves to clipboard format (thanks to Antoine Pottern)}
function TPNGObject.CopyToClipboard: Boolean;
begin
  Result := False;
  if Bitmap <> nil then
    Result := Bitmap.CopyToClipboard;
end;
{var Bitmap: PBitmap;
begin
  Bitmap := NewBitmap( Width, Height );
  TRY
    Draw( Bitmap.Canvas.Handle, 0, 0 );
    Result := Bitmap.CopyToClipboard;
  FINALLY
    Bitmap.Free;
  END;
end;}

{Loads data from clipboard}
function TPngObject.PasteFromClipboard: Boolean;
var Bitmap1: PBitmap;
begin
  Bitmap1 := NewBitmap( 0, 0 );
  TRY
    Result := Bitmap1.PasteFromClipboard;
    if not Result then Exit;
    AssignHandle( Bitmap1.Handle, False, 0 );
  FINALLY
    Bitmap1.Free;
  END;
end;

{Returns if the image is transparent}
{function TPngObject.GetTransparent: Boolean;
begin
  Result := (TransparencyMode <> ptmNone);
end;}

{Saving the PNG image to a stream of data}
procedure TPngObject.SaveToStream(Stream: PStream);
const
  ChunkSaveArray: TSaveArray = ( nil, IHDR_Save, nil, IDAT_Save,
                  PLTE_Save, nil, TRNS_Save, tEXt_Save, tIME_Save );
var
  j: Integer;
  CType: TChunkType;
begin
  {Reads the header}
  Stream.Write(PNGHeader[0], 8);
  {Write each chunk}
  for j := 0 to Chunks.Count - 1 do
  begin
    CType := ChunkTypeByName( PChunk( Chunks.Items[j] ).ChnkName );
    if Assigned( ChunkSaveArray[ CType ] ) then
      ChunkSaveArray[ CType ]( Chunks.Items[j], Stream )
    else
      PChunk( Chunks.Items[j] ).SaveToStream(Stream);
  end;
end;

{Prepares the Header chunk}
procedure BuildHeader(Header: PChunkIHDR; Handle: HBitmap; Info: Windows.PBitmap;
  HasPalette: Boolean);
var
  DC: HDC;
begin
  {Set width and height}
  Header.Width := Info.bmWidth;
  Header.Height := abs(Info.bmHeight);
  {Set bit depth}
  if Info.bmBitsPixel >= 16 then
    Header.BitDepth := 8 else Header.BitDepth := Info.bmBitsPixel;
  {Set color type}
  if Info.bmBitsPixel >= 16 then
    Header.ColorType := COLOR_RGB else Header.ColorType := COLOR_PALETTE;
  {Set other info}
  Header.CompressionMethod := 0;  {deflate/inflate}
  Header.InterlaceMethod := 0;    {no interlace}

  {Prepares bitmap headers to hold data}
  Header.PrepareImageData();
  if Handle <> 0 then
  begin
    {Copy image data}
    DC := CreateCompatibleDC(0);
    GetDIBits(DC, Handle, 0, Header.Height, Header.ImageData,
      pBitmapInfo(@Header.BitmapInfo)^, DIB_RGB_COLORS);
    DeleteDC(DC);
  end;
end;

{Loads the image from a resource}
procedure TPngObject.LoadFromResourceName(Instance: HInst;
  const AName: string);
var MemStream: PStream;
begin
  {Creates an especial stream to load from the resource}
  MemStream := NewMemoryStream;
  Resource2Stream( MemStream, Instance, PChar( AName ), RT_RCDATA );
  {Loads the png image from the resource}
  try
    MemStream.Position := 0;
    LoadFromStream(MemStream);
  finally
    MemStream.Free;
  end;
end;

{Loads the png from a resource ID}
procedure TPngObject.LoadFromResourceID(Instance: HInst; ResID: Integer);
begin
  LoadFromResourceName(Instance, MAKEINTRESOURCE(ResID));
end;

{Assigns from a bitmap object}
procedure TPngObject.AssignHandle(Handle: HBitmap; Transparent: Boolean;
  TranColor: ColorRef);
var
  BitmapInfo: Windows.TBitmap;
  HasPalette: Boolean;

  {Chunks}
  Head: PChunkIHDR;
  PLTE: PChunkPLTE;
  //IDAT: PChunkIDAT;
  //IEND: PChunkIEND;
  TRNS: PChunkTRNS;
begin
  {Obtain bitmap info}
  GetObject(Handle, SizeOf(BitmapInfo), @BitmapInfo);

  {Only bit depths 1, 4 and 8 needs a palette}
  HasPalette := (BitmapInfo.bmBitsPixel < 16);

  {Clear old chunks and prepare}
  ClearChunks();

  {Create the chunks}
  Head := CreateChunkByName( 'IHDR' );

  PLTE := nil;
  if HasPalette then
    PLTE := CreateChunkByName( 'PLTE' );

  TRNS := nil;
  if Transparent then
    TRNS := CreateChunkByName( 'TRNS' );
  CreateChunkByName( 'IDAT' );
  CreateChunkByName( 'IEND' );

  {This method will fill the Header chunk with bitmap information}
  {and copy the image data}
  BuildHeader(Head, Handle, @BitmapInfo, HasPalette);

  {In case there is a image data, set the PLTE chunk fCount variable}
  {to the actual number of palette colors which is 2^(Bits for each pixel)}
  if HasPalette then PLTE.fCount := 1 shl BitmapInfo.bmBitsPixel;

  {In case it is a transparent bitmap, prepares it}
  if Transparent then TRNS.TransparentColor := TranColor;

end;

{Assigns from another PNG}
procedure TPngObject.AssignPNG(Source: PPNGObject);
var Strm: PStream;
begin
  Strm := NewMemoryStream;
  Source.SaveToStream( Strm );
  Strm.Position := 0;
  LoadFromStream( Strm );
  Strm.Free;
end;

{Returns a alpha data scanline}
function TPngObject.GetAlphaScanline(const LineIndex: Integer): PByteArray;
begin
  with Header^ do
    if (ColorType = COLOR_RGBALPHA) or (ColorType = COLOR_GRAYSCALEALPHA) then
      NativeInt(Result) := NativeInt(ImageAlpha) + (LineIndex * NativeInt(Width))
    else Result := nil;  {In case the image does not use alpha information}
end;

{Returns a png data scanline}
function TPngObject.GetScanline(const LineIndex: Integer): Pointer;
begin
  with Header^ do
    NativeInt(Result) := (NativeInt(ImageData) + ((NativeInt(Height) - 1) *
      BytesPerRow)) - (LineIndex * BytesPerRow);
end;

{Initialize gamma table}
procedure TPngObject.InitializeGamma;
var
  i: Integer;
begin
  {Build gamma table as if there was no gamma}
  for i := 0 to 255 do
  begin
    GammaTable[i] := i;
    InverseGamma[i] := i;
  end {for i}
end;

{Returns the transparency mode used by this png}
function TPngObject.GetTransparencyMode: TPNGTransparencyMode;
var
  TRNS: PChunkTRNS;
begin
  with Header^ do
  begin
    Result := ptmNone; {Default result}
    {Gets the TRNS chunk pointer}
    TRNS := ChunkByName('TRNS');

    {Test depending on the color type}
    case ColorType of
      {This modes are always partial}
      COLOR_RGBALPHA, COLOR_GRAYSCALEALPHA: Result := ptmPartial;
      {This modes support bit transparency}
      COLOR_RGB, COLOR_GRAYSCALE: if TRNS <> nil then Result := ptmBit;
      {Supports booth translucid and bit}
      COLOR_PALETTE:
        {A TRNS chunk must be present, otherwise it won't support transparency}
        if TRNS <> nil then
          if TRNS.BitTransparency then
            Result := ptmBit else Result := ptmPartial
    end {case}

  end {with Header}
end;

{Add a text chunk}
procedure TPngObject.AddText(const Keyword, Text: AnsiString);
var
  TextChunk: PChunkTEXT;
begin
  New( TextChunk, Create( @ Self ) );
  fChunkList.Insert( fChunkList.Count-1, TextChunk );
  TextChunk.Keyword := Keyword;
  TextChunk.Text := Text;
end;

{Removes the image transparency}
procedure TPngObject.RemoveTransparency;
var TRNS: PChunkTRNS;
begin
  TRNS := ChunkByName('TRNS');
  if TRNS <> nil then
  begin
    Chunks.Remove(TRNS);
    TRNS.Free;
  end;
end;

{Generates alpha information}
procedure TPngObject.CreateAlpha;
var
  TRNS: PChunkTRNS;
begin
  {Generates depending on the color type}
  with Header^ do
    case ColorType of
      {Png allocates different memory space to hold alpha information}
      {for these types}
      COLOR_GRAYSCALE, COLOR_RGB:
      begin
        {Transform into the appropriate color type}
        if ColorType = COLOR_GRAYSCALE then
          ColorType := COLOR_GRAYSCALEALPHA
        else ColorType := COLOR_RGBALPHA;
        {Allocates memory to hold alpha information}
        GetMem(ImageAlpha, Integer(Width) * Integer(Height));
        FillChar(ImageAlpha^, Integer(Width) * Integer(Height), #255);
      end;
      {Palette uses the TChunktRNS to store alpha}
      COLOR_PALETTE:
      begin
        {Gets/creates TRNS chunk}
        TRNS := ChunkByName( 'TRNS' );
        if TRNS = nil then
          TRNS := CreateChunkByName( 'TRNS' );

        {Prepares the TRNS chunk}
        with TRNS^ do
        begin
          FillChar(PaletteValues[0], 256, #255);
          fDataSize := 1 shl Header.BitDepth;
          fBitTransparency := False
        end {with Chunks.Add};
      end;
    end {case Header.ColorType}

end;

{Returns transparent color}
function TPngObject.GetTransparentColor: TColor;
var
  TRNS: PChunkTRNS;
begin
  TRNS := ChunkByName( 'TRNS' );
  {Reads the transparency chunk to get this info}
  if Assigned(TRNS) then Result := TRNS.TransparentColor
    else Result := 0
end;

procedure TPngObject.SetTransparentColor(const Value: TColor);
var
  TRNS: PChunkTRNS;
begin
  if HeaderPresent then
    {Tests the ColorType}
    case Header.ColorType of
    {Not allowed for this modes}
    COLOR_RGBALPHA, COLOR_GRAYSCALEALPHA:
      {Self.RaiseError(
      EPNGCannotChangeTransparent, EPNGCannotChangeTransparentText)};
    {Allowed}
    COLOR_PALETTE, COLOR_RGB, COLOR_GRAYSCALE:
      begin
        TRNS := ChunkByName('TRNS');
        if not Assigned(TRNS) then
          TRNS := CreateChunkByName('TRNS');
        {Sets the transparency value from TRNS chunk}
        TRNS.TransparentColor := Value
      end {COLOR_PALETTE, COLOR_RGB, COLOR_GRAYSCALE)}
    end {case}
end;

{Returns if header is present}
function TPngObject.HeaderPresent: Boolean;
begin
  Result := (Chunks.Count > 0) and (PChunk(Chunks.Items[0]).ChnkName = 'IHDR')
end;

function TPngObject.ChunkByName(const AName: TChunkName): Pointer;
var
  I: Integer;
  Chunk: PChunk;
begin
  for I := 0 to fChunkList.Count-1 do
  begin
    Chunk := fChunkList.Items[ I ];
    if Chunk.ChnkName = AName then
    begin
      Result := Chunk;
      Exit;
    end;
  end;
  Result := nil;
end;

function TPngObject.CreateChunkByName(const AName: TChunkName): Pointer;
var
  IHDR: PChunkIHDR;
  IEND: PChunkIEND;
  IDAT: PChunkIDAT;
  PLTE: PChunkPLTE;
  GAMA: PChunkGAMA;
  TRNS: PChunkTRNS;
  TEXT: PChunkTEXT;
  TIME: PChunkTIME;
  Chnk: PChunk;
begin
  Result := nil;
  case ChunkTypeByName( AName ) of
  ctIHDR:  begin
             if HeaderPresent then Exit;
             New( IHDR, Create( @ Self ) );
             fChunkList.Insert( 0, IHDR );
             Result := IHDR;
           end;
  ctIEND:  begin
             if (fChunkList.Count > 0) and
                (PChunk( fChunkList.Items[ fChunkList.Count-1 ] ).ChnkName = 'IEND') then
                Exit;
             New( IEND, Create( @ Self ) );
             fChunkList.Add( IEND );
             Result := IEND;
           end;
  ctIDAT:  begin
             if ChunkByName( 'IDAT' ) <> nil then Exit;
             New( IDAT, Create( @ Self ) );
             IHDR := ChunkByName( 'IHDR' );
             PLTE := ChunkByName( 'PLTE' );
             if PLTE <> nil then
               fChunkList.Insert( PLTE.Index+1, IDAT )
             else
             if IHDR <> nil then
               fChunkList.Insert( 1, IDAT )
             else
               fChunkList.Insert( 0, IDAT );
             Result := IDAT;
           end;
  ctPLTE:  begin
             if ChunkByName( 'PLTE' ) <> nil then Exit;
             New( PLTE, Create( @ Self ) );
             IDAT := ChunkByName( 'IDAT' );
             IHDR := ChunkByName( 'IHDR' );
             if IDAT <> nil then
               fChunkList.Insert( IDAT.Index, PLTE )
             else if IHDR <> nil then
               fChunkList.Insert( 1, PLTE )
             else
               fChunkList.Insert( 0, PLTE );
             Result := PLTE;
           end;
  ctgAMA:  begin
             if ChunkByName( 'gAMA' ) <> nil then Exit;
             New( GAMA, Create( @ Self ) );
             PLTE := ChunkByName( 'PLTE' );
             IDAT := ChunkByName( 'IDAT' );
             IHDR := ChunkByName( 'IHDR' );
             if PLTE <> nil then
               fChunkList.Insert( PLTE.Index + 1, GAMA )
             else if IDAT <> nil then
               fChunkList.Insert( IDAT.Index + 1, GAMA )
             else if IHDR <> nil then
               fChunkList.Insert( 1, GAMA )
             else
               fChunkList.Insert( 0, GAMA );
             Result := GAMA;
           end;
  ctTRNS:  begin
             if ChunkByName( 'TRNS' ) <> nil then Exit;
             New( TRNS, Create( @ Self ) );
             GAMA := ChunkByName( 'gAMA' );
             PLTE := ChunkByName( 'PLTE' );
             IDAT := ChunkByName( 'IDAT' );
             IHDR := ChunkByName( 'IHDR' );
             if GAMA <> nil then
               fChunkList.Insert( GAMA.Index + 1, TRNS )
             else if PLTE <> nil then
               fChunkList.Insert( PLTE.Index + 1, TRNS )
             else if IDAT <> nil then
               fChunkList.Insert( IDAT.Index + 1, TRNS )
             else if IHDR <> nil then
               fChunkList.Insert( 1, TRNS )
             else
               fChunkList.Insert( 0, TRNS );
             Result := TRNS;
           end;
  cttEXt:  begin
             New( TEXT, Create( @ Self ) );
             IEND := ChunkByName( 'IEND' );
             if IEND <> nil then
               fChunkList.Insert( IEND.Index, TEXT )
             else
               fChunkList.Add( TEXT );
             Result := TEXT;
           end;
  cttIME:  begin
             New( TIME, Create( @ Self ) );
             IEND := ChunkByName( 'IEND' );
             if IEND <> nil then
               fChunkList.Insert( IEND.Index, TIME )
             else
               fChunkList.Add( TIME );
             Result := TIME;
           end;
  else
           begin
             New( Chnk, Create( @ Self ) );
             IEND := ChunkByName( 'IEND' );
             if IEND <> nil then
               fChunkList.Insert( IEND.Index, Chnk )
             else
               fChunkList.Add( Chnk );
             Result := Chnk;
           end;
  end;
  PChunk( Result ).fChnkName := AName;
end;

{ TChunktEXt }

destructor TChunktEXt.Destroy;
begin
  fKeyword := '';
  fText := '';
  inherited;
end;

procedure TPngObject.AssignDib(DibHeader: pBitmapInfo; DibData: Pointer;
  Transparent: Boolean; TranColor: ColorRef);
var
  BitmapInfo: Windows.TBitmap;
  HasPalette: Boolean;

  {Chunks}
  Head: PChunkIHDR;
  PLTE: PChunkPLTE;
  //IDAT: PChunkIDAT;
  //IEND: PChunkIEND;
  TRNS: PChunkTRNS;
begin
  {Obtain bitmap info}
  FillChar( BitmapInfo, SizeOf( BitmapInfo ), 0 );
  BitmapInfo.bmType := 0;
  BitmapInfo.bmWidth := DibHeader.bmiHeader.biWidth;
  BitmapInfo.bmHeight := DibHeader.bmiHeader.biHeight;
  BitmapInfo.bmWidthBytes := ( (DibHeader.bmiHeader.biWidth *
    (DibHeader.bmiHeader.biPlanes * DibHeader.bmiHeader.biBitCount) + 7) div 8
    + 3) div 4;
  BitmapInfo.bmPlanes := DibHeader.bmiHeader.biPlanes;
  BitmapInfo.bmBitsPixel := DibHeader.bmiHeader.biPlanes * DibHeader.bmiHeader.biBitCount;
  BitmapInfo.bmBits := DibData;

  {Only bit depths 1, 4 and 8 needs a palette}
  HasPalette := (BitmapInfo.bmBitsPixel < 16);

  {Clear old chunks and prepare}
  ClearChunks();

  {Create the chunks}
  Head := CreateChunkByName( 'IHDR' );

  PLTE := nil;
  if HasPalette then
    PLTE := CreateChunkByName( 'PLTE' );

  TRNS := nil;
  if Transparent then
    TRNS := CreateChunkByName( 'TRNS' );
  CreateChunkByName( 'IDAT' );
  CreateChunkByName( 'IEND' );

  {This method will fill the Header chunk with bitmap information}
  {and copy the image data}
  BuildHeader(Head, 0, @BitmapInfo, HasPalette);

  {In case there is a image data, set the PLTE chunk fCount variable}
  {to the actual number of palette colors which is 2^(Bits for each pixel)}
  if HasPalette then PLTE.fCount := 1 shl BitmapInfo.bmBitsPixel;

  {In case it is a transparent bitmap, prepares it}
  if Transparent then TRNS.TransparentColor := TranColor;

end;

function TPngObject.GetBitmap: PBitmap;
begin
  Result := fBitmap;
  if Result <> nil then Exit;
  if (Header = nil) or (Header.ImageData = nil) then Exit;
  fBitmap := NewDIBBitmap( 1, 1, pf1bit );
  
  //- fix: HiAsm 
    fOldBitmapData.fDIBBits := PCrackBitmap(fBitmap).fDIBBits;
    fOldBitmapData.fWidth := PCrackBitmap(fBitmap).fWidth;
    fOldBitmapData.fHeight := PCrackBitmap(fBitmap).fHeight;
    fOldBitmapData.fScanLineSize := PCrackBitmap(fBitmap).fScanLineSize;
    fOldBitmapData.fDibSize := PCrackBitmap(fBitmap).fDibSize;
    
//  GlobalFree( DWORD( PCrackBitmap( fBitmap ).fDIBBits ) );
  //- fix: HiAsm 
  
  move( Header.BitmapInfo, PCrackBitmap( fBitmap ).fDIBHeader^,
    SizeOf( TMAXBITMAPINFO ) );
  PCrackBitmap( fBitmap ).fDIBBits := Header.ImageData;
  PCrackBitmap( fBitmap ).fWidth := Width;
  PCrackBitmap( fBitmap ).fHeight := Height;
  PCrackBitmap( fBitmap ).fDIBAutoFree := True;
  PCrackBitmap( fBitmap ).fScanLineSize :=
    CalcScanLineSize( @PCrackBitmap( fBitmap ).fDIBHeader.bmiHeader );
  PCrackBitmap( fBitmap ).fDibSize := PCrackBitmap( fBitmap ).fScanLineSize
    * Height;
  Result := fBitmap;
end;

{$IFDEF PNG_MMX}
initialization
  mmxSupported := GetCpuType >= [ cpuMMX ];
{$ENDIF}

end.