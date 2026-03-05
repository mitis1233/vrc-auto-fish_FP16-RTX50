@echo off
chcp 65001 >nul
echo ===================================================
echo Python 虛擬環境 (venv) 路徑修復工具
echo ===================================================
echo.

set VENV_NAME="venv"

if not exist "%VENV_NAME%\Scripts\activate.bat" (
    echo.
    echo [錯誤] 找不到 %VENV_NAME%\Scripts\activate.bat
    echo 請確認你輸入的名稱正確，且這個 BAT 檔放在與虛擬環境同一個資料夾底下。
    echo.
    pause
    exit /b
)

echo.
echo [處理中] 正在更新 venv 內的路徑與設定檔...
python -m venv --upgrade "%VENV_NAME%"

if %errorlevel% equ 0 (
    echo.
    echo [成功] 你的 venv 已經成功修復並適應當前電腦的路徑！
    echo 請在終端機輸入以下指令啟動： %VENV_NAME%\Scripts\activate
) else (
    echo.
    echo [失敗] 修復發生錯誤。請確認這台電腦已經安裝 Python 並且加入了環境變數 (PATH)。
)

echo.
pause