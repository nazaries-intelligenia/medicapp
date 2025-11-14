# Guia de Solució de Problemes

## Introducció

### Propòsit del Document

Aquesta guia proporciona solucions a problemes comuns que poden sorgir durant el desenvolupament, compilació i ús de MedicApp. Està dissenyada per ajudar desenvolupadors i usuaris a resoldre problemes de manera ràpida i efectiva.

### Com Usar Aquesta Guia

1. Identifica la categoria del teu problema a l'índex
2. Llegeix la descripció del problema per confirmar que coincideix amb la teva situació
3. Segueix els passos de solució en ordre
4. Si el problema persisteix, consulta la secció "Obtenir Ajuda"

---

## Problemes d'Instal·lació

### Flutter SDK No Trobat

**Descripció**: En executar comandes de Flutter, apareix l'error "flutter: command not found".

**Causa Probable**: Flutter no està instal·lat o no està al PATH del sistema.

**Solució**:

1. Verifica si Flutter està instal·lat:
```bash
which flutter
```

2. Si no està instal·lat, descarrega Flutter des de [flutter.dev](https://flutter.dev)

3. Afegeix Flutter al PATH:
```bash
# A ~/.bashrc, ~/.zshrc, o similar
export PATH="$PATH:/path/to/flutter/bin"
```

4. Reinicia el teu terminal i verifica:
```bash
flutter --version
```

**Referències**: [Documentació d'instal·lació de Flutter](https://docs.flutter.dev/get-started/install)

---

### Versió Incorrecta de Flutter

**Descripció**: La versió de Flutter instal·lada no compleix amb els requisits del projecte.

**Causa Probable**: MedicApp requereix Flutter 3.24.5 o superior.

**Solució**:

1. Verifica la teva versió actual:
```bash
flutter --version
```

2. Actualitza Flutter:
```bash
flutter upgrade
```

3. Si necessites una versió específica, usa FVM:
```bash
dart pub global activate fvm
fvm install 3.24.5
fvm use 3.24.5
```

4. Verifica la versió després d'actualitzar:
```bash
flutter --version
```

---

### Problemes amb flutter pub get

**Descripció**: Error en descarregar dependències amb `flutter pub get`.

**Causa Probable**: Problemes de xarxa, caché corrupta o conflictes de versions.

**Solució**:

1. Neteja el caché de pub:
```bash
flutter pub cache repair
```

2. Elimina l'arxiu pubspec.lock:
```bash
rm pubspec.lock
```

3. Intenta novament:
```bash
flutter pub get
```

4. Si persisteix, verifica connexió a internet i proxy:
```bash
# Configura proxy si és necessari
export HTTP_PROXY=http://proxy.example.com:8080
export HTTPS_PROXY=http://proxy.example.com:8080
```

---

### Problemes amb CocoaPods (iOS)

**Descripció**: Errors relacionats amb CocoaPods durant la compilació d'iOS.

**Causa Probable**: CocoaPods desactualitzat o caché corrupta.

**Solució**:

1. Actualitza CocoaPods:
```bash
sudo gem install cocoapods
```

2. Neteja el caché de pods:
```bash
cd ios
rm -rf Pods Podfile.lock
pod cache clean --all
```

3. Reinstal·la els pods:
```bash
pod install --repo-update
```

4. Si persisteix, actualitza el repositori de specs:
```bash
pod repo update
```

**Referències**: [CocoaPods Guides](https://guides.cocoapods.org/using/troubleshooting.html)

---

### Problemes amb Gradle (Android)

**Descripció**: Errors de compilació relacionats amb Gradle a Android.

**Causa Probable**: Caché de Gradle corrupta o configuració incorrecta.

**Solució**:

1. Neteja el projecte:
```bash
cd android
./gradlew clean
```

2. Neteja el caché de Gradle:
```bash
./gradlew cleanBuildCache
rm -rf ~/.gradle/caches/
```

3. Sincronitza el projecte:
```bash
./gradlew --refresh-dependencies
```

4. Invalida caché a Android Studio:
   - File > Invalidate Caches / Restart

---

## Problemes de Compilació

### Errors de Dependències

**Descripció**: Conflictes entre versions de paquets o dependències faltants.

**Causa Probable**: Versions incompatibles a pubspec.yaml o dependències transitives en conflicte.

**Solució**:

1. Verifica l'arxiu pubspec.yaml per a restriccions de versió conflictives

2. Usa la comanda d'anàlisi de dependències:
```bash
flutter pub deps
```

3. Resol conflictes especificant versions compatibles:
```yaml
dependency_overrides:
  conflicting_package: ^1.0.0
```

4. Actualitza totes les dependències a versions compatibles:
```bash
flutter pub upgrade --major-versions
```

---

### Conflictes de Versions

**Descripció**: Dos o més paquets requereixen versions incompatibles d'una dependència comuna.

**Causa Probable**: Restriccions de versió molt estrictes a les dependències.

**Solució**:

1. Identifica el conflicte:
```bash
flutter pub deps | grep "✗"
```

2. Usa `dependency_overrides` temporalment:
```yaml
dependency_overrides:
  shared_dependency: ^2.0.0
```

3. Reporta el conflicte als mantenidors dels paquets

4. Com a últim recurs, considera alternatives als paquets conflictius

---

### Errors de Generació de l10n

**Descripció**: Fallades en generar arxius de localització.

**Causa Probable**: Errors de sintaxi en arxius .arb o configuració incorrecta.

**Solució**:

1. Verifica la sintaxi dels arxius .arb a `lib/l10n/`:
   - Assegura't que siguin JSON vàlid
   - Verifica que els placeholders siguin consistents

2. Neteja i regenera:
```bash
flutter clean
flutter pub get
flutter gen-l10n
```

3. Verifica la configuració a pubspec.yaml:
```yaml
flutter:
  generate: true
```

4. Revisa `l10n.yaml` per a configuració correcta

**Referències**: [Internacionalització a Flutter](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)

---

### Build Fallat a Android

**Descripció**: La compilació d'Android falla amb diversos errors.

**Causa Probable**: Configuració de Gradle, versió de SDK o problemes de permisos.

**Solució**:

1. Verifica la versió de Java (requereix Java 17):
```bash
java -version
```

2. Neteja el projecte completament:
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
```

3. Verifica les configuracions a `android/app/build.gradle`:
   - `compileSdkVersion`: 34
   - `minSdkVersion`: 23
   - `targetSdkVersion`: 34

4. Compila amb informació detallada:
```bash
flutter build apk --verbose
```

5. Si l'error menciona permisos, verifica `android/app/src/main/AndroidManifest.xml`

---

### Build Fallat a iOS

**Descripció**: La compilació d'iOS falla o no pot signar l'app.

**Causa Probable**: Certificats, perfils d'aprovisionament o configuració de Xcode.

**Solució**:

1. Obre el projecte a Xcode:
```bash
open ios/Runner.xcworkspace
```

2. Verifica la configuració de signatura:
   - Selecciona el projecte Runner
   - A "Signing & Capabilities", verifica el Team i Bundle Identifier

3. Neteja el build de Xcode:
   - Product > Clean Build Folder (Shift + Cmd + K)

4. Actualitza els pods:
```bash
cd ios
pod deintegrate
pod install
cd ..
```

5. Compila des del terminal:
```bash
flutter build ios --verbose
```

---

## Problemes amb Base de Dades

### Database is Locked

**Descripció**: Error "database is locked" en intentar operacions de base de dades.

**Causa Probable**: Múltiples connexions intentant escriure simultàniament o transacció no tancada.

**Solució**:

1. Assegura't de tancar totes les connexions correctament al codi

2. Verifica que no hi hagi transaccions obertes sense commit/rollback

3. Reinicia l'aplicació completament

4. Com a últim recurs, elimina la base de dades:
```bash
# Android
adb shell run-as com.medicapp.app rm -r /data/data/com.medicapp.app/databases/

# iOS - des de Xcode, elimina el contenidor de l'app
```

**Referències**: Revisa `lib/core/database/database_helper.dart` per al maneig de transaccions.

---

### Errors de Migració

**Descripció**: Fallades en actualitzar l'esquema de la base de dades.

**Causa Probable**: Script de migració incorrecte o versió de base de dades inconsistent.

**Solució**:

1. Revisa els scripts de migració a `DatabaseHelper`

2. Verifica la versió actual de la base de dades:
```dart
final db = await DatabaseHelper.instance.database;
print('Database version: ${await db.getVersion()}');
```

3. Si és desenvolupament, reseteja la base de dades:
   - Desinstal·la l'app
   - Reinstal·la

4. Per a producció, crea un script de migració que gestioni el cas específic

5. Usa la pantalla de depuració de l'app per verificar l'estat de la BD

---

### Dades No Persisteixen

**Descripció**: Les dades ingressades desapareixen després de tancar l'app.

**Causa Probable**: Operacions de base de dades no es completen o fallen silenciosament.

**Solució**:

1. Habilita logs de base de dades en mode debug

2. Verifica que les operacions d'insert/update retornin èxit:
```dart
final id = await db.insert('medications', medication.toMap());
print('Inserted medication with id: $id');
```

3. Assegura't que no hi hagi excepcions silencioses

4. Verifica permisos d'escriptura al dispositiu

5. Revisa que `await` estigui present en totes les operacions async

---

### Corrupció de Base de Dades

**Descripció**: Errors en obrir la base de dades o dades inconsistents.

**Causa Probable**: Tancament inesperat de l'app durant escriptura o problema del sistema d'arxius.

**Solució**:

1. Intenta reparar la base de dades usant la comanda sqlite3 (requereix accés root):
```bash
sqlite3 /path/to/database.db "PRAGMA integrity_check;"
```

2. Si està corrupta, restaura des de backup si existeix

3. Si no hi ha backup, reseteja la base de dades:
   - Desinstal·la l'app
   - Reinstal·la
   - Les dades es perdran

4. **Prevenció**: Implementa backups automàtics periòdics

---

### Com Resetejar Base de Dades

**Descripció**: Necessites eliminar completament la base de dades per començar de zero.

**Causa Probable**: Desenvolupament, testing o resolució de problemes.

**Solució**:

**Opció 1 - Des de l'App (Development)**:
```dart
// A la pantalla de depuració
await DatabaseHelper.instance.deleteDatabase();
```

**Opció 2 - Android**:
```bash
adb shell run-as com.medicapp.app rm /data/data/com.medicapp.app/databases/medicapp.db
```

**Opció 3 - iOS**:
- Desinstal·la l'app des del dispositiu/simulador
- Reinstal·la

**Opció 4 - Ambdues plataformes**:
```bash
flutter clean
# Desinstal·la manualment des del dispositiu
flutter run
```

---

## Problemes amb Notificacions

### Notificacions No Apareixen

**Descripció**: Les notificacions programades no es mostren.

**Causa Probable**: Permisos no atorgats, notificacions deshabilitades o error a la programació.

**Solució**:

1. Verifica permisos de notificacions:
   - Android 13+: Ha de sol·licitar `POST_NOTIFICATIONS`
   - iOS: Ha de sol·licitar autorització en primer inici

2. Comprova configuració del dispositiu:
   - Android: Configuració > Apps > MedicApp > Notificacions
   - iOS: Configuració > Notificacions > MedicApp

3. Verifica que les notificacions estiguin programades:
```dart
final pendingNotifications = await flutterLocalNotificationsPlugin
    .pendingNotificationRequests();
print('Pending notifications: ${pendingNotifications.length}');
```

4. Revisa els logs per a errors de programació

5. Usa la pantalla de depuració de l'app per veure notificacions programades

---

### Permisos Denegats (Android 13+)

**Descripció**: A Android 13+, les notificacions no funcionen encara que l'app les sol·liciti.

**Causa Probable**: El permís `POST_NOTIFICATIONS` va ser denegat per l'usuari.

**Solució**:

1. Verifica que el permís estigui declarat a `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

2. L'app ha de sol·licitar el permís en temps d'execució

3. Si l'usuari el va denegar, guia'l a configuració:
```dart
await openAppSettings();
```

4. Explica a l'usuari per què les notificacions són essencials per a l'app

5. No assumeixis que el permís està atorgat; sempre verifica abans de programar

---

### Alarmes Exactes No Funcionen

**Descripció**: Les notificacions no apareixen en el moment exacte programat.

**Causa Probable**: Falta permís `SCHEDULE_EXACT_ALARM` o restriccions de bateria.

**Solució**:

1. Verifica permisos a `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
```

2. Per a Android 12+, sol·licita el permís:
```dart
if (await Permission.scheduleExactAlarm.isDenied) {
  await Permission.scheduleExactAlarm.request();
}
```

3. Desactiva optimització de bateria per a l'app:
   - Configuració > Bateria > Optimització de bateria
   - Busca MedicApp i selecciona "No optimitzar"

4. Verifica que usis `androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle`

---

### Notificacions No Sonen

**Descripció**: Les notificacions apareixen però sense so.

**Causa Probable**: Canal de notificació sense so o mode silenciós del dispositiu.

**Solució**:

1. Verifica la configuració del canal de notificació:
```dart
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'medication_reminders',
  'Recordatoris de Medicaments',
  importance: Importance.high,
  sound: RawResourceAndroidNotificationSound('notification_sound'),
);
```

2. Assegura't que l'arxiu de so existeix a `android/app/src/main/res/raw/`

3. Verifica configuració del dispositiu:
   - Android: Configuració > Apps > MedicApp > Notificacions > Categoria
   - iOS: Configuració > Notificacions > MedicApp > Sons

4. Comprova que el dispositiu no estigui en mode silenciós/no molestar

---

### Notificacions Després de Reiniciar Dispositiu

**Descripció**: Les notificacions deixen de funcionar després de reiniciar el dispositiu.

**Causa Probable**: Les notificacions programades no persisteixen després del reinici.

**Solució**:

1. Afegeix el permís `RECEIVE_BOOT_COMPLETED` a `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

2. Implementa un `BroadcastReceiver` per reprogramar notificacions:
```xml
<receiver android:name=".BootReceiver" android:enabled="true" android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
    </intent-filter>
</receiver>
```

3. Implementa la lògica per reprogramar totes les notificacions pendents

4. A iOS, les notificacions locals persisteixen automàticament

**Referències**: Revisa `android/app/src/main/kotlin/.../MainActivity.kt`

---

## Problemes de Rendiment

### App Lenta en Mode Debug

**Descripció**: L'aplicació té rendiment pobre i és lenta.

**Causa Probable**: El mode debug inclou eines de desenvolupament que afecten el rendiment.

**Solució**:

1. **Això és normal en mode debug**. Per avaluar el rendiment real, compila en mode profile o release:
```bash
flutter run --profile
# o
flutter run --release
```

2. Usa Flutter DevTools per identificar colls d'ampolla:
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

3. Verifica que no hi hagi `print()` statements excessius en hot paths

4. Mai avaluïs el rendiment en mode debug

---

### Consum Excessiu de Bateria

**Descripció**: L'aplicació consumeix molta bateria.

**Causa Probable**: Ús excessiu de notificacions, background tasks o consultes freqüents.

**Solució**:

1. Redueix la freqüència de verificacions en background

2. Optimitza les consultes a la base de dades:
   - Usa índexs apropiats
   - Evita consultes innecessàries
   - Cacheja resultats quan sigui possible

3. Usa `WorkManager` en lloc d'alarmes freqüents quan sigui apropiat

4. Revisa l'ús de sensors o GPS (si aplica)

5. Perfila l'ús de bateria amb Android Studio:
   - View > Tool Windows > Energy Profiler

---

### Lag en Llistes Llargues

**Descripció**: L'scroll en llistes amb molts elements és lent o entretallat.

**Causa Probable**: Renderitzat ineficient de widgets o falta d'optimització de ListView.

**Solució**:

1. Usa `ListView.builder` en lloc de `ListView`:
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

2. Implementa `const` constructors on sigui possible

3. Evita widgets pesats a cada item de la llista

4. Usa `RepaintBoundary` per a widgets complexos:
```dart
RepaintBoundary(
  child: ComplexWidget(),
)
```

5. Considera paginació per a llistes molt llargues

6. Usa `AutomaticKeepAliveClientMixin` per mantenir estat d'items

---

### Frames Saltats

**Descripció**: La UI se sent entretallada amb frames perduts.

**Causa Probable**: Operacions costoses al thread principal.

**Solució**:

1. Identifica el problema amb Flutter DevTools Performance tab

2. Mou operacions costoses a isolates:
```dart
final result = await compute(expensiveFunction, data);
```

3. Evita operacions sincròniques pesades al build method

4. Usa `FutureBuilder` o `StreamBuilder` per a operacions async

5. Optimitza imatges grans:
   - Usa formats comprimits
   - Cacheja imatges descodificades
   - Usa thumbnails per a vistes prèvies

6. Revisa que no hi hagi animacions amb listeners costosos

---

## Problemes de UI/UX

### Text No Es Tradueix

**Descripció**: Alguns textos apareixen en anglès o un altre idioma incorrecte.

**Causa Probable**: Falta la cadena a l'arxiu .arb o no s'usa AppLocalizations.

**Solució**:

1. Verifica que la cadena existeix a `lib/l10n/app_ca.arb`:
```json
{
  "yourKey": "El teu text traduït"
}
```

2. Assegura't d'usar `AppLocalizations.of(context)`:
```dart
Text(AppLocalizations.of(context)!.yourKey)
```

3. Regenera els arxius de localització:
```bash
flutter gen-l10n
```

4. Si vas afegir una nova clau, assegura't que existeixi a tots els arxius .arb

5. Verifica que el locale del dispositiu estigui configurat correctament

---

### Colors Incorrectes

**Descripció**: Els colors no coincideixen amb el disseny o tema esperat.

**Causa Probable**: Ús incorrecte del tema o hardcoded colors.

**Solució**:

1. Usa sempre els colors del tema:
```dart
// Correcte
color: Theme.of(context).colorScheme.primary

// Incorrecte
color: Colors.blue
```

2. Verifica la definició del tema a `lib/core/theme/app_theme.dart`

3. Assegura't que el MaterialApp tingui el tema configurat:
```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  // ...
)
```

4. Per a debug, imprimeix els colors actuals:
```dart
print('Primary: ${Theme.of(context).colorScheme.primary}');
```

---

### Layout Trencat en Pantalles Petites

**Descripció**: La UI es desborda o es veu malament en dispositius amb pantalles petites.

**Causa Probable**: Widgets amb mides fixes o falta de responsive design.

**Solució**:

1. Usa widgets flexibles en lloc de mides fixes:
```dart
// En lloc de
Container(width: 300, child: ...)

// Usa
Expanded(child: ...)
// o
Flexible(child: ...)
```

2. Usa `LayoutBuilder` per a layouts adaptatius:
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

3. Usa `MediaQuery` per obtenir dimensions:
```dart
final screenWidth = MediaQuery.of(context).size.width;
```

4. Prova en diferents mides de pantalla usant l'emulador

---

### Overflow de Text

**Descripció**: Apareix el warning d'"overflow" amb franges grogues i negres.

**Causa Probable**: Text massa llarg per a l'espai disponible.

**Solució**:

1. Envolta el text en `Flexible` o `Expanded`:
```dart
Flexible(
  child: Text('Text llarg...'),
)
```

2. Usa `overflow` i `maxLines` al Text widget:
```dart
Text(
  'Text llarg...',
  overflow: TextOverflow.ellipsis,
  maxLines: 2,
)
```

3. Per a textos molt llargs, usa `SingleChildScrollView`:
```dart
SingleChildScrollView(
  child: Text('Text molt llarg...'),
)
```

4. Considera escurçar el text o usar un format diferent

---

## Problemes Multi-Persona

### Estoc No Es Comparteix Correctament

**Descripció**: Múltiples persones poden crear medicaments amb el mateix nom sense compartir estoc.

**Causa Probable**: Lògica de verificació de duplicats per persona en lloc de global.

**Solució**:

1. Verifica la funció de cerca de medicaments existents a `MedicationRepository`

2. Assegura't que la cerca sigui global:
```dart
// Buscar per nom sense filtrar per personId
final existing = await db.query(
  'medications',
  where: 'name = ?',
  whereArgs: [name],
);
```

3. En afegir una dosi, associa la dosi amb la persona però no el medicament

4. Revisa la lògica a `AddMedicationScreen` per reutilitzar medicaments existents

---

### Medicaments Duplicats

**Descripció**: Apareixen medicaments duplicats a la llista.

**Causa Probable**: Múltiples insercions del mateix medicament o falta de validació.

**Solució**:

1. Implementa verificació abans d'inserir:
```dart
final existing = await getMedicationByName(name);
if (existing != null) {
  return existing.id;
}
```

2. Usa restriccions UNIQUE a la base de dades:
```sql
CREATE TABLE medications (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  -- ...
);
```

3. Revisa la lògica de creació de medicaments al repository

4. Si ja existeixen duplicats, crea un script de migració per consolidar-los

---

### Historial de Dosis Incorrecte

**Descripció**: L'historial mostra dosis d'altres persones o falta informació.

**Causa Probable**: Filtrat incorrecte per persona o joins mal configurats.

**Solució**:

1. Verifica el query que obté l'historial:
```dart
final doses = await db.query(
  'dose_history',
  where: 'personId = ?',
  whereArgs: [personId],
  orderBy: 'takenAt DESC',
);
```

2. Assegura't que totes les dosis tinguin `personId` associat

3. Revisa la lògica de filtrat a `DoseHistoryScreen`

4. Verifica que els joins entre taules incloguin la condició de persona

---

### Persona Per Defecte No Canvia

**Descripció**: En canviar la persona activa, la UI no s'actualitza correctament.

**Causa Probable**: Estat no es propaga correctament o falta rebuild.

**Solució**:

1. Verifica que usis un estat global (Provider, Bloc, etc.):
```dart
Provider.of<PersonProvider>(context, listen: true).currentPerson
```

2. Assegura't que el canvi de persona dispari `notifyListeners()`:
```dart
void setCurrentPerson(Person person) {
  _currentPerson = person;
  notifyListeners();
}
```

3. Verifica que els widgets rellevants escoltin els canvis

4. Considera usar `Consumer` per a rebuilds específics:
```dart
Consumer<PersonProvider>(
  builder: (context, provider, child) {
    return Text(provider.currentPerson.name);
  },
)
```

---

## Problemes amb Dejuni

### Notificació de Dejuni No Apareix

**Descripció**: La notificació ongoing de dejuni no es mostra.

**Causa Probable**: Permisos, configuració del canal o error en crear la notificació.

**Solució**:

1. Verifica que el canal de notificacions de dejuni estigui creat:
```dart
const AndroidNotificationChannel fastingChannel = AndroidNotificationChannel(
  'fasting',
  'Dejuni',
  importance: Importance.low,
  enableVibration: false,
);
```

2. Assegura't d'usar `ongoing: true`:
```dart
const NotificationDetails(
  android: AndroidNotificationDetails(
    'fasting',
    'Dejuni',
    ongoing: true,
    autoCancel: false,
  ),
)
```

3. Verifica permisos de notificacions

4. Revisa logs per a errors en crear la notificació

---

### Compte Enrere Incorrecte

**Descripció**: El temps restant del dejuni no és correcte o no s'actualitza.

**Causa Probable**: Càlcul incorrecte de temps o falta d'actualització periòdica.

**Solució**:

1. Verifica el càlcul de temps restant:
```dart
final remaining = endTime.difference(DateTime.now());
```

2. Assegura't d'actualitzar la notificació periòdicament:
```dart
Timer.periodic(Duration(minutes: 1), (timer) {
  updateFastingNotification();
});
```

3. Verifica que el `endTime` del dejuni s'emmagatzemi correctament

4. Usa la pantalla de depuració per verificar l'estat del dejuni actual

---

### Dejuni No Es Cancel·la Automàticament

**Descripció**: La notificació de dejuni roman després que acaba el temps.

**Causa Probable**: Falta lògica per cancel·lar la notificació en completar-se.

**Solució**:

1. Implementa verificació quan el dejuni acaba:
```dart
if (DateTime.now().isAfter(fasting.endTime)) {
  await cancelFastingNotification();
  await markFastingAsCompleted(fasting.id);
}
```

2. Verifica quan l'app s'obre:
```dart
@override
void initState() {
  super.initState();
  checkActiveFastings();
}
```

3. Programa una alarma per a quan acabi el dejuni que cancel·li la notificació

4. Assegura't que la notificació es cancel·li a `onDidReceiveNotificationResponse`

**Referències**: Revisa `lib/features/fasting/` per a la implementació.

---

## Problemes de Testing

### Tests Fallen Localment

**Descripció**: Els tests que passen a CI fallen a la teva màquina local.

**Causa Probable**: Diferències d'entorn, dependències o configuració.

**Solució**:

1. Neteja i reconstrueix:
```bash
flutter clean
flutter pub get
```

2. Verifica que les versions siguin les mateixes:
```bash
flutter --version
dart --version
```

3. Executa els tests amb més informació:
```bash
flutter test --verbose
```

4. Assegura't que no hi hagi tests que depenguin d'estat previ

5. Verifica que no hi hagi tests amb dependències de temps (usa `fakeAsync`)

---

### Problemes amb sqflite_common_ffi

**Descripció**: Tests de base de dades fallen amb errors de sqflite.

**Causa Probable**: sqflite no està disponible en tests, necessites usar sqflite_common_ffi.

**Solució**:

1. Assegura't de tenir la dependència:
```yaml
dev_dependencies:
  sqflite_common_ffi: ^2.3.0
```

2. Inicialitza al setup de tests:
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

3. Usa bases de dades en memòria per a tests:
```dart
final db = await databaseFactoryFfi.openDatabase(
  inMemoryDatabasePath,
);
```

4. Neteja la base de dades després de cada test

---

### Timeouts en Tests

**Descripció**: Els tests fallen per timeout.

**Causa Probable**: Operacions lentes o deadlocks en tests async.

**Solució**:

1. Augmenta el timeout per a tests específics:
```dart
test('slow test', () async {
  // ...
}, timeout: Timeout(Duration(seconds: 30)));
```

2. Verifica que no hi hagi `await` faltants

3. Usa `fakeAsync` per a tests amb delays:
```dart
testWidgets('timer test', (tester) async {
  await tester.runAsync(() async {
    // test code with delays
  });
});
```

4. Mockeja operacions lentes com crides de xarxa

5. Revisa que no hi hagi loops infinits o condicions de carrera

---

### Tests Inconsistents

**Descripció**: Els mateixos tests a vegades passen i a vegades fallen.

**Causa Probable**: Tests amb dependències de temps, ordre d'execució o estat compartit.

**Solució**:

1. Evita dependre del temps real, usa `fakeAsync` o mocks

2. Assegura't que cada test sigui independent:
```dart
setUp(() {
  // Setup net per a cada test
});

tearDown(() {
  // Neteja després de cada test
});
```

3. No comparteixis estat mutable entre tests

4. Usa `setUpAll` només per a setup immutable

5. Executa tests en ordre aleatori per detectar dependències:
```bash
flutter test --test-randomize-ordering-seed=random
```

---

## Problemes de Permisos

### POST_NOTIFICATIONS (Android 13+)

**Descripció**: Les notificacions no funcionen a Android 13 o superior.

**Causa Probable**: El permís POST_NOTIFICATIONS s'ha de sol·licitar en runtime.

**Solució**:

1. Declara el permís a `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

2. Sol·licita el permís en runtime:
```dart
if (Platform.isAndroid && await Permission.notification.isDenied) {
  final status = await Permission.notification.request();
  if (status.isDenied) {
    // Informar l'usuari i oferir anar a configuració
  }
}
```

3. Verifica el permís abans de programar notificacions

4. Guia l'usuari a configuració si va ser denegat permanentment

**Referències**: [Android 13 Notification Permission](https://developer.android.com/about/versions/13/changes/notification-permission)

---

### SCHEDULE_EXACT_ALARM (Android 12+)

**Descripció**: Les alarmes exactes no funcionen a Android 12+.

**Causa Probable**: Requereix permís especial des d'Android 12.

**Solució**:

1. Declara el permís:
```xml
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
```

2. Verifica i sol·licita si és necessari:
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

3. Explica a l'usuari per què necessites alarmes exactes

4. Considera usar `USE_EXACT_ALARM` si ets una app d'alarma/recordatori

---

### USE_EXACT_ALARM (Android 14+)

**Descripció**: Necessites alarmes exactes sense sol·licitar permís especial.

**Causa Probable**: Android 14 introdueix USE_EXACT_ALARM per a apps d'alarma.

**Solució**:

1. Si la teva app és principalment d'alarmes/recordatoris, usa:
```xml
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
```

2. Aquesta és una alternativa a `SCHEDULE_EXACT_ALARM` que no requereix que l'usuari atorgui el permís manualment

3. Només usa-la si la teva app compleix amb els [casos d'ús permesos](https://developer.android.com/about/versions/14/changes/schedule-exact-alarms)

4. L'app ha de tenir com a funcionalitat principal alarmes o recordatoris

---

### Notificacions en Background (iOS)

**Descripció**: Les notificacions no funcionen correctament a iOS.

**Causa Probable**: Permisos no sol·licitats o configuració incorrecta.

**Solució**:

1. Sol·licita permisos en iniciar l'app:
```dart
final settings = await FirebaseMessaging.instance.requestPermission(
  alert: true,
  badge: true,
  sound: true,
);
```

2. Verifica `Info.plist`:
```xml
<key>UIBackgroundModes</key>
<array>
  <string>fetch</string>
  <string>remote-notification</string>
</array>
```

3. Assegura't de tenir els capabilities correctes a Xcode:
   - Push Notifications
   - Background Modes

4. Verifica que l'usuari no hagi deshabilitat notificacions a Configuració

---

## Errors Comuns i Solucions

### MissingPluginException

**Descripció**: Error "MissingPluginException(No implementation found for method...)"

**Causa Probable**: El plugin no està registrat correctament o necessites hot restart.

**Solució**:

1. Fes un hot restart complet (no només hot reload):
```bash
# Al terminal on corre l'app
r  # hot reload
R  # HOT RESTART (aquest és el que necessites)
```

2. Si persisteix, reconstrueix completament:
```bash
flutter clean
flutter pub get
flutter run
```

3. Verifica que el plugin estigui a `pubspec.yaml`

4. Per a iOS, reinstal·la els pods:
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
```

---

### PlatformException

**Descripció**: Error "PlatformException" amb diferents codis.

**Causa Probable**: Depèn del codi específic de l'error.

**Solució**:

1. Llegeix el missatge d'error i codi complets

2. Errors comuns:
   - `permission_denied`: Verifica permisos
   - `error`: Error genèric, revisa logs natius
   - `not_available`: Funció no disponible en aquesta plataforma

3. Per a Android, revisa logcat:
```bash
adb logcat | grep -i flutter
```

4. Per a iOS, revisa la consola de Xcode

5. Assegura't de gestionar aquests errors gracefully:
```dart
try {
  await somePluginMethod();
} on PlatformException catch (e) {
  print('Error: ${e.code} - ${e.message}');
  // Gestionar apropiadament
}
```

---

### DatabaseException

**Descripció**: Error en realitzar operacions de base de dades.

**Causa Probable**: Query invàlid, restricció violada o base de dades corrupta.

**Solució**:

1. Llegeix el missatge d'error complet per identificar el problema

2. Errors comuns:
   - `UNIQUE constraint failed`: Intentant inserir duplicat
   - `no such table`: Taula no existeix, revisa migracions
   - `syntax error`: Query SQL invàlid

3. Verifica el query SQL:
```dart
try {
  await db.query('medications', where: 'id = ?', whereArgs: [id]);
} on DatabaseException catch (e) {
  print('Database error: ${e.toString()}');
}
```

4. Assegura't que les migracions s'hagin executat

5. Com a últim recurs, reseteja la base de dades

---

### StateError

**Descripció**: Error "Bad state: No element" o similar.

**Causa Probable**: Intentant accedir a un element que no existeix.

**Solució**:

1. Identifica la línia exacta de l'error al stack trace

2. Usa mètodes segurs:
```dart
// En lloc de
final item = list.first;  // Llança StateError si està buida

// Usa
final item = list.isNotEmpty ? list.first : null;
// o
final item = list.firstOrNull;  // Dart 3.0+
```

3. Sempre verifica abans d'accedir:
```dart
if (list.isNotEmpty) {
  final item = list.first;
  // usar item
}
```

4. Usa try-catch si és necessari:
```dart
try {
  final item = list.single;
} on StateError {
  // Gestionar cas on no hi ha exactament un element
}
```

---

### Null Check Operator Used on Null Value

**Descripció**: Error en usar l'operador `!` en un valor null.

**Causa Probable**: Variable nullable usada amb `!` quan el seu valor és null.

**Solució**:

1. Identifica la línia exacta al stack trace

2. Verifica el valor abans d'usar `!`:
```dart
// En lloc de
final value = nullableValue!;

// Usa
if (nullableValue != null) {
  final value = nullableValue;
  // usar value
}
```

3. Usa operador `??` per a valors per defecte:
```dart
final value = nullableValue ?? defaultValue;
```

4. Usa operador `?.` per a accés segur:
```dart
final length = nullableString?.length;
```

5. Revisa per què el valor és null quan no hauria de ser-ho

---

## Logs i Depuració

### Com Habilitar Logs

**Descripció**: Necessites veure logs detallats per depurar un problema.

**Solució**:

1. **Logs de Flutter**:
```bash
flutter run --verbose
```

2. **Logs només de l'app**:
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

3. **Logs natius Android**:
```bash
adb logcat | grep -i flutter
# o per veure tot
adb logcat
```

4. **Logs natius iOS**:
   - Obre Console.app a macOS
   - Selecciona el teu dispositiu/simulador
   - Filtra per "flutter" o el teu bundle identifier

---

### Logs de Notificacions

**Descripció**: Necessites veure logs relacionats amb notificacions.

**Solució**:

1. Afegeix logs al codi de notificacions:
```dart
print('Scheduling notification at: $scheduledTime');
await flutterLocalNotificationsPlugin.zonedSchedule(
  id,
  title,
  body,
  scheduledTime,
  notificationDetails,
);
print('Notification scheduled successfully');
```

2. Llista notificacions pendents:
```dart
final pending = await flutterLocalNotificationsPlugin
    .pendingNotificationRequests();
for (var notification in pending) {
  print('Pending: ${notification.id} - ${notification.title}');
}
```

3. Verifica logs del sistema:
   - Android: `adb logcat | grep -i notification`
   - iOS: Console.app amb filtre "notification"

---

### Logs de Base de Dades

**Descripció**: Necessites veure les queries de base de dades executades.

**Solució**:

1. Habilita logging a sqflite:
```dart
import 'package:sqflite/sqflite.dart';

void main() {
  Sqflite.setDebugModeOn(true);
  runApp(MyApp());
}
```

2. Afegeix logs a les teves queries:
```dart
print('Executing query: SELECT * FROM medications WHERE id = $id');
final result = await db.query('medications', where: 'id = ?', whereArgs: [id]);
print('Query returned ${result.length} rows');
```

3. Wrapper per a logging automàtic:
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
    print('Result: ${result.length} rows');
    return result;
  }
}
```

---

### Usar Debugger

**Descripció**: Necessites pausar l'execució i examinar l'estat.

**Solució**:

1. **A VS Code**:
   - Col·loca un breakpoint clicant al costat del número de línia
   - Executa en mode debug (F5)
   - Quan pausi, usa els controls de debug

2. **A Android Studio**:
   - Col·loca un breakpoint clicant al marge
   - Executa Debug (Shift + F9)
   - Usa Debug panel per a step over/into/out

3. **Debugger programàtic**:
```dart
import 'dart:developer';

void someFunction() {
  debugger();  // Pausa aquí si hi ha debugger connectat
  // codi...
}
```

4. **Inspect variables**:
```dart
print('Value: $value');  // Logging simple
debugPrint('Value: $value');  // Logging que respecta rate limits
```

---

### Pantalla de Depuració de l'App

**Descripció**: MedicApp inclou una pantalla de depuració útil.

**Solució**:

1. Accedeix a la pantalla de depuració des del menú de configuració

2. Funcions disponibles:
   - Veure base de dades (taules, files, contingut)
   - Veure notificacions programades
   - Veure estat del sistema
   - Forçar actualització de notificacions
   - Netejar base de dades
   - Veure logs recents

3. Usa aquesta pantalla per a:
   - Verificar que les dades es guardin correctament
   - Comprovar notificacions pendents
   - Identificar problemes d'estat

4. Només disponible en mode debug

---

## Resetejar l'Aplicació

### Netejar Dades d'App

**Descripció**: Necessites eliminar totes les dades sense desinstal·lar.

**Solució**:

**Android**:
```bash
adb shell pm clear com.medicapp.app
```

**iOS**:
- Configuració > General > Emmagatzematge de l'iPhone
- Busca MedicApp
- "Esborrar App" (no "Descarregar App")

**Des de l'app** (només debug):
- Usa la pantalla de depuració
- "Reset Database"

---

### Desinstal·lar i Reinstal·lar

**Descripció**: Instal·lació neta completa.

**Solució**:

**Android**:
```bash
adb uninstall com.medicapp.app
flutter run
```

**iOS**:
```bash
# Des del dispositiu/simulador, mantén premut l'icona
# Selecciona "Eliminar App"
flutter run
```

**Des de Flutter**:
```bash
flutter clean
rm -rf build/
flutter run
```

---

### Resetejar Base de Dades

**Descripció**: Eliminar només la base de dades mantenint l'app.

**Solució**:

**Des de codi** (només debug):
```dart
await DatabaseHelper.instance.deleteDatabase();
```

**Android - Manualment**:
```bash
adb shell
run-as com.medicapp.app
cd databases
rm medicapp.db medicapp.db-shm medicapp.db-wal
exit
```

**iOS - Manualment**:
- Necessites accés al contenidor de l'app
- És més fàcil desinstal·lar i reinstal·lar

---

### Netejar Caché de Flutter

**Descripció**: Resoldre problemes de compilació relacionats amb caché.

**Solució**:

1. Neteja bàsica:
```bash
flutter clean
```

2. Neteja completa:
```bash
flutter clean
rm -rf build/
rm -rf .dart_tool/
rm pubspec.lock
flutter pub get
```

3. Netejar caché de pub:
```bash
flutter pub cache repair
```

4. Netejar caché de Gradle (Android):
```bash
cd android
./gradlew clean cleanBuildCache
rm -rf ~/.gradle/caches/
cd ..
```

5. Netejar caché de pods (iOS):
```bash
cd ios
rm -rf Pods Podfile.lock
pod cache clean --all
pod install
cd ..
```

---

## Problemes Coneguts

### Llista de Bugs Coneguts

1. **Notificacions no persisteixen després de reinici en alguns dispositius Android**
   - Afecta: Android 12+ amb optimització agressiva de bateria
   - Workaround: Desactivar optimització de bateria per a MedicApp

2. **Layout overflow en pantalles molt petites (<5")**
   - Afecta: Dispositius amb amplada < 320dp
   - Status: Fix planificat per a v1.1.0

3. **Animació de transició entretallada en dispositius low-end**
   - Afecta: Dispositius amb <2GB RAM
   - Workaround: Desactivar animacions a configuració

4. **Base de dades pot créixer indefinidament**
   - Afecta: Usuaris amb molt historial (>1 any)
   - Workaround: Implementar neteja periòdica d'historial antic
   - Status: Feature d'arxiu automàtic planificat

---

### Workarounds Temporals

1. **Si les notificacions no sonen en alguns dispositius**:
```dart
// Usa màxima importància temporalment
importance: Importance.max,
priority: Priority.high,
```

2. **Si hi ha lag en llistes llargues**:
   - Limita l'historial visible a últims 30 dies
   - Implementa paginació manual

3. **Si la base de dades es bloqueja freqüentment**:
   - Redueix operacions concurrents
   - Usa transaccions batch per a múltiples inserts

---

### Issues a GitHub

**Com buscar issues existents**:

1. Ves a: https://github.com/el-teu-usuari/medicapp/issues

2. Usa els filtres:
   - `is:issue is:open` - Issues oberts
   - `label:bug` - Només bugs
   - `label:enhancement` - Features sol·licitats

3. Busca per paraules clau: "notification", "database", etc.

**Abans de crear un nou issue**:
- Busca si ja n'existeix un de similar
- Verifica la llista de problemes coneguts a dalt
- Assegura't que no estigui resolt a l'última versió

---

## Obtenir Ajuda

### Revisar Documentació

**Recursos disponibles**:

1. **Documentació del projecte**:
   - `README.md` - Informació general i setup
   - `docs/ca/ARCHITECTURE.md` - Arquitectura del projecte
   - `docs/ca/CONTRIBUTING.md` - Guia de contribució
   - `docs/ca/TESTING.md` - Guia de testing

2. **Documentació de Flutter**:
   - [flutter.dev/docs](https://flutter.dev/docs)
   - [api.flutter.dev](https://api.flutter.dev)

3. **Documentació de paquets**:
   - Revisa pub.dev per a cada dependència
   - Llegeix el README i changelog de cada paquet

---

### Buscar a GitHub Issues

**Com buscar efectivament**:

1. Usa cerca avançada:
```
repo:el-teu-usuari/medicapp is:issue [paraules clau]
```

2. Busca issues tancats també:
```
is:issue is:closed notification not working
```

3. Busca per labels:
```
label:bug label:android label:notifications
```

4. Busca en comentaris:
```
commenter:username [paraules clau]
```

---

### Crear Nou Issue amb Template

**Abans de crear un issue**:

1. Confirma que és realment un bug o feature request vàlid
2. Busca issues duplicats
3. Recopila tota la informació necessària

**Informació necessària**:

**Per a bugs**:
- Descripció clara del problema
- Passos per reproduir
- Comportament esperat vs actual
- Screenshots/videos si aplica
- Informació de l'entorn (veure a sota)
- Logs rellevants

**Per a features**:
- Descripció de la funcionalitat
- Cas d'ús i beneficis
- Proposta d'implementació (opcional)
- Mockups o exemples (opcional)

**Plantilla d'issue**:
```markdown
## Descripció
[Descripció clara i concisa del problema]

## Passos per Reproduir
1. [Primer pas]
2. [Segon pas]
3. [Tercer pas]

## Comportament Esperat
[Què hauria de succeir]

## Comportament Actual
[Què succeeix realment]

## Informació de l'Entorn
- SO: [Android 13 / iOS 16.5]
- Dispositiu: [Model específic]
- Versió de MedicApp: [v1.0.0]
- Versió de Flutter: [3.24.5]

## Logs
```
[Logs rellevants]
```

## Screenshots
[Si aplica]

## Informació Addicional
[Qualsevol altre context]
```

---

### Informació Necessària per Reportar

**Sempre inclou**:

1. **Versió de l'app**:
```dart
// Des de pubspec.yaml
version: 1.0.0+1
```

2. **Informació del dispositiu**:
```dart
import 'package:device_info_plus/device_info_plus.dart';

final deviceInfo = DeviceInfoPlugin();
if (Platform.isAndroid) {
  final androidInfo = await deviceInfo.androidInfo;
  print('Android ${androidInfo.version.sdkInt}');
  print('Model: ${androidInfo.model}');
}
```

3. **Versió de Flutter**:
```bash
flutter --version
```

4. **Logs complets**:
```bash
flutter run --verbose > logs.txt 2>&1
# Adjunta logs.txt a l'issue
```

5. **Stack trace complet** si hi ha crash

6. **Screenshots o videos** mostrant el problema

---

## Conclusió

Aquesta guia cobreix els problemes més comuns a MedicApp. Si trobes un problema no llistat aquí:

1. Revisa la documentació completa del projecte
2. Busca a GitHub Issues
3. Pregunta a les discussions del repositori
4. Crea un nou issue amb tota la informació necessària

**Recorda**: Proporcionar informació detallada i passos per reproduir fa que sigui molt més fàcil resoldre el teu problema ràpidament.

Per contribuir millores a aquesta guia, si us plau obre un PR o issue al repositori.

---

**Última actualització**: 2025-11-14
**Versió del document**: 1.0.0
