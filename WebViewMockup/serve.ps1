# Local preview server for the Tecnam WebView mockup.
# Run from this folder, then open http://localhost:8081/index.html
#
# Note: Port 8080 is used by tools/gltf-viewer/serve.ps1 (repo root).
# This mockup server uses 8081 so both can run side by side.

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$port = if ($env:WEBVIEW_PORT) { [int]$env:WEBVIEW_PORT } else { 8081 }

Write-Host "WebView Mockup - root: $root"
Write-Host "Open: http://localhost:$port/index.html"
Write-Host ""
Write-Host "If you see a 404 on port 8080, that is the dev viewer (repo root)."
Write-Host "Use this mockup URL instead, or run serve.ps1 from WebViewMockup."
Write-Host "Stop with Ctrl+C"
Write-Host ""

Set-Location $root

if (Get-Command python -ErrorAction SilentlyContinue) {
    python -m http.server $port
} elseif (Get-Command py -ErrorAction SilentlyContinue) {
    py -3 -m http.server $port
} else {
    throw "Python not found. Install Python or run: npx serve ."
}
