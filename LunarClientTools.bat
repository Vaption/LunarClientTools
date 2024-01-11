@ECHO OFF

@REM colors
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
set "DEL=%%a"
)


NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (


echo        Administrator Privileges Detected!
echo.
) ELSE (

echo.
call :colorEcho 0C "########### ERROR - ADMINISTRATOR PRIVILEGES REQUIRED #############"
echo.
call :colorEcho 0C "#                                                                 #"
echo.
call :colorEcho 0C "#"
call :colorEcho 07 "    This script must be run as administrator to work properly."
call :colorEcho 0C "    #"
echo.
call :colorEcho 0C "#"
call :colorEcho 07 "    right click on the icon and select Run As Administrator"
call :colorEcho 0C " #"
echo.
call :colorEcho 0C "#                                                                 #"
echo.
call :colorEcho 0C "###################################################################"
echo.
echo.

PAUSE
EXIT /B 1
)

GOTO :menu

:menu 
echo =============================================================
echo ==               Lunar Client Tools Script                 ==
echo ==       https://github.com/Vaption/LunarClientTools       ==
echo ============================================================= 
echo What are you looking for?
echo 1. Deep Uninstall
echo 2. Clear Cache Files
echo 3. Clear Logs Directory
echo 4. Navigate to .lunarclient
echo 5. Backup and Save your Profiles
echo 6. Exit

set /P M=Type 1-6 and then press enter:
if %M%==1 goto :deep-unins
if %M%==2 goto :cache-rem
if %M%==3 goto :logs-rem
if %M%==4 goto :lcfolder
if %M%==5 goto :prf-backup
if %M%==6 goto :kill

@ECHO ON 

:lcfolder
%SystemRoot%\explorer.exe "%userprofile%\.lunarclient\"
call :colorEcho 07 "    Successfully opened .lunarclient in a new window."
pause
goto :menu

:kill
exit