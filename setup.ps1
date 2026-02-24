Set-Location -Path $PSScriptRoot

Clear-Host
Write-Host ''
Write-Host '============================================'
Write-Host '       업무보조 Tool - 자동 설치 프로그램'
Write-Host '============================================'
Write-Host ''
Write-Host '아래 항목들을 자동으로 설치합니다:'
Write-Host '  - Node.js'
Write-Host '  - qpdf'
Write-Host '  - Raycast'
Write-Host '  - 업무보조 Tool Extension 패키지'
Write-Host ''
Read-Host '설치를 시작하려면 Enter 키를 누르세요'

# ─────────────────────────────────────────
# 1. Node.js
# ─────────────────────────────────────────
Write-Host ''
Write-Host '--------------------------------------------'
Write-Host '[1/4] Node.js 설치'
Write-Host '--------------------------------------------'
if (Get-Command node -ErrorAction SilentlyContinue) {
    Write-Host '  ✓ 이미 설치되어 있습니다.' -ForegroundColor Green
} else {
    Write-Host '  → 설치를 시작합니다. 잠시 기다려주세요...'
    winget install OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements
    $env:PATH = [Environment]::GetEnvironmentVariable('PATH', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('PATH', 'User')
    if (Get-Command node -ErrorAction SilentlyContinue) {
        Write-Host '  ✓ 설치가 완료되었습니다.' -ForegroundColor Green
    } else {
        Write-Host '  ✗ 설치에 실패했습니다. 수동으로 설치해주세요: https://nodejs.org' -ForegroundColor Red
    }
}

# ─────────────────────────────────────────
# 2. qpdf
# ─────────────────────────────────────────
Write-Host ''
Write-Host '--------------------------------------------'
Write-Host '[2/4] qpdf 설치'
Write-Host '--------------------------------------------'
if (Get-Command qpdf -ErrorAction SilentlyContinue) {
    Write-Host '  ✓ 이미 설치되어 있습니다.' -ForegroundColor Green
} else {
    Write-Host '  → 설치를 시작합니다. 잠시 기다려주세요...'
    winget install qpdf.qpdf --accept-package-agreements --accept-source-agreements
    $env:PATH = [Environment]::GetEnvironmentVariable('PATH', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('PATH', 'User')

    Write-Host '  → 환경변수 등록 중...'
    $qpdfBin = Get-ChildItem 'C:\Program Files\' -Filter 'bin' -Recurse -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -like '*qpdf*' } |
        Select-Object -First 1 -ExpandProperty FullName

    if ($qpdfBin) {
        $machinePath = [Environment]::GetEnvironmentVariable('PATH', 'Machine')
        if ($machinePath -notlike ('*' + $qpdfBin + '*')) {
            [Environment]::SetEnvironmentVariable('PATH', $machinePath + ';' + $qpdfBin, 'Machine')
            $env:PATH = $env:PATH + ';' + $qpdfBin
        }
        Write-Host ('  ✓ 환경변수 등록 완료: ' + $qpdfBin) -ForegroundColor Green
    } else {
        Write-Host '  ✗ qpdf 경로를 찾지 못했습니다. 수동으로 등록해주세요.' -ForegroundColor Red
    }

    if (Get-Command qpdf -ErrorAction SilentlyContinue) {
        Write-Host '  ✓ 설치가 완료되었습니다.' -ForegroundColor Green
    } else {
        Write-Host '  ✗ 설치에 실패했습니다. 수동으로 설치해주세요: https://github.com/qpdf/qpdf/releases' -ForegroundColor Red
    }
}

# ─────────────────────────────────────────
# 3. Raycast
# ─────────────────────────────────────────
Write-Host ''
Write-Host '--------------------------------------------'
Write-Host '[3/4] Raycast 설치'
Write-Host '--------------------------------------------'
$raycastPath = $env:LOCALAPPDATA + '\Raycast\Raycast.exe'
if (Test-Path $raycastPath) {
    Write-Host '  ✓ 이미 설치되어 있습니다.' -ForegroundColor Green
} else {
    Write-Host '  → 브라우저에서 Raycast 다운로드 페이지를 엽니다...'
    Start-Process 'https://ray.so/download-windows'
    Write-Host ''
    Write-Host '  ※ 브라우저에서 Raycast 를 다운로드하여 설치해주세요.' -ForegroundColor Yellow
    Write-Host '  ※ 설치가 완료되면 아래에서 Enter 키를 눌러 계속 진행하세요.' -ForegroundColor Yellow
    Write-Host ''
    Read-Host '  Raycast 설치 완료 후 Enter 키를 누르세요'

    if (Test-Path $raycastPath) {
        Write-Host '  ✓ Raycast 설치가 확인되었습니다.' -ForegroundColor Green
    } else {
        Write-Host '  △ Raycast 설치를 확인하지 못했습니다. 설치 후 계속 진행합니다.' -ForegroundColor Yellow
    }
}

# ─────────────────────────────────────────
# 4. npm install
# ─────────────────────────────────────────
Write-Host ''
Write-Host '--------------------------------------------'
Write-Host '[4/4] Extension 패키지 설치'
Write-Host '--------------------------------------------'
Write-Host '  → 패키지를 설치합니다. 잠시 기다려주세요...'
$env:PATH = [Environment]::GetEnvironmentVariable('PATH', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('PATH', 'User') + ';C:\Program Files\nodejs\'
npm install
npm install axios qs
npm install --save-dev @types/qs

if ($LASTEXITCODE -eq 0) {
    Write-Host '  ✓ 패키지 설치가 완료되었습니다.' -ForegroundColor Green
} else {
    Write-Host '  ✗ 패키지 설치에 실패했습니다.' -ForegroundColor Red
}

# ─────────────────────────────────────────
# 완료
# ─────────────────────────────────────────
Write-Host ''
Write-Host '============================================'
Write-Host '         설치가 완료되었습니다!'
Write-Host '============================================'
Write-Host ''
Write-Host '사용 방법:'
Write-Host '  1. 아래 Enter 키를 누르면 Extension이 자동 실행됩니다.'
Write-Host '  2. Raycast 를 Alt + Space 로 열어주세요.'
Write-Host '  3. 이후부터는 Raycast 만 실행하면 됩니다.'
Write-Host ''
Read-Host 'Extension을 실행하려면 Enter 키를 누르세요'

npm run dev
