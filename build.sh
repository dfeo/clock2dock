#!/bin/bash
set -e
cd "$(dirname "$0")"
APP="clock2dock.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
swiftc main.swift -o "$APP/Contents/MacOS/clock2dock" -framework Cocoa
cp Info.plist "$APP/Contents/Info.plist"
touch "$APP"
echo "Built $APP"