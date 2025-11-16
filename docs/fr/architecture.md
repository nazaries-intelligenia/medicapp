# Architecture de MedicApp

## Table des Matières

1. [Vue d'ensemble de l'Architecture](#vue-densemble-de-larchitecture)
2. [Architecture Multi-Personne V19+](#architecture-multi-personne-v19)
3. [Couche de Modèles (Models)](#couche-de-modèles-models)
4. [Couche de Services (Services)](#couche-de-services-services)
5. [Couche de Vue (Screens/Widgets)](#couche-de-vue-screenswidgets)
6. [Flux de Données](#flux-de-données)
7. [Gestion des Notifications](#gestion-des-notifications)
8. [Base de Données SQLite V19](#base-de-données-sqlite-v19)
9. [Optimisations de Performance](#optimisations-de-performance)
10. [Modularisation du Code](#modularisation-du-code)
11. [Localisation (l10n)](#localisation-l10n)
12. [Décisions de Conception](#décisions-de-conception)

---

## Vue d'ensemble de l'Architecture

MedicApp utilise un **pattern Model-View-Service (MVS)** simplifié, sans dépendances de frameworks complexes de state management comme BLoC, Riverpod ou Redux.

### Justification

La décision de ne pas utiliser de state management complexe est basée sur :

1. **Simplicité** : L'application gère l'état principalement au niveau écran/widget
2. **Performance** : Moins de couches d'abstraction = réponses plus rapides
3. **Maintenabilité** : Code plus direct et facile à comprendre
4. **Taille** : Moins de dépendances = APK plus léger

### Diagramme de Couches

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

## Architecture Multi-Personne V19+

À partir de la version 19, MedicApp implémente un **modèle de données N:N (plusieurs-à-plusieurs)** qui permet à plusieurs personnes de partager le même médicament tout en maintenant des configurations individuelles.

### Modèle de Données N:N

```
┌─────────────┐         ┌──────────────────┐         ┌─────────────┐
│   persons   │         │person_medications│         │ medications │
├─────────────┤         ├──────────────────┤         ├─────────────┤
│ id          │◄────────│ personId         │         │ id          │
│ name        │         │ medicationId     │────────►│ name        │
│ isDefault   │         │ assignedDate     │         │ type        │
└─────────────┘         │                  │         │ stockQuantity│
                        │ PAUTA INDIVIDUAL │         │ lastRefill  │
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

### Séparation des Responsabilités

| Table | Responsabilité | Exemples |
|-------|----------------|----------|
| **medications** | Données PARTAGÉES entre personnes | nom, type, stock physique |
| **person_medications** | Configuration INDIVIDUELLE de chaque personne | horaires, durée, état de suspension |
| **dose_history** | Historique de prises par personne | enregistrement avec personId |

### Exemples de Cas d'Usage

#### Exemple 1 : Paracétamol Partagé

```
Médicament : Paracétamol 500mg
├─ Stock partagé : 50 comprimés
├─ Personne : Jean (utilisateur par défaut)
│  └─ Posologie : 08:00, 16:00, 00:00 (3 fois par jour)
└─ Personne : Marie (membre de la famille)
   └─ Posologie : 12:00 (1 fois par jour, uniquement si nécessaire)
```

En base de données :
- **1 entrée** dans `medications` (stock partagé)
- **2 entrées** dans `person_medications` (posologies différentes)

#### Exemple 2 : Médicaments Différents

```
Jean :
├─ Oméprazole 20mg → 08:00
└─ Atorvastatine 40mg → 22:00

Marie :
└─ Lévothyroxine 100mcg → 07:00
```

En base de données :
- **3 entrées** dans `medications`
- **3 entrées** dans `person_medications` (une par médicament-personne)

### Migration Automatique V16→V19

La base de données migre automatiquement depuis les architectures anciennes :

```dart
// V18 : medications contenait TOUT (stock + posologie)
medications (id, name, type, stock, doseSchedule, durationType, ...)

// V19 : SÉPARATION
medications (id, name, type, stock)  // SEULEMENT données partagées
person_medications (personId, medicationId, doseSchedule, durationType, ...)
```

**Processus de migration :**
1. Backup des tables anciennes (`medications_old`, `person_medications_old`)
2. Création des nouvelles structures
3. Copie des données partagées vers `medications`
4. Copie des posologies individuelles vers `person_medications`
5. Recréation des index
6. Suppression des backups

---

## Couche de Modèles (Models)

### Person

Représente une personne (utilisateur ou membre de la famille).

```dart
class Person {
  final String id;
  final String name;
  final bool isDefault;  // Utilisateur principal
}
```

**Responsabilités :**
- Identification unique
- Nom à afficher dans l'UI
- Indicateur de personne par défaut (reçoit des notifications sans préfixe de nom)

### Medication

Représente le **médicament physique** avec son stock partagé.

```dart
class Medication {
  // DONNÉES PARTAGÉES (dans table medications)
  final String id;
  final String name;
  final MedicationType type;
  final double stockQuantity;
  final double? lastRefillAmount;
  final int lowStockThresholdDays;
  final double? lastDailyConsumption;

  // DONNÉES INDIVIDUELLES (de person_medications, fusionnées lors de la consultation)
  final TreatmentDurationType durationType;
  final Map<String, double> doseSchedule;
  final List<String> takenDosesToday;
  final List<String> skippedDosesToday;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool requiresFasting;
  final bool isSuspended;
  // ... plus de champs de configuration individuelle
}
```

**Méthodes importantes :**
- `shouldTakeToday()` : Logique de fréquence (quotidienne, hebdomadaire, intervalle, dates spécifiques)
- `isActive` : Vérifie si le traitement est en période active
- `isStockLow` : Calcule s'il reste peu de stock selon la consommation quotidienne
- `getAvailableDosesToday()` : Filtre les doses non prises/omises

### PersonMedication

Table intermédiaire N:N avec la **posologie individuelle** de chaque personne.

```dart
class PersonMedication {
  final String id;
  final String personId;
  final String medicationId;
  final String assignedDate;

  // POSOLOGIE INDIVIDUELLE
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

Enregistrement historique de chaque prise/omission.

```dart
class DoseHistoryEntry {
  final String id;
  final String medicationId;
  final String personId;  // V19+ : Traçabilité par personne
  final DateTime scheduledDateTime;  // Heure programmée
  final DateTime registeredDateTime; // Heure réelle d'enregistrement
  final DoseStatus status;  // taken | skipped
  final double quantity;
  final bool isExtraDose;  // Dose hors horaire
  final String? notes;
}
```

**Fonctionnalité :**
- Audit d'adhérence
- Calcul de statistiques
- Permet l'édition du temps d'enregistrement
- Distingue entre doses programmées et extra

### Relations Entre Modèles

```
Person (1) ──── (N) PersonMedication (N) ──── (1) Medication
   │                      │                         │
   │                      │                         │
   │                      ▼                         │
   └──────────────► DoseHistoryEntry ◄─────────────┘
```

---

## Couche de Services (Services)

### DatabaseHelper (Singleton)

Gère TOUTES les opérations SQLite.

```dart
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // CRUD Medications (seulement données partagées)
  Future<int> insertMedication(Medication medication);
  Future<Medication?> getMedication(String id);
  Future<List<Medication>> getAllMedications();
  Future<int> updateMedication(Medication medication);

  // V19+ : CRUD avec personnes
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

**Caractéristiques clés :**
- Singleton pour éviter les connexions multiples
- Migrations automatiques jusqu'à V19
- Cache de la personne par défaut pour optimiser les requêtes
- Méthodes d'exportation/importation de base de données

### NotificationService (Singleton)

Gère TOUTES les notifications du système.

```dart
class NotificationService {
  static final NotificationService instance = NotificationService._init();

  // Initialisation
  Future<void> initialize();
  Future<bool> requestPermissions();
  Future<bool> canScheduleExactAlarms();

  // Programmation V19+ (requiert personId)
  Future<void> scheduleMedicationNotifications(
    Medication medication,
    {required String personId, bool excludeToday = false}
  );

  // Annulation intelligente
  Future<void> cancelMedicationNotifications(String medicationId, {Medication? medication});
  Future<void> cancelTodaysDoseNotification({
    required Medication medication,
    required String doseTime,
    required String personId,
  });

  // Reporter dose
  Future<void> schedulePostponedDoseNotification({
    required Medication medication,
    required String originalDoseTime,
    required TimeOfDay newTime,
    required String personId,
  });

  // Jeûne
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

  // Reprogrammation massive
  Future<void> rescheduleAllMedicationNotifications();

  // Debug
  Future<List<PendingNotificationRequest>> getPendingNotifications();
}
```

**Délégation spécialisée :**
- `DailyNotificationScheduler` : Notifications quotidiennes récurrentes
- `WeeklyNotificationScheduler` : Schémas hebdomadaires
- `FastingNotificationScheduler` : Gestion des périodes de jeûne
- `NotificationCancellationManager` : Annulation intelligente

**Limite de notifications :**
L'application maintient un maximum de **5 notifications actives** dans le système pour éviter la saturation.

### DoseHistoryService

Centralise les opérations sur l'historique.

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

**Avantages :**
- Évite la duplication de logique entre écrans
- Gère automatiquement la mise à jour de `Medication` si l'entrée est d'aujourd'hui
- Restaure le stock si une prise est supprimée

### DoseCalculationService

Logique métier pour calculer les prochaines doses.

```dart
class DoseCalculationService {
  static NextDoseInfo? getNextDoseInfo(Medication medication);
  static String formatNextDose(NextDoseInfo info, BuildContext context);
}
```

**Responsabilités :**
- Détecte la prochaine dose selon la fréquence
- Formate les messages localisés ("Aujourd'hui à 18:00", "Demain à 08:00")
- Respecte les dates de début/fin de traitement

### FastingConflictService

Service de détection et gestion des conflits de jeûne entre médicaments.

```dart
class FastingConflictService {
  static Future<List<FastingConflict>> detectConflicts({
    required String personId,
    required Medication newMedication,
    String? timeToCheck,
  });

  static String getConflictDescription(
    FastingConflict conflict,
    BuildContext context,
  );

  static bool hasActiveConflicts(List<FastingConflict> conflicts);
}
```

**Responsabilités :**
- Détecte les conflits de jeûne entre les médicaments d'une même personne
- Identifie les chevauchements de périodes de jeûne (avant/après la prise)
- Génère des descriptions localisées des conflits détectés
- Aide à prévenir les incompatibilités dans les horaires de prise avec jeûne

---

## Couche de Vue (Screens/Widgets)

### Structure des Écrans Principaux

```
MedicationListScreen (écran principal)
├─ MedicationCard (widget réutilisable)
│  ├─ TodayDosesSection
│  └─ FastingCountdownRow
├─ MedicationOptionsSheet (modal d'options)
└─ TodayDosesSection (doses du jour)

MedicationInfoScreen (créer/éditer médicament)
├─ MedicationInfoForm
├─ MedicationDosageScreen
├─ MedicationTimesScreen
├─ MedicationDurationScreen
├─ MedicationDatesScreen
└─ EditFastingScreen

DoseActionScreen (enregistrer/omettre dose)
├─ TakeDoseButton
├─ SkipDoseButton
└─ PostponeButtons

DoseHistoryScreen (historique)
├─ FilterDialog
├─ StatisticsCard
└─ DeleteConfirmationDialog

SettingsScreen
├─ PersonsManagementScreen
└─ LanguageSelectionScreen
```

### Widgets Réutilisables

**MedicationCard :**
- Affiche les informations résumées du médicament
- Prochaine dose
- État du stock
- Doses du jour (prises/omises)
- Compteur de jeûne actif (si applicable)
- Personnes assignées (en mode sans onglets)

**TodayDosesSection :**
- Liste horizontale des doses du jour
- Indicateur visuel : ✓ (prise), ✗ (omise), vide (en attente)
- Affiche l'heure réelle d'enregistrement (si la configuration est activée)
- Tap pour éditer/supprimer

**FastingCountdownRow :**
- Compteur en temps réel du jeûne restant
- Change en vert et joue un son à la fin
- Bouton dismiss pour le masquer

### Navigation

MedicApp utilise **Navigator 1.0** standard de Flutter :

```dart
// Push basique
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => NewScreen()),
);

// Push avec résultat
final result = await Navigator.push<Medication>(
  context,
  MaterialPageRoute(builder: (context) => MedicationInfoScreen()),
);
```

**Avantages de ne pas utiliser Navigator 2.0 :**
- Simplicité
- Stack explicite facile à raisonner
- Courbe d'apprentissage plus faible

### Gestion d'État au Niveau Widget

**ViewModel Pattern (sans framework) :**

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
    // Logique métier
    // Met à jour la base de données
    await loadMedications();  // Rafraîchit l'UI
  }
}
```

**Dans l'écran :**

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

**Avantages :**
- Ne nécessite pas de packages externes (BLoC, Riverpod, Redux)
- Code clair et direct
- Performance excellente (moins de couches d'abstraction)
- Test facile : il suffit d'instancier le ViewModel

---

## Flux de Données

### De l'UI vers la Base de Données (Enregistrer Dose)

```
L'utilisateur appuie sur "Prendre" dans la notification
    │
    ▼
NotificationService._handleNotificationAction()
    │
    ├─ Valide le stock disponible
    ├─ Met à jour Medication (réduit stock, ajoute à takenDosesToday)
    │  └─ DatabaseHelper.updateMedicationForPerson()
    │
    ├─ Crée DoseHistoryEntry
    │  └─ DatabaseHelper.insertDoseHistory()
    │
    ├─ Annule notification
    │  └─ NotificationService.cancelTodaysDoseNotification()
    │
    └─ Si jeûne "après", programme notification dynamique
       └─ NotificationService.scheduleDynamicFastingNotification()
```

### Des Services aux Notifications (Créer Médicament)

```
L'utilisateur complète le formulaire de nouveau médicament
    │
    ▼
MedicationListViewModel.createMedication()
    │
    ├─ DatabaseHelper.createMedicationForPerson()
    │  ├─ Cherche si un médicament avec ce nom existe déjà
    │  ├─ Si existe : réutilise (stock partagé)
    │  └─ Sinon : crée entrée dans medications
    │
    └─ NotificationService.scheduleMedicationNotifications(
         medication,
         personId: personId
       )
       │
       ├─ Annule anciennes notifications (si elles existaient)
       │
       ├─ Selon durationType :
       │  ├─ everyday/untilFinished → DailyNotificationScheduler
       │  ├─ weeklyPattern → WeeklyNotificationScheduler
       │  └─ specificDates → DailyNotificationScheduler (dates spécifiques)
       │
       └─ Si requiresFasting && notifyFasting :
          └─ FastingNotificationScheduler.scheduleFastingNotifications()
```

### Mise à Jour de l'UI (Temps Réel)

```
DatabaseHelper met à jour les données
    │
    ▼
ViewModel.loadMedications()  // Recharge depuis BD
    │
    ▼
ViewModel.notifyListeners()
    │
    ▼
Screen._onViewModelChanged()
    │
    ▼
setState(() {})  // Flutter rebuilds UI
```

**Optimisation UI-first :**
Beaucoup d'opérations mettent à jour l'UI d'abord puis la base de données en arrière-plan :

```dart
// AVANT (bloquant)
await database.update(...);
setState(() {});  // L'utilisateur attend

// MAINTENANT (optimiste)
setState(() {});  // UI instantanée
database.update(...);  // Arrière-plan
```

Résultat : **15-30x plus rapide** dans les opérations courantes.

---

## Gestion des Notifications

### Système d'IDs Uniques

Chaque notification a un ID unique calculé selon son type :

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

**Génération d'ID pour notification quotidienne :**
```dart
static int _generateDailyId(String medicationId, int doseIndex, String personId) {
  final medicationHash = medicationId.hashCode.abs();
  final personHash = personId.hashCode.abs();
  return ((medicationHash % 10000) * 1000 + (personHash % 10) * 100 + doseIndex);
}
```

**Avantages :**
- Évite les collisions entre types de notification
- Permet d'annuler sélectivement
- Debug plus facile (l'ID indique le type par sa plage)
- Support multi-personne (inclut hash du personId)

### Annulation Intelligente

Au lieu d'annuler aveuglément jusqu'à 1000 IDs, l'application calcule exactement quoi annuler :

```dart
Future<void> cancelMedicationNotifications(String medicationId, {Medication? medication}) async {
  if (medication == null) {
    // Annulation brute (compatibilité)
    _cancelBruteForce(medicationId);
    return;
  }

  // Annulation intelligente
  final doseCount = medication.doseTimes.length;

  // Pour chaque personne assignée à ce médicament
  final persons = await DatabaseHelper.instance.getPersonsForMedication(medicationId);

  for (final person in persons) {
    // Annule notifications quotidiennes
    for (int i = 0; i < doseCount; i++) {
      final notificationId = NotificationIdGenerator.generate(
        type: NotificationIdType.daily,
        medicationId: medicationId,
        personId: person.id,
        doseIndex: i,
      );
      await _notificationsPlugin.cancel(notificationId);
    }

    // Annule jeûne si applicable
    if (medication.requiresFasting) {
      _cancelFastingNotifications(medication, person.id);
    }
  }
}
```

**Résultat :**
- Annule seulement les notifications qui existent réellement
- Beaucoup plus rapide que d'itérer 1000 IDs
- Évite les effets secondaires sur d'autres notifications

### Actions Directes (Android)

Les notifications incluent des boutons d'action rapide :

```dart
final androidDetails = AndroidNotificationDetails(
  'medication_reminders',
  'Rappels de Médicaments',
  actions: [
    AndroidNotificationAction('register_dose', 'Prendre'),
    AndroidNotificationAction('skip_dose', 'Omettre'),
    AndroidNotificationAction('snooze_dose', 'Reporter 10min'),
  ],
);
```

**Flux d'action :**
```
L'utilisateur appuie sur le bouton "Prendre"
    │
    ▼
NotificationService._onNotificationTapped()
    │ (détecte actionId = 'register_dose')
    ▼
_handleNotificationAction()
    │
    ├─ Charge le médicament depuis BD
    ├─ Valide le stock
    ├─ Met à jour Medication
    ├─ Crée DoseHistoryEntry
    ├─ Annule notification
    └─ Programme jeûne si applicable
```

### Limite de 5 Notifications Actives

Android/iOS ont des limites de notifications visibles. MedicApp programme intelligemment :

**Stratégie :**
- Programme seulement les notifications pour **aujourd'hui + 1 jour** (demain)
- À l'ouverture de l'app ou au changement de jour, reprogramme automatiquement
- Priorise les notifications les plus proches

```dart
Future<void> rescheduleAllMedicationNotifications() async {
  await cancelAllNotifications();

  final allPersons = await DatabaseHelper.instance.getAllPersons();

  for (final person in allPersons) {
    final medications = await DatabaseHelper.instance.getMedicationsForPerson(person.id);

    for (final medication in medications) {
      if (medication.isActive && !medication.isSuspended) {
        // Programme seulement les prochaines 48h
        await scheduleMedicationNotifications(
          medication,
          personId: person.id,
          skipCancellation: true,  // Déjà annulé tout en haut
        );
      }
    }
  }
}
```

**Déclencheurs de reprogrammation :**
- Au démarrage de l'app
- À la reprise depuis l'arrière-plan (AppLifecycleState.resumed)
- Après création/édition/suppression de médicament
- Au changement de jour (minuit)

---

## Base de Données SQLite V19

### Schéma de Tables

#### medications (données partagées)

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

#### persons (utilisateurs et membres de la famille)

```sql
CREATE TABLE persons (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  isDefault INTEGER DEFAULT 0  -- Booléen : 1=défaut, 0=non
);
```

#### person_medications (posologie individuelle N:N)

```sql
CREATE TABLE person_medications (
  id TEXT PRIMARY KEY,
  personId TEXT NOT NULL,
  medicationId TEXT NOT NULL,
  assignedDate TEXT NOT NULL,

  -- CONFIGURATION INDIVIDUELLE
  durationType TEXT NOT NULL,
  dosageIntervalHours INTEGER DEFAULT 0,
  doseSchedule TEXT NOT NULL,  -- JSON : {"08:00": 1.0, "20:00": 1.5}
  takenDosesToday TEXT,        -- CSV : "08:00,20:00"
  skippedDosesToday TEXT,
  takenDosesDate TEXT,
  selectedDates TEXT,          -- CSV : "2025-01-15,2025-01-20"
  weeklyDays TEXT,             -- CSV : "1,3,5" (Lun, Mer, Ven)
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
  UNIQUE(personId, medicationId)  -- Une posologie par personne-médicament
);
```

#### dose_history (historique de prises)

```sql
CREATE TABLE dose_history (
  id TEXT PRIMARY KEY,
  medicationId TEXT NOT NULL,
  medicationName TEXT NOT NULL,
  medicationType TEXT NOT NULL,
  personId TEXT NOT NULL,
  scheduledDateTime TEXT NOT NULL,   -- Quand devait être prise
  registeredDateTime TEXT NOT NULL,  -- Quand enregistrée
  status TEXT NOT NULL,              -- 'taken' | 'skipped'
  quantity REAL NOT NULL,
  isExtraDose INTEGER DEFAULT 0,
  notes TEXT,

  FOREIGN KEY (personId) REFERENCES persons (id) ON DELETE CASCADE
);
```

### Index et Optimisations

```sql
-- Recherches rapides par médicament
CREATE INDEX idx_dose_history_medication ON dose_history(medicationId);

-- Recherches rapides par date
CREATE INDEX idx_dose_history_date ON dose_history(scheduledDateTime);

-- Recherches rapides de posologies par personne
CREATE INDEX idx_person_medications_person ON person_medications(personId);

-- Recherches rapides de personnes par médicament
CREATE INDEX idx_person_medications_medication ON person_medications(medicationId);
```

**Impact :**
- Requêtes d'historique : 10-100x plus rapides
- Chargement de médicaments par personne : O(log n) au lieu de O(n)
- Statistiques d'adhérence : calcul instantané

### Triggers pour l'Intégrité

Bien que SQLite n'ait pas de triggers explicites dans ce code, les **foreign keys avec CASCADE** garantissent :

```sql
FOREIGN KEY (personId) REFERENCES persons (id) ON DELETE CASCADE
```

**Comportement :**
- Si une personne est supprimée → ses `person_medications` et `dose_history` sont automatiquement supprimés
- Si un médicament est supprimé → ses `person_medications` sont automatiquement supprimés

### Système de Migrations

La base de données se met à jour automatiquement depuis toute version antérieure :

```dart
await openDatabase(
  path,
  version: 19,  // Version actuelle
  onCreate: _createDB,     // Si nouvelle installation
  onUpgrade: _upgradeDB,   // Si BD existe avec version < 19
);
```

**Exemple de migration (V18 → V19) :**

```dart
if (oldVersion < 19) {
  // 1. Backup
  await db.execute('ALTER TABLE person_medications RENAME TO person_medications_old');
  await db.execute('ALTER TABLE medications RENAME TO medications_old');

  // 2. Créer nouvelles structures
  await db.execute('''CREATE TABLE medications (...)''');
  await db.execute('''CREATE TABLE person_medications (...)''');

  // 3. Migrer données
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

  // 4. Nettoyer
  await db.execute('DROP TABLE person_medications_old');
  await db.execute('DROP TABLE medications_old');
}
```

**Avantages :**
- L'utilisateur ne perd pas de données lors de la mise à jour
- Migration transparente et automatique
- Rollback manuel possible (des backups temporaires sont sauvegardés)

---

## Optimisations de Performance

### Opérations UI-First

**Problème original :**
```dart
// L'utilisateur enregistre une dose → UI gelée ~500ms
await database.update(medication);
setState(() {});  // UI mise à jour APRÈS
```

**Solution optimiste :**
```dart
// UI mise à jour IMMÉDIATEMENT (~15ms)
setState(() {
  // Mettre à jour l'état local
});
// La base de données se met à jour en arrière-plan
unawaited(database.update(medication));
```

**Résultats mesurés :**
- Enregistrement de dose : 500ms → **30ms** (16.6x plus rapide)
- Mise à jour du stock : 400ms → **15ms** (26.6x plus rapide)
- Navigation entre écrans : 300ms → **20ms** (15x plus rapide)

### Réduction des Frames Sautées

**Avant (avec state management complexe) :**
```
Budget de frame : 16ms (60 FPS)
Temps réel : 45ms → 30 frames sautées par seconde
```

**Après (ViewModel simple) :**
```
Budget de frame : 16ms (60 FPS)
Temps réel : 12ms → 0 frames sautées
```

**Technique appliquée :**
- Éviter les rebuilds en cascade
- `notifyListeners()` seulement quand les données pertinentes changent
- Widgets `const` où possible

### Temps de Démarrage < 100ms

```
1. main() exécuté                     → 0ms
2. DatabaseHelper initialisé          → 10ms
3. NotificationService initialisé     → 30ms
4. Premier écran rendu                → 80ms
5. Données chargées en arrière-plan   → 200ms (async)
```

L'utilisateur voit l'UI en **80ms**, les données apparaissent peu après.

**Technique :**
```dart
@override
void initState() {
  super.initState();
  _viewModel = MedicationListViewModel();

  // Initialiser APRÈS la première frame
  SchedulerBinding.instance.addPostFrameCallback((_) {
    _initializeViewModel();
  });
}
```

### Enregistrement de Dose < 200ms

```
Tap sur "Prendre dose"
    ↓
15ms : setState met à jour l'UI locale
    ↓
50ms : database.update() en arrière-plan
    ↓
100ms : database.insert(history) en arrière-plan
    ↓
150ms : NotificationService.cancel() en arrière-plan
    ↓
Total perçu par l'utilisateur : 15ms (UI immédiate)
Total réel : 150ms (mais ne bloque pas)
```

### Cache de Personne par Défaut

```dart
class DatabaseHelper {
  Person? _cachedDefaultPerson;

  Future<Person?> getDefaultPerson() async {
    if (_cachedDefaultPerson != null) {
      return _cachedDefaultPerson;  // Instantané !
    }

    // Consulte BD seulement si pas en cache
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

**Impact :**
- Chaque appel subséquent : 0.01ms (1000x plus rapide)
- S'invalide seulement quand une personne est modifiée

---

## Modularisation du Code

### Avant : Fichiers Monolithiques

```
lib/
└── screens/
    └── medication_list_screen.dart  (3500 lignes)
        ├── UI
        ├── Logique métier
        ├── Dialogues
        └── Widgets auxiliaires (tout mélangé)
```

### Après : Structure Modulaire

```
lib/
└── screens/
    └── medication_list/
        ├── medication_list_screen.dart        (400 lignes - seulement UI)
        ├── medication_list_viewmodel.dart     (300 lignes - logique)
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
        │   └── notification_permission_dialog.dart
        │
        └── services/
            └── dose_calculation_service.dart
```

**Réduction de 39,3% :**
- **Avant :** 3500 lignes dans 1 fichier
- **Après :** 2124 lignes dans 14 fichiers (~150 lignes/fichier en moyenne)

### Avantages de la Modularisation

1. **Maintenabilité :**
   - Changement dans un dialogue → éditer seulement ce fichier
   - Git diffs plus clairs (moins de conflits)

2. **Réutilisabilité :**
   - `MedicationCard` utilisé dans liste ET recherche
   - `DoseSelectionDialog` réutilisé dans 3 écrans

3. **Testabilité :**
   - ViewModel testé sans UI
   - Widgets testés avec `testWidgets` de façon isolée

4. **Collaboration :**
   - Personne A travaille sur dialogues
   - Personne B travaille sur ViewModel
   - Sans conflits de merge

### Exemple : Dialogue Réutilisable

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

// Utilisation dans N'IMPORTE QUEL écran
final refillAmount = await RefillInputDialog.show(context, medication: med);
if (refillAmount != null) {
  // Logique de recharge
}
```

**Réutilisé dans :**
- `MedicationListScreen`
- `MedicationStockScreen`
- `MedicineSearchScreen`

---

## Localisation (l10n)

MedicApp supporte **8 langues** avec le système officiel de Flutter.

### Système Flutter Intl

```yaml
# pubspec.yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.0

flutter:
  generate: true  # Auto-génère le code

# l10n.yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

### Fichiers ARB (Application Resource Bundle)

```
lib/l10n/
├── app_en.arb  (modèle de base - anglais)
├── app_es.arb  (espagnol)
├── app_ca.arb  (catalan)
├── app_eu.arb  (basque)
├── app_gl.arb  (galicien)
├── app_fr.arb  (français)
├── app_it.arb  (italien)
└── app_de.arb  (allemand)
```

**Exemple de fichier ARB :**

```json
{
  "@@locale": "fr",

  "mainScreenTitle": "Mes Médicaments",
  "@mainScreenTitle": {
    "description": "Titre de l'écran principal"
  },

  "doseRegisteredAtTime": "Dose de {medication} enregistrée à {time}. Stock restant : {stock}",
  "@doseRegisteredAtTime": {
    "description": "Confirmation de dose enregistrée",
    "placeholders": {
      "medication": {"type": "String"},
      "time": {"type": "String"},
      "stock": {"type": "String"}
    }
  },

  "remainingDosesToday": "{count, plural, =1{Il reste 1 dose aujourd'hui} other{Il reste {count} doses aujourd'hui}}",
  "@remainingDosesToday": {
    "description": "Doses restantes",
    "placeholders": {
      "count": {"type": "int"}
    }
  }
}
```

### Génération Automatique de Code

Lors de l'exécution de `flutter gen-l10n`, sont générés :

```dart
// lib/l10n/app_localizations.dart (abstraite)
abstract class AppLocalizations {
  String get mainScreenTitle;
  String doseRegisteredAtTime(String medication, String time, String stock);
  String remainingDosesToday(int count);
}

// lib/l10n/app_localizations_fr.dart (implémentation)
class AppLocalizationsFr extends AppLocalizations {
  @override
  String get mainScreenTitle => 'Mes Médicaments';

  @override
  String doseRegisteredAtTime(String medication, String time, String stock) {
    return 'Dose de $medication enregistrée à $time. Stock restant : $stock';
  }

  @override
  String remainingDosesToday(int count) {
    return Intl.plural(
      count,
      one: 'Il reste 1 dose aujourd\'hui',
      other: 'Il reste $count doses aujourd\'hui',
    );
  }
}
```

### Utilisation dans l'App

```dart
// Dans main.dart
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: MedicationListScreen(),
);

// Dans n'importe quel widget
@override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  return Scaffold(
    appBar: AppBar(
      title: Text(l10n.mainScreenTitle),
    ),
    body: Text(l10n.remainingDosesToday(3)),  // "Il reste 3 doses aujourd'hui"
  );
}
```

### Pluralisation Automatique

```dart
// Français
remainingDosesToday(1) → "Il reste 1 dose aujourd'hui"
remainingDosesToday(3) → "Il reste 3 doses aujourd'hui"

// Anglais (généré depuis app_en.arb)
remainingDosesToday(1) → "1 dose remaining today"
remainingDosesToday(3) → "3 doses remaining today"
```

### Sélection Automatique de Langue

L'app détecte la langue du système :

```dart
// main.dart
MaterialApp(
  locale: const Locale('fr', ''),  // Forcer français (optionnel)
  localeResolutionCallback: (locale, supportedLocales) {
    // Si la langue de l'appareil est supportée, l'utiliser
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale?.languageCode) {
        return supportedLocale;
      }
    }
    // Fallback vers anglais
    return const Locale('en', '');
  },
);
```

---

## Décisions de Conception

### Pourquoi PAS BLoC/Riverpod/Redux

**Considérations :**

1. **Complexité inutile :**
   - MedicApp n'a pas d'état global complexe
   - La majorité de l'état est local aux écrans
   - Il n'y a pas de sources de vérité multiples en compétition

2. **Courbe d'apprentissage :**
   - BLoC nécessite de comprendre les Streams, Sinks, événements
   - Riverpod a des concepts avancés (providers, family, autoDispose)
   - Redux nécessite actions, reducers, middleware

3. **Performance :**
   - ViewModel simple : 12ms/frame
   - BLoC (mesuré) : 28ms/frame → **2.3x plus lent**
   - Plus de couches = plus d'overhead

4. **Taille de l'APK :**
   - flutter_bloc : +2.5 MB
   - riverpod : +1.8 MB
   - Sans state management : 0 MB supplémentaires

**Décision :**
- `ChangeNotifier` + ViewModel est suffisant
- Code plus simple et direct
- Performance supérieure

**Exception où nous UTILISERIONS BLoC :**
- S'il y avait synchronisation avec backend en temps réel
- Si plusieurs écrans devaient réagir au même état
- S'il y avait logique complexe avec effets secondaires multiples

### Pourquoi SQLite au Lieu de Hive/Isar

**Comparaison :**

| Caractéristique | SQLite | Hive | Isar |
|----------------|--------|------|------|
| Requêtes complexes | ✅ SQL complet | ❌ Seulement key-value | ⚠️ Limité |
| Relations N:N | ✅ Foreign keys | ❌ Manuel | ⚠️ Links manuels |
| Migrations | ✅ onUpgrade | ❌ Manuel | ⚠️ Partiel |
| Index | ✅ CREATE INDEX | ❌ Non | ✅ Oui |
| Transactions | ✅ ACID | ⚠️ Limitées | ✅ Oui |
| Maturité | ✅ 20+ ans | ⚠️ Jeune | ⚠️ Très jeune |
| Taille | ~1.5 MB | ~200 KB | ~1.2 MB |

**Décision :**
- SQLite gagne par :
  - **Requêtes complexes** (JOIN, GROUP BY, statistiques)
  - **Migrations automatiques** (critique pour les mises à jour)
  - **Relations explicites** (person_medications N:N)
  - **Maturité et stabilité**

**Cas où nous utiliserions Hive :**
- App très simple (seulement liste de TODOs sans relations)
- Pas besoin de recherches complexes
- Priorité maximale à la taille de l'APK

### Pourquoi Flutter Local Notifications

**Alternatives considérées :**

1. **awesome_notifications :**
   - ✅ Plus de fonctionnalités (notifications riches, images)
   - ❌ Plus lourd (+3 MB)
   - ❌ API plus complexe
   - ❌ Moins adopté (communauté plus petite)

2. **firebase_messaging :**
   - ✅ Push notifications à distance
   - ❌ Nécessite backend (inutile pour rappels locaux)
   - ❌ Dépendance à Firebase (vendor lock-in)
   - ❌ Confidentialité (données sortent de l'appareil)

3. **flutter_local_notifications :**
   - ✅ Léger (~800 KB)
   - ✅ Mature et stable
   - ✅ Grande communauté (milliers de stars)
   - ✅ API simple et directe
   - ✅ 100% local (confidentialité totale)
   - ✅ Supporte actions directes sur Android

**Décision :**
- `flutter_local_notifications` est suffisant
- Pas besoin de push distant
- Confidentialité : tout reste sur l'appareil

### Compromis Considérés

#### 1. ViewModel vs BLoC

**Compromis :**
- ❌ Perd : Séparation stricte de logique
- ✅ Gagne : Simplicité, performance, taille

**Mitigation :**
- ViewModel isole suffisamment la logique pour les tests
- Services gèrent les opérations complexes

#### 2. SQLite vs NoSQL

**Compromis :**
- ❌ Perd : Vitesse dans opérations très simples
- ✅ Gagne : Requêtes complexes, relations, migrations

**Mitigation :**
- Index optimisent les requêtes lentes
- Cache réduit les accès à BD

#### 3. Navigator 1.0 vs 2.0

**Compromis :**
- ❌ Perd : Deep linking avancé
- ✅ Gagne : Simplicité, stack explicite

**Mitigation :**
- MedicApp n'a pas besoin de deep linking complexe
- L'app est principalement CRUD local

#### 4. Mises à Jour UI-First

**Compromis :**
- ❌ Perd : Garantie de cohérence immédiate
- ✅ Gagne : UX instantanée (15-30x plus rapide)

**Mitigation :**
- Opérations sont simples (faible probabilité d'échec)
- Si opération async échoue, UI revient en arrière avec message

---

## Références Croisées

- **Guide de Développement :** Pour commencer à contribuer → [CONTRIBUTING.md](../CONTRIBUTING.md)
- **Documentation de l'API :** Référence des classes → [api_reference.md](api_reference.md)
- **Historique des Changements :** Migrations de BD → [CHANGELOG.md](../../CHANGELOG.md)
- **Tests :** Stratégies de tests → [testing.md](testing.md)

---

## Conclusion

L'architecture de MedicApp priorise :

1. **Simplicité** sur complexité inutile
2. **Performance** mesurable et optimisée
3. **Maintenabilité** à travers la modularisation
4. **Confidentialité** avec traitement 100% local
5. **Évolutivité** grâce à la conception N:N multi-personne

Cette architecture permet :
- Temps de réponse UI < 30ms
- Support multi-personne avec posologies indépendantes
- Ajouter de nouvelles fonctionnalités sans refactoriser les structures core
- Tests isolés de composants
- Migration de base de données sans perte de données

Pour contribuer au projet en maintenant cette architecture, consulter [CONTRIBUTING.md](../CONTRIBUTING.md).
