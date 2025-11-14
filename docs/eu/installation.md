# MedicApp Instalazio Gida

Gida oso honek garapen ingurunea konfiguratu eta MedicApp zure sisteman exekutatzeko lagunduko dizu.

---

## 1. Aurretiazko Eskakizunak

### 1.1 Sistema Eragilea

MedicApp sistema eragile hauekin bateragarria da:

- **Android:** 6.0 (API 23) edo berriagoa
- **iOS:** 12.0 edo berriagoa (macOS behar da garapenerako)
- **Garapena:**
  - Windows 10/11 (64-bit)
  - macOS 10.14 edo berriagoa
  - Linux (64-bit)

### 1.2 Flutter SDK

**Beharrezko bertsioa:** Flutter 3.9.2 edo berriagoa

Egiaztatu ea Flutter instalatuta dagoen:

```bash
flutter --version
```

Bertsioa 3.9.2 baino txikiagoa bada, eguneratu beharko duzu:

```bash
flutter upgrade
```

### 1.3 Dart SDK

Dart SDK Flutter-ekin etortzen da. Beharrezko bertsioa:

- **Dart SDK:** 3.9.2 edo berriagoa

### 1.4 Gomendatutako Kode Editorea

Editore hauetako bat erabiltzea gomendatzen da:

#### Visual Studio Code (Gomendatua)
- **Deskargatu:** https://code.visualstudio.com/
- **Beharrezko hedapenak:**
  - Flutter (Dart Code)
  - Dart

#### Android Studio
- **Deskargatu:** https://developer.android.com/studio
- **Beharrezko pluginak:**
  - Flutter
  - Dart

### 1.5 Git

Biltegi hau klonatzeko beharrezkoa:

- **Git 2.x edo berriagoa**
- **Deskargatu:** https://git-scm.com/downloads

Egiaztatu instalazioa:

```bash
git --version
```

### 1.6 Plataformaren Araberako Tresna Gehigarriak

#### Android garapenerako:
- **Android SDK** (Android Studio-rekin dator)
- **Android SDK Platform-Tools**
- **Android SDK Build-Tools**
- **Java JDK 11** (Android Studio-rekin dator)

#### iOS garapenerako (macOS soilik):
- **Xcode 13.0 edo berriagoa**
- **CocoaPods:**
  ```bash
  sudo gem install cocoapods
  ```

---

## 2. Flutter SDK Instalazioa

### 2.1 Windows

1. Deskargatu Flutter SDK:
   - Bisitatu: https://docs.flutter.dev/get-started/install/windows
   - Deskargatu Flutter ZIP fitxategia

2. Atera fitxategia kokapen iraunkor batean (adib: `C:\src\flutter`)

3. Gehitu Flutter PATH ingurune aldagaietara:
   - Bilatu "Ingurune aldagaiak" hasiera menuan
   - Editatu erabiltzailearen PATH aldagaia
   - Gehitu bidea: `C:\src\flutter\bin`

4. Egiaztatu instalazioa:
   ```bash
   flutter doctor
   ```

### 2.2 macOS

1. Deskargatu Flutter SDK:
   ```bash
   cd ~/development
   curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.9.2-stable.zip
   unzip flutter_macos_3.9.2-stable.zip
   ```

2. Gehitu Flutter PATH-era `~/.zshrc` edo `~/.bash_profile` editatuz:
   ```bash
   export PATH="$PATH:$HOME/development/flutter/bin"
   ```

3. Birkargatu konfigurazioa:
   ```bash
   source ~/.zshrc
   ```

4. Egiaztatu instalazioa:
   ```bash
   flutter doctor
   ```

### 2.3 Linux

1. Deskargatu Flutter SDK:
   ```bash
   cd ~/development
   wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.9.2-stable.tar.xz
   tar xf flutter_linux_3.9.2-stable.tar.xz
   ```

2. Gehitu Flutter PATH-era `~/.bashrc` edo `~/.zshrc` editatuz:
   ```bash
   export PATH="$PATH:$HOME/development/flutter/bin"
   ```

3. Birkargatu konfigurazioa:
   ```bash
   source ~/.bashrc
   ```

4. Egiaztatu instalazioa:
   ```bash
   flutter doctor
   ```

### 2.4 Ingurunearen Egiaztapen Osoa

Exekutatu Flutter Doctor komandoa falta diren osagaiak identifikatzeko:

```bash
flutter doctor -v
```

Konpondu [✗] batekin adierazitako edozein arazo jarraitu aurretik.

---

## 3. Biltegi Klonazioa

1. Ireki terminal bat proiektua klonatu nahi duzun direktorioan

2. Klonatu biltegia:
   ```bash
   git clone <repository-url>
   ```

3. Nabigatu proiektuaren direktoriora:
   ```bash
   cd medicapp
   ```

4. Egiaztatu adar egokian zaudela:
   ```bash
   git branch
   ```

---

## 4. Mendekotasunen Instalazioa

### 4.1 Flutter Mendekotasunak

Instalatu proiektuaren mendekotasun guztiak:

```bash
flutter pub get
```

Komando honek mendekotasun nagusi hauek instalatuko ditu:

- **sqflite:** ^2.3.0 - SQLite datu-base lokala
- **flutter_local_notifications:** ^19.5.0 - Jakinarazpenen sistema
- **timezone:** ^0.10.1 - Ordu-zonaldeen kudeaketa
- **intl:** ^0.20.2 - Nazioartekotzea
- **android_intent_plus:** ^6.0.0 - Android intentak
- **shared_preferences:** ^2.2.2 - Gako-balio biltegiratzea
- **file_picker:** ^8.0.0+1 - Fitxategi hautatzailea
- **share_plus:** ^10.1.4 - Fitxategiak partekatzea
- **path_provider:** ^2.1.5 - Sistemako direktorioen sarbidea
- **uuid:** ^4.0.0 - ID bakarra sortzea

### 4.2 Plataformaren Araberako Mendekotasun Espezifikoak

#### Android

Ez dira urrats gehigarriak behar. Android mendekotasunak automatikoki deskargatuko dira lehen konpilazioan.

#### iOS (macOS soilik)

Instalatu CocoaPods mendekotasunak:

```bash
cd ios
pod install
cd ..
```

Erroreak aurkitzen badituzu, saiatu CocoaPods biltegia eguneratzen:

```bash
cd ios
pod repo update
pod install
cd ..
```

---

## 5. Ingurunearen Konfigurazioa

### 5.1 Ingurune Aldagaiak

MedicApp-ek ez du ingurune aldagai berezirik behar garapenean exekutatzeko.

### 5.2 Android Baimenak

`android/app/src/main/AndroidManifest.xml` fitxategiak beharrezko baimenak ditu jada:

```xml
<!-- Jakinarazpenetarako baimenak -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
```

**Android 13+ (API 33+) kontuan hartzekoa:**

Erabiltzaileek jakinarazpen baimena eman beharko dute exekuzio denboran. Aplikazioak baimena eskatuko du automatikoki lehen abiaraztean.

**Alarma zehatzak (Android 12+):**

Jakinarazpen zehatzak programatzeko, erabiltzaileek "Alarmak eta oroigarriak" gaitu behar dituzte sistemaren konfigurazioan:
- Ezarpenak > Aplikazioak > MedicApp > Alarmak eta oroigarriak > Aktibatu

### 5.3 iOS Konfigurazioa

#### Baimenak Info.plist fitxategian

iOS-erako garatzen baduzu, ziurtatu `ios/Runner/Info.plist`-k hau baduela:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

#### Jakinarazpenen Gaitasunak

Jakinarazpenak automatikoki konfiguratuta daude `flutter_local_notifications` pluginaren bidez.

---

## 6. Garapenean Exekuzioa

### 6.1 Zerrendatu Eskuragarri Dauden Gailuak

Aplikazioa exekutatu aurretik, zerrendatu konektatutako gailuak:

```bash
flutter devices
```

Honek erakutsiko ditu:
- USB bidez konektatutako Android gailuak
- Eskuragarri dauden Android emulatzaileak
- iOS simulatzaileak (macOS soilik)
- Eskuragarri dauden web nabigatzaileak

### 6.2 Abiarazi Emulatzaile/Simulatzailea

#### Android Emulator:
```bash
flutter emulators
flutter emulators --launch <emulator-id>
```

#### iOS Simulator (macOS soilik):
```bash
open -a Simulator
```

### 6.3 Exekutatu Aplikazioa

#### Debug Modua (lehenetsia):
```bash
flutter run
```

Modu honek honako hau ditu:
- Hot reload (berriz-karga beroan)
- Hot restart (berrabiarazi beroan)
- Debugging osoa
- Errendimendu motelagoa

**Exekuzio garaian tresna erabilgarriak:**
- `r` - Hot reload (aldatutako kodea birkargatu)
- `R` - Hot restart (aplikazio osoa berrabiarazi)
- `q` - Aplikaziotik irten

#### Release Modua:
```bash
flutter run --release
```

Modu honek honako hau ditu:
- Errendimendu optimizatua
- Debugging-ik gabe
- Tamaina murriztua

#### Profile Modua:
```bash
flutter run --profile
```

Modu hau erabilgarria da:
- Errendimendu analisia
- Errendimendu debugging-a
- Timeline tresnak

### 6.4 Exekutatu Gailu Espezifiko Batean

Gailu bat baino gehiago konektatuta badituzu:

```bash
flutter run -d <device-id>
```

Adibidea:
```bash
flutter run -d emulator-5554
flutter run -d "iPhone 14 Pro"
```

### 6.5 Exekutatu Log Xehakatuekin

Log xehakatuagoak ikusteko:

```bash
flutter run -v
```

---

## 7. Proba Exekuzioa

MedicApp-ek 432 proba baino gehiago dituen proba-suite oso bat ditu.

### 7.1 Exekutatu Proba Guztiak

```bash
flutter test
```

### 7.2 Exekutatu Proba Espezifiko Bat

```bash
flutter test test/fitxategi_izena_test.dart
```

Adibideak:
```bash
flutter test test/settings_screen_test.dart
flutter test test/notification_actions_test.dart
flutter test test/multiple_fasting_prioritization_test.dart
```

### 7.3 Exekutatu Probak Estaldurarekin

Kode estalduraren txosten bat sortzeko:

```bash
flutter test --coverage
```

Txostena `coverage/lcov.info` fitxategian sortuko da.

### 7.4 Ikusi Estaldura Txostena

Estaldura txostena HTML-n ikusteko:

```bash
# Instalatu lcov (Linux/macOS)
sudo apt-get install lcov  # Linux
brew install lcov          # macOS

# Sortu HTML txostena
genhtml coverage/lcov.info -o coverage/html

# Ireki txostena
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
start coverage/html/index.html  # Windows
```

### 7.5 Exekutatu Probak Log Xehakatuekin

```bash
flutter test --verbose
```

---

## 8. Produkziorako Build

### 8.1 Android

#### APK (banaketa zuzenerako):

```bash
flutter build apk --release
```

APK hau sortuko da: `build/app/outputs/flutter-apk/app-release.apk`

#### APK Split ABI-ren arabera (tamaina murriztu):

```bash
flutter build apk --split-per-abi --release
```

Honek hainbat APK optimizatu sortzen ditu:
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM)
- `app-x86_64-release.apk` (64-bit Intel)

#### App Bundle (Google Play Store-rako):

```bash
flutter build appbundle --release
```

App Bundle hau sortuko da: `build/app/outputs/bundle/release/app-release.aab`

**App Bundle-en abantailak:**
- Deskarga tamaina optimizatua
- Google Play-ek gailu bakoitzerako APK espezifikoak sortzen ditu
- Play Store-ko aplikazio berrientzat beharrezkoa

#### Android Sinadura Konfigurazioa

Produkzio builds-entzat, aplikazioaren sinadura konfiguratu behar duzu:

1. Sortu keystore bat:
   ```bash
   keytool -genkey -v -keystore ~/medicapp-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias medicapp
   ```

2. Sortu `android/key.properties` fitxategia:
   ```properties
   storePassword=<zure-pasahitza>
   keyPassword=<zure-pasahitza>
   keyAlias=medicapp
   storeFile=/bidea/medicapp-release-key.jks
   ```

3. Eguneratu `android/app/build.gradle.kts` keystore erabiltzeko (proiektuan konfiguratuta dago jada).

**GARRANTZITSUA:** Ez gehitu `key.properties` edo `.jks` fitxategia bertsio kontrolean.

### 8.2 iOS (macOS soilik)

#### Build Probarako:

```bash
flutter build ios --release
```

#### Build App Store-rako:

```bash
flutter build ipa --release
```

IPA fitxategia hemen sortuko da: `build/ios/ipa/medicapp.ipa`

#### iOS Sinadura Konfigurazioa

1. Ireki proiektua Xcode-n:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. Konfiguratu sinadura taldea:
   - Hautatu "Runner" proiektua nabigatzailean
   - Joan "Signing & Capabilities"-era
   - Hautatu zure Apple garapen taldea
   - Konfiguratu Bundle Identifier bakarra

3. Sortu hornidura profil bat Apple Developer-en

4. Artxibatu eta banatu Xcode-tik:
   - Product > Archive
   - Window > Organizer
   - Distribute App

---

## 9. Arazo Ohikoak Konpontzea

### 9.1 Mendekotasunekin Arazoak

#### Errorea: "Pub get failed"

**Konponbidea:**
```bash
flutter clean
flutter pub get
```

#### Errorea: "Version solving failed"

**Konponbidea:**
```bash
# Eguneratu Flutter
flutter upgrade

# Garbitu cachea
flutter pub cache repair

# Berrinstaluatu mendekotasunak
flutter clean
flutter pub get
```

#### Errorea: "CocoaPods not installed" (iOS)

**Konponbidea:**
```bash
sudo gem install cocoapods
pod setup
```

### 9.2 Baimenekin Arazoak

#### Android: Jakinarazpenek ez dute funtzionatzen

**Egiaztatu:**
1. POST_NOTIFICATIONS baimena AndroidManifest.xml-n dago
2. Erabiltzaileak jakinarazpen baimena eman du Android 13+ sisteman
3. Alarma zehatzak gaituta daude Ezarpenetan

**Konponbide programatikoa:**
Aplikazioak baimenak automatikoki eskatzen ditu. Erabiltzaileak ukatu baditu:
```dart
// Aplikazioak ezarpenak irekitzeko botoi bat du
// Ezarpenak > Baimenak > Jakinarazpenak
```

#### Android: Alarma zehatzak ez dira funtzionatzen

**Sintomak:**
- Jakinarazpenak berandutu iristen dira
- Jakinarazpenak ez dira ordu zehatzean iristen

**Konponbidea:**
1. Ireki sistemaren Ezarpenak
2. Aplikazioak > MedicApp > Alarmak eta oroigarriak
3. Aktibatu aukera

Aplikazioak erabiltzailea ezarpen honetara zuzenduko duen laguntza botoia dauka.

### 9.3 Datu-basearekin Arazoak

#### Errorea: "Database locked" edo "Cannot open database"

**Arrazoia:** SQLite datu-basea prozesu anitzek atzitzen ari dira.

**Konponbidea:**
```bash
# Berrinstaluatu aplikazioa
flutter clean
flutter run
```

#### Errorea: Datu-basearen migrazioak huts egiten dute

**Egiaztatu:**
1. Datu-basearen bertsio zenbakia `database_helper.dart`-en
2. Migrazio scriptak osoak dira

**Konponbidea:**
```bash
# Desinstalatu aplikazioa gailutik
adb uninstall com.medicapp.medicapp  # Android
# Berrinstaluatu
flutter run
```

### 9.4 Jakinarazpenekin Arazoak

#### Jakinarazpenak ez dira berrabiarazi ondoren berriz programatzen

**Egiaztatu:**
1. RECEIVE_BOOT_COMPLETED baimena AndroidManifest.xml-n dago
2. Boot receiver erregistratuta dago

**Konponbidea:**
`AndroidManifest.xml` fitxategiak beharrezko konfigurazioa dauka jada:
```xml
<receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver"
    android:exported="false">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
    </intent-filter>
</receiver>
```

#### Jakinarazpenek ez dute soinu/bibrazioa egiten

**Egiaztatu:**
1. Gailuaren bolumena ez dago isilik
2. "Ez molestatu" modua desaktibatuta dago
3. Bibrazio baimenak emanda daude

### 9.5 Konpilazio Arazoak

#### Errorea: "Gradle build failed"

**Konponbidea:**
```bash
# Garbitu proiektua
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

#### Errorea: "Execution failed for task ':app:processDebugResources'"

**Arrazoia:** Baliabide bikoiztuak edo gatazkak.

**Konponbidea:**
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter run
```

#### Errorea: SDK version mismatch

**Egiaztatu:**
1. Flutter bertsioa: `flutter --version`
2. `pubspec.yaml` fitxategiak eskatzen du: `sdk: ^3.9.2`

**Konponbidea:**
```bash
flutter upgrade
flutter doctor
```

### 9.6 Errendimendu Arazoak

#### Aplikazioa motela da debug moduan

**Azalpena:**
Hau normala da. Debug moduak garapenerako tresnak ditu errendimendua murrizten dutenak.

**Konponbidea:**
Probatu release moduan benetako errendimendua ebaluatzeko:
```bash
flutter run --release
```

#### Hot reload ez da funtzionatzen

**Konponbidea:**
```bash
# Berrabiarazi aplikazioa
# 'flutter run' exekutatu duzun terminalean, sakatu:
R  # (maiuskulaz) hot restart-erako
```

### 9.7 Gailuen Konektibitate Arazoak

#### Gailua ez da agertzen `flutter devices`-en

**Android:**
```bash
# Egiaztatu ADB konexioa
adb devices

# Berrabiarazi ADB zerbitzaria
adb kill-server
adb start-server

# Egiaztatu berriro
flutter devices
```

**iOS:**
```bash
# Egiaztatu konektatutako gailuak
instruments -s devices

# Fidatu ordenagailuan iOS gailutik
```

---

## 10. Baliabide Gehigarriak

### Dokumentazio Ofiziala

- **Flutter:** https://docs.flutter.dev/
- **Dart:** https://dart.dev/guides
- **Material Design 3:** https://m3.material.io/

### Erabilitako Pluginak

- **sqflite:** https://pub.dev/packages/sqflite
- **flutter_local_notifications:** https://pub.dev/packages/flutter_local_notifications
- **timezone:** https://pub.dev/packages/timezone
- **intl:** https://pub.dev/packages/intl

### Komunitatea eta Laguntza

- **Flutter Community:** https://flutter.dev/community
- **Stack Overflow:** https://stackoverflow.com/questions/tagged/flutter
- **GitHub Issues:** (Proiektuaren biltegia)

---

## 11. Hurrengo Pausuak

Instalazioa osatu ondoren:

1. **Arakatu kodea:**
   - Berrikusi proiektuaren egitura `lib/`-en
   - Aztertu probak `test/`-en

2. **Exekutatu aplikazioa:**
   ```bash
   flutter run
   ```

3. **Exekutatu probak:**
   ```bash
   flutter test
   ```

4. **Irakurri dokumentazio gehigarria:**
   - [README.md](../README.md)
   - [Proiektuaren Arkitektura](architecture.md) (badago)
   - [Ekarpen Gida](contributing.md) (badago)

---

## Kontaktua eta Laguntza

Gida honetan landuta ez dauden arazoak aurkitzen badituzu, mesedez:

1. Berrikusi biltegiko issue-ak
2. Exekutatu `flutter doctor -v` eta partekatu emaitza
3. Gehitu errorearen log osoak
4. Deskribatu arazoa erreproduzitzeko pausuak

---

**Azken eguneraketa:** 2024ko azaroa
**Dokumentuaren bertsioa:** 1.0.0
**MedicApp bertsioa:** 1.0.0+1
