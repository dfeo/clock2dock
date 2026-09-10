#!/bin/bash
set -e
cd "$(dirname "$0")"
APP="clock2dock.app"
rm -rf "$APP" release AppIcon.icns
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"

swiftc main.swift ClockRenderer.swift \
  -o "$APP/Contents/MacOS/clock2dock" -framework Cocoa

swiftc icon_gen.swift ClockRenderer.swift \
  -o /tmp/icon_gen -framework Cocoa
/tmp/icon_gen
cp AppIcon.icns "$APP/Contents/Resources/AppIcon.icns"

cp Info.plist "$APP/Contents/Info.plist"
touch "$APP"
echo "Built $APP"