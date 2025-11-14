# Ekarpenen Gida

Eskerrik asko **MedicApp**-en ekarpenak egiteko interesa izateagatik. Gida honek kalitate-ekarpenak egiten lagunduko dizu komunitate osoari onura ekar diezazkieten.

---

## Edukien Taula

- [Ongi etorria](#ongi-etorria)
- [Nola Ekarpenak Egin](#nola-ekarpenak-egin)
- [Ekarpenen Prozesua](#ekarpenen-prozesua)
- [Kode Konbentzioak](#kode-konbentzioak)
- [Commit Konbentzioak](#commit-konbentzioak)
- [Pull Request Gida](#pull-request-gida)
- [Testing Gida](#testing-gida)
- [Funtzionalitate Berriak Gehitu](#funtzionalitate-berriak-gehitu)
- [Bug-en Txostena](#bug-en-txostena)
- [Itzulpenak Gehitu](#itzulpenak-gehitu)
- [Garapen Ingurunearen Konfigurazioa](#garapen-ingurunearen-konfigurazioa)
- [Baliabide Erabilgarriak](#baliabide-erabilgarriak)
- [Maiz Egindako Galderak](#maiz-egindako-galderak)
- [Kontaktua eta Komunitatea](#kontaktua-eta-komunitatea)

---

## Ongi etorria

Pozik gaude MedicApp-en ekarpenak egin nahi dituzulako. Proiektu hau zu bezalako pertsonek egiten dute posible, zure denbora eta ezagutza mundu osoko erabiltzaileen osasuna eta ongizatea hobetzeko eskaintzen dituzutenak.

### Onartutako Ekarpena Motak

Era guztietako ekarpenak balioesten ditugu:

- **Kodea**: Funtzionalitate berriak, bug zuzenketak, errendimendu hobekuntzak
- **Dokumentazioa**: Dokumentazio existentea hobetu, gida berriak, tutorialak
- **Itzulpenak**: Onartutako 8 hizkuntzetan itzulpenak gehitu edo hobetu
- **Testing**: Test-ak gehitu, estaldura hobetu, bug-en txostena
- **Diseinua**: UI/UX hobekuntzak, ikonoak, asset-ak
- **Ideiak**: Hobetzeko iradokizunak, arkitekturari buruzko eztabaidak
- **Berrikuspena**: Beste ekartzaileen PR-ak berrikusi

### Portaera Kodea

Proiektu honek elkarrekiko errespetuaren portaera kode batera lotzen da:

- **Errespetuz jokatu**: Guztiak errespetu eta kontsiderazioz tratatu
- **Eraikitzailea izan**: Kritikak eraikitzaileak izan behar dira eta hobetzera orientatuak
- **Inklusiboa izan**: Jatorri guztietako pertsonentzat ingurune ongietorriko bat sustatu
- **Profesionala izan**: Eztabaidak proiektuan zentratuta mantendu
- **Kolaboratiboak izan**: Taldean lan egin eta ezagutza partekatu

Portaera desegokia proiektuko mantentzaileei jakinarazi dakieke.

---

## Nola Ekarpenak Egin

### Bug-en Txostena

Bug bat aurkitzen baduzu, lagun gaitzazu konpontzen pausu hauek jarraituz:

1. **Lehenik bilatu**: Berrikusi [lehendik dauden issue-ak](../../issues) jadanik txostenatua ote dagoen ikusteko
2. **Issue bat sortu**: Bug berria bada, issue xehetatu bat sortu (ikusi [Bug-en Txostena](#bug-en-txostena) atala)
3. **Testuingurua eman**: Erreproduzitzeko pausoak, portaera esperoaren, pantaila-argazkiak, log-ak barne
4. **Etiketa egoki**: Issue-an `bug` etiketa erabili

### Hobekuntzak Iradoki

MedicApp hobetzeko ideia bat baduzu?

1. **Egiaztatu dagoeneko existitzen ote den**: Bilatu issue-etan norbaitek jada iradokita ote dagoen
2. **"Feature Request" motako issue bat sortu**: Deskribatu zure proposamena xehetasunez
3. **Azaldu "zergatia"**: Justifikatu hobekuntza hau zergatik baliozko den
4. **Inplementatu aurretik eztabaidatu**: Itxaron mantentzailearen feedbacka kodetzen hasi aurretik

### Kode Ekarpenak

Kodea ekartzeko:

1. **Issue bat bilatu**: Bilatu `good first issue` edo `help wanted` etiketa duten issue-ak
2. **Iruzkindu zure asmoa**: Adierazi issue horretan lan egingo duzula bikoizkapena ekiditeko
3. **Jarraitu prozesua**: Irakurri [Ekarpenen Prozesua](#ekarpenen-prozesua) atala
4. **PR bat sortu**: Jarraitu [Pull Request Gida](#pull-request-gida)

### Dokumentazioa Hobetu

Dokumentazioa funtsezkoa da:

- **Akatsak zuzendu**: Idazkera-akatsak, esteka hautsiak, informazio zaharkitua
- **Dokumentazioa zabaldu**: Gehitu adibideak, diagramak, azalpen argiago-ak
- **Dokumentazioa itzuli**: Lagundu dokumentazioa beste hizkuntzeetara itzultzen
- **Tutorialak gehitu**: Sortu kasu erabilera ohikoetarako pausoko-gidak

### Hizkuntza Berrietara Itzuli

MedicApp-ek gaur egun 8 hizkuntza onartzen ditu. Berri bat gehitzeko edo lehendik daudenak hobetzeko, kontsultatu [Itzulpenak Gehitu](#itzulpenak-gehitu) atala.

---

## Ekarpenen Prozesua

Jarraitu pausu hauek ekarpena arrakastsua egiteko:

### 1. Biltegiaren Fork-a

Egin biltegiaren fork bat zure GitHub kontuan:

```bash
# GitHub-etik, egin klik "Fork"-en goiko eskuineko izkinan
```

### 2. Zure Fork-a Klonatu

Klonatu zure fork-a lokalki:

```bash
git clone https://github.com/ZURE_ERABILTZAILEA/medicapp.git
cd medicapp
```

### 3. Upstream Biltegira Konfiguratu

Gehitu jatorrizko biltegi "upstream" gisa:

```bash
git remote add upstream https://github.com/JATORRIZKO_BILTEGI/medicapp.git
git fetch upstream
```

### 4. Adar Bat Sortu

Sortu adar deskribatzaile bat zure lanerako:

```bash
# Funtzionalitate berrietarako
git checkout -b feature/izen-deskribatzailea

# Bug zuzenketentzat
git checkout -b fix/bug-izena

# Dokumentaziorako
git checkout -b docs/aldaketa-deskribapena

# Test-etarako
git checkout -b test/test-deskribapena
```

**Adar izen konbentzioak:**
- `feature/` - Funtzionalitate berria
- `fix/` - Bug zuzenketa
- `docs/` - Dokumentazio aldaketak
- `test/` - Test-ak gehitu edo hobetu
- `refactor/` - Aldaketa funtzionalik gabeko refaktorizazioa
- `style/` - Formatu/estilo aldaketak
- `chore/` - Mantentze lanak

### 5. Aldaketak Egin

Egin zure aldaketak [Kode Konbentzioak](#kode-konbentzioak) jarraituz.

### 6. Test-ak Idatzi

**Kode aldaketa guztiek test egokiak izan behar dituzte:**

```bash
# Test-ak garapenean exekutatu
flutter test

# Test espezifikoak exekutatu
flutter test test/bidea/test-ra.dart

# Estaldura ikusi
flutter test --coverage
```

Kontsultatu [Testing Gida](#testing-gida) atala xehetasun gehiagotan.

### 7. Kodea Formateatu

Ziurtatu zure kodea zuzen formateatuta dagoela:

```bash
# Proiektu osoa formateatu
dart format .

# Analisi estatikoa egiaztatu
flutter analyze
```

### 8. Commit-ak Egin

Sortu commit-ak [Commit Konbentzioak](#commit-konbentzioak) jarraituz:

```bash
git add .
git commit -m "feat: gehitu birkargaren gogorarazpen jakinarazpena"
```

### 9. Zure Adarra Eguneratuta Mantendu

Sinkronizatu erregularki upstream biltegiarekin:

```bash
git fetch upstream
git rebase upstream/main
```

### 10. Aldaketen Push-a

Igo zure aldaketak zure fork-era:

```bash
git push origin zure-adar-izena
```

### 11. Pull Request Sortu

Sortu PR bat GitHub-etik [Pull Request Gida](#pull-request-gida) jarraituz.

---

## Kode Konbentzioak

Kode koherentea mantentzea funtsezkoa da proiektuaren mantenigarritasunerako.

### Dart Style Guide

[Dart-en Estilo Gida](https://dart.dev/guides/language/effective-dart/style) ofiziala jarraitzen dugu:

- **Klase izenak**: `PascalCase` (adib. `MedicationService`)
- **Aldagai/funtzio izenak**: `camelCase` (adib. `getMedications`)
- **Konstante izenak**: `camelCase` (adib. `maxNotifications`)
- **Fitxategi izenak**: `snake_case` (adib. `medication_service.dart`)
- **Karpeta izenak**: `snake_case` (adib. `notification_service`)

### Linting

Proiektuak `flutter_lints` erabiltzen du `analysis_options.yaml`-en konfiguratuta:

```bash
# Analisi estatikoa exekutatu
flutter analyze

# Ez luke errorerik edo oharrik izan behar
```

PR guztiek analisia akatsik eta oharrik gabe pasatu behar dute.

### Formateatzea Automatikoa

Erabili `dart format` commit egin aurretik:

```bash
# Kode osoa formateatu
dart format .

# Fitxategi espezifikoa formateatu
dart format lib/services/medication_service.dart
```

**Editoreetan konfigurazioa:**

- **VS Code**: Gaitu "Format On Save" konfigurazioan
- **Android Studio**: Settings > Editor > Code Style > Dart > Set from: Dart Official

### Izendapen Konbentzioak

**Aldagai booleanoak:**
```dart
// Ona
bool isActive = true;
bool hasNotifications = false;
bool requiresFasting = true;

// Txarra
bool active = true;
bool notifications = false;
```

**Balioak itzultzen dituzten metodoak:**
```dart
// Ona
List<Medication> getMedications();
Future<bool> saveMedication(Medication med);
String calculateNextDose();

// Txarra
List<Medication> medications();
Future<bool> medication(Medication med);
```

**Metodo pribatuak:**
```dart
// Ona
void _updateDatabase() { }
String _formatDate(DateTime date) { }

// Txarra
void updateDatabase() { }  // pribatua izan behar luke
String formatDate(DateTime date) { }  // pribatua izan behar luke
```

### Fitxategien Eraketa

**Import-en ordena:**
```dart
// 1. dart: Imports
import 'dart:async';
import 'dart:convert';

// 2. package: Imports
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

// 3. Proiektuaren import erlatiboak:
import '../models/medication.dart';
import '../services/database_service.dart';
```

**Kideen ordena klaseetan:**
```dart
class Example {
  // 1. Eremu estatikoak
  static const int maxValue = 100;

  // 2. Instantzia eremuak
  final String name;
  int count;

  // 3. Eraikitzailea
  Example(this.name, this.count);

  // 4. Metodo publikoak
  void publicMethod() { }

  // 5. Metodo pribatuak
  void _privateMethod() { }
}
```

### Iruzkinak eta Dokumentazioa

**API publikoen dokumentazioa:**
```dart
/// Pertsona espezifiko baten medikamentu guztiak lortzen ditu.
///
/// [Medication] zerrenda bat itzultzen du emandako [personId]-rako.
/// Zerrenda alfabetikoki ordenatuta dago izenez.
///
/// [DatabaseException] jaurti daiteke datu-basean akats bat gertatzen bada.
Future<List<Medication>> getMedicationsByPerson(String personId) async {
  // Inplementazioa...
}
```

**Inline iruzkinak beharrezkoa denean:**
```dart
// Kalkulatu geratzen diren egunak batez besteko kontsumoan oinarrituta
final daysRemaining = stockQuantity / averageDailyConsumption;
```

**Ekidin iruzkin argiak:**
```dart
// Txarra - iruzkina beharrezkoa
// Zenbatzailea 1ean handitu
count++;

// Ona - kode auto-deskribatzailea
count++;
```

---

## Commit Konbentzioak

Commit semantikoak erabiltzen ditugu historia argị eta irakurgarri bat mantentzeko.

### Formatua

```
mota: deskribapen laburra minuskul​az

[gorputz aukerakoa xehetasun gehiagorekin]

[footer aukerakoa issue-en erreferentziekin]
```

### Commit Motak

| Mota | Deskribapena | Adibidea |
|------|-------------|---------|
| `feat` | Funtzionalitate berria | `feat: gehitu pertsona anitzeko euskarria` |
| `fix` | Bug zuzenketa | `fix: zuzendu stock kalkulua ordu-zona desberdinean` |
| `docs` | Dokumentazio aldaketak | `docs: eguneratu instalazio gida` |
| `test` | Test-ak gehitu edo aldatu | `test: gehitu gauerdiкo barauaren test-ak` |
| `refactor` | Aldaketa funtzionalik gabeko refaktorizazioa | `refactor: atera jakinarazpen logika zerbitzura` |
| `style` | Formatu aldaketak | `style: formateatu kodea dart format arabera` |
| `chore` | Mantentze lanak | `chore: eguneratu mendekotasunak` |
| `perf` | Errendimendu hobekuntzak | `perf: optimizatu datu-base kontsultak` |

### Commit Onen Adibideak

```bash
# Ezaugarri berria deskribape​narekin
git commit -m "feat: gehitu barau jakinarazpenak iraupena pertsonalizagarriekin"

# Fix issue erreferentziarekin
git commit -m "fix: zuzendu hurrengo dosiaren kalkulua (#123)"

# Docs
git commit -m "docs: gehitu ekarpen atala README-n"

# Test
git commit -m "test: gehitu hainbat baraurako integrazio test-ak"

# Refactor testuinguruarekin
git commit -m "refactor: banatu medikamentu logika klase espezifikoetara

- Sortu MedicationValidator balioztapenetarako
- Atera stock kalkuluak MedicationStockCalculator-era
- Hobetu kodearen irakurgarritasuna"
```

### Ekiditako Commit Adibideak

```bash
# Txarra - lausoegia
git commit -m "fix bug"
git commit -m "update"
git commit -m "changes"

# Txarra - motarik gabe
git commit -m "gehitu funtzionalitate berria"

# Txarra - mota okerra
git commit -m "docs: gehitu pantaila berria"  # 'feat' izan behar luke
```

### Arau Gehigarriak

- **Lehen letra minuskulaz**: "feat: gehitu..." ez "feat: Gehitu..."
- **Puntu finalik ez**: "feat: gehitu euskarria" ez "feat: gehitu euskarria."
- **Modu inperatiboan**: "gehitu" ez "gehituta" edo "gehitzen"
- **Gehienez 72 karaktere**: Mantendu lehen lerroa laburra
- **Gorputz aukerakoa**: Erabili gorputza "zergatia" azaltzeko, ez "zera"

---

## Pull Request Gida

### PR Sortu Aurretik

**Egiaztaketa-zerrenda:**

- [ ] Zure kodea akatsik gabe konpilatzen da: `flutter run`
- [ ] Test guztiak gainditzen dira: `flutter test`
- [ ] Kodea formateatuta dago: `dart format .`
- [ ] Ez dago analisiaren oharrik: `flutter analyze`
- [ ] Zure aldaketarako test-ak gehitu dituzu
- [ ] Test estaldura >= %75 mantentzen da
- [ ] Dokumentazioa eguneratu duzu beharrezkoa bada
- [ ] Commit-ak konbentzioak jarraitzen dituzte
- [ ] Zure adarra `main`-arekin eguneratuta dago

### Pull Request Sortu

**Titulu deskribatzailea:**

```
feat: gehitu barau aldi pertsonalizagarriak
fix: zuzendu gauerdiкo jakinarazpenetan crash-a
docs: hobetu arkitekturaren dokumentazioa
```

**Deskribapen xehekatua:**

```markdown
## Deskribapena

PR honek barau aldi pertsonalizagarrien euskarria gehitzen du, erabiltzaileei medikamentua hartu aurretik edo ondoren iraupena espezifikoak konfiguratzeko aukera emanez.

## Egindako Aldaketak

- Gehitu `fastingType` eta `fastingDurationMinutes` eremuak Medication model-era
- Inplementatu barau-aldien balioztapen logika
- Gehitu UI baraua konfiguratzeko medikamentua editatzeko pantailan
- Sortu ongoing jakinarazpenak barau-aldi aktiboentzat
- Gehitu test exhaustiboak (15 test berri)

## Aldaketa Mota

- [x] Funtzionalitate berria (lehendik dagoen kodea hautsi gabe funtzionalitatea gehitzen duen aldaketa)
- [ ] Bug zuzenketa (arazoa konpontzen duen aldaketa)
- [ ] Bateragarritasuna haust en duen aldaketa (fix edo feature-ak lehendik dagoen funtzionalitatea aldatzea eragingo lukeen)
- [ ] Aldaketa honek dokumentazio eguneraketa behar du

## Pantaila-argazkiak

_Aplikatzen bada, gehitu UI aldaketen pantaila-argazkiak_

## Test-ak

- [x] Unit test-ak gehituta
- [x] Integrazio test-ak gehituta
- [x] Lehendik dauden test guztiak gainditzen dira
- [x] Estaldura >= %75

## Egiaztaketa-zerrenda

- [x] Kodeak proiektuaren konbentzioak jarraitzen ditu
- [x] Nire kode propioa berrikusi dut
- [x] Area konplexuetan iruzkindu dut
- [x] Dokumentazioa eguneratu dut
- [x] Nire aldaketak ez dute oharrik sortzen
- [x] Test-ak gehitu ditut nire fix/funtzionalitatea frogatzen dutenak
- [x] Test berri eta existenteak lokalki gainditzen dira

## Erlazionatutako Issue-ak

Closes #123
Erlazionатua #456 rekin
```

### Berrikusketan Zehar

**Erantzun iruzkinei:**
- Eskertu feedbacka
- Galderak argitasunez erantzun
- Eskatutako aldaketak azkar egin
- Markatu elkarrizketak konponduta bezala aldaketak aplikatu ondoren

**Mantendu PR eguneratuta:**
```bash
# Main-en aldaketak badaude, eguneratu zure adarra
git fetch upstream
git rebase upstream/main
git push origin zure-adarra --force-with-lease
```

### Merge Ondoren

**Garbiketa:**
```bash
# Eguneratu zure fork-a
git checkout main
git pull upstream main
git push origin main

# Ezabatu adar lokala
git branch -d zure-adarra

# Ezabatu urruneko adarra (aukerakoa)
git push origin --delete zure-adarra
```

---

## Testing Gida

Testing **obligatorioa** da kode ekarpena guztietarako.

### Printzipioak

- **PR guztiek test-ak izan behar dituzte**: Salbuespen gabe
- **Mantendu gutxieneko estaldura**: >= %75
- **Test-ak independenteak izan behar dira**: Test bakoitza bakarrik exekutatu behar da
- **Test-ak deterministikoak izan behar dira**: Input bera = output bera beti
- **Test-ak azkarrak izan behar dira**: < 1 segundo unit test bakoitzeko

### Test Motak

**Unit Test-ak:**
```dart
// test/models/medication_test.dart
void main() {
  group('Medication', () {
    test('stock egunak zuzen kalkulatzen ditu', () {
      final medication = MedicationBuilder()
        .withStock(30.0)
        .withSingleDose('08:00', 1.0)
        .build();

      expect(medication.calculateDaysRemaining(), equals(30));
    });
  });
}
```

**Widget Test-ak:**
```dart
// test/screens/medication_list_screen_test.dart
void main() {
  testWidgets('medikamentuen zerrenda zuzen erakusten du', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: MedicationListScreen()),
    );

    expect(find.text('Nire Medikamentuak'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });
}
```

**Integrazio Test-ak:**
```dart
// test/integration/medication_flow_test.dart
void main() {
  testWidgets('medikamentua gehitzeko fluxu osoa', (tester) async {
    // Setup
    await tester.pumpWidget(MyApp());

    // Gehitu medikamentua
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Egiaztatu nabigazioa eta gordetzea
    expect(find.text('Medikamentu Berria'), findsOneWidget);
  });
}
```

### MedicationBuilder Erabili

Test medikamentuak sortzeko, erabili `MedicationBuilder` helper-a:

```dart
import 'package:medicapp/test/helpers/medication_builder.dart';

// Oinarrizko medikamentua
final med = MedicationBuilder()
  .withName('Aspirina')
  .withStock(20.0)
  .build();

// Barauarekin
final medWithFasting = MedicationBuilder()
  .withName('Ibuprofeno')
  .withFasting(type: 'before', duration: 60)
  .build();

// Hainbat dosirekin
final medMultipleDoses = MedicationBuilder()
  .withName('C Bitamina')
  .withMultipleDoses(['08:00', '14:00', '20:00'], 1.0)
  .build();

// Stock baxuarekin
final medLowStock = MedicationBuilder()
  .withName('Parazeta mola')
  .withLowStock()
  .build();
```

### Test-ak Exekutatu

```bash
# Test guztiak
flutter test

# Test espezifikoa
flutter test test/models/medication_test.dart

# Estaldurarekin
flutter test --coverage

# Estaldura txostena ikusi (genhtml behar du)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Test Estaldura

**Helburua: >= %75ko estaldura**

```bash
# Txostena sortu
flutter test --coverage

# Estaldura fitxategiko ikusi
lcov --list coverage/lcov.info
```

**Test-ak izan BEHAR dituzten area kritikoak:**
- Modeloak eta negozio-logika (%95+)
- Zerbitzuak eta utilit atak (%90+)
- Pantaila eta widget nagusiak (%70+)

**Estaldura txikiagoa izan dezaketen areак:**
- Widget hutsuki bisualak
- Hasierako konfigurazioa (main.dart)
- Automatikoki sortutako fitxategiak

---

## Funtzionalitate Berriak Gehitu

### Hasi Aurretik

1. **Lehenik issue batean eztabaidatu**: Sortu issue bat zure proposamena deskribatuz
2. **Itxaron feedbacka**: Mantentzaileek berrikusi eta feedbacka emango dute
3. **Lortu onarpena**: Itxaron berde argira inplementatzean denbora inbertitu aurretik

### Jarraitu Arkitektura

MedicApp **MVS (Model-View-Service) arkitektura** erabiltzen du:

```
lib/
├── models/           # Datu-modeloak
├── screens/          # Ikuspegia (UI)
├── services/         # Negozio-logika
└── l10n/            # Itzulpenak
```

**Printzipioak:**
- **Models**: Datuak soilik, negozio-logikarik ez
- **Services**: Negozio-logika eta datu-sarrera osoa
- **Screens**: UI bakarrik, logika gutxien

**Funtzionalitate berriaren adibidea:**

```dart
// 1. Gehitu modeloa (beharrezkoa bada)
// lib/models/reminder.dart
class Reminder {
  final String id;
  final String medicationId;
  final DateTime reminderTime;

  Reminder({required this.id, required this.medicationId, required this.reminderTime});
}

// 2. Gehitu zerbitzua
// lib/services/reminder_service.dart
class ReminderService {
  Future<void> scheduleReminder(Reminder reminder) async {
    // Negozio-logika
  }
}

// 3. Gehitu pantaila/widget-a
// lib/screens/reminder_screen.dart
class ReminderScreen extends StatelessWidget {
  // UI bakarrik, delegatu logika zerbitzura
}

// 4. Gehitu test-ak
// test/services/reminder_service_test.dart
void main() {
  group('ReminderService', () {
    test('schedule reminder jakinarazpena sortzen du', () async {
      // Test
    });
  });
}
```

### Eguneratu Dokumentazioa

Funtzionalitate berria gehitzean:

- [ ] Eguneratu `docs/es/features.md`
- [ ] Gehitu erabilera adibideak
- [ ] Eguneratu diagramak aplikatzen bada
- [ ] Gehitu dokumentazio iruzkinak kodean

### Kontuan Izan Nazioartekotzea

MedicApp 8 hizkuntza onartzen ditu. **Funtzionalitate berri guztiak itzuli behar dira:**

```dart
// Hard-coded testuaren ordez:
Text('Medikamentu Berria')

// Erabili itzulpenak:
Text(AppLocalizations.of(context)!.newMedication)
```

Gehitu gakoak `.arb` fitxategi guztietan:
- `lib/l10n/app_es.arb`
- `lib/l10n/app_en.arb`
- `lib/l10n/app_de.arb`
- `lib/l10n/app_fr.arb`
- `lib/l10n/app_it.arb`
- `lib/l10n/app_ca.arb`
- `lib/l10n/app_eu.arb`
- `lib/l10n/app_gl.arb`

### Gehitu Test Exhaustiboak

Funtzionalitate berriak test osoak behar ditu:

- Logika osorako unit test-ak
- UI-rako widget test-ak
- Fluxu osoetarako integrazio test-ak
- Edge case eta akats test-ak

---

## Bug-en Txostena

### Beharrezko Informazioa

Bug-aren bat txostenatzean, sartu:

**1. Bug-aren deskribapena:**
Arazoaren deskribapen argi eta zehatza.

**2. Erreproduzitzeko pausoak:**
```
1. Joan 'Medikamentuak' pantailara
2. Egin klik 'Gehitu medikamentua'-n
3. Konfiguratu 60 minutuko baraua
4. Gorde medikamentua
5. Ikusi errorea kontsolan
```

**3. Portaera esperoا:**
"Medikamentua barauaren konfigurazioarekin gorde beharko litzateke."

**4. Uneko portaera:**
"'Invalid fasting duration' errorea erakusten da eta ez da medikamentua gordetzen."

**5. Pantaila-argazkiak/Bideoak:**
Aplikatzen bada, gehitu pantaila-argazkiak edo pantaila grabaketa.

**6. Log-ak/Akatsak:**
```
[ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception:
Invalid fasting duration
#0      Medication.validate (package:medicapp/models/medication.dart:123)
```

**7. Ingurunea:**
```
- Flutter bertsioa: 3.9.2
- Dart bertsioa: 3.0.0
- Gailua: Samsung Galaxy S21
- SE: Android 13
- MedicApp bertsioa: 1.0.0
```

**8. Testuinguru gehigarria:**
Arazoari buruzko beste informazio garrantzitsurik.

### Issue Template-a

```markdown
## Bug-aren Deskribapena
[Deskribapen argi eta zehatza]

## Erreproduzitzeko Pausoak
1.
2.
3.

## Portaera Esperoა
[Zer gertatu behar luke]

## Uneko Portaera
[Zer gertatzen ari da]

## Pantaila-argazkiak
[Aplikatzen bada]

## Log-ak/Akatsak
```
[Kopiatu log-ak hemen]
```

## Ingurunea
- Flutter bertsioa:
- Dart bertsioa:
- Gailua:
- SE eta bertsioa:
- MedicApp bertsioa:

## Testuinguru Gehigarria
[Informazio gehigarria]
```

---

## Itzulpenak Gehitu

MedicApp 8 hizkuntza onartzen ditu. Lagundu kalitate handiko itzulpenak mantentzen.

### Fitxategien Kokapena

Itzulpen fitxategiak hemen daude:

```
lib/l10n/
├── app_es.arb    # Gaztelania (oinarria)
├── app_en.arb    # Ingelesa
├── app_de.arb    # Alemana
├── app_fr.arb    # Frantsesa
├── app_it.arb    # Italiera
├── app_ca.arb    # Katalana
├── app_eu.arb    # Euskara
└── app_gl.arb    # Galiziera
```

### Hizkuntza Berri Bat Gehitu

**1. Kopiatu txantiloia:**
```bash
cp lib/l10n/app_es.arb lib/l10n/app_XX.arb
```

**2. Itzuli gako guztiak:**
```json
{
  "appTitle": "MedicApp",
  "@appTitle": {
    "description": "Aplikazioaren izenburua"
  },
  "medications": "Medikamentuak",
  "@medications": {
    "description": "Medikamentuen pantailaren izenburua"
  }
}
```

**3. Eguneratu `l10n.yaml`** (existitzen bada):
```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
```

**4. Erregistratu hizkuntza `MaterialApp`-en:**
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
    const Locale('XX'),  // Hizkuntza berria
  ],
  // ...
)
```

**5. Exekutatu kode sortzea:**
```bash
flutter pub get
# Itzulpenak automatikoki sortzen dira
```

**6. Probatu app-ean:**
```dart
// Aldatu hizkuntza aldi baterako probatzeko
Locale('XX')
```

### Lehendik Dauden Itzulpenak Hobetu

**1. Identifikatu fitxategia:**
Adibidez, ingelesa hobetzeko: `lib/l10n/app_en.arb`

**2. Bilatu gakoa:**
```json
{
  "lowStockWarning": "Low stock warning",
  "@lowStockWarning": {
    "description": "Stock baxuko oharra"
  }
}
```

**3. Hobetu itzulpena:**
```json
{
  "lowStockWarning": "Medikamentua amaitzen ari da",
  "@lowStockWarning": {
    "description": "Oharra medikamentua gutxi geratzen denean"
  }
}
```

**4. Sortu PR** aldaketarekin.

### Itzulpen Gidalerroak

- **Mantendu koherentzia**: Erabili termino berdinak itzulpen guztietan zehar
- **Testuinguru egokia**: Kontuan izan testuinguru medikoa
- **Luzera arrazoizkoa**: Ekidin UI-a haust​en duten itzulpen luze-egiak
- **Formalitasua**: Erabili tonu profesionala baina atsegina
- **Probatu UI-an**: Egiaztatu itzulpena pantailan ondo ikusten dela

---

## Garapen Ingurunearen Konfigurazioa

### Eskakizunak

- **Flutter SDK**: 3.9.2 edo berriagoa
- **Dart SDK**: 3.0 edo berriagoa
- **Editorea**: VS Code edo Android Studio gomendatua
- **Git**: Bertsioen kontrolerako

### Flutter Instalazioa

**macOS/Linux:**
```bash
# Deskargatu Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Egiaztatu instalazioa
flutter doctor
```

**Windows:**
1. Deskargatu Flutter SDK [flutter.dev](https://flutter.dev)-etik
2. Atera `C:\src\flutter`-ra
3. Gehitu `C:\src\flutter\bin` PATH-era
4. Exekutatu `flutter doctor`

### Editorearen Konfigurazioa

**VS Code (Gomendatua):**

1. **Instalatu hedapenak:**
   - Flutter
   - Dart
   - Flutter Widget Snippets (aukerakoa)

2. **Konfiguratu settings.json:**
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

3. **Lasterbide erabilgarriak:**
   - `Cmd/Ctrl + .` - Ekintza azkarrak
   - `Cmd/Ctrl + Shift + P` - Command Palette
   - `F5` - Debug
   - `Ctrl + F5` - Run debug gabe

**Android Studio:**

1. **Instalatu plugin-ak:**
   - Flutter plugin
   - Dart plugin

2. **Konfiguratu:**
   - Settings > Editor > Code Style > Dart
   - Set from: Dart Official
   - Line length: 80

### Linter-aren Konfigurazioa

Proiektuak `flutter_lints` erabiltzen du. Dagoeneko konfiguratuta dago `analysis_options.yaml`-en.

```bash
# Exekutatu analisia
flutter analyze

# Ikusi arazoak denbora errealean editorean
# (automatikoa VS Code eta Android Studio-n)
```

### Git Konfigurazioa

```bash
# Konfiguratu identitatea
git config --global user.name "Zure Izena"
git config --global user.email "zu@email.com"

# Konfiguratu lehenetsitako editorea
git config --global core.editor "code --wait"

# Konfiguratu alias erabilgarriak
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
```

### Proiektua Exekutatu

```bash
# Instalatu mendekotasunak
flutter pub get

# Exekutatu emuladorean/gailuan
flutter run

# Exekutatu debug moduan
flutter run --debug

# Exekutatu release moduan
flutter run --release

# Hot reload (exekutatzean)
# Sakatu 'r' terminalean

# Hot restart (exekutatzean)
# Sakatu 'R' terminalean
```

### Ohiko Arazoak

**"Flutter SDK not found":**
```bash
# Egiaztatu PATH
echo $PATH  # macOS/Linux
echo %PATH%  # Windows

# Gehitu Flutter PATH-era
export PATH="$PATH:/bidea/flutter-ra/bin"  # macOS/Linux
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

## Baliabide Erabilgarriak

### Proiektuaren Dokumentazioa

- [Instalazio Gida](installation.md)
- [Ezaugarriak](features.md)
- [Arkitektura](architecture.md)
- [Datu-Basea](database.md)
- [Proiektuaren Egitura](project-structure.md)
- [Teknologiak](technologies.md)

### Kanpoko Dokumentazioa

**Flutter:**
- [Flutter Dokumentazioa](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Widget Catalog](https://docs.flutter.dev/development/ui/widgets)

**Material Design 3:**
- [Material Design Gidalerroak](https://m3.material.io/)
- [Material Osagaiak](https://m3.material.io/components)
- [Material Theming](https://m3.material.io/foundations/customization)

**SQLite:**
- [SQLite Dokumentazioa](https://www.sqlite.org/docs.html)
- [SQLite Tutorial](https://www.sqlitetutorial.net/)
- [sqflite Paketea](https://pub.dev/packages/sqflite)

**Testing:**
- [Flutter Testing](https://docs.flutter.dev/testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)

### Tresnak

- [Dart Pad](https://dartpad.dev/) - Dart-en online playground
- [FlutLab](https://flutlab.io/) - Flutter-en online IDE
- [DartDoc](https://dart.dev/tools/dartdoc) - Dokumentazio sortzailea
- [Flutter Inspector](https://docs.flutter.dev/development/tools/devtools/inspector) - Widget-en debug

### Komunitatea

- [Flutter Discord](https://discord.gg/flutter)
- [r/FlutterDev](https://www.reddit.com/r/FlutterDev/)
- [Stack Overflow - Flutter](https://stackoverflow.com/questions/tagged/flutter)

---

## Maiz Egindako Galderak

### Nola has naiteke ekarpenak egiten?

1. Irakurri gida hau osorik
2. Konfiguratu zure garapen ingurunea
3. Bilatu `good first issue` etiketadun issue-ak
4. Iruzkindu issue-an lan egingo duzula
5. Jarraitu [Ekarpenen Prozesua](#ekarpenen-prozesua)

### Non lagundu dezaket?

Beti behar dugun laguntza duten areак:

- **Itzulpenak**: Hobetu edo gehitu itzulpenak
- **Dokumentazioa**: Zabaldu edo hobetu docs
- **Test-ak**: Handitu test estaldura
- **Bug-ak**: Konpondu txostenatutako issue-ak
- **UI/UX**: Hobetu interfazea eta erabiltzaile-esperientzia

Bilatu etiketa hauekin issue-ak:
- `good first issue` - Hasteko ideala
- `help wanted` - Hemen laguntza behar dugu
- `documentation` - Dokumentazioaz erlazionatua
- `translation` - Itzulpenak
- `bug` - Txostenatutako bug-ak

### Zenbat denbora behar da berrikusketetarako?

- **PR txikiak** (< 100 lerro): 1-2 egun
- **PR ertainak** (100-500 lerro): 3-5 egun
- **PR handiak** (> 500 lerro): 1-2 aste

**Berrikusketa azkarragoentzako aholkuak:**
- Mantendu PR-ak txiki eta fokatu
- Idatzi deskribapen onak
- Erantzun iruzkinei azkar
- Sartu test osoak

### Zer egin nire PR-a onartzen ez badute?

Ez galdu animoak. Arrazoiak izan daitezke:

1. **Proiektuaren ikuspegira baturik ez**: Eztabaidatu ideia issue batean lehenik
2. **Aldaketak behar ditu**: Aplikatu feedbacka eta eguneratu PR-a
3. **Arazo teknikoak**: Konpondu aipatutako arazoak
4. **Timing-a**: Agian ez da momentu egokia, baina berrikusi egingo da geroago

**Beti zerbait baliozko ikasiko duzu proze sutik.**

### Aldi berean hainbat issue-tan lan egin dezaket?

Gomendatzen dugu batera batean fokatzea:

- Osatu issue bat beste bat hasi aurretik
- Ekidin issue-ak beste batentzat blokeatzea
- Pausatu behar baduzu, iruzkindu issue-an

### Nola kudeatzen ditut merge gatazkak?

```bash
# Eguneratu zure adarra main-ekin
git fetch upstream
git rebase upstream/main

# Gatazkak badaude, Git-ek esango dizu
# Konpondu gatazkak zure editorean
# Gero:
git add .
git rebase --continue

# Push (force-ekin jada lehenago push egin baduzu)
git push origin zure-adarra --force-with-lease
```

### CLA bat sinatu behar dut?

Gaur egun **EZ** dugu CLA (Contributor License Agreement) eskatzen. Ekarpenak egitean, onartzen duzu zure kodea AGPL-3.0 lizentziapean lizentziatzea.

### Ekarpenak anonimoki egin ditzaket?

Bai, baina GitHub kontu bat behar duzu. Erabili ahal duzu erabiltzaile-izen anonimo bat nahiago baduzu.

---

## Kontaktua eta Komunitatea

### GitHub Issues

Komunikaziorako modu nagusia da [GitHub Issues](../../issues) bidez:

- **Bug-en txostena**: Sortu issue bat `bug` etiketarekin
- **Hobetzeko iradokizunak**: Sortu issue bat `enhancement` etiketarekin
- **Galderak egin**: Sortu issue bat `question` etiketarekin
- **Ideiak eztabaidatu**: Sortu issue bat `discussion` etiketarekin

### Discussions (aplikatzen bada)

Biltegiak GitHub Discussions gaituta baditu:

- Galdera orokorrak
- Erakutsi zure proiektuak MedicApp-ekin
- Partekatu ideiak
- Lagundu beste erabiltzaileei

### Erantzun Denborak

- **Issue urgenteak** (bug kritikoak): 24-48 ordu
- **Issue normalak**: 3-7 egun
- **PR-ak**: Tamainaren arabera (ikusi FAQ)
- **Galderak**: 2-5 egun

### Mantentzaileak

Proiektuaren mantentzaileek issue-ak, PR-ak berrikusi eta galderak erantzungo dituzte. Izan pazientzia, talde txikia gara eta gure denbora librean lan egiten dugu.

---

## Eskerrik Asko

Eskerrik asko gida hau irakurtzeagatik eta MedicApp-en ekarpenak egiteko interesa izateagatik.

Ekarpena bakoitzak, txikia bada ere, diferentzia egiten du aplikazio honetan oinarritzen duten erabiltzaileentzat beren osasuna kudeatzeko.

**Zure ekarpena itxaroten dugu!**

---

**Lizentzia:** Proiektu hau [AGPL-3.0](../../LICENSE) lizentziapean dago.

**Azken eguneraketa:** 2025-11-14
