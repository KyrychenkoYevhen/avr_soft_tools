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

#ifndef __WINDOWS__
#define __WINDOWS__

#ifdef SHx
#pragma warning(disable:4710)
#endif

#include <windef.h>
#include <types.h>
#include <winbase.h>
#include <wingdi.h>
#include <winuser.h>
#include <winreg.h>
#include <shellapi.h>
#ifndef WINCEMACRO
#include <ole2.h>
#endif

#include <imm.h>

#include <tchar.h>
#include <excpt.h>

#endif

