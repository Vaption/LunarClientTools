@ECHO OFF


NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (

echo.
) ELSE (

echo [90m#############################[0m [31mERROR[0m [90m###############################[0m
echo [90m#[0m                                                                 [90m#[0m
echo [90m#[0m   [91mThis script must be run as administrator to work properly.[0m    [90m#[0m
echo [90m#[0m   [91mRight click on the script and select Run As Administrator[0m     [90m#[0m
echo [90m###################################################################[0m
echo.
echo.

PAUSE
EXIT /B 1
)

GOTO :windows-version

:windows-version
SETLOCAL ENABLEDELAYEDEXPANSION
SET count=1
FOR /F "tokens=* USEBACKQ" %%F IN (`wmic os get version`) DO (
SET varver!count!=%%F
SET /a count=!count!+1
)
IF %varver2% GEQ 10.* (
    goto :menu) ELSE (
        goto :windows-error
        )
ENDLOCAL

:menu 
echo [90m###################################################################[0m
echo [90m##[0m                  [96mLunar Client Tools Script[0m                    [90m##[0m
echo [90m##[0m          [36mhttps://github.com/Vaption/LunarClientTools[0m          [90m##[0m
echo [90m###################################################################[0m
echo.
echo [92mWhat are you trying to do?[0m
echo.
echo [91m1.[0m [97mDeep Uninstall[0m
echo [91m2.[0m [97mClear Cache Files[0m
echo [91m3.[0m [97mClear Logs Directory[0m
echo [91m4.[0m [97mNavigate to .lunarclient[0m
echo [91m5.[0m [97mDelete LunarClient's JRE[0m
echo [91m6.[0m [97mDelete the Offline Folder[0m
echo [91m7.[0m [97mFix Launcher Startup Issue[0m
echo [91m8.[0m [97mBackup and Save your Profiles[0m
echo [91m9.[0m [97mSwitch to Dedicated GPU on LunarClient[0m
echo [91m10.[0m [97mPermanently Run LunarClient as Administrator[0m
echo [91m11.[0m [97mExit[0m
echo.
set /P M=[96mType[0m [91m1-11[0m [96mand then press enter[0m[91m:[0m
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

:deep-unins
echo.
echo.
echo.
%SystemRoot%\explorer.exe "%userprofile%\.lunarclient\"
echo [32mSuccessfully opened .lunarclient in a new window.[0m
echo.
echo.
echo.
pause
cls
goto :menu

:cache-rem
echo.
echo.
echo.
del c:\Users\"%username%"\.lunarclient\game-cache\* /Q > nul
del c:\Users\"%username%"\.lunarclient\launcher-cache\* /Q > nul
del c:\Users\"%username%"\.lunarclient\offline\multiver\cache\* /Q > nul
echo [32mSuccessfully deleted LunarClient cached files.[0m
echo.
echo.
echo.
pause
cls
goto :menu

:logs-rem
echo.
echo.
echo.
del c:\Users\"%username%"\.lunarclient\logs\* /Q > nul
echo [32mSuccessfully cleared your game/launcher logs.[0m
echo.
echo.
echo.
pause
cls
goto :menu

:lc-folder
echo.
echo.
echo.
%SystemRoot%\explorer.exe "%userprofile%\.lunarclient\"
echo [32mSuccessfully opened .lunarclient in a new window.[0m
echo.
echo.
echo.
pause
cls
goto :menu

:jre-rem
echo.
echo.
echo.
del c:\Users\"%username%"\.lunarclient\jre\* /Q > nul
echo [32mSuccessfully deleted LunarClient's JRE.[0m
echo.
echo.
echo.
pause
cls
goto :menu

:ofl-rem
echo.
echo.
echo.
del c:\Users\"%username%"\.lunarclient\offline\* /Q > nul
echo [32mSuccessfully deleted LunarClient's offline folder.[0m
echo.
echo.
echo.
pause
cls
goto :menu

:lc-comp
echo.
echo.
echo.
reg.exe Add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "c:\Users\"%username%"\AppData\Local\Programs\lunarclient\Lunar Client.exe" /d "~ WIN8RTM"
echo [32mSuccessfully modified the launcher's compability settings.[0m
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
echo [32mSuccessfully copied your profiles to your desktop.[0m
echo [92mFile Path: c:\Users\"%username%"\Desktop\LCT-Profiles[0m
%SystemRoot%\explorer.exe "c:\Users\"%username%"\Desktop\LCT-Profiles\"
echo.
echo.
echo.
pause
cls
goto :menu

:igpu-dgpu
echo.
echo.
echo.
%SystemRoot%\explorer.exe "%userprofile%\.lunarclient\"
echo [32mSuccessfully opened .lunarclient in a new window.[0m
echo.
echo.
echo.
pause
cls
goto :menu

:lc-admin
echo.
echo.
echo.
%SystemRoot%\explorer.exe "%userprofile%\.lunarclient\"
echo [32mSuccessfully opened .lunarclient in a new window.[0m
echo.
echo.
echo.
pause
cls
goto :menu

:kill
exit

@rem windows version incompatible error here
:windows-error
echo [90m#############################[0m [31mERROR[0m [90m###############################[0m
echo [90m#[0m                                                                 [90m#[0m
echo [90m#[0m          [91mThis script only works on Windows 10 and 11.[0m           [90m#[0m
echo [90m#[0m         [91mYour current Windows version is not supported[0m           [90m#[0m
echo [90m#[0m     [91mIf you believe this is an issue, open an issue on Github[0m    [90m#[0m
echo [90m###################################################################[0m
echo.
echo.
PAUSE