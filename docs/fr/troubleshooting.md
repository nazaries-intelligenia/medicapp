# Guide de Résolution de Problèmes

## Introduction

### Objectif du Document

Ce guide fournit des solutions aux problèmes courants qui peuvent survenir pendant le développement, la compilation et l'utilisation de MedicApp. Il est conçu pour aider les développeurs et utilisateurs à résoudre les problèmes rapidement et efficacement.

### Comment Utiliser Ce Guide

1. Identifiez la catégorie de votre problème dans l'index
2. Lisez la description du problème pour confirmer qu'elle correspond à votre situation
3. Suivez les étapes de solution dans l'ordre
4. Si le problème persiste, consultez la section "Obtenir de l'Aide"

---

## Problèmes d'Installation

### Flutter SDK Non Trouvé

**Description**: Lors de l'exécution de commandes Flutter, l'erreur "flutter: command not found" apparaît.

**Cause Probable**: Flutter n'est pas installé ou n'est pas dans le PATH du système.

**Solution**:

1. Vérifiez si Flutter est installé:
```bash
which flutter
```

2. Si non installé, téléchargez Flutter depuis [flutter.dev](https://flutter.dev)

3. Ajoutez Flutter au PATH:
```bash
# Dans ~/.bashrc, ~/.zshrc, ou similaire
export PATH="$PATH:/path/to/flutter/bin"
```

4. Redémarrez votre terminal et vérifiez:
```bash
flutter --version
```

**Références**: [Documentation d'installation de Flutter](https://docs.flutter.dev/get-started/install)

---

### Version Incorrecte de Flutter

**Description**: La version de Flutter installée ne répond pas aux exigences du projet.

**Cause Probable**: MedicApp nécessite Flutter 3.24.5 ou supérieur.

**Solution**:

1. Vérifiez votre version actuelle:
```bash
flutter --version
```

2. Mettez à jour Flutter:
```bash
flutter upgrade
```

3. Si vous avez besoin d'une version spécifique, utilisez FVM:
```bash
dart pub global activate fvm
fvm install 3.24.5
fvm use 3.24.5
```

4. Vérifiez la version après mise à jour:
```bash
flutter --version
```

---

### Problèmes avec flutter pub get

**Description**: Erreur lors du téléchargement des dépendances avec `flutter pub get`.

**Cause Probable**: Problèmes de réseau, cache corrompu ou conflits de versions.

**Solution**:

1. Nettoyez le cache de pub:
```bash
flutter pub cache repair
```

2. Supprimez le fichier pubspec.lock:
```bash
rm pubspec.lock
```

3. Réessayez:
```bash
flutter pub get
```

4. Si cela persiste, vérifiez la connexion internet et le proxy:
```bash
# Configurez le proxy si nécessaire
export HTTP_PROXY=http://proxy.example.com:8080
export HTTPS_PROXY=http://proxy.example.com:8080
```

---

### Problèmes avec CocoaPods (iOS)

**Description**: Erreurs liées à CocoaPods pendant la compilation iOS.

**Cause Probable**: CocoaPods obsolète ou cache corrompu.

**Solution**:

1. Mettez à jour CocoaPods:
```bash
sudo gem install cocoapods
```

2. Nettoyez le cache des pods:
```bash
cd ios
rm -rf Pods Podfile.lock
pod cache clean --all
```

3. Réinstallez les pods:
```bash
pod install --repo-update
```

4. Si cela persiste, mettez à jour le dépôt de specs:
```bash
pod repo update
```

**Références**: [CocoaPods Guides](https://guides.cocoapods.org/using/troubleshooting.html)

---

### Problèmes avec Gradle (Android)

**Description**: Erreurs de compilation liées à Gradle sur Android.

**Cause Probable**: Cache de Gradle corrompu ou configuration incorrecte.

**Solution**:

1. Nettoyez le projet:
```bash
cd android
./gradlew clean
```

2. Nettoyez le cache de Gradle:
```bash
./gradlew cleanBuildCache
rm -rf ~/.gradle/caches/
```

3. Synchronisez le projet:
```bash
./gradlew --refresh-dependencies
```

4. Invalidez le cache dans Android Studio:
   - File > Invalidate Caches / Restart

---

## Problèmes de Compilation

### Erreurs de Dépendances

**Description**: Conflits entre versions de packages ou dépendances manquantes.

**Cause Probable**: Versions incompatibles dans pubspec.yaml ou dépendances transitives en conflit.

**Solution**:

1. Vérifiez le fichier pubspec.yaml pour restrictions de version conflictuelles

2. Utilisez la commande d'analyse de dépendances:
```bash
flutter pub deps
```

3. Résolvez les conflits en spécifiant des versions compatibles:
```yaml
dependency_overrides:
  conflicting_package: ^1.0.0
```

4. Mettez à jour toutes les dépendances vers des versions compatibles:
```bash
flutter pub upgrade --major-versions
```

---

### Conflits de Versions

**Description**: Deux ou plusieurs packages nécessitent des versions incompatibles d'une dépendance commune.

**Cause Probable**: Restrictions de version très strictes dans les dépendances.

**Solution**:

1. Identifiez le conflit:
```bash
flutter pub deps | grep "✗"
```

2. Utilisez `dependency_overrides` temporairement:
```yaml
dependency_overrides:
  shared_dependency: ^2.0.0
```

3. Rapportez le conflit aux mainteneurs des packages

4. En dernier recours, considérez des alternatives aux packages conflictuels

---

### Erreurs de Génération de l10n

**Description**: Échecs lors de la génération des fichiers de localisation.

**Cause Probable**: Erreurs de syntaxe dans les fichiers .arb ou configuration incorrecte.

**Solution**:

1. Vérifiez la syntaxe des fichiers .arb dans `lib/l10n/`:
   - Assurez-vous qu'ils soient du JSON valide
   - Vérifiez que les placeholders soient cohérents

2. Nettoyez et régénérez:
```bash
flutter clean
flutter pub get
flutter gen-l10n
```

3. Vérifiez la configuration dans pubspec.yaml:
```yaml
flutter:
  generate: true
```

4. Révisez `l10n.yaml` pour configuration correcte

**Références**: [Internationalisation dans Flutter](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)

---

### Build Échoué sur Android

**Description**: La compilation Android échoue avec diverses erreurs.

**Cause Probable**: Configuration de Gradle, version de SDK ou problèmes de permissions.

**Solution**:

1. Vérifiez la version de Java (nécessite Java 17):
```bash
java -version
```

2. Nettoyez complètement le projet:
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
```

3. Vérifiez les configurations dans `android/app/build.gradle`:
   - `compileSdkVersion`: 34
   - `minSdkVersion`: 23
   - `targetSdkVersion`: 34

4. Compilez avec information détaillée:
```bash
flutter build apk --verbose
```

5. Si l'erreur mentionne des permissions, vérifiez `android/app/src/main/AndroidManifest.xml`

---

### Build Échoué sur iOS

**Description**: La compilation iOS échoue ou ne peut pas signer l'app.

**Cause Probable**: Certificats, profils de provisionnement ou configuration de Xcode.

**Solution**:

1. Ouvrez le projet dans Xcode:
```bash
open ios/Runner.xcworkspace
```

2. Vérifiez la configuration de signature:
   - Sélectionnez le projet Runner
   - Dans "Signing & Capabilities", vérifiez le Team et Bundle Identifier

3. Nettoyez le build de Xcode:
   - Product > Clean Build Folder (Shift + Cmd + K)

4. Mettez à jour les pods:
```bash
cd ios
pod deintegrate
pod install
cd ..
```

5. Compilez depuis le terminal:
```bash
flutter build ios --verbose
```

---

## Problèmes avec Base de Données

### Database is Locked

**Description**: Erreur "database is locked" lors de tentatives d'opérations de base de données.

**Cause Probable**: Plusieurs connexions tentant d'écrire simultanément ou transaction non fermée.

**Solution**:

1. Assurez-vous de fermer toutes les connexions correctement dans le code

2. Vérifiez qu'il n'y ait pas de transactions ouvertes sans commit/rollback

3. Redémarrez complètement l'application

4. En dernier recours, supprimez la base de données:
```bash
# Android
adb shell run-as com.medicapp.app rm -r /data/data/com.medicapp.app/databases/

# iOS - depuis Xcode, supprimez le conteneur de l'app
```

**Références**: Consultez `lib/core/database/database_helper.dart` pour la gestion de transactions.

---

### Erreurs de Migration

**Description**: Échecs lors de la mise à jour du schéma de la base de données.

**Cause Probable**: Script de migration incorrect ou version de base de données incohérente.

**Solution**:

1. Révisez les scripts de migration dans `DatabaseHelper`

2. Vérifiez la version actuelle de la base de données:
```dart
final db = await DatabaseHelper.instance.database;
print('Database version: ${await db.getVersion()}');
```

3. Si c'est du développement, réinitialisez la base de données:
   - Désinstallez l'app
   - Réinstallez

4. Pour la production, créez un script de migration qui gère le cas spécifique

5. Utilisez l'écran de debug de l'app pour vérifier l'état de la BD

---

### Les Données Ne Persistent Pas

**Description**: Les données saisies disparaissent après fermeture de l'app.

**Cause Probable**: Les opérations de base de données ne se terminent pas ou échouent silencieusement.

**Solution**:

1. Activez les logs de base de données en mode debug

2. Vérifiez que les opérations d'insert/update retournent succès:
```dart
final id = await db.insert('medications', medication.toMap());
print('Inserted medication with id: $id');
```

3. Assurez-vous qu'il n'y ait pas d'exceptions silencieuses

4. Vérifiez les permissions d'écriture sur l'appareil

5. Vérifiez que `await` soit présent dans toutes les opérations async

---

### Corruption de Base de Données

**Description**: Erreurs lors de l'ouverture de la base de données ou données incohérentes.

**Cause Probable**: Fermeture inattendue de l'app pendant écriture ou problème du système de fichiers.

**Solution**:

1. Essayez de réparer la base de données en utilisant la commande sqlite3 (nécessite accès root):
```bash
sqlite3 /path/to/database.db "PRAGMA integrity_check;"
```

2. Si elle est corrompue, restaurez depuis une sauvegarde si elle existe

3. Si pas de sauvegarde, réinitialisez la base de données:
   - Désinstallez l'app
   - Réinstallez
   - Les données seront perdues

4. **Prévention**: Implémentez des sauvegardes automatiques périodiques

---

### Comment Réinitialiser Base de Données

**Description**: Besoin de supprimer complètement la base de données pour recommencer à zéro.

**Cause Probable**: Développement, testing ou résolution de problèmes.

**Solution**:

**Option 1 - Depuis l'App (Development)**:
```dart
// Dans l'écran de debug
await DatabaseHelper.instance.deleteDatabase();
```

**Option 2 - Android**:
```bash
adb shell run-as com.medicapp.app rm /data/data/com.medicapp.app/databases/medicapp.db
```

**Option 3 - iOS**:
- Désinstallez l'app depuis l'appareil/simulateur
- Réinstallez

**Option 4 - Les Deux Plateformes**:
```bash
flutter clean
# Désinstallez manuellement depuis l'appareil
flutter run
```

---

## Problèmes avec Notifications

### Les Notifications N'Apparaissent Pas

**Description**: Les notifications programmées ne s'affichent pas.

**Cause Probable**: Permissions non accordées, notifications désactivées ou erreur dans la programmation.

**Solution**:

1. Vérifiez les permissions de notifications:
   - Android 13+: Doit demander `POST_NOTIFICATIONS`
   - iOS: Doit demander autorisation au premier démarrage

2. Vérifiez la configuration de l'appareil:
   - Android: Configuration > Apps > MedicApp > Notifications
   - iOS: Réglages > Notifications > MedicApp

3. Vérifiez que les notifications soient programmées:
```dart
final pendingNotifications = await flutterLocalNotificationsPlugin
    .pendingNotificationRequests();
print('Pending notifications: ${pendingNotifications.length}');
```

4. Consultez les logs pour erreurs de programmation

5. Utilisez l'écran de debug de l'app pour voir notifications programmées

---

### Permissions Refusées (Android 13+)

**Description**: Sur Android 13+, les notifications ne fonctionnent pas bien que l'app les demande.

**Cause Probable**: La permission `POST_NOTIFICATIONS` a été refusée par l'utilisateur.

**Solution**:

1. Vérifiez que la permission soit déclarée dans `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

2. L'app doit demander la permission à l'exécution

3. Si l'utilisateur l'a refusée, guidez-le vers la configuration:
```dart
await openAppSettings();
```

4. Expliquez à l'utilisateur pourquoi les notifications sont essentielles pour l'app

5. N'assumez pas que la permission est accordée; vérifiez toujours avant de programmer

---

### Les Alarmes Exactes Ne Fonctionnent Pas

**Description**: Les notifications n'apparaissent pas au moment exact programmé.

**Cause Probable**: Manque permission `SCHEDULE_EXACT_ALARM` ou restrictions de batterie.

**Solution**:

1. Vérifiez les permissions dans `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
```

2. Pour Android 12+, demandez la permission:
```dart
if (await Permission.scheduleExactAlarm.isDenied) {
  await Permission.scheduleExactAlarm.request();
}
```

3. Désactivez l'optimisation de batterie pour l'app:
   - Configuration > Batterie > Optimisation de batterie
   - Cherchez MedicApp et sélectionnez "Ne pas optimiser"

4. Vérifiez que vous utilisez `androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle`

---

### Les Notifications Ne Sonnent Pas

**Description**: Les notifications apparaissent mais sans son.

**Cause Probable**: Canal de notification sans son ou mode silencieux de l'appareil.

**Solution**:

1. Vérifiez la configuration du canal de notification:
```dart
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'medication_reminders',
  'Rappels de Médicaments',
  importance: Importance.high,
  sound: RawResourceAndroidNotificationSound('notification_sound'),
);
```

2. Assurez-vous que le fichier de son existe dans `android/app/src/main/res/raw/`

3. Vérifiez la configuration de l'appareil:
   - Android: Configuration > Apps > MedicApp > Notifications > Catégorie
   - iOS: Réglages > Notifications > MedicApp > Sons

4. Vérifiez que l'appareil ne soit pas en mode silencieux/ne pas déranger

---

### Notifications Après Redémarrage de l'Appareil

**Description**: Les notifications cessent de fonctionner après redémarrage de l'appareil.

**Cause Probable**: Les notifications programmées ne persistent pas après redémarrage.

**Solution**:

1. Ajoutez la permission `RECEIVE_BOOT_COMPLETED` dans `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

2. Implémentez un `BroadcastReceiver` pour reprogrammer les notifications:
```xml
<receiver android:name=".BootReceiver" android:enabled="true" android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
    </intent-filter>
</receiver>
```

3. Implémentez la logique pour reprogrammer toutes les notifications en attente

4. Sur iOS, les notifications locales persistent automatiquement

**Références**: Consultez `android/app/src/main/kotlin/.../MainActivity.kt`

---

## Problèmes de Performance

### App Lente en Mode Debug

**Description**: L'application a de mauvaises performances et est lente.

**Cause Probable**: Le mode debug inclut des outils de développement qui affectent la performance.

**Solution**:

1. **Ceci est normal en mode debug**. Pour évaluer la performance réelle, compilez en mode profile ou release:
```bash
flutter run --profile
# ou
flutter run --release
```

2. Utilisez Flutter DevTools pour identifier les goulots d'étranglement:
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

3. Vérifiez qu'il n'y ait pas de déclarations `print()` excessives dans les hot paths

4. N'évaluez jamais la performance en mode debug

---

### Consommation Excessive de Batterie

**Description**: L'application consomme beaucoup de batterie.

**Cause Probable**: Utilisation excessive de notifications, tâches en arrière-plan ou requêtes fréquentes.

**Solution**:

1. Réduisez la fréquence de vérifications en arrière-plan

2. Optimisez les requêtes à la base de données:
   - Utilisez des index appropriés
   - Évitez les requêtes inutiles
   - Mettez en cache les résultats quand c'est possible

3. Utilisez `WorkManager` au lieu d'alarmes fréquentes quand c'est approprié

4. Vérifiez l'utilisation de capteurs ou GPS (si applicable)

5. Profilez l'utilisation de batterie avec Android Studio:
   - View > Tool Windows > Energy Profiler

---

### Lag dans Listes Longues

**Description**: Le scroll dans les listes avec beaucoup d'éléments est lent ou saccadé.

**Cause Probable**: Rendu inefficace de widgets ou manque d'optimisation de ListView.

**Solution**:

1. Utilisez `ListView.builder` au lieu de `ListView`:
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

2. Implémentez des constructeurs `const` où c'est possible

3. Évitez les widgets lourds dans chaque item de la liste

4. Utilisez `RepaintBoundary` pour widgets complexes:
```dart
RepaintBoundary(
  child: ComplexWidget(),
)
```

5. Considérez la pagination pour listes très longues

6. Utilisez `AutomaticKeepAliveClientMixin` pour maintenir l'état des items

---

### Frames Sautées

**Description**: L'UI semble saccadée avec des frames perdues.

**Cause Probable**: Opérations coûteuses sur le thread principal.

**Solution**:

1. Identifiez le problème avec l'onglet Performance de Flutter DevTools

2. Déplacez les opérations coûteuses vers des isolates:
```dart
final result = await compute(expensiveFunction, data);
```

3. Évitez les opérations synchrones lourdes dans la méthode build

4. Utilisez `FutureBuilder` ou `StreamBuilder` pour opérations async

5. Optimisez les grandes images:
   - Utilisez des formats compressés
   - Mettez en cache les images décodées
   - Utilisez des miniatures pour aperçus

6. Vérifiez qu'il n'y ait pas d'animations avec listeners coûteux

---

## Problèmes d'UI/UX

### Le Texte Ne Se Traduit Pas

**Description**: Certains textes apparaissent en anglais ou autre langue incorrecte.

**Cause Probable**: Manque la chaîne dans le fichier .arb ou AppLocalizations n'est pas utilisé.

**Solution**:

1. Vérifiez que la chaîne existe dans `lib/l10n/app_es.arb`:
```json
{
  "yourKey": "Votre texte traduit"
}
```

2. Assurez-vous d'utiliser `AppLocalizations.of(context)`:
```dart
Text(AppLocalizations.of(context)!.yourKey)
```

3. Régénérez les fichiers de localisation:
```bash
flutter gen-l10n
```

4. Si vous avez ajouté une nouvelle clé, assurez-vous qu'elle existe dans tous les fichiers .arb

5. Vérifiez que la locale de l'appareil soit configurée correctement

---

### Couleurs Incorrectes

**Description**: Les couleurs ne correspondent pas au design ou thème attendu.

**Cause Probable**: Utilisation incorrecte du thème ou couleurs codées en dur.

**Solution**:

1. Utilisez toujours les couleurs du thème:
```dart
// Correct
color: Theme.of(context).colorScheme.primary

// Incorrect
color: Colors.blue
```

2. Vérifiez la définition du thème dans `lib/core/theme/app_theme.dart`

3. Assurez-vous que le MaterialApp ait le thème configuré:
```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  // ...
)
```

4. Pour debug, imprimez les couleurs actuelles:
```dart
print('Primary: ${Theme.of(context).colorScheme.primary}');
```

---

### Layout Cassé sur Petits Écrans

**Description**: L'UI déborde ou est mal affichée sur appareils avec petits écrans.

**Cause Probable**: Widgets avec tailles fixes ou manque de responsive design.

**Solution**:

1. Utilisez des widgets flexibles au lieu de tailles fixes:
```dart
// Au lieu de
Container(width: 300, child: ...)

// Utilisez
Expanded(child: ...)
// ou
Flexible(child: ...)
```

2. Utilisez `LayoutBuilder` pour layouts adaptatifs:
```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      return MobileLayout();
    } else {
      return TabletLayout();
    }
  },
)
```

3. Utilisez `MediaQuery` pour obtenir les dimensions:
```dart
final screenWidth = MediaQuery.of(context).size.width;
```

4. Testez sur différentes tailles d'écran en utilisant l'émulateur

---

### Débordement de Texte

**Description**: Le warning d'"overflow" apparaît avec des bandes jaunes et noires.

**Cause Probable**: Texte trop long pour l'espace disponible.

**Solution**:

1. Enveloppez le texte dans `Flexible` ou `Expanded`:
```dart
Flexible(
  child: Text('Texte long...'),
)
```

2. Utilisez `overflow` et `maxLines` dans le widget Text:
```dart
Text(
  'Texte long...',
  overflow: TextOverflow.ellipsis,
  maxLines: 2,
)
```

3. Pour textes très longs, utilisez `SingleChildScrollView`:
```dart
SingleChildScrollView(
  child: Text('Texte très long...'),
)
```

4. Considérez raccourcir le texte ou utiliser un format différent

---

## Problèmes Multi-Personne

### Le Stock Ne Se Partage Pas Correctement

**Description**: Plusieurs personnes peuvent créer des médicaments avec le même nom sans partager le stock.

**Cause Probable**: Logique de vérification de doublons par personne au lieu de globale.

**Solution**:

1. Vérifiez la fonction de recherche de médicaments existants dans `MedicationRepository`

2. Assurez-vous que la recherche soit globale:
```dart
// Rechercher par nom sans filtrer par personId
final existing = await db.query(
  'medications',
  where: 'name = ?',
  whereArgs: [name],
);
```

3. Lors de l'ajout d'une dose, associez la dose avec la personne mais pas le médicament

4. Consultez la logique dans `AddMedicationScreen` pour réutiliser les médicaments existants

---

### Médicaments Dupliqués

**Description**: Des médicaments dupliqués apparaissent dans la liste.

**Cause Probable**: Insertions multiples du même médicament ou manque de validation.

**Solution**:

1. Implémentez une vérification avant d'insérer:
```dart
final existing = await getMedicationByName(name);
if (existing != null) {
  return existing.id;
}
```

2. Utilisez des contraintes UNIQUE dans la base de données:
```sql
CREATE TABLE medications (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  -- ...
);
```

3. Consultez la logique de création de médicaments dans le repository

4. S'il existe déjà des doublons, créez un script de migration pour les consolider

---

### Historique de Doses Incorrect

**Description**: L'historique montre des doses d'autres personnes ou manque d'information.

**Cause Probable**: Filtrage incorrect par personne ou joins mal configurés.

**Solution**:

1. Vérifiez la requête qui obtient l'historique:
```dart
final doses = await db.query(
  'dose_history',
  where: 'personId = ?',
  whereArgs: [personId],
  orderBy: 'takenAt DESC',
);
```

2. Assurez-vous que toutes les doses aient `personId` associé

3. Consultez la logique de filtrage dans `DoseHistoryScreen`

4. Vérifiez que les joins entre tables incluent la condition de personne

---

### La Personne Par Défaut Ne Change Pas

**Description**: Lors du changement de personne active, l'UI ne se met pas à jour correctement.

**Cause Probable**: L'état ne se propage pas correctement ou manque rebuild.

**Solution**:

1. Vérifiez que vous utilisiez un état global (Provider, Bloc, etc.):
```dart
Provider.of<PersonProvider>(context, listen: true).currentPerson
```

2. Assurez-vous que le changement de personne déclenche `notifyListeners()`:
```dart
void setCurrentPerson(Person person) {
  _currentPerson = person;
  notifyListeners();
}
```

3. Vérifiez que les widgets pertinents écoutent les changements

4. Considérez utiliser `Consumer` pour rebuilds spécifiques:
```dart
Consumer<PersonProvider>(
  builder: (context, provider, child) {
    return Text(provider.currentPerson.name);
  },
)
```

---

## Problèmes avec Jeûne

### La Notification de Jeûne N'Apparaît Pas

**Description**: La notification ongoing de jeûne ne s'affiche pas.

**Cause Probable**: Permissions, configuration du canal ou erreur lors de la création de la notification.

**Solution**:

1. Vérifiez que le canal de notifications de jeûne soit créé:
```dart
const AndroidNotificationChannel fastingChannel = AndroidNotificationChannel(
  'fasting',
  'Jeûne',
  importance: Importance.low,
  enableVibration: false,
);
```

2. Assurez-vous d'utiliser `ongoing: true`:
```dart
const NotificationDetails(
  android: AndroidNotificationDetails(
    'fasting',
    'Jeûne',
    ongoing: true,
    autoCancel: false,
  ),
)
```

3. Vérifiez les permissions de notifications

4. Consultez les logs pour erreurs lors de la création de la notification

---

### Compte à Rebours Incorrect

**Description**: Le temps restant du jeûne n'est pas correct ou ne se met pas à jour.

**Cause Probable**: Calcul incorrect de temps ou manque de mise à jour périodique.

**Solution**:

1. Vérifiez le calcul de temps restant:
```dart
final remaining = endTime.difference(DateTime.now());
```

2. Assurez-vous de mettre à jour la notification périodiquement:
```dart
Timer.periodic(Duration(minutes: 1), (timer) {
  updateFastingNotification();
});
```

3. Vérifiez que le `endTime` du jeûne se stocke correctement

4. Utilisez l'écran de debug pour vérifier l'état du jeûne actuel

---

### Le Jeûne Ne S'Annule Pas Automatiquement

**Description**: La notification de jeûne reste après que le temps se termine.

**Cause Probable**: Manque logique pour annuler la notification à la fin.

**Solution**:

1. Implémentez une vérification quand le jeûne se termine:
```dart
if (DateTime.now().isAfter(fasting.endTime)) {
  await cancelFastingNotification();
  await markFastingAsCompleted(fasting.id);
}
```

2. Vérifiez quand l'app s'ouvre:
```dart
@override
void initState() {
  super.initState();
  checkActiveFastings();
}
```

3. Programmez une alarme pour quand le jeûne se termine qui annule la notification

4. Assurez-vous que la notification s'annule dans `onDidReceiveNotificationResponse`

**Références**: Consultez `lib/features/fasting/` pour l'implémentation.

---

## Problèmes de Testing

### Les Tests Échouent Localement

**Description**: Les tests qui passent en CI échouent sur votre machine locale.

**Cause Probable**: Différences d'environnement, dépendances ou configuration.

**Solution**:

1. Nettoyez et reconstruisez:
```bash
flutter clean
flutter pub get
```

2. Vérifiez que les versions soient les mêmes:
```bash
flutter --version
dart --version
```

3. Exécutez les tests avec plus d'information:
```bash
flutter test --verbose
```

4. Assurez-vous qu'il n'y ait pas de tests qui dépendent d'un état précédent

5. Vérifiez qu'il n'y ait pas de tests avec dépendances de temps (utilisez `fakeAsync`)

---

### Problèmes avec sqflite_common_ffi

**Description**: Les tests de base de données échouent avec des erreurs de sqflite.

**Cause Probable**: sqflite n'est pas disponible dans les tests, vous devez utiliser sqflite_common_ffi.

**Solution**:

1. Assurez-vous d'avoir la dépendance:
```yaml
dev_dependencies:
  sqflite_common_ffi: ^2.3.0
```

2. Initialisez dans le setup de tests:
```dart
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('database test', () async {
    // ...
  });
}
```

3. Utilisez des bases de données en mémoire pour les tests:
```dart
final db = await databaseFactoryFfi.openDatabase(
  inMemoryDatabasePath,
);
```

4. Nettoyez la base de données après chaque test

---

### Timeouts dans Tests

**Description**: Les tests échouent par timeout.

**Cause Probable**: Opérations lentes ou deadlocks dans tests async.

**Solution**:

1. Augmentez le timeout pour tests spécifiques:
```dart
test('slow test', () async {
  // ...
}, timeout: Timeout(Duration(seconds: 30)));
```

2. Vérifiez qu'il n'y ait pas d'`await` manquants

3. Utilisez `fakeAsync` pour tests avec delays:
```dart
testWidgets('timer test', (tester) async {
  await tester.runAsync(() async {
    // code de test avec delays
  });
});
```

4. Mocquez les opérations lentes comme appels réseau

5. Vérifiez qu'il n'y ait pas de boucles infinies ou conditions de course

---

### Tests Incohérents

**Description**: Les mêmes tests passent parfois et échouent parfois.

**Cause Probable**: Tests avec dépendances de temps, ordre d'exécution ou état partagé.

**Solution**:

1. Évitez de dépendre du temps réel, utilisez `fakeAsync` ou mocks

2. Assurez-vous que chaque test soit indépendant:
```dart
setUp(() {
  // Setup propre pour chaque test
});

tearDown(() {
  // Nettoyage après chaque test
});
```

3. Ne partagez pas d'état mutable entre tests

4. Utilisez `setUpAll` seulement pour setup immuable

5. Exécutez les tests en ordre aléatoire pour détecter les dépendances:
```bash
flutter test --test-randomize-ordering-seed=random
```

---

## Problèmes de Permissions

### POST_NOTIFICATIONS (Android 13+)

**Description**: Les notifications ne fonctionnent pas sur Android 13 ou supérieur.

**Cause Probable**: La permission POST_NOTIFICATIONS doit être demandée à l'exécution.

**Solution**:

1. Déclarez la permission dans `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

2. Demandez la permission à l'exécution:
```dart
if (Platform.isAndroid && await Permission.notification.isDenied) {
  final status = await Permission.notification.request();
  if (status.isDenied) {
    // Informer l'utilisateur et offrir d'aller à la configuration
  }
}
```

3. Vérifiez la permission avant de programmer des notifications

4. Guidez l'utilisateur vers la configuration si elle a été refusée définitivement

**Références**: [Android 13 Notification Permission](https://developer.android.com/about/versions/13/changes/notification-permission)

---

### SCHEDULE_EXACT_ALARM (Android 12+)

**Description**: Les alarmes exactes ne fonctionnent pas sur Android 12+.

**Cause Probable**: Nécessite permission spéciale depuis Android 12.

**Solution**:

1. Déclarez la permission:
```xml
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
```

2. Vérifiez et demandez si nécessaire:
```dart
if (Platform.isAndroid) {
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  if (androidInfo.version.sdkInt >= 31) {
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }
}
```

3. Expliquez à l'utilisateur pourquoi vous avez besoin d'alarmes exactes

4. Considérez utiliser `USE_EXACT_ALARM` si vous êtes une app d'alarme/rappel

---

### USE_EXACT_ALARM (Android 14+)

**Description**: Besoin d'alarmes exactes sans demander permission spéciale.

**Cause Probable**: Android 14 introduit USE_EXACT_ALARM pour apps d'alarme.

**Solution**:

1. Si votre app est principalement d'alarmes/rappels, utilisez:
```xml
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
```

2. C'est une alternative à `SCHEDULE_EXACT_ALARM` qui ne nécessite pas que l'utilisateur accorde la permission manuellement

3. Utilisez-la seulement si votre app remplit les [cas d'usage permis](https://developer.android.com/about/versions/14/changes/schedule-exact-alarms)

4. L'app doit avoir comme fonctionnalité principale les alarmes ou rappels

---

### Notifications en Arrière-Plan (iOS)

**Description**: Les notifications ne fonctionnent pas correctement sur iOS.

**Cause Probable**: Permissions non demandées ou configuration incorrecte.

**Solution**:

1. Demandez les permissions au démarrage de l'app:
```dart
final settings = await FirebaseMessaging.instance.requestPermission(
  alert: true,
  badge: true,
  sound: true,
);
```

2. Vérifiez `Info.plist`:
```xml
<key>UIBackgroundModes</key>
<array>
  <string>fetch</string>
  <string>remote-notification</string>
</array>
```

3. Assurez-vous d'avoir les capabilities corrects dans Xcode:
   - Push Notifications
   - Background Modes

4. Vérifiez que l'utilisateur n'ait pas désactivé les notifications dans Réglages

---

## Erreurs Courantes et Solutions

### MissingPluginException

**Description**: Erreur "MissingPluginException(No implementation found for method...)"

**Cause Probable**: Le plugin n'est pas enregistré correctement ou nécessite hot restart.

**Solution**:

1. Faites un hot restart complet (pas seulement hot reload):
```bash
# Dans le terminal où tourne l'app
r  # hot reload
R  # HOT RESTART (c'est celui dont vous avez besoin)
```

2. Si cela persiste, reconstruisez complètement:
```bash
flutter clean
flutter pub get
flutter run
```

3. Vérifiez que le plugin soit dans `pubspec.yaml`

4. Pour iOS, réinstallez les pods:
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
```

---

### PlatformException

**Description**: Erreur "PlatformException" avec différents codes.

**Cause Probable**: Dépend du code spécifique de l'erreur.

**Solution**:

1. Lisez le message d'erreur et code complets

2. Erreurs communes:
   - `permission_denied`: Vérifiez les permissions
   - `error`: Erreur générique, vérifiez les logs natifs
   - `not_available`: Fonction non disponible sur cette plateforme

3. Pour Android, vérifiez logcat:
```bash
adb logcat | grep -i flutter
```

4. Pour iOS, vérifiez la console de Xcode

5. Assurez-vous de gérer ces erreurs gracieusement:
```dart
try {
  await somePluginMethod();
} on PlatformException catch (e) {
  print('Error: ${e.code} - ${e.message}');
  // Gérer de manière appropriée
}
```

---

### DatabaseException

**Description**: Erreur lors de la réalisation d'opérations de base de données.

**Cause Probable**: Requête invalide, contrainte violée ou base de données corrompue.

**Solution**:

1. Lisez le message d'erreur complet pour identifier le problème

2. Erreurs communes:
   - `UNIQUE constraint failed`: Tentative d'insertion de doublon
   - `no such table`: Table n'existe pas, vérifiez les migrations
   - `syntax error`: Requête SQL invalide

3. Vérifiez la requête SQL:
```dart
try {
  await db.query('medications', where: 'id = ?', whereArgs: [id]);
} on DatabaseException catch (e) {
  print('Database error: ${e.toString()}');
}
```

4. Assurez-vous que les migrations aient été exécutées

5. En dernier recours, réinitialisez la base de données

---

### StateError

**Description**: Erreur "Bad state: No element" ou similaire.

**Cause Probable**: Tentative d'accès à un élément qui n'existe pas.

**Solution**:

1. Identifiez la ligne exacte de l'erreur dans le stack trace

2. Utilisez des méthodes sûres:
```dart
// Au lieu de
final item = list.first;  // Lance StateError si vide

// Utilisez
final item = list.isNotEmpty ? list.first : null;
// ou
final item = list.firstOrNull;  // Dart 3.0+
```

3. Vérifiez toujours avant d'accéder:
```dart
if (list.isNotEmpty) {
  final item = list.first;
  // utiliser item
}
```

4. Utilisez try-catch si nécessaire:
```dart
try {
  final item = list.single;
} on StateError {
  // Gérer cas où il n'y a pas exactement un élément
}
```

---

### Null Check Operator Used on Null Value

**Description**: Erreur lors de l'utilisation de l'opérateur `!` sur une valeur null.

**Cause Probable**: Variable nullable utilisée avec `!` quand sa valeur est null.

**Solution**:

1. Identifiez la ligne exacte dans le stack trace

2. Vérifiez la valeur avant d'utiliser `!`:
```dart
// Au lieu de
final value = nullableValue!;

// Utilisez
if (nullableValue != null) {
  final value = nullableValue;
  // utiliser value
}
```

3. Utilisez l'opérateur `??` pour valeurs par défaut:
```dart
final value = nullableValue ?? defaultValue;
```

4. Utilisez l'opérateur `?.` pour accès sûr:
```dart
final length = nullableString?.length;
```

5. Vérifiez pourquoi la valeur est null quand elle ne devrait pas l'être

---

## Logs et Débogage

### Comment Activer les Logs

**Description**: Besoin de voir des logs détaillés pour déboguer un problème.

**Solution**:

1. **Logs de Flutter**:
```bash
flutter run --verbose
```

2. **Logs seulement de l'app**:
```dart
import 'package:logging/logging.dart';

final logger = Logger('MedicApp');

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(MyApp());
}
```

3. **Logs natifs Android**:
```bash
adb logcat | grep -i flutter
# ou pour tout voir
adb logcat
```

4. **Logs natifs iOS**:
   - Ouvrez Console.app sur macOS
   - Sélectionnez votre appareil/simulateur
   - Filtrez par "flutter" ou votre bundle identifier

---

### Logs de Notifications

**Description**: Besoin de voir les logs liés aux notifications.

**Solution**:

1. Ajoutez des logs dans le code de notifications:
```dart
print('Scheduling notification at: $scheduledTime');
await flutterLocalNotificationsPlugin.zonedSchedule(
  id,
  title,
  body,
  scheduledTime,
  notificationDetails,
);
print('Notification scheduled successfully');
```

2. Listez les notifications en attente:
```dart
final pending = await flutterLocalNotificationsPlugin
    .pendingNotificationRequests();
for (var notification in pending) {
  print('Pending: ${notification.id} - ${notification.title}');
}
```

3. Vérifiez les logs du système:
   - Android: `adb logcat | grep -i notification`
   - iOS: Console.app avec filtre "notification"

---

### Logs de Base de Données

**Description**: Besoin de voir les requêtes de base de données exécutées.

**Solution**:

1. Activez le logging dans sqflite:
```dart
import 'package:sqflite/sqflite.dart';

void main() {
  Sqflite.setDebugModeOn(true);
  runApp(MyApp());
}
```

2. Ajoutez des logs dans vos requêtes:
```dart
print('Executing query: SELECT * FROM medications WHERE id = $id');
final result = await db.query('medications', where: 'id = ?', whereArgs: [id]);
print('Query returned ${result.length} rows');
```

3. Wrapper pour logging automatique:
```dart
class LoggedDatabase {
  final Database db;
  LoggedDatabase(this.db);

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    print('Query: $table WHERE $where ARGS $whereArgs');
    final result = await db.query(table, where: where, whereArgs: whereArgs);
    print('Result: ${result.length} rows');
    return result;
  }
}
```

---

### Utiliser le Débogueur

**Description**: Besoin de mettre en pause l'exécution et examiner l'état.

**Solution**:

1. **Dans VS Code**:
   - Placez un breakpoint en cliquant à côté du numéro de ligne
   - Exécutez en mode debug (F5)
   - Quand il se met en pause, utilisez les contrôles de debug

2. **Dans Android Studio**:
   - Placez un breakpoint en cliquant dans la marge
   - Exécutez Debug (Shift + F9)
   - Utilisez le panneau Debug pour step over/into/out

3. **Débogueur programmatique**:
```dart
import 'dart:developer';

void someFunction() {
  debugger();  // Se met en pause ici si débogueur connecté
  // code...
}
```

4. **Inspecter variables**:
```dart
print('Value: $value');  // Logging simple
debugPrint('Value: $value');  // Logging qui respecte les rate limits
```

---

### Écran de Débogage de l'App

**Description**: MedicApp inclut un écran de débogage utile.

**Solution**:

1. Accédez à l'écran de débogage depuis le menu de configuration

2. Fonctions disponibles:
   - Voir base de données (tables, lignes, contenu)
   - Voir notifications programmées
   - Voir état du système
   - Forcer mise à jour de notifications
   - Nettoyer base de données
   - Voir logs récents

3. Utilisez cet écran pour:
   - Vérifier que les données se sauvegardent correctement
   - Vérifier notifications en attente
   - Identifier problèmes d'état

4. Disponible seulement en mode debug

---

## Réinitialiser l'Application

### Nettoyer Données d'App

**Description**: Besoin de supprimer toutes les données sans désinstaller.

**Solution**:

**Android**:
```bash
adb shell pm clear com.medicapp.app
```

**iOS**:
- Réglages > Général > Stockage iPhone
- Cherchez MedicApp
- "Supprimer l'App" (pas "Décharger l'App")

**Depuis l'app** (seulement debug):
- Utilisez l'écran de débogage
- "Reset Database"

---

### Désinstaller et Réinstaller

**Description**: Installation propre complète.

**Solution**:

**Android**:
```bash
adb uninstall com.medicapp.app
flutter run
```

**iOS**:
```bash
# Depuis l'appareil/simulateur, maintenez l'icône pressée
# Sélectionnez "Supprimer l'App"
flutter run
```

**Depuis Flutter**:
```bash
flutter clean
rm -rf build/
flutter run
```

---

### Réinitialiser Base de Données

**Description**: Supprimer seulement la base de données en conservant l'app.

**Solution**:

**Depuis le code** (seulement debug):
```dart
await DatabaseHelper.instance.deleteDatabase();
```

**Android - Manuellement**:
```bash
adb shell
run-as com.medicapp.app
cd databases
rm medicapp.db medicapp.db-shm medicapp.db-wal
exit
```

**iOS - Manuellement**:
- Nécessite accès au conteneur de l'app
- Il est plus facile de désinstaller et réinstaller

---

### Nettoyer Cache de Flutter

**Description**: Résoudre problèmes de compilation liés au cache.

**Solution**:

1. Nettoyage basique:
```bash
flutter clean
```

2. Nettoyage complet:
```bash
flutter clean
rm -rf build/
rm -rf .dart_tool/
rm pubspec.lock
flutter pub get
```

3. Nettoyer cache de pub:
```bash
flutter pub cache repair
```

4. Nettoyer cache de Gradle (Android):
```bash
cd android
./gradlew clean cleanBuildCache
rm -rf ~/.gradle/caches/
cd ..
```

5. Nettoyer cache de pods (iOS):
```bash
cd ios
rm -rf Pods Podfile.lock
pod cache clean --all
pod install
cd ..
```

---

## Problèmes Connus

### Liste de Bugs Connus

1. **Les notifications ne persistent pas après redémarrage sur certains appareils Android**
   - Affecte: Android 12+ avec optimisation agressive de batterie
   - Workaround: Désactiver optimisation de batterie pour MedicApp

2. **Débordement de layout sur écrans très petits (<5")**
   - Affecte: Appareils avec largeur < 320dp
   - Status: Fix planifié pour v1.1.0

3. **Animation de transition saccadée sur appareils low-end**
   - Affecte: Appareils avec <2GB RAM
   - Workaround: Désactiver animations dans configuration

4. **La base de données peut croître indéfiniment**
   - Affecte: Utilisateurs avec beaucoup d'historique (>1 an)
   - Workaround: Implémenter nettoyage périodique d'historique ancien
   - Status: Feature d'archivage automatique planifiée

---

### Workarounds Temporaires

1. **Si les notifications ne sonnent pas sur certains appareils**:
```dart
// Utilisez importance maximale temporairement
importance: Importance.max,
priority: Priority.high,
```

2. **Si lag dans listes longues**:
   - Limitez l'historique visible aux 30 derniers jours
   - Implémentez pagination manuelle

3. **Si la base de données se bloque fréquemment**:
   - Réduisez opérations concurrentes
   - Utilisez transactions batch pour multiples inserts

---

### Issues sur GitHub

**Comment chercher issues existants**:

1. Allez sur: https://github.com/votre-utilisateur/medicapp/issues

2. Utilisez les filtres:
   - `is:issue is:open` - Issues ouverts
   - `label:bug` - Seulement bugs
   - `label:enhancement` - Features demandées

3. Cherchez par mots-clés: "notification", "database", etc.

**Avant de créer un nouvel issue**:
- Cherchez s'il en existe déjà un similaire
- Vérifiez la liste de problèmes connus ci-dessus
- Assurez-vous qu'il ne soit pas résolu dans la dernière version

---

## Obtenir de l'Aide

### Consulter la Documentation

**Ressources disponibles**:

1. **Documentation du projet**:
   - `README.md` - Information générale et setup
   - `docs/es/ARCHITECTURE.md` - Architecture du projet
   - `docs/es/CONTRIBUTING.md` - Guide de contribution
   - `docs/es/TESTING.md` - Guide de testing

2. **Documentation de Flutter**:
   - [flutter.dev/docs](https://flutter.dev/docs)
   - [api.flutter.dev](https://api.flutter.dev)

3. **Documentation de packages**:
   - Consultez pub.dev pour chaque dépendance
   - Lisez le README et changelog de chaque package

---

### Rechercher dans GitHub Issues

**Comment rechercher efficacement**:

1. Utilisez recherche avancée:
```
repo:votre-utilisateur/medicapp is:issue [mots-clés]
```

2. Cherchez aussi les issues fermés:
```
is:issue is:closed notification not working
```

3. Cherchez par labels:
```
label:bug label:android label:notifications
```

4. Cherchez dans commentaires:
```
commenter:username [mots-clés]
```

---

### Créer Nouvel Issue avec Template

**Avant de créer un issue**:

1. Confirmez que c'est vraiment un bug ou feature request valide
2. Cherchez issues dupliqués
3. Rassemblez toute l'information nécessaire

**Information nécessaire**:

**Pour bugs**:
- Description claire du problème
- Étapes pour reproduire
- Comportement attendu vs actuel
- Screenshots/vidéos si applicable
- Information de l'environnement (voir ci-dessous)
- Logs pertinents

**Pour features**:
- Description de la fonctionnalité
- Cas d'usage et bénéfices
- Proposition d'implémentation (optionnel)
- Mockups ou exemples (optionnel)

**Template d'issue**:
```markdown
## Description
[Description claire et concise du problème]

## Étapes pour Reproduire
1. [Première étape]
2. [Deuxième étape]
3. [Troisième étape]

## Comportement Attendu
[Ce qui devrait se passer]

## Comportement Actuel
[Ce qui se passe réellement]

## Information de l'Environnement
- OS: [Android 13 / iOS 16.5]
- Appareil: [Modèle spécifique]
- Version de MedicApp: [v1.0.0]
- Version de Flutter: [3.24.5]

## Logs
```
[Logs pertinents]
```

## Screenshots
[Si applicable]

## Information Additionnelle
[Tout autre contexte]
```

---

### Information Nécessaire pour Rapporter

**Incluez toujours**:

1. **Version de l'app**:
```dart
// Depuis pubspec.yaml
version: 1.0.0+1
```

2. **Information de l'appareil**:
```dart
import 'package:device_info_plus/device_info_plus.dart';

final deviceInfo = DeviceInfoPlugin();
if (Platform.isAndroid) {
  final androidInfo = await deviceInfo.androidInfo;
  print('Android ${androidInfo.version.sdkInt}');
  print('Model: ${androidInfo.model}');
}
```

3. **Version de Flutter**:
```bash
flutter --version
```

4. **Logs complets**:
```bash
flutter run --verbose > logs.txt 2>&1
# Attachez logs.txt à l'issue
```

5. **Stack trace complet** s'il y a crash

6. **Screenshots ou vidéos** montrant le problème

---

## Conclusion

Ce guide couvre les problèmes les plus courants dans MedicApp. Si vous rencontrez un problème non listé ici:

1. Consultez la documentation complète du projet
2. Cherchez dans GitHub Issues
3. Posez des questions dans les discussions du dépôt
4. Créez un nouvel issue avec toute l'information nécessaire

**Rappelez-vous**: Fournir information détaillée et étapes pour reproduire rend beaucoup plus facile la résolution rapide de votre problème.

Pour contribuer des améliorations à ce guide, veuillez ouvrir une PR ou issue dans le dépôt.

---

**Dernière mise à jour**: 2025-11-14
**Version du document**: 1.0.0
