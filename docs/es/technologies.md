# Stack Tecnológico de MedicApp

Este documento detalla todas las tecnologías, frameworks, bibliotecas y herramientas utilizadas en MedicApp, incluyendo las versiones exactas, justificaciones de elección, alternativas consideradas y trade-offs de cada decisión tecnológica.

---

## 1. Core Technologies

### Flutter 3.9.2+

**Versión utilizada:** `3.9.2+` (SDK compatible hasta `3.35.7+`)

**Propósito:**
Flutter es el framework multiplataforma que constituye la base de MedicApp. Permite desarrollar una aplicación nativa para Android e iOS desde una única base de código Dart, garantizando rendimiento cercano al nativo y experiencia de usuario consistente en ambas plataformas.

**Por qué se eligió Flutter:**

1. **Desarrollo multiplataforma eficiente:** Un solo código base para Android e iOS reduce costos de desarrollo y mantenimiento en un 60-70% comparado con desarrollo nativo dual.

2. **Rendimiento nativo:** Flutter compila a código nativo ARM, no utiliza puentes JavaScript como React Native, lo que resulta en animaciones fluidas a 60/120 FPS y tiempos de respuesta instantáneos para operaciones críticas como registro de dosis.

3. **Hot Reload:** Permite iteración rápida durante el desarrollo, visualizando cambios en menos de 1 segundo sin perder el estado de la aplicación. Esencial para ajustar la UI de notificaciones y flujos multi-paso.

4. **Material Design 3 nativo:** Implementación completa y actualizada de Material Design 3 incluida en el SDK, sin necesidad de bibliotecas de terceros.

5. **Ecosistema maduro:** Pub.dev cuenta con más de 40,000 paquetes, incluyendo soluciones robustas para notificaciones locales, base de datos SQLite y gestión de archivos.

6. **Testing integrado:** Framework de testing completo incluido en el SDK, con soporte para unit tests, widget tests e integration tests. MedicApp alcanza 432+ tests con cobertura del 75-80%.

**Alternativas consideradas:**

- **React Native:** Descartado por rendimiento inferior en listas largas (historial de dosis), problemas con notificaciones locales en segundo plano, y experiencia inconsistente entre plataformas.
- **Kotlin Multiplatform Mobile (KMM):** Descartado por inmadurez del ecosistema, necesidad de código UI específico por plataforma, y curva de aprendizaje más pronunciada.
- **Nativo (Swift + Kotlin):** Descartado por duplicación de esfuerzo de desarrollo, mayores costos de mantenimiento, y necesidad de dos equipos especializados.

**Documentación oficial:** https://flutter.dev

---

### Dart 3.0+

**Versión utilizada:** `3.9.2+` (compatible con Flutter 3.9.2+)

**Propósito:**
Dart es el lenguaje de programación orientado a objetos desarrollado por Google que ejecuta Flutter. Proporciona sintaxis moderna, tipado fuerte, null safety y rendimiento optimizado.

**Características utilizadas en MedicApp:**

1. **Null Safety:** Sistema de tipos que elimina errores de referencia nula en tiempo de compilación. Crítico para la fiabilidad de un sistema médico donde un NullPointerException podría impedir el registro de una dosis vital.

2. **Async/Await:** Programación asíncrona elegante para operaciones de base de datos, notificaciones y operaciones de archivo sin bloquear la UI.

3. **Extension Methods:** Permite extender clases existentes con métodos personalizados, utilizado para formateo de fechas y validaciones de modelos.

4. **Records y Pattern Matching (Dart 3.0+):** Estructuras de datos inmutables para devolver múltiples valores desde funciones de manera segura.

5. **Strong Type System:** Tipado estático que detecta errores en tiempo de compilación, esencial para operaciones críticas como cálculo de stock y programación de notificaciones.

**Por qué Dart:**

- **Optimizado para UI:** Dart fue diseñado específicamente para desarrollo de interfaces, con recolección de basura optimizada para evitar pauses durante animaciones.
- **AOT y JIT:** Compilación Ahead-of-Time para producción (rendimiento nativo) y Just-in-Time para desarrollo (Hot Reload).
- **Sintaxis familiar:** Similar a Java, C#, JavaScript, reduciendo la curva de aprendizaje.
- **Sound Null Safety:** Garantía en tiempo de compilación de que las variables no nulas nunca serán null.

**Documentación oficial:** https://dart.dev

---

### Material Design 3

**Versión:** Implementación nativa en Flutter 3.9.2+

**Propósito:**
Material Design 3 (Material You) es el sistema de diseño de Google que proporciona componentes, patrones y directrices para crear interfaces modernas, accesibles y consistentes.

**Implementación en MedicApp:**

```dart
useMaterial3: true
```

**Componentes utilizados:**

1. **Color Scheme dinámico:** Sistema de colores basado en semillas (`seedColor: Color(0xFF006B5A)` para tema claro, `Color(0xFF00A894)` para tema oscuro) que genera automáticamente 30+ tonalidades armónicas.

2. **FilledButton, OutlinedButton, TextButton:** Botones con estados visuales (hover, pressed, disabled) y tamaños aumentados (52dp altura mínima) para accesibilidad.

3. **Card con elevación adaptativa:** Tarjetas con esquinas redondeadas (16dp) y sombras sutiles para jerarquía visual.

4. **NavigationBar:** Barra de navegación inferior con indicadores de selección animados y soporte para navegación entre 3-5 destinos principales.

5. **FloatingActionButton extendido:** FAB con texto descriptivo para acción primaria (añadir medicamento).

6. **ModalBottomSheet:** Hojas modales para acciones contextuales como registro rápido de dosis.

7. **SnackBar con acciones:** Feedback temporal para operaciones completadas (dosis registrada, medicamento añadido).

**Temas personalizados:**

MedicApp implementa dos temas completos (claro y oscuro) con tipografía accesible:

- **Tamaños de fuente aumentados:** `titleLarge: 26sp`, `bodyLarge: 19sp` (superiores a los estándares de 22sp y 16sp respectivamente).
- **Contraste mejorado:** Colores de texto con opacidad 87% sobre fondos para cumplir WCAG AA.
- **Botones grandes:** Altura mínima de 52dp (vs 40dp estándar) para facilitar toque en dispositivos móviles.

**Por qué Material Design 3:**

- **Accesibilidad integrada:** Componentes diseñados con soporte de lectores de pantalla, tamaños táctiles mínimos y ratios de contraste WCAG.
- **Coherencia con el ecosistema Android:** Aspecto familiar para usuarios de Android 12+.
- **Personalización flexible:** Sistema de tokens de diseño que permite adaptar colores, tipografías y formas manteniendo coherencia.
- **Modo oscuro automático:** Soporte nativo para tema oscuro basado en configuración del sistema.

**Documentación oficial:** https://m3.material.io

---

## 2. Base de Datos y Persistencia

### sqflite ^2.3.0

**Versión utilizada:** `^2.3.0` (compatible con `2.3.0` hasta `< 3.0.0`)

**Propósito:**
sqflite es el plugin de SQLite para Flutter que proporciona acceso a una base de datos SQL local, relacional y transaccional. MedicApp utiliza SQLite como almacenamiento principal para todos los datos de medicamentos, personas, configuraciones de pautas y historial de dosis.

**Arquitectura de base de datos de MedicApp:**

```
medicapp.db
├── medications (tabla principal)
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
├── person_medications (tabla de relación N:M)
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

**Operaciones críticas:**

1. **Transacciones ACID:** Garantía de atomicidad para operaciones complejas como registro de dosis + descuento de stock + programación de notificación.

2. **Consultas relacionales:** JOINs entre `medications`, `persons` y `person_medications` para obtener configuraciones personalizadas por usuario.

3. **Índices optimizados:** Índices en `person_id` y `medication_id` en tablas de relación para consultas rápidas O(log n).

4. **Migraciones versionadas:** Sistema de migración de esquema desde V1 hasta V19+ con preservación de datos.

**Por qué SQLite:**

1. **ACID compliance:** Garantías transaccionales críticas para datos médicos donde la integridad es fundamental.

2. **Consultas SQL complejas:** Capacidad de realizar JOINs, agregaciones y subconsultas para reportes y filtros avanzados.

3. **Rendimiento probado:** SQLite es la base de datos más desplegada del mundo, con optimizaciones de 20+ años.

4. **Zero-configuration:** No requiere servidor, configuración o administración. La base de datos es un único archivo portátil.

5. **Exportación/importación simple:** El archivo `.db` puede copiarse directamente para backups o transferencias entre dispositivos.

6. **Tamaño ilimitado:** SQLite soporta bases de datos de hasta 281 terabytes, más que suficiente para décadas de historial de dosis.

**Comparativa con alternativas:**

| Característica | SQLite (sqflite) | Hive | Isar | Drift |
|----------------|------------------|------|------|-------|
| **Modelo de datos** | Relacional SQL | NoSQL Key-Value | NoSQL Documental | Relacional SQL |
| **Lenguaje de consulta** | SQL estándar | API Dart | Query Builder Dart | SQL + Dart |
| **Transacciones ACID** | ✅ Completo | ❌ Limitado | ✅ Sí | ✅ Sí |
| **Migraciones** | ✅ Manual robusto | ⚠️ Manual básico | ⚠️ Semi-automático | ✅ Automático |
| **Rendimiento lectura** | ⚡ Excelente | ⚡⚡ Superior | ⚡⚡ Superior | ⚡ Excelente |
| **Rendimiento escritura** | ⚡ Muy bueno | ⚡⚡ Excelente | ⚡⚡ Excelente | ⚡ Muy bueno |
| **Tamaño en disco** | ⚠️ Más grande | ✅ Compacto | ✅ Muy compacto | ⚠️ Más grande |
| **Relaciones N:M** | ✅ Nativo | ❌ Manual | ⚠️ Referencias | ✅ Nativo |
| **Madurez** | ✅ 20+ años | ⚠️ 4 años | ⚠️ 3 años | ✅ 5+ años |
| **Portabilidad** | ✅ Universal | ⚠️ Propietario | ⚠️ Propietario | ⚠️ Flutter-only |
| **Herramientas externas** | ✅ DB Browser, CLI | ❌ Limitadas | ❌ Limitadas | ❌ Ninguna |

**Justificación de SQLite sobre alternativas:**

- **Hive:** Descartado por falta de soporte robusto para relaciones N:M (arquitectura multi-persona), ausencia de transacciones ACID completas, y dificultad para realizar consultas complejas con JOINs.

- **Isar:** Descartado a pesar de su excelente rendimiento debido a su inmadurez (lanzado en 2022), formato propietario que dificulta debugging con herramientas estándar, y limitaciones en consultas relacionales complejas.

- **Drift:** Considerado seriamente pero descartado por mayor complejidad (requiere generación de código), mayor tamaño de la aplicación resultante, y menor flexibilidad en migraciones comparado con SQL directo.

**Trade-offs de SQLite:**

- ✅ **Pros:** Estabilidad probada, SQL estándar, herramientas externas, relaciones nativas, exportación trivial.
- ❌ **Contras:** Rendimiento ligeramente inferior a Hive/Isar en operaciones masivas, tamaño de archivo más grande, boilerplate SQL manual.

**Decisión:** Para MedicApp, la necesidad de relaciones N:M robustas, migraciones complejas de V1 a V19+, y capacidad de debugging con herramientas SQL estándar justifica ampliamente el uso de SQLite sobre alternativas NoSQL más rápidas pero menos maduras.

**Documentación oficial:** https://pub.dev/packages/sqflite

---

### sqflite_common_ffi ^2.3.0

**Versión utilizada:** `^2.3.0` (dev_dependencies)

**Propósito:**
Implementación FFI (Foreign Function Interface) de sqflite que permite ejecutar tests de base de datos en entornos desktop/VM sin necesidad de emuladores Android/iOS.

**Uso en MedicApp:**

```dart
// test/helpers/database_test_helper.dart
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void setupTestDatabase() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}
```

**Por qué es necesario:**

- **Tests 60x más rápidos:** Los tests de base de datos se ejecutan en VM local en lugar de emuladores Android, reduciendo tiempo de 120s a 2s para la suite completa.
- **CI/CD sin emuladores:** GitHub Actions puede ejecutar tests sin configurar emuladores, simplificando pipelines.
- **Debugging mejorado:** Los archivos `.db` de test son accesibles directamente desde el sistema de archivos del host.

**Documentación oficial:** https://pub.dev/packages/sqflite_common_ffi

---

### path ^1.8.3

**Versión utilizada:** `^1.8.3`

**Propósito:**
Biblioteca de manipulación de rutas de archivos multiplataforma que abstrae las diferencias entre sistemas de archivos (Windows: `\`, Unix: `/`).

**Uso en MedicApp:**

```dart
import 'package:path/path.dart' as path;

final dbPath = path.join(await getDatabasesPath(), 'medicapp.db');
```

**Documentación oficial:** https://pub.dev/packages/path

---

### path_provider ^2.1.5

**Versión utilizada:** `^2.1.5`

**Propósito:**
Plugin que proporciona acceso a directorios específicos del sistema operativo de forma multiplataforma (documentos, caché, soporte de aplicación).

**Uso en MedicApp:**

```dart
import 'package:path_provider/path_provider.dart';

// Obtener directorio de base de datos
final dbDirectory = await getDatabasesPath(); // Android: /data/data/com.medicapp/databases/

// Obtener directorio para exportaciones
final documentsDirectory = await getApplicationDocumentsDirectory();
```

**Directorios utilizados:**

1. **getDatabasesPath():** Para archivo `medicapp.db` principal.
2. **getApplicationDocumentsDirectory():** Para exportaciones de base de datos que el usuario puede compartir.
3. **getTemporaryDirectory():** Para archivos temporales durante importación.

**Documentación oficial:** https://pub.dev/packages/path_provider

---

## 3. Notificaciones

### flutter_local_notifications ^19.5.0

**Versión utilizada:** `^19.5.0`

**Propósito:**
Sistema completo de notificaciones locales (no requieren servidor) para Flutter, con soporte para notificaciones programadas, repetitivas, con acciones y personalizadas por plataforma.

**Implementación en MedicApp:**

MedicApp utiliza un sistema de notificaciones sofisticado que gestiona tres tipos de notificaciones:

1. **Notificaciones de recordatorio de dosis:**
   - Programadas con horarios exactos configurados por el usuario.
   - Incluyen título con nombre de persona (en multi-persona) y detalles de dosis.
   - Soporte para acciones rápidas: "Tomar", "Posponer", "Omitir" (descartadas en V20+ por limitaciones de tipo).
   - Sonido personalizado y canal de alta prioridad en Android.

2. **Notificaciones de dosis adelantadas:**
   - Detectan cuando una dosis se toma antes de su horario programado.
   - Actualizan automáticamente la próxima notificación si aplica.
   - Cancelan notificaciones obsoletas del horario adelantado.

3. **Notificaciones de fin de ayuno:**
   - Notificación ongoing (permanente) durante el período de ayuno con cuenta atrás.
   - Se cancela automáticamente cuando termina el ayuno o cuando se cierra manualmente.
   - Incluye progreso visual (Android) y hora de finalización.

**Configuración por plataforma:**

**Android:**
```dart
AndroidInitializationSettings('app_icon')
AndroidNotificationDetails(
  'medication_reminders',
  'Recordatorios de Medicamentos',
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

**Características avanzadas utilizadas:**

1. **Scheduling preciso:** Notificaciones programadas con precisión de segundo usando `timezone`.
2. **Canales de notificación (Android 8+):** 3 canales separados para recordatorios, ayuno y sistema.
3. **Payload personalizado:** Datos JSON en payload para identificar medicamento y persona.
4. **Callbacks de interacción:** Callbacks cuando el usuario toca la notificación.
5. **Gestión de permisos:** Solicitud y verificación de permisos en Android 13+ (Tiramisu).

**Límites y optimizaciones:**

- **Límite de 500 notificaciones programadas simultáneas** (limitación del sistema Android).
- MedicApp gestiona priorización automática cuando se supera este límite:
  - Prioriza próximas 7 días.
  - Descarta notificaciones de medicamentos inactivos.
  - Reorganiza cuando se añaden/eliminan medicamentos.

**Por qué flutter_local_notifications:**

1. **Notificaciones locales vs remotas:** MedicApp no requiere servidor backend, por lo que notificaciones locales son la arquitectura correcta.

2. **Funcionalidad completa:** Soporte para scheduling, repetición, acciones, personalización por plataforma y gestión de permisos.

3. **Madurez probada:** Paquete con 5+ años de desarrollo, 3000+ estrellas en GitHub, utilizado en producción por miles de aplicaciones.

4. **Documentación exhaustiva:** Ejemplos detallados para todos los casos de uso comunes.

**Por qué NO Firebase Cloud Messaging (FCM):**

| Criterio | flutter_local_notifications | Firebase Cloud Messaging |
|----------|----------------------------|--------------------------|
| **Requiere servidor** | ❌ No | ✅ Sí (Firebase) |
| **Requiere conexión** | ❌ No | ✅ Sí (internet) |
| **Privacidad** | ✅ Todos los datos locales | ⚠️ Tokens en Firebase |
| **Latencia** | ✅ Instantánea | ⚠️ Depende de red |
| **Costo** | ✅ Gratis | ⚠️ Cuota gratuita limitada |
| **Complejidad setup** | ✅ Mínima | ❌ Alta (Firebase, server) |
| **Funciona offline** | ✅ Siempre | ❌ No |
| **Scheduling preciso** | ✅ Sí | ❌ No (aproximado) |

**Decisión:** Para una aplicación de gestión de medicamentos donde la privacidad es crítica, las dosis deben notificarse puntualmente incluso sin conexión, y no hay necesidad de comunicación servidor-cliente, las notificaciones locales son la arquitectura correcta y más simple.

**Comparativa con alternativas:**

- **awesome_notifications:** Descartado por menor adopción (menos maduro), APIs más complejas, y problemas reportados con notificaciones programadas en Android 12+.

- **local_notifications (nativo):** Descartado por requerir código específico de plataforma (Kotlin/Swift), duplicando esfuerzo de desarrollo.

**Documentación oficial:** https://pub.dev/packages/flutter_local_notifications

---

### timezone ^0.10.1

**Versión utilizada:** `^0.10.1`

**Propósito:**
Biblioteca de gestión de zonas horarias que permite programar notificaciones en momentos específicos del día considerando cambios de horario de verano (DST) y conversiones entre zonas horarias.

**Uso en MedicApp:**

```dart
import 'package:timezone/timezone.dart' as tz;

// Inicialización
await tz.initializeTimeZones();
final location = tz.getLocation('Europe/Madrid');
tz.setLocalLocation(location);

// Programar notificación a las 08:00 locales
final scheduledDate = tz.TZDateTime(
  location,
  now.year,
  now.month,
  now.day,
  8, // hora
  0, // minutos
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

**Por qué es crítico:**

- **Horario de verano:** Sin `timezone`, las notificaciones se desfasarían 1 hora durante los cambios de DST.
- **Consistencia:** Los usuarios configuran horarios en su zona horaria local, que debe respetarse independientemente de cambios de zona horaria del dispositivo.
- **Precisión:** `zonedSchedule` garantiza notificaciones en el momento exacto especificado.

**Documentación oficial:** https://pub.dev/packages/timezone

---

### android_intent_plus ^6.0.0

**Versión utilizada:** `^6.0.0`

**Propósito:**
Plugin para lanzar intenciones (Intents) de Android desde Flutter, utilizado específicamente para abrir la configuración de notificaciones cuando los permisos están deshabilitados.

**Uso en MedicApp:**

```dart
import 'package:android_intent_plus/android_intent.dart';

// Abrir configuración de notificaciones de la app
final intent = AndroidIntent(
  action: 'android.settings.APP_NOTIFICATION_SETTINGS',
  arguments: {
    'android.provider.extra.APP_PACKAGE': packageName,
  },
);
await intent.launch();
```

**Casos de uso:**

1. **Guiar al usuario:** Cuando los permisos de notificación están deshabilitados, se muestra un diálogo explicativo con botón "Abrir Configuración" que lanza directamente la pantalla de configuración de notificaciones de MedicApp.

2. **UX mejorada:** Evita que el usuario tenga que navegar manualmente: Configuración > Aplicaciones > MedicApp > Notificaciones.

**Documentación oficial:** https://pub.dev/packages/android_intent_plus

---

## 4. Localización (i18n)

### flutter_localizations (SDK)

**Versión utilizada:** Incluido en Flutter SDK

**Propósito:**
Paquete oficial de Flutter que proporciona localizaciones para widgets de Material y Cupertino en 85+ idiomas, incluyendo traducciones de componentes estándar (botones de diálogo, pickers, etc.).

**Uso en MedicApp:**

```dart
import 'package:flutter_localizations/flutter_localizations.dart';

MaterialApp(
  localizationsDelegates: [
    GlobalMaterialLocalizations.delegate, // Material widgets
    GlobalWidgetsLocalizations.delegate,  // Widgets genéricos
    GlobalCupertinoLocalizations.delegate, // Cupertino (iOS)
  ],
  supportedLocales: [
    Locale('es'), // Español
    Locale('en'), // Inglés
    Locale('de'), // Alemán
    // ... 8 idiomas total
  ],
)
```

**Qué proporciona:**

- Traducciones de botones estándar: "OK", "Cancelar", "Aceptar".
- Formatos de fecha y hora localizados: "15/11/2025" (es) vs "11/15/2025" (en).
- Selectores de fecha/hora en idioma local.
- Nombres de días y meses.

**Documentación oficial:** https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization

---

### intl ^0.20.2

**Versión utilizada:** `^0.20.2`

**Propósito:**
Biblioteca de internacionalización de Dart que proporciona formateo de fechas, números, pluralización y traducción de mensajes mediante archivos ARB.

**Uso en MedicApp:**

```dart
import 'package:intl/intl.dart';

// Formateo de fechas
final formatted = DateFormat('dd/MM/yyyy').format(DateTime.now());

// Formateo de números
final stock = NumberFormat.decimalPattern().format(25.5);

// Pluralización (desde ARB)
// "{count, plural, =1{1 pastilla} other{{count} pastillas}}"
```

**Casos de uso:**

1. **Formateo de fechas:** Mostrar fechas de inicio/fin de tratamiento, historial de dosis.
2. **Formateo de números:** Mostrar stock con decimales según configuración regional.
3. **Pluralización inteligente:** Mensajes que cambian según cantidad ("1 pastilla" vs "5 pastillas").

**Documentación oficial:** https://pub.dev/packages/intl

---

### Sistema ARB (Application Resource Bundle)

**Formato utilizado:** ARB (basado en JSON)

**Propósito:**
Sistema de archivos de recursos de aplicación que permite definir traducciones de strings en formato JSON con soporte para placeholders, pluralización y metadatos.

**Configuración en MedicApp:**

**`l10n.yaml`:**
```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
untranslated-messages-file: untranslated_messages.json
```

**Estructura de archivos:**
```
lib/l10n/
├── app_es.arb (plantilla principal, español)
├── app_en.arb (traducciones inglés)
├── app_de.arb (traducciones alemán)
├── app_fr.arb (traducciones francés)
├── app_it.arb (traducciones italiano)
├── app_ca.arb (traducciones catalán)
├── app_eu.arb (traducciones euskera)
└── app_gl.arb (traducciones gallego)
```

**Ejemplo de ARB con características avanzadas:**

**`app_es.arb`:**
```json
{
  "@@locale": "es",

  "appTitle": "MedicApp",
  "@appTitle": {
    "description": "Título de la aplicación"
  },

  "medicationDose": "{count, plural, =1{1 {unit}} other{{count} {unit}}}",
  "@medicationDose": {
    "description": "Dosis de medicamento con pluralización",
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

  "stockRemaining": "Quedan {stock} {unit, plural, =1{unidad} other{unidades}}",
  "@stockRemaining": {
    "placeholders": {
      "stock": {"type": "num"},
      "unit": {"type": "String"}
    }
  }
}
```

**Generación automática:**

Flutter genera automáticamente la clase `AppLocalizations` con métodos tipados:

```dart
// Código generado en .dart_tool/flutter_gen/gen_l10n/app_localizations.dart
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

// Uso en código
Text(AppLocalizations.of(context)!.medicationDose(2.5, 'pastillas'))
// Resultado: "2.5 pastillas"
```

**Ventajas del sistema ARB:**

1. **Tipado fuerte:** Errores de traducción detectados en compilación.
2. **Placeholders seguros:** Imposible olvidar parámetros requeridos.
3. **Pluralización CLDR:** Soporte para reglas de pluralización de 200+ idiomas según Unicode CLDR.
4. **Metadatos útiles:** Descripciones y contexto para traductores.
5. **Herramientas de traducción:** Compatible con Google Translator Toolkit, Crowdin, Lokalise.

**Proceso de traducción en MedicApp:**

1. Definir strings en `app_es.arb` (plantilla).
2. Ejecutar `flutter gen-l10n` para generar código Dart.
3. Traducir a otros idiomas copiando y modificando archivos ARB.
4. Revisar `untranslated_messages.json` para detectar strings faltantes.

**Documentación oficial:** https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization#adding-your-own-localized-messages

---

### 8 Idiomas Soportados

MedicApp está completamente traducida a 8 idiomas:

| Código | Idioma | Región principal | Hablantes (millones) |
|--------|--------|------------------|----------------------|
| `es` | Español | España, Latinoamérica | 500M+ |
| `en` | English | Global | 1,500M+ |
| `de` | Deutsch | Alemania, Austria, Suiza | 130M+ |
| `fr` | Français | Francia, Canadá, África | 300M+ |
| `it` | Italiano | Italia, Suiza | 85M+ |
| `ca` | Català | Cataluña, Valencia, Baleares | 10M+ |
| `eu` | Euskara | País Vasco | 750K+ |
| `gl` | Galego | Galicia | 2.5M+ |

**Cobertura total:** ~2,500 millones de hablantes potenciales

**Strings totales:** ~450 traducciones por idioma

**Calidad de traducción:**
- Español: Nativo (plantilla)
- Inglés: Nativo
- Alemán, francés, italiano: Profesional
- Catalán, euskera, gallego: Nativo (lenguas cooficiales de España)

**Justificación de idiomas incluidos:**

- **Español:** Idioma principal del desarrollador y mercado objetivo inicial (España, Latinoamérica).
- **Inglés:** Idioma universal para alcance global.
- **Alemán, francés, italiano:** Principales idiomas de Europa occidental, mercados con alta demanda de apps de salud.
- **Catalán, euskera, gallego:** Lenguas cooficiales en España (regiones con 17M+ habitantes), mejora accesibilidad para usuarios mayores más cómodos en lengua materna.

---

## 5. Gestión de Estado

### Sin biblioteca de gestión de estado (Vanilla Flutter)

**Decisión:** MedicApp **NO utiliza** ninguna biblioteca de gestión de estado (Provider, Riverpod, BLoC, Redux, GetX).

**Por qué NO se usa gestión de estado:**

1. **Arquitectura basada en base de datos:** El estado verdadero de la aplicación reside en SQLite, no en memoria. Cada pantalla consulta la base de datos directamente para obtener datos actualizados.

2. **StatefulWidget + setState es suficiente:** Para una aplicación de complejidad media como MedicApp, `setState()` y `StatefulWidget` proporcionan gestión de estado local más que adecuada.

3. **Simplicidad sobre frameworks:** Evitar dependencias innecesarias reduce complejidad, tamaño de la aplicación y posibles breaking changes en actualizaciones.

4. **Streams de base de datos:** Para datos reactivos, se utilizan `StreamBuilder` con streams directos desde `DatabaseHelper`:

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

5. **Navegación con callbacks:** Para comunicación entre pantallas, se utilizan callbacks tradicionales de Flutter:

```dart
// Pantalla principal
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => AddMedicationScreen(
      onMedicationAdded: () {
        setState(() {}); // Refrescar lista
      },
    ),
  ),
);
```

**Comparativa con alternativas:**

| Solución | MedicApp (Vanilla) | Provider | BLoC | Riverpod |
|----------|-------------------|----------|------|----------|
| **Líneas de código adicionales** | 0 | ~500 | ~1,500 | ~800 |
| **Dependencias externas** | 0 | 1 | 2+ | 2+ |
| **Curva de aprendizaje** | ✅ Mínima | ⚠️ Media | ❌ Alta | ⚠️ Media-Alta |
| **Boilerplate** | ✅ Ninguno | ⚠️ Medio | ❌ Alto | ⚠️ Medio |
| **Testing** | ✅ Directo | ⚠️ Requiere mocks | ⚠️ Requiere setup | ⚠️ Requiere setup |
| **Rendimiento** | ✅ Excelente | ⚠️ Bueno | ⚠️ Bueno | ⚠️ Bueno |
| **Tamaño APK** | ✅ Mínimo | +50KB | +150KB | +100KB |

**Por qué NO Provider:**

- **Innecesario:** Provider está diseñado para compartir estado entre widgets profundamente anidados. MedicApp obtiene datos de la base de datos en cada pantalla raíz, sin necesidad de pasar estado hacia abajo.
- **Complejidad añadida:** Requiere `ChangeNotifier`, `MultiProvider`, context-awareness, y entender el árbol de widgets.
- **Sobre-ingeniería:** Para una aplicación con ~15 pantallas y estado en base de datos, Provider sería usar un martillo neumático para clavar un clavo.

**Por qué NO BLoC:**

- **Complejidad extrema:** BLoC (Business Logic Component) requiere entender streams, sinks, eventos, estados, y arquitectura de capas.
- **Boilerplate masivo:** Cada feature requiere 4-5 archivos (bloc, event, state, repository, test).
- **Sobre-ingeniería:** BLoC es excelente para aplicaciones empresariales con lógica de negocio compleja y múltiples desarrolladores. MedicApp es una aplicación de complejidad media donde la simplicidad es prioritaria.

**Por qué NO Riverpod:**

- **Menos maduro:** Riverpod es relativamente nuevo (2020) comparado con Provider (2018) y BLoC (2018).
- **Complejidad similar a Provider:** Requiere entender providers, autoDispose, family, y arquitectura declarativa.
- **Sin ventaja clara:** Para MedicApp, Riverpod no ofrece beneficios significativos sobre la arquitectura actual.

**Por qué NO Redux:**

- **Complejidad masiva:** Redux requiere acciones, reducers, middleware, store, e inmutabilidad estricta.
- **Boilerplate insostenible:** Incluso operaciones simples requieren múltiples archivos y cientos de líneas de código.
- **Sobre-kill total:** Redux está diseñado para aplicaciones web SPA con estado complejo en frontend. MedicApp tiene estado en SQLite, no en memoria.

**Casos donde SÍ se necesitaría gestión de estado:**

- **Estado compartido complejo en memoria:** Si múltiples pantallas necesitaran compartir objetos grandes en memoria (no aplica a MedicApp).
- **Estado global de autenticación:** Si hubiera login/sesiones (MedicApp es local, sin cuentas).
- **Sincronización en tiempo real:** Si hubiera colaboración multi-usuario en tiempo real (no aplica).
- **Lógica de negocio compleja:** Si hubiera cálculos pesados que requieren caché en memoria (MedicApp hace cálculos simples de stock y fechas).

**Decisión final:**

Para MedicApp, la arquitectura **Database as Single Source of Truth + StatefulWidget + setState** es la solución correcta. Es simple, directa, fácil de entender y mantener, y no introduce complejidad innecesaria. Añadir Provider, BLoC o Riverpod sería sobre-ingeniería pura sin beneficios tangibles.

---

## 6. Almacenamiento Local

### shared_preferences ^2.2.2

**Versión utilizada:** `^2.2.2`

**Propósito:**
Almacenamiento persistente de clave-valor para preferencias simples del usuario, configuraciones de aplicación y estados no críticos. Utiliza `SharedPreferences` en Android y `UserDefaults` en iOS.

**Uso en MedicApp:**

MedicApp utiliza `shared_preferences` para almacenar configuraciones ligeras que no justifican una tabla SQL:

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

**Datos almacenados:**

1. **Tema de aplicación:**
   - Clave: `theme_mode`
   - Valores: `ThemeMode.light`, `ThemeMode.dark`, `ThemeMode.system`
   - Uso: Persistir preferencia de tema entre sesiones.

2. **Idioma seleccionado:**
   - Clave: `locale`
   - Valores: `es`, `en`, `de`, `fr`, `it`, `ca`, `eu`, `gl`
   - Uso: Recordar idioma elegido por el usuario (override del idioma del sistema).

3. **Estado de permisos:**
   - Clave: `notifications_enabled`
   - Valores: `true`, `false`
   - Uso: Caché local del estado de permisos para evitar llamadas nativas repetidas.

4. **Primera ejecución:**
   - Clave: `first_run`
   - Valores: `true`, `false`
   - Uso: Mostrar tutorial/onboarding solo en primera ejecución.

**Por qué shared_preferences y no SQLite:**

- **Rendimiento:** Acceso instantáneo O(1) para valores simples vs consulta SQL con overhead.
- **Simplicidad:** API trivial (`getString`, `setString`) vs preparar queries SQL.
- **Propósito:** Preferencias de usuario vs datos relacionales.
- **Tamaño:** Valores pequeños (< 1KB) vs registros complejos.

**Limitaciones de shared_preferences:**

- ❌ No soporta relaciones, JOINs, transacciones.
- ❌ No apropiado para datos >100KB.
- ❌ Acceso asíncrono (requiere `await`).
- ❌ Solo tipos primitivos (String, int, double, bool, List<String>).

**Trade-offs:**

- ✅ **Pros:** API simple, rendimiento excelente, propósito correcto para preferencias.
- ❌ **Contras:** No apropiado para datos estructurados o voluminosos.

**Documentación oficial:** https://pub.dev/packages/shared_preferences

---

## 7. Operaciones de Archivos

### file_picker ^8.0.0+1

**Versión utilizada:** `^8.0.0+1`

**Propósito:**
Plugin multiplataforma para seleccionar archivos del sistema de archivos del dispositivo, con soporte para múltiples plataformas (Android, iOS, desktop, web).

**Uso en MedicApp:**

MedicApp utiliza `file_picker` exclusivamente para la función de **importación de base de datos**, permitiendo al usuario restaurar un backup o migrar datos desde otro dispositivo.

**Implementación:**

```dart
import 'package:file_picker/file_picker.dart';

Future<void> importDatabase() async {
  // Abrir selector de archivos
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['db'],
    dialogTitle: 'Seleccionar archivo de base de datos',
  );

  if (result == null) return; // Usuario canceló

  final file = result.files.single;
  final path = file.path!;

  // Validar y copiar archivo
  await DatabaseHelper.instance.importDatabase(path);

  // Recargar aplicación
  setState(() {});
}
```

**Características utilizadas:**

1. **Filtro de extensiones:** Solo permite seleccionar archivos `.db` para evitar errores del usuario.
2. **Título personalizado:** Muestra mensaje descriptivo en el diálogo del sistema.
3. **Ruta completa:** Obtiene path absoluto del archivo para copiarlo a la ubicación de la app.

**Alternativas consideradas:**

- **image_picker:** Descartado porque está diseñado específicamente para imágenes/videos, no archivos genéricos.
- **Código nativo:** Descartado porque requeriría implementar `ActivityResultLauncher` (Android) y `UIDocumentPickerViewController` (iOS) manualmente.

**Documentación oficial:** https://pub.dev/packages/file_picker

---

### share_plus ^10.1.4

**Versión utilizada:** `^10.1.4`

**Propósito:**
Plugin multiplataforma para compartir archivos, texto y URLs utilizando la hoja de compartir nativa del sistema operativo (Android Share Sheet, iOS Share Sheet).

**Uso en MedicApp:**

MedicApp utiliza `share_plus` para la función de **exportación de base de datos**, permitiendo al usuario crear un backup y compartirlo via email, cloud storage (Drive, Dropbox), Bluetooth, o guardarlo en archivos locales.

**Implementación:**

```dart
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

Future<void> exportDatabase() async {
  // Obtener ruta de la base de datos actual
  final dbPath = await DatabaseHelper.instance.getDatabasePath();

  // Crear copia temporal en directorio compartible
  final tempDir = await getTemporaryDirectory();
  final exportPath = '${tempDir.path}/medicapp_backup_${DateTime.now().millisecondsSinceEpoch}.db';

  // Copiar base de datos
  await File(dbPath).copy(exportPath);

  // Compartir archivo
  await Share.shareXFiles(
    [XFile(exportPath)],
    subject: 'Backup MedicApp',
    text: 'Base de datos de MedicApp - ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
  );
}
```

**Flujo de usuario:**

1. Usuario toca "Exportar base de datos" en menú de configuración.
2. MedicApp crea copia de `medicapp.db` con timestamp en nombre.
3. Se abre la hoja de compartir nativa del SO.
4. Usuario elige destino: Gmail (como adjunto), Drive, Bluetooth, "Guardar en archivos", etc.
5. El archivo `.db` se comparte/guarda en el destino elegido.

**Características avanzadas:**

- **XFile:** Abstracción multiplataforma de archivos que funciona en Android, iOS, desktop y web.
- **Metadatos:** Incluye nombre de archivo descriptivo y texto explicativo.
- **Compatibilidad:** Funciona con todas las apps compatibles con el protocolo de compartir del SO.

**Por qué share_plus:**

- **UX nativa:** Utiliza la interfaz de compartir que el usuario ya conoce, sin reinventar la rueda.
- **Integración perfecta:** Se integra automáticamente con todas las apps instaladas que pueden recibir archivos.
- **Multiplataforma:** Mismo código funciona en Android e iOS con comportamiento nativo en cada uno.

**Alternativas consideradas:**

- **Escribir a directorio público directamente:** Descartado porque en Android 10+ (Scoped Storage) requiere permisos complejos y no funciona de forma consistente.
- **Plugin de email directo:** Descartado porque limita al usuario a un solo método de backup (email), mientras que `share_plus` permite cualquier destino.

**Documentación oficial:** https://pub.dev/packages/share_plus

---

## 8. Testing

### flutter_test (SDK)

**Versión utilizada:** Incluido en Flutter SDK

**Propósito:**
Framework oficial de testing de Flutter que proporciona todas las herramientas necesarias para unit tests, widget tests e integration tests.

**Arquitectura de testing de MedicApp:**

MedicApp cuenta con **432+ tests** organizados en 3 categorías:

#### 1. Unit Tests (60% de los tests)

Tests de lógica de negocio pura, modelos, servicios y helpers sin dependencias de Flutter.

**Ejemplos:**
- `test/medication_model_test.dart`: Validación de modelos de datos.
- `test/dose_history_service_test.dart`: Lógica de historial de dosis.
- `test/notification_service_test.dart`: Lógica de programación de notificaciones.
- `test/preferences_service_test.dart`: Servicio de preferencias.

**Estructura típica:**
```dart
void main() {
  setUpAll(() async {
    // Inicializar base de datos de test
    setupTestDatabase();
  });

  tearDown(() async {
    // Limpiar base de datos después de cada test
    await DatabaseHelper.instance.close();
  });

  group('Medication Model', () {
    test('should create medication with valid data', () {
      final medication = Medication(
        id: 'test-id',
        name: 'Ibuprofeno',
        type: MedicationType.pill,
      );

      expect(medication.id, 'test-id');
      expect(medication.name, 'Ibuprofeno');
      expect(medication.type, MedicationType.pill);
    });

    test('should calculate next dose time correctly', () {
      final medication = Medication(
        id: 'test',
        name: 'Test',
        times: ['08:00', '20:00'],
      );

      final now = DateTime(2025, 1, 15, 10, 0); // 10:00 AM
      final nextDose = medication.getNextDoseTime(now);

      expect(nextDose.hour, 20); // Próxima dosis a las 20:00
    });
  });
}
```

#### 2. Widget Tests (30% de los tests)

Tests de widgets individuales, interacciones de UI y flujos de navegación.

**Ejemplos:**
- `test/settings_screen_test.dart`: Pantalla de configuración.
- `test/edit_schedule_screen_test.dart`: Editor de horarios.
- `test/edit_duration_screen_test.dart`: Editor de duración.
- `test/day_navigation_ui_test.dart`: Navegación de días.

**Estructura típica:**
```dart
void main() {
  testWidgets('should display medication list', (tester) async {
    // Arrange: Preparar datos de test
    final medications = [
      Medication(id: '1', name: 'Ibuprofeno', type: MedicationType.pill),
      Medication(id: '2', name: 'Paracetamol', type: MedicationType.pill),
    ];

    // Act: Construir widget
    await tester.pumpWidget(
      MaterialApp(
        home: MedicationListScreen(medications: medications),
      ),
    );

    // Assert: Verificar UI
    expect(find.text('Ibuprofeno'), findsOneWidget);
    expect(find.text('Paracetamol'), findsOneWidget);

    // Interacción: Tocar primer medicamento
    await tester.tap(find.text('Ibuprofeno'));
    await tester.pumpAndSettle();

    // Verificar navegación
    expect(find.byType(MedicationDetailScreen), findsOneWidget);
  });
}
```

#### 3. Integration Tests (10% de los tests)

Tests end-to-end de flujos completos que involucran múltiples pantallas, base de datos y servicios.

**Ejemplos:**
- `test/integration/add_medication_test.dart`: Flujo completo de añadir medicamento (8 pasos).
- `test/integration/dose_registration_test.dart`: Registro de dosis y actualización de stock.
- `test/integration/stock_management_test.dart`: Gestión completa de stock (recarga, agotamiento, alertas).
- `test/integration/app_startup_test.dart`: Inicio de aplicación y carga de datos.

**Estructura típica:**
```dart
void main() {
  testWidgets('complete add medication flow', (tester) async {
    // Iniciar aplicación
    await tester.pumpWidget(const MedicApp());
    await tester.pumpAndSettle();

    // Paso 1: Abrir pantalla de añadir medicamento
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Paso 2: Introducir nombre
    await tester.enterText(find.byType(TextField).first, 'Ibuprofeno 600mg');

    // Paso 3: Seleccionar tipo
    await tester.tap(find.text('Pastilla'));
    await tester.pumpAndSettle();

    // Paso 4: Siguiente paso
    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle();

    // ... continuar con los 8 pasos

    // Verificar medicamento añadido
    expect(find.text('Ibuprofeno 600mg'), findsOneWidget);

    // Verificar en base de datos
    final medications = await DatabaseHelper.instance.getMedications();
    expect(medications.length, 1);
    expect(medications.first.name, 'Ibuprofeno 600mg');
  });
}
```

**Cobertura de código:**

- **Objetivo:** 75-80%
- **Actual:** 75-80% (432+ tests)
- **Líneas cubiertas:** ~12,000 de ~15,000

**Áreas con mayor cobertura:**
- Models: 95%+ (lógica crítica de datos)
- Services: 85%+ (notificaciones, base de datos, dosis)
- Screens: 65%+ (UI y navegación)

**Áreas con menor cobertura:**
- Helpers y utilities: 60%
- Código de inicialización: 50%

**Estrategia de testing:**

1. **Test-first para lógica crítica:** Tests escritos antes del código para cálculos de dosis, stock, horarios.
2. **Test-after para UI:** Tests escritos después de implementar pantallas para verificar comportamiento.
3. **Regression tests:** Cada bug encontrado se convierte en un test para evitar regresiones.

**Comandos de testing:**

```bash
# Ejecutar todos los tests
flutter test

# Ejecutar tests con cobertura
flutter test --coverage

# Ejecutar tests específicos
flutter test test/medication_model_test.dart

# Ejecutar tests de integración
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
  await DatabaseHelper.instance.database; // Recrear limpia
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

**Documentación oficial:** https://docs.flutter.dev/testing

---

## 9. Herramientas de Desarrollo

### flutter_launcher_icons ^0.14.4

**Versión utilizada:** `^0.14.4` (dev_dependencies)

**Propósito:**
Paquete que genera automáticamente iconos de aplicación en todos los tamaños y formatos requeridos por Android e iOS desde una única imagen fuente.

**Configuración en MedicApp:**

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

**Iconos generados:**

**Android:**
- `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` (72x72)
- `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` (48x48)
- `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png` (96x96)
- `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` (144x144)
- `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` (192x192)
- Iconos adaptivos para Android 8+ (foreground + background separados)

**iOS:**
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/` (20x20 hasta 1024x1024, 15+ variantes)

**Comando de generación:**

```bash
flutter pub run flutter_launcher_icons
```

**Por qué esta herramienta:**

- **Automatización:** Genera manualmente 20+ archivos de iconos sería tedioso y propenso a errores.
- **Iconos adaptivos (Android 8+):** Soporta la funcionalidad de iconos adaptivos que se ajustan a diferentes formas según el launcher.
- **Optimización:** Los iconos se generan en formato PNG optimizado.
- **Consistencia:** Garantiza que todos los tamaños se generan desde la misma fuente.

**Documentación oficial:** https://pub.dev/packages/flutter_launcher_icons

---

### flutter_native_splash ^2.4.7

**Versión utilizada:** `^2.4.7` (dev_dependencies)

**Propósito:**
Paquete que genera splash screens nativos (pantallas de carga inicial) para Android e iOS, mostrándose instantáneamente mientras Flutter inicializa.

**Configuración en MedicApp:**

**`pubspec.yaml`:**
```yaml
flutter_native_splash:
  color: "#419e69"  # Color de fondo (verde MedicApp)
  image: assets/images/icon.png  # Imagen central
  android: true
  ios: true
  fullscreen: true
  android_12:
    image: assets/images/icon.png
    color: "#419e69"
```

**Características implementadas:**

1. **Splash unificado:** Misma apariencia en Android e iOS.
2. **Color de marca:** Verde `#419e69` (color primario de MedicApp).
3. **Logo centrado:** Icono de MedicApp en centro de pantalla.
4. **Pantalla completa:** Oculta barra de estado durante splash.
5. **Android 12+ específico:** Configuración especial para cumplir con el nuevo sistema de splash de Android 12.

**Archivos generados:**

**Android:**
- `android/app/src/main/res/drawable/launch_background.xml`
- `android/app/src/main/res/values/styles.xml` (tema de splash)
- `android/app/src/main/res/values-night/styles.xml` (tema oscuro)

**iOS:**
- `ios/Runner/Assets.xcassets/LaunchImage.imageset/`
- `ios/Runner/Base.lproj/LaunchScreen.storyboard`

**Comando de generación:**

```bash
flutter pub run flutter_native_splash:create
```

**Por qué splash nativo:**

- **UX profesional:** Evita pantalla blanca durante 1-2 segundos de inicialización de Flutter.
- **Branding inmediato:** Muestra logo y colores de marca desde el primer frame.
- **Percepción de velocidad:** Splash con branding se siente más rápido que pantalla blanca.

**Documentación oficial:** https://pub.dev/packages/flutter_native_splash

---

### uuid ^4.0.0

**Versión utilizada:** `^4.0.0`

**Propósito:**
Generador de UUIDs (Universally Unique Identifiers) v4 para crear identificadores únicos de medicamentos, personas y registros de dosis.

**Uso en MedicApp:**

```dart
import 'package:uuid/uuid.dart';

const uuid = Uuid();

final medication = Medication(
  id: uuid.v4(), // Genera: "f47ac10b-58cc-4372-a567-0e02b2c3d479"
  name: 'Ibuprofeno',
  type: MedicationType.pill,
);
```

**Por qué UUIDs:**

- **Unicidad global:** Probabilidad de colisión: 1 en 10³⁸ (prácticamente imposible).
- **Generación offline:** No requiere coordinación con servidor o secuencias de base de datos.
- **Sincronización futura:** Si MedicApp añade sincronización cloud, los UUIDs evitan conflictos de IDs.
- **Depuración:** IDs descriptivos en logs en lugar de enteros genéricos (1, 2, 3).

**Alternativa considerada:**

- **Auto-increment entero:** Descartado porque requeriría gestión de secuencias en SQLite y podría causar conflictos en futura sincronización.

**Documentación oficial:** https://pub.dev/packages/uuid

---

## 10. Dependencias de Plataforma

### Android

**Configuración de build:**

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
        isCoreLibraryDesugaringEnabled = true  // Para APIs modernas en Android < 26
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```

**Herramientas:**

- **Gradle 8.0+:** Sistema de build de Android.
- **Kotlin 1.9.0:** Lenguaje para código nativo Android (aunque MedicApp no usa código Kotlin custom).
- **AndroidX:** Bibliotecas de soporte modernas (reemplazo de Support Library).

**Versiones mínimas:**

- **minSdk 21 (Android 5.0 Lollipop):** Cobertura del 99%+ de dispositivos Android activos.
- **targetSdk 34 (Android 14):** Última versión de Android para aprovechar características modernas.

**Permisos requeridos:**

**`android/app/src/main/AndroidManifest.xml`:**
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" /> <!-- Android 13+ -->
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" /> <!-- Notificaciones exactas -->
<uses-permission android:name="android.permission.USE_EXACT_ALARM" /> <!-- Android 14+ -->
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" /> <!-- Reprogramar notificaciones después de reinicio -->
```

**Documentación oficial:** https://developer.android.com

---

### iOS

**Configuración de build:**

**`ios/Runner/Info.plist`:**
```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>

<key>NSUserNotificationsUsageDescription</key>
<string>MedicApp necesita enviar notificaciones para recordarte tomar tus medicamentos.</string>
```

**Herramientas:**

- **CocoaPods 1.11+:** Gestor de dependencias nativas de iOS.
- **Xcode 14+:** IDE requerido para compilar apps iOS.
- **Swift 5.0:** Lenguaje para código nativo iOS (aunque MedicApp usa AppDelegate por defecto).

**Versiones mínimas:**

- **iOS 12.0+:** Cobertura del 98%+ de dispositivos iOS activos.
- **iPadOS 12.0+:** Soporte completo para iPad.

**Capacidades requeridas:**

- **Push Notifications:** Aunque MedicApp usa notificaciones locales, esta capacidad habilita el framework de notificaciones.
- **Background Fetch:** Permite actualizar notificaciones cuando la app está en segundo plano.

**Documentación oficial:** https://developer.apple.com/documentation/

---

## 11. Versiones y Compatibilidad

### Tabla de Dependencias

| Dependencia | Versión | Propósito | Categoría |
|-------------|---------|-----------|-----------|
| **Flutter SDK** | `3.9.2+` | Framework principal | Core |
| **Dart SDK** | `3.9.2+` | Lenguaje de programación | Core |
| **cupertino_icons** | `^1.0.8` | Iconos iOS | UI |
| **sqflite** | `^2.3.0` | Base de datos SQLite | Persistencia |
| **path** | `^1.8.3` | Manipulación de rutas | Utilidad |
| **flutter_local_notifications** | `^19.5.0` | Notificaciones locales | Notificaciones |
| **timezone** | `^0.10.1` | Zonas horarias | Notificaciones |
| **intl** | `^0.20.2` | Internacionalización | i18n |
| **android_intent_plus** | `^6.0.0` | Intenciones Android | Permisos |
| **shared_preferences** | `^2.2.2` | Preferencias usuario | Persistencia |
| **file_picker** | `^8.0.0+1` | Selector de archivos | Archivos |
| **share_plus** | `^10.1.4` | Compartir archivos | Archivos |
| **path_provider** | `^2.1.5` | Directorios del sistema | Persistencia |
| **uuid** | `^4.0.0` | Generador de UUIDs | Utilidad |
| **sqflite_common_ffi** | `^2.3.0` | Testing de SQLite | Testing (dev) |
| **flutter_launcher_icons** | `^0.14.4` | Generación de iconos | Herramienta (dev) |
| **flutter_native_splash** | `^2.4.7` | Splash screen | Herramienta (dev) |
| **flutter_lints** | `^6.0.0` | Análisis estático | Herramienta (dev) |

**Total dependencias de producción:** 14
**Total dependencias de desarrollo:** 4
**Total:** 18

---

### Compatibilidad de Plataformas

| Plataforma | Versión mínima | Versión objetivo | Cobertura |
|------------|----------------|------------------|-----------|
| **Android** | 5.0 (API 21) | 14 (API 34) | 99%+ dispositivos |
| **iOS** | 12.0 | 17.0 | 98%+ dispositivos |
| **iPadOS** | 12.0 | 17.0 | 98%+ dispositivos |

**No soportado:** Web, Windows, macOS, Linux (MedicApp es exclusivamente móvil por diseño).

---

### Compatibilidad de Flutter

| Flutter | Compatible | Notas |
|---------|------------|-------|
| 3.9.2 - 3.10.x | ✅ | Versión de desarrollo |
| 3.11.x - 3.19.x | ✅ | Compatible sin cambios |
| 3.20.x - 3.35.x | ✅ | Probado hasta 3.35.7 |
| 3.36.x+ | ⚠️ | Probable compatible, no probado |
| 4.0.x | ❌ | Requiere actualización de dependencias |

---

## 12. Comparativas y Decisiones

### 12.1. Base de Datos: SQLite vs Hive vs Isar vs Drift

**Decisión:** SQLite (sqflite)

**Justificación extendida:**

**Requisitos de MedicApp:**

1. **Relaciones N:M (Muchos a Muchos):** Un medicamento puede ser asignado a múltiples personas, y una persona puede tener múltiples medicamentos. Esta arquitectura es nativa en SQL pero compleja en NoSQL.

2. **Consultas complejas:** Obtener todos los medicamentos de una persona con sus configuraciones personalizadas requiere JOINs entre 3 tablas:

```sql
SELECT m.*, pm.custom_times, pm.custom_doses
FROM medications m
JOIN person_medications pm ON m.id = pm.medication_id
JOIN persons p ON pm.person_id = p.id
WHERE p.id = ?
```

Esto es trivial en SQL pero requeriría múltiples consultas y lógica manual en NoSQL.

3. **Migraciones complejas:** MedicApp ha evolucionado desde V1 (tabla simple de medicamentos) hasta V19+ (multi-persona con relaciones). SQLite permite migraciones SQL incrementales que preservan datos:

```sql
-- Migración V18 -> V19: Añadir multi-persona
ALTER TABLE medications ADD COLUMN shared_stock REAL;
CREATE TABLE persons (...);
CREATE TABLE person_medications (...);
INSERT INTO persons (id, name, is_default) VALUES (?, 'Yo', 1);
INSERT INTO person_medications SELECT ?, id, times, doses FROM medications;
```

**Hive:**

- ✅ **Pros:** Rendimiento excelente, API simple, tamaño compacto.
- ❌ **Contras:**
  - **Sin relaciones nativas:** Implementar N:M requiere mantener listas de IDs manualmente y hacer múltiples consultas.
  - **Sin transacciones ACID completas:** No puede garantizar atomicidad en operaciones complejas (registro de dosis + descuento de stock + notificación).
  - **Migraciones manuales:** No hay sistema de versionado de esquema, requiere lógica custom.
  - **Debugging difícil:** Formato binario propietario, no se puede inspeccionar con herramientas estándar.

**Isar:**

- ✅ **Pros:** Rendimiento superior, indexado rápido, sintaxis Dart elegante.
- ❌ **Contras:**
  - **Inmadurez:** Lanzado en 2022, menos battle-tested que SQLite (20+ años).
  - **Relaciones limitadas:** Soporta relaciones pero no tan flexibles como SQL JOINs (limitado a 1:1, 1:N, sin M:N directo).
  - **Formato propietario:** Similar a Hive, dificulta debugging con herramientas externas.
  - **Lock-in:** Migrar de Isar a otra solución sería costoso.

**Drift:**

- ✅ **Pros:** Type-safe SQL, migraciones automáticas, APIs generadas.
- ❌ **Contras:**
  - **Complejidad:** Requiere generación de código, archivos `.drift`, y configuración compleja de build_runner.
  - **Boilerplate:** Incluso operaciones simples requieren definir tablas en archivos separados.
  - **Tamaño:** Aumenta el tamaño del APK en ~200KB vs sqflite directo.
  - **Flexibilidad reducida:** Consultas complejas ad-hoc son más difíciles que en SQL directo.

**Resultado final:**

Para MedicApp, donde las relaciones N:M son fundamentales, las migraciones han sido frecuentes (19 versiones de esquema), y la capacidad de debugging con DB Browser for SQLite ha sido invaluable durante desarrollo, SQLite es la elección correcta.

**Trade-off aceptado:**
Sacrificamos ~10-15% de rendimiento en operaciones masivas (irrelevante para casos de uso de MedicApp) a cambio de flexibilidad SQL completa, herramientas maduras y arquitectura de datos robusta.

---

### 12.2. Notificaciones: flutter_local_notifications vs awesome_notifications vs Firebase

**Decisión:** flutter_local_notifications

**Justificación extendida:**

**Requisitos de MedicApp:**

1. **Precisión temporal:** Notificaciones deben llegar exactamente a la hora programada (08:00:00, no 08:00:30).
2. **Funcionamiento offline:** Medicamentos se toman independientemente de conexión a internet.
3. **Privacidad:** Datos médicos nunca deben salir del dispositivo.
4. **Scheduling a largo plazo:** Notificaciones programadas para meses futuros.

**flutter_local_notifications:**

- ✅ **Scheduling preciso:** `zonedSchedule` con `androidScheduleMode: exactAllowWhileIdle` garantiza entrega exacta incluso con Doze Mode.
- ✅ **Totalmente offline:** Notificaciones se programan localmente, sin dependencia de servidor.
- ✅ **Privacidad total:** Ningún dato sale del dispositivo.
- ✅ **Madurez:** 5+ años, 3000+ estrellas, usado en producción por miles de apps médicas.
- ✅ **Documentación:** Ejemplos exhaustivos para todos los casos de uso.

**awesome_notifications:**

- ✅ **Pros:** UI de notificaciones más personalizable, animaciones, botones con iconos.
- ❌ **Contras:**
  - **Menos maduro:** 2+ años vs 5+ de flutter_local_notifications.
  - **Problemas reportados:** Issues con notificaciones programadas en Android 12+ (WorkManager conflicts).
  - **Complejidad innecesaria:** MedicApp no requiere notificaciones super personalizadas.
  - **Menor adopción:** ~1500 estrellas vs 3000+ de flutter_local_notifications.

**Firebase Cloud Messaging (FCM):**

- ✅ **Pros:** Notificaciones ilimitadas, analytics, segmentación de usuarios.
- ❌ **Contras:**
  - **Requiere servidor:** Necesitaría backend para enviar notificaciones, aumentando complejidad y costo.
  - **Requiere conexión:** Notificaciones no llegan si el dispositivo está offline.
  - **Privacidad:** Datos (horarios de medicación, nombres de medicamentos) se enviarían a Firebase.
  - **Latencia:** Depende de la red, no garantiza entrega exacta a la hora programada.
  - **Scheduling limitado:** FCM no soporta scheduling preciso, solo entrega "aproximada" con delay.
  - **Complejidad:** Requiere configurar proyecto Firebase, implementar servidor, gestionar tokens.

**Arquitectura correcta para aplicaciones médicas locales:**

Para apps como MedicApp (gestión personal, sin colaboración multi-usuario, sin backend), las notificaciones locales son arquitecturalmente superiores a notificaciones remotas:

- **Fiabilidad:** No dependen de conexión a internet o disponibilidad de servidor.
- **Privacidad:** GDPR y regulaciones médicas compliant por diseño (datos nunca salen del dispositivo).
- **Simplicidad:** Zero configuración de backend, zero costos de servidor.
- **Precisión:** Garantía de entrega exacta al segundo.

**Resultado final:**

`flutter_local_notifications` es la elección obvia y correcta para MedicApp. awesome_notifications sería sobre-ingeniería para UI que no necesitamos, y FCM sería arquitecturalmente incorrecto para una aplicación completamente local.

---

### 12.3. Gestión de Estado: Vanilla Flutter vs Provider vs BLoC vs Riverpod

**Decisión:** Vanilla Flutter (sin biblioteca de gestión de estado)

**Justificación extendida:**

**Arquitectura de MedicApp:**

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

En MedicApp, **la base de datos ES el estado**. No hay estado significativo en memoria que necesite ser compartido entre widgets.

**Patrón típico de pantalla:**

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

**Por qué Provider sería innecesario:**

Provider está diseñado para **compartir estado entre widgets distantes en el árbol**. Ejemplo clásico:

```dart
// Con Provider (innecesario en MedicApp)
ChangeNotifierProvider(
  create: (_) => MedicationProvider(),
  child: MaterialApp(
    home: HomeScreen(),
  ),
)

// HomeScreen puede acceder a MedicationProvider
Provider.of<MedicationProvider>(context).medications

// DetailScreen también puede acceder a MedicationProvider
Provider.of<MedicationProvider>(context).addDose(...)
```

**Problema:** En MedicApp, las pantallas NO necesitan compartir estado en memoria. Cada pantalla consulta la base de datos directamente:

```dart
// Pantalla 1: Lista de medicamentos
final medications = await db.getMedications();

// Pantalla 2: Detalle de medicamento
final medication = await db.getMedication(id);

// Pantalla 3: Historial de dosis
final history = await db.getDoseHistory(medicationId);
```

Todas obtienen datos directamente de SQLite, que es la única fuente de verdad. No hay necesidad de `ChangeNotifier`, `MultiProvider`, ni propagación de estado.

**Por qué BLoC sería sobre-ingeniería:**

BLoC (Business Logic Component) está diseñado para aplicaciones empresariales con **lógica de negocio compleja** que debe estar **separada de la UI** y **testeada independientemente**.

Ejemplo de arquitectura BLoC:

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
  // ... más eventos
}

// medication_event.dart (eventos separados)
// medication_state.dart (estados separados)
// medication_repository.dart (capa de datos)
```

**Problema:** Esto añade **4-5 archivos** por feature y cientos de líneas de boilerplate para implementar lo que en Vanilla Flutter es:

```dart
final medications = await DatabaseHelper.instance.getMedications();
setState(() {
  _medications = medications;
});
```

**Para MedicApp:**

- **Lógica de negocio simple:** Cálculos de stock (resta), cálculos de fechas (comparación), formateo de strings.
- **Sin reglas de negocio complejas:** No hay validaciones de tarjetas de crédito, cálculos financieros, autenticación OAuth, etc.
- **Testing directo:** Los servicios (DatabaseHelper, NotificationService) se testean directamente sin necesidad de mocks de BLoC.

**Por qué Riverpod sería innecesario:**

Riverpod es una evolución de Provider que soluciona algunos problemas (compile-time safety, no depende de BuildContext), pero sigue siendo innecesario para MedicApp por las mismas razones que Provider.

**Casos donde SÍ necesitaríamos gestión de estado:**

1. **Aplicación con autenticación:** Estado de usuario/sesión compartido entre todas las pantallas.
2. **Carrito de compra:** Estado de items seleccionados compartido entre productos, carrito, checkout.
3. **Chat en tiempo real:** Mensajes entrantes que deben actualizar múltiples pantallas simultáneamente.
4. **Aplicación colaborativa:** Múltiples usuarios editando el mismo documento en tiempo real.

**MedicApp NO tiene ninguno de estos casos.**

**Resultado final:**

Para MedicApp, `StatefulWidget + setState + Database as Source of Truth` es la arquitectura correcta. Es simple, directa, fácil de entender para cualquier desarrollador Flutter, y no introduce complejidad innecesaria.

Añadir Provider, BLoC o Riverpod sería puramente **cargo cult programming** (usar tecnología porque es popular, no porque resuelva un problema real).

---

## Conclusión

MedicApp utiliza un stack tecnológico **simple, robusto y apropiado** para una aplicación médica local multiplataforma:

- **Flutter + Dart:** Multiplataforma con rendimiento nativo.
- **SQLite:** Base de datos relacional madura con transacciones ACID.
- **Notificaciones locales:** Privacidad total y funcionamiento offline.
- **Localización ARB:** 8 idiomas con pluralización Unicode CLDR.
- **Vanilla Flutter:** Sin gestión de estado innecesaria.
- **432+ tests:** Cobertura del 75-80% con tests unitarios, de widget e integración.

Cada decisión tecnológica está **justificada por requisitos reales**, no por hype o tendencias. El resultado es una aplicación mantenible, confiable y que hace exactamente lo que promete sin complejidad artificial.

**Principio rector:** *"Simplicidad cuando es posible, complejidad cuando es necesario."*
