# Refreshes WebViewMockup assets from the MSFS PackageSources tree.
# Run from repo root or from WebViewMockup.

$ErrorActionPreference = "Stop"
$mockupRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Resolve-Path (Join-Path $mockupRoot "..")
$srcRoot = Join-Path $repoRoot "PackageSources\SimObjects\Airplanes\FSS_Tecnam_P2012"
$dstRoot = Join-Path $mockupRoot "PackageSources\SimObjects\Airplanes\FSS_Tecnam_P2012"

if (-not (Test-Path $srcRoot)) {
    throw "Source aircraft folder not found: $srcRoot"
}

Write-Host "Building WebViewMockup package..."
Write-Host "Source: $srcRoot"
Write-Host "Target: $dstRoot"

function Copy-Tree($relativePath) {
    $from = Join-Path $srcRoot $relativePath
    $to = Join-Path $dstRoot $relativePath
    if (-not (Test-Path $from)) {
        Write-Warning "Missing source path: $from"
        return
    }
    New-Item -ItemType Directory -Force -Path (Split-Path $to -Parent) | Out-Null
    if (Test-Path $to) { Remove-Item $to -Recurse -Force }
    Copy-Item $from $to -Recurse -Force
    Write-Host "Copied $relativePath"
}

Copy-Tree "common\texture"
Copy-Tree "common\model"

$attachmentParts = @(
    "part_back_door",
    "part_front_baggage",
    "part_airline",
    "part_cabin",
    "part_back_baggage",
    "part_cargo",
    "part_combi",
    "part_vip",
    "part_smp",
    "part_skydive",
    "part_medevac",
    "part_medevac_single"
)

foreach ($part in $attachmentParts) {
    Copy-Tree ("attachments\fss\{0}\model" -f $part)
}

$liveries = @("fss", "flexfly", "tecnamus")
foreach ($livery in $liveries) {
    Copy-Tree ("liveries\fss\{0}" -f $livery)
}

Write-Host ""
Write-Host "Optimizing textures for web preview (max 1024px)..."
$optimizeScript = Join-Path $mockupRoot "optimize-textures.py"
if (-not (Test-Path $optimizeScript)) {
    throw "Missing optimize-textures.py: $optimizeScript"
}

python $optimizeScript $dstRoot 1024
if ($LASTEXITCODE -ne 0) {
    throw "Texture optimization failed with exit code $LASTEXITCODE"
}

Write-Host ""
Write-Host "Done. Preview with: .\serve.ps1"
