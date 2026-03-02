@echo off
title VRChat Auto Fish - Install Dependencies

echo ============================================
echo   VRChat Auto Fish - Dependency Installer
echo ============================================
echo.

:: Check Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found. Please install Python 3.10+ and check "Add to PATH"
    echo Download: https://www.python.org/downloads/
    pause
    exit /b 1
)

echo [1/3] Python detected:
python --version
echo.

:: Check PyTorch
echo [2/3] Checking GPU...
python -c "import torch; print(f'  PyTorch {torch.__version__}  CUDA: {torch.cuda.is_available()}')" 2>nul
if errorlevel 1 (
    echo   PyTorch not installed, installing now...
    call :install_torch
) else (
    echo   PyTorch already installed
)

echo.
echo [3/3] Installing other dependencies...
pip install -r requirements.txt
echo.

echo ============================================
echo   Done! Run start.bat to launch the app.
echo ============================================
pause
exit /b 0

:install_torch
echo.
echo Checking for NVIDIA GPU (CUDA support)...
nvidia-smi >nul 2>&1
if errorlevel 1 (
    echo   No NVIDIA GPU detected, installing CPU version of PyTorch
    pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu
) else (
    echo   NVIDIA GPU detected, installing CUDA version of PyTorch (GPU acceleration)
    pip install torch torchvision --index-url https://download.pytorch.org/whl/cu128
)
exit /b 0
