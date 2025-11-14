# Structure du Projet MedicApp

Ce document décrit l'organisation des dossiers et fichiers du projet MedicApp, une application Flutter pour la gestion des médicaments et rappels.

## Arborescence des Répertoires

### Structure de `lib/`

```
lib/
├── main.dart
├── database/
│   └── database_helper.dart
├── models/
│   ├── person.dart
│   ├── medication.dart
│   ├── person_medication.dart
│   ├── dose_history_entry.dart
│   ├── medication_type.dart
│   └── treatment_duration_type.dart
├── screens/
│   ├── main_screen.dart
│   ├── medication_list_screen.dart
│   ├── medicine_cabinet_screen.dart
│   ├── dose_history_screen.dart
│   ├── settings_screen.dart
│   ├── medication_info_screen.dart
│   ├── medication_frequency_screen.dart
│   ├── medication_dosage_screen.dart
│   ├── medication_times_screen.dart
│   ├── medication_dates_screen.dart
│   ├── medication_duration_screen.dart
│   ├── medication_fasting_screen.dart
│   ├── medication_quantity_screen.dart
│   ├── medication_inventory_screen.dart
│   ├── medication_stock_screen.dart
│   ├── weekly_days_selector_screen.dart
│   ├── specific_dates_selector_screen.dart
│   ├── dose_action_screen.dart
│   ├── edit_medication_menu_screen.dart
│   ├── debug_notifications_screen.dart
│   ├── medication_list/
│   │   ├── medication_cache_manager.dart
│   │   ├── dialogs/
│   │   │   ├── dose_selection_dialog.dart
│   │   │   ├── extra_dose_confirmation_dialog.dart
│   │   │   ├── medication_options_sheet.dart
│   │   │   ├── notification_permission_dialog.dart
│   │   │   ├── debug_info_dialog.dart
│   │   │   └── edit_today_dose_dialog.dart
│   │   ├── services/
│   │   │   └── dose_calculation_service.dart
│   │   └── widgets/
│   │       ├── battery_optimization_banner.dart
│   │       ├── empty_medications_view.dart
│   │       ├── today_doses_section.dart
│   │       └── debug_menu.dart
│   ├── medicine_cabinet/
│   │   ├── medication_person_assignment_screen.dart
│   │   ├── dialogs/
│   │   └── widgets/
│   │       ├── medication_card.dart
│   │       ├── medication_options_modal.dart
│   │       ├── empty_cabinet_view.dart
│   │       └── no_search_results_view.dart
│   ├── dose_history/
│   │   ├── dialogs/
│   │   │   ├── delete_confirmation_dialog.dart
│   │   │   └── edit_entry_dialog.dart
│   │   └── widgets/
│   │       ├── dose_history_card.dart
│   │       ├── active_filters_chip.dart
│   │       ├── empty_history_view.dart
│   │       ├── filter_dialog.dart
│   │       ├── stat_card.dart
│   │       └── statistics_card.dart
│   ├── dose_action/
│   │   └── widgets/
│   │       ├── postpone_buttons.dart
│   │       ├── skip_dose_button.dart
│   │       └── take_dose_button.dart
│   ├── edit_medication_menu/
│   │   └── widgets/
│   │       └── edit_menu_option.dart
│   ├── edit_sections/
│   │   ├── edit_basic_info_screen.dart
│   │   ├── edit_frequency_screen.dart
│   │   ├── edit_schedule_screen.dart
│   │   ├── edit_duration_screen.dart
│   │   ├── edit_fasting_screen.dart
│   │   ├── edit_quantity_screen.dart
│   │   ├── edit_frequency/
│   │   │   └── widgets/
│   │   │       ├── frequency_options_list.dart
│   │   │       ├── custom_interval_config_card.dart
│   │   │       ├── specific_dates_config_card.dart
│   │   │       └── weekly_pattern_config_card.dart
│   │   ├── edit_duration/
│   │   │   └── widgets/
│   │   │       ├── duration_type_info_card.dart
│   │   │       └── treatment_dates_card.dart
│   │   └── edit_quantity/
│   │       └── widgets/
│   ├── medication_dates/
│   │   └── widgets/
│   │       ├── clear_date_button.dart
│   │       ├── date_selector_card.dart
│   │       ├── dates_help_info.dart
│   │       └── duration_summary.dart
│   ├── medication_dosage/
│   │   └── widgets/
│   │       ├── custom_doses_input_card.dart
│   │       ├── dosage_mode_option_card.dart
│   │       ├── dose_summary_info.dart
│   │       └── interval_input_card.dart
│   ├── medication_duration/
│   │   └── widgets/
│   │       ├── duration_option_card.dart
│   │       └── specific_dates_selector_card.dart
│   ├── medication_frequency/
│   │   └── widgets/
│   │       └── weekly_days_selector_card.dart
│   ├── medication_quantity/
│   │   └── widgets/
│   │       └── medication_summary_card.dart
│   ├── medication_stock/
│   │   └── widgets/
│   │       ├── empty_stock_view.dart
│   │       ├── medication_stock_card.dart
│   │       └── stock_summary_card.dart
│   ├── persons/
│   │   ├── add_edit_person_screen.dart
│   │   └── persons_management_screen.dart
│   ├── settings/
│   │   └── widgets/
│   │       ├── info_card.dart
│   │       ├── setting_option_card.dart
│   │       └── setting_switch_card.dart
│   ├── specific_dates_selector/
│   │   └── widgets/
│   │       ├── date_list_tile.dart
│   │       ├── instructions_card.dart
│   │       └── selected_dates_list_card.dart
│   └── weekly_days_selector/
│       └── widgets/
│           ├── day_selection_tile.dart
│           └── selection_count_info.dart
├── services/
│   ├── notification_service.dart
│   ├── dose_action_service.dart
│   ├── dose_history_service.dart
│   ├── preferences_service.dart
│   ├── notification_id_generator.dart
│   └── notifications/
│       ├── notification_config.dart
│       ├── notification_cancellation_manager.dart
│       ├── daily_notification_scheduler.dart
│       ├── weekly_notification_scheduler.dart
│       └── fasting_notification_scheduler.dart
├── widgets/
│   ├── action_buttons.dart
│   ├── medication_header_card.dart
│   └── forms/
│       ├── medication_info_form.dart
│       ├── frequency_option_card.dart
│       └── fasting_configuration_form.dart
├── utils/
│   ├── datetime_extensions.dart
│   ├── medication_sorter.dart
│   ├── number_utils.dart
│   └── platform_helper.dart
└── l10n/
    ├── app_es.arb
    ├── app_en.arb
    ├── app_ca.arb
    ├── app_eu.arb
    ├── app_gl.arb
    ├── app_fr.arb
    ├── app_de.arb
    ├── app_it.arb
    ├── app_localizations.dart (généré)
    └── app_localizations_*.dart (générés)
```

### Structure de `test/`

```
test/
├── helpers/
│   ├── test_helpers.dart
│   ├── database_test_helper.dart
│   ├── medication_builder.dart
│   ├── person_test_helper.dart
│   ├── notification_test_helper.dart
│   ├── widget_test_helpers.dart
│   └── test_constants.dart
├── integration/
│   ├── add_medication_test.dart
│   ├── app_startup_test.dart
│   ├── debug_menu_test.dart
│   ├── delete_medication_test.dart
│   ├── dose_registration_test.dart
│   ├── edit_medication_test.dart
│   ├── medication_modal_test.dart
│   ├── navigation_test.dart
│   └── stock_management_test.dart
├── as_needed_main_screen_display_test.dart
├── as_needed_stock_test.dart
├── database_export_import_test.dart
├── database_refill_test.dart
├── day_navigation_test.dart
├── day_navigation_ui_test.dart
├── deletion_cleanup_test.dart
├── dose_action_service_test.dart
├── dose_history_service_test.dart
├── dose_management_test.dart
├── early_dose_notification_test.dart
├── early_dose_with_fasting_test.dart
├── edit_duration_screen_test.dart
├── edit_fasting_screen_test.dart
├── edit_schedule_screen_test.dart
├── edit_screens_validation_test.dart
├── extra_dose_test.dart
├── fasting_countdown_test.dart
├── fasting_field_preservation_test.dart
├── fasting_notification_test.dart
├── fasting_test.dart
├── medication_model_test.dart
├── medication_sorting_test.dart
├── multiple_fasting_prioritization_test.dart
├── notification_actions_test.dart
├── notification_cancellation_test.dart
├── notification_limits_test.dart
├── notification_midnight_edge_cases_test.dart
├── notification_multi_person_test.dart
├── notification_person_title_test.dart
├── notification_service_test.dart
├── notification_sync_test.dart
├── preferences_service_test.dart
└── settings_screen_test.dart
```

### Fichiers Racine Importants

```
medicapp/
├── pubspec.yaml              # Dépendances et configuration du projet
├── l10n.yaml                 # Configuration de localisation
├── analysis_options.yaml     # Règles de linting
├── android/
│   └── app/
│       └── build.gradle      # Configuration Android
└── ios/
    └── Runner/
        └── Info.plist        # Configuration iOS
```

## Répertoire `lib/`

### `lib/main.dart`

Point d'entrée de l'application. Responsabilités :

- Initialiser le service de notifications
- Demander les permissions de notifications
- Créer la personne par défaut ("Moi") si elle n'existe pas
- Configurer MaterialApp avec :
  - Thèmes clair et sombre accessibles (polices plus grandes)
  - Support de localisation (8 langues)
  - GlobalKey pour navigation depuis notifications
  - Routes de navigation
- Re-programmer les notifications en arrière-plan au démarrage

### `lib/database/`

#### `database_helper.dart`

Singleton qui gère toute la persistance des données avec SQLite. Responsabilités :

- Créer et mettre à jour le schéma de base de données
- CRUD pour personnes (Person)
- CRUD pour médicaments (Medication)
- CRUD pour assignations personne-médicament (PersonMedication)
- CRUD pour historique de doses (DoseHistoryEntry)
- Requêtes complexes pour obtenir médicaments actifs par personne
- Exporter et importer base de données (backup/restore)
- Support pour base de données en mémoire (testing)

### `lib/models/`

Modèles de données représentant les entités du domaine :

#### `person.dart`

Représente une personne qui prend des médicaments :

- `id` : UUID unique
- `name` : Nom de la personne
- `isDefault` : Indique si c'est la personne par défaut ("Moi")
- Conversion JSON et Map pour SQLite

#### `medication.dart`

Représente un médicament dans l'armoire à pharmacie :

- Informations de base : nom, type, notes
- Quantité et stock
- Fréquence : quotidienne, hebdomadaire, intervalle personnalisé, dates spécifiques, si nécessaire
- Horaires de prise
- Durée du traitement : continu, date de fin, nombre de doses
- Configuration de jeûne (optionnel)
- Méthodes pour calculer prochaines doses
- Validations de complétude

#### `person_medication.dart`

Relie médicaments avec personnes :

- `personId` : Référence à Person
- `medicationId` : Référence à Medication
- `isActive` : Si actif pour la personne
- Utilisé pour assigner médicaments de l'armoire à pharmacie à personnes spécifiques

#### `dose_history_entry.dart`

Enregistrement d'une dose prise, omise ou reportée :

- `medicationId` : Médicament associé
- `personId` : Personne qui a pris/omis la dose
- `scheduledTime` : Heure programmée originalement
- `actualTime` : Heure réelle d'enregistrement
- `status` : taken, skipped, postponed
- `wasEarly` : Si prise avant l'heure
- `isExtraDose` : Si dose extra non programmée
- `notes` : Notes optionnelles

#### `medication_type.dart`

Énumération de types de médicament :

- Comprimé, Capsule, Sirop, Injection
- Inhalateur, Crème, Patch
- Pansement, Goutte, Autre

#### `treatment_duration_type.dart`

Énumération de types de durée de traitement :

- `continuous` : Sans date de fin
- `untilDate` : Jusqu'à une date spécifique
- `numberOfDoses` : Nombre limité de doses

### `lib/screens/`

Écrans de l'application organisés par fonctionnalité.

#### Écrans Principaux

- **`main_screen.dart`** : Navigation principale avec BottomNavigationBar
- **`medication_list_screen.dart`** : Liste des médicaments actifs de la personne, doses du jour
- **`medicine_cabinet_screen.dart`** : Armoire à pharmacie partagée avec tous les médicaments
- **`dose_history_screen.dart`** : Historique de doses avec filtres et statistiques
- **`settings_screen.dart`** : Configuration, exporter/importer BD, gestion de personnes

#### Flux d'Ajout de Médicament (Assistant)

Navigation séquentielle pour créer un médicament :

1. **`medication_info_screen.dart`** : Nom, type, notes
2. **`medication_frequency_screen.dart`** : Fréquence (quotidienne, hebdomadaire, intervalle, dates)
3. **`medication_dosage_screen.dart`** : Dose par prise ou intervalle entre doses
4. **`medication_times_screen.dart`** : Horaires de prise
5. **`medication_dates_screen.dart`** : Date de début (et fin optionnelle)
6. **`medication_duration_screen.dart`** : Type de durée du traitement
7. **`medication_fasting_screen.dart`** : Configuration de jeûne (optionnel)
8. **`medication_quantity_screen.dart`** : Quantité par prise
9. **`medication_inventory_screen.dart`** : Stock initial et seuil d'alerte

#### Écrans d'Édition

Situés dans `edit_sections/` :

- **`edit_basic_info_screen.dart`** : Éditer nom, type, notes
- **`edit_frequency_screen.dart`** : Modifier fréquence
- **`edit_schedule_screen.dart`** : Changer horaires
- **`edit_duration_screen.dart`** : Ajuster durée du traitement
- **`edit_fasting_screen.dart`** : Configurer jeûne
- **`edit_quantity_screen.dart`** : Modifier quantité

Chaque section a son propre dossier avec widgets spécifiques.

#### Écrans de Support

- **`weekly_days_selector_screen.dart`** : Sélecteur de jours de la semaine
- **`specific_dates_selector_screen.dart`** : Sélecteur de dates spécifiques
- **`dose_action_screen.dart`** : Enregistrer dose (prendre, omettre, reporter)
- **`edit_medication_menu_screen.dart`** : Menu pour éditer médicament
- **`medication_stock_screen.dart`** : Gestion de stock de médicaments
- **`debug_notifications_screen.dart`** : Écran de debug pour notifications (développement)

#### Écrans de Personnes

Situés dans `persons/` :

- **`persons_management_screen.dart`** : Liste et gestion de personnes
- **`add_edit_person_screen.dart`** : Créer ou éditer personne

#### Écrans de l'Armoire à Pharmacie

Situés dans `medicine_cabinet/` :

- **`medication_person_assignment_screen.dart`** : Assigner médicament à personnes

#### Organisation par Modules

Chaque écran complexe a son propre dossier avec :

- **`dialogs/`** : Dialogues spécifiques de l'écran
- **`widgets/`** : Widgets réutilisables dans l'écran
- **`services/`** : Logique métier spécifique (ex : dose_calculation_service)

### `lib/services/`

Services qui encapsulent la logique métier et opérations complexes.

#### `notification_service.dart`

Service principal de notifications. Responsabilités :

- Initialiser flutter_local_notifications
- Demander permissions de notifications
- Programmer/annuler notifications de médicaments
- Gérer notifications de jeûne (ongoing)
- Gérer notifications par personne
- Répondre aux actions de notification (prendre, omettre)
- Limiter notifications à 500 (maximum Android)

#### `dose_action_service.dart`

Gère les actions sur doses :

- Enregistrer dose prise
- Omettre dose
- Reporter dose
- Enregistrer dose extra
- Mettre à jour stock automatiquement
- Re-programmer notifications après action

#### `dose_history_service.dart`

Opérations sur l'historique de doses :

- Obtenir historique filtré par date, médicament, personne
- Calculer statistiques (adhérence, doses prises/omises)
- Éditer entrées d'historique
- Supprimer entrées

#### `preferences_service.dart`

Gère préférences utilisateur avec SharedPreferences :

- ID de personne active
- Configuration de notifications
- Préférences d'UI
- Dernière date d'utilisation

#### `notification_id_generator.dart`

Génère IDs uniques pour notifications basés sur :

- ID de médicament
- Timestamp de la dose
- Évite collisions entre médicaments

#### `services/notifications/`

Sous-dossier avec modules spécifiques de notifications :

- **`notification_config.dart`** : Configuration de canaux et sons
- **`notification_cancellation_manager.dart`** : Annulation intelligente de notifications
- **`daily_notification_scheduler.dart`** : Programmer notifications quotidiennes
- **`weekly_notification_scheduler.dart`** : Programmer notifications hebdomadaires
- **`fasting_notification_scheduler.dart`** : Programmer notifications de jeûne

### `lib/widgets/`

Widgets réutilisables dans toute l'application :

#### `action_buttons.dart`

Boutons communs d'action (prendre, omettre, reporter dose).

#### `medication_header_card.dart`

Carte d'en-tête avec informations du médicament.

#### `widgets/forms/`

Formulaires réutilisables :

- **`medication_info_form.dart`** : Formulaire d'informations de base
- **`frequency_option_card.dart`** : Carte d'option de fréquence
- **`fasting_configuration_form.dart`** : Formulaire de configuration de jeûne

### `lib/utils/`

Utilitaires et extensions :

#### `datetime_extensions.dart`

Extensions pour DateTime :

- Comparer dates en ignorant l'heure
- Formater dates
- Calculer jours entre dates
- Opérations de début/fin de jour

#### `medication_sorter.dart`

Algorithmes de tri de médicaments :

- Par prochaine dose
- Par nom
- Par type
- Par urgence de stock

#### `number_utils.dart`

Utilitaires pour nombres :

- Formater quantités
- Valider plages
- Conversions

#### `platform_helper.dart`

Helpers spécifiques à la plateforme :

- Détecter Android/iOS
- Ouvrir configuration du système
- Demander permissions spécifiques à la plateforme

### `lib/l10n/`

Système de localisation (i18n) de l'application.

#### Fichiers ARB (Application Resource Bundle)

Fichiers de traduction en format JSON :

- **`app_es.arb`** : Espagnol (modèle de base)
- **`app_en.arb`** : Anglais
- **`app_ca.arb`** : Catalan
- **`app_eu.arb`** : Basque
- **`app_gl.arb`** : Galicien
- **`app_fr.arb`** : Français
- **`app_de.arb`** : Allemand
- **`app_it.arb`** : Italien

Chaque fichier contient :

- Clés de traduction
- Valeurs traduites
- Métadonnées de placeholders
- Descriptions pour traducteurs

#### Fichiers Générés

Générés automatiquement par `flutter gen-l10n` :

- **`app_localizations.dart`** : Classe de base de localisation
- **`app_localizations_es.dart`**, **`app_localizations_en.dart`**, etc. : Implémentations par langue

Usage dans l'app :

```dart
AppLocalizations.of(context).medicationName
```

## Répertoire `test/`

Tests unitaires et d'intégration pour garantir la qualité du code.

### `test/helpers/`

Utilitaires partagés pour testing :

#### `test_helpers.dart`

Helpers généraux pour tests :

- Setup de base de données de test
- Mocks de services
- Fonctions d'initialisation

#### `database_test_helper.dart`

Helpers spécifiques pour tests de base de données :

- Créer base de données en mémoire
- Peupler avec données de test
- Nettoyer état entre tests

#### `medication_builder.dart`

Pattern Builder pour créer médicaments de test :

```dart
final medication = MedicationBuilder()
  .withName('Aspirine')
  .withDailyFrequency()
  .withTimes(['08:00', '20:00'])
  .build();
```

Simplifie la création de médicaments avec différentes configurations.

#### `person_test_helper.dart`

Helpers pour créer personnes de test :

- Créer personne par défaut
- Créer plusieurs personnes
- Gérer relations personne-médicament

#### `notification_test_helper.dart`

Mocks et helpers pour tests de notifications :

- Mock de NotificationService
- Vérifier notifications programmées
- Simuler actions de notification

#### `widget_test_helpers.dart`

Helpers pour widget tests :

- Créer widgets avec contexte complet
- Pump widgets avec localisation
- Finders personnalisés

#### `test_constants.dart`

Constantes partagées entre tests :

- IDs de test
- Dates et heures fixes
- Valeurs par défaut

### Tests Unitaires (racine de `test/`)

34 fichiers de tests unitaires organisés par fonctionnalité :

#### Tests de Base de Données

- `database_export_import_test.dart` : Exporter/importer BD
- `database_refill_test.dart` : Recharger stock

#### Tests de Modèles

- `medication_model_test.dart` : Validation de modèle Medication

#### Tests de Services

- `notification_service_test.dart` : Service de notifications
- `dose_action_service_test.dart` : Actions de dose
- `dose_history_service_test.dart` : Historique de doses
- `preferences_service_test.dart` : Préférences utilisateur

#### Tests de Notifications

- `notification_sync_test.dart` : Synchronisation de notifications
- `notification_cancellation_test.dart` : Annulation de notifications
- `notification_person_title_test.dart` : Titres avec nom de personne
- `notification_multi_person_test.dart` : Notifications multi-personne
- `notification_actions_test.dart` : Actions depuis notifications
- `notification_limits_test.dart` : Limite de 500 notifications
- `notification_midnight_edge_cases_test.dart` : Cas limites de minuit
- `early_dose_notification_test.dart` : Doses précoces
- `early_dose_with_fasting_test.dart` : Doses précoces avec jeûne

#### Tests de Jeûne

- `fasting_test.dart` : Logique de jeûne
- `fasting_notification_test.dart` : Notifications de jeûne
- `fasting_countdown_test.dart` : Compte à rebours de jeûne
- `fasting_field_preservation_test.dart` : Préservation de champs de jeûne

#### Tests de Doses

- `dose_management_test.dart` : Gestion de doses
- `extra_dose_test.dart` : Dose extra
- `deletion_cleanup_test.dart` : Nettoyage lors de suppression
- `multiple_fasting_prioritization_test.dart` : Priorisation avec plusieurs jeûnes

#### Tests de Stock

- `as_needed_stock_test.dart` : Stock pour médicaments si nécessaire

#### Tests d'UI

- `day_navigation_test.dart` : Navigation entre jours
- `day_navigation_ui_test.dart` : UI de navigation de jours
- `medication_sorting_test.dart` : Tri de médicaments
- `as_needed_main_screen_display_test.dart` : Affichage si nécessaire

#### Tests d'Écrans

- `settings_screen_test.dart` : Écran de configuration
- `edit_duration_screen_test.dart` : Éditer durée
- `edit_fasting_screen_test.dart` : Éditer jeûne
- `edit_schedule_screen_test.dart` : Éditer horaires
- `edit_screens_validation_test.dart` : Validations d'édition

### Tests d'Intégration (`test/integration/`)

9 fichiers de tests d'intégration qui testent flux complets :

- **`app_startup_test.dart`** : Démarrage d'application
- **`add_medication_test.dart`** : Flux complet d'ajout de médicament
- **`edit_medication_test.dart`** : Flux d'édition de médicament
- **`delete_medication_test.dart`** : Suppression de médicament
- **`medication_modal_test.dart`** : Modal d'options de médicament
- **`dose_registration_test.dart`** : Enregistrement de dose
- **`stock_management_test.dart`** : Gestion de stock
- **`navigation_test.dart`** : Navigation entre écrans
- **`debug_menu_test.dart`** : Menu de debug

### Schéma de Nommage des Tests

- **`*_test.dart`** : Tous les tests se terminent par `_test.dart`
- **`integration/*_test.dart`** : Tests d'intégration dans sous-dossier
- Noms descriptifs de la fonctionnalité testée
- Groupés par feature/module

## Fichiers de Configuration

### `pubspec.yaml`

Fichier principal de configuration de Flutter. Contient :

#### Dépendances Principales

- **`sqflite`** : Base de données SQLite
- **`flutter_local_notifications`** : Notifications locales
- **`timezone`** : Gestion de fuseaux horaires
- **`intl`** : Internationalisation et formatage de dates
- **`shared_preferences`** : Stockage clé-valeur
- **`file_picker`** : Sélection de fichiers
- **`share_plus`** : Partager fichiers
- **`path_provider`** : Accès aux répertoires du système
- **`uuid`** : Génération d'IDs uniques
- **`android_intent_plus`** : Intents Android

#### Assets

- Icônes de launcher (Android/iOS)
- Écran de démarrage
- Fichiers de localisation (automatiques)

#### Configuration

- SDK minimum : Dart ^3.9.2
- Version : 1.0.0+1

### `l10n.yaml`

Configuration du système de localisation :

```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
untranslated-messages-file: untranslated_messages.json
```

- **`arb-dir`** : Répertoire de fichiers ARB
- **`template-arb-file`** : Fichier modèle (espagnol)
- **`output-localization-file`** : Fichier généré
- **`untranslated-messages-file`** : Rapport de traductions manquantes

### `analysis_options.yaml`

Règles de linting et analyse statique :

- Ensemble de règles recommandées de Flutter
- Règles personnalisées supplémentaires
- Exclusions pour fichiers générés
- Configuration de sévérité des avertissements

### `android/app/build.gradle`

Configuration de compilation Android :

- `minSdkVersion` : 21 (Android 5.0)
- `targetSdkVersion` : 34 (Android 14)
- Permissions de notifications
- Configuration d'icônes adaptatives

### `ios/Runner/Info.plist`

Configuration iOS :

- Permissions de notifications
- Configuration de modes d'arrière-plan
- App Transport Security
- Icônes et écran de démarrage

## Résultats de Modularisation

La refactorisation du code a abouti à une réduction significative de lignes de code par fichier, améliorant la maintenabilité :

| Écran/Fichier | Lignes Avant | Lignes Après | Réduction |
|---------------|--------------|--------------|-----------|
| `medication_list_screen.dart` | 950 | 680 | -28.4% |
| `medicine_cabinet_screen.dart` | 850 | 212 | -75.1% |
| `dose_history_screen.dart` | 780 | 368 | -52.8% |
| `medication_list` (module) | 950 | 1450 | +52.6% (distribué dans 10 fichiers) |
| `medicine_cabinet` (module) | 850 | 875 | +2.9% (distribué dans 5 fichiers) |
| `dose_history` (module) | 780 | 920 | +17.9% (distribué dans 8 fichiers) |
| **Total** | **2580** | **1260** | **-39.3%** (fichiers principaux) |

### Avantages

- Fichiers plus petits et ciblés (< 400 lignes)
- Responsabilité unique par fichier
- Widgets réutilisables séparés
- Facilité pour trouver et modifier code
- Meilleure organisation par feature
- Tests plus spécifiques et isolés

## Schémas d'Organisation

### Séparation par Couches (Model-View-Service)

```
┌─────────────────────────────────────┐
│         Screens (View)              │
│  - UI et présentation               │
│  - StatefulWidget/StatelessWidget   │
└────────────┬────────────────────────┘
             │
             ↓
┌─────────────────────────────────────┐
│        Services (Business)          │
│  - Logique métier                   │
│  - Opérations complexes             │
└────────────┬────────────────────────┘
             │
             ↓
┌─────────────────────────────────────┐
│      Database & Models (Data)       │
│  - Persistance                      │
│  - Modèles de données               │
└─────────────────────────────────────┘
```

### Conventions de Noms

#### Fichiers

- **Écrans** : `*_screen.dart` (ex : `medication_list_screen.dart`)
- **Widgets** : `*_widget.dart` ou nom descriptif (ex : `medication_card.dart`)
- **Dialogues** : `*_dialog.dart` (ex : `dose_selection_dialog.dart`)
- **Services** : `*_service.dart` (ex : `notification_service.dart`)
- **Modèles** : nom singulier (ex : `person.dart`, `medication.dart`)
- **Helpers** : `*_helper.dart` (ex : `database_helper.dart`)
- **Tests** : `*_test.dart` (ex : `fasting_test.dart`)

#### Classes

- **Écrans** : `*Screen` (ex : `MedicationListScreen`)
- **Widgets** : nom descriptif (ex : `MedicationCard`, `DoseHistoryCard`)
- **Services** : `*Service` (ex : `NotificationService`)
- **Modèles** : nom singulier en PascalCase (ex : `Person`, `Medication`)

#### Variables

- **camelCase** pour variables et méthodes
- **UPPER_SNAKE_CASE** pour constantes
- **Noms descriptifs** qui reflètent l'objectif

### Emplacement de Widgets Réutilisables

#### Widgets Globaux (`lib/widgets/`)

Widgets utilisés dans plusieurs écrans :

- Composants UI génériques
- Formulaires partagés
- Boutons d'action communs

#### Widgets d'Écran (`lib/screens/*/widgets/`)

Widgets spécifiques à un écran :

- Composants UI uniques
- Widgets qui dépendent du contexte de l'écran
- Non réutilisés dans d'autres écrans

#### Dialogues (`lib/screens/*/dialogs/`)

Dialogues spécifiques à un écran :

- Modals de confirmation
- Feuilles d'options (bottom sheets)
- Dialogues de saisie de données

### Helpers et Utilitaires

#### `lib/utils/`

Fonctions pures et extensions :

- Sans état
- Sans dépendances externes
- Réutilisables dans toute l'app

#### `test/helpers/`

Utilitaires spécifiques au testing :

- Builders d'objets de test
- Mocks de services
- Setup d'environnement de test

## Assets et Ressources

### Icônes de Launcher

```
android/app/src/main/res/
├── mipmap-hdpi/ic_launcher.png
├── mipmap-mdpi/ic_launcher.png
├── mipmap-xhdpi/ic_launcher.png
├── mipmap-xxhdpi/ic_launcher.png
└── mipmap-xxxhdpi/ic_launcher.png

ios/Runner/Assets.xcassets/AppIcon.appiconset/
└── Icon-*.png (plusieurs résolutions)
```

### Écran de Démarrage

```
android/app/src/main/res/drawable/
└── launch_background.xml

ios/Runner/Assets.xcassets/LaunchImage.imageset/
└── LaunchImage*.png
```

### Fichiers de Configuration de Plateforme

#### Android

- `android/app/src/main/AndroidManifest.xml` : Permissions et configuration
- `android/app/build.gradle` : Compilation et dépendances
- `android/gradle.properties` : Properties de Gradle
- `android/local.properties` : Chemins locaux (non versionné)

#### iOS

- `ios/Runner/Info.plist` : Configuration de l'app
- `ios/Podfile` : Dépendances CocoaPods
- `ios/Runner.xcodeproj/` : Projet Xcode

## Statistiques du Projet

- **Total de fichiers Dart dans `lib/`** : 131
- **Total de fichiers de test** : 43 (34 unitaires + 9 intégration)
- **Lignes de code (approximatif)** : ~15,000 lignes
- **Couverture de tests** : Élevée (services critiques 100%)
- **Langues supportées** : 8 (ES, EN, CA, EU, GL, FR, DE, IT)
- **Modèles de données** : 6
- **Écrans principaux** : 20+
- **Services** : 5 principaux + 5 modules de notifications
- **Widgets réutilisables** : 50+

---

Ce document fournit une vue complète de la structure du projet MedicApp, facilitant la navigation et la compréhension du code pour les développeurs nouveaux et existants.
