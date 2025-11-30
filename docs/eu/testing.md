# Testing Gida - MedicApp

## Edukien Taula

1. [Testing-aren Ikuspegi Orokorra](#testing-aren-ikuspegi-orokorra)
2. [Test-en Egitura](#test-en-egitura)
3. [Unit Test-ak](#unit-test-ak)
4. [Widget Test-ak](#widget-test-ak)
5. [Integrazio Test-ak](#integrazio-test-ak)
6. [Testing Helper-ak](#testing-helper-ak)
7. [Test Estaldura](#test-estaldura)
8. [Estalitako Kasu Mugakoak](#estalitako-kasu-mugakoak)
9. [Test-ak Exekutatu](#test-ak-exekutatu)
10. [Test-ak Idazteko Gida](#test-ak-idazteko-gida)
11. [Datu-Basearen Testing](#datu-basearen-testing)
12. [CI/CD eta Testing Automatizatua](#cicd-eta-testing-automatizatua)
13. [Hurrengo Urratsak](#hurrengo-urratsak)

---

## Testing-aren Ikuspegi Orokorra

MedicApp-ek test-suite sendo eta ondo egituratua du kodearen kalitatea eta egonkortasuna bermatzen duena:

- **601+ test automatizatu** 57 fitxategitan banatuta
- **%75-80ko kode-estaldura** area kritikoetan
- **Test-mota anitz**: unitarioak, widget-ak eta integrazioa
- **Test-Driven Development (TDD)** funtzionalitate berrietarako
- **Estaldura neurgarria**: `flutter test --coverage` erabiltzeko euskarri integratua

### Testing Filosofia

Gure testing estrategia honetan oinarritzen da:

1. **Test-ak dokumentazio gisa**: Test-ek sistemaren portaera esperoaren dokumentu gisa balio dute
2. **Estaldura adimentsua**: Area kritikoetan fokusu (jakinarazpenak, baraua, dosien kudeaketa)
3. **Fast feedback**: Memorian exekutatzen diren test azkarrak
4. **Isolation**: Test bakoitza independentea da eta ez ditu besteei eragiten
5. **Errealisrno**: Integrazio-test-ak erabiltzaile fluxu errealak simulatzen dituztenak

### Test Motak

```
test/
├── unitarios/          # Zerbitzu, modelo eta negozio-logiкaren testak
├── widgets/            # Osagai eta pantaila indibidualen testak
└── integration/        # Fluxu osoen end-to-end testak
```

---

## Test-en Egitura

Test direktorioa modu argi eta logikoan antolatuta dago:

```
test/
├── helpers/                              # Test artean partekatutako utilitateak
│   ├── medication_builder.dart           # Medikamentuak sortzeko Builder pattern
│   ├── database_test_helper.dart         # Datu-basearen setup eta cleanup
│   ├── widget_test_helpers.dart          # Widget test-etarako helper-ak
│   ├── person_test_helper.dart           # Pertsonen kudeaketarako helper-ak
│   ├── notification_test_helper.dart     # Jakinarazpen test-etarako helper-ak
│   ├── test_constants.dart               # Partekatutako konstanteak
│   └── test_helpers.dart                 # Helper generalak
│
├── integration/                          # Integrazio-test-ak (9 fitxategi)
│   ├── add_medication_test.dart          # Medikamentua gehitzeko fluxu osoa
│   ├── edit_medication_test.dart         # Edizio-fluxua
│   ├── delete_medication_test.dart       # Ezabaketa-fluxua
│   ├── dose_registration_test.dart       # Dosi-erregistroa
│   ├── stock_management_test.dart        # Stock kudeaketa
│   ├── medication_modal_test.dart        # Xehetasun modala
│   ├── navigation_test.dart              # Pantailen arteko nabigazioa
│   ├── app_startup_test.dart             # Aplikazioaren hasiera
│   └── debug_menu_test.dart              # Arazketa-menua
│
└── [41 unit/widget test fitxategi]
```

### Test Fitxategiak Kategoriaka

#### Zerbitzu Test-ak (13 fitxategi)
- `notification_service_test.dart` - Jakinarazpen-zerbitzua
- `dose_action_service_test.dart` - Dosien gaineko ekintzak
- `dose_history_service_test.dart` - Dosien historiala
- `preferences_service_test.dart` - Erabiltzaile hobespenak
- Eta gehiago...

#### Core Funtzionalitate Test-ak (18 fitxategi)
- `medication_model_test.dart` - Medikamentu modeloa
- `dose_management_test.dart` - Dosien kudeaketa
- `extra_dose_test.dart` - Dosi gehigarria
- `database_refill_test.dart` - Stock birkargak
- `database_export_import_test.dart` - Esportazioa/inportazioa
- Eta gehiago...

#### Barauaren Test-ak (6 fitxategi)
- `fasting_test.dart` - Barauaren logika
- `fasting_notification_test.dart` - Barauaren jakinarazpenak
- `fasting_countdown_test.dart` - Barauaren kontu atzekaria
- `fasting_field_preservation_test.dart` - Eremuen preserβazioa
- `early_dose_with_fasting_test.dart` - Aurreratutako dosia barauarekin
- `multiple_fasting_prioritization_test.dart` - Hainbat barauaren lehentasuna

#### Pantaila Test-ak (14 fitxategi)
- `edit_schedule_screen_test.dart` - Ordutegi-edizio pantaila
- `edit_duration_screen_test.dart` - Iraupena-edizio pantaila
- `edit_fasting_screen_test.dart` - Baraua-edizio pantaila
- `edit_screens_validation_test.dart` - Balioztapenak
- `settings_screen_test.dart` - Konfigurazio pantaila
- `day_navigation_ui_test.dart` - Egunen nabigazioa
- Eta gehiago...

---

## Unit Test-ak

Unit test-ek osagai indib idualen portaera modu isolatuan egiaztatzen dute.

### Zerbitzu Test-ak

Zerbitzuen negozio-logika egiaztatzen dute:

#### NotificationService

```dart
test('medikamentu desberdinerakID bakarra sortu behar du', () {
  final id1 = _generateNotificationId('med1', 0);
  final id2 = _generateNotificationId('med2', 0);

  expect(id1, isNot(equals(id2)));
});

test('jakinarazpen eragiketa guztiak test moduan kudeatu behar ditu', () async {
  service.enableTestMode();

  final medication = MedicationBuilder()
      .withId('test-med')
      .withSingleDose('08:00', 1.0)
      .build();

  await service.scheduleMedicationNotifications(
    medication,
    personId: 'test-person-id'
  );

  // Ez du salbuespenak jaurti behar
});
```

#### DoseActionService

```dart
test('dosia erregistratu eta stock-a eguneratu behar du', () async {
  final medication = MedicationBuilder()
      .withStock(20.0)
      .withSingleDose('08:00', 2.0)
      .build();

  await service.registerDose(medication, '08:00');

  final updated = await db.getMedication(medication.id);
  expect(updated.stockQuantity, 18.0); // 20 - 2
  expect(updated.takenDosesToday, contains('08:00'));
});
```

### Modelo Test-ak

Datuen serializ azioa eta deserializazioa egiaztatzen dute:

```dart
group('Medication Model - Barauaren Konfigurazioa', () {
  test('barauaren konfigurazioa JSON-era serializatu behar du', () {
    final medication = MedicationBuilder()
        .withId('test_6')
        .withMultipleDoses(['08:00', '16:00'], 1.0)
        .withFasting(type: 'before', duration: 60)
        .build();

    final json = medication.toJson();

    expect(json['requiresFasting'], 1);
    expect(json['fastingType'], 'before');
    expect(json['fastingDurationMinutes'], 60);
    expect(json['notifyFasting'], 1);
  });

  test('baraua JSON-etik deserializatu behar du', () {
    final json = {
      'id': 'test_8',
      'name': 'Test Medication',
      'requiresFasting': 1,
      'fastingType': 'before',
      'fastingDurationMinutes': 60,
      // ... beste eremua
    };

    final medication = Medication.fromJson(json);

    expect(medication.requiresFasting, true);
    expect(medication.fastingType, 'before');
    expect(medication.fastingDurationMinutes, 60);
  });
});
```

### Utilitate Test-ak

Funtzio lagungarriak eta kalkuluak egiaztatzen dituzte:

```dart
test('stock agortzeko egunak kalkulatu behar ditu', () {
  final medication = MedicationBuilder()
      .withStock(20.0)
      .withMultipleDoses(['08:00', '16:00'], 1.0) // 2 dosi/eguna
      .build();

  final days = calculateStockDuration(medication);

  expect(days, 10); // 20 unitate / 2 eguneko = 10 egun
});
```

---

## Widget Test-ak

Widget test-ek erabiltzaile-interfazea eta erabiltzailearen elkarrekintza egiaztatzen dute.

### Pantaila Test-ak

Pantailak zuzen errenderi zatzen direla eta elkarrekintzei erantzuten diotela egiaztatzen dute:

```dart
testWidgets('Lehenetsitako motarekin medikamentua gehitu behar du', (tester) async {
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  await addMedicationWithDuration(tester, 'Parazeta mola');
  await waitForDatabase(tester);

  expect(find.text('Parazeta mola'), findsOneWidget);
  expect(find.text('Pastilla'), findsAtLeastNWidgets(1));
});
```

### Osagai Test-ak

UI-ko osagai indibidualak egiaztatzen dituzte:

```dart
testWidgets('Barauaren kontu atzekariak erakutsi behar du', (tester) async {
  final medication = MedicationBuilder()
      .withFasting(type: 'after', duration: 120)
      .build();

  await tester.pumpWidget(
    MaterialApp(
      home: FastingCountdown(medication: medication),
    ),
  );

  expect(find.textContaining('2:00'), findsOneWidget);
});
```

### Mendekotasunen Mock-a

Widget test-etarako, mock-ak erabiltzen ditugu osagaiak isolatzeko:

```dart
setUp(() async {
  // SharedPreferences mock-a
  SharedPreferences.setMockInitialValues({});

  // Memorian datu-basea
  DatabaseHelper.setInMemoryDatabase(true);

  // Jakinarazpenetarako test modua
  NotificationService.instance.enableTestMode();

  // Lehenetsitako pertsona ziurtatu
  await DatabaseTestHelper.ensureDefaultPerson();
});
```

### Adibide Osoa: Edizio Testa

```dart
testWidgets('Medikamentuaren ordutegia editatu behar du', (tester) async {
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  // Medikamentua gehitu
  await addMedicationWithDuration(tester, 'Ibuprofeno');
  await waitForDatabase(tester);

  // Edizio-menua ireki
  await openEditMenuAndSelectSection(
    tester,
    'Ibuprofeno',
    'Orduak eta Kantitateak',
  );

  // Orduak aldatu
  final timeField = find.byType(TextFormField).first;
  await tester.enterText(timeField, '10:00');

  // Gorde
  await scrollToWidget(tester, find.text('Gorde'));
  await tester.tap(find.text('Gorde'));
  await waitForDatabase(tester);

  // Aldaketa egiaztatu
  expect(find.text('10:00'), findsOneWidget);
});
```

---

## Integrazio Test-ak

Integrazio test-ek end-to-end erabiltzaile-fluxu osoak egiaztatzen dituzte.

### End-to-End Test-ak

Erabiltzailearen portaera erreala simulatzen dute:

```dart
testWidgets('Fluxu osoa: Medikamentua gehitu eta dosia erregistratu',
    (tester) async {
  // 1. Aplikazioa hasi
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  // 2. Medikamentua gehitu
  await addMedicationWithDuration(
    tester,
    'Parazeta mola',
    stockQuantity: '20',
  );
  await waitForDatabase(tester);

  // 3. Zerrendan agertzen dela egiaztatu
  expect(find.text('Parazeta mola'), findsOneWidget);

  // 4. Xehetasun modala ireki
  await tester.tap(find.text('Parazeta mola'));
  await tester.pumpAndSettle();

  // 5. Dosia erregistratu
  await tester.tap(find.text('Dosia hartu'));
  await waitForComplexAsyncOperation(tester);

  // 6. Stock eguneratua egiaztatu
  await tester.tap(find.text('Parazeta mola'));
  await tester.pumpAndSettle();

  expect(find.textContaining('19'), findsOneWidget); // Stock - 1
});
```

### Fluxu Osoak

Integrazio test-ek fluxu garrantzitsuak estaltzen dituzte:

1. **Medikamentua gehitu**: `add_medication_test.dart`
   - Wizard-aren nabigazio osoa
   - Parametro guztien konfigurazioa
   - Zerrenda nagusian egiaztapena

2. **Medikamentua editatu**: `edit_medication_test.dart`
   - Atal bakoitzaren aldaketa
   - Aldatu gabeko datuen preserβazioa
   - Zerrendan eguneraketa zuzena

3. **Medikamentua ezabatu**: `delete_medication_test.dart`
   - Ezabaketaren berrespena
   - Jakinarazpenen garbiketa
   - Erlazionatutako historialaren ezabaketa

4. **Dosia erregistratu**: `dose_registration_test.dart`
   - Modalatik eskuzko erregistroa
   - Stock eguneratzea
   - Historian sarrera sortzea

5. **Stock kudeaketa**: `stock_management_test.dart`
   - Stock baxuko alertak
   - Stock birkarga
   - Iraupenaren kalkulua

### Datu-Basearekin Elkarrekintza

Integrazio test-ek memorian datu-base errealekin elkarreragiten dute:

```dart
testWidgets('Aplikazioaren berrabiarazi ondoren medikamentua iraun behar du',
    (tester) async {
  // Aplikazioaren lehen instantzia
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  await addMedicationWithDuration(tester, 'Aspirina');
  await waitForDatabase(tester);

  // Itxi eta berriro irekitzea simulatu
  await DatabaseHelper.instance.close();
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  // Medikamentua oraindik han egon behar du
  expect(find.text('Aspirina'), findsOneWidget);
});
```

---

## Testing Helper-ak

Helper-ek test-ak idazten sinplifikatzen dituzte eta kode bikoiztua murrizten dute.

### MedicationBuilder

**Builder pattern**-ак test medikamentuak modu irakurgarrian sortzea ahalbidetzen du:

```dart
/// Oinarrizko adibidea
final medication = MedicationBuilder()
    .withId('test_1')
    .withName('Aspirina')
    .withStock(20.0)
    .build();

/// Barauarekin
final medication = MedicationBuilder()
    .withName('Ibuprofeno')
    .withFasting(type: 'after', duration: 120)
    .withSingleDose('08:00', 1.0)
    .build();

/// Hainbat dosirekin
final medication = MedicationBuilder()
    .withName('Antibiotikoa')
    .withMultipleDoses(['08:00', '14:00', '20:00'], 1.0)
    .withStock(30.0)
    .build();

/// "Behar denean" medikamentu gisa
final medication = MedicationBuilder()
    .withName('Analgésikoa')
    .withAsNeeded()
    .withStock(10.0)
    .build();
```

#### MedicationBuilder-en Abantailak

1. **Irakurgarritasuna**: Kodea auto-dokumentatua eta ulerterrazា da
2. **Mantenigarritasuna**: Modeloaren aldaketak builder-a bakarrik eguneratzea behar du
3. **Kode murrizketa**: Ekidin test bakoitzean lehenetsitako balioak errepikatzea
4. **Malgutasuna**: Test bakoitzerako beharrezkoa bakarrik konfiguratzea ahalbidetzen du

#### Factory Methods

Builder-ak kasu ohikoetarako factory metodoak ditu:

```dart
// Stock baxua (5 unitate)
final medication = MedicationBuilder()
    .withName('Med')
    .withLowStock()
    .build();

// Stock-ik gabe
final medication = MedicationBuilder()
    .withName('Med')
    .withNoStock()
    .build();

// Hainbat dosi egunean (automatikoa)
final medication = MedicationBuilder()
    .withName('Med')
    .withMultipleDosesPerDay(3) // 08:00, 12:00, 16:00
    .build();

// Baraua gaituta lehenetsitako balioez
final medication = MedicationBuilder()
    .withName('Med')
    .withFastingEnabled() // before, 60 min
    .build();
```

#### Constructor from Medication

Lehendik dagoen medikamentu batetik builder bat sortzea ahalbidetzen du:

```dart
final original = await db.getMedication('med-id');

final modified = MedicationBuilder.from(original)
    .withStock(50.0)
    .withName('Izen Aldatua')
    .build();
```

### DatabaseTestHelper

Datu-basearen konfigurazioa eta garbiketa sinplifikatzen du:

```dart
class DatabaseTestHelper {
  /// Hasierako konfigurazioa (fitxategiko behin)
  static void setupAll() {
    setUpAll(() {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      DatabaseHelper.setInMemoryDatabase(true);
    });
  }

  /// Garbiket a test bakoitzaren ondoren
  static void setupEach() {
    tearDown(() async {
      await cleanDatabase();
    });
  }

  /// Lasterbidea: setupAll + setupEach
  static void setup() {
    setupAll();
    setupEach();
  }

  /// Lehenetsitako pertsona badagoela ziurtatzen du
  static Future<void> ensureDefaultPerson() async {
    final hasDefault = await DatabaseHelper.instance.hasDefaultPerson();

    if (!hasDefault) {
      final person = Person(
        id: const Uuid().v4(),
        name: 'Test Erabiltzailea',
        isDefault: true,
      );
      await DatabaseHelper.instance.insertPerson(person);
    }
  }
}
```

**Test-etan erabilera:**

```dart
void main() {
  DatabaseTestHelper.setup(); // Konfigurazio osoa

  setUp(() async {
    await DatabaseTestHelper.ensureDefaultPerson();
  });

  test('nire testa', () async {
    // Zure testa hemen
  });
}
```

### WidgetTestHelpers

Widget test-etarako funtzio lagungarriak:

```dart
/// Lokalizazioak lortu
AppLocalizations getL10n(WidgetTester tester);

/// Datu-base eragiketetako itxaron
Future<void> waitForDatabase(WidgetTester tester);

/// Widget bat agertzeko itxaron
Future<void> waitForWidget(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
});

/// Widget batera scroll egin
Future<void> scrollToWidget(WidgetTester tester, Finder finder);

/// Edizio-menua ireki
Future<void> openEditMenuAndSelectSection(
  WidgetTester tester,
  String medicationName,
  String sectionTitle,
);

/// Medikamentu osoa gehitu
Future<void> addMedicationWithDuration(
  WidgetTester tester,
  String name, {
  String? type,
  String? durationType,
  int dosageIntervalHours = 8,
  String stockQuantity = '0',
});

/// Eragiketa asinkrono konplexuetarako itxaron
Future<void> waitForComplexAsyncOperation(
  WidgetTester tester, {
  Duration asyncDelay = const Duration(milliseconds: 1000),
  int pumpCount = 20,
});
```

### Beste Helper-ak

- **PersonTestHelper**: Test-etan pertsonen kudeaketa
- **NotificationTestHelper**: Jakinarazpen helper-ak
- **TestConstants**: Partekatutako konstanteak (dosiak, stock-ak, denborak)

---

## Test Estaldura

Test-suite-k aplikazioaren area kritikoenen gehiengoa estaltzen du.

### Estaldura Kategoriaka

| Kategoria | Test-ak | Deskribapena |
|-----------|-------|-------------|
| **Zerbitzuak** | ~94 test | NotificationService, DoseActionService, DoseHistoryService, PreferencesService |
| **Core Funtzionalitatea** | ~79 test | Dosien kudeaketa, stock, baraua, esportazio/inportazio |
| **Baraua** | ~61 test | Barauaren logika, jakinarazpenak, kontu atzekariak, lehentasuna |
| **Pantailak** | ~93 test | Pantaila eta nabigazio guztien widget test-ak |
| **Integrazioa** | ~52 test | End-to-end fluxu osoak |

**Guztira: 369+ test**

### Area Ondo Estaliak

#### Jakinarazpenak (%95ko estaldura)
- Jakinarazpenen programazioa eta ezabaketa
- Jakinarazpen-mota desberdinentzako ID bakarra
- Asteko eredu eta data espezifikoetarako jakinarazpenak
- Barauaren jakinarazpenak
- Jakinarazpenetatik ekintza azkarrak
- Plataforma-mugak (500 jakinarazpen)
- Gauerdiaren kasu mugakoak

#### Baraua (%90eko estaldura)
- Barau-aldien kalkulua (before/after)
- Iraupena balioztapenak
- Hasiera eta amaiera jakinarazpenak
- Ikuspegi bisualaren kontu atzekariak
- Hainbat aldi aktiborekin lehentasuna
- Aurreratutako dosiak barauarekin
- Konfigurazio preserβazioa

#### Dosien Kudeaketa (%88ko estaldura)
- Dosien erregistroa (eskuz eta jakinarazpenetik)
- Dosien baztertzea
- Dosi gehigarria
- Stock eguneratzea
- Dosien historiala
- Eguneko kontsumoaren kalkulua

#### Datu-Basea (%85eko estaldura)
- Medikamentuen CRUD
- Pertsonen CRUD
- Eskema migrazioa
- Esportazio/inportazio
- Erreferentzia-osotasuna
- Kaskadako garbiketa

### Estaldura Gutxiagoko Areак

Area batzuek estaldura txikiagoa dute baina ez kritikoa:

- **UI/UX aurreratua** (%60): Animazioak, trantsizioak
- **Konfigurazioa** (%65): Erabiltzaile-hobespenak
- **Lokalizazioa** (%70): Itzulpenak eta hizkuntzak
- **Baimenak** (%55): Sistema-baimenen eskaera

Area hauek estaldura txikiagoa dute honela:
1. Zaila da automatikoki testea tzea
2. Eskuzko elkarrekintza behar dute
3. Sistema eragilearen menpekoak dira
4. Ez dute negozio-logika kritikoa eragiten

---

## Estalitako Kasu Mugakoak

Test-ek akatsak sor litzaketen kasu bereziak barne hartzen dituzte:

### 1. Gauerdiko Jakinarazpenak

**Fitxategia**: `notification_midnight_edge_cases_test.dart`

```dart
test('23:55-etan programatutako dosiak eta 00:05-etan erregistratutakoak aurreko egunerako zenbatu behar dute',
    () async {
  // Atzo 23:55-etan programatutako dosia
  final scheduledTime = DateTime(2024, 1, 15, 23, 55);

  // Gaur 00:05-etan erregistratua
  final registeredTime = DateTime(2024, 1, 16, 0, 5);

  // Aurreko eguneko dosi gisa zenbatu behar du
  expect(getDoseDate(scheduledTime), '2024-01-15');
});

test('gauerdia gurutzatzen duen barau-aldia zuzen kudeatu behar da', () async {
  // 22:00-etan dosia 3 orduko "after" barauarekin
  final medication = MedicationBuilder()
      .withSingleDose('22:00', 1.0)
      .withFasting(type: 'after', duration: 180)
      .build();

  // Baraua hurrengo eguneko 01:00-etan amaitzen da
  final endTime = calculateFastingEnd(medication, '22:00');
  expect(endTime.hour, 1);
  expect(endTime.day, DateTime.now().add(Duration(days: 1)).day);
});
```

**Estalitako kasuak:**
- Gauerdiaren ondoren erregistratutako dosi beranduak
- Gauerdia gurutzatzen duten barau-aldiak
- 00:00 zehatz programatutako dosiak
- Eguneko zenbatzaileen berrezarketa
- Gauerdia gurutzatzen duten atzeratutako jakinarazpenak

### 2. Ezabaketa eta Garbiketa

**Fitxategia**: `deletion_cleanup_test.dart`

```dart
test('medikamentua ezabatzeak bere jakinarazpen guztiak ezeztatu behar ditu', () async {
  final medication = MedicationBuilder()
      .withId('med-to-delete')
      .withSingleDose('08:00', 1.0)
      .build();

  await db.insertMedication(medication);
  await notificationService.schedule(medication);

  // Ezabatu
  await db.deleteMedication(medication.id);
  await notificationService.cancelAll(medication.id);

  // Ez luke programatutako jakinarazpenik egon behar
  final pending = await notificationService.getPending();
  expect(pending.where((n) => n.id.contains('med-to-delete')), isEmpty);
});

test('pertsona bat ezabatzeak bere medikamentu eta historia guztiak ezabatu behar ditu', () async {
  final person = await createTestPerson('Jon');
  final med = await addMedicationForPerson(person.id, 'Aspirina');

  await registerDose(med.id, '08:00');

  // Pertsona ezabatu
  await db.deletePerson(person.id);

  // Ez luke medikamenturik edo historialik egon behar
  final meds = await db.getMedicationsForPerson(person.id);
  expect(meds, isEmpty);

  final history = await db.getDoseHistory(person.id);
  expect(history, isEmpty);
});
```

**Estalitako kasuak:**
- Medikamentua ezabatzean jakinarazpenen ezabaketa
- Historialaren kaskadako ezabaketa
- Pertsona ezabatzean jakinarazpenen garbiketa
- Beste medikamentu/pertsonei eragin ez
- Erreferentzia-osotasuna

### 3. Hainbat Barauaren Lehentasuna

**Fitxategia**: `multiple_fasting_prioritization_test.dart`

```dart
test('pertsona berarentzat 2 aktibo daudenean murrizkorrena mantendu behar du',
    () async {
  // 1. medikamentua: 120 minutuko "after" baraua
  final med1 = MedicationBuilder()
      .withId('med-1')
      .withSingleDose('08:00', 1.0)
      .withFasting(type: 'after', duration: 120)
      .build();

  // 2. medikamentua: 60 minutuko "after" baraua
  final med2 = MedicationBuilder()
      .withId('med-2')
      .withSingleDose('08:30', 1.0)
      .withFasting(type: 'after', duration: 60)
      .build();

  // Bi dosiak erregistratu
  await registerDose(med1.id, '08:00');
  await registerDose(med2.id, '08:30');

  // Barau murrizkorrena bakarrik erakutsi behar luke (med-1 10:00-ra arte)
  final activeFasting = await fastingManager.getActiveFasting();
  expect(activeFasting.length, 1);
  expect(activeFasting.first.medicationId, 'med-1');
});
```

**Estalitako kasuak:**
- Pertsona baterako hainbat barau aktibo
- Aldiko murrizkorrenaren hautaketa
- Amaiera-denboraren araberako ordenaketa
- Amaitu diren aldien iragazketa automatikoa
- Pertsona desberdinen arteko independentzia

### 4. Jakinarazpen Ekintzak

**Fitxategia**: `notification_actions_test.dart`

```dart
test('register_dose ekintzak stock-a murriztu eta historiala sortu behar du', () async {
  final medication = MedicationBuilder()
      .withStock(20.0)
      .withSingleDose('08:00', 2.0)
      .build();

  await insertMedication(medication);

  // Jakinarazpenetik "register_dose" ekintza simulatu
  await handleNotificationAction(
    action: 'register_dose',
    medicationId: medication.id,
    doseTime: '08:00',
  );

  // Efektuak egiaztatu
  final updated = await db.getMedication(medication.id);
  expect(updated.stockQuantity, 18.0); // 20 - 2
  expect(updated.takenDosesToday, contains('08:00'));

  final history = await db.getDoseHistory(medication.id);
  expect(history.last.status, 'taken');
});

test('snooze_dose ekintzak jakinarazpena 10 minutu atzeratu behar du',
    () async {
  final notification = await scheduleNotification(
    medicationId: 'med-1',
    time: TimeOfDay(hour: 8, minute: 0),
  );

  // Atzeratu
  await handleNotificationAction(
    action: 'snooze_dose',
    medicationId: 'med-1',
    notificationId: notification.id,
  );

  // Programazio berria egiaztatu
  final rescheduled = await getNextNotification('med-1');
  expect(rescheduled.time.hour, 8);
  expect(rescheduled.time.minute, 10);
});
```

**Estalitako kasuak:**
- Jakinarazpenetik erregistroa
- Jakinarazpenetik baztertzea
- 10 minutu atzeratu
- Stock eta historialaren eguneraketa zuzena
- Jatorrizko jakinarazpenaren ezabaketa

### 5. Jakinarazpen Mugak

**Fitxategia**: `notification_limits_test.dart`

```dart
test('plataformaren mugara heltzea kudeatu behar du (>400 jakinarazpen)',
    () async {
  // 100 medikamentu 4 dosirekin sortu
  for (int i = 0; i < 100; i++) {
    final med = MedicationBuilder()
        .withId('med-$i')
        .withMultipleDoses(['08:00', '12:00', '16:00', '20:00'], 1.0)
        .withWeeklyPattern([1, 2, 3, 4, 5, 6, 7])
        .build();

    await insertMedication(med);
  }

  // Jakinarazpenak programatu (potent zialki >500)
  await notificationService.scheduleAll();

  // Ez du krashea tu behar
  // Jakinarazpen hurbilak lehentasunez hartu behar ditu
  final pending = await notificationService.getPending();
  expect(pending.length, lessThanOrEqualTo(500));
});
```

**Estalitako kasuak:**
- 500 jakinarazpen baino gehiago kudeatu
- Jakinarazpen hurb ilak lehentasunez hartu
- Abisu logging-a
- App-a krashea tu ez
- Berriz-programazio automatikoa

---

## Test-ak Exekutatu

### Oinarrizko Komandoak

```bash
# Test guztiak exekutatu
flutter test

# Test espezifikoa
flutter test test/services/notification_service_test.dart

# Direktorio bateko test-ak
flutter test test/integration/

# Izen espezifikoarekin test-ak
flutter test --name "fasting"

# Test-ak verbose moduan
flutter test --verbose

# Test-ak denborarekin
flutter test --reporter expanded
```

### Estaldurarekin Test-ak

```bash
# Test-ak estaldurarekin exekutatu
flutter test --coverage

# HTML txostena sortu
genhtml coverage/lcov.info -o coverage/html

# Txostena nabigatzailean ireki
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
start coverage/html/index.html  # Windows
```

### Test Espezifikoak Exekutatu

```bash
# Zerbitzu test-ak bakarrik
flutter test test/*_service_test.dart

# Integrazio test-ak bakarrik
flutter test test/integration/

# Barau test-ak bakarrik
flutter test test/fasting*.dart

# Test motelak kanpoan utzi
flutter test --exclude-tags=slow
```

### CI/CD Test-ak

```bash
# CI modua (kolorerik gabe, log-etarako formatu egokia)
flutter test --machine --coverage

# Test moteletarako timeout-arekin
flutter test --timeout=30s

# Akatsa azkar (lehen errorean gelditu)
flutter test --fail-fast
```

### Test-en Debuggea

```bash
# Test bakarra debug moduan exekutatu
flutter test --plain-name "test izen zehatza"

# Breakpoint-ekin (VS Code/Android Studio)
# IDE-tik "Debug Test" erabili

# Print-ak ikusgai
flutter test --verbose

# Irteera fitxategira gorde
flutter test > test_output.txt 2>&1
```

---

## Test-ak Idazteko Gida

### AAA Egitura (Arrange-Act-Assert)

Test bakoitza hiru atal argietan antolatu:

```dart
test('dosia erregistratu eta stock-a eguneratu behar du', () async {
  // ARRANGE: Ingurunea prestatu
  final medication = MedicationBuilder()
      .withStock(20.0)
      .withSingleDose('08:00', 2.0)
      .build();
  await db.insertMedication(medication);

  // ACT: Testea tzeko ekintza exekutatu
  await doseService.registerDose(medication.id, '08:00');

  // ASSERT: Emaitza egiaztatu
  final updated = await db.getMedication(medication.id);
  expect(updated.stockQuantity, 18.0);
  expect(updated.takenDosesToday, contains('08:00'));
});
```

### Izendapen Konbentzioak

Erabili eszenatoki osoa azaltzen duten izen deskribatzaileak:

```dart
// ✅ ONA: Eszenatoio osoa deskribatzen du
test('medikamentua ezabatzen denean jakinarazpenak ezeztatu behar ditu', () {});
test('stock-a nahikoa ez denean errorea erakutsi behar du', () {});
test('gauerdiaren ondoren erregistratutako dosia aurreko egunerako zenbatu behar du', () {});

// ❌ TXARRA: Izen lausoak edo teknikoak
test('test1', () {});
test('jakinarazpen testa', () {});
test('ezabaketa', () {});
```

**Gomendatutako formatua:**
- `[portaera espero] should [ekintza] when [baldintza]`
- `[ekintza] [emaitza espero] [testuinguru aukerazkoa]`

### Setup eta Teardown

Ingurunea modu koherentean konfiguratu eta garbitu:

```dart
void main() {
  // Hasierako konfigurazioa behin bakarrik
  DatabaseTestHelper.setupAll();

  late NotificationService service;
  late DatabaseHelper db;

  // Test bakoitzaren aurretik
  setUp(() async {
    service = NotificationService.instance;
    service.enableTestMode();
    db = DatabaseHelper.instance;
    await DatabaseTestHelper.ensureDefaultPerson();
  });

  // Test bakoitzaren ondoren
  tearDown(() async {
    service.disableTestMode();
    await DatabaseTestHelper.cleanDatabase();
  });

  // Zure test-ak hemen
  test('...', () async {
    // Ingurune garbiarekin test isolatua
  });
}
```

### DatabaseHelper-aren Mock-a

Unit test garɓietarako, datu-basea mockea tu:

```dart
class MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  late MockDatabaseHelper mockDb;
  late DoseActionService service;

  setUp(() {
    mockDb = MockDatabaseHelper();
    service = DoseActionService(database: mockDb);
  });

  test('datu-base metodoa parametro zuzenez deitu behar du', () async {
    final medication = MedicationBuilder().build();

    // Mock-a konfiguratu
    when(mockDb.updateMedication(any))
        .thenAnswer((_) async => 1);

    // Ekintza exekutatu
    await service.registerDose(medication.id, '08:00');

    // Deia egiaztatu
    verify(mockDb.updateMedication(argThat(
      predicate<Medication>((m) =>
        m.id == medication.id &&
        m.takenDosesToday.contains('08:00')
      )
    ))).called(1);
  });
}
```

### MedicationBuilder Erabilera

Test-ek erabiltzeko test medikamentuak sortzeko builder-a erabili:

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

### Praktika Onenak

1. **Test independenteak**: Test bakoitza bakarrik exekutatu behar da
   ```dart
   // ✅ ONA: Test auto-edukia
   test('...', () async {
     final medication = createTestMedication();
     await db.insert(medication);
     // ... testaren gainerakoa
   });

   // ❌ TXARRA: Exekuzio-ordena-menpekoa
   late Medication sharedMedication;
   test('medikamentua sortu', () {
     sharedMedication = createTestMedication();
   });
   test('medikamentua erabili', () {
     expect(sharedMedication, isNotNull); // Aurreko testaren menpekoa
   });
   ```

2. **Test azkarrak**: Erabili memorian datu-basea, ekidin beharrez kanpoko atzerapenik
   ```dart
   // ✅ ONA
   DatabaseHelper.setInMemoryDatabase(true);

   // ❌ TXARRA
   await Future.delayed(Duration(seconds: 2)); // Arbitrarioko atzerapena
   ```

3. **Assertion zehat-zak**: Egiaztatu zehazki garrantzitsua dena
   ```dart
   // ✅ ONA
   expect(medication.stockQuantity, 18.0);
   expect(medication.takenDosesToday, contains('08:00'));

   // ❌ TXARRA
   expect(medication, isNotNull); // Lausoegia
   ```

4. **Talde logikoak**: Antolatu erlazionatutako test-ak
   ```dart
   group('Dosien Erregistroa', () {
     test('dosia arrakastatsu erregistratu behar du', () {});
     test('erregistratzen denean stock-a eguneratu behar du', () {});
     test('historiaren sarrera sortu behar du', () {});
   });

   group('Dosien Balioztapena', () {
     test('ordu formatu baliogabea baztertu behar du', () {});
     test('kantitate negatiboa baztertu behar du', () {});
   });
   ```

5. **Edge case test-ak**: Ez bakarrik happy path-a
   ```dart
   group('Stock Kudeaketa', () {
     test('dosia stock nahikoarekin erregistratu behar du', () {});

     test('dosia 0 stock-arekin erregistratu behar du', () {});

     test('kantitate dezimalak zuzen kudeatu behar ditu', () {});

     test('0 stockaren azpitik ez joan behar luke', () {});
   });
   ```

6. **Iruzkin erabilgarriak**: Azaldu "zergatia", ez "zera"
   ```dart
   test('dosia beranduarenaurreko egunerako zenbatu behar du', () async {
     // V19+: Gauerdiaren ondoren erregistratutako dosiak baina
     // programazioaren 2 ordu barru aurreko egunerako zenbatzen dira
     // Honek dosia berandua zenbaketa eguna bikoiztu ez dadin ekiditen du

     final scheduledTime = DateTime(..., 23, 55);
     final registeredTime = DateTime(..., 0, 5);
     // ...
   });
   ```

---

## Datu-Basearen Testing

### sqflite_common_ffi Erabilera

Test-ek `sqflite_common_ffi` erabiltzen dute memorian datu-baserako:

```dart
void main() {
  setUpAll(() {
    // FFI hasieratu
    sqfliteFfiInit();

    // FFI factory erabili
    databaseFactory = databaseFactoryFfi;

    // Memoria moduan gaitu
    DatabaseHelper.setInMemoryDatabase(true);
  });

  test('datu-base eragiketak', () async {
    // Datu-basea automatikoki memorian sortzen da
    final db = DatabaseHelper.instance;

    // Eragiketa normalak
    await db.insertMedication(medication);
    final result = await db.getMedication(medication.id);

    expect(result, isNotNull);
  });
}
```

### Memorian Datu-Basea

Memorian datu-basea erabiltzearen abantailak:

1. **Abiadura**: Diskoarekin alderatuta 10-100x azkarragoa
2. **Isolamendua**: Test bakoitza DB garbiarekin hasten da
3. **Albo-efekturik ez**: Ez ditu datu errealak aldatzen
4. **Paralelizazioa**: Test-ak paralelo exekutatu daitezke

```dart
setUp(() async {
  // DB garbiarekin berrezarri
  await DatabaseHelper.resetDatabase();

  // Memoria modua
  DatabaseHelper.setInMemoryDatabase(true);
});
```

### Test-etan Migrazioak

Test-ek migrazioak zuzen funtzionatzen dutela egiaztatzen dute:

```dart
test('v18-tik v19-ra migratu behar du (persons taula)', () async {
  // DB 18 bertsioan sortu
  final db = await openDatabase(
    inMemoryDatabasePath,
    version: 18,
    onCreate: (db, version) async {
      // V18 eskema (persons taula gabe)
      await db.execute('''
        CREATE TABLE medications (...)
      ''');
    },
  );

  await db.close();

  // 19 bertsioan ireki (migrazioa trigger-a tu)
  final migratedDb = await DatabaseHelper.instance.database;

  // Persons existitzen dela egiaztatu
  final tables = await migratedDb.rawQuery(
    "SELECT name FROM sqlite_master WHERE type='table' AND name='persons'"
  );

  expect(tables, isNotEmpty);

  // Lehenetsitako pertsona egiaztatu
  final hasDefault = await DatabaseHelper.instance.hasDefaultPerson();
  expect(hasDefault, true);
});
```

### Test-en arteko Garbiketa

Garrantzitsua da DB garbitzea test-en artean kutsadura ekiditeko:

```dart
tearDown(() async {
  // 1. metodoa: Datu guztiak ezabatu
  await DatabaseHelper.instance.deleteAllMedications();
  await DatabaseHelper.instance.deleteAllDoseHistory();
  await DatabaseHelper.instance.deleteAllPersons();

  // 2. metodoa: Guztiz berrezarri
  await DatabaseHelper.resetDatabase();

  // 3. metodoa: Helper-a erabili
  await DatabaseTestHelper.cleanDatabase();
});
```

### Erreferentzia-Osotasun Test-ak

BD erlazioak zuzen funtzionatzen dutela egiaztatu:

```dart
test('pertsona ezabatzeak kaskadako medikamentuak ezabatu behar ditu', () async {
  final person = Person(id: 'p1', name: 'Jon');
  await db.insertPerson(person);

  final med = MedicationBuilder()
      .withId('m1')
      .build();
  await db.insertMedicationForPerson(med, person.id);

  // Pertsona ezabatu
  await db.deletePerson(person.id);

  // Medikamentuak ezabatu behar ziren
  final meds = await db.getMedicationsForPerson(person.id);
  expect(meds, isEmpty);
});

test('dose_history medikamentu baliogarriari erreferentzia egiten dio', () async {
  // Medikamentu ez-existitarentzat historiala txertatzea saiatu
  final entry = DoseHistoryEntry(
    id: 'h1',
    medicationId: 'non-existent',
    personId: 'p1',
    scheduledTime: '08:00',
    status: 'taken',
  );

  // Foreign key constraint-agatik huts egin behar du
  expect(
    () => db.insertDoseHistory(entry),
    throwsA(isA<DatabaseException>()),
  );
});
```

---

## CI/CD eta Testing Automatizatua

### Integrazione Jarraitua

GitHub Actions-etarako konfigurazio tipikoa:

```yaml
name: Tests

on:
  push:
    branches: [ main, development ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2

    - name: Flutter Setup
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.24.0'
        channel: 'stable'

    - name: Mendekotasunak instalatu
      run: flutter pub get

    - name: Test-ak exekutatu
      run: flutter test --coverage --machine

    - name: Estaldura egiaztatu
      run: |
        COVERAGE=$(lcov --summary coverage/lcov.info | grep lines | awk '{print $2}' | sed 's/%//')
        if (( $(echo "$COVERAGE < 70" | bc -l) )); then
          echo "Estaldura $COVERAGE% %70-en azpitik dago"
          exit 1
        fi

    - name: Estaldura Codecov-era igo
      uses: codecov/codecov-action@v2
      with:
        file: ./coverage/lcov.info
```

### Pre-commit Hooks

`husky` edo Git hook script-ak erabili test-ak commit aurretik exekutatzeko:

```bash
# .git/hooks/pre-commit
#!/bin/sh

echo "Test-ak exekutatzen..."
flutter test

if [ $? -ne 0 ]; then
  echo "Test-ak huts egin dute. Commit-a ezeztatu da."
  exit 1
fi

echo "Test guztiak gaindituta!"
```

### Gutxieneko Estaldura Muga

Konfiguratu gutxieneko estaldura erregresio ekiditeko:

```bash
# scripts/check_coverage.sh
#!/bin/bash

flutter test --coverage

# Gutxieneko estaldura egiaztatu
MIN_COVERAGE=70
ACTUAL_COVERAGE=$(lcov --summary coverage/lcov.info | grep lines | awk '{print $2}' | sed 's/%//')

if (( $(echo "$ACTUAL_COVERAGE < $MIN_COVERAGE" | bc -l) )); then
  echo "❌ Estaldura $ACTUAL_COVERAGE% gutxieneko $MIN_COVERAGE%-tik behera dago"
  exit 1
else
  echo "✅ Estaldura $ACTUAL_COVERAGE% gutxieneko $MIN_COVERAGE% betetzen du"
fi
```

### Estaldura Txostenak

Automatikoki txosten bisualak sortu:

```bash
# Txostena sortu
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Estaldura badge-a
./scripts/generate_coverage_badge.sh

# Txostena argitaratu
# (GitHub Pages, Codecov, Coveralls erabili, etab.)
```

---

## Hurrengo Urratsak

### Hobetzeko Areак

1. **UI/UX Test-ak (%60 → %80)**
   - Animazio gehiagoentestak
   - Keinuen eta swipe-en testak
   - Irisgarritasun testak

2. **Baimen Test-ak (%55 → %75)**
   - Sistemaren baimenen mock-a
   - Baimen eskaera fluxuak
   - Baimene ukatuen kudeaketa

3. **Lokalizazio Test-ak (%70 → %90)**
   - Hizkuntza bakoitzerako testak
   - Itzulpen osoen egiaztapena
   - Data/zenbaki formateatzeko testak

4. **Performance Test-ak**
   - Eragiketa kritikoen benchmark-ak
   - Karga test-ak (medikamentu asko)
   - Memory leak detekzioa

### Falta diren Test-ak

#### Lehentasun Altua

- [ ] Backup/restore osorako testak
- [ ] Background-eko jakinarazpenen testak
- [ ] Home screen widget-etako testak
- [ ] Deep link-en testak
- [ ] Datuen partekatze testak

#### Lehentasun Ertaina

- [ ] Hizkuntza guztietarako testak
- [ ] Gai test-ak (argia/iluna)
- [ ] Onboarding testak
- [ ] Bertsio guztien arteko migrazio test-ak
- [ ] CSV/PDF esportazioa test-ak

#### Lehentasun Baxua

- [ ] Animazio konplexuen test-ak
- [ ] Keinu aurreratuen test-ak
- [ ] Irisgarritasun exhaustiבoko test-ak
- [ ] Gailu moteletan errendimendu test-ak

### Testing Roadmap

#### Q1 2025
- Estaldura orokorra %80 lortu
- Baimen test-ak osatu
- Oinarrizko performance test-ak gehitu

#### Q2 2025
- Hizkuntza guztietarako test-ak
- Backup/restore testak
- Testing dokumentazio eguneratua

#### Q3 2025
- Irisgarritasun test osoak
- Karga eta stress test-ak
- CI/CD automatizazio osoa

#### Q4 2025
- Estaldura orokorra %85+
- Performance test suite-a
- Erregresio bisual test-ak

---

## Baliabide Gehigarriak

### Dokumentazioa

- [Flutter Testing Gida](https://docs.flutter.dev/testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [Mockito Dokumentazioa](https://pub.dev/packages/mockito)

### Tresnak

- **flutter_test**: Flutter-en testing framework-a
- **mockito**: Mendekotasunen mock-a
- **sqflite_common_ffi**: Test-etarako memorian DB
- **test_coverage**: Estaldura analisia
- **lcov**: HTML txostenen sortzea

### Erlazionatutako Fitxategiak

- `/test/helpers/` - Testing helper guztiak
- `/test/integration/` - Integrazio test-ak
- `/.github/workflows/test.yml` - CI/CD konfigurazioa
- `/scripts/run_tests.sh` - Testing script-ak

---

**Azken eguneraketa**: 2025ko azaroa
**MedicApp bertsioa**: V19+
**Test osoak**: 369+
**Batez besteko estaldura**: %75-80
