@echo off
title Work Tools - Auto Setup

:: 式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
:: Check Admin Privileges
:: 式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c cd /d ""%~dp0"" && ""%~f0""' -Verb RunAs"
    exit /b
)

cd /d "%~dp0"

cls
echo.
echo ============================================
echo      Work Tools - Auto Setup
echo ============================================
echo.
echo The following will be installed:
echo  - Node.js
echo  - Git
echo  - qpdf
echo  - Raycast
echo  - Work Tools Extension
echo.
echo If UAC prompt appears, click [Yes].
echo.
pause

:: 式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
:: PowerShell Execution Policy
:: 式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
echo.
echo [1/6] Setting PowerShell execution policy...
powershell -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force"
echo       Done.

:: 式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
:: Node.js
:: 式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
echo.
echo [2/6] Installing Node.js...
winget list --id OpenJS.NodeJS.LTS >nul 2>&1
if %errorLevel% == 0 (
    echo       Already installed.
) else (
    winget install OpenJS.NodeJS.LTS --silent --accept-package-agreements --accept-source-agreements
    echo       Done.
)

:: 式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
:: Git
:: 式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
echo.
echo [3/6] Installing Git...
winget list --id Git.Git >nul 2>&1
if %errorLevel% == 0 (
    echo       Already installed.
) else (
    winget install --id Git.Git -e --silent --accept-package-agreements --accept-source-agreements
    echo       Done.
)

:: 式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
:: qpdf
:: 式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
echo.
echo [4/6] Installing qpdf...
winget list --id qpdf.qpdf >nul 2>&1
if %errorLevel% == 0 (
    echo       Already installed.
) else (
    winget install qpdf.qpdf --silent --accept-package-agreements --accept-source-agreements
    echo       Done.
)

echo       Registering qpdf to PATH...
powershell -Command "$qpdfBin = Get-ChildItem 'C:\Program Files\' -Filter 'bin' -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.FullName -like '*qpdf*' } | Select-Object -First 1 -ExpandProperty FullName; if ($qpdfBin) { $path = [Environment]::GetEnvironmentVariable('PATH', 'Machine'); if ($path -notlike ('*' + $qpdfBin + '*')) { [Environment]::SetEnvironmentVariable('PATH', $path + ';' + $qpdfBin, 'Machine'); Write-Host 'PATH registered.'; } else { Write-Host 'PATH already registered.'; } } else { Write-Host 'qpdf path not found.'; }"

:: 式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
:: Raycast
:: 式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
echo.
echo [5/6] Installing Raycast...
winget list --id Raycast.Raycast >nul 2>&1
if %errorLevel% == 0 (
    echo       Already installed.
) else (
    winget install Raycast.Raycast --silent --accept-package-agreements --accept-source-agreements
    echo       Done.
)

:: 式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
:: npm install
:: 式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
echo.
echo [6/6] Installing Extension packages...
set "PATH=%PATH%;C:\Program Files\nodejs\"
call npm install
echo       Done.

:: 式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
:: Complete
:: 式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式式
echo.
echo ============================================
echo   Setup complete!
echo ============================================
echo.
echo Next steps:
echo  1. npm run dev will start automatically.
echo  2. Open Raycast with Alt + Space.
echo  3. Search for the command you want to use.
echo.
pause

call npm run dev
