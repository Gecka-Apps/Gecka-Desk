#!/usr/bin/env bash
# Build-time customization: turns the pristine RustDesk tree into one of
# the Gecka apps (name, ids, icons, preset server):
#
#   apply.sh [full]   Gecka Remote Support - complete client (default)
#   apply.sh quick    Gecka Quick Support  - incoming-only support client
#
# Run AFTER `git submodule update --init` and BEFORE any build step:
#   bash customize/apply.sh [variant]
#
# Design: nothing here is committed to the source tree — the fork stays a
# tiny diff against upstream and rebases cleanly on upstream tags. Every
# substitution is asserted: if upstream refactors a targeted line, this
# script fails the build instead of shipping a half-branded binary.
#
# Naming rules (do not change one without the others):
#   APP_NAME has no spaces: the URL scheme, Windows registry keys and
#   service names are derived from it at runtime (see src/common.rs
#   get_uri_prefix, src/platform/windows.rs).
#   URL_SCHEME must equal lowercase(APP_NAME).
#   WIN_EXE must equal APP_NAME.exe: the MSI looks up "$Product.exe" in
#   the build dir (res/msi/Package/Components/RustDesk.wxs).
#   The com.carriez prefix is kept on purpose: macOS launchd plists are
#   templated at runtime by correct_app_name() in src/platform/macos.rs
#   which only rewrites the app-name part.

set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"

VARIANT="${1:-full}"
case "$VARIANT" in
full)
    APP_NAME="GeckaRemoteSupport"
    APP_DISPLAY_NAME="Gecka Remote Support"
    PKG_NAME="geckaremotesupport"              # = lowercase APP_NAME: single Linux system id (binary, service, .desktop, config dir)
    WIN_EXE="GeckaRemoteSupport.exe"
    URL_SCHEME="geckaremotesupport"            # = lowercase APP_NAME
    MAC_BUNDLE_ID="com.carriez.geckaRemoteSupport"
    SCITER_BUNDLE_ID="com.carriez.geckaremotesupport"
    ANDROID_APP_ID="nc.gecka.remotesupport"
    LINUX_APP_ID="nc.gecka.remotesupport"
    FLATPAK_ID="nc.gecka.RemoteSupport"
    ICONS_DIR="customize/icons"
    ;;
quick)
    APP_NAME="GeckaQuickSupport"
    APP_DISPLAY_NAME="Gecka Quick Support"
    PKG_NAME="geckaquicksupport"
    WIN_EXE="GeckaQuickSupport.exe"
    URL_SCHEME="geckaquicksupport"
    MAC_BUNDLE_ID="com.carriez.geckaQuickSupport"
    SCITER_BUNDLE_ID="com.carriez.geckaquicksupport"
    ANDROID_APP_ID="nc.gecka.quicksupport"
    LINUX_APP_ID="nc.gecka.quicksupport"
    FLATPAK_ID="nc.gecka.QuickSupport"
    ICONS_DIR="customize/icons-quick"
    ;;
*)
    echo "apply.sh: unknown variant '$VARIANT' (expected: full, quick)" >&2
    exit 1
    ;;
esac
COMPANY="Gecka"
MAINTAINER="Gecka <contact@gecka.nc>"
HOMEPAGE="https://gecka.nc"
# Rendezvous server + its public key. Not secret (they ship in every client),
# but kept out of the source so scrapers can't harvest the server from the repo.
# Local builds: customize/branding.env (gitignored); CI: repo variables.
if [ -f "$REPO/customize/branding.env" ]; then . "$REPO/customize/branding.env"; fi
RENDEZVOUS_SERVER="${GECKA_RENDEZVOUS_SERVER:?set GECKA_RENDEZVOUS_SERVER (env or customize/branding.env)}"
RS_PUB_KEY="${GECKA_RS_PUB_KEY:?set GECKA_RS_PUB_KEY (env or customize/branding.env)}"

MARKER=".gecka-customized"
if [ -f "$MARKER" ]; then
    echo "apply.sh: already applied, skipping"
    exit 0
fi

fail() { echo "apply.sh: ERROR: $*" >&2; exit 1; }

# Fixed-string replace; fails if the needle is absent (upstream drift guard).
subst() { # subst <file> <old> <new>
    [ -f "$1" ] || fail "missing file: $1"
    grep -qF -- "$2" "$1" || fail "pattern not found in $1: $2"
    FROM="$2" TO="$3" perl -pi -e 's/\Q$ENV{FROM}\E/$ENV{TO}/g' "$1"
}

# Fixed-string replace; silently skips when the needle is absent.
subst_opt() { # subst_opt <file> <old> <new>
    [ -f "$1" ] || fail "missing file: $1"
    grep -qF -- "$2" "$1" || return 0
    FROM="$2" TO="$3" perl -pi -e 's/\Q$ENV{FROM}\E/$ENV{TO}/g' "$1"
}

# Whole-file rebrand for self-contained packaging files (specs, recipes,
# maintainer scripts): fix domains/schemes first, then generic names.
brand_file() { # brand_file <file>
    [ -f "$1" ] || fail "missing file: $1"
    grep -qF -e 'rustdesk' -e 'RustDesk' "$1" || fail "nothing to brand in $1"
    # librustdesk.{so,dll} is the real cargo lib artifact, never renamed
    perl -pi -e 's/librustdesk/__KEEP_LIB__/g' "$1"
    subst_opt "$1" 'rustdesk <info@rustdesk.com>' "$MAINTAINER"
    subst_opt "$1" 'rustdesk.com' 'gecka.nc'
    subst_opt "$1" 'x-scheme-handler/rustdesk' "x-scheme-handler/$URL_SCHEME"
    FROM='rustdesk' TO="$PKG_NAME" perl -pi -e 's/\Q$ENV{FROM}\E/$ENV{TO}/g' "$1"
    FROM='RustDesk' TO="$APP_DISPLAY_NAME" perl -pi -e 's/\Q$ENV{FROM}\E/$ENV{TO}/g' "$1"
    perl -pi -e 's/__KEEP_LIB__/librustdesk/g' "$1"
}

echo "== Gecka customization: server + key + app name (hbb_common) =="
HBB_CFG="libs/hbb_common/src/config.rs"
[ -f "$HBB_CFG" ] || fail "$HBB_CFG not found - run: git submodule update --init"
subst "$HBB_CFG" \
    'pub const RENDEZVOUS_SERVERS: &[&str] = &["rs-ny.rustdesk.com"];' \
    "pub const RENDEZVOUS_SERVERS: &[&str] = &[\"$RENDEZVOUS_SERVER\"];"
subst "$HBB_CFG" \
    'pub const RS_PUB_KEY: &str = "OeVuKk5nlHiXp+APNn0Y3pC1Iwpwn44JGqrQCsWqmBw=";' \
    "pub const RS_PUB_KEY: &str = \"$RS_PUB_KEY\";"
subst "$HBB_CFG" \
    'pub static ref APP_NAME: RwLock<String> = RwLock::new("RustDesk".to_owned());' \
    "pub static ref APP_NAME: RwLock<String> = RwLock::new(\"$APP_NAME\".to_owned());"

echo "== Cargo.toml =="
subst Cargo.toml 'name = "rustdesk"' "name = \"$PKG_NAME\""
subst Cargo.toml 'default-run = "rustdesk"' "default-run = \"$PKG_NAME\""
subst Cargo.toml 'description = "RustDesk Remote Desktop"' "description = \"$APP_DISPLAY_NAME\""
subst Cargo.toml 'ProductName = "RustDesk"' "ProductName = \"$APP_DISPLAY_NAME\""
subst Cargo.toml 'FileDescription = "RustDesk Remote Desktop"' "FileDescription = \"$APP_DISPLAY_NAME\""
subst Cargo.toml 'OriginalFilename = "rustdesk.exe"' "OriginalFilename = \"$WIN_EXE\""
subst Cargo.toml 'name = "RustDesk"' "name = \"$APP_DISPLAY_NAME\""
subst Cargo.toml 'identifier = "com.carriez.rustdesk"' "identifier = \"$SCITER_BUNDLE_ID\""
# Keep the lock in sync with the renamed package: CI builds with --locked.
subst Cargo.lock 'name = "rustdesk"' "name = \"$PKG_NAME\""

echo "== build.py =="
# Specific lines first (mixed-case exe juggling), generic passes last.
subst build.py 'Maintainer: rustdesk <info@rustdesk.com>' "Maintainer: $MAINTAINER"
subst build.py 'Homepage: https://rustdesk.com' "Homepage: $HOMEPAGE"
subst build.py 'Description: A remote control software.' "Description: $APP_DISPLAY_NAME remote control software."
# cargo output (= package name) renamed to the pretty windows exe name
subst build.py 'mv target/release/rustdesk.exe target/release/RustDesk.exe' \
    "mv target/release/$PKG_NAME.exe target/release/$WIN_EXE"
subst build.py 'target\\release\\rustdesk.exe' "target\\\\release\\\\$WIN_EXE"
# flutter windows build outputs BINARY_NAME.exe (= WIN_EXE)
subst build.py '{flutter_build_dir_2}/rustdesk.exe' "{flutter_build_dir_2}/$WIN_EXE"
subst build.py 'RustDesk.exe' "$WIN_EXE"
subst build.py 'RustDesk.app' "$APP_NAME.app"
# Protect names that match real upstream artifacts (cargo lib/crate names).
perl -pi -e 's/librustdesk/__KEEP_LIB__/g; s/rustdesk-portable-packer/__KEEP_PACKER__/g' build.py
FROM='rustdesk' TO="$PKG_NAME" perl -pi -e 's/\Q$ENV{FROM}\E/$ENV{TO}/g' build.py
FROM='RustDesk' TO="$APP_NAME" perl -pi -e 's/\Q$ENV{FROM}\E/$ENV{TO}/g' build.py
perl -pi -e 's/__KEEP_LIB__/librustdesk/g; s/__KEEP_PACKER__/rustdesk-portable-packer/g' build.py

echo "== Windows (flutter runner + MSI) =="
subst flutter/windows/CMakeLists.txt 'set(BINARY_NAME "rustdesk")' "set(BINARY_NAME \"$APP_NAME\")"
RC=flutter/windows/runner/Runner.rc
subst "$RC" '"CompanyName", "Purslane Tech Pte. Ltd."' "\"CompanyName\", \"$COMPANY\""
subst "$RC" '"FileDescription", "RustDesk Remote Desktop"' "\"FileDescription\", \"$APP_DISPLAY_NAME\""
subst "$RC" '"InternalName", "rustdesk"' "\"InternalName\", \"$APP_NAME\""
subst "$RC" '"OriginalFilename", "rustdesk.exe"' "\"OriginalFilename\", \"$WIN_EXE\""
subst "$RC" '"ProductName", "RustDesk"' "\"ProductName\", \"$APP_DISPLAY_NAME\""
subst flutter/windows/runner/main.cpp 'L"RustDesk"' "L\"$APP_NAME\""
subst res/msi/preprocess.py 'default="RustDesk"' "default=\"$APP_NAME\""
subst res/msi/preprocess.py 'default="Purslane Tech Pte. Ltd."' "default=\"$COMPANY\""

echo "== Linux (flutter runner) =="
subst flutter/linux/CMakeLists.txt 'set(BINARY_NAME "rustdesk")' "set(BINARY_NAME \"$PKG_NAME\")"
subst flutter/linux/CMakeLists.txt 'set(APPLICATION_ID "com.carriez.flutter_hbb")' "set(APPLICATION_ID \"$LINUX_APP_ID\")"

echo "== macOS =="
XC=flutter/macos/Runner/Configs/AppInfo.xcconfig
subst "$XC" 'PRODUCT_NAME = RustDesk' "PRODUCT_NAME = $APP_NAME"
subst "$XC" 'PRODUCT_BUNDLE_IDENTIFIER = com.carriez.flutterHbb' "PRODUCT_BUNDLE_IDENTIFIER = $MAC_BUNDLE_ID"
subst "$XC" 'Copyright © 2026 Purslane Tech Pte. Ltd. All rights reserved.' "Copyright © 2026 Purslane Tech Pte. Ltd. & $COMPANY. All rights reserved."
subst flutter/macos/Runner/Info.plist '<string>com.carriez.rustdesk</string>' "<string>$SCITER_BUNDLE_ID</string>"
subst flutter/macos/Runner/Info.plist '<string>rustdesk</string>' "<string>$URL_SCHEME</string>"

echo "== iOS =="
subst flutter/ios/Runner/Info.plist '<string>RustDesk</string>' "<string>$APP_DISPLAY_NAME</string>"
subst flutter/ios/Runner/Info.plist '<string>com.carriez.rustdesk</string>' "<string>$SCITER_BUNDLE_ID</string>"
subst flutter/ios/Runner/Info.plist '<string>rustdesk</string>' "<string>$URL_SCHEME</string>"

echo "== Android =="
subst flutter/android/app/build.gradle 'applicationId "com.carriez.flutter_hbb"' "applicationId \"$ANDROID_APP_ID\""
AM=flutter/android/app/src/main/AndroidManifest.xml
subst "$AM" 'android:label="RustDesk Input"' "android:label=\"$APP_DISPLAY_NAME Input\""
subst "$AM" 'android:label="RustDesk"' "android:label=\"$APP_DISPLAY_NAME\""
subst "$AM" '<data android:scheme="rustdesk" />' "<data android:scheme=\"$URL_SCHEME\" />"
SX=flutter/android/app/src/main/res/values/strings.xml
FROM='RustDesk' TO="$APP_DISPLAY_NAME" perl -pi -e 's/\Q$ENV{FROM}\E/$ENV{TO}/g' "$SX"

echo "== Linux packaging files =="
command mv res/rustdesk.desktop "res/$PKG_NAME.desktop"
command mv res/rustdesk-link.desktop "res/$PKG_NAME-link.desktop"
command mv res/rustdesk.service "res/$PKG_NAME.service"
command mv res/pam.d/rustdesk.debian "res/pam.d/$PKG_NAME.debian"
command mv res/pam.d/rustdesk.suse "res/pam.d/$PKG_NAME.suse"
brand_file "res/$PKG_NAME.desktop"
brand_file "res/$PKG_NAME-link.desktop"
brand_file "res/$PKG_NAME.service"
brand_file res/PKGBUILD
brand_file res/rpm.spec
brand_file res/rpm-suse.spec
brand_file res/rpm-flutter.spec
brand_file res/rpm-flutter-suse.spec
for f in res/DEBIAN/postinst res/DEBIAN/postrm res/DEBIAN/preinst res/DEBIAN/prerm; do
    brand_file "$f"
done

echo "== AppImage & Flatpak =="
brand_file appimage/AppImageBuilder-x86_64.yml
brand_file appimage/AppImageBuilder-aarch64.yml
# dpkg on the CI runner emits data.tar.zst, not .xz; unpack whatever data
# tarball the deb actually carries (bsdtar reads both zstd and xz).
subst appimage/AppImageBuilder-x86_64.yml 'tar -xvf ./data.tar.xz' 'bsdtar -xf ./data.tar.*'
subst appimage/AppImageBuilder-aarch64.yml 'tar -xvf ./data.tar.xz' 'bsdtar -xf ./data.tar.*'
subst flatpak/rustdesk.json 'com.rustdesk.RustDesk' "$FLATPAK_ID"
brand_file flatpak/rustdesk.json
subst flatpak/rustdesk.json 'data.tar.xz' 'data.tar.*'
subst flatpak/com.rustdesk.RustDesk.metainfo.xml 'com.rustdesk.RustDesk' "$FLATPAK_ID"
brand_file flatpak/com.rustdesk.RustDesk.metainfo.xml
command mv flatpak/com.rustdesk.RustDesk.metainfo.xml "flatpak/$FLATPAK_ID.metainfo.xml"

echo "== UI strings (translations + window title) =="
subst flutter/lib/desktop/widgets/tabbar_widget.dart '"RustDesk"' "\"$APP_DISPLAY_NAME\""
# Rebrand translation VALUES only. Keys are lookup identifiers: rewriting
# them breaks translate() and the UI falls back to English. powered_by_me
# stays untouched - upstream excludes it from app-name substitution on
# purpose (attribution line, links to rustdesk.com).
for f in src/lang/*.rs; do
    # Capture groups go into lexicals first: the inner s/// would clobber
    # $1..$4 before the concatenation reads them.
    TO="$APP_DISPLAY_NAME" perl -pi -e \
        's/^(\s*\("((?:[^"\\]|\\.)*)",\s*")((?:[^"\\]|\\.)*)("\s*\),?\s*)$/my ($p,$k,$v,$c)=($1,$2,$3,$4); $v =~ s|RustDesk|$ENV{TO}|g unless $k eq "powered_by_me"; "$p$v$c"/e' \
        "$f"
done
grep -qF "$APP_DISPLAY_NAME" src/lang/fr.rs || fail "lang rebrand had no effect"
grep -qF '("About RustDesk", "")' src/lang/template.rs || fail "lang keys were rewritten - lookups would break"
# The About card title has no English value upstream (the key is the text),
# so it falls back to the key and the runtime app-name substitution yields
# the spaceless APP_NAME. Translated files (fr, ...) already carry a value
# that the rewrite above rebrands.
LANG_ANCHOR='    ].iter().cloned().collect();'
grep -qF "$LANG_ANCHOR" src/lang/en.rs || fail "en.rs map collector not found"
# Upstream's last map entry may have no trailing comma (valid before ]);
# normalise it to a comma, then append our About pair as the final entry.
TO="$APP_DISPLAY_NAME" perl -0pi -e \
    's/\),?(\s*\n\s*\]\.iter\(\)\.cloned\(\)\.collect\(\);)/),\n        ("About RustDesk", "About $ENV{TO}"),$1/' \
    src/lang/en.rs
grep -qF "(\"About RustDesk\", \"About $APP_DISPLAY_NAME\")" src/lang/en.rs \
    || fail "About entry not inserted in en.rs"

echo "== About page (links + copyright) =="
# Order matters: the privacy URL contains the bare domain URL.
DESKTOP_SETTINGS=flutter/lib/desktop/pages/desktop_setting_page.dart
MOBILE_SETTINGS=flutter/lib/mobile/pages/settings_page.dart
subst "$DESKTOP_SETTINGS" "https://rustdesk.com/privacy.html" 'https://gecka.nc/contrats/'
subst "$DESKTOP_SETTINGS" "launchUrlString('https://rustdesk.com')" "launchUrlString('$HOMEPAGE')"
subst "$MOBILE_SETTINGS" "https://rustdesk.com/privacy.html" 'https://gecka.nc/contrats/'
subst "$MOBILE_SETTINGS" "'https://rustdesk.com/'" "'$HOMEPAGE/'"
subst "$MOBILE_SETTINGS" "'rustdesk.com'" "'gecka.nc'"
# AGPL: the upstream copyright notice must be preserved; ours is added for
# the modifications.
subst "$DESKTOP_SETTINGS" \
    'Purslane Tech Pte. Ltd.\n$license' \
    'Purslane Tech Pte. Ltd.\nCopyright © ${DateTime.now().toString().substring(0, 4)} '"$COMPANY"'\n$license'

# In-app logo: upstream loadLogo() resolves assets/logo_dark.png (dark UI) or
# assets/logo_light.png (light UI), falling back to assets/logo.png, so no
# source patch is needed - we only ship the assets below. gen-icons.sh emits
# logo.png + logo_dark.png; light UI falls back to logo.png.

echo "== Disable upstream update check =="
# The built-in update check POSTs to api.rustdesk.com and, when a newer RustDesk
# release exists, points users at rustdesk.com downloads (not ours) while
# sending a device fingerprint. Force it off for every variant through
# OVERWRITE_LOCAL_SETTINGS (read first by LocalConfig::get_option), injected at
# the top of load_custom_client() like the incoming-only variant does.
UPD_NEEDLE='pub fn load_custom_client() {'
grep -qF "$UPD_NEEDLE" src/common.rs || fail "load_custom_client signature moved in src/common.rs"
FROM="$UPD_NEEDLE" perl -0pi -e 's/\Q$ENV{FROM}\E/$ENV{FROM}\n    \/\/ gecka: disable upstream update check (leaks to api.rustdesk.com)\n    config::OVERWRITE_LOCAL_SETTINGS\n        .write()\n        .unwrap()\n        .insert("enable-check-update".to_owned(), "N".to_owned());/' src/common.rs
grep -qF 'gecka: disable upstream update check' src/common.rs || fail "update-check disable injection had no effect"

echo "== Icons & logos =="
command cp -r "$ICONS_DIR/res/." res/
command cp -r "$ICONS_DIR/flutter/." flutter/

if [ "$VARIANT" = "quick" ]; then
    echo "== Incoming-only hard setting =="
    # Force conn-type=incoming into HARD_SETTINGS at startup: upstream's
    # is_incoming_only() reads it to drive the minimal UI (small fixed
    # window, ID + one-time password, no outgoing connect field). Same code
    # path the paid RustDesk custom-client generator uses, minus the signed
    # custom.txt (whose signature is checked against Purslane's key —
    # unusable for a fork). Injected at the top of load_custom_client()
    # (called once from core_main); the marker comment keeps it greppable.
    NEEDLE='pub fn load_custom_client() {'
    grep -qF "$NEEDLE" src/common.rs || fail "load_custom_client signature moved in src/common.rs"
    FROM="$NEEDLE" perl -0pi -e 's/\Q$ENV{FROM}\E/$ENV{FROM}\n    \/\/ gecka: incoming-only support client variant\n    config::HARD_SETTINGS\n        .write()\n        .unwrap()\n        .insert("conn-type".to_owned(), "incoming".to_owned());/' src/common.rs
    grep -qF 'gecka: incoming-only support client variant' src/common.rs || fail "injection had no effect"
fi

echo "== Sanity checks =="
# These files must not mention rustdesk anymore (would leak into packages).
# CMakeLists are excluded: they keep librustdesk.{dll,so} on purpose.
for f in "res/$PKG_NAME.desktop" "res/$PKG_NAME-link.desktop" "res/$PKG_NAME.service" \
         res/PKGBUILD; do
    if grep -qiF 'rustdesk' "$f"; then
        fail "leftover rustdesk reference in $f"
    fi
done
# build.py may only keep protected crate names.
if grep -F 'rustdesk' build.py | grep -vF 'librustdesk' | grep -vF 'rustdesk-portable-packer' | grep -q .; then
    fail "leftover rustdesk reference in build.py"
fi
python3 -m py_compile build.py res/msi/preprocess.py 2>/dev/null \
    || python -m py_compile build.py res/msi/preprocess.py

echo "$VARIANT" > "$MARKER"
echo "OK: tree customized as $APP_DISPLAY_NAME ($PKG_NAME, server $RENDEZVOUS_SERVER)"
