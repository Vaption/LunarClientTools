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
echo 5. Delete LunarClient's Jre
echo 6. Delete the Offline Folder
echo 7. Fix Launcher Startup Issue
echo 8. Backup and Save your Profiles
echo 9. Switch to Dedicated GPU on LunarClient
echo 10. Permanently Run LunarClient as Administrator
echo 11. Exit
echo.
set /P M=Type 1-11 and then press enter:
if %M%==1 goto :deep-unins
if %M%==2 goto :cache-rem
if %M%==3 goto :logs-rem
if %M%==4 goto :lc-folder
if %M%==5 goto :jre-rem
if %M%==6 goto :ofl-rem
if %M%==7 goto :lc-comp
if %M%==8 goto :prf-backup
if %M%==9 goto :igpu-dgpu
if %M%==10 goto :lc-admin
if %M%==11 goto :kill

@ECHO ON

:lc-folder
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