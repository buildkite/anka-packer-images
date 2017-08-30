#!/bin/bash

hdiutil attach /Applications/Install\ macOS\ Sierra.app/Contents/SharedSupport/InstallESD.dmg -noverify -nobrowse >&/dev/null
hdiutil attach /Volumes/OS\ X\ Install\ ESD/BaseSystem.dmg -noverify -nobrowse >&/dev/null

cat /Volumes/OS\ X\ Base\ System/System/Library/CoreServices/SystemVersion.plist

hdiutil detach /Volumes/OS\ X\ Base\ System/ >&/dev/null
hdiutil detach /Volumes/OS\ X\ Install\ ESD/ >&/dev/null
