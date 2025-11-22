# MedicApp

[![Tests](https://img.shields.io/badge/tests-570%2B-brightgreen)](../../test)
[![Couverture](https://img.shields.io/badge/couverture-%3E80%25-green)](../../test)
[![Flutter](https://img.shields.io/badge/Flutter-3.9.2%2B-02569B?logo=flutter)](https://flutter.dev)
[![Material Design](https://img.shields.io/badge/Material%20Design-3-757575?logo=material-design)](https://m3.material.io)
[![Dart](https://img.shields.io/badge/Dart-3.10.0-0175C2?logo=dart)](https://dart.dev)
[![SQLite](https://img.shields.io/badge/SQLite-3-003B57?logo=sqlite)](https://www.sqlite.org)

**MedicApp** est une application mobile complète de gestion des médicaments développée avec Flutter, conçue pour aider les utilisateurs et les soignants à organiser et contrôler l'administration de médicaments pour plusieurs personnes de manière efficace et sécurisée.

---

## Table des Matières

- [Description du Projet](#description-du-projet)
- [Fonctionnalités Principales](#fonctionnalités-principales)
- [Captures d'Écran](#captures-décran)
- [Démarrage Rapide](#démarrage-rapide)
- [Documentation](#documentation)
- [État du Projet](#état-du-projet)
- [Licence](#licence)

---

## Description du Projet

MedicApp est une solution intégrale pour la gestion des médicaments qui permet aux utilisateurs de gérer les traitements médicaux pour plusieurs personnes depuis une seule application. Conçue en mettant l'accent sur l'utilisabilité et l'accessibilité, MedicApp facilite le suivi des horaires de prise, le contrôle du stock, la gestion des périodes de jeûne et les notifications intelligentes.

L'application implémente une architecture propre avec séparation des responsabilités, gestion d'état avec Provider, et une base de données SQLite robuste qui garantit la persistance et la synchronisation des données. Avec le support de 8 langues et Material Design 3, MedicApp offre une expérience moderne et accessible pour les utilisateurs du monde entier.

Idéale pour les patients avec des traitements complexes, les soignants professionnels, les familles qui gèrent la médication de plusieurs membres, et toute personne nécessitant un système fiable de rappels et de suivi des médicaments.

---

## Fonctionnalités Principales

### 1. **Gestion Multi-Personne**
Gérez les médicaments pour plusieurs personnes depuis une seule application. Chaque personne a son propre profil, ses médicaments, ses prises enregistrées et ses statistiques indépendantes (Base de données V19+).

### 2. **14 Types de Médicaments**
Support complet pour divers types de médicaments : Comprimé, Gélule, Sirop, Injection, Inhalateur, Crème, Gouttes, Patch, Suppositoire, Spray, Poudre, Gel, Pansement et Autre.

### 3. **Notifications Intelligentes**
Système de notifications avancé avec actions rapides (Prendre/Reporter/Ignorer), limitation automatique à 5 notifications actives, et notifications persistantes pour les périodes de jeûne en cours.

### 4. **Contrôle de Stock Avancé**
Suivi automatique du stock avec alertes configurables, notifications de stock bas, et rappels pour renouveler les médicaments avant épuisement.

### 5. **Gestion des Périodes de Jeûne**
Configurez les périodes de jeûne pré/post médicament avec notifications persistantes, validation des horaires, et alertes intelligentes qui n'affichent que les jeûnes en cours ou futurs.

### 6. **Historique Complet des Prises**
Enregistrement détaillé de toutes les prises avec états (Pris, Ignoré, Reporté), timestamps précis, intégration avec le stock, et statistiques d'adhérence par personne.

### 7. **Interface Multilingue**
Support complet pour 8 langues : Espagnol, Anglais, Français, Allemand, Italien, Portugais, Catalan et Basque, avec changement dynamique sans redémarrer l'application.

### 8. **Material Design 3**
Interface moderne avec thème clair/sombre, composants adaptatifs, animations fluides, et design responsive qui s'adapte aux différentes tailles d'écran.

### 9. **Base de Données Robuste**
SQLite V19 avec migrations automatiques, index optimisés, validation d'intégrité référentielle, et système complet de triggers pour maintenir la cohérence des données.

### 10. **Tests Exhaustifs**
Plus de 570 tests automatisés (couverture >80%) incluant des tests unitaires, de widgets, d'intégration, et des tests spécifiques pour les cas limites comme les notifications à minuit.

### 11. **Système de Personnalisation de l'Apparence**
Choisissez parmi plusieurs palettes de couleurs selon vos préférences :
- **Sea Green** : Tons verts naturels inspirés de la forêt (par défaut)
- **Material 3** : Palette violette de référence de Material Design 3 (#6750A4)
- Sélecteur intuitif dans l'écran Paramètres avec aperçu
- Persistance des préférences par utilisateur
- Support complet pour les thèmes clair et sombre dans les deux palettes

### 12. **Configuration des Notifications (Android)**
Personnalisez entièrement le son et le comportement des notifications :
- Accès direct aux paramètres de notification du système depuis l'application
- Configurez la sonnerie, les vibrations, la priorité et d'autres options avancées
- Gestion par canaux de notification (Android 8.0+)
- Option automatiquement masquée sur les plateformes non compatibles (iOS)

---

## Captures d'Écran

_Section réservée pour les futures captures d'écran de l'application._

---

## Démarrage Rapide

### Prérequis
- Flutter 3.9.2 ou supérieur
- Dart 3.10.0 ou supérieur
- Android Studio / VS Code avec extensions Flutter

### Installation

```bash
# Cloner le dépôt
git clone <repository-url>
cd medicapp

# Installer les dépendances
flutter pub get

# Exécuter l'application
flutter run

# Exécuter les tests
flutter test

# Générer le rapport de couverture
flutter test --coverage
```

---

## Documentation

La documentation complète du projet est disponible dans le répertoire `docs/fr/` :

- **[Guide d'Installation](installation.md)** - Prérequis, installation et configuration initiale
- **[Fonctionnalités](features.md)** - Documentation détaillée de toutes les fonctionnalités
- **[Architecture](architecture.md)** - Structure du projet, modèles et décisions de conception
- **[Base de Données](database.md)** - Schéma, migrations, triggers et optimisations
- **[Structure du Projet](project-structure.md)** - Organisation des fichiers et répertoires
- **[Technologies](technologies.md)** - Stack technologique et dépendances utilisées
- **[Tests](testing.md)** - Stratégie de tests, types de tests et guides de contribution
- **[Contribution](contributing.md)** - Guides pour contribuer au projet
- **[Dépannage](troubleshooting.md)** - Problèmes courants et solutions

---

## État du Projet

- **Version Base de Données**: V19 (avec support multi-personne)
- **Tests**: 570+ tests automatisés
- **Couverture**: >80%
- **Langues Supportées**: 8 (ES, EN, CA, DE, EU, FR, GL, IT)
- **Types de Médicaments**: 14
- **Palettes de Couleurs**: 2 (Sea Green, Material 3)
- **Flutter**: 3.9.2+
- **Dart**: 3.10.0
- **Material Design**: 3
- **État**: En développement actif

---

## Licence

Ce projet est sous licence [GNU Affero General Public License v3.0 (AGPL-3.0)](../../LICENSE).

La AGPL-3.0 est une licence de logiciel libre copyleft qui exige que toute version modifiée du logiciel qui s'exécute sur un serveur réseau soit également disponible en tant que code source ouvert.

---

**Développé avec Flutter et Material Design 3**
