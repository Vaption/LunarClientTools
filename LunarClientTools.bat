@ECHO OFF


NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (

echo.
) ELSE (

echo "############################# ERROR ###############################"
echo "#                                                                 #"
echo "#   This script must be run as administrator to work properly.    #"
echo "#   Right click on the script and select Run As Administrator     #"
echo "###################################################################"
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
echo.
echo.
echo What are you trying to do?
echo.
echo 1. Deep Uninstall
echo 2. Clear Cache Files
echo 3. Clear Logs Directory
echo 4. Navigate to .lunarclient
echo 5. Backup and Save your Profiles
echo 6. Exit
echo.
set /P M=Type 1-6 and then press enter:
if %M%==1 goto :deep-unins
if %M%==2 goto :cache-rem
if %M%==3 goto :logs-rem
if %M%==4 goto :lcfolder
if %M%==5 goto :prf-backup
if %M%==6 goto :kill

@ECHO ON

:lcfolder
echo.
echo.
echo.
%SystemRoot%\explorer.exe "%userprofile%\.lunarclient\"
echo Successfully opened .lunarclient in a new window.
echo.
echo.
echo.
pause
cls
goto :menu

:prf-backup
echo.
echo.
echo.
mkdir c:\Users\"%username%"\Desktop\"LCT-Profiles"
xcopy /s /v c:\Users\"%username%"\.lunarclient\settings\game c:\Users\"%username%"\Desktop\LCT-Profiles /Q > nul
del c:\Users\"%username%"\Desktop\LCT-Profiles\accounts.json
del c:\Users\"%username%"\Desktop\LCT-Profiles\alert_manager.json
del c:\Users\"%username%"\Desktop\LCT-Profiles\features.json
del c:\Users\"%username%"\Desktop\LCT-Profiles\global_options.json
del c:\Users\"%username%"\Desktop\LCT-Profiles\internal.json
del c:\Users\"%username%"\Desktop\LCT-Profiles\knownServers.json
del c:\Users\"%username%"\Desktop\LCT-Profiles\language.json
del c:\Users\"%username%"\Desktop\LCT-Profiles\main_menu_theme_manager.json
del c:\Users\"%username%"\Desktop\LCT-Profiles\metadata_fallback.json
del c:\Users\"%username%"\Desktop\LCT-Profiles\muted_users.json
del c:\Users\"%username%"\Desktop\LCT-Profiles\rule-features.json
del c:\Users\"%username%"\Desktop\LCT-Profiles\statistics.json
del c:\Users\"%username%"\Desktop\LCT-Profiles\version
echo Successfully copied your profiles to your desktop.
echo File Path: c:\Users\"%username%"\Desktop\LCT-Profiles
%SystemRoot%\explorer.exe "c:\Users\"%username%"\Desktop\LCT-Profiles\"
echo.
echo.
echo.
pause
cls
goto :menu

:kill
exit