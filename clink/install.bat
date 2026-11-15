@echo off
rem Cai Clink (ban moi nhat tu GitHub, neu may chua co) va ap dung config (clink_settings) trong thu muc nay.
rem Dung:  install.bat
rem (File nay chay doan PowerShell nam sau dong danh dau o cuoi file.)
powershell -NoProfile -ExecutionPolicy Bypass -Command "$s=[IO.File]::ReadAllText('%~f0'); $i=$s.IndexOf('#'+'PS#'); $env:SRC='%~dp0'; Invoke-Expression $s.Substring($i)"
if errorlevel 1 ( echo [LOI] Cai dat that bai. & exit /b 1 )
exit /b 0
#PS#
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ProgressPreference = 'SilentlyContinue'

$src     = $env:SRC.TrimEnd('\')
$appRoot = Join-Path $env:LOCALAPPDATA 'clink-app'
$profile = Join-Path $env:LOCALAPPDATA 'clink'

# 1+2. Cai Clink neu chua co. Viec cap nhat sau nay do Clink tu lo (clink.autoupdate).
Write-Host '[1/2] Kiem tra Clink...'
$found = @(
    (Join-Path ${env:ProgramFiles(x86)} 'clink\clink_x64.exe'),
    (Join-Path $env:ProgramFiles 'clink\clink_x64.exe')
) + @(Get-ChildItem $appRoot -Directory -ErrorAction SilentlyContinue | ForEach-Object { Join-Path $_.FullName 'clink_x64.exe' }) |
    Where-Object { Test-Path $_ } | Select-Object -First 1

if ($found) {
    Write-Host "      Da co Clink: $found (bo qua tai)"
} else {
    $rel   = Invoke-RestMethod 'https://api.github.com/repos/chrisant996/clink/releases/latest' -Headers @{ 'User-Agent' = 'clink-installer' }
    $asset = $rel.assets | Where-Object { $_.name -match '^clink\.[\d.]+\.[0-9a-f]+\.zip$' } | Select-Object -First 1
    if (-not $asset) { throw 'Khong tim thay file zip trong ban phat hanh moi nhat.' }
    $dest = Join-Path $appRoot $asset.name.Replace('.zip', '')
    Write-Host "      Tai $($asset.name)..."
    $zip = Join-Path $env:TEMP $asset.name
    Invoke-WebRequest $asset.browser_download_url -OutFile $zip
    New-Item -ItemType Directory -Path $dest -Force | Out-Null
    Expand-Archive $zip -DestinationPath $dest -Force
    Remove-Item $zip -Force
    $exe = Join-Path $dest 'clink_x64.exe'
    if (-not (Test-Path $exe)) { throw "Khong thay $exe" }
    & $exe autorun install | Out-Null
    Write-Host "      Da cai $($rel.tag_name) vao $dest"
}

# 2. Ap dung config
Write-Host '[2/2] Ap dung config...'
$cfg = Join-Path $src 'clink_settings'
if (-not (Test-Path $cfg)) { throw "Khong thay $cfg" }
New-Item -ItemType Directory -Path $profile -Force | Out-Null
$target = Join-Path $profile 'clink_settings'
if (Test-Path $target) { Copy-Item $target "$target.bak" -Force; Write-Host '      Da sao luu config cu -> clink_settings.bak' }
Copy-Item $cfg $target -Force

Write-Host 'Xong. Mo cua so cmd moi de dung Clink.'
