library CodeGen;

uses
  Windows,kol,
  CGTShare in '..\CGTShare.pas';

type
  TCGrec = record
    MainForm:string;
    Vars,Units,IBody,Dead:PStrList;
  end;
  PCGrec = ^TCGrec;

var IsMulti:boolean;

procedure AddUnit(pr:PCGrec; const UnitName:string);
var i:smallint;
    s:string;
begin
   s := '#include "' + UnitName + '.h"';
   for i := 0 to pr.Units.Count-1 do
    if pr.Units.Items[i] = s then
      Exit;
   Pr.Units.Add( s );
end;

function ReplaceSChar(const s:string; syn:boolean = true):string;
{
var i:word;
    p,_dest:integer;
    substr,dest:string;
}
begin
     Result := s;
     if s <> '' then
      begin
       if syn then
        Replace(Result,'"','\"');
       {
       for i := 257 downto 0 do
         begin
           case i of
            257: begin substr := '\n'; _dest := 13; end;
            256: begin substr := '\r'; _dest := 10; end;
            else begin substr := '\' + int2str(i); _dest := i; end;
           end;
           dest := '''#' + int2str(_dest) + '''';
           p := Pos(substr,Result);
           while p > 0 do
            begin
             if(p = 1)or(Result[p-1] <> '\') then
              begin
               System.Delete(Result,p,length(substr));
               Insert(dest,Result,p);
              end;
             p := PosEx(substr,Result,p + Length(dest));
            end;
         end;
       }
       if syn then
         Replace(Result,'\','\\');
      end;
end;

function DoData(cgt:PCodeGenTools; dt:id_data):string;
begin
  case cgt.dtType(Dt) of
     data_null: Result := '';
     data_int: Result := '_DoData(' + Int2Str(cgt.dtInt(Dt)) + ')';
     data_str: Result := '_DoData(_his("' + ReplaceSChar(cgt.dtStr(Dt)) + '"))';
     data_real:
       if cgt.dtReal(Dt) = 0.0 then
          Result := '_DoData(0.0)'
       else Result := '_DoData(' + Double2Str(cgt.dtReal(Dt)) + ')';
   end;
end;

function GetListItem(const Text:string; Index:byte):string;
var s:string;
    i:integer;
begin
   s := Text + ',';
   for i := 0 to Index do
     Result := GetTok(s,',');
end;

function FontToStr(cgt:PCodeGenTools; F:id_font):string;
begin
   with cgt^ do
     Result := Format('hiCreateFont(_his("%s"),%d,%d,%d,%d)',[fntName(f),fntSize(f),fntStyle(f),fntColor(f),fntCharSet(f)]);
end;

function SaveParam(cgt:PCodeGenTools; e:cardinal; const pr:id_prop; InsertPropName:boolean; Alldata:boolean = false ):string;
var k:string;
    rs:PChar;
begin
   k := '';
   case cgt.propGetType(pr) of
     data_int:  k := Int2Str(cgt.propToInteger(pr));
     data_str:
        if cgt.propToString(pr) = '' then
         k := 'SNULL'
        else
         begin
          k := ReplaceSChar(cgt.propToString(pr));
          if Length(k) < 256 then
           k := '_his("' + k + '")'
          else k := '(HI_STRING)LoadResData(string(_his("' + cgt.resAddStr(PChar(ReplaceSChar(cgt.propToString(pr),false))) + '")))';
         end;
     data_list:
      begin
       k := cgt.resAddStr(PChar(cgt.propToString(pr)));
       if k <> '' then
        k := '(HI_STRING)LoadResData(string(_his("' + k  + '")))';
      end;
     //data_script: k := StrListToStr(TScript(Value).Text);
     data_data:
         if cgt.dtType(id_data(cgt.propGetValue(pr))) <> data_null then
           k := DoData(cgt,id_data(cgt.propGetValue(pr)))
         else if Alldata then k := '_data_Empty';
     data_combo:k := Int2Str(cgt.propToByte(pr));
     data_icon: k := 'LoadIcon(hInstance,_his("' + cgt.resAddIcon(pr) + '"))';
     data_stream,data_jpeg:
       begin
         rs := cgt.resAddStream(pr);
         if Assigned(rs) then
          k := 'LoadResStream(string(_his("' + rs + '")))';
       end;
     //data_bitmap: k := BitmapToRes(Value);
     data_real:
       begin
         k := Double2Str(cgt.propToReal(pr));
        if k = '0' then k := '0.0';
       end;
     data_color: k := Int2Str(cgt.propToInteger(pr));
     //data_wave:  k := WaveToRes(Value);
     //data_array: k := ArrayToRes(e,Value);
     data_comboEx: k := cgt.propToString(pr);
     data_font: k := FontToStr(cgt,id_font(cgt.propGetValue(pr)));
     data_menu: k := cgt.resAddMenu(pr);
   end;
    if InsertPropName and(k <> '') then
      Result := '_prop_' + cgt.propGetName(pr) + ' = ' + k
    else Result := k;
end;

procedure SetPropertys(pr:PCGrec; cgt:PCodeGenTools; E:cardinal);
var j:integer;
    p,u:string;
    List:PStrList;
begin
  if cgt.elGetClassIndex(e) = CI_InlineCode then
   begin
     u := 'hi' + cgt.elGetCodeName(e);
     p := cgt.propToString(cgt.elGetProperty(e,4));
     Replace(p,'HiAsmUnit',u);
     Replace(p,'THiAsmClass','THI' + cgt.elGetCodeName(e));
     List := NewStrList;
     List.Text := p;
     p := cgt.ReadCodeDir(e) + u + '.h';
     List.SaveToFile(p);
     cgt.resAddFile(PChar(p));
     List.Free;
   end
  else if cgt.elGetPropCount(e) > 0 then
   begin
    for j := 0 to cgt.elGetPropCount(e)-1 do
     //if not cgt.elIsDefProp(e,j) then
      begin
        p := SaveParam(cgt,E,cgt.elGetProperty(e,j),true);
        if p <> '' then
         Pr.IBody.Add('   ' + cgt.elGetCodeName(e) + '->' + p + ';');
      end;
    if cgt.elGetFlag(e) and IS_EDIT = IS_EDIT then
      Pr.IBody.Add('   ' + cgt.elGetCodeName(e) + '->Init();' );
   end;
end;

function GetPointCount(cgt:PCodeGenTools; e:cardinal; ptype:byte):integer;
var i:smallint;
begin
   Result := 0;
   for i := 0 to cgt.elGetPtCount(e)-1 do
    if cgt.ptGetType(cgt.elGetPt(e,i)) = PType then
     inc(Result);
end;

procedure MakeMulti(e:id_element; cgt:PCodeGenTools; const CodeName:string;Units,Vars,IBody,Dead:PStrList); cdecl;
var Res:PStrList;
    UnitName,EMN,EMCN:string;
begin
   EMN := cgt.elGetClassName(e);
   EMCN := cgt.elGetCodeName(e);

   Res := NewStrList;
   Res.Add('#ifndef _' + CodeName + '_');
   Res.Add('#define _' + CodeName + '_');
   Res.Add('');
   Res.Add('#include "win.h"');
   Res.AddStrings(Units);
   Res.Add('');
   Res.Add('class TClass' + CodeName);
   Res.Add('{');
   Res.Add(' private:');
   Res.AddStrings(Vars);
   //Res.AddStrings(Head);
   Res.Add(' public:');
   Res.Add('   THI' + EMN + ' *Child;');
   Res.Add('');
   Res.Add('   TClass' + CodeName + '(TWinControl *_Control);');
   Res.Add('   ~TClass' + CodeName + '();');
   //Res.AddStrings(Props);
   Res.Add('};');
   Res.Add('');
   Res.Add('/////////////////////////////////////////////////////////////');
   Res.Add('');
   Res.Add('THI' + EMN + '* Create_hi' + CodeName + '(TWinControl *Control)');
   Res.Add('{');
   Res.Add('  TClass' + CodeName + ' *c = new TClass' + CodeName + '(Control);');
   Res.Add('  return c->Child;');
   Res.Add('}');
   Res.Add('');
   Res.Add('TClass' + CodeName + '::TClass' + CodeName + '(TWinControl *_Control)');
   Res.Add('{');
   Res.AddStrings(IBody);
   Res.Add('   Child = ' + EMCN + ';');
   Res.Add('   ' + EMCN + '->MainClass = this;');
   Res.Add('}');
   Res.Add('');
   Res.Add('TClass' + CodeName + '::~TClass' + CodeName + '()');
   Res.Add('{');
   Res.AddStrings(Dead);
   Res.Add('}');
   Res.Add('');
   Res.Add('#endif');
   //Res.Add(Body);

   UnitName := cgt.ReadCodeDir(e) + 'hi' + CodeName + '.h';
   //cgt._Debug(PChar('Save file: ' + UnitName),clGreen);
   Res.SaveToFile(UnitName);
   cgt.resAddFile(PChar(UnitName));
   Res.free;
end;

function buildProcessProc(var params:TBuildProcessRec):integer; cdecl; forward;
const Names:array[1..4] of PChar = ('_work_','_event_','_var_','_data_');
      MNames:array[1..4] of PChar = ('doWork','Events','getVar','Datas');
      EMNames:array[1..4] of PChar = ('OnEvent','Works','_Data','Vars');
function codePoint(cgt:PCodeGenTools; p:cardinal):string;
var
    e:cardinal;
begin
   e := cgt.ptGetParent(p);
   Result := cgt.elGetCodeName(e) + '->' + Names[cgt.ptGetType(p)] + cgt.ptGetName(p);
   case cgt.elGetClassIndex(e) of
    0:;
    CI_DPElement:
     begin
      //cgt._Debug(PChar('Save file: ' + cgt.pt_dpeGetName(p)),clGreen);
      if Length(cgt.pt_dpeGetName(p)) = 0 then

      else if cgt.ptGetType(p) in [pt_Event,pt_Data] then
        Result := cgt.elGetCodeName(e) + '->' + cgt.pt_dpeGetName(p) + '[' + int2str(cgt.ptGetIndex(p)) + ']'
      else Result := cgt.elGetCodeName(e) + '->' + cgt.pt_dpeGetName(p);
     end;
    CI_MultiElement:
      if cgt.ptGetType(p) in [pt_Event,pt_Data] then
        Result := cgt.elGetCodeName(e) + '->' + MNames[cgt.ptGetType(p)] + '[' + int2str(cgt.ptGetIndex(p)) + ']'
      else Result := cgt.elGetCodeName(e) + '->' + MNames[cgt.ptGetType(p)];
    CI_EditMulti:
      if cgt.ptGetType(p) in [pt_Event,pt_Data] then
        Result := cgt.elGetCodeName(e) + '->' + EMNames[cgt.ptGetType(p)] + '[' + int2str(cgt.ptGetIndex(p)) + ']'
      else Result := cgt.elGetCodeName(e) + '->' + EMNames[cgt.ptGetType(p)];
    CI_InlineCode:
      Result := cgt.elGetCodeName(e) + '->' + cgt.ptGetName(p);
   end;
end;

procedure InitAllPoints(pcr:PCGrec;cgt:PCodeGenTools; e:cardinal);
var i:integer;
    p,lp,sdk,me:cardinal;
    srcname:pchar;
    pr:PCGrec;
    cn:string;
    params:TBuildProcessRec;
begin
   if cgt.elGetClassIndex(e) = CI_MultiElement then
    begin
        if cgt.elLinkIs(e) and(cgt.elLinkMain(e) <> e ) then
          begin
           cn := cgt.elGetCodeName(cgt.elLinkMain(e));
           AddUnit(pcr,'hi' + cn);
          end
        else
         begin
          sdk := cgt.elGetSDK(e);
          IsMulti := true;
          params.sdk := sdk;
          params.cgt := cgt;
          if buildProcessProc(params) <> CG_SUCCESS then exit;
          pr := params.result;
          IsMulti := false;
          me := cgt.sdkGetElement(sdk,0);
          MakeMulti(me,cgt,cgt.elGetCodeName(e),pr.Units,pr.Vars,pr.IBody,pr.Dead);
          AddUnit(pcr,'hi' + cgt.elGetCodeName(e));
          cn :=  cgt.elGetCodeName(e);
         end;

        pcr.IBody.Add('   ' + cgt.elGetCodeName(e) + '->SetCreateProc(Create_hi' + cn + ' );');
        pcr.IBody.Add('   ' + cgt.elGetCodeName(e) + '->SetEvents(' + int2str(GetPointCount(cgt,e,pt_event)) + ');');
        pcr.IBody.Add('   ' + cgt.elGetCodeName(e) + '->SetDatas(' + int2str(GetPointCount(cgt,e,pt_data)) + ');');
    end;

   for i := 0 to cgt.elGetPtCount(e)-1 do
    begin
     p := cgt.elGetPt(e,i);
     lp := cgt.ptGetRLinkPoint(p);
     if(lp > 0)and(cgt.ptGetType(p) in [pt_Event,pt_Data]) then
      begin
       srcname := cgt.elGetCodeName(cgt.ptGetParent(lp));
       pcr.IBody.Add('   ' + codePoint(cgt,p) + ' = _DoEvent(' + srcname + ',' + codePoint(cgt,lp) + ',' + int2str(cgt.ptGetIndex(lp)) + ');');
      end;
    end;
end;

function CheckVersionProc(const params:THiAsmVersion):integer;
begin
  if(params.build >= 162)then
    Result := CG_SUCCESS
  else Result := CG_INVALID_VERSION;
end;

function buildPrepareProc(const params:TBuildPrepareRec):integer; cdecl;
begin
  Result := CG_SUCCESS;
end;

function buildProcessProc(var params:TBuildProcessRec):integer; cdecl;
var i:integer;
    e,eind,sdk:cardinal;

    _Parent,CodeName,s:string;
    res:PCGrec;
    cgt:PCodeGenTools;
begin
  Cgt := params.cgt;
  sdk := params.sdk;

  new(res);
  FillChar(res^,sizeof(TCGrec),0);
  with res^ do
   begin
    Vars := NewStrList;
    Units := NewStrList;
    IBody := NewStrList;
    Dead := NewStrList;
   end;
  Params.result := Res;
  {
  if not reg then
   begin
     cgt._Debug('Unregistered PocketPC version! Please register you version: http://si-tech.ru/hiasm/',clRed);
     Exit;
   end;
  }
  eind := 0;
  for i := 0 to cgt.sdkGetCount(sdk)-1 do
   begin
    e := cgt.sdkGetElement(sdk,i);
    if cgt.elGetFlag(e) and IS_HIDE = 0 then
     begin
      CodeName := cgt.elGetClassName(e) + '_' + Int2Hex(e,6);
      cgt.elSetCodeName(e,PChar(CodeName));

      if cgt.elGetFlag(e) and IS_PARENT = IS_PARENT then
        begin
          _Parent := CodeName;
          eind := e;
        end;
      case cgt.elGetClassIndex(e) of
       CI_InlineCode: s := CodeName;
       else s := cgt.elGetClassName(e)
      end;
      Res.Vars.Add('   THI' + s + ' *' + CodeName + ';');
      AddUnit(Res,'hi' + s);
    end;
   end;

   if eind > 0 then
    begin
      if cgt.elGetFlag(eind) and IS_EDIT = IS_EDIT then
        if IsMulti then
          s := '_Control'
        else s := 'NULL'
      else  s := '';
      Res.IBody.Add('   ' + _Parent + ' = new THI' + cgt.elGetClassName(eind) + '(' + s + ');');
      SetPropertys(Res,cgt,eind);
    end
   else _Parent := 'NULL';

   for i := 0 to cgt.sdkGetCount(sdk)-1 do
    begin
     e := cgt.sdkGetElement(sdk,i);
     if(e <> eind)and(cgt.elGetFlag(e) and IS_HIDE = 0) then
      begin
        case cgt.elGetClassIndex(e) of
         CI_InlineCode: s := 'THI' + cgt.elGetCodeName(e);
         else s := 'THI' + cgt.elGetClassName(e)
        end;

        if(cgt.elGetInfSub(e) = 'Form')or(cgt.elGetFlag(e) and IS_EDIT = IS_EDIT) then
         Res.IBody.Add( '   ' + cgt.elGetCodeName(e) + ' = new ' + s + '(' + _Parent + '->Control );')
        else
         Res.IBody.Add( '   ' + cgt.elGetCodeName(e) + ' = new ' + s + '();');
      end;
    end;

   for i := cgt.sdkGetCount(sdk)-1 downto 0 do
    begin
     e := cgt.sdkGetElement(sdk,i);
     if(cgt.elGetFlag(e) and IS_HIDE = 0) then
      begin
       if(e <> eind)then
        SetPropertys(Res,cgt,e);
       InitAllPoints(Res,cgt,e);
      end;
    end;


   for i := 0 to cgt.sdkGetCount(sdk)-1 do
    begin
     e := cgt.sdkGetElement(sdk,i);
     if(e <> eind)and(cgt.elGetFlag(e) and IS_HIDE = 0) then
      begin
        Res.Dead.Add( '   delete ' + cgt.elGetCodeName(e) + ';');
        //cgt.elSetCodeName(e,'');
      end;
    end;

   if eind > 0 then
    begin
      Res.Dead.Add( '   delete ' + cgt.elGetCodeName(eind) + ';');
      //cgt.elSetCodeName(eind,'');
    end;

   //MessageBox(0,'ok2','',mb_ok);
   Res.MainForm := _parent;

  Result := CG_SUCCESS;
end;

procedure ConfToCode(const Pack,UName:string);
begin
  // for future used...
end;

exports
  buildPrepareProc,
  buildProcessProc,
  CheckVersionProc,
  ConfToCode;
{
var k:HKEY;
    val:string;
    i,p:integer;
}
begin
  {k := RegKeyOpenRead(HKEY_CURRENT_USER,'Software\HiAsm\PocketPC');
  Val := RegKeyGetStr(k,'') + '214';
  reg := false;
  p := 0;
  for i := 1 to Length(val) do
    p := p + ord(val[i]) - ord('0');
  while p > 10 do dec(p,10);
  reg := p = (ord(val[1]) - ord('0'));
  RegKeyClose(k);
  }
end.
