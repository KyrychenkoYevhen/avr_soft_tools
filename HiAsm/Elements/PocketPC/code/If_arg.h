#ifndef __IF_ARG_H_
#define __IF_ARG_H_

#include "share.h" 

bool Compare(TData &Op1, TData &Op2, BYTE opType )
{ 
  int i; 
  double r; 
  string s; 

  switch (Op1.data_type) 
  { 
    case data_int: 
       i = ToInteger(Op2); 
       switch (opType) 
       { 
          case 0: return (Op1.idata == i);
          case 1: return (Op1.idata < i);
          case 2: return (Op1.idata > i);
          case 3: return (Op1.idata <= i);
          case 4: return (Op1.idata >= i);
          case 5: return (Op1.idata != i);
       }
    case data_real:
       r = ToReal(Op2); 
       switch (opType) 
       { 
         case 0: return (Op1.rdata == r);
         case 1: return (Op1.rdata < r);
         case 2: return (Op1.rdata > r);
         case 3: return (Op1.rdata <= r);
         case 4: return (Op1.rdata >= r);
         case 5: return (Op1.rdata != r);
       }
    case data_str:
       s = ToString(Op2);
       switch (opType)
       {
         case 0: return (Op1.sdata == s);
         case 1: return (Op1.sdata.Length() < s.Length());
         case 2: return (Op1.sdata.Length() > s.Length());
         case 3: return (Op1.sdata.Length() <= s.Length());
         case 4: return (Op1.sdata.Length() >= s.Length());
         case 5: return !(Op1.sdata == s);
       }
    default: return false;
  }
}

#endif
