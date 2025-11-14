# Arazo Konpontze Gida

## Sarrera

### Dokumentuaren Helburua

Gida honek MedicApp-en garapena, konpilazioa eta erabileran gerta daitezkeen ohiko arazoen konponbideak eskaintzen ditu. Garatzaile eta erabiltzaileei arazoak modu azkar eta eraginkorrean konpontzen laguntzeko diseinatuta dago.

### Gida Hau Nola Erabili

1. Identifikatu zure arazoaren kategoria indizean
2. Irakurri arazoaren deskribapena zure egoerarekin bat datorren egiaztatzeko
3. Jarraitu konponbide pausoak ordenan
4. Arazoa jarraitzen badu, kontsultatu "Laguntza Lortu" atala

---

## Instalazio Arazoak

### Flutter SDK Ez Da Aurkitu

**Deskribapena**: Flutter komandoak exekutatzean, "flutter: command not found" errorea agertzen da.

**Agian kausa**: Flutter ez dago instalatuta edo ez dago sistemaren PATH-ean.

**Konponbidea**:

1. Egiaztatu Flutter instalatuta dagoen:
```bash
which flutter
```

2. Ez badago instalatuta, deskargatu Flutter [flutter.dev](https://flutter.dev)-etik

3. Gehitu Flutter PATH-era:
```bash
# ~/.bashrc, ~/.zshrc edo antzekoan
export PATH="$PATH:/bidea/flutter-ra/bin"
```

4. Berrabiarazi zure terminala eta egiaztatu:
```bash
flutter --version
```

**Erreferentziak**: [Flutter-en instalazio dokumentazioa](https://docs.flutter.dev/get-started/install)

---

### Flutter Bertsio Okerra

**Deskribapena**: Instalatutako Flutter bertsioa ez dator bat proiektuaren eskakizunekin.

**Agian kausa**: MedicApp-ek Flutter 3.24.5 edo berriagoa eskatzen du.

**Konponbidea**:

1. Egiaztatu zure uneko bertsioa:
```bash
flutter --version
```

2. Eguneratu Flutter:
```bash
flutter upgrade
```

3. Bertsio espezifiko bat behar baduzu, erabili FVM:
```bash
dart pub global activate fvm
fvm install 3.24.5
fvm use 3.24.5
```

4. Egiaztatu bertsioa eguneratu ondoren:
```bash
flutter --version
```

---

### flutter pub get Arazoak

**Deskribapena**: Errorea mendekotasunak `flutter pub get`-ekin deskargatzean.

**Agian kausa**: Sare arazoak, cache hondatua edo bertsio gatazkak.

**Konponbidea**:

1. Garbitu pub cache-a:
```bash
flutter pub cache repair
```

2. Ezabatu pubspec.lock fitxategia:
```bash
rm pubspec.lock
```

3. Saiatu berriz:
```bash
flutter pub get
```

4. Jarraitzen badu, egiaztatu internet konexioa eta proxy-a:
```bash
# Konfiguratu proxy-a beharrezkoa bada
export HTTP_PROXY=http://proxy.example.com:8080
export HTTPS_PROXY=http://proxy.example.com:8080
```

---

### CocoaPods Arazoak (iOS)

**Deskribapena**: CocoaPods-ekin erlazionatutako erroreak iOS konpilazioan.

**Agian kausa**: CocoaPods zaharkituta edo cache hondatua.

**Konponbidea**:

1. Eguneratu CocoaPods:
```bash
sudo gem install cocoapods
```

2. Garbitu pods cache-a:
```bash
cd ios
rm -rf Pods Podfile.lock
pod cache clean --all
```

3. Berriz instalatu pods-ak:
```bash
pod install --repo-update
```

4. Jarraitzen badu, eguneratu specs-en biltegi:
```bash
pod repo update
```

**Erreferentziak**: [CocoaPods Guides](https://guides.cocoapods.org/using/troubleshooting.html)

---

### Gradle Arazoak (Android)

**Deskribapena**: Gradle-rekin erlazionatutako konpilazio erroreak Android-en.

**Agian kausa**: Gradle cache hondatua edo konfigurazio okerra.

**Konponbidea**:

1. Garbitu proiektua:
```bash
cd android
./gradlew clean
```

2. Garbitu Gradle cache-a:
```bash
./gradlew cleanBuildCache
rm -rf ~/.gradle/caches/
```

3. Sinkronizatu proiektua:
```bash
./gradlew --refresh-dependencies
```

4. Baliogabetu cache-a Android Studio-n:
   - File > Invalidate Caches / Restart

---

## Konpilazio Arazoak

### Mendekotasun Erroreak

**Deskribapena**: Pakete bertsioen arteko gatazkak edo mendekotasunak falta.

**Agian kausa**: Bertsio bateraezinen pubspec.yaml-en edo mendekotasun iragankorrekin gatazketan.

**Konponbidea**:

1. Egiaztatu pubspec.yaml fitxategia gatazkan dauden bertsio mugaketak ikusteko

2. Erabili mendekotasun-analisi komandoa:
```bash
flutter pub deps
```

3. Konpondu gatazkak bertsio bateragarriak zehaztuz:
```yaml
dependency_overrides:
  conflicting_package: ^1.0.0
```

4. Eguneratu mendekotasun guztiak bertsio bateragarrietara:
```bash
flutter pub upgrade --major-versions
```

---

### Bertsio Gatazkak

**Deskribapena**: Bi pakete edo gehiagok mendekotasun komunaren bertsio bateraezinen eskatzen dute.

**Agian kausa**: Mendekotasunetan bertsio murrizketa zorrotz-egiak.

**Konponbidea**:

1. Identifikatu gatazka:
```bash
flutter pub deps | grep "✗"
```

2. Erabili `dependency_overrides` aldi baterako:
```yaml
dependency_overrides:
  shared_dependency: ^2.0.0
```

3. Txostendu gatazka paكeteen mantentzaileei

4. Azken baliabide gisa, kontuan izan gatazkan dauden paketeen alternatibak

---

### l10n Sorkuntzako Erroreak

**Deskribapena**: Huts lokalizazio fitxategiak sortzean.

**Agian kausa**: .arb fitxategietan sintaxi erroreak edo konfigurazio okerra.

**Konponbidea**:

1. Egiaztatu .arb fitxategien sintaxia `lib/l10n/`-en:
   - Ziurtatu JSON baliozkoa dela
   - Egiaztatu placeholder-ak koherenteak direla

2. Garbitu eta berriz sortu:
```bash
flutter clean
flutter pub get
flutter gen-l10n
```

3. Egiaztatu pubspec.yaml-eko konfigurazioa:
```yaml
flutter:
  generate: true
```

4. Berrikusi `l10n.yaml` konfigurazio zuzenerako

**Erreferentziak**: [Flutter-eko Nazioartekotzea](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)

---

### Android Build Hutsegitea

**Deskribapena**: Android konpilazioa huts egiten du errore anitzek in.

**Agian kausa**: Gradle konfigurazioa, SDK bertsioa edo baimen arazoak.

**Konponbidea**:

1. Egiaztatu Java bertsioa (Java 17 behar du):
```bash
java -version
```

2. Garbitu proiektua guztiz:
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
```

3. Egiaztatu `android/app/build.gradle`-ko konfigurazioak:
   - `compileSdkVersion`: 34
   - `minSdkVersion`: 23
   - `targetSdkVersion`: 34

4. Konpilatu informazio xehatuz:
```bash
flutter build apk --verbose
```

5. Erroreak baimenei buruzkoak badira, egiaztatu `android/app/src/main/AndroidManifest.xml`

---

### iOS Build Hutsegitea

**Deskribapena**: iOS konpilazioa huts egiten du edo ezin du app-a sinatu.

**Agian kausa**: Ziurtagiriak, provisioning profile-ak edo Xcode konfigurazioa.

**Konponbidea**:

1. Ireki proiektua Xcode-n:
```bash
open ios/Runner.xcworkspace
```

2. Egiaztatu sinaduraren konfigurazioa:
   - Hautatu Runner proiektua
   - "Signing & Capabilities"-en, egiaztatu Team eta Bundle Identifier

3. Garbitu Xcode-ren build-a:
   - Product > Clean Build Folder (Shift + Cmd + K)

4. Eguneratu pods-ak:
```bash
cd ios
pod deintegrate
pod install
cd ..
```

5. Konpilatu terminaletik:
```bash
flutter build ios --verbose
```

---

## Datu-Basearen Arazoak

### Database is Locked

**Deskribapena**: "database is locked" errorea datu-base eragiketak saiatzean.

**Agian kausa**: Konexio anitzek aldi berean idazten saiatzen dira edo transakzioa itxi gabe.

**Konponbidea**:

1. Ziurtatu konexio guztiak kodean zuzen ixten direla

2. Egiaztatu ez dagoela commit/rollback gabeko transakziorik zabalik

3. Berrabiarazi aplikazioa osorik

4. Azken baliabide gisa, ezabatu datu-basea:
```bash
# Android
adb shell run-as com.medicapp.app rm -r /data/data/com.medicapp.app/databases/

# iOS - Xcode-tik, ezabatu app-aren edukiontzia
```

**Erreferentziak**: Berrikusi `lib/core/database/database_helper.dart` transakzioen kudeaketarako.

---

### Migrazio Erroreak

**Deskribapena**: Datu-base eskema eguneratzean huts egiten du.

**Agian kausa**: Migrazio script okerra edo datu-base bertsio inkoherentea.

**Konponbidea**:

1. Berrikusi migrazio script-ak `DatabaseHelper`-en

2. Egiaztatu datu-basearen uneko bertsioa:
```dart
final db = await DatabaseHelper.instance.database;
print('Database version: ${await db.getVersion()}');
```

3. Garapena bada, berrezarri datu-basea:
   - Desinstalatu app-a
   - Berriz instalatu

4. Produkziorako, sortu migrazio script bat kasu espezifikoa kudeatzeko

5. Erabili app-aren debugging pantaila DB egoera egiaztatzeko

---

### Datuak Ez Dira Iraunkortzen

**Deskribapena**: Sartutako datuak desagertzen dira app-a itxi ondoren.

**Agian kausa**: Datu-base eragiketak ez dira osatzen edo huts egiten dute isilpean.

**Konponbidea**:

1. Gaitu datu-base log-ak debug moduan

2. Egiaztatu insert/update eragiketek arrakasta itzultzen dutela:
```dart
final id = await db.insert('medications', medication.toMap());
print('Medikamentua txertatuta id-arekin: $id');
```

3. Ziurtatu ez dagoela isilpeko salbuespenik

4. Egiaztatu idazketa baimenak gailuan

5. Berrikusi `await` eragiketa async guztietan dagoen

---

### Datu-Base Hondatzea

**Deskribapena**: Erroreak datu-basea irekitzen edo datu inkoherenteak.

**Agian kausa**: App-aren itxiera bat-batekoa idazketan zehar edo fitxategi-sistemaren arazoa.

**Konponbidea**:

1. Saiatu datu-basea konpontzen sqlite3 komandoa erabiliz (root sarbidea behar du):
```bash
sqlite3 /bidea/database.db-ra "PRAGMA integrity_check;"
```

2. Hondatuta badago, berreskuratu backup-etik existitzen bada

3. Backup-ik ez badago, berrezarri datu-basea:
   - Desinstalatu app-a
   - Berriz instalatu
   - Datuak galduko dira

4. **Prebentzioa**: Inplementatu aldian-aldiko backup automatikoak

---

### Datu-Basea Nola Berrezarri

**Deskribapena**: Datu-basea guztiz ezabatu behar duzu hutsetik hasteko.

**Agian kausa**: Garapena, testing edo arazo konpontzea.

**Konponbidea**:

**1. Aukera - App-etik (Development)**:
```dart
// Debugging pantailan
await DatabaseHelper.instance.deleteDatabase();
```

**2. Aukera - Android**:
```bash
adb shell run-as com.medicapp.app rm /data/data/com.medicapp.app/databases/medicapp.db
```

**3. Aukera - iOS**:
- Desinstalatu app-a gailutik/simuladoretik
- Berriz instalatu

**4. Aukera - Plataforma biak**:
```bash
flutter clean
# Desinstalatu eskuz gailutik
flutter run
```

---

## Jakinarazpenekin Arazoak

### Jakinarazpenak Ez Dira Agertzen

**Deskribapena**: Programatutako jakinarazpenak ez dira erakusten.

**Agian kausa**: Baimenak ez dira eman, jakinarazpenak desgaituta edo programazio errorea.

**Konponbidea**:

1. Egiaztatu jakinarazpen baimenak:
   - Android 13+: `POST_NOTIFICATIONS` eskatu behar du
   - iOS: Lehen abiarazpenean baimena eskatu behar du

2. Egiaztatu gailuaren konfigurazioa:
   - Android: Ezarpenak > Aplikazioak > MedicApp > Jakinarazpenak
   - iOS: Ezarpenak > Jakinarazpenak > MedicApp

3. Egiaztatu jakinarazpenak programatuta dauden:
```dart
final pendingNotifications = await flutterLocalNotificationsPlugin
    .pendingNotificationRequests();
print('Jakinarazpen zain: ${pendingNotifications.length}');
```

4. Berrikusi log-ak programazio erroreak ikusteko

5. Erabili app-aren debugging pantaila programatutako jakinarazpenak ikusteko

---

### Baimenik Gabe (Android 13+)

**Deskribapena**: Android 13+-n, jakinarazpenak ez dira funtzionatzen app-ak eskatzen baditu ere.

**Agian kausa**: `POST_NOTIFICATIONS` baimena erabiltzaileak ukatu egin du.

**Konponbidea**:

1. Egiaztatu baimena `AndroidManifest.xml`-en deklaratuta dagoela:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

2. App-ak exekuzio-denboran eskatu behar du baimena

3. Erabiltzaileak ukatu badu, gidatu ezarpenera:
```dart
await openAppSettings();
```

4. Azaldu erabiltzaileari zergatik jakinarazpenak ezinbesteকoak diren app-erako

5. Ez onartu baimena emanda dagoela; beti egiaztatu programatu aurretik

---

### Alarma Zehatzak Ez Dira Funtzionatzen

**Deskribapena**: Jakinarazpenak ez dira agertzen programatutako une zehatzean.

**Agian kausa**: `SCHEDULE_EXACT_ALARM` baimena falta edo bateria murrizketak.

**Konponbidea**:

1. Egiaztatu baimenak `AndroidManifest.xml`-en:
```xml
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
```

2. Android 12+-rako, eskatu baimena:
```dart
if (await Permission.scheduleExactAlarm.isDenied) {
  await Permission.scheduleExactAlarm.request();
}
```

3. Desaktibatu bateria optimizazioa app-erako:
   - Ezarpenak > Bateria > Bateria optimizazioa
   - Bilatu MedicApp eta hautatu "Ez optimizatu"

4. Egiaztatu `androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle` erabiltzen duzula

---

### Jakinarazpenak Ez Dute Soinurik

**Deskribapena**: Jakinarazpenak agertzen dira baina soinurik gabe.

**Agian kausa**: Jakinarazpen kanala soinurik gabe edo gailuaren modu isiltsua.

**Konponbidea**:

1. Egiaztatu jakinarazpen kanalaren konfigurazioa:
```dart
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'medication_reminders',
  'Medikamentu Gogorarazpenak',
  importance: Importance.high,
  sound: RawResourceAndroidNotificationSound('notification_sound'),
);
```

2. Ziurtatu soinu fitxategia `android/app/src/main/res/raw/`-en existitzen dela

3. Egiaztatu gailuaren konfigurazioa:
   - Android: Ezarpenak > Aplikazioak > MedicApp > Jakinarazpenak > Kategoria
   - iOS: Ezarpenak > Jakinarazpenak > MedicApp > Soinuak

4. Egiaztatu gailua ez dagoela modu isiltsuan/ez molestatu moduan

---

### Gailua Berrabiarazi Ondorengo Jakinarazpenak

**Deskribapena**: Jakinarazpenak funtzionatzeari uzten diote gailua berrabiarazi ondoren.

**Agian kausa**: Programatutako jakinarazpenak ez dira iraunkortzen berrabiarazpenaren ondoren.

**Konponbidea**:

1. Gehitu `RECEIVE_BOOT_COMPLETED` baimena `AndroidManifest.xml`-en:
```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

2. Inplementatu `BroadcastReceiver` bat jakinarazpenak berriz programatzeko:
```xml
<receiver android:name=".BootReceiver" android:enabled="true" android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
    </intent-filter>
</receiver>
```

3. Inplementatu logika jakinarazpen zain guztiak berriz programatzeko

4. iOS-en, jakinarazpen lokalak automatikoki iraunkortzen dira

**Erreferentziak**: Berrikusi `android/app/src/main/kotlin/.../MainActivity.kt`

---

## Errendimendu Arazoak

### App Motela Debug Moduan

**Deskribapena**: Aplikazioak errendimendu eskasa du eta motela da.

**Agian kausa**: Debug moduak garapen tresnak ditu errendimenduari eragiten diotenak.

**Konponbidea**:

1. **Hau normala da debug moduan**. Errendimendu erreala ebaluatzeko, konpilatu profile edo release moduan:
```bash
flutter run --profile
# edo
flutter run --release
```

2. Erabili Flutter DevTools lekuaz atzeratuak identifikatzeko:
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

3. Egiaztatu ez dagoela `print()` statement gehiegi hot path-etan

4. Inoiz ez ebaluatu errendimendua debug moduan

---

### Bateria Kontsumu Handiegi

**Deskribapena**: Aplikazioak bateria asko kontsumitzen du.

**Agian kausa**: Jakinarazpen gehiegi, background task-ak edo kontsulta maiztsuak.

**Konponbidea**:

1. Murriztu background egiaztapenen maiztasuna

2. Optimizatu datu-base kontsultak:
   - Erabili indize egokiak
   - Ekidin beharrezko kontsultak
   - Cachea tu emaitzak posible denean

3. Erabili `WorkManager` alarma maiztsuaren ordez egokia denean

4. Berrikusi sentsoreak edo GPS erabilera (aplikatzen bada)

5. Profilatu bateria erabilera Android Studio-n:
   - View > Tool Windows > Energy Profiler

---

### Zerrenda Luzeetan Lag-a

**Deskribapena**: Elementu asko dituzten zerrendatan scroll-ak motela edo moztua da.

**Agian kausa**: Widget-en errenderi eraginkorra edo ListView optimizazio falta.

**Konponbidea**:

1. Erabili `ListView.builder` `ListView`-ren ordez:
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

2. Inplementatu `const` constructor-ak posible denean

3. Ekidin widget pisuak zerrendako item bakoitzean

4. Erabili `RepaintBoundary` widget konplexuentzat:
```dart
RepaintBoundary(
  child: ComplexWidget(),
)
```

5. Kontuan izan paginazioa zerrenda oso luzeetarako

6. Erabili `AutomaticKeepAliveClientMixin` item-en egoera mantentzeko

---

### Frame Saltatuak

**Deskribapena**: UI-ak moztua sentitzen da frame galduekin.

**Agian kausa**: Thread nagusian eragiketa kostosuak.

**Konponbidea**:

1. Identifikatu arazoa Flutter DevTools Performance tab-ekin

2. Mugitu eragiketa kostosuak isolate-etara:
```dart
final result = await compute(expensiveFunction, data);
```

3. Ekidin eragiketa sinkrono pisuak build metodoan

4. Erabili `FutureBuilder` edo `StreamBuilder` eragiketa async-etarako

5. Optimizatu irudi handiak:
   - Erabili formatu konprimatuak
   - Cachea tu decodeatutako irudiak
   - Erabili thumbnail-ak aurrebistetarako

6. Berrikusi ez dagoela animazio kostosuekin listener-ik

---

## UI/UX Arazoak

### Testua Ez Da Itzultzen

**Deskribapena**: Testu batzuk ingelesez edo beste hizkuntza okеrrean agertzen dira.

**Agian kausa**: Katea .arb fitxategian falta edo AppLocalizations erabiltzen ez da.

**Konponbidea**:

1. Egiaztatu katea `lib/l10n/app_es.arb`-en existitzen dela:
```json
{
  "yourKey": "Zure testu itzulita"
}
```

2. Ziurtatu `AppLocalizations.of(context)` erabiltzen ari zarela:
```dart
Text(AppLocalizations.of(context)!.yourKey)
```

3. Berriz sortu lokalizazio fitxategiak:
```bash
flutter gen-l10n
```

4. Gako berri bat gehitu baduzu, ziurtatu .arb fitxategi guztietan existitzen dela

5. Egiaztatu gailuaren locale-a zuzen konfiguratuta dagoela

---

### Kolore Okerrak

**Deskribapena**: Koloreak ez datoz bat espero den diseinuarekin edo gaiarekin.

**Agian kausa**: Gaiaren erabilera okerra edo hardcoded colors.

**Konponbidea**:

1. Erabili beti gaiaren koloreak:
```dart
// Zuzena
color: Theme.of(context).colorScheme.primary

// Okerra
color: Colors.blue
```

2. Egiaztatu gaiaren definizioa `lib/core/theme/app_theme.dart`-en

3. Ziurtatu MaterialApp-ek gai konfiguratua duela:
```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  // ...
)
```

4. Debug-erako, inprimatu uneko koloreak:
```dart
print('Primary: ${Theme.of(context).colorScheme.primary}');
```

---

### Pantaila Txikietan Layout Hautsia

**Deskribapena**: UI-ak gainezkatzea du edo gaizki ikusten da pantaila txikiko gailuetan.

**Agian kausa**: Tamaina finkoko widget-ak edo responsive design falta.

**Konponbidea**:

1. Erabili widget malguak tamaina finkoen ordez:
```dart
// Honenordez
Container(width: 300, child: ...)

// Erabili
Expanded(child: ...)
// edo
Flexible(child: ...)
```

2. Erabili `LayoutBuilder` layout adaptatiboentzat:
```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      return MobileLayout();
    } else {
      return TabletLayout();
    }
  },
)
```

3. Erabili `MediaQuery` neurketak lortzeko:
```dart
final screenWidth = MediaQuery.of(context).size.width;
```

4. Probatu tamaina desberdinetan emuladorea erabiliz

---

### Testu Overflow-a

**Deskribapena**: "overflow" oharra agertzen da marra hori eta beltzez.

**Agian kausa**: Testua luzeegia eskuragarri dagoen espaziorako.

**Konponbidea**:

1. Inguratu testua `Flexible` edo `Expanded`-en:
```dart
Flexible(
  child: Text('Testu luzea...'),
)
```

2. Erabili `overflow` eta `maxLines` Text widget-ean:
```dart
Text(
  'Testu luzea...',
  overflow: TextOverflow.ellipsis,
  maxLines: 2,
)
```

3. Testu oso luzeetarako, erabili `SingleChildScrollView`:
```dart
SingleChildScrollView(
  child: Text('Testu oso luzea...'),
)
```

4. Kontuan izan testua laburtzea edo formatu desberdin bat erabiltzea

---

## Pertsona Anitzeko Arazoak

### Stock-a Ez Da Zuzen Partekatzen

**Deskribapena**: Pertsona anitzek izen bereko medikamentuak sortu ditzakete stock-a partekatu gabe.

**Agian kausa**: Bikoiztu egiaztapena pertsonaren arabera globala ordez.

**Konponbidea**:

1. Egiaztatu `MedicationRepository`-ko medikamentu existenteak bilatzeko funtzioa

2. Ziurtatu bilaketa globala dela:
```dart
// Bilatu izenez personId-ren arabera iragazki gabe
final existing = await db.query(
  'medications',
  where: 'name = ?',
  whereArgs: [name],
);
```

3. Dosi bat gehitzean, dosia pertsonarekin lotu baina ez medikamentua

4. Berrikusi `AddMedicationScreen`-eko logika medikamentu existenteak berrerabiltzeko

---

### Medikamentu Bikoiztuak

**Deskribapena**: Medikamentu bikoiztuak zerrendan agertzen dira.

**Agian kausa**: Medikamentu beraren txertatze anitz edo balioztapen falta.

**Konponbidea**:

1. Inplementatu egiaztapena txertatu aurretik:
```dart
final existing = await getMedicationByName(name);
if (existing != null) {
  return existing.id;
}
```

2. Erabili UNIQUE murrizketak datu-basean:
```sql
CREATE TABLE medications (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  -- ...
);
```

3. Berrikusi medikamentuak sortzeko logika repository-n

4. Dagoeneko bikoiztu existitzen badira, sortu migrazio script-a batzeko

---

### Dosi Historial Okerra

**Deskribapena**: Historialak beste pertsonen dosiak erakusten ditu edo informazio falta du.

**Agian kausa**: Pertsonika iragazki okerra edo join oker konfiguratuta.

**Konponbidea**:

1. Egiaztatu historiala lortzen duen query-a:
```dart
final doses = await db.query(
  'dose_history',
  where: 'personId = ?',
  whereArgs: [personId],
  orderBy: 'takenAt DESC',
);
```

2. Ziurtatu dosi guztiek `personId` lotuta dutela

3. Berrikusi `DoseHistoryScreen`-eko iragazki logika

4. Egiaztatu taulen arteko join-ek pertsona baldintza barne dituztela

---

### Lehenetsitako Pertsona Ez Da Aldatzen

**Deskribapena**: Pertsona aktiboa aldatzean, UI-a ez da zuzen eguneratzen.

**Agian kausa**: Egoera ez da zuzen hedatzen edo rebuild falta du.

**Konponbidea**:

1. Egiaztatu egoera global bat erabiltzen duzula (Provider, Bloc, etab.):
```dart
Provider.of<PersonProvider>(context, listen: true).currentPerson
```

2. Ziurtatu pertsona aldatzeak `notifyListeners()` trigger-atzen duela:
```dart
void setCurrentPerson(Person person) {
  _currentPerson = person;
  notifyListeners();
}
```

3. Egiaztatu widget garrantzitsuak aldaketak entzuten dituztela

4. Kontuan izan `Consumer` rebuild espezifikoetarako erabiltzea:
```dart
Consumer<PersonProvider>(
  builder: (context, provider, child) {
    return Text(provider.currentPerson.name);
  },
)
```

---

## Barauarekin Arazoak

### Barauaren Jakinarazpena Ez Da Agertzen

**Deskribapena**: Barauaren ongoing jakinarazpena ez da erakusten.

**Agian kausa**: Baimenak, kanala konfigurazioa edo jakinarazpena sortzean errorea.

**Konponbidea**:

1. Egiaztatu barauaren jakinarazpen kanala sortu dela:
```dart
const AndroidNotificationChannel fastingChannel = AndroidNotificationChannel(
  'fasting',
  'Baraua',
  importance: Importance.low,
  enableVibration: false,
);
```

2. Ziurtatu `ongoing: true` erabiltzen ari zarela:
```dart
const NotificationDetails(
  android: AndroidNotificationDetails(
    'fasting',
    'Baraua',
    ongoing: true,
    autoCancel: false,
  ),
)
```

3. Egiaztatu jakinarazpen baimenak

4. Berrikusi log-ak jakinarazpena sortzean erroreak ikusteko

---

### Kontu Atzekariari Okerra

**Deskribapena**: Barauaren geratzen den denbora ez da zuzena edo ez da eguneratzen.

**Agian kausa**: Denboraren kalkulu okerra edo aldizka eguneraketa falta.

**Konponbidea**:

1. Egiaztatu geratzen den denboraren kalkulua:
```dart
final remaining = endTime.difference(DateTime.now());
```

2. Ziurtatu jakinarazpena aldian-aldian eguneratzen dela:
```dart
Timer.periodic(Duration(minutes: 1), (timer) {
  updateFastingNotification();
});
```

3. Egiaztatu barauaren `endTime`-a zuzen gordetzen dela

4. Erabili debugging pantaila uneko barauaren egoera egiaztatzeko

---

### Baraua Ez Da Automatikoki Ezeztatu

**Deskribapena**: Barauaren jakinarazpena denbora amaitu ondoren geratzen da.

**Agian kausa**: Jakinarazpena osatzean ezeztatzeko logika falta du.

**Konponbidea**:

1. Inplementatu egiaztapena baraua amaitzen denean:
```dart
if (DateTime.now().isAfter(fasting.endTime)) {
  await cancelFastingNotification();
  await markFastingAsCompleted(fasting.id);
}
```

2. Egiaztatu app-a irekitzen denean:
```dart
@override
void initState() {
  super.initState();
  checkActiveFastings();
}
```

3. Programatu alarma bat baraua amaitzeko jakinarazpena ezeztatzen duena

4. Ziurtatu jakinarazpena `onDidReceiveNotificationResponse`-n ezeztatzen dela

**Erreferentziak**: Berrikusi `lib/features/fasting/` inplementaziorako.

---

## Testing Arazoak

### Test-ak Lokalki Huts Egiten Dute

**Deskribapena**: CI-n gainditzen diren test-ak zure makina lokalean huts egiten dute.

**Agian kausa**: Ingurune diferentziak, mendekotasunak edo konfigurazioa.

**Konponbidea**:

1. Garbitu eta berreraikatu:
```bash
flutter clean
flutter pub get
```

2. Egiaztatu bertsio berdinak direla:
```bash
flutter --version
dart --version
```

3. Exekutatu test-ak informazio gehiagorekin:
```bash
flutter test --verbose
```

4. Ziurtatu ez dagoela aurreko egoeran mendeko test-ik

5. Egiaztatu ez dagoela denboraren mendeko test-ik (erabili `fakeAsync`)

---

### sqflite_common_ffi Arazoak

**Deskribapena**: Datu-base test-ak sqflite errorekin huts egiten dute.

**Agian kausa**: sqflite ez dago test-etan erabilgarri, sqflite_common_ffi erabili behar da.

**Konponbidea**:

1. Ziurtatu mendekotasuna duzula:
```yaml
dev_dependencies:
  sqflite_common_ffi: ^2.3.0
```

2. Hasieratu test-en setup-ean:
```dart
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('database test', () async {
    // ...
  });
}
```

3. Erabili memorian datu-baseak test-etarako:
```dart
final db = await databaseFactoryFfi.openDatabase(
  inMemoryDatabasePath,
);
```

4. Garbitu datu-basea test bakoitzaren ondoren

---

### Test-etan Timeout-ak

**Deskribapena**: Test-ak timeout-agatik huts egiten dute.

**Agian kausa**: Eragiketa motelak edo deadlock-ak test async-etan.

**Konponbidea**:

1. Handitu timeout-a test espezifikoetarako:
```dart
test('slow test', () async {
  // ...
}, timeout: Timeout(Duration(seconds: 30)));
```

2. Egiaztatu `await` falta ez dagoela

3. Erabili `fakeAsync` delay-ak dituzten test-etarako:
```dart
testWidgets('timer test', (tester) async {
  await tester.runAsync(() async {
    // delay-ak dituen test kodea
  });
});
```

4. Mockeatu eragiketa motelak hala nola sare-deiak

5. Berrikusi ez dagoela loop infiniturik edo race condition-ik

---

### Test Inkoherenteak

**Deskribapena**: Test berberak batzuetan gainditzen dira eta besteetan huts egiten dute.

**Agian kausa**: Denboraren mendeko test-ak, exekuzio ordenarena edo egoera partekatua.

**Konponbidea**:

1. Ekidin denbora errealaren menpeko, erabili `fakeAsync` edo mock-ak

2. Ziurtatu test bakoitza independentea dela:
```dart
setUp(() {
  // Test bakoitzerako setup garbia
});

tearDown(() {
  // Test bakoitzaren ondoren garbiketa
});
```

3. Ez partekatu egoera mutable test artean

4. Erabili `setUpAll` soilik egoera inmutablerentzat

5. Exekutatu test-ak orden aleatoruan mendekotasunak detektatzeko:
```bash
flutter test --test-randomize-ordering-seed=random
```

---

## Baimen Arazoak

### POST_NOTIFICATIONS (Android 13+)

**Deskribapena**: Jakinarazpenak ez dira funtzionatzen Android 13 edo berriagoan.

**Agian kausa**: POST_NOTIFICATIONS baimena runtime-ean eskatu behar da.

**Konponbidea**:

1. Deklaratu baimena `AndroidManifest.xml`-en:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

2. Eskatu baimena runtime-ean:
```dart
if (Platform.isAndroid && await Permission.notification.isDenied) {
  final status = await Permission.notification.request();
  if (status.isDenied) {
    // Informatuu erabiltzailea eta eskaini ezarpenetara joatea
  }
}
```

3. Egiaztatu baimena jakinarazpenak programatu aurretik

4. Gidatu erabiltzailea ezarpenetara betiko ukatu badu

**Erreferentziak**: [Android 13 Notification Permission](https://developer.android.com/about/versions/13/changes/notification-permission)

---

### SCHEDULE_EXACT_ALARM (Android 12+)

**Deskribapena**: Alarma zehatzak ez dira funtzionatzen Android 12+-n.

**Agian kausa**: Android 12-tik baimen berezia behar du.

**Konponbidea**:

1. Deklaratu baimena:
```xml
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
```

2. Egiaztatu eta eskatu beharrezkoa bada:
```dart
if (Platform.isAndroid) {
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  if (androidInfo.version.sdkInt >= 31) {
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }
}
```

3. Azaldu erabiltzaileari zergatik alarma zehatzak behar dituzun

4. Kontuan izan `USE_EXACT_ALARM` erabilen alarma/gogorarazpen app-a bazara

---

### USE_EXACT_ALARM (Android 14+)

**Deskribapena**: Alarma zehatzak baimen berezirik gabe behar dituzu.

**Agian kausa**: Android 14-k USE_EXACT_ALARM sartu du alarma app-etarako.

**Konponbidea**:

1. Zure app-a batez ere alarmena/gogorazapenak badira, erabili:
```xml
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
```

2. Hau `SCHEDULE_EXACT_ALARM`-en alternaktiba da erabiltzaileak eskuz emana beharrik ez duena

3. Soilik erabili zure app-ak [kasu erabilera baimenak](https://developer.android.com/about/versions/14/changes/schedule-exact-alarms) betetzen baditu

4. App-ak funtzionalitate nagusia alarma edo gogorarazpenak izan behar ditu

---

### Background Jakinarazpenak (iOS)

**Deskribapena**: Jakinarazpenak ez dira zuzen funtzionatzen iOS-en.

**Agian kausa**: Baimenak ez dira eskatu edo konfigurazio okerra.

**Konponbidea**:

1. Eskatu baimenak app-a hastean:
```dart
final settings = await FirebaseMessaging.instance.requestPermission(
  alert: true,
  badge: true,
  sound: true,
);
```

2. Egiaztatu `Info.plist`:
```xml
<key>UIBackgroundModes</key>
<array>
  <string>fetch</string>
  <string>remote-notification</string>
</array>
```

3. Ziurtatu Xcode-n capability zuzenak dituzula:
   - Push Notifications
   - Background Modes

4. Egiaztatu erabiltzaileak ez duela jakinarazpenak desgaitu Ezarpenetan

---

## Errore Ohikoak eta Konponbideak

### MissingPluginException

**Deskribapena**: Errorea "MissingPluginException(No implementation found for method...)"

**Agian kausa**: Plugin-a ez dago zuzen erregistratuta edo hot restart behar da.

**Konponbidea**:

1. Egin hot restart osoa (ez soilik hot reload):
```bash
# App-a exekutatzen duen terminalean
r  # hot reload
R  # HOT RESTART (hau behar duzu)
```

2. Jarraitzen badu, berreraikitu guztiz:
```bash
flutter clean
flutter pub get
flutter run
```

3. Egiaztatu plugin-a `pubspec.yaml`-en dagoela

4. iOS-erako, berriz instalatu pods-ak:
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
```

---

### PlatformException

**Deskribapena**: Errorea "PlatformException" kode desberdinekin.

**Agian kausa**: Errore kode espezifikoaren araberakoa.

**Konponbidea**:

1. Irakurri erroree mezua eta kode guztiak

2. Errore ohikoak:
   - `permission_denied`: Egiaztatu baimenak
   - `error`: Errore generikoa, berrikusi log natiboak
   - `not_available`: Funtzioa ez dago plataforma honetan erabilgarri

3. Android-erako, berrikusi logcat:
```bash
adb logcat | grep -i flutter
```

4. iOS-erako, berrikusi Xcode-ren kontsola

5. Ziurtatu errore hauek gracefully kudeatzen dituzula:
```dart
try {
  await somePluginMethod();
} on PlatformException catch (e) {
  print('Errorea: ${e.code} - ${e.message}');
  // Kudeatu egokiro
}
```

---

### DatabaseException

**Deskribapena**: Errorea datu-base eragiketer exekutatzean.

**Agian kausa**: Query baliogabea, murrizketa hautsita edo datu-base hondatua.

**Konponbidea**:

1. Irakurri errore mezua osoa arazoa identifikatzeko

2. Errore ohikoak:
   - `UNIQUE constraint failed`: Bikoiztua txertatu saiatzen
   - `no such table`: Taula ez da existitzen, berrikusi migrazioak
   - `syntax error`: SQL query baliogabea

3. Egiaztatu SQL query-a:
```dart
try {
  await db.query('medications', where: 'id = ?', whereArgs: [id]);
} on DatabaseException catch (e) {
  print('Database errorea: ${e.toString()}');
}
```

4. Ziurtatu migrazioak exekutatu direla

5. Azken baliabide gisa, berrezarri datu-basea

---

### StateError

**Deskribapena**: Errorea "Bad state: No element" edo antzekoa.

**Agian kausa**: Existitzen ez den elementu batera sarbidea saiatzen.

**Konponbidea**:

1. Identifikatu stack trace-an lerro zehatza

2. Erabili metodo seguruak:
```dart
// Honenordez
final item = list.first;  // StateError jaurtitzen du hutsik badago

// Erabili
final item = list.isNotEmpty ? list.first : null;
// edo
final item = list.firstOrNull;  // Dart 3.0+
```

3. Beti egiaztatu sarbidetu aurretik:
```dart
if (list.isNotEmpty) {
  final item = list.first;
  // erabili item
}
```

4. Erabili try-catch beharrezkoa bada:
```dart
try {
  final item = list.single;
} on StateError {
  // Kudeatu elementu bat bakarrik ez dagoen kasua
}
```

---

### Null Check Operator Used on Null Value

**Deskribapena**: Errorea `!` operadorea balio null batean erabiltzean.

**Agian kausa**: Null izan daitekeen aldagaia `!` erabiliz bere balioa null denean.

**Konponbidea**:

1. Identifikatu stack trace-an lerro zehatza

2. Egiaztatu balioa `!` erabili aurretik:
```dart
// Honenordez
final value = nullableValue!;

// Erabili
if (nullableValue != null) {
  final value = nullableValue;
  // erabili value
}
```

3. Erabili operadorea `??` balio lehenetsirentzat:
```dart
final value = nullableValue ?? defaultValue;
```

4. Erabili operadorea `?.` sarbide segururako:
```dart
final length = nullableString?.length;
```

5. Berrikusi zergatik balioa null den ez lukeen izan behar duenean

---

## Log-ak eta Debugging

### Log-ak Nola Gaitu

**Deskribapena**: Log xehatuak ikusi behar dituzu arazo bat debuggeatzeko.

**Konponbidea**:

1. **Flutter log-ak**:
```bash
flutter run --verbose
```

2. **App-aren log-ak soilik**:
```dart
import 'package:logging/logging.dart';

final logger = Logger('MedicApp');

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(MyApp());
}
```

3. **Android log natiboak**:
```bash
adb logcat | grep -i flutter
# edo dena ikusteko
adb logcat
```

4. **iOS log natiboak**:
   - Ireki Console.app macOS-en
   - Hautatu zure gailua/simuladorea
   - Iragaztu "flutter" edo zure bundle identifier-ez

---

### Jakinarazpenen Log-ak

**Deskribapena**: Jakinarazpenekin erlazionatutako log-ak ikusi behar dituzu.

**Konponbidea**:

1. Gehitu log-ak jakinarazpenen kodean:
```dart
print('Jakinarazpena programatzen hemen: $scheduledTime');
await flutterLocalNotificationsPlugin.zonedSchedule(
  id,
  title,
  body,
  scheduledTime,
  notificationDetails,
);
print('Jakinarazpena arrakastatsu programatu da');
```

2. Zerrendatu zain dauden jakinarazpenak:
```dart
final pending = await flutterLocalNotificationsPlugin
    .pendingNotificationRequests();
for (var notification in pending) {
  print('Zain: ${notification.id} - ${notification.title}');
}
```

3. Egiaztatu sistemaren log-ak:
   - Android: `adb logcat | grep -i notification`
   - iOS: Console.app "notification" iragazkiarekin

---

### Datu-Basearen Log-ak

**Deskribapena**: Exekutatutako datu-base query-ak ikusi behar dituzu.

**Konponbidea**:

1. Gaitu logging sqflite-n:
```dart
import 'package:sqflite/sqflite.dart';

void main() {
  Sqflite.setDebugModeOn(true);
  runApp(MyApp());
}
```

2. Gehitu log-ak zure query-etan:
```dart
print('Query exekutatzen: SELECT * FROM medications WHERE id = $id');
final result = await db.query('medications', where: 'id = ?', whereArgs: [id]);
print('Query-k ${result.length} errenkada itzuli ditu');
```

3. Wrapper logging automatikoarentzat:
```dart
class LoggedDatabase {
  final Database db;
  LoggedDatabase(this.db);

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    print('Query: $table WHERE $where ARGS $whereArgs');
    final result = await db.query(table, where: where, whereArgs: whereArgs);
    print('Emaitza: ${result.length} errenkada');
    return result;
  }
}
```

---

### Debugger Erabili

**Deskribapena**: Exekuzioa pausatu eta egoera aztertu behar duzu.

**Konponbidea**:

1. **VS Code-n**:
   - Jarri breakpoint bat lerro-zenbakiaren ondoan klik eginez
   - Exekutatu debug moduan (F5)
   - Pausatu denean, erabili debug kontrolak

2. **Android Studio-n**:
   - Jarri breakpoint bat ertzean klik eginez
   - Exekutatu Debug (Shift + F9)
   - Erabili Debug panel-a step over/into/out-erako

3. **Debugger programatikoa**:
```dart
import 'dart:developer';

void someFunction() {
  debugger();  // Hemen pausatu badago debugger konektatu
  // kodea...
}
```

4. **Aldagai-ak aztertu**:
```dart
print('Value: $value');  // Logging sinplea
debugPrint('Value: $value');  // Rate limit-ak errespetatzen dituen logging-a
```

---

### App-aren Debugging Pantaila

**Deskribapena**: MedicApp-ek debugging pantaila erabilgarri bat du barne.

**Konponbidea**:

1. Sartu debugging pantailara konfigurazio menutik

2. Erabilgarri dauden funtzioak:
   - Ikusi datu-basea (taulak, errenkadak, edukia)
   - Ikusi programatutako jakinarazpenak
   - Ikusi sistemaren egoera
   - Behartu jakinarazpenen eguneraketa
   - Garbitu datu-basea
   - Ikusi azken log-ak

3. Erabili pantaila hau:
   - Egiaztatu datuak zuzen gordetzen direla
   - Egiaztatu jakinarazpen zain
   - Identifikatu egoera arazoak

4. Debug moduan soilik erabilgarri

---

## Aplikazioa Berrezarri

### App Datuak Garbitu

**Deskribapena**: Datu guztiak ezabatu behar dituzu desinstalatu gabe.

**Konponbidea**:

**Android**:
```bash
adb shell pm clear com.medicapp.app
```

**iOS**:
- Ezarpenak > Orokorra > iPhone Biltegiratzea
- Bilatu MedicApp
- "Ezabatu App-a" (ez "Deskargatu App-a")

**App-etik** (debug soilik):
- Erabili debugging pantaila
- "Reset Database"

---

### Desinstalatu eta Berriz Instalatu

**Deskribapena**: Instalazio garbi osoa.

**Konponbidea**:

**Android**:
```bash
adb uninstall com.medicapp.app
flutter run
```

**iOS**:
```bash
# Gailutik/simuladoretik, eduki sakatuta ikonoa
# Hautatu "Ezabatu App-a"
flutter run
```

**Flutter-etik**:
```bash
flutter clean
rm -rf build/
flutter run
```

---

### Datu-Basea Berrezarri

**Deskribapena**: Datu-basea soilik ezabatu app-a mantenduz.

**Konponbidea**:

**Kodetik** (debug soilik):
```dart
await DatabaseHelper.instance.deleteDatabase();
```

**Android - Eskuz**:
```bash
adb shell
run-as com.medicapp.app
cd databases
rm medicapp.db medicapp.db-shm medicapp.db-wal
exit
```

**iOS - Eskuz**:
- App-aren edukiontzira sarbidea behar duzu
- Errazagoa da desinstalatu eta berriz instalatzea

---

### Flutter Cache Garbitu

**Deskribapena**: Cache-ekin erlazionatutako konpilazio arazoak konpondu.

**Konponbidea**:

1. Oinarrizko garbiketa:
```bash
flutter clean
```

2. Garbiketa osoa:
```bash
flutter clean
rm -rf build/
rm -rf .dart_tool/
rm pubspec.lock
flutter pub get
```

3. Garbitu pub cache-a:
```bash
flutter pub cache repair
```

4. Garbitu Gradle cache-a (Android):
```bash
cd android
./gradlew clean cleanBuildCache
rm -rf ~/.gradle/caches/
cd ..
```

5. Garbitu pods cache-a (iOS):
```bash
cd ios
rm -rf Pods Podfile.lock
pod cache clean --all
pod install
cd ..
```

---

## Arazo Ezagunak

### Bug Ezagunen Zerrenda

1. **Jakinarazpenak ez dira iraunkortzen berrabiarazi ondoren Android gailu batzuetan**
   - Eragiten du: Android 12+ bateria optimizazio agresiboa duten
   - Workaround: Desaktibatu bateria optimizazioa MedicApp-erako

2. **Layout overflow pantaila oso txikietan (<5")**
   - Eragiten du: 320dp-ko zabalera baino gutxiago duten gailuak
   - Egoera: Fix planeatu v1.1.0-rako

3. **Trantsizio animazioa moztua gailu low-end-etan**
   - Eragiten du: 2GB RAM baino gutxiagoko gailuak
   - Workaround: Desaktibatu animazioak konfigurazioan

4. **Datu-basea mugagabe hazi daiteke**
   - Eragiten du: Historial askoko erabiltzaileak (>1 urte)
   - Workaround: Inplementatu historial zaharraren aldizka garbiketa
   - Egoera: Artxibатze automatikoko feature planeatu

---

### Aldi Baterako Workaround-ak

1. **Jakinarazpenak ez badute soinurik gailu batzuetan**:
```dart
// Erabili garrantzi maximoa aldi baterako
importance: Importance.max,
priority: Priority.high,
```

2. **Zerrenda luzeetan lag badago**:
   - Mugatu historial ikusgaia azken 30 egunetara
   - Inplementatu paginazio eskuzkoa

3. **Datu-basea maiztruago blokeatzen bada**:
   - Murriztu eragiketa konkurrenteak
   - Erabili transakzio batch-ak insert anitzet​arako

---

### GitHub Issue-ak

**Lehendik dauden issue-ak nola bilatu**:

1. Joan: https://github.com/zure-erabiltzailea/medicapp/issues

2. Erabili iragazkiak:
   - `is:issue is:open` - Issue zabalik
   - `label:bug` - Bug-ak soilik
   - `label:enhancement` - Eskatutako feature-ak

3. Bilatu gako-hitzez: "notification", "database", etab.

**Issue berri bat sortu aurretik**:
- Bilatu badagoen antzeko bat
- Egiaztatu goiko arazo ezagunen zerrenda
- Ziurtatu ez dagoela azken bertsioan konponduta

---

## Laguntza Lortu

### Dokumentazioa Berrikusi

**Erabilgarri dauden baliabideak**:

1. **Proiektuaren dokumentazioa**:
   - `README.md` - Informazio orokorra eta setup-a
   - `docs/es/ARCHITECTURE.md` - Proiektuaren arkitektura
   - `docs/es/CONTRIBUTING.md` - Ekarpenen gida
   - `docs/es/TESTING.md` - Testing gida

2. **Flutter dokumentazioa**:
   - [flutter.dev/docs](https://flutter.dev/docs)
   - [api.flutter.dev](https://api.flutter.dev)

3. **Pakete dokumentazioa**:
   - Berrikusi pub.dev mendekotasun bakoitzerako
   - Irakurri README eta changelog pakete bakoitzeko

---

### GitHub Issue-etan Bilatu

**Nola bilatu eraginkortasunez**:

1. Erabili bilaketa aurreratua:
```
repo:zure-erabiltzailea/medicapp is:issue [gako-hitzak]
```

2. Bilatu issue itxiak ere:
```
is:issue is:closed notification not working
```

3. Bilatu etiketengatik:
```
label:bug label:android label:notifications
```

4. Bilatu iruzkinedan:
```
commenter:username [gako-hitzak]
```

---

### Issue Berri Bat Sortu Template-arekin

**Issue bat sortu aurretik**:

1. Berretsi benetan bug edo feature request baliozkoa dela
2. Bilatu bikoiztutako issue-ak
3. Bildu informazio beharrezko guztia

**Beharrezko informazioa**:

**Bug-etarako**:
- Arazoaren deskribapen argía
- Erreproduzitzeko pausoak
- Portaera esperoא vs uneko
- Pantaila-argazkiak/bideoak aplikatzen bada
- Ingurunearen informazioa (behean ikusi)
- Log garrantzitsuak

**Feature-etarako**:
- Funtzionalitatearen deskribapena
- Erabilera kasua eta onurak
- Inplementazio proposamena (aukerakoa)
- Mockup-ak edo adibideak (aukerakoa)

**Issue template-a**:
```markdown
## Deskribapena
[Arazoaren deskribapen argi eta zehatza]

## Erreproduzitzeko Pausoak
1. [Lehen pausoa]
2. [Bigarren pausoa]
3. [Hirugarren pausoa]

## Portaera Esperoა
[Zer gertatu behar luke]

## Uneko Portaera
[Zer gertatzen ari da]

## Ingurunearen Informazioa
- SE: [Android 13 / iOS 16.5]
- Gailua: [Modelo espezifikoa]
- MedicApp bertsioa: [v1.0.0]
- Flutter bertsioa: [3.24.5]

## Log-ak
```
[Log garrantzitsuak]
```

## Pantaila-argazkiak
[Aplikatzen bada]

## Informazio Gehigarria
[Beste testuingururen bat]
```

---

### Txostenerako Beharrezko Informazioa

**Beti sartu**:

1. **App-aren bertsioa**:
```dart
// pubspec.yaml-etik
version: 1.0.0+1
```

2. **Gailuaren informazioa**:
```dart
import 'package:device_info_plus/device_info_plus.dart';

final deviceInfo = DeviceInfoPlugin();
if (Platform.isAndroid) {
  final androidInfo = await deviceInfo.androidInfo;
  print('Android ${androidInfo.version.sdkInt}');
  print('Model: ${androidInfo.model}');
}
```

3. **Flutter bertsioa**:
```bash
flutter --version
```

4. **Log osoak**:
```bash
flutter run --verbose > logs.txt 2>&1
# Erantsi logs.txt issue-ra
```

5. **Stack trace osoa** crash badago

6. **Pantaila-argazkiak edo bideoak** arazoa erakutsiz

---

## Ondorioa

Gida honek MedicApp-eko arazo ohikoenak estaltzen ditu. Hemen zerrendatu gabeको arazo bat aurkitzen baduzu:

1. Berrikusi proiektuaren dokumentazio osoa
2. Bilatu GitHub Issue-etan
3. Galdetu biltegiaren discussion-etan
4. Sortu issue berri bat informazio beharrezko guztiekin

**Gogoratu**: Informazio xehatua eta erreproduzitzeko pausoak ematea zure arazoa azkar konpontzen laguntzen du.

Gida honetarako hobekuntzak ekartzeko, mesedez ireki PR edo issue bat biltegian.

---

**Azken eguneraketa**: 2025-11-14
**Dokumentu bertsioa**: 1.0.0
