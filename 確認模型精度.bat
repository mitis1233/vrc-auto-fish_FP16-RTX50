@echo off
setlocal enabledelayedexpansion
title VRChat Auto Fish - Verify FP16
cd /d "%~dp0"

:: ============================================
::  Check Virtual Environment
:: ============================================
set VENV_DIR=%~dp0venv
set PYTHON_EXE="%VENV_DIR%\Scripts\python.exe"

if not exist %PYTHON_EXE% (
    echo [ERROR] Virtual environment not found.
    echo Please run setup_and_run.bat first.
    pause
    exit /b 1
)

:: ============================================
::  Run Verification Script
:: ============================================
echo ============================================
echo   Checking YOLO Model Precision (FP16)...
echo ============================================
echo.

%PYTHON_EXE% verify_fp16.py

echo.
echo 按任意鍵退出...
pause > nul

endlocal
exit /b 0
