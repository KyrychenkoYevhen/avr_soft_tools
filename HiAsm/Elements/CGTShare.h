#ifndef _CGTSHARE_H_
#define _CGTSHARE_H_

#include <windows.h>

  // ��������� ��������, ������������ elGetFlag
#define  ONE_COPY    0x1   // ���� ����� ���������� � �������� SDK ����� �� ����(???)
#define  NO_DELETE   0x2   // �� ��������� ���������
#define  IS_EXCLUZIV 0x4   // ���� ����� ���������� � �������� SDK � ����� ������(???)
#define  IS_EDIT     0x8   // ���������� ���������� ��������������
#define  IS_CONTAIN  0x10  // ��������� ����� ��������� ���
#define  IS_BACK     0x20  // ��� ��������� ������ ����������� �����( EditMulti )
#define  IS_MULTI    0x40  // ������� ���������
#define  ADD_LAST    0x80  // �������, ����������� �� ����� ���������( Splitter )
#define  IS_SELECT   0x100 // ��������� �������
#define  IS_PARENT   0x200 // �������� ��� ��������� ������� SDK
#define  IS_HIDE     0x400 // not build
#define  IS_LINK     0x800
#define  PSTORE      0x1000 // ������������ ����� ��-��(not used)

  // ���� ����� ��������
#define  pt_Work  1
#define  pt_Event 2
#define  pt_Var   3
#define  pt_Data  4

  // ���� ������
#define  data_null  0
#define  data_int   1
#define  data_str   2
#define  data_data  3
#define  data_combo 4
#define  data_list  5
#define  data_icon  6
#define  data_real  7
#define  data_color 8
#define  data_script  9
#define  data_stream  10
#define  data_bitmap  11
#define  data_wave  12
#define  data_array  13
#define  data_comboEx  14
#define  data_font    15
#define  data_matr  16
#define  data_jpeg  17
#define  data_menu  18
#define  data_code  19

  // ������ �������� (elGetClassIndex)
#define  CI_DPElement     1
#define  CI_MultiElement  2
#define  CI_EditMulti     3
#define  CI_EditMultiEx   4
#define  CI_InlineCode    5
#define  CI_DrawElement   6
#define  CI_AS_Special    7
#define  CI_DPLElement    8
#define  CI_UseHiDLL      9
#define  CI_WinElement    10
#define  CI_PointHint     11
#define  CI_PointElement  12
#define  CI_LineBreak     13
#define  CI_LineBreakEx   14
#define  CI_UserElement   15

  // ����� ����� ��-�� ��������
//extern char *DataNames[];

  // ������� ���������� �����
#define  PARAM_CODE_PATH          0
#define  PARAM_DEBUG_MODE         1
#define  PARAM_DEBUG_SERVER_PORT  2
#define  PARAM_DEBUG_CLIENT_PORT  3
#define  PARAM_PROJECT_PATH       4
#define  PARAM_HIASM_VERSION      5

  // ������ ��� ������ � ����������� ��������������
#define  CG_SUCCESS          0
#define  CG_NOT_FOUND        1  // ������������� �� ������
#define  CG_INVALID_VERSION  2  // ��� ������ HiAsm ������� ����� ������� ������ ��������������
#define  CG_ENTRY_POINT_NF   3  // ����� ����� � ������������� �� �������
  // ������ ��� ���������� �������
#define  CG_BUILD_FAILED     10 // ����� ������ ��� ������ �������
  // ������ �� ����� ��������� ���������� ����������
#define  CG_APP_NOT_FOUND    20 // ��������� ���������� �� ������

  // ��������� �������
#define  CGMP_COMPRESSED     0x01 // ������������ ������
#define  CGMP_RUN            0x02 // ������������ ������ �� �����
#define  CGMP_RUN_DEBUG      0x04 // ������������ ������ �� ����� � ���������� ������

struct TCodeGenTools;

typedef TCodeGenTools *PCodeGenTools;

// CodeGen types and entry point interfaces
typedef struct {
   WORD major;
   WORD minor;
   WORD build;
} THiAsmVersion;

typedef struct {
     // none
} TBuildPrepareRec;

typedef struct {
    PCodeGenTools cgt;
    DWORD sdk;
    void *result;
} TBuildProcessRec;

typedef struct {
    void *result;
    char *prjFilename;
    char *compiler;
} TBuildMakePrjRec;

typedef struct {
    char *prjFilename;
    char *appFilename;
} TBuildCompliteRec;

typedef struct {
    DWORD flags;
} TBuildParams;

typedef struct {
    char *FileName;
    int Mode;
    int ServerPort;
    int ClientPort;
    void *data;
} TBuildRunRec;

  // ����, ������������ � ����������
typedef   DWORD id_sdk;
typedef   DWORD id_element;
typedef   DWORD id_point;
typedef   DWORD id_prop;
typedef   DWORD id_array;
typedef   DWORD id_data;
typedef   DWORD id_font;

struct TCodeGenTools{
   //~~~~~~~~~~~~~~~~~~~~~~~~ SDK ~~~~~~~~~~~~~~~~~~~~~~~~~~
   int __stdcall (* sdkGetCount)(id_sdk SDK);
   //���������� ���������� ��������� � �����
   id_element __stdcall (*sdkGetElement)(id_sdk SDK, int Index);
   //���������� ����� �������� �� ��� Z-����������(�������)
   id_element __stdcall (*sdkGetElementName)(id_sdk SDK, char *Name);
   //���������� ����� �������� �� ����� ��� ������

   //~~~~~~~~~~~~~~~~~~~~~~~~ Element ~~~~~~~~~~~~~~~~~~~~~~~~~~
   DWORD __stdcall (*elGetFlag)(id_element e);
   //���������� "������" ����������� �������� �� ��� ������
   DWORD __stdcall (*elGetPropCount)(id_element e);
   //���������� ���-�� ��-� ��������
   id_prop __stdcall (*elGetProperty)(id_element e, int Index);
   //���������� ����� ��������� ��� ����������� ��-�� � ���������� ������� �� INI
   bool __stdcall (*elIsDefProp)(id_element e, int Index);
   //���������� True, ���� �������� ��-�� ��������� � �������� � INI �����, ����� False
   DWORD __stdcall (*elSetCodeName)(id_element e, char *Name);
   //���� �������� ���� �������(����������) ���
   char* __stdcall (*elGetCodeName)(id_element e);
   //� �������� ��� ������� (���� ������)
   char* __stdcall (*elGetClassName)(id_element e);
   //� ��� ��� ������ �� �� ������ - ����� ������ ������
   char* __stdcall (*elGetInfSub)(id_element e);
   //������ ���������� ���� Sub �� INI-����� ��������
   DWORD __stdcall (*elGetPtCount)(id_element e);
   //�������� ���������� ����� � ��������
   id_point __stdcall (*elGetPt)(id_element e, int i);
   //�������� ����� ����� �� � �������
   id_point __stdcall (*elGetPtName)(id_element e, char *Name);
   //�������� ����� ����� �� � �����
   BYTE __stdcall (*elGetClassIndex)(id_element e);
   //�������� �������� ��������(��������� ���� CI_���)
   id_sdk __stdcall (*elGetSDK)(id_element e);
   //�������� ����� ���������� ����� ��� ����������� � ����� ��������(id_element) ��� ��������� ����������
   bool __stdcall (*elLinkIs)(id_element e);
   //���������� True, ���� ������ ������� �������� ������� ���� �� ���� ���������
   id_element __stdcall (*elLinkMain)(id_element e);
   //���������� ����� �������� ��������(���, �� ������� ��������� ������)
   void __stdcall (*elGetPos)(id_element e, int &X, int &Y);
   //���������� ������� �������� � ��������� ����
   void __stdcall (*elGetSize)(id_element e, int &W, int &H);
   //���������� ������� �������� � ��������� ����
   int __stdcall (*elGetEID)(id_element e);

   //~~~~~~~~~~~~~~~~~~~~~~~~ Point ~~~~~~~~~~~~~~~~~~~~~~~~~~
   id_point __stdcall (*ptGetLinkPoint)(id_point p);
   //���������� ����� �����, � ������� ��������� ������
   id_point __stdcall (*ptGetRLinkPoint)(id_point p);
   //���������� ����� �����, � ������� ��������� ������ ��� ����� ����� ������� � �����
   DWORD __stdcall (*ptGetType)(id_point p);
   //���������� ��� �����(��������� pt_XXX)
   char* __stdcall (*ptGetName)(id_point p);
   //���������� ��� �����
   id_element __stdcall (*ptGetParent)(id_point p);
   //���������� ����� ��������, �������� ����������� �����
   DWORD __stdcall (*ptGetIndex)(id_point p);
   //���������� ������������� ������ ����� �� �������������� � ����� �� 4� �����
   char* __stdcall (*pt_dpeGetName)(id_point p);
   //���������� ������� ����� ����� ������������ �����(��� CI_DPElement)

   //~~~~~~~~~~~~~~~~~~~~~~~~ Property ~~~~~~~~~~~~~~~~~~~~~~~~~~
   DWORD __stdcall (*propGetType)(id_prop prop);
   //���������� ��� ���������
   char* __stdcall (*propGetName)(id_prop prop);
   //���������� ��� ���������
   void* __stdcall (*propGetValue)(id_prop prop);
   //���������� �������� ���������
   BYTE __stdcall (*propToByte)(id_prop prop);
   //
   int __stdcall (*propToInteger)(id_prop prop);
   //
   float __stdcall (*propToReal)(id_prop prop);
   //
   char* __stdcall (*propToString)(id_prop prop);
   //

   //~~~~~~~~~~~~~~~~~~~~~~~~ Res ~~~~~~~~~~~~~~~~~~~~~~~~~~
   DWORD __stdcall (*resAddFile)(char *Name);
   //��������� ��� ����� � ����� ������ ��������� ������ ��� ������������ ��������
   char* __stdcall (*resAddIcon)(id_prop p);
   //��������� ������ � ������� � � ������ ��������� ������
   char* __stdcall (*resAddStr)(char *p);
   //��������� ������ � ������� � � ������ ��������� ������
   char* __stdcall (*resAddStream)(id_prop p);
   //��������� ����� � ������� � � ������ ��������� ������
   char* __stdcall (*resAddWave)(id_prop p);
   //��������� ���� � ������� � � ������ ��������� ������
   char* __stdcall (*resAddBitmap)(id_prop p);
   //��������� �������� � ������� � � ������ ��������� ������
   char* __stdcall (*resAddMenu)(id_prop p);
   //��������� ���� � ������� � � ������ ��������� ������

   //~~~~~~~~~~~~~~~~~~~~~~~~ Other ~~~~~~~~~~~~~~~~~~~~~~~~~~
   DWORD __stdcall (*_Debug)(char *Text, DWORD Color);
   //������� ������ Text � ���� ������� ������ Color
   DWORD __stdcall (*GetParam)(WORD index, void *value);
   //���������� �������� ��������� ����� �� ��� �������

   //~~~~~~~~~~~~~~~~~~~~~~~~ Arrays ~~~~~~~~~~~~~~~~~~~~~~~~~~
   int __stdcall (*arrCount)(id_array a);
   //���������� ���-�� ��������� � ������� �
   int __stdcall (*arrType)(id_array a);
   //���������� ��� ��������� � ������� �
   char* __stdcall (*arrItemName)(id_array s, int Index);
   //���������� ��� �������� � �������� Index
   void* __stdcall (*arrItemData)(id_array a, int Index);
   //���������� �������� �������� � �������� Index
   id_prop __stdcall (*arrGetItem)(id_array a, int Index);
   //
   BOOL __stdcall (*isDebug)(id_sdk e);

   //~~~~~~~~~~~~~~~~~~~~~~~~ Data ~~~~~~~~~~~~~~~~~~~~~~~~~~
   BYTE __stdcall (*dtType)(id_data d);
   char* __stdcall (*dtStr)(id_data d);
   int __stdcall (*dtInt)(id_data d);
   float __stdcall (*dtReal)(id_data d);

   //~~~~~~~~~~~~~~~~~~~~~~~~ Font ~~~~~~~~~~~~~~~~~~~~~~~~~~
   char* __stdcall (*fntName)(id_font f);
   int __stdcall (*fntSize)(id_font f);
   BYTE __stdcall (*fntStyle)(id_font f);
   DWORD __stdcall (*fntColor)(id_font f);
   BYTE __stdcall (*fntCharSet)(id_font f);

   //~~~~~~~~~~~~~~~~~~~~~~~~ Element ~~~~~~~~~~~~~~~~~~~~~~~~~~
   void* __stdcall (*elGetData)(id_element e);
   // �������� ���������������� ������ ��������
   void __stdcall (*elSetData)(id_element e, void *data);
   // ������������� ���������������� ������ ��������

   //~~~~~~~~~~~~~~~~~~~~~~~~ Point ~~~~~~~~~~~~~~~~~~~~~~~~~~
   DWORD __stdcall (*ptGetDataType)(id_point p);
   // ���������� ��� ������ �����

   //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   // ���������������� �-���, �� �������� � ���������
   int ReadIntParam(int Index) {
     int i = 0;
     GetParam(Index, &i);
     return i;
   }

   char *ReadStrParam(int Index) {
     char *c;
     c = (char *)malloc(256);
     GetParam(Index, c);
     return c;
   }

   //------------------------- DEBUG TOOLS ----------------------
   inline void trace(char *text) {
     _Debug(text, 0x0000FF);
   }
   void trace(int value) {
     char text[32];
     itoa(value, text, 10);
     _Debug(text, 0x0000FF);
   }
};

typedef struct {
   char *elName;     // ��� �������� ��������
   char *objName;    // ��� �������
   char *inst_list;  // ������ ������� � ����� ��� ������� � ��������
   char *disp_list;  // ������, ������������ �� ������������ ���������
} TSynParams;

typedef struct {
    id_point point;
    id_sdk sdk;
    PCodeGenTools cgt;
    char *hint;
} THintParams;

/*
function PosEx(const SubStr, S: string; Offset: Cardinal = 1): Integer;
var
  I,X: Integer;
  Len, LenSubStr: Integer;
begin
  if Offset = 1 then
    Result := Pos(SubStr, S)
  else begin
    I := Offset;
    LenSubStr := Length(SubStr);
    Len := Length(S) - LenSubStr + 1;
    while I <= Len do begin
      if S[I] = SubStr[1] then
      begin
        X := 1;
        while (X < LenSubStr) and (S[I + X] = SubStr[X + 1]) do
          Inc(X);
        if (X = LenSubStr) then begin
          Result := I;
          exit;
        end;
      end;
      Inc(I);
    end;
    Result := 0;
  end;
end;


procedure Replace(var Str:string;const substr,dest:string );
var p:integer;
begin
  p := Pos(substr,str);
  while p > 0 do begin
    Delete(str,p,length(substr));
    Insert(dest,Str,p);
    p := PosEx(substr,str,p + Length(dest));
  end;
end;

function GetTok(var s:string; const c:char):string;
var p:integer;
begin
  p := Pos(c,s);
  if p > 0 then begin
    Result := Copy(s,1,p-1);
    if p = Length(s) then
      s := ''
    else Delete(s,1,p);
  end else Result := s;
end;
*/

#endif
