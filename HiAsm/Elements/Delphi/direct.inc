procedure tostr_delphi(var s:string);
begin
  replace(s, '''', '''''');
end;

var
  TP_PControl:integer;
  TP_TData:integer;

function _toCode(data:PScData; toType:byte):PScData;
var st:byte;
begin
   if data.getType in [13, 19] then
     st := data.getSubType
   else st := data.getType;
   Result := data;
   case toType of
     data_int:
      begin
       if st = data_str then
         begin
           Result := MakeData('str2int(', true);
           Result.AddValue(data, true);
           Result.AddValue(MakeData(')', true), true);
         end
        else if st = data_real then
         begin
           Result := MakeData('round(', true);
           Result.AddValue(data, true);
           Result.AddValue(MakeData(')', true), true);
         end
        else if st = TP_TData then
         begin
           Result := MakeData('ToInteger(', true);
           Result.AddValue(data, true);
           Result.AddValue(MakeData(')', true), true);
         end
        else if st <> data_int then Result := MakeData('0', true);
       Result.SetSubType(data_int);
      end;
     data_str:
      begin
       if st = data_int then
         begin
           Result := MakeData('int2str(', true);
           Result.AddValue(data, true);
           Result.AddValue(MakeData(')', true), true);
         end
       else if st = data_real then
         begin
           Result := MakeData('double2str(', true);
           Result.AddValue(data, true);
           Result.AddValue(MakeData(')', true), true);
         end
       else if st = TP_TData then
        begin
          Result := MakeData('Share.ToString(', true);
          Result.AddValue(data, true);
          Result.AddValue(MakeData(')', true), true);
        end
       else if st <> data_str then Result := MakeData('', false);
       Result.SetSubType(data_str);
      end;
    data_real:
     begin
      if st = data_str then
        begin
          Result := MakeData('str2double(', true);
          Result.AddValue(data, true);
          Result.AddValue(MakeData(')', true), true);
        end
      else if st = TP_TData then
        begin
          Result := MakeData('ToReal(', true);
          Result.AddValue(data, true);
          Result.AddValue(MakeData(')', true), true);
        end
      else if(st <> data_real)and(st <> data_int) then Result := MakeData('0.0', true);
      Result.SetSubType(data_real);
     end;
   end;
end;

type
  lng_indexer = (
      lng_begin,
      lng_end,
      lng_blk_priv_var,
      lng_blk_loc_var,
      lng_get_type,
      lng_last);

function BlockContains(Block: TCodeBlock; const S: string): Boolean;
var I: Integer;
begin
  Result := True;
  for I := 0 to Block.CurList.Count - 1 do begin
    if S = PScData(Block.CurList.Items[i]).value.sdata then // ���� ������ �� ���������� ����� ������
      Exit;
  end;
  Result := False;
end;

function lng_proc(parser:TParser; obj:pointer; index:integer; args:TArgs):TScData;
var dt:PScData;
    old, s:string;
    t:integer;
begin
  Result.SetValue('');
  case lng_indexer(index) of
   lng_begin:
    begin
      parser.Print('begin');
      parser.PrintLine;
      parser.codeb.level := parser.codeb.level + 1;
    end;
   lng_end:
    begin
      parser.codeb.level := parser.codeb.level - 1;
      parser.Print('end;');
      parser.PrintLine;
    end;
   lng_blk_priv_var:
    begin
      dt := GVarList.find('blk_priv_var');
      if dt = nil then
        parser.debug('BLK_PRIV_VAR - not found')
      else begin
        old := parser.codeb.select(dt.toStr());
        s := args.Values[0].toStr + ':' + args.Values[1].toStr + ';';
        // ��������� ������� ������ � �����
        if not BlockContains(parser.codeb, s) then begin
          parser.Print(s);
          parser.PrintLine;
        end;
        parser.codeb.select(old);
      end;
    end;
   lng_blk_loc_var:
    begin
      dt := GVarList.find('loc_vars');
      if dt = nil then
        parser.debug('LOC_VARS - not found')
      else begin
        old := parser.codeb.select(dt.toStr());
        s := args.Values[0].toStr + ':' + args.Values[1].toStr + ';';
        // ��������� ������� ������ � �����
        if not BlockContains(parser.codeb, s) then begin
          parser.Print(s);
          parser.PrintLine;
        end;
        parser.codeb.select(old);
      end;
    end;
   lng_get_type:
    begin
      t := args.Values[0].getType;
      if( t = data_code)or(t = data_array)then
        t := args.Values[0].getSubType;
      Result.Setvalue(t);
    end;
  end;
end;

procedure fill_lng_object(var methods:TAObjMethod; var count:integer);
begin
  TP_PControl := RegisterUserType('PControl');
  TP_TData := RegisterUserType('TData');

  count := integer(lng_last);
  setlength(methods, count);
  methods[integer(lng_begin)] := MakeMethod('begin',     0, '');
  methods[integer(lng_end)] := MakeMethod('end',     0, '');
  methods[integer(lng_blk_priv_var)] := MakeMethod('decl_priv_var',     2, 'name, type');
  methods[integer(lng_blk_loc_var)] := MakeMethod('decl_loc_var',     2, 'name, type');
  methods[integer(lng_get_type)] := MakeMethod('get_type',     1, 'expression');
end;

const
  lng_count = 1;
  lngs:array[0..lng_count-1] of TLangRec = (
     (entry:'EditMultiEx'; name:'delphi'; str_del_o: ''''; str_del_c: ''''; op_del: ' + '; var_mask:'%n%i'; tostr_proc:tostr_delphi)
  );
