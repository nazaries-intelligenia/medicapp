# Guía de Contribución

Gracias por tu interés en contribuir a **MedicApp**. Esta guía te ayudará a realizar contribuciones de calidad que beneficien a toda la comunidad.

---

## Tabla de Contenidos

- [Bienvenida](#bienvenida)
- [Cómo Contribuir](#cómo-contribuir)
- [Proceso de Contribución](#proceso-de-contribución)
- [Convenciones de Código](#convenciones-de-código)
- [Convenciones de Commits](#convenciones-de-commits)
- [Guía de Pull Requests](#guía-de-pull-requests)
- [Guía de Testing](#guía-de-testing)
- [Agregar Nuevas Funcionalidades](#agregar-nuevas-funcionalidades)
- [Reportar Bugs](#reportar-bugs)
- [Agregar Traducciones](#agregar-traducciones)
- [Configuración del Entorno de Desarrollo](#configuración-del-entorno-de-desarrollo)
- [Recursos Útiles](#recursos-útiles)
- [Preguntas Frecuentes](#preguntas-frecuentes)
- [Contacto y Comunidad](#contacto-y-comunidad)

---

## Bienvenida

Estamos encantados de que quieras contribuir a MedicApp. Este proyecto es posible gracias a personas como tú que dedican su tiempo y conocimiento para mejorar la salud y el bienestar de usuarios en todo el mundo.

### Tipos de Contribuciones Bienvenidas

Valoramos todo tipo de contribuciones:

- **Código**: Nuevas funcionalidades, correcciones de bugs, mejoras de rendimiento
- **Documentación**: Mejoras en la documentación existente, nuevas guías, tutoriales
- **Traducciones**: Agregar o mejorar traducciones en los 8 idiomas soportados
- **Testing**: Agregar tests, mejorar cobertura, reportar bugs
- **Diseño**: Mejoras en UI/UX, iconos, assets
- **Ideas**: Sugerencias de mejoras, discusiones sobre arquitectura
- **Revisión**: Revisar PRs de otros contribuidores

### Código de Conducta

Este proyecto se adhiere a un código de conducta de respeto mutuo:

- **Ser respetuoso**: Trata a todos con respeto y consideración
- **Ser constructivo**: Las críticas deben ser constructivas y orientadas a mejorar
- **Ser inclusivo**: Fomenta un ambiente acogedor para personas de todos los orígenes
- **Ser profesional**: Mantén las discusiones enfocadas en el proyecto
- **Ser colaborativo**: Trabaja en equipo y comparte conocimiento

Cualquier comportamiento inapropiado puede ser reportado a los mantenedores del proyecto.

---

## Cómo Contribuir

### Reportar Bugs

Si encuentras un bug, ayúdanos a solucionarlo siguiendo estos pasos:

1. **Busca primero**: Revisa los [issues existentes](../../issues) para ver si ya fue reportado
2. **Crea un issue**: Si es un bug nuevo, crea un issue detallado (ver sección [Reportar Bugs](#reportar-bugs))
3. **Proporciona contexto**: Incluye pasos para reproducir, comportamiento esperado, screenshots, logs
4. **Etiqueta apropiadamente**: Usa la etiqueta `bug` en el issue

### Sugerir Mejoras

¿Tienes una idea para mejorar MedicApp?

1. **Verifica si ya existe**: Busca en los issues si alguien ya lo sugirió
2. **Crea un issue de tipo "Feature Request"**: Describe tu propuesta en detalle
3. **Explica el "por qué"**: Justifica por qué esta mejora es valiosa
4. **Discute antes de implementar**: Espera feedback de los mantenedores antes de empezar a codificar

### Contribuir Código

Para contribuir código:

1. **Encuentra un issue**: Busca issues etiquetados como `good first issue` o `help wanted`
2. **Comenta tu intención**: Indica que trabajarás en ese issue para evitar duplicación
3. **Sigue el proceso**: Lee la sección [Proceso de Contribución](#proceso-de-contribución)
4. **Crea un PR**: Sigue la [Guía de Pull Requests](#guía-de-pull-requests)

### Mejorar Documentación

La documentación es fundamental:

- **Corrige errores**: Typos, enlaces rotos, información desactualizada
- **Expande documentación**: Agrega ejemplos, diagramas, explicaciones más claras
- **Traduce documentación**: Ayuda a traducir docs a otros idiomas
- **Agrega tutoriales**: Crea guías paso a paso para casos de uso comunes

### Traducir a Nuevos Idiomas

MedicApp soporta actualmente 8 idiomas. Para agregar uno nuevo o mejorar traducciones existentes, consulta la sección [Agregar Traducciones](#agregar-traducciones).

---

## Proceso de Contribución

Sigue estos pasos para realizar una contribución exitosa:

### 1. Fork del Repositorio

Haz un fork del repositorio a tu cuenta de GitHub:

```bash
# Desde GitHub, haz clic en "Fork" en la esquina superior derecha
```

### 2. Clonar tu Fork

Clona tu fork localmente:

```bash
git clone https://github.com/TU_USUARIO/medicapp.git
cd medicapp
```

### 3. Configurar el Repositorio Upstream

Agrega el repositorio original como "upstream":

```bash
git remote add upstream https://github.com/REPO_ORIGINAL/medicapp.git
git fetch upstream
```

### 4. Crear una Rama

Crea una rama descriptiva para tu trabajo:

```bash
# Para nuevas funcionalidades
git checkout -b feature/nombre-descriptivo

# Para correcciones de bugs
git checkout -b fix/nombre-del-bug

# Para documentación
git checkout -b docs/descripcion-cambio

# Para tests
git checkout -b test/descripcion-test
```

**Convenciones de nombres de ramas:**
- `feature/` - Nueva funcionalidad
- `fix/` - Corrección de bug
- `docs/` - Cambios en documentación
- `test/` - Agregar o mejorar tests
- `refactor/` - Refactorización sin cambios funcionales
- `style/` - Cambios de formato/estilo
- `chore/` - Tareas de mantenimiento

### 5. Hacer Cambios

Realiza tus cambios siguiendo las [Convenciones de Código](#convenciones-de-código).

### 6. Escribir Tests

**Todos los cambios de código deben incluir tests apropiados:**

```bash
# Ejecutar tests durante desarrollo
flutter test

# Ejecutar tests específicos
flutter test test/ruta/al/test.dart

# Ver cobertura
flutter test --coverage
```

Consulta la sección [Guía de Testing](#guía-de-testing) para más detalles.

### 7. Formatear el Código

Asegúrate de que tu código esté formateado correctamente:

```bash
# Formatear todo el proyecto
dart format .

# Verificar análisis estático
flutter analyze
```

### 8. Hacer Commits

Crea commits siguiendo las [Convenciones de Commits](#convenciones-de-commits):

```bash
git add .
git commit -m "feat: agregar notificación de recordatorio de recarga"
```

### 9. Mantener tu Rama Actualizada

Sincroniza regularmente con el repositorio upstream:

```bash
git fetch upstream
git rebase upstream/main
```

### 10. Push de Cambios

Sube tus cambios a tu fork:

```bash
git push origin nombre-de-tu-rama
```

### 11. Crear Pull Request

Crea un PR desde GitHub siguiendo la [Guía de Pull Requests](#guía-de-pull-requests).

---

## Convenciones de Código

Mantener un código consistente es fundamental para la mantenibilidad del proyecto.

### Dart Style Guide

Seguimos la [Guía de Estilo de Dart](https://dart.dev/guides/language/effective-dart/style) oficial:

- **Nombres de clases**: `PascalCase` (ej. `MedicationService`)
- **Nombres de variables/funciones**: `camelCase` (ej. `getMedications`)
- **Nombres de constantes**: `camelCase` (ej. `maxNotifications`)
- **Nombres de archivos**: `snake_case` (ej. `medication_service.dart`)
- **Nombres de carpetas**: `snake_case` (ej. `notification_service`)

### Linting

El proyecto usa `flutter_lints` configurado en `analysis_options.yaml`:

```bash
# Ejecutar análisis estático
flutter analyze

# No debe haber errores ni warnings
```

Todos los PRs deben pasar el análisis sin errores ni warnings.

### Formato Automático

Usa `dart format` antes de hacer commit:

```bash
# Formatear todo el código
dart format .

# Formatear archivo específico
dart format lib/services/medication_service.dart
```

**Configuración en editores:**

- **VS Code**: Activa "Format On Save" en configuración
- **Android Studio**: Settings > Editor > Code Style > Dart > Set from: Dart Official

### Naming Conventions

**Variables booleanas:**
```dart
// Bien
bool isActive = true;
bool hasNotifications = false;
bool requiresFasting = true;

// Mal
bool active = true;
bool notifications = false;
```

**Métodos que retornan valores:**
```dart
// Bien
List<Medication> getMedications();
Future<bool> saveMedication(Medication med);
String calculateNextDose();

// Mal
List<Medication> medications();
Future<bool> medication(Medication med);
```

**Métodos privados:**
```dart
// Bien
void _updateDatabase() { }
String _formatDate(DateTime date) { }

// Mal
void updateDatabase() { }  // debería ser privado
String formatDate(DateTime date) { }  // debería ser privado
```

### Organización de Archivos

**Orden de imports:**
```dart
// 1. Imports de dart:
import 'dart:async';
import 'dart:convert';

// 2. Imports de package:
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

// 3. Imports relativos del proyecto:
import '../models/medication.dart';
import '../services/database_service.dart';
```

**Orden de miembros en clases:**
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

### Comentarios y Documentación

**Documentar APIs públicas:**
```dart
/// Obtiene todos los medicamentos de una persona específica.
///
/// Retorna una lista de [Medication] para la [personId] proporcionada.
/// La lista está ordenada por nombre alfabéticamente.
///
/// Lanza [DatabaseException] si ocurre un error en la base de datos.
Future<List<Medication>> getMedicationsByPerson(String personId) async {
  // Implementación...
}
```

**Comentarios inline cuando sea necesario:**
```dart
// Calcular días restantes basado en consumo promedio
final daysRemaining = stockQuantity / averageDailyConsumption;
```

**Evitar comentarios obvios:**
```dart
// Mal - comentario innecesario
// Incrementar el contador en 1
count++;

// Bien - código auto-descriptivo
count++;
```

---

## Convenciones de Commits

Usamos commits semánticos para mantener un historial claro y legible.

### Formato

```
tipo: descripción breve en minúsculas

[cuerpo opcional con más detalles]

[footer opcional con referencias a issues]
```

### Tipos de Commits

| Tipo | Descripción | Ejemplo |
|------|-------------|---------|
| `feat` | Nueva funcionalidad | `feat: agregar soporte para múltiples personas` |
| `fix` | Corrección de bug | `fix: corregir cálculo de stock en timezone diferente` |
| `docs` | Cambios en documentación | `docs: actualizar guía de instalación` |
| `test` | Agregar o modificar tests | `test: agregar tests para ayuno a medianoche` |
| `refactor` | Refactorización sin cambios funcionales | `refactor: extraer lógica de notificaciones a servicio` |
| `style` | Cambios de formato | `style: formatear código según dart format` |
| `chore` | Tareas de mantenimiento | `chore: actualizar dependencias` |
| `perf` | Mejoras de rendimiento | `perf: optimizar consultas de base de datos` |

### Ejemplos de Buenos Commits

```bash
# Nuevo feature con descripción
git commit -m "feat: agregar notificaciones de ayuno con duración personalizable"

# Fix con referencia a issue
git commit -m "fix: corregir cálculo de próxima dosis (#123)"

# Docs
git commit -m "docs: agregar sección de contribución en README"

# Test
git commit -m "test: agregar tests de integración para múltiples ayunos"

# Refactor con contexto
git commit -m "refactor: separar lógica de medicamentos en clases específicas

- Crear MedicationValidator para validaciones
- Extraer cálculos de stock a MedicationStockCalculator
- Mejorar legibilidad del código"
```

### Ejemplos de Commits a Evitar

```bash
# Mal - demasiado vago
git commit -m "fix bug"
git commit -m "update"
git commit -m "changes"

# Mal - sin tipo
git commit -m "agregar nueva funcionalidad"

# Mal - tipo incorrecto
git commit -m "docs: agregar nueva pantalla"  # debería ser 'feat'
```

### Reglas Adicionales

- **Primera letra en minúscula**: "feat: agregar..." no "feat: Agregar..."
- **Sin punto final**: "feat: agregar soporte" no "feat: agregar soporte."
- **Modo imperativo**: "agregar" no "agregado" o "agregando"
- **Máximo 72 caracteres**: Mantén la primera línea concisa
- **Cuerpo opcional**: Usa el cuerpo para explicar el "por qué", no el "qué"

---

## Guía de Pull Requests

### Antes de Crear el PR

**Checklist:**

- [ ] Tu código compila sin errores: `flutter run`
- [ ] Todos los tests pasan: `flutter test`
- [ ] El código está formateado: `dart format .`
- [ ] No hay warnings de análisis: `flutter analyze`
- [ ] Has agregado tests para tu cambio
- [ ] La cobertura de tests se mantiene >= 75%
- [ ] Has actualizado la documentación si es necesario
- [ ] Los commits siguen las convenciones
- [ ] Tu rama está actualizada con `main`

### Crear el Pull Request

**Título descriptivo:**

```
feat: agregar soporte para períodos de ayuno personalizables
fix: corregir crash en notificaciones a medianoche
docs: mejorar documentación de arquitectura
```

**Descripción detallada:**

```markdown
## Descripción

Este PR agrega soporte para períodos de ayuno personalizables, permitiendo a los usuarios configurar duraciones específicas antes o después de tomar un medicamento.

## Cambios realizados

- Agregar campos `fastingType` y `fastingDurationMinutes` al modelo Medication
- Implementar lógica de validación de períodos de ayuno
- Agregar UI para configurar ayuno en pantalla de edición de medicamento
- Crear notificaciones ongoing para períodos de ayuno activos
- Agregar tests exhaustivos (15 nuevos tests)

## Tipo de cambio

- [x] Nueva funcionalidad (cambio que agrega funcionalidad sin romper código existente)
- [ ] Corrección de bug (cambio que soluciona un issue)
- [ ] Cambio que rompe compatibilidad (fix o feature que causaría que funcionalidad existente cambie)
- [ ] Este cambio requiere actualización de documentación

## Screenshots

_Si aplica, agregar capturas de pantalla de cambios en UI_

## Tests

- [x] Tests unitarios agregados
- [x] Tests de integración agregados
- [x] Todos los tests existentes pasan
- [x] Cobertura >= 75%

## Checklist

- [x] Código sigue las convenciones del proyecto
- [x] He revisado mi propio código
- [x] He comentado áreas complejas
- [x] He actualizado la documentación
- [x] Mis cambios no generan warnings
- [x] He agregado tests que prueban mi fix/funcionalidad
- [x] Tests nuevos y existentes pasan localmente

## Issues relacionados

Closes #123
Relacionado con #456
```

### Durante la Revisión

**Responde a comentarios:**
- Agradece el feedback
- Responde preguntas con claridad
- Realiza cambios solicitados prontamente
- Marca conversaciones como resueltas después de aplicar cambios

**Mantén el PR actualizado:**
```bash
# Si hay cambios en main, actualiza tu rama
git fetch upstream
git rebase upstream/main
git push origin tu-rama --force-with-lease
```

### Después del Merge

**Limpieza:**
```bash
# Actualizar tu fork
git checkout main
git pull upstream main
git push origin main

# Eliminar rama local
git branch -d tu-rama

# Eliminar rama remota (opcional)
git push origin --delete tu-rama
```

---

## Guía de Testing

El testing es **obligatorio** para todas las contribuciones de código.

### Principios

- **Todos los PRs deben incluir tests**: Sin excepción
- **Mantener cobertura mínima**: >= 75%
- **Tests deben ser independientes**: Cada test debe poder ejecutarse solo
- **Tests deben ser determinísticos**: Mismo input = mismo output siempre
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
  testWidgets('muestra lista de medicamentos correctamente', (tester) async {
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
  testWidgets('flujo completo de agregar medicamento', (tester) async {
    // Setup
    await tester.pumpWidget(MyApp());

    // Agregar medicamento
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verificar navegación y guardado
    expect(find.text('Nuevo Medicamento'), findsOneWidget);
  });
}
```

### Usar MedicationBuilder

Para crear medicamentos de prueba, usa el helper `MedicationBuilder`:

```dart
import 'package:medicapp/test/helpers/medication_builder.dart';

// Medicamento básico
final med = MedicationBuilder()
  .withName('Aspirina')
  .withStock(20.0)
  .build();

// Con ayuno
final medWithFasting = MedicationBuilder()
  .withName('Ibuprofeno')
  .withFasting(type: 'before', duration: 60)
  .build();

// Con múltiples dosis
final medMultipleDoses = MedicationBuilder()
  .withName('Vitamina C')
  .withMultipleDoses(['08:00', '14:00', '20:00'], 1.0)
  .build();

// Con stock bajo
final medLowStock = MedicationBuilder()
  .withName('Paracetamol')
  .withLowStock()
  .build();
```

### Ejecutar Tests

```bash
# Todos los tests
flutter test

# Test específico
flutter test test/models/medication_test.dart

# Con cobertura
flutter test --coverage

# Ver reporte de cobertura (requiere genhtml)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Cobertura de Tests

**Objetivo: >= 75% de cobertura**

```bash
# Generar reporte
flutter test --coverage

# Ver cobertura por archivo
lcov --list coverage/lcov.info
```

**Áreas críticas que DEBEN tener tests:**
- Modelos y lógica de negocio (95%+)
- Services y utilidades (90%+)
- Screens y widgets principales (70%+)

**Áreas donde la cobertura puede ser menor:**
- Widgets puramente visuales
- Configuración inicial (main.dart)
- Archivos generados automáticamente

---

## Agregar Nuevas Funcionalidades

### Antes de Empezar

1. **Discutir en un issue primero**: Crea un issue describiendo tu propuesta
2. **Esperar feedback**: Los mantenedores revisarán y darán feedback
3. **Obtener aprobación**: Espera luz verde antes de invertir tiempo en implementar

### Seguir la Arquitectura

MedicApp usa **arquitectura MVS (Model-View-Service)**:

```
lib/
├── models/           # Modelos de datos
├── screens/          # Vistas (UI)
├── services/         # Lógica de negocio
└── l10n/            # Traducciones
```

**Principios:**
- **Models**: Solo datos, sin lógica de negocio
- **Services**: Toda la lógica de negocio y acceso a datos
- **Screens**: Solo UI, mínima lógica

**Ejemplo de nueva funcionalidad:**

```dart
// 1. Agregar modelo (si necesario)
// lib/models/reminder.dart
class Reminder {
  final String id;
  final String medicationId;
  final DateTime reminderTime;

  Reminder({required this.id, required this.medicationId, required this.reminderTime});
}

// 2. Agregar servicio
// lib/services/reminder_service.dart
class ReminderService {
  Future<void> scheduleReminder(Reminder reminder) async {
    // Lógica de negocio
  }
}

// 3. Agregar pantalla/widget
// lib/screens/reminder_screen.dart
class ReminderScreen extends StatelessWidget {
  // Solo UI, delega lógica al servicio
}

// 4. Agregar tests
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

Al agregar nueva funcionalidad:

- [ ] Actualizar `docs/es/features.md`
- [ ] Agregar ejemplos de uso
- [ ] Actualizar diagramas si aplica
- [ ] Agregar comentarios de documentación en código

### Considerar Internacionalización

MedicApp soporta 8 idiomas. **Toda nueva funcionalidad debe ser traducida:**

```dart
// En lugar de texto hardcodeado:
Text('New Medication')

// Usar traducciones:
Text(AppLocalizations.of(context)!.newMedication)
```

Agrega las claves en todos los archivos `.arb`:
- `lib/l10n/app_es.arb`
- `lib/l10n/app_en.arb`
- `lib/l10n/app_de.arb`
- `lib/l10n/app_fr.arb`
- `lib/l10n/app_it.arb`
- `lib/l10n/app_ca.arb`
- `lib/l10n/app_eu.arb`
- `lib/l10n/app_gl.arb`

### Agregar Tests Exhaustivos

Nueva funcionalidad requiere tests completos:

- Tests unitarios para toda la lógica
- Tests de widgets para UI
- Tests de integración para flujos completos
- Tests de edge cases y errores

---

## Reportar Bugs

### Información Requerida

Al reportar un bug, incluye:

**1. Descripción del bug:**
Descripción clara y concisa del problema.

**2. Pasos para reproducir:**
```
1. Ir a pantalla 'Medicamentos'
2. Hacer clic en 'Agregar medicamento'
3. Configurar ayuno de 60 minutos
4. Guardar medicamento
5. Ver error en consola
```

**3. Comportamiento esperado:**
"Debería guardarse el medicamento con la configuración de ayuno."

**4. Comportamiento actual:**
"Se muestra un error 'Invalid fasting duration' y no se guarda el medicamento."

**5. Screenshots/Videos:**
Si aplica, agrega capturas de pantalla o grabación de pantalla.

**6. Logs/Errores:**
```
[ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception:
Invalid fasting duration
#0      Medication.validate (package:medicapp/models/medication.dart:123)
```

**7. Entorno:**
```
- Flutter version: 3.9.2
- Dart version: 3.0.0
- Dispositivo: Samsung Galaxy S21
- OS: Android 13
- Versión de MedicApp: 1.0.0
```

**8. Contexto adicional:**
Cualquier otra información relevante sobre el problema.

### Template de Issue

```markdown
## Descripción del Bug
[Descripción clara y concisa]

## Pasos para Reproducir
1.
2.
3.

## Comportamiento Esperado
[Qué debería pasar]

## Comportamiento Actual
[Qué está pasando actualmente]

## Screenshots
[Si aplica]

## Logs/Errores
```
[Copiar logs aquí]
```

## Entorno
- Flutter version:
- Dart version:
- Dispositivo:
- OS y versión:
- Versión de MedicApp:

## Contexto Adicional
[Información adicional]
```

---

## Agregar Traducciones

MedicApp soporta 8 idiomas. Ayúdanos a mantener traducciones de alta calidad.

### Ubicación de Archivos

Los archivos de traducción están en:

```
lib/l10n/
├── app_es.arb    # Español (base)
├── app_en.arb    # Inglés
├── app_de.arb    # Alemán
├── app_fr.arb    # Francés
├── app_it.arb    # Italiano
├── app_ca.arb    # Catalán
├── app_eu.arb    # Euskera
└── app_gl.arb    # Gallego
```

### Agregar un Nuevo Idioma

**1. Copiar plantilla:**
```bash
cp lib/l10n/app_es.arb lib/l10n/app_XX.arb
```

**2. Traducir todas las claves:**
```json
{
  "appTitle": "MedicApp",
  "@appTitle": {
    "description": "Título de la aplicación"
  },
  "medications": "Medicamentos",
  "@medications": {
    "description": "Título de la pantalla de medicamentos"
  }
}
```

**3. Actualizar `l10n.yaml`** (si existe):
```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
```

**4. Registrar el idioma en `MaterialApp`:**
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
    const Locale('XX'),  // Nuevo idioma
  ],
  // ...
)
```

**5. Ejecutar generación de código:**
```bash
flutter pub get
# Las traducciones se generan automáticamente
```

**6. Probar en la app:**
```dart
// Cambiar idioma temporalmente para probar
Locale('XX')
```

### Mejorar Traducciones Existentes

**1. Identificar el archivo:**
Por ejemplo, para mejorar inglés: `lib/l10n/app_en.arb`

**2. Buscar la clave:**
```json
{
  "lowStockWarning": "Low stock warning",
  "@lowStockWarning": {
    "description": "Advertencia de stock bajo"
  }
}
```

**3. Mejorar la traducción:**
```json
{
  "lowStockWarning": "Running low on medication",
  "@lowStockWarning": {
    "description": "Advertencia cuando queda poco stock de medicamento"
  }
}
```

**4. Crear PR** con el cambio.

### Lineamientos de Traducción

- **Mantener consistencia**: Usa los mismos términos a lo largo de todas las traducciones
- **Contexto apropiado**: Considera el contexto médico
- **Longitud razonable**: Evita traducciones muy largas que rompan UI
- **Formalidad**: Usa un tono profesional pero amigable
- **Probar en UI**: Verifica que la traducción se vea bien en pantalla

---

## Configuración del Entorno de Desarrollo

### Requisitos

- **Flutter SDK**: 3.9.2 o superior
- **Dart SDK**: 3.0 o superior
- **Editor**: VS Code o Android Studio recomendados
- **Git**: Para control de versiones

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
3. Agregar `C:\src\flutter\bin` al PATH
4. Ejecutar `flutter doctor`

### Configuración del Editor

**VS Code (Recomendado):**

1. **Instalar extensiones:**
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
   - `Cmd/Ctrl + .` - Acciones rápidas
   - `Cmd/Ctrl + Shift + P` - Command Palette
   - `F5` - Debug
   - `Ctrl + F5` - Run sin debug

**Android Studio:**

1. **Instalar plugins:**
   - Flutter plugin
   - Dart plugin

2. **Configurar:**
   - Settings > Editor > Code Style > Dart
   - Set from: Dart Official
   - Line length: 80

### Configuración del Linter

El proyecto usa `flutter_lints`. Ya está configurado en `analysis_options.yaml`.

```bash
# Ejecutar análisis
flutter analyze

# Ver issues en tiempo real en el editor
# (automático en VS Code y Android Studio)
```

### Configuración de Git

```bash
# Configurar identidad
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"

# Configurar editor predeterminado
git config --global core.editor "code --wait"

# Configurar alias útiles
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
```

### Ejecutar el Proyecto

```bash
# Instalar dependencias
flutter pub get

# Ejecutar en emulador/dispositivo
flutter run

# Ejecutar en modo debug
flutter run --debug

# Ejecutar en modo release
flutter run --release

# Hot reload (durante ejecución)
# Presionar 'r' en terminal

# Hot restart (durante ejecución)
# Presionar 'R' en terminal
```

### Problemas Comunes

**"Flutter SDK not found":**
```bash
# Verificar PATH
echo $PATH  # macOS/Linux
echo %PATH%  # Windows

# Agregar Flutter al PATH
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

### Documentación del Proyecto

- [Guía de Instalación](installation.md)
- [Características](features.md)
- [Arquitectura](architecture.md)
- [Base de Datos](database.md)
- [Estructura del Proyecto](project-structure.md)
- [Tecnologías](technologies.md)

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

### Herramientas

- [Dart Pad](https://dartpad.dev/) - Playground online de Dart
- [FlutLab](https://flutlab.io/) - IDE online de Flutter
- [DartDoc](https://dart.dev/tools/dartdoc) - Generador de documentación
- [Flutter Inspector](https://docs.flutter.dev/development/tools/devtools/inspector) - Debug de widgets

### Comunidad

- [Flutter Discord](https://discord.gg/flutter)
- [r/FlutterDev](https://www.reddit.com/r/FlutterDev/)
- [Stack Overflow - Flutter](https://stackoverflow.com/questions/tagged/flutter)

---

## Preguntas Frecuentes

### ¿Cómo empiezo a contribuir?

1. Lee esta guía completa
2. Configura tu entorno de desarrollo
3. Busca issues etiquetados como `good first issue`
4. Comenta en el issue que trabajarás en él
5. Sigue el [Proceso de Contribución](#proceso-de-contribución)

### ¿Dónde puedo ayudar?

Áreas donde siempre necesitamos ayuda:

- **Traducciones**: Mejorar o agregar traducciones
- **Documentación**: Expandir o mejorar docs
- **Tests**: Aumentar cobertura de tests
- **Bugs**: Resolver issues reportados
- **UI/UX**: Mejorar interfaz y experiencia de usuario

Busca issues con etiquetas:
- `good first issue` - Ideal para empezar
- `help wanted` - Necesitamos ayuda aquí
- `documentation` - Relacionado con docs
- `translation` - Traducciones
- `bug` - Bugs reportados

### ¿Cuánto tiempo toman los reviews?

- **PRs pequeños** (< 100 líneas): 1-2 días
- **PRs medianos** (100-500 líneas): 3-5 días
- **PRs grandes** (> 500 líneas): 1-2 semanas

**Tips para reviews más rápidos:**
- Mantén PRs pequeños y enfocados
- Escribe buenas descripciones
- Responde a comentarios prontamente
- Incluye tests completos

### ¿Qué hago si mi PR no es aceptado?

No te desanimes. Hay varias razones:

1. **No alineado con visión del proyecto**: Discute la idea en un issue primero
2. **Necesita cambios**: Aplica el feedback y actualiza el PR
3. **Problemas técnicos**: Arregla los issues mencionados
4. **Timing**: Puede que no sea el momento adecuado, pero se reconsiderará después

**Siempre aprenderás algo valioso del proceso.**

### ¿Puedo trabajar en múltiples issues a la vez?

Recomendamos enfocarte en uno a la vez:

- Completa un issue antes de empezar otro
- Evita bloquear issues para otros
- Si necesitas pausar, comenta en el issue

### ¿Cómo manejo conflictos de merge?

```bash
# Actualizar tu rama con main
git fetch upstream
git rebase upstream/main

# Si hay conflictos, Git te lo dirá
# Resuelve conflictos en tu editor
# Luego:
git add .
git rebase --continue

# Push (con force si ya habías pusheado antes)
git push origin tu-rama --force-with-lease
```

### ¿Necesito firmar un CLA?

Actualmente **no** requerimos CLA (Contributor License Agreement). Al contribuir, aceptas que tu código se licencie bajo AGPL-3.0.

### ¿Puedo contribuir anónimamente?

Sí, pero necesitas una cuenta de GitHub. Puedes usar un nombre de usuario anónimo si prefieres.

---

## Contacto y Comunidad

### GitHub Issues

La forma principal de comunicación es a través de [GitHub Issues](../../issues):

- **Reportar bugs**: Crea un issue con label `bug`
- **Sugerir mejoras**: Crea un issue con label `enhancement`
- **Hacer preguntas**: Crea un issue con label `question`
- **Discutir ideas**: Crea un issue con label `discussion`

### Discussions (si aplica)

Si el repositorio tiene GitHub Discussions habilitado:

- Preguntas generales
- Mostrar tus proyectos con MedicApp
- Compartir ideas
- Ayudar a otros usuarios

### Tiempos de Respuesta

- **Issues urgentes** (bugs críticos): 24-48 horas
- **Issues normales**: 3-7 días
- **PRs**: Según tamaño (ver FAQ)
- **Preguntas**: 2-5 días

### Mantenedores

Los mantenedores del proyecto revisarán issues, PRs y responderán preguntas. Ten paciencia, somos un equipo pequeño que trabaja en esto en nuestro tiempo libre.

---

## Agradecimientos

Gracias por leer esta guía y por tu interés en contribuir a MedicApp.

Cada contribución, por pequeña que sea, hace una diferencia para los usuarios que dependen de esta aplicación para gestionar su salud.

**¡Esperamos tu contribución!**

---

**Licencia:** Este proyecto está bajo [AGPL-3.0](../../LICENSE).

**Última actualización:** 2025-11-14
