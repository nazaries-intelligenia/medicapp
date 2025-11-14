# Guía de Solución de Problemas

## Introdución

### Propósito do Documento

Esta guía proporciona solucións a problemas comúns que poden xurdir durante o desenvolvemento, compilación e uso de MedicApp. Está deseñada para axudar a desenvolvedores e usuarios a resolver problemas de maneira rápida e efectiva.

### Como Usar Esta Guía

1. Identifica a categoría do teu problema no índice
2. Le a descrición do problema para confirmar que coincide coa túa situación
3. Segue os pasos de solución en orde
4. Se o problema persiste, consulta a sección "Obter Axuda"

---

## Problemas de Instalación

### Flutter SDK Non Atopado

**Descrición**: Ao executar comandos de Flutter, aparece o erro "flutter: command not found".

**Causa Probable**: Flutter non está instalado ou non está no PATH do sistema.

**Solución**:

1. Verifica se Flutter está instalado:
```bash
which flutter
```

2. Se non está instalado, descarga Flutter desde [flutter.dev](https://flutter.dev)

3. Engade Flutter ao PATH:
```bash
# En ~/.bashrc, ~/.zshrc, ou similar
export PATH="$PATH:/path/to/flutter/bin"
```

4. Reinicia o teu terminal e verifica:
```bash
flutter --version
```

**Referencias**: [Documentación de instalación de Flutter](https://docs.flutter.dev/get-started/install)

---

### Versión Incorrecta de Flutter

**Descrición**: A versión de Flutter instalada non cumpre cos requisitos do proxecto.

**Causa Probable**: MedicApp require Flutter 3.24.5 ou superior.

**Solución**:

1. Verifica a túa versión actual:
```bash
flutter --version
```

2. Actualiza Flutter:
```bash
flutter upgrade
```

3. Se necesitas unha versión específica, usa FVM:
```bash
dart pub global activate fvm
fvm install 3.24.5
fvm use 3.24.5
```

4. Verifica a versión despois de actualizar:
```bash
flutter --version
```

---

### Problemas con flutter pub get

**Descrición**: Erro ao descargar dependencias con `flutter pub get`.

**Causa Probable**: Problemas de rede, caché corrupta ou conflitos de versións.

**Solución**:

1. Limpa o caché de pub:
```bash
flutter pub cache repair
```

2. Elimina o arquivo pubspec.lock:
```bash
rm pubspec.lock
```

3. Intenta novamente:
```bash
flutter pub get
```

4. Se persiste, verifica conexión a internet e proxy:
```bash
# Configura proxy se é necesario
export HTTP_PROXY=http://proxy.example.com:8080
export HTTPS_PROXY=http://proxy.example.com:8080
```

---

### Problemas con CocoaPods (iOS)

**Descrición**: Erros relacionados con CocoaPods durante a compilación de iOS.

**Causa Probable**: CocoaPods desactualizado ou caché corrupta.

**Solución**:

1. Actualiza CocoaPods:
```bash
sudo gem install cocoapods
```

2. Limpa o caché de pods:
```bash
cd ios
rm -rf Pods Podfile.lock
pod cache clean --all
```

3. Reinstala os pods:
```bash
pod install --repo-update
```

4. Se persiste, actualiza o repositorio de specs:
```bash
pod repo update
```

**Referencias**: [CocoaPods Guides](https://guides.cocoapods.org/using/troubleshooting.html)

---

### Problemas con Gradle (Android)

**Descrición**: Erros de compilación relacionados con Gradle en Android.

**Causa Probable**: Caché de Gradle corrupta ou configuración incorrecta.

**Solución**:

1. Limpa o proxecto:
```bash
cd android
./gradlew clean
```

2. Limpa o caché de Gradle:
```bash
./gradlew cleanBuildCache
rm -rf ~/.gradle/caches/
```

3. Sincroniza o proxecto:
```bash
./gradlew --refresh-dependencies
```

4. Invalida caché en Android Studio:
   - File > Invalidate Caches / Restart

---

## Problemas de Compilación

### Erros de Dependencias

**Descrición**: Conflitos entre versións de paquetes ou dependencias faltantes.

**Causa Probable**: Versións incompatibles en pubspec.yaml ou dependencias transitivas en conflito.

**Solución**:

1. Verifica o arquivo pubspec.yaml para restricións de versión conflictivas

2. Usa o comando de análise de dependencias:
```bash
flutter pub deps
```

3. Resolve conflitos especificando versións compatibles:
```yaml
dependency_overrides:
  conflicting_package: ^1.0.0
```

4. Actualiza todas as dependencias a versións compatibles:
```bash
flutter pub upgrade --major-versions
```

---

### Conflitos de Versións

**Descrición**: Dous ou máis paquetes requiren versións incompatibles dunha dependencia común.

**Causa Probable**: Restricións de versión moi estritas nas dependencias.

**Solución**:

1. Identifica o conflito:
```bash
flutter pub deps | grep "✗"
```

2. Usa `dependency_overrides` temporalmente:
```yaml
dependency_overrides:
  shared_dependency: ^2.0.0
```

3. Reporta o conflito aos mantedores dos paquetes

4. Como último recurso, considera alternativas aos paquetes conflictivos

---

### Erros de Xeración de l10n

**Descrición**: Fallos ao xerar arquivos de localización.

**Causa Probable**: Erros de sintaxe en arquivos .arb ou configuración incorrecta.

**Solución**:

1. Verifica a sintaxe dos arquivos .arb en `lib/l10n/`:
   - Asegúrate de que sexan JSON válido
   - Verifica que os placeholders sexan consistentes

2. Limpa e rexenera:
```bash
flutter clean
flutter pub get
flutter gen-l10n
```

3. Verifica a configuración en pubspec.yaml:
```yaml
flutter:
  generate: true
```

4. Revisa `l10n.yaml` para configuración correcta

**Referencias**: [Internacionalización en Flutter](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)

---

### Build Fallido en Android

**Descrición**: A compilación de Android falla con diversos erros.

**Causa Probable**: Configuración de Gradle, versión de SDK ou problemas de permisos.

**Solución**:

1. Verifica a versión de Java (require Java 17):
```bash
java -version
```

2. Limpa o proxecto completamente:
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
```

3. Verifica as configuracións en `android/app/build.gradle`:
   - `compileSdkVersion`: 34
   - `minSdkVersion`: 23
   - `targetSdkVersion`: 34

4. Compila con información detallada:
```bash
flutter build apk --verbose
```

5. Se o erro menciona permisos, verifica `android/app/src/main/AndroidManifest.xml`

---

### Build Fallido en iOS

**Descrición**: A compilación de iOS falla ou non pode asinar a app.

**Causa Probable**: Certificados, perfís de aprovisionamento ou configuración de Xcode.

**Solución**:

1. Abre o proxecto en Xcode:
```bash
open ios/Runner.xcworkspace
```

2. Verifica a configuración de firma:
   - Selecciona o proxecto Runner
   - En "Signing & Capabilities", verifica o Team e Bundle Identifier

3. Limpa o build de Xcode:
   - Product > Clean Build Folder (Shift + Cmd + K)

4. Actualiza os pods:
```bash
cd ios
pod deintegrate
pod install
cd ..
```

5. Compila desde a terminal:
```bash
flutter build ios --verbose
```

---

## Problemas con Base de Datos

### Database is Locked

**Descrición**: Erro "database is locked" ao intentar operacións de base de datos.

**Causa Probable**: Múltiples conexións intentando escribir simultaneamente ou transacción non pechada.

**Solución**:

1. Asegúrate de pechar todas as conexións correctamente no código

2. Verifica que non haxa transaccións abertas sen commit/rollback

3. Reinicia a aplicación completamente

4. Como último recurso, elimina a base de datos:
```bash
# Android
adb shell run-as com.medicapp.app rm -r /data/data/com.medicapp.app/databases/

# iOS - desde Xcode, elimina o contedor da app
```

**Referencias**: Revisa `lib/core/database/database_helper.dart` para o manexo de transaccións.

---

### Erros de Migración

**Descrición**: Fallos ao actualizar o esquema da base de datos.

**Causa Probable**: Script de migración incorrecto ou versión de base de datos inconsistente.

**Solución**:

1. Revisa os scripts de migración en `DatabaseHelper`

2. Verifica a versión actual da base de datos:
```dart
final db = await DatabaseHelper.instance.database;
print('Database version: ${await db.getVersion()}');
```

3. Se é desenvolvemento, resetea a base de datos:
   - Desinstala a app
   - Reinstala

4. Para produción, crea un script de migración que manexe o caso específico

5. Usa a pantalla de depuración da app para verificar o estado da BD

---

### Datos Non Persisten

**Descrición**: Os datos ingresados desaparecen despois de pechar a app.

**Causa Probable**: Operacións de base de datos non se completan ou fallan silenciosamente.

**Solución**:

1. Habilita logs de base de datos en modo debug

2. Verifica que as operacións de insert/update retornen éxito:
```dart
final id = await db.insert('medications', medication.toMap());
print('Inserted medication with id: $id');
```

3. Asegúrate de que non haxa excepcións silenciosas

4. Verifica permisos de escritura no dispositivo

5. Revisa que `await` estea presente en todas as operacións async

---

### Corrupción de Base de Datos

**Descrición**: Erros ao abrir a base de datos ou datos inconsistentes.

**Causa Probable**: Peche inesperado da app durante escritura ou problema do sistema de arquivos.

**Solución**:

1. Intenta reparar a base de datos usando o comando sqlite3 (require acceso root):
```bash
sqlite3 /path/to/database.db "PRAGMA integrity_check;"
```

2. Se está corrupta, restaura desde backup se existe

3. Se non hai backup, resetea a base de datos:
   - Desinstala a app
   - Reinstala
   - Os datos perderanse

4. **Prevención**: Implementa backups automáticos periódicos

---

### Como Resetear Base de Datos

**Descrición**: Necesitas eliminar completamente a base de datos para empezar de cero.

**Causa Probable**: Desenvolvemento, testing ou resolución de problemas.

**Solución**:

**Opción 1 - Desde a App (Development)**:
```dart
// Na pantalla de depuración
await DatabaseHelper.instance.deleteDatabase();
```

**Opción 2 - Android**:
```bash
adb shell run-as com.medicapp.app rm /data/data/com.medicapp.app/databases/medicapp.db
```

**Opción 3 - iOS**:
- Desinstala a app desde o dispositivo/simulador
- Reinstala

**Opción 4 - Ambas plataformas**:
```bash
flutter clean
# Desinstala manualmente desde o dispositivo
flutter run
```

---

## Problemas con Notificacións

### Notificacións Non Aparecen

**Descrición**: As notificacións programadas non se mostran.

**Causa Probable**: Permisos non outorgados, notificacións deshabilitadas ou erro na programación.

**Solución**:

1. Verifica permisos de notificacións:
   - Android 13+: Debe solicitar `POST_NOTIFICATIONS`
   - iOS: Debe solicitar autorización en primeiro inicio

2. Comproba configuración do dispositivo:
   - Android: Configuración > Apps > MedicApp > Notificacións
   - iOS: Configuración > Notificacións > MedicApp

3. Verifica que as notificacións estean programadas:
```dart
final pendingNotifications = await flutterLocalNotificationsPlugin
    .pendingNotificationRequests();
print('Pending notifications: ${pendingNotifications.length}');
```

4. Revisa os logs para erros de programación

5. Usa a pantalla de depuración da app para ver notificacións programadas

---

### Permisos Denegados (Android 13+)

**Descrición**: En Android 13+, as notificacións non funcionan aínda que a app as solicite.

**Causa Probable**: O permiso `POST_NOTIFICATIONS` foi denegado polo usuario.

**Solución**:

1. Verifica que o permiso estea declarado en `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

2. A app debe solicitar o permiso en tempo de execución

3. Se o usuario o denegou, guíao a configuración:
```dart
await openAppSettings();
```

4. Explica ao usuario por que as notificacións son esenciais para a app

5. Non asumas que o permiso está outorgado; sempre verifica antes de programar

---

### Alarmas Exactas Non Funcionan

**Descrición**: As notificacións non aparecen no momento exacto programado.

**Causa Probable**: Falta permiso `SCHEDULE_EXACT_ALARM` ou restricións de batería.

**Solución**:

1. Verifica permisos en `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
```

2. Para Android 12+, solicita o permiso:
```dart
if (await Permission.scheduleExactAlarm.isDenied) {
  await Permission.scheduleExactAlarm.request();
}
```

3. Desactiva optimización de batería para a app:
   - Configuración > Batería > Optimización de batería
   - Busca MedicApp e selecciona "Non optimizar"

4. Verifica que uses `androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle`

---

### Notificacións Non Soan

**Descrición**: As notificacións aparecen pero sen son.

**Causa Probable**: Canal de notificación sen son ou modo silencioso do dispositivo.

**Solución**:

1. Verifica a configuración do canal de notificación:
```dart
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'medication_reminders',
  'Recordatorios de Medicamentos',
  importance: Importance.high,
  sound: RawResourceAndroidNotificationSound('notification_sound'),
);
```

2. Asegúrate de que o arquivo de son existe en `android/app/src/main/res/raw/`

3. Verifica configuración do dispositivo:
   - Android: Configuración > Apps > MedicApp > Notificacións > Categoría
   - iOS: Configuración > Notificacións > MedicApp > Sons

4. Comproba que o dispositivo non estea en modo silencioso/non molestar

---

### Notificacións Despois de Reiniciar Dispositivo

**Descrición**: As notificacións deixan de funcionar despois de reiniciar o dispositivo.

**Causa Probable**: As notificacións programadas non persisten tras o reinicio.

**Solución**:

1. Engade o permiso `RECEIVE_BOOT_COMPLETED` en `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

2. Implementa un `BroadcastReceiver` para reprogramar notificacións:
```xml
<receiver android:name=".BootReceiver" android:enabled="true" android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
    </intent-filter>
</receiver>
```

3. Implementa a lóxica para reprogramar todas as notificacións pendentes

4. En iOS, as notificacións locais persisten automaticamente

**Referencias**: Revisa `android/app/src/main/kotlin/.../MainActivity.kt`

---

## Problemas de Rendemento

### App Lenta en Modo Debug

**Descrición**: A aplicación ten rendemento pobre e é lenta.

**Causa Probable**: O modo debug inclúe ferramentas de desenvolvemento que afectan o rendemento.

**Solución**:

1. **Isto é normal en modo debug**. Para avaliar o rendemento real, compila en modo profile ou release:
```bash
flutter run --profile
# ou
flutter run --release
```

2. Usa Flutter DevTools para identificar cuellos de botella:
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

3. Verifica que non haxa `print()` statements excesivos en hot paths

4. Nunca avalíes o rendemento en modo debug

---

### Consumo Excesivo de Batería

**Descrición**: A aplicación consome moita batería.

**Causa Probable**: Uso excesivo de notificacións, background tasks ou consultas frecuentes.

**Solución**:

1. Reduce a frecuencia de verificacións en background

2. Optimiza as consultas á base de datos:
   - Usa índices apropiados
   - Evita consultas innecesarias
   - Cachea resultados cando sexa posible

3. Usa `WorkManager` en lugar de alarmas frecuentes cando sexa apropiado

4. Revisa o uso de sensores ou GPS (se aplica)

5. Perfila o uso de batería con Android Studio:
   - View > Tool Windows > Energy Profiler

---

### Lag en Listas Longas

**Descrición**: O scroll en listas con moitos elementos é lento ou entrecortado.

**Causa Probable**: Renderizado ineficiente de widgets ou falta de optimización de ListView.

**Solución**:

1. Usa `ListView.builder` en lugar de `ListView`:
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

2. Implementa `const` constructors onde sexa posible

3. Evita widgets pesados en cada item da lista

4. Usa `RepaintBoundary` para widgets complexos:
```dart
RepaintBoundary(
  child: ComplexWidget(),
)
```

5. Considera paxinación para listas moi longas

6. Usa `AutomaticKeepAliveClientMixin` para manter estado de items

---

### Frames Saltados

**Descrición**: A UI sente entrecortada con frames perdidos.

**Causa Probable**: Operacións custosas no thread principal.

**Solución**:

1. Identifica o problema con Flutter DevTools Performance tab

2. Move operacións custosas a isolates:
```dart
final result = await compute(expensiveFunction, data);
```

3. Evita operacións sincrónicas pesadas no build method

4. Usa `FutureBuilder` ou `StreamBuilder` para operacións async

5. Optimiza imaxes grandes:
   - Usa formatos comprimidos
   - Cachea imaxes decodificadas
   - Usa thumbnails para vistas previas

6. Revisa que non haxa animacións con listeners custosos

---

## Problemas de UI/UX

### Texto Non Se Traduce

**Descrición**: Algúns textos aparecen en inglés ou outro idioma incorrecto.

**Causa Probable**: Falta a cadea no arquivo .arb ou non se usa AppLocalizations.

**Solución**:

1. Verifica que a cadea existe en `lib/l10n/app_es.arb`:
```json
{
  "yourKey": "O teu texto traducido"
}
```

2. Asegúrate de usar `AppLocalizations.of(context)`:
```dart
Text(AppLocalizations.of(context)!.yourKey)
```

3. Rexenera os arquivos de localización:
```bash
flutter gen-l10n
```

4. Se engadiches unha nova clave, asegúrate de que exista en todos os arquivos .arb

5. Verifica que o locale do dispositivo estea configurado correctamente

---

### Cores Incorrectas

**Descrición**: As cores non coinciden co deseño ou tema esperado.

**Causa Probable**: Uso incorrecto do tema ou hardcoded colors.

**Solución**:

1. Usa sempre as cores do tema:
```dart
// Correcto
color: Theme.of(context).colorScheme.primary

// Incorrecto
color: Colors.blue
```

2. Verifica a definición do tema en `lib/core/theme/app_theme.dart`

3. Asegúrate de que o MaterialApp teña o tema configurado:
```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  // ...
)
```

4. Para debug, imprime as cores actuais:
```dart
print('Primary: ${Theme.of(context).colorScheme.primary}');
```

---

### Layout Roto en Pantallas Pequenas

**Descrición**: A UI desbórdase ou vese mal en dispositivos con pantallas pequenas.

**Causa Probable**: Widgets con tamaños fixos ou falta de responsive design.

**Solución**:

1. Usa widgets flexibles en lugar de tamaños fixos:
```dart
// En lugar de
Container(width: 300, child: ...)

// Usa
Expanded(child: ...)
// ou
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

3. Usa `MediaQuery` para obter dimensións:
```dart
final screenWidth = MediaQuery.of(context).size.width;
```

4. Proba en diferentes tamaños de pantalla usando o emulador

---

### Overflow de Texto

**Descrición**: Aparece o warning de "overflow" con franxas amarelas e negras.

**Causa Probable**: Texto demasiado longo para o espazo dispoñible.

**Solución**:

1. Envolve o texto en `Flexible` ou `Expanded`:
```dart
Flexible(
  child: Text('Texto longo...'),
)
```

2. Usa `overflow` e `maxLines` no Text widget:
```dart
Text(
  'Texto longo...',
  overflow: TextOverflow.ellipsis,
  maxLines: 2,
)
```

3. Para textos moi longos, usa `SingleChildScrollView`:
```dart
SingleChildScrollView(
  child: Text('Texto moi longo...'),
)
```

4. Considera acurtar o texto ou usar un formato diferente

---

## Problemas Multi-Persoa

### Stock Non Se Comparte Correctamente

**Descrición**: Múltiples persoas poden crear medicamentos co mesmo nome sen compartir stock.

**Causa Probable**: Lóxica de verificación de duplicados por persoa en lugar de global.

**Solución**:

1. Verifica a función de busca de medicamentos existentes en `MedicationRepository`

2. Asegúrate de que a busca sexa global:
```dart
// Buscar por nome sen filtrar por personId
final existing = await db.query(
  'medications',
  where: 'name = ?',
  whereArgs: [name],
);
```

3. Ao engadir unha dose, asocia a dose coa persoa pero non o medicamento

4. Revisa a lóxica en `AddMedicationScreen` para reutilizar medicamentos existentes

---

### Medicamentos Duplicados

**Descrición**: Aparecen medicamentos duplicados na lista.

**Causa Probable**: Múltiples insercións do mesmo medicamento ou falta de validación.

**Solución**:

1. Implementa verificación antes de inserir:
```dart
final existing = await getMedicationByName(name);
if (existing != null) {
  return existing.id;
}
```

2. Usa restricións UNIQUE na base de datos:
```sql
CREATE TABLE medications (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  -- ...
);
```

3. Revisa a lóxica de creación de medicamentos no repository

4. Se xa existen duplicados, crea un script de migración para consolidalos

---

### Historial de Doses Incorrecto

**Descrición**: O historial mostra doses doutras persoas ou falta información.

**Causa Probable**: Filtrado incorrecto por persoa ou joins mal configurados.

**Solución**:

1. Verifica o query que obtén o historial:
```dart
final doses = await db.query(
  'dose_history',
  where: 'personId = ?',
  whereArgs: [personId],
  orderBy: 'takenAt DESC',
);
```

2. Asegúrate de que todas as doses teñan `personId` asociado

3. Revisa a lóxica de filtrado en `DoseHistoryScreen`

4. Verifica que os joins entre táboas inclúan a condición de persoa

---

### Persoa Por Defecto Non Cambia

**Descrición**: Ao cambiar a persoa activa, a UI non se actualiza correctamente.

**Causa Probable**: Estado non se propaga correctamente ou falta rebuild.

**Solución**:

1. Verifica que uses un estado global (Provider, Bloc, etc.):
```dart
Provider.of<PersonProvider>(context, listen: true).currentPerson
```

2. Asegúrate de que o cambio de persoa dispare `notifyListeners()`:
```dart
void setCurrentPerson(Person person) {
  _currentPerson = person;
  notifyListeners();
}
```

3. Verifica que os widgets relevantes escoiten os cambios

4. Considera usar `Consumer` para rebuilds específicos:
```dart
Consumer<PersonProvider>(
  builder: (context, provider, child) {
    return Text(provider.currentPerson.name);
  },
)
```

---

## Problemas con Xaxún

### Notificación de Xaxún Non Aparece

**Descrición**: A notificación ongoing de xaxún non se mostra.

**Causa Probable**: Permisos, configuración do canal ou erro ao crear a notificación.

**Solución**:

1. Verifica que o canal de notificacións de xaxún estea creado:
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

3. Verifica permisos de notificacións

4. Revisa logs para erros ao crear a notificación

---

### Conta Atrás Incorrecta

**Descrición**: O tempo restante do xaxún non é correcto ou non se actualiza.

**Causa Probable**: Cálculo incorrecto de tempo ou falta de actualización periódica.

**Solución**:

1. Verifica o cálculo de tempo restante:
```dart
final remaining = endTime.difference(DateTime.now());
```

2. Asegúrate de actualizar a notificación periodicamente:
```dart
Timer.periodic(Duration(minutes: 1), (timer) {
  updateFastingNotification();
});
```

3. Verifica que o `endTime` do xaxún se almacene correctamente

4. Usa a pantalla de depuración para verificar o estado do xaxún actual

---

### Xaxún Non Se Cancela Automaticamente

**Descrición**: A notificación de xaxún permanece despois de que termina o tempo.

**Causa Probable**: Falta lóxica para cancelar a notificación ao completarse.

**Solución**:

1. Implementa verificación cando o xaxún termina:
```dart
if (DateTime.now().isAfter(fasting.endTime)) {
  await cancelFastingNotification();
  await markFastingAsCompleted(fasting.id);
}
```

2. Verifica cando a app se abre:
```dart
@override
void initState() {
  super.initState();
  checkActiveFastings();
}
```

3. Programa unha alarma para cando termine o xaxún que cancele a notificación

4. Asegúrate de que a notificación se cancele en `onDidReceiveNotificationResponse`

**Referencias**: Revisa `lib/features/fasting/` para a implementación.

---

## Problemas de Testing

### Tests Fallan Localmente

**Descrición**: Os tests que pasan en CI fallan na túa máquina local.

**Causa Probable**: Diferenzas de contorno, dependencias ou configuración.

**Solución**:

1. Limpa e reconstrúe:
```bash
flutter clean
flutter pub get
```

2. Verifica que as versións sexan as mesmas:
```bash
flutter --version
dart --version
```

3. Executa os tests con máis información:
```bash
flutter test --verbose
```

4. Asegúrate de que non haxa tests que dependan de estado previo

5. Verifica que non haxa tests con dependencias de tempo (usa `fakeAsync`)

---

### Problemas con sqflite_common_ffi

**Descrición**: Tests de base de datos fallan con erros de sqflite.

**Causa Probable**: sqflite non está dispoñible en tests, necesitas usar sqflite_common_ffi.

**Solución**:

1. Asegúrate de ter a dependencia:
```yaml
dev_dependencies:
  sqflite_common_ffi: ^2.3.0
```

2. Inicializa no setup de tests:
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

4. Limpa a base de datos despois de cada test

---

### Timeouts en Tests

**Descrición**: Os tests fallan por timeout.

**Causa Probable**: Operacións lentas ou deadlocks en tests async.

**Solución**:

1. Aumenta o timeout para tests específicos:
```dart
test('slow test', () async {
  // ...
}, timeout: Timeout(Duration(seconds: 30)));
```

2. Verifica que non haxa `await` faltantes

3. Usa `fakeAsync` para tests con delays:
```dart
testWidgets('timer test', (tester) async {
  await tester.runAsync(() async {
    // test code with delays
  });
});
```

4. Mockea operacións lentas como chamadas de rede

5. Revisa que non haxa loops infinitos ou condicións de carreira

---

### Tests Inconsistentes

**Descrición**: Os mesmos tests ás veces pasan e ás veces fallan.

**Causa Probable**: Tests con dependencias de tempo, orde de execución ou estado compartido.

**Solución**:

1. Evita depender do tempo real, usa `fakeAsync` ou mocks

2. Asegúrate de que cada test sexa independente:
```dart
setUp(() {
  // Setup limpo para cada test
});

tearDown(() {
  // Limpeza despois de cada test
});
```

3. Non compartas estado mutable entre tests

4. Usa `setUpAll` só para setup inmutable

5. Executa tests en orde aleatoria para detectar dependencias:
```bash
flutter test --test-randomize-ordering-seed=random
```

---

## Problemas de Permisos

### POST_NOTIFICATIONS (Android 13+)

**Descrición**: As notificacións non funcionan en Android 13 ou superior.

**Causa Probable**: O permiso POST_NOTIFICATIONS debe solicitarse en runtime.

**Solución**:

1. Declara o permiso en `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

2. Solicita o permiso en runtime:
```dart
if (Platform.isAndroid && await Permission.notification.isDenied) {
  final status = await Permission.notification.request();
  if (status.isDenied) {
    // Informar ao usuario e ofrecer ir a configuración
  }
}
```

3. Verifica o permiso antes de programar notificacións

4. Guía ao usuario a configuración se foi denegado permanentemente

**Referencias**: [Android 13 Notification Permission](https://developer.android.com/about/versions/13/changes/notification-permission)

---

### SCHEDULE_EXACT_ALARM (Android 12+)

**Descrición**: As alarmas exactas non funcionan en Android 12+.

**Causa Probable**: Require permiso especial desde Android 12.

**Solución**:

1. Declara o permiso:
```xml
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
```

2. Verifica e solicita se é necesario:
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

3. Explica ao usuario por que necesitas alarmas exactas

4. Considera usar `USE_EXACT_ALARM` se es unha app de alarma/recordatorio

---

### USE_EXACT_ALARM (Android 14+)

**Descrición**: Necesitas alarmas exactas sen solicitar permiso especial.

**Causa Probable**: Android 14 introduce USE_EXACT_ALARM para apps de alarma.

**Solución**:

1. Se a túa app é principalmente de alarmas/recordatorios, usa:
```xml
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
```

2. Esta é unha alternativa a `SCHEDULE_EXACT_ALARM` que non require que o usuario outorgue o permiso manualmente

3. Só úsala se a túa app cumpre cos [casos de uso permitidos](https://developer.android.com/about/versions/14/changes/schedule-exact-alarms)

4. A app debe ter como funcionalidade principal alarmas ou recordatorios

---

### Notificacións en Background (iOS)

**Descrición**: As notificacións non funcionan correctamente en iOS.

**Causa Probable**: Permisos non solicitados ou configuración incorrecta.

**Solución**:

1. Solicita permisos ao iniciar a app:
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

3. Asegúrate de ter os capabilities correctos en Xcode:
   - Push Notifications
   - Background Modes

4. Verifica que o usuario non deshabilitase notificacións en Configuración

---

## Erros Comúns e Solucións

### MissingPluginException

**Descrición**: Erro "MissingPluginException(No implementation found for method...)"

**Causa Probable**: O plugin non está rexistrado correctamente ou necesitas hot restart.

**Solución**:

1. Fai un hot restart completo (non só hot reload):
```bash
# No terminal onde corre a app
r  # hot reload
R  # HOT RESTART (este é o que necesitas)
```

2. Se persiste, reconstrúe completamente:
```bash
flutter clean
flutter pub get
flutter run
```

3. Verifica que o plugin estea en `pubspec.yaml`

4. Para iOS, reinstala os pods:
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
```

---

### PlatformException

**Descrición**: Erro "PlatformException" con diferentes códigos.

**Causa Probable**: Depende do código específico do erro.

**Solución**:

1. Le a mensaxe de erro e código completos

2. Erros comúns:
   - `permission_denied`: Verifica permisos
   - `error`: Erro xenérico, revisa logs nativos
   - `not_available`: Función non dispoñible nesta plataforma

3. Para Android, revisa logcat:
```bash
adb logcat | grep -i flutter
```

4. Para iOS, revisa a consola de Xcode

5. Asegúrate de manexar estes erros gracefully:
```dart
try {
  await somePluginMethod();
} on PlatformException catch (e) {
  print('Error: ${e.code} - ${e.message}');
  // Manexar apropiadamente
}
```

---

### DatabaseException

**Descrición**: Erro ao realizar operacións de base de datos.

**Causa Probable**: Query inválido, restrición violada ou base de datos corrupta.

**Solución**:

1. Le a mensaxe de erro completo para identificar o problema

2. Erros comúns:
   - `UNIQUE constraint failed`: Intentando inserir duplicado
   - `no such table`: Táboa non existe, revisa migracións
   - `syntax error`: Query SQL inválido

3. Verifica o query SQL:
```dart
try {
  await db.query('medications', where: 'id = ?', whereArgs: [id]);
} on DatabaseException catch (e) {
  print('Database error: ${e.toString()}');
}
```

4. Asegúrate de que as migracións se executasen

5. Como último recurso, resetea a base de datos

---

### StateError

**Descrición**: Erro "Bad state: No element" ou similar.

**Causa Probable**: Intentando acceder a un elemento que non existe.

**Solución**:

1. Identifica a liña exacta do erro no stack trace

2. Usa métodos seguros:
```dart
// En lugar de
final item = list.first;  // Lanza StateError se está baleira

// Usa
final item = list.isNotEmpty ? list.first : null;
// ou
final item = list.firstOrNull;  // Dart 3.0+
```

3. Sempre verifica antes de acceder:
```dart
if (list.isNotEmpty) {
  final item = list.first;
  // usar item
}
```

4. Usa try-catch se é necesario:
```dart
try {
  final item = list.single;
} on StateError {
  // Manexar caso onde non hai exactamente un elemento
}
```

---

### Null Check Operator Used on Null Value

**Descrición**: Erro ao usar o operador `!` nun valor null.

**Causa Probable**: Variable nullable usada con `!` cando o seu valor é null.

**Solución**:

1. Identifica a liña exacta no stack trace

2. Verifica o valor antes de usar `!`:
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

5. Revisa por que o valor é null cando non debería selo

---

## Logs e Depuración

### Como Habilitar Logs

**Descrición**: Necesitas ver logs detallados para depurar un problema.

**Solución**:

1. **Logs de Flutter**:
```bash
flutter run --verbose
```

2. **Logs só da app**:
```dart
import 'package:logging/logging.dart';

final logger = Logger('MedicApp');

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(MyApp());
}
```

3. **Logs nativos Android**:
```bash
adb logcat | grep -i flutter
# ou para ver todo
adb logcat
```

4. **Logs nativos iOS**:
   - Abre Console.app en macOS
   - Selecciona o teu dispositivo/simulador
   - Filtra por "flutter" ou o teu bundle identifier

---

### Logs de Notificacións

**Descrición**: Necesitas ver logs relacionados con notificacións.

**Solución**:

1. Engade logs no código de notificacións:
```dart
print('Scheduling notification at: $scheduledTime');
await flutterLocalNotificationsPlugin.zonedSchedule(
  id,
  title,
  body,
  scheduledTime,
  notificationDetails,
);
print('Notification scheduled successfully');
```

2. Lista notificacións pendentes:
```dart
final pending = await flutterLocalNotificationsPlugin
    .pendingNotificationRequests();
for (var notification in pending) {
  print('Pending: ${notification.id} - ${notification.title}');
}
```

3. Verifica logs do sistema:
   - Android: `adb logcat | grep -i notification`
   - iOS: Console.app con filtro "notification"

---

### Logs de Base de Datos

**Descrición**: Necesitas ver as queries de base de datos executadas.

**Solución**:

1. Habilita logging en sqflite:
```dart
import 'package:sqflite/sqflite.dart';

void main() {
  Sqflite.setDebugModeOn(true);
  runApp(MyApp());
}
```

2. Engade logs nas túas queries:
```dart
print('Executing query: SELECT * FROM medications WHERE id = $id');
final result = await db.query('medications', where: 'id = ?', whereArgs: [id]);
print('Query returned ${result.length} rows');
```

3. Wrapper para logging automático:
```dart
class LoggedDatabase {
  final Database db;
  LoggedDatabase(this.db);

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    print('Query: $table WHERE $where ARGS $whereArgs');
    final result = await db.query(table, where: where, whereArgs: whereArgs);
    print('Result: ${result.length} rows');
    return result;
  }
}
```

---

### Usar Debugger

**Descrición**: Necesitas pausar a execución e examinar o estado.

**Solución**:

1. **En VS Code**:
   - Coloca un breakpoint clickando ao lado do número de liña
   - Executa en modo debug (F5)
   - Cando pause, usa os controis de debug

2. **En Android Studio**:
   - Coloca un breakpoint clickando na marxe
   - Executa Debug (Shift + F9)
   - Usa Debug panel para step over/into/out

3. **Debugger programático**:
```dart
import 'dart:developer';

void someFunction() {
  debugger();  // Pausa aquí se hai debugger conectado
  // código...
}
```

4. **Inspect variables**:
```dart
print('Value: $value');  // Logging simple
debugPrint('Value: $value');  // Logging que respecta rate limits
```

---

### Pantalla de Depuración da App

**Descrición**: MedicApp inclúe unha pantalla de depuración útil.

**Solución**:

1. Accede á pantalla de depuración desde o menú de configuración

2. Funcións dispoñibles:
   - Ver base de datos (táboas, filas, contido)
   - Ver notificacións programadas
   - Ver estado do sistema
   - Forzar actualización de notificacións
   - Limpar base de datos
   - Ver logs recentes

3. Usa esta pantalla para:
   - Verificar que os datos se garden correctamente
   - Comprobar notificacións pendentes
   - Identificar problemas de estado

4. Só dispoñible en modo debug

---

## Resetear a Aplicación

### Limpar Datos de App

**Descrición**: Necesitas eliminar todos os datos sen desinstalar.

**Solución**:

**Android**:
```bash
adb shell pm clear com.medicapp.app
```

**iOS**:
- Configuración > Xeral > iPhone Storage
- Busca MedicApp
- "Borrar App" (non "Descargar App")

**Desde a app** (só debug):
- Usa a pantalla de depuración
- "Reset Database"

---

### Desinstalar e Reinstalar

**Descrición**: Instalación limpa completa.

**Solución**:

**Android**:
```bash
adb uninstall com.medicapp.app
flutter run
```

**iOS**:
```bash
# Desde o dispositivo/simulador, mantén premido o ícono
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

**Descrición**: Eliminar só a base de datos mantendo a app.

**Solución**:

**Desde código** (só debug):
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
- Necesitas acceso ao contedor da app
- É máis fácil desinstalar e reinstalar

---

### Limpar Caché de Flutter

**Descrición**: Resolver problemas de compilación relacionados con caché.

**Solución**:

1. Limpeza básica:
```bash
flutter clean
```

2. Limpeza completa:
```bash
flutter clean
rm -rf build/
rm -rf .dart_tool/
rm pubspec.lock
flutter pub get
```

3. Limpar caché de pub:
```bash
flutter pub cache repair
```

4. Limpar caché de Gradle (Android):
```bash
cd android
./gradlew clean cleanBuildCache
rm -rf ~/.gradle/caches/
cd ..
```

5. Limpar caché de pods (iOS):
```bash
cd ios
rm -rf Pods Podfile.lock
pod cache clean --all
pod install
cd ..
```

---

## Problemas Coñecidos

### Lista de Bugs Coñecidos

1. **Notificacións non persisten despois de reinicio nalgúns dispositivos Android**
   - Afecta: Android 12+ con optimización agresiva de batería
   - Workaround: Desactivar optimización de batería para MedicApp

2. **Layout overflow en pantallas moi pequenas (<5")**
   - Afecta: Dispositivos con ancho < 320dp
   - Status: Fix planificado para v1.1.0

3. **Animación de transición entrecortada en dispositivos low-end**
   - Afecta: Dispositivos con <2GB RAM
   - Workaround: Desactivar animacións en configuración

4. **Base de datos pode crecer indefinidamente**
   - Afecta: Usuarios con moito historial (>1 ano)
   - Workaround: Implementar limpeza periódica de historial antigo
   - Status: Feature de arquivo automático planificado

---

### Workarounds Temporais

1. **Se as notificacións non soan nalgúns dispositivos**:
```dart
// Usa máxima importancia temporalmente
importance: Importance.max,
priority: Priority.high,
```

2. **Se hai lag en listas longas**:
   - Limita o historial visible a últimos 30 días
   - Implementa paxinación manual

3. **Se a base de datos se bloquea frecuentemente**:
   - Reduce operacións concorrentes
   - Usa transaccións batch para múltiples inserts

---

### Issues en GitHub

**Como buscar issues existentes**:

1. Vai a: https://github.com/teu-usuario/medicapp/issues

2. Usa os filtros:
   - `is:issue is:open` - Issues abertos
   - `label:bug` - Só bugs
   - `label:enhancement` - Features solicitados

3. Busca por palabras clave: "notification", "database", etc.

**Antes de crear un novo issue**:
- Busca se xa existe un similar
- Verifica a lista de problemas coñecidos arriba
- Asegúrate de que non estea resolto na última versión

---

## Obter Axuda

### Revisar Documentación

**Recursos dispoñibles**:

1. **Documentación do proxecto**:
   - `README.md` - Información xeral e setup
   - `docs/es/ARCHITECTURE.md` - Arquitectura do proxecto
   - `docs/es/CONTRIBUTING.md` - Guía de contribución
   - `docs/es/TESTING.md` - Guía de testing

2. **Documentación de Flutter**:
   - [flutter.dev/docs](https://flutter.dev/docs)
   - [api.flutter.dev](https://api.flutter.dev)

3. **Documentación de paquetes**:
   - Revisa pub.dev para cada dependencia
   - Le o README e changelog de cada paquete

---

### Buscar en GitHub Issues

**Como buscar efectivamente**:

1. Usa busca avanzada:
```
repo:teu-usuario/medicapp is:issue [palabras clave]
```

2. Busca issues pechados tamén:
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

### Crear Novo Issue con Template

**Antes de crear un issue**:

1. Confirma que é realmente un bug ou feature request válido
2. Busca issues duplicados
3. Recompila toda a información necesaria

**Información necesaria**:

**Para bugs**:
- Descrición clara do problema
- Pasos para reproducir
- Comportamento esperado vs actual
- Screenshots/videos se aplica
- Información do contorno (ver abaixo)
- Logs relevantes

**Para features**:
- Descrición da funcionalidade
- Caso de uso e beneficios
- Proposta de implementación (opcional)
- Mockups ou exemplos (opcional)

**Plantilla de issue**:
```markdown
## Descrición
[Descrición clara e concisa do problema]

## Pasos para Reproducir
1. [Primeiro paso]
2. [Segundo paso]
3. [Terceiro paso]

## Comportamento Esperado
[Que debería suceder]

## Comportamento Actual
[Que sucede realmente]

## Información do Contorno
- SO: [Android 13 / iOS 16.5]
- Dispositivo: [Modelo específico]
- Versión de MedicApp: [v1.0.0]
- Versión de Flutter: [3.24.5]

## Logs
```
[Logs relevantes]
```

## Screenshots
[Se aplica]

## Información Adicional
[Calquera outro contexto]
```

---

### Información Necesaria para Reportar

**Sempre inclúe**:

1. **Versión da app**:
```dart
// Desde pubspec.yaml
version: 1.0.0+1
```

2. **Información do dispositivo**:
```dart
import 'package:device_info_plus/device_info_plus.dart';

final deviceInfo = DeviceInfoPlugin();
if (Platform.isAndroid) {
  final androidInfo = await deviceInfo.androidInfo;
  print('Android ${androidInfo.version.sdkInt}');
  print('Model: ${androidInfo.model}');
}
```

3. **Versión de Flutter**:
```bash
flutter --version
```

4. **Logs completos**:
```bash
flutter run --verbose > logs.txt 2>&1
# Adxunta logs.txt ao issue
```

5. **Stack trace completo** se hai crash

6. **Screenshots ou videos** mostrando o problema

---

## Conclusión

Esta guía cobre os problemas máis comúns en MedicApp. Se atopas un problema non listado aquí:

1. Revisa a documentación completa do proxecto
2. Busca en GitHub Issues
3. Pregunta nas discusións do repositorio
4. Crea un novo issue con toda a información necesaria

**Lembra**: Proporcionar información detallada e pasos para reproducir fai que sexa moito máis fácil resolver o teu problema rapidamente.

Para contribuír melloras a esta guía, por favor abre un PR ou issue no repositorio.

---

**Última actualización**: 2025-11-14
**Versión do documento**: 1.0.0
