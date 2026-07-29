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
  <a href="README.md">English</a> | <b>Français</b>
</p>

Les clients d'assistance à distance de Gecka, basés sur [RustDesk](https://github.com/rustdesk/rustdesk) et connectés à l'infrastructure de Gecka. Deux variantes partagent une seule base de code :

- **Gecka Quick Support** : pour les clients aidés, un client entrant uniquement : une fenêtre fixe avec un identifiant et un mot de passe à usage unique, sans connexion sortante.
- **Gecka Remote Support** : pour les techniciens qui dépannent, le client complet.

> [!IMPORTANT]
> Ces builds sont destinés aux clients et techniciens Gecka. Ils se connectent à l'infrastructure Gecka et sont distribués pour les opérations de support Gecka, pas comme un outil de bureau à distance générique.

## ⚠️ Warning · Avertissement

> [!CAUTION]
> **Misuse disclaimer.** Gecka does not condone or support any unethical or illegal use of this software. Misuse, such as unauthorized access, control, or invasion of privacy, is strictly against our guidelines. Gecka is not responsible for any misuse of the application.
>
> **Clause de non-responsabilité.** Gecka ne cautionne ni ne soutient aucun usage contraire à l'éthique ou illégal de ce logiciel. Tout usage abusif, comme l'accès, le contrôle ou l'atteinte à la vie privée sans autorisation, est strictement contraire à nos règles. Gecka n'est pas responsable d'un usage abusif de l'application.

## Téléchargement

Les liens pointent toujours vers la dernière version.

| Plateforme | Gecka Quick Support<br><sub>(pour les clients)</sub> | Gecka Remote Support<br><sub>(pour les techniciens)</sub> |
|------------|---------------------|----------------------|
| **Windows** (x64) | [Installeur (MSI)](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaquicksupport-windows-x86_64.msi) · [Portable](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaquicksupport-windows-x86_64.exe) | [Installeur (MSI)](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaremotesupport-windows-x86_64.msi) · [Portable](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaremotesupport-windows-x86_64.exe) |
| **macOS** (Apple Silicon) | [.dmg](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaquicksupport-macos-aarch64.dmg) | [.dmg](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaremotesupport-macos-aarch64.dmg) |
| **macOS** (Intel) | [.dmg](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaquicksupport-macos-x86_64.dmg) | [.dmg](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaremotesupport-macos-x86_64.dmg) |
| **Debian / Ubuntu** | [.deb](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaquicksupport-linux-x86_64.deb) | [.deb](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaremotesupport-linux-x86_64.deb) |
| **Fedora** | [.rpm](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaquicksupport-linux-x86_64.rpm) | [.rpm](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaremotesupport-linux-x86_64.rpm) |
| **openSUSE** | [.rpm](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaquicksupport-linux-x86_64-suse.rpm) | [.rpm](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaremotesupport-linux-x86_64-suse.rpm) |
| **AppImage** | [.AppImage](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaquicksupport-linux-x86_64.AppImage) | [.AppImage](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaremotesupport-linux-x86_64.AppImage) |
| **Flatpak** | [.flatpak](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaquicksupport-linux-x86_64.flatpak) | [.flatpak](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaremotesupport-linux-x86_64.flatpak) |
| **Android** | [Universel](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaquicksupport-android-universal-signed.apk) · [arm64-v8a](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaquicksupport-android-arm64-v8a-signed.apk) · [armeabi-v7a](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaquicksupport-android-armeabi-v7a-signed.apk) · [x86_64](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaquicksupport-android-x86_64-signed.apk) | [Universel](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaremotesupport-android-universal-signed.apk) · [arm64-v8a](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaremotesupport-android-arm64-v8a-signed.apk) · [armeabi-v7a](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaremotesupport-android-armeabi-v7a-signed.apk) · [x86_64](https://github.com/Gecka-Apps/Gecka-Remote-Support/releases/latest/download/geckaremotesupport-android-x86_64-signed.apk) |

## Installation : signatures et confiance par plateforme

Les certificats de signature de code commerciaux (Windows) et le programme Apple Developer (macOS) ont un coût annuel récurrent. Gecka signe ses builds avec ses propres certificats : c'est gratuit, mais chaque plateforme demande une étape de confiance à faire une fois, ou affiche un avertissement au premier lancement qu'on peut ignorer.

### Windows

Les binaires sont signés (Authenticode) avec le certificat de signature de code Gecka, émis par la **Gecka Root CA** ([`customize/certs/gecka-ca.crt`](customize/certs/gecka-ca.crt)). Sur un poste qui ne fait pas confiance à ce CA, SmartScreen affiche quand même « Éditeur inconnu » et bloque l'app au premier lancement. Selon le cas :

- **Lancer directement (le plus simple, rien à installer) :** sur l'écran SmartScreen, cliquez sur **Informations complémentaires**, puis **Exécuter quand même**.
- **Faire confiance à Gecka sur ce poste :** importez `gecka-ca.crt` dans *Autorités de certification racines de confiance* (double-clic → Installer le certificat → Ordinateur local → Autorités de certification racines de confiance). L'éditeur s'affiche alors comme Gecka et le blocage disparaît.
- **Parc géré :** déployez `gecka-ca.crt` dans *Autorités de certification racines de confiance* par GPO (Configuration ordinateur → Stratégies → Paramètres Windows → Paramètres de sécurité → Stratégies de clé publique). Les apps Gecka s'installent sans avertissement sur tous les postes.

### macOS

Les builds sont signés en ad-hoc, pour qu'Apple Silicon ne les signale pas comme « endommagés », mais ils ne sont pas notarisés (pas de compte Apple Developer payant) : Gatekeeper indique donc un développeur non identifié. Pour ouvrir l'app :

- Clic droit (ou Ctrl-clic) sur l'app → **Ouvrir** → **Ouvrir**, ou
- **Réglages Système → Confidentialité et sécurité → Ouvrir quand même** après la première tentative, ou
- dans le Terminal : `xattr -dr com.apple.quarantine /Applications/GeckaRemoteSupport.app`

### Android

Les APK sont signés avec la clé propre de Gecka, pas via Google Play. Activez **Installer des applications inconnues** pour votre navigateur ou gestionnaire de fichiers, puis ouvrez l'APK. Play Protect peut avertir ; choisissez d'installer quand même.

### Linux

Les paquets Linux ne sont pas signés (la plateforme ne l'exige pas). Installez le `.deb` / `.rpm` avec votre gestionnaire de paquets, rendez l'AppImage exécutable (`chmod +x`) et lancez-la, ou installez le bundle Flatpak avec `flatpak install`.

## À propos de ces builds

C'est un fork rebrandé de RustDesk. L'arbre upstream reste intact ; l'identité Gecka (nom, icônes, serveur, identifiants) est appliquée au moment du build par `customize/apply.sh`, ce qui garde le fork comme une fine couche au-dessus d'upstream, facile à rebaser. Les deux variantes (`full` et `quick`) proviennent de la même source.

Nous n'acceptons pas de contributions ici. Si vous souhaitez contribuer au logiciel sous-jacent, faites-le en amont sur [rustdesk/rustdesk](https://github.com/rustdesk/rustdesk). Voir [CONTRIBUTING.md](CONTRIBUTING.md).

---
Built with 🥥 and ☕ by [Gecka](https://gecka.nc) — Kanaky-New Caledonia 🇳🇨
