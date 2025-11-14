# Contributing Guide

Thank you for your interest in contributing to **MedicApp**. This guide will help you make quality contributions that benefit the entire community.

---

## Table of Contents

- [Welcome](#welcome)
- [How to Contribute](#how-to-contribute)
- [Contribution Process](#contribution-process)
- [Code Conventions](#code-conventions)
- [Commit Conventions](#commit-conventions)
- [Pull Request Guide](#pull-request-guide)
- [Testing Guide](#testing-guide)
- [Adding New Features](#adding-new-features)
- [Reporting Bugs](#reporting-bugs)
- [Adding Translations](#adding-translations)
- [Development Environment Setup](#development-environment-setup)
- [Useful Resources](#useful-resources)
- [Frequently Asked Questions](#frequently-asked-questions)
- [Contact and Community](#contact-and-community)

---

## Welcome

We're delighted that you want to contribute to MedicApp. This project is made possible by people like you who dedicate their time and knowledge to improve the health and well-being of users around the world.

### Welcome Contribution Types

We value all types of contributions:

- **Code**: New features, bug fixes, performance improvements
- **Documentation**: Improvements to existing documentation, new guides, tutorials
- **Translations**: Adding or improving translations in the 8 supported languages
- **Testing**: Adding tests, improving coverage, reporting bugs
- **Design**: UI/UX improvements, icons, assets
- **Ideas**: Suggestions for improvements, architecture discussions
- **Review**: Reviewing PRs from other contributors

### Code of Conduct

This project adheres to a code of conduct based on mutual respect:

- **Be respectful**: Treat everyone with respect and consideration
- **Be constructive**: Criticism should be constructive and aimed at improvement
- **Be inclusive**: Foster a welcoming environment for people of all backgrounds
- **Be professional**: Keep discussions focused on the project
- **Be collaborative**: Work as a team and share knowledge

Any inappropriate behavior can be reported to the project maintainers.

---

## How to Contribute

### Reporting Bugs

If you find a bug, help us fix it by following these steps:

1. **Search first**: Check the [existing issues](../../issues) to see if it has already been reported
2. **Create an issue**: If it's a new bug, create a detailed issue (see [Reporting Bugs](#reporting-bugs) section)
3. **Provide context**: Include steps to reproduce, expected behavior, screenshots, logs
4. **Label appropriately**: Use the `bug` label on the issue

### Suggesting Improvements

Do you have an idea to improve MedicApp?

1. **Check if it already exists**: Search issues to see if someone has already suggested it
2. **Create a "Feature Request" issue**: Describe your proposal in detail
3. **Explain the "why"**: Justify why this improvement is valuable
4. **Discuss before implementing**: Wait for feedback from maintainers before starting to code

### Contributing Code

To contribute code:

1. **Find an issue**: Look for issues labeled as `good first issue` or `help wanted`
2. **Comment your intention**: Indicate that you'll work on that issue to avoid duplication
3. **Follow the process**: Read the [Contribution Process](#contribution-process) section
4. **Create a PR**: Follow the [Pull Request Guide](#pull-request-guide)

### Improving Documentation

Documentation is fundamental:

- **Fix errors**: Typos, broken links, outdated information
- **Expand documentation**: Add examples, diagrams, clearer explanations
- **Translate documentation**: Help translate docs to other languages
- **Add tutorials**: Create step-by-step guides for common use cases

### Translating to New Languages

MedicApp currently supports 8 languages. To add a new one or improve existing translations, see the [Adding Translations](#adding-translations) section.

---

## Contribution Process

Follow these steps to make a successful contribution:

### 1. Fork the Repository

Fork the repository to your GitHub account:

```bash
# From GitHub, click "Fork" in the upper right corner
```

### 2. Clone Your Fork

Clone your fork locally:

```bash
git clone https://github.com/YOUR_USERNAME/medicapp.git
cd medicapp
```

### 3. Configure Upstream Repository

Add the original repository as "upstream":

```bash
git remote add upstream https://github.com/ORIGINAL_REPO/medicapp.git
git fetch upstream
```

### 4. Create a Branch

Create a descriptive branch for your work:

```bash
# For new features
git checkout -b feature/descriptive-name

# For bug fixes
git checkout -b fix/bug-name

# For documentation
git checkout -b docs/change-description

# For tests
git checkout -b test/test-description
```

**Branch naming conventions:**
- `feature/` - New feature
- `fix/` - Bug fix
- `docs/` - Documentation changes
- `test/` - Add or improve tests
- `refactor/` - Refactoring without functional changes
- `style/` - Format/style changes
- `chore/` - Maintenance tasks

### 5. Make Changes

Make your changes following the [Code Conventions](#code-conventions).

### 6. Write Tests

**All code changes must include appropriate tests:**

```bash
# Run tests during development
flutter test

# Run specific tests
flutter test test/path/to/test.dart

# View coverage
flutter test --coverage
```

See the [Testing Guide](#testing-guide) section for more details.

### 7. Format Code

Make sure your code is properly formatted:

```bash
# Format the entire project
dart format .

# Check static analysis
flutter analyze
```

### 8. Make Commits

Create commits following the [Commit Conventions](#commit-conventions):

```bash
git add .
git commit -m "feat: add medication refill reminder notification"
```

### 9. Keep Your Branch Updated

Regularly sync with the upstream repository:

```bash
git fetch upstream
git rebase upstream/main
```

### 10. Push Changes

Push your changes to your fork:

```bash
git push origin your-branch-name
```

### 11. Create Pull Request

Create a PR from GitHub following the [Pull Request Guide](#pull-request-guide).

---

## Code Conventions

Maintaining consistent code is fundamental to the project's maintainability.

### Dart Style Guide

We follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style):

- **Class names**: `PascalCase` (e.g. `MedicationService`)
- **Variable/function names**: `camelCase` (e.g. `getMedications`)
- **Constant names**: `camelCase` (e.g. `maxNotifications`)
- **File names**: `snake_case` (e.g. `medication_service.dart`)
- **Folder names**: `snake_case` (e.g. `notification_service`)

### Linting

The project uses `flutter_lints` configured in `analysis_options.yaml`:

```bash
# Run static analysis
flutter analyze

# There should be no errors or warnings
```

All PRs must pass analysis without errors or warnings.

### Automatic Formatting

Use `dart format` before committing:

```bash
# Format all code
dart format .

# Format specific file
dart format lib/services/medication_service.dart
```

**Editor configuration:**

- **VS Code**: Enable "Format On Save" in settings
- **Android Studio**: Settings > Editor > Code Style > Dart > Set from: Dart Official

### Naming Conventions

**Boolean variables:**
```dart
// Good
bool isActive = true;
bool hasNotifications = false;
bool requiresFasting = true;

// Bad
bool active = true;
bool notifications = false;
```

**Methods that return values:**
```dart
// Good
List<Medication> getMedications();
Future<bool> saveMedication(Medication med);
String calculateNextDose();

// Bad
List<Medication> medications();
Future<bool> medication(Medication med);
```

**Private methods:**
```dart
// Good
void _updateDatabase() { }
String _formatDate(DateTime date) { }

// Bad
void updateDatabase() { }  // should be private
String formatDate(DateTime date) { }  // should be private
```

### File Organization

**Import order:**
```dart
// 1. Dart imports:
import 'dart:async';
import 'dart:convert';

// 2. Package imports:
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

// 3. Project relative imports:
import '../models/medication.dart';
import '../services/database_service.dart';
```

**Class member order:**
```dart
class Example {
  // 1. Static fields
  static const int maxValue = 100;

  // 2. Instance fields
  final String name;
  int count;

  // 3. Constructor
  Example(this.name, this.count);

  // 4. Public methods
  void publicMethod() { }

  // 5. Private methods
  void _privateMethod() { }
}
```

### Comments and Documentation

**Document public APIs:**
```dart
/// Gets all medications for a specific person.
///
/// Returns a list of [Medication] for the provided [personId].
/// The list is sorted alphabetically by name.
///
/// Throws [DatabaseException] if a database error occurs.
Future<List<Medication>> getMedicationsByPerson(String personId) async {
  // Implementation...
}
```

**Inline comments when necessary:**
```dart
// Calculate remaining days based on average consumption
final daysRemaining = stockQuantity / averageDailyConsumption;
```

**Avoid obvious comments:**
```dart
// Bad - unnecessary comment
// Increment counter by 1
count++;

// Good - self-descriptive code
count++;
```

---

## Commit Conventions

We use semantic commits to maintain a clear and readable history.

### Format

```
type: brief description in lowercase

[optional body with more details]

[optional footer with issue references]
```

### Commit Types

| Type | Description | Example |
|------|-------------|---------|
| `feat` | New feature | `feat: add support for multiple people` |
| `fix` | Bug fix | `fix: correct stock calculation in different timezone` |
| `docs` | Documentation changes | `docs: update installation guide` |
| `test` | Add or modify tests | `test: add tests for fasting at midnight` |
| `refactor` | Refactoring without functional changes | `refactor: extract notification logic to service` |
| `style` | Format changes | `style: format code according to dart format` |
| `chore` | Maintenance tasks | `chore: update dependencies` |
| `perf` | Performance improvements | `perf: optimize database queries` |

### Examples of Good Commits

```bash
# New feature with description
git commit -m "feat: add fasting notifications with customizable duration"

# Fix with issue reference
git commit -m "fix: correct next dose calculation (#123)"

# Docs
git commit -m "docs: add contribution section to README"

# Test
git commit -m "test: add integration tests for multiple fasting periods"

# Refactor with context
git commit -m "refactor: separate medication logic into specific classes

- Create MedicationValidator for validations
- Extract stock calculations to MedicationStockCalculator
- Improve code readability"
```

### Examples of Commits to Avoid

```bash
# Bad - too vague
git commit -m "fix bug"
git commit -m "update"
git commit -m "changes"

# Bad - no type
git commit -m "add new feature"

# Bad - incorrect type
git commit -m "docs: add new screen"  # should be 'feat'
```

### Additional Rules

- **First letter lowercase**: "feat: add..." not "feat: Add..."
- **No ending period**: "feat: add support" not "feat: add support."
- **Imperative mood**: "add" not "added" or "adding"
- **Maximum 72 characters**: Keep the first line concise
- **Optional body**: Use the body to explain the "why", not the "what"

---

## Pull Request Guide

### Before Creating the PR

**Checklist:**

- [ ] Your code compiles without errors: `flutter run`
- [ ] All tests pass: `flutter test`
- [ ] Code is formatted: `dart format .`
- [ ] No analysis warnings: `flutter analyze`
- [ ] You've added tests for your change
- [ ] Test coverage remains >= 75%
- [ ] You've updated documentation if necessary
- [ ] Commits follow conventions
- [ ] Your branch is up to date with `main`

### Creating the Pull Request

**Descriptive title:**

```
feat: add support for customizable fasting periods
fix: correct crash in notifications at midnight
docs: improve architecture documentation
```

**Detailed description:**

```markdown
## Description

This PR adds support for customizable fasting periods, allowing users to configure specific durations before or after taking a medication.

## Changes Made

- Add `fastingType` and `fastingDurationMinutes` fields to Medication model
- Implement validation logic for fasting periods
- Add UI to configure fasting in medication edit screen
- Create ongoing notifications for active fasting periods
- Add comprehensive tests (15 new tests)

## Type of Change

- [x] New feature (change that adds functionality without breaking existing code)
- [ ] Bug fix (change that fixes an issue)
- [ ] Breaking change (fix or feature that would cause existing functionality to change)
- [ ] This change requires documentation update

## Screenshots

_If applicable, add screenshots of UI changes_

## Tests

- [x] Unit tests added
- [x] Integration tests added
- [x] All existing tests pass
- [x] Coverage >= 75%

## Checklist

- [x] Code follows project conventions
- [x] I have reviewed my own code
- [x] I have commented complex areas
- [x] I have updated documentation
- [x] My changes don't generate warnings
- [x] I have added tests that prove my fix/feature
- [x] New and existing tests pass locally

## Related Issues

Closes #123
Related to #456
```

### During Review

**Respond to comments:**
- Thank reviewers for feedback
- Respond to questions clearly
- Make requested changes promptly
- Mark conversations as resolved after applying changes

**Keep the PR updated:**
```bash
# If there are changes in main, update your branch
git fetch upstream
git rebase upstream/main
git push origin your-branch --force-with-lease
```

### After Merge

**Cleanup:**
```bash
# Update your fork
git checkout main
git pull upstream main
git push origin main

# Delete local branch
git branch -d your-branch

# Delete remote branch (optional)
git push origin --delete your-branch
```

---

## Testing Guide

Testing is **mandatory** for all code contributions.

### Principles

- **All PRs must include tests**: No exceptions
- **Maintain minimum coverage**: >= 75%
- **Tests must be independent**: Each test should be able to run alone
- **Tests must be deterministic**: Same input = same output always
- **Tests must be fast**: < 1 second per unit test

### Test Types

**Unit Tests:**
```dart
// test/models/medication_test.dart
void main() {
  group('Medication', () {
    test('calculates stock days correctly', () {
      final medication = MedicationBuilder()
        .withStock(30.0)
        .withSingleDose('08:00', 1.0)
        .build();

      expect(medication.calculateDaysRemaining(), equals(30));
    });
  });
}
```

**Widget Tests:**
```dart
// test/screens/medication_list_screen_test.dart
void main() {
  testWidgets('displays medication list correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: MedicationListScreen()),
    );

    expect(find.text('My Medications'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });
}
```

**Integration Tests:**
```dart
// test/integration/medication_flow_test.dart
void main() {
  testWidgets('complete flow of adding medication', (tester) async {
    // Setup
    await tester.pumpWidget(MyApp());

    // Add medication
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify navigation and saving
    expect(find.text('New Medication'), findsOneWidget);
  });
}
```

### Using MedicationBuilder

To create test medications, use the `MedicationBuilder` helper:

```dart
import 'package:medicapp/test/helpers/medication_builder.dart';

// Basic medication
final med = MedicationBuilder()
  .withName('Aspirin')
  .withStock(20.0)
  .build();

// With fasting
final medWithFasting = MedicationBuilder()
  .withName('Ibuprofen')
  .withFasting(type: 'before', duration: 60)
  .build();

// With multiple doses
final medMultipleDoses = MedicationBuilder()
  .withName('Vitamin C')
  .withMultipleDoses(['08:00', '14:00', '20:00'], 1.0)
  .build();

// With low stock
final medLowStock = MedicationBuilder()
  .withName('Paracetamol')
  .withLowStock()
  .build();
```

### Running Tests

```bash
# All tests
flutter test

# Specific test
flutter test test/models/medication_test.dart

# With coverage
flutter test --coverage

# View coverage report (requires genhtml)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Test Coverage

**Target: >= 75% coverage**

```bash
# Generate report
flutter test --coverage

# View coverage per file
lcov --list coverage/lcov.info
```

**Critical areas that MUST have tests:**
- Models and business logic (95%+)
- Services and utilities (90%+)
- Main screens and widgets (70%+)

**Areas where coverage can be lower:**
- Purely visual widgets
- Initial setup (main.dart)
- Auto-generated files

---

## Adding New Features

### Before Starting

1. **Discuss in an issue first**: Create an issue describing your proposal
2. **Wait for feedback**: Maintainers will review and provide feedback
3. **Get approval**: Wait for green light before investing time in implementation

### Following the Architecture

MedicApp uses **MVS (Model-View-Service) architecture**:

```
lib/
├── models/           # Data models
├── screens/          # Views (UI)
├── services/         # Business logic
└── l10n/            # Translations
```

**Principles:**
- **Models**: Only data, no business logic
- **Services**: All business logic and data access
- **Screens**: Only UI, minimal logic

**Example of new feature:**

```dart
// 1. Add model (if needed)
// lib/models/reminder.dart
class Reminder {
  final String id;
  final String medicationId;
  final DateTime reminderTime;

  Reminder({required this.id, required this.medicationId, required this.reminderTime});
}

// 2. Add service
// lib/services/reminder_service.dart
class ReminderService {
  Future<void> scheduleReminder(Reminder reminder) async {
    // Business logic
  }
}

// 3. Add screen/widget
// lib/screens/reminder_screen.dart
class ReminderScreen extends StatelessWidget {
  // Only UI, delegates logic to service
}

// 4. Add tests
// test/services/reminder_service_test.dart
void main() {
  group('ReminderService', () {
    test('schedule reminder creates notification', () async {
      // Test
    });
  });
}
```

### Update Documentation

When adding new features:

- [ ] Update `docs/es/features.md`
- [ ] Add usage examples
- [ ] Update diagrams if applicable
- [ ] Add documentation comments in code

### Consider Internationalization

MedicApp supports 8 languages. **All new features must be translated:**

```dart
// Instead of hardcoded text:
Text('New Medication')

// Use translations:
Text(AppLocalizations.of(context)!.newMedication)
```

Add keys in all `.arb` files:
- `lib/l10n/app_es.arb`
- `lib/l10n/app_en.arb`
- `lib/l10n/app_de.arb`
- `lib/l10n/app_fr.arb`
- `lib/l10n/app_it.arb`
- `lib/l10n/app_ca.arb`
- `lib/l10n/app_eu.arb`
- `lib/l10n/app_gl.arb`

### Add Comprehensive Tests

New features require complete tests:

- Unit tests for all logic
- Widget tests for UI
- Integration tests for complete flows
- Tests for edge cases and errors

---

## Reporting Bugs

### Required Information

When reporting a bug, include:

**1. Bug description:**
Clear and concise description of the problem.

**2. Steps to reproduce:**
```
1. Go to 'Medications' screen
2. Click on 'Add medication'
3. Configure 60-minute fasting
4. Save medication
5. See error in console
```

**3. Expected behavior:**
"The medication should be saved with the fasting configuration."

**4. Actual behavior:**
"An error 'Invalid fasting duration' is shown and the medication is not saved."

**5. Screenshots/Videos:**
If applicable, add screenshots or screen recording.

**6. Logs/Errors:**
```
[ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception:
Invalid fasting duration
#0      Medication.validate (package:medicapp/models/medication.dart:123)
```

**7. Environment:**
```
- Flutter version: 3.9.2
- Dart version: 3.0.0
- Device: Samsung Galaxy S21
- OS: Android 13
- MedicApp version: 1.0.0
```

**8. Additional context:**
Any other relevant information about the problem.

### Issue Template

```markdown
## Bug Description
[Clear and concise description]

## Steps to Reproduce
1.
2.
3.

## Expected Behavior
[What should happen]

## Actual Behavior
[What is currently happening]

## Screenshots
[If applicable]

## Logs/Errors
```
[Copy logs here]
```

## Environment
- Flutter version:
- Dart version:
- Device:
- OS and version:
- MedicApp version:

## Additional Context
[Additional information]
```

---

## Adding Translations

MedicApp supports 8 languages. Help us maintain high-quality translations.

### File Locations

Translation files are in:

```
lib/l10n/
├── app_es.arb    # Spanish (base)
├── app_en.arb    # English
├── app_de.arb    # German
├── app_fr.arb    # French
├── app_it.arb    # Italian
├── app_ca.arb    # Catalan
├── app_eu.arb    # Basque
└── app_gl.arb    # Galician
```

### Adding a New Language

**1. Copy template:**
```bash
cp lib/l10n/app_es.arb lib/l10n/app_XX.arb
```

**2. Translate all keys:**
```json
{
  "appTitle": "MedicApp",
  "@appTitle": {
    "description": "Application title"
  },
  "medications": "Medications",
  "@medications": {
    "description": "Medications screen title"
  }
}
```

**3. Update `l10n.yaml`** (if it exists):
```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
```

**4. Register language in `MaterialApp`:**
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
    const Locale('XX'),  // New language
  ],
  // ...
)
```

**5. Run code generation:**
```bash
flutter pub get
# Translations are generated automatically
```

**6. Test in app:**
```dart
// Change language temporarily to test
Locale('XX')
```

### Improving Existing Translations

**1. Identify the file:**
For example, to improve English: `lib/l10n/app_en.arb`

**2. Find the key:**
```json
{
  "lowStockWarning": "Low stock warning",
  "@lowStockWarning": {
    "description": "Low stock warning"
  }
}
```

**3. Improve the translation:**
```json
{
  "lowStockWarning": "Running low on medication",
  "@lowStockWarning": {
    "description": "Warning when medication stock is low"
  }
}
```

**4. Create PR** with the change.

### Translation Guidelines

- **Maintain consistency**: Use the same terms throughout all translations
- **Appropriate context**: Consider the medical context
- **Reasonable length**: Avoid very long translations that break UI
- **Formality**: Use a professional but friendly tone
- **Test in UI**: Verify that the translation looks good on screen

---

## Development Environment Setup

### Requirements

- **Flutter SDK**: 3.9.2 or higher
- **Dart SDK**: 3.0 or higher
- **Editor**: VS Code or Android Studio recommended
- **Git**: For version control

### Flutter Installation

**macOS/Linux:**
```bash
# Download Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

**Windows:**
1. Download Flutter SDK from [flutter.dev](https://flutter.dev)
2. Extract to `C:\src\flutter`
3. Add `C:\src\flutter\bin` to PATH
4. Run `flutter doctor`

### Editor Configuration

**VS Code (Recommended):**

1. **Install extensions:**
   - Flutter
   - Dart
   - Flutter Widget Snippets (optional)

2. **Configure settings.json:**
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

3. **Useful shortcuts:**
   - `Cmd/Ctrl + .` - Quick actions
   - `Cmd/Ctrl + Shift + P` - Command Palette
   - `F5` - Debug
   - `Ctrl + F5` - Run without debug

**Android Studio:**

1. **Install plugins:**
   - Flutter plugin
   - Dart plugin

2. **Configure:**
   - Settings > Editor > Code Style > Dart
   - Set from: Dart Official
   - Line length: 80

### Linter Configuration

The project uses `flutter_lints`. It's already configured in `analysis_options.yaml`.

```bash
# Run analysis
flutter analyze

# View issues in real-time in the editor
# (automatic in VS Code and Android Studio)
```

### Git Configuration

```bash
# Configure identity
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# Configure default editor
git config --global core.editor "code --wait"

# Configure useful aliases
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
```

### Running the Project

```bash
# Install dependencies
flutter pub get

# Run on emulator/device
flutter run

# Run in debug mode
flutter run --debug

# Run in release mode
flutter run --release

# Hot reload (during execution)
# Press 'r' in terminal

# Hot restart (during execution)
# Press 'R' in terminal
```

### Common Issues

**"Flutter SDK not found":**
```bash
# Check PATH
echo $PATH  # macOS/Linux
echo %PATH%  # Windows

# Add Flutter to PATH
export PATH="$PATH:/path/to/flutter/bin"  # macOS/Linux
```

**"Android licenses not accepted":**
```bash
flutter doctor --android-licenses
```

**"CocoaPods not installed" (macOS):**
```bash
sudo gem install cocoapods
pod setup
```

---

## Useful Resources

### Project Documentation

- [Installation Guide](installation.md)
- [Features](features.md)
- [Architecture](architecture.md)
- [Database](database.md)
- [Project Structure](project-structure.md)
- [Technologies](technologies.md)

### External Documentation

**Flutter:**
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Widget Catalog](https://docs.flutter.dev/development/ui/widgets)

**Material Design 3:**
- [Material Design Guidelines](https://m3.material.io/)
- [Material Components](https://m3.material.io/components)
- [Material Theming](https://m3.material.io/foundations/customization)

**SQLite:**
- [SQLite Documentation](https://www.sqlite.org/docs.html)
- [SQLite Tutorial](https://www.sqlitetutorial.net/)
- [sqflite Package](https://pub.dev/packages/sqflite)

**Testing:**
- [Flutter Testing](https://docs.flutter.dev/testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)

### Tools

- [Dart Pad](https://dartpad.dev/) - Online Dart playground
- [FlutLab](https://flutlab.io/) - Online Flutter IDE
- [DartDoc](https://dart.dev/tools/dartdoc) - Documentation generator
- [Flutter Inspector](https://docs.flutter.dev/development/tools/devtools/inspector) - Widget debugging

### Community

- [Flutter Discord](https://discord.gg/flutter)
- [r/FlutterDev](https://www.reddit.com/r/FlutterDev/)
- [Stack Overflow - Flutter](https://stackoverflow.com/questions/tagged/flutter)

---

## Frequently Asked Questions

### How do I start contributing?

1. Read this complete guide
2. Set up your development environment
3. Look for issues labeled as `good first issue`
4. Comment on the issue that you'll work on it
5. Follow the [Contribution Process](#contribution-process)

### Where can I help?

Areas where we always need help:

- **Translations**: Improve or add translations
- **Documentation**: Expand or improve docs
- **Tests**: Increase test coverage
- **Bugs**: Resolve reported issues
- **UI/UX**: Improve interface and user experience

Look for issues with labels:
- `good first issue` - Ideal to start
- `help wanted` - We need help here
- `documentation` - Related to docs
- `translation` - Translations
- `bug` - Reported bugs

### How long do reviews take?

- **Small PRs** (< 100 lines): 1-2 days
- **Medium PRs** (100-500 lines): 3-5 days
- **Large PRs** (> 500 lines): 1-2 weeks

**Tips for faster reviews:**
- Keep PRs small and focused
- Write good descriptions
- Respond to comments promptly
- Include complete tests

### What do I do if my PR is not accepted?

Don't be discouraged. There are several reasons:

1. **Not aligned with project vision**: Discuss the idea in an issue first
2. **Needs changes**: Apply feedback and update the PR
3. **Technical issues**: Fix the mentioned issues
4. **Timing**: It may not be the right time, but will be reconsidered later

**You'll always learn something valuable from the process.**

### Can I work on multiple issues at once?

We recommend focusing on one at a time:

- Complete one issue before starting another
- Avoid blocking issues for others
- If you need to pause, comment on the issue

### How do I handle merge conflicts?

```bash
# Update your branch with main
git fetch upstream
git rebase upstream/main

# If there are conflicts, Git will tell you
# Resolve conflicts in your editor
# Then:
git add .
git rebase --continue

# Push (with force if you had already pushed before)
git push origin your-branch --force-with-lease
```

### Do I need to sign a CLA?

Currently we **do not** require a CLA (Contributor License Agreement). By contributing, you agree that your code will be licensed under AGPL-3.0.

### Can I contribute anonymously?

Yes, but you need a GitHub account. You can use an anonymous username if you prefer.

---

## Contact and Community

### GitHub Issues

The primary form of communication is through [GitHub Issues](../../issues):

- **Report bugs**: Create an issue with label `bug`
- **Suggest improvements**: Create an issue with label `enhancement`
- **Ask questions**: Create an issue with label `question`
- **Discuss ideas**: Create an issue with label `discussion`

### Discussions (if applicable)

If the repository has GitHub Discussions enabled:

- General questions
- Show your projects with MedicApp
- Share ideas
- Help other users

### Response Times

- **Urgent issues** (critical bugs): 24-48 hours
- **Normal issues**: 3-7 days
- **PRs**: Depending on size (see FAQ)
- **Questions**: 2-5 days

### Maintainers

Project maintainers will review issues, PRs, and answer questions. Please be patient, we're a small team working on this in our free time.

---

## Acknowledgements

Thank you for reading this guide and for your interest in contributing to MedicApp.

Every contribution, no matter how small, makes a difference for users who depend on this application to manage their health.

**We look forward to your contribution!**

---

**License:** This project is under [AGPL-3.0](../../LICENSE).

**Last updated:** 2025-11-14
