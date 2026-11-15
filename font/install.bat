@echo off
rem Cai tat ca font .otf trong thu muc nay cho user hien tai (khong can quyen admin).
rem Dung:  install.bat
setlocal

set "FONTDIR=%LOCALAPPDATA%\Microsoft\Windows\Fonts"
set "REGKEY=HKCU\Software\Microsoft\Windows NT\CurrentVersion\Fonts"

if not exist "%FONTDIR%" mkdir "%FONTDIR%"

set COUNT=0
for %%F in ("%~dp0*.otf") do (
    copy /y "%%F" "%FONTDIR%\" >nul
    if errorlevel 1 (
        echo   [LOI] %%~nxF
    ) else (
        reg add "%REGKEY%" /v "%%~nF (OpenType)" /t REG_SZ /d "%FONTDIR%\%%~nxF" /f >nul
        echo   [OK] %%~nxF
        set /a COUNT+=1
    )
)

echo Da cai %COUNT% font vao %FONTDIR%
echo Hay khoi dong lai ung dung (VS Code, terminal...) de nhan font.
exit /b 0
