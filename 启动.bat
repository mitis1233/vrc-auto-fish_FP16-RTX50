@echo off
chcp 65001 >nul 2>&1
title VRChat ��������
cd /d "%~dp0"

:: ============================================
::  ��� Python
:: ============================================
python --version >nul 2>&1
if errorlevel 1 (
    echo ============================================
    echo   [����] δ�ҵ� Python
    echo   �밲װ Python 3.10+ ����ѡ "Add to PATH"
    echo   ����: https://www.python.org/downloads/
    echo ============================================
    pause
    exit /b 1
)

:: ============================================
::  ��������Ƿ��Ѱ�װ
:: ============================================
python -c "import cv2, keyboard, torch, ultralytics" 2>nul
if errorlevel 1 (
    echo ============================================
    echo   �״����У����ڰ�װ����...
    echo   (����һ�Σ������ĵȴ�)
    echo ============================================
    echo.
    call :install_deps
    if errorlevel 1 (
        echo [����] ��װʧ�ܣ������������Ӻ�����
        pause
        exit /b 1
    )
    echo.
    echo ============================================
    echo   ������װ��ɣ���������...
    echo ============================================
    echo.
)

:: ============================================
::  ��������
:: ============================================
python main.py
if errorlevel 1 pause
exit /b 0

:: ============================================
::  ��װ�����ӹ���
:: ============================================
:install_deps
echo.
echo [1/2] ��װ PyTorch...
call :install_torch

echo.
echo [2/2] ��װ��������...
pip install -r requirements.txt
if errorlevel 1 exit /b 1
exit /b 0

:install_torch
nvidia-smi >nul 2>&1
if errorlevel 1 (
    echo   δ��⵽ NVIDIA GPU����װ CPU �� PyTorch
    pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu
) else (
    echo   ��⵽ NVIDIA GPU����װ CUDA �� PyTorch (GPU ����)
    pip install torch torchvision --index-url https://download.pytorch.org/whl/cu128
)
exit /b 0