@echo off
setlocal enabledelayedexpansion
title VRChat Auto Fish - Launch
cd /d "%~dp0"

:: ============================================
::  Check Virtual Environment
:: ============================================
set VENV_DIR=%~dp0venv
set PYTHON_EXE="%VENV_DIR%\Scripts\python.exe"

if not exist %PYTHON_EXE% (
    echo [ERROR] Virtual environment not found.
    echo Please run setup_and_run.bat first to create the environment.
    pause
    exit /b 1
)

:: ============================================
::  Launch Project
:: ============================================
echo ============================================
echo   Launching VRChat Auto Fish...
echo ============================================
echo.
%PYTHON_EXE% main.py
if errorlevel 1 pause

endlocal
exit /b 0
