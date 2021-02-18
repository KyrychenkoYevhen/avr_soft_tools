unit hiType_Load;

interface

uses Kol,Share,Debug;

type
  THIType_Load = class(TDebug)
   private
    FType:PType;
    FObjs:PList;
    
    procedure Stream2Type(var typ:PType; st:PStream);
   public
    _prop_FileName:string;
    _prop_StreamFormat:byte;
    
    _data_ScrStream:THI_Event;
    _data_FileName:THI_Event;

    _event_onError:THI_Event;
    _event_onLoad:THI_Event;

    constructor Create;
    destructor Destroy; override;
    procedure _work_doLoad(var _Data:TData; Index:word);
    procedure _work_doClear(var _Data:TData; Index:word);
    procedure _var_FType(var _Data:TData; Index:word);
  end;

implementation

constructor THIType_Load.Create;
begin
  inherited Create;
  FObjs := NewList;
end;

destructor THIType_Load.Destroy;
var i:integer;
begin
  for i := 0 to FObjs.Count-1 do
    PObj(FObjs.Items[i]).Free;
  FObjs.Free;
  if FType <> nil then
    FType.Free;
  inherited Destroy;
end;

procedure Mem2Var(m:string; var v);
begin
  Move(m[1],v,length(m));
end;

procedure THIType_Load.Stream2Type;
var id,cn:byte;
    nm:string;
    dt:TData;
    fStg:boolean;

 procedure RInd(sst:PStream; var tp:PType; var fStg:boolean);
 var i:byte;
     s:string;
 begin
   sst.read(fStg,sizeof(fStg));
   if fStg then begin
     tp := NewStorageType;
   end else begin
     tp := NewType;
     FObjs.Add(tp);
   end;
   sst.read(i,sizeof(i));
   SetLength(s,i);
   sst.read(s[1],i);
   tp.name := LowerCase(s);
 end;
 
 procedure RVar(sst:PStream; dt:PData; cn:word; fStg:boolean);
 var b:byte;
     id:integer;
     sd:string;
     rd:real;
     bd:PBitmap;
     s1:PStream;
     ttp:PType;
 begin
   dtNull(dt^);
   sst.read(b,sizeof(b));
   case b of
    data_int:
      begin
       sst.read(id, sizeof(id)); 
       dtInteger(dt^,id);
      end;
    data_str:
      begin
       sst.read(id,sizeof(id)); 
       SetLength(sd,id);
       sst.read(sd[1],id);
       dtString(dt^,sd);
      end;
    data_real:
      begin
       sst.read(rd, sizeof(rd)); 
       dtReal(dt^,rd);
      end;
    data_bitmap: 
      begin
       bd := NewBitmap(0,0);
       bd.LoadFromStream(sst);
       if not fStg then FObjs.Add(bd);
       dtBitmap(dt^,bd);
      end;
    data_stream: 
      begin
       s1 := NewMemoryStream;
       sst.read(id, sizeof(id));
       Stream2Stream(s1, sst, id);
       if not fStg then FObjs.Add(s1);
       s1.position := 0;
       dtStream(dt^,s1);
      end;
    data_types:
      begin
       s1 := NewMemoryStream;
       sst.read(id, sizeof(id));
       Stream2Stream(s1, sst, id);
       s1.position := 0;
       Stream2Type(ttp,s1);
       s1.Free;
       dtType(dt^,ttp);
      end;
   end;
   
   if cn > 1 then begin
     new(dt.ldata);
     RVar(sst,dt.ldata,cn-1,fStg);
   end;
 end;
begin
  if st <> nil then begin
    st.read(id,sizeof(id));
    if id = data_types then begin
      RInd(st,typ,fStg);
      while st.position < st.size do begin
        st.read(cn,sizeof(cn));
        
        st.read(id,sizeof(id));
        SetLength(nm,id);
        st.read(nm[1],id);

        RVar(st,@dt,cn,fStg);
        typ.Add(LowerCase(nm),@dt);
      end;
    end else CallTypeError('',_event_onError,TYPE_ERR_INVALID_TYPE);
  end;
end;

procedure THIType_Load._work_doClear;
var i:integer;
begin
  for i := 0 to FObjs.Count-1 do
    PObj(FObjs.Items[i]).Free;
  FObjs.Clear;
  if FType <> nil then FType.Free; //Check for memory leak
end;

procedure THIType_Load._work_doLoad;
var st:PStream;
    fn,itm,nm:string;
    list:PKOLStrList;
    i:integer;
    dt:TData;
begin
  _work_doClear(_Data,Index); //sometime it can be modified
  dt := ReadData(_Data,_data_FileName);
  if Share.ToString(dt) <> '' then fn := Share.ToString(dt)
  else if _prop_FileName <> '' then fn := _prop_FileName;
  if Assigned(_data_ScrStream.event) then st := ReadStream(_data,_data_ScrStream)
  else if ToStream(dt) <> nil then st := ToStream(dt)
  else if ToStream(_Data) <> nil then st := ToStream(_data);
  if _prop_StreamFormat = 0 then begin
    if fn = '' then begin
      Stream2Type(FType,st);
    end else begin
      if FileExists(fn) then begin
        st := NewReadFileStream(Fn);
        stream2Type(FType,st);
        st.Free;
      end else CallTypeError('',_event_onError,TYPE_ERR_INVALID_TYPE);
    end;
  end else begin
    list := NewKOLStrList;
    if fn <> '' then begin
      list.LoadFromFile(fn);
    end else if st <> nil then begin
      st.position := 0;
      SetLength(fn,st.size);
      st.read(fn[1],st.size);
      list.text := fn;
    end; 
    if list.text <> '' then begin
      nm := LowerCase(list.Items[0]);
      fn := Copy(nm,2,length(nm)-2);
      if fn[1] = '1' then FType := NewStorageType else FType := NewType;
      Delete(fn,1,1);
      FType.name := fn;
      for i := 1 to list.count-1 do begin
        itm := list.items[i];
        nm := LowerCase(GetTok(itm,'='));
        dtString(dt,itm);
        FType.Add(nm,@dt);
      end;
    end else CallTypeError('',_event_onError,TYPE_ERR_INVALID_TYPE);
    list.Free;
  end;
  _hi_OnEvent(_event_onLoad,FType);
end;

procedure THIType_Load._var_FType;
begin
  dtType(_Data,FType);
end;

end.
