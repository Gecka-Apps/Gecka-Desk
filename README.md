<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="customize/branding/quick-support-logo-dark.png">
    <img src="customize/branding/quick-support-logo-light.png" alt="Gecka Quick Support" height="50">
  </picture>
  &nbsp;&nbsp;&nbsp;&nbsp;
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="customize/branding/remote-support-logo-dark.png">
    <img src="customize/branding/remote-support-logo-light.png" alt="Gecka Remote Support" height="50">
  </picture>
</p>

<p align="center">
  <b>English</b> | <a href="README.fr.md">Français</a>
</p>

Gecka's remote assistance clients, built on [RustDesk](https://github.com/rustdesk/rustdesk) and connected to Gecka's own infrastructure. Two variants share one code base:

- **Gecka Quick Support** — for the clients being helped: an incoming-only client, a fixed window with an ID and a one-time password, no outgoing connection.
- **Gecka Remote Support** — for the technicians giving support: the full client.

> [!IMPORTANT]
> These builds are intended for Gecka clients and technicians. They connect to Gecka's infrastructure and are distributed for Gecka support operations, not as a general-purpose remote desktop.

## ⚠️ Warning · Avertissement

> [!CAUTION]
> **Misuse disclaimer.** Gecka does not condone or support any unethical or illegal use of this software. Misuse, such as unauthorized access, control, or invasion of privacy, is strictly against our guidelines. Gecka is not responsible for any misuse of the application.
>
> **Clause de non-responsabilité.** Gecka ne cautionne ni ne soutient aucun usage contraire à l'éthique ou illégal de ce logiciel. Tout usage abusif, comme l'accès, le contrôle ou l'atteinte à la vie privée sans autorisation, est strictement contraire à nos règles. Gecka n'est pas responsable d'un usage abusif de l'application.

## Download

Links always point to the newest release.

| Platform | Gecka Quick Support<br><sub>(for clients)</sub> | Gecka Remote Support<br><sub>(for technicians)</sub> |
|----------|---------------------|----------------------|
| **Windows** (x64) | [Installer (MSI)](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaquicksupport-windows-x86_64.msi) · [Portable](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaquicksupport-windows-x86_64.exe) | [Installer (MSI)](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaremotesupport-windows-x86_64.msi) · [Portable](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaremotesupport-windows-x86_64.exe) |
| **macOS** (Apple Silicon) | [.dmg](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaquicksupport-macos-aarch64.dmg) | [.dmg](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaremotesupport-macos-aarch64.dmg) |
| **macOS** (Intel) | [.dmg](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaquicksupport-macos-x86_64.dmg) | [.dmg](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaremotesupport-macos-x86_64.dmg) |
| **Debian / Ubuntu** | [.deb](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaquicksupport-linux-x86_64.deb) | [.deb](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaremotesupport-linux-x86_64.deb) |
| **Fedora** | [.rpm](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaquicksupport-linux-x86_64.rpm) | [.rpm](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaremotesupport-linux-x86_64.rpm) |
| **openSUSE** | [.rpm](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaquicksupport-linux-x86_64-suse.rpm) | [.rpm](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaremotesupport-linux-x86_64-suse.rpm) |
| **AppImage** | [.AppImage](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaquicksupport-linux-x86_64.AppImage) | [.AppImage](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaremotesupport-linux-x86_64.AppImage) |
| **Flatpak** | [.flatpak](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaquicksupport-linux-x86_64.flatpak) | [.flatpak](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaremotesupport-linux-x86_64.flatpak) |
| **Android** | [Universal](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaquicksupport-android-universal-signed.apk) · [arm64-v8a](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaquicksupport-android-arm64-v8a-signed.apk) · [armeabi-v7a](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaquicksupport-android-armeabi-v7a-signed.apk) · [x86_64](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaquicksupport-android-x86_64-signed.apk) | [Universal](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaremotesupport-android-universal-signed.apk) · [arm64-v8a](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaremotesupport-android-arm64-v8a-signed.apk) · [armeabi-v7a](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaremotesupport-android-armeabi-v7a-signed.apk) · [x86_64](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaremotesupport-android-x86_64-signed.apk) |

## Installing: signatures and platform trust

Commercial code-signing certificates (Windows) and the Apple Developer Program (macOS) carry a recurring yearly cost. Gecka signs its builds with its own certificates instead, which is free but means each platform needs a one-time trust step, or shows a first-launch warning you can dismiss.

### Windows

Binaries are Authenticode-signed with the Gecka code-signing certificate, issued by the **Gecka Root CA** ([`customize/certs/gecka-ca.crt`](customize/certs/gecka-ca.crt)). On a machine that does not trust this CA, SmartScreen still reports an "Unknown publisher" and blocks the app on first run. Pick whichever fits:

- **Just run it (quickest, nothing to install):** on the SmartScreen prompt, click **More info**, then **Run anyway**.
- **Trust Gecka on this machine:** import `gecka-ca.crt` into *Trusted Root Certification Authorities* (double-click → Install Certificate → Local Machine → Trusted Root Certification Authorities). The publisher then shows as Gecka and the block goes away.
- **Managed fleet:** deploy `gecka-ca.crt` to *Trusted Root Certification Authorities* by GPO (Computer Configuration → Policies → Windows Settings → Security Settings → Public Key Policies). Gecka apps install with no warning across all machines.

### macOS

Builds are ad-hoc signed, so Apple Silicon does not flag them as "damaged", but they are not notarized (no paid Apple Developer account), so Gatekeeper reports an unidentified developer. To open the app:

- Right-click (or Ctrl-click) the app → **Open** → **Open**, or
- **System Settings → Privacy & Security → Open Anyway** after the first attempt, or
- in Terminal: `xattr -dr com.apple.quarantine /Applications/GeckaRemoteSupport.app`

### Android

APKs are signed with Gecka's own key, not Google Play. Enable **Install unknown apps** for your browser or file manager, then open the APK. Play Protect may warn; choose to install anyway.

### Linux

Linux packages are not code-signed (the platform does not require it). Install the `.deb` / `.rpm` with your package manager, make the AppImage executable (`chmod +x`) and run it, or install the Flatpak bundle with `flatpak install`.

## About these builds

This is a rebranded fork of RustDesk. The upstream tree is kept pristine; the Gecka identity (name, icons, server, IDs) is applied at build time by `customize/apply.sh`, so the fork stays a thin, rebase-friendly layer over upstream. Both variants (`full` and `quick`) come from the same source.

We do not accept contributions here. If you would like to contribute to the underlying software, please do so upstream at [rustdesk/rustdesk](https://github.com/rustdesk/rustdesk). See [CONTRIBUTING.md](CONTRIBUTING.md).

---
Built with 🥥 and ☕ by [Gecka](https://gecka.nc) — Kanaky-New Caledonia 🇳🇨
