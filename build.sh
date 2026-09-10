#!/bin/bash
set -e
cd "$(dirname "$0")"
APP="clock2dock.app"
LSREG="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister"

rm -rf "$APP" release AppIcon.icns
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"

swiftc main.swift ClockRenderer.swift \
  -o "$APP/Contents/MacOS/clock2dock" -framework Cocoa

swiftc icon_gen.swift ClockRenderer.swift \
  -o /tmp/icon_gen -framework Cocoa
/tmp/icon_gen
cp AppIcon.icns "$APP/Contents/Resources/AppIcon.icns"

cp Info.plist "$APP/Contents/Info.plist"
printf 'APPL????' > "$APP/Contents/PkgInfo"
touch "$APP"

"$LSREG" -f "$(pwd)/$APP" >/dev/null 2>&1 || true

echo "Built $APP"