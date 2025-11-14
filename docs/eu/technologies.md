# MedicApp-en Teknologia Pila

Dokumentu honek MedicApp-en erabilitako teknologia, framework, liburutegi eta tresna guztiak deskribatzen ditu, bertsio zehatzak, hautaketa justifikazioak, kontuan hartutako alternatioak eta erabaki teknologiko bakoitzaren konpromisoak barne.

---

## 1. Core Technologies

### Flutter 3.9.2+

**Erabilitako bertsioa:** `3.9.2+` (SDK bateragarria `3.35.7+` arte)

**Helburua:**
Flutter da MedicApp-en oinarria den plataforma anitzeko framework-a. Android eta iOS-erako aplikazio natibo bat garatzen du Dart kode-base bakar batetik, natiboaren antzeko errendimendua eta erabiltzaile-esperientzia koherentea bermatuz bi plataformetan.

**Zergatik aukeratu zen Flutter:**

1. **Plataforma anitzeko garapen eraginkorra:** Kode-base bakarra Android eta iOS-erako, garapen eta mantentze kostuak %60-70 murriztuz garapen natibo biko aldean.

2. **Errendimendu natibo:** Flutter-ek ARM kode natibora konpilatzen du, JavaScript zubiak erabiltzen ez ditu React Native-k bezala, animazio leun 60/120 FPS-tan eta erantzun-denbora berehalakoak dosi erregistrorako eragiketa kritikoetan.

3. **Hot Reload:** Iterazio azkarra garapenean, aldaketak segundo 1 baino gutxiagoan ikusten ditu aplikazioaren egoera galdu gabe. Ezinbestekoa jakinarazpenen UI eta urrats anitzeko fluxuak doitzeko.

4. **Material Design 3 natibo:** Material Design 3-ren inplementazio osoa eta eguneratua SDK-an sartuta, hirugarren alderdiko liburutegiak behar gabe.

5. **Ekosistema heldua:** Pub.dev-ek 40.000 pakete baino gehiago ditu, jakinarazpen lokaletarako, SQLite datu-baserako eta fitxategi kudeaketarako soluzio sendoak barne.

6. **Testing integratua:** Testing framework osoa SDK-an sartuta, unit test, widget test eta integration test-etarako euskarriarekin. MedicApp-ek 432+ test ditu %75-80ko estaldurarekin.

**Kontuan hartutako alternatioak:**

- **React Native:** Baztertua errendimendu txikiagoa zerrenda luzeetan (dosi historiala), jakinarazpen lokaletan atzeko planoan arazoak, eta esperientzia inkonsistentea plataformen artean.
- **Kotlin Multiplatform Mobile (KMM):** Baztertua ekosistemaren heldugabearengatik, plataforma bakoitzerako UI kode espezifikoa behar delako, eta ikasketa-kurba handiagoa.
- **Natibo (Swift + Kotlin):** Baztertua garapen ahaleginaren bikoiztearengatik, mantentze kostu handiagoak, eta bi talde espezializatu behar izateagatik.

**Dokumentazio ofiziala:** https://flutter.dev

---

### Dart 3.0+

**Erabilitako bertsioa:** `3.9.2+` (Flutter 3.9.2+ bateragarria)

**Helburua:**
Dart Google-k garatutako objektu orientatuko programazio-lengoaia da, Flutter-ek exekutatzen duena. Sintaxi modernoa, tipado indartsua, null safety eta errendimendu optimizatua eskaintzen ditu.

**MedicApp-en erabilitako ezaugarriak:**

1. **Null Safety:** Erreferentzia null akatsak konpilazio-denboran ezabatzen dituen tipo sistema. Kritikoa sistema mediko baten fidagarritasunerako, non NullPointerException batek dosi bital baten erregistroa galarazi dezakeen.

2. **Async/Await:** Programazio asinkrono elegantea datu-baseko eragiketetarako, jakinarazpenetarako eta fitxategi eragiketetarako UI blokeatu gabe.

3. **Extension Methods:** Lehendik dauden klaseak metodo pertsonalizatuekin hedatzea ahalbidetzen du, data formateatze eta modeloen balidazioetarako erabiltzen da.

4. **Records eta Pattern Matching (Dart 3.0+):** Datu-egitura aldaezinak funtziotatik balio anitzak modu seguruan itzultzeko.

5. **Strong Type System:** Tipado estatikoa konpilazio-denboran akatsak detektatzen dituena, ezinbestekoa eragiketa kritikoetarako hala nola stock kalkulua eta jakinarazpen programazioa.

**Zergatik Dart:**

- **UI-rako optimizatua:** Dart interfazeen garapenerako espezifikoki diseinatuta, zabor bilketa optimizatua animazioen artean pausak ekiditeko.
- **AOT eta JIT:** Ahead-of-Time konpilazioa produkziorako (errendimendu natibo) eta Just-in-Time garapenerako (Hot Reload).
- **Sintaxi ezaguna:** Java, C#, JavaScript-en antzekoa, ikasketa-kurba murriztuz.
- **Sound Null Safety:** Konpilazio-denboran bermea ez-null aldagaiak inoiz null izango ez direla.

**Dokumentazio ofiziala:** https://dart.dev

---

### Material Design 3

**Bertsioa:** Flutter 3.9.2+ inplementazio natiboan

**Helburua:**
Material Design 3 (Material You) Google-ren diseinu sistema da, interfaze modernoak, irisgarriak eta koherenteak sortzeko osagaiak, ereduak eta gidalerro-ak eskaintzen dituena.

**MedicApp-en inplementazioa:**

```dart
useMaterial3: true
```

**Erabilitako osagaiak:**

1. **Kolore eskema dinamikoa:** Hasieretan oinarritutako kolore sistema (`seedColor: Color(0xFF006B5A)` gai argiarentzat, `Color(0xFF00A894)` gai ilunarentzat) automatikoki 30+ tonalitate harmoniko sortzen dituena.

2. **FilledButton, OutlinedButton, TextButton:** Botoiak egoera bisualak dituztenak (hover, pressed, disabled) eta tamaina handituak (52dp gutxieneko altuera) irisgarritasunerako.

3. **Card elebazioa adaptatiboarekin:** Txartelak ertz borobilduak dituztenak (16dp) eta itzal finekin hierarkia bisualerako.

4. **NavigationBar:** Beheko nabigazio-barra adierazle animatuekin eta 3-5 helmuga nagusien arteko nabigaziorako euskarriarekin.

5. **FloatingActionButton hedatua:** FAB testu deskribatzailearekin ekintza nagusirako (medikamentua gehitu).

6. **ModalBottomSheet:** Orri modalak testu-laguntzarako ekintzak dosi erregistro azkarraren bat bezala.

7. **SnackBar ekintzaz:** Aldi baterako feedback eragiketa burutuetarako (dosia erregistratua, medikamentua gehitua).

**Gai pertsonalizatuak:**

MedicApp-ek bi gai oso inplementatzen ditu (argia eta iluna) tipografia irisgarriarekin:

- **Letra-tamaina handituak:** `titleLarge: 26sp`, `bodyLarge: 19sp` (22sp eta 16sp estandarrak baino handiagoak hurrenez hurren).
- **Kontraste hobetua:** Testu koloreak %87 opakutasunarekin funtsetan WCAG AA betetzeko.
- **Botoi handiak:** 52dp gutxieneko altuera (40dp estandarra vs) gailu mugikorretan ukipena errazteko.

**Zergatik Material Design 3:**

- **Irisgarritasun integratua:** Osagaiak pantaila-irakurleen euskarriarekin diseinatuak, gutxieneko ukipen-tamainak eta WCAG kontraste-ratioak.
- **Koherentzia Android ekosistemarekin:** Itxura ezaguna Android 12+ erabiltzaileentzat.
- **Pertsonalizazio malgua:** Diseinu token sistema koloreak, tipografiak eta formak egokitzea ahalbidetzen du koherentzia mantenduz.
- **Modu ilun automatikoa:** Gai ilunaren euskarri natibo sistemaren konfigurazioan oinarrituta.

**Dokumentazio ofiziala:** https://m3.material.io

---

## 2. Datu-Basea eta Iraunkortasuna

### sqflite ^2.3.0

**Erabilitako bertsioa:** `^2.3.0` (`2.3.0` bateragarria `< 3.0.0` arte)

**Helburua:**
sqflite Flutter-erako SQLite plugin-a da, SQL datu-base lokal, erlazional eta transakzionalera sarbidea ematen duena. MedicApp-ek SQLite erabiltzen du biltegi nagusi gisa medikamentu, pertsona, pauta konfigurazio eta dosi historialaren datu guztietarako.

**MedicApp-en datu-basearen arkitektura:**

```
medicapp.db
├── medications (taula nagusia)
│   ├── id (TEXT PRIMARY KEY)
│   ├── name (TEXT)
│   ├── type (TEXT)
│   ├── frequency (TEXT)
│   ├── times (TEXT JSON array)
│   ├── doses (TEXT JSON array)
│   ├── stock (REAL)
│   ├── fasting_before (INTEGER boolean)
│   ├── fasting_duration (INTEGER minutes)
│   └── ...
├── persons (V19+)
│   ├── id (TEXT PRIMARY KEY)
│   ├── name (TEXT)
│   └── is_default (INTEGER boolean)
├── person_medications (N:M erlazio-taula)
│   ├── person_id (TEXT)
│   ├── medication_id (TEXT)
│   ├── custom_times (TEXT JSON)
│   ├── custom_doses (TEXT JSON)
│   └── PRIMARY KEY (person_id, medication_id)
└── dose_history
    ├── id (TEXT PRIMARY KEY)
    ├── medication_id (TEXT)
    ├── person_id (TEXT)
    ├── timestamp (INTEGER)
    ├── dose_amount (REAL)
    └── scheduled_time (TEXT)
```

**Eragiketa kritikoak:**

1. **ACID transakzioak:** Atomikotasunaren bermea eragiketa konplexuetarako hala nola dosi erregistroa + stock deskontua + jakinarazpen programazioa.

2. **Kontsulta erlazionalak:** JOIN-ak `medications`, `persons` eta `person_medications` artean erabiltzaileko konfigurazio pertsonalizatuak lortzeko.

3. **Indize optimizatuak:** `person_id` eta `medication_id` indizeak erlazio-tauletan kontsulta azkarretarako O(log n).

4. **Bertsioko migrazioak:** Eskema migrazio-sistema V1-etik V19+ arte datuen preserba

zioarekin.

**Zergatik SQLite:**

1. **ACID betetzea:** Transakzio-bermeak kritikoak datu medikoetarako non osotasuna funtsezkoa den.

2. **SQL kontsulta konplexuak:** JOIN, agregazio eta subkontsultak txostenetarako eta iragazki aurreratuetarako gaitasuna.

3. **Frogatutako errendimendua:** SQLite munduko datu-base gehien hedatua da, 20+ urteko optimizazioekin.

4. **Zero-configuration:** Ez du zerbitzaririk, konfigurazioa edo administraziorik behar. Datu-basea fitxategi eramangarri bakarra da.

5. **Esportazio/inportazio sinplea:** `.db` fitxategia zuzenean kopiatu daiteke babeskopietarako edo gailuen arteko transferentzietarako.

6. **Tamaina mugagabea:** SQLite-k 281 terabyte arteko datu-baseak onartzen ditu, nahikoa hamarkada oso-osen dosi historialerako.

**Alternatibak alderatuz:**

| Ezaugarria | SQLite (sqflite) | Hive | Isar | Drift |
|----------------|------------------|------|------|-------|
| **Datu-eredua** | SQL erlazionala | NoSQL Key-Value | NoSQL Dokumentala | SQL erlazionala |
| **Kontsulta lengoaia** | SQL estandarra | Dart API | Dart Query Builder | SQL + Dart |
| **ACID transakzioak** | ✅ Osoa | ❌ Mugatua | ✅ Bai | ✅ Bai |
| **Migrazioak** | ✅ Eskuzko sendoa | ⚠️ Oinarrizko eskuzkoa | ⚠️ Erdi-automatikoa | ✅ Automatikoa |
| **Irakurketa errendimendua** | ⚡ Bikaina | ⚡⚡ Bikaina | ⚡⚡ Bikaina | ⚡ Bikaina |
| **Idazketa errendimendua** | ⚡ Oso ona | ⚡⚡ Bikaina | ⚡⚡ Bikaina | ⚡ Oso ona |
| **Diskoko tamaina** | ⚠️ Handiagoa | ✅ Trinkoa | ✅ Oso trinkoa | ⚠️ Handiagoa |
| **N:M Erlazioak** | ✅ Natibo | ❌ Eskuzkoa | ⚠️ Erreferentziak | ✅ Natibo |
| **Heldutasuna** | ✅ 20+ urte | ⚠️ 4 urte | ⚠️ 3 urte | ✅ 5+ urte |
| **Eramangarritasuna** | ✅ Unibertsala | ⚠️ Jabetarra | ⚠️ Jabetarra | ⚠️ Flutter-only |
| **Kanpoko tresnak** | ✅ DB Browser, CLI | ❌ Mugatuak | ❌ Mugatuak | ❌ Bat ere ez |

**SQLite justifikazioa alternatiben gainetik:**

- **Hive:** Baztertua N:M erlazio sendoen euskarri ezagatik (pertsona anitzeko arkitektura), ACID transakzio osoen ezagatik, eta JOIN-ekin kontsulta konplexuak egiteko zailtasunagatik.

- **Isar:** Baztertua errendimendu bikainarengatik gorabehera, heldugabearengatik (2022an kaleratua), formatu jabetuagatik tresna estandarrekin debugging-a zailduz, eta erlazio-kontsulta konplexuetan mugak.

- **Drift:** Serio kontuan hartua baina baztertua konplexutasun handiagoarengatik (kode sortzea behar du), aplikazioaren tamaina handiagoa, eta malgutasun txikiagoa SQL zuzenarekin alderatuta migrazio-etan.

**SQLite-ren konpromisoak:**

- ✅ **Aldekoak:** Egonkortasun frogatu, SQL estandarra, kanpoko tresnak, erlazio natiboak, esportazio arrunta.
- ❌ **Kontra:** Errendimendu pixka bat txikiagoa Hive/Isar-ekin alderatuta eragiketa masiboetan, fitxategi-tamaina handiagoa, SQL boilerplate eskuzkoa.

**Erabakia:** MedicApp-erako, N:M erlazio sendo behar izatea, V1-etik V19+ arte migrazio konplexuak, eta SQL tresna estandarrekin debugging gaitasuna, SQLite erabiltzea justifikatzen du guztiz NoSQL alternatiba azkarragoak baina heldugabeagoen gainetik.

**Dokumentazio ofiziala:** https://pub.dev/packages/sqflite

---

### sqflite_common_ffi ^2.3.0

**Erabilitako bertsioa:** `^2.3.0` (dev_dependencies)

**Helburua:**
sqflite-ren FFI (Foreign Function Interface) inplementazioa datu-base testak desktop/VM inguruneetan exekutatzen ahalbidetzen duena Android/iOS emuladoreen beharrik gabe.

**MedicApp-en erabilera:**

```dart
// test/helpers/database_test_helper.dart
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void setupTestDatabase() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}
```

**Zergatik beharrezkoa da:**

- **60x azkarragoak:** Datu-baseko testak VM lokalean exekutatzen dira Android emuladoreen ordez, denbora 120s-tik 2s-ra murriztuz suite osorako.
- **CI/CD emuladoreen gabe:** GitHub Actions-ek testak exekutatu ditzake emuladoreak konfiguratu gabe, pipeline-ak sinplifikatuz.
- **Debugging hobetua:** Testeko `.db` fitxategiak zuzenean eskuragarri daude host-aren fitxategi-sistematik.

**Dokumentazio ofiziala:** https://pub.dev/packages/sqflite_common_ffi

---

### path ^1.8.3

**Erabilitako bertsioa:** `^1.8.3`

**Helburua:**
Plataforma anitzeko fitxategi-bide manipulazio liburutegia, fitxategi-sistemen arteko diferentziak abstrahitzen dituena (Windows: `\`, Unix: `/`).

**MedicApp-en erabilera:**

```dart
import 'package:path/path.dart' as path;

final dbPath = path.join(await getDatabasesPath(), 'medicapp.db');
```

**Dokumentazio ofiziala:** https://pub.dev/packages/path

---

### path_provider ^2.1.5

**Erabilitako bertsioa:** `^2.1.5`

**Helburua:**
Plugin-a sistema eragilearen direktorio espezifikoetara sarbidea ematen duena modu plataforma-anizkoan (dokumentuak, cache, aplikazioaren euskarria).

**MedicApp-en erabilera:**

```dart
import 'package:path_provider/path_provider.dart';

// Datu-base direktorioaren lortze
final dbDirectory = await getDatabasesPath(); // Android: /data/data/com.medicapp/databases/

// Esportazioetarako direktorioaren lortze
final documentsDirectory = await getApplicationDocumentsDirectory();
```

**Erabilitako direktorioak:**

1. **getDatabasesPath():** `medicapp.db` fitxategi nagusirako.
2. **getApplicationDocumentsDirectory():** Erabiltzaileak partekatu ditzakeen datu-base esportazioetarako.
3. **getTemporaryDirectory():** Inportazioan aldi baterako fitxategietarako.

**Dokumentazio ofiziala:** https://pub.dev/packages/path_provider

---

## 3. Jakinarazpenak

### flutter_local_notifications ^19.5.0

**Erabilitako bertsioa:** `^19.5.0`

**Helburua:**
Flutter-erako jakinarazpen lokalen sistema osoa (ez dute zerbitzaririk behar), programatutakoentzako, errepikatuentzako, ekintzaz eta plataforma bakoitzeko pertsonalizatuengatiko euskarriarekin.

**MedicApp-en inplementazioa:**

MedicApp-ek jakinarazpen-sistema sofistikatu bat erabiltzen du jakinarazpen mota hiru kudeatzen dituena:

1. **Dosi-oroigarri jakinarazpenak:**
   - Erabiltzaileak konfiguratutako ordu zehatzetan programatuak.
   - Izena eta dosi xehetasunak barne (pertsona anitzean).
   - Ekintza azkarren euskarria: "Hartu", "Atzeratu", "Saltatu" (V20+-n baztertuak mota mugengatik).
   - Soinu pertsonalizatua eta lehentasun handiko kanala Android-en.

2. **Dosi aurreratuen jakinarazpenak:**
   - Detektatzen dute dosi bat bere programatutako ordua baino lehenago hartzen denean.
   - Automatikoki eguneratzen dute hurrengo jakinarazpena aplikatzen bada.
   - Ezabatzen dituzte ordua aurreratua dosi zaharretako jakinarazpenak.

3. **Barau-amaiera jakinarazpenak:**
   - Ongoing (iraunkor) jakinarazpena barau-aldian kontu atzerakaria.
   - Automatikoki ezabatzen da baraua amaitzen denean edo eskuz itxi denean.
   - Aurrerapen bisuala (Android) eta amaiera-ordua barne.

**Plataforma bakoitzeko konfigurazioa:**

**Android:**
```dart
AndroidInitializationSettings('app_icon')
AndroidNotificationDetails(
  'medication_reminders',
  'Medikamentu Oroigarriak',
  importance: Importance.high,
  priority: Priority.high,
  showWhen: true,
  enableLights: true,
  enableVibration: true,
  playSound: true,
)
```

**iOS:**
```dart
DarwinInitializationSettings(
  requestAlertPermission: true,
  requestBadgePermission: true,
  requestSoundPermission: true,
)
```

**Erabilitako ezaugarri aurreratuak:**

1. **Scheduling zehatza:** Bigarren zehaztasunez programatutako jakinarazpenak `timezone` erabiliz.
2. **Jakinarazpen-kanalak (Android 8+):** 3 kanal bereizi oroigarriak, baraua eta sistemara.
3. **Payload pertsonalizatua:** JSON datuak payload-ean medikamentua eta pertsona identifikatzeko.
4. **Interakzio callback-ak:** Callback-ak erabiltzaileak jakinarazpena ukitzen duenean.
5. **Baimen kudeaketa:** Baimenen eskaera eta egiaztapena Android 13+-n (Tiramisu).

**Mugak eta optimizazioak:**

- **500 jakinarazpen programatu batera muga** (Android sistemaren mugak).
- MedicApp-ek lehentasun automatikoa kudeatzen du muga hori gaindituz gero:
  - Lehentasuna hurrengo 7 egunetara.
  - Baztertzen ditu medikamentu ez-aktiboen jakinarazpenak.
  - Berrantol atu medikamentuak gehitu/ezabatzen direnean.

**Zergatik flutter_local_notifications:**

1. **Jakinarazpen lokalak vs urrunerakoak:** MedicApp-ek ez du backend zerbitzaririk behar, beraz jakinarazpen lokalak arkitektura zuzena dira.

2. **Funtzionalitate osoa:** Euskarria scheduling, errepikatzea, ekintzak, plataforma bakoitzerako pertsonalizazioa eta baimen kudeaketarako.

3. **Heldutasun frogatu:** 5+ urteko garapenarekin, GitHub-en 3000+ izarrak, ekoizpenean milaka aplikaziotan erabilia.

4. **Dokumentazio exhaustiboa:** Erabilera-kasu guztietarako adibide zehatzak.

**Zergatik EZ Firebase Cloud Messaging (FCM):**

| Irizpidea | flutter_local_notifications | Firebase Cloud Messaging |
|----------|----------------------------|--------------------------|
| **Zerbitzaria behar du** | ❌ Ez | ✅ Bai (Firebase) |
| **Konexioa behar du** | ❌ Ez | ✅ Bai (internet) |
| **Pribatutasuna** | ✅ Datu guztiak lokalak | ⚠️ Token-ak Firebase-n |
| **Latentzia** | ✅ Berehalakoā | ⚠️ Sare-menpekoa |
| **Kostua** | ✅ Doan | ⚠️ Kuota askea mugatua |
| **Setup konplexutasuna** | ✅ Minimoa | ❌ Altua (Firebase, server) |
| **Offline funtzionatzen du** | ✅ Beti | ❌ Ez |
| **Scheduling zehatza** | ✅ Bai | ❌ Ez (hurbilekoa) |

**Erabakia:** Medikamentu kudeaketarako aplikazio baterako non pribatutasuna kritikoa den, dosiak zehazki jakinarazi behar dira konexiorik gabe ere, eta ez dago zerbitzari-bezero komunikazioaren beharrik, jakinarazpen lokalak arkitektura zuzena eta sinpleena dira.

**Alternatibak alderatuz:**

- **awesome_notifications:** Baztertua adopzio txikiagatik (heldugabeagoa), API konplexuagoagatik, eta Android 12+-n programatutako jakinarazpenekin arazoak.

- **local_notifications (natibo):** Baztertua plataforma-espezifiko kodea (Kotlin/Swift) behar duelako, garapen ahalegina bikoiztuz.

**Dokumentazio ofiziala:** https://pub.dev/packages/flutter_local_notifications

---

### timezone ^0.10.1

**Erabilitako bertsioa:** `^0.10.1`

**Helburua:**
Ordu-zona kudeaketa liburutegia, jakinarazpenak eguneko une zehat zetan programatzea ahalbidetzen duena DST (Daylight Saving Time) aldaketak eta ordu-zonen arteko konbertsioak kontuan hartuz.

**MedicApp-en erabilera:**

```dart
import 'package:timezone/timezone.dart' as tz;

// Hasieraketa
await tz.initializeTimeZones();
final location = tz.getLocation('Europe/Madrid');
tz.setLocalLocation(location);

// Programatu jakinarazpena 08:00-etan lokalean
final scheduledDate = tz.TZDateTime(
  location,
  now.year,
  now.month,
  now.day,
  8, // ordua
  0, // minutuak
);

await flutterLocalNotificationsPlugin.zonedSchedule(
  id,
  title,
  body,
  scheduledDate,
  notificationDetails,
  uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
);
```

**Zergatik kritikoa da:**

- **Udako ordua:** `timezone` gabe, jakinarazpenak ordu 1 desplazatuko lirateke DST aldaketen bitartean.
- **Koherentzia:** Erabiltzaileek ordutegiak beren ordu-zona lokalean konfiguratzen dituzte, eta hori errespetatu behar da gailuaren ordu-zona aldaketa edozein dela ere.
- **Zehaztasuna:** `zonedSchedule` jakinarazpen zehatza bermatzen du zehaztutako unean.

**Dokumentazio ofiziala:** https://pub.dev/packages/timezone

---

### android_intent_plus ^6.0.0

**Erabilitako bertsioa:** `^6.0.0`

**Helburua:**
Android Intent-ak Flutter-etik abiarazteko plugin-a, espezifikoki jakinarazpen ezarpenak irekitzeko erabilia baimenak desgaituta daudenean.

**MedicApp-en erabilera:**

```dart
import 'package:android_intent_plus/android_intent.dart';

// App-aren jakinarazpen ezarpenak ireki
final intent = AndroidIntent(
  action: 'android.settings.APP_NOTIFICATION_SETTINGS',
  arguments: {
    'android.provider.extra.APP_PACKAGE': packageName,
  },
);
await intent.launch();
```

**Erabilera kasuak:**

1. **Erabiltzailea gidatu:** Jakinarazpen baimenak desgaituta daudenean, elkarrizketa-koadro azaltzaile bat erakusten da "Ezarpenak Ireki" botoiarekin MedicApp-en jakinarazpen-ezarpen-pantailara zuzenean abiarazten duena.

2. **UX hobetua:** Ekidin erabiltzaileak eskuz nabigatu behar izatea: Ezarpenak > Aplikazioak > MedicApp > Jakinarazpenak.

**Dokumentazio ofiziala:** https://pub.dev/packages/android_intent_plus

---

## 4. Lokalizazioa (i18n)

### flutter_localizations (SDK)

**Erabilitako bertsioa:** Flutter SDK-an sartuta

**Helburua:**
Flutter-en pakete ofiziala Material eta Cupertino widget-etarako lokalizazioak 85+ hizkuntzatan eskaintzen dituena, osagai estandarren itzulpenak barne (dialogoko botoiak, picker-ak, etab.).

**MedicApp-en erabilera:**

```dart
import 'package:flutter_localizations/flutter_localizations.dart';

MaterialApp(
  localizationsDelegates: [
    GlobalMaterialLocalizations.delegate, // Material widgets
    GlobalWidgetsLocalizations.delegate,  // Widget generikoak
    GlobalCupertinoLocalizations.delegate, // Cupertino (iOS)
  ],
  supportedLocales: [
    Locale('es'), // Gaztelania
    Locale('en'), // Ingelesa
    Locale('de'), // Alemana
    // ... 8 hizkuntza guztira
  ],
)
```

**Zer eskaintzen du:**

- Botoi estandarren itzulpenak: "OK", "Cancel", "Accept".
- Data eta ordua formatuak lokalizatuak: "15/11/2025" (es) vs "11/15/2025" (en).
- Data/ordu hautag ailuak hizkuntza lokalean.
- Egun eta hil-izenak.

**Dokumentazio ofiziala:** https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization

---

### intl ^0.20.2

**Erabilitako bertsioa:** `^0.20.2`

**Helburua:**
Dart-en nazioartekotze liburutegia datak, zenbakiak, pluralizazioa eta mezuen itzulpena ARB fitxategien bidez formateatzen dituena.

**MedicApp-en erabilera:**

```dart
import 'package:intl/intl.dart';

// Dataren formateatzea
final formatted = DateFormat('dd/MM/yyyy').format(DateTime.now());

// Zenbakien formateatzea
final stock = NumberFormat.decimalPattern().format(25.5);

// Pluralizazioa (ARB-tik)
// "{count, plural, =1{1 pastilla} other{{count} pastilla}}"
```

**Erabilera kasuak:**

1. **Dataren formateatzea:** Tratamendu hasiera/amaiera datak, dosi-historia erakustea.
2. **Zenbakien formateatzea:** Stock-a dezimalekin erakustea eskualde-konfigurazioaren arabera.
3. **Pluralizazio adimenduna:** Mezuak kantitateen arabera aldatu ("1 pastilla" vs "5 pastilla").

**Dokumentazio ofiziala:** https://pub.dev/packages/intl

---

### ARB Sistema (Application Resource Bundle)

**Erabilitako formatua:** ARB (JSON oinarritua)

**Helburua:**
Aplikazio-baliabide fitxategi sistema kateak JSON formatuan definitzea ahalbidetzen duena placeholder, pluralizazio eta metadatuen euskarriarekin.

**MedicApp-en konfigurazioa:**

**`l10n.yaml`:**
```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
untranslated-messages-file: untranslated_messages.json
```

**Fitxategi-egitura:**
```
lib/l10n/
├── app_es.arb (txantiloi nagusia, gaztelania)
├── app_en.arb (ingelesa itzulpenak)
├── app_de.arb (alemana itzulpenak)
├── app_fr.arb (frantsesa itzulpenak)
├── app_it.arb (italiera itzulpenak)
├── app_ca.arb (katalana itzulpenak)
├── app_eu.arb (euskara itzulpenak)
└── app_gl.arb (galiziera itzulpenak)
```

**ARB adibidea ezaugarri aurreratuekin:**

**`app_es.arb`:**
```json
{
  "@@locale": "es",

  "appTitle": "MedicApp",
  "@appTitle": {
    "description": "Título de la aplicación"
  },

  "medicationDose": "{count, plural, =1{1 {unit}} other{{count} {unit}}}",
  "@medicationDose": {
    "description": "Dosis de medicamento con pluralización",
    "placeholders": {
      "count": {
        "type": "num",
        "format": "decimalPattern"
      },
      "unit": {
        "type": "String"
      }
    }
  },

  "stockRemaining": "Quedan {stock} {unit, plural, =1{unidad} other{unidades}}",
  "@stockRemaining": {
    "placeholders": {
      "stock": {"type": "num"},
      "unit": {"type": "String"}
    }
  }
}
```

**Sorpen automatikoa:**

Flutter automatikoki `AppLocalizations` klasea sortzen du metodo tipizatuekin:

```dart
// Sortutako kodea .dart_tool/flutter_gen/gen_l10n/app_localizations.dart-en
class AppLocalizations {
  String get appTitle => 'MedicApp';

  String medicationDose(num count, String unit) {
    return Intl.plural(
      count,
      one: '1 $unit',
      other: '$count $unit',
      name: 'medicationDose',
      args: [count, unit],
    );
  }
}

// Kodean erabilera
Text(AppLocalizations.of(context)!.medicationDose(2.5, 'pastillak'))
// Emaitza: "2.5 pastillak"
```

**ARB sistemaren abantailak:**

1. **Tipado indartsua:** Itzulpen-akatsak konpilazioan detektatuak.
2. **Placeholder seguruak:** Ezinezkoa parametro beharrezkoak ahaztu.
3. **CLDR pluralizazioa:** Unicode CLDR arabera 200+ hizkuntzaren pluralizazio-arau-ematoa.
4. **Metadatu erabilgarriak:** Deskribapenak eta testuingurua itzultzaileentzat.
5. **Itzulpen tresnak:** Google Translator Toolkit, Crowdin, Lokalise-kin bateragarria.

**MedicApp-en itzulpen prozesua:**

1. Kateak `app_es.arb`-n definitu (txantiloia).
2. `flutter gen-l10n` exekutatu Dart kodea sortzeko.
3. Beste hizkuntzetan itzuli ARB fitxategiak kopiatu eta aldatuz.
4. `untranslated_messages.json` berrikusi falta diren kateak detektatzeko.

**Dokumentazio ofiziala:** https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization#adding-your-own-localized-messages

---

### 8 Hizkuntza Onartua

MedicApp 8 hizkuntzatara erabat itzulita dago:

| Kodea | Hizkuntza | Eskualde nagusia | Hiztunak (milioi) |
|--------|--------|------------------|----------------------|
| `es` | Español | Espainia, Latinamerika | 500M+ |
| `en` | English | Mundukoa | 1,500M+ |
| `de` | Deutsch | Alemania, Austria, Suitza | 130M+ |
| `fr` | Français | Frantzia, Kanada, Afrika | 300M+ |
| `it` | Italiano | Italia, Suitza | 85M+ |
| `ca` | Català | Katalunia, Valentzia, Balearrak | 10M+ |
| `eu` | Euskara | Euskal Herria | 750K+ |
| `gl` | Galego | Galizia | 2.5M+ |

**Estaldura osoa:** ~2,500 milioi potentzial hiztun

**Katea osoak:** ~450 itzulpen hizkuntzako

**Itzulpen kalitatea:**
- Gaztelania: Natibo (txantiloia)
- Ingelesa: Natibo
- Alemana, frantsesa, italiera: Profesionala
- Katalana, euskara, galiziera: Natibo (Espainiako ko-hizkuntza ofizialak)

**Sarturiko hizkuntzen justifikazioa:**

- **Gaztelania:** Garatzailearen hizkuntza nagusia eta hasierako helburu-merkatua (Espainia, Latinamerika).
- **Ingelesa:** Hizkuntza unibertsala mundu-mailako hedapenerako.
- **Alemana, frantsesa, italiera:** Mendebaldeko Europako hizkuntza nagusiak, osasun aplikazioen eskaera handiagoa duten merkatuak.
- **Katalana, euskara, galiziera:** Espainiako ko-hizkuntza ofizialak (17M+ biztanle dituzten eskualdeak), erabiltzaile nagusiagoek ama-hizkuntzean erosoagoak izateko irisgarritasuna hobetzen du.

---

## 5. Egoeraren Kudeaketa

### Egoera kudeaketa liburutegi gabe (Vanilla Flutter)

**Erabakia:** MedicApp-ek **EZ du** egoera kudeaketa liburutegirik erabiltzen (Provider, Riverpod, BLoC, Redux, GetX).

**Zergatik EZ da egoera kudeaketa erabiltzen:**

1. **Datu-basean oinarritutako arkitektura:** Aplikazioaren egoera egiazkoa SQLite-n dago, ez memorian. Pantaila bakoitzak datu-basea zuzenean kontsultatzen du eguneratutako datuak lortzeko.

2. **StatefulWidget + setState nahikoa da:** MedicApp bezalako konplexutasun ertaineko aplikazio baterako, `setState()` eta `StatefulWidget` egoeraren kudeaketa lokala nahikoa da.

3. **Sinpletasuna framework-en gainetik:** Mendekotasun beharrezkoak ekidituz konplexutasuna, aplikazioaren tamaina eta breaking change posibleak murrizten dira eguneraketetan.

4. **Datu-baseko stream-ak:** Datu erreaktiboetarako, `StreamBuilder` erabiltzen da `DatabaseHelper`-etik zuzeneko stream-ekin:

```dart
StreamBuilder<List<Medication>>(
  stream: DatabaseHelper.instance.watchMedications(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return CircularProgressIndicator();
    final medications = snapshot.data!;
    return ListView.builder(...);
  },
)
```

5. **Nabigazioa callback-ekin:** Pantailen arteko komunikaziorako, Flutter-en callback tradizionalak erabiltzen dira:

```dart
// Pantaila nagusia
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => AddMedicationScreen(
      onMedicationAdded: () {
        setState(() {}); // Zerrenda freskatu
      },
    ),
  ),
);
```

**Alternatibekin alderaketa:**

| Soluzioã | MedicApp (Vanilla) | Provider | BLoC | Riverpod |
|----------|-------------------|----------|------|----------|
| **Kode lerro gehigarriak** | 0 | ~500 | ~1,500 | ~800 |
| **Kanpoko mendekotasunak** | 0 | 1 | 2+ | 2+ |
| **Ikasketa-kurba** | ✅ Minimoa | ⚠️ Tartekoa | ❌ Altua | ⚠️ Tarteko-Altua |
| **Boilerplate** | ✅ Bat ere ez | ⚠️ Tartekoa | ❌ Altua | ⚠️ Tartekoa |
| **Testing** | ✅ Zuzena | ⚠️ Mock-ak behar | ⚠️ Setup behar | ⚠️ Setup behar |
| **Errendimendua** | ✅ Bikaina | ⚠️ Ona | ⚠️ Ona | ⚠️ Ona |
| **APK tamaina** | ✅ Minimoa | +50KB | +150KB | +100KB |

**Zergatik EZ Provider:**

- **Beharrezkoa ez:** Provider widget sakon habiaratuak artean egoera partekatzeko diseinatuta dago. MedicApp datuak datu-basetik lortzen ditu pantaila erro bakoitzean, egoera behera pasa beharrik gabe.
- **Konplexutasun gehigarria:** `ChangeNotifier`, `MultiProvider`, context-awareness eta widget-zuhaitza ulertzea behar du.
- **Injeniaritza gehiegi:** ~15 pantaila eta datu-basean egoera duen aplikazio baterako, Provider pneumatikozko mailua erabiltzea izango litzateke iltze bat sartzeko.

**Zergatik EZ BLoC:**

- **Konplexutasun zorrotza:** BLoC (Business Logic Component) stream, sink, gertaerak, egoerak eta geruzen arkitektura ulertzea behar du.
- **Boilerplate masiboa:** Ezaugarri bakoitzak 4-5 fitxategi behar ditu (bloc, event, state, repository, test).
- **Injeniaritza gehiegi:** BLoC bikaina da negozio-logika konplexu eta garatzaile anitzeko enpresa-aplikazioetarako. MedicApp konplexutasun ertaineko aplikazio bat da non sinpletasuna lehentasuna den.

**Zergatik EZ Riverpod:**

- **Heldugabea:** Riverpod nahiko berria da (2020) Provider (2018) eta BLoC (2018) alderatuta.
- **Provider-en antzeko konplexutasuna:** Provider-ak, autoDispose, family eta arkitektura deklaratiboa ulertzea behar du.
- **Abantaila argirik ez:** MedicApp-erako, Riverpod-ek ez du abantaila nabarmenik eskaintzen uneko arkitekturaren gainetik.

**Zergatik EZ Redux:**

- **Konplexutasun masiboa:** Redux-ek ekintzak, reducers, middleware, store eta aldaezintasun zorrotza behar ditu.
- **Boilerplate jasangaitza:** Eragiketa sinple batek ere fitxategi anitz eta ehunka lerro behar ditu.
- **Over-kill osoa:** Redux frontend-ean egoera konplexuarekin SPA web aplikazioetarako diseinatuta dago. MedicApp-ek egoera SQLite-n du, ez memorian.

**Kasuak NON BAI egoera kudeaketa behar litzateke:**

- **Memoria-egoera partekatua konplexua:** Pantaila anitzek objekte handiak memorian partekatu behar badituzte (ez da MedicApp-i aplika dakio).
- **Autentifikazio egoera globala:** Login/sesioak balego (MedicApp lokala da, konturik gabe).
- **Denbora errealeko sinkronizazioa:** Erabiltzaile-anitzeko elkarlan-lana denbora errealean balego (ez da aplikatzen).
- **Negozio-logika konplexua:** Kalkulazio astuna cache memorian behar balira (MedicApp stock eta dataren kalkulu sinpleak egiten ditu).

**Azken erabakia:**

MedicApp-erako, **Database as Single Source of Truth + StatefulWidget + setState** arkitektura zuzena da. Sinplea, zuzena, edozein garatzaile Flutter-entzat ulerterrazا da, eta konplexutasun beharrezkoa sartzen ez du. Provider, BLoC edo Riverpod gehitzea **cargo cult programming** hutsa izango litzateke (teknologia erabili arrunta delako, ez arazo erreala konpontzen duelako).

---

## 6. Biltegi Lokala

### shared_preferences ^2.2.2

**Erabilitako bertsioa:** `^2.2.2`

**Helburua:**
Erabiltzailearen hobespenen, aplikazio-konfigurazioen eta egoera ez-kritikoen gako-balio iraunkortasuna. Android-en `SharedPreferences` eta iOS-en `UserDefaults` erabiltzen ditu.

**MedicApp-en erabilera:**

MedicApp-ek `shared_preferences` erabiltzen du SQL taula justifikatzen ez duten konfigurazio arinak gordetzeko:

**`lib/services/preferences_service.dart`:**
```dart
class PreferencesService {
  static const _keyThemeMode = 'theme_mode';
  static const _keyLocale = 'locale';
  static const _keyNotificationsEnabled = 'notifications_enabled';

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeMode, mode.toString());
  }

  Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final modeStr = prefs.getString(_keyThemeMode);
    return ThemeMode.values.firstWhere(
      (e) => e.toString() == modeStr,
      orElse: () => ThemeMode.system,
    );
  }
}
```

**Gordetako datuak:**

1. **Aplikazio gaia:**
   - Gakoa: `theme_mode`
   - Balioak: `ThemeMode.light`, `ThemeMode.dark`, `ThemeMode.system`
   - Erabilera: Gai hobespena sesioen artean iraunkortasuna.

2. **Hautatutako hizkuntza:**
   - Gakoa: `locale`
   - Balioak: `es`, `en`, `de`, `fr`, `it`, `ca`, `eu`, `gl`
   - Erabilera: Erabiltzaileak hautatutako hizkuntza gogoratu (sistemaren hizkuntzaren override-a).

3. **Baimenen egoera:**
   - Gakoa: `notifications_enabled`
   - Balioak: `true`, `false`
   - Erabilera: Baimen-egoeraren cache lokala deiak natiboak errepikatu ez ondua.

4. **Lehen exekuzioa:**
   - Gakoa: `first_run`
   - Balioak: `true`, `false`
   - Erabilera: Tutorial/onboarding lehen exekuzioan bakarrik erakutseko.

**Zergatik shared_preferences eta ez SQLite:**

- **Errendimendua:** Balio sinpleentzat O(1) sarbide berehalakoa SQL kontsultarekin overhead vs.
- **Sinpletasuna:** API erraza (`getString`, `setString`) SQL kontsultak prestatu vs.
- **Helburua:** Erabiltzailearen hobespenak vs datu erlazionalak.
- **Tamaina:** Balio txikiak (< 1KB) vs erregistro konplexuak.

**shared_preferences mugak:**

- ❌ Ez du onartzen erlazioak, JOIN-ak, transakzioak.
- ❌ Ez da egokia >100KB datu-ak.
- ❌ Sarbide asinkronoa (`await` behar).
- ❌ Tipo primitiboak bakarrik (String, int, double, bool, List<String>).

**Konpromisoak:**

- ✅ **Aldekoak:** API sinplea, errendimendu bikaina, helburua egokia hobespenetan.
- ❌ **Kontra:** Ez da egokia datu egituratuetarako edo bolumentsuetarako.

**Dokumentazio ofiziala:** https://pub.dev/packages/shared_preferences

---

## 7. Fitxategi Eragiketak

### file_picker ^8.0.0+1

**Erabilitako bertsioa:** `^8.0.0+1`

**Helburua:**
Plataforma anitzeko plugin-a gailuaren fitxategi-sistematik fitxategiak hautatzeko, plataforma anitzeko euskarriarekin (Android, iOS, desktop, web).

**MedicApp-en erabilera:**

MedicApp-ek `file_picker` esklus iboki erabiltzen du **datu-basearen inportazio** funtziorako, erabiltzaileari babeskopia bat leheneratu edo beste gailu batetik datuak migratzea ahalbidetuz.

**Inplementazioa:**

```dart
import 'package:file_picker/file_picker.dart';

Future<void> importDatabase() async {
  // Fitxategi hautatzailea ireki
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['db'],
    dialogTitle: 'Datu-base fitxategia hautatu',
  );

  if (result == null) return; // Erabiltzaileak ezeztatu du

  final file = result.files.single;
  final path = file.path!;

  // Fitxategia balioztatu eta kopiatu
  await DatabaseHelper.instance.importDatabase(path);

  // Aplikazioa birkargatu
  setState(() {});
}
```

**Erabilitako ezaugarriak:**

1. **Luzapen iragazkia:** `.db` fitxategiak bakarrik hautatzea ahalbidetzen du erabiltzailearen akatsak saihesteko.
2. **Titulu pertsonalizatua:** Sistemaren elkarrizketa-koadroan mezu deskribatzailea erakusten du.
3. **Bide osoa:** Fitxategiaren bide absolutoa lortzen du app-aren kokapenera kopiatzeko.

**Kontuan hartutako alternatioak:**

- **image_picker:** Baztertua espezifikoki irudietarako/bideoetarako diseinatuta dagoelako, ez fitxategi generikoetarako.
- **Kode natibo:** Baztertua `ActivityResultLauncher` (Android) eta `UIDocumentPickerViewController` (iOS) eskuz inplementatu behar luke.

**Dokumentazio ofiziala:** https://pub.dev/packages/file_picker

---

### share_plus ^10.1.4

**Erabilitako bertsioa:** `^10.1.4`

**Helburua:**
Plataforma anitzeko plugin-a fitxategiak, testua eta URL-ak partekatzeko sistema eragilearen parteka. tze-orri natibo erabiliz (Android Share Sheet, iOS Share Sheet).

**MedicApp-en erabilera:**

MedicApp-ek `share_plus` erabiltzen du **datu-basearen esportazio** funtziorako, erabiltzaileari babeskopia sortu eta email, cloud storage (Drive, Dropbox), Bluetooth edo fitxategi lokaletan partekatzea ahalbidetuz.

**Inplementazioa:**

```dart
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

Future<void> exportDatabase() async {
  // Uneko datu-basearen bidea lortu
  final dbPath = await DatabaseHelper.instance.getDatabasePath();

  // Direktorio partekatzeko aldi baterako kopia sortu
  final tempDir = await getTemporaryDirectory();
  final exportPath = '${tempDir.path}/medicapp_backup_${DateTime.now().millisecondsSinceEpoch}.db';

  // Datu-basea kopiatu
  await File(dbPath).copy(exportPath);

  // Fitxategia partekatu
  await Share.shareXFiles(
    [XFile(exportPath)],
    subject: 'MedicApp Babeskopia',
    text: 'MedicApp-en datu-basea - ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
  );
}
```

**Erabiltzailearen fluxua:**

1. Erabiltzaileak "Datu-basea esportatu" ukitzen du konfigurazio menuan.
2. MedicApp-ek `medicapp.db`-ren kopia sortzen du izenean timestamp-arekin.
3. SO-aren partekakte-orri natibo irekitzen da.
4. Erabiltzaileak helburua hautatzen du: Gmail (eranskin gisa), Drive, Bluetooth, "Gorde fitxategietan", etab.
5. `.db` fitxategia hautatutako helburuan partekatzen/gordetzen da.

**Ezaugarri aurreratuak:**

- **XFile:** Plataforma anitzeko fitxategien abstrakzio Android, iOS, desktop eta web-en funtzionatzen duena.
- **Metadatuak:** Fitxategi-izen deskribatzailea eta testu azaltzailea barne.
- **Bateragarritasuna:** SO-aren partekakte-protokoloarekin bateragarriak diren app guztiekin funtzionatzen du.

**Zergatik share_plus:**

- **UX natibo:** Erabiltzaileak dagoeneko ezagutzen duen partekaketa-interfazea erabiltzen du, gurpila berriro asmatu gabe.
- **Integrazione perfektua:** Automatikoki integratzen da fitxategiak jaso ditzaketen instalatutako app guztiekin.
- **Plataforma anitza:** Kode bera Android eta iOS-en funtzionatzen du bakoitzean natiboaren portaerarekin.

**Kontuan hartutako alternatioak:**

- **Direktorio publikora zuzenean idatzi:** Baztertua Android 10+-n (Scoped Storage) baimen konplexuak behar dituelako eta modu koherentean funtzionatzen ez duelako.
- **Email plugin-a zuzenean:** Baztertua erabiltzailea babeskopia-metodo bakarrera mugatzen duelako (email), `share_plus`-ek edozein helburura baimentzen duen bitartean.

**Dokumentazio ofiziala:** https://pub.dev/packages/share_plus

---

## 8. Testing

### flutter_test (SDK)

**Erabilitako bertsioa:** Flutter SDK-an sartuta

**Helburua:**
Flutter-en testing framework ofiziala unit test, widget test eta integration test-etarako beharrezkoak diren tresna guztiak eskaintzen dituena.

**MedicApp-en testing arkitektura:**

MedicApp-ek **432+ test** ditu 3 kategoriatara antolatuak:

#### 1. Unit Tests (%60eko testak)

Negozio-logika puru, modelo, zerbitzu eta helper-en testak Flutter mendekotasunik gabe.

**Adibideak:**
- `test/medication_model_test.dart`: Datu-modeloen balioztapena.
- `test/dose_history_service_test.dart`: Dosi-historiaren logika.
- `test/notification_service_test.dart`: Jakinarazpen-programazioaren logika.
- `test/preferences_service_test.dart`: Hobespen-zerbitzua.

**Egitura tipikoa:**
```dart
void main() {
  setUpAll(() async {
    // Test datu-basea hasieratu
    setupTestDatabase();
  });

  tearDown(() async {
    // Datu-basea garbitu test bakoitzaren ondoren
    await DatabaseHelper.instance.close();
  });

  group('Medication Model', () {
    test('baliozko datuak duen medikamentua sortu behar du', () {
      final medication = Medication(
        id: 'test-id',
        name: 'Ibuprofeno',
        type: MedicationType.pill,
      );

      expect(medication.id, 'test-id');
      expect(medication.name, 'Ibuprofeno');
      expect(medication.type, MedicationType.pill);
    });

    test('hurrengo dosi ordua zuzen kalkulatu behar du', () {
      final medication = Medication(
        id: 'test',
        name: 'Test',
        times: ['08:00', '20:00'],
      );

      final now = DateTime(2025, 1, 15, 10, 0); // 10:00 AM
      final nextDose = medication.getNextDoseTime(now);

      expect(nextDose.hour, 20); // Hurrengo dosia 20:00-tan
    });
  });
}
```

#### 2. Widget Tests (%30eko testak)

Widget indibidualak, UI elkarreraginak eta nabigazio-fluxuen testak.

**Adibideak:**
- `test/settings_screen_test.dart`: Konfigurazio pantaila.
- `test/edit_schedule_screen_test.dart`: Ordutegi editorea.
- `test/edit_duration_screen_test.dart`: Iraupena editorea.
- `test/day_navigation_ui_test.dart`: Egunen nabigazioa.

**Egitura tipikoa:**
```dart
void main() {
  testWidgets('medikamentu-zerrenda erakutsi behar du', (tester) async {
    // Arrange: Test datuak prestatu
    final medications = [
      Medication(id: '1', name: 'Ibuprofeno', type: MedicationType.pill),
      Medication(id: '2', name: 'Parazeta mola', type: MedicationType.pill),
    ];

    // Act: Widget-a eraiki
    await tester.pumpWidget(
      MaterialApp(
        home: MedicationListScreen(medications: medications),
      ),
    );

    // Assert: UI egiaztatu
    expect(find.text('Ibuprofeno'), findsOneWidget);
    expect(find.text('Parazeta mola'), findsOneWidget);

    // Interakzioa: Lehen medikamentua ukitu
    await tester.tap(find.text('Ibuprofeno'));
    await tester.pumpAndSettle();

    // Nabigazioa egiaztatu
    expect(find.byType(MedicationDetailScreen), findsOneWidget);
  });
}
```

#### 3. Integration Tests (%10eko testak)

Pantaila anitz, datu-basea eta zerbitzuak barne hartzen dituzten fluxu osoen end-to-end testak.

**Adibideak:**
- `test/integration/add_medication_test.dart`: Medikamentua gehitzeko fluxu osoa (8 urrats).
- `test/integration/dose_registration_test.dart`: Dosi-erregistroa eta stock eguneratzea.
- `test/integration/stock_management_test.dart`: Stock kudeaketa osoa (birkargatzea, agortzea, alertak).
- `test/integration/app_startup_test.dart`: Aplikazioaren hasiera eta datuen karga.

**Egitura tipikoa:**
```dart
void main() {
  testWidgets('medikamentua gehitzeko fluxu osoa', (tester) async {
    // Aplikazioa hasi
    await tester.pumpWidget(const MedicApp());
    await tester.pumpAndSettle();

    // 1. urratsa: Medikamentua gehitzeko pantaila ireki
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // 2. urratsa: Izena sartu
    await tester.enterText(find.byType(TextField).first, 'Ibuprofeno 600mg');

    // 3. urratsa: Mota aukeratu
    await tester.tap(find.text('Pastilla'));
    await tester.pumpAndSettle();

    // 4. urratsa: Hurrengo urratsa
    await tester.tap(find.text('Hurrengoa'));
    await tester.pumpAndSettle();

    // ... 8 urratsekin jarraitu

    // Medikamentua gehituta egiaztatu
    expect(find.text('Ibuprofeno 600mg'), findsOneWidget);

    // Datu-basean egiaztatu
    final medications = await DatabaseHelper.instance.getMedications();
    expect(medications.length, 1);
    expect(medications.first.name, 'Ibuprofeno 600mg');
  });
}
```

**Kodearen estaldura:**

- **Helburua:** %75-80
- **Erreala:** %75-80 (432+ test)
- **Estalitako lerroak:** ~12,000 ~15,000-tik

**Estaldura handiena duten eremuak:**
- Modeloak: %95+ (datu-logika kritikoa)
- Zerbitzuak: %85+ (jakinarazpenak, datu-basea, dosiak)
- Pantailak: %65+ (UI eta nabigazioa)

**Estaldura txikiena duten eremuak:**
- Helper eta utilities: %60
- Hasieraketa kodea: %50

**Testing estrategia:**

1. **Test-first logika kritikorako:** Testak kodera baino lehen idatziak dosi, stock, ordutegin kalkuluetarako.
2. **Test-after UI-rentzat:** Testak pantailak inplementatu ondoren idatziak portaera egiaztatzeko.
3. **Regression tests:** Aurkitutako bug bakoitza bihurtzen da testak erregreisioak saihesteko.

**Testing komandoak:**

```bash
# Test guztiak exekutatu
flutter test

# Testak estaldurarekin
flutter test --coverage

# Test espezifikoak
flutter test test/medication_model_test.dart

# Integratze testak
flutter test test/integration/
```

**Testing helper-ak:**

**`test/helpers/database_test_helper.dart`:**
```dart
void setupTestDatabase() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}

Future<void> cleanDatabase() async {
  await DatabaseHelper.instance.close();
  await DatabaseHelper.instance.database; // Garbitu berriro sortu
}
```

**`test/helpers/medication_factory.dart`:**
```dart
class MedicationFactory {
  static Medication createPill({String name = 'Test Medication'}) {
    return Medication(
      id: const Uuid().v4(),
      name: name,
      type: MedicationType.pill,
      stock: 30,
      times: ['08:00', '20:00'],
      doses: [1, 1],
    );
  }
}
```

**Dokumentazio ofiziala:** https://docs.flutter.dev/testing

---

## 9. Garapen Tresnak

### flutter_launcher_icons ^0.14.4

**Erabilitako bertsioa:** `^0.14.4` (dev_dependencies)

**Helburua:**
Aplikazio ikonoak automatikoki sortzen dituen paketea tamaina eta formatu guztietarako Android eta iOS-en iturri irudi bakar batetik.

**MedicApp-en konfigurazioa:**

**`pubspec.yaml`:**
```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/icon.png"
  adaptive_icon_background: "#419e69"
  adaptive_icon_foreground: "assets/images/icon.png"
  min_sdk_android: 21
```

**Sortutako ikonoak:**

**Android:**
- `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` (72x72)
- `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` (48x48)
- `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png` (96x96)
- `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` (144x144)
- `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` (192x192)
- Android 8+ ikono moldakorrak (foreground + background bereiziak)

**iOS:**
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/` (20x20-tik 1024x1024-ra, 15+ barianteak)

**Sorpen-komandoa:**

```bash
flutter pub run flutter_launcher_icons
```

**Zergatik tresna hau:**

- **Automatizazioa:** 20+ ikono fitxategi eskuz sortzea neketsua eta akatsak egiteko propenoa izango litzateke.
- **Ikono moldakorrak (Android 8+):** Launcher-aren araberako forma desberdinetara egokitzen diren ikono moldakorren euskarria.
- **Optimizazioa:** Ikonoak PNG formatu optimizatuan sortzen dira.
- **Koherentzia:** Bermatzen du tamaina guztiak iturri bera dikoa sortzen direla.

**Dokumentazio ofiziala:** https://pub.dev/packages/flutter_launcher_icons

---

### flutter_native_splash ^2.4.7

**Erabilitako bertsioa:** `^2.4.7` (dev_dependencies)

**Helburua:**
Android eta iOS-erako splash screen natiboak sortzen dituen paketea, Flutter hasieratzen den bitartean berehala erakutsiz.

**MedicApp-en konfigurazioa:**

**`pubspec.yaml`:**
```yaml
flutter_native_splash:
  color: "#419e69"  # Atzeko planoko kolorea (MedicApp berdea)
  image: assets/images/icon.png  # Erdiko irudia
  android: true
  ios: true
  fullscreen: true
  android_12:
    image: assets/images/icon.png
    color: "#419e69"
```

**Inplementatutako ezaugarriak:**

1. **Splash bateratua:** Itxura bera Android eta iOS-en.
2. **Marka kolorea:** `#419e69` berdea (MedicApp-en kolore nagusia).
3. **Logo erdian:** MedicApp-en ikonoa pantailaren erdian.
4. **Pantaila osoa:** Egoera-barra ezkutatu splash-ean.
5. **Android 12+ espezifikoa:** Konfigurazio berezia Android 12-ren splash sistema berriari jarraitzeko.

**Sortutako fitxategiak:**

**Android:**
- `android/app/src/main/res/drawable/launch_background.xml`
- `android/app/src/main/res/values/styles.xml` (splash gaia)
- `android/app/src/main/res/values-night/styles.xml` (gai iluna)

**iOS:**
- `ios/Runner/Assets.xcassets/LaunchImage.imageset/`
- `ios/Runner/Base.lproj/LaunchScreen.storyboard`

**Sorpen-komandoa:**

```bash
flutter pub run flutter_native_splash:create
```

**Zergatik splash natibo:**

- **UX profesionala:** Ekidin pantaila zuria Flutter-en hasieraketa 1-2 segundutan.
- **Branding berehalakoa:** Logoa eta marka koloreak lehen frame-tik erakusten ditu.
- **Abiadura pertzepzioa:** Branding-dun splash-ak pantaila zuria baino azkarragoa dirudi.

**Dokumentazio ofiziala:** https://pub.dev/packages/flutter_native_splash

---

### uuid ^4.0.0

**Erabilitako bertsioa:** `^4.0.0`

**Helburua:**
UUID (Universally Unique Identifiers) v4 sortzailea medikamentuen, pertsonen eta dosi-erregistroen identifikadore bakarrak sortzeko.

**MedicApp-en erabilera:**

```dart
import 'package:uuid/uuid.dart';

const uuid = Uuid();

final medication = Medication(
  id: uuid.v4(), // Sortzen du: "f47ac10b-58cc-4372-a567-0e02b2c3d479"
  name: 'Ibuprofeno',
  type: MedicationType.pill,
);
```

**Zergatik UUID-ak:**

- **Bakartasun globala:** Talka probabilitatea: 10³⁸-tan 1 (praktikan ezinezkoa).
- **Offline sortzea:** Ez du zerbitzariarekin edo datu-baseko sekuentziekin koordinaziorik behar.
- **Etorkizuneko sinkronizazioa:** MedicApp-ek cloud sinkronizazioa gehitzen badu, UUID-ak ID gatazkak ekiditen ditu.
- **Depurazioa:** Log-etan ID deskribatzaileak zenbaki generikoetan (1, 2, 3).

**Kontuan hartutako alternatiboa:**

- **Auto-increment osokoa:** Baztertua SQLite-n sekuentzien kudeaketa beharko lukeelaako eta etorkizuneko sinkronizazioan gatazkak sor ditzakeelaako.

**Dokumentazio ofiziala:** https://pub.dev/packages/uuid

---

## 10. Plataformaren Mendekotasunak

### Android

**Build konfigurazioa:**

**`android/app/build.gradle.kts`:**
```kotlin
android {
    namespace = "com.medicapp.medicapp"
    compileSdk = 34
    minSdk = 21  // Android 5.0 Lollipop
    targetSdk = 34  // Android 14

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true  // API modernoak Android < 26-rako
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```

**Tresnak:**

- **Gradle 8.0+:** Android-en build sistema.
- **Kotlin 1.9.0:** Android-erako kode natiboaren lengoaia (nahiz eta MedicApp-ek ez duen Kotlin kode pertsonalizaturik).
- **AndroidX:** Euskarri liburutegi modernoak (Support Library-ren ordezkoa).

**Gutxieneko bertsioak:**

- **minSdk 21 (Android 5.0 Lollipop):** %99+ Android gailu aktiboen estaldura.
- **targetSdk 34 (Android 14):** Android-en azken bertsioa ezaugarri modernoak aprobetxatzeko.

**Beharrezko baimenak:**

**`android/app/src/main/AndroidManifest.xml`:**
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" /> <!-- Android 13+ -->
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" /> <!-- Jakinarazpen zehatzak -->
<uses-permission android:name="android.permission.USE_EXACT_ALARM" /> <!-- Android 14+ -->
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" /> <!-- Berrabiarazpenaren ondoren jakinarazpenak berriro programatu -->
```

**Dokumentazio ofiziala:** https://developer.android.com

---

### iOS

**Build konfigurazioa:**

**`ios/Runner/Info.plist`:**
```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>

<key>NSUserNotificationsUsageDescription</key>
<string>MedicApp-ek jakinarazpenak bidali behar ditu zure medikamentuak hartzeko gogoratzeko.</string>
```

**Tresnak:**

- **CocoaPods 1.11+:** iOS-en mendekotasun natiboen kudeatzailea.
- **Xcode 14+:** iOS aplikazioak konpilatzeko beharrezko IDE-a.
- **Swift 5.0:** iOS-erako kode natiboaren lengoaia (nahiz eta MedicApp-ek AppDelegate lehenetsia erabiltzen duen).

**Gutxieneko bertsioak:**

- **iOS 12.0+:** %98+ iOS gailu aktiboen estaldura.
- **iPadOS 12.0+:** iPad-erako euskarri osoa.

**Beharrezko gaitasunak:**

- **Push Notifications:** MedicApp-ek jakinarazpen lokalak erabiltzen baditu ere, gaitasun honek jakinarazpenen framework-a gaitzen du.
- **Background Fetch:** Jakinarazpenak eguneratzeko aukera app atzeko planoan dagoenean.

**Dokumentazio ofiziala:** https://developer.apple.com/documentation/

---

## 11. Bertsioak eta Bateragarritasuna

### Mendekotasunen Taula

| Mendekotasuna | Bertsioa | Helburua | Kategoria |
|-------------|---------|-----------|-----------|
| **Flutter SDK** | `3.9.2+` | Framework nagusia | Core |
| **Dart SDK** | `3.9.2+` | Programazio-lengoaia | Core |
| **cupertino_icons** | `^1.0.8` | iOS ikonoak | UI |
| **sqflite** | `^2.3.0` | SQLite datu-basea | Iraunkortasuna |
| **path** | `^1.8.3` | Bideen manipulazioa | Utilitatea |
| **flutter_local_notifications** | `^19.5.0` | Jakinarazpen lokalak | Jakinarazpenak |
| **timezone** | `^0.10.1` | Ordu-zonak | Jakinarazpenak |
| **intl** | `^0.20.2` | Nazioartekotzea | i18n |
| **android_intent_plus** | `^6.0.0` | Android Intent-ak | Baimenak |
| **shared_preferences** | `^2.2.2` | Erabiltzailearen hobespenak | Iraunkortasuna |
| **file_picker** | `^8.0.0+1` | Fitxategi hautatzailea | Fitxategiak |
| **share_plus** | `^10.1.4` | Fitxategiak partekatu | Fitxategiak |
| **path_provider** | `^2.1.5` | Sistemaren direktorioak | Iraunkortasuna |
| **uuid** | `^4.0.0` | UUID sortzailea | Utilitatea |
| **sqflite_common_ffi** | `^2.3.0` | SQLite Testing | Testing (dev) |
| **flutter_launcher_icons** | `^0.14.4` | Ikono sortzea | Tresna (dev) |
| **flutter_native_splash** | `^2.4.7` | Splash screen | Tresna (dev) |
| **flutter_lints** | `^6.0.0` | Analisi estatikoa | Tresna (dev) |

**Produkzioko mendekotasun osoa:** 14
**Garapeneko mendekotasun osoa:** 4
**Guztira:** 18

---

### Plataformen Bateragarritasuna

| Plataforma | Gutxieneko bertsioa | Helburu bertsioa | Estaldura |
|------------|----------------|------------------|-----------|
| **Android** | 5.0 (API 21) | 14 (API 34) | %99+ gailuak |
| **iOS** | 12.0 | 17.0 | %98+ gailuak |
| **iPadOS** | 12.0 | 17.0 | %98+ gailuak |

**Ez onartua:** Web, Windows, macOS, Linux (MedicApp diseinuz esklus iboki mugikorra da).

---

### Flutter Bateragarritasuna

| Flutter | Bateragarria | Oharrak |
|---------|------------|-------|
| 3.9.2 - 3.10.x | ✅ | Garapen bertsioa |
| 3.11.x - 3.19.x | ✅ | Bateragarria aldaketarik gabe |
| 3.20.x - 3.35.x | ✅ | 3.35.7-ra arte probatua |
| 3.36.x+ | ⚠️ | Ziurrenik bateragarria, ez probatua |
| 4.0.x | ❌ | Mendekotasunak eguneratu behar dira |

---

## 12. Alderaketoak eta Erabakiak

### 12.1. Datu-Basea: SQLite vs Hive vs Isar vs Drift

**Erabakia:** SQLite (sqflite)

**Justifikazio hedatua:**

**MedicApp-en eskakizunak:**

1. **N:M Erlazioak (Asko Askorekin):** Medikamentu bat pertsona anitzei esleitu dakieke, eta pertsona batek medikamentu anitz izan ditzake. Arkitektura hau SQL-en natibo da baina NoSQL-en konplexua.

2. **Kontsulta konplexuak:** Pertsona baten medikamentu guztiak lortzea bere konfigurazio pertsonalizatuekin JOIN-ak behar ditu 3 taularen artean:

```sql
SELECT m.*, pm.custom_times, pm.custom_doses
FROM medications m
JOIN person_medications pm ON m.id = pm.medication_id
JOIN persons p ON pm.person_id = p.id
WHERE p.id = ?
```

Hau SQL-en erreza da baina NoSQL-en kontsulta anitz eta logika eskulana behar luke.

3. **Migrazio konplexuak:** MedicApp V1-etik (medikamentu taula sinplea) V19+-ra (pertsona anitzeko erlazioez) eboluzionatu da. SQLite-k SQL migrazio inkrementalak ahalbidetzen ditu datuak preserba tuz:

```sql
-- V18 -> V19 migrazioa: Pertsona anitza gehitu
ALTER TABLE medications ADD COLUMN shared_stock REAL;
CREATE TABLE persons (...);
CREATE TABLE person_medications (...);
INSERT INTO persons (id, name, is_default) VALUES (?, 'Ni', 1);
INSERT INTO person_medications SELECT ?, id, times, doses FROM medications;
```

**Hive:**

- ✅ **Aldekoak:** Errendimendu bikaina, API sinplea, tamaina trinkoa.
- ❌ **Kontra:**
  - **Erlazio natiboak ez:** N:M inplementatzeak ID zerrendak eskuz mantendu eta kontsulta anitz egin behar ditu.
  - **ACID transakzio osoak ez:** Ezin du atomikotasuna bermatu eragiketa konplexuetan (dosi erregistroa + stock deskontua + jakinarazpena).
  - **Migrazio eskuzkoak:** Ez dago eskema bertsioketa sistema, logika pertsonaliz atua behar du.
  - **Debugging zaila:** Formatu binario jabetarra, ezin da tresna estandarrekin ikuskatu.

**Isar:**

- ✅ **Aldekoak:** Errendimendu bikaina, indizazio azkarra, Dart sintaxi elegantea.
- ❌ **Kontra:**
  - **Heldugabea:** 2022an kaleratua, SQLite (20+ urte) baino heldugabeagoa.
  - **Erlazio mugatuak:** Erlazioak onartzen ditu baina SQL JOIN-ak bezain malguak ez (1:1, 1:N mugatua, M:N zuzeneko ez).
  - **Formatu jabetarra:** Hive-ren antzekoa, kanpoko tresnekin debugging-a zailduz.
  - **Lock-in:** Isar-etik beste soluzio batera migratzea garestia izango litzateke.

**Drift:**

- ✅ **Aldekoak:** Type-safe SQL, migrazio automatikoak, sortutako API-ak.
- ❌ **Kontra:**
  - **Konplexutasuna:** Kode sortzea behar du, `.drift` fitxategiak, eta build_runner konfigurazio konplexua.
  - **Boilerplate:** Eragiketa sinple batek ere taula fitxategi berezietan definitu behar dira.
  - **Tamaina:** APK tamaina ~200KB sqflite zuzenekoarekin alderatuta handitzen du.
  - **Malgutasuna murriztua:** Kontsulta konplexu ad-hoc-ak SQL zuzenean baino zailagoak dira.

**Emaitza finala:**

MedicApp-erako, non N:M erlazioak funts ezkoak diren, migrazioak maiztruak izan diren (eskema-bertsioko 19), eta DB Browser for SQLite-rekin debugging gaitasuna baliotsua izan den garapenean, SQLite hautaketa zuzena da.

**Onartutako konpromi soa:**

%10-15 errendimendu eragiketa masiboetan (MedicApp-en erabilera-kasuetan garrantzirik ez duena) sakrifikatzen dugu SQL malgutasun osorako, tresna helduetarako eta datu-arkitektura sendorako.

---

### 12.2. Jakinarazpenak: flutter_local_notifications vs awesome_notifications vs Firebase

**Erabakia:** flutter_local_notifications

**Justifikazio hedatua:**

**MedicApp-en eskakizunak:**

1. **Zehaztasun tenporala:** Jakinarazpenak programatutako orduan zehaztaz heldu behar dira (08:00:00, ez 08:00:30).
2. **Offline funtzionatzea:** Medikamentuak internet konexiorik gabe hartzen dira.
3. **Pribatutasuna:** Datu medikoak inoiz ez dira gailutik irten behar.
4. **Epe luzerako scheduling:** Jakinarazpenak hilabete baterako programatuak.

**flutter_local_notifications:**

- ✅ **Scheduling zehatza:** `zonedSchedule` `androidScheduleMode: exactAllowWhileIdle`-ekin entrega zehatza bermatzen du Doze Mode-rekin ere.
- ✅ **Guztiz offline:** Jakinarazpenak lokalki programatzen dira, zerbitzari-mendekorik gabe.
- ✅ **Pribatutasun osoa:** Ez dago daturik gailutik irteten.
- ✅ **Heldutasuna:** 5+ urte, 3000+ izarrak, ekoizpenean milaka osasun aplikaziotan erabilia.
- ✅ **Dokumentazioa:** Erabilera-kasu guztietarako adibide exhaustiboak.

**awesome_notifications:**

- ✅ **Aldekoak:** Jakinarazpenen UI pertsonalizazio handiagoa, animazioak, ikono dituzten botoiak.
- ❌ **Kontra:**
  - **Heldugabeagoa:** 2+ urte vs flutter_local_notifications-en 5+.
  - **Arazoak reportatuak:** Android 12+-n programatutako jakinarazpenetan arazoak (WorkManager gatazkak).
  - **Konplexutasun beharrezkoa ez:** MedicApp-ek ez ditu jakinarazpen super pertsonalizatuak behar.
  - **Adopzio txikiagoa:** ~1500 izarrak vs flutter_local_notifications-en 3000+.

**Firebase Cloud Messaging (FCM):**

- ✅ **Aldekoak:** Jakinarazpen mugagabeak, analytics, erabiltzaile segmentazioa.
- ❌ **Kontra:**
  - **Zerbitzaria behar du:** Backend behar luke jakinarazpenak bidaltzeko, konplexutasuna eta kostua handituz.
  - **Konexioa behar du:** Jakinarazpenak ez dira heltzen gailua offline badago.
  - **Pribatutasuna:** Datuak (medikazio orduak, medikamentu izenak) Firebase-ra bidaliko lirateke.
  - **Latentzia:** Saretik mendeko, ez du entrega zehatza bermatzen programatutako orduan.
  - **Scheduling mugatua:** FCM-ek ez du scheduling zehatza onartzen, "hurbileko" entrega atzerapen-ekin bakarrik.
  - **Konplexutasuna:** Firebase proiektua konfiguratu, zerbitzaria inplementatu, token-ak kudeatu behar.

**Aplikazio mediko lokaletarako arkitektura zuzena:**

MedicApp bezalako aplikazioetarako (kudeaketa personala, erabiltzaile anitzeko elkarlanik ez, backend-ik ez), jakinarazpen lokalak arkitektura mailan hobeak dira urrunekoak baino:

- **Fidagarritasuna:** Ez dira internet konexioaren edo zerbitzariaren eskuragarritasunaren menpeko.
- **Pribatutasuna:** GDPR eta arautza mediko-ak betetzea diseinuz (datuak inoiz ez dira gailutik irteten).
- **Sinpletasuna:** Zero backend konfigurazio, zero zerbitzari kostuak.
- **Zehaztasuna:** Bigarreneko entrega-bermea.

**Emaitza finala:**

`flutter_local_notifications` MedicApp-erako hautaketa nabarmena eta zuzena da. awesome_notifications UI beharrik ez dugunerako injeniaritza gehiegi izango litzateke, eta FCM guztiz lokal aplikazio baterako arkitektura mailan okerra izango litzateke.

---

### 12.3. Egoeraren Kudeaketa: Vanilla Flutter vs Provider vs BLoC vs Riverpod

**Erabakia:** Vanilla Flutter (egoera kudeaketa liburutegik gabe)

**Justifikazio hedatua:**

**MedicApp-en arkitektura:**

```
┌─────────────┐
│  Screens    │ (StatefulWidget + setState)
└─────┬───────┘
      │ query()
      ↓
┌─────────────┐
│ DatabaseHelper │ (SQLite - Single Source of Truth)
└─────────────┘
```

MedicApp-en, **datu-basea DA egoera**. Ez dago widget artean partekatu beharreko memoria-egoera esanguratsurik.

**Pantaila tipiko eredua:**

```dart
class MedicationListScreen extends StatefulWidget {
  @override
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  List<Medication> _medications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  Future<void> _loadMedications() async {
    final medications = await DatabaseHelper.instance.getMedications();
    setState(() {
      _medications = medications;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return CircularProgressIndicator();

    return ListView.builder(
      itemCount: _medications.length,
      itemBuilder: (context, index) {
        return MedicationCard(medication: _medications[index]);
      },
    );
  }
}
```

**Zergatik Provider beharrezkoa ez litzateke:**

Provider widget urrunetik zuhaitzean **egoera partekatzeko** diseinatuta dago. Adibide klasikoa:

```dart
// Provider-ekin (MedicApp-en beharrezkoa ez)
ChangeNotifierProvider(
  create: (_) => MedicationProvider(),
  child: MaterialApp(
    home: HomeScreen(),
  ),
)

// HomeScreen-ek MedicationProvider-era sarrera du
Provider.of<MedicationProvider>(context).medications

// DetailScreen-ek ere MedicationProvider-era sarrera du
Provider.of<MedicationProvider>(context).addDose(...)
```

**Arazoa:** MedicApp-en, pantailek EZ dute memoria-egoera partekatu behar. Pantaila bakoitzak datu-basea zuzenean kontsultatzen du:

```dart
// Pantaila 1: Medikamentuen zerrenda
final medications = await db.getMedications();

// Pantaila 2: Medikamentuaren xehetasuna
final medication = await db.getMedication(id);

// Pantaila 3: Dosien historiala
final history = await db.getDoseHistory(medicationId);
```

Guztiek SQLite-tik zuzenean datuak lortzen dituzte, egiazko egia-iturri bakarra dena. Ez dago `ChangeNotifier`, `MultiProvider`, edo egoera hedapenerako beharrik.

**Zergatik BLoC injeniaritza gehiegi izango litzateke:**

BLoC (Business Logic Component) **negozio-logika konplexu** duten enpresa-aplikazioetarako diseinatuta dago **UI-tik bereizita** egon behar duena eta **independenteki testea tu** behar dena.

BLoC arkitektura adibidea:

```dart
// medication_bloc.dart
class MedicationBloc extends Bloc<MedicationEvent, MedicationState> {
  final MedicationRepository repository;

  MedicationBloc(this.repository) : super(MedicationInitial()) {
    on<LoadMedications>(_onLoadMedications);
    on<AddMedication>(_onAddMedication);
    on<DeleteMedication>(_onDeleteMedication);
  }

  Future<void> _onLoadMedications(event, emit) async {
    emit(MedicationLoading());
    try {
      final medications = await repository.getMedications();
      emit(MedicationLoaded(medications));
    } catch (e) {
      emit(MedicationError(e.toString()));
    }
  }
  // ... gertaera gehiago
}

// medication_event.dart (gertaera bereziak)
// medication_state.dart (egoera bereziak)
// medication_repository.dart (datu-geruza)
```

**Arazoa:** Honek **4-5 fitxategi** gehitzen ditu ezaugarri bakoitzeko eta ehunka lerro boilerplate Vanilla Flutter-en hau dena baino:

```dart
final medications = await DatabaseHelper.instance.getMedications();
setState(() {
  _medications = medications;
});
```

**MedicApp-erako:**

- **Negozio-logika sinplea:** Stock kalkuluak (kenketa), data kalkuluak (alderaketa), string formateatze.
- **Negozio-arau konplexurik ez:** Ez dago kreditu-txartel balioztapenak, finantza kalkuluak, OAuth autentifikazioa, etab.
- **Testing zuzenā:** Zerbitzuak (DatabaseHelper, NotificationService) zuzenean testa tu daitezke BLoC mock-en beharrik gabe.

**Zergatik Riverpod beharrezkoa ez litzateke:**

Riverpod Provider-en eboluzio bat da arazo batzuk konpontzen dituena (compile-time safety, BuildContext-ekiko mendekotasunik ez), baina MedicApp-erako beharrezkoa ez da Provider-arekin gauza berdinetarako.

**Kasuak NON BAI egoera kudeaketa behar genuke:**

1. **Autentifikazioarekin aplikazioa:** Erabiltzaile/ses io-egoera pantaila guztien artean partekatua.
2. **Erosketa-saskia:** Hautatutako elementuen egoera produktu, saskia, checkout artean partekatua.
3. **Denbora errealeko txata:** Sartzen diren mezuak pantaila anitz aldi berean eguneratu behar dituzte.
4. **Aplikazio kolaboratiboa:** Erabiltzaile anitzek dokumentu bera editatzen dute denbora errealean.

**MedicApp-ek EZ du kasu hauetakoren batik ere.**

**Emaitza finala:**

MedicApp-erako, `StatefulWidget + setState + Database as Source of Truth` arkitektura zuzena da. Sinplea, zuzena, edozein garatzaile Flutter-entzat ulerterrazа da, eta konplexutasun beharrezkoa sartzen ez du.

Provider, BLoC edo Riverpod gehitzea hutsik **cargo cult programming** izango litzateke (teknologia ezaguna delako erabili, ez arazo erreal bat konpontzen duelako).

---

## Ondorioa

MedicApp-ek teknologia-stack **sinple, sendo eta egokia** erabiltzen du plataforma-anitzeko aplikazio mediko lokal baterako:

- **Flutter + Dart:** Plataforma-anitza errendimendu natiboarekin.
- **SQLite:** Datu-base erlazional heldua ACID transakzioekin.
- **Jakinarazpen lokalak:** Pribatutasun osoa eta offline funtzionamendua.
- **ARB lokalizazioa:** 8 hizkuntza Unicode CLDR pluralizazioarekin.
- **Vanilla Flutter:** Egoera kudeaketa beharrezkoa ez.
- **432+ test:** %75-80ko estaldura unit, widget eta integrazio testetan.

Erabaki teknologiko bakoitza **eskakizun errealetatik justifikatua** dago, ez hype edo joeratatik. Emaitza aplikazio mantenigarri, fidagarri eta zehazki egiten duena konplexutasun artifiziala gabe.

**Printzipio gidaria:** *"Sinpletasuna posible denean, konplexutasuna beharrezkoa denean."*
