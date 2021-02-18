unit hiStreamArray;

interface

uses Kol,Share;

type
  THIStreamArray = class(TArray)
   private
     StreamName: string;
     function DataToPointer(var Data:TData):NativeInt; override;
     procedure PointerToData(Data:NativeInt; var Result:TData); override;
     procedure Delete(Value:NativeInt); override;

     procedure Save(P:pointer; Data:NativeInt); override;
     procedure Load(P:pointer; var Data:NativeInt); override;
   public
     _data_Stream,
     _data_Name,
     _data_IdxToName,
     _event_onGetName: THI_Event;
     property _prop_Streams:PKOLStrListEx write SetItems;
     procedure _work_doGetName(var _Data: TData; Index: word);
     procedure _work_doAddStream(var _Data: TData; Index: word);
     procedure _var_StreamName(var _Data: TData; Index: word);
     procedure _var_EndIdx(var _Data: TData; Index: word);
  end;

implementation

function THIStreamArray.DataToPointer;
var Strm:PStream;
begin
   Result := 0;  
   if (Data.Data_type = data_stream) then
     begin
       Strm := NewMemoryStream;
       Strm.Size := PStream(data.idata).Size; 
       PStream(data.idata).Position := 0;
       Stream2Stream(Strm, PStream(data.idata), Strm.Size);
//       Strm.Write((PStream(data.idata).Memory)^,PStream(data.idata).Size);
       Result := NativeInt(Strm);
     end;
end;

procedure THIStreamArray.PointerToData;
begin
  if Data <> 0 then
  begin
    PStream(Data).Position := 0;
    dtStream(Result, PStream(Data));
  end
  else
    dtStream(Result, nil);    
end;

procedure THIStreamArray.Delete;
begin
  PStream(Value).free;
end;

procedure THIStreamArray.Save;
var i:cardinal;
begin
   if _prop_FileFormat = 0 then
   begin
     i := PStream(Data).Size; 
     PStream(p).Write(i, Sizeof(i));
     PStream(p).Write((PStream(Data).Memory)^, PStream(Data).Size);
   end
   else ;
end;

procedure THIStreamArray.Load;
var Strm:PStream;
    i:cardinal;
begin
   Strm := NewMemoryStream;
   if _prop_FileFormat = 0 then
   begin
     PStream(p).Read(i, Sizeof(i));
     Stream2Stream(Strm, PStream(p), i);
   end
   else ;
   Data := NativeInt(Strm);
end;

procedure THIStreamArray._work_doGetName;
var
  ind: integer; 
begin
  ind := ReadInteger(_Data, _data_IdxToName);
  if (ind >= 0) and (ind < Items.Count) then
    StreamName := Items.Items[ind]
  else
    StreamName := '';
  _hi_CreateEvent(_Data, @_event_onGetName, StreamName);    
end;

procedure THIStreamArray._work_doAddStream;
var
  Name: String;
  dt: TData;
begin
  dt := ReadData(_Data,_data_Stream);
  Name := ReadString(_Data,_data_Name);
  Items.AddObject(Name, DataToPointer(dt));   
end;

procedure THIStreamArray._var_StreamName;
begin
  dtString(_Data, StreamName);
end;

procedure THIStreamArray._var_EndIdx;
begin
  dtInteger(_Data, Items.Count - 1);
end;

end.
