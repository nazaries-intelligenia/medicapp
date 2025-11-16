# Stack Tecnologico di MedicApp

Questo documento dettaglia tutte le tecnologie, framework, librerie e strumenti utilizzati in MedicApp, incluse le versioni esatte, giustificazioni delle scelte, alternative considerate e compromessi di ogni decisione tecnologica.

---

## 1. Core Technologies

### Flutter 3.9.2+

**Versione utilizzata:** `3.9.2+` (SDK compatibile fino a `3.35.7+`)

**Scopo:**
Flutter è il framework multipiattaforma che costituisce la base di MedicApp. Permette di sviluppare un'applicazione nativa per Android e iOS da un'unica base di codice Dart, garantendo prestazioni vicine al nativo ed esperienza utente coerente su entrambe le piattaforme.

**Perché è stato scelto Flutter:**

1. **Sviluppo multipiattaforma efficiente:** Un'unica base di codice per Android e iOS riduce i costi di sviluppo e manutenzione del 60-70% rispetto allo sviluppo nativo duale.

2. **Prestazioni native:** Flutter compila in codice ARM nativo, non utilizza bridge JavaScript come React Native, il che si traduce in animazioni fluide a 60/120 FPS e tempi di risposta istantanei per operazioni critiche come la registrazione delle dosi.

3. **Hot Reload:** Permette iterazione rapida durante lo sviluppo, visualizzando i cambiamenti in meno di 1 secondo senza perdere lo stato dell'applicazione. Essenziale per regolare l'UI delle notifiche e i flussi multi-step.

4. **Material Design 3 nativo:** Implementazione completa e aggiornata di Material Design 3 inclusa nell'SDK, senza necessità di librerie di terze parti.

5. **Ecosistema maturo:** Pub.dev conta più di 40.000 pacchetti, incluse soluzioni robuste per notifiche locali, database SQLite e gestione dei file.

6. **Testing integrato:** Framework di testing completo incluso nell'SDK, con supporto per unit test, widget test e integration test. MedicApp raggiunge 432+ test con copertura del 75-80%.

**Alternative considerate:**

- **React Native:** Scartato per prestazioni inferiori nelle liste lunghe (cronologia delle dosi), problemi con le notifiche locali in background ed esperienza incoerente tra le piattaforme.
- **Kotlin Multiplatform Mobile (KMM):** Scartato per immaturità dell'ecosistema, necessità di codice UI specifico per piattaforma e curva di apprendimento più ripida.
- **Nativo (Swift + Kotlin):** Scartato per duplicazione dello sforzo di sviluppo, maggiori costi di manutenzione e necessità di due team specializzati.

**Documentazione ufficiale:** https://flutter.dev

---

### Dart 3.0+

**Versione utilizzata:** `3.9.2+` (compatibile con Flutter 3.9.2+)

**Scopo:**
Dart è il linguaggio di programmazione orientato agli oggetti sviluppato da Google che esegue Flutter. Fornisce sintassi moderna, tipizzazione forte, null safety e prestazioni ottimizzate.

**Caratteristiche utilizzate in MedicApp:**

1. **Null Safety:** Sistema di tipi che elimina errori di riferimento nullo a tempo di compilazione. Critico per l'affidabilità di un sistema medico dove un NullPointerException potrebbe impedire la registrazione di una dose vitale.

2. **Async/Await:** Programmazione asincrona elegante per operazioni di database, notifiche e operazioni su file senza bloccare l'UI.

3. **Extension Methods:** Permette di estendere classi esistenti con metodi personalizzati, utilizzato per formattazione di date e validazioni di modelli.

4. **Records e Pattern Matching (Dart 3.0+):** Strutture di dati immutabili per restituire multipli valori da funzioni in modo sicuro.

5. **Strong Type System:** Tipizzazione statica che rileva errori a tempo di compilazione, essenziale per operazioni critiche come calcolo dello stock e programmazione delle notifiche.

**Perché Dart:**

- **Ottimizzato per UI:** Dart è stato progettato specificamente per lo sviluppo di interfacce, con garbage collection ottimizzato per evitare pause durante le animazioni.
- **AOT e JIT:** Compilazione Ahead-of-Time per produzione (prestazioni native) e Just-in-Time per sviluppo (Hot Reload).
- **Sintassi familiare:** Simile a Java, C#, JavaScript, riducendo la curva di apprendimento.
- **Sound Null Safety:** Garanzia a tempo di compilazione che le variabili non nulle non saranno mai null.

**Documentazione ufficiale:** https://dart.dev

---

### Material Design 3

**Versione:** Implementazione nativa in Flutter 3.9.2+

**Scopo:**
Material Design 3 (Material You) è il sistema di design di Google che fornisce componenti, pattern e linee guida per creare interfacce moderne, accessibili e coerenti.

**Implementazione in MedicApp:**

```dart
useMaterial3: true
```

**Componenti utilizzati:**

1. **Color Scheme dinamico:** Sistema di colori basato su semi (`seedColor: Color(0xFF006B5A)` per tema chiaro, `Color(0xFF00A894)` per tema scuro) che genera automaticamente 30+ tonalità armoniche.

2. **FilledButton, OutlinedButton, TextButton:** Pulsanti con stati visivi (hover, pressed, disabled) e dimensioni aumentate (52dp altezza minima) per l'accessibilità.

3. **Card con elevazione adattativa:** Schede con angoli arrotondati (16dp) e ombre sottili per gerarchia visiva.

4. **NavigationBar:** Barra di navigazione inferiore con indicatori di selezione animati e supporto per navigazione tra 3-5 destinazioni principali.

5. **FloatingActionButton esteso:** FAB con testo descrittivo per azione primaria (aggiungere farmaco).

6. **ModalBottomSheet:** Fogli modali per azioni contestuali come registrazione rapida della dose.

7. **SnackBar con azioni:** Feedback temporaneo per operazioni completate (dose registrata, farmaco aggiunto).

**Temi personalizzati:**

MedicApp implementa due temi completi (chiaro e scuro) con tipografia accessibile:

- **Dimensioni dei font aumentate:** `titleLarge: 26sp`, `bodyLarge: 19sp` (superiori agli standard di 22sp e 16sp rispettivamente).
- **Contrasto migliorato:** Colori del testo con opacità 87% su sfondi per conformarsi a WCAG AA.
- **Pulsanti grandi:** Altezza minima di 52dp (vs 40dp standard) per facilitare il tocco sui dispositivi mobili.

**Perché Material Design 3:**

- **Accessibilità integrata:** Componenti progettati con supporto per screen reader, dimensioni tattili minime e rapporti di contrasto WCAG.
- **Coerenza con l'ecosistema Android:** Aspetto familiare per utenti Android 12+.
- **Personalizzazione flessibile:** Sistema di token di design che permette di adattare colori, tipografie e forme mantenendo la coerenza.
- **Modalità scura automatica:** Supporto nativo per tema scuro basato sulla configurazione del sistema.

**Documentazione ufficiale:** https://m3.material.io

---

## 2. Database e Persistenza

### sqflite ^2.3.0

**Versione utilizzata:** `^2.3.0` (compatibile con `2.3.0` fino a `< 3.0.0`)

**Scopo:**
sqflite è il plugin SQLite per Flutter che fornisce accesso a un database SQL locale, relazionale e transazionale. MedicApp utilizza SQLite come storage principale per tutti i dati di farmaci, persone, configurazioni di schemi e cronologia delle dosi.

**Architettura del database di MedicApp:**

```
medicapp.db
├── medications (tabella principale)
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
├── person_medications (tabella di relazione N:M)
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

**Operazioni critiche:**

1. **Transazioni ACID:** Garanzia di atomicità per operazioni complesse come registrazione dose + decremento stock + programmazione notifica.

2. **Query relazionali:** JOIN tra `medications`, `persons` e `person_medications` per ottenere configurazioni personalizzate per utente.

3. **Indici ottimizzati:** Indici su `person_id` e `medication_id` nelle tabelle di relazione per query veloci O(log n).

4. **Migrazioni versionate:** Sistema di migrazione schema da V1 fino a V19+ con preservazione dei dati.

**Perché SQLite:**

1. **ACID compliance:** Garanzie transazionali critiche per dati medici dove l'integrità è fondamentale.

2. **Query SQL complesse:** Capacità di eseguire JOIN, aggregazioni e subquery per report e filtri avanzati.

3. **Prestazioni provate:** SQLite è il database più distribuito al mondo, con ottimizzazioni di 20+ anni.

4. **Zero-configuration:** Non richiede server, configurazione o amministrazione. Il database è un unico file portabile.

5. **Esportazione/importazione semplice:** Il file `.db` può essere copiato direttamente per backup o trasferimenti tra dispositivi.

6. **Dimensione illimitata:** SQLite supporta database fino a 281 terabyte, più che sufficiente per decenni di cronologia delle dosi.

**Confronto con alternative:**

| Caratteristica | SQLite (sqflite) | Hive | Isar | Drift |
|----------------|------------------|------|------|-------|
| **Modello dati** | Relazionale SQL | NoSQL Key-Value | NoSQL Documentale | Relazionale SQL |
| **Linguaggio query** | SQL standard | API Dart | Query Builder Dart | SQL + Dart |
| **Transazioni ACID** | ✅ Completo | ❌ Limitato | ✅ Sì | ✅ Sì |
| **Migrazioni** | ✅ Manuale robusto | ⚠️ Manuale base | ⚠️ Semi-automatico | ✅ Automatico |
| **Prestazioni lettura** | ⚡ Eccellente | ⚡⚡ Superiore | ⚡⚡ Superiore | ⚡ Eccellente |
| **Prestazioni scrittura** | ⚡ Molto buono | ⚡⚡ Eccellente | ⚡⚡ Eccellente | ⚡ Molto buono |
| **Dimensione su disco** | ⚠️ Più grande | ✅ Compatto | ✅ Molto compatto | ⚠️ Più grande |
| **Relazioni N:M** | ✅ Nativo | ❌ Manuale | ⚠️ Riferimenti | ✅ Nativo |
| **Maturità** | ✅ 20+ anni | ⚠️ 4 anni | ⚠️ 3 anni | ✅ 5+ anni |
| **Portabilità** | ✅ Universale | ⚠️ Proprietario | ⚠️ Proprietario | ⚠️ Flutter-only |
| **Strumenti esterni** | ✅ DB Browser, CLI | ❌ Limitati | ❌ Limitati | ❌ Nessuno |

**Giustificazione di SQLite rispetto alle alternative:**

- **Hive:** Scartato per mancanza di supporto robusto per relazioni N:M (architettura multi-persona), assenza di transazioni ACID complete e difficoltà nell'eseguire query complesse con JOIN.

- **Isar:** Scartato nonostante le eccellenti prestazioni per la sua immaturità (lanciato nel 2022), formato proprietario che rende difficile il debugging con strumenti standard e limitazioni nelle query relazionali complesse.

- **Drift:** Considerato seriamente ma scartato per maggiore complessità (richiede generazione di codice), maggiore dimensione dell'applicazione risultante e minore flessibilità nelle migrazioni rispetto a SQL diretto.

**Compromessi di SQLite:**

- ✅ **Pro:** Stabilità provata, SQL standard, strumenti esterni, relazioni native, esportazione banale.
- ❌ **Contro:** Prestazioni leggermente inferiori a Hive/Isar in operazioni massive, dimensione file più grande, boilerplate SQL manuale.

**Decisione:** Per MedicApp, la necessità di relazioni N:M robuste, migrazioni complesse da V1 a V19+ e capacità di debugging con strumenti SQL standard giustifica ampiamente l'uso di SQLite rispetto alle alternative NoSQL più veloci ma meno mature.

**Documentazione ufficiale:** https://pub.dev/packages/sqflite

---

### sqflite_common_ffi ^2.3.0

**Versione utilizzata:** `^2.3.0` (dev_dependencies)

**Scopo:**
Implementazione FFI (Foreign Function Interface) di sqflite che permette di eseguire test di database in ambienti desktop/VM senza necessità di emulatori Android/iOS.

**Uso in MedicApp:**

```dart
// test/helpers/database_test_helper.dart
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void setupTestDatabase() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}
```

**Perché è necessario:**

- **Test 60x più veloci:** I test del database vengono eseguiti su VM locale invece che su emulatori Android, riducendo il tempo da 120s a 2s per la suite completa.
- **CI/CD senza emulatori:** GitHub Actions può eseguire test senza configurare emulatori, semplificando le pipeline.
- **Debugging migliorato:** I file `.db` di test sono accessibili direttamente dal filesystem dell'host.

**Documentazione ufficiale:** https://pub.dev/packages/sqflite_common_ffi

---

### path ^1.8.3

**Versione utilizzata:** `^1.8.3`

**Scopo:**
Libreria di manipolazione di percorsi di file multipiattaforma che astrae le differenze tra filesystem (Windows: `\`, Unix: `/`).

**Uso in MedicApp:**

```dart
import 'package:path/path.dart' as path;

final dbPath = path.join(await getDatabasesPath(), 'medicapp.db');
```

**Documentazione ufficiale:** https://pub.dev/packages/path

---

### path_provider ^2.1.5

**Versione utilizzata:** `^2.1.5`

**Scopo:**
Plugin che fornisce accesso a directory specifiche del sistema operativo in modo multipiattaforma (documenti, cache, supporto applicazione).

**Uso in MedicApp:**

```dart
import 'package:path_provider/path_provider.dart';

// Ottenere directory del database
final dbDirectory = await getDatabasesPath(); // Android: /data/data/com.medicapp/databases/

// Ottenere directory per esportazioni
final documentsDirectory = await getApplicationDocumentsDirectory();
```

**Directory utilizzate:**

1. **getDatabasesPath():** Per il file `medicapp.db` principale.
2. **getApplicationDocumentsDirectory():** Per esportazioni di database che l'utente può condividere.
3. **getTemporaryDirectory():** Per file temporanei durante l'importazione.

**Documentazione ufficiale:** https://pub.dev/packages/path_provider

---

## 3. Notifiche

### flutter_local_notifications ^19.5.0

**Versione utilizzata:** `^19.5.0`

**Scopo:**
Sistema completo di notifiche locali (non richiedono server) per Flutter, con supporto per notifiche programmate, ripetitive, con azioni e personalizzate per piattaforma.

**Implementazione in MedicApp:**

MedicApp utilizza un sistema di notifiche sofisticato che gestisce tre tipi di notifiche:

1. **Notifiche di promemoria dosi:**
   - Programmate con orari esatti configurati dall'utente.
   - Includono titolo con nome della persona (in multi-persona) e dettagli della dose.
   - Supporto per azioni rapide: "Prendi", "Posticipa", "Salta" (scartate in V20+ per limitazioni di tipo).
   - Suono personalizzato e canale ad alta priorità su Android.

2. **Notifiche di dosi anticipate:**
   - Rilevano quando una dose viene presa prima dell'orario programmato.
   - Aggiornano automaticamente la prossima notifica se applicabile.
   - Annullano notifiche obsolete dell'orario anticipato.

3. **Notifiche di fine digiuno:**
   - Notifica ongoing (permanente) durante il periodo di digiuno con conto alla rovescia.
   - Si annulla automaticamente quando termina il digiuno o quando viene chiusa manualmente.
   - Include progresso visivo (Android) e ora di fine.

**Configurazione per piattaforma:**

**Android:**
```dart
AndroidInitializationSettings('app_icon')
AndroidNotificationDetails(
  'medication_reminders',
  'Promemoria Farmaci',
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

**Caratteristiche avanzate utilizzate:**

1. **Scheduling preciso:** Notifiche programmate con precisione al secondo usando `timezone`.
2. **Canali di notifica (Android 8+):** 3 canali separati per promemoria, digiuno e sistema.
3. **Payload personalizzato:** Dati JSON nel payload per identificare farmaco e persona.
4. **Callback di interazione:** Callback quando l'utente tocca la notifica.
5. **Gestione permessi:** Richiesta e verifica permessi su Android 13+ (Tiramisu).

**Limiti e ottimizzazioni:**

- **Limite di 500 notifiche programmate simultanee** (limitazione del sistema Android).
- MedicApp gestisce prioritizzazione automatica quando si supera questo limite:
  - Prioritizza i prossimi 7 giorni.
  - Scarta notifiche di farmaci inattivi.
  - Riorganizza quando si aggiungono/eliminano farmaci.

**Perché flutter_local_notifications:**

1. **Notifiche locali vs remote:** MedicApp non richiede server backend, quindi le notifiche locali sono l'architettura corretta.

2. **Funzionalità completa:** Supporto per scheduling, ripetizione, azioni, personalizzazione per piattaforma e gestione permessi.

3. **Maturità provata:** Pacchetto con 5+ anni di sviluppo, 3000+ stelle su GitHub, utilizzato in produzione da migliaia di applicazioni.

4. **Documentazione esaustiva:** Esempi dettagliati per tutti i casi d'uso comuni.

**Perché NON Firebase Cloud Messaging (FCM):**

| Criterio | flutter_local_notifications | Firebase Cloud Messaging |
|----------|----------------------------|--------------------------|
| **Richiede server** | ❌ No | ✅ Sì (Firebase) |
| **Richiede connessione** | ❌ No | ✅ Sì (internet) |
| **Privacy** | ✅ Tutti i dati locali | ⚠️ Token su Firebase |
| **Latenza** | ✅ Istantanea | ⚠️ Dipende dalla rete |
| **Costo** | ✅ Gratis | ⚠️ Quota gratuita limitata |
| **Complessità setup** | ✅ Minima | ❌ Alta (Firebase, server) |
| **Funziona offline** | ✅ Sempre | ❌ No |
| **Scheduling preciso** | ✅ Sì | ❌ No (approssimato) |

**Decisione:** Per un'applicazione di gestione farmaci dove la privacy è critica, le dosi devono essere notificate puntualmente anche senza connessione, e non c'è necessità di comunicazione server-client, le notifiche locali sono l'architettura corretta e più semplice.

**Confronto con alternative:**

- **awesome_notifications:** Scartato per minore adozione (meno maturo), API più complesse e problemi segnalati con notifiche programmate su Android 12+.

- **local_notifications (nativo):** Scartato per richiedere codice specifico di piattaforma (Kotlin/Swift), duplicando lo sforzo di sviluppo.

**Documentazione ufficiale:** https://pub.dev/packages/flutter_local_notifications

---

### timezone ^0.10.1

**Versione utilizzata:** `^0.10.1`

**Scopo:**
Libreria di gestione fusi orari che permette di programmare notifiche in momenti specifici del giorno considerando cambi di ora legale (DST) e conversioni tra fusi orari.

**Uso in MedicApp:**

```dart
import 'package:timezone/timezone.dart' as tz;

// Inizializzazione
await tz.initializeTimeZones();
final location = tz.getLocation('Europe/Madrid');
tz.setLocalLocation(location);

// Programmare notifica alle 08:00 locali
final scheduledDate = tz.TZDateTime(
  location,
  now.year,
  now.month,
  now.day,
  8, // ora
  0, // minuti
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

**Perché è critico:**

- **Ora legale:** Senza `timezone`, le notifiche si sfaserebbero di 1 ora durante i cambi di DST.
- **Coerenza:** Gli utenti configurano orari nel loro fuso orario locale, che deve essere rispettato indipendentemente dai cambi di fuso orario del dispositivo.
- **Precisione:** `zonedSchedule` garantisce notifiche nel momento esatto specificato.

**Documentazione ufficiale:** https://pub.dev/packages/timezone

---

### android_intent_plus ^6.0.0

**Versione utilizzata:** `^6.0.0`

**Scopo:**
Plugin per lanciare intenzioni (Intent) Android da Flutter, utilizzato specificamente per aprire le impostazioni delle notifiche quando i permessi sono disabilitati.

**Uso in MedicApp:**

```dart
import 'package:android_intent_plus/android_intent.dart';

// Aprire impostazioni notifiche dell'app
final intent = AndroidIntent(
  action: 'android.settings.APP_NOTIFICATION_SETTINGS',
  arguments: {
    'android.provider.extra.APP_PACKAGE': packageName,
  },
);
await intent.launch();
```

**Casi d'uso:**

1. **Guidare l'utente:** Quando i permessi delle notifiche sono disabilitati, si mostra un dialogo esplicativo con pulsante "Apri Impostazioni" che lancia direttamente la schermata impostazioni notifiche di MedicApp.

2. **UX migliorata:** Evita che l'utente debba navigare manualmente: Impostazioni > Applicazioni > MedicApp > Notifiche.

**Documentazione ufficiale:** https://pub.dev/packages/android_intent_plus

---

## 4. Localizzazione (i18n)

### flutter_localizations (SDK)

**Versione utilizzata:** Incluso in Flutter SDK

**Scopo:**
Pacchetto ufficiale di Flutter che fornisce localizzazioni per widget Material e Cupertino in 85+ lingue, incluse traduzioni di componenti standard (pulsanti di dialogo, picker, ecc.).

**Uso in MedicApp:**

```dart
import 'package:flutter_localizations/flutter_localizations.dart';

MaterialApp(
  localizationsDelegates: [
    GlobalMaterialLocalizations.delegate, // Material widgets
    GlobalWidgetsLocalizations.delegate,  // Widget generici
    GlobalCupertinoLocalizations.delegate, // Cupertino (iOS)
  ],
  supportedLocales: [
    Locale('es'), // Spagnolo
    Locale('en'), // Inglese
    Locale('de'), // Tedesco
    // ... 8 lingue totali
  ],
)
```

**Cosa fornisce:**

- Traduzioni di pulsanti standard: "OK", "Annulla", "Accetta".
- Formati di data e ora localizzati: "15/11/2025" (it) vs "11/15/2025" (en).
- Selettori di data/ora nella lingua locale.
- Nomi di giorni e mesi.

**Documentazione ufficiale:** https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization

---

### intl ^0.20.2

**Versione utilizzata:** `^0.20.2`

**Scopo:**
Libreria di internazionalizzazione di Dart che fornisce formattazione di date, numeri, pluralizzazione e traduzione di messaggi tramite file ARB.

**Uso in MedicApp:**

```dart
import 'package:intl/intl.dart';

// Formattazione date
final formatted = DateFormat('dd/MM/yyyy').format(DateTime.now());

// Formattazione numeri
final stock = NumberFormat.decimalPattern().format(25.5);

// Pluralizzazione (da ARB)
// "{count, plural, =1{1 pastiglia} other{{count} pastiglie}}"
```

**Casi d'uso:**

1. **Formattazione date:** Mostrare date di inizio/fine trattamento, cronologia dosi.
2. **Formattazione numeri:** Mostrare stock con decimali secondo configurazione regionale.
3. **Pluralizzazione intelligente:** Messaggi che cambiano secondo quantità ("1 pastiglia" vs "5 pastiglie").

**Documentazione ufficiale:** https://pub.dev/packages/intl

---

### Sistema ARB (Application Resource Bundle)

**Formato utilizzato:** ARB (basato su JSON)

**Scopo:**
Sistema di file di risorse applicazione che permette di definire traduzioni di stringhe in formato JSON con supporto per placeholder, pluralizzazione e metadati.

**Configurazione in MedicApp:**

**`l10n.yaml`:**
```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
untranslated-messages-file: untranslated_messages.json
```

**Struttura dei file:**
```
lib/l10n/
├── app_es.arb (template principale, spagnolo)
├── app_en.arb (traduzioni inglese)
├── app_de.arb (traduzioni tedesco)
├── app_fr.arb (traduzioni francese)
├── app_it.arb (traduzioni italiano)
├── app_ca.arb (traduzioni catalano)
├── app_eu.arb (traduzioni basco)
└── app_gl.arb (traduzioni galiziano)
```

**Esempio di ARB con caratteristiche avanzate:**

**`app_es.arb`:**
```json
{
  "@@locale": "es",

  "appTitle": "MedicApp",
  "@appTitle": {
    "description": "Titolo dell'applicazione"
  },

  "medicationDose": "{count, plural, =1{1 {unit}} other{{count} {unit}}}",
  "@medicationDose": {
    "description": "Dose di farmaco con pluralizzazione",
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

  "stockRemaining": "Rimangono {stock} {unit, plural, =1{unità} other{unità}}",
  "@stockRemaining": {
    "placeholders": {
      "stock": {"type": "num"},
      "unit": {"type": "String"}
    }
  }
}
```

**Generazione automatica:**

Flutter genera automaticamente la classe `AppLocalizations` con metodi tipizzati:

```dart
// Codice generato in .dart_tool/flutter_gen/gen_l10n/app_localizations.dart
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

// Uso nel codice
Text(AppLocalizations.of(context)!.medicationDose(2.5, 'pastiglie'))
// Risultato: "2.5 pastiglie"
```

**Vantaggi del sistema ARB:**

1. **Tipizzazione forte:** Errori di traduzione rilevati in compilazione.
2. **Placeholder sicuri:** Impossibile dimenticare parametri richiesti.
3. **Pluralizzazione CLDR:** Supporto per regole di pluralizzazione di 200+ lingue secondo Unicode CLDR.
4. **Metadati utili:** Descrizioni e contesto per traduttori.
5. **Strumenti di traduzione:** Compatibile con Google Translator Toolkit, Crowdin, Lokalise.

**Processo di traduzione in MedicApp:**

1. Definire stringhe in `app_es.arb` (template).
2. Eseguire `flutter gen-l10n` per generare codice Dart.
3. Tradurre in altre lingue copiando e modificando file ARB.
4. Rivedere `untranslated_messages.json` per rilevare stringhe mancanti.

**Documentazione ufficiale:** https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization#adding-your-own-localized-messages

---

### 8 Lingue Supportate

MedicApp è completamente tradotta in 8 lingue:

| Codice | Lingua | Regione principale | Parlanti (milioni) |
|--------|--------|------------------|----------------------|
| `es` | Español | Spagna, America Latina | 500M+ |
| `en` | English | Globale | 1,500M+ |
| `de` | Deutsch | Germania, Austria, Svizzera | 130M+ |
| `fr` | Français | Francia, Canada, Africa | 300M+ |
| `it` | Italiano | Italia, Svizzera | 85M+ |
| `ca` | Català | Catalogna, Valencia, Baleari | 10M+ |
| `eu` | Euskara | Paesi Baschi | 750K+ |
| `gl` | Galego | Galizia | 2.5M+ |

**Copertura totale:** ~2.500 miliardi di parlanti potenziali

**Stringhe totali:** ~450 traduzioni per lingua

**Qualità della traduzione:**
- Spagnolo: Nativo (template)
- Inglese: Nativo
- Tedesco, francese, italiano: Professionale
- Catalano, basco, galiziano: Nativo (lingue co-ufficiali della Spagna)

**Giustificazione delle lingue incluse:**

- **Spagnolo:** Lingua principale dello sviluppatore e mercato obiettivo iniziale (Spagna, America Latina).
- **Inglese:** Lingua universale per portata globale.
- **Tedesco, francese, italiano:** Principali lingue dell'Europa occidentale, mercati con alta domanda di app di salute.
- **Catalano, basco, galiziano:** Lingue co-ufficiali in Spagna (regioni con 17M+ abitanti), migliora l'accessibilità per utenti anziani più comodi nella lingua materna.

---

## 5. Gestione dello Stato

### Senza libreria di gestione dello stato (Vanilla Flutter)

**Decisione:** MedicApp **NON utilizza** alcuna libreria di gestione dello stato (Provider, Riverpod, BLoC, Redux, GetX).

**Perché NON si usa gestione dello stato:**

1. **Architettura basata su database:** Lo stato vero dell'applicazione risiede in SQLite, non in memoria. Ogni schermata interroga il database direttamente per ottenere dati aggiornati.

2. **StatefulWidget + setState è sufficiente:** Per un'applicazione di complessità media come MedicApp, `setState()` e `StatefulWidget` forniscono gestione dello stato locale più che adeguata.

3. **Semplicità sui framework:** Evitare dipendenze non necessarie riduce complessità, dimensione dell'applicazione e possibili breaking changes negli aggiornamenti.

4. **Stream di database:** Per dati reattivi, si utilizzano `StreamBuilder` con stream diretti da `DatabaseHelper`:

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

5. **Navigazione con callback:** Per comunicazione tra schermate, si utilizzano callback tradizionali di Flutter:

```dart
// Schermata principale
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => AddMedicationScreen(
      onMedicationAdded: () {
        setState(() {}); // Aggiornare lista
      },
    ),
  ),
);
```

**Confronto con alternative:**

| Soluzione | MedicApp (Vanilla) | Provider | BLoC | Riverpod |
|----------|-------------------|----------|------|----------|
| **Linee di codice aggiuntive** | 0 | ~500 | ~1,500 | ~800 |
| **Dipendenze esterne** | 0 | 1 | 2+ | 2+ |
| **Curva di apprendimento** | ✅ Minima | ⚠️ Media | ❌ Alta | ⚠️ Media-Alta |
| **Boilerplate** | ✅ Nessuno | ⚠️ Medio | ❌ Alto | ⚠️ Medio |
| **Testing** | ✅ Diretto | ⚠️ Richiede mock | ⚠️ Richiede setup | ⚠️ Richiede setup |
| **Prestazioni** | ✅ Eccellente | ⚠️ Buono | ⚠️ Buono | ⚠️ Buono |
| **Dimensione APK** | ✅ Minimo | +50KB | +150KB | +100KB |

**Perché NON Provider:**

- **Non necessario:** Provider è progettato per condividere stato tra widget profondamente annidati. MedicApp ottiene dati dal database in ogni schermata radice, senza necessità di passare stato verso il basso.
- **Complessità aggiunta:** Richiede `ChangeNotifier`, `MultiProvider`, context-awareness e comprensione dell'albero dei widget.
- **Sovra-ingegnerizzazione:** Per un'applicazione con ~15 schermate e stato in database, Provider sarebbe usare un martello pneumatico per piantare un chiodo.

**Perché NON BLoC:**

- **Complessità estrema:** BLoC (Business Logic Component) richiede comprensione di stream, sink, eventi, stati e architettura a strati.
- **Boilerplate massiccio:** Ogni feature richiede 4-5 file (bloc, event, state, repository, test).
- **Sovra-ingegnerizzazione:** BLoC è eccellente per applicazioni aziendali con logica di business complessa e sviluppatori multipli. MedicApp è un'applicazione di complessità media dove la semplicità è prioritaria.

**Perché NON Riverpod:**

- **Meno maturo:** Riverpod è relativamente nuovo (2020) rispetto a Provider (2018) e BLoC (2018).
- **Complessità simile a Provider:** Richiede comprensione di provider, autoDispose, family e architettura dichiarativa.
- **Nessun vantaggio chiaro:** Per MedicApp, Riverpod non offre benefici significativi rispetto all'architettura attuale.

**Perché NON Redux:**

- **Complessità massiccia:** Redux richiede azioni, reducer, middleware, store e immutabilità stretta.
- **Boilerplate insostenibile:** Persino operazioni semplici richiedono file multipli e centinaia di linee di codice.
- **Overkill totale:** Redux è progettato per applicazioni web SPA con stato complesso in frontend. MedicApp ha stato in SQLite, non in memoria.

**Casi dove SI necessiterebbe gestione dello stato:**

- **Stato condiviso complesso in memoria:** Se schermate multiple necessitassero di condividere oggetti grandi in memoria (non si applica a MedicApp).
- **Stato globale di autenticazione:** Se ci fosse login/sessioni (MedicApp è locale, senza account).
- **Sincronizzazione in tempo reale:** Se ci fosse collaborazione multi-utente in tempo reale (non si applica).
- **Logica di business complessa:** Se ci fossero calcoli pesanti che richiedono cache in memoria (MedicApp fa calcoli semplici di stock e date).

**Decisione finale:**

Per MedicApp, l'architettura **Database as Single Source of Truth + StatefulWidget + setState** è la soluzione corretta. È semplice, diretta, facile da capire e mantenere, e non introduce complessità non necessaria. Aggiungere Provider, BLoC o Riverpod sarebbe pura sovra-ingegnerizzazione senza benefici tangibili.

---

## 6. Registrazione e Debug

### logger ^2.0.0

**Versione utilizzata:** `^2.0.0` (compatibile con `2.0.0` fino a `< 3.0.0`)

**Scopo:**
logger è una libreria di logging professionale per Dart che fornisce un sistema di log strutturato, configurabile e con multipli livelli di severità. Sostituisce l'uso di `print()` statements con un sistema di logging robusto appropriato per applicazioni in produzione.

**Livelli di logging:**

MedicApp utilizza 6 livelli di log secondo la loro severità:

1. **VERBOSE (trace):** Informazioni di diagnostica molto dettagliate (sviluppo)
2. **DEBUG:** Informazioni utili durante lo sviluppo
3. **INFO:** Messaggi informativi sul flusso dell'applicazione
4. **WARNING:** Avvisi che non impediscono il funzionamento
5. **ERROR:** Errori che richiedono attenzione ma l'app può recuperarsi
6. **WTF (What a Terrible Failure):** Errori gravi che non dovrebbero mai verificarsi

**Implementazione in MedicApp:**

**`lib/services/logger_service.dart`:**
```dart
import 'package:logger/logger.dart';

class LoggerService {
  LoggerService._();

  static Logger? _logger;
  static bool _isTestMode = false;

  static Logger get instance {
    _logger ??= _createLogger();
    return _logger!;
  }

  static Logger _createLogger() {
    return Logger(
      filter: _LogFilter(),
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 80,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTime,
      ),
      output: ConsoleOutput(),
    );
  }

  // Metodi di comodità
  static void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (!_isTestMode) {
      instance.d(message, error: error, stackTrace: stackTrace);
    }
  }

  static void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (!_isTestMode) {
      instance.i(message, error: error, stackTrace: stackTrace);
    }
  }

  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (!_isTestMode) {
      instance.e(message, error: error, stackTrace: stackTrace);
    }
  }
}

class _LogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (LoggerService.isTestMode) return false;
    if (kReleaseMode) {
      return event.level.index >= Level.warning.index;
    }
    return true;
  }
}
```

**Uso nel codice:**

```dart
// PRIMA (con print)
print('Programmazione notifica per ${medication.name}');
print('Errore nel salvataggio: $e');

// DOPO (con LoggerService)
LoggerService.info('Programmazione notifica per ${medication.name}');
LoggerService.error('Errore nel salvataggio', e);
```

**Esempi di uso per livello:**

```dart
// Informazioni su flusso normale
LoggerService.info('Farmaco creato: ${medication.name}');

// Debugging durante sviluppo
LoggerService.debug('Query eseguita: SELECT * FROM medications WHERE id = ${id}');

// Avvisi non critici
LoggerService.warning('Stock basso per ${medication.name}: ${stock} unità');

// Errori recuperabili
LoggerService.error('Errore nella programmazione notifica', e, stackTrace);

// Errori gravi
LoggerService.wtf('Stato incoerente: farmaco senza ID', error);
```

**Caratteristiche utilizzate:**

1. **PrettyPrinter:** Formato leggibile con colori, emoji e timestamp:
```
💡 INFO 14:23:45 | Farmaco creato: Ibuprofene
⚠️  WARNING 14:24:10 | Stock basso: Paracetamolo
❌ ERROR 14:25:33 | Errore nel salvataggio
```

2. **Filtaggio automatico:** In release, mostra solo warning ed errori:
```dart
// Debug mode: mostra tutti i log
// Release mode: solo WARNING, ERROR, WTF
```

3. **Test mode:** Sopprime tutti i log durante il testing:
```dart
LoggerService.enableTestMode();  // Nel setUp dei test
```

4. **Stack trace automatici:** Per errori, stampa stack trace completo:
```dart
LoggerService.error('Errore database', e, stackTrace);
// Output include stack trace formattato
```

5. **Senza dipendenza da BuildContext:** Può essere usato in qualsiasi parte del codice:
```dart
// In servizi
class NotificationService {
  void scheduleNotification() {
    LoggerService.info('Programmazione notifica...');
  }
}

// In modelli
class Medication {
  void validate() {
    if (stock < 0) {
      LoggerService.warning('Stock negativo: $stock');
    }
  }
}
```

**Perché logger:**

1. **Professionale:** Progettato per produzione, non solo sviluppo
2. **Configurabile:** Diversi livelli, filtri, formati
3. **Rendimento:** Filtaggio intelligente in release mode
4. **Debugging migliorato:** Colori, emoji, timestamp, stack trace
5. **Test friendly:** Modo test per sopprimere i log
6. **Zero configurazione:** Funziona out-of-the-box con configurazione sensata

**Migrazione da print() a LoggerService:**

MedicApp ha migrato **279 print() statements** in **15 file** al sistema LoggerService:

| File | Print migrati | Livello predominante |
|---------|----------------|-------------------|
| notification_service.dart | 112 | info, error, warning |
| database_helper.dart | 26 | debug, info, error |
| fasting_notification_scheduler.dart | 32 | info, warning |
| daily_notification_scheduler.dart | 25 | info, warning |
| dose_calculation_service.dart | 25 | debug, info |
| medication_list_viewmodel.dart | 7 | info, error |
| **Totale** | **279** | - |

**Confronto con alternative:**

| Caratteristica | logger | print() | logging package | soluzione custom |
|----------------|--------|---------|----------------|-----------------|
| **Livelli di log** | ✅ 6 livelli | ❌ Nessuno | ✅ 7 livelli | ⚠️ Manuale |
| **Colori** | ✅ Sì | ❌ No | ⚠️ Base | ⚠️ Manuale |
| **Timestamp** | ✅ Configurabile | ❌ No | ✅ Sì | ⚠️ Manuale |
| **Filtaggio** | ✅ Automatico | ❌ No | ✅ Manuale | ⚠️ Manuale |
| **Stack trace** | ✅ Automatico | ❌ Manuale | ⚠️ Manuale | ⚠️ Manuale |
| **Pretty print** | ✅ Eccellente | ❌ Base | ⚠️ Base | ⚠️ Manuale |
| **Dimensione** | ✅ ~50KB | ✅ 0KB | ⚠️ ~100KB | ✅ Variabile |

**Perché NON print():**

- ❌ Non differenzia tra debug, info, warning, error
- ❌ Senza timestamp, difficile debugging
- ❌ Senza colori, difficile leggere in console
- ❌ Non si può filtrare in produzione
- ❌ Non appropriato per applicazioni professionali

**Perché NON logging package (dart:logging):**

- ⚠️ Più complesso da configurare
- ⚠️ Pretty printing richiede implementazione custom
- ⚠️ Meno ergonomico (più boilerplate)
- ⚠️ Non include colori/emoji by default

**Compromessi di logger:**

- ✅ **Pro:** Setup semplice, output bellissimo, filtaggio intelligente, appropriato per produzione
- ❌ **Contro:** Aggiunge ~50KB all'APK (irrilevante), una dipendenza in più

**Decisione:** Per MedicApp, dove il debugging e il monitoraggio sono critici (è un'app medica), logger fornisce il perfetto balance tra semplicità e funzionalità professionale. I 50KB aggiuntivi sono insignificanti rispetto ai benefici del debugging e al codice più mantenibile.

**Documentazione ufficiale:** https://pub.dev/packages/logger

---

## 7. Archiviazione Locale

### shared_preferences ^2.2.2

**Versione utilizzata:** `^2.2.2`

**Scopo:**
Archiviazione persistente chiave-valore per preferenze semplici dell'utente, configurazioni applicazione e stati non critici. Utilizza `SharedPreferences` su Android e `UserDefaults` su iOS.

**Uso in MedicApp:**

MedicApp utilizza `shared_preferences` per archiviare configurazioni leggere che non giustificano una tabella SQL:

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

**Dati archiviati:**

1. **Tema applicazione:**
   - Chiave: `theme_mode`
   - Valori: `ThemeMode.light`, `ThemeMode.dark`, `ThemeMode.system`
   - Uso: Persistere preferenza tema tra sessioni.

2. **Lingua selezionata:**
   - Chiave: `locale`
   - Valori: `es`, `en`, `de`, `fr`, `it`, `ca`, `eu`, `gl`
   - Uso: Ricordare lingua scelta dall'utente (override della lingua di sistema).

3. **Stato permessi:**
   - Chiave: `notifications_enabled`
   - Valori: `true`, `false`
   - Uso: Cache locale dello stato permessi per evitare chiamate native ripetute.

4. **Prima esecuzione:**
   - Chiave: `first_run`
   - Valori: `true`, `false`
   - Uso: Mostrare tutorial/onboarding solo alla prima esecuzione.

**Perché shared_preferences e non SQLite:**

- **Prestazioni:** Accesso istantaneo O(1) per valori semplici vs query SQL con overhead.
- **Semplicità:** API banale (`getString`, `setString`) vs preparare query SQL.
- **Scopo:** Preferenze utente vs dati relazionali.
- **Dimensione:** Valori piccoli (< 1KB) vs record complessi.

**Limitazioni di shared_preferences:**

- ❌ Non supporta relazioni, JOIN, transazioni.
- ❌ Non appropriato per dati >100KB.
- ❌ Accesso asincrono (richiede `await`).
- ❌ Solo tipi primitivi (String, int, double, bool, List<String>).

**Compromessi:**

- ✅ **Pro:** API semplice, prestazioni eccellenti, scopo corretto per preferenze.
- ❌ **Contro:** Non appropriato per dati strutturati o voluminosi.

**Documentazione ufficiale:** https://pub.dev/packages/shared_preferences

---

## 8. Operazioni sui File

### file_picker ^8.0.0+1

**Versione utilizzata:** `^8.0.0+1`

**Scopo:**
Plugin multipiattaforma per selezionare file dal filesystem del dispositivo, con supporto per piattaforme multiple (Android, iOS, desktop, web).

**Uso in MedicApp:**

MedicApp utilizza `file_picker` esclusivamente per la funzione di **importazione database**, permettendo all'utente di ripristinare un backup o migrare dati da altro dispositivo.

**Implementazione:**

```dart
import 'package:file_picker/file_picker.dart';

Future<void> importDatabase() async {
  // Aprire selettore file
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['db'],
    dialogTitle: 'Selezionare file database',
  );

  if (result == null) return; // Utente ha annullato

  final file = result.files.single;
  final path = file.path!;

  // Validare e copiare file
  await DatabaseHelper.instance.importDatabase(path);

  // Ricaricare applicazione
  setState(() {});
}
```

**Caratteristiche utilizzate:**

1. **Filtro estensioni:** Permette solo di selezionare file `.db` per evitare errori dell'utente.
2. **Titolo personalizzato:** Mostra messaggio descrittivo nel dialogo di sistema.
3. **Percorso completo:** Ottiene path assoluto del file per copiarlo nella posizione dell'app.

**Alternative considerate:**

- **image_picker:** Scartato perché progettato specificamente per immagini/video, non file generici.
- **Codice nativo:** Scartato perché richiederebbe implementare `ActivityResultLauncher` (Android) e `UIDocumentPickerViewController` (iOS) manualmente.

**Documentazione ufficiale:** https://pub.dev/packages/file_picker

---

### share_plus ^10.1.4

**Versione utilizzata:** `^10.1.4`

**Scopo:**
Plugin multipiattaforma per condividere file, testo e URL utilizzando il foglio di condivisione nativo del sistema operativo (Android Share Sheet, iOS Share Sheet).

**Uso in MedicApp:**

MedicApp utilizza `share_plus` per la funzione di **esportazione database**, permettendo all'utente di creare un backup e condividerlo via email, cloud storage (Drive, Dropbox), Bluetooth o salvarlo in file locali.

**Implementazione:**

```dart
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

Future<void> exportDatabase() async {
  // Ottenere percorso database corrente
  final dbPath = await DatabaseHelper.instance.getDatabasePath();

  // Creare copia temporanea in directory condivisibile
  final tempDir = await getTemporaryDirectory();
  final exportPath = '${tempDir.path}/medicapp_backup_${DateTime.now().millisecondsSinceEpoch}.db';

  // Copiare database
  await File(dbPath).copy(exportPath);

  // Condividere file
  await Share.shareXFiles(
    [XFile(exportPath)],
    subject: 'Backup MedicApp',
    text: 'Database di MedicApp - ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
  );
}
```

**Flusso utente:**

1. Utente tocca "Esporta database" nel menu impostazioni.
2. MedicApp crea copia di `medicapp.db` con timestamp nel nome.
3. Si apre il foglio di condivisione nativo del SO.
4. Utente sceglie destinazione: Gmail (come allegato), Drive, Bluetooth, "Salva in file", ecc.
5. Il file `.db` viene condiviso/salvato nella destinazione scelta.

**Caratteristiche avanzate:**

- **XFile:** Astrazione multipiattaforma di file che funziona su Android, iOS, desktop e web.
- **Metadati:** Include nome file descrittivo e testo esplicativo.
- **Compatibilità:** Funziona con tutte le app compatibili con il protocollo di condivisione del SO.

**Perché share_plus:**

- **UX nativa:** Utilizza l'interfaccia di condivisione che l'utente già conosce, senza reinventare la ruota.
- **Integrazione perfetta:** Si integra automaticamente con tutte le app installate che possono ricevere file.
- **Multipiattaforma:** Stesso codice funziona su Android e iOS con comportamento nativo su ciascuno.

**Alternative considerate:**

- **Scrivere in directory pubblica direttamente:** Scartato perché su Android 10+ (Scoped Storage) richiede permessi complessi e non funziona in modo coerente.
- **Plugin email diretto:** Scartato perché limita l'utente a un solo metodo di backup (email), mentre `share_plus` permette qualsiasi destinazione.

**Documentazione ufficiale:** https://pub.dev/packages/share_plus

---

## 9. Testing

### flutter_test (SDK)

**Versione utilizzata:** Incluso in Flutter SDK

**Scopo:**
Framework ufficiale di testing di Flutter che fornisce tutti gli strumenti necessari per unit test, widget test e integration test.

**Architettura di testing di MedicApp:**

MedicApp conta **432+ test** organizzati in 3 categorie:

#### 1. Unit Test (60% dei test)

Test di logica di business pura, modelli, servizi e helper senza dipendenze da Flutter.

**Esempi:**
- `test/medication_model_test.dart`: Validazione di modelli di dati.
- `test/dose_history_service_test.dart`: Logica di cronologia dosi.
- `test/notification_service_test.dart`: Logica di programmazione notifiche.
- `test/preferences_service_test.dart`: Servizio di preferenze.

**Struttura tipica:**
```dart
void main() {
  setUpAll(() async {
    // Inizializzare database di test
    setupTestDatabase();
  });

  tearDown(() async {
    // Pulire database dopo ogni test
    await DatabaseHelper.instance.close();
  });

  group('Medication Model', () {
    test('dovrebbe creare farmaco con dati validi', () {
      final medication = Medication(
        id: 'test-id',
        name: 'Ibuprofene',
        type: MedicationType.pill,
      );

      expect(medication.id, 'test-id');
      expect(medication.name, 'Ibuprofene');
      expect(medication.type, MedicationType.pill);
    });

    test('dovrebbe calcolare prossimo orario dose correttamente', () {
      final medication = Medication(
        id: 'test',
        name: 'Test',
        times: ['08:00', '20:00'],
      );

      final now = DateTime(2025, 1, 15, 10, 0); // 10:00 AM
      final nextDose = medication.getNextDoseTime(now);

      expect(nextDose.hour, 20); // Prossima dose alle 20:00
    });
  });
}
```

#### 2. Widget Test (30% dei test)

Test di widget individuali, interazioni UI e flussi di navigazione.

**Esempi:**
- `test/settings_screen_test.dart`: Schermata impostazioni.
- `test/edit_schedule_screen_test.dart`: Editor orari.
- `test/edit_duration_screen_test.dart`: Editor durata.
- `test/day_navigation_ui_test.dart`: Navigazione giorni.

**Struttura tipica:**
```dart
void main() {
  testWidgets('dovrebbe visualizzare lista farmaci', (tester) async {
    // Arrange: Preparare dati di test
    final medications = [
      Medication(id: '1', name: 'Ibuprofene', type: MedicationType.pill),
      Medication(id: '2', name: 'Paracetamolo', type: MedicationType.pill),
    ];

    // Act: Costruire widget
    await tester.pumpWidget(
      MaterialApp(
        home: MedicationListScreen(medications: medications),
      ),
    );

    // Assert: Verificare UI
    expect(find.text('Ibuprofene'), findsOneWidget);
    expect(find.text('Paracetamolo'), findsOneWidget);

    // Interazione: Toccare primo farmaco
    await tester.tap(find.text('Ibuprofene'));
    await tester.pumpAndSettle();

    // Verificare navigazione
    expect(find.byType(MedicationDetailScreen), findsOneWidget);
  });
}
```

#### 3. Integration Test (10% dei test)

Test end-to-end di flussi completi che coinvolgono schermate multiple, database e servizi.

**Esempi:**
- `test/integration/add_medication_test.dart`: Flusso completo aggiunta farmaco (8 passi).
- `test/integration/dose_registration_test.dart`: Registrazione dose e aggiornamento stock.
- `test/integration/stock_management_test.dart`: Gestione completa stock (ricarica, esaurimento, avvisi).
- `test/integration/app_startup_test.dart`: Avvio applicazione e caricamento dati.

**Struttura tipica:**
```dart
void main() {
  testWidgets('flusso completo aggiunta farmaco', (tester) async {
    // Avviare applicazione
    await tester.pumpWidget(const MedicApp());
    await tester.pumpAndSettle();

    // Passo 1: Aprire schermata aggiunta farmaco
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Passo 2: Inserire nome
    await tester.enterText(find.byType(TextField).first, 'Ibuprofene 600mg');

    // Passo 3: Selezionare tipo
    await tester.tap(find.text('Pastiglia'));
    await tester.pumpAndSettle();

    // Passo 4: Passo successivo
    await tester.tap(find.text('Successivo'));
    await tester.pumpAndSettle();

    // ... continuare con gli 8 passi

    // Verificare farmaco aggiunto
    expect(find.text('Ibuprofene 600mg'), findsOneWidget);

    // Verificare in database
    final medications = await DatabaseHelper.instance.getMedications();
    expect(medications.length, 1);
    expect(medications.first.name, 'Ibuprofene 600mg');
  });
}
```

**Copertura codice:**

- **Obiettivo:** 75-80%
- **Attuale:** 75-80% (432+ test)
- **Linee coperte:** ~12.000 di ~15.000

**Aree con maggiore copertura:**
- Modelli: 95%+ (logica critica dati)
- Servizi: 85%+ (notifiche, database, dosi)
- Schermate: 65%+ (UI e navigazione)

**Aree con minore copertura:**
- Helper e utilities: 60%
- Codice di inizializzazione: 50%

**Strategia di testing:**

1. **Test-first per logica critica:** Test scritti prima del codice per calcoli di dosi, stock, orari.
2. **Test-after per UI:** Test scritti dopo aver implementato schermate per verificare comportamento.
3. **Regression test:** Ogni bug trovato diventa un test per evitare regressioni.

**Comandi di testing:**

```bash
# Eseguire tutti i test
flutter test

# Eseguire test con copertura
flutter test --coverage

# Eseguire test specifici
flutter test test/medication_model_test.dart

# Eseguire test di integrazione
flutter test test/integration/
```

**Helper di testing:**

**`test/helpers/database_test_helper.dart`:**
```dart
void setupTestDatabase() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}

Future<void> cleanDatabase() async {
  await DatabaseHelper.instance.close();
  await DatabaseHelper.instance.database; // Ricreare pulita
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

**Documentazione ufficiale:** https://docs.flutter.dev/testing

---

## 10. Strumenti di Sviluppo

### flutter_launcher_icons ^0.14.4

**Versione utilizzata:** `^0.14.4` (dev_dependencies)

**Scopo:**
Pacchetto che genera automaticamente icone applicazione in tutte le dimensioni e formati richiesti da Android e iOS da un'unica immagine sorgente.

**Configurazione in MedicApp:**

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

**Icone generate:**

**Android:**
- `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` (72x72)
- `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` (48x48)
- `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png` (96x96)
- `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` (144x144)
- `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` (192x192)
- Icone adattive per Android 8+ (foreground + background separati)

**iOS:**
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/` (20x20 fino a 1024x1024, 15+ varianti)

**Comando di generazione:**

```bash
flutter pub run flutter_launcher_icons
```

**Perché questo strumento:**

- **Automazione:** Generare manualmente 20+ file di icone sarebbe tedioso e soggetto a errori.
- **Icone adattive (Android 8+):** Supporta la funzionalità delle icone adattive che si adattano a diverse forme secondo il launcher.
- **Ottimizzazione:** Le icone vengono generate in formato PNG ottimizzato.
- **Coerenza:** Garantisce che tutte le dimensioni vengano generate dalla stessa sorgente.

**Documentazione ufficiale:** https://pub.dev/packages/flutter_launcher_icons

---

### flutter_native_splash ^2.4.7

**Versione utilizzata:** `^2.4.7` (dev_dependencies)

**Scopo:**
Pacchetto che genera splash screen nativi (schermate di caricamento iniziali) per Android e iOS, mostrandosi istantaneamente mentre Flutter inizializza.

**Configurazione in MedicApp:**

**`pubspec.yaml`:**
```yaml
flutter_native_splash:
  color: "#419e69"  # Colore di sfondo (verde MedicApp)
  image: assets/images/icon.png  # Immagine centrale
  android: true
  ios: true
  fullscreen: true
  android_12:
    image: assets/images/icon.png
    color: "#419e69"
```

**Caratteristiche implementate:**

1. **Splash unificato:** Stesso aspetto su Android e iOS.
2. **Colore del marchio:** Verde `#419e69` (colore primario di MedicApp).
3. **Logo centrato:** Icona di MedicApp al centro dello schermo.
4. **Schermo intero:** Nasconde barra di stato durante splash.
5. **Android 12+ specifico:** Configurazione speciale per conformarsi al nuovo sistema di splash di Android 12.

**File generati:**

**Android:**
- `android/app/src/main/res/drawable/launch_background.xml`
- `android/app/src/main/res/values/styles.xml` (tema splash)
- `android/app/src/main/res/values-night/styles.xml` (tema scuro)

**iOS:**
- `ios/Runner/Assets.xcassets/LaunchImage.imageset/`
- `ios/Runner/Base.lproj/LaunchScreen.storyboard`

**Comando di generazione:**

```bash
flutter pub run flutter_native_splash:create
```

**Perché splash nativo:**

- **UX professionale:** Evita schermata bianca durante 1-2 secondi di inizializzazione di Flutter.
- **Branding immediato:** Mostra logo e colori del marchio dal primo frame.
- **Percezione di velocità:** Splash con branding si percepisce più veloce di schermata bianca.

**Documentazione ufficiale:** https://pub.dev/packages/flutter_native_splash

---

### uuid ^4.0.0

**Versione utilizzata:** `^4.0.0`

**Scopo:**
Generatore di UUID (Universally Unique Identifier) v4 per creare identificatori unici di farmaci, persone e registrazioni dosi.

**Uso in MedicApp:**

```dart
import 'package:uuid/uuid.dart';

const uuid = Uuid();

final medication = Medication(
  id: uuid.v4(), // Genera: "f47ac10b-58cc-4372-a567-0e02b2c3d479"
  name: 'Ibuprofene',
  type: MedicationType.pill,
);
```

**Perché UUID:**

- **Unicità globale:** Probabilità di collisione: 1 su 10³⁸ (praticamente impossibile).
- **Generazione offline:** Non richiede coordinazione con server o sequenze di database.
- **Sincronizzazione futura:** Se MedicApp aggiunge sincronizzazione cloud, gli UUID evitano conflitti di ID.
- **Debugging:** ID descrittivi nei log invece di interi generici (1, 2, 3).

**Alternativa considerata:**

- **Auto-increment intero:** Scartato perché richiederebbe gestione di sequenze in SQLite e potrebbe causare conflitti in futura sincronizzazione.

**Documentazione ufficiale:** https://pub.dev/packages/uuid

---

## 11. Dipendenze di Piattaforma

### Android

**Configurazione di build:**

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
        isCoreLibraryDesugaringEnabled = true  // Per API moderne su Android < 26
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```

**Strumenti:**

- **Gradle 8.0+:** Sistema di build di Android.
- **Kotlin 1.9.0:** Linguaggio per codice nativo Android (anche se MedicApp non usa codice Kotlin personalizzato).
- **AndroidX:** Librerie di supporto moderne (sostituto di Support Library).

**Versioni minime:**

- **minSdk 21 (Android 5.0 Lollipop):** Copertura del 99%+ dei dispositivi Android attivi.
- **targetSdk 34 (Android 14):** Ultima versione di Android per sfruttare caratteristiche moderne.

**Permessi richiesti:**

**`android/app/src/main/AndroidManifest.xml`:**
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" /> <!-- Android 13+ -->
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" /> <!-- Notifiche esatte -->
<uses-permission android:name="android.permission.USE_EXACT_ALARM" /> <!-- Android 14+ -->
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" /> <!-- Riprogrammare notifiche dopo riavvio -->
```

**Documentazione ufficiale:** https://developer.android.com

---

### iOS

**Configurazione di build:**

**`ios/Runner/Info.plist`:**
```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>

<key>NSUserNotificationsUsageDescription</key>
<string>MedicApp ha bisogno di inviare notifiche per ricordarti di prendere i tuoi farmaci.</string>
```

**Strumenti:**

- **CocoaPods 1.11+:** Gestore dipendenze native iOS.
- **Xcode 14+:** IDE richiesto per compilare app iOS.
- **Swift 5.0:** Linguaggio per codice nativo iOS (anche se MedicApp usa AppDelegate predefinito).

**Versioni minime:**

- **iOS 12.0+:** Copertura del 98%+ dei dispositivi iOS attivi.
- **iPadOS 12.0+:** Supporto completo per iPad.

**Capacità richieste:**

- **Push Notifications:** Anche se MedicApp usa notifiche locali, questa capacità abilita il framework delle notifiche.
- **Background Fetch:** Permette di aggiornare notifiche quando l'app è in background.

**Documentazione ufficiale:** https://developer.apple.com/documentation/

---

## 12. Versioni e Compatibilità

### Tabella Dipendenze

| Dipendenza | Versione | Scopo | Categoria |
|-------------|---------|-----------|-----------|
| **Flutter SDK** | `3.9.2+` | Framework principale | Core |
| **Dart SDK** | `3.9.2+` | Linguaggio di programmazione | Core |
| **cupertino_icons** | `^1.0.8` | Icone iOS | UI |
| **sqflite** | `^2.3.0` | Database SQLite | Persistenza |
| **path** | `^1.8.3` | Manipolazione percorsi | Utilità |
| **flutter_local_notifications** | `^19.5.0` | Notifiche locali | Notifiche |
| **timezone** | `^0.10.1` | Fusi orari | Notifiche |
| **intl** | `^0.20.2` | Internazionalizzazione | i18n |
| **android_intent_plus** | `^6.0.0` | Intenzioni Android | Permessi |
| **shared_preferences** | `^2.2.2` | Preferenze utente | Persistenza |
| **file_picker** | `^8.0.0+1` | Selettore file | File |
| **share_plus** | `^10.1.4` | Condivisione file | File |
| **path_provider** | `^2.1.5` | Directory di sistema | Persistenza |
| **uuid** | `^4.0.0` | Generatore UUID | Utilità |
| **logger** | `^2.0.0` | Sistema di logging professionale | Logging |
| **sqflite_common_ffi** | `^2.3.0` | Testing SQLite | Testing (dev) |
| **flutter_launcher_icons** | `^0.14.4` | Generazione icone | Strumento (dev) |
| **flutter_native_splash** | `^2.4.7` | Splash screen | Strumento (dev) |
| **flutter_lints** | `^6.0.0` | Analisi statica | Strumento (dev) |

**Totale dipendenze di produzione:** 15
**Totale dipendenze di sviluppo:** 4
**Totale:** 19

---

### Compatibilità Piattaforme

| Piattaforma | Versione minima | Versione obiettivo | Copertura |
|------------|----------------|------------------|-----------|
| **Android** | 5.0 (API 21) | 14 (API 34) | 99%+ dispositivi |
| **iOS** | 12.0 | 17.0 | 98%+ dispositivi |
| **iPadOS** | 12.0 | 17.0 | 98%+ dispositivi |

**Non supportato:** Web, Windows, macOS, Linux (MedicApp è esclusivamente mobile per design).

---

### Compatibilità Flutter

| Flutter | Compatibile | Note |
|---------|------------|-------|
| 3.9.2 - 3.10.x | ✅ | Versione di sviluppo |
| 3.11.x - 3.19.x | ✅ | Compatibile senza modifiche |
| 3.20.x - 3.35.x | ✅ | Testato fino a 3.35.7 |
| 3.36.x+ | ⚠️ | Probabilmente compatibile, non testato |
| 4.0.x | ❌ | Richiede aggiornamento dipendenze |

---

## 13. Confronti e Decisioni

### 12.1. Database: SQLite vs Hive vs Isar vs Drift

**Decisione:** SQLite (sqflite)

**Giustificazione estesa:**

**Requisiti di MedicApp:**

1. **Relazioni N:M (Molti a Molti):** Un farmaco può essere assegnato a persone multiple, e una persona può avere farmaci multipli. Questa architettura è nativa in SQL ma complessa in NoSQL.

2. **Query complesse:** Ottenere tutti i farmaci di una persona con le sue configurazioni personalizzate richiede JOIN tra 3 tabelle:

```sql
SELECT m.*, pm.custom_times, pm.custom_doses
FROM medications m
JOIN person_medications pm ON m.id = pm.medication_id
JOIN persons p ON pm.person_id = p.id
WHERE p.id = ?
```

Questo è banale in SQL ma richiederebbe query multiple e logica manuale in NoSQL.

3. **Migrazioni complesse:** MedicApp si è evoluto da V1 (tabella semplice di farmaci) fino a V19+ (multi-persona con relazioni). SQLite permette migrazioni SQL incrementali che preservano dati:

```sql
-- Migrazione V18 -> V19: Aggiungere multi-persona
ALTER TABLE medications ADD COLUMN shared_stock REAL;
CREATE TABLE persons (...);
CREATE TABLE person_medications (...);
INSERT INTO persons (id, name, is_default) VALUES (?, 'Io', 1);
INSERT INTO person_medications SELECT ?, id, times, doses FROM medications;
```

**Hive:**

- ✅ **Pro:** Prestazioni eccellenti, API semplice, dimensione compatta.
- ❌ **Contro:**
  - **Senza relazioni native:** Implementare N:M richiede mantenere liste di ID manualmente e fare query multiple.
  - **Senza transazioni ACID complete:** Non può garantire atomicità in operazioni complesse (registrazione dose + decremento stock + notifica).
  - **Migrazioni manuali:** Non c'è sistema di versioning schema, richiede logica personalizzata.
  - **Debugging difficile:** Formato binario proprietario, non si può ispezionare con strumenti standard.

**Isar:**

- ✅ **Pro:** Prestazioni superiori, indicizzazione veloce, sintassi Dart elegante.
- ❌ **Contro:**
  - **Immaturità:** Lanciato nel 2022, meno battle-tested di SQLite (20+ anni).
  - **Relazioni limitate:** Supporta relazioni ma non così flessibili come SQL JOIN (limitato a 1:1, 1:N, senza M:N diretto).
  - **Formato proprietario:** Simile a Hive, rende difficile debugging con strumenti esterni.
  - **Lock-in:** Migrare da Isar a un'altra soluzione sarebbe costoso.

**Drift:**

- ✅ **Pro:** SQL type-safe, migrazioni automatiche, API generate.
- ❌ **Contro:**
  - **Complessità:** Richiede generazione di codice, file `.drift`, e configurazione complessa di build_runner.
  - **Boilerplate:** Persino operazioni semplici richiedono definire tabelle in file separati.
  - **Dimensione:** Aumenta la dimensione dell'APK di ~200KB vs sqflite diretto.
  - **Flessibilità ridotta:** Query complesse ad-hoc sono più difficili che in SQL diretto.

**Risultato finale:**

Per MedicApp, dove le relazioni N:M sono fondamentali, le migrazioni sono state frequenti (19 versioni schema), e la capacità di debugging con DB Browser per SQLite è stata preziosa durante lo sviluppo, SQLite è la scelta corretta.

**Compromesso accettato:**
Sacrifichiamo ~10-15% di prestazioni in operazioni massive (irrilevante per casi d'uso di MedicApp) in cambio di flessibilità SQL completa, strumenti maturi e architettura dati robusta.

---

### 12.2. Notifiche: flutter_local_notifications vs awesome_notifications vs Firebase

**Decisione:** flutter_local_notifications

**Giustificazione estesa:**

**Requisiti di MedicApp:**

1. **Precisione temporale:** Le notifiche devono arrivare esattamente all'ora programmata (08:00:00, non 08:00:30).
2. **Funzionamento offline:** I farmaci si prendono indipendentemente dalla connessione internet.
3. **Privacy:** I dati medici non devono mai uscire dal dispositivo.
4. **Scheduling a lungo termine:** Notifiche programmate per mesi futuri.

**flutter_local_notifications:**

- ✅ **Scheduling preciso:** `zonedSchedule` con `androidScheduleMode: exactAllowWhileIdle` garantisce consegna esatta anche con Doze Mode.
- ✅ **Totalmente offline:** Le notifiche si programmano localmente, senza dipendenza da server.
- ✅ **Privacy totale:** Nessun dato esce dal dispositivo.
- ✅ **Maturità:** 5+ anni, 3000+ stelle, usato in produzione da migliaia di app mediche.
- ✅ **Documentazione:** Esempi esaustivi per tutti i casi d'uso.

**awesome_notifications:**

- ✅ **Pro:** UI notifiche più personalizzabile, animazioni, pulsanti con icone.
- ❌ **Contro:**
  - **Meno maturo:** 2+ anni vs 5+ di flutter_local_notifications.
  - **Problemi segnalati:** Issue con notifiche programmate su Android 12+ (conflitti WorkManager).
  - **Complessità non necessaria:** MedicApp non richiede notifiche super personalizzate.
  - **Minore adozione:** ~1500 stelle vs 3000+ di flutter_local_notifications.

**Firebase Cloud Messaging (FCM):**

- ✅ **Pro:** Notifiche illimitate, analytics, segmentazione utenti.
- ❌ **Contro:**
  - **Richiede server:** Necessiterebbe backend per inviare notifiche, aumentando complessità e costo.
  - **Richiede connessione:** Le notifiche non arrivano se il dispositivo è offline.
  - **Privacy:** Dati (orari medicazione, nomi farmaci) verrebbero inviati a Firebase.
  - **Latenza:** Dipende dalla rete, non garantisce consegna esatta all'ora programmata.
  - **Scheduling limitato:** FCM non supporta scheduling preciso, solo consegna "approssimata" con delay.
  - **Complessità:** Richiede configurare progetto Firebase, implementare server, gestire token.

**Architettura corretta per applicazioni mediche locali:**

Per app come MedicApp (gestione personale, senza collaborazione multi-utente, senza backend), le notifiche locali sono architetturalmente superiori alle notifiche remote:

- **Affidabilità:** Non dipendono da connessione internet o disponibilità server.
- **Privacy:** GDPR e regolamenti medici compliant per design (dati non escono mai dal dispositivo).
- **Semplicità:** Zero configurazione backend, zero costi server.
- **Precisione:** Garanzia di consegna esatta al secondo.

**Risultato finale:**

`flutter_local_notifications` è la scelta ovvia e corretta per MedicApp. awesome_notifications sarebbe sovra-ingegnerizzazione per UI che non necessitiamo, e FCM sarebbe architetturalmente scorretto per un'applicazione completamente locale.

---

### 12.3. Gestione Stato: Vanilla Flutter vs Provider vs BLoC vs Riverpod

**Decisione:** Vanilla Flutter (senza libreria di gestione stato)

**Giustificazione estesa:**

**Architettura di MedicApp:**

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

In MedicApp, **il database È lo stato**. Non c'è stato significativo in memoria che necessiti essere condiviso tra widget.

**Pattern tipico di schermata:**

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

**Perché Provider sarebbe non necessario:**

Provider è progettato per **condividere stato tra widget distanti nell'albero**. Esempio classico:

```dart
// Con Provider (non necessario in MedicApp)
ChangeNotifierProvider(
  create: (_) => MedicationProvider(),
  child: MaterialApp(
    home: HomeScreen(),
  ),
)

// HomeScreen può accedere a MedicationProvider
Provider.of<MedicationProvider>(context).medications

// DetailScreen può anche accedere a MedicationProvider
Provider.of<MedicationProvider>(context).addDose(...)
```

**Problema:** In MedicApp, le schermate NON necessitano condividere stato in memoria. Ogni schermata interroga il database direttamente:

```dart
// Schermata 1: Lista farmaci
final medications = await db.getMedications();

// Schermata 2: Dettaglio farmaco
final medication = await db.getMedication(id);

// Schermata 3: Cronologia dosi
final history = await db.getDoseHistory(medicationId);
```

Tutte ottengono dati direttamente da SQLite, che è l'unica fonte di verità. Non c'è necessità di `ChangeNotifier`, `MultiProvider`, né propagazione di stato.

**Perché BLoC sarebbe sovra-ingegnerizzazione:**

BLoC (Business Logic Component) è progettato per applicazioni aziendali con **logica business complessa** che deve essere **separata dall'UI** e **testata indipendentemente**.

Esempio di architettura BLoC:

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
  // ... più eventi
}

// medication_event.dart (eventi separati)
// medication_state.dart (stati separati)
// medication_repository.dart (layer dati)
```

**Problema:** Questo aggiunge **4-5 file** per feature e centinaia di linee di boilerplate per implementare ciò che in Vanilla Flutter è:

```dart
final medications = await DatabaseHelper.instance.getMedications();
setState(() {
  _medications = medications;
});
```

**Per MedicApp:**

- **Logica business semplice:** Calcoli di stock (sottrazione), calcoli di date (confronto), formattazione stringhe.
- **Senza regole business complesse:** Non ci sono validazioni carte di credito, calcoli finanziari, autenticazione OAuth, ecc.
- **Testing diretto:** I servizi (DatabaseHelper, NotificationService) si testano direttamente senza necessità di mock BLoC.

**Perché Riverpod sarebbe non necessario:**

Riverpod è un'evoluzione di Provider che risolve alcuni problemi (compile-time safety, non dipende da BuildContext), ma rimane non necessario per MedicApp per le stesse ragioni di Provider.

**Casi dove SI necessiterebbe gestione stato:**

1. **Applicazione con autenticazione:** Stato utente/sessione condiviso tra tutte le schermate.
2. **Carrello acquisti:** Stato di articoli selezionati condiviso tra prodotti, carrello, checkout.
3. **Chat in tempo reale:** Messaggi in arrivo che devono aggiornare schermate multiple simultaneamente.
4. **Applicazione collaborativa:** Utenti multipli che modificano lo stesso documento in tempo reale.

**MedicApp NON ha nessuno di questi casi.**

**Risultato finale:**

Per MedicApp, `StatefulWidget + setState + Database as Source of Truth` è l'architettura corretta. È semplice, diretta, facile da capire per qualsiasi sviluppatore Flutter, e non introduce complessità non necessaria.

Aggiungere Provider, BLoC o Riverpod sarebbe puramente **cargo cult programming** (usare tecnologia perché è popolare, non perché risolve un problema reale).

---

## Conclusione

MedicApp utilizza uno stack tecnologico **semplice, robusto e appropriato** per un'applicazione medica locale multipiattaforma:

- **Flutter + Dart:** Multipiattaforma con prestazioni native.
- **SQLite:** Database relazionale maturo con transazioni ACID.
- **Notifiche locali:** Privacy totale e funzionamento offline.
- **Localizzazione ARB:** 8 lingue con pluralizzazione Unicode CLDR.
- **Vanilla Flutter:** Senza gestione stato non necessaria.
- **Logger package:** Sistema di logging professionale con 6 livelli e filtaggio intelligente.
- **432+ test:** Copertura del 75-80% con test unitari, widget e integrazione.

Ogni decisione tecnologica è **giustificata da requisiti reali**, non da hype o tendenze. Il risultato è un'applicazione manutenibile, affidabile e che fa esattamente ciò che promette senza complessità artificiale.

**Principio guida:** *"Semplicità quando possibile, complessità quando necessario."*
