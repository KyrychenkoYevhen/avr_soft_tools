library make_exe;

uses
  Windows,
  kol,
  CGTShare in '..\..\CGTShare.pas';

type
  TCGrec = record
    MainForm:string;
    Vars,Units,IBody,Dead:PStrList;
  end;
  PCGrec = ^TCGrec;

function buildGetParamsProc(var params:TBuildParams):integer; cdecl;
begin
  params.flags := 0;
  Result := CG_SUCCESS;
end;

function buildMakePrj(const params:TBuildMakePrjRec):integer; cdecl;
var Res:PStrList;
    P:PCGrec;
begin
   p := params.result;
   Res := NewStrList;
   Res.Add('#include "share.h"');
   Res.AddStrings(p.Units);
   Res.Add('');
   Res.Add('class TClass' + p.MainForm);
   Res.Add('{');
   Res.Add('   public:');
   Res.AddStrings(p.Vars);
   Res.Add('');
   Res.Add('   TClass' + p.MainForm + '();');
   Res.Add('   ~TClass' + p.MainForm + '();');
   Res.Add('} *ClassMain;');
   Res.Add('');
   Res.Add('TClass' + p.MainForm + '::TClass' + p.MainForm + '()');
   Res.Add('{');
   Res.AddStrings(p.IBody);
   Res.Add('}');
   Res.Add('');
   Res.Add('TClass' + p.MainForm + '::~TClass' + p.MainForm + '()');
   Res.Add('{');
   Res.AddStrings(p.Dead);
   Res.Add('}');
   Res.Add('');
   Res.Add('');
   Res.Add('int WINAPI WinMain(HINSTANCE _hInstance,HINSTANCE hPrevInstance,USHORT *lpCmdLine,int nCmdShow)');
   Res.Add('{');
   Res.Add('  hInstance = _hInstance;');
   Res.Add('  //if( lpCmdLine == "/i" )');
   Res.Add('  //{');
   Res.Add('  //  MessageBox(NULL,L"This program made by HiAsm.","HiAsm Info",MB_OK);');
   Res.Add('  //  exit(0);');
   Res.Add('  //}');

   Res.Add('  ClassMain = new TClass' + p.MainForm + '();');
   Res.Add('  ClassMain->' + p.MainForm + '->Start();');
   Res.Add('  delete ClassMain;');
   Res.Add('  return 0;');
   Res.Add('}');

   Res.SaveToFile(params.prjFilename);
   Res.free;
   
   Result := CG_SUCCESS;
end;

function buildCompliteProc(const params:TBuildCompliteRec):integer; cdecl;
var src:string;
begin
  src := ExtractFilePath(params.prjFilename) + ExtractFileNameWOext(params.prjFilename) + '.exe';
  MoveFile(PChar(src), PChar(params.appFilename));
  Result := CG_SUCCESS;
end;

exports
    buildGetParamsProc,
    buildMakePrj,
    buildCompliteProc;

begin
end.

 