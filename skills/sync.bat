@echo off
rem Dong bo skill vao thu muc global cua Claude (mac dinh) hoac Codex.
rem Dung:  sync.bat [claude|codex] [thu_muc_dich]
setlocal

set "TARGET=%~1"
if "%TARGET%"=="" set "TARGET=claude"

if /i "%TARGET%"=="claude" (
    set "DEST=%USERPROFILE%\.claude\skills"
) else if /i "%TARGET%"=="codex" (
    set "DEST=%USERPROFILE%\.codex\skills"
) else (
    echo Target khong hop le: %TARGET%  ^(chon claude hoac codex^)
    exit /b 1
)
if not "%~2"=="" set "DEST=%~2"

echo Target: %TARGET%
echo Dich  : %DEST%

for /d %%D in ("%~dp0*") do if exist "%%D\SKILL.md" call :sync "%%D" "%%~nxD" || exit /b 1
echo Xong.
exit /b 0

:sync
robocopy %1 "%DEST%\%~2" /MIR /NFL /NDL /NJH /NJS /NP >nul
if errorlevel 8 (
    echo   [LOI] %~2
    exit /b 1
)
echo   [OK] %~2
exit /b 0
