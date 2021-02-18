unit KolZLib;

interface

uses
  Windows, Kol, Share {$IFDEF FPC}, paszlib{$ENDIF};

const
  ZLIB_ERROR      = DWord (-1);

type
  TAlloc = function (AppData: Pointer; Items, Size: Integer): Pointer;
  TFree = procedure (AppData, Block: Pointer);

  // Internal structure.  Ignore.
  {$IFNDEF FPC}
  TZStreamRec = packed record
    next_in: PChar;       // next input byte
    avail_in: Integer;    // number of bytes available at next_in
    total_in: Integer;    // total nb of input bytes read so far

    next_out: PChar;      // next output byte should be put here
    avail_out: Integer;   // remaining free space at next_out
    total_out: Integer;   // total nb of bytes output so far

    msg: PChar;           // last error message, NULL if no error
    internal: Pointer;    // not visible by applications

    zalloc: TAlloc;       // used to allocate the internal state
    zfree: TFree;         // used to free the internal state
    AppData: Pointer;     // private data object passed to zalloc and zfree

    data_type: Integer;   //  best guess about the data type: ascii or binary
    adler: Integer;       // adler32 value of the uncompressed data
    reserved: Integer;    // reserved for future use
  end;
  {$ELSE}
  TZStreamRec = TZStream;
  {$ENDIF}

  TZLibEvent = procedure (Sender: PStream) of Object;

  PZLibData = ^TZLibData;
  TZLibData = record
    FStrm: PStream;
    FStrmPos: Cardinal;
    FOnProgress: TZLibEvent;
    FZRec: TZStreamRec;
    FBuffer: array [Word] of Char;
  end;

  TCompressionLevel = (clNone, clFastest, clDefault, clMax);

//******************* NewCompressionStream *************************
// Creates new ZLib decompression stream. If ZLib initialization failed returns Nil;
// On Read/Write errors Read/Write functions return ZLIB_ERROR value (also for Seek).

function NewCompressionStream (CompressionLevel: TCompressionLevel; Destination: PStream; OnProgress: TZLibEvent): PStream;

//******************* NewDecompressionStream *************************
// Creates new ZLib decompression stream. If ZLib initialization failed returns Nil;
// On Read/Write errors Read/Write functions return ZLIB_ERROR value (also for Seek).

function NewDecompressionStream (Source: PStream; OnProgress: TZLibEvent): PStream;


//******************* NewZLibXStream *************************
//Calls New[De]CompressionStream and returns True if Result<>Nil; Stream = Result.
// !!! Don't use Overload on this functions - it may cause compilation error
// when called with OnProgress=Nil !!!

function NewZLibDStream (var Stream: PStream; Source: PStream; OnProgress: TZLibEvent): Boolean;
function NewZLibCStream (var Stream: PStream; CompressionLevel: TCompressionLevel; Destination: PStream; OnProgress: TZLibEvent): Boolean;

{define BUFFERPROCS}

{$IFDEF BUFFERPROCS}
{ CompressBuf compresses data, buffer to buffer, in one call.
   In: InBuf = ptr to compressed data
       InBytes = number of bytes in InBuf
  Out: OutBuf = ptr to newly allocated buffer containing decompressed data
       OutBytes = number of bytes in OutBuf   }

function CompressBuf(const InBuf: Pointer; InBytes: Integer; out OutBuf: Pointer; out OutBytes: Integer): Boolean;

{ DecompressBuf decompresses data, buffer to buffer, in one call.
   In: InBuf = ptr to compressed data
       InBytes = number of bytes in InBuf
       OutEstimate = zero, or est. size of the decompressed data
  Out: OutBuf = ptr to newly allocated buffer containing decompressed data
       OutBytes = number of bytes in OutBuf   }

function DecompressBuf(const InBuf: Pointer; InBytes: Integer; OutEstimate: Integer; out OutBuf: Pointer; out OutBytes: Integer): Boolean;
{$ENDIF BUFFERPROCS}

{$IFNDEF FPC}
const
  ZLib_Version = '1.1.3';

function adler32(adler: Integer; buf: PChar; len: Integer): Integer;

// deflate compresses data
function deflateInit_(var strm: TZStreamRec; level: Integer; version: PChar;
  recsize: Integer): Integer; external;
function deflate(var strm: TZStreamRec; flush: Integer): Integer; external;
function deflateEnd(var strm: TZStreamRec): Integer; external;

// inflate decompresses data
function inflateInit_(var strm: TZStreamRec; Version: PChar; recsize: Integer): Integer; external;
function inflate(var strm: TZStreamRec; flush: Integer): Integer; external;
function inflateEnd(var strm: TZStreamRec): Integer; external;
function inflateReset(var strm: TZStreamRec): Integer; external;

const
  Z_NO_FLUSH      = 0;
  Z_PARTIAL_FLUSH = 1;
  Z_SYNC_FLUSH    = 2;
  Z_FULL_FLUSH    = 3;
  Z_FINISH        = 4;

  Z_OK            = 0;
  Z_STREAM_END    = 1;
  Z_NEED_DICT     = 2;
  Z_ERRNO         = (-1);
  Z_STREAM_ERROR  = (-2);
  Z_DATA_ERROR    = (-3);
  Z_MEM_ERROR     = (-4);
  Z_BUF_ERROR     = (-5);
  Z_VERSION_ERROR = (-6);

  Z_NO_COMPRESSION       =   0;
  Z_BEST_SPEED           =   1;
  Z_BEST_COMPRESSION     =   9;
  Z_DEFAULT_COMPRESSION  = (-1);

  Z_FILTERED            = 1;
  Z_HUFFMAN_ONLY        = 2;
  Z_DEFAULT_STRATEGY    = 0;

  Z_BINARY   = 0;
  Z_ASCII    = 1;
  Z_UNKNOWN  = 2;

  Z_DEFLATED = 8;
{$ELSE}
  const
{$ENDIF}
  
  _z_errmsg: array[0..9] of PChar = (
    'need dictionary',      // Z_NEED_DICT      (2)
    'stream end',           // Z_STREAM_END     (1)
    '',                     // Z_OK             (0)
    'file error',           // Z_ERRNO          (-1)
    'stream error',         // Z_STREAM_ERROR   (-2)
    'data error',           // Z_DATA_ERROR     (-3)
    'insufficient memory',  // Z_MEM_ERROR      (-4)
    'buffer error',         // Z_BUF_ERROR      (-5)
    'incompatible version', // Z_VERSION_ERROR  (-6)
    ''                               );

implementation

{$IFNDEF FPC}

  {$L ZLibObj\deflate.obj}
  {$L ZLibObj\trees.obj}
  {$L ZLibObj\inflate.obj}
  {$L ZLibObj\inftrees.obj}
  {$L ZLibObj\adler32.obj}
  {$L ZLibObj\infblock.obj}
  {$L ZLibObj\infcodes.obj}
  {$L ZLibObj\infutil.obj}
  {$L ZLibObj\inffast.obj}

  procedure _tr_init; external;
  procedure _tr_tally; external;
  procedure _tr_flush_block; external;
  procedure _tr_align; external;
  procedure _tr_stored_block; external;
  function  adler32; external;
  procedure inflate_blocks_new; external;
  procedure inflate_blocks; external;
  procedure inflate_blocks_reset; external;
  procedure inflate_blocks_free; external;
  procedure inflate_set_dictionary; external;
  procedure inflate_trees_bits; external;
  procedure inflate_trees_dynamic; external;
  procedure inflate_trees_fixed; external;
  procedure inflate_codes_new; external;
  procedure inflate_codes; external;
  procedure inflate_codes_free; external;
  procedure _inflate_mask; external;
  procedure inflate_flush; external;
  procedure inflate_fast; external;
{$ENDIF}

procedure _memset(P: Pointer; B: Byte; count: Integer);cdecl;
begin
  FillChar(P^, count, B);
end;

procedure _memcpy(dest, source: Pointer; count: Integer);cdecl;
begin
  Move(source^, dest^, count);
end;

function zcalloc(AppData: Pointer; Items, Size: Integer): Pointer;
begin
  GetMem(Result, Items*Size);
end;

procedure zcfree(AppData, Block: Pointer);
begin
  FreeMem(Block);
end;

function ZCheck(Code: Integer; var Clear: Boolean): Integer;
begin
  Result:=Code;
  Clear:=Code>=0;
end;

{$IFDEF BUFFERPROCS}
function CompressBuf(const InBuf: Pointer; InBytes: Integer;
  out OutBuf: Pointer; out OutBytes: Integer): Boolean;
var
  strm: TZStreamRec;
  P: Pointer;
begin
  Result:=True;
  FillChar(strm, SizeOf(strm), 0);
  OutBytes := ((InBytes + (InBytes div 10) + 12) + 255) and not 255;
  GetMem(OutBuf, OutBytes);
  try
    strm.next_in := InBuf;
    strm.avail_in := InBytes;
    strm.next_out := OutBuf;
    strm.avail_out := OutBytes;
    ZCheck(deflateInit_(strm, Z_BEST_COMPRESSION, zlib_version, sizeof(strm)), Result);
    If not Result then Exit;
    while (ZCheck(deflate(strm, Z_FINISH), Result)<>Z_STREAM_END) and Result do
    begin
      P := OutBuf;
      Inc(OutBytes, 256);
      ReallocMem(OutBuf, OutBytes);
      strm.next_out := {$IFDEF FPC}PByte{$ELSE}PChar{$ENDIF}(Integer(OutBuf) + (Integer(strm.next_out) - Integer(P)));
      strm.avail_out := 256;
    end;
    If Result then ZCheck(deflateEnd(strm), Result)
    else deflateEnd(strm);
    If not Result then Exit;
    ReallocMem(OutBuf, strm.total_out);
    OutBytes := strm.total_out;
  finally
    If not Result then begin
      FreeMem(OutBuf);
      OutBuf:=nil;
    end;
  end;
end;

function DecompressBuf(const InBuf: Pointer; InBytes: Integer;
  OutEstimate: Integer; out OutBuf: Pointer; out OutBytes: Integer): Boolean;
var
  strm: TZStreamRec;
  P: Pointer;
  BufInc: Integer;
begin
  Result:=True;
  FillChar(strm, sizeof(strm), 0);
  BufInc := (InBytes + 255) and not 255;
  if OutEstimate = 0 then
    OutBytes := BufInc
  else
    OutBytes := OutEstimate;
  GetMem(OutBuf, OutBytes);
  try
    strm.next_in := InBuf;
    strm.avail_in := InBytes;
    strm.next_out := OutBuf;
    strm.avail_out := OutBytes;
    ZCheck(InflateInit_(strm, zlib_version, sizeof(strm)), Result);
    If not Result then Exit;
    while (ZCheck(Inflate(strm, Z_FINISH), Result) <> Z_STREAM_END) and Result do
    begin
      P := OutBuf;
      Inc(OutBytes, BufInc);
      ReallocMem(OutBuf, OutBytes);
      strm.next_out := {$IFDEF FPC}PByte{$ELSE}PChar{$ENDIF}(Integer(OutBuf) + (Integer(strm.next_out) - Integer(P)));
      strm.avail_out := BufInc;
    end;
    If Result then ZCheck(inflateEnd(strm), Result)
    else InflateEnd(strm);
    If not Result Then Exit;
    ReallocMem(OutBuf, strm.total_out);
    OutBytes := strm.total_out;
  finally
    If not Result then begin
      FreeMem(OutBuf);
      OutBuf:=nil;
    end;
  end;
end;
{$ENDIF BUFFERPROCS}

// Dummy methods
procedure DummySetSize(Strm: PStream; Value: TStrmSize); 
begin
end;

function DummyReadWrite (Strm: PStream; var Buffer; Count: TStrmSize): TStrmSize;
begin
  Result:=ZLIB_ERROR;
end;

function DummyGetSize(Strm: PStream): TStrmSize;
begin
  Result:=ZLIB_ERROR;
end;

// CompressStream methods
function CZLibWriteStream(Strm: PStream; var Buffer; Count: TStrmSize): TStrmSize;
var
  Check: Boolean;
begin
  Result:=ZLIB_ERROR;
  With PZlibData (Strm.Methods.fCustom)^ do begin
    FZRec.next_in := @Buffer;
    FZRec.avail_in := Count;
    If FStrm.Position <> FStrmPos then FStrm.Position := FStrmPos;
    While (FZRec.avail_in > 0) do begin
      ZCheck(deflate(FZRec, 0), Check);
      If not Check then Exit;
      If FZRec.avail_out = 0 then begin
        If FStrm.Write (FBuffer, SizeOf(FBuffer))<>SizeOf(FBuffer) then Exit;
        FZRec.next_out := {$IFDEF FPC}@{$ENDIF}FBuffer;
        FZRec.avail_out := SizeOf(FBuffer);
        FStrmPos := FStrm.Position;
        If Assigned (fOnProgress) then
          fOnProgress (Strm);
      end;
    end;
  end;
  Result := Count;
end;

function CZLibSeekStream(Strm: PStream; Offset: TStrmMove; Origin: TMoveMethod): TStrmSize;
begin
  If (Offset = 0) and (Origin=spCurrent) then Result:=PZlibData (Strm.Methods.fCustom).FZRec.total_in
  else Result:=ZLIB_ERROR;
end;

procedure CZLibCloseStream(Strm: PStream);
var
  Check: Boolean;
begin
  With PZlibData (Strm.Methods.fCustom)^ do begin
    FZRec.next_in := nil;
    FZRec.avail_in := 0;
    try
      If FStrm.Position <> FStrmPos then FStrm.Position := FStrmPos;
      while (ZCheck(deflate(FZRec, Z_FINISH), Check) <> Z_STREAM_END) and (FZRec.avail_out = 0) do begin
        If not Check then Exit;
        If FStrm.Write (FBuffer, SizeOf(FBuffer))<>SizeOf(FBuffer) then Exit;
        FZRec.next_out := {$IFDEF FPC}@{$ENDIF}FBuffer;
        FZRec.avail_out := sizeof(FBuffer);
      end;
      If FZRec.avail_out < SizeOf(FBuffer) then
        FStrm.Write (FBuffer, SizeOf(FBuffer) - FZRec.avail_out)
    finally
      deflateEnd(FZRec);
      Dispose (PZLibData (Strm.Methods.fCustom));
    end;
  end;
end;

// DecompressStream methods
procedure DZLibCloseStream(Strm: PStream);
begin
  InflateEnd(PZLibData (Strm.Methods.fCustom).FZRec);
  Dispose (PZLibData (Strm.Methods.fCustom));
end;

{$IFDEF KOL3XX}
function DZLibSeekStream(Strm: PStream; Offset: TStrmMove; Origin: TMoveMethod): TStrmSize;
var
  I: Integer;
  Buf: array [0..4095] of Char;
  Check: Boolean;
  Offs:TStrmMove;
begin
  Offs := Offset;
  Result:=ZLIB_ERROR;
  With PZlibData (Strm.Methods.fCustom)^ do begin
    If (Offs=0) and (Origin=spBegin) then begin
      ZCheck(InflateReset(FZRec), Check);
      If not Check then Exit;
      FZRec.next_in := {$IFDEF FPC}@{$ENDIF}FBuffer;
      FZRec.avail_in := 0;
      FStrm.Position := 0;
      FStrmPos := 0;
    end
    else If ((Offs>=0) and (Origin=spCurrent)) or (((Offs-FZRec.total_out)>0) and (Origin=spBegin)) then  begin
      If Origin=spBegin then Dec(Offs, FZRec.total_out);
      If Offs>0 then begin
        for I:=1 to Offs div SizeOf(Buf) do
          If Strm.Read(Buf, SizeOf(Buf))=ZLIB_ERROR then Exit;
        If Strm.Read(Buf, Offs mod SizeOf(Buf))=ZLIB_ERROR then Exit;
      end;
    end else Exit;
    Result:=FZRec.total_out;
  end;
end;

{$ELSE}
function DZLibSeekStream(Strm: PStream; Offset: Integer; Origin: TMoveMethod): DWord;
var
  I: Integer;
  Buf: array [0..4095] of Char;
  Check: Boolean;
begin
  Result:=ZLIB_ERROR;
  With PZlibData (Strm.Methods.fCustom)^ do begin
    If (Offset=0) and (Origin=spBegin) then begin
      ZCheck(InflateReset(FZRec), Check);
      If not Check then Exit;
      FZRec.next_in := FBuffer;
      FZRec.avail_in := 0;
      FStrm.Position := 0;
      FStrmPos := 0;
    end
    else If ((Offset>=0) and (Origin=spCurrent)) or (((Offset-FZRec.total_out)>0) and (Origin=spBegin)) then  begin
      If Origin=spBegin then Dec(Offset, FZRec.total_out);
      If Offset>0 then begin
        for I:=1 to Offset div SizeOf(Buf) do
          If Strm.Read(Buf, SizeOf(Buf))=ZLIB_ERROR then Exit;
        If Strm.Read(Buf, Offset mod SizeOf(Buf))=ZLIB_ERROR then Exit;
      end;
    end else Exit;
    Result:=FZRec.total_out;
  end;
end;
{$ENDIF}

function DZLibReadStream (Strm: PStream; var Buffer; Count: TStrmSize): TStrmSize;
var
  Check: Boolean;
begin
  Result:=ZLIB_ERROR;
  With PZlibData (Strm.Methods.fCustom)^ do begin
    FZRec.next_out := @Buffer;
    FZRec.avail_out := Count;
    If FStrm.Position <> FStrmPos then
      FStrm.Position := FStrmPos;
    While (FZRec.avail_out > 0) do begin
      If FZRec.avail_in = 0 then begin
        FZRec.avail_in := FStrm.Read(FBuffer, SizeOf(FBuffer));
        If FZRec.avail_in = 0 then begin
          Result := Count - DWord(FZRec.avail_out);
          Exit;
        end;
      FZRec.next_in := {$IFDEF FPC}@{$ENDIF}FBuffer;
      FStrmPos := FStrm.Position;
      If Assigned (fOnProgress) then
        fOnProgress (Strm);
      end;
      ZCheck(Inflate(FZRec, 0), Check);
      If not Check then Exit;
    end;
  end;
  Result:=Count;
end;

const
  BaseCZlibMethods: TStreamMethods = (
    fSeek:   CZLibSeekStream;
    fGetSiz: DummyGetSize;
    fSetSiz: DummySetSize;
    fRead:   DummyReadWrite;
    fWrite:  CZLibWriteStream;
    fClose:  CZLibCloseStream;
    fCustom: nil;
    fWait: nil;
  );

  BaseDZlibMethods: TStreamMethods = (
    fSeek:   DZLibSeekStream;
    fGetSiz: DummyGetSize;
    fSetSiz: DummySetSize;
    fRead:   DZLibReadStream;
    fWrite:  DummyReadWrite;
    fClose:  DZLibCloseStream;
    fCustom: nil;
    fWait: nil;
  );

function NewDecompressionStream (Source: PStream; OnProgress: TZLibEvent): PStream;
var
  Inited: Boolean;
  ZLibData: PZLibData;
begin
  New (ZLibData);
  With ZLibData^ do begin
    FillChar(FZRec, SizeOf(FZRec), 0);
    FOnProgress:=OnProgress;
    FStrm:=Source;
    FStrmPos:=Source.Position;
    FZRec.next_in := {$IFDEF FPC}@{$ENDIF}FBuffer;
    FZRec.avail_in := 0;
    ZCheck(InflateInit_(FZRec, ZLib_Version, SizeOf(FZRec)), Inited);
  end;
  If Inited then begin
    Result:=_NewStream (BaseDZlibMethods);
    Result.Methods.fCustom:=ZLibData;
  end else begin
    Dispose (ZLibData);
    Result:=nil;
  end;
end;

function NewCompressionStream (CompressionLevel: TCompressionLevel; Destination: PStream; OnProgress: TZLibEvent): PStream;
const
  Levels: array [TCompressionLevel] of ShortInt = (Z_NO_COMPRESSION, Z_BEST_SPEED, Z_DEFAULT_COMPRESSION, Z_BEST_COMPRESSION);
var
  Inited: Boolean;
  ZLibData: PZLibData;
begin
  New (ZLibData);
  With ZLibData^ do begin
    FillChar(FZRec, SizeOf(FZRec), 0);
    FOnProgress:=OnProgress;
    FStrm:=Destination;
    FStrmPos:=Destination.Position;
    FZRec.next_out := {$IFDEF FPC}@{$ENDIF}FBuffer;
    FZRec.avail_out := SizeOf(FBuffer);
    ZCheck(deflateInit_(FZRec, Levels[CompressionLevel], ZLib_Version, SizeOf(FZRec)), Inited);
  end;
  If Inited then begin
    Result:=_NewStream (BaseCZlibMethods);
    Result.Methods.fCustom:=ZLibData;
  end else begin
    Dispose (ZLibData);
    Result:=nil;
  end;
end;

function NewZLibDStream (var Stream: PStream; Source: PStream; OnProgress: TZLibEvent): boolean;
begin
  Stream:=NewDecompressionStream (Source, OnProgress);
  Result:=Assigned (Stream);
end;

function NewZLibCStream (var Stream: PStream; CompressionLevel: TCompressionLevel; Destination: PStream; OnProgress: TZLibEvent): boolean;
begin
  Stream:=NewCompressionStream (CompressionLevel, Destination, OnProgress);
  Result:=Assigned (Stream);
end;

end.
