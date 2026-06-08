# FSS Tecnam P2012 — 3D Web Demo

Interaktiver glTF-Viewer für das Tecnam P2012 (Three.js).

**Live-Demo:** https://janmartenkrull-create.github.io/GLTFWebViewDemo/

## Lokal starten

```powershell
cd WebViewMockup
.\serve.ps1
```

Browser: http://localhost:8081/index.html

## Assets

Dieses Repo enthält **nur web-optimierte Assets** (~115 MB, Texturen max. 1024 px) unter `WebViewMockup/PackageSources/`.

Zum Aktualisieren aus dem vollen MSFS-Projekt lokal `build-package.ps1` ausführen (benötigt `PackageSources/` im übergeordneten Aircraft-Repo).

## Entwicklung

Dev-Viewer unter `tools/gltf-viewer/` (Port 8080 via `serve.ps1`).
