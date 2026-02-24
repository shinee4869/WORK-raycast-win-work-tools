# 작업 폴더 고정
Set-Location -Path $PSScriptRoot

Clear-Host
Write-Host ""
Write-Host "============================================"
Write-Host "     Work Tools - Auto Setup"
Write-Host "============================================"
Write-Host ""
Write-Host "The following will be installed:"
Write-Host "  - Node.js"
Write-Host "  - Git"
Write-Host "  - qpdf"
Write-Host "  - Raycast"
Write-Host "  - Work Tools Extension"
Write-Host ""
Write-Host "If UAC prompt appears, click [Yes]."
Write-Host ""
Read-Host "Press Enter to start"

# ─────────────────────────────────────────
# 1. PowerShell Execution Policy
# ─────────────────────────────────────────
Write-Host ""
Write-Host "[1/6] Setting PowerShell execution policy..."
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
Write-Host "      Done."

# ─────────────────────────────────────────
# 2. Node.js
# ─────────────────────────────────────────
Write-Host ""
Write-Host "[2/6] Installing Node.js..."
$nodeInstalled = winget list --id OpenJS.NodeJS.LTS 2>$null
if ($nodeInstalled -match "OpenJS.NodeJS.LTS") {
    Write-Host "      Already installed."
} else {
    winget install OpenJS.NodeJS.LTS --silent --accept-package-agreements --accept-source-agreements
    Write-Host "      Done."
}

# ─────────────────────────────────────────
# 3. Git
# ─────────────────────────────────────────
Write-Host ""
Write-Host "[3/6] Installing Git..."
$gitInstalled = winget list --id Git.Git 2>$null
if ($gitInstalled -match "Git.Git") {
    Write-Host "      Already installed."
} else {
    winget install --id Git.Git -e --silent --accept-package-agreements --accept-source-agreements
    Write-Host "      Done."
}

# ─────────────────────────────────────────
# 4. qpdf
# ─────────────────────────────────────────
Write-Host ""
Write-Host "[4/6] Installing qpdf..."
$qpdfInstalled = winget list --id qpdf.qpdf 2>$null
if ($qpdfInstalled -match "qpdf.qpdf") {
    Write-Host "      Already installed."
} else {
    winget install qpdf.qpdf --silent --accept-package-agreements --accept-source-agreements
    Write-Host "      Done."
}

Write-Host "      Registering qpdf to PATH..."
$qpdfBin = Get-ChildItem "C:\Program Files\" -Filter "bin" -Recurse -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -like "*qpdf*" } |
    Select-Object -First 1 -ExpandProperty FullName

if ($qpdfBin) {
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
    if ($currentPath -notlike "*$qpdfBin*") {
        [Environment]::SetEnvironmentVariable("PATH", $currentPath + ";" + $qpdfBin, "Machine")
        Write-Host "      PATH registered."
    } else {
        Write-Host "      PATH already registered."
    }
} else {
    Write-Host "      qpdf path not found. Please register manually."
}

# ─────────────────────────────────────────
# 5. Raycast
# ─────────────────────────────────────────
Write-Host ""
Write-Host "[5/6] Installing Raycast..."
$raycastInstalled = winget list --id Raycast.Raycast 2>$null
if ($raycastInstalled -match "Raycast.Raycast") {
    Write-Host "      Already installed."
} else {
    winget install Raycast.Raycast --silent --accept-package-agreements --accept-source-agreements
    Write-Host "      Done."
}

# ─────────────────────────────────────────
# 6. npm install
# ─────────────────────────────────────────
Write-Host ""
Write-Host "[6/6] Installing Extension packages..."

# Node PATH 반영
$env:PATH = $env:PATH + ";C:\Program Files\nodejs\"

npm install
npm install axios qs
npm install --save-dev @types/qs

Write-Host "      Done."

# ─────────────────────────────────────────
# 완료
# ─────────────────────────────────────────
Write-Host ""
Write-Host "============================================"
Write-Host "  Setup complete!"
Write-Host "============================================"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. npm run dev will start automatically."
Write-Host "  2. Open Raycast with Alt + Space."
Write-Host "  3. Search for the command you want to use."
Write-Host ""
Read-Host "Press Enter to launch Extension"

npm run dev
