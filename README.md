# FSS Tecnam P2012 — 3D Web Demo

Interactive glTF viewer for the Tecnam P2012 (Three.js).

**Live demo:** https://janmartenkrull-create.github.io/GLTFWebViewDemo/

## Run locally

```powershell
cd WebViewMockup
.\serve.ps1
```

Open http://localhost:8081/index.html

## Refresh assets

```powershell
cd WebViewMockup
.\build-package.ps1
```

Copies models and liveries from `PackageSources/` in the full MSFS aircraft repo and downscales textures to 1024 px for web delivery.

## Development

Dev viewer under `tools/gltf-viewer/` (port 8080 via `serve.ps1`).
