# Stack Tecnològic de MedicApp

Aquest document detalla totes les tecnologies, frameworks, biblioteques i eines utilitzades a MedicApp, incloent les versions exactes, justificacions d'elecció, alternatives considerades i trade-offs de cada decisió tecnològica.

---

## 1. Core Technologies

### Flutter 3.9.2+

**Versió utilitzada:** `3.9.2+` (SDK compatible fins `3.35.7+`)

**Propòsit:**
Flutter és el framework multiplataforma que constitueix la base de MedicApp. Permet desenvolupar una aplicació nativa per a Android i iOS des d'una única base de codi Dart, garantint rendiment proper al natiu i experiència d'usuari consistent en ambdues plataformes.

**Per què es va triar Flutter:**

1. **Desenvolupament multiplataforma eficient:** Un sol codi base per a Android i iOS redueix costos de desenvolupament i manteniment en un 60-70% comparat amb desenvolupament natiu dual.

2. **Rendiment natiu:** Flutter compila a codi natiu ARM, no utilitza ponts JavaScript com React Native, el que resulta en animacions fluides a 60/120 FPS i temps de resposta instantanis per a operacions crítiques com registre de dosis.

3. **Hot Reload:** Permet iteració ràpida durant el desenvolupament, visualitzant canvis en menys d'1 segon sense perdre l'estat de l'aplicació. Essencial per ajustar la UI de notificacions i fluxos multipàs.

4. **Material Design 3 natiu:** Implementació completa i actualitzada de Material Design 3 inclosa al SDK, sense necessitat de biblioteques de tercers.

5. **Ecosistema madur:** Pub.dev compta amb més de 40.000 paquets, incloent solucions robustes per a notificacions locals, base de dades SQLite i gestió d'arxius.

6. **Testing integrat:** Framework de testing complet inclòs al SDK, amb suport per a unit tests, widget tests i integration tests. MedicApp assoleix 432+ tests amb cobertura del 75-80%.

**Alternatives considerades:**

- **React Native:** Descartat per rendiment inferior en llistes llargues (historial de dosis), problemes amb notificacions locals en segon pla, i experiència inconsistent entre plataformes.
- **Kotlin Multiplatform Mobile (KMM):** Descartat per immaduresa de l'ecosistema, necessitat de codi UI específic per plataforma, i corba d'aprenentatge més pronunciada.
- **Natiu (Swift + Kotlin):** Descartat per duplicació d'esforç de desenvolupament, majors costos de manteniment, i necessitat de dos equips especialitzats.

**Documentació oficial:** https://flutter.dev

---

### Dart 3.0+

**Versió utilitzada:** `3.9.2+` (compatible amb Flutter 3.9.2+)

**Propòsit:**
Dart és el llenguatge de programació orientat a objectes desenvolupat per Google que executa Flutter. Proporciona sintaxi moderna, tipat fort, null safety i rendiment optimitzat.

**Característiques utilitzades a MedicApp:**

1. **Null Safety:** Sistema de tipus que elimina errors de referència nul·la en temps de compilació. Crític per a la fiabilitat d'un sistema mèdic on un NullPointerException podria impedir el registre d'una dosi vital.

2. **Async/Await:** Programació asíncrona elegant per a operacions de base de dades, notificacions i operacions d'arxiu sense bloquejar la UI.

3. **Extension Methods:** Permet estendre classes existents amb mètodes personalitzats, utilitzat per a formatatge de dates i validacions de models.

4. **Records i Pattern Matching (Dart 3.0+):** Estructures de dades immutables per retornar múltiples valors des de funcions de manera segura.

5. **Strong Type System:** Tipat estàtic que detecta errors en temps de compilació, essencial per a operacions crítiques com càlcul d'estoc i programació de notificacions.

**Per què Dart:**

- **Optimitzat per a UI:** Dart va ser dissenyat específicament per a desenvolupament d'interfícies, amb recol·lecció d'escombraries optimitzada per evitar pauses durant animacions.
- **AOT i JIT:** Compilació Ahead-of-Time per a producció (rendiment natiu) i Just-in-Time per a desenvolupament (Hot Reload).
- **Sintaxi familiar:** Similar a Java, C#, JavaScript, reduint la corba d'aprenentatge.
- **Sound Null Safety:** Garantia en temps de compilació que les variables no nul·les mai seran null.

**Documentació oficial:** https://dart.dev

---

### Material Design 3

**Versió:** Implementació nativa en Flutter 3.9.2+

**Propòsit:**
Material Design 3 (Material You) és el sistema de disseny de Google que proporciona components, patrons i directrius per crear interfícies modernes, accessibles i consistents.

**Implementació a MedicApp:**

```dart
useMaterial3: true
```

**Components utilitzats:**

1. **Color Scheme dinàmic:** Sistema de colors basat en llavors (`seedColor: Color(0xFF006B5A)` per a tema clar, `Color(0xFF00A894)` per a tema fosc) que genera automàticament 30+ tonalitats harmòniques.

2. **FilledButton, OutlinedButton, TextButton:** Botons amb estats visuals (hover, pressed, disabled) i mides augmentades (52dp alçada mínima) per a accessibilitat.

3. **Card amb elevació adaptativa:** Targetes amb cantonades arrodonides (16dp) i ombres subtils per a jerarquia visual.

4. **NavigationBar:** Barra de navegació inferior amb indicadors de selecció animats i suport per a navegació entre 3-5 destinacions principals.

5. **FloatingActionButton estès:** FAB amb text descriptiu per a acció primària (afegir medicament).

6. **ModalBottomSheet:** Fulls modals per a accions contextuals com registre ràpid de dosi.

7. **SnackBar amb accions:** Feedback temporal per a operacions completades (dosi registrada, medicament afegit).

**Temes personalitzats:**

MedicApp implementa dos temes complets (clar i fosc) amb tipografia accessible:

- **Mides de font augmentades:** `titleLarge: 26sp`, `bodyLarge: 19sp` (superiors als estàndards de 22sp i 16sp respectivament).
- **Contrast millorat:** Colors de text amb opacitat 87% sobre fons per complir WCAG AA.
- **Botons grans:** Alçada mínima de 52dp (vs 40dp estàndard) per facilitar toc en dispositius mòbils.

**Per què Material Design 3:**

- **Accessibilitat integrada:** Components dissenyats amb suport de lectors de pantalla, mides tàctils mínimes i ràtios de contrast WCAG.
- **Coherència amb l'ecosistema Android:** Aspecte familiar per a usuaris d'Android 12+.
- **Personalització flexible:** Sistema de tokens de disseny que permet adaptar colors, tipografies i formes mantenint coherència.
- **Mode fosc automàtic:** Suport natiu per a tema fosc basat en configuració del sistema.

**Documentació oficial:** https://m3.material.io

---

## 2. Base de Dades i Persistència

### sqflite ^2.3.0

**Versió utilitzada:** `^2.3.0` (compatible amb `2.3.0` fins `< 3.0.0`)

**Propòsit:**
sqflite és el plugin de SQLite per a Flutter que proporciona accés a una base de dades SQL local, relacional i transaccional. MedicApp utilitza SQLite com a emmagatzematge principal per a totes les dades de medicaments, persones, configuracions de pautes i historial de dosis.

**Arquitectura de base de dades de MedicApp:**

```
medicapp.db
├── medications (taula principal)
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
├── person_medications (taula de relació N:M)
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

**Operacions crítiques:**

1. **Transaccions ACID:** Garantia d'atomicitat per a operacions complexes com registre de dosi + descompte d'estoc + programació de notificació.

2. **Consultes relacionals:** JOINs entre `medications`, `persons` i `person_medications` per obtenir configuracions personalitzades per usuari.

3. **Índexs optimitzats:** Índexs en `person_id` i `medication_id` en taules de relació per a consultes ràpides O(log n).

4. **Migracions versionades:** Sistema de migració d'esquema des de V1 fins V19+ amb preservació de dades.

**Per què SQLite:**

1. **ACID compliance:** Garanties transaccionals crítiques per a dades mèdiques on la integritat és fonamental.

2. **Consultes SQL complexes:** Capacitat de realitzar JOINs, agregacions i subconsultes per a informes i filtres avançats.

3. **Rendiment provat:** SQLite és la base de dades més desplegada del món, amb optimitzacions de 20+ anys.

4. **Zero-configuration:** No requereix servidor, configuració o administració. La base de dades és un únic arxiu portable.

5. **Exportació/importació simple:** L'arxiu `.db` pot copiar-se directament per a backups o transferències entre dispositius.

6. **Mida il·limitada:** SQLite suporta bases de dades de fins a 281 terabytes, més que suficient per a dècades d'historial de dosis.

**Comparativa amb alternatives:**

| Característica | SQLite (sqflite) | Hive | Isar | Drift |
|----------------|------------------|------|------|-------|
| **Model de dades** | Relacional SQL | NoSQL Key-Value | NoSQL Documental | Relacional SQL |
| **Llenguatge de consulta** | SQL estàndard | API Dart | Query Builder Dart | SQL + Dart |
| **Transaccions ACID** | ✅ Complet | ❌ Limitat | ✅ Sí | ✅ Sí |
| **Migracions** | ✅ Manual robust | ⚠️ Manual bàsic | ⚠️ Semi-automàtic | ✅ Automàtic |
| **Rendiment lectura** | ⚡ Excel·lent | ⚡⚡ Superior | ⚡⚡ Superior | ⚡ Excel·lent |
| **Rendiment escriptura** | ⚡ Molt bo | ⚡⚡ Excel·lent | ⚡⚡ Excel·lent | ⚡ Molt bo |
| **Mida en disc** | ⚠️ Més gran | ✅ Compacte | ✅ Molt compacte | ⚠️ Més gran |
| **Relacions N:M** | ✅ Natiu | ❌ Manual | ⚠️ Referències | ✅ Natiu |
| **Maduresa** | ✅ 20+ anys | ⚠️ 4 anys | ⚠️ 3 anys | ✅ 5+ anys |
| **Portabilitat** | ✅ Universal | ⚠️ Propietari | ⚠️ Propietari | ⚠️ Flutter-only |
| **Eines externes** | ✅ DB Browser, CLI | ❌ Limitades | ❌ Limitades | ❌ Cap |

**Justificació de SQLite sobre alternatives:**

- **Hive:** Descartat per falta de suport robust per a relacions N:M (arquitectura multi-persona), absència de transaccions ACID completes, i dificultat per realitzar consultes complexes amb JOINs.

- **Isar:** Descartat tot i el seu excel·lent rendiment a causa de la seva immaduresa (llançat el 2022), format propietari que dificulta debugging amb eines estàndard, i limitacions en consultes relacionals complexes.

- **Drift:** Considerat seriosament però descartat per major complexitat (requereix generació de codi), major mida de l'aplicació resultant, i menor flexibilitat en migracions comparat amb SQL directe.

**Trade-offs de SQLite:**

- ✅ **Pros:** Estabilitat provada, SQL estàndard, eines externes, relacions natives, exportació trivial.
- ❌ **Contres:** Rendiment lleugerament inferior a Hive/Isar en operacions massives, mida d'arxiu més gran, boilerplate SQL manual.

**Decisió:** Per a MedicApp, la necessitat de relacions N:M robustes, migracions complexes de V1 a V19+, i capacitat de debugging amb eines SQL estàndard justifica àmpliament l'ús de SQLite sobre alternatives NoSQL més ràpides però menys madures.

**Documentació oficial:** https://pub.dev/packages/sqflite

---

### sqflite_common_ffi ^2.3.0

**Versió utilitzada:** `^2.3.0` (dev_dependencies)

**Propòsit:**
Implementació FFI (Foreign Function Interface) de sqflite que permet executar tests de base de dades en entorns desktop/VM sense necessitat d'emuladors Android/iOS.

**Ús a MedicApp:**

```dart
// test/helpers/database_test_helper.dart
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void setupTestDatabase() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}
```

**Per què és necessari:**

- **Tests 60x més ràpids:** Els tests de base de dades s'executen en VM local en lloc d'emuladors Android, reduint temps de 120s a 2s per a la suite completa.
- **CI/CD sense emuladors:** GitHub Actions pot executar tests sense configurar emuladors, simplificant pipelines.
- **Debugging millorat:** Els arxius `.db` de test són accessibles directament des del sistema d'arxius de l'host.

**Documentació oficial:** https://pub.dev/packages/sqflite_common_ffi

---

### path ^1.8.3

**Versió utilitzada:** `^1.8.3`

**Propòsit:**
Biblioteca de manipulació de rutes d'arxius multiplataforma que abstreu les diferències entre sistemes d'arxius (Windows: `\`, Unix: `/`).

**Ús a MedicApp:**

```dart
import 'package:path/path.dart' as path;

final dbPath = path.join(await getDatabasesPath(), 'medicapp.db');
```

**Documentació oficial:** https://pub.dev/packages/path

---

### path_provider ^2.1.5

**Versió utilitzada:** `^2.1.5`

**Propòsit:**
Plugin que proporciona accés a directoris específics del sistema operatiu de forma multiplataforma (documents, caché, suport d'aplicació).

**Ús a MedicApp:**

```dart
import 'package:path_provider/path_provider.dart';

// Obtenir directori de base de dades
final dbDirectory = await getDatabasesPath(); // Android: /data/data/com.medicapp/databases/

// Obtenir directori per a exportacions
final documentsDirectory = await getApplicationDocumentsDirectory();
```

**Directoris utilitzats:**

1. **getDatabasesPath():** Per a arxiu `medicapp.db` principal.
2. **getApplicationDocumentsDirectory():** Per a exportacions de base de dades que l'usuari pot compartir.
3. **getTemporaryDirectory():** Per a arxius temporals durant importació.

**Documentació oficial:** https://pub.dev/packages/path_provider

---

## 3. Notificacions

### flutter_local_notifications ^19.5.0

**Versió utilitzada:** `^19.5.0`

**Propòsit:**
Sistema complet de notificacions locals (no requereixen servidor) per a Flutter, amb suport per a notificacions programades, repetitives, amb accions i personalitzades per plataforma.

**Implementació a MedicApp:**

MedicApp utilitza un sistema de notificacions sofisticat que gestiona tres tipus de notificacions:

1. **Notificacions de recordatori de dosi:**
   - Programades amb horaris exactes configurats per l'usuari.
   - Inclouen títol amb nom de persona (en multi-persona) i detalls de dosi.
   - Suport per a accions ràpides: "Prendre", "Posposar", "Ometre" (descartades en V20+ per limitacions de tipus).
   - So personalitzat i canal d'alta prioritat en Android.

2. **Notificacions de dosi avançada:**
   - Detecten quan una dosi es pren abans del seu horari programat.
   - Actualitzen automàticament la propera notificació si s'escau.
   - Cancel·len notificacions obsoletes de l'horari avançat.

3. **Notificacions de fi de dejuni:**
   - Notificació ongoing (permanent) durant el període de dejuni amb compte enrere.
   - Es cancel·la automàticament quan acaba el dejuni o quan es tanca manualment.
   - Inclou progrés visual (Android) i hora de finalització.

**Configuració per plataforma:**

**Android:**
```dart
AndroidInitializationSettings('app_icon')
AndroidNotificationDetails(
  'medication_reminders',
  'Recordatoris de Medicaments',
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

**Característiques avançades utilitzades:**

1. **Scheduling precís:** Notificacions programades amb precisió de segon usant `timezone`.
2. **Canals de notificació (Android 8+):** 3 canals separats per a recordatoris, dejuni i sistema.
3. **Payload personalitzat:** Dades JSON en payload per identificar medicament i persona.
4. **Callbacks d'interacció:** Callbacks quan l'usuari toca la notificació.
5. **Gestió de permisos:** Sol·licitud i verificació de permisos en Android 13+ (Tiramisu).

**Límits i optimitzacions:**

- **Límit de 500 notificacions programades simultànies** (limitació del sistema Android).
- MedicApp gestiona priorització automàtica quan se supera aquest límit:
  - Prioritza properes 7 dies.
  - Descarta notificacions de medicaments inactius.
  - Reorganitza quan s'afegeixen/eliminen medicaments.

**Per què flutter_local_notifications:**

1. **Notificacions locals vs remotes:** MedicApp no requereix servidor backend, per tant notificacions locals són l'arquitectura correcta.

2. **Funcionalitat completa:** Suport per a scheduling, repetició, accions, personalització per plataforma i gestió de permisos.

3. **Maduresa provada:** Paquet amb 5+ anys de desenvolupament, 3000+ estrelles a GitHub, utilitzat en producció per milers d'aplicacions.

4. **Documentació exhaustiva:** Exemples detallats per a tots els casos d'ús comuns.

**Per què NO Firebase Cloud Messaging (FCM):**

| Criteri | flutter_local_notifications | Firebase Cloud Messaging |
|---------|----------------------------|--------------------------|
| **Requereix servidor** | ❌ No | ✅ Sí (Firebase) |
| **Requereix connexió** | ❌ No | ✅ Sí (internet) |
| **Privacitat** | ✅ Totes les dades locals | ⚠️ Tokens a Firebase |
| **Latència** | ✅ Instantània | ⚠️ Depèn de xarxa |
| **Cost** | ✅ Gratis | ⚠️ Quota gratuïta limitada |
| **Complexitat setup** | ✅ Mínima | ❌ Alta (Firebase, server) |
| **Funciona offline** | ✅ Sempre | ❌ No |
| **Scheduling precís** | ✅ Sí | ❌ No (aproximat) |

**Decisió:** Per a una aplicació de gestió de medicaments on la privacitat és crítica, les dosis s'han de notificar puntualment fins i tot sense connexió, i no hi ha necessitat de comunicació servidor-client, les notificacions locals són l'arquitectura correcta i més simple.

**Comparativa amb alternatives:**

- **awesome_notifications:** Descartat per menor adopció (menys madur), APIs més complexes, i problemes reportats amb notificacions programades en Android 12+.

- **local_notifications (natiu):** Descartat per requerir codi específic de plataforma (Kotlin/Swift), duplicant esforç de desenvolupament.

**Documentació oficial:** https://pub.dev/packages/flutter_local_notifications

---

### timezone ^0.10.1

**Versió utilitzada:** `^0.10.1`

**Propòsit:**
Biblioteca de gestió de zones horàries que permet programar notificacions en moments específics del dia considerant canvis d'horari d'estiu (DST) i conversions entre zones horàries.

**Ús a MedicApp:**

```dart
import 'package:timezone/timezone.dart' as tz;

// Inicialització
await tz.initializeTimeZones();
final location = tz.getLocation('Europe/Madrid');
tz.setLocalLocation(location);

// Programar notificació a les 08:00 locals
final scheduledDate = tz.TZDateTime(
  location,
  now.year,
  now.month,
  now.day,
  8, // hora
  0, // minuts
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

**Per què és crític:**

- **Horari d'estiu:** Sense `timezone`, les notificacions es desfasarien 1 hora durant els canvis de DST.
- **Consistència:** Els usuaris configuren horaris en la seva zona horària local, que s'ha de respectar independentment de canvis de zona horària del dispositiu.
- **Precisió:** `zonedSchedule` garanteix notificacions en el moment exacte especificat.

**Documentació oficial:** https://pub.dev/packages/timezone

---

### android_intent_plus ^6.0.0

**Versió utilitzada:** `^6.0.0`

**Propòsit:**
Plugin per llançar intencions (Intents) d'Android des de Flutter, utilitzat específicament per obrir la configuració de notificacions quan els permisos estan deshabilitats.

**Ús a MedicApp:**

```dart
import 'package:android_intent_plus/android_intent.dart';

// Obrir configuració de notificacions de l'app
final intent = AndroidIntent(
  action: 'android.settings.APP_NOTIFICATION_SETTINGS',
  arguments: {
    'android.provider.extra.APP_PACKAGE': packageName,
  },
);
await intent.launch();
```

**Casos d'ús:**

1. **Guiar a l'usuari:** Quan els permisos de notificació estan deshabilitats, es mostra un diàleg explicatiu amb botó "Obrir Configuració" que llança directament la pantalla de configuració de notificacions de MedicApp.

2. **UX millorada:** Evita que l'usuari hagi de navegar manualment: Configuració > Aplicacions > MedicApp > Notificacions.

**Documentació oficial:** https://pub.dev/packages/android_intent_plus

---

## 4. Localització (i18n)

### flutter_localizations (SDK)

**Versió utilitzada:** Inclòs a Flutter SDK

**Propòsit:**
Paquet oficial de Flutter que proporciona localitzacions per a widgets de Material i Cupertino en 85+ idiomes, incloent traduccions de components estàndard (botons de diàleg, pickers, etc.).

**Ús a MedicApp:**

```dart
import 'package:flutter_localizations/flutter_localizations.dart';

MaterialApp(
  localizationsDelegates: [
    GlobalMaterialLocalizations.delegate, // Material widgets
    GlobalWidgetsLocalizations.delegate,  // Widgets genèrics
    GlobalCupertinoLocalizations.delegate, // Cupertino (iOS)
  ],
  supportedLocales: [
    Locale('es'), // Espanyol
    Locale('en'), // Anglès
    Locale('de'), // Alemany
    // ... 8 idiomes total
  ],
)
```

**Què proporciona:**

- Traduccions de botons estàndard: "OK", "Cancel·lar", "Acceptar".
- Formats de data i hora localitzats: "15/11/2025" (es) vs "11/15/2025" (en).
- Selectors de data/hora en idioma local.
- Noms de dies i mesos.

**Documentació oficial:** https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization

---

### intl ^0.20.2

**Versió utilitzada:** `^0.20.2`

**Propòsit:**
Biblioteca d'internacionalització de Dart que proporciona formatatge de dates, números, pluralització i traducció de missatges mitjançant arxius ARB.

**Ús a MedicApp:**

```dart
import 'package:intl/intl.dart';

// Formatatge de dates
final formatted = DateFormat('dd/MM/yyyy').format(DateTime.now());

// Formatatge de números
final stock = NumberFormat.decimalPattern().format(25.5);

// Pluralització (des d'ARB)
// "{count, plural, =1{1 pastilla} other{{count} pastilles}}"
```

**Casos d'ús:**

1. **Formatatge de dates:** Mostrar dates d'inici/fi de tractament, historial de dosis.
2. **Formatatge de números:** Mostrar estoc amb decimals segons configuració regional.
3. **Pluralització intel·ligent:** Missatges que canvien segons quantitat ("1 pastilla" vs "5 pastilles").

**Documentació oficial:** https://pub.dev/packages/intl

---

### Sistema ARB (Application Resource Bundle)

**Format utilitzat:** ARB (basat en JSON)

**Propòsit:**
Sistema d'arxius de recursos d'aplicació que permet definir traduccions de strings en format JSON amb suport per a placeholders, pluralització i metadades.

**Configuració a MedicApp:**

**`l10n.yaml`:**
```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
untranslated-messages-file: untranslated_messages.json
```

**Estructura d'arxius:**
```
lib/l10n/
├── app_es.arb (plantilla principal, espanyol)
├── app_en.arb (traduccions anglès)
├── app_de.arb (traduccions alemany)
├── app_fr.arb (traduccions francès)
├── app_it.arb (traduccions italià)
├── app_ca.arb (traduccions català)
├── app_eu.arb (traduccions basc)
└── app_gl.arb (traduccions gallec)
```

**Exemple d'ARB amb característiques avançades:**

**`app_es.arb`:**
```json
{
  "@@locale": "es",

  "appTitle": "MedicApp",
  "@appTitle": {
    "description": "Títol de l'aplicació"
  },

  "medicationDose": "{count, plural, =1{1 {unit}} other{{count} {unit}}}",
  "@medicationDose": {
    "description": "Dosi de medicament amb pluralització",
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

  "stockRemaining": "Queden {stock} {unit, plural, =1{unitat} other{unitats}}",
  "@stockRemaining": {
    "placeholders": {
      "stock": {"type": "num"},
      "unit": {"type": "String"}
    }
  }
}
```

**Generació automàtica:**

Flutter genera automàticament la classe `AppLocalizations` amb mètodes tipats:

```dart
// Codi generat a .dart_tool/flutter_gen/gen_l10n/app_localizations.dart
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

// Ús en codi
Text(AppLocalizations.of(context)!.medicationDose(2.5, 'pastilles'))
// Resultat: "2.5 pastilles"
```

**Avantatges del sistema ARB:**

1. **Tipat fort:** Errors de traducció detectats en compilació.
2. **Placeholders segurs:** Impossible oblidar paràmetres requerits.
3. **Pluralització CLDR:** Suport per a regles de pluralització de 200+ idiomes segons Unicode CLDR.
4. **Metadades útils:** Descripcions i context per a traductors.
5. **Eines de traducció:** Compatible amb Google Translator Toolkit, Crowdin, Lokalise.

**Procés de traducció a MedicApp:**

1. Definir strings a `app_es.arb` (plantilla).
2. Executar `flutter gen-l10n` per generar codi Dart.
3. Traduir a altres idiomes copiant i modificant arxius ARB.
4. Revisar `untranslated_messages.json` per detectar strings mancants.

**Documentació oficial:** https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization#adding-your-own-localized-messages

---

### 8 Idiomes Suportats

MedicApp està completament traduïda a 8 idiomes:

| Codi | Idioma | Regió principal | Parlants (milions) |
|------|--------|-----------------|-------------------|
| `es` | Español | Espanya, Llatinoamèrica | 500M+ |
| `en` | English | Global | 1.500M+ |
| `de` | Deutsch | Alemanya, Àustria, Suïssa | 130M+ |
| `fr` | Français | França, Canadà, Àfrica | 300M+ |
| `it` | Italiano | Itàlia, Suïssa | 85M+ |
| `ca` | Català | Catalunya, València, Balears | 10M+ |
| `eu` | Euskara | País Basc | 750K+ |
| `gl` | Galego | Galícia | 2,5M+ |

**Cobertura total:** ~2.500 milions de parlants potencials

**Strings totals:** ~450 traduccions per idioma

**Qualitat de traducció:**
- Espanyol: Natiu (plantilla)
- Anglès: Natiu
- Alemany, francès, italià: Professional
- Català, basc, gallec: Natiu (llengües cooficials d'Espanya)

**Justificació d'idiomes inclosos:**

- **Espanyol:** Idioma principal del desenvolupador i mercat objectiu inicial (Espanya, Llatinoamèrica).
- **Anglès:** Idioma universal per a abast global.
- **Alemany, francès, italià:** Principals idiomes d'Europa occidental, mercats amb alta demanda d'apps de salut.
- **Català, basc, gallec:** Llengües cooficials a Espanya (regions amb 17M+ habitants), millora accessibilitat per a usuaris majors més còmodes en llengua materna.

---

## 5. Gestió d'Estat

### Sense biblioteca de gestió d'estat (Vanilla Flutter)

**Decisió:** MedicApp **NO utilitza** cap biblioteca de gestió d'estat (Provider, Riverpod, BLoC, Redux, GetX).

**Per què NO s'usa gestió d'estat:**

1. **Arquitectura basada en base de dades:** L'estat veritable de l'aplicació resideix a SQLite, no en memòria. Cada pantalla consulta la base de dades directament per obtenir dades actualitzades.

2. **StatefulWidget + setState és suficient:** Per a una aplicació de complexitat mitjana com MedicApp, `setState()` i `StatefulWidget` proporcionen gestió d'estat local més que adequada.

3. **Simplicitat sobre frameworks:** Evitar dependències innecessàries redueix complexitat, mida de l'aplicació i possibles breaking changes en actualitzacions.

4. **Streams de base de dades:** Per a dades reactives, s'utilitzen `StreamBuilder` amb streams directes des de `DatabaseHelper`:

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

5. **Navegació amb callbacks:** Per a comunicació entre pantalles, s'utilitzen callbacks tradicionals de Flutter:

```dart
// Pantalla principal
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => AddMedicationScreen(
      onMedicationAdded: () {
        setState(() {}); // Refrescar llista
      },
    ),
  ),
);
```

**Comparativa amb alternatives:**

| Solució | MedicApp (Vanilla) | Provider | BLoC | Riverpod |
|---------|-------------------|----------|------|----------|
| **Línies de codi addicionals** | 0 | ~500 | ~1.500 | ~800 |
| **Dependències externes** | 0 | 1 | 2+ | 2+ |
| **Corba d'aprenentatge** | ✅ Mínima | ⚠️ Mitjana | ❌ Alta | ⚠️ Mitjana-Alta |
| **Boilerplate** | ✅ Cap | ⚠️ Mitjà | ❌ Alt | ⚠️ Mitjà |
| **Testing** | ✅ Directe | ⚠️ Requereix mocks | ⚠️ Requereix setup | ⚠️ Requereix setup |
| **Rendiment** | ✅ Excel·lent | ⚠️ Bo | ⚠️ Bo | ⚠️ Bo |
| **Mida APK** | ✅ Mínim | +50KB | +150KB | +100KB |

**Per què NO Provider:**

- **Innecessari:** Provider està dissenyat per compartir estat entre widgets profundament niats. MedicApp obté dades de la base de dades a cada pantalla arrel, sense necessitat de passar estat cap avall.
- **Complexitat afegida:** Requereix `ChangeNotifier`, `MultiProvider`, context-awareness, i entendre l'arbre de widgets.
- **Sobre-enginyeria:** Per a una aplicació amb ~15 pantalles i estat en base de dades, Provider seria usar un martell pneumàtic per clavar un clau.

**Per què NO BLoC:**

- **Complexitat extrema:** BLoC (Business Logic Component) requereix entendre streams, sinks, events, states, i arquitectura de capes.
- **Boilerplate massiu:** Cada feature requereix 4-5 arxius (bloc, event, state, repository, test).
- **Sobre-enginyeria:** BLoC és excel·lent per a aplicacions empresarials amb lògica de negoci complexa i múltiples desenvolupadors. MedicApp és una aplicació de complexitat mitjana on la simplicitat és prioritària.

**Per què NO Riverpod:**

- **Menys madur:** Riverpod és relativament nou (2020) comparat amb Provider (2018) i BLoC (2018).
- **Complexitat similar a Provider:** Requereix entendre providers, autoDispose, family, i arquitectura declarativa.
- **Sense avantatge clara:** Per a MedicApp, Riverpod no ofereix beneficis significatius sobre l'arquitectura actual.

**Per què NO Redux:**

- **Complexitat massiva:** Redux requereix accions, reducers, middleware, store, i immutabilitat estricta.
- **Boilerplate insostenible:** Fins i tot operacions simples requereixen múltiples arxius i centenars de línies de codi.
- **Sobre-kill total:** Redux està dissenyat per a aplicacions web SPA amb estat complex en frontend. MedicApp té estat a SQLite, no en memòria.

**Casos on SÍ es necessitaria gestió d'estat:**

- **Estat compartit complex en memòria:** Si múltiples pantalles necessitessin compartir objectes grans en memòria (no aplica a MedicApp).
- **Estat global d'autenticació:** Si hi hagués login/sessions (MedicApp és local, sense comptes).
- **Sincronització en temps real:** Si hi hagués col·laboració multi-usuari en temps real (no aplica).
- **Lògica de negoci complexa:** Si hi hagués càlculs pesats que requereixen caché en memòria (MedicApp fa càlculs simples d'estoc i dates).

**Decisió final:**

Per a MedicApp, l'arquitectura **Database as Single Source of Truth + StatefulWidget + setState** és la solució correcta. És simple, directa, fàcil d'entendre i mantenir, i no introdueix complexitat innecessària. Afegir Provider, BLoC o Riverpod seria sobre-enginyeria pura sense beneficis tangibles.

---

## 6. Emmagatzematge Local

### shared_preferences ^2.2.2

**Versió utilitzada:** `^2.2.2`

**Propòsit:**
Emmagatzematge persistent de clau-valor per a preferències simples de l'usuari, configuracions d'aplicació i estats no crítics. Utilitza `SharedPreferences` a Android i `UserDefaults` a iOS.

**Ús a MedicApp:**

MedicApp utilitza `shared_preferences` per emmagatzemar configuracions lleugeres que no justifiquen una taula SQL:

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

**Dades emmagatzemades:**

1. **Tema d'aplicació:**
   - Clau: `theme_mode`
   - Valors: `ThemeMode.light`, `ThemeMode.dark`, `ThemeMode.system`
   - Ús: Persistir preferència de tema entre sessions.

2. **Idioma seleccionat:**
   - Clau: `locale`
   - Valors: `es`, `en`, `de`, `fr`, `it`, `ca`, `eu`, `gl`
   - Ús: Recordar idioma triat per l'usuari (override de l'idioma del sistema).

3. **Estat de permisos:**
   - Clau: `notifications_enabled`
   - Valors: `true`, `false`
   - Ús: Caché local de l'estat de permisos per evitar crides natives repetides.

4. **Primera execució:**
   - Clau: `first_run`
   - Valors: `true`, `false`
   - Ús: Mostrar tutorial/onboarding només en primera execució.

**Per què shared_preferences i no SQLite:**

- **Rendiment:** Accés instantani O(1) per a valors simples vs consulta SQL amb overhead.
- **Simplicitat:** API trivial (`getString`, `setString`) vs preparar queries SQL.
- **Propòsit:** Preferències d'usuari vs dades relacionals.
- **Mida:** Valors petits (< 1KB) vs registres complexos.

**Limitacions de shared_preferences:**

- ❌ No suporta relacions, JOINs, transaccions.
- ❌ No apropiat per a dades >100KB.
- ❌ Accés asíncron (requereix `await`).
- ❌ Només tipus primitius (String, int, double, bool, List<String>).

**Trade-offs:**

- ✅ **Pros:** API simple, rendiment excel·lent, propòsit correcte per a preferències.
- ❌ **Contres:** No apropiat per a dades estructurades o voluminoses.

**Documentació oficial:** https://pub.dev/packages/shared_preferences

---

## 7. Operacions d'Arxius

### file_picker ^8.0.0+1

**Versió utilitzada:** `^8.0.0+1`

**Propòsit:**
Plugin multiplataforma per seleccionar arxius del sistema d'arxius del dispositiu, amb suport per a múltiples plataformes (Android, iOS, desktop, web).

**Ús a MedicApp:**

MedicApp utilitza `file_picker` exclusivament per a la funció d'**importació de base de dades**, permetent a l'usuari restaurar un backup o migrar dades des d'un altre dispositiu.

**Implementació:**

```dart
import 'package:file_picker/file_picker.dart';

Future<void> importDatabase() async {
  // Obrir selector d'arxius
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['db'],
    dialogTitle: 'Seleccionar arxiu de base de dades',
  );

  if (result == null) return; // Usuari va cancel·lar

  final file = result.files.single;
  final path = file.path!;

  // Validar i copiar arxiu
  await DatabaseHelper.instance.importDatabase(path);

  // Recarregar aplicació
  setState(() {});
}
```

**Característiques utilitzades:**

1. **Filtre d'extensions:** Només permet seleccionar arxius `.db` per evitar errors de l'usuari.
2. **Títol personalitzat:** Mostra missatge descriptiu al diàleg del sistema.
3. **Ruta completa:** Obté path absolut de l'arxiu per copiar-lo a la ubicació de l'app.

**Alternatives considerades:**

- **image_picker:** Descartat perquè està dissenyat específicament per a imatges/vídeos, no arxius genèrics.
- **Codi natiu:** Descartat perquè requeriria implementar `ActivityResultLauncher` (Android) i `UIDocumentPickerViewController` (iOS) manualment.

**Documentació oficial:** https://pub.dev/packages/file_picker

---

### share_plus ^10.1.4

**Versió utilitzada:** `^10.1.4`

**Propòsit:**
Plugin multiplataforma per compartir arxius, text i URLs utilitzant el full de compartir natiu del sistema operatiu (Android Share Sheet, iOS Share Sheet).

**Ús a MedicApp:**

MedicApp utilitza `share_plus` per a la funció d'**exportació de base de dades**, permetent a l'usuari crear un backup i compartir-lo via email, cloud storage (Drive, Dropbox), Bluetooth, o guardar-lo en arxius locals.

**Implementació:**

```dart
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

Future<void> exportDatabase() async {
  // Obtenir ruta de la base de dades actual
  final dbPath = await DatabaseHelper.instance.getDatabasePath();

  // Crear còpia temporal en directori compartible
  final tempDir = await getTemporaryDirectory();
  final exportPath = '${tempDir.path}/medicapp_backup_${DateTime.now().millisecondsSinceEpoch}.db';

  // Copiar base de dades
  await File(dbPath).copy(exportPath);

  // Compartir arxiu
  await Share.shareXFiles(
    [XFile(exportPath)],
    subject: 'Backup MedicApp',
    text: 'Base de dades de MedicApp - ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
  );
}
```

**Flux d'usuari:**

1. Usuari toca "Exportar base de dades" al menú de configuració.
2. MedicApp crea còpia de `medicapp.db` amb timestamp al nom.
3. S'obre el full de compartir natiu del SO.
4. Usuari tria destinació: Gmail (com adjunt), Drive, Bluetooth, "Guardar en arxius", etc.
5. L'arxiu `.db` es comparteix/guarda a la destinació triada.

**Característiques avançades:**

- **XFile:** Abstracció multiplataforma d'arxius que funciona a Android, iOS, desktop i web.
- **Metadades:** Inclou nom d'arxiu descriptiu i text explicatiu.
- **Compatibilitat:** Funciona amb totes les apps compatibles amb el protocol de compartir del SO.

**Per què share_plus:**

- **UX nativa:** Utilitza la interfície de compartir que l'usuari ja coneix, sense reinventar la roda.
- **Integració perfecta:** S'integra automàticament amb totes les apps instal·lades que poden rebre arxius.
- **Multiplataforma:** Mateix codi funciona a Android i iOS amb comportament natiu a cadascun.

**Alternatives considerades:**

- **Escriure a directori públic directament:** Descartat perquè a Android 10+ (Scoped Storage) requereix permisos complexos i no funciona de forma consistent.
- **Plugin d'email directe:** Descartat perquè limita l'usuari a un sol mètode de backup (email), mentre que `share_plus` permet qualsevol destinació.

**Documentació oficial:** https://pub.dev/packages/share_plus

---

## 8. Testing

### flutter_test (SDK)

**Versió utilitzada:** Inclòs a Flutter SDK

**Propòsit:**
Framework oficial de testing de Flutter que proporciona totes les eines necessàries per a unit tests, widget tests i integration tests.

**Arquitectura de testing de MedicApp:**

MedicApp compta amb **432+ tests** organitzats en 3 categories:

#### 1. Unit Tests (60% dels tests)

Tests de lògica de negoci pura, models, serveis i helpers sense dependències de Flutter.

**Exemples:**
- `test/medication_model_test.dart`: Validació de models de dades.
- `test/dose_history_service_test.dart`: Lògica d'historial de dosis.
- `test/notification_service_test.dart`: Lògica de programació de notificacions.
- `test/preferences_service_test.dart`: Servei de preferències.

**Estructura típica:**
```dart
void main() {
  setUpAll(() async {
    // Inicialitzar base de dades de test
    setupTestDatabase();
  });

  tearDown(() async {
    // Netejar base de dades després de cada test
    await DatabaseHelper.instance.close();
  });

  group('Medication Model', () {
    test('should create medication with valid data', () {
      final medication = Medication(
        id: 'test-id',
        name: 'Ibuprofèn',
        type: MedicationType.pill,
      );

      expect(medication.id, 'test-id');
      expect(medication.name, 'Ibuprofèn');
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

      expect(nextDose.hour, 20); // Propera dosi a les 20:00
    });
  });
}
```

#### 2. Widget Tests (30% dels tests)

Tests de widgets individuals, interaccions d'UI i fluxos de navegació.

**Exemples:**
- `test/settings_screen_test.dart`: Pantalla de configuració.
- `test/edit_schedule_screen_test.dart`: Editor d'horaris.
- `test/edit_duration_screen_test.dart`: Editor de durada.
- `test/day_navigation_ui_test.dart`: Navegació de dies.

**Estructura típica:**
```dart
void main() {
  testWidgets('should display medication list', (tester) async {
    // Arrange: Preparar dades de test
    final medications = [
      Medication(id: '1', name: 'Ibuprofèn', type: MedicationType.pill),
      Medication(id: '2', name: 'Paracetamol', type: MedicationType.pill),
    ];

    // Act: Construir widget
    await tester.pumpWidget(
      MaterialApp(
        home: MedicationListScreen(medications: medications),
      ),
    );

    // Assert: Verificar UI
    expect(find.text('Ibuprofèn'), findsOneWidget);
    expect(find.text('Paracetamol'), findsOneWidget);

    // Interacció: Tocar primer medicament
    await tester.tap(find.text('Ibuprofèn'));
    await tester.pumpAndSettle();

    // Verificar navegació
    expect(find.byType(MedicationDetailScreen), findsOneWidget);
  });
}
```

#### 3. Integration Tests (10% dels tests)

Tests end-to-end de fluxos complets que involucren múltiples pantalles, base de dades i serveis.

**Exemples:**
- `test/integration/add_medication_test.dart`: Flux complet d'afegir medicament (8 passos).
- `test/integration/dose_registration_test.dart`: Registre de dosi i actualització d'estoc.
- `test/integration/stock_management_test.dart`: Gestió completa d'estoc (recàrrega, esgotament, alertes).
- `test/integration/app_startup_test.dart`: Inici d'aplicació i càrrega de dades.

**Estructura típica:**
```dart
void main() {
  testWidgets('complete add medication flow', (tester) async {
    // Iniciar aplicació
    await tester.pumpWidget(const MedicApp());
    await tester.pumpAndSettle();

    // Pas 1: Obrir pantalla d'afegir medicament
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Pas 2: Introduir nom
    await tester.enterText(find.byType(TextField).first, 'Ibuprofèn 600mg');

    // Pas 3: Seleccionar tipus
    await tester.tap(find.text('Pastilla'));
    await tester.pumpAndSettle();

    // Pas 4: Següent pas
    await tester.tap(find.text('Següent'));
    await tester.pumpAndSettle();

    // ... continuar amb els 8 passos

    // Verificar medicament afegit
    expect(find.text('Ibuprofèn 600mg'), findsOneWidget);

    // Verificar a base de dades
    final medications = await DatabaseHelper.instance.getMedications();
    expect(medications.length, 1);
    expect(medications.first.name, 'Ibuprofèn 600mg');
  });
}
```

**Cobertura de codi:**

- **Objectiu:** 75-80%
- **Actual:** 75-80% (432+ tests)
- **Línies cobertes:** ~12.000 de ~15.000

**Àrees amb major cobertura:**
- Models: 95%+ (lògica crítica de dades)
- Services: 85%+ (notificacions, base de dades, dosis)
- Screens: 65%+ (UI i navegació)

**Àrees amb menor cobertura:**
- Helpers i utilities: 60%
- Codi d'inicialització: 50%

**Estratègia de testing:**

1. **Test-first per a lògica crítica:** Tests escrits abans del codi per a càlculs de dosis, estoc, horaris.
2. **Test-after per a UI:** Tests escrits després d'implementar pantalles per verificar comportament.
3. **Regression tests:** Cada bug trobat es converteix en un test per evitar regressions.

**Comandos de testing:**

```bash
# Executar tots els tests
flutter test

# Executar tests amb cobertura
flutter test --coverage

# Executar tests específics
flutter test test/medication_model_test.dart

# Executar tests d'integració
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
  await DatabaseHelper.instance.database; // Recrear neta
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

**Documentació oficial:** https://docs.flutter.dev/testing

---

## 9. Eines de Desenvolupament

### flutter_launcher_icons ^0.14.4

**Versió utilitzada:** `^0.14.4` (dev_dependencies)

**Propòsit:**
Paquet que genera automàticament icones d'aplicació en totes les mides i formats requerits per Android i iOS des d'una única imatge font.

**Configuració a MedicApp:**

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

**Icones generades:**

**Android:**
- `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` (72x72)
- `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` (48x48)
- `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png` (96x96)
- `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` (144x144)
- `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` (192x192)
- Icones adaptatives per a Android 8+ (foreground + background separats)

**iOS:**
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/` (20x20 fins 1024x1024, 15+ variants)

**Comandament de generació:**

```bash
flutter pub run flutter_launcher_icons
```

**Per què aquesta eina:**

- **Automatització:** Generar manualment 20+ arxius d'icones seria tediós i propens a errors.
- **Icones adaptatives (Android 8+):** Suporta la funcionalitat d'icones adaptatives que s'ajusten a diferents formes segons el launcher.
- **Optimització:** Les icones es generen en format PNG optimitzat.
- **Consistència:** Garanteix que totes les mides es generin des de la mateixa font.

**Documentació oficial:** https://pub.dev/packages/flutter_launcher_icons

---

### flutter_native_splash ^2.4.7

**Versió utilitzada:** `^2.4.7` (dev_dependencies)

**Propòsit:**
Paquet que genera splash screens natius (pantalles de càrrega inicial) per a Android i iOS, mostrant-se instantàniament mentre Flutter inicialitza.

**Configuració a MedicApp:**

**`pubspec.yaml`:**
```yaml
flutter_native_splash:
  color: "#419e69"  # Color de fons (verd MedicApp)
  image: assets/images/icon.png  # Imatge central
  android: true
  ios: true
  fullscreen: true
  android_12:
    image: assets/images/icon.png
    color: "#419e69"
```

**Característiques implementades:**

1. **Splash unificat:** Mateixa aparença a Android i iOS.
2. **Color de marca:** Verd `#419e69` (color primari de MedicApp).
3. **Logo centrat:** Icona de MedicApp al centre de pantalla.
4. **Pantalla completa:** Oculta barra d'estat durant splash.
5. **Android 12+ específic:** Configuració especial per complir amb el nou sistema de splash d'Android 12.

**Arxius generats:**

**Android:**
- `android/app/src/main/res/drawable/launch_background.xml`
- `android/app/src/main/res/values/styles.xml` (tema de splash)
- `android/app/src/main/res/values-night/styles.xml` (tema fosc)

**iOS:**
- `ios/Runner/Assets.xcassets/LaunchImage.imageset/`
- `ios/Runner/Base.lproj/LaunchScreen.storyboard`

**Comandament de generació:**

```bash
flutter pub run flutter_native_splash:create
```

**Per què splash natiu:**

- **UX professional:** Evita pantalla blanca durant 1-2 segons d'inicialització de Flutter.
- **Branding immediat:** Mostra logo i colors de marca des del primer frame.
- **Percepció de velocitat:** Splash amb branding se sent més ràpid que pantalla blanca.

**Documentació oficial:** https://pub.dev/packages/flutter_native_splash

---

### uuid ^4.0.0

**Versió utilitzada:** `^4.0.0`

**Propòsit:**
Generador d'UUIDs (Universally Unique Identifiers) v4 per crear identificadors únics de medicaments, persones i registres de dosis.

**Ús a MedicApp:**

```dart
import 'package:uuid/uuid.dart';

const uuid = Uuid();

final medication = Medication(
  id: uuid.v4(), // Genera: "f47ac10b-58cc-4372-a567-0e02b2c3d479"
  name: 'Ibuprofèn',
  type: MedicationType.pill,
);
```

**Per què UUIDs:**

- **Unicitat global:** Probabilitat de col·lisió: 1 en 10³⁸ (pràcticament impossible).
- **Generació offline:** No requereix coordinació amb servidor o seqüències de base de dades.
- **Sincronització futura:** Si MedicApp afegeix sincronització cloud, els UUIDs eviten conflictes d'IDs.
- **Depuració:** IDs descriptius en logs en lloc d'enters genèrics (1, 2, 3).

**Alternativa considerada:**

- **Auto-increment enter:** Descartat perquè requeriria gestió de seqüències a SQLite i podria causar conflictes en futura sincronització.

**Documentació oficial:** https://pub.dev/packages/uuid

---

## 10. Dependències de Plataforma

### Android

**Configuració de build:**

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
        isCoreLibraryDesugaringEnabled = true  // Per a APIs modernes a Android < 26
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```

**Eines:**

- **Gradle 8.0+:** Sistema de build d'Android.
- **Kotlin 1.9.0:** Llenguatge per a codi natiu Android (encara que MedicApp no usa codi Kotlin custom).
- **AndroidX:** Biblioteques de suport modernes (reemplaçament de Support Library).

**Versions mínimes:**

- **minSdk 21 (Android 5.0 Lollipop):** Cobertura del 99%+ de dispositius Android actius.
- **targetSdk 34 (Android 14):** Última versió d'Android per aprofitar característiques modernes.

**Permisos requerits:**

**`android/app/src/main/AndroidManifest.xml`:**
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" /> <!-- Android 13+ -->
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" /> <!-- Notificacions exactes -->
<uses-permission android:name="android.permission.USE_EXACT_ALARM" /> <!-- Android 14+ -->
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" /> <!-- Reprogramar notificacions després de reinici -->
```

**Documentació oficial:** https://developer.android.com

---

### iOS

**Configuració de build:**

**`ios/Runner/Info.plist`:**
```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>

<key>NSUserNotificationsUsageDescription</key>
<string>MedicApp necessita enviar notificacions per recordar-te prendre els teus medicaments.</string>
```

**Eines:**

- **CocoaPods 1.11+:** Gestor de dependències natives d'iOS.
- **Xcode 14+:** IDE requerit per compilar apps iOS.
- **Swift 5.0:** Llenguatge per a codi natiu iOS (encara que MedicApp usa AppDelegate per defecte).

**Versions mínimes:**

- **iOS 12.0+:** Cobertura del 98%+ de dispositius iOS actius.
- **iPadOS 12.0+:** Suport complet per a iPad.

**Capacitats requerides:**

- **Push Notifications:** Encara que MedicApp usa notificacions locals, aquesta capacitat habilita el framework de notificacions.
- **Background Fetch:** Permet actualitzar notificacions quan l'app està en segon pla.

**Documentació oficial:** https://developer.apple.com/documentation/

---

## 11. Versions i Compatibilitat

### Taula de Dependències

| Dependència | Versió | Propòsit | Categoria |
|-------------|---------|-----------|-----------|
| **Flutter SDK** | `3.9.2+` | Framework principal | Core |
| **Dart SDK** | `3.9.2+` | Llenguatge de programació | Core |
| **cupertino_icons** | `^1.0.8` | Icones iOS | UI |
| **sqflite** | `^2.3.0` | Base de dades SQLite | Persistència |
| **path** | `^1.8.3` | Manipulació de rutes | Utilitat |
| **flutter_local_notifications** | `^19.5.0` | Notificacions locals | Notificacions |
| **timezone** | `^0.10.1` | Zones horàries | Notificacions |
| **intl** | `^0.20.2` | Internacionalització | i18n |
| **android_intent_plus** | `^6.0.0` | Intencions Android | Permisos |
| **shared_preferences** | `^2.2.2` | Preferències usuari | Persistència |
| **file_picker** | `^8.0.0+1` | Selector d'arxius | Arxius |
| **share_plus** | `^10.1.4` | Compartir arxius | Arxius |
| **path_provider** | `^2.1.5` | Directoris del sistema | Persistència |
| **uuid** | `^4.0.0` | Generador d'UUIDs | Utilitat |
| **sqflite_common_ffi** | `^2.3.0` | Testing de SQLite | Testing (dev) |
| **flutter_launcher_icons** | `^0.14.4` | Generació d'icones | Eina (dev) |
| **flutter_native_splash** | `^2.4.7` | Splash screen | Eina (dev) |
| **flutter_lints** | `^6.0.0` | Anàlisi estàtic | Eina (dev) |

**Total dependències de producció:** 14
**Total dependències de desenvolupament:** 4
**Total:** 18

---

### Compatibilitat de Plataformes

| Plataforma | Versió mínima | Versió objectiu | Cobertura |
|------------|----------------|------------------|-----------|
| **Android** | 5.0 (API 21) | 14 (API 34) | 99%+ dispositius |
| **iOS** | 12.0 | 17.0 | 98%+ dispositius |
| **iPadOS** | 12.0 | 17.0 | 98%+ dispositius |

**No suportat:** Web, Windows, macOS, Linux (MedicApp és exclusivament mòbil per disseny).

---

### Compatibilitat de Flutter

| Flutter | Compatible | Notes |
|---------|------------|-------|
| 3.9.2 - 3.10.x | ✅ | Versió de desenvolupament |
| 3.11.x - 3.19.x | ✅ | Compatible sense canvis |
| 3.20.x - 3.35.x | ✅ | Provat fins 3.35.7 |
| 3.36.x+ | ⚠️ | Probable compatible, no provat |
| 4.0.x | ❌ | Requereix actualització de dependències |

---

## 12. Comparatives i Decisions

### 12.1. Base de Dades: SQLite vs Hive vs Isar vs Drift

**Decisió:** SQLite (sqflite)

**Justificació estesa:**

**Requisits de MedicApp:**

1. **Relacions N:M (Molts a Molts):** Un medicament pot ser assignat a múltiples persones, i una persona pot tenir múltiples medicaments. Aquesta arquitectura és nativa en SQL però complexa en NoSQL.

2. **Consultes complexes:** Obtenir tots els medicaments d'una persona amb les seves configuracions personalitzades requereix JOINs entre 3 taules:

```sql
SELECT m.*, pm.custom_times, pm.custom_doses
FROM medications m
JOIN person_medications pm ON m.id = pm.medication_id
JOIN persons p ON pm.person_id = p.id
WHERE p.id = ?
```

Això és trivial en SQL però requeriria múltiples consultes i lògica manual en NoSQL.

3. **Migracions complexes:** MedicApp ha evolucionat des de V1 (taula simple de medicaments) fins V19+ (multi-persona amb relacions). SQLite permet migracions SQL incrementals que preserven dades:

```sql
-- Migració V18 -> V19: Afegir multi-persona
ALTER TABLE medications ADD COLUMN shared_stock REAL;
CREATE TABLE persons (...);
CREATE TABLE person_medications (...);
INSERT INTO persons (id, name, is_default) VALUES (?, 'Jo', 1);
INSERT INTO person_medications SELECT ?, id, times, doses FROM medications;
```

**Hive:**

- ✅ **Pros:** Rendiment excel·lent, API simple, mida compacta.
- ❌ **Contres:**
  - **Sense relacions natives:** Implementar N:M requereix mantenir llistes d'IDs manualment i fer múltiples consultes.
  - **Sense transaccions ACID completes:** No pot garantir atomicitat en operacions complexes (registre de dosi + descompte d'estoc + notificació).
  - **Migracions manuals:** No hi ha sistema de versionat d'esquema, requereix lògica custom.
  - **Debugging difícil:** Format binari propietari, no es pot inspeccionar amb eines estàndard.

**Isar:**

- ✅ **Pros:** Rendiment superior, indexat ràpid, sintaxi Dart elegant.
- ❌ **Contres:**
  - **Immaduresa:** Llançat el 2022, menys battle-tested que SQLite (20+ anys).
  - **Relacions limitades:** Suporta relacions però no tan flexibles com SQL JOINs (limitat a 1:1, 1:N, sense M:N directe).
  - **Format propietari:** Similar a Hive, dificulta debugging amb eines externes.
  - **Lock-in:** Migrar d'Isar a una altra solució seria costós.

**Drift:**

- ✅ **Pros:** Type-safe SQL, migracions automàtiques, APIs generades.
- ❌ **Contres:**
  - **Complexitat:** Requereix generació de codi, arxius `.drift`, i configuració complexa de build_runner.
  - **Boilerplate:** Fins i tot operacions simples requereixen definir taules en arxius separats.
  - **Mida:** Augmenta la mida de l'APK en ~200KB vs sqflite directe.
  - **Flexibilitat reduïda:** Consultes complexes ad-hoc són més difícils que en SQL directe.

**Resultat final:**

Per a MedicApp, on les relacions N:M són fonamentals, les migracions han estat freqüents (19 versions d'esquema), i la capacitat de debugging amb DB Browser for SQLite ha estat invaluable durant desenvolupament, SQLite és l'elecció correcta.

**Trade-off acceptat:**
Sacrifiquem ~10-15% de rendiment en operacions massives (irrellevant per a casos d'ús de MedicApp) a canvi de flexibilitat SQL completa, eines madures i arquitectura de dades robusta.

---

### 12.2. Notificacions: flutter_local_notifications vs awesome_notifications vs Firebase

**Decisió:** flutter_local_notifications

**Justificació estesa:**

**Requisits de MedicApp:**

1. **Precisió temporal:** Notificacions han d'arribar exactament a l'hora programada (08:00:00, no 08:00:30).
2. **Funcionament offline:** Medicaments es prenen independentment de connexió a internet.
3. **Privacitat:** Dades mèdiques mai han de sortir del dispositiu.
4. **Scheduling a llarg termini:** Notificacions programades per a mesos futurs.

**flutter_local_notifications:**

- ✅ **Scheduling precís:** `zonedSchedule` amb `androidScheduleMode: exactAllowWhileIdle` garanteix entrega exacta fins i tot amb Doze Mode.
- ✅ **Totalment offline:** Notificacions es programen localment, sense dependència de servidor.
- ✅ **Privacitat total:** Cap dada surt del dispositiu.
- ✅ **Maduresa:** 5+ anys, 3000+ estrelles, usat en producció per milers d'apps mèdiques.
- ✅ **Documentació:** Exemples exhaustius per a tots els casos d'ús.

**awesome_notifications:**

- ✅ **Pros:** UI de notificacions més personalitzable, animacions, botons amb icones.
- ❌ **Contres:**
  - **Menys madur:** 2+ anys vs 5+ de flutter_local_notifications.
  - **Problemes reportats:** Issues amb notificacions programades en Android 12+ (WorkManager conflicts).
  - **Complexitat innecessària:** MedicApp no requereix notificacions super personalitzades.
  - **Menor adopció:** ~1500 estrelles vs 3000+ de flutter_local_notifications.

**Firebase Cloud Messaging (FCM):**

- ✅ **Pros:** Notificacions il·limitades, analytics, segmentació d'usuaris.
- ❌ **Contres:**
  - **Requereix servidor:** Necessitaria backend per enviar notificacions, augmentant complexitat i cost.
  - **Requereix connexió:** Notificacions no arriben si el dispositiu està offline.
  - **Privacitat:** Dades (horaris de medicació, noms de medicaments) s'enviarien a Firebase.
  - **Latència:** Depèn de la xarxa, no garanteix entrega exacta a l'hora programada.
  - **Scheduling limitat:** FCM no suporta scheduling precís, només entrega "aproximada" amb delay.
  - **Complexitat:** Requereix configurar projecte Firebase, implementar servidor, gestionar tokens.

**Arquitectura correcta per a aplicacions mèdiques locals:**

Per a apps com MedicApp (gestió personal, sense col·laboració multi-usuari, sense backend), les notificacions locals són arquitecturalment superiors a notificacions remotes:

- **Fiabilitat:** No depenen de connexió a internet o disponibilitat de servidor.
- **Privacitat:** GDPR i regulacions mèdiques compliant per disseny (dades mai surten del dispositiu).
- **Simplicitat:** Zero configuració de backend, zero costos de servidor.
- **Precisió:** Garantia d'entrega exacta al segon.

**Resultat final:**

`flutter_local_notifications` és l'elecció òbvia i correcta per a MedicApp. awesome_notifications seria sobre-enginyeria per a UI que no necessitem, i FCM seria arquitecturalment incorrecte per a una aplicació completament local.

---

### 12.3. Gestió d'Estat: Vanilla Flutter vs Provider vs BLoC vs Riverpod

**Decisió:** Vanilla Flutter (sense biblioteca de gestió d'estat)

**Justificació estesa:**

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

A MedicApp, **la base de dades ÉS l'estat**. No hi ha estat significatiu en memòria que necessiti ser compartit entre widgets.

**Patró típic de pantalla:**

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

**Per què Provider seria innecessari:**

Provider està dissenyat per **compartir estat entre widgets distants a l'arbre**. Exemple clàssic:

```dart
// Amb Provider (innecessari a MedicApp)
ChangeNotifierProvider(
  create: (_) => MedicationProvider(),
  child: MaterialApp(
    home: HomeScreen(),
  ),
)

// HomeScreen pot accedir a MedicationProvider
Provider.of<MedicationProvider>(context).medications

// DetailScreen també pot accedir a MedicationProvider
Provider.of<MedicationProvider>(context).addDose(...)
```

**Problema:** A MedicApp, les pantalles NO necessiten compartir estat en memòria. Cada pantalla consulta la base de dades directament:

```dart
// Pantalla 1: Llista de medicaments
final medications = await db.getMedications();

// Pantalla 2: Detall de medicament
final medication = await db.getMedication(id);

// Pantalla 3: Historial de dosis
final history = await db.getDoseHistory(medicationId);
```

Totes obtenen dades directament de SQLite, que és l'única font de veritat. No hi ha necessitat de `ChangeNotifier`, `MultiProvider`, ni propagació d'estat.

**Per què BLoC seria sobre-enginyeria:**

BLoC (Business Logic Component) està dissenyat per a aplicacions empresarials amb **lògica de negoci complexa** que ha d'estar **separada de la UI** i **testejada independentment**.

Exemple d'arquitectura BLoC:

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
  // ... més events
}

// medication_event.dart (events separats)
// medication_state.dart (estats separats)
// medication_repository.dart (capa de dades)
```

**Problema:** Això afegeix **4-5 arxius** per feature i centenars de línies de boilerplate per implementar el que en Vanilla Flutter és:

```dart
final medications = await DatabaseHelper.instance.getMedications();
setState(() {
  _medications = medications;
});
```

**Per a MedicApp:**

- **Lògica de negoci simple:** Càlculs d'estoc (resta), càlculs de dates (comparació), formatatge de strings.
- **Sense regles de negoci complexes:** No hi ha validacions de targetes de crèdit, càlculs financers, autenticació OAuth, etc.
- **Testing directe:** Els serveis (DatabaseHelper, NotificationService) es testegen directament sense necessitat de mocks de BLoC.

**Per què Riverpod seria innecessari:**

Riverpod és una evolució de Provider que soluciona alguns problemes (compile-time safety, no depèn de BuildContext), però continua sent innecessari per a MedicApp per les mateixes raons que Provider.

**Casos on SÍ necessitaríem gestió d'estat:**

1. **Aplicació amb autenticació:** Estat d'usuari/sessió compartit entre totes les pantalles.
2. **Carret de compra:** Estat d'items seleccionats compartit entre productes, carret, checkout.
3. **Xat en temps real:** Missatges entrants que han d'actualitzar múltiples pantalles simultàniament.
4. **Aplicació col·laborativa:** Múltiples usuaris editant el mateix document en temps real.

**MedicApp NO té cap d'aquests casos.**

**Resultat final:**

Per a MedicApp, `StatefulWidget + setState + Database as Source of Truth` és l'arquitectura correcta. És simple, directa, fàcil d'entendre per a qualsevol desenvolupador Flutter, i no introdueix complexitat innecessària.

Afegir Provider, BLoC o Riverpod seria purament **cargo cult programming** (usar tecnologia perquè és popular, no perquè resolgui un problema real).

---

## Conclusió

MedicApp utilitza un stack tecnològic **simple, robust i apropiat** per a una aplicació mèdica local multiplataforma:

- **Flutter + Dart:** Multiplataforma amb rendiment natiu.
- **SQLite:** Base de dades relacional madura amb transaccions ACID.
- **Notificacions locals:** Privacitat total i funcionament offline.
- **Localització ARB:** 8 idiomes amb pluralització Unicode CLDR.
- **Vanilla Flutter:** Sense gestió d'estat innecessària.
- **432+ tests:** Cobertura del 75-80% amb tests unitaris, de widget i integració.

Cada decisió tecnològica està **justificada per requisits reals**, no per hype o tendències. El resultat és una aplicació mantenible, fiable i que fa exactament el que promet sense complexitat artificial.

**Principi rector:** *"Simplicitat quan és possible, complexitat quan és necessari."*
