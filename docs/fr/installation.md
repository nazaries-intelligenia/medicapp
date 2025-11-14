# Guide d'Installation de MedicApp

Ce guide complet vous aidera à configurer l'environnement de développement et à exécuter MedicApp sur votre système.

---

## 1. Prérequis

### 1.1 Système d'Exploitation

MedicApp est compatible avec les systèmes d'exploitation suivants :

- **Android:** 6.0 (API 23) ou supérieur
- **iOS:** 12.0 ou supérieur (nécessite macOS pour le développement)
- **Développement:**
  - Windows 10/11 (64-bit)
  - macOS 10.14 ou supérieur
  - Linux (64-bit)

### 1.2 Flutter SDK

**Version requise:** Flutter 3.9.2 ou supérieur

Vérifiez si vous avez déjà Flutter installé :

```bash
flutter --version
```

Si la version est inférieure à 3.9.2, vous devrez mettre à jour :

```bash
flutter upgrade
```

### 1.3 Dart SDK

Le Dart SDK est inclus avec Flutter. La version requise est :

- **Dart SDK:** 3.9.2 ou supérieur

### 1.4 Éditeur de Code Recommandé

Il est recommandé d'utiliser l'un des éditeurs suivants :

#### Visual Studio Code (Recommandé)
- **Télécharger:** https://code.visualstudio.com/
- **Extensions nécessaires:**
  - Flutter (Dart Code)
  - Dart

#### Android Studio
- **Télécharger:** https://developer.android.com/studio
- **Plugins nécessaires:**
  - Flutter
  - Dart

### 1.5 Git

Nécessaire pour cloner le dépôt :

- **Git 2.x ou supérieur**
- **Télécharger:** https://git-scm.com/downloads

Vérifiez l'installation :

```bash
git --version
```

### 1.6 Outils Supplémentaires par Plateforme

#### Pour le développement Android :
- **Android SDK** (inclus avec Android Studio)
- **Android SDK Platform-Tools**
- **Android SDK Build-Tools**
- **Java JDK 11** (inclus avec Android Studio)

#### Pour le développement iOS (macOS uniquement) :
- **Xcode 13.0 ou supérieur**
- **CocoaPods:**
  ```bash
  sudo gem install cocoapods
  ```

---

## 2. Installation du Flutter SDK

### 2.1 Windows

1. Téléchargez le Flutter SDK :
   - Visitez : https://docs.flutter.dev/get-started/install/windows
   - Téléchargez le fichier ZIP de Flutter

2. Extrayez le fichier dans un emplacement permanent (ex : `C:\src\flutter`)

3. Ajoutez Flutter aux variables d'environnement PATH :
   - Recherchez "Variables d'environnement" dans le menu démarrer
   - Éditez la variable PATH de l'utilisateur
   - Ajoutez le chemin : `C:\src\flutter\bin`

4. Vérifiez l'installation :
   ```bash
   flutter doctor
   ```

### 2.2 macOS

1. Téléchargez le Flutter SDK :
   ```bash
   cd ~/development
   curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.9.2-stable.zip
   unzip flutter_macos_3.9.2-stable.zip
   ```

2. Ajoutez Flutter au PATH en éditant `~/.zshrc` ou `~/.bash_profile` :
   ```bash
   export PATH="$PATH:$HOME/development/flutter/bin"
   ```

3. Rechargez la configuration :
   ```bash
   source ~/.zshrc
   ```

4. Vérifiez l'installation :
   ```bash
   flutter doctor
   ```

### 2.3 Linux

1. Téléchargez le Flutter SDK :
   ```bash
   cd ~/development
   wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.9.2-stable.tar.xz
   tar xf flutter_linux_3.9.2-stable.tar.xz
   ```

2. Ajoutez Flutter au PATH en éditant `~/.bashrc` ou `~/.zshrc` :
   ```bash
   export PATH="$PATH:$HOME/development/flutter/bin"
   ```

3. Rechargez la configuration :
   ```bash
   source ~/.bashrc
   ```

4. Vérifiez l'installation :
   ```bash
   flutter doctor
   ```

### 2.4 Vérification Complète de l'Environnement

Exécutez la commande Flutter Doctor pour identifier les composants manquants :

```bash
flutter doctor -v
```

Résolvez tous les problèmes indiqués par [✗] avant de continuer.

---

## 3. Clonage du Dépôt

1. Ouvrez un terminal dans le répertoire où vous souhaitez cloner le projet

2. Clonez le dépôt :
   ```bash
   git clone <repository-url>
   ```

3. Naviguez vers le répertoire du projet :
   ```bash
   cd medicapp
   ```

4. Vérifiez que vous êtes sur la bonne branche :
   ```bash
   git branch
   ```

---

## 4. Installation des Dépendances

### 4.1 Dépendances Flutter

Installez toutes les dépendances du projet :

```bash
flutter pub get
```

Cette commande installera les dépendances principales suivantes :

- **sqflite:** ^2.3.0 - Base de données SQLite locale
- **flutter_local_notifications:** ^19.5.0 - Système de notifications
- **timezone:** ^0.10.1 - Gestion des fuseaux horaires
- **intl:** ^0.20.2 - Internationalisation
- **android_intent_plus:** ^6.0.0 - Intents Android
- **shared_preferences:** ^2.2.2 - Stockage clé-valeur
- **file_picker:** ^8.0.0+1 - Sélecteur de fichiers
- **share_plus:** ^10.1.4 - Partage de fichiers
- **path_provider:** ^2.1.5 - Accès aux répertoires système
- **uuid:** ^4.0.0 - Génération d'IDs uniques

### 4.2 Dépendances Spécifiques par Plateforme

#### Android

Aucune étape supplémentaire n'est requise. Les dépendances Android seront téléchargées automatiquement lors de la première compilation.

#### iOS (macOS uniquement)

Installez les dépendances CocoaPods :

```bash
cd ios
pod install
cd ..
```

Si vous rencontrez des erreurs, essayez de mettre à jour le dépôt CocoaPods :

```bash
cd ios
pod repo update
pod install
cd ..
```

---

## 5. Configuration de l'Environnement

### 5.1 Variables d'Environnement

MedicApp ne nécessite pas de variables d'environnement spéciales pour s'exécuter en développement.

### 5.2 Permissions Android

Le fichier `android/app/src/main/AndroidManifest.xml` inclut déjà les permissions nécessaires :

```xml
<!-- Permissions pour les notifications -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
```

**Important pour Android 13+ (API 33+) :**

Les utilisateurs devront accorder la permission de notification lors de l'exécution. L'application demandera cette permission automatiquement au premier démarrage.

**Alarmes exactes (Android 12+) :**

Pour programmer des notifications précises, les utilisateurs doivent activer "Alarmes et rappels" dans les paramètres système :
- Paramètres > Applications > MedicApp > Alarmes et rappels > Activer

### 5.3 Configuration iOS

#### Permissions dans Info.plist

Si vous développez pour iOS, assurez-vous que `ios/Runner/Info.plist` contient :

```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

#### Capacités de Notifications

Les notifications sont configurées automatiquement par le plugin `flutter_local_notifications`.

---

## 6. Exécution en Développement

### 6.1 Lister les Périphériques Disponibles

Avant d'exécuter l'application, listez les périphériques connectés :

```bash
flutter devices
```

Cela affichera :
- Périphériques Android connectés par USB
- Émulateurs Android disponibles
- Simulateurs iOS (macOS uniquement)
- Navigateurs web disponibles

### 6.2 Démarrer un Émulateur/Simulateur

#### Android Emulator :
```bash
flutter emulators
flutter emulators --launch <emulator-id>
```

#### iOS Simulator (macOS uniquement) :
```bash
open -a Simulator
```

### 6.3 Exécuter l'Application

#### Mode Debug (par défaut) :
```bash
flutter run
```

Ce mode inclut :
- Hot reload (rechargement à chaud)
- Hot restart (redémarrage à chaud)
- Debugging complet
- Performance plus lente

**Raccourcis utiles pendant l'exécution :**
- `r` - Hot reload (recharge le code modifié)
- `R` - Hot restart (redémarre l'application complète)
- `q` - Quitter l'application

#### Mode Release :
```bash
flutter run --release
```

Ce mode inclut :
- Performance optimisée
- Sans debugging
- Taille réduite

#### Mode Profile :
```bash
flutter run --profile
```

Ce mode est utile pour :
- Analyse de performance
- Debugging de performance
- Outils de timeline

### 6.4 Exécuter sur un Périphérique Spécifique

Si vous avez plusieurs périphériques connectés :

```bash
flutter run -d <device-id>
```

Exemple :
```bash
flutter run -d emulator-5554
flutter run -d "iPhone 14 Pro"
```

### 6.5 Exécuter avec Logs Détaillés

Pour voir des logs plus détaillés :

```bash
flutter run -v
```

---

## 7. Exécution des Tests

MedicApp inclut une suite complète de tests avec plus de 432 tests.

### 7.1 Exécuter Tous les Tests

```bash
flutter test
```

### 7.2 Exécuter un Test Spécifique

```bash
flutter test test/nom_du_fichier_test.dart
```

Exemples :
```bash
flutter test test/settings_screen_test.dart
flutter test test/notification_actions_test.dart
flutter test test/multiple_fasting_prioritization_test.dart
```

### 7.3 Exécuter les Tests avec Couverture

Pour générer un rapport de couverture de code :

```bash
flutter test --coverage
```

Le rapport sera généré dans `coverage/lcov.info`.

### 7.4 Voir le Rapport de Couverture

Pour visualiser le rapport de couverture en HTML :

```bash
# Installer lcov (Linux/macOS)
sudo apt-get install lcov  # Linux
brew install lcov          # macOS

# Générer le rapport HTML
genhtml coverage/lcov.info -o coverage/html

# Ouvrir le rapport
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
start coverage/html/index.html  # Windows
```

### 7.5 Exécuter les Tests avec Logs Détaillés

```bash
flutter test --verbose
```

---

## 8. Build pour Production

### 8.1 Android

#### APK (pour distribution directe) :

```bash
flutter build apk --release
```

L'APK sera généré dans : `build/app/outputs/flutter-apk/app-release.apk`

#### APK Split par ABI (réduit la taille) :

```bash
flutter build apk --split-per-abi --release
```

Cela génère plusieurs APKs optimisés :
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM)
- `app-x86_64-release.apk` (64-bit Intel)

#### App Bundle (pour Google Play Store) :

```bash
flutter build appbundle --release
```

L'App Bundle sera généré dans : `build/app/outputs/bundle/release/app-release.aab`

**Avantages de l'App Bundle :**
- Taille de téléchargement optimisée
- Google Play génère des APKs spécifiques pour chaque périphérique
- Requis pour les nouvelles applications sur Play Store

#### Configuration de Signature pour Android

Pour les builds de production, vous devez configurer la signature de l'application :

1. Générez un keystore :
   ```bash
   keytool -genkey -v -keystore ~/medicapp-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias medicapp
   ```

2. Créez le fichier `android/key.properties` :
   ```properties
   storePassword=<votre-mot-de-passe>
   keyPassword=<votre-mot-de-passe>
   keyAlias=medicapp
   storeFile=/chemin/vers/medicapp-release-key.jks
   ```

3. Mettez à jour `android/app/build.gradle.kts` pour utiliser le keystore (déjà configuré dans le projet).

**IMPORTANT :** N'incluez pas `key.properties` ni le fichier `.jks` dans le contrôle de version.

### 8.2 iOS (macOS uniquement)

#### Build pour Testing :

```bash
flutter build ios --release
```

#### Build pour App Store :

```bash
flutter build ipa --release
```

Le fichier IPA sera généré dans : `build/ios/ipa/medicapp.ipa`

#### Configuration de Signature pour iOS

1. Ouvrez le projet dans Xcode :
   ```bash
   open ios/Runner.xcworkspace
   ```

2. Configurez l'équipe de signature :
   - Sélectionnez le projet "Runner" dans le navigateur
   - Allez dans "Signing & Capabilities"
   - Sélectionnez votre équipe de développement Apple
   - Configurez un Bundle Identifier unique

3. Créez un profil de provisionnement dans Apple Developer

4. Archivez et distribuez depuis Xcode :
   - Product > Archive
   - Window > Organizer
   - Distribute App

---

## 9. Dépannage Courant

### 9.1 Problèmes avec les Dépendances

#### Erreur : "Pub get failed"

**Solution :**
```bash
flutter clean
flutter pub get
```

#### Erreur : "Version solving failed"

**Solution :**
```bash
# Mettre à jour Flutter
flutter upgrade

# Nettoyer le cache
flutter pub cache repair

# Réinstaller les dépendances
flutter clean
flutter pub get
```

#### Erreur : "CocoaPods not installed" (iOS)

**Solution :**
```bash
sudo gem install cocoapods
pod setup
```

### 9.2 Problèmes avec les Permissions

#### Android : Les notifications ne fonctionnent pas

**Vérifier :**
1. La permission POST_NOTIFICATIONS est dans AndroidManifest.xml
2. L'utilisateur a accordé les permissions de notification sur Android 13+
3. Les alarmes exactes sont activées dans les Paramètres

**Solution programmatique :**
L'application demande les permissions automatiquement. Si l'utilisateur les a refusées :
```dart
// L'application inclut un bouton pour ouvrir les paramètres
// Paramètres > Permissions > Notifications
```

#### Android : Les alarmes exactes ne fonctionnent pas

**Symptômes :**
- Les notifications arrivent en retard
- Les notifications n'arrivent pas à l'heure exacte

**Solution :**
1. Ouvrez les Paramètres système
2. Applications > MedicApp > Alarmes et rappels
3. Activez l'option

L'application inclut un bouton d'aide qui dirige l'utilisateur vers ces paramètres.

### 9.3 Problèmes avec la Base de Données

#### Erreur : "Database locked" ou "Cannot open database"

**Cause :** La base de données SQLite est accédée par plusieurs processus.

**Solution :**
```bash
# Réinstaller l'application
flutter clean
flutter run
```

#### Erreur : Les migrations de base de données échouent

**Vérifier :**
1. Le numéro de version de la base de données dans `database_helper.dart`
2. Les scripts de migration sont complets

**Solution :**
```bash
# Désinstaller l'application du périphérique
adb uninstall com.medicapp.medicapp  # Android
# Réinstaller
flutter run
```

### 9.4 Problèmes avec les Notifications

#### Les notifications ne se reprogramment pas après redémarrage

**Vérifier :**
1. La permission RECEIVE_BOOT_COMPLETED est dans AndroidManifest.xml
2. Le receiver de boot est enregistré

**Solution :**
Le fichier `AndroidManifest.xml` inclut déjà la configuration nécessaire :
```xml
<receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver"
    android:exported="false">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
    </intent-filter>
</receiver>
```

#### Les notifications ne font pas de son/vibration

**Vérifier :**
1. Le volume du périphérique n'est pas en silencieux
2. Le mode "Ne pas déranger" est désactivé
3. Les permissions de vibration sont accordées

### 9.5 Problèmes de Compilation

#### Erreur : "Gradle build failed"

**Solution :**
```bash
# Nettoyer le projet
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

#### Erreur : "Execution failed for task ':app:processDebugResources'"

**Cause :** Ressources dupliquées ou conflits.

**Solution :**
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter run
```

#### Erreur : SDK version mismatch

**Vérifier :**
1. La version de Flutter : `flutter --version`
2. Le fichier `pubspec.yaml` requiert : `sdk: ^3.9.2`

**Solution :**
```bash
flutter upgrade
flutter doctor
```

### 9.6 Problèmes de Performance

#### L'application est lente en mode debug

**Explication :**
C'est normal. Le mode debug inclut des outils de développement qui réduisent la performance.

**Solution :**
Testez en mode release pour évaluer la performance réelle :
```bash
flutter run --release
```

#### Hot reload ne fonctionne pas

**Solution :**
```bash
# Redémarrez l'application
# Dans le terminal où vous avez exécuté 'flutter run', appuyez sur :
R  # (majuscule) pour hot restart
```

### 9.7 Problèmes de Connectivité des Périphériques

#### Le périphérique n'apparaît pas dans `flutter devices`

**Android :**
```bash
# Vérifier la connexion ADB
adb devices

# Redémarrer le serveur ADB
adb kill-server
adb start-server

# Vérifier à nouveau
flutter devices
```

**iOS :**
```bash
# Vérifier les périphériques connectés
instruments -s devices

# Faire confiance à l'ordinateur depuis le périphérique iOS
```

---

## 10. Ressources Supplémentaires

### Documentation Officielle

- **Flutter:** https://docs.flutter.dev/
- **Dart:** https://dart.dev/guides
- **Material Design 3:** https://m3.material.io/

### Plugins Utilisés

- **sqflite:** https://pub.dev/packages/sqflite
- **flutter_local_notifications:** https://pub.dev/packages/flutter_local_notifications
- **timezone:** https://pub.dev/packages/timezone
- **intl:** https://pub.dev/packages/intl

### Communauté et Support

- **Flutter Community:** https://flutter.dev/community
- **Stack Overflow:** https://stackoverflow.com/questions/tagged/flutter
- **GitHub Issues:** (Dépôt du projet)

---

## 11. Prochaines Étapes

Une fois l'installation terminée :

1. **Explorez le code :**
   - Consultez la structure du projet dans `lib/`
   - Examinez les tests dans `test/`

2. **Exécutez l'application :**
   ```bash
   flutter run
   ```

3. **Exécutez les tests :**
   ```bash
   flutter test
   ```

4. **Lisez la documentation supplémentaire :**
   - [README.md](../README.md)
   - [Architecture du Projet](architecture.md) (si disponible)
   - [Guide de Contribution](contributing.md) (si disponible)

---

## Contact et Aide

Si vous rencontrez des problèmes non couverts dans ce guide, veuillez :

1. Consulter les issues existants dans le dépôt
2. Exécuter `flutter doctor -v` et partager le résultat
3. Inclure les logs complets de l'erreur
4. Décrire les étapes pour reproduire le problème

---

**Dernière mise à jour :** Novembre 2024
**Version du document :** 1.0.0
**Version de MedicApp :** 1.0.0+1
