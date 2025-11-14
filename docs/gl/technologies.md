# Stack Tecnolóxico de MedicApp

Este documento detalla todas as tecnoloxías, frameworks, bibliotecas e ferramentas utilizadas en MedicApp, incluíndo as versións exactas, xustificacións da elección, alternativas consideradas e trade-offs de cada decisión tecnolóxica.

---

## 1. Core Technologies

### Flutter 3.9.2+

**Versión utilizada:** `3.9.2+` (SDK compatible ata `3.35.7+`)

**Propósito:**
Flutter é o framework multiplataforma que constitúe a base de MedicApp. Permite desenvolver unha aplicación nativa para Android e iOS desde unha única base de código Dart, garantindo rendemento próximo ao nativo e experiencia de usuario consistente en ambas plataformas.

**Por que se elixiu Flutter:**

1. **Desenvolvemento multiplataforma eficiente:** Un só código base para Android e iOS reduce custos de desenvolvemento e mantemento nun 60-70% comparado con desenvolvemento nativo dual.

2. **Rendemento nativo:** Flutter compila a código nativo ARM, non utiliza pontes JavaScript como React Native, o que resulta en animacións fluídas a 60/120 FPS e tempos de resposta instantáneos para operacións críticas como rexistro de doses.

3. **Hot Reload:** Permite iteración rápida durante o desenvolvemento, visualizando cambios en menos de 1 segundo sen perder o estado da aplicación. Esencial para axustar a UI de notificacións e fluxos multi-paso.

4. **Material Design 3 nativo:** Implementación completa e actualizada de Material Design 3 incluída no SDK, sen necesidade de bibliotecas de terceiros.

5. **Ecosistema maduro:** Pub.dev conta con máis de 40.000 paquetes, incluíndo solucións robustas para notificacións locais, base de datos SQLite e xestión de arquivos.

6. **Testing integrado:** Framework de testing completo incluído no SDK, con soporte para unit tests, widget tests e integration tests. MedicApp alcanza 432+ tests cunha cobertura do 75-80%.

**Alternativas consideradas:**

- **React Native:** Descartado por rendemento inferior en listas longas (historial de doses), problemas con notificacións locais en segundo plano, e experiencia inconsistente entre plataformas.
- **Kotlin Multiplatform Mobile (KMM):** Descartado por inmadurez do ecosistema, necesidade de código UI específico por plataforma, e curva de aprendizaxe máis pronunciada.
- **Nativo (Swift + Kotlin):** Descartado por duplicación de esforzo de desenvolvemento, maiores custos de mantemento, e necesidade de dous equipos especializados.

**Documentación oficial:** https://flutter.dev

---

### Dart 3.0+

**Versión utilizada:** `3.9.2+` (compatible con Flutter 3.9.2+)

**Propósito:**
Dart é a linguaxe de programación orientada a obxectos desenvolvida por Google que executa Flutter. Proporciona sintaxe moderna, tipado forte, null safety e rendemento optimizado.

**Características utilizadas en MedicApp:**

1. **Null Safety:** Sistema de tipos que elimina erros de referencia nula en tempo de compilación. Crítico para a fiabilidade dun sistema médico onde un NullPointerException podería impedir o rexistro dunha dose vital.

2. **Async/Await:** Programación asíncrona elegante para operacións de base de datos, notificacións e operacións de arquivo sen bloquear a UI.

3. **Extension Methods:** Permite estender clases existentes con métodos personalizados, utilizado para formateo de datas e validacións de modelos.

4. **Records e Pattern Matching (Dart 3.0+):** Estruturas de datos inmutables para devolver múltiples valores desde funcións de maneira segura.

5. **Strong Type System:** Tipado estático que detecta erros en tempo de compilación, esencial para operacións críticas como cálculo de stock e programación de notificacións.

**Por que Dart:**

- **Optimizado para UI:** Dart foi deseñado especificamente para desenvolvemento de interfaces, con recolección de lixo optimizada para evitar pausas durante animacións.
- **AOT e JIT:** Compilación Ahead-of-Time para produción (rendemento nativo) e Just-in-Time para desenvolvemento (Hot Reload).
- **Sintaxe familiar:** Similar a Java, C#, JavaScript, reducindo a curva de aprendizaxe.
- **Sound Null Safety:** Garantía en tempo de compilación de que as variables non nulas nunca serán null.

**Documentación oficial:** https://dart.dev

---

### Material Design 3

**Versión:** Implementación nativa en Flutter 3.9.2+

**Propósito:**
Material Design 3 (Material You) é o sistema de deseño de Google que proporciona compoñentes, patróns e directrices para crear interfaces modernas, accesibles e consistentes.

**Implementación en MedicApp:**

```dart
useMaterial3: true
```

**Compoñentes utilizados:**

1. **Color Scheme dinámico:** Sistema de cores baseado en sementes (`seedColor: Color(0xFF006B5A)` para tema claro, `Color(0xFF00A894)` para tema escuro) que xera automaticamente 30+ tonalidades harmónicas.

2. **FilledButton, OutlinedButton, TextButton:** Botóns con estados visuais (hover, pressed, disabled) e tamaños aumentados (52dp altura mínima) para accesibilidade.

3. **Card con elevación adaptativa:** Tarxetas con esquinas redondeadas (16dp) e sombras sutís para xerarquía visual.

4. **NavigationBar:** Barra de navegación inferior con indicadores de selección animados e soporte para navegación entre 3-5 destinos principais.

5. **FloatingActionButton estendido:** FAB con texto descritivo para acción primaria (engadir medicamento).

6. **ModalBottomSheet:** Follas modais para accións contextuais como rexistro rápido de dose.

7. **SnackBar con accións:** Feedback temporal para operacións completadas (dose rexistrada, medicamento engadido).

**Temas personalizados:**

MedicApp implementa dous temas completos (claro e escuro) con tipografía accesible:

- **Tamaños de fonte aumentados:** `titleLarge: 26sp`, `bodyLarge: 19sp` (superiores aos estándares de 22sp e 16sp respectivamente).
- **Contraste mellorado:** Cores de texto con opacidade 87% sobre fondos para cumprir WCAG AA.
- **Botóns grandes:** Altura mínima de 52dp (vs 40dp estándar) para facilitar toque en dispositivos móbiles.

**Por que Material Design 3:**

- **Accesibilidade integrada:** Compoñentes deseñados con soporte de lectores de pantalla, tamaños táctiles mínimos e ratios de contraste WCAG.
- **Coherencia co ecosistema Android:** Aspecto familiar para usuarios de Android 12+.
- **Personalización flexible:** Sistema de tokens de deseño que permite adaptar cores, tipografías e formas mantendo coherencia.
- **Modo escuro automático:** Soporte nativo para tema escuro baseado en configuración do sistema.

**Documentación oficial:** https://m3.material.io

---

## 2. Base de Datos e Persistencia

### sqflite ^2.3.0

**Versión utilizada:** `^2.3.0` (compatible con `2.3.0` ata `< 3.0.0`)

**Propósito:**
sqflite é o plugin de SQLite para Flutter que proporciona acceso a unha base de datos SQL local, relacional e transaccional. MedicApp utiliza SQLite como almacenamento principal para todos os datos de medicamentos, persoas, configuracións de pautas e historial de doses.

**Arquitectura de base de datos de MedicApp:**

```
medicapp.db
├── medications (táboa principal)
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
├── person_medications (táboa de relación N:M)
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

**Operacións críticas:**

1. **Transaccións ACID:** Garantía de atomicidade para operacións complexas como rexistro de dose + desconto de stock + programación de notificación.

2. **Consultas relacionais:** JOINs entre `medications`, `persons` e `person_medications` para obter configuracións personalizadas por usuario.

3. **Índices optimizados:** Índices en `person_id` e `medication_id` en táboas de relación para consultas rápidas O(log n).

4. **Migracións versionadas:** Sistema de migración de esquema desde V1 ata V19+ con preservación de datos.

**Por que SQLite:**

1. **ACID compliance:** Garantías transaccionais críticas para datos médicos onde a integridade é fundamental.

2. **Consultas SQL complexas:** Capacidade de realizar JOINs, agregacións e subconsultas para informes e filtros avanzados.

3. **Rendemento probado:** SQLite é a base de datos máis despregada do mundo, con optimizacións de 20+ anos.

4. **Zero-configuration:** Non require servidor, configuración ou administración. A base de datos é un único arquivo portátil.

5. **Exportación/importación simple:** O arquivo `.db` pode copiarse directamente para backups ou transferencias entre dispositivos.

6. **Tamaño ilimitado:** SQLite soporta bases de datos de ata 281 terabytes, máis que suficiente para décadas de historial de doses.

**Comparativa con alternativas:**

| Característica | SQLite (sqflite) | Hive | Isar | Drift |
|----------------|------------------|------|------|-------|
| **Modelo de datos** | Relacional SQL | NoSQL Key-Value | NoSQL Documental | Relacional SQL |
| **Linguaxe de consulta** | SQL estándar | API Dart | Query Builder Dart | SQL + Dart |
| **Transaccións ACID** | ✅ Completo | ❌ Limitado | ✅ Si | ✅ Si |
| **Migracións** | ✅ Manual robusto | ⚠️ Manual básico | ⚠️ Semi-automático | ✅ Automático |
| **Rendemento lectura** | ⚡ Excelente | ⚡⚡ Superior | ⚡⚡ Superior | ⚡ Excelente |
| **Rendemento escritura** | ⚡ Moi bo | ⚡⚡ Excelente | ⚡⚡ Excelente | ⚡ Moi bo |
| **Tamaño en disco** | ⚠️ Máis grande | ✅ Compacto | ✅ Moi compacto | ⚠️ Máis grande |
| **Relacións N:M** | ✅ Nativo | ❌ Manual | ⚠️ Referencias | ✅ Nativo |
| **Madurez** | ✅ 20+ anos | ⚠️ 4 anos | ⚠️ 3 anos | ✅ 5+ anos |
| **Portabilidade** | ✅ Universal | ⚠️ Propietario | ⚠️ Propietario | ⚠️ Flutter-only |
| **Ferramentas externas** | ✅ DB Browser, CLI | ❌ Limitadas | ❌ Limitadas | ❌ Ningunha |

**Xustificación de SQLite sobre alternativas:**

- **Hive:** Descartado por falta de soporte robusto para relacións N:M (arquitectura multi-persoa), ausencia de transaccións ACID completas, e dificultade para realizar consultas complexas con JOINs.

- **Isar:** Descartado a pesar do seu excelente rendemento debido á súa inmadurez (lanzado en 2022), formato propietario que dificulta debugging con ferramentas estándar, e limitacións en consultas relacionais complexas.

- **Drift:** Considerado seriamente pero descartado por maior complexidade (require xeración de código), maior tamaño da aplicación resultante, e menor flexibilidade en migracións comparado con SQL directo.

**Trade-offs de SQLite:**

- ✅ **Pros:** Estabilidade probada, SQL estándar, ferramentas externas, relacións nativas, exportación trivial.
- ❌ **Contras:** Rendemento lixeiramente inferior a Hive/Isar en operacións masivas, tamaño de arquivo máis grande, boilerplate SQL manual.

**Decisión:** Para MedicApp, a necesidade de relacións N:M robustas, migracións complexas de V1 a V19+, e capacidade de debugging con ferramentas SQL estándar xustifica amplamente o uso de SQLite sobre alternativas NoSQL máis rápidas pero menos maduras.

**Documentación oficial:** https://pub.dev/packages/sqflite

---

### sqflite_common_ffi ^2.3.0

**Versión utilizada:** `^2.3.0` (dev_dependencies)

**Propósito:**
Implementación FFI (Foreign Function Interface) de sqflite que permite executar tests de base de datos en contornas desktop/VM sen necesidade de emuladores Android/iOS.

**Uso en MedicApp:**

```dart
// test/helpers/database_test_helper.dart
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void setupTestDatabase() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}
```

**Por que é necesario:**

- **Tests 60x máis rápidos:** Os tests de base de datos execútanse en VM local en lugar de emuladores Android, reducindo tempo de 120s a 2s para a suite completa.
- **CI/CD sen emuladores:** GitHub Actions pode executar tests sen configurar emuladores, simplificando pipelines.
- **Debugging mellorado:** Os arquivos `.db` de test son accesibles directamente desde o sistema de arquivos do host.

**Documentación oficial:** https://pub.dev/packages/sqflite_common_ffi

---

### path ^1.8.3

**Versión utilizada:** `^1.8.3`

**Propósito:**
Biblioteca de manipulación de rutas de arquivos multiplataforma que abstrae as diferenzas entre sistemas de arquivos (Windows: `\`, Unix: `/`).

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
Plugin que proporciona acceso a directorios específicos do sistema operativo de forma multiplataforma (documentos, caché, soporte de aplicación).

**Uso en MedicApp:**

```dart
import 'package:path_provider/path_provider.dart';

// Obter directorio de base de datos
final dbDirectory = await getDatabasesPath(); // Android: /data/data/com.medicapp/databases/

// Obter directorio para exportacións
final documentsDirectory = await getApplicationDocumentsDirectory();
```

**Directorios utilizados:**

1. **getDatabasesPath():** Para arquivo `medicapp.db` principal.
2. **getApplicationDocumentsDirectory():** Para exportacións de base de datos que o usuario pode compartir.
3. **getTemporaryDirectory():** Para arquivos temporais durante importación.

**Documentación oficial:** https://pub.dev/packages/path_provider

---

## 3. Notificacións

### flutter_local_notifications ^19.5.0

**Versión utilizada:** `^19.5.0`

**Propósito:**
Sistema completo de notificacións locais (non requiren servidor) para Flutter, con soporte para notificacións programadas, repetitivas, con accións e personalizadas por plataforma.

**Implementación en MedicApp:**

MedicApp utiliza un sistema de notificacións sofisticado que xestiona tres tipos de notificacións:

1. **Notificacións de recordatorio de dose:**
   - Programadas con horarios exactos configurados polo usuario.
   - Inclúen título con nome de persoa (en multi-persoa) e detalles de dose.
   - Soporte para accións rápidas: "Tomar", "Adiar", "Omitir" (descartadas en V20+ por limitacións de tipo).
   - Son personalizado e canle de alta prioridade en Android.

2. **Notificacións de doses adiantadas:**
   - Detectan cando unha dose se toma antes do seu horario programado.
   - Actualizan automaticamente a próxima notificación se aplica.
   - Cancelan notificacións obsoletas do horario adiantado.

3. **Notificacións de fin de xaxún:**
   - Notificación ongoing (permanente) durante o período de xaxún con conta atrás.
   - Cancélase automaticamente cando termina o xaxún ou cando se pecha manualmente.
   - Inclúe progreso visual (Android) e hora de finalización.

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

1. **Scheduling preciso:** Notificacións programadas con precisión de segundo usando `timezone`.
2. **Canles de notificación (Android 8+):** 3 canles separadas para recordatorios, xaxún e sistema.
3. **Payload personalizado:** Datos JSON en payload para identificar medicamento e persoa.
4. **Callbacks de interacción:** Callbacks cando o usuario toca a notificación.
5. **Xestión de permisos:** Solicitude e verificación de permisos en Android 13+ (Tiramisu).

**Límites e optimizacións:**

- **Límite de 500 notificacións programadas simultáneas** (limitación do sistema Android).
- MedicApp xestiona priorización automática cando se supera este límite:
  - Prioriza próximos 7 días.
  - Descarta notificacións de medicamentos inactivos.
  - Reorganiza cando se engaden/eliminan medicamentos.

**Por que flutter_local_notifications:**

1. **Notificacións locais vs remotas:** MedicApp non require servidor backend, polo que notificacións locais son a arquitectura correcta.

2. **Funcionalidade completa:** Soporte para scheduling, repetición, accións, personalización por plataforma e xestión de permisos.

3. **Madurez probada:** Paquete con 5+ anos de desenvolvemento, 3000+ estrelas en GitHub, utilizado en produción por miles de aplicacións.

4. **Documentación exhaustiva:** Exemplos detallados para todos os casos de uso comúns.

**Por que NON Firebase Cloud Messaging (FCM):**

| Criterio | flutter_local_notifications | Firebase Cloud Messaging |
|----------|----------------------------|--------------------------|
| **Require servidor** | ❌ Non | ✅ Si (Firebase) |
| **Require conexión** | ❌ Non | ✅ Si (internet) |
| **Privacidade** | ✅ Todos os datos locais | ⚠️ Tokens en Firebase |
| **Latencia** | ✅ Instantánea | ⚠️ Depende de rede |
| **Custo** | ✅ Gratis | ⚠️ Cota gratuíta limitada |
| **Complexidade setup** | ✅ Mínima | ❌ Alta (Firebase, server) |
| **Funciona offline** | ✅ Sempre | ❌ Non |
| **Scheduling preciso** | ✅ Si | ❌ Non (aproximado) |

**Decisión:** Para unha aplicación de xestión de medicamentos onde a privacidade é crítica, as doses deben notificarse puntualmente incluso sen conexión, e non hai necesidade de comunicación servidor-cliente, as notificacións locais son a arquitectura correcta e máis simple.

**Comparativa con alternativas:**

- **awesome_notifications:** Descartado por menor adopción (menos maduro), APIs máis complexas, e problemas reportados con notificacións programadas en Android 12+.

- **local_notifications (nativo):** Descartado por requirir código específico de plataforma (Kotlin/Swift), duplicando esforzo de desenvolvemento.

**Documentación oficial:** https://pub.dev/packages/flutter_local_notifications

---

### timezone ^0.10.1

**Versión utilizada:** `^0.10.1`

**Propósito:**
Biblioteca de xestión de zonas horarias que permite programar notificacións en momentos específicos do día considerando cambios de horario de verán (DST) e conversións entre zonas horarias.

**Uso en MedicApp:**

```dart
import 'package:timezone/timezone.dart' as tz;

// Inicialización
await tz.initializeTimeZones();
final location = tz.getLocation('Europe/Madrid');
tz.setLocalLocation(location);

// Programar notificación ás 08:00 locais
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

**Por que é crítico:**

- **Horario de verán:** Sen `timezone`, as notificacións desfasaríanse 1 hora durante os cambios de DST.
- **Consistencia:** Os usuarios configuran horarios na súa zona horaria local, que debe respectarse independentemente de cambios de zona horaria do dispositivo.
- **Precisión:** `zonedSchedule` garante notificacións no momento exacto especificado.

**Documentación oficial:** https://pub.dev/packages/timezone

---

### android_intent_plus ^6.0.0

**Versión utilizada:** `^6.0.0`

**Propósito:**
Plugin para lanzar intencións (Intents) de Android desde Flutter, utilizado especificamente para abrir a configuración de notificacións cando os permisos están deshabilitados.

**Uso en MedicApp:**

```dart
import 'package:android_intent_plus/android_intent.dart';

// Abrir configuración de notificacións da app
final intent = AndroidIntent(
  action: 'android.settings.APP_NOTIFICATION_SETTINGS',
  arguments: {
    'android.provider.extra.APP_PACKAGE': packageName,
  },
);
await intent.launch();
```

**Casos de uso:**

1. **Guiar ao usuario:** Cando os permisos de notificación están deshabilitados, móstrase un diálogo explicativo con botón "Abrir Configuración" que lanza directamente a pantalla de configuración de notificacións de MedicApp.

2. **UX mellorada:** Evita que o usuario teña que navegar manualmente: Configuración > Aplicacións > MedicApp > Notificacións.

**Documentación oficial:** https://pub.dev/packages/android_intent_plus

---

## 4. Localización (i18n)

### flutter_localizations (SDK)

**Versión utilizada:** Incluído en Flutter SDK

**Propósito:**
Paquete oficial de Flutter que proporciona localizacións para widgets de Material e Cupertino en 85+ idiomas, incluíndo traducións de compoñentes estándar (botóns de diálogo, pickers, etc.).

**Uso en MedicApp:**

```dart
import 'package:flutter_localizations/flutter_localizations.dart';

MaterialApp(
  localizationsDelegates: [
    GlobalMaterialLocalizations.delegate, // Material widgets
    GlobalWidgetsLocalizations.delegate,  // Widgets xenéricos
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

**Que proporciona:**

- Traducións de botóns estándar: "OK", "Cancelar", "Aceptar".
- Formatos de data e hora localizados: "15/11/2025" (es) vs "11/15/2025" (en).
- Selectores de data/hora en idioma local.
- Nomes de días e meses.

**Documentación oficial:** https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization

---

### intl ^0.20.2

**Versión utilizada:** `^0.20.2`

**Propósito:**
Biblioteca de internacionalización de Dart que proporciona formateo de datas, números, pluralización e tradución de mensaxes mediante arquivos ARB.

**Uso en MedicApp:**

```dart
import 'package:intl/intl.dart';

// Formateo de datas
final formatted = DateFormat('dd/MM/yyyy').format(DateTime.now());

// Formateo de números
final stock = NumberFormat.decimalPattern().format(25.5);

// Pluralización (desde ARB)
// "{count, plural, =1{1 pastilla} other{{count} pastillas}}"
```

**Casos de uso:**

1. **Formateo de datas:** Mostrar datas de inicio/fin de tratamento, historial de doses.
2. **Formateo de números:** Mostrar stock con decimais segundo configuración rexional.
3. **Pluralización intelixente:** Mensaxes que cambian segundo cantidade ("1 pastilla" vs "5 pastillas").

**Documentación oficial:** https://pub.dev/packages/intl

---

### Sistema ARB (Application Resource Bundle)

**Formato utilizado:** ARB (baseado en JSON)

**Propósito:**
Sistema de arquivos de recursos de aplicación que permite definir traducións de strings en formato JSON con soporte para placeholders, pluralización e metadatos.

**Configuración en MedicApp:**

**`l10n.yaml`:**
```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
untranslated-messages-file: untranslated_messages.json
```

**Estrutura de arquivos:**
```
lib/l10n/
├── app_es.arb (plantilla principal, español)
├── app_en.arb (traducións inglés)
├── app_de.arb (traducións alemán)
├── app_fr.arb (traducións francés)
├── app_it.arb (traducións italiano)
├── app_ca.arb (traducións catalán)
├── app_eu.arb (traducións éuscaro)
└── app_gl.arb (traducións galego)
```

**Exemplo de ARB con características avanzadas:**

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

**Xeración automática:**

Flutter xera automaticamente a clase `AppLocalizations` con métodos tipados:

```dart
// Código xerado en .dart_tool/flutter_gen/gen_l10n/app_localizations.dart
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

**Vantaxes do sistema ARB:**

1. **Tipado forte:** Erros de tradución detectados en compilación.
2. **Placeholders seguros:** Imposible esquecer parámetros requiridos.
3. **Pluralización CLDR:** Soporte para regras de pluralización de 200+ idiomas segundo Unicode CLDR.
4. **Metadatos útiles:** Descricións e contexto para tradutores.
5. **Ferramentas de tradución:** Compatible con Google Translator Toolkit, Crowdin, Lokalise.

**Proceso de tradución en MedicApp:**

1. Definir strings en `app_es.arb` (plantilla).
2. Executar `flutter gen-l10n` para xerar código Dart.
3. Traducir a outros idiomas copiando e modificando arquivos ARB.
4. Revisar `untranslated_messages.json` para detectar strings faltantes.

**Documentación oficial:** https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization#adding-your-own-localized-messages

---

### 8 Idiomas Soportados

MedicApp está completamente traducida a 8 idiomas:

| Código | Idioma | Rexión principal | Falantes (millóns) |
|--------|--------|------------------|----------------------|
| `es` | Español | España, Latinoamérica | 500M+ |
| `en` | English | Global | 1,500M+ |
| `de` | Deutsch | Alemaña, Austria, Suíza | 130M+ |
| `fr` | Français | Francia, Canadá, África | 300M+ |
| `it` | Italiano | Italia, Suíza | 85M+ |
| `ca` | Català | Cataluña, Valencia, Baleares | 10M+ |
| `eu` | Euskara | País Vasco | 750K+ |
| `gl` | Galego | Galicia | 2.5M+ |

**Cobertura total:** ~2.500 millóns de falantes potenciais

**Strings totais:** ~450 traducións por idioma

**Calidade de tradución:**
- Español: Nativo (plantilla)
- Inglés: Nativo
- Alemán, francés, italiano: Profesional
- Catalán, éuscaro, galego: Nativo (linguas cooficiais de España)

**Xustificación de idiomas incluídos:**

- **Español:** Idioma principal do desenvolvedor e mercado obxectivo inicial (España, Latinoamérica).
- **Inglés:** Idioma universal para alcance global.
- **Alemán, francés, italiano:** Principais idiomas de Europa occidental, mercados con alta demanda de apps de saúde.
- **Catalán, éuscaro, galego:** Linguas cooficiais en España (rexións con 17M+ habitantes), mellora accesibilidade para usuarios maiores máis cómodos en lingua materna.

---

## 5. Xestión de Estado

### Sen biblioteca de xestión de estado (Vanilla Flutter)

**Decisión:** MedicApp **NON utiliza** ningunha biblioteca de xestión de estado (Provider, Riverpod, BLoC, Redux, GetX).

**Por que NON se usa xestión de estado:**

1. **Arquitectura baseada en base de datos:** O estado verdadeiro da aplicación reside en SQLite, non en memoria. Cada pantalla consulta a base de datos directamente para obter datos actualizados.

2. **StatefulWidget + setState é suficiente:** Para unha aplicación de complexidade media como MedicApp, `setState()` e `StatefulWidget` proporcionan xestión de estado local máis que adecuada.

3. **Simplicidade sobre frameworks:** Evitar dependencias innecesarias reduce complexidade, tamaño da aplicación e posibles breaking changes en actualizacións.

4. **Streams de base de datos:** Para datos reactivos, utilízanse `StreamBuilder` con streams directos desde `DatabaseHelper`:

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

5. **Navegación con callbacks:** Para comunicación entre pantallas, utilízanse callbacks tradicionais de Flutter:

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
| **Liñas de código adicionais** | 0 | ~500 | ~1,500 | ~800 |
| **Dependencias externas** | 0 | 1 | 2+ | 2+ |
| **Curva de aprendizaxe** | ✅ Mínima | ⚠️ Media | ❌ Alta | ⚠️ Media-Alta |
| **Boilerplate** | ✅ Ningún | ⚠️ Medio | ❌ Alto | ⚠️ Medio |
| **Testing** | ✅ Directo | ⚠️ Require mocks | ⚠️ Require setup | ⚠️ Require setup |
| **Rendemento** | ✅ Excelente | ⚠️ Bo | ⚠️ Bo | ⚠️ Bo |
| **Tamaño APK** | ✅ Mínimo | +50KB | +150KB | +100KB |

**Por que NON Provider:**

- **Innecesario:** Provider está deseñado para compartir estado entre widgets profundamente aniñados. MedicApp obtén datos da base de datos en cada pantalla raíz, sen necesidade de pasar estado cara abaixo.
- **Complexidade engadida:** Require `ChangeNotifier`, `MultiProvider`, context-awareness, e entender a árbore de widgets.
- **Sobre-enxeñaría:** Para unha aplicación con ~15 pantallas e estado en base de datos, Provider sería usar un martelo neumático para cravar un cravo.

**Por que NON BLoC:**

- **Complexidade extrema:** BLoC (Business Logic Component) require entender streams, sinks, eventos, estados, e arquitectura de capas.
- **Boilerplate masivo:** Cada feature require 4-5 arquivos (bloc, event, state, repository, test).
- **Sobre-enxeñaría:** BLoC é excelente para aplicacións empresariais con lóxica de negocio complexa e múltiples desenvolvedores. MedicApp é unha aplicación de complexidade media onde a simplicidade é prioritaria.

**Por que NON Riverpod:**

- **Menos maduro:** Riverpod é relativamente novo (2020) comparado con Provider (2018) e BLoC (2018).
- **Complexidade similar a Provider:** Require entender providers, autoDispose, family, e arquitectura declarativa.
- **Sen vantaxe clara:** Para MedicApp, Riverpod non ofrece beneficios significativos sobre a arquitectura actual.

**Por que NON Redux:**

- **Complexidade masiva:** Redux require accións, reducers, middleware, store, e inmutabilidade estricta.
- **Boilerplate insostible:** Incluso operacións simples requiren múltiples arquivos e centos de liñas de código.
- **Sobre-kill total:** Redux está deseñado para aplicacións web SPA con estado complexo en frontend. MedicApp ten estado en SQLite, non en memoria.

**Casos onde SI se necesitaría xestión de estado:**

- **Estado compartido complexo en memoria:** Se múltiples pantallas necesitasen compartir obxectos grandes en memoria (non aplica a MedicApp).
- **Estado global de autenticación:** Se houbese login/sesións (MedicApp é local, sen contas).
- **Sincronización en tempo real:** Se houbese colaboración multi-usuario en tempo real (non aplica).
- **Lóxica de negocio complexa:** Se houbese cálculos pesados que requiren caché en memoria (MedicApp fai cálculos simples de stock e datas).

**Decisión final:**

Para MedicApp, a arquitectura **Database as Single Source of Truth + StatefulWidget + setState** é a solución correcta. É simple, directa, fácil de entender e manter, e non introduce complexidade innecesaria. Engadir Provider, BLoC ou Riverpod sería sobre-enxeñaría pura sen beneficios tanxibles.

---

## 6. Almacenamento Local

### shared_preferences ^2.2.2

**Versión utilizada:** `^2.2.2`

**Propósito:**
Almacenamento persistente de clave-valor para preferencias simples do usuario, configuracións de aplicación e estados non críticos. Utiliza `SharedPreferences` en Android e `UserDefaults` en iOS.

**Uso en MedicApp:**

MedicApp utiliza `shared_preferences` para almacenar configuracións lixeiras que non xustifican unha táboa SQL:

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
   - Uso: Persistir preferencia de tema entre sesións.

2. **Idioma seleccionado:**
   - Clave: `locale`
   - Valores: `es`, `en`, `de`, `fr`, `it`, `ca`, `eu`, `gl`
   - Uso: Recordar idioma elixido polo usuario (override do idioma do sistema).

3. **Estado de permisos:**
   - Clave: `notifications_enabled`
   - Valores: `true`, `false`
   - Uso: Caché local do estado de permisos para evitar chamadas nativas repetidas.

4. **Primeira execución:**
   - Clave: `first_run`
   - Valores: `true`, `false`
   - Uso: Mostrar tutorial/onboarding só en primeira execución.

**Por que shared_preferences e non SQLite:**

- **Rendemento:** Acceso instantáneo O(1) para valores simples vs consulta SQL con overhead.
- **Simplicidade:** API trivial (`getString`, `setString`) vs preparar queries SQL.
- **Propósito:** Preferencias de usuario vs datos relacionais.
- **Tamaño:** Valores pequenos (< 1KB) vs rexistros complexos.

**Limitacións de shared_preferences:**

- ❌ Non soporta relacións, JOINs, transaccións.
- ❌ Non apropiado para datos >100KB.
- ❌ Acceso asíncrono (require `await`).
- ❌ Só tipos primitivos (String, int, double, bool, List<String>).

**Trade-offs:**

- ✅ **Pros:** API simple, rendemento excelente, propósito correcto para preferencias.
- ❌ **Contras:** Non apropiado para datos estruturados ou voluminosos.

**Documentación oficial:** https://pub.dev/packages/shared_preferences

---

## 7. Operacións de Arquivos

### file_picker ^8.0.0+1

**Versión utilizada:** `^8.0.0+1`

**Propósito:**
Plugin multiplataforma para seleccionar arquivos do sistema de arquivos do dispositivo, con soporte para múltiples plataformas (Android, iOS, desktop, web).

**Uso en MedicApp:**

MedicApp utiliza `file_picker` exclusivamente para a función de **importación de base de datos**, permitindo ao usuario restaurar un backup ou migrar datos desde outro dispositivo.

**Implementación:**

```dart
import 'package:file_picker/file_picker.dart';

Future<void> importDatabase() async {
  // Abrir selector de arquivos
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['db'],
    dialogTitle: 'Seleccionar arquivo de base de datos',
  );

  if (result == null) return; // Usuario cancelou

  final file = result.files.single;
  final path = file.path!;

  // Validar e copiar arquivo
  await DatabaseHelper.instance.importDatabase(path);

  // Recargar aplicación
  setState(() {});
}
```

**Características utilizadas:**

1. **Filtro de extensións:** Só permite seleccionar arquivos `.db` para evitar erros do usuario.
2. **Título personalizado:** Mostra mensaxe descritiva no diálogo do sistema.
3. **Ruta completa:** Obtén path absoluto do arquivo para copialo á ubicación da app.

**Alternativas consideradas:**

- **image_picker:** Descartado porque está deseñado especificamente para imaxes/vídeos, non arquivos xenéricos.
- **Código nativo:** Descartado porque requiriría implementar `ActivityResultLauncher` (Android) e `UIDocumentPickerViewController` (iOS) manualmente.

**Documentación oficial:** https://pub.dev/packages/file_picker

---

### share_plus ^10.1.4

**Versión utilizada:** `^10.1.4`

**Propósito:**
Plugin multiplataforma para compartir arquivos, texto e URLs utilizando a folla de compartir nativa do sistema operativo (Android Share Sheet, iOS Share Sheet).

**Uso en MedicApp:**

MedicApp utiliza `share_plus` para a función de **exportación de base de datos**, permitindo ao usuario crear un backup e compartilo vía email, cloud storage (Drive, Dropbox), Bluetooth, ou gardalo en arquivos locais.

**Implementación:**

```dart
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

Future<void> exportDatabase() async {
  // Obter ruta da base de datos actual
  final dbPath = await DatabaseHelper.instance.getDatabasePath();

  // Crear copia temporal en directorio compartible
  final tempDir = await getTemporaryDirectory();
  final exportPath = '${tempDir.path}/medicapp_backup_${DateTime.now().millisecondsSinceEpoch}.db';

  // Copiar base de datos
  await File(dbPath).copy(exportPath);

  // Compartir arquivo
  await Share.shareXFiles(
    [XFile(exportPath)],
    subject: 'Backup MedicApp',
    text: 'Base de datos de MedicApp - ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
  );
}
```

**Fluxo de usuario:**

1. Usuario toca "Exportar base de datos" en menú de configuración.
2. MedicApp crea copia de `medicapp.db` con timestamp en nome.
3. Ábrese a folla de compartir nativa do SO.
4. Usuario elixe destino: Gmail (como adxunto), Drive, Bluetooth, "Gardar en arquivos", etc.
5. O arquivo `.db` compártese/gárdase no destino elixido.

**Características avanzadas:**

- **XFile:** Abstracción multiplataforma de arquivos que funciona en Android, iOS, desktop e web.
- **Metadatos:** Inclúe nome de arquivo descritivo e texto explicativo.
- **Compatibilidade:** Funciona con todas as apps compatibles co protocolo de compartir do SO.

**Por que share_plus:**

- **UX nativa:** Utiliza a interface de compartir que o usuario xa coñece, sen reinventar a roda.
- **Integración perfecta:** Intégrase automaticamente con todas as apps instaladas que poden recibir arquivos.
- **Multiplataforma:** Mesmo código funciona en Android e iOS con comportamento nativo en cada un.

**Alternativas consideradas:**

- **Escribir a directorio público directamente:** Descartado porque en Android 10+ (Scoped Storage) require permisos complexos e non funciona de forma consistente.
- **Plugin de email directo:** Descartado porque limita ao usuario a un só método de backup (email), mentres que `share_plus` permite calquera destino.

**Documentación oficial:** https://pub.dev/packages/share_plus

---

## 8. Testing

### flutter_test (SDK)

**Versión utilizada:** Incluído en Flutter SDK

**Propósito:**
Framework oficial de testing de Flutter que proporciona todas as ferramentas necesarias para unit tests, widget tests e integration tests.

**Arquitectura de testing de MedicApp:**

MedicApp conta con **432+ tests** organizados en 3 categorías:

#### 1. Unit Tests (60% dos tests)

Tests de lóxica de negocio pura, modelos, servizos e helpers sen dependencias de Flutter.

**Exemplos:**
- `test/medication_model_test.dart`: Validación de modelos de datos.
- `test/dose_history_service_test.dart`: Lóxica de historial de doses.
- `test/notification_service_test.dart`: Lóxica de programación de notificacións.
- `test/preferences_service_test.dart`: Servizo de preferencias.

**Estrutura típica:**
```dart
void main() {
  setUpAll(() async {
    // Inicializar base de datos de test
    setupTestDatabase();
  });

  tearDown(() async {
    // Limpar base de datos despois de cada test
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

      expect(nextDose.hour, 20); // Próxima dose ás 20:00
    });
  });
}
```

#### 2. Widget Tests (30% dos tests)

Tests de widgets individuais, interaccións de UI e fluxos de navegación.

**Exemplos:**
- `test/settings_screen_test.dart`: Pantalla de configuración.
- `test/edit_schedule_screen_test.dart`: Editor de horarios.
- `test/edit_duration_screen_test.dart`: Editor de duración.
- `test/day_navigation_ui_test.dart`: Navegación de días.

**Estrutura típica:**
```dart
void main() {
  testWidgets('should display medication list', (tester) async {
    // Arrange: Preparar datos de test
    final medications = [
      Medication(id: '1', name: 'Ibuprofeno', type: MedicationType.pill),
      Medication(id: '2', name: 'Paracetamol', type: MedicationType.pill),
    ];

    // Act: Construír widget
    await tester.pumpWidget(
      MaterialApp(
        home: MedicationListScreen(medications: medications),
      ),
    );

    // Assert: Verificar UI
    expect(find.text('Ibuprofeno'), findsOneWidget);
    expect(find.text('Paracetamol'), findsOneWidget);

    // Interacción: Tocar primeiro medicamento
    await tester.tap(find.text('Ibuprofeno'));
    await tester.pumpAndSettle();

    // Verificar navegación
    expect(find.byType(MedicationDetailScreen), findsOneWidget);
  });
}
```

#### 3. Integration Tests (10% dos tests)

Tests end-to-end de fluxos completos que involucran múltiples pantallas, base de datos e servizos.

**Exemplos:**
- `test/integration/add_medication_test.dart`: Fluxo completo de engadir medicamento (8 pasos).
- `test/integration/dose_registration_test.dart`: Rexistro de dose e actualización de stock.
- `test/integration/stock_management_test.dart`: Xestión completa de stock (recarga, esgotamento, alertas).
- `test/integration/app_startup_test.dart`: Inicio de aplicación e carga de datos.

**Estrutura típica:**
```dart
void main() {
  testWidgets('complete add medication flow', (tester) async {
    // Iniciar aplicación
    await tester.pumpWidget(const MedicApp());
    await tester.pumpAndSettle();

    // Paso 1: Abrir pantalla de engadir medicamento
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Paso 2: Introducir nome
    await tester.enterText(find.byType(TextField).first, 'Ibuprofeno 600mg');

    // Paso 3: Seleccionar tipo
    await tester.tap(find.text('Pastilla'));
    await tester.pumpAndSettle();

    // Paso 4: Seguinte paso
    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle();

    // ... continuar cos 8 pasos

    // Verificar medicamento engadido
    expect(find.text('Ibuprofeno 600mg'), findsOneWidget);

    // Verificar en base de datos
    final medications = await DatabaseHelper.instance.getMedications();
    expect(medications.length, 1);
    expect(medications.first.name, 'Ibuprofeno 600mg');
  });
}
```

**Cobertura de código:**

- **Obxectivo:** 75-80%
- **Actual:** 75-80% (432+ tests)
- **Liñas cubertas:** ~12.000 de ~15.000

**Áreas con maior cobertura:**
- Models: 95%+ (lóxica crítica de datos)
- Services: 85%+ (notificacións, base de datos, doses)
- Screens: 65%+ (UI e navegación)

**Áreas con menor cobertura:**
- Helpers e utilities: 60%
- Código de inicialización: 50%

**Estratexia de testing:**

1. **Test-first para lóxica crítica:** Tests escritos antes do código para cálculos de doses, stock, horarios.
2. **Test-after para UI:** Tests escritos despois de implementar pantallas para verificar comportamento.
3. **Regression tests:** Cada bug atopado convértese nun test para evitar regresións.

**Comandos de testing:**

```bash
# Executar todos os tests
flutter test

# Executar tests con cobertura
flutter test --coverage

# Executar tests específicos
flutter test test/medication_model_test.dart

# Executar tests de integración
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
  await DatabaseHelper.instance.database; // Recrear limpa
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

## 9. Ferramentas de Desenvolvemento

### flutter_launcher_icons ^0.14.4

**Versión utilizada:** `^0.14.4` (dev_dependencies)

**Propósito:**
Paquete que xera automaticamente iconos de aplicación en todos os tamaños e formatos requiridos por Android e iOS desde unha única imaxe fonte.

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

**Iconos xerados:**

**Android:**
- `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` (72x72)
- `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` (48x48)
- `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png` (96x96)
- `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` (144x144)
- `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` (192x192)
- Iconos adaptivos para Android 8+ (foreground + background separados)

**iOS:**
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/` (20x20 ata 1024x1024, 15+ variantes)

**Comando de xeración:**

```bash
flutter pub run flutter_launcher_icons
```

**Por que esta ferramenta:**

- **Automatización:** Xerar manualmente 20+ arquivos de iconos sería tedioso e propenso a erros.
- **Iconos adaptivos (Android 8+):** Soporta a funcionalidade de iconos adaptivos que se axustan a diferentes formas segundo o launcher.
- **Optimización:** Os iconos xéranse en formato PNG optimizado.
- **Consistencia:** Garante que todos os tamaños se xeran desde a mesma fonte.

**Documentación oficial:** https://pub.dev/packages/flutter_launcher_icons

---

### flutter_native_splash ^2.4.7

**Versión utilizada:** `^2.4.7` (dev_dependencies)

**Propósito:**
Paquete que xera splash screens nativos (pantallas de carga inicial) para Android e iOS, mostrándose instantaneamente mentres Flutter inicializa.

**Configuración en MedicApp:**

**`pubspec.yaml`:**
```yaml
flutter_native_splash:
  color: "#419e69"  # Cor de fondo (verde MedicApp)
  image: assets/images/icon.png  # Imaxe central
  android: true
  ios: true
  fullscreen: true
  android_12:
    image: assets/images/icon.png
    color: "#419e69"
```

**Características implementadas:**

1. **Splash unificado:** Mesma aparencia en Android e iOS.
2. **Cor de marca:** Verde `#419e69` (cor primaria de MedicApp).
3. **Logo centrado:** Icono de MedicApp no centro de pantalla.
4. **Pantalla completa:** Oculta barra de estado durante splash.
5. **Android 12+ específico:** Configuración especial para cumprir co novo sistema de splash de Android 12.

**Arquivos xerados:**

**Android:**
- `android/app/src/main/res/drawable/launch_background.xml`
- `android/app/src/main/res/values/styles.xml` (tema de splash)
- `android/app/src/main/res/values-night/styles.xml` (tema escuro)

**iOS:**
- `ios/Runner/Assets.xcassets/LaunchImage.imageset/`
- `ios/Runner/Base.lproj/LaunchScreen.storyboard`

**Comando de xeración:**

```bash
flutter pub run flutter_native_splash:create
```

**Por que splash nativo:**

- **UX profesional:** Evita pantalla branca durante 1-2 segundos de inicialización de Flutter.
- **Branding inmediato:** Mostra logo e cores de marca desde o primeiro frame.
- **Percepción de velocidade:** Splash con branding séntese máis rápido que pantalla branca.

**Documentación oficial:** https://pub.dev/packages/flutter_native_splash

---

### uuid ^4.0.0

**Versión utilizada:** `^4.0.0`

**Propósito:**
Xerador de UUIDs (Universally Unique Identifiers) v4 para crear identificadores únicos de medicamentos, persoas e rexistros de doses.

**Uso en MedicApp:**

```dart
import 'package:uuid/uuid.dart';

const uuid = Uuid();

final medication = Medication(
  id: uuid.v4(), // Xera: "f47ac10b-58cc-4372-a567-0e02b2c3d479"
  name: 'Ibuprofeno',
  type: MedicationType.pill,
);
```

**Por que UUIDs:**

- **Unicidade global:** Probabilidade de colisión: 1 en 10³⁸ (practicamente imposible).
- **Xeración offline:** Non require coordinación con servidor ou secuencias de base de datos.
- **Sincronización futura:** Se MedicApp engade sincronización cloud, os UUIDs evitan conflitos de IDs.
- **Depuración:** IDs descritivos en logs no lugar de enteiros xenéricos (1, 2, 3).

**Alternativa considerada:**

- **Auto-increment enteiro:** Descartado porque requiriría xestión de secuencias en SQLite e podería causar conflitos en futura sincronización.

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

**Ferramentas:**

- **Gradle 8.0+:** Sistema de build de Android.
- **Kotlin 1.9.0:** Linguaxe para código nativo Android (aínda que MedicApp non usa código Kotlin custom).
- **AndroidX:** Bibliotecas de soporte modernas (reemplazo de Support Library).

**Versións mínimas:**

- **minSdk 21 (Android 5.0 Lollipop):** Cobertura do 99%+ de dispositivos Android activos.
- **targetSdk 34 (Android 14):** Última versión de Android para aproveitar características modernas.

**Permisos requiridos:**

**`android/app/src/main/AndroidManifest.xml`:**
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" /> <!-- Android 13+ -->
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" /> <!-- Notificacións exactas -->
<uses-permission android:name="android.permission.USE_EXACT_ALARM" /> <!-- Android 14+ -->
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" /> <!-- Reprogramar notificacións despois de reinicio -->
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
<string>MedicApp necesita enviar notificacións para recordarche tomar os teus medicamentos.</string>
```

**Ferramentas:**

- **CocoaPods 1.11+:** Xestor de dependencias nativas de iOS.
- **Xcode 14+:** IDE requirido para compilar apps iOS.
- **Swift 5.0:** Linguaxe para código nativo iOS (aínda que MedicApp usa AppDelegate por defecto).

**Versións mínimas:**

- **iOS 12.0+:** Cobertura do 98%+ de dispositivos iOS activos.
- **iPadOS 12.0+:** Soporte completo para iPad.

**Capacidades requiridas:**

- **Push Notifications:** Aínda que MedicApp usa notificacións locais, esta capacidade habilita o framework de notificacións.
- **Background Fetch:** Permite actualizar notificacións cando a app está en segundo plano.

**Documentación oficial:** https://developer.apple.com/documentation/

---

## 11. Versións e Compatibilidade

### Táboa de Dependencias

| Dependencia | Versión | Propósito | Categoría |
|-------------|---------|-----------|-----------|
| **Flutter SDK** | `3.9.2+` | Framework principal | Core |
| **Dart SDK** | `3.9.2+` | Linguaxe de programación | Core |
| **cupertino_icons** | `^1.0.8` | Iconos iOS | UI |
| **sqflite** | `^2.3.0` | Base de datos SQLite | Persistencia |
| **path** | `^1.8.3` | Manipulación de rutas | Utilidade |
| **flutter_local_notifications** | `^19.5.0` | Notificacións locais | Notificacións |
| **timezone** | `^0.10.1` | Zonas horarias | Notificacións |
| **intl** | `^0.20.2` | Internacionalización | i18n |
| **android_intent_plus** | `^6.0.0` | Intencións Android | Permisos |
| **shared_preferences** | `^2.2.2` | Preferencias usuario | Persistencia |
| **file_picker** | `^8.0.0+1` | Selector de arquivos | Arquivos |
| **share_plus** | `^10.1.4` | Compartir arquivos | Arquivos |
| **path_provider** | `^2.1.5` | Directorios do sistema | Persistencia |
| **uuid** | `^4.0.0` | Xerador de UUIDs | Utilidade |
| **sqflite_common_ffi** | `^2.3.0` | Testing de SQLite | Testing (dev) |
| **flutter_launcher_icons** | `^0.14.4` | Xeración de iconos | Ferramenta (dev) |
| **flutter_native_splash** | `^2.4.7` | Splash screen | Ferramenta (dev) |
| **flutter_lints** | `^6.0.0` | Análise estática | Ferramenta (dev) |

**Total dependencias de produción:** 14
**Total dependencias de desenvolvemento:** 4
**Total:** 18

---

### Compatibilidade de Plataformas

| Plataforma | Versión mínima | Versión obxectivo | Cobertura |
|------------|----------------|------------------|-----------|
| **Android** | 5.0 (API 21) | 14 (API 34) | 99%+ dispositivos |
| **iOS** | 12.0 | 17.0 | 98%+ dispositivos |
| **iPadOS** | 12.0 | 17.0 | 98%+ dispositivos |

**Non soportado:** Web, Windows, macOS, Linux (MedicApp é exclusivamente móbil por deseño).

---

### Compatibilidade de Flutter

| Flutter | Compatible | Notas |
|---------|------------|-------|
| 3.9.2 - 3.10.x | ✅ | Versión de desenvolvemento |
| 3.11.x - 3.19.x | ✅ | Compatible sen cambios |
| 3.20.x - 3.35.x | ✅ | Probado ata 3.35.7 |
| 3.36.x+ | ⚠️ | Probable compatible, non probado |
| 4.0.x | ❌ | Require actualización de dependencias |

---

## 12. Comparativas e Decisións

### 12.1. Base de Datos: SQLite vs Hive vs Isar vs Drift

**Decisión:** SQLite (sqflite)

**Xustificación estendida:**

**Requisitos de MedicApp:**

1. **Relacións N:M (Moitos a Moitos):** Un medicamento pode ser asignado a múltiples persoas, e unha persoa pode ter múltiples medicamentos. Esta arquitectura é nativa en SQL pero complexa en NoSQL.

2. **Consultas complexas:** Obter todos os medicamentos dunha persoa coas súas configuracións personalizadas require JOINs entre 3 táboas:

```sql
SELECT m.*, pm.custom_times, pm.custom_doses
FROM medications m
JOIN person_medications pm ON m.id = pm.medication_id
JOIN persons p ON pm.person_id = p.id
WHERE p.id = ?
```

Isto é trivial en SQL pero requiriría múltiples consultas e lóxica manual en NoSQL.

3. **Migracións complexas:** MedicApp evolucionou desde V1 (táboa simple de medicamentos) ata V19+ (multi-persoa con relacións). SQLite permite migracións SQL incrementais que preservan datos:

```sql
-- Migración V18 -> V19: Engadir multi-persoa
ALTER TABLE medications ADD COLUMN shared_stock REAL;
CREATE TABLE persons (...);
CREATE TABLE person_medications (...);
INSERT INTO persons (id, name, is_default) VALUES (?, 'Yo', 1);
INSERT INTO person_medications SELECT ?, id, times, doses FROM medications;
```

**Hive:**

- ✅ **Pros:** Rendemento excelente, API simple, tamaño compacto.
- ❌ **Contras:**
  - **Sen relacións nativas:** Implementar N:M require manter listas de IDs manualmente e facer múltiples consultas.
  - **Sen transaccións ACID completas:** Non pode garantir atomicidade en operacións complexas (rexistro de dose + desconto de stock + notificación).
  - **Migracións manuais:** Non hai sistema de versionado de esquema, require lóxica custom.
  - **Debugging difícil:** Formato binario propietario, non se pode inspeccionar con ferramentas estándar.

**Isar:**

- ✅ **Pros:** Rendemento superior, indexado rápido, sintaxe Dart elegante.
- ❌ **Contras:**
  - **Inmadurez:** Lanzado en 2022, menos battle-tested que SQLite (20+ anos).
  - **Relacións limitadas:** Soporta relacións pero non tan flexibles como SQL JOINs (limitado a 1:1, 1:N, sen M:N directo).
  - **Formato propietario:** Similar a Hive, dificulta debugging con ferramentas externas.
  - **Lock-in:** Migrar de Isar a outra solución sería costoso.

**Drift:**

- ✅ **Pros:** Type-safe SQL, migracións automáticas, APIs xeradas.
- ❌ **Contras:**
  - **Complexidade:** Require xeración de código, arquivos `.drift`, e configuración complexa de build_runner.
  - **Boilerplate:** Incluso operacións simples requiren definir táboas en arquivos separados.
  - **Tamaño:** Aumenta o tamaño do APK en ~200KB vs sqflite directo.
  - **Flexibilidade reducida:** Consultas complexas ad-hoc son máis difíciles que en SQL directo.

**Resultado final:**

Para MedicApp, onde as relacións N:M son fundamentais, as migracións foron frecuentes (19 versións de esquema), e a capacidade de debugging con DB Browser for SQLite foi invaluable durante desenvolvemento, SQLite é a elección correcta.

**Trade-off aceptado:**
Sacrificamos ~10-15% de rendemento en operacións masivas (irrelevante para casos de uso de MedicApp) a cambio de flexibilidade SQL completa, ferramentas maduras e arquitectura de datos robusta.

---

### 12.2. Notificacións: flutter_local_notifications vs awesome_notifications vs Firebase

**Decisión:** flutter_local_notifications

**Xustificación estendida:**

**Requisitos de MedicApp:**

1. **Precisión temporal:** Notificacións deben chegar exactamente á hora programada (08:00:00, non 08:00:30).
2. **Funcionamento offline:** Medicamentos tómanse independentemente de conexión a internet.
3. **Privacidade:** Datos médicos nunca deben saír do dispositivo.
4. **Scheduling a longo prazo:** Notificacións programadas para meses futuros.

**flutter_local_notifications:**

- ✅ **Scheduling preciso:** `zonedSchedule` con `androidScheduleMode: exactAllowWhileIdle` garante entrega exacta incluso con Doze Mode.
- ✅ **Totalmente offline:** Notificacións prográmanse localmente, sen dependencia de servidor.
- ✅ **Privacidade total:** Ningún dato sae do dispositivo.
- ✅ **Madurez:** 5+ anos, 3000+ estrelas, usado en produción por miles de apps médicas.
- ✅ **Documentación:** Exemplos exhaustivos para todos os casos de uso.

**awesome_notifications:**

- ✅ **Pros:** UI de notificacións máis personalizable, animacións, botóns con iconos.
- ❌ **Contras:**
  - **Menos maduro:** 2+ anos vs 5+ de flutter_local_notifications.
  - **Problemas reportados:** Issues con notificacións programadas en Android 12+ (WorkManager conflicts).
  - **Complexidade innecesaria:** MedicApp non require notificacións super personalizadas.
  - **Menor adopción:** ~1500 estrelas vs 3000+ de flutter_local_notifications.

**Firebase Cloud Messaging (FCM):**

- ✅ **Pros:** Notificacións ilimitadas, analytics, segmentación de usuarios.
- ❌ **Contras:**
  - **Require servidor:** Necesitaría backend para enviar notificacións, aumentando complexidade e custo.
  - **Require conexión:** Notificacións non chegan se o dispositivo está offline.
  - **Privacidade:** Datos (horarios de medicación, nomes de medicamentos) enviaríanse a Firebase.
  - **Latencia:** Depende da rede, non garante entrega exacta á hora programada.
  - **Scheduling limitado:** FCM non soporta scheduling preciso, só entrega "aproximada" con delay.
  - **Complexidade:** Require configurar proxecto Firebase, implementar servidor, xestionar tokens.

**Arquitectura correcta para aplicacións médicas locais:**

Para apps como MedicApp (xestión persoal, sen colaboración multi-usuario, sen backend), as notificacións locais son arquitecturalmente superiores a notificacións remotas:

- **Fiabilidade:** Non dependen de conexión a internet ou dispoñibilidade de servidor.
- **Privacidade:** GDPR e regulacións médicas compliant por deseño (datos nunca saen do dispositivo).
- **Simplicidade:** Zero configuración de backend, zero custos de servidor.
- **Precisión:** Garantía de entrega exacta ao segundo.

**Resultado final:**

`flutter_local_notifications` é a elección obvia e correcta para MedicApp. awesome_notifications sería sobre-enxeñaría para UI que non necesitamos, e FCM sería arquitecturalmente incorrecto para unha aplicación completamente local.

---

### 12.3. Xestión de Estado: Vanilla Flutter vs Provider vs BLoC vs Riverpod

**Decisión:** Vanilla Flutter (sen biblioteca de xestión de estado)

**Xustificación estendida:**

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

En MedicApp, **a base de datos É o estado**. Non hai estado significativo en memoria que necesite ser compartido entre widgets.

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

**Por que Provider sería innecesario:**

Provider está deseñado para **compartir estado entre widgets distantes na árbore**. Exemplo clásico:

```dart
// Con Provider (innecesario en MedicApp)
ChangeNotifierProvider(
  create: (_) => MedicationProvider(),
  child: MaterialApp(
    home: HomeScreen(),
  ),
)

// HomeScreen pode acceder a MedicationProvider
Provider.of<MedicationProvider>(context).medications

// DetailScreen tamén pode acceder a MedicationProvider
Provider.of<MedicationProvider>(context).addDose(...)
```

**Problema:** En MedicApp, as pantallas NON necesitan compartir estado en memoria. Cada pantalla consulta a base de datos directamente:

```dart
// Pantalla 1: Lista de medicamentos
final medications = await db.getMedications();

// Pantalla 2: Detalle de medicamento
final medication = await db.getMedication(id);

// Pantalla 3: Historial de doses
final history = await db.getDoseHistory(medicationId);
```

Todas obteñen datos directamente de SQLite, que é a única fonte de verdade. Non hai necesidade de `ChangeNotifier`, `MultiProvider`, nin propagación de estado.

**Por que BLoC sería sobre-enxeñaría:**

BLoC (Business Logic Component) está deseñado para aplicacións empresariais con **lóxica de negocio complexa** que debe estar **separada da UI** e **testeada independentemente**.

Exemplo de arquitectura BLoC:

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
  // ... máis eventos
}

// medication_event.dart (eventos separados)
// medication_state.dart (estados separados)
// medication_repository.dart (capa de datos)
```

**Problema:** Isto engade **4-5 arquivos** por feature e centos de liñas de boilerplate para implementar o que en Vanilla Flutter é:

```dart
final medications = await DatabaseHelper.instance.getMedications();
setState(() {
  _medications = medications;
});
```

**Para MedicApp:**

- **Lóxica de negocio simple:** Cálculos de stock (resta), cálculos de datas (comparación), formateo de strings.
- **Sen regras de negocio complexas:** Non hai validacións de tarxetas de crédito, cálculos financeiros, autenticación OAuth, etc.
- **Testing directo:** Os servizos (DatabaseHelper, NotificationService) testéanse directamente sen necesidade de mocks de BLoC.

**Por que Riverpod sería innecesario:**

Riverpod é unha evolución de Provider que soluciona algúns problemas (compile-time safety, non depende de BuildContext), pero segue sendo innecesario para MedicApp polas mesmas razóns que Provider.

**Casos onde SI se necesitaría xestión de estado:**

1. **Aplicación con autenticación:** Estado de usuario/sesión compartido entre todas as pantallas.
2. **Carro de compra:** Estado de items seleccionados compartido entre produtos, carro, checkout.
3. **Chat en tempo real:** Mensaxes entrantes que deben actualizar múltiples pantallas simultáneamente.
4. **Aplicación colaborativa:** Múltiples usuarios editando o mesmo documento en tempo real.

**MedicApp NON ten ningún destes casos.**

**Resultado final:**

Para MedicApp, `StatefulWidget + setState + Database as Source of Truth` é a arquitectura correcta. É simple, directa, fácil de entender para calquera desenvolvedor Flutter, e non introduce complexidade innecesaria.

Engadir Provider, BLoC ou Riverpod sería puramente **cargo cult programming** (usar tecnoloxía porque é popular, non porque resolve un problema real).

---

## Conclusión

MedicApp utiliza un stack tecnolóxico **simple, robusto e apropiado** para unha aplicación médica local multiplataforma:

- **Flutter + Dart:** Multiplataforma con rendemento nativo.
- **SQLite:** Base de datos relacional madura con transaccións ACID.
- **Notificacións locais:** Privacidade total e funcionamento offline.
- **Localización ARB:** 8 idiomas con pluralización Unicode CLDR.
- **Vanilla Flutter:** Sen xestión de estado innecesaria.
- **432+ tests:** Cobertura do 75-80% con tests unitarios, de widget e integración.

Cada decisión tecnolóxica está **xustificada por requisitos reais**, non por hype ou tendencias. O resultado é unha aplicación mantenible, confiable e que fai exactamente o que promete sen complexidade artificial.

**Principio rector:** *"Simplicidade cando é posible, complexidade cando é necesario."*
