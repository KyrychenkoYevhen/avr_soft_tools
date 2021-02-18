unit hiRealArray;

interface

uses Kol,Share;

type
  THIRealArray = class(TArray)
   private
     function DataToPointer(var Data:TData):NativeInt; override;
     procedure PointerToData(Data:NativeInt; var Result:TData); override;

     procedure Save(P:pointer; Data:NativeInt); override;
     procedure Load(P:pointer; var Data:NativeInt); override;

     procedure Delete(Value:NativeInt); override;
   public
     property _prop_RealArray:PKOLStrListEx write SetItems;
  end;

implementation

function THIRealArray.DataToPointer;
var r:^real;
begin
   new(r);
   r^ := ToReal(Data);
   Result := NativeInt(r);
end;

procedure THIRealArray.PointerToData;
begin
   dtreal(Result,real(pointer(Data)^));
end;

procedure THIRealArray.Save;
begin
   if _prop_FileFormat = 0 then
    PStream(p).write(Real(pointer(Data)^),sizeof(real))
   else string(p^) := double2str(Real(pointer(Data)^));
end;

procedure THIRealArray.Load;
var r:^real;
begin
   new(r);
   if _prop_FileFormat = 0 then
    PStream(p).Read(r^,sizeof(real))
   else r^ := str2double(string(p^));
   Data := NativeInt(r);
end;

procedure THIRealArray.Delete;
var r:^real;
begin
   r := pointer(Value);
   dispose( r );
end;

end.
