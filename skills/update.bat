@echo off
rem Cap nhat cac skill tu repo goc (khai bao trong sources.txt).
rem Dung:  update.bat                 chi cap nhat thu muc nay
rem        update.bat sync            cap nhat + dong bo vao Claude global
rem        update.bat sync codex      cap nhat + dong bo vao Codex global
rem (File nay chay doan PowerShell nam sau dong danh dau o cuoi file.)
setlocal
powershell -NoProfile -ExecutionPolicy Bypass -Command "$s=[IO.File]::ReadAllText('%~f0'); $i=$s.LastIndexOf('#'+'PS#'); $env:SRC='%~dp0'; Invoke-Expression $s.Substring($i)"
if errorlevel 1 ( echo [LOI] Cap nhat that bai. & exit /b 1 )
if /i "%~1"=="sync" call "%~dp0sync.bat" %2
exit /b %errorlevel%
#PS#
$ErrorActionPreference = 'Stop'
$src = $env:SRC.TrimEnd('\')
function Get-TreeHash($dir) {
    $root = (Resolve-Path $dir).Path.TrimEnd('\')
    (Get-ChildItem $root -Recurse -File -Force | Where-Object { $_.FullName -notmatch '\\\.git\\' } | Sort-Object FullName | ForEach-Object {
        $_.FullName.Substring($root.Length) + ':' + (Get-FileHash $_.FullName -Algorithm SHA256).Hash
    }) -join "`n"
}
$tmp = Join-Path $env:TEMP ('skills-update-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $tmp | Out-Null

try {
    $rows = Get-Content (Join-Path $src 'sources.txt') | Where-Object { $_ -and $_ -notmatch '^\s*#' } | ForEach-Object {
        $p = $_ -split '\s+'
        if ($p.Count -ne 3) { throw "Dong sai dinh dang trong sources.txt: $_" }
        [pscustomobject]@{ Name = $p[0]; Repo = $p[1]; Path = $p[2] }
    }

    # Moi repo chi tai dung cac thu muc skill can (sparse checkout, khong tai blob khac)
    # nen repo lon (anh, site...) van nhanh.
    # Neu commit moi nhat cua repo trung voi lan cap nhat truoc (luu trong .update-state.json)
    # va cac thu muc skill van con, bo qua han viec tai. Xoa file state de ep tai lai.
    $stateFile = Join-Path $src '.update-state.json'
    $state = @{}
    if (Test-Path $stateFile) { (Get-Content $stateFile -Raw | ConvertFrom-Json).PSObject.Properties | ForEach-Object { $state[$_.Name] = $_.Value } }
    $newState = @{}

    $clones = @{}
    foreach ($g in ($rows | Group-Object Repo)) {
        $sha = ((git ls-remote $g.Name HEAD 2>$null) -split '\s+')[0]
        if ($LASTEXITCODE -ne 0 -or -not $sha) { throw "Khong truy cap duoc $($g.Name)" }
        $newState[$g.Name] = $sha
        $present = -not ($g.Group | Where-Object { -not (Test-Path (Join-Path $src "$($_.Name)\SKILL.md")) })
        if ($present -and $state[$g.Name] -eq $sha) { Write-Host "Khong doi: $($g.Name)"; continue }

        $dir = Join-Path $tmp ('r' + $clones.Count)
        Write-Host "Tai $($g.Name)"
        git clone --quiet --depth 1 --filter=blob:none --sparse $g.Name $dir 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) { throw "Khong clone duoc $($g.Name)" }
        git -C $dir sparse-checkout set @($g.Group.Path) 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) { throw "sparse-checkout loi o $($g.Name)" }
        $clones[$g.Name] = $dir
    }

    $n = 0
    foreach ($r in $rows) {
        if (-not $clones.ContainsKey($r.Repo)) { continue }
        $from = Join-Path $clones[$r.Repo] $r.Path
        if (-not (Test-Path (Join-Path $from 'SKILL.md'))) { Write-Host "  [BO QUA] $($r.Name): khong thay SKILL.md o $($r.Path)"; continue }

        $to = Join-Path $src $r.Name
        if ((Test-Path $to) -and ((Get-TreeHash $from) -eq (Get-TreeHash $to))) { Write-Host "  [giu nguyen] $($r.Name)"; continue }
        robocopy $from $to /MIR /NJH /NJS /NP /NDL /NFL /XD .git | Out-Null
        if ($LASTEXITCODE -ge 8) { throw "robocopy loi o $($r.Name)" }
        Write-Host "  [CAP NHAT]   $($r.Name)"; $n++
    }
    $newState | ConvertTo-Json | Set-Content $stateFile -Encoding UTF8
    Write-Host "Xong: $n skill co thay doi."
}
finally {
    Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
    $global:LASTEXITCODE = 0
}
