# MedicApp Arkitektura

## Edukien Taula

1. [Arkitekturaren Ikuspegi Orokorra](#arkitekturaren-ikuspegi-orokorra)
2. [Pertsona Anitzeko Arkitektura V19+](#pertsona-anitzeko-arkitektura-v19)
3. [Modeloen Geruza (Models)](#modeloen-geruza-models)
4. [Zerbitzuen Geruza (Services)](#zerbitzuen-geruza-services)
5. [Ikuspegi Geruza (Screens/Widgets)](#ikuspegi-geruza-screenswidgets)
6. [Datuen Fluxua](#datuen-fluxua)
7. [Jakinarazpenen Kudeaketa](#jakinarazpenen-kudeaketa)
8. [SQLite Datu-basea V19](#sqlite-datu-basea-v19)
9. [Errendimendu Optimizazioak](#errendimendu-optimizazioak)
10. [Kodearen Modularizazioa](#kodearen-modularizazioa)
11. [Lokalizazioa (l10n)](#lokalizazioa-l10n)
12. [Diseinu Erabakiak](#diseinu-erabakiak)

---

## Arkitekturaren Ikuspegi Orokorra

MedicApp **Model-View-Service (MVS)** eredu sinplifikatua erabiltzen du, BLoC, Riverpod edo Redux bezalako state management framework konplexuen mendekotasunik gabe.

### Justifikazioa

State management konplexua ez erabiltzeko erabakia oinarritzen da:

1. **Sinpletasuna**: Aplikazioak egoera nagusiki pantaila/widget mailan kudeatzen du
2. **Errendimendua**: Abstrakzio geruza gutxiago = erantzun azkarragoak
3. **Mantengarra sugarritasuna**: Kode zuzenagoa eta ulerterrazagoa
4. **Tamaina**: Mendekotasun gutxiago = APK arinagoa

### Geruzen Diagrama

```
┌─────────────────────────────────────────────────────────┐
│                    UI Layer (Views)                     │
│  ┌────────────┐  ┌────────────┐  ┌────────────────┐   │
│  │  Screens   │  │  Widgets   │  │  ViewModels    │   │
│  └────────────┘  └────────────┘  └────────────────┘   │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                  Service Layer                          │
│  ┌────────────┐  ┌────────────┐  ┌────────────────┐   │
│  │Notification│  │DoseHistory │  │DoseCalculation │   │
│  │  Service   │  │  Service   │  │    Service     │   │
│  └────────────┘  └────────────┘  └────────────────┘   │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                   Data Layer                            │
│  ┌────────────┐  ┌────────────┐  ┌────────────────┐   │
│  │  Models    │  │ Database   │  │ Preferences    │   │
│  │            │  │  Helper    │  │                │   │
│  └────────────┘  └────────────┘  └────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## Pertsona Anitzeko Arkitektura V19+

19. bertsiotik aurrera, MedicApp-ek **N:N (askotariko) datu-modelo** bat inplementatzen du, pertsona anitzek sendagai bera partekatzeko aukera emanez konfigurazio indibidualak mantentzen dituzten bitartean.

### N:N Datu-modeloa

```
┌─────────────┐         ┌──────────────────┐         ┌─────────────┐
│   persons   │         │person_medications│         │ medications │
├─────────────┤         ├──────────────────┤         ├─────────────┤
│ id          │◄────────│ personId         │         │ id          │
│ name        │         │ medicationId     │────────►│ name        │
│ isDefault   │         │ assignedDate     │         │ type        │
└─────────────┘         │                  │         │ stockQuantity│
                        │ PAUTA INDIBIDUALA│         │ lastRefill  │
                        │ ──────────────── │         │ lowStockDays│
                        │ durationType     │         │ lastConsump.│
                        │ doseSchedule     │         └─────────────┘
                        │ takenDosesToday  │
                        │ skippedDosesTo.. │
                        │ startDate        │
                        │ endDate          │
                        │ requiresFasting  │
                        │ isSuspended      │
                        └──────────────────┘
```

### Erantzukizunen Banaketa

| Taula | Erantzukizuna | Adibideak |
|-------|---------------|----------|
| **medications** | Pertsonen artean PARTEKATUTAKO datuak | izena, mota, stock fisikoa |
| **person_medications** | Pertsona bakoitzaren INDIBIDUALA konfigurazioa | orduak, iraupena, etete-egoera |
| **dose_history** | Pertsonaren araberako hartze historiala | personId-rekin erregistroa |

### Erabilera Kasuen Adibideak

#### 1. Adibidea: Parazeta mola Partekatua

```
Sendagaia: Parazeta mola 500mg
├─ Stock partekatua: 50 pilula
├─ Pertsona: Juan (erabiltzaile lehenetsia)
│  └─ Pauta: 08:00, 16:00, 00:00 (egunean 3 aldiz)
└─ Pertsona: María (familia kidea)
   └─ Pauta: 12:00 (egunean behin, behar denean soilik)
```

Datu-basean:
- **1 sarrera** `medications` taulan (stock partekatua)
- **2 sarrera** `person_medications` taulan (pauta desberdinak)

#### 2. Adibidea: Sendagai Desberdinak

```
Juan:
├─ Omeprazole 20mg → 08:00
└─ Atorvastatina 40mg → 22:00

María:
└─ Levotiroxina 100mcg → 07:00
```

Datu-basean:
- **3 sarrera** `medications` taulan
- **3 sarrera** `person_medications` taulan (sendagai-pertsona bakoitzeko bat)

### V16→V19 Migrazio Automatikoa

Datu-baseak automatikoki migratzen du arkitektura zaharretatik:

```dart
// V18: medications-ek GUZTIA zeukan (stock + pauta)
medications (id, name, type, stock, doseSchedule, durationType, ...)

// V19: BANAKETA
medications (id, name, type, stock)  // SOILIK partekatutako datuak
person_medications (personId, medicationId, doseSchedule, durationType, ...)
```

**Migrazio prozesua:**
1. Taula zaharen backup-a (`medications_old`, `person_medications_old`)
2. Egitura berrien sorrera
3. Partekatutako datuen kopia `medications`-era
4. Pauta indibidualena kopia `person_medications`-era
5. Indizeen berrorrera
6. Backup-en ezabaketa

---

## Modeloen Geruza (Models)

### Person

Sendagaiak hartzen dituen pertsona bat adierazten du:

```dart
class Person {
  final String id;
  final String name;
  final bool isDefault;  // Erabiltzaile nagusia
}
```

**Erantzukizunak:**
- Identifikazio bakarra
- UI-n erakusteko izena
- Pertsona lehenetsiaren adierazlea (izenaren aurrizki gabeko jakinarazpenak jasotzen ditu)

### Medication

**Sendagai fisikoa** bere stock partekatuarekin adierazten du:

```dart
class Medication {
  // PARTEKATUTAKO DATUAK (medications taulan)
  final String id;
  final String name;
  final MedicationType type;
  final double stockQuantity;
  final double? lastRefillAmount;
  final int lowStockThresholdDays;
  final double? lastDailyConsumption;

  // DATU INDIBIDUALAK (person_medications-etik, kontsultatzean fusionatzen dira)
  final TreatmentDurationType durationType;
  final Map<String, double> doseSchedule;
  final List<String> takenDosesToday;
  final List<String> skippedDosesToday;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool requiresFasting;
  final bool isSuspended;
  // ... konfigurazio indibidualaentzako eremu gehiago
}
```

**Metodo garrantzitsuak:**
- `shouldTakeToday()`: Maiztasun logika (egunero, astero, tartea, data espezifikoak)
- `isActive`: Egiaztatu tratamendua aldietan aktibo dagoen
- `isStockLow`: Kalkulatu stock baxua egunkako kontsumu arabera
- `getAvailableDosesToday()`: Iragazi hartuta/omititu ez diren dosiak

### PersonMedication

N:N tarteko taula pertsona bakoitzaren **pauta indibiduala** batekin:

```dart
class PersonMedication {
  final String id;
  final String personId;
  final String medicationId;
  final String assignedDate;

  // PAUTA INDIBIDUALA
  final TreatmentDurationType durationType;
  final int dosageIntervalHours;
  final Map<String, double> doseSchedule;
  final List<String> takenDosesToday;
  final List<String> skippedDosesToday;
  final String? takenDosesDate;
  final List<String>? selectedDates;
  final List<int>? weeklyDays;
  final int? dayInterval;
  final String? startDate;
  final String? endDate;
  final bool requiresFasting;
  final String? fastingType;
  final int? fastingDurationMinutes;
  final bool notifyFasting;
  final bool isSuspended;
}
```

### DoseHistoryEntry

Hartze/omisio bakoitzaren erregistro historikoa:

```dart
class DoseHistoryEntry {
  final String id;
  final String medicationId;
  final String personId;  // V19+: Pertsonaren araberako jarraipena
  final DateTime scheduledDateTime;  // Programatutako ordua
  final DateTime registeredDateTime; // Erregistroaren benetako ordua
  final DoseStatus status;  // taken | skipped
  final double quantity;
  final bool isExtraDose;  // Ordutegi kanpoko dosia
  final String? notes;
}
```

**Funtzionalitateak:**
- Atxikipenaren auditoria
- Estatistiken kalkulua
- Erregistro denboraren edizioa ahalbidetzen du
- Programatutako dosien eta estren arteko bereizketa

### Modeloen Arteko Erlazioak

```
Person (1) ──── (N) PersonMedication (N) ──── (1) Medication
   │                      │                         │
   │                      │                         │
   │                      ▼                         │
   └──────────────► DoseHistoryEntry ◄─────────────┘
```

---

## Zerbitzuen Geruza (Services)

### DatabaseHelper (Singleton)

SQLite eragiketa GUZTIAK kudeatzen ditu:

```dart
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // CRUD Medications (partekatutako datuak soilik)
  Future<int> insertMedication(Medication medication);
  Future<Medication?> getMedication(String id);
  Future<List<Medication>> getAllMedications();
  Future<int> updateMedication(Medication medication);

  // V19+: CRUD pertsonekin
  Future<String> createMedicationForPerson({
    required Medication medication,
    required String personId,
  });
  Future<Medication?> getMedicationForPerson(String medicationId, String personId);
  Future<List<Medication>> getMedicationsForPerson(String personId);
  Future<int> updateMedicationForPerson({
    required Medication medication,
    required String personId,
  });

  // CRUD Persons
  Future<int> insertPerson(Person person);
  Future<Person?> getDefaultPerson();
  Future<List<Person>> getAllPersons();

  // CRUD PersonMedications
  Future<int> insertPersonMedication(PersonMedication pm);
  Future<List<Person>> getPersonsForMedication(String medicationId);

  // CRUD DoseHistory
  Future<int> insertDoseHistory(DoseHistoryEntry entry);
  Future<List<DoseHistoryEntry>> getDoseHistoryForDateRange(...);
  Future<Map<String, dynamic>> getDoseStatistics(...);
}
```

**Funtzionalitate nagusiak:**
- Singleton konexio anitz saihesteko
- V19-ra arteko migrazio automatikoak
- Pertsona lehenetsiaren cachea kontsultak optimizatzeko
- Datu-basearen esportazio/inportazio metodoak

### NotificationService (Singleton)

Sistemaren jakinarazpen GUZTIAK kudeatzen ditu:

```dart
class NotificationService {
  static final NotificationService instance = NotificationService._init();

  // Hasieratzea
  Future<void> initialize();
  Future<bool> requestPermissions();
  Future<bool> canScheduleExactAlarms();

  // V19+ Programazioa (personId behar du)
  Future<void> scheduleMedicationNotifications(
    Medication medication,
    {required String personId, bool excludeToday = false}
  );

  // Ezeztapen adimentsua
  Future<void> cancelMedicationNotifications(String medicationId, {Medication? medication});
  Future<void> cancelTodaysDoseNotification({
    required Medication medication,
    required String doseTime,
    required String personId,
  });

  // Dosia atzeratu
  Future<void> schedulePostponedDoseNotification({
    required Medication medication,
    required String originalDoseTime,
    required TimeOfDay newTime,
    required String personId,
  });

  // Baraualdia
  Future<void> scheduleDynamicFastingNotification({
    required Medication medication,
    required DateTime actualDoseTime,
    required String personId,
  });
  Future<void> showOngoingFastingNotification({
    required String personId,
    required String medicationName,
    required String timeRemaining,
    required String endTime,
  });

  // Berprogramazio masiboa
  Future<void> rescheduleAllMedicationNotifications();

  // Debug
  Future<List<PendingNotificationRequest>> getPendingNotifications();
}
```

**Delegazio espezializatua:**
- `DailyNotificationScheduler`: Eguneroko jakinarazpen errepikakoak
- `WeeklyNotificationScheduler`: Asteko patronak
- `FastingNotificationScheduler`: Baraualdi aldien kudeaketa
- `NotificationCancellationManager`: Ezeztapen adimentsua

**Jakinarazpen muga:**
Aplikazioak gehienez **5 jakinarazpen aktibo** mantentzen ditu sisteman gainezka saihesteko.

### DoseHistoryService

Historialaren operazioak zentralizatzen ditu:

```dart
class DoseHistoryService {
  static Future<void> deleteHistoryEntry(DoseHistoryEntry entry);
  static Future<DoseHistoryEntry> changeEntryStatus(
    DoseHistoryEntry entry,
    DoseStatus newStatus,
  );
  static Future<DoseHistoryEntry> changeRegisteredTime(
    DoseHistoryEntry entry,
    DateTime newRegisteredTime,
  );
}
```

**Abantailak:**
- Pantaileten arteko logika bikoizketa saihesten du
- Automatikoki kudeatzen du `Medication` eguneraketa sarrera gaurko bada
- Stocka berreskuratzen du hartze bat ezabatzen bada

### DoseCalculationService

Hurrengo dosiak kalkulatzeko negozio logika:

```dart
class DoseCalculationService {
  static NextDoseInfo? getNextDoseInfo(Medication medication);
  static String formatNextDose(NextDoseInfo info, BuildContext context);
}
```

**Erantzukizunak:**
- Hurrengo dosia maiztasunaren arabera detektatu
- Lokalizatutako mezuak formateatu ("Gaur 18:00etan", "Bihar 08:00etan")
- Tratamenduaren hasiera/amaiera datak errespetatu

### FastingConflictService

Sendagaien ordutegien eta baraualdi aldien arteko gatazkak detektatzen ditu.

```dart
class FastingConflictService {
  static FastingConflict? checkForConflicts({
    required String selectedTime,
    required List<Medication> allMedications,
    String? excludeMedicationId,
  });
  static String? suggestAlternativeTime({
    required String conflictTime,
    required FastingConflict conflict,
  });
}
```

**Erantzukizunak:**
- Proposatutako ordutegi bat beste sendagai baten baraualdi aldiarekin bat datorren egiaztatzen du
- Baraualdi aldi aktiboak kalkulatzen ditu (sendagaia hartu aurretik/ondoren)
- Gatazkak saihesten dituzten ordutegi alternatiboak iradokitzen ditu
- "before" (hartu aurretik) eta "after" (hartu ondoren) baraualdia onartzen du

**Erabilera kasuak:**
- `DoseScheduleEditor`-en dosi ordutegi berri bat gehitzean
- `EditScheduleScreen`-en sendagaia sortu edo editatzean
- Tratamenduaren eraginkortasuna arriskuan jar dezaketen gatazkak saihesten ditu
- V19+ bertsioan aktibatuta `EditScheduleScreen`-ek `allMedications` eta `personId` parametroak jaso ondoren

### Stock Baxuko Jakinarazpen Sistema

MedicApp-ek stock alerten sistema duala inplementatzen du, jakinarazpen erreaktiboak (une kritikoan) eta proaktiboak (aurreikuspenezkoak) konbinatzen dituena.

#### Jakinarazpen Erreaktiboak (Immediate Stock Check)

Sistemak automatikoki egiaztatzen du eskuragarri dagoen stocka erabiltzaile batek dosia erregistratzen saiatzen den bakoitzean, hemendik:
- Pantaila nagusitik dosia "hartuta" markatzerakoan
- Jakinarazpenen ekintza azkarretatik ("Erregistratu" botoia)
- Aldizkako dosien erregistro eskuzkotik

**NotificationService-en inplementazioa:**

```dart
Future<void> showLowStockNotification({
  required Medication medication,
  required String personName,
  bool isInsufficientForDose = false,
  int? daysRemaining,
}) async
```

**Fluxu erreaktiboa:**
1. Erabiltzaileak dosia erregistratzen saiatzen da
2. Sistemak egiaztatzen du: `medication.stockQuantity < doseQuantity`
3. Ez bada nahikoa:
   - Lehentasun altuko jakinarazpen berehalakoa erakusten du
   - EZ du dosien erregistroa ahalbidetzen
   - Beharrezko vs eskuragarri kantitatea adierazten du
   - Erabiltzailea stocka berritzera gidatzen du

**ID-en tartea:** 7,000,000 - 7,999,999 (`NotificationIdGenerator.generateLowStockId()`-k sortuta)

#### Jakinarazpen Proaktiboak (Daily Stock Monitoring)

Sistemak eguneko egiaztapen proaktiboak exekutatu ditzake, hornidura arazoak gertatu aurretik aurreikusten dituztenak.

**Metodo nagusia:**

```dart
Future<void> checkLowStockForAllMedications() async
```

**Fluxu proaktiboa:**
1. Gehienez egunean behin exekutatzen da (SharedPreferences erabiltzen du jarraipenerako)
2. Erregistratutako pertsona guztien artean iteratzen du
3. Sendagai aktibo bakoitzerako:
   - Eguneko dosi totala kalkulatzen du kontuan hartuz:
     - Sendagaiari esleitutako pertsona guztiak
     - Tratamenduaren maiztasuna (egunero, astero, tartea)
     - Pertsonaren araberako konfiguratutako orduak
   - Uneko stocka eguneko dosiaren artean zatitzen du
   - Geratzen diren hornidura egunak lortzen ditu
4. `medication.isStockLow` bada (sendagaiaren arabera konfiguragarri den atalasea erabiltzen du):
   - Jakinarazpen proaktiboa igortzen du
   - Gutxi gorabehera geratzen diren egunak barne hartzen ditu
   - Ez du ekintzarik blokeatzen

**Spam-aren prebentzioa:**
- Azken egiaztapen data SharedPreferences-en erregistratzen du
- `lastCheck != today` bada soilik exekutatzen du
- Sendagai bakoitzak egunean behin soilik jakinarazten du
- Stocka berritzerakoan berrabiarazten da

**Medication.isStockLow-rekin integrazioa:**
Stock baxuaren kalkuluak modeloaren lehendik dagoen propietatea erabiltzen du:
```dart
bool get isStockLow {
  if (stockQuantity <= 0) return true;
  final dailyDose = doseSchedule.values.fold(0.0, (sum, dose) => sum + dose);
  if (dailyDose <= 0) return false;
  final daysRemaining = stockQuantity / dailyDose;
  return daysRemaining <= lowStockThresholdDays;
}
```

#### Jakinarazpen Kanalen Konfigurazioa

Stock jakinarazpenek kanal dedikatu bat erabiltzen dute:

```dart
// NotificationConfig.getStockAlertAndroidDetails()-en
AndroidNotificationDetails(
  'stock_alerts',
  'Stock Baxuko Alertak',
  channelDescription: 'Sendagaien stocka baxuan dagoeneko jakinarazpenak',
  importance: Importance.high,
  priority: Priority.high,
  autoCancel: true,
)
```

**Ezaugarriak:**
- Dosi oroigarrietatik bereizitako kanala
- Lehentasun altua (ez maximoa, intrusibo ez izateko)
- Auto-ezeztapena ukitzerakoan
- Integraturiko ekintzarik gabe (soilik informagarriak)

#### Noiz Erabili Mota Bakoitza

| Mota | Unea | Helburua | Blokeatzailea |
|------|------|----------|---------------|
| **Erreaktiboa** | Dosia erregistratzen saiatzerakoan | Eragotzi erregistroa stock nahikorik gabe | ✅ Bai |
| **Proaktiboa** | Eguneko egiaztapena (aukerakoa) | Aurreikusi beharrezko berritze beharra | ❌ Ez |

**Diseinu dualaren abantaila:**
- Babes absolutua une kritikoan (erreaktiboa)
- Aurreratutako plangintza une kritikoetara iristea saihesteko (proaktiboa)
- Sistema proaktiboa opt-in da (aplikazioaren logikak esplizituki deitu behar du)

---

## Ikuspegi Geruza (Screens/Widgets)

### Pantaila Nagusien Egitura

```
MedicationListScreen (pantaila nagusia)
├─ MedicationCard (widget berrerabilgarria)
│  ├─ TodayDosesSection
│  └─ FastingCountdownRow
├─ MedicationOptionsSheet (aukeren modala)
└─ TodayDosesSection (egunaren dosiak)

MedicationInfoScreen (sendagaia sortu/editatu)
├─ MedicationInfoForm
├─ MedicationDosageScreen
├─ MedicationTimesScreen
├─ MedicationDurationScreen
├─ MedicationDatesScreen
└─ EditFastingScreen

DoseActionScreen (dosia erregistratu/omititu)
├─ TakeDoseButton
├─ SkipDoseButton
└─ PostponeButtons

DoseHistoryScreen (historiala)
├─ FilterDialog
├─ StatisticsCard
└─ DeleteConfirmationDialog

SettingsScreen
├─ PersonsManagementScreen
└─ LanguageSelectionScreen
```

### Widget Berrerabilgarriak

**MedicationCard:**
- Sendagaiaren informazio laburra erakusten du
- Hurrengo dosia
- Stock egoera
- Gaurko dosiak (hartutak/omitituak)
- Baraualdi aktiboko kontaketa (aplikatzen bada)
- Esleitu diren pertsonak (fitxarik gabeko moduan)

**TodayDosesSection:**
- Egunaren dosien zerrenda horizontala
- Adierazle bisuala: ✓ (hartua), ✗ (omititua), hutsik (zain)
- Erregistroaren benetako ordua erakusten du (konfigurazioa aktibatuta badago)
- Tap editatzeko/ezabatzeko

**FastingCountdownRow:**
- Geratzen den baraualdi denboraren kontaketa denbora errealean
- Berdez aldatzen da eta soinua egiten du osatzean
- Dismiss botoia ezkutatzeko

### Nabigazioa

MedicApp Flutter-en **Navigator 1.0** estandarra erabiltzen du:

```dart
// Push oinarrizkoa
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => NewScreen()),
);

// Push emaitzarekin
final result = await Navigator.push<Medication>(
  context,
  MaterialPageRoute(builder: (context) => MedicationInfoScreen()),
);
```

**Navigator 2.0 ez erabiltzeko abantailak:**
- Sinpletasuna
- Stack esplizitua arrazoinamendu errazagoa
- Ikaste-kurba txikiagoa

### Widget Mailako Egoeraren Kudeaketa

**ViewModel Pattern (framework gabe):**

```dart
class MedicationListViewModel extends ChangeNotifier {
  List<Medication> _medications = [];
  List<Person> _persons = [];
  Person? _selectedPerson;
  bool _isLoading = false;

  // Getters
  List<Medication> get medications => _medications;
  bool get isLoading => _isLoading;

  // Business logic
  Future<void> loadMedications() async {
    _isLoading = true;
    notifyListeners();

    _medications = _selectedPerson != null
      ? await DatabaseHelper.instance.getMedicationsForPerson(_selectedPerson!.id)
      : await DatabaseHelper.instance.getAllMedications();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> registerDose({required Medication medication, required String doseTime}) async {
    // Negozio logika
    // Datu-basea eguneratu
    await loadMedications();  // UI freskatu
  }
}
```

**Pantailan:**

```dart
class MedicationListScreen extends StatefulWidget {
  @override
  State<MedicationListScreen> createState() => MedicationListScreenState();
}

class MedicationListScreenState extends State<MedicationListScreen> {
  late final MedicationListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = MedicationListViewModel();
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.initialize();
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _viewModel.isLoading
        ? CircularProgressIndicator()
        : ListView.builder(
            itemCount: _viewModel.medications.length,
            itemBuilder: (context, index) {
              return MedicationCard(medication: _viewModel.medications[index]);
            },
          ),
    );
  }
}
```

**Abantailak:**
- Ez ditu kanpoko paketerik behar (BLoC, Riverpod, Redux)
- Kode argia eta zuzena
- Errendimendu bikaina (abstrakzio geruza gutxiago)
- Probaketa erraza: ViewModel soilik instantziatzea

---

## Datuen Fluxua

### UI-tik Datu-basera (Dosia Erregistratu)

```
Erabiltzaileak "Hartu" ukitzen du jakinarazpenean
    │
    ▼
NotificationService._handleNotificationAction()
    │
    ├─ Stock eskuragarria balioztatu
    ├─ Medication eguneratu (stocka murriztu, takenDosesToday-ra gehitu)
    │  └─ DatabaseHelper.updateMedicationForPerson()
    │
    ├─ DoseHistoryEntry sortu
    │  └─ DatabaseHelper.insertDoseHistory()
    │
    ├─ Jakinarazpena ezeztatu
    │  └─ NotificationService.cancelTodaysDoseNotification()
    │
    └─ "Ondoren" baraualdia badu, jakinarazpen dinamikoa programatu
       └─ NotificationService.scheduleDynamicFastingNotification()
```

### Zerbitzuetatik Jakinarazpenetara (Sendagai Sortu)

```
Erabiltzaileak sendagai berriaren formularioa osatzen du
    │
    ▼
MedicationListViewModel.createMedication()
    │
    ├─ DatabaseHelper.createMedicationForPerson()
    │  ├─ Bilatu ea sendagai horrekin existitzen den
    │  ├─ Badago: berrerabili (stock partekatua)
    │  └─ Ez badago: medications-en sarrera sortu
    │
    └─ NotificationService.scheduleMedicationNotifications(
         medication,
         personId: personId
       )
       │
       ├─ Jakinarazpen zaharrak ezeztatu (existitzen baziren)
       │
       ├─ durationType-ren arabera:
       │  ├─ everyday/untilFinished → DailyNotificationScheduler
       │  ├─ weeklyPattern → WeeklyNotificationScheduler
       │  └─ specificDates → DailyNotificationScheduler (data espezifikoak)
       │
       └─ requiresFasting && notifyFasting bada:
          └─ FastingNotificationScheduler.scheduleFastingNotifications()
```

### UI Eguneraketa (Denbora Errealean)

```
DatabaseHelper datuak eguneratzen ditu
    │
    ▼
ViewModel.loadMedications()  // BD-tik birkargatu
    │
    ▼
ViewModel.notifyListeners()
    │
    ▼
Screen._onViewModelChanged()
    │
    ▼
setState(() {})  // Flutter UI berreraiki
```

**UI-first optimizazioa:**
Eragiketa askok UI lehenengo eguneratzen dute eta gero datu-basea bigarren planoan:

```dart
// AURRETIK (blokeatzailea)
await database.update(...);
setState(() {});  // Erabiltzaileak itxaron

// ORAIN (optimista)
setState(() {});  // UI berehalakoa
database.update(...);  // Bigarren planoan
```

Emaitza: Eragiketa ohikoetan **15-30x azkarragoa**.

---

## Jakinarazpenen Kudeaketa

### ID Bakarra Sistema

Jakinarazpen bakoitzak ID bakarra du bere motaren arabera kalkulatua:

```dart
enum NotificationIdType {
  daily,           // 0-10,999,999
  postponed,       // 2,000,000-2,999,999
  specificDate,    // 3,000,000-3,999,999
  weekly,          // 4,000,000-4,999,999
  fasting,         // 5,000,000-5,999,999
  dynamicFasting,  // 6,000,000-6,999,999
}
```

**Eguneko jakinarazpenerako ID sorrera:**
```dart
static int _generateDailyId(String medicationId, int doseIndex, String personId) {
  final medicationHash = medicationId.hashCode.abs();
  final personHash = personId.hashCode.abs();
  return ((medicationHash % 10000) * 1000 + (personHash % 10) * 100 + doseIndex);
}
```

**Abantailak:**
- Jakinarazpen moten arteko talken saiheste
- Hautazko ezeztapena ahalbidetzen du
- Debug errazagoa (ID-ak mota adierazten du bere tarte arabera)
- Pertsona anitzeko onarpena (personId-ren hash-a barne hartzen du)

### Ezeztapen Adimentsua

1000 ID-ra arte itsu-itsuan ezeztatu ordez, aplikazioak zehazki kalkulatzen du zer ezeztatu:

```dart
Future<void> cancelMedicationNotifications(String medicationId, {Medication? medication}) async {
  if (medication == null) {
    // Ezeztapen zakarra (bateragarritasuna)
    _cancelBruteForce(medicationId);
    return;
  }

  // Ezeztapen adimentsua
  final doseCount = medication.doseTimes.length;

  // Sendagai honi esleitutako pertsona bakoitzerako
  final persons = await DatabaseHelper.instance.getPersonsForMedication(medicationId);

  for (final person in persons) {
    // Eguneroko jakinarazpenak ezeztatu
    for (int i = 0; i < doseCount; i++) {
      final notificationId = NotificationIdGenerator.generate(
        type: NotificationIdType.daily,
        medicationId: medicationId,
        personId: person.id,
        doseIndex: i,
      );
      await _notificationsPlugin.cancel(notificationId);
    }

    // Baraualdia ezeztatu aplikatzen bada
    if (medication.requiresFasting) {
      _cancelFastingNotifications(medication, person.id);
    }
  }
}
```

**Emaitza:**
- Benetan existitzen diren jakinarazpenak soilik ezeztatzen ditu
- 1000 ID iteratzea baino askoz azkarragoa
- Beste jakinarazpenetan albo-efektuak saihesten ditu

### Ekintza Zuzenak (Android)

Jakinarazpenek ekintza azkarreko botoiak barne hartzen dituzte:

```dart
final androidDetails = AndroidNotificationDetails(
  'medication_reminders',
  'Sendagaien Oroigarriak',
  actions: [
    AndroidNotificationAction('register_dose', 'Hartu'),
    AndroidNotificationAction('skip_dose', 'Omititu'),
    AndroidNotificationAction('snooze_dose', 'Atzeratu 10min'),
  ],
);
```

**Ekintza fluxua:**
```
Erabiltzaileak "Hartu" botoia ukitzen du
    │
    ▼
NotificationService._onNotificationTapped()
    │ (actionId = 'register_dose' detektatu)
    ▼
_handleNotificationAction()
    │
    ├─ Sendagaia BD-tik kargatu
    ├─ Stocka balioztatu
    ├─ Medication eguneratu
    ├─ DoseHistoryEntry sortu
    ├─ Jakinarazpena ezeztatu
    └─ Baraualdia programatu aplikatzen bada
```

### 5 Jakinarazpen Aktiboren Muga

Android/iOS-ek ikusgai dauden jakinarazpenen mugak ditu. MedicApp adimenduz programatzen du:

**Estrategia:**
- **Gaur + 1 egun** (bihar) bakarrik programatzen da
- Aplikazioa irekitzean edo eguna aldatzean, automatikoki berprogramatzen da
- Hurbileneko jakinarazpenei lehentasuna ematen zaie

```dart
Future<void> rescheduleAllMedicationNotifications() async {
  await cancelAllNotifications();

  final allPersons = await DatabaseHelper.instance.getAllPersons();

  for (final person in allPersons) {
    final medications = await DatabaseHelper.instance.getMedicationsForPerson(person.id);

    for (final medication in medications) {
      if (medication.isActive && !medication.isSuspended) {
        // Hurrengo 48h soilik programatu
        await scheduleMedicationNotifications(
          medication,
          personId: person.id,
          skipCancellation: true,  // Goian guztiak ezeztatu ditugu
        );
      }
    }
  }
}
```

**Berprogramazio trigger-ak:**
- Aplikazioa abiarazi
- Bigarren planotik berreskuratzen (AppLifecycleState.resumed)
- Sendagaia sortu/editatu/ezabatu ondoren
- Eguna aldatuz (gauerdia)

---

## SQLite Datu-basea V19

### Taulen Eskema

#### medications (partekatutako datuak)

```sql
CREATE TABLE medications (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  stockQuantity REAL NOT NULL DEFAULT 0,
  lastRefillAmount REAL,
  lowStockThresholdDays INTEGER NOT NULL DEFAULT 3,
  lastDailyConsumption REAL
);
```

#### persons (erabiltzaileak eta familiarrak)

```sql
CREATE TABLE persons (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  isDefault INTEGER DEFAULT 0  -- Boolearra: 1=lehenetsia, 0=ez
);
```

#### person_medications (pauta indibiduala N:N)

```sql
CREATE TABLE person_medications (
  id TEXT PRIMARY KEY,
  personId TEXT NOT NULL,
  medicationId TEXT NOT NULL,
  assignedDate TEXT NOT NULL,

  -- INDIBIDUALA KONFIGURAZIOA
  durationType TEXT NOT NULL,
  dosageIntervalHours INTEGER DEFAULT 0,
  doseSchedule TEXT NOT NULL,  -- JSON: {"08:00": 1.0, "20:00": 1.5}
  takenDosesToday TEXT,        -- CSV: "08:00,20:00"
  skippedDosesToday TEXT,
  takenDosesDate TEXT,
  selectedDates TEXT,          -- CSV: "2025-01-15,2025-01-20"
  weeklyDays TEXT,             -- CSV: "1,3,5" (Al, Az, Or)
  dayInterval INTEGER,
  startDate TEXT,              -- ISO8601
  endDate TEXT,
  requiresFasting INTEGER DEFAULT 0,
  fastingType TEXT,
  fastingDurationMinutes INTEGER,
  notifyFasting INTEGER DEFAULT 0,
  isSuspended INTEGER DEFAULT 0,

  FOREIGN KEY (personId) REFERENCES persons (id) ON DELETE CASCADE,
  FOREIGN KEY (medicationId) REFERENCES medications (id) ON DELETE CASCADE,
  UNIQUE(personId, medicationId)  -- Pauta bat pertsona-sendagai bakoitzeko
);
```

#### dose_history (hartze historiala)

```sql
CREATE TABLE dose_history (
  id TEXT PRIMARY KEY,
  medicationId TEXT NOT NULL,
  medicationName TEXT NOT NULL,
  medicationType TEXT NOT NULL,
  personId TEXT NOT NULL,
  scheduledDateTime TEXT NOT NULL,   -- Noiz hartu behar zen
  registeredDateTime TEXT NOT NULL,  -- Noiz erregistratu zen
  status TEXT NOT NULL,              -- 'taken' | 'skipped'
  quantity REAL NOT NULL,
  isExtraDose INTEGER DEFAULT 0,
  notes TEXT,

  FOREIGN KEY (personId) REFERENCES persons (id) ON DELETE CASCADE
);
```

### Indizeak eta Optimizazioak

```sql
-- Sendagaiaren araberako bilaketa azkarrak
CREATE INDEX idx_dose_history_medication ON dose_history(medicationId);

-- Dataren araberako bilaketa azkarrak
CREATE INDEX idx_dose_history_date ON dose_history(scheduledDateTime);

-- Pertsonaren araberako pauten bilaketa azkarrak
CREATE INDEX idx_person_medications_person ON person_medications(personId);

-- Sendagaiaren araberako pertsonen bilaketa azkarrak
CREATE INDEX idx_person_medications_medication ON person_medications(medicationId);
```

**Inpaktua:**
- Historial kontsultak: 10-100x azkarragoak
- Pertsonaren araberako sendagaien karga: O(log n) O(n) ordez
- Atxikipen estatistikak: kalkulu berehalakoa

### Trigger-ak Osotasunerako

SQLite-k ez ditu trigger esplizituak kode honetan, baina **atzerriko gakoak CASCADE-rekin** bermatzen dute:

```sql
FOREIGN KEY (personId) REFERENCES persons (id) ON DELETE CASCADE
```

**Portaera:**
- Pertsona bat ezabatzen bada → bere `person_medications` eta `dose_history` automatikoki ezabatzen dira
- Sendagai bat ezabatzen bada → bere `person_medications` automatikoki ezabatzen dira

### Migrazio Sistema

Datu-baseak automatikoki eguneratzen da aurretiko edozein bertsiotik:

```dart
await openDatabase(
  path,
  version: 19,  // Uneko bertsioa
  onCreate: _createDB,     // Instalazio berria bada
  onUpgrade: _upgradeDB,   // BD existitzen bada bertsioa < 19
);
```

**Migrazio adibidea (V18 → V19):**

```dart
if (oldVersion < 19) {
  // 1. Backup
  await db.execute('ALTER TABLE person_medications RENAME TO person_medications_old');
  await db.execute('ALTER TABLE medications RENAME TO medications_old');

  // 2. Egitura berriak sortu
  await db.execute('''CREATE TABLE medications (...)''');
  await db.execute('''CREATE TABLE person_medications (...)''');

  // 3. Datuak migratu
  await db.execute('''
    INSERT INTO medications (id, name, type, stockQuantity, ...)
    SELECT id, name, type, stockQuantity, ... FROM medications_old
  ''');

  await db.execute('''
    INSERT INTO person_medications (id, personId, medicationId, doseSchedule, ...)
    SELECT pm.id, pm.personId, pm.medicationId, m.doseSchedule, ...
    FROM person_medications_old pm
    INNER JOIN medications_old m ON pm.medicationId = m.id
  ''');

  // 4. Garbitu
  await db.execute('DROP TABLE person_medications_old');
  await db.execute('DROP TABLE medications_old');
}
```

**Abantailak:**
- Erabiltzaileak ez du daturik galtzen eguneratzean
- Migrazio gardena eta automatikoa
- Rollback manuala posible (aldi baterako backup-ak gordetzen dira)

---

## Errendimendu Optimizazioak

### UI-First Eragiketak

**Jatorrizko arazoa:**
```dart
// Erabiltzaileak dosia erregistratzen du → UI izoztua ~500ms
await database.update(medication);
setState(() {});  // UI ONDOREN eguneratua
```

**Konponbide optimista:**
```dart
// UI BEREHALAKO eguneratua (~15ms)
setState(() {
  // Egoera lokala eguneratu
});
// Datu-basea bigarren planoan eguneratzen da
unawaited(database.update(medication));
```

**Neurtutako emaitzak:**
- Dosien erregistroa: 500ms → **30ms** (16.6x azkarragoa)
- Stock eguneraketa: 400ms → **15ms** (26.6x azkarragoa)
- Pantailen arteko nabigazioa: 300ms → **20ms** (15x azkarragoa)

### Frame Galdu Murrizketa

**Aurretik (state management konplexuarekin):**
```
Frame aurrekontua: 16ms (60 FPS)
Benetako denbora: 45ms → segundoko 30 frame galduak
```

**Ondoren (ViewModel sinplea):**
```
Frame aurrekontua: 16ms (60 FPS)
Benetako denbora: 12ms → 0 frame galdu
```

**Aplikatutako teknika:**
- Kataratak berreraiki saihestea
- `notifyListeners()` datu garrantzitsuak aldatzen direnean soilik
- `const` widgetak posible den tokietan

### Hasiera Denbora < 100ms

```
1. main() exekutatuta                   → 0ms
2. DatabaseHelper hasieratuta           → 10ms
3. NotificationService hasieratuta      → 30ms
4. Lehen pantaila errendizatua          → 80ms
5. Datuak bigarren planoan kargatuak    → 200ms (asinkrono)
```

Erabiltzaileak **80ms**-tan UI ikusten du, datuak geroago agertzen dira.

**Teknika:**
```dart
@override
void initState() {
  super.initState();
  _viewModel = MedicationListViewModel();

  // Lehen frame-aren ONDOREN hasieratu
  SchedulerBinding.instance.addPostFrameCallback((_) {
    _initializeViewModel();
  });
}
```

### Dosien Erregistroa < 200ms

```
"Dosia hartu" tap-a
    ↓
15ms: setState UI lokala eguneratzen du
    ↓
50ms: database.update() bigarren planoan
    ↓
100ms: database.insert(history) bigarren planoan
    ↓
150ms: NotificationService.cancel() bigarren planoan
    ↓
Erabiltzaileak hautemandako osoa: 15ms (UI berehalakoa)
Benetako osoa: 150ms (baina ez du blokeatzen)
```

### Pertsona Lehenetsiaren Cachea

```dart
class DatabaseHelper {
  Person? _cachedDefaultPerson;

  Future<Person?> getDefaultPerson() async {
    if (_cachedDefaultPerson != null) {
      return _cachedDefaultPerson;  // Berehalakoa!
    }

    // BD soilik cachean ez badago kontsultatu
    final db = await database;
    final result = await db.query('persons', where: 'isDefault = ?', whereArgs: [1]);
    _cachedDefaultPerson = Person.fromJson(result.first);
    return _cachedDefaultPerson;
  }

  void _invalidateDefaultPersonCache() {
    _cachedDefaultPerson = null;
  }
}
```

**Inpaktua:**
- Ondorengo dei bakoitza: 0,01ms (1000x azkarragoa)
- Pertsona bat aldatzen denean soilik baliogabetu

---

## Kodearen Modularizazioa

### Aurretik: Fitxategi Monolitikoak

```
lib/
└── screens/
    └── medication_list_screen.dart  (3500 lerro)
        ├── UI
        ├── Negozio logika
        ├── Elkarrizketak
        └── Widget laguntzaileak (guztia nahasita)
```

### Ondoren: Egitura Modularra

```
lib/
└── screens/
    └── medication_list/
        ├── medication_list_screen.dart        (400 lerro - UI soilik)
        ├── medication_list_viewmodel.dart     (300 lerro - logika)
        │
        ├── widgets/
        │   ├── medication_card.dart
        │   ├── today_doses_section.dart
        │   ├── empty_medications_view.dart
        │   ├── battery_optimization_banner.dart
        │   └── debug_menu.dart
        │
        ├── dialogs/
        │   ├── medication_options_sheet.dart
        │   ├── dose_selection_dialog.dart
        │   ├── refill_input_dialog.dart
        │   └─ notification_permission_dialog.dart
        │
        └── services/
            └── dose_calculation_service.dart
```

**%39,3-ko murrizketa:**
- **Aurretik:** 3500 lerro fitxategi batean
- **Ondoren:** 2124 lerro 14 fitxategitan (~150 lerro/fitxategi batez besteko)

### Modularizazioaren Abantailak

1. **Mantengarra:**
   - Elkarrizketa batean aldaketa → fitxategi hori soilik editatzen duzu
   - Git diff-ak argiagoak (gatazka gutxiago)

2. **Berrerabilgarritasuna:**
   - `MedicationCard` zerrendan ETA bilaketatan erabiltzen da
   - `DoseSelectionDialog` 3 pantailatan berrerabiltzen da

3. **Probagarritasuna:**
   - ViewModel UI gabe probatzen da
   - Widgetak `testWidgets`-ekin modu isolatuan probatzen dira

4. **Lankidetza:**
   - A pertsona elkarrizketetan lan egiten du
   - B pertsona ViewModel-ean lan egiten du
   - Merge gatazkak gabe

### Adibidea: Elkarrizketa Berrerabilgarria

```dart
// lib/screens/medication_list/dialogs/refill_input_dialog.dart
class RefillInputDialog {
  static Future<double?> show(
    BuildContext context,
    {required Medication medication}
  ) async {
    return showDialog<double>(
      context: context,
      builder: (context) => _RefillInputDialogWidget(medication: medication),
    );
  }
}

// Erabilera EDOZEIN pantailatan
final refillAmount = await RefillInputDialog.show(context, medication: med);
if (refillAmount != null) {
  // Karga logika
}
```

**Berrerabilia horretan:**
- `MedicationListScreen`
- `MedicationStockScreen`
- `MedicineSearchScreen`

---

## Lokalizazioa (l10n)

MedicApp-ek **8 hizkuntza** onartzen ditu Flutter-en sistema ofizialarekin.

### Flutter Intl Sistema

```yaml
# pubspec.yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.0

flutter:
  generate: true  # Kodea automatikoki sortu

# l10n.yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

### ARB Fitxategiak (Application Resource Bundle)

```
lib/l10n/
├── app_en.arb  (oinarri txantiloia - ingelesa)
├── app_es.arb  (gaztelania)
├── app_ca.arb  (katalana)
├── app_eu.arb  (euskara)
├── app_gl.arb  (galiziera)
├── app_fr.arb  (frantsesa)
├── app_it.arb  (italiera)
└── app_de.arb  (alemana)
```

**ARB fitxategi adibidea:**

```json
{
  "@@locale": "eu",

  "mainScreenTitle": "Nire Sendagaiak",
  "@mainScreenTitle": {
    "description": "Pantaila nagusiaren izenburua"
  },

  "doseRegisteredAtTime": "{medication} dosia {time}-etan erregistratua. Geratzen den stocka: {stock}",
  "@doseRegisteredAtTime": {
    "description": "Erregistratutako dosiaren berrespena",
    "placeholders": {
      "medication": {"type": "String"},
      "time": {"type": "String"},
      "stock": {"type": "String"}
    }
  },

  "remainingDosesToday": "{count, plural, =1{1 dosi geratzen da gaur} other{{count} dosi geratzen dira gaur}}",
  "@remainingDosesToday": {
    "description": "Geratzen diren dosiak",
    "placeholders": {
      "count": {"type": "int"}
    }
  }
}
```

### Kodearen Sorrera Automatikoa

`flutter gen-l10n` exekutatzean sortzen dira:

```dart
// lib/l10n/app_localizations.dart (abstraktua)
abstract class AppLocalizations {
  String get mainScreenTitle;
  String doseRegisteredAtTime(String medication, String time, String stock);
  String remainingDosesToday(int count);
}

// lib/l10n/app_localizations_eu.dart (inplementazioa)
class AppLocalizationsEu extends AppLocalizations {
  @override
  String get mainScreenTitle => 'Nire Sendagaiak';

  @override
  String doseRegisteredAtTime(String medication, String time, String stock) {
    return '$medication dosia $time-etan erregistratua. Geratzen den stocka: $stock';
  }

  @override
  String remainingDosesToday(int count) {
    return Intl.plural(
      count,
      one: '1 dosi geratzen da gaur',
      other: '$count dosi geratzen dira gaur',
    );
  }
}
```

### Aplikazioko Erabilera

```dart
// main.dart-en
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: MedicationListScreen(),
);

// Edozein widget-en
@override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  return Scaffold(
    appBar: AppBar(
      title: Text(l10n.mainScreenTitle),
    ),
    body: Text(l10n.remainingDosesToday(3)),  // "3 dosi geratzen dira gaur"
  );
}
```

### Pluralizazio Automatikoa

```dart
// Euskara
remainingDosesToday(1) → "1 dosi geratzen da gaur"
remainingDosesToday(3) → "3 dosi geratzen dira gaur"

// Ingelesa (app_en.arb-tik sortua)
remainingDosesToday(1) → "1 dose remaining today"
remainingDosesToday(3) → "3 doses remaining today"
```

### Hizkuntza Hautaketa Automatikoa

Aplikazioak sistemaaren hizkuntza detektatzen du:

```dart
// main.dart
MaterialApp(
  locale: const Locale('eu', ''),  // Euskara behartu (aukerakoa)
  localeResolutionCallback: (locale, supportedLocales) {
    // Gailuaren hizkuntza onartuta badago, erabili
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale?.languageCode) {
        return supportedLocale;
      }
    }
    // Fallback ingelesa
    return const Locale('en', '');
  },
);
```

---

## Diseinu Erabakiak

### Zergatik EZ BLoC/Riverpod/Redux

**Kontuan hartutako gauzak:**

1. **Konplexutasun beharrezkoa:**
   - MedicApp-ek ez du egoera global konplexurik
   - Egoera gehiena pantailetara lokala da
   - Ez dago lehian egia iturri anitz

2. **Ikaste kurba:**
   - BLoC-ek Streams, Sinks, gertaerak ulertzea eskatzen du
   - Riverpod-ek kontzeptu aurreratuak ditu (providers, family, autoDispose)
   - Redux-ek ekintzak, murrizleak, middleware eskatzen du

3. **Errendimendua:**
   - ViewModel sinplea: 12ms/frame
   - BLoC (neurtuta): 28ms/frame → **2,3x motelagoa**
   - Geruza gehiago = overhead gehiago

4. **APK Tamaina:**
   - flutter_bloc: +2,5 MB
   - riverpod: +1,8 MB
   - State management gabeko: 0 MB gehigarriak

**Erabakia:**
- `ChangeNotifier` + ViewModel nahikoa da
- Kode sinpleagoa eta zuzenagoa
- Errendimendu hobea

**Salbuespen BAI erabiliko genukeena:**
- Backend-arekin denbora errealean sinkronizazioa badago
- Pantaila anitzek egoera berdinera erreakzionatu behar badute
- Albo-efektu anitzeko logika konplexua badago

### Zergatik SQLite Hive/Isar Ordez

**Konparaketa:**

| Ezaugarria | SQLite | Hive | Isar |
|------------|--------|------|------|
| Kontsulta konplexuak | ✅ SQL osoa | ❌ Gako-balio soilik | ⚠️ Mugatua |
| N:N Erlazioak | ✅ Atzerriko gakoak | ❌ Eskuzkoa | ⚠️ Esteka eskuzoak |
| Migrazioak | ✅ onUpgrade | ❌ Eskuzkoa | ⚠️ Partziala |
| Indizeak | ✅ CREATE INDEX | ❌ Ez | ✅ Bai |
| Transakzioak | ✅ ACID | ⚠️ Mugatuak | ✅ Bai |
| Heldutasuna | ✅ 20+ urte | ⚠️ Gaztea | ⚠️ Oso gaztea |
| Tamaina | ~1,5 MB | ~200 KB | ~1,2 MB |

**Erabakia:**
- SQLite irabazten du:
  - **Kontsulta konplexuak** (JOIN, GROUP BY, estatistikak)
  - **Migrazio automatikoak** (eguneraketetarako kritikoa)
  - **Erlazio esplizituak** (person_medications N:N)
  - **Heldutasuna eta egonkortasuna**

**Kasua Hive erabiliko genukeena:**
- Aplikazio oso sinplea (TODO zerrenda soilik erlaziorik gabe)
- Ez dira bilaketa konplexuak behar
- APK tamainean lehentasun maximoa

### Zergatik Flutter Local Notifications

**Alternatiba kontsidera tuak:**

1. **awesome_notifications:**
   - ✅ Feature gehiago (jakinarazpen aberatsak, irudiak)
   - ❌ Asturagoa (+3 MB)
   - ❌ API konplexuagoa
   - ❌ Gutxiago onartuta (komunitate txikiagoa)

2. **firebase_messaging:**
   - ✅ Push jakinarazpen urrunekoituak
   - ❌ Backend behar (beharrezkoa ez oroigarri lokalentzat)
   - ❌ Firebase mendekotasuna (vendor lock-in)
   - ❌ Pribatutasuna (datuak gailutik irteten dira)

3. **flutter_local_notifications:**
   - ✅ Arina (~800 KB)
   - ✅ Heldua eta egonkorra
   - ✅ Komunitate handia (milaka star)
   - ✅ API sinplea eta zuzena
   - ✅ 100% lokala (pribatutasun osoa)
   - ✅ Android-en ekintza zuzenak onartzen ditu

**Erabakia:**
- `flutter_local_notifications` nahikoa da
- Ez dugu push urrunekoa behar
- Pribatutasuna: guztia gailuan gelditzen da

### Kontuan Hartutako Trade-off-ak

#### 1. ViewModel vs BLoC

**Trade-off:**
- ❌ Galtzen du: Logika banaketa zorrotza
- ✅ Irabazten du: Sinpletasuna, errendimendua, tamaina

**Murrizketa:**
- ViewModel-ek logika nahikoa isolatzen du probaketarako
- Zerbitzuak eragiketa konplexuak kudeatzen dituzte

#### 2. SQLite vs NoSQL

**Trade-off:**
- ❌ Galtzen du: Abiadura eragiketa oso sinpleetan
- ✅ Irabazten du: Kontsulta konplexuak, erlazioak, migrazioak

**Murrizketa:**
- Indizeek kontsulta motelak optimizatzen dituzte
- Cacheak BD sarbidea murrizten du

#### 3. Navigator 1.0 vs 2.0

**Trade-off:**
- ❌ Galtzen du: Deep linking aurreratua
- ✅ Irabazten du: Sinpletasuna, stack esplizitua

**Murrizketa:**
- MedicApp-ek ez du deep linking konplexurik behar
- Aplikazioa nagusiki CRUD lokala da

#### 4. UI-First Eguneraketak

**Trade-off:**
- ❌ Galtzen du: Berehalako koherentziaren bermea
- ✅ Irabazten du: UX berehalakoa (15-30x azkarragoa)

**Murrizketa:**
- Eragiketak sinpleak dira (huts egiteko probabilitate baxua)
- Async eragiketa huts egiten badu, UI aldatzen da mezuarekin

---

## Erreferentzia Gurutzatuak

- **Garapen Gida:** Ekarpenak egiten hasteko → [CONTRIBUTING.md](../CONTRIBUTING.md)
- **API Dokumentazioa:** Klaseen erreferentzia → [api_reference.md](api_reference.md)
- **Aldaketen Historiala:** BD migrazioak → [CHANGELOG.md](../../CHANGELOG.md)
- **Probaket a:** Proba estrategiak → [testing.md](testing.md)

---

## Ondorioa

MedicApp-en arkitekturak lehentasuna ematen dio:

1. **Sinpletasuna** konplexutasun beharrezkoaren aurretik
2. **Errendimendua** neurgaiai eta optimizatua
3. **Mantengarra** modularizazioaren bidez
4. **Pribatutasuna** %100 prozesatze lokalarekin
5. **Eskalagarritasuna** N:N pertsona anitzeko diseinuaren bidez

Arkitektura honek ahalbidetzen du:
- UI erantzun denbora < 30ms
- Pertsona anitzeko onarpena pauta independente batekin
- Funtzionalitate berriak gehitzea egitura nagusiak berregituratzen gabe
- Osagaien proba isolatua
- Datu-basearen migrazioa datu galtzerik gabe

Arkitektura hau mantenduz proiektuari ekarpenak egiteko, ikusi [CONTRIBUTING.md](../CONTRIBUTING.md).
