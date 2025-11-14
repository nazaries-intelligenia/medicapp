# MedicApp

[![Tests](https://img.shields.io/badge/tests-432%2B-brightgreen)](../../test)
[![Coverage](https://img.shields.io/badge/coverage-75--80%25-green)](../../test)
[![Flutter](https://img.shields.io/badge/Flutter-3.9.2%2B-02569B?logo=flutter)](https://flutter.dev)
[![Material Design](https://img.shields.io/badge/Material%20Design-3-757575?logo=material-design)](https://m3.material.io)
[![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?logo=dart)](https://dart.dev)
[![SQLite](https://img.shields.io/badge/SQLite-3-003B57?logo=sqlite)](https://www.sqlite.org)

**MedicApp** is a comprehensive medication management mobile application developed with Flutter, designed to help users and caregivers organize and control medication administration for multiple people efficiently and securely.

---

## Table of Contents

- [Project Description](#project-description)
- [Key Features](#key-features)
- [Screenshots](#screenshots)
- [Quick Start](#quick-start)
- [Documentation](#documentation)
- [Project Status](#project-status)
- [License](#license)

---

## Project Description

MedicApp is a comprehensive solution for medication management that allows users to manage medical treatments for multiple people from a single application. Designed with a focus on usability and accessibility, MedicApp facilitates the tracking of medication schedules, stock control, fasting period management, and smart notifications.

The application implements clean architecture with separation of concerns, state management with Provider, and a robust SQLite database that ensures data persistence and synchronization. With support for 8 languages and Material Design 3, MedicApp offers a modern and accessible experience for users worldwide.

Ideal for patients with complex treatments, professional caregivers, families managing medication for multiple members, and anyone who needs a reliable medication reminder and tracking system.

---

## Key Features

### 1. **Multi-Person Management**
Manage medications for multiple people from a single application. Each person has their own profile, medications, recorded doses, and independent statistics (Database V19+).

### 2. **14 Medication Types**
Complete support for various medication types: Tablet, Capsule, Syrup, Injection, Inhaler, Cream, Drops, Patch, Suppository, Spray, Powder, Gel, Dressing, and Other.

### 3. **Smart Notifications**
Advanced notification system with quick actions (Take/Postpone/Skip), automatic limitation to 5 active notifications, and ongoing notifications for active fasting periods.

### 4. **Advanced Stock Control**
Automatic stock tracking with configurable alerts, low stock notifications, and reminders to refill medications before they run out.

### 5. **Fasting Period Management**
Configure pre/post-medication fasting periods with ongoing notifications, schedule validation, and smart alerts that only show current or upcoming fasting periods.

### 6. **Complete Dose History**
Detailed record of all doses with statuses (Taken, Skipped, Postponed), precise timestamps, stock integration, and adherence statistics per person.

### 7. **Multilingual Interface**
Complete support for 8 languages: Spanish, English, French, German, Italian, Portuguese, Catalan, and Basque, with dynamic switching without restarting the application.

### 8. **Material Design 3**
Modern interface with light/dark theme, adaptive components, smooth animations, and responsive design that adapts to different screen sizes.

### 9. **Robust Database**
SQLite V19 with automatic migrations, optimized indexes, referential integrity validation, and complete trigger system to maintain data consistency.

### 10. **Exhaustive Testing**
Over 432 automated tests (75-80% coverage) including unit tests, widget tests, integration tests, and specific tests for edge cases such as midnight notifications.

---

## Screenshots

_Section reserved for future application screenshots._

---

## Quick Start

### Prerequisites
- Flutter 3.9.2 or higher
- Dart 3.0 or higher
- Android Studio / VS Code with Flutter extensions

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd medicapp

# Install dependencies
flutter pub get

# Run the application
flutter run

# Run tests
flutter test

# Generate coverage report
flutter test --coverage
```

---

## Documentation

Complete project documentation is available in the `docs/en/` directory:

- **[Installation Guide](installation.md)** - Requirements, installation, and initial setup
- **[Features](features.md)** - Detailed documentation of all functionalities
- **[Architecture](architecture.md)** - Project structure, patterns, and design decisions
- **[Database](database.md)** - Schema, migrations, triggers, and optimizations
- **[Project Structure](project-structure.md)** - File and directory organization
- **[Technologies](technologies.md)** - Technology stack and dependencies used
- **[Testing](testing.md)** - Testing strategy, test types, and contribution guidelines
- **[Contributing](contributing.md)** - Guidelines for contributing to the project
- **[Troubleshooting](troubleshooting.md)** - Common issues and solutions

---

## Project Status

- **Database Version**: V19 (with multi-person support)
- **Tests**: 432+ automated tests
- **Coverage**: 75-80%
- **Supported Languages**: 8 (ES, EN, FR, DE, IT, PT, CA, EU)
- **Medication Types**: 14
- **Flutter**: 3.9.2+
- **Material Design**: 3
- **Status**: In active development

---

## License

This project is licensed under the [GNU Affero General Public License v3.0 (AGPL-3.0)](../../LICENSE).

The AGPL-3.0 is a copyleft free software license that requires that any modified version of the software running on a network server must also be made available as open source.

---

**Developed with Flutter and Material Design 3**
