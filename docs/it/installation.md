# Guida all'Installazione di MedicApp

Questa guida completa ti aiuterà a configurare l'ambiente di sviluppo ed eseguire MedicApp sul tuo sistema.

---

## 1. Requisiti Preliminari

### 1.1 Sistema Operativo

MedicApp è compatibile con i seguenti sistemi operativi:

- **Android:** 6.0 (API 23) o superiore
- **iOS:** 12.0 o superiore (richiede macOS per lo sviluppo)
- **Sviluppo:**
  - Windows 10/11 (64-bit)
  - macOS 10.14 o superiore
  - Linux (64-bit)

### 1.2 Flutter SDK

**Versione richiesta:** Flutter 3.9.2 o superiore

Verifica se hai già Flutter installato:

```bash
flutter --version
```

Se la versione è inferiore a 3.9.2, dovrai aggiornare:

```bash
flutter upgrade
```

### 1.3 Dart SDK

Il Dart SDK è incluso con Flutter. La versione richiesta è:

- **Dart SDK:** 3.9.2 o superiore

### 1.4 Editor di Codice Consigliato

Si consiglia di utilizzare uno dei seguenti editor:

#### Visual Studio Code (Consigliato)
- **Scarica:** https://code.visualstudio.com/
- **Estensioni necessarie:**
  - Flutter (Dart Code)
  - Dart

#### Android Studio
- **Scarica:** https://developer.android.com/studio
- **Plugin necessari:**
  - Flutter
  - Dart

### 1.5 Git

Necessario per clonare il repository:

- **Git 2.x o superiore**
- **Scarica:** https://git-scm.com/downloads

Verifica l'installazione:

```bash
git --version
```

### 1.6 Strumenti Aggiuntivi per Piattaforma

#### Per sviluppo Android:
- **Android SDK** (incluso con Android Studio)
- **Android SDK Platform-Tools**
- **Android SDK Build-Tools**
- **Java JDK 11** (incluso con Android Studio)

#### Per sviluppo iOS (solo macOS):
- **Xcode 13.0 o superiore**
- **CocoaPods:**
  ```bash
  sudo gem install cocoapods
  ```

---

## 2. Installazione di Flutter SDK

### 2.1 Windows

1. Scarica il Flutter SDK:
   - Visita: https://docs.flutter.dev/get-started/install/windows
   - Scarica il file ZIP di Flutter

2. Estrai il file in una posizione permanente (es: `C:\src\flutter`)

3. Aggiungi Flutter alle variabili d'ambiente PATH:
   - Cerca "Variabili d'ambiente" nel menu start
   - Modifica la variabile PATH dell'utente
   - Aggiungi il percorso: `C:\src\flutter\bin`

4. Verifica l'installazione:
   ```bash
   flutter doctor
   ```

### 2.2 macOS

1. Scarica il Flutter SDK:
   ```bash
   cd ~/development
   curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.9.2-stable.zip
   unzip flutter_macos_3.9.2-stable.zip
   ```

2. Aggiungi Flutter al PATH modificando `~/.zshrc` o `~/.bash_profile`:
   ```bash
   export PATH="$PATH:$HOME/development/flutter/bin"
   ```

3. Ricarica la configurazione:
   ```bash
   source ~/.zshrc
   ```

4. Verifica l'installazione:
   ```bash
   flutter doctor
   ```

### 2.3 Linux

1. Scarica il Flutter SDK:
   ```bash
   cd ~/development
   wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.9.2-stable.tar.xz
   tar xf flutter_linux_3.9.2-stable.tar.xz
   ```

2. Aggiungi Flutter al PATH modificando `~/.bashrc` o `~/.zshrc`:
   ```bash
   export PATH="$PATH:$HOME/development/flutter/bin"
   ```

3. Ricarica la configurazione:
   ```bash
   source ~/.bashrc
   ```

4. Verifica l'installazione:
   ```bash
   flutter doctor
   ```

### 2.4 Verifica Completa dell'Ambiente

Esegui il comando Flutter Doctor per identificare componenti mancanti:

```bash
flutter doctor -v
```

Risolvi qualsiasi problema indicato con un [✗] prima di continuare.

---

## 3. Clonazione del Repository

1. Apri un terminale nella directory dove desideri clonare il progetto

2. Clona il repository:
   ```bash
   git clone <repository-url>
   ```

3. Naviga nella directory del progetto:
   ```bash
   cd medicapp
   ```

4. Verifica di essere sul branch corretto:
   ```bash
   git branch
   ```

---

## 4. Installazione delle Dipendenze

### 4.1 Dipendenze di Flutter

Installa tutte le dipendenze del progetto:

```bash
flutter pub get
```

Questo comando installerà le seguenti dipendenze principali:

- **sqflite:** ^2.3.0 - Database SQLite locale
- **flutter_local_notifications:** ^19.5.0 - Sistema di notifiche
- **timezone:** ^0.10.1 - Gestione dei fusi orari
- **intl:** ^0.20.2 - Internazionalizzazione
- **android_intent_plus:** ^6.0.0 - Intent di Android
- **shared_preferences:** ^2.2.2 - Archiviazione chiave-valore
- **file_picker:** ^8.0.0+1 - Selettore di file
- **share_plus:** ^10.1.4 - Condivisione di file
- **path_provider:** ^2.1.5 - Accesso alle directory di sistema
- **uuid:** ^4.0.0 - Generazione di ID univoci

### 4.2 Dipendenze Specifiche per Piattaforma

#### Android

Non sono richiesti passaggi aggiuntivi. Le dipendenze di Android verranno scaricate automaticamente alla prima compilazione.

#### iOS (solo macOS)

Installa le dipendenze di CocoaPods:

```bash
cd ios
pod install
cd ..
```

Se incontri errori, prova ad aggiornare il repository di CocoaPods:

```bash
cd ios
pod repo update
pod install
cd ..
```

---

## 5. Configurazione dell'Ambiente

### 5.1 Variabili d'Ambiente

MedicApp non richiede variabili d'ambiente speciali per essere eseguita in sviluppo.

### 5.2 Permessi di Android

Il file `android/app/src/main/AndroidManifest.xml` include già i permessi necessari:

```xml
<!-- Permessi per le notifiche -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
```

**Importante per Android 13+ (API 33+):**

Gli utenti dovranno concedere il permesso per le notifiche a runtime. L'applicazione richiederà questo permesso automaticamente al primo avvio.

**Allarmi esatti (Android 12+):**

Per programmare notifiche precise, gli utenti devono abilitare "Allarmi e promemoria" nelle impostazioni del sistema:
- Impostazioni > App > MedicApp > Allarmi e promemoria > Attiva

### 5.3 Configurazione iOS

#### Permessi in Info.plist

Se stai sviluppando per iOS, assicurati che `ios/Runner/Info.plist` contenga:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

#### Capacità delle Notifiche

Le notifiche sono configurate automaticamente dal plugin `flutter_local_notifications`.

---

## 6. Esecuzione in Sviluppo

### 6.1 Elencare i Dispositivi Disponibili

Prima di eseguire l'applicazione, elenca i dispositivi connessi:

```bash
flutter devices
```

Questo mostrerà:
- Dispositivi Android connessi tramite USB
- Emulatori Android disponibili
- Simulatori iOS (solo macOS)
- Browser web disponibili

### 6.2 Avviare un Emulatore/Simulatore

#### Android Emulator:
```bash
flutter emulators
flutter emulators --launch <emulator-id>
```

#### iOS Simulator (solo macOS):
```bash
open -a Simulator
```

### 6.3 Eseguire l'Applicazione

#### Modalità Debug (predefinita):
```bash
flutter run
```

Questa modalità include:
- Hot reload (ricaricamento a caldo)
- Hot restart (riavvio a caldo)
- Debugging completo
- Prestazioni più lente

**Scorciatoie utili durante l'esecuzione:**
- `r` - Hot reload (ricarica il codice modificato)
- `R` - Hot restart (riavvia l'applicazione completa)
- `q` - Esci dall'applicazione

#### Modalità Release:
```bash
flutter run --release
```

Questa modalità include:
- Prestazioni ottimizzate
- Senza debugging
- Dimensione ridotta

#### Modalità Profile:
```bash
flutter run --profile
```

Questa modalità è utile per:
- Analisi delle prestazioni
- Debugging delle prestazioni
- Strumenti timeline

### 6.4 Eseguire su un Dispositivo Specifico

Se hai più dispositivi connessi:

```bash
flutter run -d <device-id>
```

Esempio:
```bash
flutter run -d emulator-5554
flutter run -d "iPhone 14 Pro"
```

### 6.5 Eseguire con Log Dettagliati

Per vedere log più dettagliati:

```bash
flutter run -v
```

---

## 7. Esecuzione dei Test

MedicApp include una suite completa di test con più di 432 prove.

### 7.1 Eseguire Tutti i Test

```bash
flutter test
```

### 7.2 Eseguire un Test Specifico

```bash
flutter test test/nome_del_file_test.dart
```

Esempi:
```bash
flutter test test/settings_screen_test.dart
flutter test test/notification_actions_test.dart
flutter test test/multiple_fasting_prioritization_test.dart
```

### 7.3 Eseguire Test con Copertura

Per generare un report di copertura del codice:

```bash
flutter test --coverage
```

Il report verrà generato in `coverage/lcov.info`.

### 7.4 Visualizzare il Report di Copertura

Per visualizzare il report di copertura in HTML:

```bash
# Installare lcov (Linux/macOS)
sudo apt-get install lcov  # Linux
brew install lcov          # macOS

# Generare report HTML
genhtml coverage/lcov.info -o coverage/html

# Aprire il report
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
start coverage/html/index.html  # Windows
```

### 7.5 Eseguire Test con Log Dettagliati

```bash
flutter test --verbose
```

---

## 8. Build per Produzione

### 8.1 Android

#### APK (per distribuzione diretta):

```bash
flutter build apk --release
```

L'APK verrà generato in: `build/app/outputs/flutter-apk/app-release.apk`

#### APK Split per ABI (riduce dimensione):

```bash
flutter build apk --split-per-abi --release
```

Questo genera più APK ottimizzati:
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM)
- `app-x86_64-release.apk` (64-bit Intel)

#### App Bundle (per Google Play Store):

```bash
flutter build appbundle --release
```

L'App Bundle verrà generato in: `build/app/outputs/bundle/release/app-release.aab`

**Vantaggi dell'App Bundle:**
- Dimensione di download ottimizzata
- Google Play genera APK specifici per ogni dispositivo
- Richiesto per le nuove applicazioni nel Play Store

#### Configurazione della Firma per Android

Per build di produzione, devi configurare la firma dell'applicazione:

1. Genera un keystore:
   ```bash
   keytool -genkey -v -keystore ~/medicapp-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias medicapp
   ```

2. Crea il file `android/key.properties`:
   ```properties
   storePassword=<tua-password>
   keyPassword=<tua-password>
   keyAlias=medicapp
   storeFile=/percorso/a/medicapp-release-key.jks
   ```

3. Aggiorna `android/app/build.gradle.kts` per utilizzare il keystore (già configurato nel progetto).

**IMPORTANTE:** Non includere `key.properties` né il file `.jks` nel controllo versioni.

### 8.2 iOS (solo macOS)

#### Build per Testing:

```bash
flutter build ios --release
```

#### Build per App Store:

```bash
flutter build ipa --release
```

Il file IPA verrà generato in: `build/ios/ipa/medicapp.ipa`

#### Configurazione della Firma per iOS

1. Apri il progetto in Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. Configura il team di firma:
   - Seleziona il progetto "Runner" nel navigatore
   - Vai a "Signing & Capabilities"
   - Seleziona il tuo team di sviluppo Apple
   - Configura un Bundle Identifier univoco

3. Crea un profilo di provisioning in Apple Developer

4. Archivia e distribuisci da Xcode:
   - Product > Archive
   - Window > Organizer
   - Distribute App

---

## 9. Troubleshooting Comune

### 9.1 Problemi con le Dipendenze

#### Errore: "Pub get failed"

**Soluzione:**
```bash
flutter clean
flutter pub get
```

#### Errore: "Version solving failed"

**Soluzione:**
```bash
# Aggiornare Flutter
flutter upgrade

# Pulire cache
flutter pub cache repair

# Reinstallare dipendenze
flutter clean
flutter pub get
```

#### Errore: "CocoaPods not installed" (iOS)

**Soluzione:**
```bash
sudo gem install cocoapods
pod setup
```

### 9.2 Problemi con i Permessi

#### Android: Le notifiche non funzionano

**Verificare:**
1. Il permesso POST_NOTIFICATIONS è in AndroidManifest.xml
2. L'utente ha concesso i permessi per le notifiche in Android 13+
3. Gli allarmi esatti sono abilitati nelle Impostazioni

**Soluzione programmatica:**
L'app richiede i permessi automaticamente. Se l'utente li ha negati:
```dart
// L'app include un pulsante per aprire le impostazioni
// Impostazioni > Permessi > Notifiche
```

#### Android: Gli allarmi esatti non funzionano

**Sintomi:**
- Le notifiche arrivano in ritardo
- Le notifiche non arrivano all'ora esatta

**Soluzione:**
1. Apri Impostazioni del sistema
2. App > MedicApp > Allarmi e promemoria
3. Attiva l'opzione

L'app include un pulsante di aiuto che indirizza l'utente a questa configurazione.

### 9.3 Problemi con il Database

#### Errore: "Database locked" o "Cannot open database"

**Causa:** Il database SQLite è accessibile da più processi.

**Soluzione:**
```bash
# Reinstallare l'applicazione
flutter clean
flutter run
```

#### Errore: Le migrazioni del database falliscono

**Verificare:**
1. Il numero di versione del database in `database_helper.dart`
2. Gli script di migrazione sono completi

**Soluzione:**
```bash
# Disinstallare l'applicazione dal dispositivo
adb uninstall com.medicapp.medicapp  # Android
# Reinstallare
flutter run
```

### 9.4 Problemi con le Notifiche

#### Le notifiche non vengono riprogrammate dopo il riavvio

**Verificare:**
1. Il permesso RECEIVE_BOOT_COMPLETED è in AndroidManifest.xml
2. Il receiver di boot è registrato

**Soluzione:**
Il file `AndroidManifest.xml` include già la configurazione necessaria:
```xml
<receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver"
    android:exported="false">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
    </intent-filter>
</receiver>
```

#### Le notifiche non emettono suono/vibrazione

**Verificare:**
1. Il volume del dispositivo non è silenzioso
2. La modalità "Non disturbare" è disattivata
3. I permessi di vibrazione sono concessi

### 9.5 Problemi di Compilazione

#### Errore: "Gradle build failed"

**Soluzione:**
```bash
# Pulire progetto
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

#### Errore: "Execution failed for task ':app:processDebugResources'"

**Causa:** Risorse duplicate o conflitti.

**Soluzione:**
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter run
```

#### Errore: SDK version mismatch

**Verificare:**
1. La versione di Flutter: `flutter --version`
2. Il file `pubspec.yaml` richiede: `sdk: ^3.9.2`

**Soluzione:**
```bash
flutter upgrade
flutter doctor
```

### 9.6 Problemi di Prestazioni

#### L'applicazione è lenta in modalità debug

**Spiegazione:**
Questo è normale. La modalità debug include strumenti di sviluppo che riducono le prestazioni.

**Soluzione:**
Prova in modalità release per valutare le prestazioni reali:
```bash
flutter run --release
```

#### Hot reload non funziona

**Soluzione:**
```bash
# Riavvia l'applicazione
# Nel terminale dove hai eseguito 'flutter run', premi:
R  # (maiuscolo) per hot restart
```

### 9.7 Problemi di Connettività dei Dispositivi

#### Il dispositivo non appare in `flutter devices`

**Android:**
```bash
# Verificare connessione ADB
adb devices

# Riavviare server ADB
adb kill-server
adb start-server

# Verificare di nuovo
flutter devices
```

**iOS:**
```bash
# Verificare dispositivi connessi
instruments -s devices

# Fidarsi del computer dal dispositivo iOS
```

---

## 10. Risorse Aggiuntive

### Documentazione Ufficiale

- **Flutter:** https://docs.flutter.dev/
- **Dart:** https://dart.dev/guides
- **Material Design 3:** https://m3.material.io/

### Plugin Utilizzati

- **sqflite:** https://pub.dev/packages/sqflite
- **flutter_local_notifications:** https://pub.dev/packages/flutter_local_notifications
- **timezone:** https://pub.dev/packages/timezone
- **intl:** https://pub.dev/packages/intl

### Comunità e Supporto

- **Flutter Community:** https://flutter.dev/community
- **Stack Overflow:** https://stackoverflow.com/questions/tagged/flutter
- **GitHub Issues:** (Repository del progetto)

---

## 11. Prossimi Passi

Una volta completata l'installazione:

1. **Esplora il codice:**
   - Rivedi la struttura del progetto in `lib/`
   - Esamina i test in `test/`

2. **Esegui l'applicazione:**
   ```bash
   flutter run
   ```

3. **Esegui i test:**
   ```bash
   flutter test
   ```

4. **Leggi la documentazione aggiuntiva:**
   - [README.md](../README.md)
   - [Architettura del Progetto](architecture.md) (se esiste)
   - [Guida al Contributo](contributing.md) (se esiste)

---

## Contatto e Aiuto

Se incontri problemi non trattati in questa guida, per favore:

1. Rivedi le issue esistenti nel repository
2. Esegui `flutter doctor -v` e condividi il risultato
3. Includi i log completi dell'errore
4. Descrivi i passaggi per riprodurre il problema

---

**Ultimo aggiornamento:** Novembre 2024
**Versione del documento:** 1.0.0
**Versione di MedicApp:** 1.0.0+1
