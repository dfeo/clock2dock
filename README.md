# clock2dock

Reloj digital minimalista para el Dock de macOS. Dibuja la hora actual (formato 24h `HH:mm`) directamente sobre el icono de la app en el Dock, actualizándolo cada segundo. Sin ventana, sin dependencias, nativo Swift + AppKit.

![dock icon](https://img.shields.io/badge/platform-macOS%2011%2B-blue)

## Características

- **Mínimo**: un solo archivo Swift, sin frameworks de terceros, sin Electron/Python.
- **Ligero**: ~0% CPU (solo redibuja cuando el minuto cambia).
- **Sin ventana**: la app vive solo en el Dock; se cierra con `pkill clock2dock`.
- **Personalizable**: color de fondo, color del texto, formato, fuente.

## Uso

### Construir y ejecutar

```bash
./build.sh
open clock2dock.app
```

### Fijar en el Dock

Clic derecho sobre el icono → **Opciones** → **Mantener en el Dock**.

### Salir

```bash
pkill clock2dock
```

## Personalización

Edita `main.swift`:

| Qué | Dónde |
|-----|-------|
| Formato (24h/12h/con segundos) | `f.dateFormat = "HH:mm"` |
| Color del texto | `.foregroundColor:` |
| Color de fondo | `NSColor(calibratedRed...` del `bg.fill()` |

Ejemplos de formato:

- `"HH:mm"` → 14:30 (24h, por defecto)
- `"hh:mm a"` → 02:30 PM (12h)
- `"HH:mm:ss"` → 14:30:45 (con segundos)

Recompila con `./build.sh` tras editar.

## Requisitos

- macOS 11 (Big Sur) o superior
- Swift 6+ (incluido en macOS / Xcode Command Line Tools)

## Estructura

```
clock2dock/
├── main.swift      # la app (sin ventana, redibuja el icono del Dock)
├── Info.plist      # metadatos del bundle
└── build.sh        # compila y genera clock2dock.app
```

## Licencia

MIT