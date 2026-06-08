# Local HTTP server for the GLTF viewer.
# Run from repo root or from tools/gltf-viewer.

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Resolve-Path (Join-Path $scriptDir "..\..")
$port = 8080

Write-Host "GLTF Viewer - Repo root: $repoRoot"
Write-Host "Open: http://localhost:$port/tools/gltf-viewer/index.html"
Write-Host "Stop with Ctrl+C"
Write-Host ""

Set-Location $repoRoot

if (Get-Command python -ErrorAction SilentlyContinue) {
    python -m http.server $port
} elseif (Get-Command py -ErrorAction SilentlyContinue) {
    py -3 -m http.server $port
} else {
    throw "Python not found. Install Python or run: npx serve ."
}
