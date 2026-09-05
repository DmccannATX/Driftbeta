#!/bin/bash
set -euo pipefail
VERSION="$(node -p 'require("./package.json").version')"
rm -rf dist dmg-stage
npx electron-packager . "Michael Job Agent" --platform=darwin --arch=arm64 --electron-version=44.2.0 --overwrite --out=dist --prune=true --asar --ignore='^/dist$'
APP='dist/Michael Job Agent-darwin-arm64/Michael Job Agent.app'
/usr/bin/codesign --force --deep --sign - "$APP"
/usr/bin/codesign --verify --deep --strict "$APP"
mkdir -p dmg-stage
cp -R "$APP" dmg-stage/
ln -s /Applications dmg-stage/Applications
DMG="dist/Michael-Job-Agent-${VERSION}-arm64.dmg"
hdiutil create -volname "Michael Job Agent" -srcfolder dmg-stage -ov -format UDZO "$DMG"
shasum -a 256 "$DMG" > "${DMG}.sha256"
