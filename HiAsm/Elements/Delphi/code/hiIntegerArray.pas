unit hiIntegerArray;

interface

uses Kol,Share;

type
  THIIntegerArray = class(TArray)
   private
     function DataToPointer(var Data:TData):NativeInt; override;
     procedure PointerToData(Data:NativeInt; var Result:TData); override;

     procedure Save(P:pointer; Data:NativeInt); override;
     procedure Load(P:pointer; var Data:NativeInt); override;
     function Swap(d1,d2:NativeInt):boolean; override;
   public
     property _prop_IntArray:PKOLStrListEx write SetItems;
  end;

implementation

function THIIntegerArray.Swap;
begin
  Result := integer(d1) > integer(d2);
end;

function THIIntegerArray.DataToPointer;
begin
   Result := ToInteger(Data);
end;

procedure THIIntegerArray.PointerToData;
begin
   dtInteger(Result,Data);
end;

procedure THIIntegerArray.Save;
begin
   if _prop_FileFormat = 0 then
    PStream(p).write(Data,sizeof(data))
   else string(p^) := int2str(data);
end;

procedure THIIntegerArray.Load;
begin
   if _prop_FileFormat = 0 then
    PStream(p).Read(Data,sizeof(data))
   else Data := str2int(string(p^));
end;

end.
