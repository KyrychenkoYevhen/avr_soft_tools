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
/**


 Module: windbase.h

 Purpose: Master include file for WINCE Database APIs

**/

// @doc OBJSTORE
/*
@topic Windows CE Object Store |
    The Windows CE object store has 3 parts - a registry API, a file system API and a database API. 
    <nl>The standard Win32 API's supported by the registry are:
    <nl>RegCloseKey 
    <nl>RegCreateKeyEx
    <nl>RegDeleteKey
    <nl>RegDeleteValue
    <nl>RegEnumValue
    <nl>RegEnumKeyEx
    <nl>RegOpenKeyEx
    <nl>RegQueryInfoKey
    <nl>RegQueryValueEx
    <nl>RegSetValueEx

    The standard Win32 API's supported by the filesytem are:
    <nl>CreateDirectory
    <nl>RemoveDirectory
    <nl>MoveFile
    <nl>CopyFile
    <nl>DeleteFile
    <nl>GetFileAttributes
    <nl>FindFirstFile
    <nl>CreateFileW
    <nl>ReadFile
    <nl>WriteFile
    <nl>GetFileSize
    <nl>SetFilePointer
    <nl>GetFileInformationByHandle
    <nl>FlushFileBuffers
    <nl>GetFileTime
    <nl>SetFileTime
    <nl>SetEndOfFile
    <nl>FindClose
    <nl>FindNextFile

    In addition, the following additional filesystem call is available:
    <nl>CreateContainer

    The various functions and data structures are described in this
    document.
*/

#ifndef __WINDBASE__
#define __WINDBASE__

// @CESYSGEN IF CE_MODULES_FILESYS

/*
@type CEOID | Unique identifier for all WINCE objects
@comm Every WINCE object can be efficiently referred to by its OID. OID's are unique
      in the system and are not reused 
*/
typedef DWORD CEOID;
typedef CEOID *PCEOID;

typedef struct  _CEGUID {
    DWORD Data1;
    DWORD Data2;
    DWORD Data3;
    DWORD Data4;
} CEGUID, *PCEGUID;


#ifndef WM_DBNOTIFICATION
#define WM_DBNOTIFICATION 0x03FD
#else
ERRFALSE(WM_DBNOTIFICATION == 0x03FD);
#endif

#define CEDB_EXNOTIFICATION	0x00000001
typedef struct _CENOTIFYREQUEST {
    DWORD dwSize;   // must be set to the structure size
    HWND  hwnd;     // window handle for notifications to be posted
    DWORD dwFlags;
    HANDLE hHeap;   // heap from which to allocate EX-NOTIFICATIONS
    DWORD  dwParam;
} CENOTIFYREQUEST, *PCENOTIFYREQUEST;


typedef struct _CENOTIFICATION {
    DWORD dwSize;
    DWORD dwParam;
    UINT  uType;
    CEGUID guid;
    CEOID  oid;
    CEOID  oidParent;
} CENOTIFICATION, *PCENOTIFICATION;

// @CESYSGEN IF FILESYS_FSMAIN

// @struct CEFILEINFO | Contains information about a file object    
typedef struct _CEFILEINFO {
    DWORD    dwAttributes;         //@field File attributes
    CEOID    oidParent;            //@field CEOID of parent directory
    WCHAR    szFileName[MAX_PATH]; //@field Full path name of the file
    FILETIME ftLastChanged;        //@field Time stamp of last change
    DWORD    dwLength;             //@field Length of file
} CEFILEINFO, *PCEFILEINFO;

//@struct CEDIRINFO | Contains information about a directory object    
typedef struct _CEDIRINFO {
    DWORD dwAttributes;        //@field Directory attributes
    CEOID oidParent;           //@field CEOID of parent directory
    WCHAR szDirName[MAX_PATH]; //@field Full path name of the directory
} CEDIRINFO, *PCEDIRINFO;

/*
@msg DB_CEOID_CREATED | Msg sent on creation of new oid
@comm WParam == CEOID modified
      LParam == CEOID's parent CEOID
@xref <f CeRegisterReplNotification>      
*/
#define DB_CEOID_CREATED            (WM_USER + 0x1)
/*
@msg DB_CEOID_DATABASE_DELETED | Msg sent on deletion of database
@comm WParam == CEOID modified
      LParam == CEOID's parent CEOID
@xref <f CeRegisterReplNotification>      
*/
#define DB_CEOID_DATABASE_DELETED   (WM_USER + 0x2)
/*
@msg DB_CEOID_RECORD_DELETED | Msg sent on deletion of record
@comm WParam == CEOID modified
      LParam == CEOID's parent CEOID
@xref <f CeRegisterReplNotification>      
*/
#define DB_CEOID_RECORD_DELETED     (WM_USER + 0x3)
/*
@msg DB_CEOID_FILE_DELETED | Msg sent on deletion of file
@comm WParam == CEOID modified
      LParam == CEOID's parent CEOID
@xref <f CeRegisterReplNotification>      
*/
#define DB_CEOID_FILE_DELETED       (WM_USER + 0x4)
/*
@msg DB_CEOID_DIRECTORY_DELETED | Msg sent on deletion of directory
@comm WParam == CEOID modified
      LParam == CEOID's parent CEOID
@xref <f CeRegisterReplNotification>      
*/
#define DB_CEOID_DIRECTORY_DELETED  (WM_USER + 0x5)
/*
@msg DB_CEOID_CHANGED | Msg sent on item modification
@comm WParam == CEOID modified
      LParam == CEOID's parent CEOID
@xref <f CeRegisterReplNotification>      
*/
#define DB_CEOID_CHANGED            (WM_USER + 0x6)

// flags for CeGetReplChangeMask
#define REPL_CHANGE_WILLCLEAR   0x00000001

typedef struct STORE_INFORMATION {
    DWORD dwStoreSize;
    DWORD dwFreeSize;
} STORE_INFORMATION, *LPSTORE_INFORMATION;

BOOL GetStoreInformation (LPSTORE_INFORMATION lpsi);

// @CESYSGEN ENDIF

// @CESYSGEN IF FILESYS_FSDBASE

/*
@type CEPROPID | PropID's for WINCE properties
@comm PropID's on the WINCE match PropID's used by Mapi1. The top 2 bytes are an ID
     and the low 2 bytes are the type. For a list of supported types look at the tags
     supported in <t CEVALUNION>. We reserve one bit (0x4000) in the type as the 
     flag <b CEPROPVAL_NULL> as a special flag. It denotes that a property was not 
     found in a Read call, or that the property should be deleted in a write call.
*/
typedef DWORD CEPROPID;
typedef CEPROPID *PCEPROPID;
#define TypeFromPropID(propid) LOWORD(propid)

//@struct CERECORDINFO | Contains information about a record object    
typedef struct _CERECORDINFO {
    CEOID  oidParent;          //@field CEOID of parent database
} CERECORDINFO, *PCERECORDINFO;

#define CEDB_SORT_DESCENDING        0x00000001
#define CEDB_SORT_CASEINSENSITIVE   0x00000002
#define CEDB_SORT_UNKNOWNFIRST      0x00000004
#define CEDB_SORT_GENERICORDER      0x00000008  // internally used for generic ordering
#define CEDB_SORT_IGNORENONSPACE    0x00000010
#define CEDB_SORT_IGNORESYMBOLS     0x00000020
#define CEDB_SORT_IGNOREKANATYPE    0x00000040
#define CEDB_SORT_IGNOREWIDTH       0x00000080
#define CEDB_SORT_STRINGSORT        0x00000100
#define CEDB_SORT_UNIQUE            0x00000200
#define CEDB_SORT_NONNULL           0x00000400
// High nibble of flags reserved
//@struct SORTORDERSPEC | Specifies details about a sort order in a database
//@comm Note that we only support simple sorts on a primary key. Records with the same key value
//      will be sorted in arbitrary order.
typedef struct _SORTORDERSPEC {
    CEPROPID  propid;   //@field PropID to be sorted on.
    DWORD     dwFlags;  //@field Any combination of the following
                        //@flag CEDB_SORT_DESCENDING | Sort in descending order. Default is ascending.
                        //@flag CEDB_SORT_CASEINSENSITIVE | Only valid for strings.
                        //@flag CEDB_SORT_UNKNOWNFIRST | Puts records which do 
                        // not contain this property before all the other records.
                        // Default is to put them last.
                        //@flag CEDB_SORT_IGNORENONSPACE | Only valid for strings.
                        // This flag only has an effect for the locales in which 
                        // accented characters are sorted in a second pass from
                        // main characters.
                        //@flag CEDB_SORT_IGNORESYMBOLS | Only valid for strings.
                        //@flag CEDB_SORT_IGNOREKANATYPE | Only valid for strings.
                        // Do not differentiate between Hiragana and Katakana characters.
                        //@flag CEDB_SORT_IGNOREWIDTH | Only valid for strings.
                        // Do not differentiate between a single-byte character 
                        // and the same character as a double-byte character.
                        //@flag CEDB_SORT_UNIQUE | Require the property to be
                        // unique across all records in the database.
                        //@flag CEDB_SORT_NONNULL | Require the property to be
                        // present in all records.
} SORTORDERSPEC, *PSORTORDERSPEC;

#define CEDB_MAXSORTPROP 3

#define SORTORDERSPECEX_VERSION 1
//@struct SORTORDERSPECEX | Specifies details about a sort order in a database
//@comm Supports a hierarchy of sorts.
typedef struct _SORTORDERSPECEX {
    WORD      wVersion;    //@field Version of this structure.
    WORD      wNumProps;   //@field Number of properties in this sort order.
                           // Must not be more than CEDB_MAXSORTPROP.
    WORD      wKeyFlags;   //@field Flags that correspond to the sort key.
                           // Any combination of the following:
                           //@flag CEDB_SORT_UNIQUE | Require the key to be
                           // unique across all records in the database.
    WORD      wReserved;   //Padding for DWORD alignment
    CEPROPID  rgPropID[CEDB_MAXSORTPROP]; //@field Array of PropIDs to be sorted
                           // on, in order of importance.
    DWORD     rgdwFlags[CEDB_MAXSORTPROP]; //@field Flags that correspond to the sort PropIDs
                           // Any combination of the following:
                           //@flag CEDB_SORT_DESCENDING | Sort in descending order. Default is ascending
                           //@flag CEDB_SORT_CASEINSENSITIVE | Only valid for strings.
                           //@flag CEDB_SORT_UNKNOWNFIRST | Puts records which do 
                           // not contain this property before all the other records.
                           // Default is to put them last.
                           //@flag CEDB_SORT_IGNORENONSPACE | Only valid for strings.
                           // This flag only has an effect for the locales in which 
                           // accented characters are sorted in a second pass from
                           // main characters.
                           //@flag CEDB_SORT_IGNORESYMBOLS | Only valid for strings.
                           //@flag CEDB_SORT_IGNOREKANATYPE | Only valid for strings.
                           // Do not differentiate between Hiragana and Katakana characters.
                           //@flag CEDB_SORT_IGNOREWIDTH | Only valid for strings.
                           // Do not differentiate between a single-byte character 
                           // and the same character as a double-byte character.
                           //@flag CEDB_SORT_NONNULL | Require the property to be
                           // present in all records.
} SORTORDERSPECEX, *PSORTORDERSPECEX;

// NOTENOTE someday this should become a separate CE-only error code
#define ERROR_DBPROP_NOT_FOUND  ERROR_ACCESS_DENIED
#define ERROR_REPEATED_KEY      ERROR_ALREADY_EXISTS

#define CEDB_MAXDBASENAMELEN 32
#define CEDB_MAXSORTORDER    4

// values for validity mask flags
#define CEDB_VALIDNAME     0x0001
#define CEDB_VALIDTYPE     0x0002
#define CEDB_VALIDSORTSPEC 0x0004
#define CEDB_VALIDMODTIME  0x0008
#define CEDB_VALIDDBFLAGS  0x0010
#define CEDB_VALIDCREATE   (CEDB_VALIDNAME | CEDB_VALIDTYPE | CEDB_VALIDSORTSPEC | CEDB_VALIDDBFLAGS)

// values for dbflags
#define CEDB_NOCOMPRESS    0x00010000
#define CEDB_SYSTEMDB      0x00020000


// @struct CEDBASEINFO | Contains information about a database object    
typedef struct _CEDBASEINFO {
    DWORD    dwFlags;           //@field Indicates which fields are valid. Possible values are:
                                //  @flag CEDB_VALIDNAME | The name field is valid and should be used
                                //  @flag CEDB_VALIDTYPE | The type field is valid and should be used
                                //  @flag CEDB_VALIDSORTSPEC | The sortspecs are valid and should be used
    WCHAR    szDbaseName[CEDB_MAXDBASENAMELEN]; //@field Name of Database. Max CEDB_MAXDBASENAMELEN characters.
    DWORD    dwDbaseType;       //@field A type ID for this database
    WORD     wNumRecords;       //@field Number of records in the database
    WORD     wNumSortOrder;     //@field Number of sort orders active in the database
                                // Maximum is CEDB_MAXSORTORDER.
    DWORD    dwSize;            //@field Size in bytes that this database is using
    FILETIME ftLastModified;    //@field Last time this database was modified
    SORTORDERSPEC rgSortSpecs[CEDB_MAXSORTORDER];  //@field Actual sort order descriptions. 
                                // Only first wNumSortOrder of this array are valid.
} CEDBASEINFO, *PCEDBASEINFO;

#define CEDBASEINFOEX_VERSION 1
// @struct CEDBASEINFOEX | Contains extended information about a database object    
typedef struct _CEDBASEINFOEX {
    WORD     wVersion;          //@field Version of this structure
    WORD     wNumSortOrder;     //@field Number of sort orders active in the database
                                // Maximum is CEDB_MAXSORTORDER.
    DWORD    dwFlags;           //@field Indicates which fields are valid. Possible values are:
                                //  @flag CEDB_VALIDNAME | The name field is valid and should be used
                                //  @flag CEDB_VALIDTYPE | The type field is valid and should be used
                                //  @flag CEDB_VALIDSORTSPEC | The sortspecs are valid and should be used
    WCHAR    szDbaseName[CEDB_MAXDBASENAMELEN]; //@field Name of Database. Max CEDB_MAXDBASENAMELEN characters.
    DWORD    dwDbaseType;       //@field A type ID for this database
    DWORD    dwNumRecords;      //@field Number of records in the database
    DWORD    dwSize;            //@field Size in bytes that this database is using
    FILETIME ftLastModified;    //@field Last time this database was modified
    SORTORDERSPECEX rgSortSpecs[CEDB_MAXSORTORDER];  //@field Actual sort order descriptions. 
                                // Only first wNumSortOrder of this array are valid.
} CEDBASEINFOEX, *PCEDBASEINFOEX;


#define BY_HANDLE_DB_INFORMATION_VERSION 1
// @struct BY_HANDLE_DB_INFORMATION | Contains extended information about an open database
typedef struct _BY_HANDLE_DB_INFORMATION {
    WORD     wVersion;          //@field Version of this structure
    WORD     wReserved;         //Padding for DWORD alignment
    CEGUID   guidVol;           //@field GUID of parent volume
    CEOID    oidDbase;          //@field OID of database
    CEDBASEINFOEX infDatabase;  //@field Extended database information
} BY_HANDLE_DB_INFORMATION, *LPBY_HANDLE_DB_INFORMATION;


// flags for open database - use low word
#define CEDB_AUTOINCREMENT          0x00000001

#define CEDB_SEEK_CEOID             0x00000001
#define CEDB_SEEK_BEGINNING         0x00000002
#define CEDB_SEEK_END               0x00000004
#define CEDB_SEEK_CURRENT           0x00000008
#define CEDB_SEEK_VALUESMALLER      0x00000010
#define CEDB_SEEK_VALUEFIRSTEQUAL   0x00000020
#define CEDB_SEEK_VALUEGREATER      0x00000040
#define CEDB_SEEK_VALUENEXTEQUAL    0x00000080


typedef struct _CEBLOB {
    DWORD           dwCount;
    LPBYTE          lpb;
} CEBLOB, *PCEBLOB;


#define CEVT_I2       2
#define CEVT_UI2      18
#define CEVT_I4       3
#define CEVT_UI4      19
#define CEVT_FILETIME 64
#define CEVT_LPWSTR   31
#define CEVT_BLOB     65
#define CEVT_BOOL     11
#define CEVT_R8       5

// @union CEVALUNION | value types for a property
typedef union _CEVALUNION {
    short           iVal;     //@field CEVT_I2
    USHORT          uiVal;    //@field CEVT_UI2
    long            lVal;     //@field CEVT_I4
    ULONG           ulVal;    //@field CEVT_UI4
    FILETIME        filetime; //@field CEVT_FILETIME 
    LPWSTR          lpwstr;   //@field CEVT_LPWSTR - Ptr to null terminated string
    CEBLOB          blob;     //@field CEVT_BLOB - DWORD count, and Ptr to bytes
    BOOL            boolVal;  //@field CEVT_BOOL
    double          dblVal;   //@field CEVT_R8
} CEVALUNION, *PCEVALUNION;
 
// @struct CEPROPVAL | Contains a property value
// Don't define flags in low byte or high nibble
#define CEDB_PROPNOTFOUND 0x0100
#define CEDB_PROPDELETE   0x0200
typedef struct _CEPROPVAL {
    CEPROPID   propid;    //@field PropID of the value.
    WORD       wLenData;  //@field Private field - can be garbage on entry
    WORD       wFlags;    //@field Special flags for this property. Possible flags
                          //@flag CEDB_PROPNOTFOUND | Set by <f CeReadRecordProps> if property not found
                          //@flag CEDB_PROPDELETE | If passed to <f CeWriteRecordProps> it causes 
                          // this property to be deleted
    CEVALUNION val;       //@field Actual value for simple types, ptr for strings/blobs                        
} CEPROPVAL, *PCEPROPVAL;

// Max record length defines
// zero is a valid length so we cant have full 4196
#define CEDB_MAXDATABLOCKSIZE 4092
#define CEDB_MAXPROPDATASIZE  ((CEDB_MAXDATABLOCKSIZE*16)-1)
// max record size is bound only by the max logging space we want to consume
// this is not explicitly checked for - if you read too much data and cause the log
// page to overflow the call will fail.
#define CEDB_MAXRECORDSIZE (128*1024)

// Max number of records allowed in a single database.
#define CEDB_MAXNUMRECORDS 0xFFFF

// flags for ReadRecord
#define CEDB_ALLOWREALLOC  0x00000001

#define CREATE_SYSTEMGUID(pguid)  (memset((pguid), 0, sizeof(CEGUID)))
#define CREATE_INVALIDGUID(pguid) (memset((pguid), -1, sizeof(CEGUID)))

#define CHECK_SYSTEMGUID(pguid)   ! ((pguid)->Data1 | (pguid)->Data2 | (pguid)->Data3 | (pguid)->Data4)
#define CHECK_INVALIDGUID(pguid)  !~((pguid)->Data1 & (pguid)->Data2 & (pguid)->Data3 & (pguid)->Data4)

// Obsolete versions for backward compatibility
HANDLE CeFindFirstDatabase (DWORD dwClassID);
CEOID CeFindNextDatabase (HANDLE hEnum);
CEOID CeCreateDatabase (LPWSTR lpszname, DWORD dwClassID, WORD wNumSortOrder,
                        SORTORDERSPEC *rgSortSpecs);
CEOID CeCreateDatabaseEx (PCEGUID pguid, CEDBASEINFO *pInfo);
BOOL CeSetDatabaseInfo (CEOID oidDbase, CEDBASEINFO *pNewInfo);
BOOL CeSetDatabaseInfoEx (PCEGUID pguid, CEOID oidDbase, CEDBASEINFO *pNewInfo);
HANDLE CeOpenDatabase (PCEOID poid, LPWSTR lpszName, CEPROPID propid,
                       DWORD dwFlags, HWND hwndNotify);
HANDLE CeOpenDatabaseEx (PCEGUID pguid, PCEOID poid, LPWSTR lpszName,
                         CEPROPID propid, DWORD dwFlags, CENOTIFYREQUEST *pReq);
BOOL CeDeleteDatabase (CEOID oid);
CEOID CeReadRecordProps (HANDLE hDbase, DWORD dwFlags, LPWORD lpcPropID,
                         CEPROPID *rgPropID, LPBYTE *lplpBuffer,
                         LPDWORD lpcbBuffer);
CEOID CeSeekDatabase (HANDLE hDatabase, DWORD dwSeekType, DWORD dwValue,
                      LPDWORD lpdwIndex);

BOOL CeGetDBInformationByHandle (HANDLE hDbase, LPBY_HANDLE_DB_INFORMATION lpDBInfo);
HANDLE CeFindFirstDatabaseEx (PCEGUID pguid, DWORD dwClassID);
CEOID CeFindNextDatabaseEx (HANDLE hEnum, PCEGUID pguid);
CEOID CeCreateDatabaseEx2 (PCEGUID pguid, CEDBASEINFOEX *pInfo);
BOOL CeSetDatabaseInfoEx2 (PCEGUID pguid, CEOID oidDbase, CEDBASEINFOEX *pNewInfo);
HANDLE CeOpenDatabaseEx2 (PCEGUID pguid, PCEOID poid, LPWSTR lpszName,
                          SORTORDERSPECEX* pSort, DWORD dwFlags,
                          CENOTIFYREQUEST *pReq);
BOOL CeDeleteDatabaseEx (PCEGUID pguid, CEOID oid);
CEOID CeSeekDatabaseEx (HANDLE hDatabase, DWORD dwSeekType, DWORD dwValue,
                        WORD wNumVals, LPDWORD lpdwIndex);
BOOL CeDeleteRecord (HANDLE hDatabase, CEOID oidRecord);
CEOID CeReadRecordPropsEx (HANDLE hDbase, DWORD dwFlags, LPWORD lpcPropID,
                           CEPROPID *rgPropID, LPBYTE *lplpBuffer, 
                           LPDWORD lpcbBuffer, HANDLE hHeap);
CEOID CeWriteRecordProps (HANDLE hDbase, CEOID oidRecord, WORD cPropID,
                          CEPROPVAL *rgPropVal);

BOOL CeMountDBVol(PCEGUID pguid, LPWSTR lpszVol, DWORD dwFlags);
BOOL CeUnmountDBVol(PCEGUID pguid);
BOOL CeFlushDBVol(PCEGUID pguid);
BOOL CeEnumDBVolumes(PCEGUID pguid, LPWSTR lpBuf, DWORD dwSize);
BOOL CeFreeNotification(PCENOTIFYREQUEST pRequest, PCENOTIFICATION pNotify);

// @CESYSGEN ENDIF


// @CESYSGEN IF FILESYS_FSMAIN

/*
@struct CEOIDINFO | Contains information about a WINCE object
@field WORD | wObjType | Type of object
   @flag   OBJTYPE_INVALID   | There was no valid object with this CEOID
   @flag   OBJTYPE_FILE      | The object is a file
   @flag   OBJTYPE_DIRECTORY | The object is a directory
   @flag   OBJTYPE_DATABASE  | The object is a database
   @flag   OBJTYPE_RECORD    | The object is a record inside a database
@field <lt>SeeBelow<gt> | <lt>CEOIDINFOUNIONref<gt> | Note: The remaining members form a union
@field CEFILEINFO   | infFile      | Valid for file objects
@field CEDIRINFO    | infDirectory | Valid for directory objects
@field CEDBASEINFO  | infDatabase  | Valid for database objects
@field CERECORDINFO | infRecord    | Valid for record objects
@xref   <t CEFILEINFO>  <t CEDIRINFO> <t CEDBASEINFO>  <t CERECORDINFO>
*/
#define OBJTYPE_INVALID     0
#define OBJTYPE_FILE        1
#define OBJTYPE_DIRECTORY   2
#define OBJTYPE_DATABASE    3
#define OBJTYPE_RECORD      4

typedef struct _CEOIDINFO {
    WORD  wObjType;     //Type of object
            //        OBJTYPE_INVALID   | There was no valid object with this CEOID
            //        OBJTYPE_FILE      | The object is a file
            //        OBJTYPE_DIRECTORY | The object is a directory
            //        OBJTYPE_DATABASE  | The object is a database
            //        OBJTYPE_RECORD    | The object is a record inside a database
    WORD   wPad;        // dword alignment            
    union {             //This is a union 
        CEFILEINFO  infFile;           //Valid for file objects
        CEDIRINFO   infDirectory;      //Valid for directory objects
// @CESYSGEN IF FILESYS_FSDBASE
        CEDBASEINFO infDatabase;       //Valid for database objects
        CERECORDINFO infRecord;        //Valid for record objects
// @CESYSGEN ENDIF
    };
} CEOIDINFO, PCEOIDINFO;

#define CEOIDINFOEX_VERSION 1
/*
@struct CEOIDINFOEX | Contains extended information about a WINCE object
@field WORD | wObjType | Type of object
   @flag   OBJTYPE_INVALID   | There was no valid object with this CEOID
   @flag   OBJTYPE_FILE      | The object is a file
   @flag   OBJTYPE_DIRECTORY | The object is a directory
   @flag   OBJTYPE_DATABASE  | The object is a database
   @flag   OBJTYPE_RECORD    | The object is a record inside a database
@field <lt>SeeBelow<gt> | <lt>CEOIDINFOUNIONref<gt> | Note: The remaining members form a union
@field CEFILEINFO   | infFile      | Valid for file objects
@field CEDIRINFO    | infDirectory | Valid for directory objects
@field CEDBASEINFO  | infDatabase  | Valid for database objects
@field CERECORDINFO | infRecord    | Valid for record objects
@xref   <t CEFILEINFO>  <t CEDIRINFO> <t CEDBASEINFO>  <t CERECORDINFO>
*/
typedef struct _CEOIDINFOEX {
    WORD  wVersion;    //@field Version of this structure
    WORD  wObjType;    //@field Type of object
                //@flag OBJTYPE_INVALID   | There was no valid object with this CEOID
                //@flag OBJTYPE_FILE      | The object is a file
                //@flag OBJTYPE_DIRECTORY | The object is a directory
                //@flag OBJTYPE_DATABASE  | The object is a database
                //@flag OBJTYPE_RECORD    | The object is a record inside a database
    union {
        CEFILEINFO    infFile;       // Valid for file objects
        CEDIRINFO     infDirectory;  // Valid for directory objects
// @CESYSGEN IF FILESYS_FSDBASE
        CEDBASEINFOEX infDatabase;   // Valid for database objects
        CERECORDINFO  infRecord;     // Valid for record objects
// @CESYSGEN ENDIF
    };
} CEOIDINFOEX, PCEOIDINFOEX;

// Functions
BOOL CeOidGetInfoEx2 (PCEGUID pguid, CEOID oid, CEOIDINFOEX *oidInfo);
BOOL CeOidGetInfoEx (PCEGUID pguid, CEOID oid, CEOIDINFO *oidInfo);
BOOL CeOidGetInfo (CEOID oid, CEOIDINFO *oidInfo);

// @CESYSGEN ENDIF

#ifdef WINCEOEM
#include <pwindbas.h>   // internal defines 
#ifdef WINCEMACRO
#include <mwindbas.h>
#endif
#endif

// @CESYSGEN ENDIF

#endif

