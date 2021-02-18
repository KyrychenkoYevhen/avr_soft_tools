unit delphisys;

interface

type
  PGUID = ^TGUID;
  TGUID = packed record
    D1: LongWord;
    D2: Word;
    D3: Word;
    D4: array[0..7] of Byte;
  end;

const
  IID_IUnknown: TGUID = ( D1: 0; D2: 0; D3: 0; D4: ( $C0, 0, 0, 0, 0, 0, 0, $46 ) );

(*
type
  IUnknown = interface ['{00000000-0000-0000-C000-000000000046}']
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  end;
*)

type
  StrRec = packed record
    allocSiz: Longint;
    refCnt: Longint;
    length: Longint;
  end;

const
        skew = sizeof(StrRec);
        rOff = sizeof(StrRec) - sizeof(Longint); { refCnt offset }
        overHead = sizeof(StrRec) + 1;

procedure LStrClr(var S: AnsiString);
procedure LStrToPChar{str: AnsiString): PChar};


implementation

procedure LStrClr(var S: AnsiString);
begin
asm
        { ->    EAX pointer to str      }

        MOV     EDX,[EAX]                       { fetch str                     }
        TEST    EDX,EDX                         { if nil, nothing to do         }
        JE      @@done
        MOV     dword ptr [EAX],0               { clear str                     }
        MOV     ECX,[EDX-skew].StrRec.refCnt    { fetch refCnt                  }
        DEC     ECX                             { if < 0: literal str           }
        JL      @@done
   LOCK DEC     [EDX-skew].StrRec.refCnt        { threadsafe dec refCount       }
        JNE     @@done
        PUSH    EAX
        LEA     EAX,[EDX-skew].StrRec.refCnt    { if refCnt now zero, deallocate}
        CALL    FreeMem
        POP     EAX
@@done:
end;
end;

procedure LStrToPChar{str: AnsiString): PChar};
asm
        { ->    EAX pointer to str              }
        { <-    EAX pointer to PChar    }

        TEST    EAX,EAX
        JE      @@handle0
        RET
@@zeroByte:
        DB      0
@@handle0:
        MOV     EAX,offset @@zeroByte
end;





end.
