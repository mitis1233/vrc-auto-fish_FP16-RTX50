@echo off
setlocal enabledelayedexpansion
title VRChat Auto Fish - Virtual Env Setup
cd /d "%~dp0"

:: ============================================
::  Check Python
:: ============================================
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found. Please install Python 3.10+ and check "Add to PATH"
    pause
    exit /b 1
)

:: ============================================
::  Create Virtual Environment
:: ============================================
set VENV_DIR=%~dp0venv
if not exist "%VENV_DIR%" (
    echo Creating virtual environment in %VENV_DIR%...
    python -m venv venv
    if errorlevel 1 (
        echo [ERROR] Failed to create virtual environment.
        pause
        exit /b 1
    )
    echo Virtual environment created.
) else (
    echo Virtual environment already exists.
)

:: ============================================
::  Activate Virtual Environment
:: ============================================
set PYTHON_EXE="%VENV_DIR%\Scripts\python.exe"
set PIP_EXE="%VENV_DIR%\Scripts\pip.exe"

if not exist %PYTHON_EXE% (
    echo [ERROR] Virtual environment structure is invalid.
    pause
    exit /b 1
)

echo Updating pip...
%PYTHON_EXE% -m pip install --upgrade pip

:: ============================================
::  Install PyTorch (GPU/CPU)
:: ============================================
echo.
echo Checking for NVIDIA GPU [CUDA support]...

:: Simple GPU detection
nvidia-smi >nul 2>&1
if errorlevel 1 (
    echo No NVIDIA GPU detected, installing CPU version of PyTorch...
    %PIP_EXE% install --pre torch torchvision --index-url https://download.pytorch.org/whl/nightly/cpu
) else (
    echo NVIDIA GPU detected, installing CUDA version of PyTorch [GPU acceleration]...
    %PIP_EXE% install --pre torch torchvision --index-url https://download.pytorch.org/whl/nightly/cu130
)

:: ============================================
::  Install other dependencies
:: ============================================
echo.
echo Installing dependencies from requirements.txt...
%PIP_EXE% install -r requirements.txt
if errorlevel 1 (
    echo [ERROR] Dependency installation failed.
    pause
    exit /b 1
)

:: ============================================
::  Launch Project
:: ============================================
echo.
echo ============================================
echo   Setup Complete! Launching VRChat Auto Fish...
echo ============================================
echo.
%PYTHON_EXE% main.py
if errorlevel 1 pause

endlocal
exit /b 0