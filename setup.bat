@echo off
chcp 65001 > nul
title Unlock PDF — 자동 설치

:: ─────────────────────────────────────────
:: 관리자 권한 확인 및 재실행
:: ─────────────────────────────────────────
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo 관리자 권한으로 재실행합니다...
    powershell -Command "Start-Process cmd -ArgumentList '/c cd /d ""%~dp0"" && ""%~f0""' -Verb RunAs"
    exit /b
)

:: 배치 파일 위치로 이동
cd /d "%~dp0"

cls
echo.
echo ╔══════════════════════════════════════╗
echo ║      업무보조 Tool 자동 설치 프로그램  ║
echo ╚══════════════════════════════════════╝
echo.
echo 이 프로그램은 아래 항목을 자동으로 설치합니다.
echo  - Node.js
echo  - Git
echo  - qpdf
echo  - Raycast
echo  - 업무보조 Tool Extension
echo.
pause

:: ─────────────────────────────────────────
:: PowerShell 실행 정책 설정
:: ─────────────────────────────────────────
echo.
echo [1/6] PowerShell 실행 정책 설정 중...
powershell -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force"
echo       완료 ✓

:: ─────────────────────────────────────────
:: Node.js 설치
:: ─────────────────────────────────────────
echo.
echo [2/6] Node.js 설치 중...
winget list --id OpenJS.NodeJS.LTS >nul 2>&1
if %errorLevel% == 0 (
    echo       이미 설치되어 있습니다 ✓
) else (
    winget install OpenJS.NodeJS.LTS --silent --accept-package-agreements --accept-source-agreements
    echo       완료 ✓
)

:: ─────────────────────────────────────────
:: Git 설치
:: ─────────────────────────────────────────
echo.
echo [3/6] Git 설치 중...
winget list --id Git.Git >nul 2>&1
if %errorLevel% == 0 (
    echo       이미 설치되어 있습니다 ✓
) else (
    winget install --id Git.Git -e --silent --accept-package-agreements --accept-source-agreements
    echo       완료 ✓
)

:: ─────────────────────────────────────────
:: qpdf 설치
:: ─────────────────────────────────────────
echo.
echo [4/6] qpdf 설치 중...
winget list --id qpdf.qpdf >nul 2>&1
if %errorLevel% == 0 (
    echo       이미 설치되어 있습니다 ✓
) else (
    winget install qpdf.qpdf --silent --accept-package-agreements --accept-source-agreements
    echo       완료 ✓
)

:: qpdf 환경변수 자동 등록
echo       qpdf 환경변수 등록 중...
powershell -Command "$qpdfBin = Get-ChildItem 'C:\Program Files\' -Filter 'bin' -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.FullName -like '*qpdf*' } | Select-Object -First 1 -ExpandProperty FullName; if ($qpdfBin) { $path = [Environment]::GetEnvironmentVariable('PATH', 'Machine'); if ($path -notlike ('*' + $qpdfBin + '*')) { [Environment]::SetEnvironmentVariable('PATH', $path + ';' + $qpdfBin, 'Machine'); Write-Host '      환경변수 등록 완료'; } else { Write-Host '      환경변수 이미 등록되어 있습니다'; } } else { Write-Host '      qpdf 경로를 찾지 못했습니다'; }"
echo       완료 ✓

:: ─────────────────────────────────────────
:: Raycast 설치
:: ─────────────────────────────────────────
echo.
echo [5/6] Raycast 설치 중...
winget list --id Raycast.Raycast >nul 2>&1
if %errorLevel% == 0 (
    echo       이미 설치되어 있습니다 ✓
) else (
    winget install Raycast.Raycast --silent --accept-package-agreements --accept-source-agreements
    echo       완료 ✓
)

:: ─────────────────────────────────────────
:: Node PATH 수동 반영
:: ─────────────────────────────────────────
set "PATH=%PATH%;C:\Program Files\nodejs\"

:: ─────────────────────────────────────────
:: Extension 패키지 설치
:: ─────────────────────────────────────────
echo.
echo [6/6] Extension 패키지 설치 중...
call npm install
echo       완료 ✓

:: ─────────────────────────────────────────
:: 완료
:: ─────────────────────────────────────────
echo.
echo ╔══════════════════════════════════════╗
echo ║         설치가 완료되었습니다 🎉       ║
echo ╚══════════════════════════════════════╝
echo.
echo 아래 순서로 Extension을 실행하세요.
echo.
echo  1. 아래 명령이 자동으로 실행됩니다.
echo  2. Raycast 가 실행되면 커맨드를 검색하세요.
echo  3. 이후부터는 Raycast 만 실행하면 됩니다.
echo     (기본 단축키: Alt + Space)
echo.
pause

:: ─────────────────────────────────────────
:: Extension 실행
:: ─────────────────────────────────────────
call npm run dev
