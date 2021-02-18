unit hiDDEClient;

interface

uses Windows,Kol,Share,Debug,DDEML;

type
  THIDDEClient = class(TDdeConversation)
   private
    FItems:PKOLStrList;
    FLastItem:string;
   
    function MyCallback(uType,uFmt:cardinal; hConv,hSz1,hSz2,hData:THandle; dwData1,dwData2:DWORD):cardinal;
    procedure SetText(const Value:string);
    procedure CheckOpenLink;
    procedure CheckAutoUpdate(const Value:integer);

   public
    _prop_ServiceName:string;
    _prop_TopicName:string;
    _prop_AutoUpdate:integer;
    _prop_AutoConnect:boolean;
    _prop_ServerApp:string;
    _prop_Timeout:integer;

    _data_Name:THI_Event;
    _data_Value:THI_Event;
    
    _event_onOpenLink:THI_Event;
    _event_onCloseLink:THI_Event;
    _event_onGetItem:THI_Event;
    _event_onPutItem:THI_Event;
    _event_onExecute:THI_Event;
    _event_onError:THI_Event;

    constructor Create;
    destructor Destroy; override;

    procedure _work_doOpenLink(var _Data:TData; Index:word);
    procedure _work_doCloseLink(var _Data:TData; Index:word);
    procedure _work_doGetItem(var _Data:TData; Index:word);
    procedure _work_doPutItem(var _Data:TData; Index:word);
    procedure _work_doExecute(var _Data:TData; Index:word);

    procedure _var_ItemName(var _Data:TData; Index:word);
    procedure _var_ItemIndex(var _Data:TData; Index:word);

    procedure _work_doServiceName(var _Data:TData; Index:word);
    procedure _work_doTopicName(var _Data:TData; Index:word);
    procedure _work_doItems(var _Data:TData; Index:word);
    procedure _work_doAutoUpdate(var _Data:TData; Index:word);
    procedure _work_doAutoConnect(var _Data:TData; Index:word);
    procedure _work_doServerApp(var _Data:TData; Index:word);
    procedure _work_doTimeout(var _Data:TData; Index:word);

    property _prop_Items:string write SetText;
  end;

implementation

constructor THIDDEClient.Create;
begin
  inherited;
  FConv := 0;
  FCallback := MyCallback;
  FItems := NewKOLStrList;
end;

destructor THIDDEClient.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure THIDDEClient.SetText;
begin
   FItems.Text := Value;
end;

function THIDDEClient.MyCallback(uType,uFmt:cardinal; hConv,hSz1,hSz2,hData:THandle; dwData1,dwData2:DWORD):cardinal;
var s:string; dwLen:DWORD;
begin
  case uType of
  XTYP_ADVDATA:
   begin
     dwLen := DdeQueryString(g_DdeInstance,hSz2,nil,0,DDE_CODEPAGE)+1; SetLength(FLastItem,dwLen);
     DdeQueryString(g_DdeInstance,hSz2,@FLastItem[1],dwLen,DDE_CODEPAGE); SetLength(FLastItem,dwLen-1);
     dwLen := DdeGetData(hData,nil,0,0) div SizeOf(Char);
     SetLength(s,dwLen);
     DdeGetData(hData,@s[1], dwLen * SizeOf(Char),0);
     _hi_onEvent(_event_onGetItem,s);
     Result := DDE_FACK; 
   end;
  XTYP_DISCONNECT:
   begin
     CheckAutoUpdate(0);
     FConv := 0;
     _hi_onEvent(_event_onCloseLink);
     Result := DDE_FACK; 
   end
  else
   Result := DDE_FNOTPROCESSED;
  end;
end; 

procedure THIDDEClient.CheckAutoUpdate;
var i:integer; hszItem,hData:THandle; dwRes:DWORD;
begin
  for i:=0 to FItems.Count-1 do begin
    hszItem := DdeCreateStringHandle(g_DdeInstance,PChar(FItems.Items[i]),DDE_CODEPAGE);
    if Value=0 then begin
      DDEML.DdeClientTransaction(nil,0,FConv,hszItem,CF_TEXT,XTYP_ADVSTOP,_prop_Timeout,dwRes);
    end else begin
      hData := DDEML.DdeClientTransaction(nil,0,FConv,hszItem,CF_TEXT,XTYP_REQUEST,_prop_Timeout,dwRes);
      MyCallback(XTYP_ADVDATA,CF_TEXT,FConv,0,hszItem,hData,0,0);
      DdeFreeDataHandle(hData);
      DDEML.DdeClientTransaction(nil,0,FConv,hszItem,CF_TEXT,XTYP_ADVSTART,_prop_Timeout,dwRes);
    end;
    DdeFreeStringHandle(g_DdeInstance,hszItem);
  end;
end;

procedure THIDDEClient.CheckOpenLink;
var hszService,hszTopic:THandle; errMsg:string;
begin
  if FConv<>0 then Exit;
  errMsg := 'Server is not running.';
  hszService := DdeCreateStringHandle(g_DdeInstance,PChar(_prop_ServiceName),DDE_CODEPAGE); 
  hszTopic := DdeCreateStringHandle(g_DdeInstance,PChar(_prop_TopicName),DDE_CODEPAGE);
  FConv := DDEConnect(g_DdeInstance,hszService,hszTopic,nil);
  if (FConv=0) and (_prop_ServerApp<>'') then begin
    if WinExec(PAnsiChar(_prop_ServerApp),SW_SHOW)>31 then // TODO: WinExec() is deprecated - use CreateProcess() instead (NetSpirit)
      FConv := DDEConnect(g_DdeInstance,hszService,hszTopic,nil)
    else
      errMsg := 'Can''t start DDE server.';
  end;
  DdeFreeStringHandle(g_DdeInstance,hszTopic);
  DdeFreeStringHandle(g_DdeInstance,hszService);
  if FConv=0 then _hi_onEvent(_event_onError,errMsg) else begin
    CheckAutoUpdate(_prop_AutoUpdate);
    _hi_onEvent(_event_onOpenLink);
  end;
end;

procedure THIDDEClient._work_doOpenLink;
begin
  CheckOpenLink;
end;

procedure THIDDEClient._work_doCloseLink;
begin
  if FConv=0 then Exit;
  CheckAutoUpdate(0);
  DdeDisconnect(FConv); FConv := 0;
  _hi_CreateEvent(_Data,@_event_onCloseLink);
end;

procedure THIDDEClient._work_doGetItem;
var hszItem,hData:THandle; dwRes:DWORD;
begin
  if _prop_AutoConnect then CheckOpenLink;
  if FConv=0 then Exit;
  hszItem := DdeCreateStringHandle(g_DdeInstance,PChar(ReadString(_Data,_data_Name,'')),DDE_CODEPAGE);
  hData := DDEML.DdeClientTransaction(nil,0,FConv,hszItem,CF_TEXT,XTYP_REQUEST,_prop_Timeout,dwRes);
  MyCallback(XTYP_ADVDATA,CF_TEXT,FConv,0,hszItem,hData,0,0);
  DdeFreeDataHandle(hData);
  DdeFreeStringHandle(g_DdeInstance,hszItem);
end;

procedure THIDDEClient._work_doPutItem;
var s:string; hszItem,hData:THandle; dwRes:DWORD;
begin
  if _prop_AutoConnect then CheckOpenLink;
  if FConv=0 then Exit;
  hszItem := DdeCreateStringHandle(g_DdeInstance,PChar(ReadString(_Data,_data_Name,'')),DDE_CODEPAGE);
  s := ReadString(_Data,_data_Value,'');
  hData := DDEML.DdeClientTransaction(PChar(s),Length(s){+1} * SizeOf(Char),FConv,hszItem,CF_TEXT,XTYP_POKE,_prop_Timeout,dwRes);
  DdeFreeStringHandle(g_DdeInstance,hszItem);
  _hi_CreateEvent(_Data,@_event_onPutItem, NativeInt(hData));
end;

procedure THIDDEClient._work_doExecute;
var s:string; hData:THandle; dwRes:DWORD;
begin
  if _prop_AutoConnect then CheckOpenLink;
  if FConv=0 then Exit;
  s := Share.ToString(_Data);
  hData := DDEML.DdeClientTransaction(PChar(s),Length(s){+1} * SizeOf(Char),FConv,0,CF_TEXT,XTYP_EXECUTE,_prop_Timeout,dwRes);
  _hi_CreateEvent(_Data, @_event_onExecute, NativeInt(hData));
end;

procedure THIDDEClient._var_ItemName;
begin
  dtString(_Data, FLastItem);
end;

procedure THIDDEClient._var_ItemIndex;
begin
  dtInteger(_Data, FItems.IndexOf(FLastItem));
end;

procedure THIDDEClient._work_doServiceName;
begin
  _prop_ServiceName := Share.ToString(_Data);
end;

procedure THIDDEClient._work_doTopicName;
begin
  _prop_TopicName := Share.ToString(_Data);
end;

procedure THIDDEClient._work_doItems;
begin
  FItems.Text := Share.ToString(_Data);
end;

procedure THIDDEClient._work_doAutoUpdate;
begin
  _prop_AutoUpdate := ToInteger(_Data);
  CheckAutoUpdate(_prop_AutoUpdate);
end;

procedure THIDDEClient._work_doAutoConnect;
begin
  _prop_AutoConnect := ReadBool(_Data);
end;

procedure THIDDEClient._work_doServerApp;
begin
  _prop_ServerApp := Share.ToString(_Data);
end;

procedure THIDDEClient._work_doTimeout;
begin
  _prop_Timeout := ToInteger(_Data);
end;

end.