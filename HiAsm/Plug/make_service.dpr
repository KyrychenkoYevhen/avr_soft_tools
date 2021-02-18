library make_service;

uses
  kol;

type
  TCGrec = record
    MainForm:string;
    Vars,Units,IBody,Dead:PStrList;
  end;
  PCGrec = ^TCGrec;

//procedure Run(MainForm,Units,Vars,OldBody,Dead, Body,Props,Head,FileName:PChar); cdecl;
procedure Run(P:PCGrec; FileName:PChar ); cdecl;
var Res:PStrList;
    i:integer;
begin
   Res := NewStrList;
   Res.Add('Program HiAsm;');
   Res.Add('{$ifdef F_P} {$APPTYPE GUI} {$endif}');
   Res.Add('{$R allres.res}');
   Res.Add('uses ');
   for i := 0 to p.Units.Count-1 do
     Res.Add('   ' + p.Units.Items[i] + ',');
   Res.Add('  kol,Share;');     
   Res.Add('');
   Res.Add('type');
   Res.Add('  TClass' + p.MainForm + ' = class');
   Res.Add('   public');
   Res.AddStrings(p.Vars);
   Res.Add('   constructor Create;');
   Res.Add('   destructor Destroy; override;');
   //Res.Add(Head);
   //Res.Add(Props);
   Res.Add('  end;');
   Res.Add('var');
   Res.Add('  ClassMain:TClass' + p.MainForm + ';');
   Res.Add('  Msg:TMsg;');
   Res.Add('');
   Res.Add('constructor TClass' + p.MainForm + '.Create;');
   Res.Add('begin');
   Res.Add('  inherited;');
   Res.AddStrings(p.IBody);
   Res.Add('end;');
   Res.Add('');
   Res.Add('destructor TClass' + p.MainForm + '.Destroy;');
   Res.Add('begin');
   Res.AddStrings(p.Dead);
   Res.Add('  inherited;');
   Res.Add('end;');
   Res.Add('');
   //Res.Add(Body);
   Res.Add('begin');

   Res.Add('if ParamStr(1) = ''/i'' then');
   Res.Add('  begin');
   Res.Add('     MessageBox(0,''This program made by HiAsm.'',''HiAsm Info'',MB_OK);');
   Res.Add('     Halt;');
   Res.Add('  end;');

   Res.Add('  ClassMain := TClass' + p.MainForm + '.Create;');
   Res.Add('  ClassMain.' + p.MainForm + '.Start;');
   Res.Add(' if ClassMain.' + p.MainForm + '._prop_Wait = 0 then');
   Res.Add('  while GetMessage( Msg,0, 0, 0 ) and not ClassMain.' + p.MainForm + '.SStop do');
   Res.Add('   begin');
   Res.Add('    TranslateMessage( Msg );');
   Res.Add('    DispatchMessage( Msg );');
   Res.Add('   end;');
   Res.Add('  ClassMain.' + p.MainForm + '.Stop;');
   Res.Add('  ClassMain.Destroy;');
   Res.Add('end.');

   Res.SaveToFile(FileName);
   Res.free;
end;

procedure EndBuild(FileName:PChar); cdecl;
begin
end;

exports
    Run,
    EndBuild;

begin
end.
 