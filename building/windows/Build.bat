@echo off
setlocal enabledelayedexpansion

rem Ensure we're under the right path.
cd /d "%~dp0"
set "CURDIR=%cd%"

rem In case it ends in a backslash.
if "%CURDIR:~-1%"=="\" set "CURDIR=%CURDIR:~0,-1%"
if /i "%CURDIR:~-16%"=="building\windows" (
    cd ..\..
)

rem The file with the build number
if not exist "build" (
    echo|set /p="0">"build"
)

set /p NUM=<"build"
set /a NEW_NUM=NUM+1
echo|set /p="!NEW_NUM!">"build"

echo.
echo ===============================================
echo Building B-!NEW_NUM! for Windows.
echo ===============================================
echo.

shift
call lime %*
if !errorlevel! neq 0 (
    echo Build failed.
    exit /b 1
)