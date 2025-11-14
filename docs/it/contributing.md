# Guida alla Contribuzione

Grazie per il tuo interesse nel contribuire a **MedicApp**. Questa guida ti aiuterà a realizzare contributi di qualità che beneficino tutta la comunità.

---

## Indice

- [Benvenuto](#benvenuto)
- [Come Contribuire](#come-contribuire)
- [Processo di Contribuzione](#processo-di-contribuzione)
- [Convenzioni di Codice](#convenzioni-di-codice)
- [Convenzioni dei Commit](#convenzioni-dei-commit)
- [Guida Pull Request](#guida-pull-request)
- [Guida Testing](#guida-testing)
- [Aggiungere Nuove Funzionalità](#aggiungere-nuove-funzionalità)
- [Segnalare Bug](#segnalare-bug)
- [Aggiungere Traduzioni](#aggiungere-traduzioni)
- [Configurazione Ambiente di Sviluppo](#configurazione-ambiente-di-sviluppo)
- [Risorse Utili](#risorse-utili)
- [Domande Frequenti](#domande-frequenti)
- [Contatto e Comunità](#contatto-e-comunità)

---

## Benvenuto

Siamo lieti che tu voglia contribuire a MedicApp. Questo progetto è possibile grazie a persone come te che dedicano il loro tempo e conoscenza per migliorare la salute e il benessere degli utenti in tutto il mondo.

### Tipi di Contributi Benvenuti

Valorizziamo ogni tipo di contributo:

- **Codice**: Nuove funzionalità, correzioni bug, miglioramenti prestazioni
- **Documentazione**: Miglioramenti documentazione esistente, nuove guide, tutorial
- **Traduzioni**: Aggiungere o migliorare traduzioni nelle 8 lingue supportate
- **Testing**: Aggiungere test, migliorare copertura, segnalare bug
- **Design**: Miglioramenti UI/UX, icone, asset
- **Idee**: Suggerimenti miglioramenti, discussioni su architettura
- **Revisione**: Rivedere PR di altri contributori

### Codice di Condotta

Questo progetto aderisce a un codice di condotta di rispetto reciproco:

- **Essere rispettosi**: Tratta tutti con rispetto e considerazione
- **Essere costruttivo**: Le critiche devono essere costruttive e orientate al miglioramento
- **Essere inclusivo**: Promuovi un ambiente accogliente per persone di tutti i background
- **Essere professionale**: Mantieni le discussioni focalizzate sul progetto
- **Essere collaborativo**: Lavora in team e condividi conoscenza

Qualsiasi comportamento inappropriato può essere segnalato ai mantenitori del progetto.

---

## Come Contribuire

### Segnalare Bug

Se trovi un bug, aiutaci a risolverlo seguendo questi passaggi:

1. **Cerca prima**: Controlla gli [issue esistenti](../../issues) per vedere se è già stato segnalato
2. **Crea un issue**: Se è un nuovo bug, crea un issue dettagliato (vedi sezione [Segnalare Bug](#segnalare-bug))
3. **Fornisci contesto**: Includi passaggi per riprodurre, comportamento atteso, screenshot, log
4. **Etichetta appropriatamente**: Usa l'etichetta `bug` nell'issue

### Suggerire Miglioramenti

Hai un'idea per migliorare MedicApp?

1. **Verifica se esiste già**: Cerca negli issue se qualcuno l'ha già suggerito
2. **Crea un issue tipo "Feature Request"**: Descrivi la tua proposta in dettaglio
3. **Spiega il "perché"**: Giustifica perché questo miglioramento è prezioso
4. **Discuti prima di implementare**: Aspetta feedback dai mantenitori prima di iniziare a codificare

### Contribuire Codice

Per contribuire codice:

1. **Trova un issue**: Cerca issue etichettati come `good first issue` o `help wanted`
2. **Commenta la tua intenzione**: Indica che lavorerai su quell'issue per evitare duplicazione
3. **Segui il processo**: Leggi la sezione [Processo di Contribuzione](#processo-di-contribuzione)
4. **Crea una PR**: Segui la [Guida Pull Request](#guida-pull-request)

### Migliorare Documentazione

La documentazione è fondamentale:

- **Correggi errori**: Typo, link rotti, informazioni obsolete
- **Espandi documentazione**: Aggiungi esempi, diagrammi, spiegazioni più chiare
- **Traduci documentazione**: Aiuta a tradurre docs in altre lingue
- **Aggiungi tutorial**: Crea guide passo-passo per casi d'uso comuni

### Tradurre in Nuove Lingue

MedicApp supporta attualmente 8 lingue. Per aggiungerne una nuova o migliorare traduzioni esistenti, consulta la sezione [Aggiungere Traduzioni](#aggiungere-traduzioni).

---

## Processo di Contribuzione

Segui questi passaggi per realizzare una contribuzione di successo:

### 1. Fork del Repository

Fai un fork del repository sul tuo account GitHub:

```bash
# Da GitHub, clicca su "Fork" nell'angolo in alto a destra
```

### 2. Clonare il tuo Fork

Clona il tuo fork localmente:

```bash
git clone https://github.com/TUO_UTENTE/medicapp.git
cd medicapp
```

### 3. Configurare il Repository Upstream

Aggiungi il repository originale come "upstream":

```bash
git remote add upstream https://github.com/REPO_ORIGINALE/medicapp.git
git fetch upstream
```

### 4. Creare un Branch

Crea un branch descrittivo per il tuo lavoro:

```bash
# Per nuove funzionalità
git checkout -b feature/nome-descrittivo

# Per correzioni bug
git checkout -b fix/nome-del-bug

# Per documentazione
git checkout -b docs/descrizione-modifica

# Per test
git checkout -b test/descrizione-test
```

**Convenzioni nomi branch:**
- `feature/` - Nuova funzionalità
- `fix/` - Correzione bug
- `docs/` - Modifiche documentazione
- `test/` - Aggiungere o migliorare test
- `refactor/` - Refactoring senza modifiche funzionali
- `style/` - Modifiche formato/stile
- `chore/` - Attività manutenzione

### 5. Fare Modifiche

Realizza le tue modifiche seguendo le [Convenzioni di Codice](#convenzioni-di-codice).

### 6. Scrivere Test

**Tutte le modifiche al codice devono includere test appropriati:**

```bash
# Eseguire test durante sviluppo
flutter test

# Eseguire test specifici
flutter test test/percorso/al/test.dart

# Vedere copertura
flutter test --coverage
```

Consulta la sezione [Guida Testing](#guida-testing) per maggiori dettagli.

### 7. Formattare il Codice

Assicurati che il tuo codice sia formattato correttamente:

```bash
# Formattare tutto il progetto
dart format .

# Verificare analisi statica
flutter analyze
```

### 8. Fare Commit

Crea commit seguendo le [Convenzioni dei Commit](#convenzioni-dei-commit):

```bash
git add .
git commit -m "feat: aggiungere notifica promemoria ricarica"
```

### 9. Mantenere il tuo Branch Aggiornato

Sincronizza regolarmente con il repository upstream:

```bash
git fetch upstream
git rebase upstream/main
```

### 10. Push delle Modifiche

Carica le tue modifiche sul tuo fork:

```bash
git push origin nome-del-tuo-branch
```

### 11. Creare Pull Request

Crea una PR da GitHub seguendo la [Guida Pull Request](#guida-pull-request).

---

## Convenzioni di Codice

Mantenere un codice consistente è fondamentale per la manutenibilità del progetto.

### Dart Style Guide

Seguiamo la [Guida di Stile Dart](https://dart.dev/guides/language/effective-dart/style) ufficiale:

- **Nomi classi**: `PascalCase` (es. `MedicationService`)
- **Nomi variabili/funzioni**: `camelCase` (es. `getMedications`)
- **Nomi costanti**: `camelCase` (es. `maxNotifications`)
- **Nomi file**: `snake_case` (es. `medication_service.dart`)
- **Nomi cartelle**: `snake_case` (es. `notification_service`)

### Linting

Il progetto usa `flutter_lints` configurato in `analysis_options.yaml`:

```bash
# Eseguire analisi statica
flutter analyze

# Non devono esserci errori né warning
```

Tutte le PR devono passare l'analisi senza errori né warning.

### Formato Automatico

Usa `dart format` prima di fare commit:

```bash
# Formattare tutto il codice
dart format .

# Formattare file specifico
dart format lib/services/medication_service.dart
```

**Configurazione negli editor:**

- **VS Code**: Attiva "Format On Save" in configurazione
- **Android Studio**: Settings > Editor > Code Style > Dart > Set from: Dart Official

### Naming Conventions

**Variabili booleane:**
```dart
// Bene
bool isActive = true;
bool hasNotifications = false;
bool requiresFasting = true;

// Male
bool active = true;
bool notifications = false;
```

**Metodi che ritornano valori:**
```dart
// Bene
List<Medication> getMedications();
Future<bool> saveMedication(Medication med);
String calculateNextDose();

// Male
List<Medication> medications();
Future<bool> medication(Medication med);
```

**Metodi privati:**
```dart
// Bene
void _updateDatabase() { }
String _formatDate(DateTime date) { }

// Male
void updateDatabase() { }  // dovrebbe essere privato
String formatDate(DateTime date) { }  // dovrebbe essere privato
```

### Organizzazione File

**Ordine import:**
```dart
// 1. Import dart:
import 'dart:async';
import 'dart:convert';

// 2. Import package:
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

// 3. Import relativi del progetto:
import '../models/medication.dart';
import '../services/database_service.dart';
```

**Ordine membri nelle classi:**
```dart
class Example {
  // 1. Campi statici
  static const int maxValue = 100;

  // 2. Campi istanza
  final String name;
  int count;

  // 3. Constructor
  Example(this.name, this.count);

  // 4. Metodi pubblici
  void publicMethod() { }

  // 5. Metodi privati
  void _privateMethod() { }
}
```

### Commenti e Documentazione

**Documentare API pubbliche:**
```dart
/// Ottiene tutti i farmaci di una persona specifica.
///
/// Ritorna una lista di [Medication] per il [personId] fornito.
/// La lista è ordinata per nome alfabeticamente.
///
/// Lancia [DatabaseException] se si verifica un errore nel database.
Future<List<Medication>> getMedicationsByPerson(String personId) async {
  // Implementazione...
}
```

**Commenti inline quando necessario:**
```dart
// Calcolare giorni rimanenti basati su consumo medio
final daysRemaining = stockQuantity / averageDailyConsumption;
```

**Evitare commenti ovvi:**
```dart
// Male - commento non necessario
// Incrementare il contatore di 1
count++;

// Bene - codice auto-descrittivo
count++;
```

---

## Convenzioni dei Commit

Usiamo commit semantici per mantenere una cronologia chiara e leggibile.

### Formato

```
tipo: descrizione breve in minuscolo

[corpo opzionale con più dettagli]

[footer opzionale con riferimenti agli issue]
```

### Tipi di Commit

| Tipo | Descrizione | Esempio |
|------|-------------|---------|
| `feat` | Nuova funzionalità | `feat: aggiungere supporto per più persone` |
| `fix` | Correzione bug | `fix: correggere calcolo stock in timezone diverso` |
| `docs` | Modifiche documentazione | `docs: aggiornare guida installazione` |
| `test` | Aggiungere o modificare test | `test: aggiungere test per digiuno a mezzanotte` |
| `refactor` | Refactoring senza modifiche funzionali | `refactor: estrarre logica notifiche in servizio` |
| `style` | Modifiche formato | `style: formattare codice secondo dart format` |
| `chore` | Attività manutenzione | `chore: aggiornare dipendenze` |
| `perf` | Miglioramenti prestazioni | `perf: ottimizzare query database` |

### Esempi di Buoni Commit

```bash
# Nuovo feature con descrizione
git commit -m "feat: aggiungere notifiche digiuno con durata personalizzabile"

# Fix con riferimento a issue
git commit -m "fix: correggere calcolo prossima dose (#123)"

# Docs
git commit -m "docs: aggiungere sezione contribuzione in README"

# Test
git commit -m "test: aggiungere test integrazione per digiuni multipli"

# Refactor con contesto
git commit -m "refactor: separare logica farmaci in classi specifiche

- Creare MedicationValidator per validazioni
- Estrarre calcoli stock in MedicationStockCalculator
- Migliorare leggibilità codice"
```

### Esempi di Commit da Evitare

```bash
# Male - troppo vago
git commit -m "fix bug"
git commit -m "update"
git commit -m "changes"

# Male - senza tipo
git commit -m "aggiungere nuova funzionalità"

# Male - tipo errato
git commit -m "docs: aggiungere nuova schermata"  # dovrebbe essere 'feat'
```

### Regole Aggiuntive

- **Prima lettera minuscola**: "feat: aggiungere..." non "feat: Aggiungere..."
- **Senza punto finale**: "feat: aggiungere supporto" non "feat: aggiungere supporto."
- **Modo imperativo**: "aggiungere" non "aggiunto" o "aggiungendo"
- **Massimo 72 caratteri**: Mantieni la prima riga concisa
- **Corpo opzionale**: Usa il corpo per spiegare il "perché", non il "cosa"

---

## Guida Pull Request

### Prima di Creare la PR

**Checklist:**

- [ ] Il tuo codice compila senza errori: `flutter run`
- [ ] Tutti i test passano: `flutter test`
- [ ] Il codice è formattato: `dart format .`
- [ ] Non ci sono warning di analisi: `flutter analyze`
- [ ] Hai aggiunto test per la tua modifica
- [ ] La copertura test si mantiene >= 75%
- [ ] Hai aggiornato la documentazione se necessario
- [ ] I commit seguono le convenzioni
- [ ] Il tuo branch è aggiornato con `main`

### Creare la Pull Request

**Titolo descrittivo:**

```
feat: aggiungere supporto per periodi digiuno personalizzabili
fix: correggere crash in notifiche a mezzanotte
docs: migliorare documentazione architettura
```

**Descrizione dettagliata:**

```markdown
## Descrizione

Questa PR aggiunge supporto per periodi digiuno personalizzabili, permettendo agli utenti di configurare durate specifiche prima o dopo l'assunzione di un farmaco.

## Modifiche realizzate

- Aggiungere campi `fastingType` e `fastingDurationMinutes` al modello Medication
- Implementare logica validazione periodi digiuno
- Aggiungere UI per configurare digiuno nella schermata modifica farmaco
- Creare notifiche ongoing per periodi digiuno attivi
- Aggiungere test esaustivi (15 nuovi test)

## Tipo di modifica

- [x] Nuova funzionalità (modifica che aggiunge funzionalità senza rompere codice esistente)
- [ ] Correzione bug (modifica che risolve un issue)
- [ ] Modifica che rompe compatibilità (fix o feature che causerebbe cambiamento funzionalità esistente)
- [ ] Questa modifica richiede aggiornamento documentazione

## Screenshot

_Se applicabile, aggiungere catture schermo di modifiche in UI_

## Test

- [x] Test unitari aggiunti
- [x] Test integrazione aggiunti
- [x] Tutti i test esistenti passano
- [x] Copertura >= 75%

## Checklist

- [x] Il codice segue le convenzioni del progetto
- [x] Ho revisionato il mio codice
- [x] Ho commentato aree complesse
- [x] Ho aggiornato la documentazione
- [x] Le mie modifiche non generano warning
- [x] Ho aggiunto test che provano il mio fix/funzionalità
- [x] Test nuovi ed esistenti passano localmente

## Issue correlati

Closes #123
Correlato a #456
```

### Durante la Revisione

**Rispondi ai commenti:**
- Ringrazia per il feedback
- Rispondi alle domande con chiarezza
- Realizza le modifiche richieste prontamente
- Marca le conversazioni come risolte dopo aver applicato le modifiche

**Mantieni la PR aggiornata:**
```bash
# Se ci sono modifiche in main, aggiorna il tuo branch
git fetch upstream
git rebase upstream/main
git push origin tuo-branch --force-with-lease
```

### Dopo il Merge

**Pulizia:**
```bash
# Aggiornare il tuo fork
git checkout main
git pull upstream main
git push origin main

# Eliminare branch locale
git branch -d tuo-branch

# Eliminare branch remoto (opzionale)
git push origin --delete tuo-branch
```

---

## Guida Testing

Il testing è **obbligatorio** per tutti i contributi di codice.

### Principi

- **Tutte le PR devono includere test**: Senza eccezioni
- **Mantenere copertura minima**: >= 75%
- **I test devono essere indipendenti**: Ogni test deve poter essere eseguito da solo
- **I test devono essere deterministici**: Stesso input = stesso output sempre
- **I test devono essere rapidi**: < 1 secondo per test unitario

### Tipi di Test

**Test Unitari:**
```dart
// test/models/medication_test.dart
void main() {
  group('Medication', () {
    test('calcola giorni stock correttamente', () {
      final medication = MedicationBuilder()
        .withStock(30.0)
        .withSingleDose('08:00', 1.0)
        .build();

      expect(medication.calculateDaysRemaining(), equals(30));
    });
  });
}
```

**Test Widget:**
```dart
// test/screens/medication_list_screen_test.dart
void main() {
  testWidgets('mostra elenco farmaci correttamente', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: MedicationListScreen()),
    );

    expect(find.text('I Miei Farmaci'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });
}
```

**Test Integrazione:**
```dart
// test/integration/medication_flow_test.dart
void main() {
  testWidgets('flusso completo aggiungere farmaco', (tester) async {
    // Setup
    await tester.pumpWidget(MyApp());

    // Aggiungere farmaco
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verificare navigazione e salvataggio
    expect(find.text('Nuovo Farmaco'), findsOneWidget);
  });
}
```

### Usare MedicationBuilder

Per creare farmaci di prova, usa l'helper `MedicationBuilder`:

```dart
import 'package:medicapp/test/helpers/medication_builder.dart';

// Farmaco base
final med = MedicationBuilder()
  .withName('Aspirina')
  .withStock(20.0)
  .build();

// Con digiuno
final medWithFasting = MedicationBuilder()
  .withName('Ibuprofene')
  .withFasting(type: 'before', duration: 60)
  .build();

// Con dosi multiple
final medMultipleDoses = MedicationBuilder()
  .withName('Vitamina C')
  .withMultipleDoses(['08:00', '14:00', '20:00'], 1.0)
  .build();

// Con stock basso
final medLowStock = MedicationBuilder()
  .withName('Paracetamolo')
  .withLowStock()
  .build();
```

### Eseguire Test

```bash
# Tutti i test
flutter test

# Test specifico
flutter test test/models/medication_test.dart

# Con copertura
flutter test --coverage

# Vedere report copertura (richiede genhtml)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Copertura Test

**Obiettivo: >= 75% di copertura**

```bash
# Generare report
flutter test --coverage

# Vedere copertura per file
lcov --list coverage/lcov.info
```

**Aree critiche che DEVONO avere test:**
- Modelli e logica business (95%+)
- Servizi e utility (90%+)
- Schermate e widget principali (70%+)

**Aree dove la copertura può essere minore:**
- Widget puramente visuali
- Configurazione iniziale (main.dart)
- File generati automaticamente

---

## Aggiungere Nuove Funzionalità

### Prima di Iniziare

1. **Discuti in un issue prima**: Crea un issue descrivendo la tua proposta
2. **Aspetta feedback**: I mantenitori revisioneranno e daranno feedback
3. **Ottieni approvazione**: Aspetta luce verde prima di investire tempo nell'implementazione

### Seguire l'Architettura

MedicApp usa **architettura MVS (Model-View-Service)**:

```
lib/
├── models/           # Modelli dati
├── screens/          # Viste (UI)
├── services/         # Logica business
└── l10n/            # Traduzioni
```

**Principi:**
- **Models**: Solo dati, senza logica business
- **Services**: Tutta la logica business e accesso dati
- **Screens**: Solo UI, minima logica

**Esempio nuova funzionalità:**

```dart
// 1. Aggiungere modello (se necessario)
// lib/models/reminder.dart
class Reminder {
  final String id;
  final String medicationId;
  final DateTime reminderTime;

  Reminder({required this.id, required this.medicationId, required this.reminderTime});
}

// 2. Aggiungere servizio
// lib/services/reminder_service.dart
class ReminderService {
  Future<void> scheduleReminder(Reminder reminder) async {
    // Logica business
  }
}

// 3. Aggiungere schermata/widget
// lib/screens/reminder_screen.dart
class ReminderScreen extends StatelessWidget {
  // Solo UI, delega logica al servizio
}

// 4. Aggiungere test
// test/services/reminder_service_test.dart
void main() {
  group('ReminderService', () {
    test('schedule reminder crea notifica', () async {
      // Test
    });
  });
}
```

### Aggiornare Documentazione

Quando aggiungi nuova funzionalità:

- [ ] Aggiornare `docs/it/features.md`
- [ ] Aggiungere esempi d'uso
- [ ] Aggiornare diagrammi se applicabile
- [ ] Aggiungere commenti documentazione nel codice

### Considerare Internazionalizzazione

MedicApp supporta 8 lingue. **Ogni nuova funzionalità deve essere tradotta:**

```dart
// Invece di testo hardcoded:
Text('New Medication')

// Usare traduzioni:
Text(AppLocalizations.of(context)!.newMedication)
```

Aggiungi le chiavi in tutti i file `.arb`:
- `lib/l10n/app_es.arb`
- `lib/l10n/app_en.arb`
- `lib/l10n/app_de.arb`
- `lib/l10n/app_fr.arb`
- `lib/l10n/app_it.arb`
- `lib/l10n/app_ca.arb`
- `lib/l10n/app_eu.arb`
- `lib/l10n/app_gl.arb`

### Aggiungere Test Esaustivi

Nuova funzionalità richiede test completi:

- Test unitari per tutta la logica
- Test widget per UI
- Test integrazione per flussi completi
- Test edge case e errori

---

## Segnalare Bug

### Informazioni Richieste

Quando segnali un bug, includi:

**1. Descrizione del bug:**
Descrizione chiara e concisa del problema.

**2. Passaggi per riprodurre:**
```
1. Andare alla schermata 'Farmaci'
2. Cliccare su 'Aggiungi farmaco'
3. Configurare digiuno di 60 minuti
4. Salvare farmaco
5. Vedere errore in console
```

**3. Comportamento atteso:**
"Dovrebbe salvare il farmaco con la configurazione del digiuno."

**4. Comportamento attuale:**
"Viene mostrato un errore 'Invalid fasting duration' e non viene salvato il farmaco."

**5. Screenshot/Video:**
Se applicabile, aggiungi catture schermo o registrazione schermo.

**6. Log/Errori:**
```
[ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception:
Invalid fasting duration
#0      Medication.validate (package:medicapp/models/medication.dart:123)
```

**7. Ambiente:**
```
- Flutter version: 3.9.2
- Dart version: 3.0.0
- Dispositivo: Samsung Galaxy S21
- OS: Android 13
- Versione MedicApp: 1.0.0
```

**8. Contesto aggiuntivo:**
Qualsiasi altra informazione rilevante sul problema.

### Template di Issue

```markdown
## Descrizione del Bug
[Descrizione chiara e concisa]

## Passaggi per Riprodurre
1.
2.
3.

## Comportamento Atteso
[Cosa dovrebbe succedere]

## Comportamento Attuale
[Cosa sta succedendo attualmente]

## Screenshot
[Se applicabile]

## Log/Errori
```
[Copiare log qui]
```

## Ambiente
- Flutter version:
- Dart version:
- Dispositivo:
- OS e versione:
- Versione MedicApp:

## Contesto Aggiuntivo
[Informazioni aggiuntive]
```

---

## Aggiungere Traduzioni

MedicApp supporta 8 lingue. Aiutaci a mantenere traduzioni di alta qualità.

### Ubicazione File

I file di traduzione sono in:

```
lib/l10n/
├── app_es.arb    # Spagnolo (base)
├── app_en.arb    # Inglese
├── app_de.arb    # Tedesco
├── app_fr.arb    # Francese
├── app_it.arb    # Italiano
├── app_ca.arb    # Catalano
├── app_eu.arb    # Basco
└── app_gl.arb    # Galiziano
```

### Aggiungere una Nuova Lingua

**1. Copiare template:**
```bash
cp lib/l10n/app_es.arb lib/l10n/app_XX.arb
```

**2. Tradurre tutte le chiavi:**
```json
{
  "appTitle": "MedicApp",
  "@appTitle": {
    "description": "Titolo dell'applicazione"
  },
  "medications": "Farmaci",
  "@medications": {
    "description": "Titolo della schermata farmaci"
  }
}
```

**3. Aggiornare `l10n.yaml`** (se esiste):
```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
```

**4. Registrare la lingua in `MaterialApp`:**
```dart
// lib/main.dart
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: [
    const Locale('es'),
    const Locale('en'),
    const Locale('de'),
    const Locale('fr'),
    const Locale('it'),
    const Locale('ca'),
    const Locale('eu'),
    const Locale('gl'),
    const Locale('XX'),  // Nuova lingua
  ],
  // ...
)
```

**5. Eseguire generazione codice:**
```bash
flutter pub get
# Le traduzioni vengono generate automaticamente
```

**6. Provare nell'app:**
```dart
// Cambiare lingua temporaneamente per provare
Locale('XX')
```

### Migliorare Traduzioni Esistenti

**1. Identificare il file:**
Ad esempio, per migliorare italiano: `lib/l10n/app_it.arb`

**2. Cercare la chiave:**
```json
{
  "lowStockWarning": "Avviso stock basso",
  "@lowStockWarning": {
    "description": "Avviso quando lo stock è basso"
  }
}
```

**3. Migliorare la traduzione:**
```json
{
  "lowStockWarning": "Scorte in esaurimento",
  "@lowStockWarning": {
    "description": "Avviso quando rimane poco stock del farmaco"
  }
}
```

**4. Creare PR** con la modifica.

### Linee Guida Traduzione

- **Mantenere consistenza**: Usa gli stessi termini in tutte le traduzioni
- **Contesto appropriato**: Considera il contesto medico
- **Lunghezza ragionevole**: Evita traduzioni molto lunghe che rompono UI
- **Formalità**: Usa un tono professionale ma amichevole
- **Provare in UI**: Verifica che la traduzione si veda bene sullo schermo

---

## Configurazione Ambiente di Sviluppo

### Requisiti

- **Flutter SDK**: 3.9.2 o superiore
- **Dart SDK**: 3.0 o superiore
- **Editor**: VS Code o Android Studio raccomandati
- **Git**: Per controllo versioni

### Installazione Flutter

**macOS/Linux:**
```bash
# Scaricare Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Verificare installazione
flutter doctor
```

**Windows:**
1. Scaricare Flutter SDK da [flutter.dev](https://flutter.dev)
2. Estrarre in `C:\src\flutter`
3. Aggiungere `C:\src\flutter\bin` al PATH
4. Eseguire `flutter doctor`

### Configurazione Editor

**VS Code (Raccomandato):**

1. **Installare estensioni:**
   - Flutter
   - Dart
   - Flutter Widget Snippets (opzionale)

2. **Configurare settings.json:**
```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  },
  "[dart]": {
    "editor.defaultFormatter": "Dart-Code.dart-code",
    "editor.rulers": [80]
  },
  "dart.lineLength": 80
}
```

3. **Scorciatoie utili:**
   - `Cmd/Ctrl + .` - Azioni rapide
   - `Cmd/Ctrl + Shift + P` - Command Palette
   - `F5` - Debug
   - `Ctrl + F5` - Run senza debug

**Android Studio:**

1. **Installare plugin:**
   - Flutter plugin
   - Dart plugin

2. **Configurare:**
   - Settings > Editor > Code Style > Dart
   - Set from: Dart Official
   - Line length: 80

### Configurazione Linter

Il progetto usa `flutter_lints`. È già configurato in `analysis_options.yaml`.

```bash
# Eseguire analisi
flutter analyze

# Vedere issue in tempo reale nell'editor
# (automatico in VS Code e Android Studio)
```

### Configurazione Git

```bash
# Configurare identità
git config --global user.name "Il Tuo Nome"
git config --global user.email "tua@email.com"

# Configurare editor predefinito
git config --global core.editor "code --wait"

# Configurare alias utili
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
```

### Eseguire il Progetto

```bash
# Installare dipendenze
flutter pub get

# Eseguire in emulatore/dispositivo
flutter run

# Eseguire in modo debug
flutter run --debug

# Eseguire in modo release
flutter run --release

# Hot reload (durante esecuzione)
# Premere 'r' nel terminale

# Hot restart (durante esecuzione)
# Premere 'R' nel terminale
```

### Problemi Comuni

**"Flutter SDK not found":**
```bash
# Verificare PATH
echo $PATH  # macOS/Linux
echo %PATH%  # Windows

# Aggiungere Flutter al PATH
export PATH="$PATH:/percorso/a/flutter/bin"  # macOS/Linux
```

**"Android licenses not accepted":**
```bash
flutter doctor --android-licenses
```

**"CocoaPods not installed" (macOS):**
```bash
sudo gem install cocoapods
pod setup
```

---

## Risorse Utili

### Documentazione Progetto

- [Guida Installazione](installation.md)
- [Caratteristiche](features.md)
- [Architettura](architecture.md)
- [Database](database.md)
- [Struttura Progetto](project-structure.md)
- [Tecnologie](technologies.md)

### Documentazione Esterna

**Flutter:**
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Widget Catalog](https://docs.flutter.dev/development/ui/widgets)

**Material Design 3:**
- [Material Design Guidelines](https://m3.material.io/)
- [Material Components](https://m3.material.io/components)
- [Material Theming](https://m3.material.io/foundations/customization)

**SQLite:**
- [SQLite Documentation](https://www.sqlite.org/docs.html)
- [SQLite Tutorial](https://www.sqlitetutorial.net/)
- [sqflite Package](https://pub.dev/packages/sqflite)

**Testing:**
- [Flutter Testing](https://docs.flutter.dev/testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)

### Strumenti

- [Dart Pad](https://dartpad.dev/) - Playground online Dart
- [FlutLab](https://flutlab.io/) - IDE online Flutter
- [DartDoc](https://dart.dev/tools/dartdoc) - Generatore documentazione
- [Flutter Inspector](https://docs.flutter.dev/development/tools/devtools/inspector) - Debug widget

### Comunità

- [Flutter Discord](https://discord.gg/flutter)
- [r/FlutterDev](https://www.reddit.com/r/FlutterDev/)
- [Stack Overflow - Flutter](https://stackoverflow.com/questions/tagged/flutter)

---

## Domande Frequenti

### Come inizio a contribuire?

1. Leggi questa guida completa
2. Configura il tuo ambiente di sviluppo
3. Cerca issue etichettati come `good first issue`
4. Commenta nell'issue che ci lavorerai
5. Segui il [Processo di Contribuzione](#processo-di-contribuzione)

### Dove posso aiutare?

Aree dove abbiamo sempre bisogno di aiuto:

- **Traduzioni**: Migliorare o aggiungere traduzioni
- **Documentazione**: Espandere o migliorare docs
- **Test**: Aumentare copertura test
- **Bug**: Risolvere issue segnalati
- **UI/UX**: Migliorare interfaccia ed esperienza utente

Cerca issue con etichette:
- `good first issue` - Ideale per iniziare
- `help wanted` - Abbiamo bisogno di aiuto qui
- `documentation` - Correlato a docs
- `translation` - Traduzioni
- `bug` - Bug segnalati

### Quanto tempo prendono le revisioni?

- **PR piccole** (< 100 righe): 1-2 giorni
- **PR medie** (100-500 righe): 3-5 giorni
- **PR grandi** (> 500 righe): 1-2 settimane

**Suggerimenti per revisioni più rapide:**
- Mantieni PR piccole e focalizzate
- Scrivi buone descrizioni
- Rispondi ai commenti prontamente
- Includi test completi

### Cosa faccio se la mia PR non viene accettata?

Non scoraggiarti. Ci sono varie ragioni:

1. **Non allineato con visione progetto**: Discuti l'idea in un issue prima
2. **Necessita modifiche**: Applica il feedback e aggiorna la PR
3. **Problemi tecnici**: Correggi gli issue menzionati
4. **Timing**: Potrebbe non essere il momento giusto, ma verrà riconsiderato dopo

**Imparerai sempre qualcosa di prezioso dal processo.**

### Posso lavorare su più issue contemporaneamente?

Raccomandiamo di focalizzarti su uno alla volta:

- Completa un issue prima di iniziarne un altro
- Evita di bloccare issue per altri
- Se devi fare una pausa, commenta nell'issue

### Come gestisco conflitti di merge?

```bash
# Aggiornare il tuo branch con main
git fetch upstream
git rebase upstream/main

# Se ci sono conflitti, Git te lo dirà
# Risolvi conflitti nel tuo editor
# Poi:
git add .
git rebase --continue

# Push (con force se avevi già pushato prima)
git push origin tuo-branch --force-with-lease
```

### Devo firmare un CLA?

Attualmente **non** richiediamo CLA (Contributor License Agreement). Contribuendo, accetti che il tuo codice sia licenziato sotto AGPL-3.0.

### Posso contribuire anonimamente?

Sì, ma hai bisogno di un account GitHub. Puoi usare un nome utente anonimo se preferisci.

---

## Contatto e Comunità

### GitHub Issues

Il modo principale di comunicazione è attraverso [GitHub Issues](../../issues):

- **Segnalare bug**: Crea un issue con label `bug`
- **Suggerire miglioramenti**: Crea un issue con label `enhancement`
- **Fare domande**: Crea un issue con label `question`
- **Discutere idee**: Crea un issue con label `discussion`

### Discussions (se applicabile)

Se il repository ha GitHub Discussions abilitato:

- Domande generali
- Mostrare i tuoi progetti con MedicApp
- Condividere idee
- Aiutare altri utenti

### Tempi di Risposta

- **Issue urgenti** (bug critici): 24-48 ore
- **Issue normali**: 3-7 giorni
- **PR**: Secondo dimensione (vedi FAQ)
- **Domande**: 2-5 giorni

### Mantenitori

I mantenitori del progetto revisioneranno issue, PR e risponderanno a domande. Abbi pazienza, siamo un piccolo team che lavora su questo nel tempo libero.

---

## Ringraziamenti

Grazie per aver letto questa guida e per il tuo interesse nel contribuire a MedicApp.

Ogni contributo, per piccolo che sia, fa la differenza per gli utenti che dipendono da questa applicazione per gestire la loro salute.

**Attendiamo il tuo contributo!**

---

**Licenza:** Questo progetto è sotto [AGPL-3.0](../../LICENSE).

**Ultimo aggiornamento:** 2025-11-14
