@rem LunarClientTools v1.8 by Vaption
@rem https://github.com/Vaption/LunarClientTools
@rem Please report any issues on Github

@rem MIT License
@rem Copyright (c) 2024 Vaption ✨

@rem Permission is hereby granted, free of charge, to any person obtaining a copy
@rem of this software and associated documentation files (the "Software"), to deal
@rem in the Software without restriction, including without limitation the rights
@rem to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
@rem copies of the Software, and to permit persons to whom the Software is
@rem furnished to do so, subject to the following conditions:

@rem The above copyright notice and this permission notice shall be included in all
@rem copies or substantial portions of the Software.

@rem THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
@rem IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
@rem FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
@rem AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
@rem LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
@rem OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
@rem SOFTWARE.

@ECHO OFF
TITLE LunarClientTools v1.8

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

PAUSE >nul
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
cls
echo [90m###################################################################[0m
echo [90m##[0m                  [96mLunar Client Tools Script[0m                    [90m##[0m
echo [90m##[0m          [36mhttps://github.com/Vaption/LunarClientTools[0m          [90m##[0m
echo [90m###################################################################[0m
echo.
echo [92mWhat are you trying to do?[0m
echo.
echo [91m1.[0m [97mClear Cached Files[0m
echo [91m2.[0m [97mNavigate to .lunarclient[0m
echo [91m3.[0m [97mProfile Management Options[0m
echo [91m4.[0m [97mSwitch LunarClient's GPU to Dedicated/Integrated[0m
echo [91m5.[0m [97mExit[0m
echo.
set /P M=[96mType[0m [91m1-5[0m [96mand then press enter[0m[91m:[0m
if %M%==1 goto :cache-rem
if %M%==2 goto :lc-folder
if %M%==3 goto :json-menu
if %M%==4 goto :igpu-dgpu
if %M%==5 goto :kill

@ECHO ON

:cls-menu
cls
goto :menu

:json-menu
cls
echo [90m###################################################################[0m
echo [90m##[0m                  [96mLunar Client Tools Script[0m                    [90m##[0m
echo [90m##[0m          [36mhttps://github.com/Vaption/LunarClientTools[0m          [90m##[0m
echo [90m###################################################################[0m
echo.
echo [92mProfile Management Options[0m
echo.
echo [91m1.[0m [97mImport Profiles From the Archive[0m
echo [91m2.[0m [97mList All Present Profiles in the Directory[0m
echo [91m3.[0m [97mAutodetect Profiles and Replace Current Profile Manager[0m
echo [91m4.[0m [97mManual Profile Manager Generator[0m
echo [91m5.[0m [97mExport Current Profiles to Desktop[0m
echo [91m6.[0m [97mCancel[0m
echo.
set /P M=[96mType[0m [91m1-6[0m [96mand then press enter[0m[91m:[0m
if %M%==1 goto :json-archive
if %M%==2 goto :json-list
if %M%==3 goto :json-auto
if %M%==4 goto :json-manual
if %M%==5 goto :json-backup
if %M%==6 goto :cls-menu
echo.
echo.
echo.
pause
cls
goto :menu

:json-archive
@rem sync with the archive
@Echo off
del "%userprofile%"\.lunarclient\.lct-cache\* /Q 2>nul
rmdir /s /q "%userprofile%"\.lunarclient\.lct-cache\ 2>nul
mkdir "%userprofile%"\.lunarclient\".lct-cache"
powershell -Command "$url = 'https://raw.githubusercontent.com/Vaption/LunarClientProfiles/main/profiles/data.json'; $filename = [System.IO.Path]::GetFileName($url); wget -Uri $url -OutFile ('%userprofile%\.lunarclient\.lct-cache\' + $filename)"
Powershell -Nop -C "$profiles = (Get-Content '%userprofile%\.lunarclient\.lct-cache\data.json' | ConvertFrom-Json).profiles; foreach ($profile in $profiles) { $profile.link | Out-File -FilePath ('%userprofile%\.lunarclient\.lct-cache\{0}.txt' -f $profile.name) }"
cls
echo [90m###################################################################[0m
echo [90m##[0m                  [96mLunar Client Tools Script[0m                    [90m##[0m
echo [90m##[0m          [36mhttps://github.com/Vaption/LunarClientTools[0m          [90m##[0m
echo [90m###################################################################[0m
echo.
echo [92mScanning current available profiles...[0m
timeout /t 3 /nobreak >nul
set "settingsFolder=%userprofile%\.lunarclient\settings\game"
set /a totalProfiles=0
for /d %%i in ("%settingsFolder%\*") do (
    set /a totalProfiles+=1
)
if %totalProfiles% gtr 7 (
    echo [31mError: More than seven profiles are present![0m
    echo [31mMaximum amount of profiles allowed is eight, importing profiles isn't possible.[0m
    echo [31mPlease navigate to .lunarclient\settings\game and remove some profiles before running the command.[0m
    pause >nul
    exit /b
) else (
    goto :json-archive-loader
)
:json-archive-loader
@echo off
setlocal EnableDelayedExpansion
set "folderPath=%userprofile%\.lunarclient\.lct-cache"
set /a count=0
for %%F in ("%folderPath%\*.txt") do (
    set "filename=%%~nF"
    if not "!filename!"=="linkDisplay" (
        set /a count+=1
        set "file[!count!]=%%~nF"
    )
)
echo [97mAvailable Profiles on the Archive:[0m
for /l %%N in (1,1,!count!) do (
    echo %%N. !file[%%N]!
)
set /p choice=[96mEnter the number of the profile you want to import[0m[91m:[0m
if defined file[%choice%] (
    set "fileName=!file[%choice%]!.txt"
    set "filePath=%folderPath%\!fileName!"
    if exist "!filePath!" (
        set "tempFile=%folderPath%\linkDisplay.txt"
        if exist "!tempFile!" del "!tempFile!"
        type "!filePath!" > "!tempFile!"
        set "fileContent="
        for /f "usebackq delims=" %%G in ("!tempFile!") do (
            set "fileContent=%%G"
            goto :json-archive-link-display
        )
        :json-archive-link-display
        for /f "delims=" %%G in ("!fileContent!") do (
            set "downloadLink=%%G"
            goto :json-archive-downloader
        )
    ) else (
        echo [91mThe selected profile does not exist. Exiting...[0m
        timeout 3 >nul
        goto :menu
    )
)

:json-archive-downloader
echo [96mAttempting to download the profile from the archive...[0m
timeout 2 >nul
powershell -Command "$url = '!downloadLink!'; $filename = [System.IO.Path]::GetFileName($url); wget -Uri $url -OutFile ('%userprofile%\.lunarclient\settings\game\' + $filename); Expand-Archive -Path ('%userprofile%\.lunarclient\settings\game\' + $filename) -DestinationPath ('%userprofile%\.lunarclient\settings\game\' + [System.IO.Path]::GetFileNameWithoutExtension($filename)) -Force"
echo [32mProfile imported successfully, attempting to generate the new profile_manager.json...[0m
timeout 2 >nul
goto :json-auto
pause >nul
cls
goto :menu

:json-list
echo.
@echo off
setlocal
echo [32mScanning your profiles directory...[0m
timeout /t 4 /nobreak >nul
set "path=%userprofile%\.lunarclient\settings\game"
set count=0

for /d %%G in ("%path%\*") do (
    set /a count+=1
)
echo [92mYou have a total of %count%/8 profiles:[0m
echo.

for /d %%G in ("%path%\*") do (
    echo - %%~nG
)
echo.
echo.
echo.
endlocal
pause
cls
goto :menu

:json-auto
@echo off
setlocal enabledelayedexpansion
set "settingsFolder=%userprofile%\.lunarclient\settings\game"

if not exist "%settingsFolder%" (
    echo [91mThe settings folder does not exist in .lunarclient[0m
    echo [91mLCT was unable to detect any profile in your settings directory.[0m
    pause >nul
    exit /b
)
echo [92mScanning the settings folder...[0m
timeout /t 3 /nobreak >nul
set /a totalProfiles=0
for /d %%i in ("%settingsFolder%\*") do (
    set /a totalProfiles+=1
)

if %totalProfiles% gtr 8 (
    echo [31mError: More than eight profiles are present![0m
    echo [31mPlease navigate to .lunarclient\settings\game and remove some profiles before running the command.[0m
    del "%userprofile%"\.lunarclient\.lct-cache\* /Q 2>nul
    rmdir /s /q "%userprofile%"\.lunarclient\.lct-cache\ 2>nul
    pause >nul
    exit /b
) else (
    goto :json-auto-action
)
:json-auto-action
echo [92mFound %totalProfiles% profiles in the settings folder.[0m
echo [32mGenerating profiles...[0m
timeout /t 3 /nobreak >nul
set "jsonContent=["

for /d %%i in ("%settingsFolder%\*") do (
    set "folderName=%%~nxi"
    
    set "profileJson={"name":"!folderName!","displayName":"!folderName!","default":false,"active":false,"iconName":"","server":""}"
    
    set "jsonContent=!jsonContent!!profileJson!"
    set /a totalProfiles-=1
    if !totalProfiles! gtr 0 (
        set "jsonContent=!jsonContent!,"
    )
)
set "jsonContent=!jsonContent!]"
    
> "%userprofile%\.lunarclient\settings\game\profile_manager.json" echo !jsonContent!
echo.
echo [32mSuccessfully generated and replaced profile_manager.json[0m
echo [32mOperation successful.[0m
del "%userprofile%"\.lunarclient\.lct-cache\* /Q 2>nul
rmdir /s /q "%userprofile%"\.lunarclient\.lct-cache\ 2>nul
pause >nul
cls
goto :menu

:json-manual
@echo off
setlocal enabledelayedexpansion

echo [36mEnter the total number of profiles you want to add (Max=8):[0m
set /p totalProfiles=

if %totalProfiles% gtr 8 (
    echo [31mError: Maximum number of profiles exceeded. Please enter a number between 1 and 8.[0m
    pause >nul
    cls
    goto :menu
)

echo [32mGenerating profiles...[0m
echo.

set "jsonContent=["

for /l %%i in (1, 1, %totalProfiles%) do (
    echo [96mProfile %%i[0m
    echo [93mEnter the name for profile %%i:[0m
    set /p profileName=
    echo [93mEnter the display name for profile %%i:[0m
    set /p displayName=
    
    if %%i==1 (
        set "profileJson={"name":"!profileName!","displayName":"!displayName!","default":true,"active":true,"iconName":"","server":""}"
    ) else (
        set "profileJson=,{"name":"!profileName!","displayName":"!displayName!","default":false,"active":false,"iconName":"","server":""}"
    )
    
    set "jsonContent=!jsonContent!!profileJson!"
)

set "jsonContent=!jsonContent!]"
    
> "%userprofile%\Desktop\profile_manager.json" echo !jsonContent!

echo.
echo [32mSuccessfully generated profile_manager.json on your desktop.[0m
echo.
echo.
pause
cls
goto :menu

:json-backup
echo.
echo.
echo.
choice /N /C YC /M "Are you sure you want to proceed? Press Y to Continue, Press C to Cancel"%1
IF ERRORLEVEL==2 goto :menu
IF ERRORLEVEL==1 goto :json-backup-action
:json-backup-action
mkdir "%userprofile%"\Desktop\"LCT-Profiles"
xcopy /s /v "%userprofile%"\.lunarclient\settings\game "%userprofile%"\Desktop\LCT-Profiles /Q > nul
del "%userprofile%"\Desktop\LCT-Profiles\accounts.json
del "%userprofile%"\Desktop\LCT-Profiles\alert_manager.json
del "%userprofile%"\Desktop\LCT-Profiles\features.json
del "%userprofile%"\Desktop\LCT-Profiles\global_options.json
del "%userprofile%"\Desktop\LCT-Profiles\internal.json
del "%userprofile%"\Desktop\LCT-Profiles\knownServers.json
del "%userprofile%"\Desktop\LCT-Profiles\language.json
del "%userprofile%"\Desktop\LCT-Profiles\main_menu_theme_manager.json
del "%userprofile%"\Desktop\LCT-Profiles\metadata_fallback.json
del "%userprofile%"\Desktop\LCT-Profiles\muted_users.json
del "%userprofile%"\Desktop\LCT-Profiles\rule-features.json
del "%userprofile%"\Desktop\LCT-Profiles\statistics.json
del "%userprofile%"\Desktop\LCT-Profiles\version
echo [32mSuccessfully copied your profiles to your desktop.[0m
echo [92mFile Path: "%userprofile%"\Desktop\LCT-Profiles[0m
%SystemRoot%\explorer.exe "%userprofile%\Desktop\LCT-Profiles\"
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
choice /N /C YC /M "Are you sure you want to proceed? Press Y to Continue, Press C to Cancel"%1
IF ERRORLEVEL==2 goto :menu
IF ERRORLEVEL==1 goto :cache-rem-action
:cache-rem-action
del "%userprofile%"\.lunarclient\offline\multiver\cache\* /Q > nul
echo [32mSuccessfully deleted LunarClient game cache.[0m
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

:igpu-dgpu
echo.
echo.
echo.
choice /N /C DI /M "Which Graphics Processor are you trying to switch to? Press D for Dedicated, Press I for Integrated"%1
IF ERRORLEVEL==2 goto :igpu-dgpu-dedicated
IF ERRORLEVEL==1 goto :igpu-dgpu-integrated

:igpu-dgpu-integrated
choice /N /C YC /M "Are you sure you want to proceed? Press Y to Continue, Press C to Cancel"%1
IF ERRORLEVEL==2 goto :menu
IF ERRORLEVEL==1 goto :igpu-dgpu-action-integrated
:igpu-dgpu-action-integrated
@echo off
set "root_directory=%userprofile%\.lunarclient\jre\"
set "javaw_path="

:findjavaw
for /d %%i in ("%root_directory%\*") do (
    if exist "%%i\bin\javaw.exe" (
        set "javaw_path=%%i\bin\"
        goto :validatejavaw
    )
    set "root_directory=%%i"
    goto :findjavaw
)

:validatejavaw
if defined javaw_path (
    reg Add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\DirectX\UserGpuPreferences" /v "%javaw_path%javaw.exe" /d "GpuPreference=1;" /f
    color 0A
    echo Successfully switched LunarClient's GPU to Power Saving.
) else (
    color 0C
    echo LCT was unable to locate javaw.exe, relaunch the game for the file to be redownloaded.
)
echo.
echo.
pause
cls
goto :menu

:igpu-dgpu-dedicated
choice /N /C YC /M "Are you sure you want to proceed? Press Y to Continue, Press C to Cancel"%1
IF ERRORLEVEL==2 goto :menu
IF ERRORLEVEL==1 goto :igpu-dgpu-action-dedicated
:igpu-dgpu-action-dedicated
@echo off
set "root_directory=C:\Users\%username%\.lunarclient\jre\"
set "javaw_path="

:findjavaw
for /d %%i in ("%root_directory%\*") do (
    if exist "%%i\bin\javaw.exe" (
        set "javaw_path=%%i\bin\"
        goto :validatejavaw
    )
    set "root_directory=%%i"
    goto :findjavaw
)

:validatejavaw
if defined javaw_path (
    reg Add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\DirectX\UserGpuPreferences" /v "%javaw_path%javaw.exe" /d "GpuPreference=2;" /f
    color 0A
    echo Successfully switched LunarClient's GPU to High Performance.
) else (
    color 0C
    echo LCT was unable to locate javaw.exe, relaunch the game for the file to be redownloaded.
)
echo.
echo.
pause
cls
goto :menu

:kill
exit

@rem unsupported windows version error here
:windows-error
echo [90m#############################[0m [31mERROR[0m [90m###############################[0m
echo [90m#[0m                                                                 [90m#[0m
echo [90m#[0m          [91mThis script only works on Windows 10 and above.[0m           [90m#[0m
echo [90m#[0m         [91mYour current Windows version is not supported[0m           [90m#[0m
echo [90m#[0m     [91mIf you believe this is an issue, open an issue on Github[0m    [90m#[0m
echo [90m###################################################################[0m
echo.
echo.
PAUSE >nul