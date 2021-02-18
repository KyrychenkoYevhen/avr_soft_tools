#include "windows.h"

class TIniFile
{
private:
	char *FName;
public:
	char *Section;

	TIniFile(char *FileName){ FName = FileName; }
	void WriteStr(char *key,char *str)
	{
		WritePrivateProfileString(Section,key,str,FName);
	}
	char *ReadStr(char *key,char *Def)
	{
		char Result[2048];
		Result[0] = 0;
		GetPrivateProfileString(Section,key,Def,Result,sizeof(Result),FName);
		return Result;
	}
	void WriteInt(char *key,int Value)
	{
		char val[10];
		itoa(Value,val,10);
		WriteStr(key,val);
	}
	int ReadInt(char *key,int Def)
	{
		return GetPrivateProfileInt(Section,key,Def,FName);
	}
};

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
