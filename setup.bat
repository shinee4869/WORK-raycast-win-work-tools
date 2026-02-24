@echo off
chcp 65001 > nul
title Unlock PDF — 자동 설치

echo.
echo ╔══════════════════════════════════════╗
echo ║     Unlock PDF 자동 설치 프로그램     ║
echo ╚══════════════════════════════════════╝
echo.
echo 이 프로그램은 아래 항목을 자동으로 설치합니다.
echo  - Node.js
echo  - Git
echo  - qpdf
echo  - Raycast
echo  - Unlock PDF Extension
echo.
echo 설치 중 UAC(관리자 권한) 창이 뜨면 [예] 를 눌러주세요.
echo.
pause

:: ─────────────────────────────────────────
:: 관리자 권한 확인 및 재실행
:: ─────────────────────────────────────────
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo 관리자 권한이 필요합니다. 자동으로 재실행합니다...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: ─────────────────────────────────────────
:: PowerShell 실행 정책 설정
:: ─────────────────────────────────────────
echo [1/6] PowerShell 실행 정책 설정 중...
powershell -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force"
echo       완료 ✓
echo.

:: ─────────────────────────────────────────
:: Node.js 설치
:: ─────────────────────────────────────────
echo [2/6] Node.js 설치 중...
where node >nul 2>&1
if %errorLevel% == 0 (
    echo       이미 설치되어 있습니다 ✓
) else (
    winget install OpenJS.NodeJS.LTS --silent --accept-package-agreements --accept-source-agreements
    echo       완료 ✓
)
echo.

:: ─────────────────────────────────────────
:: Git 설치
:: ─────────────────────────────────────────
echo [3/6] Git 설치 중...
where git >nul 2>&1
if %errorLevel% == 0 (
    echo       이미 설치되어 있습니다 ✓
) else (
    winget install --id Git.Git -e --silent --accept-package-agreements --accept-source-agreements
    echo       완료 ✓
)
echo.

:: ─────────────────────────────────────────
:: qpdf 설치
:: ─────────────────────────────────────────
echo [4/6] qpdf 설치 중...
where qpdf >nul 2>&1
if %errorLevel% == 0 (
    echo       이미 설치되어 있습니다 ✓
) else (
    winget install qpdf.qpdf --silent --accept-package-agreements --accept-source-agreements

    :: qpdf 환경변수 자동 등록
    echo       환경변수 등록 중...
    powershell -Command ^
        "$qpdfBin = Get-ChildItem 'C:\Program Files\' -Filter 'bin' -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.FullName -like '*qpdf*' } | Select-Object -First 1 -ExpandProperty FullName;" ^
        "if ($qpdfBin) {" ^
        "    $path = [Environment]::GetEnvironmentVariable('PATH', 'Machine');" ^
        "    if ($path -notlike \"*$qpdfBin*\") {" ^
        "        [Environment]::SetEnvironmentVariable('PATH', $path + ';' + $qpdfBin, 'Machine');" ^
        "        Write-Host '      환경변수 등록 완료 ✓';" ^
        "    } else {" ^
        "        Write-Host '      환경변수 이미 등록되어 있습니다 ✓';" ^
        "    }" ^
        "} else {" ^
        "    Write-Host '      qpdf 경로를 찾지 못했습니다. 수동으로 등록해주세요.';" ^
        "}"
    echo       완료 ✓
)
echo.

:: ─────────────────────────────────────────
:: Raycast 설치
:: ─────────────────────────────────────────
echo [5/6] Raycast 설치 중...
winget list --id Raycast.Raycast >nul 2>&1
if %errorLevel% == 0 (
    echo       이미 설치되어 있습니다 ✓
) else (
    winget install Raycast.Raycast --silent --accept-package-agreements --accept-source-agreements
    echo       완료 ✓
)
echo.

:: ─────────────────────────────────────────
:: Extension 패키지 설치 및 실행
:: ─────────────────────────────────────────
echo [6/6] Unlock PDF Extension 설치 중...

:: PATH 새로고침
call RefreshEnv.cmd >nul 2>&1
set "PATH=%PATH%;C:\Program Files\nodejs\"

cd /d "%~dp0"
call npm install
echo       완료 ✓
echo.

:: ─────────────────────────────────────────
:: 완료
:: ─────────────────────────────────────────
echo.
echo ╔══════════════════════════════════════╗
echo ║          설치가 완료되었습니다 🎉      ║
echo ╚══════════════════════════════════════╝
echo.
echo 아래 순서로 Extension을 실행하세요.
echo.
echo  1. 이 창을 닫지 말고 아래 명령이 자동 실행됩니다.
echo  2. Raycast 가 실행되면 "Unlock PDF" 를 검색하세요.
echo  3. 이후부터는 Raycast 만 실행하면 됩니다.
echo.
pause

:: Extension 개발 모드 실행
call npm run dev
