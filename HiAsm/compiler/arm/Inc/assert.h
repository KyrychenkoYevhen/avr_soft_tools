//
// Copyright (c) Microsoft Corporation.  All rights reserved.
//
//
// Use of this source code is subject to the terms of the Microsoft end-user
// license agreement (EULA) under which you licensed this SOFTWARE PRODUCT.
// If you did not accept the terms of the EULA, you are not authorized to use
// this source code. For a copy of the EULA, please see the LICENSE.RTF on your
// install media.
//
/****
*
* assert.h - define the assert macro
*
* Purpose:
*	Defines the assert(exp) macro.
*	If the DEBUG compiler directive is set, assert(exp) where exp
*	evaluates to a false condition will result in a debug message
*	being printed to the debug console, followed by a DebugBreak().
*	The debug message will be in the form:
*
*	*** ASSERTION FAILED in <file>(<line>):
*	<expression>
*
* Note:
* 	If the DEBUG directive is set, winbase.h will be included
* 	by this file.
*
****/

#ifndef _INC_ASSERT
#define _INC_ASSERT

#ifndef _CRTIMP
#ifdef CRTDLL
#define _CRTIMP __declspec(dllexport)
#else  /* CRTDLL */
#ifdef _DLL
#define _CRTIMP __declspec(dllimport)
#else  /* _DLL */
#define _CRTIMP
#endif  /* _DLL */
#endif  /* CRTDLL */
#endif  /* _CRTIMP */

/* Define __cdecl for non-Microsoft compilers */

#if (!defined (_MSC_VER) && !defined (__cdecl))
#define __cdecl
#endif  /* (!defined (_MSC_VER) && !defined (__cdecl)) */

/* If DEBUG is not defined, make sure NDEBUG is defined */
#ifndef DEBUG
#ifndef NDEBUG
#define NDEBUG
#endif /* NDEBUG */
#endif /* DEBUG */

#ifdef NDEBUG

#define assert(exp)	((void)0)

#else /* NDEBUG */

#include <winbase.h>
/* Multi-level macro needed to launder __LINE__ */
#define ASSERT_PRINT(exp,file,line) OutputDebugStringW(TEXT("\r\n*** ASSERTION FAILED in ") TEXT(file) TEXT("(") TEXT(#line) TEXT("):\r\n") TEXT(#exp) TEXT("\r\n"))
#define ASSERT_AT(exp,file,line) (void)( (exp) || (ASSERT_PRINT(exp,file,line), DebugBreak(), 0 ) )
#define assert(exp) ASSERT_AT(exp,__FILE__,__LINE__)

#endif /* NDEBUG */

#endif /* _INC_ASSERT */
