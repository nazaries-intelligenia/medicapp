# Guía de Instalación de MedicApp

Esta guía completa le ayudará a configurar el entorno de desarrollo y ejecutar MedicApp en su sistema.

---

## 1. Requisitos Previos

### 1.1 Sistema Operativo

MedicApp es compatible con los siguientes sistemas operativos:

- **Android:** 6.0 (API 23) o superior
- **iOS:** 12.0 o superior (requiere macOS para desarrollo)
- **Desarrollo:**
  - Windows 10/11 (64-bit)
  - macOS 10.14 o superior
  - Linux (64-bit)

### 1.2 Flutter SDK

**Versión requerida:** Flutter 3.9.2 o superior

Verifique si ya tiene Flutter instalado:

```bash
flutter --version
```

Si la versión es inferior a 3.9.2, necesitará actualizar:

```bash
flutter upgrade
```

### 1.3 Dart SDK

El Dart SDK viene incluido con Flutter. La versión requerida es:

- **Dart SDK:** 3.9.2 o superior

### 1.4 Editor de Código Recomendado

Se recomienda usar uno de los siguientes editores:

#### Visual Studio Code (Recomendado)
- **Descargar:** https://code.visualstudio.com/
- **Extensiones necesarias:**
  - Flutter (Dart Code)
  - Dart

#### Android Studio
- **Descargar:** https://developer.android.com/studio
- **Plugins necesarios:**
  - Flutter
  - Dart

### 1.5 Git

Necesario para clonar el repositorio:

- **Git 2.x o superior**
- **Descargar:** https://git-scm.com/downloads

Verifique la instalación:

```bash
git --version
```

### 1.6 Herramientas Adicionales por Plataforma

#### Para desarrollo Android:
- **Android SDK** (incluido con Android Studio)
- **Android SDK Platform-Tools**
- **Android SDK Build-Tools**
- **Java JDK 11** (incluido con Android Studio)

#### Para desarrollo iOS (solo macOS):
- **Xcode 13.0 o superior**
- **CocoaPods:**
  ```bash
  sudo gem install cocoapods
  ```

---

## 2. Instalación de Flutter SDK

### 2.1 Windows

1. Descargue el Flutter SDK:
   - Visite: https://docs.flutter.dev/get-started/install/windows
   - Descargue el archivo ZIP de Flutter

2. Extraiga el archivo en una ubicación permanente (ej: `C:\src\flutter`)

3. Agregue Flutter a las variables de entorno PATH:
   - Busque "Variables de entorno" en el menú de inicio
   - Edite la variable PATH del usuario
   - Agregue la ruta: `C:\src\flutter\bin`

4. Verifique la instalación:
   ```bash
   flutter doctor
   ```

### 2.2 macOS

1. Descargue el Flutter SDK:
   ```bash
   cd ~/development
   curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.9.2-stable.zip
   unzip flutter_macos_3.9.2-stable.zip
   ```

2. Agregue Flutter al PATH editando `~/.zshrc` o `~/.bash_profile`:
   ```bash
   export PATH="$PATH:$HOME/development/flutter/bin"
   ```

3. Recargue la configuración:
   ```bash
   source ~/.zshrc
   ```

4. Verifique la instalación:
   ```bash
   flutter doctor
   ```

### 2.3 Linux

1. Descargue el Flutter SDK:
   ```bash
   cd ~/development
   wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.9.2-stable.tar.xz
   tar xf flutter_linux_3.9.2-stable.tar.xz
   ```

2. Agregue Flutter al PATH editando `~/.bashrc` o `~/.zshrc`:
   ```bash
   export PATH="$PATH:$HOME/development/flutter/bin"
   ```

3. Recargue la configuración:
   ```bash
   source ~/.bashrc
   ```

4. Verifique la instalación:
   ```bash
   flutter doctor
   ```

### 2.4 Verificación Completa del Entorno

Ejecute el comando Flutter Doctor para identificar componentes faltantes:

```bash
flutter doctor -v
```

Resuelva cualquier problema indicado con una [✗] antes de continuar.

---

## 3. Clonación del Repositorio

1. Abra una terminal en el directorio donde desea clonar el proyecto

2. Clone el repositorio:
   ```bash
   git clone <repository-url>
   ```

3. Navegue al directorio del proyecto:
   ```bash
   cd medicapp
   ```

4. Verifique que está en la rama correcta:
   ```bash
   git branch
   ```

---

## 4. Instalación de Dependencias

### 4.1 Dependencias de Flutter

Instale todas las dependencias del proyecto:

```bash
flutter pub get
```

Este comando instalará las siguientes dependencias principales:

- **sqflite:** ^2.3.0 - Base de datos SQLite local
- **flutter_local_notifications:** ^19.5.0 - Sistema de notificaciones
- **timezone:** ^0.10.1 - Manejo de zonas horarias
- **intl:** ^0.20.2 - Internacionalización
- **android_intent_plus:** ^6.0.0 - Intents de Android
- **shared_preferences:** ^2.2.2 - Almacenamiento clave-valor
- **file_picker:** ^8.0.0+1 - Selector de archivos
- **share_plus:** ^10.1.4 - Compartir archivos
- **path_provider:** ^2.1.5 - Acceso a directorios del sistema
- **uuid:** ^4.0.0 - Generación de IDs únicos

### 4.2 Dependencias Específicas por Plataforma

#### Android

No se requieren pasos adicionales. Las dependencias de Android se descargarán automáticamente en la primera compilación.

#### iOS (solo macOS)

Instale las dependencias de CocoaPods:

```bash
cd ios
pod install
cd ..
```

Si encuentra errores, intente actualizar el repositorio de CocoaPods:

```bash
cd ios
pod repo update
pod install
cd ..
```

---

## 5. Configuración del Entorno

### 5.1 Variables de Entorno

MedicApp no requiere variables de entorno especiales para ejecutarse en desarrollo.

### 5.2 Permisos de Android

El archivo `android/app/src/main/AndroidManifest.xml` ya incluye los permisos necesarios:

```xml
<!-- Permisos para notificaciones -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
```

**Importante para Android 13+ (API 33+):**

Los usuarios deberán conceder permiso de notificaciones en tiempo de ejecución. La aplicación solicitará este permiso automáticamente en el primer inicio.

**Alarmas exactas (Android 12+):**

Para programar notificaciones precisas, los usuarios deben habilitar "Alarmas y recordatorios" en la configuración del sistema:
- Configuración > Aplicaciones > MedicApp > Alarmas y recordatorios > Activar

### 5.3 Configuración de iOS

#### Permisos en Info.plist

Si está desarrollando para iOS, asegúrese de que `ios/Runner/Info.plist` contenga:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

#### Capacidades de Notificaciones

Las notificaciones están configuradas automáticamente por el plugin `flutter_local_notifications`.

---

## 6. Ejecución en Desarrollo

### 6.1 Listar Dispositivos Disponibles

Antes de ejecutar la aplicación, liste los dispositivos conectados:

```bash
flutter devices
```

Esto mostrará:
- Dispositivos Android conectados por USB
- Emuladores Android disponibles
- Simuladores iOS (solo macOS)
- Navegadores web disponibles

### 6.2 Iniciar un Emulador/Simulador

#### Android Emulator:
```bash
flutter emulators
flutter emulators --launch <emulator-id>
```

#### iOS Simulator (solo macOS):
```bash
open -a Simulator
```

### 6.3 Ejecutar la Aplicación

#### Modo Debug (predeterminado):
```bash
flutter run
```

Este modo incluye:
- Hot reload (recarga en caliente)
- Hot restart (reinicio en caliente)
- Debugging completo
- Rendimiento más lento

**Atajos útiles durante la ejecución:**
- `r` - Hot reload (recarga el código cambiado)
- `R` - Hot restart (reinicia la aplicación completa)
- `q` - Salir de la aplicación

#### Modo Release:
```bash
flutter run --release
```

Este modo incluye:
- Rendimiento optimizado
- Sin debugging
- Tamaño reducido

#### Modo Profile:
```bash
flutter run --profile
```

Este modo es útil para:
- Análisis de rendimiento
- Debugging de rendimiento
- Timeline tools

### 6.4 Ejecutar en un Dispositivo Específico

Si tiene múltiples dispositivos conectados:

```bash
flutter run -d <device-id>
```

Ejemplo:
```bash
flutter run -d emulator-5554
flutter run -d "iPhone 14 Pro"
```

### 6.5 Ejecutar con Logs Detallados

Para ver logs más detallados:

```bash
flutter run -v
```

---

## 7. Ejecución de Tests

MedicApp incluye una suite completa de tests con más de 432 pruebas.

### 7.1 Ejecutar Todos los Tests

```bash
flutter test
```

### 7.2 Ejecutar un Test Específico

```bash
flutter test test/nombre_del_archivo_test.dart
```

Ejemplos:
```bash
flutter test test/settings_screen_test.dart
flutter test test/notification_actions_test.dart
flutter test test/multiple_fasting_prioritization_test.dart
```

### 7.3 Ejecutar Tests con Cobertura

Para generar un reporte de cobertura de código:

```bash
flutter test --coverage
```

El reporte se generará en `coverage/lcov.info`.

### 7.4 Ver el Reporte de Cobertura

Para visualizar el reporte de cobertura en HTML:

```bash
# Instalar lcov (Linux/macOS)
sudo apt-get install lcov  # Linux
brew install lcov          # macOS

# Generar reporte HTML
genhtml coverage/lcov.info -o coverage/html

# Abrir el reporte
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
start coverage/html/index.html  # Windows
```

### 7.5 Ejecutar Tests con Logs Detallados

```bash
flutter test --verbose
```

---

## 8. Build para Producción

### 8.1 Android

#### APK (para distribución directa):

```bash
flutter build apk --release
```

El APK se generará en: `build/app/outputs/flutter-apk/app-release.apk`

#### APK Split por ABI (reduce tamaño):

```bash
flutter build apk --split-per-abi --release
```

Esto genera múltiples APKs optimizados:
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM)
- `app-x86_64-release.apk` (64-bit Intel)

#### App Bundle (para Google Play Store):

```bash
flutter build appbundle --release
```

El App Bundle se generará en: `build/app/outputs/bundle/release/app-release.aab`

**Ventajas del App Bundle:**
- Tamaño de descarga optimizado
- Google Play genera APKs específicos para cada dispositivo
- Requerido para nuevas aplicaciones en Play Store

#### Configuración de Firma para Android

Para builds de producción, necesita configurar la firma de la aplicación:

1. Genere un keystore:
   ```bash
   keytool -genkey -v -keystore ~/medicapp-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias medicapp
   ```

2. Cree el archivo `android/key.properties`:
   ```properties
   storePassword=<su-contraseña>
   keyPassword=<su-contraseña>
   keyAlias=medicapp
   storeFile=/ruta/a/medicapp-release-key.jks
   ```

3. Actualice `android/app/build.gradle.kts` para usar el keystore (ya está configurado en el proyecto).

**IMPORTANTE:** No incluya `key.properties` ni el archivo `.jks` en el control de versiones.

### 8.2 iOS (solo macOS)

#### Build para Testing:

```bash
flutter build ios --release
```

#### Build para App Store:

```bash
flutter build ipa --release
```

El archivo IPA se generará en: `build/ios/ipa/medicapp.ipa`

#### Configuración de Firma para iOS

1. Abra el proyecto en Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. Configure el equipo de firma:
   - Seleccione el proyecto "Runner" en el navegador
   - Vaya a "Signing & Capabilities"
   - Seleccione su equipo de desarrollo de Apple
   - Configure el Bundle Identifier único

3. Cree un perfil de aprovisionamiento en Apple Developer

4. Archive y distribuya desde Xcode:
   - Product > Archive
   - Window > Organizer
   - Distribute App

---

## 9. Troubleshooting Común

### 9.1 Problemas con Dependencias

#### Error: "Pub get failed"

**Solución:**
```bash
flutter clean
flutter pub get
```

#### Error: "Version solving failed"

**Solución:**
```bash
# Actualizar Flutter
flutter upgrade

# Limpiar caché
flutter pub cache repair

# Reinstalar dependencias
flutter clean
flutter pub get
```

#### Error: "CocoaPods not installed" (iOS)

**Solución:**
```bash
sudo gem install cocoapods
pod setup
```

### 9.2 Problemas con Permisos

#### Android: Notificaciones no funcionan

**Verificar:**
1. El permiso POST_NOTIFICATIONS está en AndroidManifest.xml
2. El usuario ha concedido permisos de notificación en Android 13+
3. Las alarmas exactas están habilitadas en Configuración

**Solución programática:**
La app solicita permisos automáticamente. Si el usuario los denegó:
```dart
// La app incluye un botón para abrir la configuración
// Configuración > Permisos > Notificaciones
```

#### Android: Alarmas exactas no funcionan

**Síntomas:**
- Las notificaciones llegan tarde
- Las notificaciones no llegan a la hora exacta

**Solución:**
1. Abra Configuración del sistema
2. Aplicaciones > MedicApp > Alarmas y recordatorios
3. Active la opción

La app incluye un botón de ayuda que dirige al usuario a esta configuración.

### 9.3 Problemas con Base de Datos

#### Error: "Database locked" o "Cannot open database"

**Causa:** La base de datos SQLite está siendo accedida por múltiples procesos.

**Solución:**
```bash
# Reinstalar la aplicación
flutter clean
flutter run
```

#### Error: Migraciones de base de datos fallan

**Verificar:**
1. El número de versión de la base de datos en `database_helper.dart`
2. Los scripts de migración están completos

**Solución:**
```bash
# Desinstalar la aplicación del dispositivo
adb uninstall com.medicapp.medicapp  # Android
# Reinstalar
flutter run
```

### 9.4 Problemas con Notificaciones

#### Las notificaciones no se reprograman después de reiniciar

**Verificar:**
1. El permiso RECEIVE_BOOT_COMPLETED está en AndroidManifest.xml
2. El receiver de boot está registrado

**Solución:**
El archivo `AndroidManifest.xml` ya incluye la configuración necesaria:
```xml
<receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver"
    android:exported="false">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
    </intent-filter>
</receiver>
```

#### Las notificaciones no hacen sonido/vibración

**Verificar:**
1. El volumen del dispositivo no está en silencio
2. El modo "No molestar" está desactivado
3. Los permisos de vibración están concedidos

### 9.5 Problemas de Compilación

#### Error: "Gradle build failed"

**Solución:**
```bash
# Limpiar proyecto
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

#### Error: "Execution failed for task ':app:processDebugResources'"

**Causa:** Recursos duplicados o conflictos.

**Solución:**
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter run
```

#### Error: SDK version mismatch

**Verificar:**
1. La versión de Flutter: `flutter --version`
2. El archivo `pubspec.yaml` requiere: `sdk: ^3.9.2`

**Solución:**
```bash
flutter upgrade
flutter doctor
```

### 9.6 Problemas de Rendimiento

#### La aplicación es lenta en modo debug

**Explicación:**
Esto es normal. El modo debug incluye herramientas de desarrollo que reducen el rendimiento.

**Solución:**
Pruebe en modo release para evaluar el rendimiento real:
```bash
flutter run --release
```

#### Hot reload no funciona

**Solución:**
```bash
# Reinicie la aplicación
# En la terminal donde ejecutó 'flutter run', presione:
R  # (mayúscula) para hot restart
```

### 9.7 Problemas de Conectividad de Dispositivos

#### El dispositivo no aparece en `flutter devices`

**Android:**
```bash
# Verificar conexión ADB
adb devices

# Reiniciar servidor ADB
adb kill-server
adb start-server

# Verificar de nuevo
flutter devices
```

**iOS:**
```bash
# Verificar dispositivos conectados
instruments -s devices

# Confiar en la computadora desde el dispositivo iOS
```

---

## 10. Recursos Adicionales

### Documentación Oficial

- **Flutter:** https://docs.flutter.dev/
- **Dart:** https://dart.dev/guides
- **Material Design 3:** https://m3.material.io/

### Plugins Utilizados

- **sqflite:** https://pub.dev/packages/sqflite
- **flutter_local_notifications:** https://pub.dev/packages/flutter_local_notifications
- **timezone:** https://pub.dev/packages/timezone
- **intl:** https://pub.dev/packages/intl

### Comunidad y Soporte

- **Flutter Community:** https://flutter.dev/community
- **Stack Overflow:** https://stackoverflow.com/questions/tagged/flutter
- **GitHub Issues:** (Repositorio del proyecto)

---

## 11. Próximos Pasos

Una vez completada la instalación:

1. **Explore el código:**
   - Revise la estructura del proyecto en `lib/`
   - Examine los tests en `test/`

2. **Ejecute la aplicación:**
   ```bash
   flutter run
   ```

3. **Ejecute los tests:**
   ```bash
   flutter test
   ```

4. **Lea la documentación adicional:**
   - [README.md](../README.md)
   - [Arquitectura del Proyecto](architecture.md) (si existe)
   - [Guía de Contribución](contributing.md) (si existe)

---

## Contacto y Ayuda

Si encuentra problemas no cubiertos en esta guía, por favor:

1. Revise los issues existentes en el repositorio
2. Ejecute `flutter doctor -v` y comparta el resultado
3. Incluya logs completos del error
4. Describa los pasos para reproducir el problema

---

**Última actualización:** Noviembre 2024
**Versión del documento:** 1.0.0
**Versión de MedicApp:** 1.0.0+1
