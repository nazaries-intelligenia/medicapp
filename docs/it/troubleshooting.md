# Guida alla Risoluzione dei Problemi

## Introduzione

### Scopo del Documento

Questa guida fornisce soluzioni ai problemi comuni che possono sorgere durante lo sviluppo, compilazione e utilizzo di MedicApp. È progettata per aiutare sviluppatori e utenti a risolvere problemi in modo rapido ed efficace.

### Come Usare Questa Guida

1. Identifica la categoria del tuo problema nell'indice
2. Leggi la descrizione del problema per confermare che corrisponda alla tua situazione
3. Segui i passaggi di soluzione in ordine
4. Se il problema persiste, consulta la sezione "Ottenere Aiuto"

---

## Problemi di Installazione

### Flutter SDK Non Trovato

**Descrizione**: Quando esegui comandi Flutter, appare l'errore "flutter: command not found".

**Causa Probabile**: Flutter non è installato o non è nel PATH del sistema.

**Soluzione**:

1. Verifica se Flutter è installato:
```bash
which flutter
```

2. Se non è installato, scarica Flutter da [flutter.dev](https://flutter.dev)

3. Aggiungi Flutter al PATH:
```bash
# In ~/.bashrc, ~/.zshrc, o simile
export PATH="$PATH:/percorso/a/flutter/bin"
```

4. Riavvia il terminale e verifica:
```bash
flutter --version
```

**Riferimenti**: [Documentazione installazione Flutter](https://docs.flutter.dev/get-started/install)

---

### Versione Incorretta di Flutter

**Descrizione**: La versione di Flutter installata non soddisfa i requisiti del progetto.

**Causa Probabile**: MedicApp richiede Flutter 3.24.5 o superiore.

**Soluzione**:

1. Verifica la tua versione attuale:
```bash
flutter --version
```

2. Aggiorna Flutter:
```bash
flutter upgrade
```

3. Se hai bisogno di una versione specifica, usa FVM:
```bash
dart pub global activate fvm
fvm install 3.24.5
fvm use 3.24.5
```

4. Verifica la versione dopo l'aggiornamento:
```bash
flutter --version
```

---

### Problemi con flutter pub get

**Descrizione**: Errore durante il download delle dipendenze con `flutter pub get`.

**Causa Probabile**: Problemi di rete, cache corrotta o conflitti di versione.

**Soluzione**:

1. Pulisci la cache di pub:
```bash
flutter pub cache repair
```

2. Elimina il file pubspec.lock:
```bash
rm pubspec.lock
```

3. Prova di nuovo:
```bash
flutter pub get
```

4. Se persiste, verifica connessione internet e proxy:
```bash
# Configura proxy se necessario
export HTTP_PROXY=http://proxy.example.com:8080
export HTTPS_PROXY=http://proxy.example.com:8080
```

---

### Problemi con CocoaPods (iOS)

**Descrizione**: Errori relativi a CocoaPods durante la compilazione iOS.

**Causa Probabile**: CocoaPods obsoleto o cache corrotta.

**Soluzione**:

1. Aggiorna CocoaPods:
```bash
sudo gem install cocoapods
```

2. Pulisci la cache pods:
```bash
cd ios
rm -rf Pods Podfile.lock
pod cache clean --all
```

3. Reinstalla i pods:
```bash
pod install --repo-update
```

4. Se persiste, aggiorna il repository specs:
```bash
pod repo update
```

**Riferimenti**: [CocoaPods Guides](https://guides.cocoapods.org/using/troubleshooting.html)

---

### Problemi con Gradle (Android)

**Descrizione**: Errori di compilazione relativi a Gradle su Android.

**Causa Probabile**: Cache Gradle corrotta o configurazione incorretta.

**Soluzione**:

1. Pulisci il progetto:
```bash
cd android
./gradlew clean
```

2. Pulisci la cache Gradle:
```bash
./gradlew cleanBuildCache
rm -rf ~/.gradle/caches/
```

3. Sincronizza il progetto:
```bash
./gradlew --refresh-dependencies
```

4. Invalida cache in Android Studio:
   - File > Invalidate Caches / Restart

---

## Problemi di Compilazione

### Errori di Dipendenze

**Descrizione**: Conflitti tra versioni di pacchetti o dipendenze mancanti.

**Causa Probabile**: Versioni incompatibili in pubspec.yaml o dipendenze transitive in conflitto.

**Soluzione**:

1. Verifica il file pubspec.yaml per restrizioni di versione conflittuali

2. Usa il comando analisi dipendenze:
```bash
flutter pub deps
```

3. Risolvi conflitti specificando versioni compatibili:
```yaml
dependency_overrides:
  conflicting_package: ^1.0.0
```

4. Aggiorna tutte le dipendenze a versioni compatibili:
```bash
flutter pub upgrade --major-versions
```

---

### Conflitti di Versioni

**Descrizione**: Due o più pacchetti richiedono versioni incompatibili di una dipendenza comune.

**Causa Probabile**: Restrizioni di versione molto strette nelle dipendenze.

**Soluzione**:

1. Identifica il conflitto:
```bash
flutter pub deps | grep "✗"
```

2. Usa `dependency_overrides` temporaneamente:
```yaml
dependency_overrides:
  shared_dependency: ^2.0.0
```

3. Segnala il conflitto ai mantenitori dei pacchetti

4. Come ultima risorsa, considera alternative ai pacchetti conflittuali

---

### Errori di Generazione l10n

**Descrizione**: Fallimenti nella generazione file localizzazione.

**Causa Probabile**: Errori sintassi in file .arb o configurazione incorretta.

**Soluzione**:

1. Verifica la sintassi dei file .arb in `lib/l10n/`:
   - Assicurati che siano JSON validi
   - Verifica che i placeholder siano consistenti

2. Pulisci e rigenera:
```bash
flutter clean
flutter pub get
flutter gen-l10n
```

3. Verifica la configurazione in pubspec.yaml:
```yaml
flutter:
  generate: true
```

4. Controlla `l10n.yaml` per configurazione corretta

**Riferimenti**: [Internazionalizzazione in Flutter](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)

---

### Build Fallita su Android

**Descrizione**: La compilazione Android fallisce con vari errori.

**Causa Probabile**: Configurazione Gradle, versione SDK o problemi di permessi.

**Soluzione**:

1. Verifica la versione Java (richiede Java 17):
```bash
java -version
```

2. Pulisci completamente il progetto:
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
```

3. Verifica le configurazioni in `android/app/build.gradle`:
   - `compileSdkVersion`: 34
   - `minSdkVersion`: 23
   - `targetSdkVersion`: 34

4. Compila con informazioni dettagliate:
```bash
flutter build apk --verbose
```

5. Se l'errore menziona permessi, verifica `android/app/src/main/AndroidManifest.xml`

---

### Build Fallita su iOS

**Descrizione**: La compilazione iOS fallisce o non può firmare l'app.

**Causa Probabile**: Certificati, profili provisioning o configurazione Xcode.

**Soluzione**:

1. Apri il progetto in Xcode:
```bash
open ios/Runner.xcworkspace
```

2. Verifica la configurazione firma:
   - Seleziona il progetto Runner
   - In "Signing & Capabilities", verifica Team e Bundle Identifier

3. Pulisci build Xcode:
   - Product > Clean Build Folder (Shift + Cmd + K)

4. Aggiorna i pods:
```bash
cd ios
pod deintegrate
pod install
cd ..
```

5. Compila dal terminale:
```bash
flutter build ios --verbose
```

---

## Problemi con Database

### Database is Locked

**Descrizione**: Errore "database is locked" quando si tentano operazioni database.

**Causa Probabile**: Multiple connessioni che tentano di scrivere simultaneamente o transazione non chiusa.

**Soluzione**:

1. Assicurati di chiudere tutte le connessioni correttamente nel codice

2. Verifica che non ci siano transazioni aperte senza commit/rollback

3. Riavvia completamente l'applicazione

4. Come ultima risorsa, elimina il database:
```bash
# Android
adb shell run-as com.medicapp.app rm -r /data/data/com.medicapp.app/databases/

# iOS - da Xcode, elimina il container dell'app
```

**Riferimenti**: Controlla `lib/core/database/database_helper.dart` per la gestione delle transazioni.

---

### Errori di Migrazione

**Descrizione**: Fallimenti nell'aggiornamento schema database.

**Causa Probabile**: Script migrazione incorrecto o versione database inconsistente.

**Soluzione**:

1. Controlla gli script migrazione in `DatabaseHelper`

2. Verifica la versione attuale del database:
```dart
final db = await DatabaseHelper.instance.database;
print('Database version: ${await db.getVersion()}');
```

3. Se è sviluppo, resetta il database:
   - Disinstalla l'app
   - Reinstalla

4. Per produzione, crea uno script migrazione che gestisca il caso specifico

5. Usa la schermata debug dell'app per verificare lo stato del DB

---

### Dati Non Persistono

**Descrizione**: I dati inseriti scompaiono dopo la chiusura dell'app.

**Causa Probabile**: Operazioni database non si completano o falliscono silenziosamente.

**Soluzione**:

1. Abilita log database in modo debug

2. Verifica che operazioni insert/update ritornino successo:
```dart
final id = await db.insert('medications', medication.toMap());
print('Inserted medication with id: $id');
```

3. Assicurati che non ci siano eccezioni silenziose

4. Verifica permessi scrittura sul dispositivo

5. Controlla che `await` sia presente in tutte le operazioni async

---

### Corruzione Database

**Descrizione**: Errori aprendo il database o dati inconsistenti.

**Causa Probabile**: Chiusura inaspettata app durante scrittura o problema filesystem.

**Soluzione**:

1. Prova a riparare il database usando comando sqlite3 (richiede accesso root):
```bash
sqlite3 /percorso/a/database.db "PRAGMA integrity_check;"
```

2. Se corrotto, ripristina da backup se esiste

3. Se non c'è backup, resetta il database:
   - Disinstalla l'app
   - Reinstalla
   - I dati andranno persi

4. **Prevenzione**: Implementa backup automatici periodici

---

### Come Resettare Database

**Descrizione**: Devi eliminare completamente il database per ricominciare da zero.

**Causa Probabile**: Sviluppo, testing o risoluzione problemi.

**Soluzione**:

**Opzione 1 - Dall'App (Development)**:
```dart
// Nella schermata debug
await DatabaseHelper.instance.deleteDatabase();
```

**Opzione 2 - Android**:
```bash
adb shell run-as com.medicapp.app rm /data/data/com.medicapp.app/databases/medicapp.db
```

**Opzione 3 - iOS**:
- Disinstalla l'app dal dispositivo/simulatore
- Reinstalla

**Opzione 4 - Entrambe le piattaforme**:
```bash
flutter clean
# Disinstalla manualmente dal dispositivo
flutter run
```

---

## Problemi con Notifiche

### Notifiche Non Appaiono

**Descrizione**: Le notifiche programmate non vengono mostrate.

**Causa Probabile**: Permessi non concessi, notifiche disabilitate o errore nella programmazione.

**Soluzione**:

1. Verifica permessi notifiche:
   - Android 13+: Deve richiedere `POST_NOTIFICATIONS`
   - iOS: Deve richiedere autorizzazione al primo avvio

2. Controlla configurazione dispositivo:
   - Android: Impostazioni > App > MedicApp > Notifiche
   - iOS: Impostazioni > Notifiche > MedicApp

3. Verifica che le notifiche siano programmate:
```dart
final pendingNotifications = await flutterLocalNotificationsPlugin
    .pendingNotificationRequests();
print('Pending notifications: ${pendingNotifications.length}');
```

4. Controlla i log per errori programmazione

5. Usa la schermata debug dell'app per vedere notifiche programmate

---

### Permessi Negati (Android 13+)

**Descrizione**: Su Android 13+, le notifiche non funzionano anche se l'app le richiede.

**Causa Probabile**: Il permesso `POST_NOTIFICATIONS` è stato negato dall'utente.

**Soluzione**:

1. Verifica che il permesso sia dichiarato in `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

2. L'app deve richiedere il permesso a runtime

3. Se l'utente l'ha negato, guidalo alle impostazioni:
```dart
await openAppSettings();
```

4. Spiega all'utente perché le notifiche sono essenziali per l'app

5. Non presumere che il permesso sia concesso; verifica sempre prima di programmare

---

### Allarmi Esatti Non Funzionano

**Descrizione**: Le notifiche non appaiono nell'orario esatto programmato.

**Causa Probabile**: Manca permesso `SCHEDULE_EXACT_ALARM` o restrizioni batteria.

**Soluzione**:

1. Verifica permessi in `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
```

2. Per Android 12+, richiedi il permesso:
```dart
if (await Permission.scheduleExactAlarm.isDenied) {
  await Permission.scheduleExactAlarm.request();
}
```

3. Disattiva ottimizzazione batteria per l'app:
   - Impostazioni > Batteria > Ottimizzazione batteria
   - Cerca MedicApp e seleziona "Non ottimizzare"

4. Verifica di usare `androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle`

---

### Notifiche Non Suonano

**Descrizione**: Le notifiche appaiono ma senza suono.

**Causa Probabile**: Canale notifica senza suono o modo silenzioso dispositivo.

**Soluzione**:

1. Verifica la configurazione canale notifica:
```dart
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'medication_reminders',
  'Promemoria Farmaci',
  importance: Importance.high,
  sound: RawResourceAndroidNotificationSound('notification_sound'),
);
```

2. Assicurati che il file suono esista in `android/app/src/main/res/raw/`

3. Verifica configurazione dispositivo:
   - Android: Impostazioni > App > MedicApp > Notifiche > Categoria
   - iOS: Impostazioni > Notifiche > MedicApp > Suoni

4. Controlla che il dispositivo non sia in modo silenzioso/non disturbare

---

### Notifiche Dopo Riavvio Dispositivo

**Descrizione**: Le notifiche smettono di funzionare dopo il riavvio del dispositivo.

**Causa Probabile**: Le notifiche programmate non persistono dopo il riavvio.

**Soluzione**:

1. Aggiungi il permesso `RECEIVE_BOOT_COMPLETED` in `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

2. Implementa un `BroadcastReceiver` per riprogrammare notifiche:
```xml
<receiver android:name=".BootReceiver" android:enabled="true" android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
    </intent-filter>
</receiver>
```

3. Implementa la logica per riprogrammare tutte le notifiche pendenti

4. Su iOS, le notifiche locali persistono automaticamente

**Riferimenti**: Controlla `android/app/src/main/kotlin/.../MainActivity.kt`

---

## Problemi di Prestazioni

### App Lenta in Modo Debug

**Descrizione**: L'applicazione ha prestazioni scarse ed è lenta.

**Causa Probabile**: Il modo debug include strumenti sviluppo che influenzano le prestazioni.

**Soluzione**:

1. **Questo è normale in modo debug**. Per valutare le prestazioni reali, compila in modo profile o release:
```bash
flutter run --profile
# o
flutter run --release
```

2. Usa Flutter DevTools per identificare colli di bottiglia:
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

3. Verifica che non ci siano statement `print()` eccessivi in hot path

4. Non valutare mai le prestazioni in modo debug

---

### Consumo Eccessivo Batteria

**Descrizione**: L'applicazione consuma molta batteria.

**Causa Probabile**: Uso eccessivo notifiche, task background o query frequenti.

**Soluzione**:

1. Riduci la frequenza verifiche in background

2. Ottimizza le query database:
   - Usa indici appropriati
   - Evita query non necessarie
   - Cachea risultati quando possibile

3. Usa `WorkManager` invece di allarmi frequenti quando appropriato

4. Controlla uso sensori o GPS (se applicabile)

5. Profila uso batteria con Android Studio:
   - View > Tool Windows > Energy Profiler

---

### Lag in Liste Lunghe

**Descrizione**: Lo scroll in liste con molti elementi è lento o a scatti.

**Causa Probabile**: Rendering inefficiente widget o mancanza ottimizzazione ListView.

**Soluzione**:

1. Usa `ListView.builder` invece di `ListView`:
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

2. Implementa constructor `const` dove possibile

3. Evita widget pesanti in ogni item della lista

4. Usa `RepaintBoundary` per widget complessi:
```dart
RepaintBoundary(
  child: ComplexWidget(),
)
```

5. Considera paginazione per liste molto lunghe

6. Usa `AutomaticKeepAliveClientMixin` per mantenere stato item

---

### Frame Saltati

**Descrizione**: L'UI si sente a scatti con frame persi.

**Causa Probabile**: Operazioni costose nel thread principale.

**Soluzione**:

1. Identifica il problema con Flutter DevTools Performance tab

2. Sposta operazioni costose in isolate:
```dart
final result = await compute(expensiveFunction, data);
```

3. Evita operazioni sincrone pesanti nel metodo build

4. Usa `FutureBuilder` o `StreamBuilder` per operazioni async

5. Ottimizza immagini grandi:
   - Usa formati compressi
   - Cachea immagini decodificate
   - Usa thumbnail per anteprime

6. Controlla che non ci siano animazioni con listener costosi

---

## Problemi UI/UX

### Testo Non Si Traduce

**Descrizione**: Alcuni testi appaiono in inglese o altra lingua incorretta.

**Causa Probabile**: Manca la stringa nel file .arb o non viene usato AppLocalizations.

**Soluzione**:

1. Verifica che la stringa esista in `lib/l10n/app_it.arb`:
```json
{
  "yourKey": "Il tuo testo tradotto"
}
```

2. Assicurati di usare `AppLocalizations.of(context)`:
```dart
Text(AppLocalizations.of(context)!.yourKey)
```

3. Rigenera i file localizzazione:
```bash
flutter gen-l10n
```

4. Se hai aggiunto una nuova chiave, assicurati che esista in tutti i file .arb

5. Verifica che il locale dispositivo sia configurato correttamente

---

### Colori Incorretti

**Descrizione**: I colori non corrispondono al design o tema atteso.

**Causa Probabile**: Uso errato del tema o colori hardcoded.

**Soluzione**:

1. Usa sempre i colori del tema:
```dart
// Corretto
color: Theme.of(context).colorScheme.primary

// Incorretto
color: Colors.blue
```

2. Verifica la definizione del tema in `lib/core/theme/app_theme.dart`

3. Assicurati che MaterialApp abbia il tema configurato:
```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  // ...
)
```

4. Per debug, stampa i colori attuali:
```dart
print('Primary: ${Theme.of(context).colorScheme.primary}');
```

---

### Layout Rotto su Schermi Piccoli

**Descrizione**: La UI trabocca o si vede male su dispositivi con schermi piccoli.

**Causa Probabile**: Widget con dimensioni fisse o mancanza responsive design.

**Soluzione**:

1. Usa widget flessibili invece di dimensioni fisse:
```dart
// Invece di
Container(width: 300, child: ...)

// Usa
Expanded(child: ...)
// o
Flexible(child: ...)
```

2. Usa `LayoutBuilder` per layout adattivi:
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

3. Usa `MediaQuery` per ottenere dimensioni:
```dart
final screenWidth = MediaQuery.of(context).size.width;
```

4. Prova su diverse dimensioni schermo usando l'emulatore

---

### Overflow di Testo

**Descrizione**: Appare warning "overflow" con strisce gialle e nere.

**Causa Probabile**: Testo troppo lungo per lo spazio disponibile.

**Soluzione**:

1. Avvolgi il testo in `Flexible` o `Expanded`:
```dart
Flexible(
  child: Text('Testo lungo...'),
)
```

2. Usa `overflow` e `maxLines` nel widget Text:
```dart
Text(
  'Testo lungo...',
  overflow: TextOverflow.ellipsis,
  maxLines: 2,
)
```

3. Per testi molto lunghi, usa `SingleChildScrollView`:
```dart
SingleChildScrollView(
  child: Text('Testo molto lungo...'),
)
```

4. Considera accorciare il testo o usare un formato diverso

---

## Problemi Multi-Persona

### Stock Non Si Condivide Correttamente

**Descrizione**: Più persone possono creare farmaci con lo stesso nome senza condividere stock.

**Causa Probabile**: Logica verifica duplicati per persona invece che globale.

**Soluzione**:

1. Verifica la funzione ricerca farmaci esistenti in `MedicationRepository`

2. Assicurati che la ricerca sia globale:
```dart
// Cercare per nome senza filtrare per personId
final existing = await db.query(
  'medications',
  where: 'name = ?',
  whereArgs: [name],
);
```

3. Quando aggiungi una dose, associa la dose con la persona ma non il farmaco

4. Controlla la logica in `AddMedicationScreen` per riutilizzare farmaci esistenti

---

### Farmaci Duplicati

**Descrizione**: Appaiono farmaci duplicati nell'elenco.

**Causa Probabile**: Inserimenti multipli dello stesso farmaco o mancanza validazione.

**Soluzione**:

1. Implementa verifica prima di inserire:
```dart
final existing = await getMedicationByName(name);
if (existing != null) {
  return existing.id;
}
```

2. Usa restrizioni UNIQUE nel database:
```sql
CREATE TABLE medications (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  -- ...
);
```

3. Controlla la logica creazione farmaci nel repository

4. Se esistono già duplicati, crea uno script migrazione per consolidarli

---

### Storico Dosi Incorretto

**Descrizione**: Lo storico mostra dosi di altre persone o manca informazione.

**Causa Probabile**: Filtraggio incorretto per persona o join mal configurati.

**Soluzione**:

1. Verifica la query che ottiene lo storico:
```dart
final doses = await db.query(
  'dose_history',
  where: 'personId = ?',
  whereArgs: [personId],
  orderBy: 'takenAt DESC',
);
```

2. Assicurati che tutte le dosi abbiano `personId` associato

3. Controlla la logica filtro in `DoseHistoryScreen`

4. Verifica che i join tra tabelle includano la condizione persona

---

### Persona Predefinita Non Cambia

**Descrizione**: Quando si cambia la persona attiva, l'UI non si aggiorna correttamente.

**Causa Probabile**: Stato non si propaga correttamente o manca rebuild.

**Soluzione**:

1. Verifica che usi uno stato globale (Provider, Bloc, ecc.):
```dart
Provider.of<PersonProvider>(context, listen: true).currentPerson
```

2. Assicurati che il cambio persona attivi `notifyListeners()`:
```dart
void setCurrentPerson(Person person) {
  _currentPerson = person;
  notifyListeners();
}
```

3. Verifica che i widget rilevanti ascoltino i cambiamenti

4. Considera usare `Consumer` per rebuild specifici:
```dart
Consumer<PersonProvider>(
  builder: (context, provider, child) {
    return Text(provider.currentPerson.name);
  },
)
```

---

## Problemi con Digiuno

### Notifica Digiuno Non Appare

**Descrizione**: La notifica ongoing digiuno non viene mostrata.

**Causa Probabile**: Permessi, configurazione canale o errore creando notifica.

**Soluzione**:

1. Verifica che il canale notifiche digiuno sia creato:
```dart
const AndroidNotificationChannel fastingChannel = AndroidNotificationChannel(
  'fasting',
  'Digiuno',
  importance: Importance.low,
  enableVibration: false,
);
```

2. Assicurati di usare `ongoing: true`:
```dart
const NotificationDetails(
  android: AndroidNotificationDetails(
    'fasting',
    'Digiuno',
    ongoing: true,
    autoCancel: false,
  ),
)
```

3. Verifica permessi notifiche

4. Controlla log per errori creando notifica

---

### Conto Alla Rovescia Incorretto

**Descrizione**: Il tempo rimanente del digiuno non è corretto o non si aggiorna.

**Causa Probabile**: Calcolo incorretto tempo o mancanza aggiornamento periodico.

**Soluzione**:

1. Verifica il calcolo tempo rimanente:
```dart
final remaining = endTime.difference(DateTime.now());
```

2. Assicurati di aggiornare la notifica periodicamente:
```dart
Timer.periodic(Duration(minutes: 1), (timer) {
  updateFastingNotification();
});
```

3. Verifica che `endTime` del digiuno si memorizzi correttamente

4. Usa la schermata debug per verificare lo stato digiuno attuale

---

### Digiuno Non Si Cancella Automaticamente

**Descrizione**: La notifica digiuno rimane dopo che termina il tempo.

**Causa Probabile**: Manca logica per cancellare notifica al completamento.

**Soluzione**:

1. Implementa verifica quando il digiuno termina:
```dart
if (DateTime.now().isAfter(fasting.endTime)) {
  await cancelFastingNotification();
  await markFastingAsCompleted(fasting.id);
}
```

2. Verifica quando l'app si apre:
```dart
@override
void initState() {
  super.initState();
  checkActiveFastings();
}
```

3. Programma un allarme per quando termina il digiuno che cancelli la notifica

4. Assicurati che la notifica si cancelli in `onDidReceiveNotificationResponse`

**Riferimenti**: Controlla `lib/features/fasting/` per l'implementazione.

---

## Problemi di Testing

### Test Falliscono Localmente

**Descrizione**: I test che passano in CI falliscono sulla tua macchina locale.

**Causa Probabile**: Differenze ambiente, dipendenze o configurazione.

**Soluzione**:

1. Pulisci e ricostruisci:
```bash
flutter clean
flutter pub get
```

2. Verifica che le versioni siano le stesse:
```bash
flutter --version
dart --version
```

3. Esegui i test con più informazioni:
```bash
flutter test --verbose
```

4. Assicurati che non ci siano test che dipendono da stato precedente

5. Verifica che non ci siano test con dipendenze tempo (usa `fakeAsync`)

---

### Problemi con sqflite_common_ffi

**Descrizione**: Test database falliscono con errori sqflite.

**Causa Probabile**: sqflite non è disponibile nei test, devi usare sqflite_common_ffi.

**Soluzione**:

1. Assicurati di avere la dipendenza:
```yaml
dev_dependencies:
  sqflite_common_ffi: ^2.3.0
```

2. Inizializza nel setup test:
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

3. Usa database in memoria per test:
```dart
final db = await databaseFactoryFfi.openDatabase(
  inMemoryDatabasePath,
);
```

4. Pulisci il database dopo ogni test

---

### Timeout nei Test

**Descrizione**: I test falliscono per timeout.

**Causa Probabile**: Operazioni lente o deadlock in test async.

**Soluzione**:

1. Aumenta il timeout per test specifici:
```dart
test('slow test', () async {
  // ...
}, timeout: Timeout(Duration(seconds: 30)));
```

2. Verifica che non manchino `await`

3. Usa `fakeAsync` per test con delay:
```dart
testWidgets('timer test', (tester) async {
  await tester.runAsync(() async {
    // codice test con delay
  });
});
```

4. Mockea operazioni lente come chiamate rete

5. Controlla che non ci siano loop infiniti o race condition

---

### Test Inconsistenti

**Descrizione**: Gli stessi test a volte passano e a volte falliscono.

**Causa Probabile**: Test con dipendenze tempo, ordine esecuzione o stato condiviso.

**Soluzione**:

1. Evita dipendere dal tempo reale, usa `fakeAsync` o mock

2. Assicurati che ogni test sia indipendente:
```dart
setUp(() {
  // Setup pulito per ogni test
});

tearDown(() {
  // Pulizia dopo ogni test
});
```

3. Non condividere stato mutabile tra test

4. Usa `setUpAll` solo per setup immutabile

5. Esegui test in ordine casuale per rilevare dipendenze:
```bash
flutter test --test-randomize-ordering-seed=random
```

---

## Problemi di Permessi

### POST_NOTIFICATIONS (Android 13+)

**Descrizione**: Le notifiche non funzionano su Android 13 o superiore.

**Causa Probabile**: Il permesso POST_NOTIFICATIONS deve essere richiesto a runtime.

**Soluzione**:

1. Dichiara il permesso in `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

2. Richiedi il permesso a runtime:
```dart
if (Platform.isAndroid && await Permission.notification.isDenied) {
  final status = await Permission.notification.request();
  if (status.isDenied) {
    // Informare utente e offrire andare a impostazioni
  }
}
```

3. Verifica il permesso prima di programmare notifiche

4. Guida l'utente alle impostazioni se negato permanentemente

**Riferimenti**: [Android 13 Notification Permission](https://developer.android.com/about/versions/13/changes/notification-permission)

---

### SCHEDULE_EXACT_ALARM (Android 12+)

**Descrizione**: Gli allarmi esatti non funzionano su Android 12+.

**Causa Probabile**: Richiede permesso speciale da Android 12.

**Soluzione**:

1. Dichiara il permesso:
```xml
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
```

2. Verifica e richiedi se necessario:
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

3. Spiega all'utente perché hai bisogno di allarmi esatti

4. Considera usare `USE_EXACT_ALARM` se sei un'app allarme/promemoria

---

### USE_EXACT_ALARM (Android 14+)

**Descrizione**: Hai bisogno di allarmi esatti senza richiedere permesso speciale.

**Causa Probabile**: Android 14 introduce USE_EXACT_ALARM per app allarme.

**Soluzione**:

1. Se la tua app è principalmente allarmi/promemoria, usa:
```xml
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
```

2. Questa è un'alternativa a `SCHEDULE_EXACT_ALARM` che non richiede che l'utente conceda il permesso manualmente

3. Usala solo se la tua app soddisfa i [casi d'uso permessi](https://developer.android.com/about/versions/14/changes/schedule-exact-alarms)

4. L'app deve avere come funzionalità principale allarmi o promemoria

---

### Notifiche in Background (iOS)

**Descrizione**: Le notifiche non funzionano correttamente su iOS.

**Causa Probabile**: Permessi non richiesti o configurazione incorretta.

**Soluzione**:

1. Richiedi permessi all'avvio app:
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

3. Assicurati di avere le capability corrette in Xcode:
   - Push Notifications
   - Background Modes

4. Verifica che l'utente non abbia disabilitato notifiche in Impostazioni

---

## Errori Comuni e Soluzioni

### MissingPluginException

**Descrizione**: Errore "MissingPluginException(No implementation found for method...)"

**Causa Probabile**: Il plugin non è registrato correttamente o serve hot restart.

**Soluzione**:

1. Fai un hot restart completo (non solo hot reload):
```bash
# Nel terminale dove gira l'app
r  # hot reload
R  # HOT RESTART (questo è quello che serve)
```

2. Se persiste, ricostruisci completamente:
```bash
flutter clean
flutter pub get
flutter run
```

3. Verifica che il plugin sia in `pubspec.yaml`

4. Per iOS, reinstalla i pods:
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
```

---

### PlatformException

**Descrizione**: Errore "PlatformException" con diversi codici.

**Causa Probabile**: Dipende dal codice specifico dell'errore.

**Soluzione**:

1. Leggi il messaggio errore e codice completi

2. Errori comuni:
   - `permission_denied`: Verifica permessi
   - `error`: Errore generico, controlla log nativi
   - `not_available`: Funzione non disponibile su questa piattaforma

3. Per Android, controlla logcat:
```bash
adb logcat | grep -i flutter
```

4. Per iOS, controlla la console Xcode

5. Assicurati di gestire questi errori gracefully:
```dart
try {
  await somePluginMethod();
} on PlatformException catch (e) {
  print('Error: ${e.code} - ${e.message}');
  // Gestire appropriatamente
}
```

---

### DatabaseException

**Descrizione**: Errore eseguendo operazioni database.

**Causa Probabile**: Query invalida, restrizione violata o database corrotto.

**Soluzione**:

1. Leggi il messaggio errore completo per identificare il problema

2. Errori comuni:
   - `UNIQUE constraint failed`: Tentando inserire duplicato
   - `no such table`: Tabella non esiste, controlla migrazioni
   - `syntax error`: Query SQL invalida

3. Verifica la query SQL:
```dart
try {
  await db.query('medications', where: 'id = ?', whereArgs: [id]);
} on DatabaseException catch (e) {
  print('Database error: ${e.toString()}');
}
```

4. Assicurati che le migrazioni siano state eseguite

5. Come ultima risorsa, resetta il database

---

### StateError

**Descrizione**: Errore "Bad state: No element" o simile.

**Causa Probabile**: Tentando accedere a un elemento che non esiste.

**Soluzione**:

1. Identifica la riga esatta dell'errore nello stack trace

2. Usa metodi sicuri:
```dart
// Invece di
final item = list.first;  // Lancia StateError se vuota

// Usa
final item = list.isNotEmpty ? list.first : null;
// o
final item = list.firstOrNull;  // Dart 3.0+
```

3. Verifica sempre prima di accedere:
```dart
if (list.isNotEmpty) {
  final item = list.first;
  // usare item
}
```

4. Usa try-catch se necessario:
```dart
try {
  final item = list.single;
} on StateError {
  // Gestire caso dove non c'è esattamente un elemento
}
```

---

### Null Check Operator Used on Null Value

**Descrizione**: Errore usando operatore `!` su valore null.

**Causa Probabile**: Variabile nullable usata con `!` quando il suo valore è null.

**Soluzione**:

1. Identifica la riga esatta nello stack trace

2. Verifica il valore prima di usare `!`:
```dart
// Invece di
final value = nullableValue!;

// Usa
if (nullableValue != null) {
  final value = nullableValue;
  // usare value
}
```

3. Usa operatore `??` per valori predefiniti:
```dart
final value = nullableValue ?? defaultValue;
```

4. Usa operatore `?.` per accesso sicuro:
```dart
final length = nullableString?.length;
```

5. Controlla perché il valore è null quando non dovrebbe esserlo

---

## Log e Debug

### Come Abilitare Log

**Descrizione**: Devi vedere log dettagliati per debuggare un problema.

**Soluzione**:

1. **Log Flutter**:
```bash
flutter run --verbose
```

2. **Log solo app**:
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

3. **Log nativi Android**:
```bash
adb logcat | grep -i flutter
# o per vedere tutto
adb logcat
```

4. **Log nativi iOS**:
   - Apri Console.app su macOS
   - Seleziona dispositivo/simulatore
   - Filtra per "flutter" o bundle identifier

---

### Log Notifiche

**Descrizione**: Devi vedere log relativi a notifiche.

**Soluzione**:

1. Aggiungi log nel codice notifiche:
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

2. Elenca notifiche pendenti:
```dart
final pending = await flutterLocalNotificationsPlugin
    .pendingNotificationRequests();
for (var notification in pending) {
  print('Pending: ${notification.id} - ${notification.title}');
}
```

3. Verifica log sistema:
   - Android: `adb logcat | grep -i notification`
   - iOS: Console.app con filtro "notification"

---

### Log Database

**Descrizione**: Devi vedere le query database eseguite.

**Soluzione**:

1. Abilita logging in sqflite:
```dart
import 'package:sqflite/sqflite.dart';

void main() {
  Sqflite.setDebugModeOn(true);
  runApp(MyApp());
}
```

2. Aggiungi log nelle tue query:
```dart
print('Executing query: SELECT * FROM medications WHERE id = $id');
final result = await db.query('medications', where: 'id = ?', whereArgs: [id]);
print('Query returned ${result.length} rows');
```

3. Wrapper per logging automatico:
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

### Usare Debugger

**Descrizione**: Devi mettere in pausa l'esecuzione ed esaminare lo stato.

**Soluzione**:

1. **In VS Code**:
   - Metti un breakpoint cliccando vicino al numero riga
   - Esegui in modo debug (F5)
   - Quando mette in pausa, usa i controlli debug

2. **In Android Studio**:
   - Metti un breakpoint cliccando nel margine
   - Esegui Debug (Shift + F9)
   - Usa pannello Debug per step over/into/out

3. **Debugger programmatico**:
```dart
import 'dart:developer';

void someFunction() {
  debugger();  // Mette in pausa qui se c'è debugger connesso
  // codice...
}
```

4. **Ispezionare variabili**:
```dart
print('Value: $value');  // Logging semplice
debugPrint('Value: $value');  // Logging che rispetta rate limit
```

---

### Schermata Debug App

**Descrizione**: MedicApp include una schermata debug utile.

**Soluzione**:

1. Accedi alla schermata debug dal menu impostazioni

2. Funzioni disponibili:
   - Vedere database (tabelle, righe, contenuto)
   - Vedere notifiche programmate
   - Vedere stato sistema
   - Forzare aggiornamento notifiche
   - Pulire database
   - Vedere log recenti

3. Usa questa schermata per:
   - Verificare che i dati siano salvati correttamente
   - Controllare notifiche pendenti
   - Identificare problemi stato

4. Disponibile solo in modo debug

---

## Resettare l'Applicazione

### Pulire Dati App

**Descrizione**: Devi eliminare tutti i dati senza disinstallare.

**Soluzione**:

**Android**:
```bash
adb shell pm clear com.medicapp.app
```

**iOS**:
- Impostazioni > Generali > Spazio iPhone
- Cerca MedicApp
- "Elimina App" (non "Scarica App")

**Dall'app** (solo debug):
- Usa la schermata debug
- "Reset Database"

---

### Disinstallare e Reinstallare

**Descrizione**: Installazione pulita completa.

**Soluzione**:

**Android**:
```bash
adb uninstall com.medicapp.app
flutter run
```

**iOS**:
```bash
# Dal dispositivo/simulatore, tieni premuta l'icona
# Seleziona "Elimina App"
flutter run
```

**Da Flutter**:
```bash
flutter clean
rm -rf build/
flutter run
```

---

### Resettare Database

**Descrizione**: Eliminare solo il database mantenendo l'app.

**Soluzione**:

**Da codice** (solo debug):
```dart
await DatabaseHelper.instance.deleteDatabase();
```

**Android - Manualmente**:
```bash
adb shell
run-as com.medicapp.app
cd databases
rm medicapp.db medicapp.db-shm medicapp.db-wal
exit
```

**iOS - Manualmente**:
- Serve accesso al container dell'app
- È più facile disinstallare e reinstallare

---

### Pulire Cache Flutter

**Descrizione**: Risolvere problemi compilazione relativi a cache.

**Soluzione**:

1. Pulizia base:
```bash
flutter clean
```

2. Pulizia completa:
```bash
flutter clean
rm -rf build/
rm -rf .dart_tool/
rm pubspec.lock
flutter pub get
```

3. Pulire cache pub:
```bash
flutter pub cache repair
```

4. Pulire cache Gradle (Android):
```bash
cd android
./gradlew clean cleanBuildCache
rm -rf ~/.gradle/caches/
cd ..
```

5. Pulire cache pods (iOS):
```bash
cd ios
rm -rf Pods Podfile.lock
pod cache clean --all
pod install
cd ..
```

---

## Problemi Conosciuti

### Lista Bug Conosciuti

1. **Notifiche non persistono dopo riavvio su alcuni dispositivi Android**
   - Colpisce: Android 12+ con ottimizzazione batteria aggressiva
   - Workaround: Disattivare ottimizzazione batteria per MedicApp

2. **Layout overflow su schermi molto piccoli (<5")**
   - Colpisce: Dispositivi con larghezza < 320dp
   - Stato: Fix pianificato per v1.1.0

3. **Animazione transizione a scatti su dispositivi low-end**
   - Colpisce: Dispositivi con <2GB RAM
   - Workaround: Disattivare animazioni in impostazioni

4. **Database può crescere indefinitamente**
   - Colpisce: Utenti con molto storico (>1 anno)
   - Workaround: Implementare pulizia periodica storico vecchio
   - Stato: Feature archiviazione automatica pianificata

---

### Workaround Temporanei

1. **Se le notifiche non suonano su alcuni dispositivi**:
```dart
// Usa massima importanza temporaneamente
importance: Importance.max,
priority: Priority.high,
```

2. **Se c'è lag in liste lunghe**:
   - Limita storico visibile agli ultimi 30 giorni
   - Implementa paginazione manuale

3. **Se il database si blocca frequentemente**:
   - Riduci operazioni concorrenti
   - Usa transazioni batch per insert multipli

---

### Issue in GitHub

**Come cercare issue esistenti**:

1. Vai a: https://github.com/tuo-utente/medicapp/issues

2. Usa i filtri:
   - `is:issue is:open` - Issue aperti
   - `label:bug` - Solo bug
   - `label:enhancement` - Feature richieste

3. Cerca per parole chiave: "notification", "database", ecc.

**Prima di creare un nuovo issue**:
- Cerca se esiste già uno simile
- Verifica la lista problemi conosciuti sopra
- Assicurati che non sia risolto nell'ultima versione

---

## Ottenere Aiuto

### Rivedere Documentazione

**Risorse disponibili**:

1. **Documentazione progetto**:
   - `README.md` - Informazioni generali e setup
   - `docs/it/ARCHITECTURE.md` - Architettura progetto
   - `docs/it/CONTRIBUTING.md` - Guida contribuzione
   - `docs/it/TESTING.md` - Guida testing

2. **Documentazione Flutter**:
   - [flutter.dev/docs](https://flutter.dev/docs)
   - [api.flutter.dev](https://api.flutter.dev)

3. **Documentazione pacchetti**:
   - Controlla pub.dev per ogni dipendenza
   - Leggi README e changelog di ogni pacchetto

---

### Cercare in GitHub Issues

**Come cercare efficacemente**:

1. Usa ricerca avanzata:
```
repo:tuo-utente/medicapp is:issue [parole chiave]
```

2. Cerca issue chiusi anche:
```
is:issue is:closed notification not working
```

3. Cerca per label:
```
label:bug label:android label:notifications
```

4. Cerca in commenti:
```
commenter:username [parole chiave]
```

---

### Creare Nuovo Issue con Template

**Prima di creare un issue**:

1. Conferma che sia realmente un bug o feature request valido
2. Cerca issue duplicati
3. Raccogli tutte le informazioni necessarie

**Informazioni necessarie**:

**Per bug**:
- Descrizione chiara del problema
- Passaggi per riprodurre
- Comportamento atteso vs attuale
- Screenshot/video se applicabile
- Informazioni ambiente (vedi sotto)
- Log rilevanti

**Per feature**:
- Descrizione funzionalità
- Caso d'uso e benefici
- Proposta implementazione (opzionale)
- Mockup o esempi (opzionale)

**Template issue**:
```markdown
## Descrizione
[Descrizione chiara e concisa del problema]

## Passaggi per Riprodurre
1. [Primo passo]
2. [Secondo passo]
3. [Terzo passo]

## Comportamento Atteso
[Cosa dovrebbe succedere]

## Comportamento Attuale
[Cosa succede realmente]

## Informazioni Ambiente
- OS: [Android 13 / iOS 16.5]
- Dispositivo: [Modello specifico]
- Versione MedicApp: [v1.0.0]
- Versione Flutter: [3.24.5]

## Log
```
[Log rilevanti]
```

## Screenshot
[Se applicabile]

## Informazioni Aggiuntive
[Qualsiasi altro contesto]
```

---

### Informazioni Necessarie per Segnalare

**Includi sempre**:

1. **Versione app**:
```dart
// Da pubspec.yaml
version: 1.0.0+1
```

2. **Informazioni dispositivo**:
```dart
import 'package:device_info_plus/device_info_plus.dart';

final deviceInfo = DeviceInfoPlugin();
if (Platform.isAndroid) {
  final androidInfo = await deviceInfo.androidInfo;
  print('Android ${androidInfo.version.sdkInt}');
  print('Model: ${androidInfo.model}');
}
```

3. **Versione Flutter**:
```bash
flutter --version
```

4. **Log completi**:
```bash
flutter run --verbose > logs.txt 2>&1
# Allega logs.txt all'issue
```

5. **Stack trace completo** se c'è crash

6. **Screenshot o video** che mostrano il problema

---

## Conclusione

Questa guida copre i problemi più comuni in MedicApp. Se trovi un problema non elencato qui:

1. Controlla la documentazione completa del progetto
2. Cerca in GitHub Issues
3. Chiedi nelle discussioni del repository
4. Crea un nuovo issue con tutte le informazioni necessarie

**Ricorda**: Fornire informazioni dettagliate e passaggi per riprodurre rende molto più facile risolvere rapidamente il tuo problema.

Per contribuire miglioramenti a questa guida, per favore apri una PR o issue nel repository.

---

**Ultimo aggiornamento**: 2025-11-14
**Versione documento**: 1.0.0
