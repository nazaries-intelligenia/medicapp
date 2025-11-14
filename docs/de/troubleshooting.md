# Fehlerbehebungshandbuch

## Einführung

### Zweck des Dokuments

Dieses Handbuch bietet Lösungen für häufige Probleme, die während der Entwicklung, Kompilierung und Verwendung von MedicApp auftreten können. Es wurde entwickelt, um Entwicklern und Benutzern zu helfen, Probleme schnell und effektiv zu lösen.

### Wie man dieses Handbuch verwendet

1. Identifizieren Sie die Kategorie Ihres Problems im Inhaltsverzeichnis
2. Lesen Sie die Problembeschreibung, um zu bestätigen, dass sie zu Ihrer Situation passt
3. Folgen Sie den Lösungsschritten in der angegebenen Reihenfolge
4. Wenn das Problem weiterhin besteht, konsultieren Sie den Abschnitt "Hilfe erhalten"

---

## Installationsprobleme

### Flutter SDK nicht gefunden

**Beschreibung**: Bei der Ausführung von Flutter-Befehlen erscheint der Fehler "flutter: command not found".

**Wahrscheinliche Ursache**: Flutter ist nicht installiert oder nicht im System-PATH.

**Lösung**:

1. Überprüfen Sie, ob Flutter installiert ist:
```bash
which flutter
```

2. Wenn nicht installiert, laden Sie Flutter von [flutter.dev](https://flutter.dev) herunter

3. Fügen Sie Flutter zum PATH hinzu:
```bash
# In ~/.bashrc, ~/.zshrc, oder ähnlich
export PATH="$PATH:/pfad/zu/flutter/bin"
```

4. Starten Sie Ihr Terminal neu und überprüfen Sie:
```bash
flutter --version
```

**Referenzen**: [Flutter-Installationsdokumentation](https://docs.flutter.dev/get-started/install)

---

### Falsche Flutter-Version

**Beschreibung**: Die installierte Flutter-Version erfüllt nicht die Projektanforderungen.

**Wahrscheinliche Ursache**: MedicApp erfordert Flutter 3.24.5 oder höher.

**Lösung**:

1. Überprüfen Sie Ihre aktuelle Version:
```bash
flutter --version
```

2. Flutter aktualisieren:
```bash
flutter upgrade
```

3. Wenn Sie eine bestimmte Version benötigen, verwenden Sie FVM:
```bash
dart pub global activate fvm
fvm install 3.24.5
fvm use 3.24.5
```

4. Überprüfen Sie die Version nach der Aktualisierung:
```bash
flutter --version
```

---

### Probleme mit flutter pub get

**Beschreibung**: Fehler beim Herunterladen von Abhängigkeiten mit `flutter pub get`.

**Wahrscheinliche Ursache**: Netzwerkprobleme, beschädigter Cache oder Versionskonflikte.

**Lösung**:

1. Pub-Cache bereinigen:
```bash
flutter pub cache repair
```

2. pubspec.lock-Datei löschen:
```bash
rm pubspec.lock
```

3. Erneut versuchen:
```bash
flutter pub get
```

4. Wenn es weiterhin besteht, Internetverbindung und Proxy überprüfen:
```bash
# Proxy bei Bedarf konfigurieren
export HTTP_PROXY=http://proxy.example.com:8080
export HTTPS_PROXY=http://proxy.example.com:8080
```

---

### CocoaPods-Probleme (iOS)

**Beschreibung**: CocoaPods-bezogene Fehler während der iOS-Kompilierung.

**Wahrscheinliche Ursache**: Veraltetes CocoaPods oder beschädigter Cache.

**Lösung**:

1. CocoaPods aktualisieren:
```bash
sudo gem install cocoapods
```

2. Pods-Cache bereinigen:
```bash
cd ios
rm -rf Pods Podfile.lock
pod cache clean --all
```

3. Pods neu installieren:
```bash
pod install --repo-update
```

4. Wenn es weiterhin besteht, Specs-Repository aktualisieren:
```bash
pod repo update
```

**Referenzen**: [CocoaPods Guides](https://guides.cocoapods.org/using/troubleshooting.html)

---

### Gradle-Probleme (Android)

**Beschreibung**: Gradle-bezogene Kompilierungsfehler bei Android.

**Wahrscheinliche Ursache**: Beschädigter Gradle-Cache oder falsche Konfiguration.

**Lösung**:

1. Projekt bereinigen:
```bash
cd android
./gradlew clean
```

2. Gradle-Cache bereinigen:
```bash
./gradlew cleanBuildCache
rm -rf ~/.gradle/caches/
```

3. Projekt synchronisieren:
```bash
./gradlew --refresh-dependencies
```

4. Cache in Android Studio invalidieren:
   - File > Invalidate Caches / Restart

---

## Kompilierungsprobleme

### Abhängigkeitsfehler

**Beschreibung**: Konflikte zwischen Paketversionen oder fehlende Abhängigkeiten.

**Wahrscheinliche Ursache**: Inkompatible Versionen in pubspec.yaml oder Konflikte mit transitiven Abhängigkeiten.

**Lösung**:

1. Überprüfen Sie pubspec.yaml auf widersprüchliche Versionsbeschränkungen

2. Verwenden Sie den Abhängigkeitsanalyse-Befehl:
```bash
flutter pub deps
```

3. Lösen Sie Konflikte, indem Sie kompatible Versionen angeben:
```yaml
dependency_overrides:
  conflicting_package: ^1.0.0
```

4. Alle Abhängigkeiten auf kompatible Versionen aktualisieren:
```bash
flutter pub upgrade --major-versions
```

---

### Versionskonflikte

**Beschreibung**: Zwei oder mehr Pakete benötigen inkompatible Versionen einer gemeinsamen Abhängigkeit.

**Wahrscheinliche Ursache**: Zu strenge Versionsbeschränkungen in Abhängigkeiten.

**Lösung**:

1. Konflikt identifizieren:
```bash
flutter pub deps | grep "✗"
```

2. Temporär `dependency_overrides` verwenden:
```yaml
dependency_overrides:
  shared_dependency: ^2.0.0
```

3. Konflikt an Paket-Maintainer melden

4. Als letzten Ausweg alternative Pakete in Betracht ziehen

---

### l10n-Generierungsfehler

**Beschreibung**: Fehler beim Generieren von Lokalisierungsdateien.

**Wahrscheinliche Ursache**: Syntaxfehler in .arb-Dateien oder falsche Konfiguration.

**Lösung**:

1. Syntax der .arb-Dateien in `lib/l10n/` überprüfen:
   - Sicherstellen, dass sie gültiges JSON sind
   - Überprüfen, dass Platzhalter konsistent sind

2. Bereinigen und neu generieren:
```bash
flutter clean
flutter pub get
flutter gen-l10n
```

3. Konfiguration in pubspec.yaml überprüfen:
```yaml
flutter:
  generate: true
```

4. `l10n.yaml` auf korrekte Konfiguration überprüfen

**Referenzen**: [Internationalisierung in Flutter](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)

---

### Android-Build fehlgeschlagen

**Beschreibung**: Android-Kompilierung schlägt mit verschiedenen Fehlern fehl.

**Wahrscheinliche Ursache**: Gradle-Konfiguration, SDK-Version oder Berechtigungsprobleme.

**Lösung**:

1. Java-Version überprüfen (benötigt Java 17):
```bash
java -version
```

2. Projekt vollständig bereinigen:
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
```

3. Konfigurationen in `android/app/build.gradle` überprüfen:
   - `compileSdkVersion`: 34
   - `minSdkVersion`: 23
   - `targetSdkVersion`: 34

4. Mit detaillierten Informationen kompilieren:
```bash
flutter build apk --verbose
```

5. Wenn der Fehler Berechtigungen erwähnt, `android/app/src/main/AndroidManifest.xml` überprüfen

---

### iOS-Build fehlgeschlagen

**Beschreibung**: iOS-Kompilierung schlägt fehl oder kann die App nicht signieren.

**Wahrscheinliche Ursache**: Zertifikate, Bereitstellungsprofile oder Xcode-Konfiguration.

**Lösung**:

1. Projekt in Xcode öffnen:
```bash
open ios/Runner.xcworkspace
```

2. Signaturkonfiguration überprüfen:
   - Runner-Projekt auswählen
   - Unter "Signing & Capabilities" Team und Bundle Identifier überprüfen

3. Xcode-Build bereinigen:
   - Product > Clean Build Folder (Shift + Cmd + K)

4. Pods aktualisieren:
```bash
cd ios
pod deintegrate
pod install
cd ..
```

5. Vom Terminal aus kompilieren:
```bash
flutter build ios --verbose
```

---

## Datenbankprobleme

### Database is Locked

**Beschreibung**: Fehler "database is locked" bei Datenbankoperationen.

**Wahrscheinliche Ursache**: Mehrere Verbindungen versuchen gleichzeitig zu schreiben oder nicht geschlossene Transaktion.

**Lösung**:

1. Sicherstellen, dass alle Verbindungen im Code korrekt geschlossen werden

2. Überprüfen, dass keine offenen Transaktionen ohne commit/rollback vorhanden sind

3. Anwendung vollständig neu starten

4. Als letzten Ausweg Datenbank löschen:
```bash
# Android
adb shell run-as com.medicapp.app rm -r /data/data/com.medicapp.app/databases/

# iOS - aus Xcode, App-Container löschen
```

**Referenzen**: Überprüfen Sie `lib/core/database/database_helper.dart` für Transaktionshandhabung.

---

### Migrationsfehler

**Beschreibung**: Fehler beim Aktualisieren des Datenbankschemas.

**Wahrscheinliche Ursache**: Falsches Migrationsskript oder inkonsistente Datenbankversion.

**Lösung**:

1. Migrationsskripte in `DatabaseHelper` überprüfen

2. Aktuelle Datenbankversion überprüfen:
```dart
final db = await DatabaseHelper.instance.database;
print('Database version: ${await db.getVersion()}');
```

3. Wenn Entwicklung, Datenbank zurücksetzen:
   - App deinstallieren
   - Neu installieren

4. Für Produktion Migrationsskript erstellen, das den spezifischen Fall behandelt

5. Debug-Bildschirm der App verwenden, um DB-Status zu überprüfen

---

### Daten werden nicht persistent gespeichert

**Beschreibung**: Eingegebene Daten verschwinden nach dem Schließen der App.

**Wahrscheinliche Ursache**: Datenbankoperationen werden nicht abgeschlossen oder schlagen stillschweigend fehl.

**Lösung**:

1. Datenbankprotokollierung im Debug-Modus aktivieren

2. Überprüfen, dass Insert/Update-Operationen Erfolg zurückgeben:
```dart
final id = await db.insert('medications', medication.toMap());
print('Inserted medication with id: $id');
```

3. Sicherstellen, dass keine stillen Exceptions vorhanden sind

4. Schreibberechtigungen auf dem Gerät überprüfen

5. Überprüfen, dass `await` bei allen async-Operationen vorhanden ist

---

### Datenbankbeschädigung

**Beschreibung**: Fehler beim Öffnen der Datenbank oder inkonsistente Daten.

**Wahrscheinliche Ursache**: Unerwartetes Schließen der App während des Schreibens oder Problem mit dem Dateisystem.

**Lösung**:

1. Versuchen Sie, die Datenbank mit dem sqlite3-Befehl zu reparieren (erfordert Root-Zugriff):
```bash
sqlite3 /pfad/zur/database.db "PRAGMA integrity_check;"
```

2. Wenn beschädigt, aus Backup wiederherstellen, falls vorhanden

3. Wenn kein Backup vorhanden, Datenbank zurücksetzen:
   - App deinstallieren
   - Neu installieren
   - Daten gehen verloren

4. **Vorbeugung**: Automatische periodische Backups implementieren

---

### Datenbank zurücksetzen

**Beschreibung**: Datenbank muss vollständig gelöscht werden, um von vorne zu beginnen.

**Wahrscheinliche Ursache**: Entwicklung, Testing oder Problemlösung.

**Lösung**:

**Option 1 - Aus der App (Development)**:
```dart
// Im Debug-Bildschirm
await DatabaseHelper.instance.deleteDatabase();
```

**Option 2 - Android**:
```bash
adb shell run-as com.medicapp.app rm /data/data/com.medicapp.app/databases/medicapp.db
```

**Option 3 - iOS**:
- App vom Gerät/Simulator deinstallieren
- Neu installieren

**Option 4 - Beide Plattformen**:
```bash
flutter clean
# Manuell vom Gerät deinstallieren
flutter run
```

---

## Benachrichtigungsprobleme

### Benachrichtigungen erscheinen nicht

**Beschreibung**: Geplante Benachrichtigungen werden nicht angezeigt.

**Wahrscheinliche Ursache**: Nicht erteilte Berechtigungen, deaktivierte Benachrichtigungen oder Fehler bei der Planung.

**Lösung**:

1. Benachrichtigungsberechtigungen überprüfen:
   - Android 13+: Muss `POST_NOTIFICATIONS` anfordern
   - iOS: Muss bei erstem Start Autorisierung anfordern

2. Gerätekonfiguration überprüfen:
   - Android: Einstellungen > Apps > MedicApp > Benachrichtigungen
   - iOS: Einstellungen > Mitteilungen > MedicApp

3. Überprüfen, dass Benachrichtigungen geplant sind:
```dart
final pendingNotifications = await flutterLocalNotificationsPlugin
    .pendingNotificationRequests();
print('Pending notifications: ${pendingNotifications.length}');
```

4. Logs auf Planungsfehler überprüfen

5. Debug-Bildschirm der App verwenden, um geplante Benachrichtigungen zu sehen

---

### Berechtigungen verweigert (Android 13+)

**Beschreibung**: Bei Android 13+ funktionieren Benachrichtigungen nicht, obwohl die App sie anfordert.

**Wahrscheinliche Ursache**: Die Berechtigung `POST_NOTIFICATIONS` wurde vom Benutzer verweigert.

**Lösung**:

1. Überprüfen, dass die Berechtigung in `AndroidManifest.xml` deklariert ist:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

2. Die App muss die Berechtigung zur Laufzeit anfordern

3. Wenn der Benutzer sie verweigert hat, zu den Einstellungen führen:
```dart
await openAppSettings();
```

4. Dem Benutzer erklären, warum Benachrichtigungen für die App wichtig sind

5. Nicht davon ausgehen, dass die Berechtigung erteilt ist; immer vor der Planung überprüfen

---

### Exakte Alarme funktionieren nicht

**Beschreibung**: Benachrichtigungen erscheinen nicht zum exakt geplanten Zeitpunkt.

**Wahrscheinliche Ursache**: Fehlende `SCHEDULE_EXACT_ALARM`-Berechtigung oder Akkubeschränkungen.

**Lösung**:

1. Berechtigungen in `AndroidManifest.xml` überprüfen:
```xml
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
```

2. Für Android 12+ Berechtigung anfordern:
```dart
if (await Permission.scheduleExactAlarm.isDenied) {
  await Permission.scheduleExactAlarm.request();
}
```

3. Akkuoptimierung für die App deaktivieren:
   - Einstellungen > Akku > Akkuoptimierung
   - MedicApp suchen und "Nicht optimieren" auswählen

4. Überprüfen, dass Sie `androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle` verwenden

---

### Benachrichtigungen ohne Ton

**Beschreibung**: Benachrichtigungen erscheinen, aber ohne Ton.

**Wahrscheinliche Ursache**: Benachrichtigungskanal ohne Ton oder Gerät im Lautlos-Modus.

**Lösung**:

1. Konfiguration des Benachrichtigungskanals überprüfen:
```dart
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'medication_reminders',
  'Recordatorios de Medicamentos',
  importance: Importance.high,
  sound: RawResourceAndroidNotificationSound('notification_sound'),
);
```

2. Sicherstellen, dass die Tondatei in `android/app/src/main/res/raw/` existiert

3. Gerätekonfiguration überprüfen:
   - Android: Einstellungen > Apps > MedicApp > Benachrichtigungen > Kategorie
   - iOS: Einstellungen > Mitteilungen > MedicApp > Töne

4. Überprüfen, dass das Gerät nicht im Lautlos-/Nicht stören-Modus ist

---

### Benachrichtigungen nach Geräteneustart

**Beschreibung**: Benachrichtigungen funktionieren nach dem Neustart des Geräts nicht mehr.

**Wahrscheinliche Ursache**: Geplante Benachrichtigungen bleiben nach dem Neustart nicht erhalten.

**Lösung**:

1. Berechtigung `RECEIVE_BOOT_COMPLETED` in `AndroidManifest.xml` hinzufügen:
```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

2. `BroadcastReceiver` implementieren, um Benachrichtigungen neu zu planen:
```xml
<receiver android:name=".BootReceiver" android:enabled="true" android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
    </intent-filter>
</receiver>
```

3. Logik zum Neuplanen aller ausstehenden Benachrichtigungen implementieren

4. Bei iOS bleiben lokale Benachrichtigungen automatisch erhalten

**Referenzen**: Überprüfen Sie `android/app/src/main/kotlin/.../MainActivity.kt`

---

## Performance-Probleme

### App langsam im Debug-Modus

**Beschreibung**: Die Anwendung hat schlechte Performance und ist langsam.

**Wahrscheinliche Ursache**: Der Debug-Modus enthält Entwicklungstools, die die Performance beeinträchtigen.

**Lösung**:

1. **Dies ist im Debug-Modus normal**. Um die tatsächliche Performance zu bewerten, im Profile- oder Release-Modus kompilieren:
```bash
flutter run --profile
# oder
flutter run --release
```

2. Flutter DevTools verwenden, um Engpässe zu identifizieren:
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

3. Überprüfen, dass keine übermäßigen `print()` Statements in Hot Paths vorhanden sind

4. Performance niemals im Debug-Modus bewerten

---

### Übermäßiger Akkuverbrauch

**Beschreibung**: Die Anwendung verbraucht viel Akku.

**Wahrscheinliche Ursache**: Übermäßige Verwendung von Benachrichtigungen, Hintergrundaufgaben oder häufigen Abfragen.

**Lösung**:

1. Häufigkeit von Hintergrundprüfungen reduzieren

2. Datenbankabfragen optimieren:
   - Geeignete Indizes verwenden
   - Unnötige Abfragen vermeiden
   - Ergebnisse bei Bedarf cachen

3. `WorkManager` statt häufiger Alarme verwenden, wenn angemessen

4. Verwendung von Sensoren oder GPS überprüfen (falls zutreffend)

5. Akkuverbrauch mit Android Studio profilieren:
   - View > Tool Windows > Energy Profiler

---

### Lag in langen Listen

**Beschreibung**: Scrollen in Listen mit vielen Elementen ist langsam oder ruckelig.

**Wahrscheinliche Ursache**: Ineffizientes Widget-Rendering oder fehlende ListView-Optimierung.

**Lösung**:

1. `ListView.builder` statt `ListView` verwenden:
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

2. `const` Konstruktoren wo möglich implementieren

3. Schwere Widgets in jedem Listenelement vermeiden

4. `RepaintBoundary` für komplexe Widgets verwenden:
```dart
RepaintBoundary(
  child: ComplexWidget(),
)
```

5. Paginierung für sehr lange Listen in Betracht ziehen

6. `AutomaticKeepAliveClientMixin` verwenden, um Elementzustand zu erhalten

---

### Übersprungene Frames

**Beschreibung**: Die UI fühlt sich ruckelig an mit verlorenen Frames.

**Wahrscheinliche Ursache**: Teure Operationen im Haupt-Thread.

**Lösung**:

1. Problem mit Flutter DevTools Performance Tab identifizieren

2. Teure Operationen in Isolates verschieben:
```dart
final result = await compute(expensiveFunction, data);
```

3. Schwere synchrone Operationen in der Build-Methode vermeiden

4. `FutureBuilder` oder `StreamBuilder` für async-Operationen verwenden

5. Große Bilder optimieren:
   - Komprimierte Formate verwenden
   - Dekodierte Bilder cachen
   - Thumbnails für Vorschauen verwenden

6. Überprüfen, dass keine Animationen mit teuren Listenern vorhanden sind

---

## UI/UX-Probleme

### Text wird nicht übersetzt

**Beschreibung**: Einige Texte erscheinen auf Englisch oder in einer falschen Sprache.

**Wahrscheinliche Ursache**: String fehlt in der .arb-Datei oder AppLocalizations wird nicht verwendet.

**Lösung**:

1. Überprüfen, dass der String in `lib/l10n/app_es.arb` existiert:
```json
{
  "yourKey": "Tu texto traducido"
}
```

2. Sicherstellen, dass `AppLocalizations.of(context)` verwendet wird:
```dart
Text(AppLocalizations.of(context)!.yourKey)
```

3. Lokalisierungsdateien neu generieren:
```bash
flutter gen-l10n
```

4. Wenn Sie einen neuen Schlüssel hinzugefügt haben, sicherstellen, dass er in allen .arb-Dateien existiert

5. Überprüfen, dass das Geräte-Locale korrekt konfiguriert ist

---

### Falsche Farben

**Beschreibung**: Farben stimmen nicht mit dem Design oder erwarteten Theme überein.

**Wahrscheinliche Ursache**: Falsche Verwendung des Themes oder hardcodierte Farben.

**Lösung**:

1. Immer Theme-Farben verwenden:
```dart
// Richtig
color: Theme.of(context).colorScheme.primary

// Falsch
color: Colors.blue
```

2. Theme-Definition in `lib/core/theme/app_theme.dart` überprüfen

3. Sicherstellen, dass MaterialApp das Theme konfiguriert hat:
```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  // ...
)
```

4. Für Debugging aktuelle Farben ausgeben:
```dart
print('Primary: ${Theme.of(context).colorScheme.primary}');
```

---

### Kaputtes Layout auf kleinen Bildschirmen

**Beschreibung**: Die UI läuft über oder sieht auf Geräten mit kleinen Bildschirmen schlecht aus.

**Wahrscheinliche Ursache**: Widgets mit festen Größen oder fehlendes responsives Design.

**Lösung**:

1. Flexible Widgets statt fester Größen verwenden:
```dart
// Anstatt
Container(width: 300, child: ...)

// Verwenden
Expanded(child: ...)
// oder
Flexible(child: ...)
```

2. `LayoutBuilder` für adaptive Layouts verwenden:
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

3. `MediaQuery` verwenden, um Dimensionen zu erhalten:
```dart
final screenWidth = MediaQuery.of(context).size.width;
```

4. In verschiedenen Bildschirmgrößen mit dem Emulator testen

---

### Text-Overflow

**Beschreibung**: Overflow-Warnung erscheint mit gelben und schwarzen Streifen.

**Wahrscheinliche Ursache**: Text zu lang für verfügbaren Platz.

**Lösung**:

1. Text in `Flexible` oder `Expanded` einwickeln:
```dart
Flexible(
  child: Text('Texto largo...'),
)
```

2. `overflow` und `maxLines` im Text-Widget verwenden:
```dart
Text(
  'Texto largo...',
  overflow: TextOverflow.ellipsis,
  maxLines: 2,
)
```

3. Für sehr lange Texte `SingleChildScrollView` verwenden:
```dart
SingleChildScrollView(
  child: Text('Texto muy largo...'),
)
```

4. Text kürzen oder anderes Format verwenden in Betracht ziehen

---

## Multi-Personen-Probleme

### Bestand wird nicht korrekt geteilt

**Beschreibung**: Mehrere Personen können Medikamente mit demselben Namen erstellen, ohne Bestand zu teilen.

**Wahrscheinliche Ursache**: Duplikatsprüfungslogik pro Person statt global.

**Lösung**:

1. Funktion zur Suche vorhandener Medikamente in `MedicationRepository` überprüfen

2. Sicherstellen, dass die Suche global ist:
```dart
// Nach Namen suchen ohne nach personId zu filtern
final existing = await db.query(
  'medications',
  where: 'name = ?',
  whereArgs: [name],
);
```

3. Beim Hinzufügen einer Dosis die Dosis mit der Person verknüpfen, aber nicht das Medikament

4. Logik in `AddMedicationScreen` überprüfen, um vorhandene Medikamente wiederzuverwenden

---

### Duplizierte Medikamente

**Beschreibung**: Duplizierte Medikamente erscheinen in der Liste.

**Wahrscheinliche Ursache**: Mehrfache Einfügungen desselben Medikaments oder fehlende Validierung.

**Lösung**:

1. Überprüfung vor dem Einfügen implementieren:
```dart
final existing = await getMedicationByName(name);
if (existing != null) {
  return existing.id;
}
```

2. UNIQUE-Beschränkungen in der Datenbank verwenden:
```sql
CREATE TABLE medications (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  -- ...
);
```

3. Logik zur Medikamentenerstellung im Repository überprüfen

4. Wenn bereits Duplikate vorhanden sind, Migrationsskript zum Konsolidieren erstellen

---

### Falscher Dosisverlauf

**Beschreibung**: Der Verlauf zeigt Dosen anderer Personen oder fehlende Informationen.

**Wahrscheinliche Ursache**: Falsche Filterung nach Person oder falsch konfigurierte Joins.

**Lösung**:

1. Query überprüfen, die den Verlauf abruft:
```dart
final doses = await db.query(
  'dose_history',
  where: 'personId = ?',
  whereArgs: [personId],
  orderBy: 'takenAt DESC',
);
```

2. Sicherstellen, dass alle Dosen eine zugehörige `personId` haben

3. Filterlogik in `DoseHistoryScreen` überprüfen

4. Überprüfen, dass Joins zwischen Tabellen die Personenbedingung einschließen

---

### Standardperson ändert sich nicht

**Beschreibung**: Beim Ändern der aktiven Person wird die UI nicht korrekt aktualisiert.

**Wahrscheinliche Ursache**: Zustand wird nicht korrekt weitergegeben oder fehlendes Rebuild.

**Lösung**:

1. Überprüfen, dass Sie einen globalen Zustand verwenden (Provider, Bloc, etc.):
```dart
Provider.of<PersonProvider>(context, listen: true).currentPerson
```

2. Sicherstellen, dass Personenwechsel `notifyListeners()` auslöst:
```dart
void setCurrentPerson(Person person) {
  _currentPerson = person;
  notifyListeners();
}
```

3. Überprüfen, dass relevante Widgets auf Änderungen hören

4. `Consumer` für spezifische Rebuilds in Betracht ziehen:
```dart
Consumer<PersonProvider>(
  builder: (context, provider, child) {
    return Text(provider.currentPerson.name);
  },
)
```

---

## Fastenprobleme

### Fastenbenachrichtigung erscheint nicht

**Beschreibung**: Die Ongoing-Fastenbenachrichtigung wird nicht angezeigt.

**Wahrscheinliche Ursache**: Berechtigungen, Kanalkonfiguration oder Fehler beim Erstellen der Benachrichtigung.

**Lösung**:

1. Überprüfen, dass der Fastenbenachrichtigungskanal erstellt ist:
```dart
const AndroidNotificationChannel fastingChannel = AndroidNotificationChannel(
  'fasting',
  'Ayuno',
  importance: Importance.low,
  enableVibration: false,
);
```

2. Sicherstellen, dass `ongoing: true` verwendet wird:
```dart
const NotificationDetails(
  android: AndroidNotificationDetails(
    'fasting',
    'Ayuno',
    ongoing: true,
    autoCancel: false,
  ),
)
```

3. Benachrichtigungsberechtigungen überprüfen

4. Logs auf Fehler beim Erstellen der Benachrichtigung überprüfen

---

### Falscher Countdown

**Beschreibung**: Die verbleibende Fastenzeit ist nicht korrekt oder wird nicht aktualisiert.

**Wahrscheinliche Ursache**: Falsche Zeitberechnung oder fehlende periodische Aktualisierung.

**Lösung**:

1. Berechnung der verbleibenden Zeit überprüfen:
```dart
final remaining = endTime.difference(DateTime.now());
```

2. Sicherstellen, dass die Benachrichtigung periodisch aktualisiert wird:
```dart
Timer.periodic(Duration(minutes: 1), (timer) {
  updateFastingNotification();
});
```

3. Überprüfen, dass die `endTime` des Fastens korrekt gespeichert wird

4. Debug-Bildschirm verwenden, um den aktuellen Fastenstatus zu überprüfen

---

### Fasten wird nicht automatisch abgebrochen

**Beschreibung**: Die Fastenbenachrichtigung bleibt bestehen, nachdem die Zeit abgelaufen ist.

**Wahrscheinliche Ursache**: Fehlende Logik zum Abbrechen der Benachrichtigung bei Abschluss.

**Lösung**:

1. Überprüfung implementieren, wenn das Fasten endet:
```dart
if (DateTime.now().isAfter(fasting.endTime)) {
  await cancelFastingNotification();
  await markFastingAsCompleted(fasting.id);
}
```

2. Überprüfen, wenn die App geöffnet wird:
```dart
@override
void initState() {
  super.initState();
  checkActiveFastings();
}
```

3. Alarm planen, wenn das Fasten endet, der die Benachrichtigung abbricht

4. Sicherstellen, dass die Benachrichtigung in `onDidReceiveNotificationResponse` abgebrochen wird

**Referenzen**: Überprüfen Sie `lib/features/fasting/` für die Implementierung.

---

## Testing-Probleme

### Tests schlagen lokal fehl

**Beschreibung**: Tests, die in CI bestehen, schlagen auf Ihrem lokalen Rechner fehl.

**Wahrscheinliche Ursache**: Umgebungsunterschiede, Abhängigkeiten oder Konfiguration.

**Lösung**:

1. Bereinigen und neu aufbauen:
```bash
flutter clean
flutter pub get
```

2. Überprüfen, dass die Versionen dieselben sind:
```bash
flutter --version
dart --version
```

3. Tests mit mehr Informationen ausführen:
```bash
flutter test --verbose
```

4. Sicherstellen, dass keine Tests von vorherigem Zustand abhängen

5. Überprüfen, dass keine Tests mit Zeitabhängigkeiten vorhanden sind (verwenden Sie `fakeAsync`)

---

### Probleme mit sqflite_common_ffi

**Beschreibung**: Datenbanktests schlagen mit sqflite-Fehlern fehl.

**Wahrscheinliche Ursache**: sqflite ist in Tests nicht verfügbar, Sie müssen sqflite_common_ffi verwenden.

**Lösung**:

1. Sicherstellen, dass Sie die Abhängigkeit haben:
```yaml
dev_dependencies:
  sqflite_common_ffi: ^2.3.0
```

2. Im Test-Setup initialisieren:
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

3. In-Memory-Datenbanken für Tests verwenden:
```dart
final db = await databaseFactoryFfi.openDatabase(
  inMemoryDatabasePath,
);
```

4. Datenbank nach jedem Test bereinigen

---

### Timeouts in Tests

**Beschreibung**: Tests schlagen aufgrund von Timeout fehl.

**Wahrscheinliche Ursache**: Langsame Operationen oder Deadlocks in async-Tests.

**Lösung**:

1. Timeout für spezifische Tests erhöhen:
```dart
test('slow test', () async {
  // ...
}, timeout: Timeout(Duration(seconds: 30)));
```

2. Überprüfen, dass keine fehlenden `await` vorhanden sind

3. `fakeAsync` für Tests mit Verzögerungen verwenden:
```dart
testWidgets('timer test', (tester) async {
  await tester.runAsync(() async {
    // Testcode mit Verzögerungen
  });
});
```

4. Langsame Operationen wie Netzwerkaufrufe mocken

5. Überprüfen, dass keine Endlosschleifen oder Race Conditions vorhanden sind

---

### Inkonsistente Tests

**Beschreibung**: Dieselben Tests bestehen manchmal und schlagen manchmal fehl.

**Wahrscheinliche Ursache**: Tests mit Zeitabhängigkeiten, Ausführungsreihenfolge oder gemeinsamen Zustand.

**Lösung**:

1. Nicht von echter Zeit abhängen, verwenden Sie `fakeAsync` oder Mocks

2. Sicherstellen, dass jeder Test unabhängig ist:
```dart
setUp(() {
  // Sauberes Setup für jeden Test
});

tearDown(() {
  // Bereinigung nach jedem Test
});
```

3. Keinen veränderlichen Zustand zwischen Tests teilen

4. `setUpAll` nur für unveränderliches Setup verwenden

5. Tests in zufälliger Reihenfolge ausführen, um Abhängigkeiten zu erkennen:
```bash
flutter test --test-randomize-ordering-seed=random
```

---

## Berechtigungsprobleme

### POST_NOTIFICATIONS (Android 13+)

**Beschreibung**: Benachrichtigungen funktionieren nicht auf Android 13 oder höher.

**Wahrscheinliche Ursache**: Die POST_NOTIFICATIONS-Berechtigung muss zur Laufzeit angefordert werden.

**Lösung**:

1. Berechtigung in `AndroidManifest.xml` deklarieren:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

2. Berechtigung zur Laufzeit anfordern:
```dart
if (Platform.isAndroid && await Permission.notification.isDenied) {
  final status = await Permission.notification.request();
  if (status.isDenied) {
    // Benutzer informieren und anbieten, zu Einstellungen zu gehen
  }
}
```

3. Berechtigung vor der Planung von Benachrichtigungen überprüfen

4. Benutzer zu Einstellungen führen, wenn dauerhaft verweigert

**Referenzen**: [Android 13 Notification Permission](https://developer.android.com/about/versions/13/changes/notification-permission)

---

### SCHEDULE_EXACT_ALARM (Android 12+)

**Beschreibung**: Exakte Alarme funktionieren nicht auf Android 12+.

**Wahrscheinliche Ursache**: Erfordert spezielle Berechtigung seit Android 12.

**Lösung**:

1. Berechtigung deklarieren:
```xml
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
```

2. Bei Bedarf überprüfen und anfordern:
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

3. Dem Benutzer erklären, warum Sie exakte Alarme benötigen

4. `USE_EXACT_ALARM` in Betracht ziehen, wenn Sie eine Alarm-/Erinnerungs-App sind

---

### USE_EXACT_ALARM (Android 14+)

**Beschreibung**: Sie benötigen exakte Alarme ohne spezielle Berechtigungsanfrage.

**Wahrscheinliche Ursache**: Android 14 führt USE_EXACT_ALARM für Alarm-Apps ein.

**Lösung**:

1. Wenn Ihre App hauptsächlich für Alarme/Erinnerungen ist, verwenden:
```xml
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
```

2. Dies ist eine Alternative zu `SCHEDULE_EXACT_ALARM`, die nicht erfordert, dass der Benutzer die Berechtigung manuell erteilt

3. Nur verwenden, wenn Ihre App die [erlaubten Anwendungsfälle](https://developer.android.com/about/versions/14/changes/schedule-exact-alarms) erfüllt

4. Die App muss Alarme oder Erinnerungen als Hauptfunktion haben

---

### Benachrichtigungen im Hintergrund (iOS)

**Beschreibung**: Benachrichtigungen funktionieren nicht richtig auf iOS.

**Wahrscheinliche Ursache**: Nicht angeforderte Berechtigungen oder falsche Konfiguration.

**Lösung**:

1. Berechtigungen beim Start der App anfordern:
```dart
final settings = await FirebaseMessaging.instance.requestPermission(
  alert: true,
  badge: true,
  sound: true,
);
```

2. `Info.plist` überprüfen:
```xml
<key>UIBackgroundModes</key>
<array>
  <string>fetch</string>
  <string>remote-notification</string>
</array>
```

3. Sicherstellen, dass Sie die richtigen Capabilities in Xcode haben:
   - Push Notifications
   - Background Modes

4. Überprüfen, dass der Benutzer Benachrichtigungen in den Einstellungen nicht deaktiviert hat

---

## Häufige Fehler und Lösungen

### MissingPluginException

**Beschreibung**: Fehler "MissingPluginException(No implementation found for method...)"

**Wahrscheinliche Ursache**: Plugin nicht korrekt registriert oder Hot Restart erforderlich.

**Lösung**:

1. Vollständigen Hot Restart durchführen (nicht nur Hot Reload):
```bash
# Im Terminal, wo die App läuft
r  # hot reload
R  # HOT RESTART (das brauchen Sie)
```

2. Wenn es weiterhin besteht, vollständig neu aufbauen:
```bash
flutter clean
flutter pub get
flutter run
```

3. Überprüfen, dass das Plugin in `pubspec.yaml` ist

4. Für iOS Pods neu installieren:
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
```

---

### PlatformException

**Beschreibung**: Fehler "PlatformException" mit verschiedenen Codes.

**Wahrscheinliche Ursache**: Hängt vom spezifischen Fehlercode ab.

**Lösung**:

1. Vollständige Fehlermeldung und Code lesen

2. Häufige Fehler:
   - `permission_denied`: Berechtigungen überprüfen
   - `error`: Generischer Fehler, native Logs überprüfen
   - `not_available`: Funktion auf dieser Plattform nicht verfügbar

3. Für Android logcat überprüfen:
```bash
adb logcat | grep -i flutter
```

4. Für iOS Xcode-Konsole überprüfen

5. Sicherstellen, dass diese Fehler gracefully behandelt werden:
```dart
try {
  await somePluginMethod();
} on PlatformException catch (e) {
  print('Error: ${e.code} - ${e.message}');
  // Angemessen behandeln
}
```

---

### DatabaseException

**Beschreibung**: Fehler bei Datenbankoperationen.

**Wahrscheinliche Ursache**: Ungültige Query, verletzte Beschränkung oder beschädigte Datenbank.

**Lösung**:

1. Vollständige Fehlermeldung lesen, um das Problem zu identifizieren

2. Häufige Fehler:
   - `UNIQUE constraint failed`: Versucht, Duplikat einzufügen
   - `no such table`: Tabelle existiert nicht, Migrationen überprüfen
   - `syntax error`: Ungültige SQL-Query

3. SQL-Query überprüfen:
```dart
try {
  await db.query('medications', where: 'id = ?', whereArgs: [id]);
} on DatabaseException catch (e) {
  print('Database error: ${e.toString()}');
}
```

4. Sicherstellen, dass Migrationen ausgeführt wurden

5. Als letzten Ausweg Datenbank zurücksetzen

---

### StateError

**Beschreibung**: Fehler "Bad state: No element" oder ähnlich.

**Wahrscheinliche Ursache**: Versuch, auf ein nicht existierendes Element zuzugreifen.

**Lösung**:

1. Exakte Zeile des Fehlers im Stack Trace identifizieren

2. Sichere Methoden verwenden:
```dart
// Anstatt
final item = list.first;  // Wirft StateError, wenn leer

// Verwenden
final item = list.isNotEmpty ? list.first : null;
// oder
final item = list.firstOrNull;  // Dart 3.0+
```

3. Immer vor Zugriff überprüfen:
```dart
if (list.isNotEmpty) {
  final item = list.first;
  // item verwenden
}
```

4. Try-catch bei Bedarf verwenden:
```dart
try {
  final item = list.single;
} on StateError {
  // Fall behandeln, wo es nicht genau ein Element gibt
}
```

---

### Null Check Operator Used on Null Value

**Beschreibung**: Fehler bei Verwendung des `!`-Operators auf einem Null-Wert.

**Wahrscheinliche Ursache**: Nullable Variable mit `!` verwendet, wenn ihr Wert null ist.

**Lösung**:

1. Exakte Zeile im Stack Trace identifizieren

2. Wert vor Verwendung von `!` überprüfen:
```dart
// Anstatt
final value = nullableValue!;

// Verwenden
if (nullableValue != null) {
  final value = nullableValue;
  // value verwenden
}
```

3. `??`-Operator für Standardwerte verwenden:
```dart
final value = nullableValue ?? defaultValue;
```

4. `?.`-Operator für sicheren Zugriff verwenden:
```dart
final length = nullableString?.length;
```

5. Überprüfen, warum der Wert null ist, wenn er es nicht sein sollte

---

## Logs und Debugging

### Logs aktivieren

**Beschreibung**: Sie müssen detaillierte Logs zum Debuggen eines Problems sehen.

**Lösung**:

1. **Flutter-Logs**:
```bash
flutter run --verbose
```

2. **Nur App-Logs**:
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

3. **Native Android-Logs**:
```bash
adb logcat | grep -i flutter
# oder für alles
adb logcat
```

4. **Native iOS-Logs**:
   - Console.app auf macOS öffnen
   - Ihr Gerät/Simulator auswählen
   - Nach "flutter" oder Ihrer Bundle-ID filtern

---

### Benachrichtigungs-Logs

**Beschreibung**: Sie müssen Logs im Zusammenhang mit Benachrichtigungen sehen.

**Lösung**:

1. Logs im Benachrichtigungscode hinzufügen:
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

2. Ausstehende Benachrichtigungen auflisten:
```dart
final pending = await flutterLocalNotificationsPlugin
    .pendingNotificationRequests();
for (var notification in pending) {
  print('Pending: ${notification.id} - ${notification.title}');
}
```

3. System-Logs überprüfen:
   - Android: `adb logcat | grep -i notification`
   - iOS: Console.app mit Filter "notification"

---

### Datenbank-Logs

**Beschreibung**: Sie müssen die ausgeführten Datenbank-Queries sehen.

**Wahrscheinliche Ursache**: Logging in sqflite aktivieren:

**Lösung**:

1. Logging in sqflite aktivieren:
```dart
import 'package:sqflite/sqflite.dart';

void main() {
  Sqflite.setDebugModeOn(true);
  runApp(MyApp());
}
```

2. Logs in Ihren Queries hinzufügen:
```dart
print('Executing query: SELECT * FROM medications WHERE id = $id');
final result = await db.query('medications', where: 'id = ?', whereArgs: [id]);
print('Query returned ${result.length} rows');
```

3. Wrapper für automatisches Logging:
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

### Debugger verwenden

**Beschreibung**: Sie müssen die Ausführung pausieren und den Zustand untersuchen.

**Lösung**:

1. **In VS Code**:
   - Breakpoint setzen, indem Sie neben die Zeilennummer klicken
   - Im Debug-Modus ausführen (F5)
   - Wenn pausiert, Debug-Steuerelemente verwenden

2. **In Android Studio**:
   - Breakpoint setzen, indem Sie in den Rand klicken
   - Debug ausführen (Shift + F9)
   - Debug-Panel zum Durchlaufen verwenden

3. **Programmatischer Debugger**:
```dart
import 'dart:developer';

void someFunction() {
  debugger();  // Hier pausieren, wenn Debugger verbunden
  // Code...
}
```

4. **Variablen inspizieren**:
```dart
print('Value: $value');  // Einfaches Logging
debugPrint('Value: $value');  // Logging, das Rate Limits respektiert
```

---

### Debug-Bildschirm der App

**Beschreibung**: MedicApp enthält einen nützlichen Debug-Bildschirm.

**Lösung**:

1. Auf Debug-Bildschirm vom Einstellungsmenü zugreifen

2. Verfügbare Funktionen:
   - Datenbank anzeigen (Tabellen, Zeilen, Inhalt)
   - Geplante Benachrichtigungen anzeigen
   - Systemstatus anzeigen
   - Benachrichtigungsaktualisierung erzwingen
   - Datenbank bereinigen
   - Aktuelle Logs anzeigen

3. Diesen Bildschirm verwenden für:
   - Überprüfen, dass Daten korrekt gespeichert werden
   - Ausstehende Benachrichtigungen überprüfen
   - Zustandsprobleme identifizieren

4. Nur im Debug-Modus verfügbar

---

## Anwendung zurücksetzen

### App-Daten bereinigen

**Beschreibung**: Alle Daten löschen, ohne zu deinstallieren.

**Lösung**:

**Android**:
```bash
adb shell pm clear com.medicapp.app
```

**iOS**:
- Einstellungen > Allgemein > iPhone-Speicher
- MedicApp suchen
- "App löschen" (nicht "App auslagern")

**Aus der App** (nur Debug):
- Debug-Bildschirm verwenden
- "Reset Database"

---

### Deinstallieren und neu installieren

**Beschreibung**: Vollständige saubere Installation.

**Lösung**:

**Android**:
```bash
adb uninstall com.medicapp.app
flutter run
```

**iOS**:
```bash
# Vom Gerät/Simulator aus, Icon gedrückt halten
# "App löschen" auswählen
flutter run
```

**Aus Flutter**:
```bash
flutter clean
rm -rf build/
flutter run
```

---

### Datenbank zurücksetzen

**Beschreibung**: Nur die Datenbank löschen, App behalten.

**Lösung**:

**Aus Code** (nur Debug):
```dart
await DatabaseHelper.instance.deleteDatabase();
```

**Android - Manuell**:
```bash
adb shell
run-as com.medicapp.app
cd databases
rm medicapp.db medicapp.db-shm medicapp.db-wal
exit
```

**iOS - Manuell**:
- Benötigt Zugriff auf App-Container
- Einfacher zu deinstallieren und neu zu installieren

---

### Flutter-Cache bereinigen

**Beschreibung**: Kompilierungsprobleme im Zusammenhang mit Cache lösen.

**Lösung**:

1. Grundlegende Bereinigung:
```bash
flutter clean
```

2. Vollständige Bereinigung:
```bash
flutter clean
rm -rf build/
rm -rf .dart_tool/
rm pubspec.lock
flutter pub get
```

3. Pub-Cache bereinigen:
```bash
flutter pub cache repair
```

4. Gradle-Cache bereinigen (Android):
```bash
cd android
./gradlew clean cleanBuildCache
rm -rf ~/.gradle/caches/
cd ..
```

5. Pods-Cache bereinigen (iOS):
```bash
cd ios
rm -rf Pods Podfile.lock
pod cache clean --all
pod install
cd ..
```

---

## Bekannte Probleme

### Liste bekannter Bugs

1. **Benachrichtigungen bleiben nach Neustart auf einigen Android-Geräten nicht erhalten**
   - Betrifft: Android 12+ mit aggressiver Akkuoptimierung
   - Workaround: Akkuoptimierung für MedicApp deaktivieren

2. **Layout-Overflow auf sehr kleinen Bildschirmen (<5")**
   - Betrifft: Geräte mit Breite < 320dp
   - Status: Fix für v1.1.0 geplant

3. **Ruckelige Übergangsanimation auf Low-End-Geräten**
   - Betrifft: Geräte mit <2GB RAM
   - Workaround: Animationen in Einstellungen deaktivieren

4. **Datenbank kann unbegrenzt wachsen**
   - Betrifft: Benutzer mit viel Historie (>1 Jahr)
   - Workaround: Periodische Bereinigung alter Historie implementieren
   - Status: Automatisches Archivierungs-Feature geplant

---

### Temporäre Workarounds

1. **Wenn Benachrichtigungen auf einigen Geräten nicht klingen**:
```dart
// Temporär maximale Wichtigkeit verwenden
importance: Importance.max,
priority: Priority.high,
```

2. **Wenn Lag in langen Listen**:
   - Sichtbare Historie auf letzte 30 Tage begrenzen
   - Manuelle Paginierung implementieren

3. **Wenn Datenbank häufig blockiert**:
   - Gleichzeitige Operationen reduzieren
   - Batch-Transaktionen für mehrere Inserts verwenden

---

### Issues auf GitHub

**Wie man nach vorhandenen Issues sucht**:

1. Gehen Sie zu: https://github.com/ihr-benutzer/medicapp/issues

2. Filter verwenden:
   - `is:issue is:open` - Offene Issues
   - `label:bug` - Nur Bugs
   - `label:enhancement` - Angeforderte Features

3. Nach Schlüsselwörtern suchen: "notification", "database", etc.

**Bevor Sie ein neues Issue erstellen**:
- Suchen, ob bereits ein ähnliches existiert
- Liste bekannter Probleme oben überprüfen
- Sicherstellen, dass es nicht in der neuesten Version gelöst ist

---

## Hilfe erhalten

### Dokumentation überprüfen

**Verfügbare Ressourcen**:

1. **Projektdokumentation**:
   - `README.md` - Allgemeine Informationen und Setup
   - `docs/es/ARCHITECTURE.md` - Projektarchitektur
   - `docs/es/CONTRIBUTING.md` - Beitragsleitfaden
   - `docs/es/TESTING.md` - Testing-Leitfaden

2. **Flutter-Dokumentation**:
   - [flutter.dev/docs](https://flutter.dev/docs)
   - [api.flutter.dev](https://api.flutter.dev)

3. **Paket-Dokumentation**:
   - Pub.dev für jede Abhängigkeit überprüfen
   - README und Changelog jedes Pakets lesen

---

### In GitHub Issues suchen

**Wie man effektiv sucht**:

1. Erweiterte Suche verwenden:
```
repo:ihr-benutzer/medicapp is:issue [Schlüsselwörter]
```

2. Auch geschlossene Issues durchsuchen:
```
is:issue is:closed notification not working
```

3. Nach Labels suchen:
```
label:bug label:android label:notifications
```

4. In Kommentaren suchen:
```
commenter:username [Schlüsselwörter]
```

---

### Neues Issue mit Template erstellen

**Bevor Sie ein Issue erstellen**:

1. Bestätigen, dass es wirklich ein gültiger Bug oder Feature Request ist
2. Nach duplizierten Issues suchen
3. Alle notwendigen Informationen sammeln

**Notwendige Informationen**:

**Für Bugs**:
- Klare Problembeschreibung
- Schritte zur Reproduktion
- Erwartetes vs. tatsächliches Verhalten
- Screenshots/Videos falls zutreffend
- Umgebungsinformationen (siehe unten)
- Relevante Logs

**Für Features**:
- Funktionalitätsbeschreibung
- Anwendungsfall und Vorteile
- Implementierungsvorschlag (optional)
- Mockups oder Beispiele (optional)

**Issue-Template**:
```markdown
## Beschreibung
[Klare und prägnante Problembeschreibung]

## Schritte zur Reproduktion
1. [Erster Schritt]
2. [Zweiter Schritt]
3. [Dritter Schritt]

## Erwartetes Verhalten
[Was sollte passieren]

## Tatsächliches Verhalten
[Was tatsächlich passiert]

## Umgebungsinformationen
- OS: [Android 13 / iOS 16.5]
- Gerät: [Spezifisches Modell]
- MedicApp-Version: [v1.0.0]
- Flutter-Version: [3.24.5]

## Logs
```
[Relevante Logs]
```

## Screenshots
[Falls zutreffend]

## Zusätzliche Informationen
[Jeder andere Kontext]
```

---

### Notwendige Informationen zum Melden

**Immer einschließen**:

1. **App-Version**:
```dart
// Aus pubspec.yaml
version: 1.0.0+1
```

2. **Geräteinformationen**:
```dart
import 'package:device_info_plus/device_info_plus.dart';

final deviceInfo = DeviceInfoPlugin();
if (Platform.isAndroid) {
  final androidInfo = await deviceInfo.androidInfo;
  print('Android ${androidInfo.version.sdkInt}');
  print('Model: ${androidInfo.model}');
}
```

3. **Flutter-Version**:
```bash
flutter --version
```

4. **Vollständige Logs**:
```bash
flutter run --verbose > logs.txt 2>&1
# logs.txt an Issue anhängen
```

5. **Vollständiger Stack Trace** falls Crash

6. **Screenshots oder Videos**, die das Problem zeigen

---

## Fazit

Dieses Handbuch deckt die häufigsten Probleme in MedicApp ab. Wenn Sie ein nicht aufgeführtes Problem finden:

1. Vollständige Projektdokumentation überprüfen
2. In GitHub Issues suchen
3. In Repository-Diskussionen fragen
4. Neues Issue mit allen notwendigen Informationen erstellen

**Denken Sie daran**: Detaillierte Informationen und Reproduktionsschritte bereitzustellen macht es viel einfacher, Ihr Problem schnell zu lösen.

Um Verbesserungen an diesem Leitfaden beizutragen, öffnen Sie bitte einen PR oder ein Issue im Repository.

---

**Letzte Aktualisierung**: 2025-11-14
**Dokumentversion**: 1.0.0
