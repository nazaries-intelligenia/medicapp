# Guía de Solución de Problemas

## Introducción

### Propósito del Documento

Esta guía proporciona soluciones a problemas comunes que pueden surgir durante el desarrollo, compilación y uso de MedicApp. Está diseñada para ayudar a desarrolladores y usuarios a resolver problemas de manera rápida y efectiva.

### Cómo Usar Esta Guía

1. Identifica la categoría de tu problema en el índice
2. Lee la descripción del problema para confirmar que coincide con tu situación
3. Sigue los pasos de solución en orden
4. Si el problema persiste, consulta la sección "Obtener Ayuda"

---

## Problemas de Instalación

### Flutter SDK No Encontrado

**Descripción**: Al ejecutar comandos de Flutter, aparece el error "flutter: command not found".

**Causa Probable**: Flutter no está instalado o no está en el PATH del sistema.

**Solución**:

1. Verifica si Flutter está instalado:
```bash
which flutter
```

2. Si no está instalado, descarga Flutter desde [flutter.dev](https://flutter.dev)

3. Agrega Flutter al PATH:
```bash
# En ~/.bashrc, ~/.zshrc, o similar
export PATH="$PATH:/path/to/flutter/bin"
```

4. Reinicia tu terminal y verifica:
```bash
flutter --version
```

**Referencias**: [Documentación de instalación de Flutter](https://docs.flutter.dev/get-started/install)

---

### Versión Incorrecta de Flutter

**Descripción**: La versión de Flutter instalada no cumple con los requisitos del proyecto.

**Causa Probable**: MedicApp requiere Flutter 3.24.5 o superior.

**Solución**:

1. Verifica tu versión actual:
```bash
flutter --version
```

2. Actualiza Flutter:
```bash
flutter upgrade
```

3. Si necesitas una versión específica, usa FVM:
```bash
dart pub global activate fvm
fvm install 3.24.5
fvm use 3.24.5
```

4. Verifica la versión después de actualizar:
```bash
flutter --version
```

---

### Problemas con flutter pub get

**Descripción**: Error al descargar dependencias con `flutter pub get`.

**Causa Probable**: Problemas de red, caché corrupta o conflictos de versiones.

**Solución**:

1. Limpia el caché de pub:
```bash
flutter pub cache repair
```

2. Elimina el archivo pubspec.lock:
```bash
rm pubspec.lock
```

3. Intenta nuevamente:
```bash
flutter pub get
```

4. Si persiste, verifica conexión a internet y proxy:
```bash
# Configura proxy si es necesario
export HTTP_PROXY=http://proxy.example.com:8080
export HTTPS_PROXY=http://proxy.example.com:8080
```

---

### Problemas con CocoaPods (iOS)

**Descripción**: Errores relacionados con CocoaPods durante la compilación de iOS.

**Causa Probable**: CocoaPods desactualizado o caché corrupta.

**Solución**:

1. Actualiza CocoaPods:
```bash
sudo gem install cocoapods
```

2. Limpia el caché de pods:
```bash
cd ios
rm -rf Pods Podfile.lock
pod cache clean --all
```

3. Reinstala los pods:
```bash
pod install --repo-update
```

4. Si persiste, actualiza el repositorio de specs:
```bash
pod repo update
```

**Referencias**: [CocoaPods Guides](https://guides.cocoapods.org/using/troubleshooting.html)

---

### Problemas con Gradle (Android)

**Descripción**: Errores de compilación relacionados con Gradle en Android.

**Causa Probable**: Caché de Gradle corrupta o configuración incorrecta.

**Solución**:

1. Limpia el proyecto:
```bash
cd android
./gradlew clean
```

2. Limpia el caché de Gradle:
```bash
./gradlew cleanBuildCache
rm -rf ~/.gradle/caches/
```

3. Sincroniza el proyecto:
```bash
./gradlew --refresh-dependencies
```

4. Invalida caché en Android Studio:
   - File > Invalidate Caches / Restart

---

## Problemas de Compilación

### Errores de Dependencias

**Descripción**: Conflictos entre versiones de paquetes o dependencias faltantes.

**Causa Probable**: Versiones incompatibles en pubspec.yaml o dependencias transitivas en conflicto.

**Solución**:

1. Verifica el archivo pubspec.yaml para restricciones de versión conflictivas

2. Usa el comando de análisis de dependencias:
```bash
flutter pub deps
```

3. Resuelve conflictos especificando versiones compatibles:
```yaml
dependency_overrides:
  conflicting_package: ^1.0.0
```

4. Actualiza todas las dependencias a versiones compatibles:
```bash
flutter pub upgrade --major-versions
```

---

### Conflictos de Versiones

**Descripción**: Dos o más paquetes requieren versiones incompatibles de una dependencia común.

**Causa Probable**: Restricciones de versión muy estrictas en las dependencias.

**Solución**:

1. Identifica el conflicto:
```bash
flutter pub deps | grep "✗"
```

2. Usa `dependency_overrides` temporalmente:
```yaml
dependency_overrides:
  shared_dependency: ^2.0.0
```

3. Reporta el conflicto a los mantenedores de los paquetes

4. Como último recurso, considera alternativas a los paquetes conflictivos

---

### Errores de Generación de l10n

**Descripción**: Fallos al generar archivos de localización.

**Causa Probable**: Errores de sintaxis en archivos .arb o configuración incorrecta.

**Solución**:

1. Verifica la sintaxis de los archivos .arb en `lib/l10n/`:
   - Asegúrate de que sean JSON válido
   - Verifica que los placeholders sean consistentes

2. Limpia y regenera:
```bash
flutter clean
flutter pub get
flutter gen-l10n
```

3. Verifica la configuración en pubspec.yaml:
```yaml
flutter:
  generate: true
```

4. Revisa `l10n.yaml` para configuración correcta

**Referencias**: [Internacionalización en Flutter](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)

---

### Build Fallido en Android

**Descripción**: La compilación de Android falla con diversos errores.

**Causa Probable**: Configuración de Gradle, versión de SDK o problemas de permisos.

**Solución**:

1. Verifica la versión de Java (requiere Java 17):
```bash
java -version
```

2. Limpia el proyecto completamente:
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
```

3. Verifica las configuraciones en `android/app/build.gradle`:
   - `compileSdkVersion`: 34
   - `minSdkVersion`: 23
   - `targetSdkVersion`: 34

4. Compila con información detallada:
```bash
flutter build apk --verbose
```

5. Si el error menciona permisos, verifica `android/app/src/main/AndroidManifest.xml`

---

### Build Fallido en iOS

**Descripción**: La compilación de iOS falla o no puede firmar la app.

**Causa Probable**: Certificados, perfiles de aprovisionamiento o configuración de Xcode.

**Solución**:

1. Abre el proyecto en Xcode:
```bash
open ios/Runner.xcworkspace
```

2. Verifica la configuración de firma:
   - Selecciona el proyecto Runner
   - En "Signing & Capabilities", verifica el Team y Bundle Identifier

3. Limpia el build de Xcode:
   - Product > Clean Build Folder (Shift + Cmd + K)

4. Actualiza los pods:
```bash
cd ios
pod deintegrate
pod install
cd ..
```

5. Compila desde la terminal:
```bash
flutter build ios --verbose
```

---

## Problemas con Base de Datos

### Database is Locked

**Descripción**: Error "database is locked" al intentar operaciones de base de datos.

**Causa Probable**: Múltiples conexiones intentando escribir simultáneamente o transacción no cerrada.

**Solución**:

1. Asegúrate de cerrar todas las conexiones correctamente en el código

2. Verifica que no haya transacciones abiertas sin commit/rollback

3. Reinicia la aplicación completamente

4. Como último recurso, elimina la base de datos:
```bash
# Android
adb shell run-as com.medicapp.app rm -r /data/data/com.medicapp.app/databases/

# iOS - desde Xcode, elimina el contenedor de la app
```

**Referencias**: Revisa `lib/core/database/database_helper.dart` para el manejo de transacciones.

---

### Errores de Migración

**Descripción**: Fallos al actualizar el esquema de la base de datos.

**Causa Probable**: Script de migración incorrecto o versión de base de datos inconsistente.

**Solución**:

1. Revisa los scripts de migración en `DatabaseHelper`

2. Verifica la versión actual de la base de datos:
```dart
import 'package:medicapp/services/logger_service.dart';

final db = await DatabaseHelper.instance.database;
LoggerService.info('Database version: ${await db.getVersion()}');
```

3. Si es desarrollo, resetea la base de datos:
   - Desinstala la app
   - Reinstala

4. Para producción, crea un script de migración que maneje el caso específico

5. Usa la pantalla de depuración de la app para verificar el estado de la BD

---

### Datos No Persisten

**Descripción**: Los datos ingresados desaparecen después de cerrar la app.

**Causa Probable**: Operaciones de base de datos no se completan o fallan silenciosamente.

**Solución**:

1. Habilita logs de base de datos en modo debug

2. Verifica que las operaciones de insert/update retornen éxito:
```dart
import 'package:medicapp/services/logger_service.dart';

final id = await db.insert('medications', medication.toMap());
LoggerService.info('Inserted medication with id: $id');
```

3. Asegúrate de que no haya excepciones silenciosas

4. Verifica permisos de escritura en el dispositivo

5. Revisa que `await` esté presente en todas las operaciones async

---

### Corrupción de Base de Datos

**Descripción**: Errores al abrir la base de datos o datos inconsistentes.

**Causa Probable**: Cierre inesperado de la app durante escritura o problema del sistema de archivos.

**Solución**:

1. Intenta reparar la base de datos usando el comando sqlite3 (requiere acceso root):
```bash
sqlite3 /path/to/database.db "PRAGMA integrity_check;"
```

2. Si está corrupta, restaura desde backup si existe

3. Si no hay backup, resetea la base de datos:
   - Desinstala la app
   - Reinstala
   - Los datos se perderán

4. **Prevención**: Implementa backups automáticos periódicos

---

### Cómo Resetear Base de Datos

**Descripción**: Necesitas eliminar completamente la base de datos para empezar de cero.

**Causa Probable**: Desarrollo, testing o resolución de problemas.

**Solución**:

**Opción 1 - Desde la App (Development)**:
```dart
// En la pantalla de depuración
await DatabaseHelper.instance.deleteDatabase();
```

**Opción 2 - Android**:
```bash
adb shell run-as com.medicapp.app rm /data/data/com.medicapp.app/databases/medicapp.db
```

**Opción 3 - iOS**:
- Desinstala la app desde el dispositivo/simulador
- Reinstala

**Opción 4 - Ambas plataformas**:
```bash
flutter clean
# Desinstala manualmente desde el dispositivo
flutter run
```

---

## Problemas con Notificaciones

### Notificaciones No Aparecen

**Descripción**: Las notificaciones programadas no se muestran.

**Causa Probable**: Permisos no otorgados, notificaciones deshabilitadas o error en la programación.

**Solución**:

1. Verifica permisos de notificaciones:
   - Android 13+: Debe solicitar `POST_NOTIFICATIONS`
   - iOS: Debe solicitar autorización en primer inicio

2. Comprueba configuración del dispositivo:
   - Android: Configuración > Apps > MedicApp > Notificaciones
   - iOS: Configuración > Notificaciones > MedicApp

3. Verifica que las notificaciones estén programadas:
```dart
import 'package:medicapp/services/logger_service.dart';

final pendingNotifications = await flutterLocalNotificationsPlugin
    .pendingNotificationRequests();
LoggerService.info('Pending notifications: ${pendingNotifications.length}');
```

4. Revisa los logs para errores de programación

5. Usa la pantalla de depuración de la app para ver notificaciones programadas

---

### Permisos Denegados (Android 13+)

**Descripción**: En Android 13+, las notificaciones no funcionan aunque la app las solicite.

**Causa Probable**: El permiso `POST_NOTIFICATIONS` fue denegado por el usuario.

**Solución**:

1. Verifica que el permiso esté declarado en `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

2. La app debe solicitar el permiso en tiempo de ejecución

3. Si el usuario lo denegó, guíalo a configuración:
```dart
await openAppSettings();
```

4. Explica al usuario por qué las notificaciones son esenciales para la app

5. No asumas que el permiso está otorgado; siempre verifica antes de programar

---

### Alarmas Exactas No Funcionan

**Descripción**: Las notificaciones no aparecen en el momento exacto programado.

**Causa Probable**: Falta permiso `SCHEDULE_EXACT_ALARM` o restricciones de batería.

**Solución**:

1. Verifica permisos en `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
```

2. Para Android 12+, solicita el permiso:
```dart
if (await Permission.scheduleExactAlarm.isDenied) {
  await Permission.scheduleExactAlarm.request();
}
```

3. Desactiva optimización de batería para la app:
   - Configuración > Batería > Optimización de batería
   - Busca MedicApp y selecciona "No optimizar"

4. Verifica que uses `androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle`

---

### Notificaciones No Suenan

**Descripción**: Las notificaciones aparecen pero sin sonido.

**Causa Probable**: Canal de notificación sin sonido o modo silencioso del dispositivo.

**Solución**:

1. Verifica la configuración del canal de notificación:
```dart
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'medication_reminders',
  'Recordatorios de Medicamentos',
  importance: Importance.high,
  sound: RawResourceAndroidNotificationSound('notification_sound'),
);
```

2. Asegúrate de que el archivo de sonido existe en `android/app/src/main/res/raw/`

3. Verifica configuración del dispositivo:
   - Android: Configuración > Apps > MedicApp > Notificaciones > Categoría
   - iOS: Configuración > Notificaciones > MedicApp > Sonidos

4. Comprueba que el dispositivo no esté en modo silencioso/no molestar

---

### Notificaciones Después de Reiniciar Dispositivo

**Descripción**: Las notificaciones dejan de funcionar después de reiniciar el dispositivo.

**Causa Probable**: Las notificaciones programadas no persisten tras el reinicio.

**Solución**:

1. Agrega el permiso `RECEIVE_BOOT_COMPLETED` en `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

2. Implementa un `BroadcastReceiver` para reprogramar notificaciones:
```xml
<receiver android:name=".BootReceiver" android:enabled="true" android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
    </intent-filter>
</receiver>
```

3. Implementa la lógica para reprogramar todas las notificaciones pendientes

4. En iOS, las notificaciones locales persisten automáticamente

**Referencias**: Revisa `android/app/src/main/kotlin/.../MainActivity.kt`

---

## Problemas de Rendimiento

### App Lenta en Modo Debug

**Descripción**: La aplicación tiene rendimiento pobre y es lenta.

**Causa Probable**: El modo debug incluye herramientas de desarrollo que afectan el rendimiento.

**Solución**:

1. **Esto es normal en modo debug**. Para evaluar el rendimiento real, compila en modo profile o release:
```bash
flutter run --profile
# o
flutter run --release
```

2. Usa Flutter DevTools para identificar cuellos de botella:
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

3. Verifica que no haya `LoggerService` statements excesivos en hot paths

4. Nunca evalúes el rendimiento en modo debug

---

### Consumo Excesivo de Batería

**Descripción**: La aplicación consume mucha batería.

**Causa Probable**: Uso excesivo de notificaciones, background tasks o consultas frecuentes.

**Solución**:

1. Reduce la frecuencia de verificaciones en background

2. Optimiza las consultas a la base de datos:
   - Usa índices apropiados
   - Evita consultas innecesarias
   - Cachea resultados cuando sea posible

3. Usa `WorkManager` en lugar de alarmas frecuentes cuando sea apropiado

4. Revisa el uso de sensores o GPS (si aplica)

5. Perfila el uso de batería con Android Studio:
   - View > Tool Windows > Energy Profiler

---

### Lag en Listas Largas

**Descripción**: El scroll en listas con muchos elementos es lento o entrecortado.

**Causa Probable**: Renderizado ineficiente de widgets o falta de optimización de ListView.

**Solución**:

1. Usa `ListView.builder` en lugar de `ListView`:
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

2. Implementa `const` constructors donde sea posible

3. Evita widgets pesados en cada item de la lista

4. Usa `RepaintBoundary` para widgets complejos:
```dart
RepaintBoundary(
  child: ComplexWidget(),
)
```

5. Considera paginación para listas muy largas

6. Usa `AutomaticKeepAliveClientMixin` para mantener estado de items

---

### Frames Saltados

**Descripción**: La UI se siente entrecortada con frames perdidos.

**Causa Probable**: Operaciones costosas en el thread principal.

**Solución**:

1. Identifica el problema con Flutter DevTools Performance tab

2. Mueve operaciones costosas a isolates:
```dart
final result = await compute(expensiveFunction, data);
```

3. Evita operaciones sincrónicas pesadas en el build method

4. Usa `FutureBuilder` o `StreamBuilder` para operaciones async

5. Optimiza imágenes grandes:
   - Usa formatos comprimidos
   - Cachea imágenes decodificadas
   - Usa thumbnails para vistas previas

6. Revisa que no haya animaciones con listeners costosos

---

## Problemas de UI/UX

### Texto No Se Traduce

**Descripción**: Algunos textos aparecen en inglés u otro idioma incorrecto.

**Causa Probable**: Falta la cadena en el archivo .arb o no se usa AppLocalizations.

**Solución**:

1. Verifica que la cadena existe en `lib/l10n/app_es.arb`:
```json
{
  "yourKey": "Tu texto traducido"
}
```

2. Asegúrate de usar `AppLocalizations.of(context)`:
```dart
Text(AppLocalizations.of(context)!.yourKey)
```

3. Regenera los archivos de localización:
```bash
flutter gen-l10n
```

4. Si agregaste una nueva clave, asegúrate de que exista en todos los archivos .arb

5. Verifica que el locale del dispositivo esté configurado correctamente

---

### Colores Incorrectos

**Descripción**: Los colores no coinciden con el diseño o tema esperado.

**Causa Probable**: Uso incorrecto del tema o hardcoded colors.

**Solución**:

1. Usa siempre los colores del tema:
```dart
// Correcto
color: Theme.of(context).colorScheme.primary

// Incorrecto
color: Colors.blue
```

2. Verifica la definición del tema en `lib/core/theme/app_theme.dart`

3. Asegúrate de que el MaterialApp tenga el tema configurado:
```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  // ...
)
```

4. Para debug, imprime los colores actuales:
```dart
import 'package:medicapp/services/logger_service.dart';

LoggerService.debug('Primary: ${Theme.of(context).colorScheme.primary}');
```

---

### Layout Roto en Pantallas Pequeñas

**Descripción**: La UI se desborda o se ve mal en dispositivos con pantallas pequeñas.

**Causa Probable**: Widgets con tamaños fijos o falta de responsive design.

**Solución**:

1. Usa widgets flexibles en lugar de tamaños fijos:
```dart
// En lugar de
Container(width: 300, child: ...)

// Usa
Expanded(child: ...)
// o
Flexible(child: ...)
```

2. Usa `LayoutBuilder` para layouts adaptativos:
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

3. Usa `MediaQuery` para obtener dimensiones:
```dart
final screenWidth = MediaQuery.of(context).size.width;
```

4. Prueba en diferentes tamaños de pantalla usando el emulador

---

### Overflow de Texto

**Descripción**: Aparece el warning de "overflow" con franjas amarillas y negras.

**Causa Probable**: Texto demasiado largo para el espacio disponible.

**Solución**:

1. Envuelve el texto en `Flexible` o `Expanded`:
```dart
Flexible(
  child: Text('Texto largo...'),
)
```

2. Usa `overflow` y `maxLines` en el Text widget:
```dart
Text(
  'Texto largo...',
  overflow: TextOverflow.ellipsis,
  maxLines: 2,
)
```

3. Para textos muy largos, usa `SingleChildScrollView`:
```dart
SingleChildScrollView(
  child: Text('Texto muy largo...'),
)
```

4. Considera acortar el texto o usar un formato diferente

---

## Problemas Multi-Persona

### Stock No Se Comparte Correctamente

**Descripción**: Múltiples personas pueden crear medicamentos con el mismo nombre sin compartir stock.

**Causa Probable**: Lógica de verificación de duplicados por persona en lugar de global.

**Solución**:

1. Verifica la función de búsqueda de medicamentos existentes en `MedicationRepository`

2. Asegúrate de que la búsqueda sea global:
```dart
// Buscar por nombre sin filtrar por personId
final existing = await db.query(
  'medications',
  where: 'name = ?',
  whereArgs: [name],
);
```

3. Al agregar una dosis, asocia la dosis con la persona pero no el medicamento

4. Revisa la lógica en `AddMedicationScreen` para reutilizar medicamentos existentes

---

### Medicamentos Duplicados

**Descripción**: Aparecen medicamentos duplicados en la lista.

**Causa Probable**: Múltiples inserciones del mismo medicamento o falta de validación.

**Solución**:

1. Implementa verificación antes de insertar:
```dart
final existing = await getMedicationByName(name);
if (existing != null) {
  return existing.id;
}
```

2. Usa restricciones UNIQUE en la base de datos:
```sql
CREATE TABLE medications (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  -- ...
);
```

3. Revisa la lógica de creación de medicamentos en el repository

4. Si ya existen duplicados, crea un script de migración para consolidarlos

---

### Historial de Dosis Incorrecto

**Descripción**: El historial muestra dosis de otras personas o falta información.

**Causa Probable**: Filtrado incorrecto por persona o joins mal configurados.

**Solución**:

1. Verifica el query que obtiene el historial:
```dart
final doses = await db.query(
  'dose_history',
  where: 'personId = ?',
  whereArgs: [personId],
  orderBy: 'takenAt DESC',
);
```

2. Asegúrate de que todas las dosis tengan `personId` asociado

3. Revisa la lógica de filtrado en `DoseHistoryScreen`

4. Verifica que los joins entre tablas incluyan la condición de persona

---

### Persona Por Defecto No Cambia

**Descripción**: Al cambiar la persona activa, la UI no se actualiza correctamente.

**Causa Probable**: Estado no se propaga correctamente o falta rebuild.

**Solución**:

1. Verifica que uses un estado global (Provider, Bloc, etc.):
```dart
Provider.of<PersonProvider>(context, listen: true).currentPerson
```

2. Asegúrate de que el cambio de persona dispare `notifyListeners()`:
```dart
void setCurrentPerson(Person person) {
  _currentPerson = person;
  notifyListeners();
}
```

3. Verifica que los widgets relevantes escuchen los cambios

4. Considera usar `Consumer` para rebuilds específicos:
```dart
Consumer<PersonProvider>(
  builder: (context, provider, child) {
    return Text(provider.currentPerson.name);
  },
)
```

---

## Problemas con Ayuno

### Notificación de Ayuno No Aparece

**Descripción**: La notificación ongoing de ayuno no se muestra.

**Causa Probable**: Permisos, configuración del canal o error al crear la notificación.

**Solución**:

1. Verifica que el canal de notificaciones de ayuno esté creado:
```dart
const AndroidNotificationChannel fastingChannel = AndroidNotificationChannel(
  'fasting',
  'Ayuno',
  importance: Importance.low,
  enableVibration: false,
);
```

2. Asegúrate de usar `ongoing: true`:
```dart
const NotificationDetails(
  android: AndroidNotificationDetails(
    'fasting',
    'Ayuno',
    ongoing: true,
    autoCancel: false,
  ),
)
```

3. Verifica permisos de notificaciones

4. Revisa logs para errores al crear la notificación

---

### Cuenta Atrás Incorrecta

**Descripción**: El tiempo restante del ayuno no es correcto o no se actualiza.

**Causa Probable**: Cálculo incorrecto de tiempo o falta de actualización periódica.

**Solución**:

1. Verifica el cálculo de tiempo restante:
```dart
final remaining = endTime.difference(DateTime.now());
```

2. Asegúrate de actualizar la notificación periódicamente:
```dart
Timer.periodic(Duration(minutes: 1), (timer) {
  updateFastingNotification();
});
```

3. Verifica que el `endTime` del ayuno se almacene correctamente

4. Usa la pantalla de depuración para verificar el estado del ayuno actual

---

### Ayuno No Se Cancela Automáticamente

**Descripción**: La notificación de ayuno permanece después de que termina el tiempo.

**Causa Probable**: Falta lógica para cancelar la notificación al completarse.

**Solución**:

1. Implementa verificación cuando el ayuno termina:
```dart
if (DateTime.now().isAfter(fasting.endTime)) {
  await cancelFastingNotification();
  await markFastingAsCompleted(fasting.id);
}
```

2. Verifica cuando la app se abre:
```dart
@override
void initState() {
  super.initState();
  checkActiveFastings();
}
```

3. Programa una alarma para cuando termine el ayuno que cancele la notificación

4. Asegúrate de que la notificación se cancele en `onDidReceiveNotificationResponse`

**Referencias**: Revisa `lib/features/fasting/` para la implementación.

---

## Problemas de Testing

### Tests Fallan Localmente

**Descripción**: Los tests que pasan en CI fallan en tu máquina local.

**Causa Probable**: Diferencias de entorno, dependencias o configuración.

**Solución**:

1. Limpia y reconstruye:
```bash
flutter clean
flutter pub get
```

2. Verifica que las versiones sean las mismas:
```bash
flutter --version
dart --version
```

3. Ejecuta los tests con más información:
```bash
flutter test --verbose
```

4. Asegúrate de que no haya tests que dependan de estado previo

5. Verifica que no haya tests con dependencias de tiempo (usa `fakeAsync`)

---

### Problemas con sqflite_common_ffi

**Descripción**: Tests de base de datos fallan con errores de sqflite.

**Causa Probable**: sqflite no está disponible en tests, necesitas usar sqflite_common_ffi.

**Solución**:

1. Asegúrate de tener la dependencia:
```yaml
dev_dependencies:
  sqflite_common_ffi: ^2.3.0
```

2. Inicializa en el setup de tests:
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

3. Usa bases de datos en memoria para tests:
```dart
final db = await databaseFactoryFfi.openDatabase(
  inMemoryDatabasePath,
);
```

4. Limpia la base de datos después de cada test

---

### Timeouts en Tests

**Descripción**: Los tests fallan por timeout.

**Causa Probable**: Operaciones lentas o deadlocks en tests async.

**Solución**:

1. Aumenta el timeout para tests específicos:
```dart
test('slow test', () async {
  // ...
}, timeout: Timeout(Duration(seconds: 30)));
```

2. Verifica que no haya `await` faltantes

3. Usa `fakeAsync` para tests con delays:
```dart
testWidgets('timer test', (tester) async {
  await tester.runAsync(() async {
    // test code with delays
  });
});
```

4. Mockea operaciones lentas como llamadas de red

5. Revisa que no haya loops infinitos o condiciones de carrera

---

### Tests Inconsistentes

**Descripción**: Los mismos tests a veces pasan y a veces fallan.

**Causa Probable**: Tests con dependencias de tiempo, orden de ejecución o estado compartido.

**Solución**:

1. Evita depender del tiempo real, usa `fakeAsync` o mocks

2. Asegúrate de que cada test sea independiente:
```dart
setUp(() {
  // Setup limpio para cada test
});

tearDown(() {
  // Limpieza después de cada test
});
```

3. No compartas estado mutable entre tests

4. Usa `setUpAll` solo para setup inmutable

5. Ejecuta tests en orden aleatorio para detectar dependencias:
```bash
flutter test --test-randomize-ordering-seed=random
```

---

## Problemas de Permisos

### POST_NOTIFICATIONS (Android 13+)

**Descripción**: Las notificaciones no funcionan en Android 13 o superior.

**Causa Probable**: El permiso POST_NOTIFICATIONS debe solicitarse en runtime.

**Solución**:

1. Declara el permiso en `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

2. Solicita el permiso en runtime:
```dart
if (Platform.isAndroid && await Permission.notification.isDenied) {
  final status = await Permission.notification.request();
  if (status.isDenied) {
    // Informar al usuario y ofrecer ir a configuración
  }
}
```

3. Verifica el permiso antes de programar notificaciones

4. Guía al usuario a configuración si fue denegado permanentemente

**Referencias**: [Android 13 Notification Permission](https://developer.android.com/about/versions/13/changes/notification-permission)

---

### SCHEDULE_EXACT_ALARM (Android 12+)

**Descripción**: Las alarmas exactas no funcionan en Android 12+.

**Causa Probable**: Requiere permiso especial desde Android 12.

**Solución**:

1. Declara el permiso:
```xml
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
```

2. Verifica y solicita si es necesario:
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

3. Explica al usuario por qué necesitas alarmas exactas

4. Considera usar `USE_EXACT_ALARM` si eres una app de alarma/recordatorio

---

### USE_EXACT_ALARM (Android 14+)

**Descripción**: Necesitas alarmas exactas sin solicitar permiso especial.

**Causa Probable**: Android 14 introduce USE_EXACT_ALARM para apps de alarma.

**Solución**:

1. Si tu app es principalmente de alarmas/recordatorios, usa:
```xml
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
```

2. Esta es una alternativa a `SCHEDULE_EXACT_ALARM` que no requiere que el usuario otorgue el permiso manualmente

3. Solo úsala si tu app cumple con los [casos de uso permitidos](https://developer.android.com/about/versions/14/changes/schedule-exact-alarms)

4. La app debe tener como funcionalidad principal alarmas o recordatorios

---

### Notificaciones en Background (iOS)

**Descripción**: Las notificaciones no funcionan correctamente en iOS.

**Causa Probable**: Permisos no solicitados o configuración incorrecta.

**Solución**:

1. Solicita permisos al iniciar la app:
```dart
final settings = await FirebaseMessaging.instance.requestPermission(
  alert: true,
  badge: true,
  sound: true,
);
```

2. Verifica `Info.plist`:
```xml
<key>UIBackgroundModes</key>
<array>
  <string>fetch</string>
  <string>remote-notification</string>
</array>
```

3. Asegúrate de tener los capabilities correctos en Xcode:
   - Push Notifications
   - Background Modes

4. Verifica que el usuario no haya deshabilitado notificaciones en Configuración

---

## Errores Comunes y Soluciones

### MissingPluginException

**Descripción**: Error "MissingPluginException(No implementation found for method...)"

**Causa Probable**: El plugin no está registrado correctamente o necesitas hot restart.

**Solución**:

1. Haz un hot restart completo (no solo hot reload):
```bash
# En el terminal donde corre la app
r  # hot reload
R  # HOT RESTART (este es el que necesitas)
```

2. Si persiste, reconstruye completamente:
```bash
flutter clean
flutter pub get
flutter run
```

3. Verifica que el plugin esté en `pubspec.yaml`

4. Para iOS, reinstala los pods:
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
```

---

### PlatformException

**Descripción**: Error "PlatformException" con diferentes códigos.

**Causa Probable**: Depende del código específico del error.

**Solución**:

1. Lee el mensaje de error y código completos

2. Errores comunes:
   - `permission_denied`: Verifica permisos
   - `error`: Error genérico, revisa logs nativos
   - `not_available`: Función no disponible en esta plataforma

3. Para Android, revisa logcat:
```bash
adb logcat | grep -i flutter
```

4. Para iOS, revisa la consola de Xcode

5. Asegúrate de manejar estos errores gracefully:
```dart
import 'package:medicapp/services/logger_service.dart';

try {
  await somePluginMethod();
} on PlatformException catch (e) {
  LoggerService.error('Error: ${e.code} - ${e.message}');
  // Manejar apropiadamente
}
```

---

### DatabaseException

**Descripción**: Error al realizar operaciones de base de datos.

**Causa Probable**: Query inválido, restricción violada o base de datos corrupta.

**Solución**:

1. Lee el mensaje de error completo para identificar el problema

2. Errores comunes:
   - `UNIQUE constraint failed`: Intentando insertar duplicado
   - `no such table`: Tabla no existe, revisa migraciones
   - `syntax error`: Query SQL inválido

3. Verifica el query SQL:
```dart
import 'package:medicapp/services/logger_service.dart';

try {
  await db.query('medications', where: 'id = ?', whereArgs: [id]);
} on DatabaseException catch (e) {
  LoggerService.error('Database error: ${e.toString()}');
}
```

4. Asegúrate de que las migraciones se hayan ejecutado

5. Como último recurso, resetea la base de datos

---

### StateError

**Descripción**: Error "Bad state: No element" o similar.

**Causa Probable**: Intentando acceder a un elemento que no existe.

**Solución**:

1. Identifica la línea exacta del error en el stack trace

2. Usa métodos seguros:
```dart
// En lugar de
final item = list.first;  // Lanza StateError si está vacía

// Usa
final item = list.isNotEmpty ? list.first : null;
// o
final item = list.firstOrNull;  // Dart 3.0+
```

3. Siempre verifica antes de acceder:
```dart
if (list.isNotEmpty) {
  final item = list.first;
  // usar item
}
```

4. Usa try-catch si es necesario:
```dart
try {
  final item = list.single;
} on StateError {
  // Manejar caso donde no hay exactamente un elemento
}
```

---

### Null Check Operator Used on Null Value

**Descripción**: Error al usar el operador `!` en un valor null.

**Causa Probable**: Variable nullable usada con `!` cuando su valor es null.

**Solución**:

1. Identifica la línea exacta en el stack trace

2. Verifica el valor antes de usar `!`:
```dart
// En lugar de
final value = nullableValue!;

// Usa
if (nullableValue != null) {
  final value = nullableValue;
  // usar value
}
```

3. Usa operador `??` para valores por defecto:
```dart
final value = nullableValue ?? defaultValue;
```

4. Usa operador `?.` para acceso seguro:
```dart
final length = nullableString?.length;
```

5. Revisa por qué el valor es null cuando no debería serlo

---

## Logs y Depuración

### Cómo Habilitar Logs

**Nota**: MedicApp utiliza `LoggerService` en lugar de `print()` para registrar eventos. Se recomienda utilizar LoggerService.info(), LoggerService.error(), LoggerService.debug() y otros métodos en lugar de print() para mantener consistencia con el sistema de logging centralizado.

**Descripción**: Necesitas ver logs detallados para depurar un problema.

**Solución**:

1. **Logs de Flutter**:
```bash
flutter run --verbose
```

2. **Logs solo de la app** (alternativa: usar LoggerService):
```dart
import 'package:medicapp/services/logger_service.dart';

// LoggerService proporciona una forma centralizada de logging
// Usa LoggerService.info(), LoggerService.error(), LoggerService.debug(), etc.

void main() {
  LoggerService.info('MedicApp iniciando');
  runApp(MyApp());
}
```

3. **Logs nativos Android**:
```bash
adb logcat | grep -i flutter
# o para ver todo
adb logcat
```

4. **Logs nativos iOS**:
   - Abre Console.app en macOS
   - Selecciona tu dispositivo/simulador
   - Filtra por "flutter" o tu bundle identifier

---

### Logs de Notificaciones

**Descripción**: Necesitas ver logs relacionados con notificaciones.

**Solución**:

1. Agrega logs en el código de notificaciones:
```dart
import 'package:medicapp/services/logger_service.dart';

LoggerService.info('Scheduling notification at: $scheduledTime');
await flutterLocalNotificationsPlugin.zonedSchedule(
  id,
  title,
  body,
  scheduledTime,
  notificationDetails,
);
LoggerService.info('Notification scheduled successfully');
```

2. Lista notificaciones pendientes:
```dart
import 'package:medicapp/services/logger_service.dart';

final pending = await flutterLocalNotificationsPlugin
    .pendingNotificationRequests();
for (var notification in pending) {
  LoggerService.info('Pending: ${notification.id} - ${notification.title}');
}
```

3. Verifica logs del sistema:
   - Android: `adb logcat | grep -i notification`
   - iOS: Console.app con filtro "notification"

---

### Logs de Base de Datos

**Descripción**: Necesitas ver las queries de base de datos ejecutadas.

**Solución**:

1. Habilita logging en sqflite:
```dart
import 'package:sqflite/sqflite.dart';

void main() {
  Sqflite.setDebugModeOn(true);
  runApp(MyApp());
}
```

2. Agrega logs en tus queries:
```dart
import 'package:medicapp/services/logger_service.dart';

LoggerService.debug('Executing query: SELECT * FROM medications WHERE id = $id');
final result = await db.query('medications', where: 'id = ?', whereArgs: [id]);
LoggerService.debug('Query returned ${result.length} rows');
```

3. Wrapper para logging automático:
```dart
import 'package:medicapp/services/logger_service.dart';
import 'package:sqflite/sqflite.dart';

class LoggedDatabase {
  final Database db;
  LoggedDatabase(this.db);

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    LoggerService.debug('Query: $table WHERE $where ARGS $whereArgs');
    final result = await db.query(table, where: where, whereArgs: whereArgs);
    LoggerService.debug('Result: ${result.length} rows');
    return result;
  }
}
```

---

### Usar Debugger

**Descripción**: Necesitas pausar la ejecución y examinar el estado.

**Solución**:

1. **En VS Code**:
   - Coloca un breakpoint clickeando al lado del número de línea
   - Ejecuta en modo debug (F5)
   - Cuando pause, usa los controles de debug

2. **En Android Studio**:
   - Coloca un breakpoint clickeando en el margen
   - Ejecuta Debug (Shift + F9)
   - Usa Debug panel para step over/into/out

3. **Debugger programático**:
```dart
import 'dart:developer';

void someFunction() {
  debugger();  // Pausa aquí si hay debugger conectado
  // código...
}
```

4. **Inspect variables**:
```dart
import 'package:medicapp/services/logger_service.dart';

LoggerService.debug('Value: $value');  // Logging centralizado con LoggerService
debugPrint('Value: $value');  // Logging que respeta rate limits
```

---

### Pantalla de Depuración de la App

**Descripción**: MedicApp incluye una pantalla de depuración útil.

**Solución**:

1. Accede a la pantalla de depuración desde el menú de configuración

2. Funciones disponibles:
   - Ver base de datos (tablas, filas, contenido)
   - Ver notificaciones programadas
   - Ver estado del sistema
   - Forzar actualización de notificaciones
   - Limpiar base de datos
   - Ver logs recientes

3. Usa esta pantalla para:
   - Verificar que los datos se guarden correctamente
   - Comprobar notificaciones pendientes
   - Identificar problemas de estado

4. Solo disponible en modo debug

---

## Resetear la Aplicación

### Limpiar Datos de App

**Descripción**: Necesitas eliminar todos los datos sin desinstalar.

**Solución**:

**Android**:
```bash
adb shell pm clear com.medicapp.app
```

**iOS**:
- Configuración > General > iPhone Storage
- Busca MedicApp
- "Borrar App" (no "Descargar App")

**Desde la app** (solo debug):
- Usa la pantalla de depuración
- "Reset Database"

---

### Desinstalar y Reinstalar

**Descripción**: Instalación limpia completa.

**Solución**:

**Android**:
```bash
adb uninstall com.medicapp.app
flutter run
```

**iOS**:
```bash
# Desde el dispositivo/simulador, mantén presionado el ícono
# Selecciona "Eliminar App"
flutter run
```

**Desde Flutter**:
```bash
flutter clean
rm -rf build/
flutter run
```

---

### Resetear Base de Datos

**Descripción**: Eliminar solo la base de datos manteniendo la app.

**Solución**:

**Desde código** (solo debug):
```dart
await DatabaseHelper.instance.deleteDatabase();
```

**Android - Manualmente**:
```bash
adb shell
run-as com.medicapp.app
cd databases
rm medicapp.db medicapp.db-shm medicapp.db-wal
exit
```

**iOS - Manualmente**:
- Necesitas acceso al contenedor de la app
- Es más fácil desinstalar y reinstalar

---

### Limpiar Caché de Flutter

**Descripción**: Resolver problemas de compilación relacionados con caché.

**Solución**:

1. Limpieza básica:
```bash
flutter clean
```

2. Limpieza completa:
```bash
flutter clean
rm -rf build/
rm -rf .dart_tool/
rm pubspec.lock
flutter pub get
```

3. Limpiar caché de pub:
```bash
flutter pub cache repair
```

4. Limpiar caché de Gradle (Android):
```bash
cd android
./gradlew clean cleanBuildCache
rm -rf ~/.gradle/caches/
cd ..
```

5. Limpiar caché de pods (iOS):
```bash
cd ios
rm -rf Pods Podfile.lock
pod cache clean --all
pod install
cd ..
```

---

## Problemas Conocidos

### Lista de Bugs Conocidos

1. **Notificaciones no persisten después de reinicio en algunos dispositivos Android**
   - Afecta: Android 12+ con optimización agresiva de batería
   - Workaround: Desactivar optimización de batería para MedicApp

2. **Layout overflow en pantallas muy pequeñas (<5")**
   - Afecta: Dispositivos con ancho < 320dp
   - Status: Fix planificado para v1.1.0

3. **Animación de transición entrecortada en dispositivos low-end**
   - Afecta: Dispositivos con <2GB RAM
   - Workaround: Desactivar animaciones en configuración

4. **Base de datos puede crecer indefinidamente**
   - Afecta: Usuarios con mucho historial (>1 año)
   - Workaround: Implementar limpieza periódica de historial antiguo
   - Status: Feature de archivo automático planificado

---

### Workarounds Temporales

1. **Si las notificaciones no suenan en algunos dispositivos**:
```dart
// Usa máxima importancia temporalmente
importance: Importance.max,
priority: Priority.high,
```

2. **Si hay lag en listas largas**:
   - Limita el historial visible a últimos 30 días
   - Implementa paginación manual

3. **Si la base de datos se bloquea frecuentemente**:
   - Reduce operaciones concurrentes
   - Usa transacciones batch para múltiples inserts

---

### Issues en GitHub

**Cómo buscar issues existentes**:

1. Ve a: https://github.com/tu-usuario/medicapp/issues

2. Usa los filtros:
   - `is:issue is:open` - Issues abiertos
   - `label:bug` - Solo bugs
   - `label:enhancement` - Features solicitados

3. Busca por palabras clave: "notification", "database", etc.

**Antes de crear un nuevo issue**:
- Busca si ya existe uno similar
- Verifica la lista de problemas conocidos arriba
- Asegúrate de que no esté resuelto en la última versión

---

## Obtener Ayuda

### Revisar Documentación

**Recursos disponibles**:

1. **Documentación del proyecto**:
   - `README.md` - Información general y setup
   - `docs/es/ARCHITECTURE.md` - Arquitectura del proyecto
   - `docs/es/CONTRIBUTING.md` - Guía de contribución
   - `docs/es/TESTING.md` - Guía de testing

2. **Documentación de Flutter**:
   - [flutter.dev/docs](https://flutter.dev/docs)
   - [api.flutter.dev](https://api.flutter.dev)

3. **Documentación de paquetes**:
   - Revisa pub.dev para cada dependencia
   - Lee el README y changelog de cada paquete

---

### Buscar en GitHub Issues

**Cómo buscar efectivamente**:

1. Usa búsqueda avanzada:
```
repo:tu-usuario/medicapp is:issue [palabras clave]
```

2. Busca issues cerrados también:
```
is:issue is:closed notification not working
```

3. Busca por labels:
```
label:bug label:android label:notifications
```

4. Busca en comentarios:
```
commenter:username [palabras clave]
```

---

### Crear Nuevo Issue con Template

**Antes de crear un issue**:

1. Confirma que es realmente un bug o feature request válido
2. Busca issues duplicados
3. Recopila toda la información necesaria

**Información necesaria**:

**Para bugs**:
- Descripción clara del problema
- Pasos para reproducir
- Comportamiento esperado vs actual
- Screenshots/videos si aplica
- Información del entorno (ver abajo)
- Logs relevantes

**Para features**:
- Descripción de la funcionalidad
- Caso de uso y beneficios
- Propuesta de implementación (opcional)
- Mockups o ejemplos (opcional)

**Plantilla de issue**:
```markdown
## Descripción
[Descripción clara y concisa del problema]

## Pasos para Reproducir
1. [Primer paso]
2. [Segundo paso]
3. [Tercer paso]

## Comportamiento Esperado
[Qué debería suceder]

## Comportamiento Actual
[Qué sucede realmente]

## Información del Entorno
- SO: [Android 13 / iOS 16.5]
- Dispositivo: [Modelo específico]
- Versión de MedicApp: [v1.0.0]
- Versión de Flutter: [3.24.5]

## Logs
```
[Logs relevantes]
```

## Screenshots
[Si aplica]

## Información Adicional
[Cualquier otro contexto]
```

---

### Información Necesaria para Reportar

**Siempre incluye**:

1. **Versión de la app**:
```dart
// Desde pubspec.yaml
version: 1.0.0+1
```

2. **Información del dispositivo**:
```dart
import 'package:device_info_plus/device_info_plus.dart';
import 'package:medicapp/services/logger_service.dart';

final deviceInfo = DeviceInfoPlugin();
if (Platform.isAndroid) {
  final androidInfo = await deviceInfo.androidInfo;
  LoggerService.info('Android ${androidInfo.version.sdkInt}');
  LoggerService.info('Model: ${androidInfo.model}');
}
```

3. **Versión de Flutter**:
```bash
flutter --version
```

4. **Logs completos**:
```bash
flutter run --verbose > logs.txt 2>&1
# Adjunta logs.txt al issue
```

5. **Stack trace completo** si hay crash

6. **Screenshots o videos** mostrando el problema

---

## Conclusión

Esta guía cubre los problemas más comunes en MedicApp. Si encuentras un problema no listado aquí:

1. Revisa la documentación completa del proyecto
2. Busca en GitHub Issues
3. Pregunta en las discusiones del repositorio
4. Crea un nuevo issue con toda la información necesaria

**Recuerda**: Proporcionar información detallada y pasos para reproducir hace que sea mucho más fácil resolver tu problema rápidamente.

Para contribuir mejoras a esta guía, por favor abre un PR o issue en el repositorio.

---

**Última actualización**: 2025-11-14
**Versión del documento**: 1.0.0
