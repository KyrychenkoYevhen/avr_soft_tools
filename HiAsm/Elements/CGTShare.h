#ifndef _CGTSHARE_H_
#define _CGTSHARE_H_

#include <windows.h>

  // параметры элемента, возвращаемые elGetFlag
#define  ONE_COPY    0x1   // одна копия компонента в пределах SDK этого же типа(???)
#define  NO_DELETE   0x2   // не удаляемый компонент
#define  IS_EXCLUZIV 0x4   // одна копия компонента в пределах SDK с таким флагом(???)
#define  IS_EDIT     0x8   // определяет компоненты редактирования
#define  IS_CONTAIN  0x10  // контейнер может содержать все
#define  IS_BACK     0x20  // для элементов всегда находящихся внизу( EditMulti )
#define  IS_MULTI    0x40  // элемент контейнер
#define  ADD_LAST    0x80  // элемент, добавляемый на форму последним( Splitter )
#define  IS_SELECT   0x100 // выбранный элемент
#define  IS_PARENT   0x200 // родитель для элементов текущей SDK
#define  IS_HIDE     0x400 // not build
#define  IS_LINK     0x800
#define  PSTORE      0x1000 // генерировать карту св-тв(not used)

  // типы точек элемента
#define  pt_Work  1
#define  pt_Event 2
#define  pt_Var   3
#define  pt_Data  4

  // типы данных
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

  // классы элемента (elGetClassIndex)
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

  // имена типов св-тв элемента
//extern char *DataNames[];

  // индексы параметров среды
#define  PARAM_CODE_PATH          0
#define  PARAM_DEBUG_MODE         1
#define  PARAM_DEBUG_SERVER_PORT  2
#define  PARAM_DEBUG_CLIENT_PORT  3
#define  PARAM_PROJECT_PATH       4
#define  PARAM_HIASM_VERSION      5

  // ошибки при работе с библиотекой кодогенератора
#define  CG_SUCCESS          0
#define  CG_NOT_FOUND        1  // кодогенератор не найден
#define  CG_INVALID_VERSION  2  // эта версия HiAsm требует более позднюю версию кодогенератора
#define  CG_ENTRY_POINT_NF   3  // точка входа в кодогенератор не найдена
  // ошибки при компиляции проекта
#define  CG_BUILD_FAILED     10 // общая ошибка при сборке проекта
  // ошибки на этапе обработки результата компиляции
#define  CG_APP_NOT_FOUND    20 // результат компиляции не найден

  // параметры проекта
#define  CGMP_COMPRESSED     0x01 // поддерживает сжатие
#define  CGMP_RUN            0x02 // поддерживает запуск из среды
#define  CGMP_RUN_DEBUG      0x04 // поддерживает запуск из среды в отладочном режиме

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

  // типы, используемые в интерфейсе
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
   //возвращает количество элементов в схеме
   id_element __stdcall (*sdkGetElement)(id_sdk SDK, int Index);
   //возвращает идент элемента по его Z-координате(индексу)
   id_element __stdcall (*sdkGetElementName)(id_sdk SDK, char *Name);
   //возвращает идент элемента по имени его класса

   //~~~~~~~~~~~~~~~~~~~~~~~~ Element ~~~~~~~~~~~~~~~~~~~~~~~~~~
   DWORD __stdcall (*elGetFlag)(id_element e);
   //возвращает "хитрые" особенности элемента по его иденту
   DWORD __stdcall (*elGetPropCount)(id_element e);
   //возвращает кол-во св-в элемента
   id_prop __stdcall (*elGetProperty)(id_element e, int Index);
   //возвращает целую структуру для конкретного св-ва с порядковым номером из INI
   bool __stdcall (*elIsDefProp)(id_element e, int Index);
   //возвращает True, если значение св-ва совпадает с заданным в INI файле, иначе False
   DWORD __stdcall (*elSetCodeName)(id_element e, char *Name);
   //даем элементу свое любимое(уникальное) имя
   char* __stdcall (*elGetCodeName)(id_element e);
   //и получаем его обратно (если забыли)
   char* __stdcall (*elGetClassName)(id_element e);
   //а вот имя класса не мы давали - можем только узнать
   char* __stdcall (*elGetInfSub)(id_element e);
   //просто содержимое поля Sub из INI-файла элемента
   DWORD __stdcall (*elGetPtCount)(id_element e);
   //получаем количество точек у элемента
   id_point __stdcall (*elGetPt)(id_element e, int i);
   //получаем идент точки по её индексу
   id_point __stdcall (*elGetPtName)(id_element e, char *Name);
   //получаем идент точки по её имени
   BYTE __stdcall (*elGetClassIndex)(id_element e);
   //получаем подкласс элемента(константы типа CI_ХХХ)
   id_sdk __stdcall (*elGetSDK)(id_element e);
   //получаем идент внутренней схемы для контейнеров и идент родителя(id_element) для редактора контейнера
   bool __stdcall (*elLinkIs)(id_element e);
   //возвращает True, если данный элемент является ссылкой либо на него ссылаются
   id_element __stdcall (*elLinkMain)(id_element e);
   //возвращает идент главного элемента(тот, на который ссылаются другие)
   void __stdcall (*elGetPos)(id_element e, int &X, int &Y);
   //возвращает позицию элемента в редакторе схем
   void __stdcall (*elGetSize)(id_element e, int &W, int &H);
   //возвращает размеры элемента в редакторе схем
   int __stdcall (*elGetEID)(id_element e);

   //~~~~~~~~~~~~~~~~~~~~~~~~ Point ~~~~~~~~~~~~~~~~~~~~~~~~~~
   id_point __stdcall (*ptGetLinkPoint)(id_point p);
   //возвращает идент точки, с которой соеденена данная
   id_point __stdcall (*ptGetRLinkPoint)(id_point p);
   //возвращает идент точки, с которой соеденена данная без учета точек разрыва и хабов
   DWORD __stdcall (*ptGetType)(id_point p);
   //возвращает тип точек(константы pt_XXX)
   char* __stdcall (*ptGetName)(id_point p);
   //возвращает имя точки
   id_element __stdcall (*ptGetParent)(id_point p);
   //возвращает идент элемента, которому принадлежит точка
   DWORD __stdcall (*ptGetIndex)(id_point p);
   //возвращает относительный индекс точки по принадлежности к одной из 4х групп
   char* __stdcall (*pt_dpeGetName)(id_point p);
   //возвращает базовую часть имени динамических точек(для CI_DPElement)

   //~~~~~~~~~~~~~~~~~~~~~~~~ Property ~~~~~~~~~~~~~~~~~~~~~~~~~~
   DWORD __stdcall (*propGetType)(id_prop prop);
   //возвращает тип параметра
   char* __stdcall (*propGetName)(id_prop prop);
   //возвращает имя параметра
   void* __stdcall (*propGetValue)(id_prop prop);
   //возвращает значение параметра
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
   //добавляет имя файла в общий список временных файлов для последующего удаления
   char* __stdcall (*resAddIcon)(id_prop p);
   //добавляет иконку в ресурсы и в список временных файлов
   char* __stdcall (*resAddStr)(char *p);
   //добавляет строку в ресурсы и в список временных файлов
   char* __stdcall (*resAddStream)(id_prop p);
   //добавляет поток в ресурсы и в список временных файлов
   char* __stdcall (*resAddWave)(id_prop p);
   //добавляет звук в ресурсы и в список временных файлов
   char* __stdcall (*resAddBitmap)(id_prop p);
   //добавляет картинку в ресурсы и в список временных файлов
   char* __stdcall (*resAddMenu)(id_prop p);
   //добавляет меню в ресурсы и в список временных файлов

   //~~~~~~~~~~~~~~~~~~~~~~~~ Other ~~~~~~~~~~~~~~~~~~~~~~~~~~
   DWORD __stdcall (*_Debug)(char *Text, DWORD Color);
   //выводит строку Text в окно Отладка цветом Color
   DWORD __stdcall (*GetParam)(WORD index, void *value);
   //возвращает значение параметра среды по его индексу

   //~~~~~~~~~~~~~~~~~~~~~~~~ Arrays ~~~~~~~~~~~~~~~~~~~~~~~~~~
   int __stdcall (*arrCount)(id_array a);
   //возвращает кол-во элементов в массиве а
   int __stdcall (*arrType)(id_array a);
   //возвращает тип элементов в массиве а
   char* __stdcall (*arrItemName)(id_array s, int Index);
   //возвращает имя элемента с индексом Index
   void* __stdcall (*arrItemData)(id_array a, int Index);
   //возвращает значение элемента с индексом Index
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
   // получает пользовательские данные элемента
   void __stdcall (*elSetData)(id_element e, void *data);
   // устанавливает пользовательские данные элемента

   //~~~~~~~~~~~~~~~~~~~~~~~~ Point ~~~~~~~~~~~~~~~~~~~~~~~~~~
   DWORD __stdcall (*ptGetDataType)(id_point p);
   // возвращает тип данных точки

   //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   // пользовательские ф-ции, не входящие в интерфейс
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
   char *elName;     // имя текущего элемента
   char *objName;    // имя объекта
   char *inst_list;  // список методов и полей для вставки в редактор
   char *disp_list;  // список, отображаемый во всплыывающей подсказке
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
