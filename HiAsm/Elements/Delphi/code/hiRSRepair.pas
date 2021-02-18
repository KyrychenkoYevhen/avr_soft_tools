unit hiRSRepair;

interface

uses kol, Share, Debug;

const
  ERROR_CORRECTION_NOT_NEED       = 0;
  ERROR_SUCCESS_CORRECTION        = 1;
  ERROR_CORRECTION_IMPOSSIBLE     = 2;
  ERROR_INCORRECT_DATA_LENGTH     = 3;
  ERROR_INCORRECT_CHECKBLOCK_LENGTH = 4;

const
  mm  = 8;       (* ������� RS-�������� (�������� ��������� ECMA-130 - ������ *)
  nn  = 255;     (* nn = 2 * mm - 1 (����� �������� �����) *)
  tt  = 16;      (* ���������� ������, ������� �� ����� ��������������� *)
  kk  = 223;     (* kk = nn - 2 * tt (����� ��������������� �����) *)
  ltt = nn - kk; (* ����� ��������������� ����� *)

  (* ������������ ����������� �������, �������� ��������� ECMA-130: P(x) = x8 + x4 + x3 + x2 + 1 *)
  pp:       array [0..mm]            of integer =  (1, 0, 1, 1, 1, 0, 0, 0, 1);

type
 THiRSRepair = class(TDebug)
   private

     alpha_to: array [0..nn]            of integer; (* ������� �������� ������������ ����� *)
     index_of: array [0..nn]            of integer; (* ��������� ������� ��� �������� ��������� *)

     gg:       array [0..ltt]       of integer; 
     recd:     array [0..Pred(nn)]      of integer; 
     data:     array [0..Pred(kk)]      of integer; 
     bb:       array [0..Pred(ltt)] of integer; 

     FDataBlock: string;
     FRemaind: string;
     FCheckBlock: string;
     FRepairDataBlock: string;
     FCountErrors: integer;
     Fldb: integer;
          
     procedure SetFldb(Value: integer);
     procedure generate_gf_gp;
     procedure encode_rs;     
     function decode_rs: integer;
   public
     _prop_ValueSymbolFill: integer;     

     _data_DataEncode: THI_Event;
     _data_DataDecode: THI_Event;      
     _data_ChkSumDecode: THI_Event;
     
     _event_onEncode: THI_Event;
     _event_onDecode: THI_Event;     
     _event_onInfo: THI_Event;
     
     property _prop_LengthDataBlock: integer read Fldb write SetFldb;

     constructor Create;
     procedure _work_doEncode(var _Data:TData; Index:word);
     procedure _work_doDecode(var _Data:TData; Index:word);
     
     procedure _work_doLengthDataBlock(var _Data:TData; Index:word);     
     procedure _work_doValueSymbolFill(var _Data:TData; Index:word);     

     procedure _var_DataBlock(var _Data:TData; Index:word);
     procedure _var_Remaind(var _Data:TData; Index:word);
     procedure _var_CheckBlock(var _Data:TData; Index:word);          
     procedure _var_CountErrors(var _Data:TData; Index:word);
     procedure _var_RepairDataBlock(var _Data:TData; Index:word);          
          
 end;

implementation

constructor THiRSRepair.Create;
begin
  inherited;
  generate_gf_gp();
end;  


(*----------------------------------------------------------------------------
*
* ��������� ����� �����
* ========================
*
* ���������� look-up ������� ��� �������� ��������� ��� GF(2 ^ m) �� ������
* ������������� ������������ �������� Pc �� pp[0] �� pp[m].
*
* look-up �������:
* index->polynomial �� alpha_to[] �������� j = alpha ^ i,
* ��� alpha ���� ����������� ����, ������ ������ 2
*
* �������������� ����� -> index �� index_of[j = alpha ^ i] = i;
*----------------------------------------------------------------------------*)

procedure THiRSRepair.generate_gf_gp; 
var
  i: integer;
  j: integer;    
  mask: integer; 
begin
  mask := 1; 
  alpha_to[mm] := 0; 
  for i := 0 to Pred(mm) do
  begin 
    alpha_to[i] := mask; 
    index_of[alpha_to[i]] := i; 
    if pp[i] <> 0 then alpha_to[mm]:= alpha_to[mm] xor (mask); 
    mask := mask shl 1; 
  end;
  index_of[alpha_to[mm]] := mm; 
  mask := mask shr 1; 
  for i := mm + 1 to Pred(nn) do
  begin 
    if alpha_to[i - 1] >= mask then
      alpha_to[i] := alpha_to[mm] xor ((alpha_to[i - 1] xor mask) shl 1) 
    else
      alpha_to[i] := alpha_to[i - 1] shl 1; 
    index_of[alpha_to[i]] := i; 
  end;
  index_of[0] := -1; 

(*----------------------------------------------------------------------------
*
* ��������� ��������� ���������
*
* ==================================
* ���������� ����������� �������� ��� ��������� tt-������, ������ nn = (2 ^ mm - 1)
* �� (X + alpha ^ i), ��� i = 1..2 * tt
*----------------------------------------------------------------------------*)

  gg[0] := 2; 
  gg[1] := 1; (* ����������� ���� alpha = 2 *)

  (* g(x) = (X+alpha) initially *)
  for i := 2 to ltt do
  begin 
    gg[i] := 1; 
    for j := i - 1 downto Succ(0) do
      if gg[j] <> 0 then
        gg[j] := gg[j - 1] xor alpha_to[(index_of[gg[j]] + i) mod nn] 
      else
        gg[j] := gg[j - 1]; 
    gg[0] := alpha_to[(index_of[gg[0]] + i) mod nn]; (* gg[0] �� ����� ������� ���� ������� *)
  end;

  (* ����������� gg[] �� �������������� ����� � ��������� ��� ����� �������� ����������� *)
  for i := 0 to ltt do gg[i] := index_of[gg[i]]; 
end;

(*----------------------------------------------------------------------------
*
* ����� ����-��������
* ========================
*
* ���������� ������ ���������� ����� ������ data[i], ��� i = 0...(kk - 1),
* � ��������������� ������� �������� ��������� � ������ bb[0]...bb[2 * tt - 1].
* �������� � �������������� ������ ������ ���� ������������ � ��������������
* ����� (�.�. � ������� ����� ��������� ������������� ������).
* ����������� ������������ � �������������� ���������� feedback-��������,
* ������������ ���������������� ���������� ������� gg[] � �����������
* ��������� ������, ��������� ��������� �������� ��� ����������� �
* ���������� �����.
* ��������������� ������� ����� ����������� ��������� ��������:
* �(x) = data(x) * x ^ (nn - kk) + bb(x)
-----------------------------------------------------------------------------*)

procedure THiRSRepair.encode_rs;
var
  i: integer;
  j: integer;
  feedback: integer;
begin
  for i := 0 to Pred(ltt) do bb[i] := 0;
  for i := kk - 1 downto 0 do
  begin
    feedback := index_of[data[i] xor bb[ltt - 1]];
    if feedback <> -1 then
    begin
      for j := ltt - 1 downto Succ(0) do
        if gg[j] <> -1 then
          bb[j] := bb[j - 1] xor alpha_to[(gg[j] + feedback) mod nn]
        else
          bb[j] := bb[j - 1];
      bb[0] := alpha_to[(gg[0] + feedback) mod nn];
    end
    else
    begin
      for j := ltt - 1 downto Succ(0) do
        bb[j] := bb[j - 1];
      bb[0] := 0;
    end;
  end;
end;

(*----------------------------------------------------------------------------
*
* ������� ����-��������
* =====================
*
* ��������� ������������� ����� ����-�������� ������� �� ���������� �����:
* ������� �� ��������� 2t-���������� ������� ����� ���������� alpha ^ i �
* recd(x), ��� recd - ���������� ������� �����, �������������� ������������
* � ��������� �����. �� ����� ���������� recd(x) �� ���������� ���������
* ������ �������� � s[i], ��� i ��������� �������� �� 1 �� 2tt, ��������
* s[0] ������ ����.
* �����, ��������� ����������� �������� ���������� (Berlekamp), ��
* ������� ������� �������� ������ - elp[i]. ���� ������� elp ���������
* ����� �������� tt, �� ��������� ��������������� ��� ������ � ��������������
* ������� ��������� � ������������ ������, ����� ���� ��������� ���������
* ����� �� ��������. ���� �� ������� elp �� ��������� t, �� �����������
* alpha ^ i, ��� i = 1...nn � elp ��� ���������� ������ ��������. ���������
* ��������� ������ ���� ��� ������� ���������� ��������. ���� ����������
* ������������ ������� ���������� �������� ������ ������� elp, ���������
* ����������� ����� ��� t �������� � �� �� ����� ������������ ��.
* �� ���� ��������� ������� �������������� ������������� �����������
* ���������� �������� ������ ��������.
* � ������, ����� ���������� ������ �������� ������, ��� �� �����������
* ������������ ������� �������� ������ ������� ��� ����� ���� ���������
-----------------------------------------------------------------------------*)

function THiRSRepair.decode_rs; 

  procedure end_operation();
  var
    ii: integer;
  begin
    for ii := 0 to Pred(nn) do
      if recd[ii] <> -1 then   (* ��������� recd[] � �������������� ����� *)
        recd[ii] := alpha_to[recd[ii]] 
      else
        recd[ii] := 0; (* ������� �������������� ����� "��� ����" *)
  end;

var
  i: integer; 
  j: integer; 
  u: integer; 
  q: integer; 
  count: integer;
  syn_error: integer;

  elp:  array [0..Pred(ltt + 2),0..Pred(ltt)] of integer; 
  d:    array [0..Pred(ltt + 2)]                  of integer; 
  l:    array [0..Pred(ltt + 2)]                  of integer; 
  u_lu: array [0..Pred(ltt + 2)]                  of integer; 
  s:    array [0..Pred(ltt + 1)]                  of integer; 
 
  root: array [0..Pred(tt)]     of integer; 
  loc:  array [0..Pred(tt)]     of integer; 
  z:    array [0..Pred(tt + 1)] of integer; 
  err:  array [0..Pred(nn)]     of integer; 
  reg:  array [0..Pred(tt + 1)] of integer; 
begin
  syn_error := 0; 
  
  (* ��������� ���������� ������� ����� � ��������� ����� ��� ��������� ���������� *)
  for i := 0 to Pred(nn) do recd[i] := index_of[recd[i]];

 (*  ������������� s-��������
     �� ��� ���� �� ��������� ��������� ����
     ��������� s[i] += recd[j] * ij
     �.�. ����� ��������� ������ ������������ ������,
     �������� ��� �� ���������� ����� ������� �������,
     ���������� �� ����� ���������� ������� � ����������
     ���������� ��������� � ���������� s-��������;
     �� ����� ���������� ���� ������������ ������ ��
     ��������� ���� ���� ���������� ����� - �� ������
     ���� ��� ������� ������� �������� *)
     
  for i := 1 to ltt do
  begin 
    s[i] := 0; 
    for j := 0 to Pred(nn) do
      if recd[j] <> -1 then
        s[i] := s[i] xor (alpha_to[(recd[j] + i * j) mod nn]); (* recd[j] � ��������� ����� *)

    if s[i] <> 0 then
      syn_error := 1; (* ���� ������� �� ����� ����, ������� ���� ������ *) 
    (* ����������� ������� �� �������������� ����� � ��������� *)
    s[i] := index_of[s[i]]; 
  end;

  if syn_error <> 0 then (* ���� ���� ������, �������� �� ��������������� *)
  begin 
    (* ���������� �������� �������� ������
       -------------------------------------------------------------------
       ��������� ������� �������� ������ ����� ����������� ��������
       ����������. ������ ������������ Lin and Costello (��. "Error
       Control Coding: Fundamentals and Applications" Prentice Hall 1983
       ISBN 013283796) d[u] ������������ ����� m ("��"), ����������
       ����������� (discrepancy), ��� u = m + 1 � m ���� ����� ����
       �� ��������� �� -1 �� 2tt. � �������� �� �� ����� ��������
       ������������ D(x) ("������") � ���������� �������.
       l[u] ������������ ����� ������� elp ��� ������� ���� ��������,
       u_l[u] ������������ ����� ������� ����� ������� ���� � �������� elp *)


    (* �������������� �������� ������� *)
    d[0] := 0;      (* ��������� ����� *) 
    d[1] := s[1];   (* ��������� ����� *) 
    elp[0][0] := 0; (* �������������� ����� *) 
    elp[1][0] := 1; (* ��������� ����� *)

    for i := 1 to Pred(ltt) do
    begin 
      elp[0][i] := -1; (* ��������� ����� *) 
      elp[1][i] := 0;  (* �������������� ����� *) 
    end;
    l[0] := 0; 
    l[1] := 0; 
    u_lu[0] := -1; 
    u_lu[1] := 0; 
    u := 0; 
    repeat
      inc(u); 
      if d[u] = -1 then
      begin 
        l[u + 1] := l[u]; 
        for i := 0 to l[u] do
        begin 
          elp[u + 1][i] := elp[u][i]; 
          elp[u][i] := index_of[elp[u][i]]; 
        end;
      end
      else
      begin 
        (* ����� ���� � ���������� u_lu[q] ��� ��������� d[q] *)
        q := u - 1 ; 
        while (d[q] = -1) and (q > 0) do dec(q);
                
        if q > 0 then (* ������ ������ ��������� d[q] *)
        begin 
          j := q; 
          repeat
            dec(j); 
            if (d[j] <> -1) and (u_lu[q] < u_lu[j]) then q := j; 
          until j <= 0;          
        end;

        (* ��� ������ �� ������ q, ����� ��� d[u] <> 0 � u_lu[q] ���� ��������,
           ��  ������� ������� ������ elp �������� *)
        if l[u] > l[q] + u - q then
          l[u + 1] := l[u] 
        else
          l[u + 1] := l[q] + u - q; 

        (* form new elp(x) *)
        for i := 0 to Pred(ltt) do elp[u + 1][i] := 0; 
        for i := 0 to l[q] do
          if elp[q][i] <> -1 then
            elp[u + 1][i + u - q] := alpha_to[(d[u] + nn - d[q] + elp[q][i]) mod nn]; 
        for i := 0 to l[u] do
        begin 
          elp[u + 1][i] := elp[u + 1][i] xor (elp[u][i]); 
          (* ����������� ������ elp � ��������� ����� *)
          elp[u][i] := index_of[elp[u][i]];
        end;
      end;
      u_lu[u + 1] := u - l[u + 1];
       
      (* ��������� (u + 1)'� �������
         --------------------------------------------------------------------- *)
      
      (* ��������� ����� elp(x) *)
      if u < ltt then (* �� ��������� �������� ����������� �� ���� ���������� *)
      begin 
        if s[u + 1] <> - 1 then
          d[u + 1] := alpha_to[s[u + 1]] 
        else
          d[u + 1] := 0; 
        for i := 1 to l[u + 1] do
          if (s[u + 1 - i] <> -1) and (elp[u + 1][i] <> 0) then
            d[u + 1] := d[u + 1] xor (alpha_to[(s[u + 1 - i] + index_of[elp[u + 1][i]]) mod nn]); 
        (* ����������� d[u+1] � ��������� ����� *)
        d[u + 1] := index_of[d[u + 1]];
      end;
    until not ((u < ltt) and (l[u + 1] <= tt));
    
    (* ������ �������� ��������
       ----------------------------------------------------------------------- *)
           
    inc(u); 
    if l[u] <= tt then (* ��������� ������ �������� *)
    begin 
      (* ����������� elp � ��������� ����� *)
      for i := 0 to l[u] do elp[u][i] := index_of[elp[u][i]]; 

      (* ���������� ������ �������� �������� ������ *)
      for i := 1 to l[u] do reg[i] := elp[u][i]; 
      count:= 0; 
      for i := 1 to nn do
      begin 
        q := 1; 
        for j := 1 to l[u] do
          if reg[j] <> -1 then
          begin 
            reg[j] := (reg[j] + j) mod nn; 
            q := q xor (alpha_to[reg[j]]); 
          end;
 
        (* ���������� ������ � ������ ������� ������ *)
        if q = 0 then
        begin 
          root[count] := i; 
          loc[count] := nn - i; 
          inc(count); 
        end;
      end;
      if count = l[u] then (* ��� ������ - ������� elp < tt ������ *)
      begin 
        (* ��������� ������� z(x) *)
        for i := 1 to l[u] do (* Z[0] ������ ����� 1 *)
        begin 
          if (s[i] <> -1) and (elp[u][i] <> -1) then
             z[i] := alpha_to[s[i]] xor alpha_to[elp[u][i]] 
          else if (s[i] <> -1) and (elp[u][i] = -1) then
            z[i] := alpha_to[s[i]] 
          else if (s[i] = -1) and (elp[u][i] <> -1) then
            z[i] := alpha_to[elp[u][i]] 
          else
            z[i] := 0; 
          for j := 1 to Pred(i) do
            if (s[j] <> -1) and (elp[u][i-j] <> -1) then
              z[i] := z[i] xor (alpha_to[(elp[u][i - j] + s[j]) mod nn]); 
          (* ������������ z[] � ��������� ����� *)
          z[i] := index_of[z[i]];
        end;
 
        (* ���������� �������� ������ � �������� loc[i] *)
        for i := 0 to Pred(nn) do
        begin 
          err[i] := 0; 
          if recd[i] <> -1 then (* ����������� recd[] � �������������� ����� *)
            recd[i] := alpha_to[recd[i]] 
          else
            recd[i] := 0; 
        end;

        (* ������� ��������� ��������� ������ *)
        for i := 0 to Pred(l[u]) do
        begin 
          err[loc[i]] := 1;
          for j := 1 to l[u] do
            if z[j] <> -1 then
              err[loc[i]] := err[loc[i]] xor (alpha_to[(z[j] + j * root[i]) mod nn]); 
          if err[loc[i]] <> 0 then
          begin 
            err[loc[i]] := index_of[err[loc[i]]]; 
            q := 0; (* ��������� ����������� ������������ ������ *)
            for j := 0 to Pred(l[u]) do
              if j <> i then
                q := q + (index_of[1 xor alpha_to[(loc[j] + root[i]) mod nn]]); 
            q := q mod nn; 
            err[loc[i]] := alpha_to[(err[loc[i]] - q + nn) mod nn]; 
            (* recd[i] ������ ���� � �������������� ����� *)
            recd[loc[i]] := recd[loc[i]] xor (err[loc[i]]);
          end;
        end;
      end
      else (* ��� ������, ������� ������� ��������� ����������, �.�. ������� elp >= tt *)
      begin
        end_operation();
        Result := ERROR_CORRECTION_IMPOSSIBLE;
        exit;
      end;      
    end
    else (* ������� elp > tt, ������� ���������� *)
    begin
      end_operation();
      Result := ERROR_CORRECTION_IMPOSSIBLE;
      exit;
    end;       
  end
  else (* ������ �� ���������� *)
  begin
    end_operation();
    Result := ERROR_CORRECTION_NOT_NEED;
    exit;
  end;
  Result := Count shl 16 + ERROR_SUCCESS_CORRECTION;       
end;

procedure THiRSRepair._work_doEncode;
var
  i: integer;
  instr, remaind, strbb: string;
  dtbb, dtdt, dtrm: TData;
  lb, sz: integer;
begin
  instr := ReadString(_Data, _data_DataEncode);  
  sz := length(instr);

  lb := Fldb;

  remaind := '';
  if sz > lb then 
  begin
    remaind := Copy(instr, lb + 1, sz - lb + 1);
    SetLength(instr, lb);
    sz := lb;
  end;

  for i := 0 to Pred(kk) do data[i] := _prop_ValueSymbolFill;
  for i := 0 to Pred(sz) do data[i] := ord(instr[i + 1]);

  encode_rs(); 

  SetLength(strbb, ltt);
  for i := 0 to Pred(ltt) do strbb[i + 1] := Chr(bb[i]);  

  dtString(dtdt, instr);
  dtString(dtbb, strbb);
  dtString(dtrm, remaind);    
  dtbb.ldata := @dtdt;
  dtdt.ldata := @dtrm;

  _hi_onEvent_(_event_onEncode, dtbb);   
end;

procedure THiRSRepair._work_doDecode;
var
  lb, i: integer;
  instr, block: string;
  Err: integer;
  dtce, dtee: TData;
begin
  FCountErrors := 0;
  instr := ReadString(_Data, _data_DataDecode);  
  block := ReadString(_Data, _data_ChkSumDecode);

  lb := Fldb;

  if Length(instr) < lb then lb := Length(instr);

  if length(instr) <= kk then
    if length(block) = ltt then
    begin
      for i := 0 to Pred(ltt) do recd[i] := ord(block[i + 1]);

      for i := (ltt) to Pred(nn) do recd[i] := _prop_ValueSymbolFill; 
      for i := (ltt) to Pred(lb + ltt) do recd[i] := ord(instr[i - ltt + 1]);  

      Err := decode_rs();  
      FCountErrors := Err shr 16;
      Err := Err and $ffff;

      SetLength(instr, lb);
      for i := (ltt) to Pred(lb + ltt) do instr[i - ltt + 1] := Chr(recd[i]);
      _hi_onEvent(_event_onDecode, instr);    
    end
    else
      Err := ERROR_INCORRECT_CHECKBLOCK_LENGTH    
  else
    Err := ERROR_INCORRECT_DATA_LENGTH;

  dtInteger(dtee, Err);
  dtInteger(dtce, FCountErrors);
  dtee.ldata := @dtce;  

  _hi_onEvent_(_event_onInfo, dtee);
end;

procedure THiRSRepair._var_DataBlock;
begin
  dtString(_Data, FDataBlock);
end;

procedure THiRSRepair._var_Remaind;
begin
  dtString(_Data, FRemaind);
end;

procedure THiRSRepair._var_CheckBlock;
begin
  dtString(_Data, FCheckBlock);
end;

procedure THiRSRepair._var_CountErrors;
begin
  dtInteger(_Data, FCountErrors);
end;

procedure THiRSRepair._var_RepairDataBlock;
begin
  dtString(_Data, FRepairDataBlock);
end;

procedure THiRSRepair._work_doValueSymbolFill;
begin
  _prop_ValueSymbolFill := ToInteger(_Data);
end;

procedure THiRSRepair._work_doLengthDataBlock;
begin
  SetFldb(ToInteger(_Data));
end;

procedure THiRSRepair.SetFldb;
begin
  Fldb := Max (1, Min(Value, kk));
end;

end.