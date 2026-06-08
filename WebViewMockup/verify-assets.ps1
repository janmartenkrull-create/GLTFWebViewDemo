# Fail if PackageSources contains Git LFS pointer files (GitHub Pages cannot serve them).
$ErrorActionPreference = "Stop"
$root = Join-Path $PSScriptRoot "PackageSources"
if (-not (Test-Path $root)) {
    throw "Missing PackageSources folder: $root"
}

$bad = @()
Get-ChildItem $root -Recurse -File | ForEach-Object {
    $head = Get-Content $_.FullName -TotalCount 1 -Encoding utf8 -ErrorAction SilentlyContinue
    if ($head -match '^version https://git-lfs.github.com/spec/v1') {
        $bad += $_.FullName.Substring($PSScriptRoot.Length + 1)
    }
}

if ($bad.Count) {
    Write-Error "Found $($bad.Count) Git LFS pointer file(s) in PackageSources. Run build-package.ps1 and ensure .gitattributes disables LFS."
    $bad | Select-Object -First 10 | ForEach-Object { Write-Host "  $_" }
    exit 1
}

Write-Host "OK: no LFS pointers in PackageSources."
