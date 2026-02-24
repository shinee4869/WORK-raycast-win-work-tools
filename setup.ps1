Set-Location -Path $PSScriptRoot

Clear-Host
Write-Host ''
Write-Host '============================================'
Write-Host '       업무보조 Tool - 자동 설치 프로그램'
Write-Host '============================================'
Write-Host ''
Write-Host '아래 항목들을 자동으로 설치합니다:'
Write-Host '  - Node.js'
Write-Host '  - Git'
Write-Host '  - qpdf'
Write-Host '  - Raycast'
Write-Host '  - 업무보조 Tool Extension'
Write-Host ''
Read-Host '설치를 시작하려면 Enter 키를 누르세요'

# 1. Node.js
Write-Host ''
Write-Host '[1/5] Node.js 설치 중...'
if (Get-Command node -ErrorAction SilentlyContinue) {
    Write-Host '      이미 설치되어 있습니다.'
} else {
    winget install OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements
    $env:PATH = [Environment]::GetEnvironmentVariable('PATH', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('PATH', 'User')
    Write-Host '      설치 완료.'
}

# 2. Git
Write-Host ''
Write-Host '[2/5] Git 설치 중...'
if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Host '      이미 설치되어 있습니다.'
} else {
    winget install --id Git.Git -e --accept-package-agreements --accept-source-agreements
    $env:PATH = [Environment]::GetEnvironmentVariable('PATH', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('PATH', 'User')
    Write-Host '      설치 완료.'
}

# 3. qpdf
Write-Host ''
Write-Host '[3/5] qpdf 설치 중...'
if (Get-Command qpdf -ErrorAction SilentlyContinue) {
    Write-Host '      이미 설치되어 있습니다.'
} else {
    winget install qpdf.qpdf --accept-package-agreements --accept-source-agreements
    $env:PATH = [Environment]::GetEnvironmentVariable('PATH', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('PATH', 'User')

    Write-Host '      환경변수 등록 중...'
    $qpdfBin = Get-ChildItem 'C:\Program Files\' -Filter 'bin' -Recurse -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -like '*qpdf*' } |
        Select-Object -First 1 -ExpandProperty FullName

    if ($qpdfBin) {
        $machinePath = [Environment]::GetEnvironmentVariable('PATH', 'Machine')
        if ($machinePath -notlike ('*' + $qpdfBin + '*')) {
            [Environment]::SetEnvironmentVariable('PATH', $machinePath + ';' + $qpdfBin, 'Machine')
            $env:PATH = $env:PATH + ';' + $qpdfBin
            Write-Host ('      환경변수 등록 완료: ' + $qpdfBin)
        } else {
            Write-Host '      환경변수가 이미 등록되어 있습니다.'
        }
    } else {
        Write-Host '      qpdf 경로를 찾지 못했습니다. 수동으로 등록해주세요.'
    }
    Write-Host '      설치 완료.'
}

# 4. Raycast
Write-Host ''
Write-Host '[4/5] Raycast 설치 중...'
$raycastPath = $env:LOCALAPPDATA + '\Raycast\Raycast.exe'
if (Test-Path $raycastPath) {
    Write-Host '      이미 설치되어 있습니다.'
} else {
    winget install Raycast.Raycast --accept-package-agreements --accept-source-agreements
    Write-Host '      설치 완료.'
}

# 5. npm install
Write-Host ''
Write-Host '[5/5] Extension 패키지 설치 중...'
$env:PATH = [Environment]::GetEnvironmentVariable('PATH', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('PATH', 'User') + ';C:\Program Files\nodejs\'
npm install
npm install axios qs
npm install --save-dev @types/qs
Write-Host '      설치 완료.'

# 완료
Write-Host ''
Write-Host '============================================'
Write-Host '         설치가 완료되었습니다!'
Write-Host '============================================'
Write-Host ''
Write-Host '사용 방법:'
Write-Host '  1. 아래 Enter 키를 누르면 Extension이 자동 실행됩니다.'
Write-Host '  2. Raycast 가 실행되면 Alt + Space 로 열어주세요.'
Write-Host '  3. 이후부터는 Raycast 만 실행하면 됩니다.'
Write-Host ''
Read-Host 'Extension을 실행하려면 Enter 키를 누르세요'

npm run dev
