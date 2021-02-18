
#pragma warning( disable: 4049 )  /* more than 64k source lines */

/* this ALWAYS GENERATED file contains the definitions for the interfaces */


 /* File created by MIDL compiler version 5.03.0279 */
/* at Thu Dec 13 20:39:52 2001
 */
/* Compiler settings for .\shobjidl.idl:
    Oicf (OptLev=i2), W1, Zp8, env=Win32 (32b run), ms_ext, c_ext
    error checks: allocation ref bounds_check enum stub_data 
    VC __declspec() decoration level: 
         __declspec(uuid()), __declspec(selectany), __declspec(novtable)
         DECLSPEC_UUID(), MIDL_INTERFACE()
*/
//@@MIDL_FILE_HEADING(  )


/* verify that the <rpcndr.h> version is high enough to compile this file*/
#ifndef __REQUIRED_RPCNDR_H_VERSION__
#define __REQUIRED_RPCNDR_H_VERSION__ 440
#endif

#include "rpc.h"
#include "rpcndr.h"

#ifndef __RPCNDR_H_VERSION__
#error this stub requires an updated version of <rpcndr.h>
#endif // __RPCNDR_H_VERSION__

#ifndef COM_NO_WINDOWS_H
#include "windows.h"
#include "ole2.h"
#endif /*COM_NO_WINDOWS_H*/

#ifndef __shobjidl_h__
#define __shobjidl_h__

/* Forward Declarations */ 

#ifndef __IPersistFolder_FWD_DEFINED__
#define __IPersistFolder_FWD_DEFINED__
typedef interface IPersistFolder IPersistFolder;
#endif 	/* __IPersistFolder_FWD_DEFINED__ */


#ifndef __IPersistFolder2_FWD_DEFINED__
#define __IPersistFolder2_FWD_DEFINED__
typedef interface IPersistFolder2 IPersistFolder2;
#endif 	/* __IPersistFolder2_FWD_DEFINED__ */


#ifndef __IPersistIDList_FWD_DEFINED__
#define __IPersistIDList_FWD_DEFINED__
typedef interface IPersistIDList IPersistIDList;
#endif 	/* __IPersistIDList_FWD_DEFINED__ */


#ifndef __IEnumIDList_FWD_DEFINED__
#define __IEnumIDList_FWD_DEFINED__
typedef interface IEnumIDList IEnumIDList;
#endif 	/* __IEnumIDList_FWD_DEFINED__ */


#ifndef __IShellFolder_FWD_DEFINED__
#define __IShellFolder_FWD_DEFINED__
typedef interface IShellFolder IShellFolder;
#endif 	/* __IShellFolder_FWD_DEFINED__ */


#ifndef __IEnumExtraSearch_FWD_DEFINED__
#define __IEnumExtraSearch_FWD_DEFINED__
typedef interface IEnumExtraSearch IEnumExtraSearch;
#endif 	/* __IEnumExtraSearch_FWD_DEFINED__ */


#ifndef __IShellFolder2_FWD_DEFINED__
#define __IShellFolder2_FWD_DEFINED__
typedef interface IShellFolder2 IShellFolder2;
#endif 	/* __IShellFolder2_FWD_DEFINED__ */


#ifndef __IShellView_FWD_DEFINED__
#define __IShellView_FWD_DEFINED__
typedef interface IShellView IShellView;
#endif 	/* __IShellView_FWD_DEFINED__ */


#ifndef __IShellView2_FWD_DEFINED__
#define __IShellView2_FWD_DEFINED__
typedef interface IShellView2 IShellView2;
#endif 	/* __IShellView2_FWD_DEFINED__ */


#ifndef __IShellBrowser_FWD_DEFINED__
#define __IShellBrowser_FWD_DEFINED__
typedef interface IShellBrowser IShellBrowser;
#endif 	/* __IShellBrowser_FWD_DEFINED__ */


#ifndef __IShellNetCrawler_FWD_DEFINED__
#define __IShellNetCrawler_FWD_DEFINED__
typedef interface IShellNetCrawler IShellNetCrawler;
#endif 	/* __IShellNetCrawler_FWD_DEFINED__ */


#ifndef __IProfferService_FWD_DEFINED__
#define __IProfferService_FWD_DEFINED__
typedef interface IProfferService IProfferService;
#endif 	/* __IProfferService_FWD_DEFINED__ */


#ifndef __ICompositeFolder_FWD_DEFINED__
#define __ICompositeFolder_FWD_DEFINED__
typedef interface ICompositeFolder ICompositeFolder;
#endif 	/* __ICompositeFolder_FWD_DEFINED__ */


#ifndef __IFolderAndItem_FWD_DEFINED__
#define __IFolderAndItem_FWD_DEFINED__
typedef interface IFolderAndItem IFolderAndItem;
#endif 	/* __IFolderAndItem_FWD_DEFINED__ */


#ifndef __IPropertyUI_FWD_DEFINED__
#define __IPropertyUI_FWD_DEFINED__
typedef interface IPropertyUI IPropertyUI;
#endif 	/* __IPropertyUI_FWD_DEFINED__ */


#ifndef __CompositeFolder_FWD_DEFINED__
#define __CompositeFolder_FWD_DEFINED__

#ifdef __cplusplus
typedef class CompositeFolder CompositeFolder;
#else
typedef struct CompositeFolder CompositeFolder;
#endif /* __cplusplus */

#endif 	/* __CompositeFolder_FWD_DEFINED__ */


#ifndef __ImageProperties_FWD_DEFINED__
#define __ImageProperties_FWD_DEFINED__

#ifdef __cplusplus
typedef class ImageProperties ImageProperties;
#else
typedef struct ImageProperties ImageProperties;
#endif /* __cplusplus */

#endif 	/* __ImageProperties_FWD_DEFINED__ */


#ifndef __PropertiesUI_FWD_DEFINED__
#define __PropertiesUI_FWD_DEFINED__

#ifdef __cplusplus
typedef class PropertiesUI PropertiesUI;
#else
typedef struct PropertiesUI PropertiesUI;
#endif /* __cplusplus */

#endif 	/* __PropertiesUI_FWD_DEFINED__ */


/* header files for imported files */
#include "objidl.h"
#include "oleidl.h"
#include "oaidl.h"
#include "shtypes.h"
#include "servprov.h"

#ifdef __cplusplus
extern "C"{
#endif 

void __RPC_FAR * __RPC_USER MIDL_user_allocate(size_t);
void __RPC_USER MIDL_user_free( void __RPC_FAR * ); 

/* interface __MIDL_itf_shobjidl_0000 */
/* [local] */ 

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
#ifndef _WINRESRC_
#ifndef _WIN32_IE
#define _WIN32_IE 0x0501
#else
#if (_WIN32_IE < 0x0400) && defined(_WIN32_WINNT) && (_WIN32_WINNT >= 0x0500)
#error _WIN32_IE setting conflicts with _WIN32_WINNT setting
#endif
#endif
#endif
//===========================================================================
//
// IPersistFolder Interface
//
//  The IPersistFolder interface is used by the file system implementation of
// IShellFolder::BindToObject when it is initializing a shell folder object.
//
//
// [Member functions]
//
// IPersistFolder::Initialize
//
//  This member function is called when the explorer is initializing a
// shell folder object.
//
//  Parameters:
//   pidl -- Specifies the absolute location of the folder.
//
//===========================================================================


extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0000_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0000_v0_0_s_ifspec;

#ifndef __IPersistFolder_INTERFACE_DEFINED__
#define __IPersistFolder_INTERFACE_DEFINED__

/* interface IPersistFolder */
/* [unique][uuid][object] */ 


EXTERN_C const IID IID_IPersistFolder;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("000214EA-0000-0000-C000-000000000046")
    IPersistFolder : public IPersist
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE Initialize( 
            /* [in] */ LPCITEMIDLIST pidl) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct IPersistFolderVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *QueryInterface )( 
            IPersistFolder __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppvObject);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *AddRef )( 
            IPersistFolder __RPC_FAR * This);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *Release )( 
            IPersistFolder __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetClassID )( 
            IPersistFolder __RPC_FAR * This,
            /* [out] */ CLSID __RPC_FAR *pClassID);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Initialize )( 
            IPersistFolder __RPC_FAR * This,
            /* [in] */ LPCITEMIDLIST pidl);
        
        END_INTERFACE
    } IPersistFolderVtbl;

    interface IPersistFolder
    {
        CONST_VTBL struct IPersistFolderVtbl __RPC_FAR *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IPersistFolder_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define IPersistFolder_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define IPersistFolder_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define IPersistFolder_GetClassID(This,pClassID)	\
    (This)->lpVtbl -> GetClassID(This,pClassID)


#define IPersistFolder_Initialize(This,pidl)	\
    (This)->lpVtbl -> Initialize(This,pidl)

#endif /* COBJMACROS */


#endif 	/* C style interface */



HRESULT STDMETHODCALLTYPE IPersistFolder_Initialize_Proxy( 
    IPersistFolder __RPC_FAR * This,
    /* [in] */ LPCITEMIDLIST pidl);


void __RPC_STUB IPersistFolder_Initialize_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif 	/* __IPersistFolder_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_shobjidl_0111 */
/* [local] */ 

typedef IPersistFolder __RPC_FAR *LPPERSISTFOLDER;

#if (_WIN32_IE >= 0x0400)


extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0111_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0111_v0_0_s_ifspec;

#ifndef __IPersistFolder2_INTERFACE_DEFINED__
#define __IPersistFolder2_INTERFACE_DEFINED__

/* interface IPersistFolder2 */
/* [unique][uuid][object] */ 


EXTERN_C const IID IID_IPersistFolder2;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("1AC3D9F0-175C-11d1-95BE-00609797EA4F")
    IPersistFolder2 : public IPersistFolder
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE GetCurFolder( 
            /* [out] */ LPITEMIDLIST __RPC_FAR *ppidl) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct IPersistFolder2Vtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *QueryInterface )( 
            IPersistFolder2 __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppvObject);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *AddRef )( 
            IPersistFolder2 __RPC_FAR * This);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *Release )( 
            IPersistFolder2 __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetClassID )( 
            IPersistFolder2 __RPC_FAR * This,
            /* [out] */ CLSID __RPC_FAR *pClassID);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Initialize )( 
            IPersistFolder2 __RPC_FAR * This,
            /* [in] */ LPCITEMIDLIST pidl);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetCurFolder )( 
            IPersistFolder2 __RPC_FAR * This,
            /* [out] */ LPITEMIDLIST __RPC_FAR *ppidl);
        
        END_INTERFACE
    } IPersistFolder2Vtbl;

    interface IPersistFolder2
    {
        CONST_VTBL struct IPersistFolder2Vtbl __RPC_FAR *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IPersistFolder2_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define IPersistFolder2_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define IPersistFolder2_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define IPersistFolder2_GetClassID(This,pClassID)	\
    (This)->lpVtbl -> GetClassID(This,pClassID)


#define IPersistFolder2_Initialize(This,pidl)	\
    (This)->lpVtbl -> Initialize(This,pidl)


#define IPersistFolder2_GetCurFolder(This,ppidl)	\
    (This)->lpVtbl -> GetCurFolder(This,ppidl)

#endif /* COBJMACROS */


#endif 	/* C style interface */



HRESULT STDMETHODCALLTYPE IPersistFolder2_GetCurFolder_Proxy( 
    IPersistFolder2 __RPC_FAR * This,
    /* [out] */ LPITEMIDLIST __RPC_FAR *ppidl);


void __RPC_STUB IPersistFolder2_GetCurFolder_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif 	/* __IPersistFolder2_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_shobjidl_0112 */
/* [local] */ 

typedef IPersistFolder2 __RPC_FAR *LPPERSISTFOLDER2;

#endif


extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0112_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0112_v0_0_s_ifspec;

#ifndef __IPersistIDList_INTERFACE_DEFINED__
#define __IPersistIDList_INTERFACE_DEFINED__

/* interface IPersistIDList */
/* [unique][uuid][object] */ 


EXTERN_C const IID IID_IPersistIDList;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("1079acfc-29bd-11d3-8e0d-00c04f6837d5")
    IPersistIDList : public IPersist
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE LoadIDList( 
            /* [in] */ LPCITEMIDLIST pidl) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE SaveIDList( 
            /* [out] */ LPITEMIDLIST __RPC_FAR *ppidl) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct IPersistIDListVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *QueryInterface )( 
            IPersistIDList __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppvObject);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *AddRef )( 
            IPersistIDList __RPC_FAR * This);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *Release )( 
            IPersistIDList __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetClassID )( 
            IPersistIDList __RPC_FAR * This,
            /* [out] */ CLSID __RPC_FAR *pClassID);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *LoadIDList )( 
            IPersistIDList __RPC_FAR * This,
            /* [in] */ LPCITEMIDLIST pidl);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *SaveIDList )( 
            IPersistIDList __RPC_FAR * This,
            /* [out] */ LPITEMIDLIST __RPC_FAR *ppidl);
        
        END_INTERFACE
    } IPersistIDListVtbl;

    interface IPersistIDList
    {
        CONST_VTBL struct IPersistIDListVtbl __RPC_FAR *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IPersistIDList_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define IPersistIDList_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define IPersistIDList_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define IPersistIDList_GetClassID(This,pClassID)	\
    (This)->lpVtbl -> GetClassID(This,pClassID)


#define IPersistIDList_LoadIDList(This,pidl)	\
    (This)->lpVtbl -> LoadIDList(This,pidl)

#define IPersistIDList_SaveIDList(This,ppidl)	\
    (This)->lpVtbl -> SaveIDList(This,ppidl)

#endif /* COBJMACROS */


#endif 	/* C style interface */



HRESULT STDMETHODCALLTYPE IPersistIDList_LoadIDList_Proxy( 
    IPersistIDList __RPC_FAR * This,
    /* [in] */ LPCITEMIDLIST pidl);


void __RPC_STUB IPersistIDList_LoadIDList_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IPersistIDList_SaveIDList_Proxy( 
    IPersistIDList __RPC_FAR * This,
    /* [out] */ LPITEMIDLIST __RPC_FAR *ppidl);


void __RPC_STUB IPersistIDList_SaveIDList_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif 	/* __IPersistIDList_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_shobjidl_0113 */
/* [local] */ 

//-------------------------------------------------------------------------
//
// IEnumIDList interface
//
//  IShellFolder::EnumObjects member returns an IEnumIDList object.
//
//-------------------------------------------------------------------------



extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0113_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0113_v0_0_s_ifspec;

#ifndef __IEnumIDList_INTERFACE_DEFINED__
#define __IEnumIDList_INTERFACE_DEFINED__

/* interface IEnumIDList */
/* [unique][object][uuid][helpstring] */ 


EXTERN_C const IID IID_IEnumIDList;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("000214F2-0000-0000-C000-000000000046")
    IEnumIDList : public IUnknown
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE Next( 
            /* [in] */ ULONG celt,
            /* [length_is][size_is][out] */ LPITEMIDLIST __RPC_FAR *rgelt,
            /* [out] */ ULONG __RPC_FAR *pceltFetched) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE Skip( 
            /* [in] */ ULONG celt) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE Reset( void) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE Clone( 
            /* [out] */ IEnumIDList __RPC_FAR *__RPC_FAR *ppenum) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct IEnumIDListVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *QueryInterface )( 
            IEnumIDList __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppvObject);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *AddRef )( 
            IEnumIDList __RPC_FAR * This);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *Release )( 
            IEnumIDList __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Next )( 
            IEnumIDList __RPC_FAR * This,
            /* [in] */ ULONG celt,
            /* [length_is][size_is][out] */ LPITEMIDLIST __RPC_FAR *rgelt,
            /* [out] */ ULONG __RPC_FAR *pceltFetched);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Skip )( 
            IEnumIDList __RPC_FAR * This,
            /* [in] */ ULONG celt);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Reset )( 
            IEnumIDList __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Clone )( 
            IEnumIDList __RPC_FAR * This,
            /* [out] */ IEnumIDList __RPC_FAR *__RPC_FAR *ppenum);
        
        END_INTERFACE
    } IEnumIDListVtbl;

    interface IEnumIDList
    {
        CONST_VTBL struct IEnumIDListVtbl __RPC_FAR *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IEnumIDList_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define IEnumIDList_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define IEnumIDList_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define IEnumIDList_Next(This,celt,rgelt,pceltFetched)	\
    (This)->lpVtbl -> Next(This,celt,rgelt,pceltFetched)

#define IEnumIDList_Skip(This,celt)	\
    (This)->lpVtbl -> Skip(This,celt)

#define IEnumIDList_Reset(This)	\
    (This)->lpVtbl -> Reset(This)

#define IEnumIDList_Clone(This,ppenum)	\
    (This)->lpVtbl -> Clone(This,ppenum)

#endif /* COBJMACROS */


#endif 	/* C style interface */



HRESULT STDMETHODCALLTYPE IEnumIDList_Next_Proxy( 
    IEnumIDList __RPC_FAR * This,
    /* [in] */ ULONG celt,
    /* [length_is][size_is][out] */ LPITEMIDLIST __RPC_FAR *rgelt,
    /* [out] */ ULONG __RPC_FAR *pceltFetched);


void __RPC_STUB IEnumIDList_Next_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IEnumIDList_Skip_Proxy( 
    IEnumIDList __RPC_FAR * This,
    /* [in] */ ULONG celt);


void __RPC_STUB IEnumIDList_Skip_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IEnumIDList_Reset_Proxy( 
    IEnumIDList __RPC_FAR * This);


void __RPC_STUB IEnumIDList_Reset_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IEnumIDList_Clone_Proxy( 
    IEnumIDList __RPC_FAR * This,
    /* [out] */ IEnumIDList __RPC_FAR *__RPC_FAR *ppenum);


void __RPC_STUB IEnumIDList_Clone_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif 	/* __IEnumIDList_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_shobjidl_0114 */
/* [local] */ 

typedef IEnumIDList __RPC_FAR *LPENUMIDLIST;

//-------------------------------------------------------------------------
//
// IShellFolder interface
//
//
// [Member functions]
//
// IShellFolder::BindToObject(pidl, pbc, riid, ppv)
//   This function returns an instance of a sub-folder which is specified
//  by the IDList (pidl).
//
// IShellFolder::BindToStorage(pidl, pbc, riid, ppv)
//   This function returns a storage instance of a sub-folder which is
//  specified by the IDList (pidl). The shell never calls this member
//  function in the first release of Win95.
//
// IShellFolder::CompareIDs(lParam, pidl1, pidl2)
//   This function compares two IDLists and returns the result. The shell
//  explorer always passes 0 as lParam, which indicates 'sort by name'.
//  It should return 0 (as CODE of the scode), if two id indicates the
//  same object; negative value if pidl1 should be placed before pidl2;
//  positive value if pidl2 should be placed before pidl1.
//
// IShellFolder::CreateViewObject(hwndOwner, riid, ppv)
//   This function creates a view object of the folder itself. The view
//  object is a difference instance from the shell folder object.
//   'hwndOwner' can be used  as the owner window of its dialog box or
//  menu during the lifetime of the view object.
//  This member function should always create a new   ;Internal
//  instance which has only one reference count. The explorer may create
//  more than one instances of view object from one shell folder object
//  and treat them as separate instances.
//
// IShellFolder::GetAttributesOf(cidl, apidl, prgfInOut)
//   This function returns the attributes of specified objects in that
//  folder. 'cidl' and 'apidl' specifies objects. 'apidl' contains only
//  simple IDLists. The explorer initializes *prgfInOut with a set of
//  flags to be evaluated. The shell folder may optimize the operation
//  by not returning unspecified flags.
//
// IShellFolder::GetUIObjectOf(hwndOwner, cidl, apidl, riid, prgfInOut, ppv)
//   This function creates a UI object to be used for specified objects.
//  The shell explorer passes either IID_IDataObject (for transfer operation)
//  or IID_IContextMenu (for context menu operation) as riid.
//
// IShellFolder::GetDisplayNameOf
//   This function returns the display name of the specified object.
//  If the ID contains the display name (in the locale character set),
//  it returns the offset to the name. Otherwise, it returns a pointer
//  to the display name string (UNICODE), which is allocated by the
//  task allocator, or fills in a buffer.
//
// IShellFolder::SetNameOf
//   This function sets the display name of the specified object.
//  If it changes the ID as well, it returns the new ID which is
//  alocated by the task allocator.
//
//-------------------------------------------------------------------------
// IShellFolder::GetDisplayNameOf/SetNameOf uFlags
typedef enum tagSHGDN
{
    SHGDN_NORMAL             = 0x0000,  // default (display purpose)
    SHGDN_INFOLDER           = 0x0001,  // displayed under a folder (relative)
    SHGDN_NOFRAGMENT         = 0x0002,  // URL without location
    SHGDN_FOREDITING         = 0x1000,  // for in-place editing
    SHGDN_FORADDRESSBAR      = 0x4000,  // UI friendly parsing name (remove ugly stuff)
    SHGDN_FORPARSING         = 0x8000,  // parsing name for ParseDisplayName()
} SHGNO;
typedef DWORD SHGDNF;

// IShellFolder::EnumObjects grfFlags bits
typedef enum tagSHCONTF
{
    SHCONTF_FOLDERS             = 0x0020,   // only want folders enumerated (SHGAO_FOLDER)
    SHCONTF_NONFOLDERS          = 0x0040,   // include non folders
    SHCONTF_INCLUDEHIDDEN       = 0x0080,   // show items normally hidden
    SHCONTF_INIT_ON_FIRST_NEXT  = 0x0100,   // allow EnumObject() to return before validating enum
    SHCONTF_NETPRINTERSRCH      = 0x0200,   // hint that client is looking for printers
    SHCONTF_SHAREABLE           = 0x0400,   // hint that client is looking sharable resources (remote shares)
};
typedef DWORD SHCONTF;

// IShellFolder::CompareIDs lParam flags
//
//  SHCIDS_ALLFIELDS is a mask for lParam indicating that the shell folder
//  should first compare on the lParam column, and if that proves equal,
//  then perform a full comparison on all fields.  This flag is supported
//  if the IShellFolder supports IShellFolder2.
//
//  If you add more flags in the future, you need to enhance the return
//  value from SFVM_SUPPORTSIDENTITY.
//
#define SHCIDS_ALLFIELDS        0x80000000L
#define SHCIDS_COLUMNMASK       0x0000FFFFL
// IShellFolder::GetAttributesOf flags
// DESCRIPTION:
// SFGAO_CANLINK: If this bit is set on an item in the shell folder, a
//            'Create Shortcut' menu item will be added to the File
//            menu and context menus for the item.  If the user selects
//            that command, your IContextMenu::InvokeCommand() will be called
//            with 'link'.
//            	 That flag will also be used to determine if 'Create Shortcut'
//            should be added when the item in your folder is dragged to another
//            folder.
#define SFGAO_CANCOPY           DROPEFFECT_COPY // Objects can be copied    (0x1)
#define SFGAO_CANMOVE           DROPEFFECT_MOVE // Objects can be moved     (0x2)
#define SFGAO_CANLINK           DROPEFFECT_LINK // Objects can be linked    (0x4)
#define SFGAO_CANRENAME         0x00000010L     // Objects can be renamed
#define SFGAO_CANDELETE         0x00000020L     // Objects can be deleted
#define SFGAO_HASPROPSHEET      0x00000040L     // Objects have property sheets
#define SFGAO_DROPTARGET        0x00000100L     // Objects are drop target
#define SFGAO_CAPABILITYMASK    0x00000177L
#define SFGAO_LINK              0x00010000L     // Shortcut (link)
#define SFGAO_SHARE             0x00020000L     // shared
#define SFGAO_READONLY          0x00040000L     // read-only
#define SFGAO_GHOSTED           0x00080000L     // ghosted icon
#define SFGAO_HIDDEN            0x00080000L     // hidden object
#define SFGAO_DISPLAYATTRMASK   0x000F0000L
#define SFGAO_FILESYSANCESTOR   0x10000000L     // It contains file system folder
#define SFGAO_FOLDER            0x20000000L     // It's a folder.
#define SFGAO_FILESYSTEM        0x40000000L     // is a file system thing (file/folder/root)
#define SFGAO_HASSUBFOLDER      0x80000000L     // Expandable in the map pane
#define SFGAO_CONTENTSMASK      0x80000000L
#define SFGAO_VALIDATE          0x01000000L     // invalidate cached information
#define SFGAO_REMOVABLE         0x02000000L     // is this removeable media?
#define SFGAO_COMPRESSED        0x04000000L     // Object is compressed (use alt color)
#define SFGAO_BROWSABLE         0x08000000L     // is in-place browsable
#define SFGAO_NONENUMERATED     0x00100000L     // is a non-enumerated object
#define SFGAO_NEWCONTENT        0x00200000L     // should show bold in explorer tree
#define SFGAO_CANMONIKER        0x00400000L     // can create monikers for its objects
typedef ULONG SFGAOF;

// IShellFolder IBindCtx* parameters. the IUnknown for these are
// accessed through IBindCtx::RegisterObjectParam/GetObjectParam

// this object will support IPersist to query a CLSID that should be skipped
// in the binding process. this is to avoid loops or to allow delegation to
// base name space functionality. see SHSkipJunction()

#define STR_SKIP_BINDING_CLSID      L"Skip Binding CLSID"



extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0114_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0114_v0_0_s_ifspec;

#ifndef __IShellFolder_INTERFACE_DEFINED__
#define __IShellFolder_INTERFACE_DEFINED__

/* interface IShellFolder */
/* [unique][local][object][uuid][helpstring] */ 


EXTERN_C const IID IID_IShellFolder;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("000214E6-0000-0000-C000-000000000046")
    IShellFolder : public IUnknown
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE ParseDisplayName( 
            /* [in] */ HWND hwnd,
            /* [in] */ LPBC pbc,
            /* [string][in] */ LPOLESTR pszDisplayName,
            /* [out] */ ULONG __RPC_FAR *pchEaten,
            /* [out] */ LPITEMIDLIST __RPC_FAR *ppidl,
            /* [out][in] */ ULONG __RPC_FAR *pdwAttributes) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE EnumObjects( 
            /* [in] */ HWND hwnd,
            /* [in] */ SHCONTF grfFlags,
            /* [out] */ IEnumIDList __RPC_FAR *__RPC_FAR *ppenumIDList) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE BindToObject( 
            /* [in] */ LPCITEMIDLIST pidl,
            /* [in] */ LPBC pbc,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppv) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE BindToStorage( 
            /* [in] */ LPCITEMIDLIST pidl,
            /* [in] */ LPBC pbc,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppv) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE CompareIDs( 
            /* [in] */ LPARAM lParam,
            /* [in] */ LPCITEMIDLIST pidl1,
            /* [in] */ LPCITEMIDLIST pidl2) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE CreateViewObject( 
            /* [in] */ HWND hwndOwner,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppv) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetAttributesOf( 
            /* [in] */ UINT cidl,
            /* [size_is][in] */ LPCITEMIDLIST __RPC_FAR *apidl,
            /* [out][in] */ SFGAOF __RPC_FAR *rgfInOut) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetUIObjectOf( 
            /* [in] */ HWND hwndOwner,
            /* [in] */ UINT cidl,
            /* [size_is][in] */ LPCITEMIDLIST __RPC_FAR *apidl,
            /* [in] */ REFIID riid,
            UINT __RPC_FAR *rgfReserved,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppv) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetDisplayNameOf( 
            /* [in] */ LPCITEMIDLIST pidl,
            /* [in] */ SHGDNF uFlags,
            /* [out] */ LPSTRRET lpName) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE SetNameOf( 
            /* [in] */ HWND hwnd,
            /* [in] */ LPCITEMIDLIST pidl,
            /* [string][in] */ LPCOLESTR pszName,
            /* [in] */ SHGDNF uFlags,
            /* [out] */ LPITEMIDLIST __RPC_FAR *ppidlOut) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct IShellFolderVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *QueryInterface )( 
            IShellFolder __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppvObject);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *AddRef )( 
            IShellFolder __RPC_FAR * This);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *Release )( 
            IShellFolder __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *ParseDisplayName )( 
            IShellFolder __RPC_FAR * This,
            /* [in] */ HWND hwnd,
            /* [in] */ LPBC pbc,
            /* [string][in] */ LPOLESTR pszDisplayName,
            /* [out] */ ULONG __RPC_FAR *pchEaten,
            /* [out] */ LPITEMIDLIST __RPC_FAR *ppidl,
            /* [out][in] */ ULONG __RPC_FAR *pdwAttributes);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *EnumObjects )( 
            IShellFolder __RPC_FAR * This,
            /* [in] */ HWND hwnd,
            /* [in] */ SHCONTF grfFlags,
            /* [out] */ IEnumIDList __RPC_FAR *__RPC_FAR *ppenumIDList);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *BindToObject )( 
            IShellFolder __RPC_FAR * This,
            /* [in] */ LPCITEMIDLIST pidl,
            /* [in] */ LPBC pbc,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppv);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *BindToStorage )( 
            IShellFolder __RPC_FAR * This,
            /* [in] */ LPCITEMIDLIST pidl,
            /* [in] */ LPBC pbc,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppv);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *CompareIDs )( 
            IShellFolder __RPC_FAR * This,
            /* [in] */ LPARAM lParam,
            /* [in] */ LPCITEMIDLIST pidl1,
            /* [in] */ LPCITEMIDLIST pidl2);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *CreateViewObject )( 
            IShellFolder __RPC_FAR * This,
            /* [in] */ HWND hwndOwner,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppv);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetAttributesOf )( 
            IShellFolder __RPC_FAR * This,
            /* [in] */ UINT cidl,
            /* [size_is][in] */ LPCITEMIDLIST __RPC_FAR *apidl,
            /* [out][in] */ SFGAOF __RPC_FAR *rgfInOut);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetUIObjectOf )( 
            IShellFolder __RPC_FAR * This,
            /* [in] */ HWND hwndOwner,
            /* [in] */ UINT cidl,
            /* [size_is][in] */ LPCITEMIDLIST __RPC_FAR *apidl,
            /* [in] */ REFIID riid,
            UINT __RPC_FAR *rgfReserved,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppv);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetDisplayNameOf )( 
            IShellFolder __RPC_FAR * This,
            /* [in] */ LPCITEMIDLIST pidl,
            /* [in] */ SHGDNF uFlags,
            /* [out] */ LPSTRRET lpName);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *SetNameOf )( 
            IShellFolder __RPC_FAR * This,
            /* [in] */ HWND hwnd,
            /* [in] */ LPCITEMIDLIST pidl,
            /* [string][in] */ LPCOLESTR pszName,
            /* [in] */ SHGDNF uFlags,
            /* [out] */ LPITEMIDLIST __RPC_FAR *ppidlOut);
        
        END_INTERFACE
    } IShellFolderVtbl;

    interface IShellFolder
    {
        CONST_VTBL struct IShellFolderVtbl __RPC_FAR *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IShellFolder_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define IShellFolder_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define IShellFolder_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define IShellFolder_ParseDisplayName(This,hwnd,pbc,pszDisplayName,pchEaten,ppidl,pdwAttributes)	\
    (This)->lpVtbl -> ParseDisplayName(This,hwnd,pbc,pszDisplayName,pchEaten,ppidl,pdwAttributes)

#define IShellFolder_EnumObjects(This,hwnd,grfFlags,ppenumIDList)	\
    (This)->lpVtbl -> EnumObjects(This,hwnd,grfFlags,ppenumIDList)

#define IShellFolder_BindToObject(This,pidl,pbc,riid,ppv)	\
    (This)->lpVtbl -> BindToObject(This,pidl,pbc,riid,ppv)

#define IShellFolder_BindToStorage(This,pidl,pbc,riid,ppv)	\
    (This)->lpVtbl -> BindToStorage(This,pidl,pbc,riid,ppv)

#define IShellFolder_CompareIDs(This,lParam,pidl1,pidl2)	\
    (This)->lpVtbl -> CompareIDs(This,lParam,pidl1,pidl2)

#define IShellFolder_CreateViewObject(This,hwndOwner,riid,ppv)	\
    (This)->lpVtbl -> CreateViewObject(This,hwndOwner,riid,ppv)

#define IShellFolder_GetAttributesOf(This,cidl,apidl,rgfInOut)	\
    (This)->lpVtbl -> GetAttributesOf(This,cidl,apidl,rgfInOut)

#define IShellFolder_GetUIObjectOf(This,hwndOwner,cidl,apidl,riid,rgfReserved,ppv)	\
    (This)->lpVtbl -> GetUIObjectOf(This,hwndOwner,cidl,apidl,riid,rgfReserved,ppv)

#define IShellFolder_GetDisplayNameOf(This,pidl,uFlags,lpName)	\
    (This)->lpVtbl -> GetDisplayNameOf(This,pidl,uFlags,lpName)

#define IShellFolder_SetNameOf(This,hwnd,pidl,pszName,uFlags,ppidlOut)	\
    (This)->lpVtbl -> SetNameOf(This,hwnd,pidl,pszName,uFlags,ppidlOut)

#endif /* COBJMACROS */


#endif 	/* C style interface */



HRESULT STDMETHODCALLTYPE IShellFolder_ParseDisplayName_Proxy( 
    IShellFolder __RPC_FAR * This,
    /* [in] */ HWND hwnd,
    /* [in] */ LPBC pbc,
    /* [string][in] */ LPOLESTR pszDisplayName,
    /* [out] */ ULONG __RPC_FAR *pchEaten,
    /* [out] */ LPITEMIDLIST __RPC_FAR *ppidl,
    /* [out][in] */ ULONG __RPC_FAR *pdwAttributes);


void __RPC_STUB IShellFolder_ParseDisplayName_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellFolder_EnumObjects_Proxy( 
    IShellFolder __RPC_FAR * This,
    /* [in] */ HWND hwnd,
    /* [in] */ SHCONTF grfFlags,
    /* [out] */ IEnumIDList __RPC_FAR *__RPC_FAR *ppenumIDList);


void __RPC_STUB IShellFolder_EnumObjects_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellFolder_BindToObject_Proxy( 
    IShellFolder __RPC_FAR * This,
    /* [in] */ LPCITEMIDLIST pidl,
    /* [in] */ LPBC pbc,
    /* [in] */ REFIID riid,
    /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppv);


void __RPC_STUB IShellFolder_BindToObject_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellFolder_BindToStorage_Proxy( 
    IShellFolder __RPC_FAR * This,
    /* [in] */ LPCITEMIDLIST pidl,
    /* [in] */ LPBC pbc,
    /* [in] */ REFIID riid,
    /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppv);


void __RPC_STUB IShellFolder_BindToStorage_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellFolder_CompareIDs_Proxy( 
    IShellFolder __RPC_FAR * This,
    /* [in] */ LPARAM lParam,
    /* [in] */ LPCITEMIDLIST pidl1,
    /* [in] */ LPCITEMIDLIST pidl2);


void __RPC_STUB IShellFolder_CompareIDs_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellFolder_CreateViewObject_Proxy( 
    IShellFolder __RPC_FAR * This,
    /* [in] */ HWND hwndOwner,
    /* [in] */ REFIID riid,
    /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppv);


void __RPC_STUB IShellFolder_CreateViewObject_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellFolder_GetAttributesOf_Proxy( 
    IShellFolder __RPC_FAR * This,
    /* [in] */ UINT cidl,
    /* [size_is][in] */ LPCITEMIDLIST __RPC_FAR *apidl,
    /* [out][in] */ SFGAOF __RPC_FAR *rgfInOut);


void __RPC_STUB IShellFolder_GetAttributesOf_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellFolder_GetUIObjectOf_Proxy( 
    IShellFolder __RPC_FAR * This,
    /* [in] */ HWND hwndOwner,
    /* [in] */ UINT cidl,
    /* [size_is][in] */ LPCITEMIDLIST __RPC_FAR *apidl,
    /* [in] */ REFIID riid,
    UINT __RPC_FAR *rgfReserved,
    /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppv);


void __RPC_STUB IShellFolder_GetUIObjectOf_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellFolder_GetDisplayNameOf_Proxy( 
    IShellFolder __RPC_FAR * This,
    /* [in] */ LPCITEMIDLIST pidl,
    /* [in] */ SHGDNF uFlags,
    /* [out] */ LPSTRRET lpName);


void __RPC_STUB IShellFolder_GetDisplayNameOf_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellFolder_SetNameOf_Proxy( 
    IShellFolder __RPC_FAR * This,
    /* [in] */ HWND hwnd,
    /* [in] */ LPCITEMIDLIST pidl,
    /* [string][in] */ LPCOLESTR pszName,
    /* [in] */ SHGDNF uFlags,
    /* [out] */ LPITEMIDLIST __RPC_FAR *ppidlOut);


void __RPC_STUB IShellFolder_SetNameOf_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif 	/* __IShellFolder_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_shobjidl_0115 */
/* [local] */ 

typedef IShellFolder __RPC_FAR *LPSHELLFOLDER;

#if (_WIN32_IE >= 0x0500)
//-------------------------------------------------------------------------
//
// IEnumExtraSearch interface
//
//  IShellFolder2::EnumSearches member returns an IEnumExtraSearch object.
//
//-------------------------------------------------------------------------
typedef struct tagEXTRASEARCH
    {
    GUID guidSearch;
    WCHAR wszFriendlyName[ 80 ];
    WCHAR wszUrl[ 2084 ];
    }	EXTRASEARCH;

typedef struct tagEXTRASEARCH __RPC_FAR *LPEXTRASEARCH;

typedef struct IEnumExtraSearch __RPC_FAR *LPENUMEXTRASEARCH;




extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0115_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0115_v0_0_s_ifspec;

#ifndef __IEnumExtraSearch_INTERFACE_DEFINED__
#define __IEnumExtraSearch_INTERFACE_DEFINED__

/* interface IEnumExtraSearch */
/* [unique][object][uuid][helpstring] */ 


EXTERN_C const IID IID_IEnumExtraSearch;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("0E700BE1-9DB6-11d1-A1CE-00C04FD75D13")
    IEnumExtraSearch : public IUnknown
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE Next( 
            /* [in] */ ULONG celt,
            /* [length_is][size_is][out] */ EXTRASEARCH __RPC_FAR *rgelt,
            /* [out] */ ULONG __RPC_FAR *pceltFetched) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE Skip( 
            /* [in] */ ULONG celt) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE Reset( void) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE Clone( 
            /* [out] */ IEnumExtraSearch __RPC_FAR *__RPC_FAR *ppenum) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct IEnumExtraSearchVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *QueryInterface )( 
            IEnumExtraSearch __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppvObject);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *AddRef )( 
            IEnumExtraSearch __RPC_FAR * This);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *Release )( 
            IEnumExtraSearch __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Next )( 
            IEnumExtraSearch __RPC_FAR * This,
            /* [in] */ ULONG celt,
            /* [length_is][size_is][out] */ EXTRASEARCH __RPC_FAR *rgelt,
            /* [out] */ ULONG __RPC_FAR *pceltFetched);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Skip )( 
            IEnumExtraSearch __RPC_FAR * This,
            /* [in] */ ULONG celt);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Reset )( 
            IEnumExtraSearch __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Clone )( 
            IEnumExtraSearch __RPC_FAR * This,
            /* [out] */ IEnumExtraSearch __RPC_FAR *__RPC_FAR *ppenum);
        
        END_INTERFACE
    } IEnumExtraSearchVtbl;

    interface IEnumExtraSearch
    {
        CONST_VTBL struct IEnumExtraSearchVtbl __RPC_FAR *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IEnumExtraSearch_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define IEnumExtraSearch_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define IEnumExtraSearch_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define IEnumExtraSearch_Next(This,celt,rgelt,pceltFetched)	\
    (This)->lpVtbl -> Next(This,celt,rgelt,pceltFetched)

#define IEnumExtraSearch_Skip(This,celt)	\
    (This)->lpVtbl -> Skip(This,celt)

#define IEnumExtraSearch_Reset(This)	\
    (This)->lpVtbl -> Reset(This)

#define IEnumExtraSearch_Clone(This,ppenum)	\
    (This)->lpVtbl -> Clone(This,ppenum)

#endif /* COBJMACROS */


#endif 	/* C style interface */



HRESULT STDMETHODCALLTYPE IEnumExtraSearch_Next_Proxy( 
    IEnumExtraSearch __RPC_FAR * This,
    /* [in] */ ULONG celt,
    /* [length_is][size_is][out] */ EXTRASEARCH __RPC_FAR *rgelt,
    /* [out] */ ULONG __RPC_FAR *pceltFetched);


void __RPC_STUB IEnumExtraSearch_Next_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IEnumExtraSearch_Skip_Proxy( 
    IEnumExtraSearch __RPC_FAR * This,
    /* [in] */ ULONG celt);


void __RPC_STUB IEnumExtraSearch_Skip_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IEnumExtraSearch_Reset_Proxy( 
    IEnumExtraSearch __RPC_FAR * This);


void __RPC_STUB IEnumExtraSearch_Reset_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IEnumExtraSearch_Clone_Proxy( 
    IEnumExtraSearch __RPC_FAR * This,
    /* [out] */ IEnumExtraSearch __RPC_FAR *__RPC_FAR *ppenum);


void __RPC_STUB IEnumExtraSearch_Clone_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif 	/* __IEnumExtraSearch_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_shobjidl_0116 */
/* [local] */ 

//--------------------------------------------------------------------------
// IShellFolder2
//
// [member functions]
//
// IShellFolder2::GetDefaultSearchGUID(LPGUID pGuid)
//   Returns the guid of the search that is to be invoked when user clicks 
//   on the search toolbar button
//
// IShellFolder2::EnumSearches(IEnumExtraSearch **ppenum)
//   gives an enumerator of the searches to be added to the search menu
//--------------------------------------------------------------------------
//
// IShellFolder2::GetDefaultColumnState values
typedef /* [public][v1_enum] */ 
enum __MIDL___MIDL_itf_shobjidl_0116_0001
    {	SHCOLSTATE_TYPE_STR	= 0x1,
	SHCOLSTATE_TYPE_INT	= 0x2,
	SHCOLSTATE_TYPE_DATE	= 0x3,
	SHCOLSTATE_TYPEMASK	= 0xf,
	SHCOLSTATE_ONBYDEFAULT	= 0x10,
	SHCOLSTATE_SLOW	= 0x20,
	SHCOLSTATE_EXTENDED	= 0x40,
	SHCOLSTATE_SECONDARYUI	= 0x80,
	SHCOLSTATE_HIDDEN	= 0x100
    }	SHCOLSTATE;

typedef DWORD SHCOLSTATEF;

typedef /* [public][public][public][public] */ struct __MIDL___MIDL_itf_shobjidl_0116_0002
    {
    GUID fmtid;
    DWORD pid;
    }	SHCOLUMNID;

typedef struct __MIDL___MIDL_itf_shobjidl_0116_0002 __RPC_FAR *LPSHCOLUMNID;

typedef const SHCOLUMNID __RPC_FAR *LPCSHCOLUMNID;




extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0116_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0116_v0_0_s_ifspec;

#ifndef __IShellFolder2_INTERFACE_DEFINED__
#define __IShellFolder2_INTERFACE_DEFINED__

/* interface IShellFolder2 */
/* [unique][local][object][uuid][helpstring] */ 


EXTERN_C const IID IID_IShellFolder2;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("93F2F68C-1D1B-11d3-A30E-00C04F79ABD1")
    IShellFolder2 : public IShellFolder
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE GetDefaultSearchGUID( 
            /* [out] */ GUID __RPC_FAR *pguid) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE EnumSearches( 
            /* [out] */ IEnumExtraSearch __RPC_FAR *__RPC_FAR *ppenum) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetDefaultColumn( 
            DWORD dwRes,
            /* [out] */ ULONG __RPC_FAR *pSort,
            /* [out] */ ULONG __RPC_FAR *pDisplay) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetDefaultColumnState( 
            /* [in] */ UINT iColumn,
            /* [out] */ SHCOLSTATEF __RPC_FAR *pcsFlags) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetDetailsEx( 
            /* [in] */ LPCITEMIDLIST pidl,
            /* [in] */ const SHCOLUMNID __RPC_FAR *pscid,
            /* [out] */ VARIANT __RPC_FAR *pv) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetDetailsOf( 
            /* [in] */ LPCITEMIDLIST pidl,
            /* [in] */ UINT iColumn,
            /* [out] */ SHELLDETAILS __RPC_FAR *psd) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE MapColumnToSCID( 
            /* [in] */ UINT iColumn,
            /* [in] */ SHCOLUMNID __RPC_FAR *pscid) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct IShellFolder2Vtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *QueryInterface )( 
            IShellFolder2 __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppvObject);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *AddRef )( 
            IShellFolder2 __RPC_FAR * This);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *Release )( 
            IShellFolder2 __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *ParseDisplayName )( 
            IShellFolder2 __RPC_FAR * This,
            /* [in] */ HWND hwnd,
            /* [in] */ LPBC pbc,
            /* [string][in] */ LPOLESTR pszDisplayName,
            /* [out] */ ULONG __RPC_FAR *pchEaten,
            /* [out] */ LPITEMIDLIST __RPC_FAR *ppidl,
            /* [out][in] */ ULONG __RPC_FAR *pdwAttributes);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *EnumObjects )( 
            IShellFolder2 __RPC_FAR * This,
            /* [in] */ HWND hwnd,
            /* [in] */ SHCONTF grfFlags,
            /* [out] */ IEnumIDList __RPC_FAR *__RPC_FAR *ppenumIDList);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *BindToObject )( 
            IShellFolder2 __RPC_FAR * This,
            /* [in] */ LPCITEMIDLIST pidl,
            /* [in] */ LPBC pbc,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppv);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *BindToStorage )( 
            IShellFolder2 __RPC_FAR * This,
            /* [in] */ LPCITEMIDLIST pidl,
            /* [in] */ LPBC pbc,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppv);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *CompareIDs )( 
            IShellFolder2 __RPC_FAR * This,
            /* [in] */ LPARAM lParam,
            /* [in] */ LPCITEMIDLIST pidl1,
            /* [in] */ LPCITEMIDLIST pidl2);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *CreateViewObject )( 
            IShellFolder2 __RPC_FAR * This,
            /* [in] */ HWND hwndOwner,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppv);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetAttributesOf )( 
            IShellFolder2 __RPC_FAR * This,
            /* [in] */ UINT cidl,
            /* [size_is][in] */ LPCITEMIDLIST __RPC_FAR *apidl,
            /* [out][in] */ SFGAOF __RPC_FAR *rgfInOut);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetUIObjectOf )( 
            IShellFolder2 __RPC_FAR * This,
            /* [in] */ HWND hwndOwner,
            /* [in] */ UINT cidl,
            /* [size_is][in] */ LPCITEMIDLIST __RPC_FAR *apidl,
            /* [in] */ REFIID riid,
            UINT __RPC_FAR *rgfReserved,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppv);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetDisplayNameOf )( 
            IShellFolder2 __RPC_FAR * This,
            /* [in] */ LPCITEMIDLIST pidl,
            /* [in] */ SHGDNF uFlags,
            /* [out] */ LPSTRRET lpName);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *SetNameOf )( 
            IShellFolder2 __RPC_FAR * This,
            /* [in] */ HWND hwnd,
            /* [in] */ LPCITEMIDLIST pidl,
            /* [string][in] */ LPCOLESTR pszName,
            /* [in] */ SHGDNF uFlags,
            /* [out] */ LPITEMIDLIST __RPC_FAR *ppidlOut);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetDefaultSearchGUID )( 
            IShellFolder2 __RPC_FAR * This,
            /* [out] */ GUID __RPC_FAR *pguid);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *EnumSearches )( 
            IShellFolder2 __RPC_FAR * This,
            /* [out] */ IEnumExtraSearch __RPC_FAR *__RPC_FAR *ppenum);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetDefaultColumn )( 
            IShellFolder2 __RPC_FAR * This,
            DWORD dwRes,
            /* [out] */ ULONG __RPC_FAR *pSort,
            /* [out] */ ULONG __RPC_FAR *pDisplay);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetDefaultColumnState )( 
            IShellFolder2 __RPC_FAR * This,
            /* [in] */ UINT iColumn,
            /* [out] */ SHCOLSTATEF __RPC_FAR *pcsFlags);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetDetailsEx )( 
            IShellFolder2 __RPC_FAR * This,
            /* [in] */ LPCITEMIDLIST pidl,
            /* [in] */ const SHCOLUMNID __RPC_FAR *pscid,
            /* [out] */ VARIANT __RPC_FAR *pv);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetDetailsOf )( 
            IShellFolder2 __RPC_FAR * This,
            /* [in] */ LPCITEMIDLIST pidl,
            /* [in] */ UINT iColumn,
            /* [out] */ SHELLDETAILS __RPC_FAR *psd);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *MapColumnToSCID )( 
            IShellFolder2 __RPC_FAR * This,
            /* [in] */ UINT iColumn,
            /* [in] */ SHCOLUMNID __RPC_FAR *pscid);
        
        END_INTERFACE
    } IShellFolder2Vtbl;

    interface IShellFolder2
    {
        CONST_VTBL struct IShellFolder2Vtbl __RPC_FAR *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IShellFolder2_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define IShellFolder2_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define IShellFolder2_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define IShellFolder2_ParseDisplayName(This,hwnd,pbc,pszDisplayName,pchEaten,ppidl,pdwAttributes)	\
    (This)->lpVtbl -> ParseDisplayName(This,hwnd,pbc,pszDisplayName,pchEaten,ppidl,pdwAttributes)

#define IShellFolder2_EnumObjects(This,hwnd,grfFlags,ppenumIDList)	\
    (This)->lpVtbl -> EnumObjects(This,hwnd,grfFlags,ppenumIDList)

#define IShellFolder2_BindToObject(This,pidl,pbc,riid,ppv)	\
    (This)->lpVtbl -> BindToObject(This,pidl,pbc,riid,ppv)

#define IShellFolder2_BindToStorage(This,pidl,pbc,riid,ppv)	\
    (This)->lpVtbl -> BindToStorage(This,pidl,pbc,riid,ppv)

#define IShellFolder2_CompareIDs(This,lParam,pidl1,pidl2)	\
    (This)->lpVtbl -> CompareIDs(This,lParam,pidl1,pidl2)

#define IShellFolder2_CreateViewObject(This,hwndOwner,riid,ppv)	\
    (This)->lpVtbl -> CreateViewObject(This,hwndOwner,riid,ppv)

#define IShellFolder2_GetAttributesOf(This,cidl,apidl,rgfInOut)	\
    (This)->lpVtbl -> GetAttributesOf(This,cidl,apidl,rgfInOut)

#define IShellFolder2_GetUIObjectOf(This,hwndOwner,cidl,apidl,riid,rgfReserved,ppv)	\
    (This)->lpVtbl -> GetUIObjectOf(This,hwndOwner,cidl,apidl,riid,rgfReserved,ppv)

#define IShellFolder2_GetDisplayNameOf(This,pidl,uFlags,lpName)	\
    (This)->lpVtbl -> GetDisplayNameOf(This,pidl,uFlags,lpName)

#define IShellFolder2_SetNameOf(This,hwnd,pidl,pszName,uFlags,ppidlOut)	\
    (This)->lpVtbl -> SetNameOf(This,hwnd,pidl,pszName,uFlags,ppidlOut)


#define IShellFolder2_GetDefaultSearchGUID(This,pguid)	\
    (This)->lpVtbl -> GetDefaultSearchGUID(This,pguid)

#define IShellFolder2_EnumSearches(This,ppenum)	\
    (This)->lpVtbl -> EnumSearches(This,ppenum)

#define IShellFolder2_GetDefaultColumn(This,dwRes,pSort,pDisplay)	\
    (This)->lpVtbl -> GetDefaultColumn(This,dwRes,pSort,pDisplay)

#define IShellFolder2_GetDefaultColumnState(This,iColumn,pcsFlags)	\
    (This)->lpVtbl -> GetDefaultColumnState(This,iColumn,pcsFlags)

#define IShellFolder2_GetDetailsEx(This,pidl,pscid,pv)	\
    (This)->lpVtbl -> GetDetailsEx(This,pidl,pscid,pv)

#define IShellFolder2_GetDetailsOf(This,pidl,iColumn,psd)	\
    (This)->lpVtbl -> GetDetailsOf(This,pidl,iColumn,psd)

#define IShellFolder2_MapColumnToSCID(This,iColumn,pscid)	\
    (This)->lpVtbl -> MapColumnToSCID(This,iColumn,pscid)

#endif /* COBJMACROS */


#endif 	/* C style interface */



HRESULT STDMETHODCALLTYPE IShellFolder2_GetDefaultSearchGUID_Proxy( 
    IShellFolder2 __RPC_FAR * This,
    /* [out] */ GUID __RPC_FAR *pguid);


void __RPC_STUB IShellFolder2_GetDefaultSearchGUID_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellFolder2_EnumSearches_Proxy( 
    IShellFolder2 __RPC_FAR * This,
    /* [out] */ IEnumExtraSearch __RPC_FAR *__RPC_FAR *ppenum);


void __RPC_STUB IShellFolder2_EnumSearches_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellFolder2_GetDefaultColumn_Proxy( 
    IShellFolder2 __RPC_FAR * This,
    DWORD dwRes,
    /* [out] */ ULONG __RPC_FAR *pSort,
    /* [out] */ ULONG __RPC_FAR *pDisplay);


void __RPC_STUB IShellFolder2_GetDefaultColumn_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellFolder2_GetDefaultColumnState_Proxy( 
    IShellFolder2 __RPC_FAR * This,
    /* [in] */ UINT iColumn,
    /* [out] */ SHCOLSTATEF __RPC_FAR *pcsFlags);


void __RPC_STUB IShellFolder2_GetDefaultColumnState_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellFolder2_GetDetailsEx_Proxy( 
    IShellFolder2 __RPC_FAR * This,
    /* [in] */ LPCITEMIDLIST pidl,
    /* [in] */ const SHCOLUMNID __RPC_FAR *pscid,
    /* [out] */ VARIANT __RPC_FAR *pv);


void __RPC_STUB IShellFolder2_GetDetailsEx_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellFolder2_GetDetailsOf_Proxy( 
    IShellFolder2 __RPC_FAR * This,
    /* [in] */ LPCITEMIDLIST pidl,
    /* [in] */ UINT iColumn,
    /* [out] */ SHELLDETAILS __RPC_FAR *psd);


void __RPC_STUB IShellFolder2_GetDetailsOf_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellFolder2_MapColumnToSCID_Proxy( 
    IShellFolder2 __RPC_FAR * This,
    /* [in] */ UINT iColumn,
    /* [in] */ SHCOLUMNID __RPC_FAR *pscid);


void __RPC_STUB IShellFolder2_MapColumnToSCID_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif 	/* __IShellFolder2_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_shobjidl_0117 */
/* [local] */ 

#endif // _WIN32_IE >= 0x0500)
//--------------------------------------------------------------------------
//
// FOLDERSETTINGS
//
//  FOLDERSETTINGS is a data structure that explorer passes from one folder
// view to another, when the user is browsing. It calls ISV::GetCurrentInfo
// member to get the current settings and pass it to ISV::CreateViewWindow
// to allow the next folder view 'inherit' it. These settings assumes a
// particular UI (which the shell's folder view has), and shell extensions
// may or may not use those settings.
//
//--------------------------------------------------------------------------
typedef LPVIEWSETTINGS;

// NB Bitfields.
// FWF_DESKTOP implies FWF_TRANSPARENT/NOCLIENTEDGE/NOSCROLL
typedef /* [public][v1_enum] */ 
enum __MIDL___MIDL_itf_shobjidl_0117_0001
    {	FWF_AUTOARRANGE	= 0x1,
	FWF_ABBREVIATEDNAMES	= 0x2,
	FWF_SNAPTOGRID	= 0x4,
	FWF_OWNERDATA	= 0x8,
	FWF_BESTFITWINDOW	= 0x10,
	FWF_DESKTOP	= 0x20,
	FWF_SINGLESEL	= 0x40,
	FWF_NOSUBFOLDERS	= 0x80,
	FWF_TRANSPARENT	= 0x100,
	FWF_NOCLIENTEDGE	= 0x200,
	FWF_NOSCROLL	= 0x400,
	FWF_ALIGNLEFT	= 0x800,
	FWF_NOICONS	= 0x1000,
	FWF_SHOWSELALWAYS	= 0x2000,
	FWF_NOVISIBLE	= 0x4000,
	FWF_SINGLECLICKACTIVATE	= 0x8000,
	FWF_NOWEBVIEW	= 0x10000,
	FWF_HIDEFILENAMES	= 0x20000
    }	FOLDERFLAGS;

typedef /* [public][v1_enum] */ 
enum __MIDL___MIDL_itf_shobjidl_0117_0002
    {	FVM_ICON	= 1,
	FVM_SMALLICON	= 2,
	FVM_LIST	= 3,
	FVM_DETAILS	= 4
    }	FOLDERVIEWMODE;

typedef /* [public][public][public][public][public][public][public][public][public] */ struct __MIDL___MIDL_itf_shobjidl_0117_0003
    {
    UINT ViewMode;
    UINT fFlags;
    }	FOLDERSETTINGS;

typedef FOLDERSETTINGS __RPC_FAR *LPFOLDERSETTINGS;

typedef const FOLDERSETTINGS __RPC_FAR *LPCFOLDERSETTINGS;

typedef FOLDERSETTINGS __RPC_FAR *PFOLDERSETTINGS;

//==========================================================================
//
// Interface:   IShellView
//
// IShellView::GetWindow(phwnd)
//
//   Inherited from IOleWindow::GetWindow.
//
//
// IShellView::ContextSensitiveHelp(fEnterMode)
//
//   Inherited from IOleWindow::ContextSensitiveHelp.
//
//
// IShellView::TranslateAccelerator(lpmsg)
//
//   Similar to IOleInPlaceActiveObject::TranlateAccelerator. The explorer
//  calls this function BEFORE any other translation. Returning S_OK
//  indicates that the message was translated (eaten) and should not be
//  translated or dispatched by the explorer.
//
//
// IShellView::EnableModeless(fEnable)
//   Similar to IOleInPlaceActiveObject::EnableModeless.
//
//
// IShellView::UIActivate(uState)
//
//   The explorer calls this member function whenever the activation
//  state of the view window is changed by a certain event that is
//  NOT caused by the shell view itself.
//
//   SVUIA_DEACTIVATE will be passed when the explorer is about to
//  destroy the shell view window; the shell view is supposed to remove
//  all the extended UIs (typically merged menu and modeless popup windows).
//
//   SVUIA_ACTIVATE_NOFOCUS will be passsed when the shell view is losing
//  the input focus or the shell view has been just created without the
//  input focus; the shell view is supposed to set menuitems appropriate
//  for non-focused state (no selection specific items should be added).
//
//   SVUIA_ACTIVATE_FOCUS will be passed when the explorer has just
//  created the view window with the input focus; the shell view is
//  supposed to set menuitems appropriate for focused state.
//
//   SVUIA_INPLACEACTIVATE(new) will be passed when the shell view is opened
//  within an ActiveX control, which is not a UI active. In this case,
//  the shell view should not merge menus or put toolbas. To be compatible
//  with Win95 client, we don't pass this value unless the view supports
//  IShellView2.
//
//   The shell view should not change focus within this member function.
//  The shell view should not hook the WM_KILLFOCUS message to remerge
//  menuitems. However, the shell view typically hook the WM_SETFOCUS
//  message, and re-merge the menu after calling IShellBrowser::
//  OnViewWindowActivated.
//
//   One of the ACTIVATE / INPLACEACTIVATE messages will be sent when
//  the view window becomes the currently displayed view.  On Win95 systems,
//  this will happen immediately after the CreateViewWindow call.  On IE4, Win98,
//  and NT5 systems this may happen when the view reports it is ready (if the
//  IShellView supports async creation).  This can be used as a hint as to when
//  to make your view window visible.  Note: the Win95/Win98/NT4 common dialogs
//  do not send either of these on creation.
//
//
// IShellView::Refresh()
//
//   The explorer calls this member when the view needs to refresh its
//  contents (such as when the user hits F5 key).
//
//
// IShellView::CreateViewWindow
//
//   This member creates the view window (right-pane of the explorer or the
//  client window of the folder window).
//
//
// IShellView::DestroyViewWindow
//
//   This member destroys the view window.
//
//
// IShellView::GetCurrentInfo
//
//   This member returns the folder settings.
//
//
// IShellView::AddPropertySHeetPages
//
//   The explorer calls this member when it is opening the option property
//  sheet. This allows the view to add additional pages to it.
//
//
// IShellView::SaveViewState()
//
//   The explorer calls this member when the shell view is supposed to
//  store its view settings. The shell view is supposed to get a view
//  stream by calling IShellBrowser::GetViewStateStream and store the
//  current view state into that stream.
//
//
// IShellView::SelectItem(pidlItem, uFlags)
//
//   The explorer calls this member to change the selection state of
//  item(s) within the shell view window.  If pidlItem is NULL and uFlags
//  is SVSI_DESELECTOTHERS, all items should be deselected.
//
//-------------------------------------------------------------------------

//
// shellview select item flags
//
#define SVSI_DESELECT   0x0000
#define SVSI_SELECT     0x0001
#define SVSI_EDIT       0x0003  // includes select
#define SVSI_DESELECTOTHERS 0x0004
#define SVSI_ENSUREVISIBLE  0x0008
#define SVSI_FOCUSED        0x0010
#define SVSI_TRANSLATEPT    0x0020

//
// shellview get item object flags
//
#define SVGIO_BACKGROUND    0x00000000
#define SVGIO_SELECTION     0x00000001
#define SVGIO_ALLVIEW       0x00000002

//
// uState values for IShellView::UIActivate
//
typedef /* [public][v1_enum] */ 
enum __MIDL___MIDL_itf_shobjidl_0117_0004
    {	SVUIA_DEACTIVATE	= 0,
	SVUIA_ACTIVATE_NOFOCUS	= 1,
	SVUIA_ACTIVATE_FOCUS	= 2,
	SVUIA_INPLACEACTIVATE	= 3
    }	SVUIA_STATUS;

#ifdef _FIX_ENABLEMODELESS_CONFLICT
#define    EnableModeless EnableModelessSV
#endif
#ifdef _NEVER_
typedef LPARAM LPFNSVADDPROPSHEETPAGE;

#else //!_NEVER_
#include <prsht.h>
typedef LPFNADDPROPSHEETPAGE LPFNSVADDPROPSHEETPAGE;
#endif //_NEVER_




extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0117_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0117_v0_0_s_ifspec;

#ifndef __IShellView_INTERFACE_DEFINED__
#define __IShellView_INTERFACE_DEFINED__

/* interface IShellView */
/* [unique][object][uuid][helpstring] */ 


EXTERN_C const IID IID_IShellView;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("000214E3-0000-0000-C000-000000000046")
    IShellView : public IOleWindow
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE TranslateAccelerator( 
            /* [in] */ LPMSG lpmsg) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE EnableModeless( 
            /* [in] */ BOOL fEnable) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE UIActivate( 
            /* [in] */ UINT uState) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE Refresh( void) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE CreateViewWindow( 
            /* [in] */ IShellView __RPC_FAR *psvPrevious,
            /* [in] */ LPCFOLDERSETTINGS lpfs,
            /* [in] */ IShellBrowser __RPC_FAR *psb,
            /* [out] */ RECT __RPC_FAR *prcView,
            /* [out] */ HWND __RPC_FAR *phWnd) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE DestroyViewWindow( void) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetCurrentInfo( 
            /* [out] */ LPFOLDERSETTINGS lpfs) = 0;
        
        virtual /* [local] */ HRESULT STDMETHODCALLTYPE AddPropertySheetPages( 
            /* [in] */ DWORD dwReserved,
            /* [in] */ LPFNSVADDPROPSHEETPAGE lpfn,
            /* [in] */ LPARAM lparam) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE SaveViewState( void) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE SelectItem( 
            /* [in] */ LPCITEMIDLIST pidlItem,
            /* [in] */ UINT uFlags) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetItemObject( 
            /* [in] */ UINT uItem,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppv) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct IShellViewVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *QueryInterface )( 
            IShellView __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppvObject);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *AddRef )( 
            IShellView __RPC_FAR * This);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *Release )( 
            IShellView __RPC_FAR * This);
        
        /* [input_sync] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetWindow )( 
            IShellView __RPC_FAR * This,
            /* [out] */ HWND __RPC_FAR *phwnd);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *ContextSensitiveHelp )( 
            IShellView __RPC_FAR * This,
            /* [in] */ BOOL fEnterMode);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *TranslateAccelerator )( 
            IShellView __RPC_FAR * This,
            /* [in] */ LPMSG lpmsg);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *EnableModeless )( 
            IShellView __RPC_FAR * This,
            /* [in] */ BOOL fEnable);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *UIActivate )( 
            IShellView __RPC_FAR * This,
            /* [in] */ UINT uState);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Refresh )( 
            IShellView __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *CreateViewWindow )( 
            IShellView __RPC_FAR * This,
            /* [in] */ IShellView __RPC_FAR *psvPrevious,
            /* [in] */ LPCFOLDERSETTINGS lpfs,
            /* [in] */ IShellBrowser __RPC_FAR *psb,
            /* [out] */ RECT __RPC_FAR *prcView,
            /* [out] */ HWND __RPC_FAR *phWnd);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *DestroyViewWindow )( 
            IShellView __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetCurrentInfo )( 
            IShellView __RPC_FAR * This,
            /* [out] */ LPFOLDERSETTINGS lpfs);
        
        /* [local] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *AddPropertySheetPages )( 
            IShellView __RPC_FAR * This,
            /* [in] */ DWORD dwReserved,
            /* [in] */ LPFNSVADDPROPSHEETPAGE lpfn,
            /* [in] */ LPARAM lparam);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *SaveViewState )( 
            IShellView __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *SelectItem )( 
            IShellView __RPC_FAR * This,
            /* [in] */ LPCITEMIDLIST pidlItem,
            /* [in] */ UINT uFlags);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetItemObject )( 
            IShellView __RPC_FAR * This,
            /* [in] */ UINT uItem,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppv);
        
        END_INTERFACE
    } IShellViewVtbl;

    interface IShellView
    {
        CONST_VTBL struct IShellViewVtbl __RPC_FAR *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IShellView_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define IShellView_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define IShellView_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define IShellView_GetWindow(This,phwnd)	\
    (This)->lpVtbl -> GetWindow(This,phwnd)

#define IShellView_ContextSensitiveHelp(This,fEnterMode)	\
    (This)->lpVtbl -> ContextSensitiveHelp(This,fEnterMode)


#define IShellView_TranslateAccelerator(This,lpmsg)	\
    (This)->lpVtbl -> TranslateAccelerator(This,lpmsg)

#define IShellView_EnableModeless(This,fEnable)	\
    (This)->lpVtbl -> EnableModeless(This,fEnable)

#define IShellView_UIActivate(This,uState)	\
    (This)->lpVtbl -> UIActivate(This,uState)

#define IShellView_Refresh(This)	\
    (This)->lpVtbl -> Refresh(This)

#define IShellView_CreateViewWindow(This,psvPrevious,lpfs,psb,prcView,phWnd)	\
    (This)->lpVtbl -> CreateViewWindow(This,psvPrevious,lpfs,psb,prcView,phWnd)

#define IShellView_DestroyViewWindow(This)	\
    (This)->lpVtbl -> DestroyViewWindow(This)

#define IShellView_GetCurrentInfo(This,lpfs)	\
    (This)->lpVtbl -> GetCurrentInfo(This,lpfs)

#define IShellView_AddPropertySheetPages(This,dwReserved,lpfn,lparam)	\
    (This)->lpVtbl -> AddPropertySheetPages(This,dwReserved,lpfn,lparam)

#define IShellView_SaveViewState(This)	\
    (This)->lpVtbl -> SaveViewState(This)

#define IShellView_SelectItem(This,pidlItem,uFlags)	\
    (This)->lpVtbl -> SelectItem(This,pidlItem,uFlags)

#define IShellView_GetItemObject(This,uItem,riid,ppv)	\
    (This)->lpVtbl -> GetItemObject(This,uItem,riid,ppv)

#endif /* COBJMACROS */


#endif 	/* C style interface */



HRESULT STDMETHODCALLTYPE IShellView_TranslateAccelerator_Proxy( 
    IShellView __RPC_FAR * This,
    /* [in] */ LPMSG lpmsg);


void __RPC_STUB IShellView_TranslateAccelerator_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellView_EnableModeless_Proxy( 
    IShellView __RPC_FAR * This,
    /* [in] */ BOOL fEnable);


void __RPC_STUB IShellView_EnableModeless_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellView_UIActivate_Proxy( 
    IShellView __RPC_FAR * This,
    /* [in] */ UINT uState);


void __RPC_STUB IShellView_UIActivate_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellView_Refresh_Proxy( 
    IShellView __RPC_FAR * This);


void __RPC_STUB IShellView_Refresh_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellView_CreateViewWindow_Proxy( 
    IShellView __RPC_FAR * This,
    /* [in] */ IShellView __RPC_FAR *psvPrevious,
    /* [in] */ LPCFOLDERSETTINGS lpfs,
    /* [in] */ IShellBrowser __RPC_FAR *psb,
    /* [out] */ RECT __RPC_FAR *prcView,
    /* [out] */ HWND __RPC_FAR *phWnd);


void __RPC_STUB IShellView_CreateViewWindow_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellView_DestroyViewWindow_Proxy( 
    IShellView __RPC_FAR * This);


void __RPC_STUB IShellView_DestroyViewWindow_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellView_GetCurrentInfo_Proxy( 
    IShellView __RPC_FAR * This,
    /* [out] */ LPFOLDERSETTINGS lpfs);


void __RPC_STUB IShellView_GetCurrentInfo_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [local] */ HRESULT STDMETHODCALLTYPE IShellView_AddPropertySheetPages_Proxy( 
    IShellView __RPC_FAR * This,
    /* [in] */ DWORD dwReserved,
    /* [in] */ LPFNSVADDPROPSHEETPAGE lpfn,
    /* [in] */ LPARAM lparam);


void __RPC_STUB IShellView_AddPropertySheetPages_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellView_SaveViewState_Proxy( 
    IShellView __RPC_FAR * This);


void __RPC_STUB IShellView_SaveViewState_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellView_SelectItem_Proxy( 
    IShellView __RPC_FAR * This,
    /* [in] */ LPCITEMIDLIST pidlItem,
    /* [in] */ UINT uFlags);


void __RPC_STUB IShellView_SelectItem_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellView_GetItemObject_Proxy( 
    IShellView __RPC_FAR * This,
    /* [in] */ UINT uItem,
    /* [in] */ REFIID riid,
    /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppv);


void __RPC_STUB IShellView_GetItemObject_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif 	/* __IShellView_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_shobjidl_0118 */
/* [local] */ 

typedef IShellView __RPC_FAR *LPSHELLVIEW;

typedef GUID SHELLVIEWID;

#define SV2GV_CURRENTVIEW ((UINT)-1)
#define SV2GV_DEFAULTVIEW ((UINT)-2)
// The pvid parameter of the GetView() method of IShellView2 is normally only an OUT parameter.
// But, for SV2GV_ISEXTENDEDVIEW, it is an IN parameter.
#define SV2GV_ISEXTENDEDVIEW    ((UINT)-3)
typedef struct _SV2CVW2_PARAMS
    {
    DWORD cbSize;
    IShellView __RPC_FAR *psvPrev;
    LPCFOLDERSETTINGS pfs;
    IShellBrowser __RPC_FAR *psbOwner;
    RECT __RPC_FAR *prcView;
    const SHELLVIEWID __RPC_FAR *pvid;
    HWND hwndView;
    }	SV2CVW2_PARAMS;

typedef SV2CVW2_PARAMS __RPC_FAR *LPSV2CVW2_PARAMS;




extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0118_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0118_v0_0_s_ifspec;

#ifndef __IShellView2_INTERFACE_DEFINED__
#define __IShellView2_INTERFACE_DEFINED__

/* interface IShellView2 */
/* [unique][object][uuid][helpstring] */ 


EXTERN_C const IID IID_IShellView2;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("88E39E80-3578-11CF-AE69-08002B2E1262")
    IShellView2 : public IShellView
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE GetView( 
            /* [out][in] */ SHELLVIEWID __RPC_FAR *pvid,
            /* [in] */ ULONG uView) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE CreateViewWindow2( 
            /* [in] */ LPSV2CVW2_PARAMS lpParams) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE HandleRename( 
            /* [in] */ LPCITEMIDLIST pidlNew) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE SelectAndPositionItem( 
            /* [in] */ LPCITEMIDLIST pidlItem,
            /* [in] */ UINT uFlags,
            /* [in] */ POINT __RPC_FAR *ppt) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct IShellView2Vtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *QueryInterface )( 
            IShellView2 __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppvObject);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *AddRef )( 
            IShellView2 __RPC_FAR * This);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *Release )( 
            IShellView2 __RPC_FAR * This);
        
        /* [input_sync] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetWindow )( 
            IShellView2 __RPC_FAR * This,
            /* [out] */ HWND __RPC_FAR *phwnd);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *ContextSensitiveHelp )( 
            IShellView2 __RPC_FAR * This,
            /* [in] */ BOOL fEnterMode);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *TranslateAccelerator )( 
            IShellView2 __RPC_FAR * This,
            /* [in] */ LPMSG lpmsg);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *EnableModeless )( 
            IShellView2 __RPC_FAR * This,
            /* [in] */ BOOL fEnable);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *UIActivate )( 
            IShellView2 __RPC_FAR * This,
            /* [in] */ UINT uState);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Refresh )( 
            IShellView2 __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *CreateViewWindow )( 
            IShellView2 __RPC_FAR * This,
            /* [in] */ IShellView __RPC_FAR *psvPrevious,
            /* [in] */ LPCFOLDERSETTINGS lpfs,
            /* [in] */ IShellBrowser __RPC_FAR *psb,
            /* [out] */ RECT __RPC_FAR *prcView,
            /* [out] */ HWND __RPC_FAR *phWnd);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *DestroyViewWindow )( 
            IShellView2 __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetCurrentInfo )( 
            IShellView2 __RPC_FAR * This,
            /* [out] */ LPFOLDERSETTINGS lpfs);
        
        /* [local] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *AddPropertySheetPages )( 
            IShellView2 __RPC_FAR * This,
            /* [in] */ DWORD dwReserved,
            /* [in] */ LPFNSVADDPROPSHEETPAGE lpfn,
            /* [in] */ LPARAM lparam);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *SaveViewState )( 
            IShellView2 __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *SelectItem )( 
            IShellView2 __RPC_FAR * This,
            /* [in] */ LPCITEMIDLIST pidlItem,
            /* [in] */ UINT uFlags);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetItemObject )( 
            IShellView2 __RPC_FAR * This,
            /* [in] */ UINT uItem,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppv);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetView )( 
            IShellView2 __RPC_FAR * This,
            /* [out][in] */ SHELLVIEWID __RPC_FAR *pvid,
            /* [in] */ ULONG uView);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *CreateViewWindow2 )( 
            IShellView2 __RPC_FAR * This,
            /* [in] */ LPSV2CVW2_PARAMS lpParams);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *HandleRename )( 
            IShellView2 __RPC_FAR * This,
            /* [in] */ LPCITEMIDLIST pidlNew);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *SelectAndPositionItem )( 
            IShellView2 __RPC_FAR * This,
            /* [in] */ LPCITEMIDLIST pidlItem,
            /* [in] */ UINT uFlags,
            /* [in] */ POINT __RPC_FAR *ppt);
        
        END_INTERFACE
    } IShellView2Vtbl;

    interface IShellView2
    {
        CONST_VTBL struct IShellView2Vtbl __RPC_FAR *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IShellView2_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define IShellView2_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define IShellView2_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define IShellView2_GetWindow(This,phwnd)	\
    (This)->lpVtbl -> GetWindow(This,phwnd)

#define IShellView2_ContextSensitiveHelp(This,fEnterMode)	\
    (This)->lpVtbl -> ContextSensitiveHelp(This,fEnterMode)


#define IShellView2_TranslateAccelerator(This,lpmsg)	\
    (This)->lpVtbl -> TranslateAccelerator(This,lpmsg)

#define IShellView2_EnableModeless(This,fEnable)	\
    (This)->lpVtbl -> EnableModeless(This,fEnable)

#define IShellView2_UIActivate(This,uState)	\
    (This)->lpVtbl -> UIActivate(This,uState)

#define IShellView2_Refresh(This)	\
    (This)->lpVtbl -> Refresh(This)

#define IShellView2_CreateViewWindow(This,psvPrevious,lpfs,psb,prcView,phWnd)	\
    (This)->lpVtbl -> CreateViewWindow(This,psvPrevious,lpfs,psb,prcView,phWnd)

#define IShellView2_DestroyViewWindow(This)	\
    (This)->lpVtbl -> DestroyViewWindow(This)

#define IShellView2_GetCurrentInfo(This,lpfs)	\
    (This)->lpVtbl -> GetCurrentInfo(This,lpfs)

#define IShellView2_AddPropertySheetPages(This,dwReserved,lpfn,lparam)	\
    (This)->lpVtbl -> AddPropertySheetPages(This,dwReserved,lpfn,lparam)

#define IShellView2_SaveViewState(This)	\
    (This)->lpVtbl -> SaveViewState(This)

#define IShellView2_SelectItem(This,pidlItem,uFlags)	\
    (This)->lpVtbl -> SelectItem(This,pidlItem,uFlags)

#define IShellView2_GetItemObject(This,uItem,riid,ppv)	\
    (This)->lpVtbl -> GetItemObject(This,uItem,riid,ppv)


#define IShellView2_GetView(This,pvid,uView)	\
    (This)->lpVtbl -> GetView(This,pvid,uView)

#define IShellView2_CreateViewWindow2(This,lpParams)	\
    (This)->lpVtbl -> CreateViewWindow2(This,lpParams)

#define IShellView2_HandleRename(This,pidlNew)	\
    (This)->lpVtbl -> HandleRename(This,pidlNew)

#define IShellView2_SelectAndPositionItem(This,pidlItem,uFlags,ppt)	\
    (This)->lpVtbl -> SelectAndPositionItem(This,pidlItem,uFlags,ppt)

#endif /* COBJMACROS */


#endif 	/* C style interface */



HRESULT STDMETHODCALLTYPE IShellView2_GetView_Proxy( 
    IShellView2 __RPC_FAR * This,
    /* [out][in] */ SHELLVIEWID __RPC_FAR *pvid,
    /* [in] */ ULONG uView);


void __RPC_STUB IShellView2_GetView_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellView2_CreateViewWindow2_Proxy( 
    IShellView2 __RPC_FAR * This,
    /* [in] */ LPSV2CVW2_PARAMS lpParams);


void __RPC_STUB IShellView2_CreateViewWindow2_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellView2_HandleRename_Proxy( 
    IShellView2 __RPC_FAR * This,
    /* [in] */ LPCITEMIDLIST pidlNew);


void __RPC_STUB IShellView2_HandleRename_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellView2_SelectAndPositionItem_Proxy( 
    IShellView2 __RPC_FAR * This,
    /* [in] */ LPCITEMIDLIST pidlItem,
    /* [in] */ UINT uFlags,
    /* [in] */ POINT __RPC_FAR *ppt);


void __RPC_STUB IShellView2_SelectAndPositionItem_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif 	/* __IShellView2_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_shobjidl_0119 */
/* [local] */ 

#ifdef _FIX_ENABLEMODELESS_CONFLICT
#undef    EnableModeless 
#endif
//--------------------------------------------------------------------------
//
// Interface:   IShellBrowser
//
//  IShellBrowser interface is the interface that is provided by the shell
// explorer/folder frame window. When it creates the 'contents pane' of
// a shell folder (which provides IShellFolder interface), it calls its
// CreateViewObject member function to create an IShellView object. Then,
// it calls its CreateViewWindow member to create the 'contents pane'
// window. The pointer to the IShellBrowser interface is passed to
// the IShellView object as a parameter to this CreateViewWindow member
// function call.
//
//    +--------------------------+  <-- Explorer window
//    | [] Explorer              |
//    |--------------------------+       IShellBrowser
//    | File Edit View ..        |
//    |--------------------------|
//    |        |                 |
//    |        |              <-------- Content pane
//    |        |                 |
//    |        |                 |       IShellView
//    |        |                 |
//    |        |                 |
//    +--------------------------+
//
//
//
// [Member functions]
//
//
// IShellBrowser::GetWindow(phwnd)
//
//   Inherited from IOleWindow::GetWindow.
//
//
// IShellBrowser::ContextSensitiveHelp(fEnterMode)
//
//   Inherited from IOleWindow::ContextSensitiveHelp.
//
//
// IShellBrowser::InsertMenusSB(hmenuShared, lpMenuWidths)
//
//   Similar to the IOleInPlaceFrame::InsertMenus. The explorer will put
//  'File' and 'Edit' pulldown in the File menu group, 'View' and 'Tools'
//  in the Container menu group and 'Help' in the Window menu group. Each
//  pulldown menu will have a uniqu ID, FCIDM_MENU_FILE/EDIT/VIEW/TOOLS/HELP
//  The view is allowed to insert menuitems into those sub-menus by those
//  IDs must be between FCIDM_SHVIEWFIRST and FCIDM_SHVIEWLAST.
//
//
// IShellBrowser::SetMenuSB(hmenuShared, holemenu, hwndActiveObject)
//
//   Similar to the IOleInPlaceFrame::SetMenu. The explorer ignores the
//  holemenu parameter (reserved for future enhancement)  and performs
//  menu-dispatch based on the menuitem IDs (see the description above).
//  It is important to note that the explorer will add different
//  set of menuitems depending on whether the view has a focus or not.
//  Therefore, it is very important to call ISB::OnViewWindowActivate
//  whenever the view window (or its children) gets the focus.
//
//
// IShellBrowser::RemoveMenusSB(hmenuShared)
//
//   Same as the IOleInPlaceFrame::RemoveMenus.
//
//
// IShellBrowser::SetStatusTextSB(pszStatusText)
//
//   Same as the IOleInPlaceFrame::SetStatusText. It is also possible to
//  send messages directly to the status window via SendControlMsg.
//
//
// IShellBrowser::EnableModelessSB(fEnable)
//
//   Same as the IOleInPlaceFrame::EnableModeless.
//
//
// IShellBrowser::TranslateAcceleratorSB(lpmsg, wID)
//
//   Same as the IOleInPlaceFrame::TranslateAccelerator, but will be
//  never called because we don't support EXEs (i.e., the explorer has
//  the message loop). This member function is defined here for possible
//  future enhancement.
//
//
// IShellBrowser::BrowseObject(pidl, wFlags)
//
//   The view calls this member to let shell explorer browse to another
//  folder. The pidl and wFlags specifies the folder to be browsed.
//
//  Following three flags specifies whether it creates another window or not.
//   SBSP_SAMEBROWSER  -- Browse to another folder with the same window.
//   SBSP_NEWBROWSER   -- Creates another window for the specified folder.
//   SBSP_DEFBROWSER   -- Default behavior (respects the view option).
//
//  Following three flags specifies open, explore, or default mode. These   .
//  are ignored if SBSP_SAMEBROWSER or (SBSP_DEFBROWSER && (single window   .
//  browser || explorer)).                                                  .
//   SBSP_OPENMODE     -- Use a normal folder window
//   SBSP_EXPLOREMODE  -- Use an explorer window
//   SBSP_DEFMODE      -- Use the same as the current window
//
//  Following three flags specifies the pidl.
//   SBSP_ABSOLUTE -- pidl is an absolute pidl (relative from desktop)
//   SBSP_RELATIVE -- pidl is relative from the current folder.
//   SBSP_PARENT   -- Browse the parent folder (ignores the pidl)
//   SBSP_NAVIGATEBACK    -- Navigate back (ignores the pidl)
//   SBSP_NAVIGATEFORWARD -- Navigate forward (ignores the pidl)
//
//  Following two flags control history manipulation as result of navigate
//   SBSP_WRITENOHISTORY -- write no history (shell folder) entry
//   SBSP_NOAUTOSELECT -- suppress selection in history pane
//
// IShellBrowser::GetViewStateStream(grfMode, ppstm)
//
//   The browser returns an IStream interface as the storage for view
//  specific state information.
//
//   grfMode -- Specifies the read/write access (STGM_READ/WRITE/READWRITE)
//   ppstm   -- Specifies the IStream *variable to be filled.
//
//
// IShellBrowser::GetControlWindow(id, phwnd)
//
//   The shell view may call this member function to get the window handle
//  of Explorer controls (toolbar or status winodw -- FCW_TOOLBAR or
//  FCW_STATUS).
//
//
// IShellBrowser::SendControlMsg(id, uMsg, wParam, lParam, pret)
//
//   The shell view calls this member function to send control messages to
//  one of Explorer controls (toolbar or status window -- FCW_TOOLBAR or
//  FCW_STATUS).
//
//
// IShellBrowser::QueryActiveShellView(IShellView * ppshv)
//
//   This member returns currently activated (displayed) shellview object.
//  A shellview never need to call this member function.
//
//
// IShellBrowser::OnViewWindowActive(pshv)
//
//   The shell view window calls this member function when the view window
//  (or one of its children) got the focus. It MUST call this member before
//  calling IShellBrowser::InsertMenus, because it will insert different
//  set of menu items depending on whether the view has the focus or not.
//
//
// IShellBrowser::SetToolbarItems(lpButtons, nButtons, uFlags)
//
//   The view calls this function to add toolbar items to the exporer's
//  toolbar. 'lpButtons' and 'nButtons' specifies the array of toolbar
//  items. 'uFlags' must be one of FCT_MERGE, FCT_CONFIGABLE, FCT_ADDTOEND.
//
//-------------------------------------------------------------------------

//
// Values for wFlags parameter of ISB::BrowseObject() member.
//
#define SBSP_DEFBROWSER         0x0000
#define SBSP_SAMEBROWSER        0x0001
#define SBSP_NEWBROWSER         0x0002

#define SBSP_DEFMODE            0x0000
#define SBSP_OPENMODE           0x0010
#define SBSP_EXPLOREMODE        0x0020
#define SBSP_HELPMODE           0x0040 // IEUNIX : Help window uses this.
#define SBSP_NOTRANSFERHIST     0x0080

#define SBSP_ABSOLUTE           0x0000
#define SBSP_RELATIVE           0x1000
#define SBSP_PARENT             0x2000
#define SBSP_NAVIGATEBACK       0x4000
#define SBSP_NAVIGATEFORWARD    0x8000

#define SBSP_ALLOW_AUTONAVIGATE 0x10000

#define SBSP_NOAUTOSELECT       0x04000000
#define SBSP_WRITENOHISTORY     0x08000000

#define SBSP_REDIRECT                     0x40000000
#define SBSP_INITIATEDBYHLINKFRAME        0x80000000
//
// Values for id parameter of ISB::GetWindow/SendControlMsg members.
//
// WARNING:
//  Any shell extensions which sends messages to those control windows
// might not work in the future version of windows. If you really need
// to send messages to them, (1) don't assume that those control window
// always exist (i.e. GetControlWindow may fail) and (2) verify the window
// class of the window before sending any messages.
//
#define FCW_STATUS      0x0001
#define FCW_TOOLBAR     0x0002
#define FCW_TREE        0x0003
#define FCW_VIEW        0x0004  
#define FCW_BROWSER     0x0005  //;Internal
#define FCW_INTERNETBAR 0x0006
#define FCW_MENUBAR     0x0007  //;internal
#define FCW_PROGRESS    0x0008

#if (_WIN32_IE >= 0x0400)
#define FCW_ADDRESSBAR  0x0009  //;internal
#define FCW_TOOLBAND    0x000a  //;internal
#define FCW_LINKSBAR    0x000b  //;internal
#endif

//
// Values for uFlags paremeter of ISB::SetToolbarItems member.
//
#define FCT_MERGE       0x0001
#define FCT_CONFIGABLE  0x0002
#define FCT_ADDTOEND    0x0004
#ifdef _NEVER_
typedef LPARAM LPTBBUTTONSB;

#else //!_NEVER_
#include <commctrl.h>
typedef LPTBBUTTON LPTBBUTTONSB;
#endif //_NEVER_



extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0119_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0119_v0_0_s_ifspec;

#ifndef __IShellBrowser_INTERFACE_DEFINED__
#define __IShellBrowser_INTERFACE_DEFINED__

/* interface IShellBrowser */
/* [unique][object][uuid][helpstring] */ 


EXTERN_C const IID IID_IShellBrowser;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("000214E2-0000-0000-C000-000000000046")
    IShellBrowser : public IOleWindow
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE InsertMenusSB( 
            /* [in] */ HMENU hmenuShared,
            /* [out][in] */ LPOLEMENUGROUPWIDTHS lpMenuWidths) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE SetMenuSB( 
            /* [in] */ HMENU hmenuShared,
            /* [in] */ HOLEMENU holemenuRes,
            /* [in] */ HWND hwndActiveObject) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE RemoveMenusSB( 
            /* [in] */ HMENU hmenuShared) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE SetStatusTextSB( 
            /* [unique][in] */ LPCOLESTR pszStatusText) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE EnableModelessSB( 
            /* [in] */ BOOL fEnable) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE TranslateAcceleratorSB( 
            /* [in] */ MSG __RPC_FAR *pmsg,
            /* [in] */ WORD wID) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE BrowseObject( 
            /* [in] */ LPCITEMIDLIST pidl,
            /* [in] */ UINT wFlags) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetViewStateStream( 
            /* [in] */ DWORD grfMode,
            /* [out] */ IStream __RPC_FAR *__RPC_FAR *ppStrm) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetControlWindow( 
            /* [in] */ UINT id,
            /* [out] */ HWND __RPC_FAR *lphwnd) = 0;
        
        virtual /* [local] */ HRESULT STDMETHODCALLTYPE SendControlMsg( 
            /* [in] */ UINT id,
            /* [in] */ UINT uMsg,
            /* [in] */ WPARAM wParam,
            /* [in] */ LPARAM lParam,
            /* [in] */ LRESULT __RPC_FAR *pret) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE QueryActiveShellView( 
            /* [in] */ IShellView __RPC_FAR *__RPC_FAR *ppshv) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE OnViewWindowActive( 
            /* [in] */ IShellView __RPC_FAR *pshv) = 0;
        
        virtual /* [local] */ HRESULT STDMETHODCALLTYPE SetToolbarItems( 
            /* [in] */ LPTBBUTTONSB lpButtons,
            /* [in] */ UINT nButtons,
            /* [in] */ UINT uFlags) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct IShellBrowserVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *QueryInterface )( 
            IShellBrowser __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppvObject);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *AddRef )( 
            IShellBrowser __RPC_FAR * This);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *Release )( 
            IShellBrowser __RPC_FAR * This);
        
        /* [input_sync] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetWindow )( 
            IShellBrowser __RPC_FAR * This,
            /* [out] */ HWND __RPC_FAR *phwnd);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *ContextSensitiveHelp )( 
            IShellBrowser __RPC_FAR * This,
            /* [in] */ BOOL fEnterMode);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *InsertMenusSB )( 
            IShellBrowser __RPC_FAR * This,
            /* [in] */ HMENU hmenuShared,
            /* [out][in] */ LPOLEMENUGROUPWIDTHS lpMenuWidths);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *SetMenuSB )( 
            IShellBrowser __RPC_FAR * This,
            /* [in] */ HMENU hmenuShared,
            /* [in] */ HOLEMENU holemenuRes,
            /* [in] */ HWND hwndActiveObject);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *RemoveMenusSB )( 
            IShellBrowser __RPC_FAR * This,
            /* [in] */ HMENU hmenuShared);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *SetStatusTextSB )( 
            IShellBrowser __RPC_FAR * This,
            /* [unique][in] */ LPCOLESTR pszStatusText);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *EnableModelessSB )( 
            IShellBrowser __RPC_FAR * This,
            /* [in] */ BOOL fEnable);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *TranslateAcceleratorSB )( 
            IShellBrowser __RPC_FAR * This,
            /* [in] */ MSG __RPC_FAR *pmsg,
            /* [in] */ WORD wID);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *BrowseObject )( 
            IShellBrowser __RPC_FAR * This,
            /* [in] */ LPCITEMIDLIST pidl,
            /* [in] */ UINT wFlags);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetViewStateStream )( 
            IShellBrowser __RPC_FAR * This,
            /* [in] */ DWORD grfMode,
            /* [out] */ IStream __RPC_FAR *__RPC_FAR *ppStrm);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetControlWindow )( 
            IShellBrowser __RPC_FAR * This,
            /* [in] */ UINT id,
            /* [out] */ HWND __RPC_FAR *lphwnd);
        
        /* [local] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *SendControlMsg )( 
            IShellBrowser __RPC_FAR * This,
            /* [in] */ UINT id,
            /* [in] */ UINT uMsg,
            /* [in] */ WPARAM wParam,
            /* [in] */ LPARAM lParam,
            /* [in] */ LRESULT __RPC_FAR *pret);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *QueryActiveShellView )( 
            IShellBrowser __RPC_FAR * This,
            /* [in] */ IShellView __RPC_FAR *__RPC_FAR *ppshv);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *OnViewWindowActive )( 
            IShellBrowser __RPC_FAR * This,
            /* [in] */ IShellView __RPC_FAR *pshv);
        
        /* [local] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *SetToolbarItems )( 
            IShellBrowser __RPC_FAR * This,
            /* [in] */ LPTBBUTTONSB lpButtons,
            /* [in] */ UINT nButtons,
            /* [in] */ UINT uFlags);
        
        END_INTERFACE
    } IShellBrowserVtbl;

    interface IShellBrowser
    {
        CONST_VTBL struct IShellBrowserVtbl __RPC_FAR *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IShellBrowser_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define IShellBrowser_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define IShellBrowser_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define IShellBrowser_GetWindow(This,phwnd)	\
    (This)->lpVtbl -> GetWindow(This,phwnd)

#define IShellBrowser_ContextSensitiveHelp(This,fEnterMode)	\
    (This)->lpVtbl -> ContextSensitiveHelp(This,fEnterMode)


#define IShellBrowser_InsertMenusSB(This,hmenuShared,lpMenuWidths)	\
    (This)->lpVtbl -> InsertMenusSB(This,hmenuShared,lpMenuWidths)

#define IShellBrowser_SetMenuSB(This,hmenuShared,holemenuRes,hwndActiveObject)	\
    (This)->lpVtbl -> SetMenuSB(This,hmenuShared,holemenuRes,hwndActiveObject)

#define IShellBrowser_RemoveMenusSB(This,hmenuShared)	\
    (This)->lpVtbl -> RemoveMenusSB(This,hmenuShared)

#define IShellBrowser_SetStatusTextSB(This,pszStatusText)	\
    (This)->lpVtbl -> SetStatusTextSB(This,pszStatusText)

#define IShellBrowser_EnableModelessSB(This,fEnable)	\
    (This)->lpVtbl -> EnableModelessSB(This,fEnable)

#define IShellBrowser_TranslateAcceleratorSB(This,pmsg,wID)	\
    (This)->lpVtbl -> TranslateAcceleratorSB(This,pmsg,wID)

#define IShellBrowser_BrowseObject(This,pidl,wFlags)	\
    (This)->lpVtbl -> BrowseObject(This,pidl,wFlags)

#define IShellBrowser_GetViewStateStream(This,grfMode,ppStrm)	\
    (This)->lpVtbl -> GetViewStateStream(This,grfMode,ppStrm)

#define IShellBrowser_GetControlWindow(This,id,lphwnd)	\
    (This)->lpVtbl -> GetControlWindow(This,id,lphwnd)

#define IShellBrowser_SendControlMsg(This,id,uMsg,wParam,lParam,pret)	\
    (This)->lpVtbl -> SendControlMsg(This,id,uMsg,wParam,lParam,pret)

#define IShellBrowser_QueryActiveShellView(This,ppshv)	\
    (This)->lpVtbl -> QueryActiveShellView(This,ppshv)

#define IShellBrowser_OnViewWindowActive(This,pshv)	\
    (This)->lpVtbl -> OnViewWindowActive(This,pshv)

#define IShellBrowser_SetToolbarItems(This,lpButtons,nButtons,uFlags)	\
    (This)->lpVtbl -> SetToolbarItems(This,lpButtons,nButtons,uFlags)

#endif /* COBJMACROS */


#endif 	/* C style interface */



HRESULT STDMETHODCALLTYPE IShellBrowser_InsertMenusSB_Proxy( 
    IShellBrowser __RPC_FAR * This,
    /* [in] */ HMENU hmenuShared,
    /* [out][in] */ LPOLEMENUGROUPWIDTHS lpMenuWidths);


void __RPC_STUB IShellBrowser_InsertMenusSB_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellBrowser_SetMenuSB_Proxy( 
    IShellBrowser __RPC_FAR * This,
    /* [in] */ HMENU hmenuShared,
    /* [in] */ HOLEMENU holemenuRes,
    /* [in] */ HWND hwndActiveObject);


void __RPC_STUB IShellBrowser_SetMenuSB_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellBrowser_RemoveMenusSB_Proxy( 
    IShellBrowser __RPC_FAR * This,
    /* [in] */ HMENU hmenuShared);


void __RPC_STUB IShellBrowser_RemoveMenusSB_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellBrowser_SetStatusTextSB_Proxy( 
    IShellBrowser __RPC_FAR * This,
    /* [unique][in] */ LPCOLESTR pszStatusText);


void __RPC_STUB IShellBrowser_SetStatusTextSB_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellBrowser_EnableModelessSB_Proxy( 
    IShellBrowser __RPC_FAR * This,
    /* [in] */ BOOL fEnable);


void __RPC_STUB IShellBrowser_EnableModelessSB_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellBrowser_TranslateAcceleratorSB_Proxy( 
    IShellBrowser __RPC_FAR * This,
    /* [in] */ MSG __RPC_FAR *pmsg,
    /* [in] */ WORD wID);


void __RPC_STUB IShellBrowser_TranslateAcceleratorSB_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellBrowser_BrowseObject_Proxy( 
    IShellBrowser __RPC_FAR * This,
    /* [in] */ LPCITEMIDLIST pidl,
    /* [in] */ UINT wFlags);


void __RPC_STUB IShellBrowser_BrowseObject_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellBrowser_GetViewStateStream_Proxy( 
    IShellBrowser __RPC_FAR * This,
    /* [in] */ DWORD grfMode,
    /* [out] */ IStream __RPC_FAR *__RPC_FAR *ppStrm);


void __RPC_STUB IShellBrowser_GetViewStateStream_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellBrowser_GetControlWindow_Proxy( 
    IShellBrowser __RPC_FAR * This,
    /* [in] */ UINT id,
    /* [out] */ HWND __RPC_FAR *lphwnd);


void __RPC_STUB IShellBrowser_GetControlWindow_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [local] */ HRESULT STDMETHODCALLTYPE IShellBrowser_SendControlMsg_Proxy( 
    IShellBrowser __RPC_FAR * This,
    /* [in] */ UINT id,
    /* [in] */ UINT uMsg,
    /* [in] */ WPARAM wParam,
    /* [in] */ LPARAM lParam,
    /* [in] */ LRESULT __RPC_FAR *pret);


void __RPC_STUB IShellBrowser_SendControlMsg_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellBrowser_QueryActiveShellView_Proxy( 
    IShellBrowser __RPC_FAR * This,
    /* [in] */ IShellView __RPC_FAR *__RPC_FAR *ppshv);


void __RPC_STUB IShellBrowser_QueryActiveShellView_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IShellBrowser_OnViewWindowActive_Proxy( 
    IShellBrowser __RPC_FAR * This,
    /* [in] */ IShellView __RPC_FAR *pshv);


void __RPC_STUB IShellBrowser_OnViewWindowActive_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [local] */ HRESULT STDMETHODCALLTYPE IShellBrowser_SetToolbarItems_Proxy( 
    IShellBrowser __RPC_FAR * This,
    /* [in] */ LPTBBUTTONSB lpButtons,
    /* [in] */ UINT nButtons,
    /* [in] */ UINT uFlags);


void __RPC_STUB IShellBrowser_SetToolbarItems_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif 	/* __IShellBrowser_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_shobjidl_0120 */
/* [local] */ 

typedef IShellBrowser __RPC_FAR *LPSHELLBROWSER;

//-------------------------------------------------------------------------
//
// IShellNetCrawler interface
//
// [Member functions]
//
//   IShellNetCrawler::Update
//   Causes an enumeration of the local workgroup and subsequent addition
//   of folder shortcut and printer objects.   As is a blocking call
//   which will potentially take a long time (seconds) it should be called
//   on a seperate thread
#define SNCF_IGNORERAS   0x00000001



extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0120_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0120_v0_0_s_ifspec;

#ifndef __IShellNetCrawler_INTERFACE_DEFINED__
#define __IShellNetCrawler_INTERFACE_DEFINED__

/* interface IShellNetCrawler */
/* [unique][object][uuid][helpstring] */ 


EXTERN_C const IID IID_IShellNetCrawler;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("49c929ee-a1b7-4c58-b539-e63be392b6f3")
    IShellNetCrawler : public IUnknown
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE Update( 
            /* [in] */ DWORD dwFlags) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct IShellNetCrawlerVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *QueryInterface )( 
            IShellNetCrawler __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppvObject);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *AddRef )( 
            IShellNetCrawler __RPC_FAR * This);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *Release )( 
            IShellNetCrawler __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Update )( 
            IShellNetCrawler __RPC_FAR * This,
            /* [in] */ DWORD dwFlags);
        
        END_INTERFACE
    } IShellNetCrawlerVtbl;

    interface IShellNetCrawler
    {
        CONST_VTBL struct IShellNetCrawlerVtbl __RPC_FAR *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IShellNetCrawler_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define IShellNetCrawler_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define IShellNetCrawler_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define IShellNetCrawler_Update(This,dwFlags)	\
    (This)->lpVtbl -> Update(This,dwFlags)

#endif /* COBJMACROS */


#endif 	/* C style interface */



HRESULT STDMETHODCALLTYPE IShellNetCrawler_Update_Proxy( 
    IShellNetCrawler __RPC_FAR * This,
    /* [in] */ DWORD dwFlags);


void __RPC_STUB IShellNetCrawler_Update_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif 	/* __IShellNetCrawler_INTERFACE_DEFINED__ */


#ifndef __IProfferService_INTERFACE_DEFINED__
#define __IProfferService_INTERFACE_DEFINED__

/* interface IProfferService */
/* [unique][object][uuid][helpstring] */ 


EXTERN_C const IID IID_IProfferService;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("cb728b20-f786-11ce-92ad-00aa00a74cd0")
    IProfferService : public IUnknown
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE ProfferService( 
            /* [in] */ REFGUID rguidService,
            /* [in] */ IServiceProvider __RPC_FAR *psp,
            /* [out] */ DWORD __RPC_FAR *pdwCookie) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE RevokeService( 
            /* [in] */ DWORD dwCookie) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct IProfferServiceVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *QueryInterface )( 
            IProfferService __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppvObject);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *AddRef )( 
            IProfferService __RPC_FAR * This);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *Release )( 
            IProfferService __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *ProfferService )( 
            IProfferService __RPC_FAR * This,
            /* [in] */ REFGUID rguidService,
            /* [in] */ IServiceProvider __RPC_FAR *psp,
            /* [out] */ DWORD __RPC_FAR *pdwCookie);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *RevokeService )( 
            IProfferService __RPC_FAR * This,
            /* [in] */ DWORD dwCookie);
        
        END_INTERFACE
    } IProfferServiceVtbl;

    interface IProfferService
    {
        CONST_VTBL struct IProfferServiceVtbl __RPC_FAR *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IProfferService_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define IProfferService_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define IProfferService_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define IProfferService_ProfferService(This,rguidService,psp,pdwCookie)	\
    (This)->lpVtbl -> ProfferService(This,rguidService,psp,pdwCookie)

#define IProfferService_RevokeService(This,dwCookie)	\
    (This)->lpVtbl -> RevokeService(This,dwCookie)

#endif /* COBJMACROS */


#endif 	/* C style interface */



HRESULT STDMETHODCALLTYPE IProfferService_ProfferService_Proxy( 
    IProfferService __RPC_FAR * This,
    /* [in] */ REFGUID rguidService,
    /* [in] */ IServiceProvider __RPC_FAR *psp,
    /* [out] */ DWORD __RPC_FAR *pdwCookie);


void __RPC_STUB IProfferService_ProfferService_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IProfferService_RevokeService_Proxy( 
    IProfferService __RPC_FAR * This,
    /* [in] */ DWORD dwCookie);


void __RPC_STUB IProfferService_RevokeService_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif 	/* __IProfferService_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_shobjidl_0122 */
/* [local] */ 

#define SID_SProfferService IID_IProfferService	// nearest service that you can proffer to
//-------------------------------------------------------------------------
//
// ICompositeFolder interface
//
// [Member functions]
//
//   ICompositeFolder::InitComposite
//       initializes a composite folder with the information necessary to aggregate
//       the child folders
typedef /* [v1_enum] */ 
enum _CFITYPE
    {	CFITYPE_CSIDL	= 0,
	CFITYPE_PIDL	= CFITYPE_CSIDL + 1,
	CFITYPE_PATH	= CFITYPE_PIDL + 1
    }	CFITYPE;

/* [v1_enum] */ 
enum __MIDL___MIDL_itf_shobjidl_0122_0001
    {	CFINITF_CHILDREN	= 0,
	CFINITF_FLAT	= 0x1
    };
typedef UINT CFINITF;

typedef struct _COMPFOLDERINIT
    {
    UINT uType;
    /* [switch_is][switch_type] */ union 
        {
        /* [case()] */ int csidl;
        /* [case()] */ LPCITEMIDLIST pidl;
        /* [case()][string] */ LPOLESTR pszPath;
        }	DUMMYUNIONNAME;
    LPOLESTR pszName;
    }	COMPFOLDERINIT;




extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0122_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0122_v0_0_s_ifspec;

#ifndef __ICompositeFolder_INTERFACE_DEFINED__
#define __ICompositeFolder_INTERFACE_DEFINED__

/* interface ICompositeFolder */
/* [unique][object][uuid][helpstring] */ 


EXTERN_C const IID IID_ICompositeFolder;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("601ac3dd-786a-4eb0-bf40-ee3521e70bfb")
    ICompositeFolder : public IUnknown
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE InitComposite( 
            /* [in] */ WORD wSignature,
            /* [in] */ REFCLSID refclsid,
            /* [in] */ CFINITF flags,
            /* [in] */ ULONG celt,
            /* [size_is][in] */ const COMPFOLDERINIT __RPC_FAR *rgCFs) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE BindToParent( 
            /* [in] */ LPCITEMIDLIST pidl,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppv,
            /* [out] */ LPITEMIDLIST __RPC_FAR *ppidlLast) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct ICompositeFolderVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *QueryInterface )( 
            ICompositeFolder __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppvObject);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *AddRef )( 
            ICompositeFolder __RPC_FAR * This);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *Release )( 
            ICompositeFolder __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *InitComposite )( 
            ICompositeFolder __RPC_FAR * This,
            /* [in] */ WORD wSignature,
            /* [in] */ REFCLSID refclsid,
            /* [in] */ CFINITF flags,
            /* [in] */ ULONG celt,
            /* [size_is][in] */ const COMPFOLDERINIT __RPC_FAR *rgCFs);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *BindToParent )( 
            ICompositeFolder __RPC_FAR * This,
            /* [in] */ LPCITEMIDLIST pidl,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppv,
            /* [out] */ LPITEMIDLIST __RPC_FAR *ppidlLast);
        
        END_INTERFACE
    } ICompositeFolderVtbl;

    interface ICompositeFolder
    {
        CONST_VTBL struct ICompositeFolderVtbl __RPC_FAR *lpVtbl;
    };

    

#ifdef COBJMACROS


#define ICompositeFolder_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define ICompositeFolder_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define ICompositeFolder_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define ICompositeFolder_InitComposite(This,wSignature,refclsid,flags,celt,rgCFs)	\
    (This)->lpVtbl -> InitComposite(This,wSignature,refclsid,flags,celt,rgCFs)

#define ICompositeFolder_BindToParent(This,pidl,riid,ppv,ppidlLast)	\
    (This)->lpVtbl -> BindToParent(This,pidl,riid,ppv,ppidlLast)

#endif /* COBJMACROS */


#endif 	/* C style interface */



HRESULT STDMETHODCALLTYPE ICompositeFolder_InitComposite_Proxy( 
    ICompositeFolder __RPC_FAR * This,
    /* [in] */ WORD wSignature,
    /* [in] */ REFCLSID refclsid,
    /* [in] */ CFINITF flags,
    /* [in] */ ULONG celt,
    /* [size_is][in] */ const COMPFOLDERINIT __RPC_FAR *rgCFs);


void __RPC_STUB ICompositeFolder_InitComposite_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE ICompositeFolder_BindToParent_Proxy( 
    ICompositeFolder __RPC_FAR * This,
    /* [in] */ LPCITEMIDLIST pidl,
    /* [in] */ REFIID riid,
    /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppv,
    /* [out] */ LPITEMIDLIST __RPC_FAR *ppidlLast);


void __RPC_STUB ICompositeFolder_BindToParent_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif 	/* __ICompositeFolder_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_shobjidl_0123 */
/* [local] */ 




extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0123_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0123_v0_0_s_ifspec;

#ifndef __IFolderAndItem_INTERFACE_DEFINED__
#define __IFolderAndItem_INTERFACE_DEFINED__

/* interface IFolderAndItem */
/* [unique][object][uuid][helpstring] */ 


EXTERN_C const IID IID_IFolderAndItem;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("b3a4b685-b234-4805-99d9-5dead2873236")
    IFolderAndItem : public IUnknown
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE SetFolderAndItem( 
            /* [in] */ IShellFolder __RPC_FAR *psf,
            /* [in] */ LPCITEMIDLIST pidl) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetFolderAndItem( 
            /* [out] */ IShellFolder __RPC_FAR *__RPC_FAR *ppsf,
            /* [out] */ LPITEMIDLIST __RPC_FAR *ppidl) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct IFolderAndItemVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *QueryInterface )( 
            IFolderAndItem __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppvObject);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *AddRef )( 
            IFolderAndItem __RPC_FAR * This);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *Release )( 
            IFolderAndItem __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *SetFolderAndItem )( 
            IFolderAndItem __RPC_FAR * This,
            /* [in] */ IShellFolder __RPC_FAR *psf,
            /* [in] */ LPCITEMIDLIST pidl);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetFolderAndItem )( 
            IFolderAndItem __RPC_FAR * This,
            /* [out] */ IShellFolder __RPC_FAR *__RPC_FAR *ppsf,
            /* [out] */ LPITEMIDLIST __RPC_FAR *ppidl);
        
        END_INTERFACE
    } IFolderAndItemVtbl;

    interface IFolderAndItem
    {
        CONST_VTBL struct IFolderAndItemVtbl __RPC_FAR *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IFolderAndItem_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define IFolderAndItem_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define IFolderAndItem_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define IFolderAndItem_SetFolderAndItem(This,psf,pidl)	\
    (This)->lpVtbl -> SetFolderAndItem(This,psf,pidl)

#define IFolderAndItem_GetFolderAndItem(This,ppsf,ppidl)	\
    (This)->lpVtbl -> GetFolderAndItem(This,ppsf,ppidl)

#endif /* COBJMACROS */


#endif 	/* C style interface */



HRESULT STDMETHODCALLTYPE IFolderAndItem_SetFolderAndItem_Proxy( 
    IFolderAndItem __RPC_FAR * This,
    /* [in] */ IShellFolder __RPC_FAR *psf,
    /* [in] */ LPCITEMIDLIST pidl);


void __RPC_STUB IFolderAndItem_SetFolderAndItem_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IFolderAndItem_GetFolderAndItem_Proxy( 
    IFolderAndItem __RPC_FAR * This,
    /* [out] */ IShellFolder __RPC_FAR *__RPC_FAR *ppsf,
    /* [out] */ LPITEMIDLIST __RPC_FAR *ppidl);


void __RPC_STUB IFolderAndItem_GetFolderAndItem_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif 	/* __IFolderAndItem_INTERFACE_DEFINED__ */


/* interface __MIDL_itf_shobjidl_0124 */
/* [local] */ 

typedef /* [public][public][v1_enum] */ 
enum __MIDL___MIDL_itf_shobjidl_0124_0001
    {	PUIF_DEFAULT	= 0,
	PUIF_RIGHTALIGN	= 0x1,
	PUIF_NOLABELININFOTIP	= 0x2
    }	PROPERTYUI_FLAGS;

typedef /* [public][public][v1_enum] */ 
enum __MIDL___MIDL_itf_shobjidl_0124_0002
    {	PUIFFDF_DEFAULT	= 0,
	PUIFFDF_RIGHTTOLEFT	= 0x1,
	PUIFFDF_SHORTFORMAT	= 0x2,
	PUIFFDF_NOTIME	= 0x4,
	PUIFFDF_FRIENDLYDATE	= 0x8,
	PUIFFDF_NOUNITS	= 0x10
    }	PROPERTYUI_FORMAT_FLAGS;



extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0124_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_shobjidl_0124_v0_0_s_ifspec;

#ifndef __IPropertyUI_INTERFACE_DEFINED__
#define __IPropertyUI_INTERFACE_DEFINED__

/* interface IPropertyUI */
/* [unique][object][uuid][helpstring] */ 


EXTERN_C const IID IID_IPropertyUI;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("d43eacec-eaaf-4aae-ba46-eecba97d988a")
    IPropertyUI : public IUnknown
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE ParsePropertyName( 
            /* [in] */ LPCWSTR pszName,
            /* [out] */ FMTID __RPC_FAR *pfmtid,
            /* [out] */ PROPID __RPC_FAR *ppid,
            /* [out] */ ULONG __RPC_FAR *pchEaten) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetCannonicalName( 
            /* [in] */ REFFMTID fmtid,
            /* [in] */ PROPID pid,
            /* [size_is][out] */ LPWSTR pwszText,
            /* [in] */ DWORD cchText) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetDisplayName( 
            /* [in] */ REFFMTID fmtid,
            /* [in] */ PROPID pid,
            /* [size_is][out] */ LPWSTR pwszText,
            /* [in] */ DWORD cchText) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetPropertyDescription( 
            /* [in] */ REFFMTID fmtid,
            /* [in] */ PROPID pid,
            /* [size_is][out] */ LPWSTR pwszText,
            /* [in] */ DWORD cchText) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetDefaultWidth( 
            /* [in] */ REFFMTID fmtid,
            /* [in] */ PROPID pid,
            /* [out] */ ULONG __RPC_FAR *pcxChars) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetFlags( 
            /* [in] */ REFFMTID fmtid,
            /* [in] */ PROPID pid,
            /* [out] */ PROPERTYUI_FLAGS __RPC_FAR *pFlags) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE FormatForDisplay( 
            /* [in] */ REFFMTID fmtid,
            /* [in] */ PROPID pid,
            /* [in] */ const VARIANT __RPC_FAR *pvar,
            /* [in] */ PROPERTYUI_FORMAT_FLAGS flags,
            /* [size_is][out] */ LPWSTR pwszText,
            /* [in] */ DWORD cchText) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct IPropertyUIVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *QueryInterface )( 
            IPropertyUI __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppvObject);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *AddRef )( 
            IPropertyUI __RPC_FAR * This);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *Release )( 
            IPropertyUI __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *ParsePropertyName )( 
            IPropertyUI __RPC_FAR * This,
            /* [in] */ LPCWSTR pszName,
            /* [out] */ FMTID __RPC_FAR *pfmtid,
            /* [out] */ PROPID __RPC_FAR *ppid,
            /* [out] */ ULONG __RPC_FAR *pchEaten);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetCannonicalName )( 
            IPropertyUI __RPC_FAR * This,
            /* [in] */ REFFMTID fmtid,
            /* [in] */ PROPID pid,
            /* [size_is][out] */ LPWSTR pwszText,
            /* [in] */ DWORD cchText);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetDisplayName )( 
            IPropertyUI __RPC_FAR * This,
            /* [in] */ REFFMTID fmtid,
            /* [in] */ PROPID pid,
            /* [size_is][out] */ LPWSTR pwszText,
            /* [in] */ DWORD cchText);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetPropertyDescription )( 
            IPropertyUI __RPC_FAR * This,
            /* [in] */ REFFMTID fmtid,
            /* [in] */ PROPID pid,
            /* [size_is][out] */ LPWSTR pwszText,
            /* [in] */ DWORD cchText);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetDefaultWidth )( 
            IPropertyUI __RPC_FAR * This,
            /* [in] */ REFFMTID fmtid,
            /* [in] */ PROPID pid,
            /* [out] */ ULONG __RPC_FAR *pcxChars);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetFlags )( 
            IPropertyUI __RPC_FAR * This,
            /* [in] */ REFFMTID fmtid,
            /* [in] */ PROPID pid,
            /* [out] */ PROPERTYUI_FLAGS __RPC_FAR *pFlags);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *FormatForDisplay )( 
            IPropertyUI __RPC_FAR * This,
            /* [in] */ REFFMTID fmtid,
            /* [in] */ PROPID pid,
            /* [in] */ const VARIANT __RPC_FAR *pvar,
            /* [in] */ PROPERTYUI_FORMAT_FLAGS flags,
            /* [size_is][out] */ LPWSTR pwszText,
            /* [in] */ DWORD cchText);
        
        END_INTERFACE
    } IPropertyUIVtbl;

    interface IPropertyUI
    {
        CONST_VTBL struct IPropertyUIVtbl __RPC_FAR *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IPropertyUI_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define IPropertyUI_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define IPropertyUI_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define IPropertyUI_ParsePropertyName(This,pszName,pfmtid,ppid,pchEaten)	\
    (This)->lpVtbl -> ParsePropertyName(This,pszName,pfmtid,ppid,pchEaten)

#define IPropertyUI_GetCannonicalName(This,fmtid,pid,pwszText,cchText)	\
    (This)->lpVtbl -> GetCannonicalName(This,fmtid,pid,pwszText,cchText)

#define IPropertyUI_GetDisplayName(This,fmtid,pid,pwszText,cchText)	\
    (This)->lpVtbl -> GetDisplayName(This,fmtid,pid,pwszText,cchText)

#define IPropertyUI_GetPropertyDescription(This,fmtid,pid,pwszText,cchText)	\
    (This)->lpVtbl -> GetPropertyDescription(This,fmtid,pid,pwszText,cchText)

#define IPropertyUI_GetDefaultWidth(This,fmtid,pid,pcxChars)	\
    (This)->lpVtbl -> GetDefaultWidth(This,fmtid,pid,pcxChars)

#define IPropertyUI_GetFlags(This,fmtid,pid,pFlags)	\
    (This)->lpVtbl -> GetFlags(This,fmtid,pid,pFlags)

#define IPropertyUI_FormatForDisplay(This,fmtid,pid,pvar,flags,pwszText,cchText)	\
    (This)->lpVtbl -> FormatForDisplay(This,fmtid,pid,pvar,flags,pwszText,cchText)

#endif /* COBJMACROS */


#endif 	/* C style interface */



HRESULT STDMETHODCALLTYPE IPropertyUI_ParsePropertyName_Proxy( 
    IPropertyUI __RPC_FAR * This,
    /* [in] */ LPCWSTR pszName,
    /* [out] */ FMTID __RPC_FAR *pfmtid,
    /* [out] */ PROPID __RPC_FAR *ppid,
    /* [out] */ ULONG __RPC_FAR *pchEaten);


void __RPC_STUB IPropertyUI_ParsePropertyName_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IPropertyUI_GetCannonicalName_Proxy( 
    IPropertyUI __RPC_FAR * This,
    /* [in] */ REFFMTID fmtid,
    /* [in] */ PROPID pid,
    /* [size_is][out] */ LPWSTR pwszText,
    /* [in] */ DWORD cchText);


void __RPC_STUB IPropertyUI_GetCannonicalName_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IPropertyUI_GetDisplayName_Proxy( 
    IPropertyUI __RPC_FAR * This,
    /* [in] */ REFFMTID fmtid,
    /* [in] */ PROPID pid,
    /* [size_is][out] */ LPWSTR pwszText,
    /* [in] */ DWORD cchText);


void __RPC_STUB IPropertyUI_GetDisplayName_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IPropertyUI_GetPropertyDescription_Proxy( 
    IPropertyUI __RPC_FAR * This,
    /* [in] */ REFFMTID fmtid,
    /* [in] */ PROPID pid,
    /* [size_is][out] */ LPWSTR pwszText,
    /* [in] */ DWORD cchText);


void __RPC_STUB IPropertyUI_GetPropertyDescription_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IPropertyUI_GetDefaultWidth_Proxy( 
    IPropertyUI __RPC_FAR * This,
    /* [in] */ REFFMTID fmtid,
    /* [in] */ PROPID pid,
    /* [out] */ ULONG __RPC_FAR *pcxChars);


void __RPC_STUB IPropertyUI_GetDefaultWidth_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IPropertyUI_GetFlags_Proxy( 
    IPropertyUI __RPC_FAR * This,
    /* [in] */ REFFMTID fmtid,
    /* [in] */ PROPID pid,
    /* [out] */ PROPERTYUI_FLAGS __RPC_FAR *pFlags);


void __RPC_STUB IPropertyUI_GetFlags_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IPropertyUI_FormatForDisplay_Proxy( 
    IPropertyUI __RPC_FAR * This,
    /* [in] */ REFFMTID fmtid,
    /* [in] */ PROPID pid,
    /* [in] */ const VARIANT __RPC_FAR *pvar,
    /* [in] */ PROPERTYUI_FORMAT_FLAGS flags,
    /* [size_is][out] */ LPWSTR pwszText,
    /* [in] */ DWORD cchText);


void __RPC_STUB IPropertyUI_FormatForDisplay_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif 	/* __IPropertyUI_INTERFACE_DEFINED__ */



#ifndef __ShellObjects_LIBRARY_DEFINED__
#define __ShellObjects_LIBRARY_DEFINED__

/* library ShellObjects */
/* [version][lcid][helpstring][uuid] */ 


EXTERN_C const IID LIBID_ShellObjects;

EXTERN_C const CLSID CLSID_CompositeFolder;

#ifdef __cplusplus

class DECLSPEC_UUID("FEF10DED-355E-4e06-9381-9B24D7F7CC88")
CompositeFolder;
#endif

EXTERN_C const CLSID CLSID_ImageProperties;

#ifdef __cplusplus

class DECLSPEC_UUID("7ab770c7-0e23-4d7a-8aa2-19bfad479829")
ImageProperties;
#endif

EXTERN_C const CLSID CLSID_PropertiesUI;

#ifdef __cplusplus

class DECLSPEC_UUID("d912f8cf-0396-4915-884e-fb425d32943b")
PropertiesUI;
#endif
#endif /* __ShellObjects_LIBRARY_DEFINED__ */

/* Additional Prototypes for ALL interfaces */

unsigned long             __RPC_USER  HGLOBAL_UserSize(     unsigned long __RPC_FAR *, unsigned long            , HGLOBAL __RPC_FAR * ); 
unsigned char __RPC_FAR * __RPC_USER  HGLOBAL_UserMarshal(  unsigned long __RPC_FAR *, unsigned char __RPC_FAR *, HGLOBAL __RPC_FAR * ); 
unsigned char __RPC_FAR * __RPC_USER  HGLOBAL_UserUnmarshal(unsigned long __RPC_FAR *, unsigned char __RPC_FAR *, HGLOBAL __RPC_FAR * ); 
void                      __RPC_USER  HGLOBAL_UserFree(     unsigned long __RPC_FAR *, HGLOBAL __RPC_FAR * ); 

unsigned long             __RPC_USER  HMENU_UserSize(     unsigned long __RPC_FAR *, unsigned long            , HMENU __RPC_FAR * ); 
unsigned char __RPC_FAR * __RPC_USER  HMENU_UserMarshal(  unsigned long __RPC_FAR *, unsigned char __RPC_FAR *, HMENU __RPC_FAR * ); 
unsigned char __RPC_FAR * __RPC_USER  HMENU_UserUnmarshal(unsigned long __RPC_FAR *, unsigned char __RPC_FAR *, HMENU __RPC_FAR * ); 
void                      __RPC_USER  HMENU_UserFree(     unsigned long __RPC_FAR *, HMENU __RPC_FAR * ); 

unsigned long             __RPC_USER  HWND_UserSize(     unsigned long __RPC_FAR *, unsigned long            , HWND __RPC_FAR * ); 
unsigned char __RPC_FAR * __RPC_USER  HWND_UserMarshal(  unsigned long __RPC_FAR *, unsigned char __RPC_FAR *, HWND __RPC_FAR * ); 
unsigned char __RPC_FAR * __RPC_USER  HWND_UserUnmarshal(unsigned long __RPC_FAR *, unsigned char __RPC_FAR *, HWND __RPC_FAR * ); 
void                      __RPC_USER  HWND_UserFree(     unsigned long __RPC_FAR *, HWND __RPC_FAR * ); 

unsigned long             __RPC_USER  LPCITEMIDLIST_UserSize(     unsigned long __RPC_FAR *, unsigned long            , LPCITEMIDLIST __RPC_FAR * ); 
unsigned char __RPC_FAR * __RPC_USER  LPCITEMIDLIST_UserMarshal(  unsigned long __RPC_FAR *, unsigned char __RPC_FAR *, LPCITEMIDLIST __RPC_FAR * ); 
unsigned char __RPC_FAR * __RPC_USER  LPCITEMIDLIST_UserUnmarshal(unsigned long __RPC_FAR *, unsigned char __RPC_FAR *, LPCITEMIDLIST __RPC_FAR * ); 
void                      __RPC_USER  LPCITEMIDLIST_UserFree(     unsigned long __RPC_FAR *, LPCITEMIDLIST __RPC_FAR * ); 

unsigned long             __RPC_USER  LPITEMIDLIST_UserSize(     unsigned long __RPC_FAR *, unsigned long            , LPITEMIDLIST __RPC_FAR * ); 
unsigned char __RPC_FAR * __RPC_USER  LPITEMIDLIST_UserMarshal(  unsigned long __RPC_FAR *, unsigned char __RPC_FAR *, LPITEMIDLIST __RPC_FAR * ); 
unsigned char __RPC_FAR * __RPC_USER  LPITEMIDLIST_UserUnmarshal(unsigned long __RPC_FAR *, unsigned char __RPC_FAR *, LPITEMIDLIST __RPC_FAR * ); 
void                      __RPC_USER  LPITEMIDLIST_UserFree(     unsigned long __RPC_FAR *, LPITEMIDLIST __RPC_FAR * ); 

unsigned long             __RPC_USER  VARIANT_UserSize(     unsigned long __RPC_FAR *, unsigned long            , VARIANT __RPC_FAR * ); 
unsigned char __RPC_FAR * __RPC_USER  VARIANT_UserMarshal(  unsigned long __RPC_FAR *, unsigned char __RPC_FAR *, VARIANT __RPC_FAR * ); 
unsigned char __RPC_FAR * __RPC_USER  VARIANT_UserUnmarshal(unsigned long __RPC_FAR *, unsigned char __RPC_FAR *, VARIANT __RPC_FAR * ); 
void                      __RPC_USER  VARIANT_UserFree(     unsigned long __RPC_FAR *, VARIANT __RPC_FAR * ); 

/* end of Additional Prototypes */

#ifdef __cplusplus
}
#endif

#endif


