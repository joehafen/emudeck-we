::::::::::::::::::::::::::::::::::::::::::::
:: Elevate.cmd - Version 4
:: Automatically check & get admin rights
:: see "https://stackoverflow.com/a/12264592/1016343" for description
::::::::::::::::::::::::::::::::::::::::::::
 @Write-Output off
 CLS
 ECHO.
 Write-Output =============================
 Write-Output Running Admin shell desktopmode.bat
 Write-Output =============================

:init
 setlocal DisableDelayedExpansion
 set cmdInvoke=1
 set winSysFolder=System32
 set "batchPath=%~dpnx0"
 rem this works also from cmd shell, other than %~0
 for %%k in (%0) do set batchName=%%~nk
 set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
 setlocal EnableDelayedExpansion

:checkPrivileges
  NET FILE 1>NUL 2>NUL
  if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
  if '%1'=='ELEV' (Write-Output ELEV & shift /1 & goto gotPrivileges)
  ECHO.
  Write-Output **************************************
  Write-Output Invoking UAC for Privilege Escalation
  Write-Output **************************************

  Write-Output Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
  Write-Output args = "ELEV " >> "%vbsGetPrivileges%"
  Write-Output For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
  Write-Output args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
  Write-Output Next >> "%vbsGetPrivileges%"
  
  if '%cmdInvoke%'=='1' goto InvokeCmd 

  Write-Output UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
  goto ExecElevation

:InvokeCmd
  Write-Output args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
  Write-Output UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 1 >> "%vbsGetPrivileges%"

:ExecElevation
 "%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
 exit /B

:gotPrivileges
 setlocal & cd /d %~dp0
 if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

 ::::::::::::::::::::::::::::
 ::START
 ::::::::::::::::::::::::::::


taskkill /F /IM steam.exe > NUL 2>NUL
echo|set /p="Loading Windows Desktop in a few seconds seconds, don't close this window..."
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /t REG_SZ /d "explorer.exe" /f
IF %ERRORLEVEL% == 0 ( Write-Output OK! ) ELSE ( Write-Output FAIL! )
taskkill /F /IM sihost.exe
timeout /T 5 /nobreak > NUL 2>NUL
start sihost.exe
timeout /T 5 /nobreak > NUL 2>NUL
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /t REG_SZ /d "cmd /c start /min """GamingMode""" """%USERPROFILE%\AppData\Roaming\EmuDeck\backend\tools\gamemode\logon.bat"""" /f
IF %ERRORLEVEL% == 0 ( Write-Output OK! ) ELSE ( Write-Output FAIL! )
exit