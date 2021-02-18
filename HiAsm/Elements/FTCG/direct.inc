procedure tostr_php_java(var s:string);
begin
  replace(s, '\', '\\');
  replace(s, '"', '\"');
end;

procedure tostr_html(var s:string);
begin

end;

function _toCode(data:PScData; toType:byte):PScData;
begin
   Result := data;
{   case toType of
    data_str:
      case data.getSubType of
       data_int:
        begin
          Result := MakeData(data);
          Result.AddValue(MakeData('.toString()',true), true);
        end;
      end
   end;}
end;

type
  lng_indexer = (
      lng_linked,
      lng_last);

function ReadPointByTypeIndex(parser:TParser; ind:integer; ptype:byte):id_point; forward;

const
  Multi:array[1..4]of byte = (pt_Event,pt_Work,pt_Data,pt_Var);

function lng_proc(parser:TParser; obj:pointer; index:integer; args:TArgs):TScData;
var lp:id_point;
    e,oe:id_element;
begin
  Result.SetValue(0);
  case lng_indexer(index) of
   lng_linked:
    begin
      lp := parser.cgt.ptGetRLinkPoint(args.Values[0].toInt());
      if lp > 0 then
       begin
        e := parser.cgt.ptGetParent(lp);
        with parser.cgt^ do
        while elGetClassIndex(e) in [CI_EditMulti, CI_MultiElement] do
         begin
          if elGetClassIndex(e) = CI_EditMulti then
           begin
            e := elGetSDK(e);
            if byte(propGetValue(elGetProperty(e, 0))^) = 0 then
              break;
            oe := parser.el;
            parser.el := e;
            lp := ptGetRLinkPoint(ReadPointByTypeIndex(parser, ptGetIndex(lp), Multi[ptGetType(lp)]));
            parser.el := oe;
           end
          else if elGetClassIndex(e) = CI_MultiElement then
           begin
            if byte(propGetValue(elGetProperty(e, 0))^) = 0 then
              break;
            oe := parser.el;
            parser.el := sdkGetElement(elGetSDK(e), 0);
            lp := ptGetRLinkPoint(ReadPointByTypeIndex(parser, ptGetIndex(lp), Multi[ptGetType(lp)]));
            parser.el := oe;
           end;
          if lp = 0 then break;
          e := parser.cgt.ptGetParent(lp);
         end;
          
        Result.SetValue(lp);    
       end;   
    end;
  end;
end;

procedure fill_lng_object(var methods:TAObjMethod; var count:integer);
begin
  count := integer(lng_last);
  setlength(methods, count);
  methods[integer(lng_linked)] := MakeMethod('linked',     1, 'name');
end;

const
  lng_count = 0;
  lngs:array[0..0] of TLangRec = (
     (entry:'EntryPoint';     name:'php';  str_del_o: '"'; str_del_c: '"';op_del: '.';   var_mask:'$%n%i'; tostr_proc:tostr_php_java)
  );
