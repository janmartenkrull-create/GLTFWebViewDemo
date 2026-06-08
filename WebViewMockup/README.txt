FSS Tecnam P2012 - 3D Web Demo (WebView Mockup)

Preview locally:
  1. Open PowerShell in this folder (WebViewMockup)
  2. Run: .\serve.ps1
  3. Open: http://localhost:8081/index.html

Alternative via repo dev server (port 8080):
  http://localhost:8080/WebViewMockup/index.html
  (Do NOT use http://localhost:8080/index.html — that path has no file.)

Refresh assets from the MSFS project:
  .\build-package.ps1
  (copies models/liveries and downscales textures to max 1024px for faster web loading)

Re-optimize textures only (after manual edits):
  python .\optimize-textures.py

To share with Tecnam:
  Zip this entire WebViewMockup folder and send it.
  The recipient can use serve.ps1 the same way (Python required).

Contents:
  index.html          - Three.js web viewer
  PackageSources/     - glTF models, attachments, textures, liveries (FSS, FlexFly, Tecnam US)
