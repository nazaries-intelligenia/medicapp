# Stack Technologique de MedicApp

Ce document détaille toutes les technologies, frameworks, bibliothèques et outils utilisés dans MedicApp, y compris les versions exactes, les justifications de choix, les alternatives considérées et les compromis de chaque décision technologique.

---

## 1. Technologies de Base

### Flutter 3.9.2+

**Version utilisée:** `3.9.2+` (SDK compatible jusqu'à `3.35.7+`)

**Objectif:**
Flutter est le framework multiplateforme qui constitue la base de MedicApp. Il permet de développer une application native pour Android et iOS à partir d'une unique base de code Dart, garantissant des performances proches du natif et une expérience utilisateur cohérente sur les deux plateformes.

**Pourquoi Flutter a été choisi:**

1. **Développement multiplateforme efficace:** Une seule base de code pour Android et iOS réduit les coûts de développement et de maintenance de 60-70% par rapport au développement natif dual.

2. **Performance native:** Flutter compile en code ARM natif, n'utilise pas de ponts JavaScript comme React Native, ce qui résulte en des animations fluides à 60/120 FPS et des temps de réponse instantanés pour les opérations critiques comme l'enregistrement de doses.

3. **Hot Reload:** Permet une itération rapide pendant le développement, visualisant les changements en moins d'1 seconde sans perdre l'état de l'application. Essentiel pour ajuster l'UI des notifications et les flux multi-étapes.

4. **Material Design 3 natif:** Implémentation complète et actualisée de Material Design 3 incluse dans le SDK, sans besoin de bibliothèques tierces.

5. **Écosystème mature:** Pub.dev compte plus de 40 000 packages, incluant des solutions robustes pour les notifications locales, la base de données SQLite et la gestion de fichiers.

6. **Testing intégré:** Framework de testing complet inclus dans le SDK, avec support pour les unit tests, widget tests et integration tests. MedicApp atteint 432+ tests avec une couverture de 75-80%.

**Alternatives considérées:**

- **React Native:** Écarté pour performance inférieure dans les listes longues (historique des doses), problèmes avec les notifications locales en arrière-plan, et expérience incohérente entre plateformes.
- **Kotlin Multiplatform Mobile (KMM):** Écarté pour immaturité de l'écosystème, besoin de code UI spécifique par plateforme, et courbe d'apprentissage plus prononcée.
- **Natif (Swift + Kotlin):** Écarté pour duplication de l'effort de développement, coûts de maintenance plus élevés, et besoin de deux équipes spécialisées.

**Documentation officielle:** https://flutter.dev

---

### Dart 3.0+

**Version utilisée:** `3.9.2+` (compatible avec Flutter 3.9.2+)

**Objectif:**
Dart est le langage de programmation orienté objet développé par Google qui exécute Flutter. Il fournit une syntaxe moderne, un typage fort, la null safety et des performances optimisées.

**Caractéristiques utilisées dans MedicApp:**

1. **Null Safety:** Système de types qui élimine les erreurs de référence nulle au moment de la compilation. Critique pour la fiabilité d'un système médical où une NullPointerException pourrait empêcher l'enregistrement d'une dose vitale.

2. **Async/Await:** Programmation asynchrone élégante pour les opérations de base de données, notifications et opérations de fichiers sans bloquer l'UI.

3. **Extension Methods:** Permet d'étendre les classes existantes avec des méthodes personnalisées, utilisé pour le formatage de dates et les validations de modèles.

4. **Records et Pattern Matching (Dart 3.0+):** Structures de données immuables pour retourner plusieurs valeurs depuis les fonctions de manière sécurisée.

5. **Strong Type System:** Typage statique qui détecte les erreurs au moment de la compilation, essentiel pour les opérations critiques comme le calcul de stock et la programmation de notifications.

**Pourquoi Dart:**

- **Optimisé pour l'UI:** Dart a été conçu spécifiquement pour le développement d'interfaces, avec un garbage collector optimisé pour éviter les pauses pendant les animations.
- **AOT et JIT:** Compilation Ahead-of-Time pour la production (performance native) et Just-in-Time pour le développement (Hot Reload).
- **Syntaxe familière:** Similaire à Java, C#, JavaScript, réduisant la courbe d'apprentissage.
- **Sound Null Safety:** Garantie au moment de la compilation que les variables non nulles ne seront jamais null.

**Documentation officielle:** https://dart.dev

---

### Material Design 3

**Version:** Implémentation native dans Flutter 3.9.2+

**Objectif:**
Material Design 3 (Material You) est le système de design de Google qui fournit des composants, patterns et directives pour créer des interfaces modernes, accessibles et cohérentes.

**Implémentation dans MedicApp:**

```dart
useMaterial3: true
```

**Composants utilisés:**

1. **Color Scheme dynamique:** Système de couleurs basé sur des graines (`seedColor: Color(0xFF006B5A)` pour thème clair, `Color(0xFF00A894)` pour thème sombre) qui génère automatiquement 30+ tonalités harmoniques.

2. **FilledButton, OutlinedButton, TextButton:** Boutons avec états visuels (hover, pressed, disabled) et tailles augmentées (52dp hauteur minimale) pour l'accessibilité.

3. **Card avec élévation adaptative:** Cartes avec coins arrondis (16dp) et ombres subtiles pour la hiérarchie visuelle.

4. **NavigationBar:** Barre de navigation inférieure avec indicateurs de sélection animés et support pour la navigation entre 3-5 destinations principales.

5. **FloatingActionButton étendu:** FAB avec texte descriptif pour l'action primaire (ajouter médicament).

6. **ModalBottomSheet:** Feuilles modales pour les actions contextuelles comme l'enregistrement rapide de dose.

7. **SnackBar avec actions:** Retour temporaire pour les opérations complétées (dose enregistrée, médicament ajouté).

**Thèmes personnalisés:**

MedicApp implémente deux thèmes complets (clair et sombre) avec typographie accessible:

- **Tailles de police augmentées:** `titleLarge: 26sp`, `bodyLarge: 19sp` (supérieures aux standards de 22sp et 16sp respectivement).
- **Contraste amélioré:** Couleurs de texte avec opacité 87% sur fonds pour respecter WCAG AA.
- **Boutons larges:** Hauteur minimale de 52dp (vs 40dp standard) pour faciliter le toucher sur appareils mobiles.

**Pourquoi Material Design 3:**

- **Accessibilité intégrée:** Composants conçus avec support des lecteurs d'écran, tailles tactiles minimales et ratios de contraste WCAG.
- **Cohérence avec l'écosystème Android:** Apparence familière pour les utilisateurs d'Android 12+.
- **Personnalisation flexible:** Système de tokens de design qui permet d'adapter couleurs, typographies et formes en maintenant la cohérence.
- **Mode sombre automatique:** Support natif pour le thème sombre basé sur la configuration du système.

**Documentation officielle:** https://m3.material.io

---

## 2. Base de Données et Persistance

### sqflite ^2.3.0

**Version utilisée:** `^2.3.0` (compatible avec `2.3.0` jusqu'à `< 3.0.0`)

**Objectif:**
sqflite est le plugin SQLite pour Flutter qui fournit un accès à une base de données SQL locale, relationnelle et transactionnelle. MedicApp utilise SQLite comme stockage principal pour toutes les données de médicaments, personnes, configurations de schémas et historique de doses.

**Architecture de base de données de MedicApp:**

```
medicapp.db
├── medications (table principale)
│   ├── id (TEXT PRIMARY KEY)
│   ├── name (TEXT)
│   ├── type (TEXT)
│   ├── frequency (TEXT)
│   ├── times (TEXT JSON array)
│   ├── doses (TEXT JSON array)
│   ├── stock (REAL)
│   ├── fasting_before (INTEGER boolean)
│   ├── fasting_duration (INTEGER minutes)
│   └── ...
├── persons (V19+)
│   ├── id (TEXT PRIMARY KEY)
│   ├── name (TEXT)
│   └── is_default (INTEGER boolean)
├── person_medications (table de relation N:M)
│   ├── person_id (TEXT)
│   ├── medication_id (TEXT)
│   ├── custom_times (TEXT JSON)
│   ├── custom_doses (TEXT JSON)
│   └── PRIMARY KEY (person_id, medication_id)
└── dose_history
    ├── id (TEXT PRIMARY KEY)
    ├── medication_id (TEXT)
    ├── person_id (TEXT)
    ├── timestamp (INTEGER)
    ├── dose_amount (REAL)
    └── scheduled_time (TEXT)
```

**Opérations critiques:**

1. **Transactions ACID:** Garantie d'atomicité pour les opérations complexes comme enregistrement de dose + déduction de stock + programmation de notification.

2. **Requêtes relationnelles:** JOINs entre `medications`, `persons` et `person_medications` pour obtenir les configurations personnalisées par utilisateur.

3. **Index optimisés:** Index sur `person_id` et `medication_id` dans les tables de relation pour des requêtes rapides O(log n).

4. **Migrations versionnées:** Système de migration de schéma depuis V1 jusqu'à V19+ avec préservation des données.

**Pourquoi SQLite:**

1. **ACID compliance:** Garanties transactionnelles critiques pour les données médicales où l'intégrité est fondamentale.

2. **Requêtes SQL complexes:** Capacité d'effectuer des JOINs, agrégations et sous-requêtes pour les rapports et filtres avancés.

3. **Performance prouvée:** SQLite est la base de données la plus déployée au monde, avec des optimisations de 20+ ans.

4. **Zero-configuration:** Ne nécessite pas de serveur, configuration ou administration. La base de données est un unique fichier portable.

5. **Exportation/importation simple:** Le fichier `.db` peut être copié directement pour les sauvegardes ou transferts entre appareils.

6. **Taille illimitée:** SQLite supporte des bases de données jusqu'à 281 téraoctets, plus que suffisant pour des décennies d'historique de doses.

**Comparatif avec alternatives:**

| Caractéristique | SQLite (sqflite) | Hive | Isar | Drift |
|----------------|------------------|------|------|-------|
| **Modèle de données** | Relationnel SQL | NoSQL Key-Value | NoSQL Documentaire | Relationnel SQL |
| **Langage de requête** | SQL standard | API Dart | Query Builder Dart | SQL + Dart |
| **Transactions ACID** | ✅ Complet | ❌ Limité | ✅ Oui | ✅ Oui |
| **Migrations** | ✅ Manuel robuste | ⚠️ Manuel basique | ⚠️ Semi-automatique | ✅ Automatique |
| **Performance lecture** | ⚡ Excellent | ⚡⚡ Supérieur | ⚡⚡ Supérieur | ⚡ Excellent |
| **Performance écriture** | ⚡ Très bon | ⚡⚡ Excellent | ⚡⚡ Excellent | ⚡ Très bon |
| **Taille sur disque** | ⚠️ Plus grande | ✅ Compact | ✅ Très compact | ⚠️ Plus grande |
| **Relations N:M** | ✅ Natif | ❌ Manuel | ⚠️ Références | ✅ Natif |
| **Maturité** | ✅ 20+ ans | ⚠️ 4 ans | ⚠️ 3 ans | ✅ 5+ ans |
| **Portabilité** | ✅ Universelle | ⚠️ Propriétaire | ⚠️ Propriétaire | ⚠️ Flutter-only |
| **Outils externes** | ✅ DB Browser, CLI | ❌ Limitées | ❌ Limitées | ❌ Aucune |

**Justification de SQLite sur les alternatives:**

- **Hive:** Écarté pour manque de support robuste pour les relations N:M (architecture multi-personne), absence de transactions ACID complètes, et difficulté d'effectuer des requêtes complexes avec JOINs.

- **Isar:** Écarté malgré son excellente performance en raison de son immaturité (lancé en 2022), format propriétaire qui complique le debugging avec des outils standards, et limitations dans les requêtes relationnelles complexes.

- **Drift:** Sérieusement considéré mais écarté pour complexité accrue (nécessite génération de code), taille de l'application résultante plus grande, et moins de flexibilité dans les migrations comparé au SQL direct.

**Compromis de SQLite:**

- ✅ **Avantages:** Stabilité prouvée, SQL standard, outils externes, relations natives, exportation triviale.
- ❌ **Inconvénients:** Performance légèrement inférieure à Hive/Isar dans les opérations massives, taille de fichier plus grande, boilerplate SQL manuel.

**Décision:** Pour MedicApp, le besoin de relations N:M robustes, migrations complexes de V1 à V19+, et capacité de debugging avec des outils SQL standards justifie amplement l'utilisation de SQLite sur des alternatives NoSQL plus rapides mais moins matures.

**Documentation officielle:** https://pub.dev/packages/sqflite

---

### sqflite_common_ffi ^2.3.0

**Version utilisée:** `^2.3.0` (dev_dependencies)

**Objectif:**
Implémentation FFI (Foreign Function Interface) de sqflite qui permet d'exécuter des tests de base de données dans des environnements desktop/VM sans besoin d'émulateurs Android/iOS.

**Utilisation dans MedicApp:**

```dart
// test/helpers/database_test_helper.dart
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void setupTestDatabase() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}
```

**Pourquoi c'est nécessaire:**

- **Tests 60x plus rapides:** Les tests de base de données s'exécutent en VM locale au lieu d'émulateurs Android, réduisant le temps de 120s à 2s pour la suite complète.
- **CI/CD sans émulateurs:** GitHub Actions peut exécuter des tests sans configurer d'émulateurs, simplifiant les pipelines.
- **Debugging amélioré:** Les fichiers `.db` de test sont accessibles directement depuis le système de fichiers de l'hôte.

**Documentation officielle:** https://pub.dev/packages/sqflite_common_ffi

---

### path ^1.8.3

**Version utilisée:** `^1.8.3`

**Objectif:**
Bibliothèque de manipulation de chemins de fichiers multiplateforme qui abstrait les différences entre systèmes de fichiers (Windows: `\`, Unix: `/`).

**Utilisation dans MedicApp:**

```dart
import 'package:path/path.dart' as path;

final dbPath = path.join(await getDatabasesPath(), 'medicapp.db');
```

**Documentation officielle:** https://pub.dev/packages/path

---

### path_provider ^2.1.5

**Version utilisée:** `^2.1.5`

**Objectif:**
Plugin qui fournit un accès aux répertoires spécifiques du système d'exploitation de façon multiplateforme (documents, cache, support d'application).

**Utilisation dans MedicApp:**

```dart
import 'package:path_provider/path_provider.dart';

// Obtenir répertoire de base de données
final dbDirectory = await getDatabasesPath(); // Android: /data/data/com.medicapp/databases/

// Obtenir répertoire pour exportations
final documentsDirectory = await getApplicationDocumentsDirectory();
```

**Répertoires utilisés:**

1. **getDatabasesPath():** Pour le fichier `medicapp.db` principal.
2. **getApplicationDocumentsDirectory():** Pour les exportations de base de données que l'utilisateur peut partager.
3. **getTemporaryDirectory():** Pour les fichiers temporaires pendant l'importation.

**Documentation officielle:** https://pub.dev/packages/path_provider

---

## 3. Notifications

### flutter_local_notifications ^19.5.0

**Version utilisée:** `^19.5.0`

**Objectif:**
Système complet de notifications locales (ne nécessitent pas de serveur) pour Flutter, avec support pour les notifications programmées, répétitives, avec actions et personnalisées par plateforme.

**Implémentation dans MedicApp:**

MedicApp utilise un système de notifications sophistiqué qui gère trois types de notifications:

1. **Notifications de rappel de dose:**
   - Programmées avec horaires exacts configurés par l'utilisateur.
   - Incluent titre avec nom de personne (en multi-personne) et détails de dose.
   - Support pour actions rapides: "Prendre", "Reporter", "Omettre" (écartées en V20+ pour limitations de type).
   - Son personnalisé et canal de haute priorité sur Android.

2. **Notifications de doses anticipées:**
   - Détectent quand une dose est prise avant son horaire programmé.
   - Mettent à jour automatiquement la prochaine notification si applicable.
   - Annulent les notifications obsolètes de l'horaire anticipé.

3. **Notifications de fin de jeûne:**
   - Notification ongoing (permanente) pendant la période de jeûne avec compte à rebours.
   - S'annule automatiquement quand le jeûne se termine ou quand fermée manuellement.
   - Inclut progrès visuel (Android) et heure de finalisation.

**Configuration par plateforme:**

**Android:**
```dart
AndroidInitializationSettings('app_icon')
AndroidNotificationDetails(
  'medication_reminders',
  'Rappels de Médicaments',
  importance: Importance.high,
  priority: Priority.high,
  showWhen: true,
  enableLights: true,
  enableVibration: true,
  playSound: true,
)
```

**iOS:**
```dart
DarwinInitializationSettings(
  requestAlertPermission: true,
  requestBadgePermission: true,
  requestSoundPermission: true,
)
```

**Caractéristiques avancées utilisées:**

1. **Scheduling précis:** Notifications programmées avec précision de seconde en utilisant `timezone`.
2. **Canaux de notification (Android 8+):** 3 canaux séparés pour rappels, jeûne et système.
3. **Payload personnalisé:** Données JSON dans le payload pour identifier médicament et personne.
4. **Callbacks d'interaction:** Callbacks quand l'utilisateur touche la notification.
5. **Gestion des permissions:** Demande et vérification de permissions sur Android 13+ (Tiramisu).

**Limites et optimisations:**

- **Limite de 500 notifications programmées simultanées** (limitation du système Android).
- MedicApp gère la priorisation automatique quand cette limite est dépassée:
  - Priorise les 7 prochains jours.
  - Écarte les notifications de médicaments inactifs.
  - Réorganise quand des médicaments sont ajoutés/supprimés.

**Pourquoi flutter_local_notifications:**

1. **Notifications locales vs distantes:** MedicApp ne nécessite pas de serveur backend, donc les notifications locales sont l'architecture correcte.

2. **Fonctionnalité complète:** Support pour scheduling, répétition, actions, personnalisation par plateforme et gestion de permissions.

3. **Maturité prouvée:** Package avec 5+ ans de développement, 3000+ étoiles sur GitHub, utilisé en production par des milliers d'applications.

4. **Documentation exhaustive:** Exemples détaillés pour tous les cas d'usage communs.

**Pourquoi PAS Firebase Cloud Messaging (FCM):**

| Critère | flutter_local_notifications | Firebase Cloud Messaging |
|----------|----------------------------|--------------------------|
| **Nécessite serveur** | ❌ Non | ✅ Oui (Firebase) |
| **Nécessite connexion** | ❌ Non | ✅ Oui (internet) |
| **Confidentialité** | ✅ Toutes données locales | ⚠️ Tokens sur Firebase |
| **Latence** | ✅ Instantanée | ⚠️ Dépend du réseau |
| **Coût** | ✅ Gratuit | ⚠️ Quota gratuit limité |
| **Complexité setup** | ✅ Minimale | ❌ Élevée (Firebase, serveur) |
| **Fonctionne hors ligne** | ✅ Toujours | ❌ Non |
| **Scheduling précis** | ✅ Oui | ❌ Non (approximatif) |

**Décision:** Pour une application de gestion de médicaments où la confidentialité est critique, les doses doivent être notifiées ponctuellement même sans connexion, et il n'y a pas besoin de communication serveur-client, les notifications locales sont l'architecture correcte et plus simple.

**Comparatif avec alternatives:**

- **awesome_notifications:** Écarté pour adoption moindre (moins mature), APIs plus complexes, et problèmes rapportés avec notifications programmées sur Android 12+.

- **local_notifications (natif):** Écarté pour nécessité de code spécifique de plateforme (Kotlin/Swift), dupliquant l'effort de développement.

**Documentation officielle:** https://pub.dev/packages/flutter_local_notifications

---

### timezone ^0.10.1

**Version utilisée:** `^0.10.1`

**Objectif:**
Bibliothèque de gestion de fuseaux horaires qui permet de programmer des notifications à des moments spécifiques de la journée en considérant les changements d'heure d'été (DST) et conversions entre fuseaux horaires.

**Utilisation dans MedicApp:**

```dart
import 'package:timezone/timezone.dart' as tz;

// Initialisation
await tz.initializeTimeZones();
final location = tz.getLocation('Europe/Madrid');
tz.setLocalLocation(location);

// Programmer notification à 08:00 locales
final scheduledDate = tz.TZDateTime(
  location,
  now.year,
  now.month,
  now.day,
  8, // heure
  0, // minutes
);

await flutterLocalNotificationsPlugin.zonedSchedule(
  id,
  title,
  body,
  scheduledDate,
  notificationDetails,
  uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
);
```

**Pourquoi c'est critique:**

- **Heure d'été:** Sans `timezone`, les notifications seraient décalées d'1 heure pendant les changements de DST.
- **Cohérence:** Les utilisateurs configurent les horaires dans leur fuseau horaire local, qui doit être respecté indépendamment des changements de fuseau horaire de l'appareil.
- **Précision:** `zonedSchedule` garantit les notifications au moment exact spécifié.

**Documentation officielle:** https://pub.dev/packages/timezone

---

### android_intent_plus ^6.0.0

**Version utilisée:** `^6.0.0`

**Objectif:**
Plugin pour lancer des intentions (Intents) Android depuis Flutter, utilisé spécifiquement pour ouvrir la configuration des notifications quand les permissions sont désactivées.

**Utilisation dans MedicApp:**

```dart
import 'package:android_intent_plus/android_intent.dart';

// Ouvrir configuration des notifications de l'app
final intent = AndroidIntent(
  action: 'android.settings.APP_NOTIFICATION_SETTINGS',
  arguments: {
    'android.provider.extra.APP_PACKAGE': packageName,
  },
);
await intent.launch();
```

**Cas d'usage:**

1. **Guider l'utilisateur:** Quand les permissions de notification sont désactivées, un dialogue explicatif s'affiche avec un bouton "Ouvrir Configuration" qui lance directement l'écran de configuration des notifications de MedicApp.

2. **UX améliorée:** Évite que l'utilisateur doive naviguer manuellement: Configuration > Applications > MedicApp > Notifications.

**Documentation officielle:** https://pub.dev/packages/android_intent_plus

---

## 4. Localisation (i18n)

### flutter_localizations (SDK)

**Version utilisée:** Inclus dans Flutter SDK

**Objectif:**
Package officiel de Flutter qui fournit des localisations pour les widgets Material et Cupertino en 85+ langues, incluant les traductions de composants standards (boutons de dialogue, pickers, etc.).

**Utilisation dans MedicApp:**

```dart
import 'package:flutter_localizations/flutter_localizations.dart';

MaterialApp(
  localizationsDelegates: [
    GlobalMaterialLocalizations.delegate, // Widgets Material
    GlobalWidgetsLocalizations.delegate,  // Widgets génériques
    GlobalCupertinoLocalizations.delegate, // Cupertino (iOS)
  ],
  supportedLocales: [
    Locale('es'), // Espagnol
    Locale('en'), // Anglais
    Locale('de'), // Allemand
    // ... 8 langues au total
  ],
)
```

**Ce que cela fournit:**

- Traductions de boutons standards: "OK", "Annuler", "Accepter".
- Formats de date et heure localisés: "15/11/2025" (es) vs "11/15/2025" (en).
- Sélecteurs de date/heure en langue locale.
- Noms de jours et mois.

**Documentation officielle:** https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization

---

### intl ^0.20.2

**Version utilisée:** `^0.20.2`

**Objectif:**
Bibliothèque d'internationalisation de Dart qui fournit le formatage de dates, nombres, pluralisation et traduction de messages via fichiers ARB.

**Utilisation dans MedicApp:**

```dart
import 'package:intl/intl.dart';

// Formatage de dates
final formatted = DateFormat('dd/MM/yyyy').format(DateTime.now());

// Formatage de nombres
final stock = NumberFormat.decimalPattern().format(25.5);

// Pluralisation (depuis ARB)
// "{count, plural, =1{1 comprimé} other{{count} comprimés}}"
```

**Cas d'usage:**

1. **Formatage de dates:** Afficher dates de début/fin de traitement, historique de doses.
2. **Formatage de nombres:** Afficher stock avec décimales selon configuration régionale.
3. **Pluralisation intelligente:** Messages qui changent selon quantité ("1 comprimé" vs "5 comprimés").

**Documentation officielle:** https://pub.dev/packages/intl

---

### Système ARB (Application Resource Bundle)

**Format utilisé:** ARB (basé sur JSON)

**Objectif:**
Système de fichiers de ressources d'application qui permet de définir des traductions de chaînes en format JSON avec support pour placeholders, pluralisation et métadonnées.

**Configuration dans MedicApp:**

**`l10n.yaml`:**
```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
untranslated-messages-file: untranslated_messages.json
```

**Structure de fichiers:**
```
lib/l10n/
├── app_es.arb (modèle principal, espagnol)
├── app_en.arb (traductions anglais)
├── app_de.arb (traductions allemand)
├── app_fr.arb (traductions français)
├── app_it.arb (traductions italien)
├── app_ca.arb (traductions catalan)
├── app_eu.arb (traductions basque)
└── app_gl.arb (traductions galicien)
```

**Exemple d'ARB avec caractéristiques avancées:**

**`app_es.arb`:**
```json
{
  "@@locale": "es",

  "appTitle": "MedicApp",
  "@appTitle": {
    "description": "Titre de l'application"
  },

  "medicationDose": "{count, plural, =1{1 {unit}} other{{count} {unit}}}",
  "@medicationDose": {
    "description": "Dose de médicament avec pluralisation",
    "placeholders": {
      "count": {
        "type": "num",
        "format": "decimalPattern"
      },
      "unit": {
        "type": "String"
      }
    }
  },

  "stockRemaining": "Il reste {stock} {unit, plural, =1{unité} other{unités}}",
  "@stockRemaining": {
    "placeholders": {
      "stock": {"type": "num"},
      "unit": {"type": "String"}
    }
  }
}
```

**Génération automatique:**

Flutter génère automatiquement la classe `AppLocalizations` avec méthodes typées:

```dart
// Code généré dans .dart_tool/flutter_gen/gen_l10n/app_localizations.dart
class AppLocalizations {
  String get appTitle => 'MedicApp';

  String medicationDose(num count, String unit) {
    return Intl.plural(
      count,
      one: '1 $unit',
      other: '$count $unit',
      name: 'medicationDose',
      args: [count, unit],
    );
  }
}

// Utilisation dans le code
Text(AppLocalizations.of(context)!.medicationDose(2.5, 'comprimés'))
// Résultat: "2.5 comprimés"
```

**Avantages du système ARB:**

1. **Typage fort:** Erreurs de traduction détectées à la compilation.
2. **Placeholders sécurisés:** Impossible d'oublier des paramètres requis.
3. **Pluralisation CLDR:** Support pour règles de pluralisation de 200+ langues selon Unicode CLDR.
4. **Métadonnées utiles:** Descriptions et contexte pour traducteurs.
5. **Outils de traduction:** Compatible avec Google Translator Toolkit, Crowdin, Lokalise.

**Processus de traduction dans MedicApp:**

1. Définir chaînes dans `app_es.arb` (modèle).
2. Exécuter `flutter gen-l10n` pour générer code Dart.
3. Traduire vers autres langues en copiant et modifiant fichiers ARB.
4. Réviser `untranslated_messages.json` pour détecter chaînes manquantes.

**Documentation officielle:** https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization#adding-your-own-localized-messages

---

### 8 Langues Supportées

MedicApp est complètement traduite en 8 langues:

| Code | Langue | Région principale | Locuteurs (millions) |
|--------|--------|------------------|----------------------|
| `es` | Espagnol | Espagne, Amérique Latine | 500M+ |
| `en` | English | Mondial | 1 500M+ |
| `de` | Deutsch | Allemagne, Autriche, Suisse | 130M+ |
| `fr` | Français | France, Canada, Afrique | 300M+ |
| `it` | Italiano | Italie, Suisse | 85M+ |
| `ca` | Català | Catalogne, Valence, Baléares | 10M+ |
| `eu` | Euskara | Pays Basque | 750K+ |
| `gl` | Galego | Galice | 2,5M+ |

**Couverture totale:** ~2 500 millions de locuteurs potentiels

**Chaînes totales:** ~450 traductions par langue

**Qualité de traduction:**
- Espagnol: Natif (modèle)
- Anglais: Natif
- Allemand, français, italien: Professionnel
- Catalan, basque, galicien: Natif (langues co-officielles d'Espagne)

**Justification des langues incluses:**

- **Espagnol:** Langue principale du développeur et marché objectif initial (Espagne, Amérique Latine).
- **Anglais:** Langue universelle pour portée mondiale.
- **Allemand, français, italien:** Principales langues d'Europe occidentale, marchés avec forte demande d'apps de santé.
- **Catalan, basque, galicien:** Langues co-officielles en Espagne (régions avec 17M+ habitants), améliore l'accessibilité pour utilisateurs âgés plus à l'aise en langue maternelle.

---

## 5. Gestion d'État

### Sans bibliothèque de gestion d'état (Vanilla Flutter)

**Décision:** MedicApp **N'utilise PAS** de bibliothèque de gestion d'état (Provider, Riverpod, BLoC, Redux, GetX).

**Pourquoi AUCUNE gestion d'état n'est utilisée:**

1. **Architecture basée sur base de données:** Le véritable état de l'application réside dans SQLite, pas en mémoire. Chaque écran interroge la base de données directement pour obtenir des données actualisées.

2. **StatefulWidget + setState est suffisant:** Pour une application de complexité moyenne comme MedicApp, `setState()` et `StatefulWidget` fournissent une gestion d'état local plus que suffisante.

3. **Simplicité sur frameworks:** Éviter des dépendances inutiles réduit la complexité, la taille de l'application et les possibles breaking changes dans les mises à jour.

4. **Streams de base de données:** Pour les données réactives, on utilise `StreamBuilder` avec streams directs depuis `DatabaseHelper`:

```dart
StreamBuilder<List<Medication>>(
  stream: DatabaseHelper.instance.watchMedications(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return CircularProgressIndicator();
    final medications = snapshot.data!;
    return ListView.builder(...);
  },
)
```

5. **Navigation avec callbacks:** Pour la communication entre écrans, on utilise les callbacks traditionnels de Flutter:

```dart
// Écran principal
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => AddMedicationScreen(
      onMedicationAdded: () {
        setState(() {}); // Rafraîchir liste
      },
    ),
  ),
);
```

**Comparatif avec alternatives:**

| Solution | MedicApp (Vanilla) | Provider | BLoC | Riverpod |
|----------|-------------------|----------|------|----------|
| **Lignes de code supplémentaires** | 0 | ~500 | ~1 500 | ~800 |
| **Dépendances externes** | 0 | 1 | 2+ | 2+ |
| **Courbe d'apprentissage** | ✅ Minimale | ⚠️ Moyenne | ❌ Élevée | ⚠️ Moyenne-Élevée |
| **Boilerplate** | ✅ Aucun | ⚠️ Moyen | ❌ Élevé | ⚠️ Moyen |
| **Testing** | ✅ Direct | ⚠️ Nécessite mocks | ⚠️ Nécessite setup | ⚠️ Nécessite setup |
| **Performance** | ✅ Excellent | ⚠️ Bon | ⚠️ Bon | ⚠️ Bon |
| **Taille APK** | ✅ Minimale | +50KB | +150KB | +100KB |

**Pourquoi PAS Provider:**

- **Inutile:** Provider est conçu pour partager l'état entre widgets profondément imbriqués. MedicApp obtient des données de la base de données dans chaque écran racine, sans besoin de passer l'état vers le bas.
- **Complexité ajoutée:** Nécessite `ChangeNotifier`, `MultiProvider`, context-awareness, et comprendre l'arbre de widgets.
- **Sur-ingénierie:** Pour une application avec ~15 écrans et état en base de données, Provider serait utiliser un marteau-piqueur pour planter un clou.

**Pourquoi PAS BLoC:**

- **Complexité extrême:** BLoC (Business Logic Component) nécessite comprendre streams, sinks, événements, états, et architecture en couches.
- **Boilerplate massif:** Chaque feature nécessite 4-5 fichiers (bloc, event, state, repository, test).
- **Sur-ingénierie:** BLoC est excellent pour applications d'entreprise avec logique métier complexe et multiples développeurs. MedicApp est une application de complexité moyenne où la simplicité est prioritaire.

**Pourquoi PAS Riverpod:**

- **Moins mature:** Riverpod est relativement nouveau (2020) comparé à Provider (2018) et BLoC (2018).
- **Complexité similaire à Provider:** Nécessite comprendre providers, autoDispose, family, et architecture déclarative.
- **Sans avantage clair:** Pour MedicApp, Riverpod n'offre pas de bénéfices significatifs sur l'architecture actuelle.

**Pourquoi PAS Redux:**

- **Complexité massive:** Redux nécessite actions, reducers, middleware, store, et immutabilité stricte.
- **Boilerplate insoutenable:** Même les opérations simples nécessitent plusieurs fichiers et centaines de lignes de code.
- **Over-kill total:** Redux est conçu pour applications web SPA avec état complexe en frontend. MedicApp a l'état dans SQLite, pas en mémoire.

**Cas où on aurait BESOIN de gestion d'état:**

- **État partagé complexe en mémoire:** Si plusieurs écrans devaient partager des objets larges en mémoire (ne s'applique pas à MedicApp).
- **État global d'authentification:** S'il y avait login/sessions (MedicApp est local, sans comptes).
- **Synchronisation en temps réel:** S'il y avait collaboration multi-utilisateur en temps réel (ne s'applique pas).
- **Logique métier complexe:** S'il y avait des calculs lourds nécessitant cache en mémoire (MedicApp fait des calculs simples de stock et dates).

**Décision finale:**

Pour MedicApp, l'architecture **Database as Single Source of Truth + StatefulWidget + setState** est la solution correcte. C'est simple, direct, facile à comprendre et maintenir, et n'introduit pas de complexité inutile. Ajouter Provider, BLoC ou Riverpod serait de la pure sur-ingénierie sans bénéfices tangibles.

---

## 6. Stockage Local

### shared_preferences ^2.2.2

**Version utilisée:** `^2.2.2`

**Objectif:**
Stockage persistant clé-valeur pour préférences simples de l'utilisateur, configurations d'application et états non critiques. Utilise `SharedPreferences` sur Android et `UserDefaults` sur iOS.

**Utilisation dans MedicApp:**

MedicApp utilise `shared_preferences` pour stocker des configurations légères qui ne justifient pas une table SQL:

**`lib/services/preferences_service.dart`:**
```dart
class PreferencesService {
  static const _keyThemeMode = 'theme_mode';
  static const _keyLocale = 'locale';
  static const _keyNotificationsEnabled = 'notifications_enabled';

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeMode, mode.toString());
  }

  Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final modeStr = prefs.getString(_keyThemeMode);
    return ThemeMode.values.firstWhere(
      (e) => e.toString() == modeStr,
      orElse: () => ThemeMode.system,
    );
  }
}
```

**Données stockées:**

1. **Thème d'application:**
   - Clé: `theme_mode`
   - Valeurs: `ThemeMode.light`, `ThemeMode.dark`, `ThemeMode.system`
   - Usage: Persister préférence de thème entre sessions.

2. **Langue sélectionnée:**
   - Clé: `locale`
   - Valeurs: `es`, `en`, `de`, `fr`, `it`, `ca`, `eu`, `gl`
   - Usage: Mémoriser langue choisie par l'utilisateur (override de langue du système).

3. **État des permissions:**
   - Clé: `notifications_enabled`
   - Valeurs: `true`, `false`
   - Usage: Cache local de l'état des permissions pour éviter appels natifs répétés.

4. **Première exécution:**
   - Clé: `first_run`
   - Valeurs: `true`, `false`
   - Usage: Montrer tutoriel/onboarding seulement à la première exécution.

**Pourquoi shared_preferences et pas SQLite:**

- **Performance:** Accès instantané O(1) pour valeurs simples vs requête SQL avec overhead.
- **Simplicité:** API triviale (`getString`, `setString`) vs préparer queries SQL.
- **Objectif:** Préférences utilisateur vs données relationnelles.
- **Taille:** Valeurs petites (< 1KB) vs enregistrements complexes.

**Limitations de shared_preferences:**

- ❌ Ne supporte pas relations, JOINs, transactions.
- ❌ Non approprié pour données >100KB.
- ❌ Accès asynchrone (nécessite `await`).
- ❌ Seulement types primitifs (String, int, double, bool, List<String>).

**Compromis:**

- ✅ **Avantages:** API simple, performance excellente, objectif correct pour préférences.
- ❌ **Inconvénients:** Non approprié pour données structurées ou volumineuses.

**Documentation officielle:** https://pub.dev/packages/shared_preferences

---

## 7. Opérations de Fichiers

### file_picker ^8.0.0+1

**Version utilisée:** `^8.0.0+1`

**Objectif:**
Plugin multiplateforme pour sélectionner des fichiers du système de fichiers de l'appareil, avec support pour multiples plateformes (Android, iOS, desktop, web).

**Utilisation dans MedicApp:**

MedicApp utilise `file_picker` exclusivement pour la fonction d'**importation de base de données**, permettant à l'utilisateur de restaurer une sauvegarde ou migrer des données depuis un autre appareil.

**Implémentation:**

```dart
import 'package:file_picker/file_picker.dart';

Future<void> importDatabase() async {
  // Ouvrir sélecteur de fichiers
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['db'],
    dialogTitle: 'Sélectionner fichier de base de données',
  );

  if (result == null) return; // Utilisateur a annulé

  final file = result.files.single;
  final path = file.path!;

  // Valider et copier fichier
  await DatabaseHelper.instance.importDatabase(path);

  // Recharger application
  setState(() {});
}
```

**Caractéristiques utilisées:**

1. **Filtre d'extensions:** Permet seulement de sélectionner des fichiers `.db` pour éviter erreurs de l'utilisateur.
2. **Titre personnalisé:** Affiche message descriptif dans le dialogue du système.
3. **Chemin complet:** Obtient path absolu du fichier pour le copier à l'emplacement de l'app.

**Alternatives considérées:**

- **image_picker:** Écarté car conçu spécifiquement pour images/vidéos, pas fichiers génériques.
- **Code natif:** Écarté car nécessiterait implémenter `ActivityResultLauncher` (Android) et `UIDocumentPickerViewController` (iOS) manuellement.

**Documentation officielle:** https://pub.dev/packages/file_picker

---

### share_plus ^10.1.4

**Version utilisée:** `^10.1.4`

**Objectif:**
Plugin multiplateforme pour partager fichiers, texte et URLs en utilisant la feuille de partage native du système d'exploitation (Android Share Sheet, iOS Share Sheet).

**Utilisation dans MedicApp:**

MedicApp utilise `share_plus` pour la fonction d'**exportation de base de données**, permettant à l'utilisateur de créer une sauvegarde et la partager via email, cloud storage (Drive, Dropbox), Bluetooth, ou la sauvegarder dans fichiers locaux.

**Implémentation:**

```dart
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

Future<void> exportDatabase() async {
  // Obtenir chemin de la base de données actuelle
  final dbPath = await DatabaseHelper.instance.getDatabasePath();

  // Créer copie temporaire dans répertoire partageable
  final tempDir = await getTemporaryDirectory();
  final exportPath = '${tempDir.path}/medicapp_backup_${DateTime.now().millisecondsSinceEpoch}.db';

  // Copier base de données
  await File(dbPath).copy(exportPath);

  // Partager fichier
  await Share.shareXFiles(
    [XFile(exportPath)],
    subject: 'Sauvegarde MedicApp',
    text: 'Base de données de MedicApp - ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
  );
}
```

**Flux utilisateur:**

1. Utilisateur touche "Exporter base de données" dans menu de configuration.
2. MedicApp crée copie de `medicapp.db` avec timestamp dans le nom.
3. La feuille de partage native de l'OS s'ouvre.
4. Utilisateur choisit destination: Gmail (comme pièce jointe), Drive, Bluetooth, "Enregistrer dans fichiers", etc.
5. Le fichier `.db` est partagé/sauvegardé dans la destination choisie.

**Caractéristiques avancées:**

- **XFile:** Abstraction multiplateforme de fichiers qui fonctionne sur Android, iOS, desktop et web.
- **Métadonnées:** Inclut nom de fichier descriptif et texte explicatif.
- **Compatibilité:** Fonctionne avec toutes les apps compatibles avec le protocole de partage de l'OS.

**Pourquoi share_plus:**

- **UX native:** Utilise l'interface de partage que l'utilisateur connaît déjà, sans réinventer la roue.
- **Intégration parfaite:** S'intègre automatiquement avec toutes les apps installées qui peuvent recevoir des fichiers.
- **Multiplateforme:** Même code fonctionne sur Android et iOS avec comportement natif sur chacun.

**Alternatives considérées:**

- **Écrire dans répertoire public directement:** Écarté car sur Android 10+ (Scoped Storage) nécessite permissions complexes et ne fonctionne pas de façon cohérente.
- **Plugin d'email direct:** Écarté car limite l'utilisateur à une seule méthode de sauvegarde (email), tandis que `share_plus` permet n'importe quelle destination.

**Documentation officielle:** https://pub.dev/packages/share_plus

---

## 8. Testing

### flutter_test (SDK)

**Version utilisée:** Inclus dans Flutter SDK

**Objectif:**
Framework officiel de testing de Flutter qui fournit tous les outils nécessaires pour unit tests, widget tests et integration tests.

**Architecture de testing de MedicApp:**

MedicApp compte **432+ tests** organisés en 3 catégories:

#### 1. Unit Tests (60% des tests)

Tests de logique métier pure, modèles, services et helpers sans dépendances de Flutter.

**Exemples:**
- `test/medication_model_test.dart`: Validation de modèles de données.
- `test/dose_history_service_test.dart`: Logique d'historique de doses.
- `test/notification_service_test.dart`: Logique de programmation de notifications.
- `test/preferences_service_test.dart`: Service de préférences.

**Structure typique:**
```dart
void main() {
  setUpAll(() async {
    // Initialiser base de données de test
    setupTestDatabase();
  });

  tearDown(() async {
    // Nettoyer base de données après chaque test
    await DatabaseHelper.instance.close();
  });

  group('Medication Model', () {
    test('devrait créer médicament avec données valides', () {
      final medication = Medication(
        id: 'test-id',
        name: 'Ibuprofène',
        type: MedicationType.pill,
      );

      expect(medication.id, 'test-id');
      expect(medication.name, 'Ibuprofène');
      expect(medication.type, MedicationType.pill);
    });

    test('devrait calculer prochaine heure de dose correctement', () {
      final medication = Medication(
        id: 'test',
        name: 'Test',
        times: ['08:00', '20:00'],
      );

      final now = DateTime(2025, 1, 15, 10, 0); // 10:00 AM
      final nextDose = medication.getNextDoseTime(now);

      expect(nextDose.hour, 20); // Prochaine dose à 20:00
    });
  });
}
```

#### 2. Widget Tests (30% des tests)

Tests de widgets individuels, interactions d'UI et flux de navigation.

**Exemples:**
- `test/settings_screen_test.dart`: Écran de configuration.
- `test/edit_schedule_screen_test.dart`: Éditeur d'horaires.
- `test/edit_duration_screen_test.dart`: Éditeur de durée.
- `test/day_navigation_ui_test.dart`: Navigation de jours.

**Structure typique:**
```dart
void main() {
  testWidgets('devrait afficher liste de médicaments', (tester) async {
    // Arrange: Préparer données de test
    final medications = [
      Medication(id: '1', name: 'Ibuprofène', type: MedicationType.pill),
      Medication(id: '2', name: 'Paracétamol', type: MedicationType.pill),
    ];

    // Act: Construire widget
    await tester.pumpWidget(
      MaterialApp(
        home: MedicationListScreen(medications: medications),
      ),
    );

    // Assert: Vérifier UI
    expect(find.text('Ibuprofène'), findsOneWidget);
    expect(find.text('Paracétamol'), findsOneWidget);

    // Interaction: Toucher premier médicament
    await tester.tap(find.text('Ibuprofène'));
    await tester.pumpAndSettle();

    // Vérifier navigation
    expect(find.byType(MedicationDetailScreen), findsOneWidget);
  });
}
```

#### 3. Integration Tests (10% des tests)

Tests end-to-end de flux complets qui impliquent plusieurs écrans, base de données et services.

**Exemples:**
- `test/integration/add_medication_test.dart`: Flux complet d'ajout médicament (8 étapes).
- `test/integration/dose_registration_test.dart`: Enregistrement de dose et mise à jour de stock.
- `test/integration/stock_management_test.dart`: Gestion complète de stock (recharge, épuisement, alertes).
- `test/integration/app_startup_test.dart`: Démarrage d'application et chargement de données.

**Structure typique:**
```dart
void main() {
  testWidgets('flux complet ajout médicament', (tester) async {
    // Démarrer application
    await tester.pumpWidget(const MedicApp());
    await tester.pumpAndSettle();

    // Étape 1: Ouvrir écran d'ajout médicament
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Étape 2: Introduire nom
    await tester.enterText(find.byType(TextField).first, 'Ibuprofène 600mg');

    // Étape 3: Sélectionner type
    await tester.tap(find.text('Comprimé'));
    await tester.pumpAndSettle();

    // Étape 4: Étape suivante
    await tester.tap(find.text('Suivant'));
    await tester.pumpAndSettle();

    // ... continuer avec les 8 étapes

    // Vérifier médicament ajouté
    expect(find.text('Ibuprofène 600mg'), findsOneWidget);

    // Vérifier dans base de données
    final medications = await DatabaseHelper.instance.getMedications();
    expect(medications.length, 1);
    expect(medications.first.name, 'Ibuprofène 600mg');
  });
}
```

**Couverture de code:**

- **Objectif:** 75-80%
- **Actuel:** 75-80% (432+ tests)
- **Lignes couvertes:** ~12 000 de ~15 000

**Zones avec plus grande couverture:**
- Models: 95%+ (logique critique de données)
- Services: 85%+ (notifications, base de données, doses)
- Screens: 65%+ (UI et navigation)

**Zones avec moindre couverture:**
- Helpers et utilities: 60%
- Code d'initialisation: 50%

**Stratégie de testing:**

1. **Test-first pour logique critique:** Tests écrits avant le code pour calculs de doses, stock, horaires.
2. **Test-after pour UI:** Tests écrits après avoir implémenté les écrans pour vérifier comportement.
3. **Regression tests:** Chaque bug trouvé devient un test pour éviter les régressions.

**Commandes de testing:**

```bash
# Exécuter tous les tests
flutter test

# Exécuter tests avec couverture
flutter test --coverage

# Exécuter tests spécifiques
flutter test test/medication_model_test.dart

# Exécuter tests d'intégration
flutter test test/integration/
```

**Helpers de testing:**

**`test/helpers/database_test_helper.dart`:**
```dart
void setupTestDatabase() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}

Future<void> cleanDatabase() async {
  await DatabaseHelper.instance.close();
  await DatabaseHelper.instance.database; // Recréer propre
}
```

**`test/helpers/medication_factory.dart`:**
```dart
class MedicationFactory {
  static Medication createPill({String name = 'Test Medication'}) {
    return Medication(
      id: const Uuid().v4(),
      name: name,
      type: MedicationType.pill,
      stock: 30,
      times: ['08:00', '20:00'],
      doses: [1, 1],
    );
  }
}
```

**Documentation officielle:** https://docs.flutter.dev/testing

---

## 9. Outils de Développement

### flutter_launcher_icons ^0.14.4

**Version utilisée:** `^0.14.4` (dev_dependencies)

**Objectif:**
Package qui génère automatiquement des icônes d'application dans toutes les tailles et formats requis par Android et iOS depuis une unique image source.

**Configuration dans MedicApp:**

**`pubspec.yaml`:**
```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/icon.png"
  adaptive_icon_background: "#419e69"
  adaptive_icon_foreground: "assets/images/icon.png"
  min_sdk_android: 21
```

**Icônes générées:**

**Android:**
- `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` (72x72)
- `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` (48x48)
- `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png` (96x96)
- `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` (144x144)
- `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` (192x192)
- Icônes adaptatives pour Android 8+ (foreground + background séparés)

**iOS:**
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/` (20x20 jusqu'à 1024x1024, 15+ variantes)

**Commande de génération:**

```bash
flutter pub run flutter_launcher_icons
```

**Pourquoi cet outil:**

- **Automatisation:** Générer manuellement 20+ fichiers d'icônes serait fastidieux et sujet à erreurs.
- **Icônes adaptatives (Android 8+):** Supporte la fonctionnalité d'icônes adaptatives qui s'ajustent à différentes formes selon le launcher.
- **Optimisation:** Les icônes sont générées en format PNG optimisé.
- **Cohérence:** Garantit que toutes les tailles sont générées depuis la même source.

**Documentation officielle:** https://pub.dev/packages/flutter_launcher_icons

---

### flutter_native_splash ^2.4.7

**Version utilisée:** `^2.4.7` (dev_dependencies)

**Objectif:**
Package qui génère des splash screens natifs (écrans de chargement initial) pour Android et iOS, s'affichant instantanément pendant que Flutter s'initialise.

**Configuration dans MedicApp:**

**`pubspec.yaml`:**
```yaml
flutter_native_splash:
  color: "#419e69"  # Couleur de fond (vert MedicApp)
  image: assets/images/icon.png  # Image centrale
  android: true
  ios: true
  fullscreen: true
  android_12:
    image: assets/images/icon.png
    color: "#419e69"
```

**Caractéristiques implémentées:**

1. **Splash unifié:** Même apparence sur Android et iOS.
2. **Couleur de marque:** Vert `#419e69` (couleur primaire de MedicApp).
3. **Logo centré:** Icône de MedicApp au centre de l'écran.
4. **Plein écran:** Cache la barre d'état pendant le splash.
5. **Android 12+ spécifique:** Configuration spéciale pour respecter le nouveau système de splash d'Android 12.

**Fichiers générés:**

**Android:**
- `android/app/src/main/res/drawable/launch_background.xml`
- `android/app/src/main/res/values/styles.xml` (thème de splash)
- `android/app/src/main/res/values-night/styles.xml` (thème sombre)

**iOS:**
- `ios/Runner/Assets.xcassets/LaunchImage.imageset/`
- `ios/Runner/Base.lproj/LaunchScreen.storyboard`

**Commande de génération:**

```bash
flutter pub run flutter_native_splash:create
```

**Pourquoi splash natif:**

- **UX professionnelle:** Évite écran blanc pendant 1-2 secondes d'initialisation de Flutter.
- **Branding immédiat:** Montre logo et couleurs de marque depuis la première frame.
- **Perception de vitesse:** Splash avec branding semble plus rapide qu'écran blanc.

**Documentation officielle:** https://pub.dev/packages/flutter_native_splash

---

### uuid ^4.0.0

**Version utilisée:** `^4.0.0`

**Objectif:**
Générateur d'UUIDs (Universally Unique Identifiers) v4 pour créer des identifiants uniques de médicaments, personnes et enregistrements de doses.

**Utilisation dans MedicApp:**

```dart
import 'package:uuid/uuid.dart';

const uuid = Uuid();

final medication = Medication(
  id: uuid.v4(), // Génère: "f47ac10b-58cc-4372-a567-0e02b2c3d479"
  name: 'Ibuprofène',
  type: MedicationType.pill,
);
```

**Pourquoi UUIDs:**

- **Unicité globale:** Probabilité de collision: 1 sur 10³⁸ (pratiquement impossible).
- **Génération hors ligne:** Ne nécessite pas coordination avec serveur ou séquences de base de données.
- **Synchronisation future:** Si MedicApp ajoute synchronisation cloud, les UUIDs évitent conflits d'IDs.
- **Debugging:** IDs descriptifs dans les logs au lieu d'entiers génériques (1, 2, 3).

**Alternative considérée:**

- **Auto-increment entier:** Écarté car nécessiterait gestion de séquences dans SQLite et pourrait causer conflits dans future synchronisation.

**Documentation officielle:** https://pub.dev/packages/uuid

---

## 10. Dépendances de Plateforme

### Android

**Configuration de build:**

**`android/app/build.gradle.kts`:**
```kotlin
android {
    namespace = "com.medicapp.medicapp"
    compileSdk = 34
    minSdk = 21  // Android 5.0 Lollipop
    targetSdk = 34  // Android 14

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true  // Pour APIs modernes sur Android < 26
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```

**Outils:**

- **Gradle 8.0+:** Système de build d'Android.
- **Kotlin 1.9.0:** Langage pour code natif Android (bien que MedicApp n'utilise pas de code Kotlin custom).
- **AndroidX:** Bibliothèques de support modernes (remplacement de Support Library).

**Versions minimales:**

- **minSdk 21 (Android 5.0 Lollipop):** Couverture de 99%+ d'appareils Android actifs.
- **targetSdk 34 (Android 14):** Dernière version d'Android pour profiter de caractéristiques modernes.

**Permissions requises:**

**`android/app/src/main/AndroidManifest.xml`:**
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" /> <!-- Android 13+ -->
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" /> <!-- Notifications exactes -->
<uses-permission android:name="android.permission.USE_EXACT_ALARM" /> <!-- Android 14+ -->
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" /> <!-- Reprogrammer notifications après redémarrage -->
```

**Documentation officielle:** https://developer.android.com

---

### iOS

**Configuration de build:**

**`ios/Runner/Info.plist`:**
```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>

<key>NSUserNotificationsUsageDescription</key>
<string>MedicApp a besoin d'envoyer des notifications pour vous rappeler de prendre vos médicaments.</string>
```

**Outils:**

- **CocoaPods 1.11+:** Gestionnaire de dépendances natives iOS.
- **Xcode 14+:** IDE requis pour compiler apps iOS.
- **Swift 5.0:** Langage pour code natif iOS (bien que MedicApp utilise AppDelegate par défaut).

**Versions minimales:**

- **iOS 12.0+:** Couverture de 98%+ d'appareils iOS actifs.
- **iPadOS 12.0+:** Support complet pour iPad.

**Capacités requises:**

- **Push Notifications:** Bien que MedicApp utilise notifications locales, cette capacité active le framework de notifications.
- **Background Fetch:** Permet mettre à jour notifications quand l'app est en arrière-plan.

**Documentation officielle:** https://developer.apple.com/documentation/

---

## 11. Versions et Compatibilité

### Tableau de Dépendances

| Dépendance | Version | Objectif | Catégorie |
|-------------|---------|-----------|-----------|
| **Flutter SDK** | `3.9.2+` | Framework principal | Core |
| **Dart SDK** | `3.9.2+` | Langage de programmation | Core |
| **cupertino_icons** | `^1.0.8` | Icônes iOS | UI |
| **sqflite** | `^2.3.0` | Base de données SQLite | Persistance |
| **path** | `^1.8.3` | Manipulation de chemins | Utilitaire |
| **flutter_local_notifications** | `^19.5.0` | Notifications locales | Notifications |
| **timezone** | `^0.10.1` | Fuseaux horaires | Notifications |
| **intl** | `^0.20.2` | Internationalisation | i18n |
| **android_intent_plus** | `^6.0.0` | Intentions Android | Permissions |
| **shared_preferences** | `^2.2.2` | Préférences utilisateur | Persistance |
| **file_picker** | `^8.0.0+1` | Sélecteur de fichiers | Fichiers |
| **share_plus** | `^10.1.4` | Partager fichiers | Fichiers |
| **path_provider** | `^2.1.5` | Répertoires du système | Persistance |
| **uuid** | `^4.0.0` | Générateur d'UUIDs | Utilitaire |
| **sqflite_common_ffi** | `^2.3.0` | Testing de SQLite | Testing (dev) |
| **flutter_launcher_icons** | `^0.14.4` | Génération d'icônes | Outil (dev) |
| **flutter_native_splash** | `^2.4.7` | Splash screen | Outil (dev) |
| **flutter_lints** | `^6.0.0` | Analyse statique | Outil (dev) |

**Total dépendances de production:** 14
**Total dépendances de développement:** 4
**Total:** 18

---

### Compatibilité de Plateformes

| Plateforme | Version minimale | Version cible | Couverture |
|------------|----------------|------------------|-----------|
| **Android** | 5.0 (API 21) | 14 (API 34) | 99%+ appareils |
| **iOS** | 12.0 | 17.0 | 98%+ appareils |
| **iPadOS** | 12.0 | 17.0 | 98%+ appareils |

**Non supporté:** Web, Windows, macOS, Linux (MedicApp est exclusivement mobile par design).

---

### Compatibilité de Flutter

| Flutter | Compatible | Notes |
|---------|------------|-------|
| 3.9.2 - 3.10.x | ✅ | Version de développement |
| 3.11.x - 3.19.x | ✅ | Compatible sans changements |
| 3.20.x - 3.35.x | ✅ | Testé jusqu'à 3.35.7 |
| 3.36.x+ | ⚠️ | Probablement compatible, non testé |
| 4.0.x | ❌ | Nécessite mise à jour de dépendances |

---

## 12. Comparatifs et Décisions

### 12.1. Base de Données: SQLite vs Hive vs Isar vs Drift

**Décision:** SQLite (sqflite)

**Justification étendue:**

**Exigences de MedicApp:**

1. **Relations N:M (Plusieurs à Plusieurs):** Un médicament peut être assigné à plusieurs personnes, et une personne peut avoir plusieurs médicaments. Cette architecture est native en SQL mais complexe en NoSQL.

2. **Requêtes complexes:** Obtenir tous les médicaments d'une personne avec leurs configurations personnalisées nécessite des JOINs entre 3 tables:

```sql
SELECT m.*, pm.custom_times, pm.custom_doses
FROM medications m
JOIN person_medications pm ON m.id = pm.medication_id
JOIN persons p ON pm.person_id = p.id
WHERE p.id = ?
```

Ceci est trivial en SQL mais nécessiterait plusieurs requêtes et logique manuelle en NoSQL.

3. **Migrations complexes:** MedicApp a évolué depuis V1 (table simple de médicaments) jusqu'à V19+ (multi-personne avec relations). SQLite permet des migrations SQL incrémentales qui préservent les données:

```sql
-- Migration V18 -> V19: Ajouter multi-personne
ALTER TABLE medications ADD COLUMN shared_stock REAL;
CREATE TABLE persons (...);
CREATE TABLE person_medications (...);
INSERT INTO persons (id, name, is_default) VALUES (?, 'Moi', 1);
INSERT INTO person_medications SELECT ?, id, times, doses FROM medications;
```

**Hive:**

- ✅ **Avantages:** Performance excellente, API simple, taille compacte.
- ❌ **Inconvénients:**
  - **Sans relations natives:** Implémenter N:M nécessite maintenir des listes d'IDs manuellement et faire plusieurs requêtes.
  - **Sans transactions ACID complètes:** Ne peut garantir atomicité dans opérations complexes (enregistrement de dose + déduction de stock + notification).
  - **Migrations manuelles:** Pas de système de versionnage de schéma, nécessite logique custom.
  - **Debugging difficile:** Format binaire propriétaire, ne peut être inspecté avec outils standards.

**Isar:**

- ✅ **Avantages:** Performance supérieure, indexation rapide, syntaxe Dart élégante.
- ❌ **Inconvénients:**
  - **Immaturité:** Lancé en 2022, moins battle-tested que SQLite (20+ ans).
  - **Relations limitées:** Supporte relations mais pas aussi flexibles que SQL JOINs (limité à 1:1, 1:N, sans M:N direct).
  - **Format propriétaire:** Similaire à Hive, complique debugging avec outils externes.
  - **Lock-in:** Migrer d'Isar vers autre solution serait coûteux.

**Drift:**

- ✅ **Avantages:** Type-safe SQL, migrations automatiques, APIs générées.
- ❌ **Inconvénients:**
  - **Complexité:** Nécessite génération de code, fichiers `.drift`, et configuration complexe de build_runner.
  - **Boilerplate:** Même opérations simples nécessitent définir tables dans fichiers séparés.
  - **Taille:** Augmente taille de l'APK d'~200KB vs sqflite direct.
  - **Flexibilité réduite:** Requêtes complexes ad-hoc sont plus difficiles qu'en SQL direct.

**Résultat final:**

Pour MedicApp, où les relations N:M sont fondamentales, les migrations ont été fréquentes (19 versions de schéma), et la capacité de debugging avec DB Browser for SQLite a été inestimable pendant le développement, SQLite est le choix correct.

**Compromis accepté:**
Nous sacrifions ~10-15% de performance dans les opérations massives (non pertinent pour les cas d'usage de MedicApp) en échange de flexibilité SQL complète, outils matures et architecture de données robuste.

---

### 12.2. Notifications: flutter_local_notifications vs awesome_notifications vs Firebase

**Décision:** flutter_local_notifications

**Justification étendue:**

**Exigences de MedicApp:**

1. **Précision temporelle:** Les notifications doivent arriver exactement à l'heure programmée (08:00:00, pas 08:00:30).
2. **Fonctionnement hors ligne:** Les médicaments se prennent indépendamment de la connexion internet.
3. **Confidentialité:** Les données médicales ne doivent jamais sortir de l'appareil.
4. **Scheduling à long terme:** Notifications programmées pour mois futurs.

**flutter_local_notifications:**

- ✅ **Scheduling précis:** `zonedSchedule` avec `androidScheduleMode: exactAllowWhileIdle` garantit livraison exacte même avec Doze Mode.
- ✅ **Totalement hors ligne:** Notifications programmées localement, sans dépendance de serveur.
- ✅ **Confidentialité totale:** Aucune donnée ne sort de l'appareil.
- ✅ **Maturité:** 5+ ans, 3000+ étoiles, utilisé en production par milliers d'apps médicales.
- ✅ **Documentation:** Exemples exhaustifs pour tous les cas d'usage.

**awesome_notifications:**

- ✅ **Avantages:** UI de notifications plus personnalisable, animations, boutons avec icônes.
- ❌ **Inconvénients:**
  - **Moins mature:** 2+ ans vs 5+ de flutter_local_notifications.
  - **Problèmes rapportés:** Issues avec notifications programmées sur Android 12+ (conflits WorkManager).
  - **Complexité inutile:** MedicApp ne nécessite pas notifications super personnalisées.
  - **Adoption moindre:** ~1500 étoiles vs 3000+ de flutter_local_notifications.

**Firebase Cloud Messaging (FCM):**

- ✅ **Avantages:** Notifications illimitées, analytics, segmentation d'utilisateurs.
- ❌ **Inconvénients:**
  - **Nécessite serveur:** Nécessiterait backend pour envoyer notifications, augmentant complexité et coût.
  - **Nécessite connexion:** Notifications n'arrivent pas si l'appareil est hors ligne.
  - **Confidentialité:** Données (horaires de médication, noms de médicaments) seraient envoyées à Firebase.
  - **Latence:** Dépend du réseau, ne garantit pas livraison exacte à l'heure programmée.
  - **Scheduling limité:** FCM ne supporte pas scheduling précis, seulement livraison "approximative" avec delay.
  - **Complexité:** Nécessite configurer projet Firebase, implémenter serveur, gérer tokens.

**Architecture correcte pour applications médicales locales:**

Pour apps comme MedicApp (gestion personnelle, sans collaboration multi-utilisateur, sans backend), les notifications locales sont architecturalement supérieures aux notifications distantes:

- **Fiabilité:** Ne dépendent pas de connexion internet ou disponibilité de serveur.
- **Confidentialité:** RGPD et réglementations médicales compliant par design (données ne sortent jamais de l'appareil).
- **Simplicité:** Zero configuration de backend, zero coûts de serveur.
- **Précision:** Garantie de livraison exacte à la seconde.

**Résultat final:**

`flutter_local_notifications` est le choix évident et correct pour MedicApp. awesome_notifications serait sur-ingénierie pour UI dont nous n'avons pas besoin, et FCM serait architecturalement incorrect pour une application complètement locale.

---

### 12.3. Gestion d'État: Vanilla Flutter vs Provider vs BLoC vs Riverpod

**Décision:** Vanilla Flutter (sans bibliothèque de gestion d'état)

**Justification étendue:**

**Architecture de MedicApp:**

```
┌─────────────┐
│  Screens    │ (StatefulWidget + setState)
└─────┬───────┘
      │ query()
      ↓
┌─────────────┐
│ DatabaseHelper │ (SQLite - Single Source of Truth)
└─────────────┘
```

Dans MedicApp, **la base de données EST l'état**. Il n'y a pas d'état significatif en mémoire qui doive être partagé entre widgets.

**Pattern typique d'écran:**

```dart
class MedicationListScreen extends StatefulWidget {
  @override
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  List<Medication> _medications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  Future<void> _loadMedications() async {
    final medications = await DatabaseHelper.instance.getMedications();
    setState(() {
      _medications = medications;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return CircularProgressIndicator();

    return ListView.builder(
      itemCount: _medications.length,
      itemBuilder: (context, index) {
        return MedicationCard(medication: _medications[index]);
      },
    );
  }
}
```

**Pourquoi Provider serait inutile:**

Provider est conçu pour **partager l'état entre widgets distants dans l'arbre**. Exemple classique:

```dart
// Avec Provider (inutile dans MedicApp)
ChangeNotifierProvider(
  create: (_) => MedicationProvider(),
  child: MaterialApp(
    home: HomeScreen(),
  ),
)

// HomeScreen peut accéder à MedicationProvider
Provider.of<MedicationProvider>(context).medications

// DetailScreen peut aussi accéder à MedicationProvider
Provider.of<MedicationProvider>(context).addDose(...)
```

**Problème:** Dans MedicApp, les écrans N'ont PAS besoin de partager l'état en mémoire. Chaque écran interroge la base de données directement:

```dart
// Écran 1: Liste de médicaments
final medications = await db.getMedications();

// Écran 2: Détail de médicament
final medication = await db.getMedication(id);

// Écran 3: Historique de doses
final history = await db.getDoseHistory(medicationId);
```

Toutes obtiennent des données directement de SQLite, qui est la seule source de vérité. Pas besoin de `ChangeNotifier`, `MultiProvider`, ni propagation d'état.

**Pourquoi BLoC serait sur-ingénierie:**

BLoC (Business Logic Component) est conçu pour applications d'entreprise avec **logique métier complexe** qui doit être **séparée de l'UI** et **testée indépendamment**.

Exemple d'architecture BLoC:

```dart
// medication_bloc.dart
class MedicationBloc extends Bloc<MedicationEvent, MedicationState> {
  final MedicationRepository repository;

  MedicationBloc(this.repository) : super(MedicationInitial()) {
    on<LoadMedications>(_onLoadMedications);
    on<AddMedication>(_onAddMedication);
    on<DeleteMedication>(_onDeleteMedication);
  }

  Future<void> _onLoadMedications(event, emit) async {
    emit(MedicationLoading());
    try {
      final medications = await repository.getMedications();
      emit(MedicationLoaded(medications));
    } catch (e) {
      emit(MedicationError(e.toString()));
    }
  }
  // ... plus d'événements
}

// medication_event.dart (événements séparés)
// medication_state.dart (états séparés)
// medication_repository.dart (couche de données)
```

**Problème:** Ceci ajoute **4-5 fichiers** par feature et centaines de lignes de boilerplate pour implémenter ce qui en Vanilla Flutter est:

```dart
final medications = await DatabaseHelper.instance.getMedications();
setState(() {
  _medications = medications;
});
```

**Pour MedicApp:**

- **Logique métier simple:** Calculs de stock (soustraction), calculs de dates (comparaison), formatage de chaînes.
- **Sans règles métier complexes:** Pas de validations de cartes de crédit, calculs financiers, authentification OAuth, etc.
- **Testing direct:** Les services (DatabaseHelper, NotificationService) se testent directement sans besoin de mocks de BLoC.

**Pourquoi Riverpod serait inutile:**

Riverpod est une évolution de Provider qui résout certains problèmes (compile-time safety, ne dépend pas de BuildContext), mais reste inutile pour MedicApp pour les mêmes raisons que Provider.

**Cas où on aurait BESOIN de gestion d'état:**

1. **Application avec authentification:** État d'utilisateur/session partagé entre tous les écrans.
2. **Panier d'achat:** État d'articles sélectionnés partagé entre produits, panier, checkout.
3. **Chat en temps réel:** Messages entrants qui doivent mettre à jour plusieurs écrans simultanément.
4. **Application collaborative:** Plusieurs utilisateurs éditant le même document en temps réel.

**MedicApp N'a AUCUN de ces cas.**

**Résultat final:**

Pour MedicApp, `StatefulWidget + setState + Database as Source of Truth` est l'architecture correcte. C'est simple, direct, facile à comprendre pour tout développeur Flutter, et n'introduit pas de complexité inutile.

Ajouter Provider, BLoC ou Riverpod serait purement **cargo cult programming** (utiliser technologie parce qu'elle est populaire, pas parce qu'elle résout un problème réel).

---

## Conclusion

MedicApp utilise un stack technologique **simple, robuste et approprié** pour une application médicale locale multiplateforme:

- **Flutter + Dart:** Multiplateforme avec performance native.
- **SQLite:** Base de données relationnelle mature avec transactions ACID.
- **Notifications locales:** Confidentialité totale et fonctionnement hors ligne.
- **Localisation ARB:** 8 langues avec pluralisation Unicode CLDR.
- **Vanilla Flutter:** Sans gestion d'état inutile.
- **432+ tests:** Couverture de 75-80% avec tests unitaires, de widget et d'intégration.

Chaque décision technologique est **justifiée par exigences réelles**, pas par hype ou tendances. Le résultat est une application maintenable, fiable et qui fait exactement ce qu'elle promet sans complexité artificielle.

**Principe directeur:** *"Simplicité quand c'est possible, complexité quand c'est nécessaire."*
