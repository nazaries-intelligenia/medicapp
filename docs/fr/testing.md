# Guide de Tests - MedicApp

## Table des Matières

1. [Vue d'Ensemble des Tests](#vue-densemble-des-tests)
2. [Structure des Tests](#structure-des-tests)
3. [Tests Unitaires](#tests-unitaires)
4. [Tests de Widgets](#tests-de-widgets)
5. [Tests d'Intégration](#tests-dintégration)
6. [Helpers de Tests](#helpers-de-tests)
7. [Couverture des Tests](#couverture-des-tests)
8. [Cas Limites Couverts](#cas-limites-couverts)
9. [Exécuter les Tests](#exécuter-les-tests)
10. [Guide pour Écrire des Tests](#guide-pour-écrire-des-tests)
11. [Tests de Base de Données](#tests-de-base-de-données)
12. [CI/CD et Tests Automatisés](#cicd-et-tests-automatisés)
13. [Prochaines Étapes](#prochaines-étapes)

---

## Vue d'Ensemble des Tests

MedicApp dispose d'une suite de tests robuste et bien structurée qui garantit la qualité et la stabilité du code :

- **369+ tests automatisés** répartis dans 50 fichiers
- **75-80% de couverture de code** dans les zones critiques
- **Multiples types de tests** : unitaires, widgets et intégration
- **Test-Driven Development (TDD)** pour les nouvelles fonctionnalités

### Philosophie de Tests

Notre stratégie de tests repose sur :

1. **Les tests comme documentation** : Les tests documentent le comportement attendu du système
2. **Couverture intelligente** : Focus sur les zones critiques (notifications, jeûne, gestion des doses)
3. **Feedback rapide** : Tests rapides qui s'exécutent en mémoire
4. **Isolation** : Chaque test est indépendant et n'affecte pas les autres
5. **Réalisme** : Tests d'intégration qui simulent des flux utilisateur réels

### Types de Tests

```
test/
├── unitarios/          # Tests de services, modèles et logique métier
├── widgets/            # Tests de composants et écrans individuels
└── integration/        # Tests end-to-end de flux complets
```

---

## Structure des Tests

Le répertoire de tests est organisé de manière claire et logique :

```
test/
├── helpers/                              # Utilitaires partagés entre tests
│   ├── medication_builder.dart           # Builder pattern pour créer des médicaments
│   ├── database_test_helper.dart         # Setup et nettoyage de base de données
│   ├── widget_test_helpers.dart          # Helpers pour tests de widgets
│   ├── person_test_helper.dart           # Helpers pour gestion des personnes
│   ├── notification_test_helper.dart     # Helpers pour tests de notifications
│   ├── test_constants.dart               # Constantes partagées
│   └── test_helpers.dart                 # Helpers généraux
│
├── integration/                          # Tests d'intégration (9 fichiers)
│   ├── add_medication_test.dart          # Flux complet d'ajout de médicament
│   ├── edit_medication_test.dart         # Flux d'édition
│   ├── delete_medication_test.dart       # Flux de suppression
│   ├── dose_registration_test.dart       # Enregistrement de dose
│   ├── stock_management_test.dart        # Gestion du stock
│   ├── medication_modal_test.dart        # Modal de détails
│   ├── navigation_test.dart              # Navigation entre écrans
│   ├── app_startup_test.dart             # Démarrage de l'application
│   └── debug_menu_test.dart              # Menu de débogage
│
└── [41 fichiers de tests unitaires/widgets]
```

### Fichiers de Tests par Catégorie

#### Tests de Services (13 fichiers)
- `notification_service_test.dart` - Service de notifications
- `dose_action_service_test.dart` - Actions sur les doses
- `dose_history_service_test.dart` - Historique des doses
- `preferences_service_test.dart` - Préférences utilisateur
- Et plus...

#### Tests de Fonctionnalité Core (18 fichiers)
- `medication_model_test.dart` - Modèle de médicament
- `dose_management_test.dart` - Gestion des doses
- `extra_dose_test.dart` - Dose supplémentaire
- `database_refill_test.dart` - Recharges de stock
- `database_export_import_test.dart` - Exportation/importation
- Et plus...

#### Tests de Jeûne (6 fichiers)
- `fasting_test.dart` - Logique de jeûne
- `fasting_notification_test.dart` - Notifications de jeûne
- `fasting_countdown_test.dart` - Compte à rebours de jeûne
- `fasting_field_preservation_test.dart` - Préservation des champs
- `early_dose_with_fasting_test.dart` - Dose anticipée avec jeûne
- `multiple_fasting_prioritization_test.dart` - Priorisation multiple

#### Tests d'Écrans (14 fichiers)
- `edit_schedule_screen_test.dart` - Écran d'édition des horaires
- `edit_duration_screen_test.dart` - Écran d'édition de durée
- `edit_fasting_screen_test.dart` - Écran d'édition de jeûne
- `edit_screens_validation_test.dart` - Validations
- `settings_screen_test.dart` - Écran de configuration
- `day_navigation_ui_test.dart` - Navigation par jours
- Et plus...

---

## Tests Unitaires

Les tests unitaires vérifient le comportement de composants individuels de manière isolée.

### Tests de Services

Vérifient la logique métier des services :

#### NotificationService

```dart
test('should generate unique IDs for different medications', () {
  final id1 = _generateNotificationId('med1', 0);
  final id2 = _generateNotificationId('med2', 0);

  expect(id1, isNot(equals(id2)));
});

test('should handle all notification operations in test mode', () async {
  service.enableTestMode();

  final medication = MedicationBuilder()
      .withId('test-med')
      .withSingleDose('08:00', 1.0)
      .build();

  await service.scheduleMedicationNotifications(
    medication,
    personId: 'test-person-id'
  );

  // Ne doit pas lever d'exceptions
});
```

#### DoseActionService

```dart
test('should register dose and update stock', () async {
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

### Tests de Modèles

Vérifient la sérialisation et désérialisation des données :

```dart
group('Medication Model - Fasting Configuration', () {
  test('should serialize fasting configuration to JSON', () {
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

  test('should deserialize fasting from JSON', () {
    final json = {
      'id': 'test_8',
      'name': 'Test Medication',
      'requiresFasting': 1,
      'fastingType': 'before',
      'fastingDurationMinutes': 60,
      // ... autres champs
    };

    final medication = Medication.fromJson(json);

    expect(medication.requiresFasting, true);
    expect(medication.fastingType, 'before');
    expect(medication.fastingDurationMinutes, 60);
  });
});
```

### Tests d'Utilitaires

Vérifient les fonctions auxiliaires et calculs :

```dart
test('should calculate days until stock runs out', () {
  final medication = MedicationBuilder()
      .withStock(20.0)
      .withMultipleDoses(['08:00', '16:00'], 1.0) // 2 doses/jour
      .build();

  final days = calculateStockDuration(medication);

  expect(days, 10); // 20 unités / 2 par jour = 10 jours
});
```

---

## Tests de Widgets

Les tests de widgets vérifient l'interface utilisateur et l'interaction utilisateur.

### Tests d'Écrans

Vérifient que les écrans s'affichent correctement et répondent aux interactions :

```dart
testWidgets('Should add medication with default type', (tester) async {
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  await addMedicationWithDuration(tester, 'Paracetamol');
  await waitForDatabase(tester);

  expect(find.text('Paracetamol'), findsOneWidget);
  expect(find.text('Pastilla'), findsAtLeastNWidgets(1));
});
```

### Tests de Composants

Vérifient les composants individuels de l'UI :

```dart
testWidgets('Should display fasting countdown', (tester) async {
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

### Mocking des Dépendances

Pour les tests de widgets, nous utilisons des mocks pour isoler les composants :

```dart
setUp(() async {
  // Mock SharedPreferences
  SharedPreferences.setMockInitialValues({});

  // Base de données en mémoire
  DatabaseHelper.setInMemoryDatabase(true);

  // Mode de test pour notifications
  NotificationService.instance.enableTestMode();

  // Assurer personne par défaut
  await DatabaseTestHelper.ensureDefaultPerson();
});
```

### Exemple Complet : Test d'Édition

```dart
testWidgets('Should edit medication schedule', (tester) async {
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  // Ajouter médicament
  await addMedicationWithDuration(tester, 'Ibuprofeno');
  await waitForDatabase(tester);

  // Ouvrir menu d'édition
  await openEditMenuAndSelectSection(
    tester,
    'Ibuprofeno',
    'Horarios y Cantidades',
  );

  // Modifier horaires
  final timeField = find.byType(TextFormField).first;
  await tester.enterText(timeField, '10:00');

  // Enregistrer
  await scrollToWidget(tester, find.text('Guardar'));
  await tester.tap(find.text('Guardar'));
  await waitForDatabase(tester);

  // Vérifier changement
  expect(find.text('10:00'), findsOneWidget);
});
```

---

## Tests d'Intégration

Les tests d'intégration vérifient des flux utilisateur complets end-to-end.

### Tests End-to-End

Simulent le comportement réel de l'utilisateur :

```dart
testWidgets('Complete flow: Add medication and register dose',
    (tester) async {
  // 1. Démarrer app
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  // 2. Ajouter médicament
  await addMedicationWithDuration(
    tester,
    'Paracetamol',
    stockQuantity: '20',
  );
  await waitForDatabase(tester);

  // 3. Vérifier qu'il apparaît dans la liste
  expect(find.text('Paracetamol'), findsOneWidget);

  // 4. Ouvrir modal de détails
  await tester.tap(find.text('Paracetamol'));
  await tester.pumpAndSettle();

  // 5. Enregistrer dose
  await tester.tap(find.text('Tomar dosis'));
  await waitForComplexAsyncOperation(tester);

  // 6. Vérifier stock mis à jour
  await tester.tap(find.text('Paracetamol'));
  await tester.pumpAndSettle();

  expect(find.textContaining('19'), findsOneWidget); // Stock - 1
});
```

### Flux Complets

Les tests d'intégration couvrent des flux importants :

1. **Ajouter médicament** : `add_medication_test.dart`
   - Navigation complète du wizard
   - Configuration de tous les paramètres
   - Vérification dans la liste principale

2. **Éditer médicament** : `edit_medication_test.dart`
   - Modification de chaque section
   - Préservation des données non modifiées
   - Mise à jour correcte dans la liste

3. **Supprimer médicament** : `delete_medication_test.dart`
   - Confirmation de suppression
   - Nettoyage des notifications
   - Suppression de l'historique associé

4. **Enregistrer dose** : `dose_registration_test.dart`
   - Enregistrement manuel depuis la modal
   - Mise à jour du stock
   - Création d'entrée dans l'historique

5. **Gestion du stock** : `stock_management_test.dart`
   - Alertes de stock bas
   - Recharge de stock
   - Calcul de durée

### Interaction avec Base de Données

Les tests d'intégration interagissent avec une base de données réelle en mémoire :

```dart
testWidgets('Should persist medication after app restart',
    (tester) async {
  // Première instance de l'app
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  await addMedicationWithDuration(tester, 'Aspirina');
  await waitForDatabase(tester);

  // Simuler fermeture et réouverture
  await DatabaseHelper.instance.close();
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  // Le médicament doit être toujours présent
  expect(find.text('Aspirina'), findsOneWidget);
});
```

---

## Helpers de Tests

Les helpers simplifient l'écriture de tests et réduisent le code dupliqué.

### MedicationBuilder

Le **pattern builder** permet de créer des médicaments de test de manière lisible :

```dart
/// Exemple basique
final medication = MedicationBuilder()
    .withId('test_1')
    .withName('Aspirina')
    .withStock(20.0)
    .build();

/// Avec jeûne
final medication = MedicationBuilder()
    .withName('Ibuprofeno')
    .withFasting(type: 'after', duration: 120)
    .withSingleDose('08:00', 1.0)
    .build();

/// Avec plusieurs doses
final medication = MedicationBuilder()
    .withName('Antibiótico')
    .withMultipleDoses(['08:00', '14:00', '20:00'], 1.0)
    .withStock(30.0)
    .build();

/// Comme médicament "à la demande"
final medication = MedicationBuilder()
    .withName('Analgésico')
    .withAsNeeded()
    .withStock(10.0)
    .build();
```

#### Avantages de MedicationBuilder

1. **Lisibilité** : Le code est auto-documenté et facile à comprendre
2. **Maintenabilité** : Les modifications du modèle nécessitent seulement de mettre à jour le builder
3. **Réduction de code** : Évite de répéter les valeurs par défaut dans chaque test
4. **Flexibilité** : Permet de configurer uniquement ce qui est nécessaire pour chaque test

#### Factory Methods

Le builder inclut des méthodes factory pour les cas courants :

```dart
// Stock bas (5 unités)
final medication = MedicationBuilder()
    .withName('Med')
    .withLowStock()
    .build();

// Sans stock
final medication = MedicationBuilder()
    .withName('Med')
    .withNoStock()
    .build();

// Plusieurs doses par jour (automatique)
final medication = MedicationBuilder()
    .withName('Med')
    .withMultipleDosesPerDay(3) // 08:00, 12:00, 16:00
    .build();

// Jeûne activé avec valeurs par défaut
final medication = MedicationBuilder()
    .withName('Med')
    .withFastingEnabled() // before, 60 min
    .build();
```

#### Constructor from Medication

Permet de créer un builder à partir d'un médicament existant :

```dart
final original = await db.getMedication('med-id');

final modified = MedicationBuilder.from(original)
    .withStock(50.0)
    .withName('Nombre Modificado')
    .build();
```

### DatabaseTestHelper

Simplifie la configuration et le nettoyage de la base de données :

```dart
class DatabaseTestHelper {
  /// Configuration initiale (une fois par fichier)
  static void setupAll() {
    setUpAll(() {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      DatabaseHelper.setInMemoryDatabase(true);
    });
  }

  /// Nettoyage après chaque test
  static void setupEach() {
    tearDown(() async {
      await cleanDatabase();
    });
  }

  /// Raccourci : setupAll + setupEach
  static void setup() {
    setupAll();
    setupEach();
  }

  /// Assure qu'il existe une personne par défaut
  static Future<void> ensureDefaultPerson() async {
    final hasDefault = await DatabaseHelper.instance.hasDefaultPerson();

    if (!hasDefault) {
      final person = Person(
        id: const Uuid().v4(),
        name: 'Test User',
        isDefault: true,
      );
      await DatabaseHelper.instance.insertPerson(person);
    }
  }
}
```

**Utilisation dans les tests :**

```dart
void main() {
  DatabaseTestHelper.setup(); // Configuration complète

  setUp(() async {
    await DatabaseTestHelper.ensureDefaultPerson();
  });

  test('my test', () async {
    // Votre test ici
  });
}
```

### WidgetTestHelpers

Fonctions auxiliaires pour tests de widgets :

```dart
/// Obtenir localisations
AppLocalizations getL10n(WidgetTester tester);

/// Attendre opérations de base de données
Future<void> waitForDatabase(WidgetTester tester);

/// Attendre qu'un widget apparaisse
Future<void> waitForWidget(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
});

/// Faire défiler vers un widget
Future<void> scrollToWidget(WidgetTester tester, Finder finder);

/// Ouvrir menu d'édition
Future<void> openEditMenuAndSelectSection(
  WidgetTester tester,
  String medicationName,
  String sectionTitle,
);

/// Ajouter médicament complet
Future<void> addMedicationWithDuration(
  WidgetTester tester,
  String name, {
  String? type,
  String? durationType,
  int dosageIntervalHours = 8,
  String stockQuantity = '0',
});

/// Attendre opérations asynchrones complexes
Future<void> waitForComplexAsyncOperation(
  WidgetTester tester, {
  Duration asyncDelay = const Duration(milliseconds: 1000),
  int pumpCount = 20,
});
```

### Autres Helpers

- **PersonTestHelper** : Gestion des personnes dans les tests
- **NotificationTestHelper** : Helpers pour les notifications
- **TestConstants** : Constantes partagées (doses, stocks, temps)

---

## Couverture des Tests

La suite de tests couvre les zones les plus critiques de l'application.

### Couverture par Catégorie

| Catégorie | Tests | Description |
|-----------|-------|-------------|
| **Services** | ~94 tests | NotificationService, DoseActionService, DoseHistoryService, PreferencesService |
| **Fonctionnalité Core** | ~79 tests | Gestion des doses, stock, jeûne, exportation/importation |
| **Jeûne** | ~61 tests | Logique de jeûne, notifications, compte à rebours, priorisation |
| **Écrans** | ~93 tests | Tests de widgets et navigation de tous les écrans |
| **Intégration** | ~52 tests | Flux complets end-to-end |

**Total : 369+ tests**

### Zones Bien Couvertes

#### Notifications (95% de couverture)
- Programmation et annulation de notifications
- IDs uniques pour différents types de notifications
- Notifications pour motifs hebdomadaires et dates spécifiques
- Notifications de jeûne
- Actions rapides depuis les notifications
- Limites de plateforme (500 notifications)
- Cas limites de minuit

#### Jeûne (90% de couverture)
- Calcul des périodes de jeûne (before/after)
- Validations de durée
- Notifications de début et fin
- Compte à rebours visuel
- Priorisation avec plusieurs périodes actives
- Doses anticipées avec jeûne
- Préservation de configuration

#### Gestion des Doses (88% de couverture)
- Enregistrement de dose (manuel et depuis notification)
- Omission de dose
- Dose supplémentaire
- Mise à jour du stock
- Historique des doses
- Calcul de consommation journalière

#### Base de Données (85% de couverture)
- CRUD de médicaments
- CRUD de personnes
- Migration de schéma
- Exportation/importation
- Intégrité référentielle
- Nettoyage en cascade

### Zones avec Moins de Couverture

Certaines zones ont une couverture moindre mais non critique :

- **UI/UX avancée** (60%) : Animations, transitions
- **Configuration** (65%) : Préférences utilisateur
- **Localisation** (70%) : Traductions et langues
- **Permissions** (55%) : Demande de permissions système

Ces zones ont une couverture moindre parce que :
1. Elles sont difficiles à tester automatiquement
2. Elles nécessitent une interaction manuelle
3. Elles dépendent du système d'exploitation
4. Elles n'affectent pas la logique métier critique

---

## Cas Limites Couverts

Les tests incluent des cas spéciaux qui pourraient causer des erreurs :

### 1. Notifications à Minuit

**Fichier** : `notification_midnight_edge_cases_test.dart`

```dart
test('dose scheduled at 23:55 but registered at 00:05 counts for previous day',
    () async {
  // Dose programmée hier à 23:55
  final scheduledTime = DateTime(2024, 1, 15, 23, 55);

  // Enregistrée aujourd'hui à 00:05
  final registeredTime = DateTime(2024, 1, 16, 0, 5);

  // Doit compter comme dose du jour précédent
  expect(getDoseDate(scheduledTime), '2024-01-15');
});

test('fasting period crossing midnight is handled correctly', () async {
  // Dose à 22:00 avec jeûne "after" de 3 heures
  final medication = MedicationBuilder()
      .withSingleDose('22:00', 1.0)
      .withFasting(type: 'after', duration: 180)
      .build();

  // Le jeûne se termine à 01:00 du jour suivant
  final endTime = calculateFastingEnd(medication, '22:00');
  expect(endTime.hour, 1);
  expect(endTime.day, DateTime.now().add(Duration(days: 1)).day);
});
```

**Cas couverts :**
- Doses tardives enregistrées après minuit
- Périodes de jeûne qui traversent minuit
- Doses programmées exactement à 00:00
- Réinitialisation des compteurs journaliers
- Notifications reportées qui traversent minuit

### 2. Suppression et Nettoyage

**Fichier** : `deletion_cleanup_test.dart`

```dart
test('deleting a medication cancels all its notifications', () async {
  final medication = MedicationBuilder()
      .withId('med-to-delete')
      .withSingleDose('08:00', 1.0)
      .build();

  await db.insertMedication(medication);
  await notificationService.schedule(medication);

  // Supprimer
  await db.deleteMedication(medication.id);
  await notificationService.cancelAll(medication.id);

  // Il ne doit pas y avoir de notifications programmées
  final pending = await notificationService.getPending();
  expect(pending.where((n) => n.id.contains('med-to-delete')), isEmpty);
});

test('deleting a person deletes all their medications and history', () async {
  final person = await createTestPerson('John');
  final med = await addMedicationForPerson(person.id, 'Aspirin');

  await registerDose(med.id, '08:00');

  // Supprimer personne
  await db.deletePerson(person.id);

  // Il ne doit pas y avoir de médicaments ni d'historique
  final meds = await db.getMedicationsForPerson(person.id);
  expect(meds, isEmpty);

  final history = await db.getDoseHistory(person.id);
  expect(history, isEmpty);
});
```

**Cas couverts :**
- Annulation des notifications lors de la suppression d'un médicament
- Suppression en cascade de l'historique
- Nettoyage des notifications lors de la suppression d'une personne
- Ne pas affecter les autres médicaments/personnes
- Intégrité référentielle

### 3. Priorisation de Plusieurs Jeûnes

**Fichier** : `multiple_fasting_prioritization_test.dart`

```dart
test('should keep most restrictive fasting when 2 active for same person',
    () async {
  // Médicament 1 : jeûne "after" de 120 minutes
  final med1 = MedicationBuilder()
      .withId('med-1')
      .withSingleDose('08:00', 1.0)
      .withFasting(type: 'after', duration: 120)
      .build();

  // Médicament 2 : jeûne "after" de 60 minutes
  final med2 = MedicationBuilder()
      .withId('med-2')
      .withSingleDose('08:30', 1.0)
      .withFasting(type: 'after', duration: 60)
      .build();

  // Enregistrer les deux doses
  await registerDose(med1.id, '08:00');
  await registerDose(med2.id, '08:30');

  // Seul le jeûne le plus restrictif doit être affiché (med-1 jusqu'à 10:00)
  final activeFasting = await fastingManager.getActiveFasting();
  expect(activeFasting.length, 1);
  expect(activeFasting.first.medicationId, 'med-1');
});
```

**Cas couverts :**
- Plusieurs jeûnes actifs pour une personne
- Sélection de la période la plus restrictive
- Tri par temps de fin
- Filtrage automatique des périodes terminées
- Indépendance entre différentes personnes

### 4. Actions de Notification

**Fichier** : `notification_actions_test.dart`

```dart
test('register_dose action should reduce stock and create history', () async {
  final medication = MedicationBuilder()
      .withStock(20.0)
      .withSingleDose('08:00', 2.0)
      .build();

  await insertMedication(medication);

  // Simuler action "register_dose" depuis notification
  await handleNotificationAction(
    action: 'register_dose',
    medicationId: medication.id,
    doseTime: '08:00',
  );

  // Vérifier effets
  final updated = await db.getMedication(medication.id);
  expect(updated.stockQuantity, 18.0); // 20 - 2
  expect(updated.takenDosesToday, contains('08:00'));

  final history = await db.getDoseHistory(medication.id);
  expect(history.last.status, 'taken');
});

test('snooze_dose action should postpone notification by 10 minutes',
    () async {
  final notification = await scheduleNotification(
    medicationId: 'med-1',
    time: TimeOfDay(hour: 8, minute: 0),
  );

  // Reporter
  await handleNotificationAction(
    action: 'snooze_dose',
    medicationId: 'med-1',
    notificationId: notification.id,
  );

  // Vérifier nouvelle programmation
  final rescheduled = await getNextNotification('med-1');
  expect(rescheduled.time.hour, 8);
  expect(rescheduled.time.minute, 10);
});
```

**Cas couverts :**
- Enregistrement depuis notification
- Omission depuis notification
- Reporter 10 minutes
- Mise à jour correcte du stock et de l'historique
- Annulation de la notification originale

### 5. Limites de Notifications

**Fichier** : `notification_limits_test.dart`

```dart
test('should handle approaching platform limit (>400 notifications)',
    () async {
  // Créer 100 médicaments avec 4 doses chacun
  for (int i = 0; i < 100; i++) {
    final med = MedicationBuilder()
        .withId('med-$i')
        .withMultipleDoses(['08:00', '12:00', '16:00', '20:00'], 1.0)
        .withWeeklyPattern([1, 2, 3, 4, 5, 6, 7])
        .build();

    await insertMedication(med);
  }

  // Programmer notifications (potentiellement >500)
  await notificationService.scheduleAll();

  // Ne doit pas crasher
  // Doit prioriser les notifications proches
  final pending = await notificationService.getPending();
  expect(pending.length, lessThanOrEqualTo(500));
});
```

**Cas couverts :**
- Gérer plus de 500 notifications
- Prioriser les notifications proches
- Logging d'avertissements
- Ne pas faire crasher l'app
- Reprogrammation automatique

---

## Exécuter les Tests

### Commandes Basiques

```bash
# Exécuter tous les tests
flutter test

# Test spécifique
flutter test test/services/notification_service_test.dart

# Tests dans un répertoire
flutter test test/integration/

# Tests avec nom spécifique
flutter test --name "fasting"

# Tests en mode verbose
flutter test --verbose

# Tests avec rapport de temps
flutter test --reporter expanded
```

### Tests avec Couverture

```bash
# Exécuter tests avec couverture
flutter test --coverage

# Générer rapport HTML
genhtml coverage/lcov.info -o coverage/html

# Ouvrir rapport dans le navigateur
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
start coverage/html/index.html  # Windows
```

### Exécuter Tests Spécifiques

```bash
# Seulement tests de services
flutter test test/*_service_test.dart

# Seulement tests d'intégration
flutter test test/integration/

# Seulement tests de jeûne
flutter test test/fasting*.dart

# Exclure tests lents
flutter test --exclude-tags=slow
```

### Tests en CI/CD

```bash
# Mode CI (sans couleur, format adapté pour logs)
flutter test --machine --coverage

# Avec timeout pour tests lents
flutter test --timeout=30s

# Échec rapide (arrêter à la première erreur)
flutter test --fail-fast
```

### Débogage de Tests

```bash
# Exécuter un seul test en mode debug
flutter test --plain-name "specific test name"

# Avec breakpoints (VS Code/Android Studio)
# Utiliser "Debug Test" depuis l'IDE

# Avec prints visibles
flutter test --verbose

# Sauvegarder output dans fichier
flutter test > test_output.txt 2>&1
```

---

## Guide pour Écrire des Tests

### Structure AAA (Arrange-Act-Assert)

Organisez chaque test en trois sections claires :

```dart
test('should register dose and update stock', () async {
  // ARRANGE : Préparer l'environnement
  final medication = MedicationBuilder()
      .withStock(20.0)
      .withSingleDose('08:00', 2.0)
      .build();
  await db.insertMedication(medication);

  // ACT : Exécuter l'action à tester
  await doseService.registerDose(medication.id, '08:00');

  // ASSERT : Vérifier le résultat
  final updated = await db.getMedication(medication.id);
  expect(updated.stockQuantity, 18.0);
  expect(updated.takenDosesToday, contains('08:00'));
});
```

### Conventions de Nommage

Utilisez des noms descriptifs qui expliquent le scénario :

```dart
// ✅ BON : Décrit le scénario complet
test('should cancel notifications when medication is deleted', () {});
test('should show error when stock is insufficient', () {});
test('dose registered after midnight counts for previous day', () {});

// ❌ MAUVAIS : Noms vagues ou techniques
test('test1', () {});
test('notification test', () {});
test('deletion', () {});
```

**Format recommandé :**
- `should [action attendue] when [condition]`
- `[action] [résultat attendu] [contexte optionnel]`

### Setup et Teardown

Configurez et nettoyez l'environnement de manière cohérente :

```dart
void main() {
  // Configuration initiale une seule fois
  DatabaseTestHelper.setupAll();

  late NotificationService service;
  late DatabaseHelper db;

  // Avant chaque test
  setUp(() async {
    service = NotificationService.instance;
    service.enableTestMode();
    db = DatabaseHelper.instance;
    await DatabaseTestHelper.ensureDefaultPerson();
  });

  // Après chaque test
  tearDown(() async {
    service.disableTestMode();
    await DatabaseTestHelper.cleanDatabase();
  });

  // Vos tests ici
  test('...', () async {
    // Test isolé avec environnement propre
  });
}
```

### Mocking de DatabaseHelper

Pour les tests unitaires purs, mockez la base de données :

```dart
class MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  late MockDatabaseHelper mockDb;
  late DoseActionService service;

  setUp(() {
    mockDb = MockDatabaseHelper();
    service = DoseActionService(database: mockDb);
  });

  test('should call database method with correct parameters', () async {
    final medication = MedicationBuilder().build();

    // Configurer mock
    when(mockDb.updateMedication(any))
        .thenAnswer((_) async => 1);

    // Exécuter action
    await service.registerDose(medication.id, '08:00');

    // Vérifier appel
    verify(mockDb.updateMedication(argThat(
      predicate<Medication>((m) =>
        m.id == medication.id &&
        m.takenDosesToday.contains('08:00')
      )
    ))).called(1);
  });
}
```

### Utilisation de MedicationBuilder

Profitez du builder pour créer des tests lisibles :

```dart
test('should calculate correct stock duration', () {
  // Créer médicament avec builder
  final medication = MedicationBuilder()
      .withName('Paracetamol')
      .withStock(30.0)
      .withMultipleDosesPerDay(3) // 3 doses par jour
      .build();

  final duration = calculateStockDays(medication);

  expect(duration, 10); // 30 / 3 = 10 jours
});

test('should alert when stock is low', () {
  final medication = MedicationBuilder()
      .withLowStock() // Factory method pour stock bas
      .withLowStockThreshold(3)
      .build();

  expect(isStockLow(medication), true);
});
```

### Meilleures Pratiques

1. **Tests indépendants** : Chaque test doit pouvoir s'exécuter seul
   ```dart
   // ✅ BON : Test auto-contenu
   test('...', () async {
     final medication = createTestMedication();
     await db.insert(medication);
     // ... reste du test
   });

   // ❌ MAUVAIS : Dépend de l'ordre d'exécution
   late Medication sharedMedication;
   test('create medication', () {
     sharedMedication = createTestMedication();
   });
   test('use medication', () {
     expect(sharedMedication, isNotNull); // Dépend du test précédent
   });
   ```

2. **Tests rapides** : Utilisez base de données en mémoire, évitez les delays inutiles
   ```dart
   // ✅ BON
   DatabaseHelper.setInMemoryDatabase(true);

   // ❌ MAUVAIS
   await Future.delayed(Duration(seconds: 2)); // Delay arbitraire
   ```

3. **Assertions spécifiques** : Vérifiez exactement ce qui importe
   ```dart
   // ✅ BON
   expect(medication.stockQuantity, 18.0);
   expect(medication.takenDosesToday, contains('08:00'));

   // ❌ MAUVAIS
   expect(medication, isNotNull); // Trop vague
   ```

4. **Groupes logiques** : Organisez les tests liés
   ```dart
   group('Dose Registration', () {
     test('should register dose successfully', () {});
     test('should update stock when registering', () {});
     test('should create history entry', () {});
   });

   group('Dose Validation', () {
     test('should reject invalid time format', () {});
     test('should reject negative quantity', () {});
   });
   ```

5. **Tester les cas limites** : Pas seulement le happy path
   ```dart
   group('Stock Management', () {
     test('should register dose with sufficient stock', () {});

     test('should register dose even with 0 stock', () {});

     test('should handle decimal quantities correctly', () {});

     test('should not go below 0 stock', () {});
   });
   ```

6. **Commentaires utiles** : Expliquez le "pourquoi", pas le "quoi"
   ```dart
   test('should count late dose for previous day', () async {
     // V19+ : Doses enregistrées après minuit mais dans les
     // 2 heures de la programmation comptent pour le jour précédent
     // Cela évite que les doses tardives dupliquent le comptage journalier

     final scheduledTime = DateTime(..., 23, 55);
     final registeredTime = DateTime(..., 0, 5);
     // ...
   });
   ```

---

## Tests de Base de Données

### Utilisation de sqflite_common_ffi

Les tests utilisent `sqflite_common_ffi` pour base de données en mémoire :

```dart
void main() {
  setUpAll(() {
    // Initialiser FFI
    sqfliteFfiInit();

    // Utiliser factory FFI
    databaseFactory = databaseFactoryFfi;

    // Activer mode en mémoire
    DatabaseHelper.setInMemoryDatabase(true);
  });

  test('database operations', () async {
    // Base de données créée automatiquement en mémoire
    final db = DatabaseHelper.instance;

    // Opérations normales
    await db.insertMedication(medication);
    final result = await db.getMedication(medication.id);

    expect(result, isNotNull);
  });
}
```

### Base de Données en Mémoire

Avantages d'utiliser base de données en mémoire :

1. **Vitesse** : 10-100x plus rapide que disque
2. **Isolation** : Chaque test commence avec BD propre
3. **Sans effets secondaires** : Ne modifie pas les données réelles
4. **Parallélisation** : Les tests peuvent s'exécuter en parallèle

```dart
setUp(() async {
  // Réinitialiser pour BD propre
  await DatabaseHelper.resetDatabase();

  // Mode en mémoire
  DatabaseHelper.setInMemoryDatabase(true);
});
```

### Migrations dans les Tests

Les tests vérifient que les migrations fonctionnent correctement :

```dart
test('should migrate from v18 to v19 (persons table)', () async {
  // Créer BD en version 18
  final db = await openDatabase(
    inMemoryDatabasePath,
    version: 18,
    onCreate: (db, version) async {
      // Schema v18 (sans table persons)
      await db.execute('''
        CREATE TABLE medications (...)
      ''');
    },
  );

  await db.close();

  // Ouvrir en version 19 (déclenche migration)
  final migratedDb = await DatabaseHelper.instance.database;

  // Vérifier que persons existe
  final tables = await migratedDb.rawQuery(
    "SELECT name FROM sqlite_master WHERE type='table' AND name='persons'"
  );

  expect(tables, isNotEmpty);

  // Vérifier personne par défaut
  final hasDefault = await DatabaseHelper.instance.hasDefaultPerson();
  expect(hasDefault, true);
});
```

### Nettoyage entre Tests

Il est crucial de nettoyer la BD entre tests pour éviter la contamination :

```dart
tearDown(() async {
  // Méthode 1 : Supprimer toutes les données
  await DatabaseHelper.instance.deleteAllMedications();
  await DatabaseHelper.instance.deleteAllDoseHistory();
  await DatabaseHelper.instance.deleteAllPersons();

  // Méthode 2 : Réinitialiser complètement
  await DatabaseHelper.resetDatabase();

  // Méthode 3 : Utiliser helper
  await DatabaseTestHelper.cleanDatabase();
});
```

### Tests d'Intégrité Référentielle

Vérifier que les relations de BD fonctionnent correctement :

```dart
test('deleting person should cascade delete medications', () async {
  final person = Person(id: 'p1', name: 'John');
  await db.insertPerson(person);

  final med = MedicationBuilder()
      .withId('m1')
      .build();
  await db.insertMedicationForPerson(med, person.id);

  // Supprimer personne
  await db.deletePerson(person.id);

  // Les médicaments doivent avoir été supprimés
  final meds = await db.getMedicationsForPerson(person.id);
  expect(meds, isEmpty);
});

test('dose_history references valid medication', () async {
  // Essayer d'insérer historique pour médicament inexistant
  final entry = DoseHistoryEntry(
    id: 'h1',
    medicationId: 'non-existent',
    personId: 'p1',
    scheduledTime: '08:00',
    status: 'taken',
  );

  // Doit échouer par contrainte foreign key
  expect(
    () => db.insertDoseHistory(entry),
    throwsA(isA<DatabaseException>()),
  );
});
```

---

## CI/CD et Tests Automatisés

### Intégration Continue

Configuration typique pour GitHub Actions :

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

    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.24.0'
        channel: 'stable'

    - name: Install dependencies
      run: flutter pub get

    - name: Run tests
      run: flutter test --coverage --machine

    - name: Check coverage
      run: |
        COVERAGE=$(lcov --summary coverage/lcov.info | grep lines | awk '{print $2}' | sed 's/%//')
        if (( $(echo "$COVERAGE < 70" | bc -l) )); then
          echo "Coverage $COVERAGE% is below 70%"
          exit 1
        fi

    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v2
      with:
        file: ./coverage/lcov.info
```

### Pre-commit Hooks

Utiliser `husky` ou scripts Git hooks pour exécuter tests avant commit :

```bash
# .git/hooks/pre-commit
#!/bin/sh

echo "Running tests..."
flutter test

if [ $? -ne 0 ]; then
  echo "Tests failed. Commit aborted."
  exit 1
fi

echo "All tests passed!"
```

### Seuil Minimum de Couverture

Configurer seuil minimum pour éviter les régressions :

```bash
# scripts/check_coverage.sh
#!/bin/bash

flutter test --coverage

# Vérifier couverture minimum
MIN_COVERAGE=70
ACTUAL_COVERAGE=$(lcov --summary coverage/lcov.info | grep lines | awk '{print $2}' | sed 's/%//')

if (( $(echo "$ACTUAL_COVERAGE < $MIN_COVERAGE" | bc -l) )); then
  echo "❌ Coverage $ACTUAL_COVERAGE% is below minimum $MIN_COVERAGE%"
  exit 1
else
  echo "✅ Coverage $ACTUAL_COVERAGE% meets minimum $MIN_COVERAGE%"
fi
```

### Rapports de Couverture

Générer rapports visuels automatiquement :

```bash
# Générer rapport
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Badge de couverture
./scripts/generate_coverage_badge.sh

# Publier rapport
# (utiliser GitHub Pages, Codecov, Coveralls, etc.)
```

---

## Prochaines Étapes

### Zones à Améliorer

1. **Tests de UI/UX (60% → 80%)**
   - Plus de tests d'animations
   - Tests de gestes et swipes
   - Tests d'accessibilité

2. **Tests de Permissions (55% → 75%)**
   - Mock de permissions du système
   - Flux de demande de permissions
   - Gestion des permissions refusées

3. **Tests de Localisation (70% → 90%)**
   - Tests pour chaque langue
   - Vérification de traductions complètes
   - Tests de formatage de dates/nombres

4. **Tests de Performance**
   - Benchmarks d'opérations critiques
   - Tests de charge (nombreux médicaments)
   - Détection de fuites mémoire

### Tests En Attente

#### Haute Priorité

- [ ] Tests de backup/restore complet
- [ ] Tests de notifications en background
- [ ] Tests de widget de home screen
- [ ] Tests de deep links
- [ ] Tests de partage de données

#### Priorité Moyenne

- [ ] Tests de toutes les langues
- [ ] Tests de thèmes (clair/sombre)
- [ ] Tests d'onboarding
- [ ] Tests de migrations entre toutes versions
- [ ] Tests d'exportation vers CSV/PDF

#### Basse Priorité

- [ ] Tests d'animations complexes
- [ ] Tests de gestes avancés
- [ ] Tests d'accessibilité exhaustifs
- [ ] Tests de performance sur appareils lents

### Roadmap de Tests

#### Q1 2025
- Atteindre 80% de couverture générale
- Compléter tests de permissions
- Ajouter tests de performance basiques

#### Q2 2025
- Tests de toutes les langues
- Tests de backup/restore
- Documentation de tests mise à jour

#### Q3 2025
- Tests d'accessibilité complets
- Tests de charge et stress
- Automatisation complète en CI/CD

#### Q4 2025
- 85%+ couverture générale
- Suite de tests de performance
- Tests de régression visuelle

---

## Ressources Additionnelles

### Documentation

- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [Mockito Documentation](https://pub.dev/packages/mockito)

### Outils

- **flutter_test** : Framework de tests de Flutter
- **mockito** : Mocking de dépendances
- **sqflite_common_ffi** : BD en mémoire pour tests
- **test_coverage** : Analyse de couverture
- **lcov** : Génération de rapports HTML

### Fichiers Liés

- `/test/helpers/` - Tous les helpers de tests
- `/test/integration/` - Tests d'intégration
- `/.github/workflows/test.yml` - Configuration CI/CD
- `/scripts/run_tests.sh` - Scripts de tests

---

**Dernière mise à jour** : Novembre 2025
**Version de MedicApp** : V19+
**Tests totaux** : 369+
**Couverture moyenne** : 75-80%
