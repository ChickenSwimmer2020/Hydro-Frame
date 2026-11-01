@echo off
setlocal enabledelayedexpansion

echo.
echo ===============================================
echo Running complete Windows setup.
echo ===============================================

set "BUILD_STEP=Setup"
call .\building\windows\Setup.bat
if %errorlevel% neq 0 goto :error

set "BUILD_STEP=Building"
call .\building\windows\QuikBuild.bat
if %errorlevel% neq 0 goto :error

:error
echo.
echo !BUILD_STEP! failed.
exit /b 1