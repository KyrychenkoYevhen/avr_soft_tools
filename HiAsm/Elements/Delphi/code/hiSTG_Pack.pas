unit hiSTG_Pack;

interface

uses
   Windows, Messages, ActiveX, {$ifdef FPC_NEW}ComObj,{$else}KolComObj,{$endif} KOL, Share, Debug, hiSStorage_DS;

type
  THISTG_Pack = class(TDebug)
   private
   public
    _prop_SStorage_DS: PISStorage_DS;

    _prop_PackStgPath: string;

    _data_IsCurrentStgPack,
    _data_PackStgPath,
    _event_onEndPack:THI_Event;

    procedure _work_doPack(var _Data:TData; Index:word);
  end;

implementation

//==============================================================================
//
//                            �������� ���������
//
//==============================================================================

procedure THISTG_Pack._work_doPack;
var
  FStgName: WideString;
  Res: HResult;
  Bool: boolean;
  len: dword;
  s: WideString;
  fp: PWideChar;
  FRootStorage: TSStorage;
begin
  if not Assigned(_prop_SStorage_DS) then exit;
  s := WideString(ReadString(_Data, _data_PackStgPath, _prop_PackStgPath));
  if s = '' then
  begin
    _prop_SStorage_DS.EventError(STG_ERROR_INCORRECTFILENAME);
    exit;
  end;

  FRootStorage := _prop_SStorage_DS.GetFRootStorage; 
  len := GetFullPathNameW(PWideChar(s), 0, nil, fp);
  SetLength(FStgName, len - 1);
  GetFullPathNameW(PWideChar(s), len, PWideChar(FStgName), fp);
  if FRootStorage <> nil then
    if AnsiCompareTextW(FRootStorage.GetStgName, FStgName) = 0 then
      if  ReadInteger(_Data, _data_IsCurrentStgPack) = 0 then
        _prop_SStorage_DS.CloseRootStorage
      else
      begin
        _prop_SStorage_DS.EventError(STG_ERROR_IMPOSSIBLEPACKOPENSTG);
        exit;
      end;

  Bool := false;
  Res := StgIsStorageFile(PWideChar(FStgName));
  case Res of
    S_OK:  Bool := StoragePack(FStgName);
  end;
  if Bool and (Res = S_OK) then
    _hi_onEvent(_event_onEndPack)
  else
    _prop_SStorage_DS.EventError(STG_ERROR_IMPOSSIBLEPACKSTORAGE);
end;

end.