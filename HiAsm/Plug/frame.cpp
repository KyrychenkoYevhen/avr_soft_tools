#include <windows.h>


#ifdef __cplusplus 
#define EXPORT extern "C" __declspec (dllexport)
#else 
#define EXPORT __declspec (dllexport)
#endif 

HBRUSH br;
HPEN Pen[5];
HPEN BlackPen;

void FrameDots(RECT &r,HDC DC)
{
	SetBkMode(DC,TRANSPARENT);
	SetTextColor(DC,0);
	DrawFocusRect(DC,&r);
}

void FrameClear(RECT &r,HDC DC)
{
}

void FrameLine(RECT &r,HDC DC)
{
	static bool Init = false;
	if( !Init )
	{
		Init = true;
		BlackPen = CreatePen(0,1,0);
	}
	SelectObject(DC,BlackPen);
	SelectObject(DC,br);
	Rectangle(DC,r.left,r.top,r.right,r.bottom);
}

void FrameGradient(RECT &r,HDC DC)
{
	static bool Init = false;

	if( !Init )
	{
		Init = true;
		for(int i = 0; i < 5; i++)
			Pen[i] = CreatePen(0,1,RGB(100 + i*15,100 + i*15,100 + i*15));
	}
	SelectObject(DC,br);
	for(int i = 0; i < 5; i++)
	{
		SelectObject(DC,Pen[i]);
		Rectangle(DC,r.left + i,r.top + i,r.right - i,r.bottom - i);
	}
}

EXPORT __cdecl void FrameProc(BYTE Index, RECT &r,HDC DC)
{
	switch( Index )
	{
		case 0: FrameDots(r,DC); break;
		case 1: FrameClear(r,DC); break;
		case 2: FrameLine(r,DC); break;
		case 3: FrameGradient(r,DC);
	}
}

BOOL APIENTRY DllMain(HINSTANCE hModule,DWORD ul_reason_for_call,LPVOID lpReserved)
{
	br = (HBRUSH)GetStockObject(NULL_BRUSH);
	return true;
}