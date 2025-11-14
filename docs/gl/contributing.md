# Guía de Contribución

Grazas polo teu interese en contribuír a **MedicApp**. Esta guía axudarache a realizar contribucións de calidade que beneficien a toda a comunidade.

---

## Táboa de Contidos

- [Benvida](#benvida)
- [Como Contribuír](#como-contribuír)
- [Proceso de Contribución](#proceso-de-contribución)
- [Convencións de Código](#convencións-de-código)
- [Convencións de Commits](#convencións-de-commits)
- [Guía de Pull Requests](#guía-de-pull-requests)
- [Guía de Testing](#guía-de-testing)
- [Engadir Novas Funcionalidades](#engadir-novas-funcionalidades)
- [Reportar Bugs](#reportar-bugs)
- [Engadir Traducións](#engadir-traducións)
- [Configuración do Contorno de Desenvolvemento](#configuración-do-contorno-de-desenvolvemento)
- [Recursos Útiles](#recursos-útiles)
- [Preguntas Frecuentes](#preguntas-frecuentes)
- [Contacto e Comunidade](#contacto-e-comunidade)

---

## Benvida

Estamos encantados de que queiras contribuír a MedicApp. Este proxecto é posible grazas a persoas coma ti que dedican o seu tempo e coñecemento para mellorar a saúde e o benestar de usuarios en todo o mundo.

### Tipos de Contribucións Benvidas

Valoramos todo tipo de contribucións:

- **Código**: Novas funcionalidades, correccións de bugs, melloras de rendemento
- **Documentación**: Melloras na documentación existente, novas guías, tutoriais
- **Traducións**: Engadir ou mellorar traducións nos 8 idiomas soportados
- **Testing**: Engadir tests, mellorar cobertura, reportar bugs
- **Deseño**: Melloras en UI/UX, iconos, assets
- **Ideas**: Suxestións de melloras, discusións sobre arquitectura
- **Revisión**: Revisar PRs doutros contribuíntes

### Código de Conduta

Este proxecto adhírese a un código de conduta de respecto mutuo:

- **Ser respectuoso**: Trata a todos con respecto e consideración
- **Ser construtivo**: As críticas deben ser construtivas e orientadas a mellorar
- **Ser inclusivo**: Fomenta un ambiente acolledor para persoas de todas as orixes
- **Ser profesional**: Mantén as discusións enfocadas no proxecto
- **Ser colaborativo**: Traballa en equipo e comparte coñecemento

Calquera comportamento inapropiado pode ser reportado aos mantedores do proxecto.

---

## Como Contribuír

### Reportar Bugs

Se atopas un bug, axúdanos a solucionalo seguindo estes pasos:

1. **Busca primeiro**: Revisa os [issues existentes](../../issues) para ver se xa foi reportado
2. **Crea un issue**: Se é un bug novo, crea un issue detallado (ver sección [Reportar Bugs](#reportar-bugs))
3. **Proporciona contexto**: Inclúe pasos para reproducir, comportamento esperado, screenshots, logs
4. **Etiqueta apropiadamente**: Usa a etiqueta `bug` no issue

### Suxerir Melloras

Tes unha idea para mellorar MedicApp?

1. **Verifica se xa existe**: Busca nos issues se alguén xa o suxeriu
2. **Crea un issue de tipo "Feature Request"**: Describe a túa proposta en detalle
3. **Explica o "por que"**: Xustifica por que esta mellora é valiosa
4. **Discute antes de implementar**: Espera feedback dos mantedores antes de empezar a codificar

### Contribuír Código

Para contribuír código:

1. **Atopa un issue**: Busca issues etiquetados como `good first issue` ou `help wanted`
2. **Comenta a túa intención**: Indica que traballarás nese issue para evitar duplicación
3. **Segue o proceso**: Le a sección [Proceso de Contribución](#proceso-de-contribución)
4. **Crea un PR**: Segue a [Guía de Pull Requests](#guía-de-pull-requests)

### Mellorar Documentación

A documentación é fundamental:

- **Corrixe erros**: Typos, ligazóns rotas, información desactualizada
- **Expande documentación**: Engade exemplos, diagramas, explicacións máis claras
- **Traduce documentación**: Axuda a traducir docs a outros idiomas
- **Engade tutoriais**: Crea guías paso a paso para casos de uso comúns

### Traducir a Novos Idiomas

MedicApp soporta actualmente 8 idiomas. Para engadir un novo ou mellorar traducións existentes, consulta a sección [Engadir Traducións](#engadir-traducións).

---

## Proceso de Contribución

Segue estes pasos para realizar unha contribución exitosa:

### 1. Fork do Repositorio

Fai un fork do repositorio á túa conta de GitHub:

```bash
# Desde GitHub, fai clic en "Fork" na esquina superior dereita
```

### 2. Clonar o teu Fork

Clona o teu fork localmente:

```bash
git clone https://github.com/TEU_USUARIO/medicapp.git
cd medicapp
```

### 3. Configurar o Repositorio Upstream

Engade o repositorio orixinal como "upstream":

```bash
git remote add upstream https://github.com/REPO_ORIXINAL/medicapp.git
git fetch upstream
```

### 4. Crear unha Rama

Crea unha rama descritiva para o teu traballo:

```bash
# Para novas funcionalidades
git checkout -b feature/nome-descritivo

# Para correccións de bugs
git checkout -b fix/nome-do-bug

# Para documentación
git checkout -b docs/descripcion-cambio

# Para tests
git checkout -b test/descripcion-test
```

**Convencións de nomes de ramas:**
- `feature/` - Nova funcionalidade
- `fix/` - Corrección de bug
- `docs/` - Cambios en documentación
- `test/` - Engadir ou mellorar tests
- `refactor/` - Refactorización sen cambios funcionais
- `style/` - Cambios de formato/estilo
- `chore/` - Tarefas de mantemento

### 5. Facer Cambios

Realiza os teus cambios seguindo as [Convencións de Código](#convencións-de-código).

### 6. Escribir Tests

**Todos os cambios de código deben incluír tests apropiados:**

```bash
# Executar tests durante desenvolvemento
flutter test

# Executar tests específicos
flutter test test/ruta/ao/test.dart

# Ver cobertura
flutter test --coverage
```

Consulta a sección [Guía de Testing](#guía-de-testing) para máis detalles.

### 7. Formatear o Código

Asegúrate de que o teu código estea formateado correctamente:

```bash
# Formatear todo o proxecto
dart format .

# Verificar análise estática
flutter analyze
```

### 8. Facer Commits

Crea commits seguindo as [Convencións de Commits](#convencións-de-commits):

```bash
git add .
git commit -m "feat: engadir notificación de recordatorio de recarga"
```

### 9. Manter a túa Rama Actualizada

Sincroniza regularmente co repositorio upstream:

```bash
git fetch upstream
git rebase upstream/main
```

### 10. Push de Cambios

Sube os teus cambios ao teu fork:

```bash
git push origin nome-da-tua-rama
```

### 11. Crear Pull Request

Crea un PR desde GitHub seguindo a [Guía de Pull Requests](#guía-de-pull-requests).

---

## Convencións de Código

Manter un código consistente é fundamental para a mantenibilidade do proxecto.

### Dart Style Guide

Seguimos a [Guía de Estilo de Dart](https://dart.dev/guides/language/effective-dart/style) oficial:

- **Nomes de clases**: `PascalCase` (ex. `MedicationService`)
- **Nomes de variables/funcións**: `camelCase` (ex. `getMedications`)
- **Nomes de constantes**: `camelCase` (ex. `maxNotifications`)
- **Nomes de arquivos**: `snake_case` (ex. `medication_service.dart`)
- **Nomes de cartafoles**: `snake_case` (ex. `notification_service`)

### Linting

O proxecto usa `flutter_lints` configurado en `analysis_options.yaml`:

```bash
# Executar análise estática
flutter analyze

# Non debe haber erros nin warnings
```

Todos os PRs deben pasar a análise sen erros nin warnings.

### Formato Automático

Usa `dart format` antes de facer commit:

```bash
# Formatear todo o código
dart format .

# Formatear arquivo específico
dart format lib/services/medication_service.dart
```

**Configuración en editores:**

- **VS Code**: Activa "Format On Save" en configuración
- **Android Studio**: Settings > Editor > Code Style > Dart > Set from: Dart Official

### Naming Conventions

**Variables booleanas:**
```dart
// Ben
bool isActive = true;
bool hasNotifications = false;
bool requiresFasting = true;

// Mal
bool active = true;
bool notifications = false;
```

**Métodos que retornan valores:**
```dart
// Ben
List<Medication> getMedications();
Future<bool> saveMedication(Medication med);
String calculateNextDose();

// Mal
List<Medication> medications();
Future<bool> medication(Medication med);
```

**Métodos privados:**
```dart
// Ben
void _updateDatabase() { }
String _formatDate(DateTime date) { }

// Mal
void updateDatabase() { }  // debería ser privado
String formatDate(DateTime date) { }  // debería ser privado
```

### Organización de Arquivos

**Orde de imports:**
```dart
// 1. Imports de dart:
import 'dart:async';
import 'dart:convert';

// 2. Imports de package:
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

// 3. Imports relativos do proxecto:
import '../models/medication.dart';
import '../services/database_service.dart';
```

**Orde de membros en clases:**
```dart
class Example {
  // 1. Campos estáticos
  static const int maxValue = 100;

  // 2. Campos de instancia
  final String name;
  int count;

  // 3. Constructor
  Example(this.name, this.count);

  // 4. Métodos públicos
  void publicMethod() { }

  // 5. Métodos privados
  void _privateMethod() { }
}
```

### Comentarios e Documentación

**Documentar APIs públicas:**
```dart
/// Obtén todos os medicamentos dunha persoa específica.
///
/// Retorna unha lista de [Medication] para a [personId] proporcionada.
/// A lista está ordenada por nome alfabeticamente.
///
/// Lanza [DatabaseException] se ocorre un erro na base de datos.
Future<List<Medication>> getMedicationsByPerson(String personId) async {
  // Implementación...
}
```

**Comentarios inline cando sexa necesario:**
```dart
// Calcular días restantes baseado en consumo promedio
final daysRemaining = stockQuantity / averageDailyConsumption;
```

**Evitar comentarios obvios:**
```dart
// Mal - comentario innecesario
// Incrementar o contador en 1
count++;

// Ben - código auto-descritivo
count++;
```

---

## Convencións de Commits

Usamos commits semánticos para manter un historial claro e lexible.

### Formato

```
tipo: descrición breve en minúsculas

[corpo opcional con máis detalles]

[footer opcional con referencias a issues]
```

### Tipos de Commits

| Tipo | Descrición | Exemplo |
|------|------------|---------|
| `feat` | Nova funcionalidade | `feat: engadir soporte para múltiples persoas` |
| `fix` | Corrección de bug | `fix: corrixir cálculo de stock en timezone diferente` |
| `docs` | Cambios en documentación | `docs: actualizar guía de instalación` |
| `test` | Engadir ou modificar tests | `test: engadir tests para xaxún a medianoite` |
| `refactor` | Refactorización sen cambios funcionais | `refactor: extraer lóxica de notificacións a servizo` |
| `style` | Cambios de formato | `style: formatear código segundo dart format` |
| `chore` | Tarefas de mantemento | `chore: actualizar dependencias` |
| `perf` | Melloras de rendemento | `perf: optimizar consultas de base de datos` |

### Exemplos de Bos Commits

```bash
# Novo feature con descrición
git commit -m "feat: engadir notificacións de xaxún con duración personalizable"

# Fix con referencia a issue
git commit -m "fix: corrixir cálculo de próxima dose (#123)"

# Docs
git commit -m "docs: engadir sección de contribución en README"

# Test
git commit -m "test: engadir tests de integración para múltiples xaxúns"

# Refactor con contexto
git commit -m "refactor: separar lóxica de medicamentos en clases específicas

- Crear MedicationValidator para validacións
- Extraer cálculos de stock a MedicationStockCalculator
- Mellorar lexibilidade do código"
```

### Exemplos de Commits a Evitar

```bash
# Mal - demasiado vago
git commit -m "fix bug"
git commit -m "update"
git commit -m "changes"

# Mal - sen tipo
git commit -m "engadir nova funcionalidade"

# Mal - tipo incorrecto
git commit -m "docs: engadir nova pantalla"  # debería ser 'feat'
```

### Regras Adicionais

- **Primeira letra en minúscula**: "feat: engadir..." non "feat: Engadir..."
- **Sen punto final**: "feat: engadir soporte" non "feat: engadir soporte."
- **Modo imperativo**: "engadir" non "engadido" ou "engadindo"
- **Máximo 72 caracteres**: Mantén a primeira liña concisa
- **Corpo opcional**: Usa o corpo para explicar o "por que", non o "que"

---

## Guía de Pull Requests

### Antes de Crear o PR

**Checklist:**

- [ ] O teu código compila sen erros: `flutter run`
- [ ] Todos os tests pasan: `flutter test`
- [ ] O código está formateado: `dart format .`
- [ ] Non hai warnings de análise: `flutter analyze`
- [ ] Engadiches tests para o teu cambio
- [ ] A cobertura de tests mantense >= 75%
- [ ] Actualizaches a documentación se é necesario
- [ ] Os commits seguen as convencións
- [ ] A túa rama está actualizada con `main`

### Crear o Pull Request

**Título descritivo:**

```
feat: engadir soporte para períodos de xaxún personalizables
fix: corrixir crash en notificacións a medianoite
docs: mellorar documentación de arquitectura
```

**Descrición detallada:**

```markdown
## Descrición

Este PR engade soporte para períodos de xaxún personalizables, permitindo aos usuarios configurar duracións específicas antes ou despois de tomar un medicamento.

## Cambios realizados

- Engadir campos `fastingType` e `fastingDurationMinutes` ao modelo Medication
- Implementar lóxica de validación de períodos de xaxún
- Engadir UI para configurar xaxún en pantalla de edición de medicamento
- Crear notificacións ongoing para períodos de xaxún activos
- Engadir tests exhaustivos (15 novos tests)

## Tipo de cambio

- [x] Nova funcionalidade (cambio que engade funcionalidade sen romper código existente)
- [ ] Corrección de bug (cambio que soluciona un issue)
- [ ] Cambio que rompe compatibilidade (fix ou feature que causaría que funcionalidade existente cambie)
- [ ] Este cambio require actualización de documentación

## Screenshots

_Se aplica, engadir capturas de pantalla de cambios en UI_

## Tests

- [x] Tests unitarios engadidos
- [x] Tests de integración engadidos
- [x] Todos os tests existentes pasan
- [x] Cobertura >= 75%

## Checklist

- [x] Código segue as convencións do proxecto
- [x] Revisei o meu propio código
- [x] Comentei áreas complexas
- [x] Actualicei a documentación
- [x] Os meus cambios non xeran warnings
- [x] Engadín tests que proban o meu fix/funcionalidade
- [x] Tests novos e existentes pasan localmente

## Issues relacionados

Closes #123
Relacionado con #456
```

### Durante a Revisión

**Responde a comentarios:**
- Agradece o feedback
- Responde preguntas con claridade
- Realiza cambios solicitados prontamente
- Marca conversacións como resoltas despois de aplicar cambios

**Mantén o PR actualizado:**
```bash
# Se hai cambios en main, actualiza a túa rama
git fetch upstream
git rebase upstream/main
git push origin tua-rama --force-with-lease
```

### Despois do Merge

**Limpeza:**
```bash
# Actualizar o teu fork
git checkout main
git pull upstream main
git push origin main

# Eliminar rama local
git branch -d tua-rama

# Eliminar rama remota (opcional)
git push origin --delete tua-rama
```

---

## Guía de Testing

O testing é **obrigatorio** para todas as contribucións de código.

### Principios

- **Todos os PRs deben incluír tests**: Sen excepción
- **Manter cobertura mínima**: >= 75%
- **Tests deben ser independentes**: Cada test debe poder executarse só
- **Tests deben ser determinísticos**: Mesmo input = mesmo output sempre
- **Tests deben ser rápidos**: < 1 segundo por test unitario

### Tipos de Tests

**Tests Unitarios:**
```dart
// test/models/medication_test.dart
void main() {
  group('Medication', () {
    test('calcula días de stock correctamente', () {
      final medication = MedicationBuilder()
        .withStock(30.0)
        .withSingleDose('08:00', 1.0)
        .build();

      expect(medication.calculateDaysRemaining(), equals(30));
    });
  });
}
```

**Tests de Widgets:**
```dart
// test/screens/medication_list_screen_test.dart
void main() {
  testWidgets('mostra lista de medicamentos correctamente', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: MedicationListScreen()),
    );

    expect(find.text('Mis Medicamentos'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });
}
```

**Tests de Integración:**
```dart
// test/integration/medication_flow_test.dart
void main() {
  testWidgets('fluxo completo de engadir medicamento', (tester) async {
    // Setup
    await tester.pumpWidget(MyApp());

    // Engadir medicamento
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verificar navegación e gardado
    expect(find.text('Novo Medicamento'), findsOneWidget);
  });
}
```

### Usar MedicationBuilder

Para crear medicamentos de proba, usa o helper `MedicationBuilder`:

```dart
import 'package:medicapp/test/helpers/medication_builder.dart';

// Medicamento básico
final med = MedicationBuilder()
  .withName('Aspirina')
  .withStock(20.0)
  .build();

// Con xaxún
final medWithFasting = MedicationBuilder()
  .withName('Ibuprofeno')
  .withFasting(type: 'before', duration: 60)
  .build();

// Con múltiples doses
final medMultipleDoses = MedicationBuilder()
  .withName('Vitamina C')
  .withMultipleDoses(['08:00', '14:00', '20:00'], 1.0)
  .build();

// Con stock baixo
final medLowStock = MedicationBuilder()
  .withName('Paracetamol')
  .withLowStock()
  .build();
```

### Executar Tests

```bash
# Todos os tests
flutter test

# Test específico
flutter test test/models/medication_test.dart

# Con cobertura
flutter test --coverage

# Ver reporte de cobertura (require genhtml)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Cobertura de Tests

**Obxectivo: >= 75% de cobertura**

```bash
# Xerar reporte
flutter test --coverage

# Ver cobertura por arquivo
lcov --list coverage/lcov.info
```

**Áreas críticas que DEBEN ter tests:**
- Modelos e lóxica de negocio (95%+)
- Services e utilidades (90%+)
- Screens e widgets principais (70%+)

**Áreas onde a cobertura pode ser menor:**
- Widgets puramente visuais
- Configuración inicial (main.dart)
- Arquivos xerados automaticamente

---

## Engadir Novas Funcionalidades

### Antes de Empezar

1. **Discutir nun issue primeiro**: Crea un issue describindo a túa proposta
2. **Esperar feedback**: Os mantedores revisarán e darán feedback
3. **Obter aprobación**: Espera luz verde antes de investir tempo en implementar

### Seguir a Arquitectura

MedicApp usa **arquitectura MVS (Model-View-Service)**:

```
lib/
├── models/           # Modelos de datos
├── screens/          # Vistas (UI)
├── services/         # Lóxica de negocio
└── l10n/            # Traducións
```

**Principios:**
- **Models**: Só datos, sen lóxica de negocio
- **Services**: Toda a lóxica de negocio e acceso a datos
- **Screens**: Só UI, mínima lóxica

**Exemplo de nova funcionalidade:**

```dart
// 1. Engadir modelo (se necesario)
// lib/models/reminder.dart
class Reminder {
  final String id;
  final String medicationId;
  final DateTime reminderTime;

  Reminder({required this.id, required this.medicationId, required this.reminderTime});
}

// 2. Engadir servizo
// lib/services/reminder_service.dart
class ReminderService {
  Future<void> scheduleReminder(Reminder reminder) async {
    // Lóxica de negocio
  }
}

// 3. Engadir pantalla/widget
// lib/screens/reminder_screen.dart
class ReminderScreen extends StatelessWidget {
  // Só UI, delega lóxica ao servizo
}

// 4. Engadir tests
// test/services/reminder_service_test.dart
void main() {
  group('ReminderService', () {
    test('schedule reminder crea notificación', () async {
      // Test
    });
  });
}
```

### Actualizar Documentación

Ao engadir nova funcionalidade:

- [ ] Actualizar `docs/es/features.md`
- [ ] Engadir exemplos de uso
- [ ] Actualizar diagramas se aplica
- [ ] Engadir comentarios de documentación en código

### Considerar Internacionalización

MedicApp soporta 8 idiomas. **Toda nova funcionalidade debe ser traducida:**

```dart
// En lugar de texto hardcodeado:
Text('New Medication')

// Usar traducións:
Text(AppLocalizations.of(context)!.newMedication)
```

Engade as claves en todos os arquivos `.arb`:
- `lib/l10n/app_es.arb`
- `lib/l10n/app_en.arb`
- `lib/l10n/app_de.arb`
- `lib/l10n/app_fr.arb`
- `lib/l10n/app_it.arb`
- `lib/l10n/app_ca.arb`
- `lib/l10n/app_eu.arb`
- `lib/l10n/app_gl.arb`

### Engadir Tests Exhaustivos

Nova funcionalidade require tests completos:

- Tests unitarios para toda a lóxica
- Tests de widgets para UI
- Tests de integración para fluxos completos
- Tests de edge cases e erros

---

## Reportar Bugs

### Información Requirida

Ao reportar un bug, inclúe:

**1. Descrición do bug:**
Descrición clara e concisa do problema.

**2. Pasos para reproducir:**
```
1. Ir a pantalla 'Medicamentos'
2. Facer clic en 'Engadir medicamento'
3. Configurar xaxún de 60 minutos
4. Gardar medicamento
5. Ver erro en consola
```

**3. Comportamento esperado:**
"Debería gardarse o medicamento coa configuración de xaxún."

**4. Comportamento actual:**
"Móstrase un erro 'Invalid fasting duration' e non se garda o medicamento."

**5. Screenshots/Videos:**
Se aplica, engade capturas de pantalla ou gravación de pantalla.

**6. Logs/Erros:**
```
[ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception:
Invalid fasting duration
#0      Medication.validate (package:medicapp/models/medication.dart:123)
```

**7. Contorno:**
```
- Flutter version: 3.9.2
- Dart version: 3.0.0
- Dispositivo: Samsung Galaxy S21
- OS: Android 13
- Versión de MedicApp: 1.0.0
```

**8. Contexto adicional:**
Calquera outra información relevante sobre o problema.

### Template de Issue

```markdown
## Descrición do Bug
[Descrición clara e concisa]

## Pasos para Reproducir
1.
2.
3.

## Comportamento Esperado
[Que debería pasar]

## Comportamento Actual
[Que está pasando actualmente]

## Screenshots
[Se aplica]

## Logs/Erros
```
[Copiar logs aquí]
```

## Contorno
- Flutter version:
- Dart version:
- Dispositivo:
- OS e versión:
- Versión de MedicApp:

## Contexto Adicional
[Información adicional]
```

---

## Engadir Traducións

MedicApp soporta 8 idiomas. Axúdanos a manter traducións de alta calidade.

### Ubicación de Arquivos

Os arquivos de tradución están en:

```
lib/l10n/
├── app_es.arb    # Español (base)
├── app_en.arb    # Inglés
├── app_de.arb    # Alemán
├── app_fr.arb    # Francés
├── app_it.arb    # Italiano
├── app_ca.arb    # Catalán
├── app_eu.arb    # Euskera
└── app_gl.arb    # Galego
```

### Engadir un Novo Idioma

**1. Copiar plantilla:**
```bash
cp lib/l10n/app_es.arb lib/l10n/app_XX.arb
```

**2. Traducir todas as claves:**
```json
{
  "appTitle": "MedicApp",
  "@appTitle": {
    "description": "Título da aplicación"
  },
  "medications": "Medicamentos",
  "@medications": {
    "description": "Título da pantalla de medicamentos"
  }
}
```

**3. Actualizar `l10n.yaml`** (se existe):
```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
```

**4. Rexistrar o idioma en `MaterialApp`:**
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
    const Locale('XX'),  // Novo idioma
  ],
  // ...
)
```

**5. Executar xeración de código:**
```bash
flutter pub get
# As traducións xéranse automaticamente
```

**6. Probar na app:**
```dart
// Cambiar idioma temporalmente para probar
Locale('XX')
```

### Mellorar Traducións Existentes

**1. Identificar o arquivo:**
Por exemplo, para mellorar inglés: `lib/l10n/app_en.arb`

**2. Buscar a clave:**
```json
{
  "lowStockWarning": "Low stock warning",
  "@lowStockWarning": {
    "description": "Advertencia de stock baixo"
  }
}
```

**3. Mellorar a tradución:**
```json
{
  "lowStockWarning": "Running low on medication",
  "@lowStockWarning": {
    "description": "Advertencia cando queda pouco stock de medicamento"
  }
}
```

**4. Crear PR** co cambio.

### Lineamentos de Tradución

- **Manter consistencia**: Usa os mesmos termos ao longo de todas as traducións
- **Contexto apropiado**: Considera o contexto médico
- **Lonxitude razoable**: Evita traducións moi longas que rompan UI
- **Formalidade**: Usa un ton profesional pero amigable
- **Probar en UI**: Verifica que a tradución se vexa ben en pantalla

---

## Configuración do Contorno de Desenvolvemento

### Requisitos

- **Flutter SDK**: 3.9.2 ou superior
- **Dart SDK**: 3.0 ou superior
- **Editor**: VS Code ou Android Studio recomendados
- **Git**: Para control de versións

### Instalación de Flutter

**macOS/Linux:**
```bash
# Descargar Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Verificar instalación
flutter doctor
```

**Windows:**
1. Descargar Flutter SDK desde [flutter.dev](https://flutter.dev)
2. Extraer a `C:\src\flutter`
3. Engadir `C:\src\flutter\bin` ao PATH
4. Executar `flutter doctor`

### Configuración do Editor

**VS Code (Recomendado):**

1. **Instalar extensións:**
   - Flutter
   - Dart
   - Flutter Widget Snippets (opcional)

2. **Configurar settings.json:**
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

3. **Shortcuts útiles:**
   - `Cmd/Ctrl + .` - Accións rápidas
   - `Cmd/Ctrl + Shift + P` - Command Palette
   - `F5` - Debug
   - `Ctrl + F5` - Run sen debug

**Android Studio:**

1. **Instalar plugins:**
   - Flutter plugin
   - Dart plugin

2. **Configurar:**
   - Settings > Editor > Code Style > Dart
   - Set from: Dart Official
   - Line length: 80

### Configuración do Linter

O proxecto usa `flutter_lints`. Xa está configurado en `analysis_options.yaml`.

```bash
# Executar análise
flutter analyze

# Ver issues en tempo real no editor
# (automático en VS Code e Android Studio)
```

### Configuración de Git

```bash
# Configurar identidade
git config --global user.name "O teu Nome"
git config --global user.email "teu@email.com"

# Configurar editor predeterminado
git config --global core.editor "code --wait"

# Configurar alias útiles
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
```

### Executar o Proxecto

```bash
# Instalar dependencias
flutter pub get

# Executar en emulador/dispositivo
flutter run

# Executar en modo debug
flutter run --debug

# Executar en modo release
flutter run --release

# Hot reload (durante execución)
# Presionar 'r' en terminal

# Hot restart (durante execución)
# Presionar 'R' en terminal
```

### Problemas Comúns

**"Flutter SDK not found":**
```bash
# Verificar PATH
echo $PATH  # macOS/Linux
echo %PATH%  # Windows

# Engadir Flutter ao PATH
export PATH="$PATH:/ruta/a/flutter/bin"  # macOS/Linux
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

## Recursos Útiles

### Documentación do Proxecto

- [Guía de Instalación](installation.md)
- [Características](features.md)
- [Arquitectura](architecture.md)
- [Base de Datos](database.md)
- [Estrutura do Proxecto](project-structure.md)
- [Tecnoloxías](technologies.md)

### Documentación Externa

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

### Ferramentas

- [Dart Pad](https://dartpad.dev/) - Playground online de Dart
- [FlutLab](https://flutlab.io/) - IDE online de Flutter
- [DartDoc](https://dart.dev/tools/dartdoc) - Xerador de documentación
- [Flutter Inspector](https://docs.flutter.dev/development/tools/devtools/inspector) - Debug de widgets

### Comunidade

- [Flutter Discord](https://discord.gg/flutter)
- [r/FlutterDev](https://www.reddit.com/r/FlutterDev/)
- [Stack Overflow - Flutter](https://stackoverflow.com/questions/tagged/flutter)

---

## Preguntas Frecuentes

### Como empezar a contribuír?

1. Le esta guía completa
2. Configura o teu contorno de desenvolvemento
3. Busca issues etiquetados como `good first issue`
4. Comenta no issue que traballarás nel
5. Segue o [Proceso de Contribución](#proceso-de-contribución)

### Onde podo axudar?

Áreas onde sempre necesitamos axuda:

- **Traducións**: Mellorar ou engadir traducións
- **Documentación**: Expandir ou mellorar docs
- **Tests**: Aumentar cobertura de tests
- **Bugs**: Resolver issues reportados
- **UI/UX**: Mellorar interface e experiencia de usuario

Busca issues con etiquetas:
- `good first issue` - Ideal para empezar
- `help wanted` - Necesitamos axuda aquí
- `documentation` - Relacionado con docs
- `translation` - Traducións
- `bug` - Bugs reportados

### Canto tempo toman os reviews?

- **PRs pequenos** (< 100 liñas): 1-2 días
- **PRs medianos** (100-500 liñas): 3-5 días
- **PRs grandes** (> 500 liñas): 1-2 semanas

**Tips para reviews máis rápidos:**
- Mantén PRs pequenos e enfocados
- Escribe boas descricións
- Responde a comentarios prontamente
- Inclúe tests completos

### Que fago se o meu PR non é aceptado?

Non te desanimes. Hai varias razóns:

1. **Non aliñado con visión do proxecto**: Discute a idea nun issue primeiro
2. **Necesita cambios**: Aplica o feedback e actualiza o PR
3. **Problemas técnicos**: Arranxa os issues mencionados
4. **Timing**: Pode que non sexa o momento adecuado, pero reconsiderarase despois

**Sempre aprenderás algo valioso do proceso.**

### Podo traballar en múltiples issues á vez?

Recomendamos enfocarte nun á vez:

- Completa un issue antes de empezar outro
- Evita bloquear issues para outros
- Se necesitas pausar, comenta no issue

### Como manexo conflitos de merge?

```bash
# Actualizar a túa rama con main
git fetch upstream
git rebase upstream/main

# Se hai conflitos, Git dirache
# Resolve conflitos no teu editor
# Logo:
git add .
git rebase --continue

# Push (con force se xa puxeches antes)
git push origin tua-rama --force-with-lease
```

### Necesito asinar un CLA?

Actualmente **non** requerimos CLA (Contributor License Agreement). Ao contribuír, aceptas que o teu código se licencie baixo AGPL-3.0.

### Podo contribuír anonimamente?

Si, pero necesitas unha conta de GitHub. Podes usar un nome de usuario anónimo se prefires.

---

## Contacto e Comunidade

### GitHub Issues

A forma principal de comunicación é a través de [GitHub Issues](../../issues):

- **Reportar bugs**: Crea un issue con label `bug`
- **Suxerir melloras**: Crea un issue con label `enhancement`
- **Facer preguntas**: Crea un issue con label `question`
- **Discutir ideas**: Crea un issue con label `discussion`

### Discussions (se aplica)

Se o repositorio ten GitHub Discussions habilitado:

- Preguntas xerais
- Mostrar os teus proxectos con MedicApp
- Compartir ideas
- Axudar a outros usuarios

### Tempos de Resposta

- **Issues urxentes** (bugs críticos): 24-48 horas
- **Issues normais**: 3-7 días
- **PRs**: Segundo tamaño (ver FAQ)
- **Preguntas**: 2-5 días

### Mantedores

Os mantedores do proxecto revisarán issues, PRs e responderán preguntas. Ten paciencia, somos un equipo pequeno que traballa nisto no noso tempo libre.

---

## Agradecementos

Grazas por ler esta guía e polo teu interese en contribuír a MedicApp.

Cada contribución, por pequena que sexa, fai unha diferenza para os usuarios que dependen desta aplicación para xestionar a súa saúde.

**Esperamos a túa contribución!**

---

**Licenza:** Este proxecto está baixo [AGPL-3.0](../../LICENSE).

**Última actualización:** 2025-11-14
