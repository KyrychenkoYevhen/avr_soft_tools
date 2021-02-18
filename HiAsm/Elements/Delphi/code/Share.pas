unit Share;

// ************************************************
// ����� ������, �-��� � ������ ��� ��������� HiAsm
// Last modification: 01.3.2011
// ************************************************
{
   ����������:
    ##array
    ##types
    ##ReadXXX
    ##ToXXX
    ##_hi_onEvent
    ##_hi_CreateEvent
    ##_DoData
    ##CreateData
}

interface

uses Windows,Kol,WinSock;

{$include def.inc}
{$include share.inc}

{$ifdef F_P}
{$SMARTLINK ON}
{$endif}



type
  // � ������ Delphi � FPC ��� NativeInt.
  // � ����� ������� Delphi � FPC NativeInt �������� ��� ������� �����, ��� ������ ������.
  {$ifdef win64}
    NativeInt = Int64;
    NativeUInt = UInt64;
  {$else}
    NativeInt = Integer;
    NativeUInt = Cardinal;
  {$endif}
  PNativeInt = ^NativeInt;
  PNativeUInt = ^NativeUInt;

{$ifndef FPC_NEW}

const
  GWLP_WNDPROC             = -4; 
  GWLP_HINSTANCE           = -6; 
  GWLP_HWNDPARENT          = -8; 
  GWLP_USERDATA            = -21;
  GWLP_ID                  = -12;
  
  {$ifndef WIN64}
    function GetWindowLongPtr(hWnd: HWND; nIndex: LongInt): LongInt; stdcall; external 'user32.dll' name {$ifdef UNICODE}'GetWindowLongW'{$else}'GetWindowLongA'{$endif};
    function SetWindowLongPtr(hWnd: HWND; nIndex: LongInt; dwNewLong: LongInt): LongInt; stdcall; external 'user32.dll' name {$ifdef UNICODE}'SetWindowLongW'{$else}'SetWindowLongA'{$endif};
  {$endif}

{$endif}

{$ifndef KOL3XX}

type
  // � ����� KOL - ��� ������, ����������� �������� AnsiString ��� WideString
  KOLString = AnsiString;
  KOLChar = AnsiChar;
  PKOLChar = PAnsiChar;
  
  TStrmSize = DWORD;
  TStrmMove = Integer;
  
  // ������������� ������ ����� - ANSI/Unicode � ����������� �� �����������
  TKOLStrList = TStrList;
  PKOLStrList = PStrList;
  TKOLStrListEx = TStrListEx;
  PKOLStrListEx = PStrListEx;
  
  function NewKOLStrList: PKOLStrList;
  function NewKOLStrListEx: PKOLStrListEx;

{$endif}


// ============= ������� ��������� Unicode ============= //

type
  TBytes = array of Byte;
  
  // �������������� Char � ������ �����
  {$ifdef UNICODE}
  CharInt = Word;
  {$else}
  CharInt = Byte;
  {$endif}
  


{$ifndef FPC_NEW}
var
  DefaultSystemCodePage: Integer;
{$endif}


  // ����� ������ � ������
  function ByteLength(const S: AnsiString): Integer; {$ifndef VER120} inline; overload;{$endif}
  {$ifndef VER120}
  function ByteLength(const S: WideString): Integer; inline; overload;
  {$endif}

  // ���������� ����� �������� ������, ����������� � ������ � �����������
  // ���������� = 2 ��� 3
  function BinaryLength(const S: string): DWord;
  
  // ���������� ���� �� ���������� � ������
  function IsBinaryString(const S: string): Boolean;

  // ���������� ���������� ����������� ������ ������ � �������� � ������ ����������
  // ��� ������������ ������� raw-������ RawSize (� ������).
  // ������������ ��� �������� ������ �������� � ������, ����� ��������������
  // ����������� ������. 
  function BinaryStrSize(RawSize: DWord): DWord; {$ifndef VER120} inline;{$endif}

  // ��������� 2 ����� ���������� � ����� Buf.
  // ���������� �������� ������ ������ � ������ (� ��������)
  // ������ ������ ������ ���� �� ������ BinaryStrSize(RawSize)
  function PadBinaryBuf(Buf: Pointer; RawSize: DWord): DWord;

  // ������� ������������ ������ � ������.
  // ��� UNICODE - ����������� 1 ������ ���������� ��� ������������
  // ����������� ����������� ������, ��������� 2-� ������.
  // ���������� = #2 ��� #3.
  function BufToBinaryStr(Buf: Pointer; BufLen: DWord): string;
  
  
  
  function AnsiStringToWideString(const S: AnsiString; SourceCP: Integer): WideString;
  function WideStringToAnsiString(const S: WideString; TargetCP: Integer): AnsiString;
  function AnsiConvertCharset(const S: AnsiString; SourceCP: Integer; TargetCP: Integer): AnsiString;
  function StringToUTF8(const S: string): AnsiString;
  function UTF8ToString(const S: AnsiString): string;

// ============================================================== //


const
  data_null   = 0;
  data_int    = 1;
  data_str    = 2;
//data_data   = 3;
//data_combo  = 4;
//data_list   = 5;
  data_icon   = 6;
  data_real   = 7;
//data_color  = 8;
//data_script = 9;
  data_stream = 10;
  data_bitmap = 11;
//data_wave   = 12;
  data_array  = 13;
//data_comboEx= 14;
  data_font   = 15;
  data_matr   = 16;
  data_jpeg   = 17;
  data_menu   = 18;
//data_code   = 19;
  data_object = 20;
  data_break  = 21; //!!! ������� ���������������� �����
  data_types  = 22;

 data_gl_point3d = 100;
 data_rect = 101;

const
(*
  crDefault   = 0;
  crArrow     = 1;
  crIBeam     = 19;
  crHourGlass = 21;
  crCross     = 23;
  crUpArrow   = 25;
  crSizeNWSE  = 27;
  crSizeNESW  = 29;
  crSizeWE    = 31;
  crSizeNS    = 33;
  crSizeAll   = 35;
  crNo        = 37;
  crBusy      = 39;
  crHelp      = 41;
  crPen       = 43;
  crHandPoint = 45;
  crCube      = 47;
  crCD        = 49;
*)
  OCR_PEN     = 32631;
  OCR_HELP    = 32651;
  OCR_WAITCD =  32663;

  crDefault     = 0;
  crArrow       = OCR_NORMAL;
  crIBeam       = OCR_IBEAM;
  crWait        = OCR_WAIT;
  crCross       = OCR_CROSS;
  crUpArrow     = OCR_UP;
  crSizeNWSE    = OCR_SIZENWSE;
  crSizeNESW    = OCR_SIZENESW;
  crSizeWE      = OCR_SIZEWE;
  crSizeNS      = OCR_SIZENS;
  crSizeAll     = OCR_SIZEALL;
  crNo          = OCR_NO;
  crAppStarting = OCR_APPSTARTING;
  crHelp        = OCR_HELP;
  crPen         = OCR_PEN;
  crHand        = OCR_HAND;
//  crCube      = 47;
  crWaitCD      = OCR_WAITCD;

  crSize      = crSizeAll;
  crHourGlass = crWait;
  crCD        = crWaitCD;
  crHandPoint = crHand;
  crBusy      = crAppStarting;

//!!! ������������ � �������� Debug � ���������� _Debug
  DataNames:array[0..22]of string[7] =
   (
     'NULL',
     'Integer',
     'String',
     'Data',
     'Combo',
     'StrList',
     'Icon',
     'Real',
     'Color',
     'Script',
     'Stream',
     'Bitmap',
     'Wave',
     'Array',
     'ComboEx',
     'Font',
     'Matrix',
     'Jpeg',
     'Menu',
     'Code',
     'Object',
     'Type',
     'Break'
   );

type
  PRGN = ^HRGN;
  
  {$ifdef WIN64}
  THiInt = Int64;
  {$else}
  THiInt = Integer;
  {$endif}

  PHI_Event = ^THI_Event;

  //TGL_Point3D

  PData = ^TData;
  TData = record
    Data_type:byte;
    idata:THiInt;
    sdata:string;
    rdata:real;
    Next:PHI_Event;
    ldata:PData;
  end;
  PValue = ^TValue;
  TValue = record
    vtype:byte;
    vdata:pointer;
  end;
  TFontRec = record
     Name:string;
     Size:byte;
     Style:byte;
     Color:TColor;
     CharSet:byte;
  end;
  PFontRec = ^TFontRec;

  TRGB = record r,g,b,x:byte; end;
  PColor = ^TColor;

  TEvent = procedure(var Data:TData; Index:word) of object;
  THI_Event = record
    Event:TEvent;
    Index:word;
    {$ifdef _DEBUG_}
    dbgPoint:Cardinal;
    {$endif}
  end;
  TInitProc = procedure of object; //!!! ������ ����������� InitMan

  TMatrSet = procedure(x,y:integer; var Val:TData) of object;
  TMatrGet = function(x,y:integer):TData of object;
  TMatrSize = function:integer of object;
  TMatrSetSize = procedure(x,y:integer) of object;
  TMatrix = record
    _Set:TMatrSet;
    _Get:TMatrGet;
    _Rows:TMatrSize;
    _Cols:TMatrSize;
    _SetSize:TMatrSetSize;
  end;
  PMatrix = ^TMatrix;

  TArrSet = procedure(var Item:TData; var Val:TData) of object;
  TArrGet = function(Var Item:TData; var Val:TData):boolean of object;
  TArrCount = function:integer of object;
  TArrAdd = procedure(var Val:TData) of object;
  TXArray = record
    _Set:TArrSet;
    _Get:TArrGet;
    _Count:TArrCount;
    _Add:TArrAdd;
  end;
  PArray = ^TXArray;
  // ~~~~~~~~~~~~~~~ ARRAYS ~~~~~~~~~~~~~~~
  // ##array
  TArray = class
    private
     Arr:TXArray;
    protected
     function DataToPointer(var Data:TData):NativeInt; virtual;
     procedure PointerToData(Data:NativeInt; var Result:TData); virtual;
     procedure Delete(Value:NativeInt); virtual;
    protected
     procedure Save(P:pointer; Data:NativeInt); virtual; abstract;
     procedure Load(P:pointer; var Data:NativeInt); virtual; abstract;
     function Swap(d1,d2:NativeInt):boolean; virtual;
    public
     _prop_FileName:string;
     _prop_FileFormat:byte;
     _prop_UseName:boolean;

     _data_FileName:THI_Event;

     Items:PKOLStrListEx;

     constructor Create;
     destructor Destroy; override;
     procedure SetItems(Value:PKOLStrListEx);
     procedure _work_doSave(var _Data:TData; Index:word);
     procedure _work_doLoad(var _Data:TData; Index:word);
     procedure _work_doClear(var _Data:TData; Index:word);
     procedure _work_doSort(var _Data:TData; Index:word);
     procedure _var_Array(var _Data:TData; Index:word);
     procedure _var_Count(var _Data:TData; Index:word);

     function Count:integer;
     procedure Write(var Item:TData; var Val:TData);
     function Read(Var Item:TData; var Val:TData):boolean;
     procedure Add(var Val:TData);
  end;
  TTranslator = object
    private
      Sources:PKOLStrList;
      Dests:PKOLStrList;
    public
      procedure SetTranslate(s,d:PKOLStrList); 
      function tr(const text:string):string;
  end;
  // event handlers(C# delegates like)
  TEventProc = procedure(param:pointer) of object; 
  TEvents = class
    private
      FEvents:array of TEventProc; 
    public 
      procedure event(param:pointer);
      procedure Add(proc:TEventProc);
      procedure Remove(proc:TEventProc);
  end;

  function MakeArrayInteger(const Names: string; Values: array of Integer): PKOLStrListEx;
  function MakeArrayString(const Names: string; Values: array of PChar): PKOLStrListEx;
  function MakeArrayBitmap(const Names: string; Values: array of HBITMAP): PKOLStrListEx;
  function MakeArrayReal(const Names: string; Values: array of Real): PKOLStrListEx;
  function MakeArrayWave(const Names: string; Values: array of PChar): PKOLStrListEx;
  function MakeArrayIcon(const Names: string; Values: array of HICON): PKOLStrListEx;
  function MakeArrayStream(const Names: string; Values: array of PStream): PKOLStrListEx;

var Null:THI_Event=(Event:nil;index:0); //!!! ������ �������������
    _data_Empty:TData=(data_type:0;idata:0;sdata:'';rdata:0;next:nil;ldata:nil);
    GHandle:cardinal=0;
    NeedInit:boolean=false; //!!! ������� ������������� ������������ ������� InitDo
    ScreenDPI:integer=0;
    Translator:TTranslator;

function _DoEvent(Event:TEvent; Index:word{$ifdef _DEBUG_}; Point:Cardinal{$endif}):THI_Event;
function _hi_SizeFnt(Sz:integer):integer; // ���������������� ������ ��� ���������� ������

//~~~~~~~~~~~~~~~ TYPES ~~~~~~~~~~~~~~~~~

type
  TType = class
   protected 
    fTypeDt : PKOLStrListEx;
    fCount  : word;
    
    function  Data_Get(idx:word):PData; virtual;
    procedure Data_Set(idx:word; dt:PData); virtual;
    procedure SetName(idx:word; nn:string);
    function  GetName(idx:word):string;
   public
    name:string;
   
    constructor Create;
    destructor  Destroy; override;
    
    function  Add(nm:string; dt:PData):integer; virtual;
    function  Delete(i:word):boolean; virtual;
    procedure Clear; virtual;
    function  IndexOf(nm:string):integer;
    
    property  Data[idx:word]:PData read Data_Get write Data_Set;
    property  NameOf[idx:word]:string read GetName write SetName;
    property  Count:word read fCount;
  end;
  PType = ^TType;
  
  TStorageType = class(TType)
   protected
     fData : PList;
     
//     function  Data_Get(idx:word):PData; override;
     procedure Data_Set(idx:word; dt:PData); override;
     function  CreateCopy(dt:PData):PData;
     procedure FreeCopy(dt:PData);
   public
     constructor Create;
     destructor  Destroy; override;
     
     function  Add(nm:string; dt:PData):integer; override;
     function  Delete(i:word):boolean; override;
     procedure Clear; override;
  end;
  PStorageType = ^TStorageType;

const
  TYPE_ERR_INVALID_TYPE = 0;
  TYPE_ERR_DIFF_TYPE    = 1;
  TYPE_ERR_NONEXIST_VAR = 2;
  TYPE_ERR_ALREXIST_VAR = 3;
  TYPE_ERR_NOTLOADED    = 4;

procedure CallTypeError(elm:string; evt:THI_Event; err:byte);
function  NewType:PType;
function  NewStorageType:PType;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function ToStringEvent(const PointData:THI_Event):string;
function ToIntegerEvent(const PointData:THI_Event):THiInt;
function ToRealEvent(const PointData:THI_Event):real;
function ToStreamEvent(const PointData:THI_Event):PStream;
function ToBitmapEvent(const PointData:THI_Event):PBitmap;
function ToIconEvent(const PointData:THI_Event):PIcon;
function ToTypesEvent(const PointData:THI_Event):PType;
function ToObjectEvent(const PointData:THI_Event; const ID: Integer):Pointer;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// ##ReadXXX
function ReadString(var Data:TData; PointData:THI_Event; const Def:string=''):string;
function ReadInteger(var Data:TData; PointData:THI_Event; Def:THiInt=0):THiInt;
function ReadReal(var Data:TData; PointData:THI_Event; Def:real=0):real;
function ReadBool(var Data:TData):boolean;
function ReadMTData(var Data:TData; PointData:THI_Event; Def:PData=nil):TData;
function ReadData(var Data:TData; PointData:THI_Event; Def:PData=nil):TData;
function ReadStream(var Data:TData; PointData:THI_Event; Def:PStream=nil):PStream;
function ReadBitmap(var Data:TData; PointData:THI_Event; Def:PBitmap=nil):PBitmap;
function ReadIcon(var Data:TData; PointData:THI_Event; Def:PIcon=nil):PIcon;
function ReadMatrix(PointData:THI_Event):PMatrix;
function ReadArray(PointData:THI_Event):PArray;
function ReadType(var Data:TData; PointData:THI_Event; Def:PType=nil):PType;
function ReadObject(var Data:TData; PointData:THI_Event; const ID: Integer):Pointer;

function ReadControl(PointData:THI_Event; const CName:string):PControl;
//����������� ��� ��������������� ������
procedure _ReadData(var Data:TData; PointData:THI_Event);
//���������� ������ �� ������ ��� MT �����������
function ReadFromThread(var Data:TData):TData;

// ##ToXXX
function ToString(const Data:TData):string;
function ToInteger(const Data:TData):THiInt;
function ToReal(const Data:TData):real;
function ToStream(var Data:TData):PStream;
function ToBitmap(var Data:TData):PBitmap;
function ToIcon(var Data:TData):PIcon;
function ToObject(var Data:TData; const ID: Integer = 0):pointer;
function ToFont(var Data:TData):PFontRec;
function ToTypes(var Data:TData):PType;

// ##_hi_onEvent
procedure _hi_OnEvent_(const PointEvent:THI_Event;var Data:TData);//����������� Data
procedure _hi_OnEvent(const PointEvent:THI_Event;var Data:TData); overload;
procedure _hi_OnEvent(const PointEvent:THI_Event;Value:THiInt); overload;
procedure _hi_OnEvent(const PointEvent:THI_Event;Value:real); overload;
procedure _hi_OnEvent(const PointEvent:THI_Event;const Value:string); overload;
procedure _hi_OnEvent(const PointEvent:THI_Event;Value:PStream); overload;
procedure _hi_OnEvent(const PointEvent:THI_Event); overload;
procedure _hi_OnEvent(const PointEvent:THI_Event;Value:PBitmap); overload;
procedure _hi_OnEvent(const PointEvent:THI_Event;const Value:TFontRec); overload;
procedure _hi_OnEvent(const PointEvent:THI_Event;Value:PType); overload;
procedure _hi_OnEvent(const PointEvent:THI_Event; const ID:Integer; const Value:Pointer); overload;

// ##_hi_CreateEvent
procedure _hi_CreateEvent_(var _Data:TData; Event:PHI_Event); overload; //�� ���� ������ ����������
procedure _hi_CreateEvent(var _Data:TData; Event:PHI_Event); overload;
procedure _hi_CreateEvent(var _Data:TData; Event:PHI_Event; const Data:TData); overload;
procedure _hi_CreateEvent(var _Data:TData; Event:PHI_Event; Data:THiInt); overload;
procedure _hi_CreateEvent(var _Data:TData; Event:PHI_Event; Data:real); overload;
procedure _hi_CreateEvent(var _Data:TData; Event:PHI_Event; const Data:string); overload;
procedure _hi_CreateEvent(var _Data:TData; Event:PHI_Event; const Data:PStream); overload;
procedure _hi_CreateEvent(var _Data:TData; Event:PHI_Event; const Data:PBitmap); overload;
procedure _hi_CreateEvent(var _Data:TData; Event:PHI_Event; const Data:PType); overload;
procedure _hi_CreateEvent(var _Data:TData; Event:PHI_Event; const ID:Integer; const Data:Pointer); overload;

// ##_DoData
function _DoData(Value:THiInt):TData; overload;
function _DoData(Value:real):TData; overload;
function _DoData(const Value:string):TData; overload;
function _DoData(const Value:TData):TData; overload;
function _DoData(Value:PStream):TData; overload;
function _DoData(Value:PBitmap):TData; overload;
function _DoData(Value:PMatrix):TData; overload;
function _DoData(Value:PType):TData; overload;
function _DoData(ID:Integer; Value:Pointer):TData; overload;

// ##CreateData
procedure dtData(var Data:TData; const Value:TData);
procedure dtNull(var Data:TData);
procedure dtInteger(var Data:TData; Value:THiInt);
procedure dtReal(var Data:TData; Value:real);
procedure dtString(var Data:TData; const Value:string);
procedure dtArray(var Data:TData; Value:PArray);
procedure dtMatrix(var Data:TData; Value:PMatrix);
procedure dtBitmap(var Data:TData; Value:PBitmap);
procedure dtStream(var Data:TData; Value:PStream);
procedure dtObject(var Data:TData; id:integer; Value:pointer);
procedure dtRect(var Data:TData; Value:pointer);
procedure dtIcon(var Data:TData; Value:PIcon);
procedure dtType(var Data:TData; Value:PType);

function _IsStr(const Data:TData):boolean;
function _IsInteger(const Data:TData):boolean;
function _IsFont(const Data:TData):boolean;
function _IsStream(const Data:TData):boolean;
function _IsBitmap(const Data:TData):boolean;
function _IsIcon(const Data:TData):boolean;
function _IsObject(const Data:TData; id:integer):boolean;
function _IsNull(const Data:TData):boolean;
function _IsBreak(const Data:TData):boolean;
function _IsTypes(const Data:TData):boolean;
function _IsType(const Data:TData):integer;

procedure GenGUID(var g:integer);

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function PosEx(const SubStr, S: string; Offset: Cardinal = 1): Integer;

// ������� ���� ������ ��������� ������ SearchBuf � ������ Buffer
// ���������� �������� �� ������ Buffer ��� -1, ���� �� ������� 
function PosBuf(Buffer: Pointer; BufLen: Integer; SearchBuf: Pointer; SBufLen: Integer): Integer;


type
  Tbackrep = function(Pos: Integer): Boolean of object;
procedure Replace(var Str: string; const substr, dest: string; back: TbackRep = nil);

// ���������� null-terminated ������ ������������������ (������ a-z).
// ��������� >0 ��� Str1 > Str2, <0 ��� Str1 < Str2, =0 ��� Str1 = Str2
function StrIComp(const Str1, Str2: PChar): Integer;


function _hi_OnMessage(Message: TOnMessage; var Msg: TMsg; var Rslt: LRESULT): Boolean;

function UPD_Init:boolean;
procedure UPD_Clear;
function TCPGetHostByName(name: PAnsiChar): string;

function ReadHandle:HWND;
function ReadFileName(const FName:string):string;
function WinDirs(const FName:string):string;

function LoadResData(const Name: string; OutLen: PInteger = nil): Pointer;
function LoadResStr(const Name: string): string;
function LoadResStream(const Name: string): PStream;
function hiCreateFont(const Name:string; Size,Style:byte; Color:TColor; CharSet:byte):TFontRec;
procedure SetFont(Font:PGraphicTool; Value:byte);

function GetString(var _Data:TData):string; //!!! ��������� ������ � ��������� �� TData
function GetTypeString(typ:PType):string;//!!! ��� ��������� ������ � ��������� Type �� TData
procedure _Debug; overload;
procedure _Debug(const info:string); overload;
procedure _Debug(info:integer); overload;
procedure _Debug(var _Data:TData; ident:string='Data-Debug'); overload; //!!! ������� ��� MT
function GetTok(var s:string; const c:char):string;


procedure BmpTransparent(bmp:PBitmap);
function ToSysColor(Color:cardinal):TColor;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Parser IconsIndex ~~~~~~~~~~~~~~~~~~~~~~~~~~
type
  PIconsIdx =^TIconsIdx;
  TIconsIdx = array of integer;
procedure ParseIconsIdx(var s:string; IconsIdx:TIconsIdx; init:boolean=false);


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ MT technology ~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure AddMTData(p,q:PData; var forFree:PData);
procedure FreeData(Data:PData);
procedure CopyData(Dest,Src:PData);

type
  TMT = record
    start:^PData;
    next:^PData;
  end;
  PMT = ^TMT;

function mt_make(var data:TData):PMT;
procedure mt_string(mt:PMT; const value:string);
procedure mt_int(mt:PMT; value:integer);
procedure mt_real(mt:PMT; value:real);
procedure mt_data(mt:PMT; const value:TData);
procedure mt_free(mt:PMT);

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ARRAYS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function ToIntIndex(var Data:TData):integer;
function CreateArray(_Set:TArrSet; _Get:TArrGet; _Count:TArrCount; _Add:TArrAdd):PArray;

function CreateMatrix(_Set:TMatrSet; _Get:TMatrGet; _X,_Y:TMatrSize; _SetSize:TMatrSetSize=nil):PMatrix;

{$ifdef F_P}
function NewThreadForFPC:PTHread;
{$endif}

procedure EventOn;
procedure EventOff;

procedure InitAdd(proc:TInitProc);
procedure InitDo;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SPLITTER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
type
  TNewSpl=function(P:PControl;MPrev,MNext:Integer;C:TColor;S:Integer):PControl;
function LObjSp(P:PControl;MPrev,MNext:Integer;C:TColor;S:Integer):PControl;
function RObjSp(P:PControl;MPrev,MNext:Integer;C:TColor;S:Integer):PControl;
function FObjSp(P:PControl;MPrev,MNext:Integer;C:TColor;S:Integer):PControl;
const
  spLowered:TNewSpl=LObjSp;
  spRaised: TNewSpl=RObjSp;
  spFlat:   TNewSpl=FObjSp;
  spNone:   TNewSpl=nil;

{$ifdef F_P}
function StringToOleStr(const value:string):PWideChar;
function LStrFromPWCharLen(Source: PWideChar; Length: Integer): String;
{$endif}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Math Functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
const
  digE = 2.718281828459045;

procedure Power(var x: Real; const Exponent: Real);
function IntPower({$IFNDEF WIN64}const{$ENDIF} Base:Extended; const Exponent:Integer):Extended;
function Tan(const X: Extended): Extended;
function CoTan(const X: Extended): Extended;
function ArcTan2(const Y,X:Extended):Extended;
function LogN(const Base,X:Extended):Extended;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

implementation

uses Debug;

var WSA_Init:integer = 0;
    _guids_:integer=0;
    InitMan:array of TInitProc = nil; //!!! � ���� ������ ���

// �������� � �������
type
  TArr_nil = object
    procedure _Set(var Item:TData; var Val:TData);
    procedure _Add(var Val:TData);
  end;
var _arr:TArr_nil;


{$ifndef KOL3XX}
function NewKOLStrList: PKOLStrList;
begin
  Result := NewStrList;
end;

function NewKOLStrListEx: PKOLStrListEx;
begin
  Result := NewStrListEx;
end;
{$endif}


function ByteLength(const S: AnsiString): Integer; {$ifndef VER120} inline; overload;{$endif}
begin
  Result := Length(S);
end;

{$ifndef VER120}
function ByteLength(const S: WideString): Integer; inline; overload;
begin
  Result := Length(S)*SizeOf(WideChar);
end;
{$endif}

{$ifdef UNICODE}
function BinaryLength(const S: string): DWord;
var
  W: Word;
begin
  Result := Length(S); // � ��������
  if Result = 0 then Exit;  

  // ���� ��������� ������ ����� #2 ��� #3 - ������, ��� ����������
  // �������� ������ (�� ����������� � ����� ��������� �������).
  // ���������� ������ �������� ������ � ������ ��� ����������.
  W := Word(S[Result]);
  
  Result := Result * SizeOf(WideChar); // � ������
  
  if W in [2, 3] then Dec(Result, W); // W = 2-3 ����� ����������
end;
{$else}
function BinaryLength(const S: string): DWord; {$ifndef VER120} inline;{$endif}
begin
  Result := Length(S);
end;
{$endif}


{$ifdef UNICODE}
function IsBinaryString(const S: string): Boolean;
var
  L: DWord;
begin
  L := Length(S);
  Result := (L > 0) and (S[L] in [#2, #3]);
end;
{$else}
function IsBinaryString(const S: string): Boolean; {$ifndef VER120} inline;{$endif}
begin
  Result := False;
end;
{$endif}


function BinaryStrSize(RawSize: DWord): DWord; {$ifndef VER120} inline;{$endif}
begin
{$ifdef UNICODE}
  // � ������ ����������� 1 ������ (WideChar, 2 �����) ��� ��������� �������� ����������
  // ���� ����� ��������� SizeOf(WideChar), �� ����������� ��� 1 ������,
  // � ������� ����� ���������� ��������� ����.
  if RawSize = 0 then
    Result := 0
  else
    Result := (RawSize div SizeOf(WideChar)) + (RawSize mod SizeOf(WideChar)) + 1;
{$else}
  Result := RawSize;
{$endif}
end;


{$ifdef UNICODE}
function PadBinaryBuf(Buf: Pointer; RawSize: DWord): DWord;
var
  W: Word;
  CharL: DWord;
begin
  Result := 0;
  if (Buf = nil) or (RawSize = 0) then Exit;
  
  CharL := RawSize div SizeOf(WideChar);
  
  // =1, ���� ������ ������ ��������� 2, ����� =0
  W := RawSize mod SizeOf(WideChar);
  
  Inc(CharL, W + 1); //  + 0||1 ������ ��� ��������� ���� � ��� ���� ������ ���������� 
  
  Inc(W, SizeOf(WideChar)); // 0||1 + 2 = ���������� ���� ����������  
  
  PWideChar(Buf)[CharL - 1] := WideChar(W);
  
  Result := CharL;
end;
{$else}
function PadBinaryBuf(Buf: Pointer; RawSize: DWord): DWord; {$ifndef VER120} inline;{$endif}
begin
  Result := RawSize;
end;
{$endif}


function BufToBinaryStr(Buf: Pointer; BufLen: DWord): string;
{$ifdef UNICODE}
var
  W: Word;
  CharL: DWord;
begin
  Result := '';
  if (Buf = nil) or (BufLen = 0) then Exit;
  
  CharL := BufLen div SizeOf(WideChar);
  
  // =1, ���� ������ ������ ��������� 2, ����� =0
  W := BufLen mod SizeOf(WideChar);
  
  {if W = 1 then
    Inc(CharL, 2) //  + ���� ������ ���������� � ��� ���� ������ ��� ��������� ����
  else
    Inc(CharL); //  + ���� ������ ����������}
  // ����������:
  Inc(CharL, W + 1);
  
  Inc(W, SizeOf(WideChar)); // 0||1 + 2 = ���������� ���� ����������  
  
  SetLength(Result, CharL);
  
  Move(Buf^, Result[1], BufLen);
  Result[CharL] := WideChar(W); // 2 ����� ����������
end;
{$else}
begin
  Result := '';
  if (Buf = nil) or (BufLen = 0) then Exit;
  
  SetLength(Result, BufLen);
  Move(Buf^, Result[1], BufLen);
  //{.$ifdef FPC_NEW}SetCodePage(RawByteString(Result), CP_NONE, False);{.$endif}
end;
{$endif}

function AnsiStringToWideString(const S: AnsiString; SourceCP: Integer): WideString;
var
  L, DestL, dwFlags: DWord;
begin  
  Result := '';
  if S = '' then Exit;
  
  if (SourceCP = CP_ACP) or (SourceCP = DefaultSystemCodePage) then
    Result := S // ���������� ������������� �������������
  else
  begin
    // ���� ��� ��������� ���������, ����� CP_UTF8, ��� ������� dwFlags ������ ���� 0
    if SourceCP = CP_UTF8 then
      dwFlags := 0
    else
      dwFlags := MB_PRECOMPOSED;
    L := Length(S);
    // ��������������� ����������� ������ ����� ���������� (���������)
    //DestL := MultiByteToWideChar(SourceCP, dwFlags, Pointer(S), L, nil, 0);
    //if DestL = 0 then Exit;
    // ������ �������� � ������� �� �������, ��� �������� ������ ������� �� 1-�������� ��������
    // ����� ���������� �������������� WideChar ����� ����� ���������� ��������
    DestL := L;
    
    SetLength(Result, DestL);
    DestL := MultiByteToWideChar(SourceCP, dwFlags, Pointer(S), L, Pointer(Result), DestL);
    if DestL <> L then SetLength(Result, DestL); // � DestL - ����������� ���������� ��������
  end;
end;

function WideStringToAnsiString(const S: WideString; TargetCP: Integer): AnsiString;
var
  L, DestL: DWord;
begin  
  Result := '';
  if S = '' then Exit;
  
  if (TargetCP = CP_ACP) or (TargetCP = DefaultSystemCodePage) then
    Result := S // ���������� ������������� �������������
  else
  begin
    L := Length(S);
    DestL := WideCharToMultiByte(TargetCP, 0, Pointer(S), L, nil, 0, nil, nil);
    if DestL > 0 then
    begin
      SetLength(Result, DestL);
      if WideCharToMultiByte(TargetCP, 0, Pointer(S), L, Pointer(Result), DestL, nil, nil) = 0 then
        Result := ''; // Error
    end;
    {$ifdef FPC_NEW}SetCodePage(RawByteString(Result), TargetCP, False);{$endif}
  end;
end;

function AnsiConvertCharset(const S: AnsiString; SourceCP: Integer; TargetCP: Integer): AnsiString;
begin
  if SourceCP = TargetCP then
    Result := S
  else
    Result := WideStringToAnsiString(AnsiStringToWideString(S, SourceCP), TargetCP);
end;

function StringToUTF8(const S: string): AnsiString;
begin
  {$ifdef UNICODE}
    Result := WideStringToAnsiString(S, CP_UTF8);
  {$else}
    Result := AnsiConvertCharset(S, CP_ACP, CP_UTF8);
  {$endif}
end;

function UTF8ToString(const S: AnsiString): string;
begin
  {$ifdef UNICODE}
    Result := AnsiStringToWideString(S, CP_UTF8);
  {$else}
    Result := AnsiConvertCharset(S, CP_UTF8, CP_ACP);
  {$endif}
end;




//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ FONT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function _hi_SizeFnt;
var dc:THandle;
begin
  if ScreenDPI=0 then begin
    dc := GetDC(0);
    ScreenDPI := GetDeviceCaps(dc,LOGPIXELSY);
    ReleaseDC(0,dc);
  end;
  Result := (Sz*ScreenDPI+36)div -72;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SPLITTER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function LObjSp;
begin
  Result := NewSplitterEx(P,MPrev,MNext,esLowered).SetSize(S,S);
  Result.Color := C;
end;
function RObjSp;
begin
  Result := NewSplitterEx(P,MPrev,MNext,esRaised).SetSize(S,S);
  Result.Color := C;
end;
function FObjSp;
begin
  Result := NewSplitterEx(P,MPrev,MNext,esNone).SetSize(S,S);
  Result.Color := C;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ InitMan ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//!!! � ���� ������ ���
procedure InitAdd;
begin
  SetLength(InitMan,length(InitMan)+1);
  InitMan[high(InitMan)] := Proc;
end;

procedure InitDo;
var i:integer;
begin
  i := 0;
  while i<length(InitMan) do
   begin
    InitMan[i];
    inc(i);
   end;
  SetLength(InitMan,0);
  NeedInit := True;
end;
//!!! � ���...
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function GetTok(var s:string; const c:char):string;
var p:integer;
begin
   p := Pos(c,s);
   if p > 0 then
     begin
       Result := Copy(s,1,p-1);
       if p = Length(s) then
         s := ''
       else Delete(s,1,p);
     end
   else Result := s;
end;

procedure BmpTransparent;
var
  i,j:word;
  c:TColor;
begin
  if Bmp.Empty then exit;

  c := Bmp.Pixels[0,0];
   for i := 0 to Bmp.Width-1 do
    for j := 0 to Bmp.Height-1 do
      if Bmp.Pixels[i,j] = c then
       Bmp.Pixels[i,j] := clBtnFace; //GetSysColor(COLOR_BTNFACE);
end;

function ToSysColor(Color:cardinal):TColor;
begin
   if Color > $00FFFFFF then
     Result := GetSysColor(Color and $000000FF)
   else Result := Color;
end;

procedure _Debug;
var P:pChar;
begin
   FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER+FORMAT_MESSAGE_FROM_SYSTEM,nil,GetLastError,LANG_NEUTRAL,@P,0,nil);
   MessageBox(ReadHandle,P,'GetLastError',MB_OK);
   LocalFree(dword(P));
end;

procedure _Debug(const info:string);
begin
   MessageBox(ReadHandle,PChar(info),'String-Debug',MB_OK);
end;

procedure _Debug(info:integer);
begin
   MessageBox(ReadHandle,PChar(int2str(info)),'Integer-Debug',MB_OK);
end;

procedure _Debug(var _Data:TData; ident:string='Data-Debug'); //!!! ��� �������
  function GetStr(var _Data:TData):string;
  begin
    Result := GetString(_Data);
    if _Data.data_type<=high(DataNames) then
     begin
      if Result<>'' then Result := ':'#9+Result;
      Result := DataNames[_Data.data_type] + Result;
     end
    else Result := 'Unknown: '+int2str(_Data.data_type);
  end;
begin
  {$ifdef MT_ENABLED}
  if (_Data.data_type=data_null)or(_Data.ldata=nil) then
    MessageBox(ReadHandle,PChar(GetStr(_Data)),PChar(ident),MB_OK)
  else if MessageBox(ReadHandle,PChar(GetStr(_Data)),PChar(ident),MB_YESNO)=IDYES then
    _Debug(_Data.ldata^,ident);
  {$else}
    MessageBox(ReadHandle,PChar(GetStr(_Data)),PChar(ident),MB_OK)
  {$endif}
end;

function GetString(var _Data:TData):string;
begin
  Result := '';
  case _isType(_Data) of
    data_break : Result := 'BREAK';
    data_null  : Result := 'NULL';
    data_int   : Result := int2str(NativeInt(_Data.idata));
    data_str   : Result := '"' + _Data.sdata + '"';
    data_object: Result := 'ID: ' + Double2str(_Data.rdata);
    data_real  : begin
      Result := double2str(_Data.rdata);
      if Pos('.',Result) = 0 then Result := Result + '.0';
    end;
    data_array:
      Result := 'arrCount: ' + int2str(PArray(_data.idata)._Count);
    data_matr:
      Result := 'mtxSize: ' + int2str(PMatrix(_data.idata)._Cols)
                  +'x' + int2str(PMatrix(_data.idata)._Rows);
    data_stream:
      if pointer(_data.idata) = nil then Result := 'noStream'
      else Result := 'stSize=' + int2str(PStream(_data.idata).Size)
         +', stPosition=' + int2str(PStream(_data.idata).Position);
    data_bitmap:
      if pointer(_data.idata) = nil then Result := 'noBitmap'
      else Result := 'bmpSize: ' + int2str(PBitmap(_data.idata).Width)
                             +'x' + int2str(PBitmap(_data.idata).Height);
    data_types:
      if pointer(_data.idata) = nil then Result := 'noType'
      else Result := GetTypeString(PType(_Data.idata));
  end;
end;

function GetTypeString(typ:PType):string;
(*var i:integer;
    str:string;
    td:PData;*)
begin
  Result := '';
  if typ.name <> #0 then Result := 'Name: "' + typ.name + '", Count: ' + int2str(typ.count);
(*  for i := 0 to typ.count - 1 do begin
    str := '';
    td := typ.data[i];
    if td.ldata = nil then str := GetString(td^)
    else while td <> nil do begin
      if td.data_type > high(DataNames) then
        str := str + '[ Unknown: ' + int2str(td.data_type) + ']'
      else str := str + '[' + GetString(td^) + ']';
      td := td.ldata;
    end;
    Result := Result + '{' + typ.NameOf[i] + ': ' + str + '}';
  end;*)  // ��� ��� �������� ����� ������ � ���� ��������� ��� ������� ���-�� ���������� � ����
end;

function _DoEvent;
begin
   Result.Event := Event;
   Result.Index := Index;
   {$ifdef _DEBUG_}
   Result.dbgPoint := Point;
   {$endif}
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

procedure TTranslator.SetTranslate(s,d:PKOLStrList);
begin
  Sources := s;
  Dests := d;
end;

function TTranslator.tr(const text:string):string;
var i:integer;
begin
   if Sources = nil then
     Result := text
   else
    begin
       i := Sources.indexof(text);
       if i = -1 then
          Result := text
       else Result := Dests.Items[i];
    end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

procedure TEvents.event(param:pointer);
var i:integer;
begin   
   for i := 0 to High(FEvents) do
     FEvents[i](param);
end;

procedure TEvents.Add(proc:TEventProc);
var i:integer;
begin
  i := high(FEvents);
  SetLength(FEvents, i+2);
  FEvents[i+1] := proc;
end;

procedure TEvents.Remove(proc:TEventProc);
var i,c:integer;
begin
   c := High(FEvents);
   for i := 0 to c do
     if @proc = @FEvents[i] then
       begin
         FEvents[i] := FEvents[c];
         SetLength(FEvents, c);
       end;
end;

//------------------------------------------------------------------------------

procedure __hi_OnEvent_(const PointEvent:THI_Event;var Data:TData);
begin
end;

var OnEvent:procedure(const PointEvent:THI_Event;var Data:TData) = __hi_OnEvent_;
    OnData: procedure(const PointEvent:THI_Event;var Data:TData) = __hi_OnEvent_;

function ToStringEvent;
var dt:TData;
begin
  dt.Data_type := data_null;
  OnData(PointData,dt);
  Result := ToString(dt);
end;

function ToIntegerEvent;
var dt:TData;
begin
  dt.Data_type := data_null;
  OnData(PointData,dt);
  Result := ToInteger(dt);
end;

function ToRealEvent;
var dt:TData;
begin
  dt.Data_type := data_null;
  OnData(PointData,dt);
  Result := ToReal(dt);
end;

function ToStreamEvent;
var dt:TData;
begin
  dt.Data_type := data_null;
  OnData(PointData,dt);
  Result := ToStream(dt);
end;

function ToBitmapEvent;
var dt:TData;
begin
  dt.Data_type := data_null;
  OnData(PointData,dt);
  Result := ToBitmap(dt);
end;

function ToIconEvent;
var dt:TData;
begin
  dt.Data_type := data_null;
  OnData(PointData,dt);
  Result := ToIcon(dt);
end;

function ToTypesEvent;
var dt:TData;
begin
  dt.Data_type := data_null;
  onData(PointData,dt);
  Result := ToTypes(dt);
end;

function ToObjectEvent;
var dt:TData;
begin
  dt.Data_type := data_null;
  onData(PointData,dt);
  Result := ToObject(dt, ID);
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function ReadString(var Data:TData; PointData:THI_Event; const Def:string):string;
var dt:TData;
begin
   if Assigned(PointData.Event) then
     begin
       dt.Data_type := data_null;
       OnData(PointData,dt);
       if dt.data_type <> data_break then //!!! data_break-feature
        begin
         Result := ToString(dt);
         exit;
        end;
     end;
   if(Def = '')and(Data.data_type <> data_null) then
    begin
      Result := ToString(Data);
      {$ifdef MT_ENABLED}if Data.ldata <> nil then
        Data := Data.ldata^
      else{$endif}
      Data.Data_type := data_null;
    end
   else Result := Def;
end;

function ToString;
begin
   case Data.data_type of
    data_str : Result := Data.sdata;
    data_int : Result := Int2Str(NativeInt(Data.idata));
    data_real: Result := Double2Str(Data.rdata);
    else Result := '';
   end;
end;

function ReadInteger;
var dt:TData;
begin
   if Assigned(PointData.Event) then
     begin
       dt.Data_type := data_null;
       OnData(PointData,dt);
       if dt.data_type <> data_break then //!!! data_break-feature
        begin
         Result := ToInteger(dt);
         exit;
        end;
     end;
   if(Def = 0)and( Data.data_type <> data_null )then
    begin
      Result := ToInteger(Data);
      {$ifdef MT_ENABLED}if Data.ldata <> nil then
        Data := Data.ldata^
      else{$endif}
      Data.Data_type := data_null;
    end
   else Result := Def;
end;

function ToInteger;
begin
   case Data.data_type of
     data_str : Result := Str2Int(Data.sdata);
     data_int : Result := THiInt(Data.idata);
     data_real: Result := Round(Data.rdata);
     else Result := 0;
   end;
end;

function ReadReal(var Data:TData; PointData:THI_Event; Def:real):real;
var dt:TData;
begin
   if Assigned(PointData.Event) then
     begin
       dt.Data_type := data_null;
       OnData(PointData,dt);
       if dt.data_type <> data_break then //!!! data_break-feature
        begin
         Result := ToReal(dt);
         exit;
        end;
     end;
   if (Def = 0)and( Data.data_type <> data_null ) then
    begin
     Result := ToReal(Data);
      {$ifdef MT_ENABLED}if Data.ldata <> nil then
        Data := Data.ldata^
      else{$endif}
     Data.Data_type := data_null;
    end
   else Result := Def;
end;

function ToReal;
begin
   case Data.data_type of
    data_real: Result := Data.rdata;
    data_int : Result := THiInt(Data.idata);
    data_str : Result := Str2Double(Data.sdata);
    else Result := 0;
   end;
end;

function ToStream;
begin
   case Data.data_type of
    data_stream: Result := PStream(Data.idata);
    else Result := nil;
   end;
end;

function ToBitmap;
begin
   case Data.data_type of
    data_bitmap: Result := PBitmap(Data.idata);
    else Result := nil;
   end;
end;

function ToIcon;
begin
   case Data.data_type of
    data_icon: Result := PIcon(Data.idata);
    else Result := nil;
   end;
end;

function ToObject;
begin
  if (Data.data_type = data_object) and (ID = 0) then // ��� �������������. TODO: ������ ����� ������ ������������ �����������
  begin  //
    Result := Pointer(Data.idata); //
    Exit; //
  end; //
  
  if (Data.data_type = data_object) and (Data.rdata > 0) and (Data.rdata = ID)
  then
    Result := Pointer(Data.idata)
  else
    Result := nil;
end;

function ToFont;
begin
   case Data.data_type of
    data_font: Result := pfontrec(Data.idata);
    else Result := nil;
   end;
end;

function ToTypes(var Data:TData):PType;
begin
   case Data.data_type of
    data_types: Result := PType(Data.idata);
    else Result := nil
   end;
end;

function ReadControl;
var dt:TData;
begin
  dt.Data_type := data_null;
  _ReadData(dt,PointData);
  if( Dt.Data_type = data_int)and(Dt.sdata = CName)then
   Result := PControl(dt.idata)
  else Result := nil;
end;

function ReadBool(var Data:TData):boolean;
begin
  Result := (Data.Data_type<>data_int)or(Data.idata<>0);
end;

function ReadMTData(var Data:TData; PointData:THI_Event; Def:PData):TData;
begin {$ifdef MT_ENABLED}
  if Assigned(PointData.Event) then begin
    dtNull(Result);
    OnData(PointData,Result);
    if Result.data_type <> data_break then exit;  //!!! data_break-feature
  end;
  if(Def = nil)or(Def.data_type = data_null) then begin
    Result := Data;
    dtNull(Data);
  end else Result := Def^;
{$endif}end;

function ReadData(var Data:TData; PointData:THI_Event; Def:PData):TData;
begin
  if Assigned(PointData.Event) then begin
    dtNull(Result);
    OnData(PointData,Result);
    Result.ldata := nil; //!!!!!!!!!!!!!
    if Result.data_type <> data_break then exit;  //!!! data_break-feature
  end;
  if(Def = nil)or(Def.data_type = data_null) then begin
    Result := Data;
    {$ifdef MT_ENABLED}Result.ldata := nil;
    if Data.data_type = data_null then Data.ldata := nil;
    if Data.ldata <> nil then Data := Data.ldata^
    else {$endif}Data.data_type := data_null;
  end else Result := Def^;
end;

procedure _ReadData;
begin
   if Assigned(PointData.Event) then
     OnData(PointData,Data)
   else Data.data_type := data_break;  //!!! data_break-feature
end;

function ReadFromThread(var Data:TData):TData;
var e:THI_Event;
begin
   e.Event := nil;
   Result := ReadData(Data,e,nil);
end;

function ReadStream;
var dt:TData;
begin
   if Assigned(PointData.Event) then
     begin
       dtNull(dt);
       OnData(PointData,dt);
       if dt.data_type <> data_break then  //!!! data_break-feature
        begin
         if dt.data_type = data_stream then
           Result := PStream(dt.idata)
         else Result := nil;
         exit;
        end;
     end;
   if (Def = nil)and(Data.data_type = data_stream) then
     begin
      Result := PStream(Data.idata);
      {$ifdef MT_ENABLED}if Data.ldata <> nil then
        Data := Data.ldata^
      else{$endif}
        data.Data_type := data_null;
     end
   else Result := Def;
end;

function ReadBitmap;
var dt:TData;
begin
   if Assigned(PointData.Event) then
     begin
      dt.Data_type := data_null;
      OnData(PointData,dt);
      if dt.data_type <> data_break then  //!!! data_break-feature
       begin
        if dt.data_type = data_bitmap then
          Result := PBitmap(dt.idata)
        else Result := nil;
        exit;
       end;
     end;
   if (Def = nil)and(Data.Data_type = data_bitmap) then
     begin
       Result := PBitmap(data.idata);
      {$ifdef MT_ENABLED}if Data.ldata <> nil then
        Data := Data.ldata^
      else{$endif}
       data.Data_type := data_null;
     end
   else Result := Def;
end;

function ReadIcon;
var dt:TData;
begin
   if Assigned(PointData.Event) then
     begin
       dt.Data_type := data_null;
       OnData(PointData,dt);
       if dt.data_type = data_icon then
         Result := PIcon(dt.idata)
       else Result := nil;
     end
   else if (Def = nil)and(Data.Data_type = data_icon) then
     begin
       Result := PIcon(data.idata);
      {$ifdef MT_ENABLED}
      if Data.ldata <> nil then
        Data := Data.ldata^
      else
      {$endif}
       data.Data_type := data_null;
     end
   else Result := Def;
end;

function ReadMatrix;
var dt:TData;
begin
   Result := nil;
   if Assigned(PointData.Event) then
    begin
      dt.data_type := data_null; //!!!
      OnData(PointData,dt);
      if dt.Data_type = data_matr then
        Result := PMatrix(Dt.idata);
    end;
end;

function ReadArray;
var dt:TData;
begin
   Result := nil;
   if Assigned(PointData.Event) then
    begin
      dt.data_type := data_null; //!!!
      OnData(PointData,dt);
      if dt.Data_type = data_array then
        Result := PArray(Dt.idata);
    end;
end;

function ReadType;
var dt:TData;
begin
   if Assigned(PointData.Event) then
     begin
       dt.Data_type := data_null;
       OnData(PointData,dt);
       if dt.data_type = data_types then
         Result := PType(dt.idata)
       else Result := nil;
     end
   else if (Def = nil)and(Data.Data_type = data_types) then
     begin
       Result := PType(data.idata);
      {$ifdef MT_ENABLED}
      if Data.ldata <> nil then
        Data := Data.ldata^
      else
      {$endif}
       data.Data_type := data_null;
     end
   else Result := Def;
end;

function ReadObject;
var dt:TData;
begin
  Result := nil;
  if Assigned(PointData.Event) then
  begin
    dt.data_type := data_null; //!!!
    OnData(PointData,dt);
    if (dt.data_type = data_object) and (dt.rdata > 0) and (dt.rdata = ID)
    then Result := Pointer(dt.idata);
  end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

procedure __hi_OnEvent(const PointEvent:THI_Event;var Data:TData);
var P:PHI_Event;
begin
  P := @PointEvent;
  while Assigned(P.Event) do begin
    {$ifdef _DEBUG_}CallEvent(2,P^,Data);{$endif}
    P.Event(Data,P.Index);
    if(Data.data_type and $80)=0 then break;
    dec(Data.data_type,$80);
    P := PHI_Event(Data.next);
  end;
end;

procedure __hi_OnData(const P:THI_Event;var Data:TData);
begin
  if Assigned(P.Event) then begin
    {$ifdef _DEBUG_}CallEvent(4,P,Data);{$endif}
    P.Event(Data,P.Index);
    {$ifdef _DEBUG_}CallEvent(3,P,Data);{$endif}
  end;
end;

procedure EventOn;
begin
  OnEvent := __hi_OnEvent;
  OnData  := __hi_OnData;
end;

procedure EventOff;
begin
  OnEvent := __hi_OnEvent_;
  OnData  := __hi_OnEvent_;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

procedure _hi_CreateEvent_(var _Data:TData; Event:PHI_Event); //�� ���� ������ ����������
begin
  inc(_Data.data_type,$80);
  _Data.Next := Event;
end;

procedure _hi_CreateEvent(var _Data:TData; Event:PHI_Event);
begin
  _Data.data_type := data_null + $80;
  _Data.Next := Event;
end;

procedure _hi_CreateEvent(var _Data:TData; Event:PHI_Event; const Data:TData);
begin
  _Data := Data;
  inc(_Data.data_type,$80);
  _Data.Next := Event;
end;

procedure _hi_CreateEvent(var _Data:TData; Event:PHI_Event; Data:THiInt);
begin
  _Data.Data_type := Data_int + $80;
  _Data.idata := Data;
   {$ifdef MT_ENABLED}_Data.ldata := nil;{$endif}
  _Data.Next := Event;
end;

procedure _hi_CreateEvent(var _Data:TData; Event:PHI_Event; Data:real);
begin
  _Data.Data_type := Data_real + $80;
  _Data.rdata := Data;
   {$ifdef MT_ENABLED}_Data.ldata := nil;{$endif}
  _Data.Next := Event;
end;

procedure _hi_CreateEvent(var _Data:TData; Event:PHI_Event; const Data:string);
begin
  _Data.Data_type := Data_str + $80;
  _Data.sdata := Data;
   {$ifdef MT_ENABLED}_Data.ldata := nil;{$endif}
  _Data.Next := Event;
end;

procedure _hi_CreateEvent(var _Data:TData; Event:PHI_Event; const Data:PStream);
begin
  _Data.Data_type := Data_stream + $80;
  _Data.idata := NativeInt(Data);
   {$ifdef MT_ENABLED}_Data.ldata := nil;{$endif}
  _Data.Next := Event;
end;

procedure _hi_CreateEvent(var _Data:TData; Event:PHI_Event; const Data:PBitmap);
begin
  _Data.Data_type := Data_bitmap + $80;
  _Data.idata := NativeInt(Data);
   {$ifdef MT_ENABLED}_Data.ldata := nil;{$endif}
  _Data.Next := Event;
end;

procedure _hi_CreateEvent(var _Data:TData; Event:PHI_Event; const Data:PType);
begin
  _Data.Data_type := Data_types + $80;
  _Data.idata := NativeInt(Data);
   {$ifdef MT_ENABLED}_Data.ldata := nil;{$endif}
  _Data.Next := Event;
end;

procedure _hi_CreateEvent(var _Data:TData; Event:PHI_Event; const ID:Integer; const Data:Pointer); overload;
begin
  _Data.Data_type := data_object + $80;
  _Data.idata := THiInt(Data);
  _Data.rdata := ID;
   {$ifdef MT_ENABLED}_Data.ldata := nil;{$endif}
  _Data.Next := Event;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

procedure _hi_OnEvent(const PointEvent:THI_Event;var Data:TData);
begin
   OnEvent(PointEvent,Data);
end;

procedure _hi_OnEvent_(const PointEvent:THI_Event;var Data:TData);
var dt:TData;//�����������
begin
   dt := Data;
   OnEvent(PointEvent,dt);
end;

procedure _hi_OnEvent(const PointEvent:THI_Event;Value:THiInt);
var Data:TData;
begin
   dtInteger(Data,Value);
   OnEvent(PointEvent,Data);
end;

procedure _hi_OnEvent(const PointEvent:THI_Event;Value:real);
var Data:TData;
begin
   dtReal(Data,Value);
   OnEvent(PointEvent,Data);
end;

procedure _hi_OnEvent(const PointEvent:THI_Event;const Value:string);
var Data:TData;
begin
   dtString(Data,Value);
   OnEvent(PointEvent,Data);
end;

procedure _hi_OnEvent(const PointEvent:THI_Event;Value:PStream);
var Data:TData;
begin
   dtStream(Data,Value);
   OnEvent(PointEvent,Data);
end;

procedure _hi_OnEvent(const PointEvent:THI_Event;Value:PBitmap);
var Data:TData;
begin
   dtBitmap(Data,Value);
   OnEvent(PointEvent,Data);
end;

procedure _hi_OnEvent(const PointEvent:THI_Event);
var Data:TData;
begin
   dtNull(Data);
   OnEvent(PointEvent,Data);
end;

procedure _hi_OnEvent(const PointEvent:THI_Event;const Value:TFontRec);
var Data:TData;
begin
   Data.Data_type := data_font;
   Data.idata := NativeInt(@Value);
   {$ifdef MT_ENABLED}Data.ldata := nil;{$endif}
   OnEvent(PointEvent,Data);
end;

procedure _hi_OnEvent(const PointEvent:THI_Event;Value:PType);
var Data:TData;
begin
   dtType(Data,Value);
   OnEvent(PointEvent,Data);
end;

procedure _hi_OnEvent(const PointEvent:THI_Event; const ID:Integer; const Value:Pointer); overload;
var Data:TData;
begin
  dtObject(Data, ID, Value);
  OnEvent(PointEvent, Data);
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

//##__DoData
function _DoData(Value:THiInt):TData;
begin
   dtInteger(Result,Value);
end;

function _DoData(Value:real):TData;
begin
   dtReal(Result,Value);
end;

function _DoData(const Value:string):TData;
begin
   dtString(Result,Value);
end;

function _DoData(const Value:TData):TData;  // �� ���� ????
begin
   dtData(Result,Value);
end;

function _DoData(Value:PStream):TData;
begin
   dtStream(Result,Value);
end;

function _DoData(Value:PBitmap):TData;
begin
   dtBitmap(Result,Value);
end;

function _DoData(Value:PMatrix):TData;
begin
   dtMatrix(Result,Value);
end;

function _DoData(Value:PType):TData;
begin
  dtType(Result,Value);
end;

function _DoData(ID:Integer; Value:Pointer):TData;
begin
  dtObject(Result,ID,Value);
end;

procedure dtData(var Data:TData; const Value:TData);
begin
   Data := Value;
   Data.Next := nil;
   {$ifdef MT_ENABLED}Data.ldata := nil;{$endif}
end;

procedure dtNull(var Data:TData);
begin
   Data.data_type := data_null;
   Data.Next := nil;
   {$ifdef MT_ENABLED}Data.ldata := nil;{$endif}
end;

procedure dtInteger(var Data:TData; Value:THiInt);
begin
   Data.data_type := data_int;
   Data.idata := Value;
   Data.Next := nil;
   {$ifdef MT_ENABLED}Data.ldata := nil;{$endif}
end;

procedure dtReal(var Data:TData; Value:real);
begin
   Data.data_type := data_real;
   Data.rdata := Value;
   Data.Next := nil;
   {$ifdef MT_ENABLED}Data.ldata := nil;{$endif}
end;

procedure dtString(var Data:TData; const Value:string);
begin
   Data.data_type := data_str;
   Data.sdata := Value;
   Data.Next := nil;
   {$ifdef MT_ENABLED}Data.ldata := nil;{$endif}
end;

procedure dtArray(var Data:TData; Value:PArray);
begin
   Data.data_type := data_array;
   Data.idata := NativeInt(Value);
   Data.Next := nil;
   {$ifdef MT_ENABLED}Data.ldata := nil;{$endif}
end;

procedure dtMatrix(var Data:TData; Value:PMatrix);
begin
   Data.data_type := data_matr;
   Data.idata := NativeInt(Value);
   Data.Next := nil;
   {$ifdef MT_ENABLED}Data.ldata := nil;{$endif}
end;

procedure dtBitmap(var Data:TData; Value:PBitmap);
begin
   Data.data_type := data_bitmap;
   Data.idata := NativeInt(Value);
   Data.Next := nil;
   {$ifdef MT_ENABLED}Data.ldata := nil;{$endif}
end;

procedure dtStream(var Data:TData; Value:PStream);
begin
   Data.data_type := data_stream;
   Data.idata := NativeInt(Value);
   Data.Next := nil;
   {$ifdef MT_ENABLED}Data.ldata := nil;{$endif}
end;

procedure dtRect(var Data:TData; Value:pointer);
begin
   Data.data_type := data_rect;
   Data.idata := NativeInt(Value);
   Data.Next := nil;
   {$ifdef MT_ENABLED}Data.ldata := nil;{$endif}
end;

procedure dtIcon(var Data:TData; Value:PIcon);
begin
   Data.data_type := data_icon;
   Data.idata := NativeInt(Value);
   Data.Next := nil;
   {$ifdef MT_ENABLED}Data.ldata := nil;{$endif}
end;

procedure dtObject(var Data:TData; id:integer; Value:pointer);
begin
   Data.data_type := data_object;
   Data.idata := NativeInt(Value);
   Data.rdata := id;  // xxxx
   Data.Next := nil;
   {$ifdef MT_ENABLED}Data.ldata := nil;{$endif}
end;

procedure dtType(var Data:TData; Value:PType);
begin
  Data.data_type := data_types;
  Data.idata := NativeInt(Value);
  Data.next := nil;
  {$ifdef MT_ENABLED}Data.ldata := nil{$endif}
end;

function _IsStr(const Data:TData):boolean;
begin
   Result := Data.Data_type = data_str;
end;

function _IsInteger(const Data:TData):boolean;
begin
   Result := Data.Data_type = data_int;
end;

function _IsFont(const Data:TData):boolean;
begin
   Result := Data.Data_type = data_font;
end;

function _IsStream(const Data:TData):boolean;
begin
   Result := Data.Data_type = data_stream;
end;

function _IsBitmap(const Data:TData):boolean;
begin
   Result := Data.Data_type = data_bitmap;
end;

function _IsIcon(const Data:TData):boolean;
begin
   Result := Data.Data_type = data_icon;
end;

function _IsObject(const Data:TData; id:integer):boolean;
begin
   Result := (Data.Data_type = data_object) and ( data.rdata > 0) and ( data.rdata = id);
end;

function _IsNull(const Data:TData):boolean;
begin
   Result := Data.Data_type = data_null;
end;

function _IsBreak(const Data:TData):boolean;
begin
   Result := Data.Data_type = data_break;
end;

function _IsTypes(const Data:TData):boolean;
begin
  Result := Data.data_type = data_types;
end;

function _IsType(const Data:TData):integer;
begin
   Result := Data.data_type;
end;

procedure GenGUID;
begin
   if g = 0 then
    begin
     inc(_guids_);
     g := _guids_;
    end;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$ifdef WIN64}
function StrIComp(const Str1, Str2: PKOLChar): Integer;
var
  S1, S2: PKOLChar;
  c1, c2: KOLChar;
begin
  S1 := Str1;
  S2 := Str2;
  while (S1^ <> #0) and (S2^ <> #0) do
  begin
    c1 := S1^;
    if (c1 >= 'a') and (c1 <= 'z') then
      Dec(c1, 32);
    c2 := S2^;
    if (c2 >= 'a') and (c2 <= 'z') then
      Dec(c2, 32);
    Result := Ord(c1) - Ord(c2);
    if Result <> 0 then Exit;
    Inc(S1);
    Inc(S2);
  end;
  Result := Ord(S1^) - Ord(S2^);
end;
{$else}
{$ifdef UNICODE}
function StrIComp(const Str1, Str2: PChar): Integer; assembler;
asm
        PUSH    EDI
        PUSH    ESI
        MOV     EDI,EDX
        MOV     ESI,EAX
        MOV     ECX,0FFFFFFFFH
        XOR     EAX,EAX
        REPNE   SCASW
        NOT     ECX
        MOV     EDI,EDX
        XOR     EDX,EDX
@@1:    REPE    CMPSW
        JE      @@4
        MOV     AX,[ESI-1]
        CMP     AX,'a'
        JB      @@2
        CMP     AX,'z'
        JA      @@2
        SUB     AX,20H
@@2:    MOV     DX,[EDI-1]
        CMP     DX,'a'
        JB      @@3
        CMP     DX,'z'
        JA      @@3
        SUB     DX,20H
@@3:    SUB     EAX,EDX
        JE      @@1
@@4:    POP     ESI
        POP     EDI
end;
{$else}
function StrIComp(const Str1, Str2: PChar): Integer; assembler;
asm
        PUSH    EDI
        PUSH    ESI
        MOV     EDI,EDX
        MOV     ESI,EAX
        MOV     ECX,0FFFFFFFFH
        XOR     EAX,EAX
        REPNE   SCASB
        NOT     ECX
        MOV     EDI,EDX
        XOR     EDX,EDX
@@1:    REPE    CMPSB
        JE      @@4
        MOV     AL,[ESI-1]
        CMP     AL,'a'
        JB      @@2
        CMP     AL,'z'
        JA      @@2
        SUB     AL,20H
@@2:    MOV     DL,[EDI-1]
        CMP     DL,'a'
        JB      @@3
        CMP     DL,'z'
        JA      @@3
        SUB     DL,20H
@@3:    SUB     EAX,EDX
        JE      @@1
@@4:    POP     ESI
        POP     EDI
end;
{$endif}
{$endif}

function PosEx(const SubStr, S: string; Offset: Cardinal = 1): Integer;
var
  I,X: Integer;
  Len, LenSubStr: Integer;
begin
  if Offset = 1 then
    Result := Pos(SubStr, S)
  else if Length(SubStr) = 0 then
    Result := 0
  else
   begin
    I := Offset;
    LenSubStr := Length(SubStr);
    Len := Length(S) - LenSubStr + 1;
    while I <= Len do
    begin
      if S[I] = SubStr[1] then
      begin
        X := 1;
        while (X < LenSubStr) and (S[I + X] = SubStr[X + 1]) do
          Inc(X);
        if (X = LenSubStr) then
        begin
          Result := I;
          exit;
        end;
      end;
      Inc(I);
    end;
    Result := 0;
   end;
end;

function PosBuf(Buffer: Pointer; BufLen: Integer; SearchBuf: Pointer; SBufLen: Integer): Integer;
var
  B: PByte;
begin
  Result := -1;
  if (BufLen < 1) or (SBufLen < 1) {or (BufLen < SBufLen)} then exit;
  
  B := Buffer;
  while BufLen >= SBufLen do
  begin
    if B^ = PByte(SearchBuf)^ then
    begin
      if CompareMem(B, SearchBuf, SBufLen) then // �������
      begin
        Result := NativeInt(B) - NativeInt(Buffer);
        break;
      end;
    end;
    Dec(BufLen);
    Inc(NativeUInt(B));
  end;
end;

procedure Replace;
var p,q:integer;
begin
   q := Length(dest);
   p := Pos(substr,str);
   while p > 0 do begin
     if (@back = nil) or back(p) then begin
       Delete(str,p,length(substr));
       Insert(dest,Str,p);
       inc(p,q);
     end else inc(p);
     p := PosEx(substr,str,p);
   end;
end;

function _hi_OnMessage(Message: TOnMessage; var Msg: TMsg; var Rslt: LRESULT): Boolean;
begin
   if Assigned(Message) then
    Result := Message(Msg,Rslt)
   else Result := false;
end;

function UPD_Init;
var wsaData:TWSAData;
begin
  if WSA_Init = 0 then
    Result := WSAStartup($101,wsaData) = 0
  else Result := true;
  inc(WSA_Init);
end;

procedure UPD_Clear;
begin
   dec(WSA_Init);
   if WSA_Init = 0 then
     WSACleanup
   else ; // ---- ERROR -----
end;

function TCPGetHostByName(name: PAnsiChar): string;
var
  host:phostent;
  adr:in_addr;
begin
  host := gethostbyname(name);
  if host = nil then
   Result := ''
  else
   begin
    move(host.h_addr^^,adr,host.h_length);
    Result := inet_ntoa(adr);
   end;
end;

function ReadHandle:HWND;
begin
   if Assigned(Applet) then
     begin
      if not Assigned(Applet.ActiveControl) then
        Result := Applet.Children[0].Handle
      else Result := Applet.ActiveControl.handle
     end
   else Result := GHandle;
end;

function ReadFilename;
begin
   Result := WinDirs(FName);
   if ExtractFilePath(Result) = '' then
    Result := GetStartDir + Result;
end;

function WinDirs;
begin
   Result := FName;
   Replace(Result,'%windir%',GetWindowsDir);
   Replace(Result,'%tmpdir%',GetTempDir);
   Replace(Result,'%sysdir%',GetSystemDir);
end;

function LoadResData(const Name: string; OutLen: PInteger = nil): Pointer;
var
  hRes: HRSRC;
  hResource: HRSRC;
begin
  Result := nil;
  hRes := FindResource(hInstance, PChar(Name), PChar(100));
  if hRes = 0 then Exit;
  
  if OutLen <> nil then 
    OutLen^ := SizeofResource(hInstance, hRes);
  
  hResource := LoadResource(hInstance, hRes);
  if hResource = 0 then Exit;
  
  Result := LockResource(hResource);
  FreeResource(hResource);
end;

function LoadResStr(const Name: string): string;
var
  P: PAnsiChar;
  {$ifdef UNICODE}W: Word;{$endif}
begin
  P := LoadResData(Name);
  {$ifdef UNICODE}
  W := PWord(P)^;
  Inc(P, 2);
  Result := AnsiStringToWideString(P, W);
  {$else}
  Inc(P, 2); // ���������� 2 ����� ��������� � ������ ������
  Result := P;
  {$endif}
end;

function LoadResStream(const Name: string): PStream;
var
  P: Pointer;
  L: Integer;
begin
  Result := NewMemoryStream;
  P := LoadResData(Name, @L);
  if (P <> nil) and (L > 0) then
  begin
    Result.Write(P^, L);
    Result.Position := 0;
  end;
end;

function hiCreateFont;
begin
   Result.Name := Name;
   Result.Size := Size;
   Result.Style := Style;
   Result.Color := Color;
   Result.CharSet := CharSet;
end;

procedure SetFont;
{$ifdef F_P}
var fs:TFontStyle;
{$endif}
begin
   {$ifdef F_P}
   if Value and 1 > 0 then
    fs := [fsBold]
   else fs := [];
   if Value and 2 > 0 then
     Include(fs,fsItalic);
   if Value and 4 > 0 then
     Include(fs, fsUnderline);
   if Value and 8 > 0 then
     Include(fs,fsStrikeOut);
   Font.FontStyle := fs;
   {$else}
   Font.FontStyle := TFontStyle(pointer(@Value)^);
   {$endif}
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ARRAYS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

constructor TArray.Create;
begin
   inherited Create;
   Items := NewKOLStrListEx;
   Arr._Count := Count;
   Arr._Set := Write;
   Arr._Get := Read;
   Arr._Add := Add;
end;

destructor TArray.Destroy;
var i:integer;
begin
  for i := 0 to Items.Count-1 do
   Delete(Items.Objects[i]);
  Items.Free;
  inherited Destroy;
end;

procedure TArray._work_doSave;
var
  fn:string;
  st:PStream;
  Lst:PKOLStrList;
  i:cardinal;
  s:string;
begin
   fn := ReadString(_data,_data_FileName,_prop_FileName);
   if Items.Count > 0 then
   if _prop_FileFormat = 0 then
    begin
      st := NewWriteFileStream(fn);
      for i := 0 to Items.Count-1 do
       Save(st,Items.Objects[i]);
      st.Free;
    end
   else
    begin
      Lst := NewKOLStrList;
      for i := 0 to Items.Count-1 do
       begin
        Save(@s,Items.Objects[i]);
        Lst.Add(Items.Items[i] + '=' + s);
       end;
      Lst.SaveToFile(fn);
      Lst.Free;
    end;
end;

procedure TArray._work_doLoad;
var fn,fn_:string;
    st:PStream;
    Lst:PKOLStrList;
    i:integer;
    c:NativeInt;
begin
   fn := ReadString(_data,_data_FileName,_prop_FileName);
   if FileExists(fn) then
    begin
      _work_doClear(_data,0);
      if _prop_FileFormat = 0 then
       begin
        st := NewReadFileStream(fn);
        while st.Position < st.Size do
         begin
           Load(st,c);
           Items.AddObject('',c);
         end;
        st.Free;
       end
      else
       begin
        Lst := NewKOLStrList;
        Lst.LoadFromFile(fn);
        for i := 0 to Lst.Count-1 do
         begin
          fn := Lst.Items[i];
          fn_ := GetTok(fn,'=');
          Load(@fn,c);
          Items.AddObject(fn_,c);
         end;
        Lst.Free;
       end;
    end;
end;

procedure TArray._work_doClear;
var i:integer;
begin
   for i := 0 to Items.Count-1 do
    Delete(Items.Objects[i]);
   Items.Clear;
end;

function TArray.Swap;
begin
   Result := false;
end;

procedure TArray._work_doSort;
var
  i: Integer;
  fl: Boolean;
  p: NativeUInt;
begin
  if Items.Count > 1 then
    repeat
      fl := false;
      for i := 0 to Items.Count-2 do
        if Swap(Items.Objects[i],Items.Objects[i+1]) then
        begin
         p := Items.Objects[i];
         Items.Objects[i] := Items.Objects[i+1];
         Items.Objects[i+1] := p;
         fl := true;
        end;
    until not fl;
end;

procedure TArray.SetItems;
begin
   Items.Free;
   Items := Value;
end;

procedure TArray._var_Array;
begin
   dtArray(_data,@Arr);
end;

procedure TArray._var_Count;
begin
   dtInteger(_data,Items.Count);
end;

function TArray.DataToPointer;
begin
  Result := 0;
end;

procedure TArray.PointerToData;
begin
   dtNull(Result);
end;


procedure TArray.Delete;
begin
end;

procedure TArray.Add;
begin
   Items.AddObject('',DataToPointer(Val));
end;

procedure TArray.Write;
var i:integer;
    s:string;
    dt:TData;
begin
   if Items.Count > 0 then
    begin
     if _prop_UseName then
      begin
        dt := Item;
        s := Share.ToString(Item);
        Item := dt;
        for i := 0 to Items.Count-1 do
         if Items.Items[i] = s then
          begin
            Delete(Items.Objects[i]);
            Items.Objects[i] := DataToPointer(Val);
            Exit;
          end;
      end;
     i := ToIntIndex(Item);
     if(i >= 0)and(i < Items.Count) then
      begin
       Delete(Items.Objects[i]);
       Items.Objects[i] := DataToPointer(Val);
      end;
    end;
end;

function TArray.Read;
var i:integer;
    s:string;
    dt:TData;
begin
   Val.Data_type := data_null;
   if Items.Count > 0 then
    begin
     if _prop_UseName then
      begin
        dt := Item;
        s := Share.ToString(Item);
        Item := dt;
        for i := 0 to Items.Count-1 do
         if Items.Items[i] = s then
          begin
           PointerToData(Items.Objects[i],Val);
           Result := val.Data_type <> data_null;
           Exit;
          end;
      end;
     i := ToIntIndex(Item);                                  // ������ �� �����, ���������� �� ������ �����
     if(i >= 0)and(i < Items.Count)and(not _prop_UseName or (int2str(i) = Share.ToString(Item))) then
       PointerToData(Items.Objects[i],Val);
    end;

  Result := val.Data_type <> data_null;
end;

function TArray.Count;
begin
  Result := Items.Count;
end;

function MakeArrayInteger(const Names: string; Values: array of Integer): PKOLStrListEx;
var
  I: Integer;
begin
  Result := NewKOLStrListEx;
  Result.Text := Names;
  for I := 0 to Result.Count - 1 do
    Result.Objects[I] := Values[I];
end;

function MakeArrayString(const Names: string; Values: array of PChar): PKOLStrListEx;
var
  I: Integer;
begin
  Result := NewKOLStrListEx;
  Result.Text := Names;
  for I := 0 to Result.Count - 1 do
    Result.Objects[I] := NativeUInt(Values[I]);
end;

function MakeArrayBitmap(const Names: string; Values: array of HBITMAP): PKOLStrListEx;
var
  I: Integer;
begin
  Result := NewKOLStrListEx;
  Result.Text := Names;
  for I := 0 to Result.Count - 1 do
    Result.Objects[I] := NativeUInt(Values[I]);
end;

function MakeArrayReal(const Names: string; Values: array of Real): PKOLStrListEx;
var
  I: Integer;
  R: ^Real;
begin
  Result := NewKOLStrListEx;
  Result.Text := Names;
  for I := 0 to Result.Count - 1 do
  begin
    New(R);
    R^ := Values[I];
    Result.Objects[I] := NativeUInt(R);
  end;
end;

function MakeArrayWave(const Names: string; Values: array of PChar): PKOLStrListEx;
var
  I: Integer;
  R: ^string;
begin
  Result := NewKOLStrListEx;
  Result.Text := Names;
  for I := 0 to Result.Count - 1 do
  begin
    New(R);
    NativeUInt(R^) := 0;
    R^ := Values[I];
    Result.Objects[I] := NativeUInt(R);
  end;
end;

function MakeArrayIcon(const Names: string; Values: array of HICON): PKOLStrListEx;
var
  I: Integer;
begin
  Result := NewKOLStrListEx;
  Result.Text := Names;
  for I := 0 to Result.Count - 1 do
    Result.Objects[I] := NativeUInt(Values[I]);
end;

function MakeArrayStream(const Names: string; Values: array of PStream): PKOLStrListEx;
var
  I: Integer;
begin
  Result := NewKOLStrListEx;
  Result.Text := Names;
  for I := 0 to Result.Count - 1 do
    Result.Objects[I] := NativeUInt(Values[I]);
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TYPES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function TType.Data_Get;
begin
  Result := nil;
  if idx < fCount then Result := PData(fTypeDt.Objects[idx]);
end;

procedure TType.Data_Set;
var p:PData;
begin
  if idx < fCount then begin
    p := PData(fTypeDt.Objects[idx]);
    FreeData(p);
    if dt = nil then dtNull(p^) else CopyData(p,dt);
  end;
end;


constructor TType.Create;
begin
  inherited Create;
  fTypeDt := NewKOLStrListEx;
  name    := '';
  fCount  := 0;
end;

destructor TType.Destroy;
var i:integer;
begin
  for i := 0 to fCount-1 do begin 
    FreeData(PData(fTypeDt.Objects[i]));
    dispose(PData(fTypeDt.Objects[i]));
  end;
  fTypeDt.Free;
  inherited Destroy;
end;

function TType.Add;
var tdt:PData;
begin
  Result := -1;
  if fTypeDt.IndexOf(nm) <> -1 then Exit;
  new(tdt);
  CopyData(tdt,dt);
  Result := fTypeDt.AddObject(nm,Cardinal(tdt));
  inc(fCount);
end;

function TType.Delete;
begin
  Result := false;
  if i >= fCount then Exit;
  FreeData(PData(fTypeDt.Objects[i]));
  dispose(PData(fTypeDt.Objects[i]));
  fTypeDt.Delete(i);
  dec(fCount);
  Result := true;
end;

procedure TType.Clear;
var i:integer;
begin
  for i := 0 to fCount-1 do begin
   FreeData(PData(fTypeDt.Objects[i]));
   dispose(PData(fTypeDt.Objects[i]));
  end;
  fTypeDt.Clear;
//  name := '';
  fCount := 0;
end;

function TType.IndexOf;
begin
  Result := fTypeDt.IndexOf(nm);
end;

procedure TType.SetName;
begin
  if idx < fTypeDt.count then fTypeDt.Items[idx] := nn;
end;

function TType.GetName;
begin
  Result := fTypeDt.Items[idx];
end;

//~~~~~~~ TStorageType ~~~~~~~~

//function TStorageType.Data_Get;
//begin
//  Result := nil;
//  if idx < fCount then Result := PData(fTypeDt.Objects[idx]);
//end;

function TStorageType.CreateCopy;
var mt:PMT;
    md:TData;
    st,st1:PStream;
    bmp:PBitmap;
    typ,tp:PType;
    i:integer;
begin
  Result := nil;
  if dt = nil then Exit;
  mt := mt_make(md);
  while dt <> nil do begin
    case dt.data_type of
      data_stream:
       begin
         st := NewMemoryStream;
         st1 := PStream(dt.idata);
         st1.position := 0;
         Stream2Stream(st,st1,st1.size);
         st.position := 0;
         fData.Add(st);
         mt_data(mt,_DoData(st));
       end;
    
      data_bitmap:
       begin
         bmp := NewBitmap(0,0);
         bmp.Assign(PBitmap(dt.idata));
         fData.Add(bmp);
         mt_data(mt,_DoData(bmp));
       end;
    
      data_types:
       begin
         tp := PType(dt.idata);
         if tp^ is TStorageType then typ := NewStorageType else typ := NewType;
         typ.name := tp.name;
         for i := 0 to tp.count-1 do typ.Add(tp.NameOf[i],tp.Data[i]);
         fData.Add(typ);
         mt_data(mt,_DoData(typ));
       end;
    
    else
      mt_data(mt,dt^);
    end;
    dt := dt.ldata;
  end;
  dispose(mt);
  Result := md.ldata;
end;

procedure TStorageType.FreeCopy;
var temp:PData;
    sl:pointer;
begin
  while dt <> nil do begin
    temp := dt.ldata;
    case dt.data_type of
      data_stream, data_bitmap, data_types:
       begin
         sl := pointer(dt.idata);
         PObj(sl).Free;
         fData.Remove(sl);
       end;
       
    else
      dispose(dt);
    end;
    dt := temp;
  end;
end; 

procedure TStorageType.Data_Set;
var p:PData;
begin
  if idx < fCount then begin
    p := PData(fTypeDt.Objects[idx]);
    FreeCopy(p);
    if dt = nil then begin 
      new(p);
      dtNull(p^); 
    end else fTypeDt.Objects[idx] := NativeUInt(CreateCopy(dt));
  end;
end;


constructor TStorageType.Create;
begin
  inherited Create;
  fData := NewList;
end;

destructor TStorageType.Destroy;
var i:integer;
begin
  for i := 0 to fData.Count-1 do
    PObj(fData.Items[i]).Free;
  fData.Free;
  inherited Destroy;
end;

function TStorageType.Add;
var tdt:PData;
begin
  Result := -1;
  if fTypeDt.IndexOf(nm) <> -1 then Exit;
  tdt := CreateCopy(dt);
  Result := fTypeDt.AddObject(nm,NativeUInt(tdt));
  inc(fCount);
end;

function TStorageType.Delete;
begin
  Result := false;
  if i >= fCount then Exit;
  FreeCopy(PData(fTypeDt.Objects[i]));
  fTypeDt.Delete(i);
  dec(fCount);
  Result := true;
end;

procedure TStorageType.Clear;
var i:integer;
begin
  for i := 0 to fCount-1 do begin
    FreeData(PData(fTypeDt.Objects[i]));
    dispose(PData(fTypeDt.Objects[i]));
  end;
  for i := 0 to fData.Count-1 do
    PObj(fData.Items[i]).Free;
  fTypeDt.Clear;
  fData.Clear;
  fCount := 0;
end;

//~~~~~~~ Other ~~~~~~~~

procedure CallTypeError;
var dt,tdt:TData;
begin
  dtInteger(dt,err);
  if elm <> '' then begin 
    dtString(tdt,elm);
    dt.ldata := @tdt;
  end;
  _hi_OnEvent(evt,dt);
end;

function NewType;
begin
  new(Result);
  Result^ := TType.Create;
end;

function NewStorageType;
begin
  new(Result);
  Result^ := TStorageType.Create;
end;

//___________________

procedure AddMTData(p,q:PData; var forFree:PData);
begin
  if p.data_type <> data_null then
    while p.ldata <> nil do
      p := p.ldata
  else begin
    p^ := q^;
    q := q.ldata;
    p.ldata := nil;
  end;
  forFree := p;
  while(q <> nil)and(q.data_type <> data_null) do begin
    new(p.ldata);
    p := p.ldata;
    p^ := q^;
    q := q.ldata;
  end;
end;

procedure FreeData(Data:PData);
var k:PData;
begin
   {$ifdef MT_ENABLED}
   k := Data.ldata;
   Data.ldata := nil;
   while k <> nil do
    begin
      Data := k;
      k := k.ldata;
      dispose(Data);
    end;
   {$endif}
end;

procedure CopyData(Dest,Src:PData);
begin
   Dest^ := Src^;
   {$ifdef MT_ENABLED}
   while (Src.data_type<>data_null)and(Src.ldata <> nil) do
    begin
       Src := Src.ldata;
       new(Dest.ldata);
       Dest := Dest.ldata;
       Dest^ := Src^;
    end;
   {$endif}
end;

function mt_make(var data:TData):PMT;
begin
  new(Result);
  FillChar(Result^, sizeof(TMT), 0);
  data.ldata := nil;
  Result.start := @data.ldata;
  Result.next := @data.ldata; 
end;

procedure mt_string(mt:PMT; const value:string);
begin
  new(mt.next^);
  FillChar(mt.next^^, sizeof(TData), 0);
  dtString(mt.next^^, value);
  mt.next := @mt.next^.ldata; 
end;

procedure mt_int(mt:PMT; value:integer);
begin
  new(mt.next^);
  FillChar(mt.next^^, sizeof(TData), 0);
  dtInteger(mt.next^^, value);
  mt.next := @mt.next^.ldata; 
end;

procedure mt_real(mt:PMT; value:real);
begin
  new(mt.next^);
  FillChar(mt.next^^, sizeof(TData), 0);
  dtReal(mt.next^^, value);
  mt.next := @mt.next^.ldata; 
end;

procedure mt_data(mt:PMT; const value:TData);
begin
  new(mt.next^);
  FillChar(mt.next^^, sizeof(TData), 0);
  mt.next^^ := value;
  mt.next := @mt.next^.ldata;
  mt.next^ := nil; 
end;

procedure mt_free(mt:PMT);
var n,d:PData;
begin
  n := mt.start^;
  while n <> nil do
    begin
      d := n;
      n := n.ldata;
      dispose(d);
    end;
  dispose(mt);
end;

//___________________

function ToIntIndex;
begin
   case _isType(Data) of
    data_int : Result := Integer(data.idata);
    data_real: Result := round(data.rdata);
    data_str: begin
      Result := str2int(Data.sdata);
      if (Data.sdata = '')or(Result = 0)and(data.sdata[1] <> '0')then
        Result := -1;
    end;
    else Result := -1;
   end;
   //Data.data_type := data_null;
end;

procedure TArr_nil._Set;
begin
end;

procedure TArr_nil._Add;
begin
end;

function CreateArray;
begin
  new(Result);
  Result._Get := _Get;
  Result._Count := _Count;
  if not Assigned(_Set) then
    Result._Set := _arr._Set
  else Result._Set := _Set;
  if not Assigned(_Add) then
    Result._Add := _arr._Add
  else Result._Add := _Add;
end;

function CreateMatrix;
begin
   new(result);
   Result._Get := _Get;
   Result._Set := _Set;
   Result._Rows := _Y;
   Result._Cols := _X;
end;

{$ifdef F_P}
type TMTh = class(PThread);

function ThreadFunc(Thread: PThread): integer; stdcall;
begin
  Result := Thread.Execute;
end;

function NewThreadForFPC:PTHread;
begin
   Result := PTHread.Create;
   TMTh(Result).FHandle := CreateThread( nil, // no security
                                  0,   // the same stack size
                                  @ThreadFunc, // thread entry point
                                  Result,      // parameter to pass to ThreadFunc
                                  CREATE_SUSPENDED,   // always SUSPENDED
                                  TMTh(Result).FThreadID ); // receive thread ID
end;
{$endif}

//--------------- ������ ��������� �������� ������� <1,2,3,4> ------------------

procedure ParseIconsIdx(var s:string; IconsIdx:TIconsIdx; init:boolean=false);
const _dlm = ',';
var   sint, parse:string;
      i:integer;
begin
   if init then for i:=0 to high(IconsIdx) do IconsIdx[i] := I_SKIP;
   s := TrimLeft(s);
   if (s = '') or (s[1] <> '<') or (Pos('>',s)=0) then exit;
   Delete(s,1,1);
   parse := GetTok(s,'>') + _dlm;
   Replace(parse, ' ' ,'');
   i:=0; repeat
      sint := gettok(parse, _dlm);
      if sint <> '' then IconsIdx[i] := str2int(sint);
      inc(i);
   until (parse = '') or (i > high(IconsIdx));
end;

//------------------------------------------------------------------------------

{$ifdef F_P}
function StringToOleStr(const value:string):PWideChar;
begin
   Result := PWideChar(WideString(value));
end;
function LStrFromPWCharLen(Source: PWideChar; Length: Integer): String;
var
  DestLen: Integer;
  Buffer: array[0..2047] of Char;
begin
  if Length <= 0 then
  begin
    //_LStrClr(Result);
    Result := '';
    Exit;
  end;
  if Length < SizeOf(Buffer) div 2 then
  begin
    DestLen := WideCharToMultiByte(0, 0, Source, Length,
      Buffer, SizeOf(Buffer), nil, nil);
    if DestLen > 0 then
    begin
      Result := Buffer;
      //System.LStrFromPCharLen(Result, Buffer, DestLen);
      Exit;
    end;
  end;
  DestLen := WideCharToMultiByte(0, 0, Source, Length, nil, 0, nil, nil);
  // _LStrFromPCharLen(Dest, nil, DestLen);
  SetLength( Result, DestLen );
  WideCharToMultiByte(0, 0, Source, Length, Pointer(Result), DestLen, nil, nil);
end;
{$endif}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Math Function ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

{$IFDEF WIN64}
function IntPower(Base: Extended; const Exponent: Integer): Extended;
var
  Y: Integer;
begin
  Y := Abs(Exponent);
  Result := 1.0;
  while Y > 0 do begin
    while not Odd(Y) do
    begin
      Y := Y shr 1;
      Base := Base * Base
    end;
    Dec(Y);
    Result := Result * Base
  end;
  if Exponent < 0 then Result := 1.0 / Result
end;

procedure Power(var x: Real; const Exponent: Real);
var y:integer;
begin
  y := Round(Exponent);
  if Exponent=y then x := IntPower(x, y)
  else if (x=0)and(Exponent>0) then x := 0
  else x := Exp(Exponent*Ln(x));
end;

function Tan(const X: Extended): Extended;
begin
  Result := Sin(X) / Cos(X);
end;  

function CoTan(const X: Extended): Extended;
begin
  Result := 1 / Tan(X);
end;

function ArcTan2(const Y, X: Extended): Extended;
begin
  If (Y = 0) and (X > 0) then Result :=  0
  else
  If (Y > 0) and (X = 0) then Result :=  pi/2
  else
  If (Y = 0) and (X < 0) then Result :=  pi
  else
  If (Y < 0) and (X = 0) then Result := -pi/2
  else
  If (Y = 0) and (X = 0) then Result :=  0
  else 
  Result := ArcTan(Y/(X));
end;

function LogN(const Base, X: Extended): Extended;
begin
  Result := ln(X)/ln(Base); 
end;

{$ELSE}
function IntPower(const Base:Extended; const Exponent:Integer):Extended;
asm
        fld1                      { Result := 1 }
        fld     Base
        test    eax,eax
        jg      @@2
        fdivr   ST,ST(1)          { Base := 1 / Base }
        neg     eax
        jnz     @@2
        jmp     @@3
@@1:    fmul    ST,ST             { X := Base * Base }
@@2:    shr     eax,1
        jnc     @@1
        fmul    ST(1),ST          { Result := Result * X }
        jnz     @@1
@@3:    fstp    st                { pop X from FPU stack }
        fwait
end;

procedure Power(var x: Real; const Exponent: Real);
var y:integer;
begin
  y := Round(Exponent);
  if Exponent=y then x := IntPower(x, y)
  else if (x=0)and(Exponent>0) then x := 0
  else x := Exp(Exponent*Ln(x));
end;

function Tan(const X: Extended): Extended;
//  Tan := Sin(X) / Cos(X)
asm
  FLD    X
  FPTAN
  FSTP   ST(0)      // FPTAN pushes 1.0 after result
  FWAIT
end;

function CoTan(const X: Extended): Extended;
// CoTan := Cos(X) / Sin(X) = 1 / Tan(X)
asm
  FLD   X
  FPTAN
  FDIVRP
  FWAIT
end;

function ArcTan2(const Y, X: Extended): Extended;
asm
  FLD     Y
  FLD     X
  FPATAN
  FWAIT
end;

function LogN(const Base, X: Extended): Extended;
// Log.N(X) := Log.2(X) / Log.2(N)
asm
  FLD1
  FLD     X
  FYL2X
  FLD1
  FLD     Base
  FYL2X
  FDIV
  FWAIT
end;
{$ENDIF}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

{$ifndef FPC_NEW}
initialization
  DefaultSystemCodePage := GetACP;
{$endif}

end.