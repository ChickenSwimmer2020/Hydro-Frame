@echo off
setlocal enabledelayedexpansion

echo.
echo ===============================================
echo Setting up building for Windows.
echo ===============================================
echo.

rem See if Haxe is installed.
where haxe >nul 2>&1
if %errorlevel% neq 0 (
    echo Haxe is not installed. Installing haxe via winget.

    set "STEP=Installing Haxe via winget"
    winget install --id HaxeFoundation.Haxe -e

    rem Just in case of error.
    if %errorlevel% neq 0 goto :error

    rem To referesh PATH, just in case.
    set "STEP=Refreshing PATH"
    for /f "skip=2 tokens=3*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH') do set "SYS_PATH=%%A"
    for /f "skip=2 tokens=3*" %%A in ('reg query "HKCU\Environment" /v PATH 2^>nul') do set "USER_PATH=%%A"
    set "PATH=%SYS_PATH%;%USER_PATH%"

    rem Now we can set up haxelib.
    set "STEP=Running haxelib setup"
    call haxelib setup
    if %errorlevel% neq 0 goto :error
    echo.
)

for /f "delims=" %%v in ('haxe --version') do set HAXE_VERSION=%%v
echo ===============================================
echo Haxe !HAXE_VERSION! is installed. Setting up HMM.
echo ===============================================
echo.

set "STEP=Installing HMM (haxelib install hmm)"
call haxelib --global install hmm
if %errorlevel% neq 0 goto :error

set "STEP=Running hmm setup"
call haxelib --global run hmm setup
if %errorlevel% neq 0 goto :error
echo.
echo ===============================================
echo HMM is installed. Setting up libraries.
echo ===============================================
echo.

set "STEP=Running hmm install"
call hmm install
if %errorlevel% neq 0 goto :error
echo.
echo ===============================================
echo Libraries installed. Running HXCPP setup.
echo ===============================================
echo.

set "STEP=Running hxcpp setup"
pushd ".haxelib\hxcpp\git\tools\hxcpp"
call haxe compile.hxml
popd
if %errorlevel% neq 0 goto :error
echo ===============================================
echo HXCPP has been setup. Running Lime setup.
echo ===============================================
echo.


set "STEP=Running lime setup"
call haxelib run lime setup
if %errorlevel% neq 0 goto :error
echo ===============================================
echo Lime has been setup. Locking HMM.
echo ===============================================
echo.

set "STEP=Running hmm lock"
call hmm lock
if %errorlevel% neq 0 goto :error
echo.
echo ===============================================
echo Setup is complete.
echo ===============================================
goto :eof

:error
echo ===============================================
echo Setup failed during step: !STEP!
echo See the error output above for details.
echo ===============================================
exit /b 1