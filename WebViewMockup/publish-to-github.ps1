# Rebuild web assets from the MSFS project and push to the GLTFWebViewDemo GitHub repo.
$ErrorActionPreference = "Stop"
$mockupRoot = $PSScriptRoot
$repoRoot = Resolve-Path (Join-Path $mockupRoot "..")

Set-Location $mockupRoot
Write-Host "Building PackageSources..."
& (Join-Path $mockupRoot "build-package.ps1")

Write-Host "Verifying assets..."
& (Join-Path $mockupRoot "verify-assets.ps1")

Set-Location $repoRoot
Copy-Item (Join-Path $mockupRoot "index.html") (Join-Path $repoRoot "tools\gltf-viewer\index.html") -Force

git add WebViewMockup/ tools/gltf-viewer/index.html .gitattributes
$status = git status --short WebViewMockup tools/gltf-viewer/index.html .gitattributes
if (-not $status) {
    Write-Host "Nothing to commit — GitHub repo already matches local PackageSources."
} else {
    git commit -m "Sync web demo assets and viewer with local PackageSources build."
}

git push github github-main:main
Write-Host "Done. GitHub Pages will update in 1–2 minutes."
