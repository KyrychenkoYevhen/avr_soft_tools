procedure _tostr_proc(var s:string);
begin
  replace(s, '"', '\"');
end;

procedure cpp_tostr_proc(var s:string);
begin
  replace(s, '"', '\"');
end;

function ins_func(const func:string; data:PScData; sub:integer):PScData;
begin
  Result := MakeData(func + '(', true);
  Result.AddValue(data, true);
  Result.AddValue(MakeData(')', true), true);
  Result.SetSubType(sub);
end;

var data_pchar:byte;

function _toCode(data:PScData; toType:byte):PScData;
begin
   Result := data;
   if nsection = 1 then
     case toType of
       data_int:
         case data.GetType of
           data_int: ;
           data_str,data_real: Result := MakeData(data.toInt);
           data_code:
             case data.GetSubType of
               data_int: ;
               data_str: Result := ins_func('str_to_int', data, toType);
               data_real: Result := ins_func('real_to_int', data, toType);
             end;
         end;
       data_str:
         case data.GetType of
           data_int, data_real: Result := MakeData(data.toStr);
           data_str: Result := ins_func('string', data, toType); 
           data_code:
             case data.GetSubType of
               data_int: Result := ins_func('int_to_str', data, toType);
               data_str:;
               data_real: Result := ins_func('real_to_str', data, toType);
             end;
         end;
       data_real:
         case data.GetType of
           data_real: ;
           data_str,data_int: Result := MakeData(data.toReal);
           data_code:
             case data.GetSubType of
               data_int:;
               data_str: Result := ins_func('str_to_real', data, toType);
               data_real: ;
             end;
         end;
       else
        if toType = data_pchar then
         case data.GetType of
           data_code:
             case data.GetSubType of          
               data_str: 
                begin
                  Result := MakeData(data);
                  Result.AddValue(MakeData('.c_str()', true), true);
                  Result.SetSubType(toType);
                end;
             end;
           data_array:
             case data.GetSubType of          
               data_str: 
                begin
                  Result := MakeData('(', true);
                  Result.AddValue(data, true);
                  Result.AddValue(MakeData(').c_str()', true), true);
                  Result.SetSubType(toType);
                end;
             end;
         end;         
     end;
   // TODO
end;

type
  lng_indexer = (
      lng_begin,
      lng_end,
      lng_blk_priv_var,
      lng_blk_loc_var,
      lng_last);

function lng_proc(parser:TParser; obj:pointer; index:integer; args:TArgs):TScData;
var dt:PScData;
    old,s:string;
begin
  Result.SetValue('');
  case lng_indexer(index) of
   lng_begin:
    begin
      case nsection of
       0:;
       1: parser.Print('{');
      end;
      parser.codeb.level := parser.codeb.level + 1;
      parser.PrintLine;
    end;
   lng_end:
    begin
      parser.codeb.level := parser.codeb.level - 1;
      case nsection of
       0:;
       1: parser.Print('}');
      end;
      parser.PrintLine;
    end;
   lng_blk_priv_var,lng_blk_loc_var:
    begin
      if lng_indexer(index) = lng_blk_priv_var then
       s := 'BLK_PRIV_VAR'
      else s := 'BLK_FUNC';
      dt := GVarList.find(lowercase(s));
      if dt = nil then
        parser.debug(s + ' - not found')
      else
       begin
         old := parser.codeb.select(dt.toStr());
         case nsection of
          0:;
          1: 
           begin
             parser.Print(args.Values[1].toStr);
             parser.Print(' ' + args.Values[0].toStr + ';');
           end; 
         end;
         parser.PrintLine;
         parser.codeb.select(old);
       end;
    end;
  end;
end;

procedure fill_lng_object(var methods:TAObjMethod; var count:integer);
begin
  data_pchar := RegisterUserType('PChar');

  count := integer(lng_last);
  setlength(methods, count);
  methods[integer(lng_begin)] := MakeMethod('begin',     0, '');
  methods[integer(lng_end)] := MakeMethod('end',     0, '');
  methods[integer(lng_blk_priv_var)] := MakeMethod('decl_priv_var',     2, 'name, type');
  methods[integer(lng_blk_loc_var)] := MakeMethod('decl_loc_var',     2, 'name, type');
end;

// change this for your pack settings
const
  lng_count = 2;
  lngs:array[0..lng_count-1] of TLangRec = (
     (entry:'HISEntryPoint';     name:'java';  str_del_o: '"'; str_del_c: '"'; op_del: ' + ';   var_mask:'%n%i'; tostr_proc:_tostr_proc),
     (entry:'MakeEntryPoint';    name:'cpp';   str_del_o: '"'; str_del_c: '"'; op_del: ' + ';  var_mask:'%n%i'; tostr_proc:cpp_tostr_proc)
  );
