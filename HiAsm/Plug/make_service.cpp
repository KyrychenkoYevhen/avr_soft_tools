#include <windows.h>
#include <stdio.h>

#ifdef __cplusplus 
#define EXPORT extern "C" __declspec (dllexport)
#else 
#define EXPORT __declspec (dllexport)
#endif 

EXPORT __cdecl void Run(char *MainForm,char *Units,char *Vars,char *OldBody,char *Dead,char *Body,char *Props,char *Head,char *FileName)
{
	FILE *f = fopen(FileName,"w");
	fputs("Program HiAsm;\n",f);
	fputs("{$ifdef F_P} {$APPTYPE GUI} {$endif}\n",f);
	fputs("{$include hi_exe.def}\n",f);
	fprintf(f,"uses %s;\n",Units);
	fputs("\n",f);
	fputs("type\n",f);
	fprintf(f,"  TClass%s = class\n",MainForm);
	fputs("   public\n",f);
	fputs(Vars,f);
	fputs("   constructor Create;\n",f);
	fputs("   destructor Destroy; override;\n",f);
	fputs(Head,f);
	fputs(Props,f);
	fputs("  end;\n",f);
	fputs("var\n",f);
	fprintf(f,"  ClassMain:TClass%s;\n",MainForm);
	fputs("  Msg:TMsg;\n",f);
	fputs("\n",f);
	fprintf(f,"constructor TClass%s.Create;\n",MainForm);
	fputs("begin\n",f);
	fputs("  inherited;\n",f);
	fputs(OldBody,f);
	fputs("end;\n",f);
	fputs("\n",f);
	fprintf(f,"destructor TClass%s.Destroy;\n",MainForm);
	fputs("begin\n",f);
	fputs(Dead,f);
	fputs("  inherited;\n",f);
	fputs("end;\n",f);
	fputs("",f);
	fputs(Body,f);
	fputs("begin\n",f);

	fputs("\nif ParamStr(1) = '/i' then\n",f);
	fputs("  begin\n",f);
	fputs("     MessageBox(0,'This program made by HiAsm.','HiAsm Info',MB_OK);\n",f);
	fputs("     Halt;\n",f);
	fputs("  end;\n",f);

	fprintf(f,"  ClassMain := TClass%s.Create;\n",MainForm);
	fprintf(f,"  ClassMain.%s.Start;\n",MainForm);
	fprintf(f," if ClassMain.%s._prop_Wait = 0 then\n",MainForm);
	fprintf(f,"  while GetMessage( Msg,0, 0, 0 ) and not ClassMain.%s.SStop do\n",MainForm);
	fputs("   begin\n",f);
	fputs("    TranslateMessage( Msg );\n",f);
	fputs("    DispatchMessage( Msg );\n",f);
	fputs("   end;\n",f);
	fprintf(f,"  ClassMain.%s.Stop;\n",MainForm);
	fputs("  ClassMain.Destroy;\n",f);
	fputs("end.\n",f);
	fclose(f);
}

EXPORT __cdecl void EndBuild(char *FileName)
{
	
}

BOOL APIENTRY DllMain(HINSTANCE hModule,DWORD ul_reason_for_call,LPVOID lpReserved)
{
	return true;
}