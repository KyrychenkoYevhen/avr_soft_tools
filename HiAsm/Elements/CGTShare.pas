unit CGTShare;

interface

const
  // параметры элемента, возвращаемые elGetFlag
  ONE_COPY   = $1;   // одна копия компонента в пределах SDK этого же типа(???)
  NO_DELETE  = $2;   // не удаляемый компонент
  IS_EXCLUZIV= $4;   // одна копия компонента в пределах SDK с таким флагом(???)
  IS_EDIT    = $8;   // определяет компоненты редактирования
  IS_CONTAIN = $10;  // контейнер может содержать все
  IS_BACK    = $20;  // для элементов всегда находящихся внизу( EditMulti )
  IS_MULTI   = $40;  // элемент контейнер
  ADD_LAST   = $80;  // элемент, добавляемый на форму последним( Splitter )
  IS_SELECT  = $100; // выбранный элемент
  IS_PARENT  = $200; // родитель для элементов текущей SDK
  IS_HIDE    = $400; // not build
  IS_LINK    = $800;
  PSTORE     = $1000; // генерировать карту св-тв(not used)

  // типы точек элемента
  pt_Work  = 1;
  pt_Event = 2;
  pt_Var   = 3;
  pt_Data  = 4;

  // типы данных
  data_null = 0;
  data_int  = 1;
  data_str  = 2;
  data_data = 3;
  data_combo= 4;
  data_list = 5;
  data_icon = 6;
  data_real = 7;
  data_color= 8;
  data_script = 9;
  data_stream = 10;
  data_bitmap = 11;
  data_wave = 12;
  data_array = 13;
  data_comboEx = 14;
  data_font   = 15;
  data_matr = 16;
  data_jpeg = 17;
  data_menu = 18;
  data_code = 19;
  data_element = 20;
  data_flags   = 21;

  data_object = 100;

  // классы элемента (elGetClassIndex)
  CI_DPElement    = 1;
  CI_MultiElement = 2;
  CI_EditMulti    = 3;
  CI_EditMultiEx  = 4;
  CI_InlineCode   = 5;
  CI_DrawElement  = 6;
  CI_AS_Special   = 7;
  CI_DPLElement   = 8;
  CI_UseHiDLL     = 9;
  CI_WinElement   = 10;
  CI_PointHint    = 11;
  CI_PointElement = 12;
  CI_LineBreak    = 13;
  CI_LineBreakEx  = 14;
  CI_UserElement  = 15;
  CI_Translate    = 16;
  CI_PolyMulti    = 17;
  CI_DocumentTemplate = 18;

  // имена типов св-тв элемента
  DataNames:array[0..20]of string =
   (
     'NULL',
     'Integer',
     'String',
     'Data',
     '', //Combo
     'StrList', //data_list
     'Icon',
     'Real',
     'Color',
     '', //data_script = 9;
     'Stream',
     'Bitmap',
     'Wave',
     '', //data_array = 13;
     '', //combo Ex
     '', // font
     '', // matrix
     '', //jpeg
     'Menu', //menu
     'Code',
     'LinkElement'
   );

  // индексы параметров среды
  PARAM_CODE_PATH         = 0;
  PARAM_DEBUG_MODE        = 1;
  PARAM_DEBUG_SERVER_PORT = 2;
  PARAM_DEBUG_CLIENT_PORT = 3;
  PARAM_PROJECT_PATH      = 4;
  PARAM_HIASM_VERSION     = 5;
  PARAM_USER_NAME         = 6;
  PARAM_USER_MAIL         = 7;
  PARAM_PROJECT_NAME      = 8;
  PARAM_SDE_WIDTH         = 9;
  PARAM_SDE_HEIGHT        = 10;
  PARAM_COMPILER          = 11;

  // ошибки при работе с библиотекой кодогенератора
  CG_SUCCESS         = 0;
  CG_NOT_FOUND       = 1;  // кодогенератор не найден
  CG_INVALID_VERSION = 2;  // эта версия HiAsm требует более позднюю версию кодогенератора
  CG_ENTRY_POINT_NF  = 3;  // точка входа в кодогенератор не найдена
  // ошибки при компиляции проекта
  CG_BUILD_FAILED    = 10; // общая ошибка при сборке проекта
  // ошибки на этапе обработки результата компиляции
  CG_APP_NOT_FOUND   = 20; // результат компиляции не найден

  // параметры проекта
  CGMP_COMPRESSED    = $01; // поддерживает сжатие
  CGMP_RUN           = $02; // поддерживает запуск из среды
  CGMP_RUN_DEBUG     = $04; // поддерживает запуск из среды в отладочном режиме
  CGMP_FORM_EDIT     = $08; // внешний редактор форм

  id_empty = 0;

type
  // CodeGen types and entry point interfaces
 PCodeGenTools = ^TCodeGenTools;
  THiAsmVersion = record
    major:word;
    minor:word;
    build:word;
  end;
  TBuildPrepareRec = record
     // none
  end;
  TBuildProcessRec = record
     cgt:PCodeGenTools;
     sdk:cardinal;
     result:pointer;
  end;
  TBuildMakePrjRec = record
     result:pointer;
     prjFilename:PChar;
  end;
  TBuildCompliteRec = record
     prjFilename:PChar;
     appFilename:PChar;
  end;
  TBuildParams = record
     flags:cardinal;
  end;
  TBuildRunRec = record
     FileName:PChar;
     Mode:integer;
     ServerPort,ClientPort:integer;
     data:pointer;
  end;

  // типы, используемые в интерфейсе
  id_sdk = cardinal;
  id_element = cardinal;
  id_point = cardinal;
  id_prop = cardinal;
  id_array = cardinal;
  id_data = cardinal;
  id_font = cardinal;
  id_proplist = cardinal;

 TCodeGenTools = object
   //~~~~~~~~~~~~~~~~~~~~~~~~ SDK ~~~~~~~~~~~~~~~~~~~~~~~~~~
   sdkGetCount:function (SDK:id_sdk):integer; stdcall;
   //возвращает количество элементов в схеме
   sdkGetElement:function (SDK:id_sdk; Index:integer ):id_element; stdcall;
   //возвращает идент элемента по его Z-координате(индексу)
   sdkGetElementName:function (SDK:id_sdk; Name:PChar ):id_element; stdcall;
   //возвращает идент элемента по имени его класса

   //~~~~~~~~~~~~~~~~~~~~~~~~ Element ~~~~~~~~~~~~~~~~~~~~~~~~~~
   elGetFlag:function (e:id_element):cardinal; stdcall;
   //возвращает "хитрые" особенности элемента по его иденту
   elGetPropCount:function (e:id_element):cardinal; stdcall;
   //возвращает кол-во св-в элемента
   elGetProperty:function (e:id_element; Index:integer):id_prop; stdcall;
   //возвращает целую структуру для конкретного св-ва с порядковым номером из INI
   elIsDefProp:function (e:id_element; Index:integer):boolean; stdcall;
   //возвращает True, если значение св-ва совпадает с заданным в INI файле, иначе False
   elSetCodeName:function (e:id_element; Name:pchar):cardinal; stdcall;
   //даем элементу свое любимое(уникальное) имя
   elGetCodeName:function (e:id_element):PChar; stdcall;
   //и получаем его обратно (если забыли)
   elGetClassName:function (e:id_element):PChar; stdcall;
   //а вот имя класса не мы давали - можем только узнать
   elGetInfSub:function (e:id_element):PChar; stdcall;
   //просто содержимое поля Sub из INI-файла элемента
   elGetPtCount:function (e:id_element):cardinal; stdcall;
   //получаем количество точек у элемента
   elGetPt:function (e:id_element; i:integer):id_point; stdcall;
   //получаем идент точки по её индексу
   elGetPtName:function (e:id_element; Name:PChar):id_point; stdcall;
   //получаем идент точки по её имени
   elGetClassIndex:function (e:id_element):byte; stdcall;
   //получаем подкласс элемента(константы типа CI_ХХХ)
   elGetSDK:function (e:id_element):id_sdk; stdcall;
   //получаем идент внутренней схемы для контейнеров и идент родителя(id_element) для редактора контейнера
   elLinkIs:function (e:id_element):boolean; stdcall;
   //возвращает True, если данный элемент является ссылкой либо на него ссылаются
   elLinkMain:function (e:id_element):id_element; stdcall;
   //возвращает идент главного элемента(тот, на который ссылаются другие)
   elGetPos:procedure (e:cardinal; var X,Y:integer); stdcall;
   //возвращает позицию элемента в редакторе схем
   elGetSize:procedure (e:cardinal; var W,H:integer); stdcall;
   //возвращает размеры элемента в редакторе схем
   elGetEID:function (e:cardinal):integer; stdcall;

   //~~~~~~~~~~~~~~~~~~~~~~~~ Point ~~~~~~~~~~~~~~~~~~~~~~~~~~
   ptGetLinkPoint:function (p:id_point):id_point; stdcall;
   //возвращает идент точки, с которой соеденена данная
   ptGetRLinkPoint:function (p:id_point):id_point; stdcall;
   //возвращает идент точки, с которой соеденена данная без учета точек разрыва и хабов
   ptGetType:function (p:id_point):cardinal; stdcall;
   //возвращает тип точек(константы pt_XXX)
   ptGetName:function (p:id_point):pchar; stdcall;
   //возвращает имя точки
   ptGetParent:function (p:id_point):id_element; stdcall;
   //возвращает идент элемента, которому принадлежит точка
   ptGetIndex:function (p:id_point):cardinal; stdcall;
   //возвращает относительный индекс точки по принадлежности к одной из 4х групп
   pt_dpeGetName:function (p:id_point):PChar; stdcall;
   //возвращает базовую часть имени динамических точек(для CI_DPElement)

   //~~~~~~~~~~~~~~~~~~~~~~~~ Property ~~~~~~~~~~~~~~~~~~~~~~~~~~
   propGetType:function (prop:id_prop):integer; stdcall;
   //возвращает тип параметра
   propGetName:function (prop:id_prop):PChar; stdcall;
   //возвращает имя параметра
   propGetValue:function (prop:id_prop):pointer; stdcall;
   //возвращает значение параметра
   propToByte:function (prop:id_prop):byte; stdcall;
   //
   propToInteger:function (prop:id_prop):integer; stdcall;
   //
   propToReal:function (prop:id_prop):real; stdcall;
   //
   propToString:function (prop:id_prop):PChar; stdcall;
   //

   //~~~~~~~~~~~~~~~~~~~~~~~~ Res ~~~~~~~~~~~~~~~~~~~~~~~~~~
   resAddFile:function (Name:pchar):cardinal; stdcall;
   //добавляет имя файла в общий список временных файлов для последующего удаления
   resAddIcon:function (P:id_prop):PChar; stdcall;
   //добавляет иконку в ресурсы и в список временных файлов
   resAddStr:function (P:PChar):PChar; stdcall;
   //добавляет строку в ресурсы и в список временных файлов
   resAddStream:function (P:id_prop):PChar; stdcall;
   //добавляет поток в ресурсы и в список временных файлов
   resAddWave:function (P:id_prop):PChar; stdcall;
   //добавляет звук в ресурсы и в список временных файлов
   resAddBitmap:function (P:id_prop):PChar; stdcall;
   //добавляет картинку в ресурсы и в список временных файлов
   resAddMenu:function (P:id_prop):PChar; stdcall;
   //добавляет меню в ресурсы и в список временных файлов

   //~~~~~~~~~~~~~~~~~~~~~~~~ Other ~~~~~~~~~~~~~~~~~~~~~~~~~~
   _Debug:function (Text:PChar; Color:cardinal):cardinal; stdcall;
   //выводит строку Text в окно Отладка цветом Color
   GetParam:function(index:word; value:pointer):cardinal; stdcall;
   //возвращает значение параметра среды по его индексу

   //~~~~~~~~~~~~~~~~~~~~~~~~ Arrays ~~~~~~~~~~~~~~~~~~~~~~~~~~
   arrCount:function (a:id_array):integer; stdcall;
   //возвращает кол-во элементов в массиве а
   arrType:function (a:id_array):integer; stdcall;
   //возвращает тип элементов в массиве а
   arrItemName:function (a:id_array; Index:integer):PChar; stdcall;
   //возвращает имя элемента с индексом Index
   arrItemData:function (a:id_array; Index:integer):pointer; stdcall;
   //возвращает значение элемента с индексом Index
   arrGetItem:function (a:id_array; Index:integer):id_prop; stdcall;
   //
   isDebug:function (e:id_sdk):longbool; stdcall;

   //~~~~~~~~~~~~~~~~~~~~~~~~ Data ~~~~~~~~~~~~~~~~~~~~~~~~~~
   dtType:function (d:id_data):byte; stdcall;
   dtStr:function (d:id_data):PChar; stdcall;
   dtInt:function (d:id_data):integer; stdcall;
   dtReal:function (d:id_data):real; stdcall;

   //~~~~~~~~~~~~~~~~~~~~~~~~ Font ~~~~~~~~~~~~~~~~~~~~~~~~~~
   fntName:function (f:id_font):PChar; stdcall;
   fntSize:function (f:id_font):integer; stdcall;
   fntStyle:function (f:id_font):byte; stdcall;
   fntColor:function (f:id_font):cardinal; stdcall;
   fntCharSet:function (f:id_font):byte; stdcall;

   //~~~~~~~~~~~~~~~~~~~~~~~~ Element ~~~~~~~~~~~~~~~~~~~~~~~~~~
   elGetData:function (e:id_element):pointer; stdcall;
   // получает пользовательские данные элемента
   elSetData:procedure (e:id_element; data:pointer); stdcall;
   // устанавливает пользовательские данные элемента

   //~~~~~~~~~~~~~~~~~~~~~~~~ Point ~~~~~~~~~~~~~~~~~~~~~~~~~~
   ptGetDataType:function (p:id_point):integer; stdcall;
   // возвращает тип данных точки

   //~~~~~~~~~~~~~~~~~~~~~~~~ Element ~~~~~~~~~~~~~~~~~~~~~~~~~~
   elGetParent:function (e:id_element):id_sdk; stdcall;
   // возвращает родителя
   elGetPropertyListCount:function (e:id_element):cardinal; stdcall;
   // возвращает количество элементов в списке св-тв(из панели св-ва)
   elGetPropertyListItem:function (e:id_element; i:integer):id_proplist; stdcall;
   // возвращает элемент списка св-тв

   //~~~~~~~~~~~~~~~~~~~~~~~~ PropertyList ~~~~~~~~~~~~~~~~~~~~~~~~~~
   plGetName:function (p:id_proplist):PChar; stdcall;
   // возвращает имя св-ва
   plGetInfo:function (p:id_proplist):PChar; stdcall;
   // возвращает описание св-ва
   plGetGroup:function (p:id_proplist):PChar; stdcall;
   // возвращает группу св-ва
   plGetProperty:function (p:id_proplist):id_prop; stdcall;
   // возвращает значение св-ва
   plGetOwner:function (p:id_proplist):id_element; stdcall;
   // возвращает родительский элемент даного св-ва

   //~~~~~~~~~~~~~~~~~~~~~~~~ Point ~~~~~~~~~~~~~~~~~~~~~~~~~~
   ptGetInfo:function (p:id_point):PChar; stdcall;
   // Возвращает описание точки

   //~~~~~~~~~~~~~~~~~~~~~~~~ Property ~~~~~~~~~~~~~~~~~~~~~~~~~~
   propGetLinkedElement:function(e:id_element; propName:PChar):id_element; stdcall;
   // Возвращает id элемента, прилинкованного к указанному св-ву
   propIsTranslate:function (e:id_element; p:id_prop):integer; stdcall;
   // Возвращает 1 если св-во помечено на перевод

   propGetLinkedElementInfo:function(e:id_element; prop:id_prop; _int:PChar):id_element; stdcall;

   //~~~~~~~~~~~~~~~~~~~~~~~~ Element ~~~~~~~~~~~~~~~~~~~~~~~~~~
   elGetSDKByIndex:function (e:id_element; index:integer):id_sdk; stdcall;
   // Возвращает SDK полиморфного контейнера по его индексу
   elGetSDKCount:function (e:id_element):integer; stdcall;
   // Возвращает количаство сабклассов полиморфного контейнера
   elGetSDKName:function (e:id_element; index:integer):PChar; stdcall;

   //~~~~~~~~~~~~~~~~~~~~~~~~ SDK ~~~~~~~~~~~~~~~~~~~~~~~~~~
   sdkGetParent:function (SDK:id_sdk):id_element; stdcall;
   // Возвращает елемент родитель для данного SDK
   
   //~~~~~~~~~~~~~~~~~~~~~~~~ Element ~~~~~~~~~~~~~~~~~~~~~~~~~~
   elGetInterface:function (e:id_element):PChar; stdcall;
   // Возвращает интерфейсы, предоставляемые элементом
   elGetInherit:function (e:cardinal):PChar; stdcall;
   // Возвращает классы, от которых наследуется элемент

   //~~~~~~~~~~~~~~~~~~~~~~~~ Resource ~~~~~~~~~~~~~~~~~~~~~~~~~~
   resEmpty:function:integer; stdcall;
   // Возвращает 1 если список ресурсов пуст, и 0 в противном случае
   resSetPref:function(pref:PChar):integer; stdcall;
   // Устанавливает префикс для имен ресурсов

   //~~~~~~~~~~~~~~~~~~~~~~~~ SDE ~~~~~~~~~~~~~~~~~~~~~~~~~~
   _Error:function (Line:integer; e:id_element; Text:PChar):cardinal; stdcall;
   // Добавляет информацию в панель ошибок

   //~~~~~~~~~~~~~~~~~~~~~~~~ Element ~~~~~~~~~~~~~~~~~~~~~~~~~~
   elGetGroup:function (e:id_element):integer; stdcall;
   // возвращает ID группы, к которой принадлежит элемент и 0 если группа отсутствует

   //~~~~~~~~~~~~~~~~~~~~~~~~ Property ~~~~~~~~~~~~~~~~~~~~~~~~~~
   propSaveToFile:function (p:id_prop; fileName:PChar):integer; stdcall;

   //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   // пользовательские ф-ции, не входящие в интерфейс
   function ReadIntParam(Index:word):integer;
   function ReadStrParam(Index:word):string;
   function ReadCodeDir(e:id_element):string;
 end;

  TSynParams = record
    elName:PChar;     // имя текущего элемента
    objName:PChar;    // имя объекта
    inst_list:PChar;  // список методов и полей для вставки в редактор
    disp_list:PChar;  // список, отображаемый во всплыывающей подсказке
  end;

  THintParams = record
    point:id_point;
    sdk:cardinal;
    cgt:PCodeGenTools;
    hint:PChar;
  end;

procedure Replace(var Str:string;const substr,dest:string );
function PosEx(const SubStr, S: string; Offset: Cardinal = 1): Integer;
function GetTok(var s:string; const c:char):string;

implementation

function TCodeGenTools.ReadIntParam;
begin
   GetParam(Index, @Result);
end;

var buf:array[0..255] of char;

function TCodeGenTools.ReadStrParam;
begin
    GetParam(Index, @buf);
    Result := PChar(@buf);
end;

function TCodeGenTools.ReadCodeDir;
var
    path:array[0..256] of char;
begin
   integer(pointer(@path)^) := e;
   GetParam(PARAM_CODE_PATH, @path);
   Result := path;
end;

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

end.