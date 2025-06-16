@rem LunarClientTools v1.9 by Vaption
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
TITLE LunarClientTools v1.9

@rem Check for administrator privileges
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if %errorlevel% NEQ 0 (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0""", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /b
)

@rem Main menu of the script
:menu
cls
echo [90m###################################################################[0m
echo [90m##[0m                  [96mLunar Client Tools Script[0m                    [90m##[0m
echo [90m##[0m          [36mhttps://github.com/Vaption/LunarClientTools[0m          [90m##[0m
echo [90m###################################################################[0m
echo.
echo [92mWhat are you trying to do?[0m
echo.
echo [91m1.[0m [97mImport Profiles From the Archive[0m
echo [91m2.[0m [97mAuto-detect Profiles and Replace Current Profile Manager[0m
echo [91m3.[0m [97mSwitch LunarClient's GPU to Dedicated/Integrated[0m
choice /C 123 /N
if errorlevel 3 goto :igpu-dgpu
if errorlevel 2 goto :json-auto
if errorlevel 1 goto :json-archive

@rem Code to get data.json from LunarClientProfiles repository
:json-archive
@rem Sync with the archive to display present profile
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
set "choiceNumbers="
for /l %%N in (1,1,!count!) do (
    set "choiceNumbers=!choiceNumbers!%%N"
)
choice /C !choiceNumbers! /N /M "[96mEnter the number of the profile you want to import[0m[91m:"
set "choice=%errorlevel%"

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

@rem Download profiles from the archive and extract it, using powershell
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

@rem Scan for available profiles on the user's computer
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
timeout /t 2 /nobreak >nul
set /a totalProfiles=0
for /d %%i in ("%settingsFolder%\*") do (
    set /a totalProfiles+=1
)
@rem Automatically generate and replace profile_manager.json based on the profile folder available
echo [92mFound %totalProfiles% profiles in the settings folder.[0m
echo [92mTerminating launcher processes...[0m
taskkill /im "Lunar Client.exe" /f 2>nul
timeout /t 2 /nobreak >nul
echo [32mTask completed.[0m
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
del "%userprofile%"\.lunarclient\.lct-cache\* /Q 2>nul
rmdir /s /q "%userprofile%"\.lunarclient\.lct-cache\ 2>nul
pause >nul
cls
goto :menu

@rem Change if Lunar should use your integrated, or dedicated graphics
:igpu-dgpu
echo.
echo.
echo.
choice /N /C DI /M "Which Graphics Processor are you trying to switch to? Press D for Dedicated, Press I for Integrated"%1
IF ERRORLEVEL==2 goto :igpu-dgpu-dedicated
IF ERRORLEVEL==1 goto :igpu-dgpu-integrated

@rem Confirm
:igpu-dgpu-integrated
choice /N /C YC /M "Are you sure you want to proceed? Press Y to Continue, Press C to Cancel"%1
IF ERRORLEVEL==2 goto :menu
IF ERRORLEVEL==1 goto :igpu-dgpu-action-integrated
:igpu-dgpu-action-integrated
@echo off
set "root_directory=%userprofile%\.lunarclient\jre\"
set "javaw_path="
@rem Find the javaw.exe file
:findjavaw
for /d %%i in ("%root_directory%\*") do (
    if exist "%%i\bin\javaw.exe" (
        set "javaw_path=%%i\bin\"
        goto :validatejavaw
    )
    set "root_directory=%%i"
    goto :findjavaw
)

@rem Change the registry value for javaw.exe to switch the GPU used by LunarClient to Power Saving graphics
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
pause >nul
cls
goto :menu

@rem Confirm (again)
:igpu-dgpu-dedicated
choice /N /C YC /M "Are you sure you want to proceed? Press Y to Continue, Press C to Cancel"%1
IF ERRORLEVEL==2 goto :menu
IF ERRORLEVEL==1 goto :igpu-dgpu-action-dedicated
:igpu-dgpu-action-dedicated
@echo off
set "root_directory=C:\Users\%username%\.lunarclient\jre\"
set "javaw_path="
@rem Find the javaw.exe file (again)
:findjavaw
for /d %%i in ("%root_directory%\*") do (
    if exist "%%i\bin\javaw.exe" (
        set "javaw_path=%%i\bin\"
        goto :validatejavaw
    )
    set "root_directory=%%i"
    goto :findjavaw
)

@rem Change the registry value for javaw.exe to switch the GPU used by LunarClient to High Performance graphics
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
pause >nul
cls
goto :menu