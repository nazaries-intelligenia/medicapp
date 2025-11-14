# Installationsanleitung

Diese Anleitung führt Sie durch die Installation und Erstkonfiguration von **MedicApp** auf Ihrem Entwicklungssystem.

---

## Inhaltsverzeichnis

- [Systemanforderungen](#systemanforderungen)
- [Installation der Entwicklungsumgebung](#installation-der-entwicklungsumgebung)
- [Repository-Konfiguration](#repository-konfiguration)
- [Abhängigkeiten installieren](#abhängigkeiten-installieren)
- [Anwendung ausführen](#anwendung-ausführen)
- [Tests ausführen](#tests-ausführen)
- [Häufige Probleme](#häufige-probleme)

---

## Systemanforderungen

### Minimum
- **Flutter**: 3.9.2 oder höher
- **Dart**: 3.0 oder höher
- **Android SDK**: API Level 21 (Android 5.0) oder höher
- **iOS**: 11.0 oder höher (für iOS-Entwicklung)
- **Speicher**: Mindestens 8 GB RAM
- **Festplattenspeicher**: 10 GB frei

### Empfohlen
- **Flutter**: Neueste stabile Version
- **Android Studio**: Neueste Version mit Flutter-Plugin
- **VS Code**: Mit Flutter- und Dart-Erweiterungen
- **Speicher**: 16 GB RAM oder mehr
- **Festplattenspeicher**: 20 GB frei

---

## Installation der Entwicklungsumgebung

### 1. Flutter installieren

#### Windows
```bash
# Flutter SDK herunterladen
# Von https://docs.flutter.dev/get-started/install/windows

# Zum PATH hinzufügen
setx PATH "%PATH%;C:\path\to\flutter\bin"

# Installation verifizieren
flutter doctor
```

#### macOS
```bash
# Mit Homebrew installieren
brew install flutter

# Oder manuell herunterladen
# Von https://docs.flutter.dev/get-started/install/macos

# Installation verifizieren
flutter doctor
```

#### Linux
```bash
# Flutter SDK herunterladen
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.9.2-stable.tar.xz

# Extrahieren
tar xf flutter_linux_3.9.2-stable.tar.xz

# Zum PATH hinzufügen
export PATH="$PATH:`pwd`/flutter/bin"

# Installation verifizieren
flutter doctor
```

### 2. IDE konfigurieren

#### Android Studio
```bash
1. Android Studio von https://developer.android.com/studio herunterladen
2. Installieren und Android SDK einrichten
3. Flutter-Plugin installieren:
   - File > Settings > Plugins
   - Nach "Flutter" suchen und installieren
   - Android Studio neu starten
```

#### VS Code
```bash
1. VS Code von https://code.visualstudio.com/ herunterladen
2. Dart-Erweiterung installieren
3. Flutter-Erweiterung installieren
4. Dart SDK-Pfad konfigurieren
```

### 3. Android SDK konfigurieren

```bash
# SDK-Manager öffnen
flutter doctor --android-licenses

# Alle Lizenzen akzeptieren
# 'y' eingeben, wenn dazu aufgefordert wird

# Installation verifizieren
flutter doctor -v
```

---

## Repository-Konfiguration

### 1. Repository klonen

```bash
# Mit HTTPS
git clone https://github.com/IhrBenutzername/medicapp.git

# Oder mit SSH
git clone git@github.com:IhrBenutzername/medicapp.git

# Zum Projektverzeichnis wechseln
cd medicapp
```

### 2. Branch verifizieren

```bash
# Aktuellen Branch prüfen
git branch

# Zum Entwicklungs-Branch wechseln (falls erforderlich)
git checkout development

# Branch-Status prüfen
git status
```

### 3. Repository aktualisieren

```bash
# Neueste Änderungen abrufen
git pull origin development

# Branch-Liste aktualisieren
git fetch --all
```

---

## Abhängigkeiten installieren

### 1. Flutter-Pakete

```bash
# Alle Abhängigkeiten installieren
flutter pub get

# Pub Cache verifizieren
flutter pub cache repair

# Veraltete Pakete prüfen
flutter pub outdated
```

### 2. Native Abhängigkeiten

#### Android
```bash
# Gradle-Cache bereinigen (falls erforderlich)
cd android
./gradlew clean

# Zurück zum Stammverzeichnis
cd ..
```

#### iOS (nur macOS)
```bash
# CocoaPods installieren (falls nicht installiert)
sudo gem install cocoapods

# Pods installieren
cd ios
pod install

# Zurück zum Stammverzeichnis
cd ..
```

### 3. Code-Generierung

```bash
# Falls das Projekt codegen verwendet
flutter pub run build_runner build

# Oder im Watch-Modus
flutter pub run build_runner watch
```

---

## Anwendung ausführen

### 1. Verfügbare Geräte prüfen

```bash
# Alle verfügbaren Geräte auflisten
flutter devices

# Beispielausgabe:
# Android SDK built for x86 (mobile) • emulator-5554 • android-x86
# iPhone 14 Pro Max (mobile) • iOS Simulator • ios
```

### 2. Anwendung ausführen

```bash
# Auf Standard-Gerät ausführen
flutter run

# Auf spezifischem Gerät ausführen
flutter run -d <device-id>

# Im Release-Modus ausführen
flutter run --release

# Im Profile-Modus ausführen (für Performance-Profiling)
flutter run --profile
```

### 3. Hot Reload verwenden

```bash
# Während die App läuft:
# - 'r' drücken für Hot Reload
# - 'R' drücken für Hot Restart
# - 'q' drücken zum Beenden
```

---

## Tests ausführen

### 1. Alle Tests ausführen

```bash
# Alle Tests ausführen
flutter test

# Mit ausführlicher Ausgabe
flutter test --verbose

# Spezifische Testdatei ausführen
flutter test test/path/to/test_file.dart
```

### 2. Abdeckungsbericht generieren

```bash
# Tests mit Abdeckung ausführen
flutter test --coverage

# HTML-Bericht generieren (erfordert lcov)
genhtml coverage/lcov.info -o coverage/html

# Bericht im Browser öffnen
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
start coverage/html/index.html  # Windows
```

### 3. Tests nach Typ

```bash
# Nur Unit-Tests
flutter test test/unit/

# Nur Widget-Tests
flutter test test/widget/

# Nur Integrationstests
flutter test test/integration/

# Spezifischer Testordner
flutter test test/models/
```

---

## Häufige Probleme

### 1. Flutter Doctor-Probleme

```bash
Problem: "Android licenses not accepted"
Lösung:
flutter doctor --android-licenses
# Alle Lizenzen mit 'y' akzeptieren
```

```bash
Problem: "Flutter SDK not found"
Lösung:
# PATH verifizieren
echo $PATH  # Linux/macOS
echo %PATH%  # Windows

# Flutter-Pfad hinzufügen
export PATH="$PATH:/pfad/zu/flutter/bin"  # Linux/macOS
setx PATH "%PATH%;C:\pfad\zu\flutter\bin"  # Windows
```

### 2. Abhängigkeitsprobleme

```bash
Problem: "pub get failed"
Lösung:
# Cache bereinigen
flutter pub cache clean
flutter pub cache repair

# Abhängigkeiten neu installieren
rm pubspec.lock
flutter pub get
```

```bash
Problem: "Version solving failed"
Lösung:
# Dart/Flutter-Version prüfen
flutter --version
dart --version

# Auf kompatible Version aktualisieren
flutter upgrade

# Falls nötig, pubspec.yaml anpassen
```

### 3. Build-Probleme

```bash
Problem: "Gradle build failed"
Lösung:
# Gradle-Cache bereinigen
cd android
./gradlew clean
./gradlew --stop

# Zurück zum Stammverzeichnis und erneut ausführen
cd ..
flutter clean
flutter pub get
flutter run
```

```bash
Problem: "CocoaPods install failed" (iOS)
Lösung:
# CocoaPods-Cache bereinigen
cd ios
pod cache clean --all
pod deintegrate
pod install

# Zurück zum Stammverzeichnis
cd ..
flutter clean
flutter run
```

### 4. Emulator-Probleme

```bash
Problem: "No devices available"
Lösung:
# Android-Emulator erstellen
flutter emulator --create

# Verfügbare Emulatoren auflisten
flutter emulators

# Emulator starten
flutter emulators --launch <emulator-id>
```

```bash
Problem: "iOS Simulator not found"
Lösung:
# Xcode-Tools installieren (nur macOS)
xcode-select --install

# Simulator über Xcode öffnen
open -a Simulator
```

### 5. Performance-Probleme

```bash
Problem: "Slow compilation"
Lösung:
# Gradle Daemon aktivieren
echo "org.gradle.daemon=true" >> android/gradle.properties

# Build-Cache erhöhen
echo "org.gradle.caching=true" >> android/gradle.properties

# Parallele Builds aktivieren
echo "org.gradle.parallel=true" >> android/gradle.properties
```

```bash
Problem: "Hot reload not working"
Lösung:
# Hot Restart versuchen (R)
# Oder App komplett neu starten
flutter run
```

---

## Nächste Schritte

Nach erfolgreicher Installation:

1. Lesen Sie die **[Funktionsdokumentation](features.md)**, um alle Funktionen zu verstehen
2. Konsultieren Sie die **[Architekturdokumentation](architecture.md)**, um die Projektstruktur zu verstehen
3. Lesen Sie die **[Beitragsleitfäden](contributing.md)**, falls Sie zum Projekt beitragen möchten
4. Konsultieren Sie die **[Fehlerbehebung](troubleshooting.md)** bei weiteren Problemen

---

## Zusätzliche Ressourcen

- **[Offizielle Flutter-Dokumentation](https://docs.flutter.dev/)**
- **[Dart-Dokumentation](https://dart.dev/guides)**
- **[Material Design 3](https://m3.material.io/)**
- **[SQLite-Dokumentation](https://www.sqlite.org/docs.html)**
- **[Provider Package](https://pub.dev/packages/provider)**

---

**Bei Problemen konsultieren Sie die [Fehlerbehebungsdokumentation](troubleshooting.md) oder öffnen Sie ein Issue im Repository.**
