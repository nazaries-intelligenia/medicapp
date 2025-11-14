# Technologie-Stack von MedicApp

Dieses Dokument beschreibt alle Technologien, Frameworks, Bibliotheken und Tools, die in MedicApp verwendet werden, einschließlich exakter Versionen, Begründungen für die Auswahl, betrachteter Alternativen und Trade-offs jeder technologischen Entscheidung.

---

## 1. Kerntechnologien

### Flutter 3.9.2+

**Verwendete Version:** `3.9.2+` (SDK kompatibel bis `3.35.7+`)

**Zweck:**
Flutter ist das plattformübergreifende Framework, das die Basis von MedicApp bildet. Es ermöglicht die Entwicklung einer nativen Anwendung für Android und iOS aus einer einzigen Dart-Codebasis und garantiert nahezu native Leistung und konsistente Benutzererfahrung auf beiden Plattformen.

**Warum Flutter gewählt wurde:**

1. **Effiziente plattformübergreifende Entwicklung:** Eine einzige Codebasis für Android und iOS reduziert Entwicklungs- und Wartungskosten um 60-70% im Vergleich zur dualen nativen Entwicklung.

2. **Native Leistung:** Flutter kompiliert zu nativem ARM-Code, verwendet keine JavaScript-Brücken wie React Native, was zu flüssigen Animationen bei 60/120 FPS und sofortigen Reaktionszeiten für kritische Operationen wie Dosisregistrierung führt.

3. **Hot Reload:** Ermöglicht schnelle Iteration während der Entwicklung, Änderungen werden in weniger als 1 Sekunde sichtbar ohne Verlust des Anwendungszustands. Essentiell für die Anpassung von Benachrichtigungs-UI und mehrstufigen Abläufen.

4. **Natives Material Design 3:** Vollständige und aktuelle Implementierung von Material Design 3 im SDK enthalten, ohne Drittanbieter-Bibliotheken.

5. **Ausgereiftes Ökosystem:** Pub.dev hat über 40.000 Pakete, einschließlich robuster Lösungen für lokale Benachrichtigungen, SQLite-Datenbank und Dateiverwaltung.

6. **Integriertes Testing:** Vollständiges Test-Framework im SDK enthalten, mit Unterstützung für Unit-Tests, Widget-Tests und Integration-Tests. MedicApp erreicht 432+ Tests mit 75-80% Abdeckung.

**Betrachtete Alternativen:**

- **React Native:** Verworfen wegen schlechterer Leistung bei langen Listen (Dosishistorie), Problemen mit lokalen Hintergrund-Benachrichtigungen und inkonsistenter Erfahrung zwischen Plattformen.
- **Kotlin Multiplatform Mobile (KMM):** Verworfen wegen unreifem Ökosystem, Notwendigkeit plattformspezifischen UI-Codes und steilerer Lernkurve.
- **Native (Swift + Kotlin):** Verworfen wegen Verdopplung des Entwicklungsaufwands, höheren Wartungskosten und Bedarf an zwei spezialisierten Teams.

**Offizielle Dokumentation:** https://flutter.dev

---

### Dart 3.0+

**Verwendete Version:** `3.9.2+` (kompatibel mit Flutter 3.9.2+)

**Zweck:**
Dart ist die objektorientierte Programmiersprache von Google, die Flutter ausführt. Bietet moderne Syntax, starke Typisierung, Null-Safety und optimierte Leistung.

**In MedicApp verwendete Funktionen:**

1. **Null Safety:** Typsystem, das Nullreferenzfehler zur Kompilierzeit eliminiert. Kritisch für die Zuverlässigkeit eines medizinischen Systems, wo eine NullPointerException die Registrierung einer lebenswichtigen Dosis verhindern könnte.

2. **Async/Await:** Elegante asynchrone Programmierung für Datenbankoperationen, Benachrichtigungen und Dateioperationen ohne UI-Blockierung.

3. **Extension Methods:** Ermöglicht das Erweitern vorhandener Klassen mit benutzerdefinierten Methoden, verwendet für Datumsformatierung und Modellvalidierungen.

4. **Records und Pattern Matching (Dart 3.0+):** Unveränderliche Datenstrukturen zum sicheren Zurückgeben mehrerer Werte aus Funktionen.

5. **Starkes Typsystem:** Statische Typisierung, die Fehler zur Kompilierzeit erkennt, essentiell für kritische Operationen wie Bestandsberechnung und Benachrichtigungsplanung.

**Warum Dart:**

- **Für UI optimiert:** Dart wurde speziell für UI-Entwicklung entworfen, mit optimierter Garbage Collection zur Vermeidung von Pausen während Animationen.
- **AOT und JIT:** Ahead-of-Time-Kompilierung für Produktion (native Leistung) und Just-in-Time für Entwicklung (Hot Reload).
- **Vertraute Syntax:** Ähnlich wie Java, C#, JavaScript, reduziert Lernkurve.
- **Sound Null Safety:** Garantie zur Kompilierzeit, dass nicht-nullable Variablen niemals null sein werden.

**Offizielle Dokumentation:** https://dart.dev

---

### Material Design 3

**Version:** Native Implementierung in Flutter 3.9.2+

**Zweck:**
Material Design 3 (Material You) ist Googles Designsystem, das Komponenten, Muster und Richtlinien zur Erstellung moderner, zugänglicher und konsistenter Oberflächen bereitstellt.

**Implementierung in MedicApp:**

```dart
useMaterial3: true
```

**Verwendete Komponenten:**

1. **Dynamisches Farbschema:** Farbs auf Seed-Basis (`seedColor: Color(0xFF006B5A)` für helles Theme, `Color(0xFF00A894)` für dunkles Theme), das automatisch 30+ harmonische Schattierungen generiert.

2. **FilledButton, OutlinedButton, TextButton:** Buttons mit visuellen Zuständen (Hover, Pressed, Disabled) und erhöhten Größen (52dp Mindesthöhe) für Zugänglichkeit.

3. **Card mit adaptiver Elevation:** Karten mit abgerundeten Ecken (16dp) und subtilen Schatten für visuelle Hierarchie.

4. **NavigationBar:** Untere Navigationsleiste mit animierten Auswahlindikatoren und Unterstützung für Navigation zwischen 3-5 Hauptzielen.

5. **Erweiterter FloatingActionButton:** FAB mit beschreibendem Text für Hauptaktion (Medikament hinzufügen).

6. **ModalBottomSheet:** Modale Blätter für kontextuelle Aktionen wie schnelle Dosisregistrierung.

7. **SnackBar mit Aktionen:** Temporäres Feedback für abgeschlossene Operationen (Dosis registriert, Medikament hinzugefügt).

**Benutzerdefinierte Themes:**

MedicApp implementiert zwei vollständige Themes (hell und dunkel) mit zugänglicher Typografie:

- **Vergrößerte Schriftgrößen:** `titleLarge: 26sp`, `bodyLarge: 19sp` (höher als Standard 22sp und 16sp).
- **Verbesserter Kontrast:** Textfarben mit 87% Deckkraft auf Hintergründen zur Einhaltung von WCAG AA.
- **Große Buttons:** Mindesthöhe von 52dp (vs. Standard 40dp) zur Erleichterung der Berührung auf Mobilgeräten.

**Warum Material Design 3:**

- **Integrierte Zugänglichkeit:** Komponenten mit Screen-Reader-Unterstützung, minimalen Berührungsgrößen und WCAG-Kontrastverhältnissen.
- **Konsistenz mit Android-Ökosystem:** Vertrautes Aussehen für Android 12+ Benutzer.
- **Flexible Anpassung:** Design-Token-System ermöglicht Anpassung von Farben, Typografien und Formen unter Beibehaltung der Konsistenz.
- **Automatischer Dunkelmodus:** Native Unterstützung für dunkles Theme basierend auf Systemkonfiguration.

**Offizielle Dokumentation:** https://m3.material.io

---

## 2. Datenbank und Persistenz

### sqflite ^2.3.0

**Verwendete Version:** `^2.3.0` (kompatibel mit `2.3.0` bis `< 3.0.0`)

**Zweck:**
sqflite ist das SQLite-Plugin für Flutter, das Zugriff auf eine lokale, relationale und transaktionale SQL-Datenbank bietet. MedicApp verwendet SQLite als Hauptspeicher für alle Medikamenten-, Personen-, Schematakonfigurations- und Dosishistoriendaten.

**MedicApp-Datenbankarchitektur:**

```
medicapp.db
├── medications (Haupttabelle)
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
├── person_medications (N:M Beziehungstabelle)
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

**Kritische Operationen:**

1. **ACID-Transaktionen:** Atomaritätsgarantie für komplexe Operationen wie Dosisregistrierung + Bestandsabzug + Benachrichtigungsplanung.

2. **Relationale Abfragen:** JOINs zwischen `medications`, `persons` und `person_medications` zum Abrufen personalisierter Konfigurationen nach Benutzer.

3. **Optimierte Indizes:** Indizes auf `person_id` und `medication_id` in Beziehungstabellen für schnelle O(log n) Abfragen.

4. **Versionierte Migrationen:** Schema-Migrationssystem von V1 bis V19+ mit Datenerhaltung.

**Warum SQLite:**

1. **ACID-Konformität:** Transaktionsgarantien kritisch für medizinische Daten, wo Integrität fundamental ist.

2. **Komplexe SQL-Abfragen:** Fähigkeit, JOINs, Aggregationen und Unterabfragen für erweiterte Berichte und Filter durchzuführen.

3. **Bewährte Leistung:** SQLite ist die am weitesten verbreitete Datenbank der Welt, mit 20+ Jahren Optimierungen.

4. **Zero-Configuration:** Erfordert keinen Server, Konfiguration oder Verwaltung. Die Datenbank ist eine einzige portable Datei.

5. **Einfacher Export/Import:** Die `.db`-Datei kann direkt für Backups oder Übertragungen zwischen Geräten kopiert werden.

6. **Unbegrenzte Größe:** SQLite unterstützt Datenbanken bis zu 281 Terabyte, mehr als genug für Jahrzehnte Dosishistorie.

**Vergleich mit Alternativen:**

| Merkmal | SQLite (sqflite) | Hive | Isar | Drift |
|---------|------------------|------|------|-------|
| **Datenmodell** | Relational SQL | NoSQL Key-Value | NoSQL Dokument | Relational SQL |
| **Abfragesprache** | Standard-SQL | Dart-API | Dart Query Builder | SQL + Dart |
| **ACID-Transaktionen** | ✅ Vollständig | ❌ Begrenzt | ✅ Ja | ✅ Ja |
| **Migrationen** | ✅ Robustes Manuell | ⚠️ Basis-Manuell | ⚠️ Halbautomatisch | ✅ Automatisch |
| **Leseleistung** | ⚡ Ausgezeichnet | ⚡⚡ Überlegen | ⚡⚡ Überlegen | ⚡ Ausgezeichnet |
| **Schreibleistung** | ⚡ Sehr gut | ⚡⚡ Ausgezeichnet | ⚡⚡ Ausgezeichnet | ⚡ Sehr gut |
| **Festplattengröße** | ⚠️ Größer | ✅ Kompakt | ✅ Sehr kompakt | ⚠️ Größer |
| **N:M-Beziehungen** | ✅ Nativ | ❌ Manuell | ⚠️ Referenzen | ✅ Nativ |
| **Reife** | ✅ 20+ Jahre | ⚠️ 4 Jahre | ⚠️ 3 Jahre | ✅ 5+ Jahre |
| **Portabilität** | ✅ Universal | ⚠️ Proprietär | ⚠️ Proprietär | ⚠️ Nur-Flutter |
| **Externe Tools** | ✅ DB Browser, CLI | ❌ Begrenzt | ❌ Begrenzt | ❌ Keine |

**Begründung von SQLite gegenüber Alternativen:**

- **Hive:** Verworfen wegen fehlender robuster Unterstützung für N:M-Beziehungen (Multi-Personen-Architektur), Fehlen vollständiger ACID-Transaktionen und Schwierigkeit komplexer Abfragen mit JOINs.

- **Isar:** Trotz ausgezeichneter Leistung verworfen wegen Unreife (2022 veröffentlicht), proprietärem Format, das Debugging mit Standard-Tools erschwert, und Einschränkungen bei komplexen relationalen Abfragen.

- **Drift:** Ernsthaft erwogen aber verworfen wegen größerer Komplexität (erfordert Code-Generierung), größerer resultierender Anwendungsgröße und geringerer Flexibilität bei Migrationen im Vergleich zu direktem SQL.

**SQLite-Trade-offs:**

- ✅ **Vorteile:** Bewährte Stabilität, Standard-SQL, externe Tools, native Beziehungen, triviales Exportieren.
- ❌ **Nachteile:** Leicht schlechtere Leistung als Hive/Isar bei massiven Operationen, größere Dateigröße, manuelles SQL-Boilerplate.

**Entscheidung:** Für MedicApp rechtfertigt die Notwendigkeit robuster N:M-Beziehungen, komplexer Migrationen von V1 bis V19+ und der Fähigkeit zum Debugging mit Standard-SQL-Tools vollständig die Verwendung von SQLite über schnellere aber weniger reife NoSQL-Alternativen.

**Offizielle Dokumentation:** https://pub.dev/packages/sqflite

---

### sqflite_common_ffi ^2.3.0

**Verwendete Version:** `^2.3.0` (dev_dependencies)

**Zweck:**
FFI (Foreign Function Interface) Implementierung von sqflite, die das Ausführen von Datenbanktests in Desktop/VM-Umgebungen ohne Android/iOS-Emulatoren ermöglicht.

**Verwendung in MedicApp:**

```dart
// test/helpers/database_test_helper.dart
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void setupTestDatabase() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}
```

**Warum notwendig:**

- **60x schnellere Tests:** Datenbanktests laufen in lokaler VM statt Android-Emulatoren, reduziert Zeit von 120s auf 2s für vollständige Suite.
- **CI/CD ohne Emulatoren:** GitHub Actions kann Tests ohne Emulator-Setup ausführen, vereinfacht Pipelines.
- **Verbessertes Debugging:** Test-`.db`-Dateien sind direkt vom Host-Dateisystem zugänglich.

**Offizielle Dokumentation:** https://pub.dev/packages/sqflite_common_ffi

---

### path ^1.8.3

**Verwendete Version:** `^1.8.3`

**Zweck:**
Plattformübergreifende Dateipfad-Manipulationsbibliothek, die Unterschiede zwischen Dateisystemen abstrahiert (Windows: `\`, Unix: `/`).

**Verwendung in MedicApp:**

```dart
import 'package:path/path.dart' as path;

final dbPath = path.join(await getDatabasesPath(), 'medicapp.db');
```

**Offizielle Dokumentation:** https://pub.dev/packages/path

---

### path_provider ^2.1.5

**Verwendete Version:** `^2.1.5`

**Zweck:**
Plugin, das plattformübergreifenden Zugriff auf betriebssystemspezifische Verzeichnisse bietet (Dokumente, Cache, Anwendungsunterstützung).

**Verwendung in MedicApp:**

```dart
import 'package:path_provider/path_provider.dart';

// Datenbankverzeichnis abrufen
final dbDirectory = await getDatabasesPath(); // Android: /data/data/com.medicapp/databases/

// Verzeichnis für Exporte abrufen
final documentsDirectory = await getApplicationDocumentsDirectory();
```

**Verwendete Verzeichnisse:**

1. **getDatabasesPath():** Für Haupt-`medicapp.db`-Datei.
2. **getApplicationDocumentsDirectory():** Für Datenbankexporte, die Benutzer teilen können.
3. **getTemporaryDirectory():** Für temporäre Dateien während Import.

**Offizielle Dokumentation:** https://pub.dev/packages/path_provider

---

## 3. Benachrichtigungen

### flutter_local_notifications ^19.5.0

**Verwendete Version:** `^19.5.0`

**Zweck:**
Vollständiges System lokaler Benachrichtigungen (erfordert keinen Server) für Flutter, mit Unterstützung für geplante, wiederkehrende, aktionsbasierte und plattformspezifisch angepasste Benachrichtigungen.

**Implementierung in MedicApp:**

MedicApp verwendet ein ausgeklügeltes Benachrichtigungssystem, das drei Benachrichtigungstypen verwaltet:

1. **Dosis-Erinnerungsbenachrichtigungen:**
   - Geplant mit vom Benutzer konfigurierten exakten Zeiten.
   - Enthalten Titel mit Personenname (bei Multi-Person) und Dosisdetails.
   - Unterstützung für Schnellaktionen: "Einnehmen", "Verschieben", "Auslassen" (verworfen in V20+ wegen Typeinschränkungen).
   - Benutzerdefinierter Ton und hochpriorisierter Kanal auf Android.

2. **Vorzeitige Dosis-Benachrichtigungen:**
   - Erkennen wenn Dosis vor geplantem Zeitplan eingenommen wird.
   - Aktualisieren automatisch nächste Benachrichtigung falls zutreffend.
   - Stornieren obsolete Benachrichtigungen der vorzeitigen Zeit.

3. **Fasten-End-Benachrichtigungen:**
   - Ongoing (permanente) Benachrichtigung während Fastenzeit mit Countdown.
   - Wird automatisch storniert wenn Fasten endet oder manuell geschlossen wird.
   - Enthält visuellen Fortschritt (Android) und Endzeit.

**Plattformspezifische Konfiguration:**

**Android:**
```dart
AndroidInitializationSettings('app_icon')
AndroidNotificationDetails(
  'medication_reminders',
  'Medikamentenerinnerungen',
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

**Verwendete erweiterte Funktionen:**

1. **Präzises Scheduling:** Benachrichtigungen geplant mit sekundengenauer Präzision unter Verwendung von `timezone`.
2. **Benachrichtigungskanäle (Android 8+):** 3 separate Kanäle für Erinnerungen, Fasten und System.
3. **Benutzerdefiniertes Payload:** JSON-Daten im Payload zur Identifizierung von Medikament und Person.
4. **Interaktions-Callbacks:** Callbacks wenn Benutzer Benachrichtigung antippt.
5. **Berechtigungsverwaltung:** Anforderung und Überprüfung von Berechtigungen auf Android 13+ (Tiramisu).

**Limits und Optimierungen:**

- **Limit von 500 gleichzeitig geplanten Benachrichtigungen** (Android-Systembeschränkung).
- MedicApp verwaltet automatische Priorisierung bei Überschreitung dieses Limits:
  - Priorisiert nächste 7 Tage.
  - Verwirft Benachrichtigungen inaktiver Medikamente.
  - Reorganisiert beim Hinzufügen/Entfernen von Medikamenten.

**Warum flutter_local_notifications:**

1. **Lokale vs. Remote-Benachrichtigungen:** MedicApp benötigt kein Backend, daher sind lokale Benachrichtigungen die richtige Architektur.

2. **Vollständige Funktionalität:** Unterstützung für Scheduling, Wiederholung, Aktionen, plattformspezifische Anpassung und Berechtigungsverwaltung.

3. **Bewährte Reife:** Paket mit 5+ Jahren Entwicklung, 3000+ GitHub-Sternen, in Produktion von tausenden Anwendungen verwendet.

4. **Umfassende Dokumentation:** Detaillierte Beispiele für alle gängigen Anwendungsfälle.

**Warum NICHT Firebase Cloud Messaging (FCM):**

| Kriterium | flutter_local_notifications | Firebase Cloud Messaging |
|-----------|----------------------------|--------------------------|
| **Erfordert Server** | ❌ Nein | ✅ Ja (Firebase) |
| **Erfordert Verbindung** | ❌ Nein | ✅ Ja (Internet) |
| **Datenschutz** | ✅ Alle Daten lokal | ⚠️ Tokens bei Firebase |
| **Latenz** | ✅ Sofort | ⚠️ Netzabhängig |
| **Kosten** | ✅ Kostenlos | ⚠️ Begrenztes Freikontingent |
| **Setup-Komplexität** | ✅ Minimal | ❌ Hoch (Firebase, Server) |
| **Funktioniert offline** | ✅ Immer | ❌ Nein |
| **Präzises Scheduling** | ✅ Ja | ❌ Nein (annähernd) |

**Entscheidung:** Für eine Medikamentenverwaltungsanwendung, wo Datenschutz kritisch ist, Dosen pünktlich auch ohne Verbindung benachrichtigt werden müssen und keine Server-Client-Kommunikation erforderlich ist, sind lokale Benachrichtigungen die richtige und einfachste Architektur.

**Vergleich mit Alternativen:**

- **awesome_notifications:** Verworfen wegen geringerer Akzeptanz (weniger reif), komplexeren APIs und gemeldeten Problemen mit geplanten Benachrichtigungen auf Android 12+.

- **local_notifications (nativ):** Verworfen wegen Erfordernis plattformspezifischen Codes (Kotlin/Swift), was Entwicklungsaufwand verdoppelt.

**Offizielle Dokumentation:** https://pub.dev/packages/flutter_local_notifications

---

### timezone ^0.10.1

**Verwendete Version:** `^0.10.1`

**Zweck:**
Zeitzonenverwaltungsbibliothek, die das Planen von Benachrichtigungen zu bestimmten Tageszeiten unter Berücksichtigung von Sommerzeit (DST) und Zeitzonenkonvertierungen ermöglicht.

**Verwendung in MedicApp:**

```dart
import 'package:timezone/timezone.dart' as tz;

// Initialisierung
await tz.initializeTimeZones();
final location = tz.getLocation('Europe/Madrid');
tz.setLocalLocation(location);

// Benachrichtigung um 08:00 lokale Zeit planen
final scheduledDate = tz.TZDateTime(
  location,
  now.year,
  now.month,
  now.day,
  8, // Stunde
  0, // Minuten
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

**Warum kritisch:**

- **Sommerzeit:** Ohne `timezone` würden Benachrichtigungen sich während DST-Wechseln um 1 Stunde verschieben.
- **Konsistenz:** Benutzer konfigurieren Zeiten in ihrer lokalen Zeitzone, die unabhängig von Gerätezeitonenänderungen respektiert werden muss.
- **Präzision:** `zonedSchedule` garantiert Benachrichtigungen zum genau angegebenen Zeitpunkt.

**Offizielle Dokumentation:** https://pub.dev/packages/timezone

---

### android_intent_plus ^6.0.0

**Verwendete Version:** `^6.0.0`

**Zweck:**
Plugin zum Starten von Android-Intents aus Flutter, speziell verwendet zum Öffnen der Benachrichtigungseinstellungen wenn Berechtigungen deaktiviert sind.

**Verwendung in MedicApp:**

```dart
import 'package:android_intent_plus/android_intent.dart';

// App-Benachrichtigungseinstellungen öffnen
final intent = AndroidIntent(
  action: 'android.settings.APP_NOTIFICATION_SETTINGS',
  arguments: {
    'android.provider.extra.APP_PACKAGE': packageName,
  },
);
await intent.launch();
```

**Anwendungsfälle:**

1. **Benutzerführung:** Wenn Benachrichtigungsberechtigungen deaktiviert sind, wird erläuternder Dialog mit "Einstellungen öffnen"-Button angezeigt, der direkt MedicApp-Benachrichtigungseinstellungs-Bildschirm startet.

2. **Verbesserte UX:** Vermeidet, dass Benutzer manuell navigieren müssen: Einstellungen > Apps > MedicApp > Benachrichtigungen.

**Offizielle Dokumentation:** https://pub.dev/packages/android_intent_plus

---

## 4. Lokalisierung (i18n)

### flutter_localizations (SDK)

**Verwendete Version:** Im Flutter-SDK enthalten

**Zweck:**
Offizielles Flutter-Paket, das Lokalisierungen für Material- und Cupertino-Widgets in 85+ Sprachen bereitstellt, einschließlich Übersetzungen von Standard-Komponenten (Dialog-Buttons, Picker usw.).

**Verwendung in MedicApp:**

```dart
import 'package:flutter_localizations/flutter_localizations.dart';

MaterialApp(
  localizationsDelegates: [
    GlobalMaterialLocalizations.delegate, // Material-Widgets
    GlobalWidgetsLocalizations.delegate,  // Generische Widgets
    GlobalCupertinoLocalizations.delegate, // Cupertino (iOS)
  ],
  supportedLocales: [
    Locale('es'), // Spanisch
    Locale('en'), // Englisch
    Locale('de'), // Deutsch
    // ... 8 Sprachen gesamt
  ],
)
```

**Was es bietet:**

- Übersetzungen von Standard-Buttons: "OK", "Abbrechen", "Akzeptieren".
- Lokalisierte Datums- und Zeitformate: "15/11/2025" (de) vs "11/15/2025" (en).
- Datums-/Zeit-Picker in lokaler Sprache.
- Tages- und Monatsnamen.

**Offizielle Dokumentation:** https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization

---

### intl ^0.20.2

**Verwendete Version:** `^0.20.2`

**Zweck:**
Dart-Internationalisierungsbibliothek, die Formatierung von Daten, Zahlen, Pluralisierung und Nachrichtenübersetzung über ARB-Dateien bietet.

**Verwendung in MedicApp:**

```dart
import 'package:intl/intl.dart';

// Datumsformatierung
final formatted = DateFormat('dd/MM/yyyy').format(DateTime.now());

// Zahlenformatierung
final stock = NumberFormat.decimalPattern().format(25.5);

// Pluralisierung (aus ARB)
// "{count, plural, =1{1 Tablette} other{{count} Tabletten}}"
```

**Anwendungsfälle:**

1. **Datumsformatierung:** Anzeige von Start-/Enddaten der Behandlung, Dosishistorie.
2. **Zahlenformatierung:** Anzeige von Bestand mit Dezimalstellen nach regionaler Konfiguration.
3. **Intelligente Pluralisierung:** Nachrichten, die sich nach Menge ändern ("1 Tablette" vs "5 Tabletten").

**Offizielle Dokumentation:** https://pub.dev/packages/intl

---

### ARB-System (Application Resource Bundle)

**Verwendetes Format:** ARB (JSON-basiert)

**Zweck:**
Anwendungsressourcen-Dateisystem, das das Definieren von String-Übersetzungen im JSON-Format mit Unterstützung für Platzhalter, Pluralisierung und Metadaten ermöglicht.

**Konfiguration in MedicApp:**

**`l10n.yaml`:**
```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
untranslated-messages-file: untranslated_messages.json
```

**Dateistruktur:**
```
lib/l10n/
├── app_es.arb (Hauptvorlage, Spanisch)
├── app_en.arb (Englische Übersetzungen)
├── app_de.arb (Deutsche Übersetzungen)
├── app_fr.arb (Französische Übersetzungen)
├── app_it.arb (Italienische Übersetzungen)
├── app_ca.arb (Katalanische Übersetzungen)
├── app_eu.arb (Baskische Übersetzungen)
└── app_gl.arb (Galicische Übersetzungen)
```

**Beispiel ARB mit erweiterten Funktionen:**

**`app_de.arb`:**
```json
{
  "@@locale": "de",

  "appTitle": "MedicApp",
  "@appTitle": {
    "description": "Anwendungstitel"
  },

  "medicationDose": "{count, plural, =1{1 {unit}} other{{count} {unit}}}",
  "@medicationDose": {
    "description": "Medikamentendosis mit Pluralisierung",
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

  "stockRemaining": "{stock} {unit, plural, =1{Einheit} other{Einheiten}} verbleiben",
  "@stockRemaining": {
    "placeholders": {
      "stock": {"type": "num"},
      "unit": {"type": "String"}
    }
  }
}
```

**Automatische Generierung:**

Flutter generiert automatisch die `AppLocalizations`-Klasse mit typisierten Methoden:

```dart
// Generierter Code in .dart_tool/flutter_gen/gen_l10n/app_localizations.dart
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

// Verwendung im Code
Text(AppLocalizations.of(context)!.medicationDose(2.5, 'Tabletten'))
// Ergebnis: "2,5 Tabletten"
```

**Vorteile des ARB-Systems:**

1. **Starke Typisierung:** Übersetzungsfehler zur Kompilierzeit erkannt.
2. **Sichere Platzhalter:** Unmöglich, erforderliche Parameter zu vergessen.
3. **CLDR-Pluralisierung:** Unterstützung für Pluralisierungsregeln von 200+ Sprachen nach Unicode CLDR.
4. **Nützliche Metadaten:** Beschreibungen und Kontext für Übersetzer.
5. **Übersetzungswerkzeuge:** Kompatibel mit Google Translator Toolkit, Crowdin, Lokalise.

**Übersetzungsprozess in MedicApp:**

1. Strings in `app_es.arb` definieren (Vorlage).
2. `flutter gen-l10n` ausführen, um Dart-Code zu generieren.
3. In andere Sprachen übersetzen, indem ARB-Dateien kopiert und modifiziert werden.
4. `untranslated_messages.json` überprüfen, um fehlende Strings zu erkennen.

**Offizielle Dokumentation:** https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization#adding-your-own-localized-messages

---

### 8 Unterstützte Sprachen

MedicApp ist vollständig in 8 Sprachen übersetzt:

| Code | Sprache | Hauptregion | Sprecher (Millionen) |
|------|---------|-------------|----------------------|
| `es` | Spanisch | Spanien, Lateinamerika | 500M+ |
| `en` | English | Global | 1.500M+ |
| `de` | Deutsch | Deutschland, Österreich, Schweiz | 130M+ |
| `fr` | Français | Frankreich, Kanada, Afrika | 300M+ |
| `it` | Italiano | Italien, Schweiz | 85M+ |
| `ca` | Català | Katalonien, Valencia, Balearen | 10M+ |
| `eu` | Euskara | Baskenland | 750K+ |
| `gl` | Galego | Galicien | 2,5M+ |

**Gesamtabdeckung:** ~2.500 Millionen potenzielle Sprecher

**Strings gesamt:** ~450 Übersetzungen pro Sprache

**Übersetzungsqualität:**
- Spanisch: Muttersprachler (Vorlage)
- Englisch: Muttersprachler
- Deutsch, Französisch, Italienisch: Professionell
- Katalanisch, Baskisch, Galicisch: Muttersprachler (spanische Amtssprachen)

**Begründung enthaltener Sprachen:**

- **Spanisch:** Hauptsprache des Entwicklers und Anfangszielmarkt (Spanien, Lateinamerika).
- **Englisch:** Universalsprache für globale Reichweite.
- **Deutsch, Französisch, Italienisch:** Hauptsprachen Westeuropas, Märkte mit hoher Nachfrage nach Gesundheits-Apps.
- **Katalanisch, Baskisch, Galicisch:** Amtssprachen in Spanien (Regionen mit 17M+ Einwohnern), verbessert Zugänglichkeit für ältere Benutzer, die in Muttersprache komfortabler sind.

---

## 5. Zustandsverwaltung

### Ohne Zustandsverwaltungsbibliothek (Vanilla Flutter)

**Entscheidung:** MedicApp verwendet **KEINE** Zustandsverwaltungsbibliothek (Provider, Riverpod, BLoC, Redux, GetX).

**Warum KEINE Zustandsverwaltung verwendet wird:**

1. **Datenbankbasierte Architektur:** Der wahre Zustand der Anwendung liegt in SQLite, nicht im Speicher. Jeder Bildschirm fragt die Datenbank direkt ab, um aktualisierte Daten zu erhalten.

2. **StatefulWidget + setState ist ausreichend:** Für eine Anwendung mittlerer Komplexität wie MedicApp bieten `setState()` und `StatefulWidget` mehr als ausreichende lokale Zustandsverwaltung.

3. **Einfachheit über Frameworks:** Vermeidung unnötiger Abhängigkeiten reduziert Komplexität, Anwendungsgröße und mögliche Breaking Changes bei Updates.

4. **Datenbank-Streams:** Für reaktive Daten werden `StreamBuilder` mit direkten Streams von `DatabaseHelper` verwendet:

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

5. **Navigation mit Callbacks:** Für Kommunikation zwischen Bildschirmen werden traditionelle Flutter-Callbacks verwendet:

```dart
// Hauptbildschirm
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => AddMedicationScreen(
      onMedicationAdded: () {
        setState(() {}); // Liste aktualisieren
      },
    ),
  ),
);
```

**Vergleich mit Alternativen:**

| Lösung | MedicApp (Vanilla) | Provider | BLoC | Riverpod |
|--------|-------------------|----------|------|----------|
| **Zusätzliche Codezeilen** | 0 | ~500 | ~1.500 | ~800 |
| **Externe Abhängigkeiten** | 0 | 1 | 2+ | 2+ |
| **Lernkurve** | ✅ Minimal | ⚠️ Mittel | ❌ Hoch | ⚠️ Mittel-Hoch |
| **Boilerplate** | ✅ Keines | ⚠️ Mittel | ❌ Hoch | ⚠️ Mittel |
| **Testing** | ✅ Direkt | ⚠️ Erfordert Mocks | ⚠️ Erfordert Setup | ⚠️ Erfordert Setup |
| **Leistung** | ✅ Ausgezeichnet | ⚠️ Gut | ⚠️ Gut | ⚠️ Gut |
| **APK-Größe** | ✅ Minimal | +50KB | +150KB | +100KB |

**Warum KEIN Provider:**

- **Unnötig:** Provider ist für das Teilen von Zustand zwischen tief verschachtelten Widgets konzipiert. MedicApp erhält Daten aus der Datenbank auf jedem Root-Bildschirm, ohne Notwendigkeit, Zustand nach unten zu übergeben.
- **Hinzugefügte Komplexität:** Erfordert `ChangeNotifier`, `MultiProvider`, Context-Awareness und Verständnis des Widget-Baums.
- **Over-Engineering:** Für eine Anwendung mit ~15 Bildschirmen und datenbankbasiertem Zustand wäre Provider wie Presslufthammer für Nagel.

**Warum KEIN BLoC:**

- **Extreme Komplexität:** BLoC (Business Logic Component) erfordert Verständnis von Streams, Sinks, Events, States und Schichtenarchitektur.
- **Massives Boilerplate:** Jedes Feature erfordert 4-5 Dateien (bloc, event, state, repository, test).
- **Over-Engineering:** BLoC ist ausgezeichnet für Unternehmensanwendungen mit komplexer Geschäftslogik und mehreren Entwicklern. MedicApp ist Anwendung mittlerer Komplexität, wo Einfachheit Priorität hat.

**Warum KEIN Riverpod:**

- **Weniger reif:** Riverpod ist relativ neu (2020) im Vergleich zu Provider (2018) und BLoC (2018).
- **Ähnliche Komplexität wie Provider:** Erfordert Verständnis von Providers, autoDispose, Family und deklarativer Architektur.
- **Kein klarer Vorteil:** Für MedicApp bietet Riverpod keine signifikanten Vorteile gegenüber aktueller Architektur.

**Warum KEIN Redux:**

- **Massive Komplexität:** Redux erfordert Actions, Reducers, Middleware, Store und strikte Unveränderlichkeit.
- **Unhaltbares Boilerplate:** Selbst einfache Operationen erfordern mehrere Dateien und hunderte Codezeilen.
- **Totales Over-Kill:** Redux ist für Web-SPA-Anwendungen mit komplexem Frontend-Zustand konzipiert. MedicApp hat Zustand in SQLite, nicht im Speicher.

**Fälle wo Zustandsverwaltung benötigt würde:**

- **Komplexer geteilter Speicherzustand:** Wenn mehrere Bildschirme große Objekte im Speicher teilen müssen (trifft auf MedicApp nicht zu).
- **Globaler Authentifizierungszustand:** Bei Login/Sessions (MedicApp ist lokal, ohne Konten).
- **Echtzeit-Synchronisation:** Bei Echtzeit-Multi-Benutzer-Kollaboration (trifft nicht zu).
- **Komplexe Geschäftslogik:** Bei schweren Berechnungen, die Speicher-Caching erfordern (MedicApp führt einfache Bestands- und Datumsberechnungen durch).

**Endgültige Entscheidung:**

Für MedicApp ist die Architektur **Database as Single Source of Truth + StatefulWidget + setState** die richtige Lösung. Sie ist einfach, direkt, leicht verständlich und wartbar und führt keine unnötige Komplexität ein. Hinzufügen von Provider, BLoC oder Riverpod wäre reines Over-Engineering ohne greifbare Vorteile.

---

## 6. Lokale Speicherung

### shared_preferences ^2.2.2

**Verwendete Version:** `^2.2.2`

**Zweck:**
Persistenter Schlüssel-Wert-Speicher für einfache Benutzereinstellungen, Anwendungskonfigurationen und nicht-kritische Zustände. Verwendet `SharedPreferences` auf Android und `UserDefaults` auf iOS.

**Verwendung in MedicApp:**

MedicApp verwendet `shared_preferences` zum Speichern leichter Konfigurationen, die keine SQL-Tabelle rechtfertigen:

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

**Gespeicherte Daten:**

1. **Anwendungsthema:**
   - Schlüssel: `theme_mode`
   - Werte: `ThemeMode.light`, `ThemeMode.dark`, `ThemeMode.system`
   - Verwendung: Theme-Präferenz zwischen Sitzungen behalten.

2. **Ausgewählte Sprache:**
   - Schlüssel: `locale`
   - Werte: `es`, `en`, `de`, `fr`, `it`, `ca`, `eu`, `gl`
   - Verwendung: Vom Benutzer gewählte Sprache merken (Systemsprachen-Override).

3. **Berechtigungsstatus:**
   - Schlüssel: `notifications_enabled`
   - Werte: `true`, `false`
   - Verwendung: Lokaler Cache des Berechtigungsstatus zur Vermeidung wiederholter nativer Aufrufe.

4. **Erste Ausführung:**
   - Schlüssel: `first_run`
   - Werte: `true`, `false`
   - Verwendung: Tutorial/Onboarding nur bei erster Ausführung anzeigen.

**Warum shared_preferences und nicht SQLite:**

- **Leistung:** Sofortiger O(1) Zugriff für einfache Werte vs. SQL-Abfrage mit Overhead.
- **Einfachheit:** Triviale API (`getString`, `setString`) vs. Vorbereitung von SQL-Abfragen.
- **Zweck:** Benutzereinstellungen vs. relationale Daten.
- **Größe:** Kleine Werte (< 1KB) vs. komplexe Datensätze.

**Einschränkungen von shared_preferences:**

- ❌ Unterstützt keine Beziehungen, JOINs, Transaktionen.
- ❌ Nicht geeignet für Daten >100KB.
- ❌ Asynchroner Zugriff (erfordert `await`).
- ❌ Nur primitive Typen (String, int, double, bool, List<String>).

**Trade-offs:**

- ✅ **Vorteile:** Einfache API, ausgezeichnete Leistung, richtiger Zweck für Einstellungen.
- ❌ **Nachteile:** Nicht geeignet für strukturierte oder voluminöse Daten.

**Offizielle Dokumentation:** https://pub.dev/packages/shared_preferences

---

## 7. Dateioperationen

### file_picker ^8.0.0+1

**Verwendete Version:** `^8.0.0+1`

**Zweck:**
Plattformübergreifendes Plugin zur Auswahl von Dateien aus dem Gerätedateisystem, mit Unterstützung für mehrere Plattformen (Android, iOS, Desktop, Web).

**Verwendung in MedicApp:**

MedicApp verwendet `file_picker` ausschließlich für die **Datenbankimport**-Funktion, die es Benutzern ermöglicht, ein Backup wiederherzustellen oder Daten von einem anderen Gerät zu migrieren.

**Implementierung:**

```dart
import 'package:file_picker/file_picker.dart';

Future<void> importDatabase() async {
  // Dateiauswahl öffnen
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['db'],
    dialogTitle: 'Datenbankdatei auswählen',
  );

  if (result == null) return; // Benutzer abgebrochen

  final file = result.files.single;
  final path = file.path!;

  // Datei validieren und kopieren
  await DatabaseHelper.instance.importDatabase(path);

  // Anwendung neu laden
  setState(() {});
}
```

**Verwendete Funktionen:**

1. **Erweiterungsfilter:** Erlaubt nur Auswahl von `.db`-Dateien zur Vermeidung von Benutzerfehlern.
2. **Benutzerdefinierter Titel:** Zeigt beschreibende Nachricht im System-Dialog.
3. **Vollständiger Pfad:** Erhält absoluten Pfad der Datei zum Kopieren an App-Speicherort.

**Betrachtete Alternativen:**

- **image_picker:** Verworfen, da speziell für Bilder/Videos konzipiert, nicht für generische Dateien.
- **Nativer Code:** Verworfen, da manuelle Implementierung von `ActivityResultLauncher` (Android) und `UIDocumentPickerViewController` (iOS) erfordert.

**Offizielle Dokumentation:** https://pub.dev/packages/file_picker

---

### share_plus ^10.1.4

**Verwendete Version:** `^10.1.4`

**Zweck:**
Plattformübergreifendes Plugin zum Teilen von Dateien, Text und URLs unter Verwendung des nativen Teilen-Blatts des Betriebssystems (Android Share Sheet, iOS Share Sheet).

**Verwendung in MedicApp:**

MedicApp verwendet `share_plus` für die **Datenbankexport**-Funktion, die es Benutzern ermöglicht, ein Backup zu erstellen und es per E-Mail, Cloud-Speicher (Drive, Dropbox), Bluetooth zu teilen oder in lokalen Dateien zu speichern.

**Implementierung:**

```dart
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

Future<void> exportDatabase() async {
  // Aktuellen Datenbankpfad abrufen
  final dbPath = await DatabaseHelper.instance.getDatabasePath();

  // Temporäre Kopie in teilbarem Verzeichnis erstellen
  final tempDir = await getTemporaryDirectory();
  final exportPath = '${tempDir.path}/medicapp_backup_${DateTime.now().millisecondsSinceEpoch}.db';

  // Datenbank kopieren
  await File(dbPath).copy(exportPath);

  // Datei teilen
  await Share.shareXFiles(
    [XFile(exportPath)],
    subject: 'MedicApp Backup',
    text: 'MedicApp-Datenbank - ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
  );
}
```

**Benutzerablauf:**

1. Benutzer tippt "Datenbank exportieren" im Konfigurationsmenü.
2. MedicApp erstellt Kopie von `medicapp.db` mit Zeitstempel im Namen.
3. Natives Teilen-Blatt des Betriebssystems öffnet sich.
4. Benutzer wählt Ziel: Gmail (als Anhang), Drive, Bluetooth, "In Dateien speichern" usw.
5. `.db`-Datei wird an gewähltes Ziel geteilt/gespeichert.

**Erweiterte Funktionen:**

- **XFile:** Plattformübergreifende Dateiabstraktion, die auf Android, iOS, Desktop und Web funktioniert.
- **Metadaten:** Enthält beschreibenden Dateinamen und erläuternden Text.
- **Kompatibilität:** Funktioniert mit allen Apps, die mit dem Teilen-Protokoll des Betriebssystems kompatibel sind.

**Warum share_plus:**

- **Native UX:** Verwendet die Teilen-Schnittstelle, die Benutzer bereits kennen, ohne Rad neu zu erfinden.
- **Perfekte Integration:** Integriert sich automatisch mit allen installierten Apps, die Dateien empfangen können.
- **Plattformübergreifend:** Gleicher Code funktioniert auf Android und iOS mit nativem Verhalten auf jedem.

**Betrachtete Alternativen:**

- **Direktes Schreiben in öffentliches Verzeichnis:** Verworfen, da auf Android 10+ (Scoped Storage) komplexe Berechtigungen erfordert und nicht konsistent funktioniert.
- **Direktes E-Mail-Plugin:** Verworfen, da Benutzer auf eine Backup-Methode (E-Mail) beschränkt, während `share_plus` jedes Ziel erlaubt.

**Offizielle Dokumentation:** https://pub.dev/packages/share_plus

---

## 8. Testing

### flutter_test (SDK)

**Verwendete Version:** Im Flutter-SDK enthalten

**Zweck:**
Offizielles Flutter-Test-Framework, das alle notwendigen Tools für Unit-Tests, Widget-Tests und Integration-Tests bereitstellt.

**MedicApp-Testarchitektur:**

MedicApp hat **432+ Tests** in 3 Kategorien organisiert:

#### 1. Unit-Tests (60% der Tests)

Tests reiner Geschäftslogik, Modelle, Services und Helfer ohne Flutter-Abhängigkeiten.

**Beispiele:**
- `test/medication_model_test.dart`: Datenmodellvalidierung.
- `test/dose_history_service_test.dart`: Dosishistorienlogik.
- `test/notification_service_test.dart`: Benachrichtigungsplanungslogik.
- `test/preferences_service_test.dart`: Einstellungsdienst.

**Typische Struktur:**
```dart
void main() {
  setUpAll(() async {
    // Testdatenbank initialisieren
    setupTestDatabase();
  });

  tearDown(() async {
    // Datenbank nach jedem Test bereinigen
    await DatabaseHelper.instance.close();
  });

  group('Medication Model', () {
    test('should create medication with valid data', () {
      final medication = Medication(
        id: 'test-id',
        name: 'Ibuprofen',
        type: MedicationType.pill,
      );

      expect(medication.id, 'test-id');
      expect(medication.name, 'Ibuprofen');
      expect(medication.type, MedicationType.pill);
    });

    test('should calculate next dose time correctly', () {
      final medication = Medication(
        id: 'test',
        name: 'Test',
        times: ['08:00', '20:00'],
      );

      final now = DateTime(2025, 1, 15, 10, 0); // 10:00 Uhr
      final nextDose = medication.getNextDoseTime(now);

      expect(nextDose.hour, 20); // Nächste Dosis um 20:00
    });
  });
}
```

#### 2. Widget-Tests (30% der Tests)

Tests einzelner Widgets, UI-Interaktionen und Navigationsabläufe.

**Beispiele:**
- `test/settings_screen_test.dart`: Einstellungsbildschirm.
- `test/edit_schedule_screen_test.dart`: Zeitplan-Editor.
- `test/edit_duration_screen_test.dart`: Dauer-Editor.
- `test/day_navigation_ui_test.dart`: Tagesnavigation.

**Typische Struktur:**
```dart
void main() {
  testWidgets('should display medication list', (tester) async {
    // Arrange: Testdaten vorbereiten
    final medications = [
      Medication(id: '1', name: 'Ibuprofen', type: MedicationType.pill),
      Medication(id: '2', name: 'Paracetamol', type: MedicationType.pill),
    ];

    // Act: Widget bauen
    await tester.pumpWidget(
      MaterialApp(
        home: MedicationListScreen(medications: medications),
      ),
    );

    // Assert: UI überprüfen
    expect(find.text('Ibuprofen'), findsOneWidget);
    expect(find.text('Paracetamol'), findsOneWidget);

    // Interaktion: Erstes Medikament antippen
    await tester.tap(find.text('Ibuprofen'));
    await tester.pumpAndSettle();

    // Navigation überprüfen
    expect(find.byType(MedicationDetailScreen), findsOneWidget);
  });
}
```

#### 3. Integrationstests (10% der Tests)

End-to-End-Tests vollständiger Abläufe, die mehrere Bildschirme, Datenbank und Services umfassen.

**Beispiele:**
- `test/integration/add_medication_test.dart`: Vollständiger Medikament-Hinzufügen-Ablauf (8 Schritte).
- `test/integration/dose_registration_test.dart`: Dosisregistrierung und Bestandsaktualisierung.
- `test/integration/stock_management_test.dart`: Vollständige Bestandsverwaltung (Nachfüllen, Erschöpfung, Warnungen).
- `test/integration/app_startup_test.dart`: Anwendungsstart und Datenladen.

**Typische Struktur:**
```dart
void main() {
  testWidgets('complete add medication flow', (tester) async {
    // Anwendung starten
    await tester.pumpWidget(const MedicApp());
    await tester.pumpAndSettle();

    // Schritt 1: Medikament-Hinzufügen-Bildschirm öffnen
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Schritt 2: Name eingeben
    await tester.enterText(find.byType(TextField).first, 'Ibuprofen 600mg');

    // Schritt 3: Typ auswählen
    await tester.tap(find.text('Tablette'));
    await tester.pumpAndSettle();

    // Schritt 4: Nächster Schritt
    await tester.tap(find.text('Weiter'));
    await tester.pumpAndSettle();

    // ... fortsetzen mit den 8 Schritten

    // Hinzugefügtes Medikament überprüfen
    expect(find.text('Ibuprofen 600mg'), findsOneWidget);

    // In Datenbank überprüfen
    final medications = await DatabaseHelper.instance.getMedications();
    expect(medications.length, 1);
    expect(medications.first.name, 'Ibuprofen 600mg');
  });
}
```

**Code-Abdeckung:**

- **Ziel:** 75-80%
- **Aktuell:** 75-80% (432+ Tests)
- **Abgedeckte Zeilen:** ~12.000 von ~15.000

**Bereiche mit höchster Abdeckung:**
- Models: 95%+ (kritische Datenlogik)
- Services: 85%+ (Benachrichtigungen, Datenbank, Dosen)
- Screens: 65%+ (UI und Navigation)

**Bereiche mit geringerer Abdeckung:**
- Helfer und Utilities: 60%
- Initialisierungscode: 50%

**Test-Strategie:**

1. **Test-First für kritische Logik:** Tests vor Code für Dosis-, Bestands-, Zeitplanberechnungen geschrieben.
2. **Test-After für UI:** Tests nach Bildschirmimplementierung zur Verhaltensüberprüfung geschrieben.
3. **Regressionstests:** Jeder gefundene Bug wird zu Test zur Vermeidung von Regressionen.

**Test-Befehle:**

```bash
# Alle Tests ausführen
flutter test

# Tests mit Abdeckung ausführen
flutter test --coverage

# Spezifische Tests ausführen
flutter test test/medication_model_test.dart

# Integrationstests ausführen
flutter test test/integration/
```

**Test-Helfer:**

**`test/helpers/database_test_helper.dart`:**
```dart
void setupTestDatabase() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}

Future<void> cleanDatabase() async {
  await DatabaseHelper.instance.close();
  await DatabaseHelper.instance.database; // Sauber neu erstellen
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

**Offizielle Dokumentation:** https://docs.flutter.dev/testing

---

## 9. Entwicklungswerkzeuge

### flutter_launcher_icons ^0.14.4

**Verwendete Version:** `^0.14.4` (dev_dependencies)

**Zweck:**
Paket, das automatisch Anwendungs-Icons in allen von Android und iOS erforderlichen Größen und Formaten aus einem einzigen Quellbild generiert.

**Konfiguration in MedicApp:**

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

**Generierte Icons:**

**Android:**
- `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` (72x72)
- `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` (48x48)
- `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png` (96x96)
- `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` (144x144)
- `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` (192x192)
- Adaptive Icons für Android 8+ (separater Vordergrund + Hintergrund)

**iOS:**
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/` (20x20 bis 1024x1024, 15+ Varianten)

**Generierungsbefehl:**

```bash
flutter pub run flutter_launcher_icons
```

**Warum dieses Tool:**

- **Automatisierung:** Manuelles Generieren von 20+ Icon-Dateien wäre mühsam und fehleranfällig.
- **Adaptive Icons (Android 8+):** Unterstützt adaptive Icon-Funktionalität, die sich verschiedenen Formen je nach Launcher anpasst.
- **Optimierung:** Icons werden in optimiertem PNG-Format generiert.
- **Konsistenz:** Garantiert, dass alle Größen aus derselben Quelle generiert werden.

**Offizielle Dokumentation:** https://pub.dev/packages/flutter_launcher_icons

---

### flutter_native_splash ^2.4.7

**Verwendete Version:** `^2.4.7` (dev_dependencies)

**Zweck:**
Paket, das native Splash-Screens (anfängliche Ladebildschirme) für Android und iOS generiert, die sofort angezeigt werden, während Flutter initialisiert.

**Konfiguration in MedicApp:**

**`pubspec.yaml`:**
```yaml
flutter_native_splash:
  color: "#419e69"  # Hintergrundfarbe (MedicApp-Grün)
  image: assets/images/icon.png  # Zentrales Bild
  android: true
  ios: true
  fullscreen: true
  android_12:
    image: assets/images/icon.png
    color: "#419e69"
```

**Implementierte Funktionen:**

1. **Einheitlicher Splash:** Gleiches Aussehen auf Android und iOS.
2. **Markenfarbe:** Grün `#419e69` (MedicApp-Primärfarbe).
3. **Zentriertes Logo:** MedicApp-Icon in Bildschirmmitte.
4. **Vollbild:** Versteckt Statusleiste während Splash.
5. **Android 12+ spezifisch:** Spezielle Konfiguration zur Einhaltung des neuen Android 12 Splash-Systems.

**Generierte Dateien:**

**Android:**
- `android/app/src/main/res/drawable/launch_background.xml`
- `android/app/src/main/res/values/styles.xml` (Splash-Theme)
- `android/app/src/main/res/values-night/styles.xml` (Dunkles Theme)

**iOS:**
- `ios/Runner/Assets.xcassets/LaunchImage.imageset/`
- `ios/Runner/Base.lproj/LaunchScreen.storyboard`

**Generierungsbefehl:**

```bash
flutter pub run flutter_native_splash:create
```

**Warum nativer Splash:**

- **Professionelle UX:** Vermeidet weißen Bildschirm während 1-2 Sekunden Flutter-Initialisierung.
- **Sofortiges Branding:** Zeigt Logo und Markenfarben vom ersten Frame an.
- **Geschwindigkeitswahrnehmung:** Splash mit Branding fühlt sich schneller an als weißer Bildschirm.

**Offizielle Dokumentation:** https://pub.dev/packages/flutter_native_splash

---

### uuid ^4.0.0

**Verwendete Version:** `^4.0.0`

**Zweck:**
UUID (Universally Unique Identifiers) v4 Generator zur Erstellung eindeutiger Bezeichner für Medikamente, Personen und Dosisaufzeichnungen.

**Verwendung in MedicApp:**

```dart
import 'package:uuid/uuid.dart';

const uuid = Uuid();

final medication = Medication(
  id: uuid.v4(), // Generiert: "f47ac10b-58cc-4372-a567-0e02b2c3d479"
  name: 'Ibuprofen',
  type: MedicationType.pill,
);
```

**Warum UUIDs:**

- **Globale Eindeutigkeit:** Kollisionswahrscheinlichkeit: 1 zu 10³⁸ (praktisch unmöglich).
- **Offline-Generierung:** Erfordert keine Koordination mit Server oder Datenbanksequenzen.
- **Zukünftige Synchronisation:** Falls MedicApp Cloud-Synchronisation hinzufügt, vermeiden UUIDs ID-Konflikte.
- **Debugging:** Beschreibende IDs in Logs statt generischer Ganzzahlen (1, 2, 3).

**Betrachtete Alternative:**

- **Auto-Increment Integer:** Verworfen, da Sequenzverwaltung in SQLite erforderlich und könnte Konflikte bei zukünftiger Synchronisation verursachen.

**Offizielle Dokumentation:** https://pub.dev/packages/uuid

---

## 10. Plattformabhängigkeiten

### Android

**Build-Konfiguration:**

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
        isCoreLibraryDesugaringEnabled = true  // Für moderne APIs auf Android < 26
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```

**Werkzeuge:**

- **Gradle 8.0+:** Android-Build-System.
- **Kotlin 1.9.0:** Sprache für nativen Android-Code (obwohl MedicApp keinen benutzerdefinierten Kotlin-Code verwendet).
- **AndroidX:** Moderne Support-Bibliotheken (Ersatz für Support Library).

**Mindestversionen:**

- **minSdk 21 (Android 5.0 Lollipop):** Abdeckung von 99%+ aktiver Android-Geräte.
- **targetSdk 34 (Android 14):** Neueste Android-Version zur Nutzung moderner Funktionen.

**Erforderliche Berechtigungen:**

**`android/app/src/main/AndroidManifest.xml`:**
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" /> <!-- Android 13+ -->
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" /> <!-- Exakte Benachrichtigungen -->
<uses-permission android:name="android.permission.USE_EXACT_ALARM" /> <!-- Android 14+ -->
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" /> <!-- Benachrichtigungen nach Neustart neu planen -->
```

**Offizielle Dokumentation:** https://developer.android.com

---

### iOS

**Build-Konfiguration:**

**`ios/Runner/Info.plist`:**
```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>

<key>NSUserNotificationsUsageDescription</key>
<string>MedicApp muss Benachrichtigungen senden, um Sie an die Einnahme Ihrer Medikamente zu erinnern.</string>
```

**Werkzeuge:**

- **CocoaPods 1.11+:** iOS-Native-Abhängigkeitsmanager.
- **Xcode 14+:** IDE erforderlich zum Kompilieren von iOS-Apps.
- **Swift 5.0:** Sprache für nativen iOS-Code (obwohl MedicApp Standard-AppDelegate verwendet).

**Mindestversionen:**

- **iOS 12.0+:** Abdeckung von 98%+ aktiver iOS-Geräte.
- **iPadOS 12.0+:** Vollständige iPad-Unterstützung.

**Erforderliche Funktionen:**

- **Push-Benachrichtigungen:** Obwohl MedicApp lokale Benachrichtigungen verwendet, ermöglicht diese Funktion das Benachrichtigungsframework.
- **Hintergrund-Fetch:** Ermöglicht Aktualisierung von Benachrichtigungen wenn App im Hintergrund.

**Offizielle Dokumentation:** https://developer.apple.com/documentation/

---

## 11. Versionen und Kompatibilität

### Abhängigkeitstabelle

| Abhängigkeit | Version | Zweck | Kategorie |
|--------------|---------|-------|-----------|
| **Flutter SDK** | `3.9.2+` | Haupt-Framework | Core |
| **Dart SDK** | `3.9.2+` | Programmiersprache | Core |
| **cupertino_icons** | `^1.0.8` | iOS-Icons | UI |
| **sqflite** | `^2.3.0` | SQLite-Datenbank | Persistenz |
| **path** | `^1.8.3` | Pfadmanipulation | Utility |
| **flutter_local_notifications** | `^19.5.0` | Lokale Benachrichtigungen | Benachrichtigungen |
| **timezone** | `^0.10.1` | Zeitzonen | Benachrichtigungen |
| **intl** | `^0.20.2` | Internationalisierung | i18n |
| **android_intent_plus** | `^6.0.0` | Android-Intents | Berechtigungen |
| **shared_preferences** | `^2.2.2` | Benutzereinstellungen | Persistenz |
| **file_picker** | `^8.0.0+1` | Dateiauswahl | Dateien |
| **share_plus** | `^10.1.4` | Dateien teilen | Dateien |
| **path_provider** | `^2.1.5` | Systemverzeichnisse | Persistenz |
| **uuid** | `^4.0.0` | UUID-Generator | Utility |
| **sqflite_common_ffi** | `^2.3.0` | SQLite-Testing | Testing (dev) |
| **flutter_launcher_icons** | `^0.14.4` | Icon-Generierung | Tool (dev) |
| **flutter_native_splash** | `^2.4.7` | Splash-Screen | Tool (dev) |
| **flutter_lints** | `^6.0.0` | Statische Analyse | Tool (dev) |

**Produktionsabhängigkeiten gesamt:** 14
**Entwicklungsabhängigkeiten gesamt:** 4
**Gesamt:** 18

---

### Plattformkompatibilität

| Plattform | Mindestversion | Zielversion | Abdeckung |
|-----------|----------------|-------------|-----------|
| **Android** | 5.0 (API 21) | 14 (API 34) | 99%+ Geräte |
| **iOS** | 12.0 | 17.0 | 98%+ Geräte |
| **iPadOS** | 12.0 | 17.0 | 98%+ Geräte |

**Nicht unterstützt:** Web, Windows, macOS, Linux (MedicApp ist ausschließlich mobil konzipiert).

---

### Flutter-Kompatibilität

| Flutter | Kompatibel | Hinweise |
|---------|------------|----------|
| 3.9.2 - 3.10.x | ✅ | Entwicklungsversion |
| 3.11.x - 3.19.x | ✅ | Kompatibel ohne Änderungen |
| 3.20.x - 3.35.x | ✅ | Getestet bis 3.35.7 |
| 3.36.x+ | ⚠️ | Wahrscheinlich kompatibel, nicht getestet |
| 4.0.x | ❌ | Erfordert Abhängigkeitsaktualisierung |

---

## 12. Vergleiche und Entscheidungen

### 12.1. Datenbank: SQLite vs Hive vs Isar vs Drift

**Entscheidung:** SQLite (sqflite)

**Erweiterte Begründung:**

**MedicApp-Anforderungen:**

1. **N:M-Beziehungen (Viele-zu-Viele):** Ein Medikament kann mehreren Personen zugewiesen werden, und eine Person kann mehrere Medikamente haben. Diese Architektur ist in SQL nativ, aber komplex in NoSQL.

2. **Komplexe Abfragen:** Abrufen aller Medikamente einer Person mit ihren personalisierten Konfigurationen erfordert JOINs zwischen 3 Tabellen:

```sql
SELECT m.*, pm.custom_times, pm.custom_doses
FROM medications m
JOIN person_medications pm ON m.id = pm.medication_id
JOIN persons p ON pm.person_id = p.id
WHERE p.id = ?
```

Dies ist trivial in SQL, würde aber mehrere Abfragen und manuelle Logik in NoSQL erfordern.

3. **Komplexe Migrationen:** MedicApp hat sich von V1 (einfache Medikamententabelle) bis V19+ (Multi-Person mit Beziehungen) entwickelt. SQLite ermöglicht inkrementelle SQL-Migrationen, die Daten erhalten:

```sql
-- Migration V18 -> V19: Multi-Person hinzufügen
ALTER TABLE medications ADD COLUMN shared_stock REAL;
CREATE TABLE persons (...);
CREATE TABLE person_medications (...);
INSERT INTO persons (id, name, is_default) VALUES (?, 'Ich', 1);
INSERT INTO person_medications SELECT ?, id, times, doses FROM medications;
```

**Hive:**

- ✅ **Vorteile:** Ausgezeichnete Leistung, einfache API, kompakte Größe.
- ❌ **Nachteile:**
  - **Keine nativen Beziehungen:** Implementierung von N:M erfordert manuelles Verwalten von ID-Listen und mehrere Abfragen.
  - **Keine vollständigen ACID-Transaktionen:** Kann Atomarität bei komplexen Operationen nicht garantieren (Dosisregistrierung + Bestandsabzug + Benachrichtigung).
  - **Manuelle Migrationen:** Kein Schema-Versionssystem, erfordert benutzerdefinierte Logik.
  - **Schwieriges Debugging:** Proprietäres Binärformat, kann nicht mit Standard-Tools inspiziert werden.

**Isar:**

- ✅ **Vorteile:** Überlegene Leistung, schnelle Indizierung, elegante Dart-Syntax.
- ❌ **Nachteile:**
  - **Unreife:** 2022 veröffentlicht, weniger battle-tested als SQLite (20+ Jahre).
  - **Begrenzte Beziehungen:** Unterstützt Beziehungen, aber nicht so flexibel wie SQL-JOINs (begrenzt auf 1:1, 1:N, kein direktes M:N).
  - **Proprietäres Format:** Ähnlich wie Hive, erschwert Debugging mit externen Tools.
  - **Lock-in:** Migration von Isar zu anderer Lösung wäre kostspielig.

**Drift:**

- ✅ **Vorteile:** Typsicheres SQL, automatische Migrationen, generierte APIs.
- ❌ **Nachteile:**
  - **Komplexität:** Erfordert Code-Generierung, `.drift`-Dateien und komplexe build_runner-Konfiguration.
  - **Boilerplate:** Selbst einfache Operationen erfordern Tabellendefinition in separaten Dateien.
  - **Größe:** Erhöht APK-Größe um ~200KB vs. direktes sqflite.
  - **Reduzierte Flexibilität:** Komplexe Ad-hoc-Abfragen sind schwieriger als in direktem SQL.

**Endergebnis:**

Für MedicApp, wo N:M-Beziehungen fundamental sind, Migrationen häufig waren (19 Schemaversionen) und die Fähigkeit zum Debugging mit DB Browser for SQLite während Entwicklung unschätzbar war, ist SQLite die richtige Wahl.

**Akzeptierter Trade-off:**
Wir opfern ~10-15% Leistung bei massiven Operationen (irrelevant für MedicApp-Anwendungsfälle) zugunsten vollständiger SQL-Flexibilität, reifer Tools und robuster Datenarchitektur.

---

### 12.2. Benachrichtigungen: flutter_local_notifications vs awesome_notifications vs Firebase

**Entscheidung:** flutter_local_notifications

**Erweiterte Begründung:**

**MedicApp-Anforderungen:**

1. **Zeitliche Präzision:** Benachrichtigungen müssen genau zur geplanten Zeit ankommen (08:00:00, nicht 08:00:30).
2. **Offline-Funktionalität:** Medikamente werden unabhängig von Internetverbindung eingenommen.
3. **Datenschutz:** Medizinische Daten dürfen niemals das Gerät verlassen.
4. **Langfristige Planung:** Benachrichtigungen für Monate im Voraus geplant.

**flutter_local_notifications:**

- ✅ **Präzise Planung:** `zonedSchedule` mit `androidScheduleMode: exactAllowWhileIdle` garantiert exakte Zustellung auch mit Doze Mode.
- ✅ **Vollständig offline:** Benachrichtigungen werden lokal geplant, ohne Serverabhängigkeit.
- ✅ **Totaler Datenschutz:** Keine Daten verlassen das Gerät.
- ✅ **Reife:** 5+ Jahre, 3000+ Sterne, in Produktion von tausenden medizinischen Apps verwendet.
- ✅ **Dokumentation:** Umfassende Beispiele für alle Anwendungsfälle.

**awesome_notifications:**

- ✅ **Vorteile:** Stärker anpassbare Benachrichtigungs-UI, Animationen, Buttons mit Icons.
- ❌ **Nachteile:**
  - **Weniger reif:** 2+ Jahre vs. 5+ von flutter_local_notifications.
  - **Gemeldete Probleme:** Issues mit geplanten Benachrichtigungen auf Android 12+ (WorkManager-Konflikte).
  - **Unnötige Komplexität:** MedicApp benötigt keine super angepassten Benachrichtigungen.
  - **Geringere Akzeptanz:** ~1500 Sterne vs. 3000+ von flutter_local_notifications.

**Firebase Cloud Messaging (FCM):**

- ✅ **Vorteile:** Unbegrenzte Benachrichtigungen, Analytics, Benutzersegmentierung.
- ❌ **Nachteile:**
  - **Erfordert Server:** Würde Backend zum Senden von Benachrichtigungen benötigen, erhöht Komplexität und Kosten.
  - **Erfordert Verbindung:** Benachrichtigungen kommen nicht an, wenn Gerät offline.
  - **Datenschutz:** Daten (Medikationszeiten, Medikamentennamen) würden an Firebase gesendet.
  - **Latenz:** Abhängig vom Netzwerk, garantiert keine exakte Zustellung zur geplanten Zeit.
  - **Begrenztes Scheduling:** FCM unterstützt kein präzises Scheduling, nur "annähernde" Zustellung mit Verzögerung.
  - **Komplexität:** Erfordert Firebase-Projekt-Setup, Server-Implementierung, Token-Verwaltung.

**Richtige Architektur für lokale medizinische Anwendungen:**

Für Apps wie MedicApp (persönliche Verwaltung, ohne Multi-Benutzer-Kollaboration, ohne Backend) sind lokale Benachrichtigungen architektonisch überlegen gegenüber Remote-Benachrichtigungen:

- **Zuverlässigkeit:** Unabhängig von Internetverbindung oder Serververfügbarkeit.
- **Datenschutz:** GDPR- und medizinische Vorschriften-konform by Design (Daten verlassen niemals Gerät).
- **Einfachheit:** Zero Backend-Konfiguration, null Serverkosten.
- **Präzision:** Garantie sekundengenaue Zustellung.

**Endergebnis:**

`flutter_local_notifications` ist die offensichtliche und richtige Wahl für MedicApp. awesome_notifications wäre Over-Engineering für UI die wir nicht brauchen, und FCM wäre architektonisch falsch für eine vollständig lokale Anwendung.

---

### 12.3. Zustandsverwaltung: Vanilla Flutter vs Provider vs BLoC vs Riverpod

**Entscheidung:** Vanilla Flutter (ohne Zustandsverwaltungsbibliothek)

**Erweiterte Begründung:**

**MedicApp-Architektur:**

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

In MedicApp **IST die Datenbank der Zustand**. Es gibt keinen signifikanten Speicherzustand, der zwischen Widgets geteilt werden muss.

**Typisches Bildschirmmuster:**

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

**Warum Provider unnötig wäre:**

Provider ist für **Teilen von Zustand zwischen entfernten Widgets im Baum** konzipiert. Klassisches Beispiel:

```dart
// Mit Provider (unnötig in MedicApp)
ChangeNotifierProvider(
  create: (_) => MedicationProvider(),
  child: MaterialApp(
    home: HomeScreen(),
  ),
)

// HomeScreen kann auf MedicationProvider zugreifen
Provider.of<MedicationProvider>(context).medications

// DetailScreen kann auch auf MedicationProvider zugreifen
Provider.of<MedicationProvider>(context).addDose(...)
```

**Problem:** In MedicApp müssen Bildschirme KEINEN Zustand im Speicher teilen. Jeder Bildschirm fragt die Datenbank direkt ab:

```dart
// Bildschirm 1: Medikamentenliste
final medications = await db.getMedications();

// Bildschirm 2: Medikamentendetail
final medication = await db.getMedication(id);

// Bildschirm 3: Dosishistorie
final history = await db.getDoseHistory(medicationId);
```

Alle erhalten Daten direkt von SQLite, die einzige Wahrheitsquelle ist. Keine Notwendigkeit für `ChangeNotifier`, `MultiProvider` oder Zustandspropagierung.

**Warum BLoC Over-Engineering wäre:**

BLoC (Business Logic Component) ist für Unternehmensanwendungen mit **komplexer Geschäftslogik** konzipiert, die **von UI getrennt** und **unabhängig getestet** werden muss.

BLoC-Architekturbeispiel:

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
  // ... mehr Events
}

// medication_event.dart (separate Events)
// medication_state.dart (separate States)
// medication_repository.dart (Datenschicht)
```

**Problem:** Dies fügt **4-5 Dateien** pro Feature und hunderte Boilerplate-Zeilen hinzu, um zu implementieren, was in Vanilla Flutter ist:

```dart
final medications = await DatabaseHelper.instance.getMedications();
setState(() {
  _medications = medications;
});
```

**Für MedicApp:**

- **Einfache Geschäftslogik:** Bestandsberechnungen (Subtraktion), Datumsberechnungen (Vergleich), String-Formatierung.
- **Keine komplexen Geschäftsregeln:** Keine Kreditkartenvalidierungen, Finanzberechnungen, OAuth-Authentifizierung usw.
- **Direktes Testing:** Services (DatabaseHelper, NotificationService) werden direkt getestet ohne Notwendigkeit von BLoC-Mocks.

**Warum Riverpod unnötig wäre:**

Riverpod ist Evolution von Provider, die einige Probleme löst (Compile-Time Safety, keine BuildContext-Abhängigkeit), ist aber aus denselben Gründen wie Provider für MedicApp unnötig.

**Fälle wo Zustandsverwaltung benötigt würde:**

1. **Anwendung mit Authentifizierung:** Benutzer-/Sitzungszustand geteilt zwischen allen Bildschirmen.
2. **Einkaufswagen:** Zustand ausgewählter Items geteilt zwischen Produkten, Warenkorb, Checkout.
3. **Echtzeit-Chat:** Eingehende Nachrichten müssen mehrere Bildschirme gleichzeitig aktualisieren.
4. **Kollaborative Anwendung:** Mehrere Benutzer bearbeiten dasselbe Dokument in Echtzeit.

**MedicApp hat KEINEN dieser Fälle.**

**Endergebnis:**

Für MedicApp ist `StatefulWidget + setState + Database as Source of Truth` die richtige Architektur. Sie ist einfach, direkt, für jeden Flutter-Entwickler verständlich und führt keine unnötige Komplexität ein.

Hinzufügen von Provider, BLoC oder Riverpod wäre rein **Cargo-Cult-Programmierung** (Technologie verwenden weil sie populär ist, nicht weil sie ein reales Problem löst).

---

## Fazit

MedicApp verwendet einen **einfachen, robusten und angemessenen** Technologie-Stack für eine lokale plattformübergreifende medizinische Anwendung:

- **Flutter + Dart:** Plattformübergreifend mit nativer Leistung.
- **SQLite:** Reife relationale Datenbank mit ACID-Transaktionen.
- **Lokale Benachrichtigungen:** Totaler Datenschutz und Offline-Funktionalität.
- **ARB-Lokalisierung:** 8 Sprachen mit Unicode CLDR Pluralisierung.
- **Vanilla Flutter:** Ohne unnötige Zustandsverwaltung.
- **432+ Tests:** 75-80% Abdeckung mit Unit-, Widget- und Integrationstests.

Jede technologische Entscheidung ist **durch reale Anforderungen begründet**, nicht durch Hype oder Trends. Das Ergebnis ist eine wartbare, zuverlässige Anwendung, die genau das tut, was sie verspricht, ohne künstliche Komplexität.

**Leitprinzip:** *"Einfachheit wenn möglich, Komplexität wenn notwendig."*
