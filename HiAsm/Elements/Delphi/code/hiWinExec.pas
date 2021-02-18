unit hiWinExec;

interface

uses
  Windows, ShellApi, Kol, Share, Debug;

type

  THIWinExec = class(TDebug)
    private
      FProcessH: THandle;
      
      FPipeInRead, FPipeInWrite: THandle;
      FPipeOutRead, FPipeOutWrite: THandle;
      FPipeErrRead, FPipeErrWrite: THandle;
      
      FEvWait: THandle;
      
      FReadingThread: PThread;
      
      FExitCode: DWord;
      FProcessID: DWord;

      // Возвращает хендл процесса, или 0 в случае ошибки.
      // Сделайте CloseHandle(), когда хендл больше не нужен.
      function RunProcess(const Fn, CmdLine, WDir: string): THandle;
      
      
      // Запуск консольных приложений
      function PreparePipes: Boolean;
      procedure DestroyPipes;
      procedure StartReading;
      procedure StopReading;
      procedure Detach;
      procedure Terminate;
      procedure ProcessTerminated;
      function ExecuteReading(T: PThread): NativeInt;
      procedure StartConsoleApp(const Fn, CmdLine, WDir: string);
      
    public
      _prop_Param: string;
      _prop_FileName: string;
      _prop_Mode: Byte;
      _prop_RunEvent: Byte;
      _prop_Action: string;
      _prop_WorkingDir: string;

      _data_Params: THI_Event;
      _data_FileName: THI_Event;
      _data_Action: THI_Event;
      _data_WorkingDir: THI_Event;

      _event_onExec: THI_Event;
      _event_onErrorExec: THI_Event;
      _event_onConsoleResult: THI_Event;
      _event_onConsoleError: THI_Event;
      _event_onConsoleTerminate: THI_Event;
      _event_onFinished: THI_Event;

      procedure _work_doAbortWait(var _Data: TData; Index: Word);
      procedure _work_doExec(var _Data: TData; Index: Word);
      procedure _work_doRunCpl(var _Data: TData; Index: Word);
      procedure _work_doShellExec(var _Data: TData; Index: Word);
      procedure _work_doConsoleExec(var _Data: TData; Index: Word);
      procedure _work_doConsoleInput(var _Data: TData; Index: Word);
      procedure _work_doConsoleTerminate(var _Data: TData; Index: Word);
      procedure _work_doConsoleDetach(var _Data: TData; Index: Word);

      procedure _var_ExitCode(var _Data: TData; Index: Word);
      procedure _var_ProcessID(var _Data: TData; Index: Word);

      destructor Destroy; override;
  end;

implementation

const
  READ_BUFFER_SIZE = 8192;



destructor THIWinExec.Destroy;
begin
  // Спустить ожидающий поток, чтобы он мог завершиться.
  // Вероятно, не надо - в процессе уничтожения компонентов это 
  // может привести к ошибке
  // SetEvent(FEvWait);
  
  CloseHandle(FEvWait);
  
  Detach;
  inherited;
end;

function THIWinExec.RunProcess(const Fn, CmdLine, WDir: string): THandle;
var
  SI: TStartupInfo;
  PI: TProcessInformation;
begin
  Result := 0;
  FProcessID := 0;
  
  FillChar(SI, SizeOf(TStartupInfo), 0);
  with SI do
  begin
    cb := SizeOf(TStartupInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := _prop_Mode;
  end;
  
  if CreateProcess(nil, PChar(Trim(Fn + ' ' + CmdLine)), nil, nil,
                        False, CREATE_DEFAULT_ERROR_MODE, nil, Pointer(WDir), SI, PI)
  then
  begin
    FProcessID := PI.dwProcessId;
    Result := PI.hProcess;
    CloseHandle(PI.hThread);
  end;
end;

procedure THIWinExec._work_doAbortWait;
begin
  SetEvent(FEvWait);
end;

procedure THIWinExec._work_doRunCpl;
var
  Fn: string;
  H: THandle;
begin
  Fn := ReadString(_Data, _data_FileName, _prop_FileName);
  
  // WinExec() is deprecated!
  //WinExec(PChar('rundll32.exe shell32.dll,Control_RunDLL ' + Fn),_prop_Mode)
  
  H := RunProcess('rundll32.exe', 'shell32.dll,Control_RunDLL ' + Fn, '');
  if H <> 0 then
  begin
    _hi_CreateEvent(_Data, @_event_onExec);
    CloseHandle(H);
  end
  else
    _hi_CreateEvent(_Data, @_event_onErrorExec, Integer(GetLastError()));
end;

procedure THIWinExec._work_doExec;
var
  Fn, Cmd, WD: string;
  H: THandle;
  WaitRec: record
    Event1: THandle;
    Event2: THandle;
  end;
begin
  Fn := ReadString(_Data, _data_FileName, _prop_FileName);
  Cmd := ReadString(_Data, _data_Params, _prop_Param);
  WD := ReadString(_Data, _data_WorkingDir, _prop_WorkingDir);
  
  FExitCode := 0;
  
  H := RunProcess(Fn, Cmd, WD);
  
  if H <> 0 then
  begin
    _hi_OnEvent(_event_onExec);
  
    if _prop_RunEvent = 1 then
    begin
      if FEvWait = 0 then
        FEvWait := CreateEvent(nil, False{=Auto-reset}, False, nil);
      
      WaitRec.Event1 := FEvWait;
      WaitRec.Event2 := H;
      
      if WaitForMultipleObjects(2, @WaitRec, False {wait any}, INFINITE) > 0 then // 0 - прерывание ожидания, 1 - завершилась программа
      begin
        GetExitCodeProcess(H, FExitCode);
        _hi_CreateEvent(_Data, @_event_onFinished);
      end;
    end;
    
    CloseHandle(H);
  end
  else
    _hi_CreateEvent(_Data, @_event_onErrorExec, Integer(GetLastError()));
end;

procedure THIWinExec._work_doShellExec;
var
  Fn, Params, WD, Action: string;
begin
  Fn := ReadString(_Data, _data_FileName, _prop_FileName);
  Params := ReadString(_Data, _data_Params, _prop_Param);
  WD := ReadString(_Data, _data_WorkingDir, _prop_WorkingDir);
  Action := ReadString(_Data, _data_Action, _prop_Action);
  
  if ShellExecute(0, Pointer(Action), Pointer(Fn), Pointer(Params), Pointer(WD), _prop_Mode) > 32 then
    _hi_CreateEvent(_Data, @_event_onExec)
  else
    _hi_CreateEvent(_Data, @_event_onErrorExec, Integer(GetLastError()));
end;




// Работа с консольными приложениями

function THIWinExec.PreparePipes: Boolean;
var
  SA: TSecurityAttributes;
  dwError: DWord;
begin
  if FPipeInRead <> 0 then // Уже созданы
  begin
    Result := True;
    Exit;
  end;

  SA.nLength := SizeOf(TSecurityAttributes);
  SA.bInheritHandle := True;
  SA.lpSecurityDescriptor := nil;

  Result := 
    CreatePipe(FPipeInRead, FPipeInWrite, @SA, 0{auto}) and
    CreatePipe(FPipeOutRead, FPipeOutWrite, @SA, READ_BUFFER_SIZE) and
    CreatePipe(FPipeErrRead, FPipeErrWrite, @SA, READ_BUFFER_SIZE);

  if Result then
  begin
    // Ensure the read handle to the pipe for STDOUT is not inherited.
    SetHandleInformation(FPipeOutRead, HANDLE_FLAG_INHERIT, 0);
    
    // Ensure the read handle to the pipe for STDERR is not inherited.
    SetHandleInformation(FPipeErrRead, HANDLE_FLAG_INHERIT, 0);
    
    // Ensure the write handle to the pipe for STDIN is not inherited.
    SetHandleInformation(FPipeInWrite, HANDLE_FLAG_INHERIT, 0);
  end
  else
  begin
    // Если часть каналов была создана, а часть нет -
    // сохраняем код ошибки, уничтожаем созданные,
    // и восстанавливаем код ошибки (CloseHandle() сбросит код ошибки)
    dwError := GetLastError;
    DestroyPipes;
    SetLastError(dwError);
  end;
end;

procedure THIWinExec.DestroyPipes;
begin
  CloseHandle(FPipeInRead);
  CloseHandle(FPipeInWrite);
  CloseHandle(FPipeOutRead);
  CloseHandle(FPipeOutWrite);
  CloseHandle(FPipeErrRead);
  CloseHandle(FPipeErrWrite);
  
  FPipeInRead := 0;
  FPipeInWrite := 0;
  FPipeOutRead := 0;
  FPipeOutWrite := 0;
  FPipeErrRead := 0;
  FPipeErrWrite := 0;
end;

procedure THIWinExec.StartReading;
begin
  if (FProcessH = 0) or
     (FReadingThread <> nil)
  then
    Exit;
  
  FReadingThread := {$ifdef F_P}NewThreadForFPC{$else}NewThread{$endif};
  FReadingThread.OnExecute := ExecuteReading;
  FReadingThread.AutoFree := True;
  FReadingThread.Resume;
end;

procedure THIWinExec.StopReading;
begin
  if FReadingThread <> nil then
  begin
    FReadingThread.Tag := 1; // Предписываем потоку завершиться
    FReadingThread := nil;
  end;
end;


procedure THIWinExec.Detach;
begin
  if FProcessH = 0 then Exit;
  
  StopReading;
  DestroyPipes;
  
  CloseHandle(FProcessH);
  FProcessH := 0;
  
  SetEvent(FEvWait);
end;

procedure THIWinExec.Terminate;
begin
  if FProcessH = 0 then Exit;
  
  StopReading;
  DestroyPipes;
  
  TerminateProcess(FProcessH, 0);
  
  CloseHandle(FProcessH);
  FProcessH := 0;
  
  SetEvent(FEvWait);
end;

procedure THIWinExec.ProcessTerminated;
begin
  FReadingThread := nil;
  
  GetExitCodeProcess(FProcessH, FExitCode);
  
  DestroyPipes;
  CloseHandle(FProcessH);
  FProcessH := 0;
  
  _hi_OnEvent(_event_onConsoleTerminate);
  
  // Отпустить поток, блокированный по doConsoleExec при RunEvent=Wait
  SetEvent(FEvWait);
end;

function THIWinExec.ExecuteReading(T: PThread): NativeInt;
var
  DataAvail, IsTerminated: Boolean;
  Buf: TBytes;
  BR: DWord;
begin
  Result := 0;
  IsTerminated := False;
  
  // T.Tag = 1 - нас принудительно завершают, прекратить всю работу и завершиться максимально быстро.
  // По выходу из метода FReadingThread.AutoFree освободит объект потока.


  SetLength(Buf, READ_BUFFER_SIZE);


  // PeekNamedPipe() возвращает False только когда закрывается локальный хендл (аргумент функции).
  // Когда удаленный процесс завершается, PeekNamedPipe() продолжает возвращать True.
  // В том же случае при закрытии противоположного конца канала ReadFile возвращает False и
  // GetLastError = ERROR_BROKEN_PIPE


  repeat
    DataAvail := False;

    // Чтение канала STDOUT
    BR := 0;
    if PeekNamedPipe(FPipeOutRead, nil, 0, nil, @BR, nil) then
    begin
      // При использвании PeekNamedPipe() нельзя определить, когда в канал подаются данные 0-вой длины.
      // Это можно отловить по ReadFile()=True с 0-вой длиной данных.
      if BR > 0 then
      begin
        if ReadFile(FPipeOutRead, Pointer(Buf)^, READ_BUFFER_SIZE, BR, nil) then
        begin
          DataAvail := True;
          //if BR > 0 then // Здесь все равно BR <> 0
            _hi_OnEvent(_event_onConsoleResult, BufToBinaryStr(Pointer(Buf), BR));
        end;
        {else
        begin
          // ReadFile() может дать ошибку, когда удаленный процесс хочет завершиться -
          // нам нужно дождаться его завершения ниже.
          Break;
        end;}
      end;
    end
    else // Ошибка - закрыли локальный хендл, нам больше нечего делать
    begin
      Break;
    end;

    // Ручная остановка, в т.ч. из _event_onConsoleResult
    if T.Tag = 1 then Break;
 
    // Чтение канала STDERR
    BR := 0;
    if PeekNamedPipe(FPipeErrRead, nil, 0, nil, @BR, nil) then
    begin
      if BR > 0 then
      begin
        if ReadFile(FPipeErrRead, Pointer(Buf)^, READ_BUFFER_SIZE, BR, nil) then
        begin
          DataAvail := True;
          //if BR > 0 then
            _hi_OnEvent(_event_onConsoleError, BufToBinaryStr(Pointer(Buf), BR));
        end;
        {else
        begin
          Break;
        end;}
      end;
    end
    else
    begin
      Break;
    end;
    
    // Если ни из одного канала данных не поступило - падаем на таймаут, ожидая завершения процесса
    if (T.Tag <> 1) and (not DataAvail) then
    begin
      // В предыдущих итерациях уже определили завершение процесса и были прочитаны все данные из каналов
      if IsTerminated then
      begin
        ProcessTerminated;
        // Чтобы ниже не делалось FReadingThread := nil, так как делается по ProcessTerminated()
        // и там же может запуститься новый поток по _event_onConsoleTerminate
        T.Tag := 1;
        Break;
      end;
      
      // WaitForSingleObject() <> WAIT_TIMEOUT - процесс завершился.
      // Либо ошибка после закрытия FProcessH по Detach()/Terminate(). Тогда и T.Tag = 1.
      if (WaitForSingleObject(FProcessH, 20) <> WAIT_TIMEOUT) and (T.Tag <> 1) then
      begin
        // Выставляем флаг завершения и продолжаем выборку оставшихся данных из каналов
        IsTerminated := True;
      end;
    end;

  until (T.Tag = 1);



  // Если мы сюда дошли сами без требования остановки по FReadingThread.Tag := 1
  // - обнуляем поле, так как дальше объект потока будет уничтожен.
  if T.Tag <> 1 then
  begin
    FReadingThread := nil;
    SetEvent(FEvWait); // Для случаев ошибок когда ProcessTerminated() выше не был вызван
  end;
end;

procedure THIWinExec.StartConsoleApp(const Fn, CmdLine, WDir: string);
var
  SI: TStartupInfo;
  PI: TProcessInformation;
begin
  if FProcessH <> 0 then Exit;
  
  FProcessID := 0;
  FExitCode := 0;
  
  if not PreparePipes then
  begin
    _hi_OnEvent(_event_onErrorExec, Integer(GetLastError()));
    Exit;
  end;
  
  FillChar(SI, SizeOf(TStartupInfo), 0);
  with SI do
  begin
    cb := SizeOf(TStartupInfo);
    dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
    wShowWindow := _prop_Mode;
    
    hStdInput := FPipeInRead;
    hStdOutput := FPipeOutWrite;
    hStdError := FPipeErrWrite;
  end;
  
  if CreateProcess(nil, PChar(Trim(Fn + ' ' + CmdLine)), nil, nil,
                        True, CREATE_NEW_CONSOLE, nil, Pointer(WDir), SI, PI)
  then
  begin
    FProcessID := PI.dwProcessId;
    FProcessH := PI.hProcess;
    CloseHandle(PI.hThread);
    
    if _prop_RunEvent = 1 then
    begin
      // Приостановка метода doConsoleExec до завершения работы программы.
      // Ожидаем на событии, а не хендле процесса, чтобы по завершении
      // поток чтения успел убрать за собой. Событие сигналит поток чтения.
      if FEvWait = 0 then
        FEvWait := CreateEvent(nil, False{=Auto-reset}, False, nil);
      
      _hi_OnEvent(_event_onExec);
      StartReading;
      
      WaitForSingleObject(FEvWait, INFINITE);
    end
    else
    begin
      _hi_OnEvent(_event_onExec);
      StartReading;
    end;
  end
  else
  begin
    SI.cb := GetLastError();
    DestroyPipes; // По onErrorExec могут захотеть повторить запуск
    _hi_OnEvent(_event_onErrorExec, Integer(SI.cb));
  end;
end;

procedure THIWinExec._work_doConsoleExec;
var
  Fn, Cmd, WD: string;
begin
  Fn := ReadString(_Data, _data_FileName, _prop_FileName);
  Cmd := ReadString(_Data, _data_Params, _prop_Param);
  WD := ReadString(_Data, _data_WorkingDir, _prop_WorkingDir);
  StartConsoleApp(Fn, Cmd, WD);
end;

procedure THIWinExec._work_doConsoleInput;
var
  BW: DWord;
  S: string;
begin
  if FProcessH = 0 then Exit;
  S := Share.ToString(_Data);
  WriteFile(FPipeInWrite, Pointer(S)^, BinaryLength(S), BW, nil);
end;

procedure THIWinExec._work_doConsoleTerminate;
begin
  if FProcessH <> 0 then
  begin
    Terminate;
    _hi_CreateEvent(_Data, @_event_onConsoleTerminate);
  end;
end;

procedure THIWinExec._work_doConsoleDetach;
begin
  Detach;
end;


procedure THIWinExec._var_ExitCode(var _Data: TData; Index: word);
begin
  dtInteger(_Data, FExitCode);
end;

procedure THIWinExec._var_ProcessID(var _Data: TData; Index: word);
begin
  dtInteger(_Data, FProcessID);
end;

end.
