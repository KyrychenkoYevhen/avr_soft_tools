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
/*++


Module Name:

    pshpack8.h

Abstract:

    This file turns 8 byte packing of structures on.  (That is, it disables
    automatic alignment of structure fields.)  An include file is needed
    because various compilers do this in different ways.  For Microsoft
    compatible compilers, this files uses the push option to the pack pragma
    so that the poppack.h include file can restore the previous packing
    reliably.

    The file poppack.h is the complement to this file.

--*/

#if ! (defined(lint) || defined(_lint) || defined(RC_INVOKED))
#if ( _MSC_VER >= 800 )
#pragma warning(disable:4103)
#if !(defined( MIDL_PASS )) || defined( __midl )
#pragma pack(push)
#endif
#pragma pack(8)
#else
#pragma pack(8)
#endif
#endif // ! (defined(lint) || defined(_lint) || defined(RC_INVOKED))
