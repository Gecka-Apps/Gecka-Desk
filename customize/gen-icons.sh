#!/usr/bin/env bash
# Generate the full multi-platform icon sets from the Gecka brand SVGs.
#
# One set per app, each with its own dedicated mark:
#   icons/        Gecka Remote Support - headset in the gecko ring
#   icons-quick/  Gecka Quick Support  - lifebuoy in the gecko ring
#
# Per-set sources (customize/branding/), monochrome marks on transparent bg:
#   <icon-light>  - black mark  -> tray on light menubar, master for shapes
#   <icon-dark>   - white mark  -> launcher icon (on BG_COLOR), tray on dark
#   <logo-light>  - horizontal logo, dark text  -> in-app logo (light theme)
#   <logo-dark>   - horizontal logo, light text -> in-app logo (dark theme)
#
# The launcher icon is the white mark composited on a filled BG_COLOR square.
# Output goes to the set's outdir, mirroring repo-relative paths; apply.sh
# copies the matching tree over the working copy at build time.
#
# Requires: inkscape, imagemagick, uv. Run once, commit the result.

set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
BRAND="$HERE/branding"
TMP="$(mktemp -d "${TMPDIR:-$HOME/.local/tmp}/gecka-icons.XXXXXX")"
trap 'command rm -rf "$TMP"' EXIT

command -v inkscape >/dev/null || { echo "inkscape is required" >&2; exit 1; }
command -v convert >/dev/null || { echo "imagemagick (convert) is required" >&2; exit 1; }
command -v uvx >/dev/null || { echo "uv (uvx) is required for icns packing" >&2; exit 1; }

BG_COLOR="#353535"   # dark background behind the white mark on launcher icons
MARK_SIZE=820        # mark size inside the 1024 launcher square (~80%, 10% margin)

render() { # render <svg> <size> <out.png>
    inkscape -w "$2" -h "$2" "$1" -o "$3" 2>/dev/null
}

gen_set() { # gen_set <icon-light.svg> <icon-dark.svg> <logo-light.svg> <logo-dark.svg> <outdir>
    local ICON_LIGHT="$BRAND/$1" ICON_DARK="$BRAND/$2"
    local LOGO_LIGHT="$BRAND/$3" LOGO_DARK="$BRAND/$4"
    local OUT="$HERE/$5"

    command rm -rf "$OUT"
    mkdir -p "$OUT"

    # Master marks (transparent): dark svg = white mark, light svg = black mark
    render "$ICON_DARK" 1024 "$TMP/mark-white-1024.png"
    render "$ICON_LIGHT" 1024 "$TMP/mark-black-1024.png"

    # Launcher master: white mark centered on a filled BG_COLOR square
    convert -size 1024x1024 "xc:$BG_COLOR" \
        \( "$TMP/mark-white-1024.png" -resize ${MARK_SIZE}x${MARK_SIZE} \) \
        -gravity center -composite "$TMP/icon-1024.png"

    # --- res/ (desktop core icons) -----------------------------------------
    mkdir -p "$OUT/res"
    command cp "$TMP/icon-1024.png" "$OUT/res/icon.png"
    for s in 32 64 128; do
        convert "$TMP/icon-1024.png" -resize ${s}x${s} "$OUT/res/${s}x${s}.png"
    done
    convert "$TMP/icon-1024.png" -resize 256x256 "$OUT/res/128x128@2x.png"

    # Multi-size Windows ICOs
    convert "$TMP/icon-1024.png" -define icon:auto-resize=256,128,64,48,32,24,16 "$OUT/res/icon.ico"
    convert "$TMP/icon-1024.png" -define icon:auto-resize=32,16 "$OUT/res/tray-icon.ico"

    # macOS app icon: square with ~10% margin, macOS style
    convert "$TMP/icon-1024.png" -resize 824x824 -gravity center -background none -extent 1024x1024 "$OUT/res/mac-icon.png"

    # macOS menubar: black mark for light menubar, white mark for dark menubar
    render "$ICON_LIGHT" 48 "$OUT/res/mac-tray-light-x2.png"
    render "$ICON_DARK" 60 "$OUT/res/mac-tray-dark-x2.png"

    command cp "$ICON_DARK" "$OUT/res/scalable.svg"

    # --- flutter shared assets ----------------------------------------------
    mkdir -p "$OUT/flutter/assets"
    command cp "$ICON_DARK" "$OUT/flutter/assets/icon.svg"
    command cp "$TMP/icon-1024.png" "$OUT/flutter/assets/icon.png"
    # In-app logo, max 300x60 (loadLogo in flutter/lib/common.dart): dark text
    # for light mode (logo.png), light text for dark mode (logo_dark.png).
    inkscape -h 120 "$LOGO_LIGHT" -o "$TMP/logo-l-2x.png" 2>/dev/null
    convert "$TMP/logo-l-2x.png" -resize 300x60 "$OUT/flutter/assets/logo.png"
    inkscape -h 120 "$LOGO_DARK" -o "$TMP/logo-d-2x.png" 2>/dev/null
    convert "$TMP/logo-d-2x.png" -resize 300x60 "$OUT/flutter/assets/logo_dark.png"

    # --- Windows runner ------------------------------------------------------
    mkdir -p "$OUT/flutter/windows/runner/resources"
    command cp "$OUT/res/icon.ico" "$OUT/flutter/windows/runner/resources/app_icon.ico"

    # --- macOS .icns -----------------------------------------------------------
    # imagemagick cannot write icns; icnsutil (python) packs PNGs properly.
    mkdir -p "$OUT/flutter/macos/Runner"
    for s in 16 32 128 256 512 1024; do
        convert "$OUT/res/mac-icon.png" -resize ${s}x${s} "$TMP/${s}x${s}.png"
    done
    uvx icnsutil compose -f "$OUT/flutter/macos/Runner/AppIcon.icns" \
        "$TMP/16x16.png" "$TMP/32x32.png" "$TMP/128x128.png" \
        "$TMP/256x256.png" "$TMP/512x512.png" "$TMP/1024x1024.png"

    # --- Android ---------------------------------------------------------------
    local ARES="$OUT/flutter/android/app/src/main/res"
    local -A DPI=( [mdpi]=48 [hdpi]=72 [xhdpi]=96 [xxhdpi]=144 [xxxhdpi]=192 )
    local -A FG=( [mdpi]=108 [hdpi]=162 [xhdpi]=216 [xxhdpi]=324 [xxxhdpi]=432 )
    local d s f g
    for d in "${!DPI[@]}"; do
        mkdir -p "$ARES/mipmap-$d"
        s=${DPI[$d]}
        convert "$TMP/icon-1024.png" -resize ${s}x${s} "$ARES/mipmap-$d/ic_launcher.png"
        command cp "$ARES/mipmap-$d/ic_launcher.png" "$ARES/mipmap-$d/ic_launcher_round.png"
        # Adaptive foreground: white mark at ~50% inside the 66% safe zone
        f=${FG[$d]}
        g=$(( f / 2 ))
        convert "$TMP/mark-white-1024.png" -resize ${g}x${g} -gravity center -background none -extent ${f}x${f} "$ARES/mipmap-$d/ic_launcher_foreground.png"
    done
    mkdir -p "$ARES/values"
    cat > "$ARES/values/ic_launcher_background.xml" <<EOF
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">$BG_COLOR</color>
</resources>
EOF

    # --- iOS (no alpha allowed: full-bleed square) -----------------------------
    local IOSDIR="$OUT/flutter/ios/Runner/Assets.xcassets/AppIcon.appiconset"
    mkdir -p "$IOSDIR"
    convert "$TMP/mark-white-1024.png" -resize 716x716 -gravity center -background "$BG_COLOR" -extent 1024x1024 -alpha remove -alpha off "$TMP/ios-1024.png"
    ios_icon() { convert "$TMP/ios-1024.png" -resize "$1x$1" "$IOSDIR/$2"; }
    ios_icon 1024 Icon-App-1024x1024@1x.png
    ios_icon 20  Icon-App-20x20@1x.png
    ios_icon 40  Icon-App-20x20@2x.png
    ios_icon 60  Icon-App-20x20@3x.png
    ios_icon 29  Icon-App-29x29@1x.png
    ios_icon 58  Icon-App-29x29@2x.png
    ios_icon 87  Icon-App-29x29@3x.png
    ios_icon 40  Icon-App-40x40@1x.png
    ios_icon 80  Icon-App-40x40@2x.png
    ios_icon 120 Icon-App-40x40@3x.png
    ios_icon 120 Icon-App-60x60@2x.png
    ios_icon 180 Icon-App-60x60@3x.png
    ios_icon 76  Icon-App-76x76@1x.png
    ios_icon 152 Icon-App-76x76@2x.png
    ios_icon 167 "Icon-App-83.5x83.5@2x.png"

    echo "Icon set generated in $OUT"
    find "$OUT" -type f | wc -l
}

gen_set remote-support-icon-light.svg remote-support-icon-dark.svg \
        remote-support-logo-light.svg remote-support-logo-dark.svg icons
gen_set quick-support-icon-light.svg quick-support-icon-dark.svg \
        quick-support-logo-light.svg quick-support-logo-dark.svg icons-quick
