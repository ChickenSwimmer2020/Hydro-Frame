@echo off

echo.
echo ===============================================
echo Running QuikBuild [Debug] for Windows.
echo ===============================================

cd /d "%~dp0"
.\Build.bat test windows -debug