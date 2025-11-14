# Guia de Contribució

Gràcies pel teu interès en contribuir a **MedicApp**. Aquesta guia t'ajudarà a realitzar contribucions de qualitat que beneficiïn tota la comunitat.

---

## Taula de Continguts

- [Benvinguda](#benvinguda)
- [Com Contribuir](#com-contribuir)
- [Procés de Contribució](#procés-de-contribució)
- [Convencions de Codi](#convencions-de-codi)
- [Convencions de Commits](#convencions-de-commits)
- [Guia de Pull Requests](#guia-de-pull-requests)
- [Guia de Testing](#guia-de-testing)
- [Afegir Noves Funcionalitats](#afegir-noves-funcionalitats)
- [Reportar Bugs](#reportar-bugs)
- [Afegir Traduccions](#afegir-traduccions)
- [Configuració de l'Entorn de Desenvolupament](#configuració-de-lentorn-de-desenvolupament)
- [Recursos Útils](#recursos-útils)
- [Preguntes Freqüents](#preguntes-freqüents)
- [Contacte i Comunitat](#contacte-i-comunitat)

---

## Benvinguda

Estem encantats que vulguis contribuir a MedicApp. Aquest projecte és possible gràcies a persones com tu que dediquen el seu temps i coneixement per millorar la salut i el benestar d'usuaris d'arreu del món.

### Tipus de Contribucions Benvingudes

Valorem tot tipus de contribucions:

- **Codi**: Noves funcionalitats, correccions de bugs, millores de rendiment
- **Documentació**: Millores en la documentació existent, noves guies, tutorials
- **Traduccions**: Afegir o millorar traduccions en els 8 idiomes suportats
- **Testing**: Afegir tests, millorar cobertura, reportar bugs
- **Disseny**: Millores en UI/UX, icones, assets
- **Ideas**: Suggeriments de millores, discussions sobre arquitectura
- **Revisió**: Revisar PRs d'altres contribuïdors

### Codi de Conducta

Aquest projecte s'adhereix a un codi de conducta de respecte mutu:

- **Ser respectuós**: Tracta tothom amb respecte i consideració
- **Ser constructiu**: Les crítiques han de ser constructives i orientades a millorar
- **Ser inclusiu**: Fomenta un ambient acollidor per a persones de tots els orígens
- **Ser professional**: Mantén les discussions enfocades en el projecte
- **Ser col·laboratiu**: Treballa en equip i comparteix coneixement

Qualsevol comportament inadequat pot ser reportat als mantenidors del projecte.

---

## Com Contribuir

### Reportar Bugs

Si trobes un bug, ajuda'ns a solucionar-lo seguint aquests passos:

1. **Busca primer**: Revisa els [issues existents](../../issues) per veure si ja va ser reportat
2. **Crea un issue**: Si és un bug nou, crea un issue detallat (veure secció [Reportar Bugs](#reportar-bugs))
3. **Proporciona context**: Inclou passos per reproduir, comportament esperat, screenshots, logs
4. **Etiqueta apropiadament**: Usa l'etiqueta `bug` en l'issue

### Suggerir Millores

Tens una idea per millorar MedicApp?

1. **Verifica si ja existeix**: Busca en els issues si algú ja ho va suggerir
2. **Crea un issue de tipus "Feature Request"**: Descriu la teva proposta en detall
3. **Explica el "per què"**: Justifica per què aquesta millora és valuosa
4. **Discuteix abans d'implementar**: Espera feedback dels mantenidors abans de començar a codificar

### Contribuir Codi

Per contribuir codi:

1. **Troba un issue**: Busca issues etiquetats com `good first issue` o `help wanted`
2. **Comenta la teva intenció**: Indica que treballaràs en aquest issue per evitar duplicació
3. **Segueix el procés**: Llegeix la secció [Procés de Contribució](#procés-de-contribució)
4. **Crea un PR**: Segueix la [Guia de Pull Requests](#guia-de-pull-requests)

### Millorar Documentació

La documentació és fonamental:

- **Corregeix errors**: Typos, enllaços trencats, informació desactualitzada
- **Expandeix documentació**: Afegeix exemples, diagrames, explicacions més clares
- **Tradueix documentació**: Ajuda a traduir docs a altres idiomes
- **Afegeix tutorials**: Crea guies pas a pas per a casos d'ús comuns

### Traduir a Nous Idiomes

MedicApp suporta actualment 8 idiomes. Per afegir-ne un de nou o millorar traduccions existents, consulta la secció [Afegir Traduccions](#afegir-traduccions).

---

## Procés de Contribució

Segueix aquests passos per realitzar una contribució exitosa:

### 1. Fork del Repositori

Fes un fork del repositori al teu compte de GitHub:

```bash
# Des de GitHub, fes clic a "Fork" a la cantonada superior dreta
```

### 2. Clonar el teu Fork

Clona el teu fork localment:

```bash
git clone https://github.com/EL_TEU_USUARI/medicapp.git
cd medicapp
```

### 3. Configurar el Repositori Upstream

Afegeix el repositori original com a "upstream":

```bash
git remote add upstream https://github.com/REPO_ORIGINAL/medicapp.git
git fetch upstream
```

### 4. Crear una Branca

Crea una branca descriptiva per al teu treball:

```bash
# Per a noves funcionalitats
git checkout -b feature/nom-descriptiu

# Per a correccions de bugs
git checkout -b fix/nom-del-bug

# Per a documentació
git checkout -b docs/descripcio-canvi

# Per a tests
git checkout -b test/descripcio-test
```

**Convencions de noms de branques:**
- `feature/` - Nova funcionalitat
- `fix/` - Correcció de bug
- `docs/` - Canvis en documentació
- `test/` - Afegir o millorar tests
- `refactor/` - Refactorització sense canvis funcionals
- `style/` - Canvis de format/estil
- `chore/` - Tasques de manteniment

### 5. Fer Canvis

Realitza els teus canvis seguint les [Convencions de Codi](#convencions-de-codi).

### 6. Escriure Tests

**Tots els canvis de codi han d'incloure tests apropiats:**

```bash
# Executar tests durant desenvolupament
flutter test

# Executar tests específics
flutter test test/ruta/al/test.dart

# Veure cobertura
flutter test --coverage
```

Consulta la secció [Guia de Testing](#guia-de-testing) per a més detalls.

### 7. Formatar el Codi

Assegura't que el teu codi estigui formatat correctament:

```bash
# Formatar tot el projecte
dart format .

# Verificar anàlisi estàtic
flutter analyze
```

### 8. Fer Commits

Crea commits seguint les [Convencions de Commits](#convencions-de-commits):

```bash
git add .
git commit -m "feat: afegir notificació de recordatori de recàrrega"
```

### 9. Mantenir la teva Branca Actualitzada

Sincronitza regularment amb el repositori upstream:

```bash
git fetch upstream
git rebase upstream/main
```

### 10. Push de Canvis

Puja els teus canvis al teu fork:

```bash
git push origin nom-de-la-teva-branca
```

### 11. Crear Pull Request

Crea un PR des de GitHub seguint la [Guia de Pull Requests](#guia-de-pull-requests).

---

## Convencions de Codi

Mantenir un codi consistent és fonamental per a la mantenibilitat del projecte.

### Dart Style Guide

Seguim la [Guia d'Estil de Dart](https://dart.dev/guides/language/effective-dart/style) oficial:

- **Noms de classes**: `PascalCase` (ex. `MedicationService`)
- **Noms de variables/funcions**: `camelCase` (ex. `getMedications`)
- **Noms de constants**: `camelCase` (ex. `maxNotifications`)
- **Noms d'arxius**: `snake_case` (ex. `medication_service.dart`)
- **Noms de carpetes**: `snake_case` (ex. `notification_service`)

### Linting

El projecte usa `flutter_lints` configurat a `analysis_options.yaml`:

```bash
# Executar anàlisi estàtic
flutter analyze

# No hi ha d'haver errors ni warnings
```

Tots els PRs han de passar l'anàlisi sense errors ni warnings.

### Format Automàtic

Usa `dart format` abans de fer commit:

```bash
# Formatar tot el codi
dart format .

# Formatar arxiu específic
dart format lib/services/medication_service.dart
```

**Configuració en editors:**

- **VS Code**: Activa "Format On Save" a configuració
- **Android Studio**: Settings > Editor > Code Style > Dart > Set from: Dart Official

### Naming Conventions

**Variables booleanes:**
```dart
// Bé
bool isActive = true;
bool hasNotifications = false;
bool requiresFasting = true;

// Malament
bool active = true;
bool notifications = false;
```

**Mètodes que retornen valors:**
```dart
// Bé
List<Medication> getMedications();
Future<bool> saveMedication(Medication med);
String calculateNextDose();

// Malament
List<Medication> medications();
Future<bool> medication(Medication med);
```

**Mètodes privats:**
```dart
// Bé
void _updateDatabase() { }
String _formatDate(DateTime date) { }

// Malament
void updateDatabase() { }  // hauria de ser privat
String formatDate(DateTime date) { }  // hauria de ser privat
```

### Organització d'Arxius

**Ordre d'imports:**
```dart
// 1. Imports de dart:
import 'dart:async';
import 'dart:convert';

// 2. Imports de package:
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

// 3. Imports relatius del projecte:
import '../models/medication.dart';
import '../services/database_service.dart';
```

**Ordre de membres en classes:**
```dart
class Example {
  // 1. Camps estàtics
  static const int maxValue = 100;

  // 2. Camps d'instància
  final String name;
  int count;

  // 3. Constructor
  Example(this.name, this.count);

  // 4. Mètodes públics
  void publicMethod() { }

  // 5. Mètodes privats
  void _privateMethod() { }
}
```

### Comentaris i Documentació

**Documentar APIs públiques:**
```dart
/// Obté tots els medicaments d'una persona específica.
///
/// Retorna una llista de [Medication] per a la [personId] proporcionada.
/// La llista està ordenada per nom alfabèticament.
///
/// Llança [DatabaseException] si ocorre un error a la base de dades.
Future<List<Medication>> getMedicationsByPerson(String personId) async {
  // Implementació...
}
```

**Comentaris inline quan sigui necessari:**
```dart
// Calcular dies restants basat en consum promig
final daysRemaining = stockQuantity / averageDailyConsumption;
```

**Evitar comentaris obvis:**
```dart
// Malament - comentari innecessari
// Incrementar el comptador en 1
count++;

// Bé - codi auto-descriptiu
count++;
```

---

## Convencions de Commits

Usem commits semàntics per mantenir un historial clar i llegible.

### Format

```
tipus: descripció breu en minúscules

[cos opcional amb més detalls]

[footer opcional amb referències a issues]
```

### Tipus de Commits

| Tipus | Descripció | Exemple |
|------|-------------|---------|
| `feat` | Nova funcionalitat | `feat: afegir suport per a múltiples persones` |
| `fix` | Correcció de bug | `fix: corregir càlcul d'estoc en timezone diferent` |
| `docs` | Canvis en documentació | `docs: actualitzar guia d'instal·lació` |
| `test` | Afegir o modificar tests | `test: afegir tests per a dejuni a mitjanit` |
| `refactor` | Refactorització sense canvis funcionals | `refactor: extreure lògica de notificacions a servei` |
| `style` | Canvis de format | `style: formatar codi segons dart format` |
| `chore` | Tasques de manteniment | `chore: actualitzar dependències` |
| `perf` | Millores de rendiment | `perf: optimitzar consultes de base de dades` |

### Exemples de Bons Commits

```bash
# Nou feature amb descripció
git commit -m "feat: afegir notificacions de dejuni amb durada personalitzable"

# Fix amb referència a issue
git commit -m "fix: corregir càlcul de propera dosi (#123)"

# Docs
git commit -m "docs: afegir secció de contribució al README"

# Test
git commit -m "test: afegir tests d'integració per a múltiples dejunis"

# Refactor amb context
git commit -m "refactor: separar lògica de medicaments en classes específiques

- Crear MedicationValidator per a validacions
- Extreure càlculs d'estoc a MedicationStockCalculator
- Millorar llegibilitat del codi"
```

### Exemples de Commits a Evitar

```bash
# Malament - massa vag
git commit -m "fix bug"
git commit -m "update"
git commit -m "changes"

# Malament - sense tipus
git commit -m "afegir nova funcionalitat"

# Malament - tipus incorrecte
git commit -m "docs: afegir nova pantalla"  # hauria de ser 'feat'
```

### Regles Addicionals

- **Primera lletra en minúscules**: "feat: afegir..." no "feat: Afegir..."
- **Sense punt final**: "feat: afegir suport" no "feat: afegir suport."
- **Mode imperatiu**: "afegir" no "afegit" o "afegint"
- **Màxim 72 caràcters**: Mantén la primera línia concisa
- **Cos opcional**: Usa el cos per explicar el "per què", no el "què"

---

## Guia de Pull Requests

### Abans de Crear el PR

**Checklist:**

- [ ] El teu codi compila sense errors: `flutter run`
- [ ] Tots els tests passen: `flutter test`
- [ ] El codi està formatat: `dart format .`
- [ ] No hi ha warnings d'anàlisi: `flutter analyze`
- [ ] Has afegit tests per al teu canvi
- [ ] La cobertura de tests es manté >= 75%
- [ ] Has actualitzat la documentació si és necessari
- [ ] Els commits segueixen les convencions
- [ ] La teva branca està actualitzada amb `main`

### Crear el Pull Request

**Títol descriptiu:**

```
feat: afegir suport per a períodes de dejuni personalitzables
fix: corregir crash en notificacions a mitjanit
docs: millorar documentació d'arquitectura
```

**Descripció detallada:**

```markdown
## Descripció

Aquest PR afegeix suport per a períodes de dejuni personalitzables, permetent als usuaris configurar durades específiques abans o després de prendre un medicament.

## Canvis realitzats

- Afegir camps `fastingType` i `fastingDurationMinutes` al model Medication
- Implementar lògica de validació de períodes de dejuni
- Afegir UI per configurar dejuni a pantalla d'edició de medicament
- Crear notificacions ongoing per a períodes de dejuni actius
- Afegir tests exhaustius (15 nous tests)

## Tipus de canvi

- [x] Nova funcionalitat (canvi que afegeix funcionalitat sense trencar codi existent)
- [ ] Correcció de bug (canvi que soluciona un issue)
- [ ] Canvi que trenca compatibilitat (fix o feature que causaria que funcionalitat existent canviï)
- [ ] Aquest canvi requereix actualització de documentació

## Screenshots

_Si aplica, afegir captures de pantalla de canvis a la UI_

## Tests

- [x] Tests unitaris afegits
- [x] Tests d'integració afegits
- [x] Tots els tests existents passen
- [x] Cobertura >= 75%

## Checklist

- [x] El codi segueix les convencions del projecte
- [x] He revisat el meu propi codi
- [x] He comentat àrees complexes
- [x] He actualitzat la documentació
- [x] Els meus canvis no generen warnings
- [x] He afegit tests que proven el meu fix/funcionalitat
- [x] Tests nous i existents passen localment

## Issues relacionats

Closes #123
Relacionat amb #456
```

### Durant la Revisió

**Respon a comentaris:**
- Agraeix el feedback
- Respon preguntes amb claredat
- Realitza canvis sol·licitats promptament
- Marca converses com a resoltes després d'aplicar canvis

**Mantén el PR actualitzat:**
```bash
# Si hi ha canvis a main, actualitza la teva branca
git fetch upstream
git rebase upstream/main
git push origin la-teva-branca --force-with-lease
```

### Després del Merge

**Neteja:**
```bash
# Actualitzar el teu fork
git checkout main
git pull upstream main
git push origin main

# Eliminar branca local
git branch -d la-teva-branca

# Eliminar branca remota (opcional)
git push origin --delete la-teva-branca
```

---

## Guia de Testing

El testing és **obligatori** per a totes les contribucions de codi.

### Principis

- **Tots els PRs han d'incloure tests**: Sense excepció
- **Mantenir cobertura mínima**: >= 75%
- **Tests han de ser independents**: Cada test ha de poder executar-se sol
- **Tests han de ser determinístics**: Mateix input = mateix output sempre
- **Tests han de ser ràpids**: < 1 segon per test unitari

### Tipus de Tests

**Tests Unitaris:**
```dart
// test/models/medication_test.dart
void main() {
  group('Medication', () {
    test('calcula dies d\'estoc correctament', () {
      final medication = MedicationBuilder()
        .withStock(30.0)
        .withSingleDose('08:00', 1.0)
        .build();

      expect(medication.calculateDaysRemaining(), equals(30));
    });
  });
}
```

**Tests de Widgets:**
```dart
// test/screens/medication_list_screen_test.dart
void main() {
  testWidgets('mostra llista de medicaments correctament', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: MedicationListScreen()),
    );

    expect(find.text('Els Meus Medicaments'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });
}
```

**Tests d'Integració:**
```dart
// test/integration/medication_flow_test.dart
void main() {
  testWidgets('flux complet d\'afegir medicament', (tester) async {
    // Setup
    await tester.pumpWidget(MyApp());

    // Afegir medicament
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verificar navegació i guardat
    expect(find.text('Nou Medicament'), findsOneWidget);
  });
}
```

### Usar MedicationBuilder

Per crear medicaments de prova, usa l'helper `MedicationBuilder`:

```dart
import 'package:medicapp/test/helpers/medication_builder.dart';

// Medicament bàsic
final med = MedicationBuilder()
  .withName('Aspirina')
  .withStock(20.0)
  .build();

// Amb dejuni
final medWithFasting = MedicationBuilder()
  .withName('Ibuprofen')
  .withFasting(type: 'before', duration: 60)
  .build();

// Amb múltiples dosis
final medMultipleDoses = MedicationBuilder()
  .withName('Vitamina C')
  .withMultipleDoses(['08:00', '14:00', '20:00'], 1.0)
  .build();

// Amb estoc baix
final medLowStock = MedicationBuilder()
  .withName('Paracetamol')
  .withLowStock()
  .build();
```

### Executar Tests

```bash
# Tots els tests
flutter test

# Test específic
flutter test test/models/medication_test.dart

# Amb cobertura
flutter test --coverage

# Veure report de cobertura (requereix genhtml)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Cobertura de Tests

**Objectiu: >= 75% de cobertura**

```bash
# Generar report
flutter test --coverage

# Veure cobertura per arxiu
lcov --list coverage/lcov.info
```

**Àrees crítiques que HAN de tenir tests:**
- Models i lògica de negoci (95%+)
- Services i utilitats (90%+)
- Screens i widgets principals (70%+)

**Àrees on la cobertura pot ser menor:**
- Widgets purament visuals
- Configuració inicial (main.dart)
- Arxius generats automàticament

---

## Afegir Noves Funcionalitats

### Abans de Començar

1. **Discutir en un issue primer**: Crea un issue descrivint la teva proposta
2. **Esperar feedback**: Els mantenidors revisaran i donaran feedback
3. **Obtenir aprovació**: Espera llum verda abans d'invertir temps en implementar

### Seguir l'Arquitectura

MedicApp usa **arquitectura MVS (Model-View-Service)**:

```
lib/
├── models/           # Models de dades
├── screens/          # Vistes (UI)
├── services/         # Lògica de negoci
└── l10n/            # Traduccions
```

**Principis:**
- **Models**: Només dades, sense lògica de negoci
- **Services**: Tota la lògica de negoci i accés a dades
- **Screens**: Només UI, mínima lògica

**Exemple de nova funcionalitat:**

```dart
// 1. Afegir model (si necessari)
// lib/models/reminder.dart
class Reminder {
  final String id;
  final String medicationId;
  final DateTime reminderTime;

  Reminder({required this.id, required this.medicationId, required this.reminderTime});
}

// 2. Afegir servei
// lib/services/reminder_service.dart
class ReminderService {
  Future<void> scheduleReminder(Reminder reminder) async {
    // Lògica de negoci
  }
}

// 3. Afegir pantalla/widget
// lib/screens/reminder_screen.dart
class ReminderScreen extends StatelessWidget {
  // Només UI, delega lògica al servei
}

// 4. Afegir tests
// test/services/reminder_service_test.dart
void main() {
  group('ReminderService', () {
    test('schedule reminder crea notificació', () async {
      // Test
    });
  });
}
```

### Actualitzar Documentació

En afegir nova funcionalitat:

- [ ] Actualitzar `docs/ca/features.md`
- [ ] Afegir exemples d'ús
- [ ] Actualitzar diagrames si aplica
- [ ] Afegir comentaris de documentació al codi

### Considerar Internacionalització

MedicApp suporta 8 idiomes. **Tota nova funcionalitat ha de ser traduïda:**

```dart
// En lloc de text hardcoded:
Text('New Medication')

// Usar traduccions:
Text(AppLocalizations.of(context)!.newMedication)
```

Afegeix les claus en tots els arxius `.arb`:
- `lib/l10n/app_es.arb`
- `lib/l10n/app_en.arb`
- `lib/l10n/app_de.arb`
- `lib/l10n/app_fr.arb`
- `lib/l10n/app_it.arb`
- `lib/l10n/app_ca.arb`
- `lib/l10n/app_eu.arb`
- `lib/l10n/app_gl.arb`

### Afegir Tests Exhaustius

Nova funcionalitat requereix tests complets:

- Tests unitaris per a tota la lògica
- Tests de widgets per a UI
- Tests d'integració per a fluxos complets
- Tests de edge cases i errors

---

## Reportar Bugs

### Informació Requerida

En reportar un bug, inclou:

**1. Descripció del bug:**
Descripció clara i concisa del problema.

**2. Passos per reproduir:**
```
1. Anar a pantalla 'Medicaments'
2. Fer clic a 'Afegir medicament'
3. Configurar dejuni de 60 minuts
4. Guardar medicament
5. Veure error a consola
```

**3. Comportament esperat:**
"S'hauria de guardar el medicament amb la configuració de dejuni."

**4. Comportament actual:**
"Es mostra un error 'Invalid fasting duration' i no es guarda el medicament."

**5. Screenshots/Videos:**
Si aplica, afegeix captures de pantalla o gravació de pantalla.

**6. Logs/Errors:**
```
[ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception:
Invalid fasting duration
#0      Medication.validate (package:medicapp/models/medication.dart:123)
```

**7. Entorn:**
```
- Flutter version: 3.9.2
- Dart version: 3.0.0
- Dispositiu: Samsung Galaxy S21
- OS: Android 13
- Versió de MedicApp: 1.0.0
```

**8. Context addicional:**
Qualsevol altra informació rellevant sobre el problema.

### Template d'Issue

```markdown
## Descripció del Bug
[Descripció clara i concisa]

## Passos per Reproduir
1.
2.
3.

## Comportament Esperat
[Què hauria de passar]

## Comportament Actual
[Què està passant actualment]

## Screenshots
[Si aplica]

## Logs/Errors
```
[Copiar logs aquí]
```

## Entorn
- Flutter version:
- Dart version:
- Dispositiu:
- OS i versió:
- Versió de MedicApp:

## Context Addicional
[Informació addicional]
```

---

## Afegir Traduccions

MedicApp suporta 8 idiomes. Ajuda'ns a mantenir traduccions d'alta qualitat.

### Ubicació d'Arxius

Els arxius de traducció estan a:

```
lib/l10n/
├── app_es.arb    # Espanyol (base)
├── app_en.arb    # Anglès
├── app_de.arb    # Alemany
├── app_fr.arb    # Francès
├── app_it.arb    # Italià
├── app_ca.arb    # Català
├── app_eu.arb    # Basc
└── app_gl.arb    # Gallec
```

### Afegir un Nou Idioma

**1. Copiar plantilla:**
```bash
cp lib/l10n/app_es.arb lib/l10n/app_XX.arb
```

**2. Traduir totes les claus:**
```json
{
  "appTitle": "MedicApp",
  "@appTitle": {
    "description": "Títol de l'aplicació"
  },
  "medications": "Medicaments",
  "@medications": {
    "description": "Títol de la pantalla de medicaments"
  }
}
```

**3. Actualitzar `l10n.yaml`** (si existeix):
```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
```

**4. Registrar l'idioma al `MaterialApp`:**
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
    const Locale('XX'),  // Nou idioma
  ],
  // ...
)
```

**5. Executar generació de codi:**
```bash
flutter pub get
# Les traduccions es generen automàticament
```

**6. Provar a l'app:**
```dart
// Canviar idioma temporalment per provar
Locale('XX')
```

### Millorar Traduccions Existents

**1. Identificar l'arxiu:**
Per exemple, per millorar català: `lib/l10n/app_ca.arb`

**2. Buscar la clau:**
```json
{
  "lowStockWarning": "Avís d'estoc baix",
  "@lowStockWarning": {
    "description": "Avís d'estoc baix"
  }
}
```

**3. Millorar la traducció:**
```json
{
  "lowStockWarning": "S'està acabant el medicament",
  "@lowStockWarning": {
    "description": "Avís quan queda poc estoc de medicament"
  }
}
```

**4. Crear PR** amb el canvi.

### Lineaments de Traducció

- **Mantenir consistència**: Usa els mateixos termes al llarg de totes les traduccions
- **Context apropiat**: Considera el context mèdic
- **Longitud raonable**: Evita traduccions molt llargues que trenquin la UI
- **Formalitat**: Usa un to professional però amigable
- **Provar a la UI**: Verifica que la traducció es vegi bé a pantalla

---

## Configuració de l'Entorn de Desenvolupament

### Requisits

- **Flutter SDK**: 3.9.2 o superior
- **Dart SDK**: 3.0 o superior
- **Editor**: VS Code o Android Studio recomanats
- **Git**: Per a control de versions

### Instal·lació de Flutter

**macOS/Linux:**
```bash
# Descarregar Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Verificar instal·lació
flutter doctor
```

**Windows:**
1. Descarregar Flutter SDK des de [flutter.dev](https://flutter.dev)
2. Extreure a `C:\src\flutter`
3. Afegir `C:\src\flutter\bin` al PATH
4. Executar `flutter doctor`

### Configuració de l'Editor

**VS Code (Recomanat):**

1. **Instal·lar extensions:**
   - Flutter
   - Dart
   - Flutter Widget Snippets (opcional)

2. **Configurar settings.json:**
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

3. **Shortcuts útils:**
   - `Cmd/Ctrl + .` - Accions ràpides
   - `Cmd/Ctrl + Shift + P` - Command Palette
   - `F5` - Debug
   - `Ctrl + F5` - Run sense debug

**Android Studio:**

1. **Instal·lar plugins:**
   - Flutter plugin
   - Dart plugin

2. **Configurar:**
   - Settings > Editor > Code Style > Dart
   - Set from: Dart Official
   - Line length: 80

### Configuració del Linter

El projecte usa `flutter_lints`. Ja està configurat a `analysis_options.yaml`.

```bash
# Executar anàlisi
flutter analyze

# Veure issues en temps real a l'editor
# (automàtic en VS Code i Android Studio)
```

### Configuració de Git

```bash
# Configurar identitat
git config --global user.name "El Teu Nom"
git config --global user.email "tu@email.com"

# Configurar editor predeterminat
git config --global core.editor "code --wait"

# Configurar alias útils
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
```

### Executar el Projecte

```bash
# Instal·lar dependències
flutter pub get

# Executar en emulador/dispositiu
flutter run

# Executar en mode debug
flutter run --debug

# Executar en mode release
flutter run --release

# Hot reload (durant execució)
# Prémer 'r' al terminal

# Hot restart (durant execució)
# Prémer 'R' al terminal
```

### Problemes Comuns

**"Flutter SDK not found":**
```bash
# Verificar PATH
echo $PATH  # macOS/Linux
echo %PATH%  # Windows

# Afegir Flutter al PATH
export PATH="$PATH:/ruta/a/flutter/bin"  # macOS/Linux
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

## Recursos Útils

### Documentació del Projecte

- [Guia d'Instal·lació](installation.md)
- [Característiques](features.md)
- [Arquitectura](architecture.md)
- [Base de Dades](database.md)
- [Estructura del Projecte](project-structure.md)
- [Tecnologies](technologies.md)

### Documentació Externa

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

### Eines

- [Dart Pad](https://dartpad.dev/) - Playground online de Dart
- [FlutLab](https://flutlab.io/) - IDE online de Flutter
- [DartDoc](https://dart.dev/tools/dartdoc) - Generador de documentació
- [Flutter Inspector](https://docs.flutter.dev/development/tools/devtools/inspector) - Debug de widgets

### Comunitat

- [Flutter Discord](https://discord.gg/flutter)
- [r/FlutterDev](https://www.reddit.com/r/FlutterDev/)
- [Stack Overflow - Flutter](https://stackoverflow.com/questions/tagged/flutter)

---

## Preguntes Freqüents

### Com començo a contribuir?

1. Llegeix aquesta guia completa
2. Configura el teu entorn de desenvolupament
3. Busca issues etiquetats com `good first issue`
4. Comenta a l'issue que treballaràs en ell
5. Segueix el [Procés de Contribució](#procés-de-contribució)

### On puc ajudar?

Àrees on sempre necessitem ajuda:

- **Traduccions**: Millorar o afegir traduccions
- **Documentació**: Expandir o millorar docs
- **Tests**: Augmentar cobertura de tests
- **Bugs**: Resoldre issues reportats
- **UI/UX**: Millorar interfície i experiència d'usuari

Busca issues amb etiquetes:
- `good first issue` - Ideal per començar
- `help wanted` - Necessitem ajuda aquí
- `documentation` - Relacionat amb docs
- `translation` - Traduccions
- `bug` - Bugs reportats

### Quant de temps triguen els reviews?

- **PRs petits** (< 100 línies): 1-2 dies
- **PRs mitjans** (100-500 línies): 3-5 dies
- **PRs grans** (> 500 línies): 1-2 setmanes

**Tips per a reviews més ràpids:**
- Mantén PRs petits i enfocats
- Escriu bones descripcions
- Respon a comentaris promptament
- Inclou tests complets

### Què faig si el meu PR no és acceptat?

No et desanimis. Hi ha diverses raons:

1. **No alineat amb visió del projecte**: Discuteix la idea en un issue primer
2. **Necessita canvis**: Aplica el feedback i actualitza el PR
3. **Problemes tècnics**: Arregla els issues mencionats
4. **Timing**: Pot ser que no sigui el moment adequat, però es reconsiderarà després

**Sempre aprendràs alguna cosa valuosa del procés.**

### Puc treballar en múltiples issues alhora?

Recomanem enfocar-te en un a la vegada:

- Completa un issue abans de començar un altre
- Evita bloquejar issues per a altres
- Si necessites pausar, comenta a l'issue

### Com gestiono conflictes de merge?

```bash
# Actualitzar la teva branca amb main
git fetch upstream
git rebase upstream/main

# Si hi ha conflictes, Git t'ho dirà
# Resol conflictes al teu editor
# Després:
git add .
git rebase --continue

# Push (amb force si ja havies pushejat abans)
git push origin la-teva-branca --force-with-lease
```

### Necessito signar un CLA?

Actualment **no** requerim CLA (Contributor License Agreement). En contribuir, acceptes que el teu codi es llicenciï sota AGPL-3.0.

### Puc contribuir anònimament?

Sí, però necessites un compte de GitHub. Pots usar un nom d'usuari anònim si ho prefereixes.

---

## Contacte i Comunitat

### GitHub Issues

La forma principal de comunicació és a través de [GitHub Issues](../../issues):

- **Reportar bugs**: Crea un issue amb label `bug`
- **Suggerir millores**: Crea un issue amb label `enhancement`
- **Fer preguntes**: Crea un issue amb label `question`
- **Discutir ideas**: Crea un issue amb label `discussion`

### Discussions (si aplica)

Si el repositori té GitHub Discussions habilitat:

- Preguntes generals
- Mostrar els teus projectes amb MedicApp
- Compartir idees
- Ajudar altres usuaris

### Temps de Resposta

- **Issues urgents** (bugs crítics): 24-48 hores
- **Issues normals**: 3-7 dies
- **PRs**: Segons mida (veure FAQ)
- **Preguntes**: 2-5 dies

### Mantenidors

Els mantenidors del projecte revisaran issues, PRs i respondran preguntes. Tingues paciència, som un equip petit que treballa en això al nostre temps lliure.

---

## Agraïments

Gràcies per llegir aquesta guia i pel teu interès en contribuir a MedicApp.

Cada contribució, per petita que sigui, fa una diferència per als usuaris que depenen d'aquesta aplicació per gestionar la seva salut.

**Esperem la teva contribució!**

---

**Llicència:** Aquest projecte està sota [AGPL-3.0](../../LICENSE).

**Última actualització:** 2025-11-14
