' 参考
' スクリプト センター > スクリプトを学ぶ > Hey, Scripting Guy!
' イベント ログに追加された最新のイベントに関する情報を取得する方法はありますか
' http://www.microsoft.com/japan/technet/scriptcenter/resources/qanda/jan06/hey0131.mspx
' スクリプト センター > スクリプト一覧 > ログ > イベント ログ
' 特定イベント ログの照会
' http://www.microsoft.com/japan/technet/scriptcenter/scripts/logs/eventlog/lgevvb11.mspx

Option Explicit
On Error Resume Next
Dim InputKey, LogFiles, i , MaxLog

If Right((LCase(WScript.FullName)),11) <> "cscript.exe" then
  WScript.Echo "このスクリプトはCSCRIPT.EXEを使用して実行して下さい。" & _
    vbCRLF & "例： cscript eventvcui.vbs"
  WScript.Quit
End if

InputKey = ""
Do While InputKey <> "Q"
  WScript.Echo
  WScript.Echo "イベント ビューアー（CUI）"
  WScript.Echo "───────────────────────────────────────"
  WScript.Echo
  MaxLog = 0
  LogFiles = GetLogFileName()
  WScript.Echo "   0 アプリケーション(" & LogFiles(0) & ")"
  WScript.Echo "   1 セキュリティ(" & LogFiles(1) & ")"
  WScript.Echo "   2 システム(" & LogFiles(2) & ")"
  For i = 3 to Ubound(LogFiles)
    if LogFiles(i) <> "" then
      if i < 10 then
        WScript.Echo "   " & i & " " & LogFiles(i)
      Else
        WScript.Echo "  " & i & " " & LogFiles(i)
      End If
    Else
      WScript.Echo
      if MaxLog = 0 then
        MaxLog = i - 1
      End If
    End If
  Next
  WScript.Echo
  WScript.Echo "───────────────────────────────────────"
  WScript.StdOut.Write "番号を入力して下さい（Q 終了）： "
  InputKey = Trim(Ucase(WScript.StdIn.ReadLine))
  If IsNumeric(InputKey) then
    If Int(InputKey) <= Int(MaxLog) then
      Call LogSummary(LogFiles(Int(InputKey)))
    End If
  End If
Loop

Function GetLogFileName()
  Dim LogFiles(17), i, strComputer, objWMIService, objInstalledLogFiles, objLogfile
  LogFiles(0) = "Application"
  LogFiles(1) = "Security"
  LogFiles(2) = "System"
  i = 3
  strComputer = "." 
  Set objWMIService = GetObject("winmgmts:" _ 
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2") 
  Set objInstalledLogFiles = objWMIService.ExecQuery _ 
    ("Select * from Win32_NTEventLogFile") 
  For each objLogfile in objInstalledLogFiles 
    Select Case objLogfile.LogFileName
    Case "Application"
    Case "Security"
    Case "System"
    Case Else
      LogFiles(i) = objLogfile.LogFileName
      i = i + 1
    End Select
  Next
  GetLogFileName = LogFiles
End Function


Sub LogSummary(LogFile)
  Dim LastLogID, FirstLogID, MinLogID, MaxLogID, _
      strComputer, objWMIService, colLoggedEvents, _
      objEvent, colLogFiles, colLogFile, aEvents(18), _
      i, j, strDateTime, strLevel

  MinLogID = 1
  MaxLogID = 0
  InputKey = "R"

  strComputer = "." 
  Set objWMIService = GetObject("winmgmts:" _ 
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2") 
  Do While InputKey <> "Q" AND InputKey <> "T"
    For i = 0 to 17
      aEvents(i) = ""
    Next
    If InputKey = "R" then
      Set colLogFiles = objWMIService.ExecQuery _ 
        ("Select * from Win32_NTEventLogFile Where LogfileName = '" & LogFile & "'") 
      For Each colLogFile in colLogFiles
        MaxLogID = colLogFile.NumberOfRecords
      Next
      Set colLogFiles = Nothing
      If IsNull(MaxLogID) then
        MaxLogID = 0
        MinLogID = 0
        LastLogID = 0
      Else
        Set colLoggedEvents = objWMIService.ExecQuery _ 
          ("Select * from Win32_NTLogEvent Where Logfile = '" & LogFile & "'") 
        For Each objEvent in colLoggedEvents
          If Not IsNull(objEvent.RecordNumber) Then
            MinLogID = objEvent.RecordNumber
            Exit For
          End If
        Next
        Set colLoggedEvents = Nothing
        LastLogID = MinLogID
        MinLogID = MinLogID - MaxLogID + 1
        MaxLogID = LastLogID
      End If
    End If
    FirstLogID = LastLogID - 17
    If FirstLogID < MinLogID Then
      FirstLogID = MinLogID
    End If
    WScript.Echo
    WScript.Echo "イベント ビューアー： " & LogFile & "  " & MaxLogID - MinLogID + 1 & " イベント" 
    WScript.Echo "───────────────────────────────────────"
    WScript.Echo "Record No. レベル     日付と時刻          Event ID ソース"
    If MaxLogID > 0 then
      Set  colLoggedEvents = objWMIService.ExecQuery _ 
        ("Select * from Win32_NTLogEvent Where Logfile = '" & _
          LogFile & "' AND RecordNumber <= " & LastLogID & " AND RecordNumber >= " & FirstLogID) 
      i = 0
      For Each objEvent in colLoggedEvents
        If Not IsNull(objEvent.RecordNumber) Then
          strDateTime = objEvent.TimeWritten
          strDateTime = Mid(strDateTime,1,4) & "/" & _
                        Mid(strDateTime,5,2) & "/" & _
                        Mid(strDateTime,7,2) & " " & _
                        Mid(strDateTime,9,2) & ":" & _
                        Mid(strDateTime,11,2) & ":" & _
                        Mid(strDateTime,13,2)
          Select Case objEvent.EventType
          Case 0
            strLevel = "○成功　　"
          Case 1
            strLevel = "×エラー　"
          Case 2
            strLevel = "△警告　　"
          Case 3
            strLevel = "！情報　　"
          Case 4
            strLevel = "成功の監査"
          Case 5
            strLevel = "失敗の監査"
          Case Else
            strLevel = "  (不明)　"
          End Select
          aEvents(i) = FixNumLen(objEvent.RecordNumber,10,False) & " " & _
                       strLevel & " " & strDateTime & " " & _
                       FixNumLen(objEvent.EventCode,8,True) & " "
          If Len(objEvent.SourceName) > 27 then
            aEvents(i) = aEvents(i) & Mid(objEvent.SourceName,1,25) & ".."
          Else
            aEvents(i) = aEvents(i) & objEvent.SourceName
          End If
          i = i + 1
        End If
      Next
      Set  colLoggedEvents = Nothing
    Else
      aEvents(0) = "（ログがありません。）"
    End If
    j = 0
    For i = 0 to 17
      if aEvents(i) <> "" then
        WScript.Echo aEvents(i)
        j = j + 1
      End If
    Next
    For i = 0 to 17 - j
      WScript.Echo
    Next
    WScript.Echo
    WScript.Echo "───────────────────────────────────────"
    WScript.StdOut.Write " 前へ(B) | 次へ(N) | 最新(R) | 詳細(Record No.) | トップへ(T) | 終了(Q) ："
    InputKey = Trim(Ucase(WScript.StdIn.ReadLine))
    If IsNumeric(InputKey) then
      Call LogDetail(LogFile,InputKey)
      InputKey = ""
    ElseIf InputKey = "N" then
      LastLogID = LastLogID - 18
      If LastLogID < 1 then
        LastLogID = MaxLogID
        InputKey = "R"
      End If
    ElseIf InputKey = "B" then
      LastLogID = LastLogID + 18
      If MaxLogID < LastLogID then
        LastLogID = MaxLogID
        InputKey = "R"
      End If
    ElseIf InputKey = "T" then
    ElseIf InputKey = "Q" then
    ElseIf InputKey = "R" then
    Else
      InputKey = ""
    End If
  Loop
End Sub

Sub LogDetail(LogFile,LogRecNo)
  Dim strComputer, objWMIService, colLoggedEvents, objEvent, _
      i, strDateTime, strLines, aText(20), LogRecNoTemp

  strComputer = "." 
  Set objWMIService = GetObject("winmgmts:" _ 
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2") 
  LogRecNoTemp = LogRecNo
  Do While InputKey <> "Q"
    For i = 0 to 19
      aText(i) = ""
    Next
    Set colLoggedEvents = objWMIService.ExecQuery _ 
      ("Select * from Win32_NTLogEvent Where Logfile = '" & _
       LogFile & "' AND RecordNumber = " & LogRecNoTemp)
    If Err <> 0 then
      aText(0) = "（イベントがありません。）"
    Else
      If ColLoggedEvents.Count > 0 then
        For Each objEvent in colLoggedEvents
          strDateTime = objEvent.TimeWritten
          aText(0) = "日付：    " & Mid(strDateTime,1,4) & "/" & _
            Mid(strDateTime,5,2) & "/" & Mid(strDateTime,7,2) & _
            "    ソース：    " & objEvent.SourceName
          aText(1) = "時刻：    " & Mid(strDateTime,9,2) & ":" & _
            Mid(strDateTime,11,2) & ":" & Mid(strDateTime,13,2) & _
            "      分類：      " & objEvent.Category
          aText(2) = "種類：    "
          Select Case objEvent.EventType
          Case 0
            aText(2) = aText(2) & "成功　  　"
          Case 1
            aText(2) = aText(2) & "エラー　  "
          Case 2
            aText(2) = aText(2) & "警告　  　"
          Case 3
            aText(2) = aText(2) & "情報　  　"
          Case 4
            aText(2) = aText(2) & "成功の監査"
          Case 5
            aText(2) = aText(2) & "失敗の監査"
          Case Else
            aText(2) = aText(2) & "  (不明)　"
          End Select
          aText(2) = aText(2) & "    イベントID：" & objEvent.EventCode
          aText(3) = "ユーザー：    " & objEvent.User 
          aText(4) = "コンピュータ：" & objEvent.ComputerName
          aText(5) = "説明："
          strLines = FormatText(replace(objEvent.Message,vbTab," "),78)
          For i = 6 to 19
            If strLines(i - 6) <> "" then
              aText(i) = strLines(i - 6)
            End If
          Next
        Next
      Else
        aText(0) = "（イベントがありません。）"
      End If
    End If
    Set colLoggedEvents = Nothing
    WScript.Echo
    WScript.Echo "イベントのプロパティ - " & LogFile & ", Record No. " & LogRecNoTemp
    WScript.Echo "───────────────────────────────────────"
    For i = 0 to 19
      WScript.Echo aText(i)
    Next
    WScript.Echo "───────────────────────────────────────"
    WScript.StdOut.Write " 前へ(B) | 次へ(N) | 閉じる(Q) ："
    InputKey = Trim(Ucase(WScript.StdIn.ReadLine))
    If InputKey = "N" then
      If LogRecNoTemp > 1 then
        LogRecNoTemp = LogRecNoTemp - 1
      End If
    ElseIf InputKey = "B" then
      LogRecNoTemp = LogRecNoTemp + 1
    End If
  Loop
End Sub

Function FixNumLen(Num,FixLen,IsRight)
  Dim strOut, i
  Num = CStr(Num)
  strOut = ""
  For i = 0 to FixLen - Len(Num) - 1
    strOut = strOut & " "
  Next
  If IsRight then
    FixNumLen = strOut & Num
  Else
    FixNumLen = Num & strOut 
  End If
End Function

Function FormatText(StrMessage,Cols)
  Dim aTemp, aOut(100), strTemp, i, j, LineLen
  aTemp = Split(StrMessage,vbCrLF)
  j = 0
  aOut(j) = ""
  LineLen = 0
  For i = 0 to Ubound(aTemp)
    aTemp(i) = replace(replace(aTemp(i),vbCR,""),vbLF,"")
    Do While Trim(aTemp(i)) <> ""
      strTemp = Mid(aTemp(i),1,1)
      'If (Asc(strTemp) >= 0) And (Asc(strTemp) <= 255) then
      If ( Asc(strTemp) And &HFF00 ) = 0 then
        LineLen = LineLen + 1
      Else
        LineLen = LineLen + 2
      End If
      If LineLen <= Cols then
        aOut(j) = aOut(j) & strTemp
        aTemp(i) = Mid(aTemp(i),2)
      Else
        j = j + 1
        LineLen = 0
        aOut(j) = ""
      End If
    Loop
  Next
  FormatText = aOut
End Function
