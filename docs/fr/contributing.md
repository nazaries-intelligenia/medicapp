# Guide de Contribution

Merci de votre intérêt pour contribuer à **MedicApp**. Ce guide vous aidera à réaliser des contributions de qualité qui bénéficieront à toute la communauté.

---

## Table des Matières

- [Bienvenue](#bienvenue)
- [Comment Contribuer](#comment-contribuer)
- [Processus de Contribution](#processus-de-contribution)
- [Conventions de Code](#conventions-de-code)
- [Conventions de Commits](#conventions-de-commits)
- [Guide des Pull Requests](#guide-des-pull-requests)
- [Guide de Tests](#guide-de-tests)
- [Ajouter de Nouvelles Fonctionnalités](#ajouter-de-nouvelles-fonctionnalités)
- [Signaler des Bugs](#signaler-des-bugs)
- [Ajouter des Traductions](#ajouter-des-traductions)
- [Configuration de l'Environnement de Développement](#configuration-de-lenvironnement-de-développement)
- [Ressources Utiles](#ressources-utiles)
- [Questions Fréquentes](#questions-fréquentes)
- [Contact et Communauté](#contact-et-communauté)

---

## Bienvenue

Nous sommes ravis que vous souhaitiez contribuer à MedicApp. Ce projet est possible grâce à des personnes comme vous qui consacrent leur temps et leurs connaissances pour améliorer la santé et le bien-être des utilisateurs du monde entier.

### Types de Contributions Bienvenues

Nous apprécions tout type de contributions :

- **Code** : Nouvelles fonctionnalités, corrections de bugs, améliorations de performance
- **Documentation** : Améliorations de la documentation existante, nouveaux guides, tutoriels
- **Traductions** : Ajouter ou améliorer les traductions dans les 8 langues supportées
- **Tests** : Ajouter des tests, améliorer la couverture, signaler des bugs
- **Design** : Améliorations UI/UX, icônes, assets
- **Idées** : Suggestions d'améliorations, discussions sur l'architecture
- **Revue** : Réviser les PRs d'autres contributeurs

### Code de Conduite

Ce projet adhère à un code de conduite de respect mutuel :

- **Être respectueux** : Traitez tout le monde avec respect et considération
- **Être constructif** : Les critiques doivent être constructives et orientées vers l'amélioration
- **Être inclusif** : Favorisez un environnement accueillant pour les personnes de tous horizons
- **Être professionnel** : Maintenez les discussions centrées sur le projet
- **Être collaboratif** : Travaillez en équipe et partagez vos connaissances

Tout comportement inapproprié peut être signalé aux mainteneurs du projet.

---

## Comment Contribuer

### Signaler des Bugs

Si vous trouvez un bug, aidez-nous à le résoudre en suivant ces étapes :

1. **Recherchez d'abord** : Consultez les [issues existantes](../../issues) pour voir s'il a déjà été signalé
2. **Créez une issue** : S'il s'agit d'un nouveau bug, créez une issue détaillée (voir section [Signaler des Bugs](#signaler-des-bugs))
3. **Fournissez du contexte** : Incluez les étapes pour reproduire, le comportement attendu, des screenshots, des logs
4. **Étiquetez appropriément** : Utilisez l'étiquette `bug` dans l'issue

### Suggérer des Améliorations

Vous avez une idée pour améliorer MedicApp ?

1. **Vérifiez si elle existe déjà** : Recherchez dans les issues si quelqu'un l'a déjà suggérée
2. **Créez une issue de type "Feature Request"** : Décrivez votre proposition en détail
3. **Expliquez le "pourquoi"** : Justifiez pourquoi cette amélioration est précieuse
4. **Discutez avant d'implémenter** : Attendez le feedback des mainteneurs avant de commencer à coder

### Contribuer du Code

Pour contribuer du code :

1. **Trouvez une issue** : Recherchez des issues étiquetées comme `good first issue` ou `help wanted`
2. **Commentez votre intention** : Indiquez que vous travaillerez sur cette issue pour éviter la duplication
3. **Suivez le processus** : Lisez la section [Processus de Contribution](#processus-de-contribution)
4. **Créez une PR** : Suivez le [Guide des Pull Requests](#guide-des-pull-requests)

### Améliorer la Documentation

La documentation est fondamentale :

- **Corrigez les erreurs** : Fautes de frappe, liens cassés, informations obsolètes
- **Développez la documentation** : Ajoutez des exemples, des diagrammes, des explications plus claires
- **Traduisez la documentation** : Aidez à traduire les docs vers d'autres langues
- **Ajoutez des tutoriels** : Créez des guides pas à pas pour des cas d'usage courants

### Traduire vers de Nouvelles Langues

MedicApp supporte actuellement 8 langues. Pour ajouter une nouvelle langue ou améliorer les traductions existantes, consultez la section [Ajouter des Traductions](#ajouter-des-traductions).

---

## Processus de Contribution

Suivez ces étapes pour réaliser une contribution réussie :

### 1. Fork du Dépôt

Faites un fork du dépôt vers votre compte GitHub :

```bash
# Depuis GitHub, cliquez sur "Fork" dans le coin supérieur droit
```

### 2. Cloner votre Fork

Clonez votre fork localement :

```bash
git clone https://github.com/VOTRE_UTILISATEUR/medicapp.git
cd medicapp
```

### 3. Configurer le Dépôt Upstream

Ajoutez le dépôt original comme "upstream" :

```bash
git remote add upstream https://github.com/REPO_ORIGINAL/medicapp.git
git fetch upstream
```

### 4. Créer une Branche

Créez une branche descriptive pour votre travail :

```bash
# Pour nouvelles fonctionnalités
git checkout -b feature/nom-descriptif

# Pour corrections de bugs
git checkout -b fix/nom-du-bug

# Pour documentation
git checkout -b docs/description-changement

# Pour tests
git checkout -b test/description-test
```

**Conventions de noms de branches :**
- `feature/` - Nouvelle fonctionnalité
- `fix/` - Correction de bug
- `docs/` - Changements dans la documentation
- `test/` - Ajouter ou améliorer les tests
- `refactor/` - Refactorisation sans changements fonctionnels
- `style/` - Changements de format/style
- `chore/` - Tâches de maintenance

### 5. Faire des Changements

Réalisez vos changements en suivant les [Conventions de Code](#conventions-de-code).

### 6. Écrire des Tests

**Tous les changements de code doivent inclure des tests appropriés :**

```bash
# Exécuter tests pendant le développement
flutter test

# Exécuter tests spécifiques
flutter test test/chemin/vers/test.dart

# Voir la couverture
flutter test --coverage
```

Consultez la section [Guide de Tests](#guide-de-tests) pour plus de détails.

### 7. Formater le Code

Assurez-vous que votre code est correctement formaté :

```bash
# Formater tout le projet
dart format .

# Vérifier l'analyse statique
flutter analyze
```

### 8. Faire des Commits

Créez des commits en suivant les [Conventions de Commits](#conventions-de-commits) :

```bash
git add .
git commit -m "feat: ajouter notification de rappel de recharge"
```

### 9. Maintenir votre Branche à Jour

Synchronisez régulièrement avec le dépôt upstream :

```bash
git fetch upstream
git rebase upstream/main
```

### 10. Push des Changements

Poussez vos changements vers votre fork :

```bash
git push origin nom-de-votre-branche
```

### 11. Créer une Pull Request

Créez une PR depuis GitHub en suivant le [Guide des Pull Requests](#guide-des-pull-requests).

---

## Conventions de Code

Maintenir un code cohérent est fondamental pour la maintenabilité du projet.

### Dart Style Guide

Nous suivons le [Guide de Style Dart](https://dart.dev/guides/language/effective-dart/style) officiel :

- **Noms de classes** : `PascalCase` (ex. `MedicationService`)
- **Noms de variables/fonctions** : `camelCase` (ex. `getMedications`)
- **Noms de constantes** : `camelCase` (ex. `maxNotifications`)
- **Noms de fichiers** : `snake_case` (ex. `medication_service.dart`)
- **Noms de dossiers** : `snake_case` (ex. `notification_service`)

### Linting

Le projet utilise `flutter_lints` configuré dans `analysis_options.yaml` :

```bash
# Exécuter l'analyse statique
flutter analyze

# Il ne doit pas y avoir d'erreurs ni de warnings
```

Toutes les PRs doivent passer l'analyse sans erreurs ni warnings.

### Format Automatique

Utilisez `dart format` avant de faire un commit :

```bash
# Formater tout le code
dart format .

# Formater un fichier spécifique
dart format lib/services/medication_service.dart
```

**Configuration dans les éditeurs :**

- **VS Code** : Activez "Format On Save" dans la configuration
- **Android Studio** : Settings > Editor > Code Style > Dart > Set from: Dart Official

### Conventions de Nommage

**Variables booléennes :**
```dart
// Bien
bool isActive = true;
bool hasNotifications = false;
bool requiresFasting = true;

// Mal
bool active = true;
bool notifications = false;
```

**Méthodes qui retournent des valeurs :**
```dart
// Bien
List<Medication> getMedications();
Future<bool> saveMedication(Medication med);
String calculateNextDose();

// Mal
List<Medication> medications();
Future<bool> medication(Medication med);
```

**Méthodes privées :**
```dart
// Bien
void _updateDatabase() { }
String _formatDate(DateTime date) { }

// Mal
void updateDatabase() { }  // devrait être privée
String formatDate(DateTime date) { }  // devrait être privée
```

### Organisation des Fichiers

**Ordre des imports :**
```dart
// 1. Imports dart:
import 'dart:async';
import 'dart:convert';

// 2. Imports package:
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

// 3. Imports relatifs du projet:
import '../models/medication.dart';
import '../services/database_service.dart';
```

**Ordre des membres dans les classes :**
```dart
class Example {
  // 1. Champs statiques
  static const int maxValue = 100;

  // 2. Champs d'instance
  final String name;
  int count;

  // 3. Constructeur
  Example(this.name, this.count);

  // 4. Méthodes publiques
  void publicMethod() { }

  // 5. Méthodes privées
  void _privateMethod() { }
}
```

### Commentaires et Documentation

**Documenter les APIs publiques :**
```dart
/// Obtient tous les médicaments d'une personne spécifique.
///
/// Retourne une liste de [Medication] pour le [personId] fourni.
/// La liste est triée par nom alphabétiquement.
///
/// Lance [DatabaseException] si une erreur se produit dans la base de données.
Future<List<Medication>> getMedicationsByPerson(String personId) async {
  // Implémentation...
}
```

**Commentaires inline si nécessaire :**
```dart
// Calculer jours restants basé sur consommation moyenne
final daysRemaining = stockQuantity / averageDailyConsumption;
```

**Éviter les commentaires évidents :**
```dart
// Mal - commentaire inutile
// Incrémenter le compteur de 1
count++;

// Bien - code auto-descriptif
count++;
```

---

## Conventions de Commits

Nous utilisons des commits sémantiques pour maintenir un historique clair et lisible.

### Format

```
type: description brève en minuscules

[corps optionnel avec plus de détails]

[footer optionnel avec références aux issues]
```

### Types de Commits

| Type | Description | Exemple |
|------|-------------|---------|
| `feat` | Nouvelle fonctionnalité | `feat: ajouter support pour plusieurs personnes` |
| `fix` | Correction de bug | `fix: corriger calcul de stock en timezone différent` |
| `docs` | Changements dans la documentation | `docs: mettre à jour guide d'installation` |
| `test` | Ajouter ou modifier des tests | `test: ajouter tests pour jeûne à minuit` |
| `refactor` | Refactorisation sans changements fonctionnels | `refactor: extraire logique de notifications vers service` |
| `style` | Changements de format | `style: formater code selon dart format` |
| `chore` | Tâches de maintenance | `chore: mettre à jour dépendances` |
| `perf` | Améliorations de performance | `perf: optimiser requêtes de base de données` |

### Exemples de Bons Commits

```bash
# Nouveau feature avec description
git commit -m "feat: ajouter notifications de jeûne avec durée personnalisable"

# Fix avec référence à issue
git commit -m "fix: corriger calcul de prochaine dose (#123)"

# Docs
git commit -m "docs: ajouter section de contribution dans README"

# Test
git commit -m "test: ajouter tests d'intégration pour plusieurs jeûnes"

# Refactor avec contexte
git commit -m "refactor: séparer logique de médicaments en classes spécifiques

- Créer MedicationValidator pour validations
- Extraire calculs de stock vers MedicationStockCalculator
- Améliorer lisibilité du code"
```

### Exemples de Commits à Éviter

```bash
# Mal - trop vague
git commit -m "fix bug"
git commit -m "update"
git commit -m "changes"

# Mal - sans type
git commit -m "ajouter nouvelle fonctionnalité"

# Mal - type incorrect
git commit -m "docs: ajouter nouvel écran"  # devrait être 'feat'
```

### Règles Additionnelles

- **Première lettre en minuscules** : "feat: ajouter..." pas "feat: Ajouter..."
- **Sans point final** : "feat: ajouter support" pas "feat: ajouter support."
- **Mode impératif** : "ajouter" pas "ajouté" ou "ajoutant"
- **Maximum 72 caractères** : Gardez la première ligne concise
- **Corps optionnel** : Utilisez le corps pour expliquer le "pourquoi", pas le "quoi"

---

## Guide des Pull Requests

### Avant de Créer la PR

**Checklist :**

- [ ] Votre code compile sans erreurs : `flutter run`
- [ ] Tous les tests passent : `flutter test`
- [ ] Le code est formaté : `dart format .`
- [ ] Il n'y a pas de warnings d'analyse : `flutter analyze`
- [ ] Vous avez ajouté des tests pour votre changement
- [ ] La couverture des tests se maintient >= 75%
- [ ] Vous avez mis à jour la documentation si nécessaire
- [ ] Les commits suivent les conventions
- [ ] Votre branche est à jour avec `main`

### Créer la Pull Request

**Titre descriptif :**

```
feat: ajouter support pour périodes de jeûne personnalisables
fix: corriger crash dans les notifications à minuit
docs: améliorer documentation d'architecture
```

**Description détaillée :**

```markdown
## Description

Cette PR ajoute le support pour les périodes de jeûne personnalisables, permettant aux utilisateurs de configurer des durées spécifiques avant ou après la prise d'un médicament.

## Changements réalisés

- Ajouter champs `fastingType` et `fastingDurationMinutes` au modèle Medication
- Implémenter logique de validation des périodes de jeûne
- Ajouter UI pour configurer le jeûne dans l'écran d'édition de médicament
- Créer notifications ongoing pour périodes de jeûne actives
- Ajouter tests exhaustifs (15 nouveaux tests)

## Type de changement

- [x] Nouvelle fonctionnalité (changement qui ajoute une fonctionnalité sans casser le code existant)
- [ ] Correction de bug (changement qui résout une issue)
- [ ] Changement qui rompt la compatibilité (fix ou feature qui causerait que la fonctionnalité existante change)
- [ ] Ce changement nécessite une mise à jour de la documentation

## Screenshots

_Si applicable, ajouter des captures d'écran de changements dans l'UI_

## Tests

- [x] Tests unitaires ajoutés
- [x] Tests d'intégration ajoutés
- [x] Tous les tests existants passent
- [x] Couverture >= 75%

## Checklist

- [x] Le code suit les conventions du projet
- [x] J'ai revu mon propre code
- [x] J'ai commenté les zones complexes
- [x] J'ai mis à jour la documentation
- [x] Mes changements ne génèrent pas de warnings
- [x] J'ai ajouté des tests qui prouvent mon fix/fonctionnalité
- [x] Les tests nouveaux et existants passent localement

## Issues liées

Closes #123
Lié à #456
```

### Pendant la Revue

**Répondez aux commentaires :**
- Remerciez pour le feedback
- Répondez aux questions avec clarté
- Réalisez les changements demandés rapidement
- Marquez les conversations comme résolues après avoir appliqué les changements

**Maintenez la PR à jour :**
```bash
# S'il y a des changements dans main, mettez à jour votre branche
git fetch upstream
git rebase upstream/main
git push origin votre-branche --force-with-lease
```

### Après le Merge

**Nettoyage :**
```bash
# Mettre à jour votre fork
git checkout main
git pull upstream main
git push origin main

# Supprimer branche locale
git branch -d votre-branche

# Supprimer branche distante (optionnel)
git push origin --delete votre-branche
```

---

## Guide de Tests

Les tests sont **obligatoires** pour toutes les contributions de code.

### Principes

- **Toutes les PRs doivent inclure des tests** : Sans exception
- **Maintenir couverture minimum** : >= 75%
- **Les tests doivent être indépendants** : Chaque test doit pouvoir s'exécuter seul
- **Les tests doivent être déterministes** : Même input = même output toujours
- **Les tests doivent être rapides** : < 1 seconde par test unitaire

### Types de Tests

**Tests Unitaires :**
```dart
// test/models/medication_test.dart
void main() {
  group('Medication', () {
    test('calcule jours de stock correctement', () {
      final medication = MedicationBuilder()
        .withStock(30.0)
        .withSingleDose('08:00', 1.0)
        .build();

      expect(medication.calculateDaysRemaining(), equals(30));
    });
  });
}
```

**Tests de Widgets :**
```dart
// test/screens/medication_list_screen_test.dart
void main() {
  testWidgets('affiche liste de médicaments correctement', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: MedicationListScreen()),
    );

    expect(find.text('Mes Médicaments'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });
}
```

**Tests d'Intégration :**
```dart
// test/integration/medication_flow_test.dart
void main() {
  testWidgets('flux complet d\'ajout de médicament', (tester) async {
    // Setup
    await tester.pumpWidget(MyApp());

    // Ajouter médicament
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Vérifier navigation et sauvegarde
    expect(find.text('Nouveau Médicament'), findsOneWidget);
  });
}
```

### Utiliser MedicationBuilder

Pour créer des médicaments de test, utilisez le helper `MedicationBuilder` :

```dart
import 'package:medicapp/test/helpers/medication_builder.dart';

// Médicament basique
final med = MedicationBuilder()
  .withName('Aspirina')
  .withStock(20.0)
  .build();

// Avec jeûne
final medWithFasting = MedicationBuilder()
  .withName('Ibuprofeno')
  .withFasting(type: 'before', duration: 60)
  .build();

// Avec plusieurs doses
final medMultipleDoses = MedicationBuilder()
  .withName('Vitamina C')
  .withMultipleDoses(['08:00', '14:00', '20:00'], 1.0)
  .build();

// Avec stock bas
final medLowStock = MedicationBuilder()
  .withName('Paracetamol')
  .withLowStock()
  .build();
```

### Exécuter les Tests

```bash
# Tous les tests
flutter test

# Test spécifique
flutter test test/models/medication_test.dart

# Avec couverture
flutter test --coverage

# Voir rapport de couverture (nécessite genhtml)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Couverture des Tests

**Objectif : >= 75% de couverture**

```bash
# Générer rapport
flutter test --coverage

# Voir couverture par fichier
lcov --list coverage/lcov.info
```

**Zones critiques qui DOIVENT avoir des tests :**
- Modèles et logique métier (95%+)
- Services et utilitaires (90%+)
- Écrans et widgets principaux (70%+)

**Zones où la couverture peut être moindre :**
- Widgets purement visuels
- Configuration initiale (main.dart)
- Fichiers générés automatiquement

---

## Ajouter de Nouvelles Fonctionnalités

### Avant de Commencer

1. **Discuter dans une issue d'abord** : Créez une issue décrivant votre proposition
2. **Attendre feedback** : Les mainteneurs réviseront et donneront un feedback
3. **Obtenir l'approbation** : Attendez le feu vert avant d'investir du temps dans l'implémentation

### Suivre l'Architecture

MedicApp utilise **l'architecture MVS (Model-View-Service)** :

```
lib/
├── models/           # Modèles de données
├── screens/          # Vues (UI)
├── services/         # Logique métier
└── l10n/            # Traductions
```

**Principes :**
- **Models** : Seulement des données, pas de logique métier
- **Services** : Toute la logique métier et accès aux données
- **Screens** : Seulement UI, logique minimale

**Exemple de nouvelle fonctionnalité :**

```dart
// 1. Ajouter modèle (si nécessaire)
// lib/models/reminder.dart
class Reminder {
  final String id;
  final String medicationId;
  final DateTime reminderTime;

  Reminder({required this.id, required this.medicationId, required this.reminderTime});
}

// 2. Ajouter service
// lib/services/reminder_service.dart
class ReminderService {
  Future<void> scheduleReminder(Reminder reminder) async {
    // Logique métier
  }
}

// 3. Ajouter écran/widget
// lib/screens/reminder_screen.dart
class ReminderScreen extends StatelessWidget {
  // Seulement UI, délègue logique au service
}

// 4. Ajouter tests
// test/services/reminder_service_test.dart
void main() {
  group('ReminderService', () {
    test('schedule reminder crée notification', () async {
      // Test
    });
  });
}
```

### Mettre à Jour la Documentation

Lors de l'ajout d'une nouvelle fonctionnalité :

- [ ] Mettre à jour `docs/es/features.md`
- [ ] Ajouter des exemples d'utilisation
- [ ] Mettre à jour les diagrammes si applicable
- [ ] Ajouter des commentaires de documentation dans le code

### Considérer l'Internationalisation

MedicApp supporte 8 langues. **Toute nouvelle fonctionnalité doit être traduite :**

```dart
// Au lieu de texte codé en dur :
Text('New Medication')

// Utiliser traductions :
Text(AppLocalizations.of(context)!.newMedication)
```

Ajoutez les clés dans tous les fichiers `.arb` :
- `lib/l10n/app_es.arb`
- `lib/l10n/app_en.arb`
- `lib/l10n/app_de.arb`
- `lib/l10n/app_fr.arb`
- `lib/l10n/app_it.arb`
- `lib/l10n/app_ca.arb`
- `lib/l10n/app_eu.arb`
- `lib/l10n/app_gl.arb`

### Ajouter des Tests Exhaustifs

Une nouvelle fonctionnalité nécessite des tests complets :

- Tests unitaires pour toute la logique
- Tests de widgets pour l'UI
- Tests d'intégration pour des flux complets
- Tests de cas limites et d'erreurs

---

## Signaler des Bugs

### Informations Requises

Lors du signalement d'un bug, incluez :

**1. Description du bug :**
Description claire et concise du problème.

**2. Étapes pour reproduire :**
```
1. Aller à l'écran 'Médicaments'
2. Cliquer sur 'Ajouter médicament'
3. Configurer jeûne de 60 minutes
4. Enregistrer médicament
5. Voir erreur dans la console
```

**3. Comportement attendu :**
"Le médicament devrait être enregistré avec la configuration de jeûne."

**4. Comportement actuel :**
"Une erreur 'Invalid fasting duration' s'affiche et le médicament n'est pas enregistré."

**5. Screenshots/Vidéos :**
Si applicable, ajoutez des captures d'écran ou un enregistrement d'écran.

**6. Logs/Erreurs :**
```
[ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception:
Invalid fasting duration
#0      Medication.validate (package:medicapp/models/medication.dart:123)
```

**7. Environnement :**
```
- Version Flutter : 3.9.2
- Version Dart : 3.0.0
- Appareil : Samsung Galaxy S21
- OS : Android 13
- Version de MedicApp : 1.0.0
```

**8. Contexte additionnel :**
Toute autre information pertinente sur le problème.

### Template d'Issue

```markdown
## Description du Bug
[Description claire et concise]

## Étapes pour Reproduire
1.
2.
3.

## Comportement Attendu
[Ce qui devrait se passer]

## Comportement Actuel
[Ce qui se passe actuellement]

## Screenshots
[Si applicable]

## Logs/Erreurs
```
[Copier logs ici]
```

## Environnement
- Version Flutter :
- Version Dart :
- Appareil :
- OS et version :
- Version de MedicApp :

## Contexte Additionnel
[Informations additionnelles]
```

---

## Ajouter des Traductions

MedicApp supporte 8 langues. Aidez-nous à maintenir des traductions de haute qualité.

### Emplacement des Fichiers

Les fichiers de traduction se trouvent dans :

```
lib/l10n/
├── app_es.arb    # Espagnol (base)
├── app_en.arb    # Anglais
├── app_de.arb    # Allemand
├── app_fr.arb    # Français
├── app_it.arb    # Italien
├── app_ca.arb    # Catalan
├── app_eu.arb    # Basque
└── app_gl.arb    # Galicien
```

### Ajouter une Nouvelle Langue

**1. Copier le template :**
```bash
cp lib/l10n/app_es.arb lib/l10n/app_XX.arb
```

**2. Traduire toutes les clés :**
```json
{
  "appTitle": "MedicApp",
  "@appTitle": {
    "description": "Titre de l'application"
  },
  "medications": "Médicaments",
  "@medications": {
    "description": "Titre de l'écran des médicaments"
  }
}
```

**3. Mettre à jour `l10n.yaml`** (si existant) :
```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
```

**4. Enregistrer la langue dans `MaterialApp` :**
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
    const Locale('XX'),  // Nouvelle langue
  ],
  // ...
)
```

**5. Exécuter la génération de code :**
```bash
flutter pub get
# Les traductions sont générées automatiquement
```

**6. Tester dans l'app :**
```dart
// Changer temporairement la langue pour tester
Locale('XX')
```

### Améliorer les Traductions Existantes

**1. Identifier le fichier :**
Par exemple, pour améliorer l'anglais : `lib/l10n/app_en.arb`

**2. Trouver la clé :**
```json
{
  "lowStockWarning": "Low stock warning",
  "@lowStockWarning": {
    "description": "Avertissement de stock bas"
  }
}
```

**3. Améliorer la traduction :**
```json
{
  "lowStockWarning": "Running low on medication",
  "@lowStockWarning": {
    "description": "Avertissement quand il reste peu de stock de médicament"
  }
}
```

**4. Créer une PR** avec le changement.

### Directives de Traduction

- **Maintenir la cohérence** : Utilisez les mêmes termes tout au long de toutes les traductions
- **Contexte approprié** : Considérez le contexte médical
- **Longueur raisonnable** : Évitez les traductions très longues qui cassent l'UI
- **Formalité** : Utilisez un ton professionnel mais amical
- **Tester dans l'UI** : Vérifiez que la traduction s'affiche bien à l'écran

---

## Configuration de l'Environnement de Développement

### Prérequis

- **Flutter SDK** : 3.9.2 ou supérieur
- **Dart SDK** : 3.0 ou supérieur
- **Éditeur** : VS Code ou Android Studio recommandés
- **Git** : Pour contrôle de version

### Installation de Flutter

**macOS/Linux :**
```bash
# Télécharger Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Vérifier installation
flutter doctor
```

**Windows :**
1. Télécharger Flutter SDK depuis [flutter.dev](https://flutter.dev)
2. Extraire vers `C:\src\flutter`
3. Ajouter `C:\src\flutter\bin` au PATH
4. Exécuter `flutter doctor`

### Configuration de l'Éditeur

**VS Code (Recommandé) :**

1. **Installer extensions :**
   - Flutter
   - Dart
   - Flutter Widget Snippets (optionnel)

2. **Configurer settings.json :**
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

3. **Raccourcis utiles :**
   - `Cmd/Ctrl + .` - Actions rapides
   - `Cmd/Ctrl + Shift + P` - Command Palette
   - `F5` - Debug
   - `Ctrl + F5` - Run sans debug

**Android Studio :**

1. **Installer plugins :**
   - Flutter plugin
   - Dart plugin

2. **Configurer :**
   - Settings > Editor > Code Style > Dart
   - Set from: Dart Official
   - Line length: 80

### Configuration du Linter

Le projet utilise `flutter_lints`. Il est déjà configuré dans `analysis_options.yaml`.

```bash
# Exécuter l'analyse
flutter analyze

# Voir issues en temps réel dans l'éditeur
# (automatique dans VS Code et Android Studio)
```

### Configuration de Git

```bash
# Configurer identité
git config --global user.name "Votre Nom"
git config --global user.email "votre@email.com"

# Configurer éditeur par défaut
git config --global core.editor "code --wait"

# Configurer alias utiles
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
```

### Exécuter le Projet

```bash
# Installer dépendances
flutter pub get

# Exécuter sur émulateur/appareil
flutter run

# Exécuter en mode debug
flutter run --debug

# Exécuter en mode release
flutter run --release

# Hot reload (pendant l'exécution)
# Appuyer 'r' dans le terminal

# Hot restart (pendant l'exécution)
# Appuyer 'R' dans le terminal
```

### Problèmes Courants

**"Flutter SDK not found" :**
```bash
# Vérifier PATH
echo $PATH  # macOS/Linux
echo %PATH%  # Windows

# Ajouter Flutter au PATH
export PATH="$PATH:/chemin/vers/flutter/bin"  # macOS/Linux
```

**"Android licenses not accepted" :**
```bash
flutter doctor --android-licenses
```

**"CocoaPods not installed" (macOS) :**
```bash
sudo gem install cocoapods
pod setup
```

---

## Ressources Utiles

### Documentation du Projet

- [Guide d'Installation](installation.md)
- [Caractéristiques](features.md)
- [Architecture](architecture.md)
- [Base de Données](database.md)
- [Structure du Projet](project-structure.md)
- [Technologies](technologies.md)

### Documentation Externe

**Flutter :**
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Widget Catalog](https://docs.flutter.dev/development/ui/widgets)

**Material Design 3 :**
- [Material Design Guidelines](https://m3.material.io/)
- [Material Components](https://m3.material.io/components)
- [Material Theming](https://m3.material.io/foundations/customization)

**SQLite :**
- [SQLite Documentation](https://www.sqlite.org/docs.html)
- [SQLite Tutorial](https://www.sqlitetutorial.net/)
- [sqflite Package](https://pub.dev/packages/sqflite)

**Tests :**
- [Flutter Testing](https://docs.flutter.dev/testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)

### Outils

- [Dart Pad](https://dartpad.dev/) - Playground en ligne de Dart
- [FlutLab](https://flutlab.io/) - IDE en ligne de Flutter
- [DartDoc](https://dart.dev/tools/dartdoc) - Générateur de documentation
- [Flutter Inspector](https://docs.flutter.dev/development/tools/devtools/inspector) - Debug de widgets

### Communauté

- [Flutter Discord](https://discord.gg/flutter)
- [r/FlutterDev](https://www.reddit.com/r/FlutterDev/)
- [Stack Overflow - Flutter](https://stackoverflow.com/questions/tagged/flutter)

---

## Questions Fréquentes

### Comment commencer à contribuer ?

1. Lisez ce guide complet
2. Configurez votre environnement de développement
3. Recherchez des issues étiquetées comme `good first issue`
4. Commentez dans l'issue que vous travaillerez dessus
5. Suivez le [Processus de Contribution](#processus-de-contribution)

### Où puis-je aider ?

Domaines où nous avons toujours besoin d'aide :

- **Traductions** : Améliorer ou ajouter des traductions
- **Documentation** : Développer ou améliorer les docs
- **Tests** : Augmenter la couverture des tests
- **Bugs** : Résoudre les issues signalées
- **UI/UX** : Améliorer l'interface et l'expérience utilisateur

Recherchez des issues avec les étiquettes :
- `good first issue` - Idéal pour commencer
- `help wanted` - Nous avons besoin d'aide ici
- `documentation` - Lié aux docs
- `translation` - Traductions
- `bug` - Bugs signalés

### Combien de temps prennent les revues ?

- **PRs petites** (< 100 lignes) : 1-2 jours
- **PRs moyennes** (100-500 lignes) : 3-5 jours
- **PRs grandes** (> 500 lignes) : 1-2 semaines

**Astuces pour des revues plus rapides :**
- Gardez les PRs petites et ciblées
- Écrivez de bonnes descriptions
- Répondez aux commentaires rapidement
- Incluez des tests complets

### Que faire si ma PR n'est pas acceptée ?

Ne vous découragez pas. Il y a plusieurs raisons :

1. **Pas aligné avec la vision du projet** : Discutez l'idée dans une issue d'abord
2. **Nécessite des changements** : Appliquez le feedback et mettez à jour la PR
3. **Problèmes techniques** : Corrigez les issues mentionnées
4. **Timing** : Ce n'est peut-être pas le bon moment, mais sera reconsidéré plus tard

**Vous apprendrez toujours quelque chose de précieux du processus.**

### Puis-je travailler sur plusieurs issues à la fois ?

Nous recommandons de vous concentrer sur une à la fois :

- Complétez une issue avant d'en commencer une autre
- Évitez de bloquer des issues pour d'autres
- Si vous devez faire une pause, commentez dans l'issue

### Comment gérer les conflits de merge ?

```bash
# Mettre à jour votre branche avec main
git fetch upstream
git rebase upstream/main

# S'il y a des conflits, Git vous le dira
# Résolvez les conflits dans votre éditeur
# Puis :
git add .
git rebase --continue

# Push (avec force si vous aviez déjà poussé avant)
git push origin votre-branche --force-with-lease
```

### Dois-je signer un CLA ?

Actuellement **non**, nous ne nécessitons pas de CLA (Contributor License Agreement). En contribuant, vous acceptez que votre code soit sous licence AGPL-3.0.

### Puis-je contribuer anonymement ?

Oui, mais vous avez besoin d'un compte GitHub. Vous pouvez utiliser un nom d'utilisateur anonyme si vous préférez.

---

## Contact et Communauté

### GitHub Issues

La forme principale de communication est via [GitHub Issues](../../issues) :

- **Signaler des bugs** : Créez une issue avec label `bug`
- **Suggérer des améliorations** : Créez une issue avec label `enhancement`
- **Poser des questions** : Créez une issue avec label `question`
- **Discuter des idées** : Créez une issue avec label `discussion`

### Discussions (si applicable)

Si le dépôt a GitHub Discussions activé :

- Questions générales
- Montrer vos projets avec MedicApp
- Partager des idées
- Aider d'autres utilisateurs

### Temps de Réponse

- **Issues urgentes** (bugs critiques) : 24-48 heures
- **Issues normales** : 3-7 jours
- **PRs** : Selon la taille (voir FAQ)
- **Questions** : 2-5 jours

### Mainteneurs

Les mainteneurs du projet réviseront les issues, PRs et répondront aux questions. Soyez patients, nous sommes une petite équipe qui travaille dessus pendant notre temps libre.

---

## Remerciements

Merci d'avoir lu ce guide et pour votre intérêt à contribuer à MedicApp.

Chaque contribution, aussi petite soit-elle, fait une différence pour les utilisateurs qui dépendent de cette application pour gérer leur santé.

**Nous attendons votre contribution avec impatience !**

---

**Licence :** Ce projet est sous [AGPL-3.0](../../LICENSE).

**Dernière mise à jour :** 2025-11-14
