# Guía de Instalación de MedicApp

Esta guía completa axudarache a configurar o entorno de desenvolvemento e executar MedicApp no teu sistema.

---

## 1. Requisitos Previos

### 1.1 Sistema Operativo

MedicApp é compatible cos seguintes sistemas operativos:

- **Android:** 6.0 (API 23) ou superior
- **iOS:** 12.0 ou superior (require macOS para desenvolvemento)
- **Desenvolvemento:**
  - Windows 10/11 (64-bit)
  - macOS 10.14 ou superior
  - Linux (64-bit)

### 1.2 Flutter SDK

**Versión requirida:** Flutter 3.9.2 ou superior

Verifica se xa tes Flutter instalado:

```bash
flutter --version
```

Se a versión é inferior a 3.9.2, necesitarás actualizar:

```bash
flutter upgrade
```

### 1.3 Dart SDK

O Dart SDK vén incluído con Flutter. A versión requirida é:

- **Dart SDK:** 3.9.2 ou superior

### 1.4 Editor de Código Recomendado

Recoméndase usar un dos seguintes editores:

#### Visual Studio Code (Recomendado)
- **Descargar:** https://code.visualstudio.com/
- **Extensións necesarias:**
  - Flutter (Dart Code)
  - Dart

#### Android Studio
- **Descargar:** https://developer.android.com/studio
- **Plugins necesarios:**
  - Flutter
  - Dart

### 1.5 Git

Necesario para clonar o repositorio:

- **Git 2.x ou superior**
- **Descargar:** https://git-scm.com/downloads

Verifica a instalación:

```bash
git --version
```

### 1.6 Ferramentas Adicionais por Plataforma

#### Para desenvolvemento Android:
- **Android SDK** (incluído con Android Studio)
- **Android SDK Platform-Tools**
- **Android SDK Build-Tools**
- **Java JDK 11** (incluído con Android Studio)

#### Para desenvolvemento iOS (só macOS):
- **Xcode 13.0 ou superior**
- **CocoaPods:**
  ```bash
  sudo gem install cocoapods
  ```

---

## 2. Instalación de Flutter SDK

### 2.1 Windows

1. Descarga o Flutter SDK:
   - Visita: https://docs.flutter.dev/get-started/install/windows
   - Descarga o arquivo ZIP de Flutter

2. Extrae o arquivo nunha ubicación permanente (ex: `C:\src\flutter`)

3. Engade Flutter ás variables de entorno PATH:
   - Busca "Variables de entorno" no menú de inicio
   - Edita a variable PATH do usuario
   - Engade a ruta: `C:\src\flutter\bin`

4. Verifica a instalación:
   ```bash
   flutter doctor
   ```

### 2.2 macOS

1. Descarga o Flutter SDK:
   ```bash
   cd ~/development
   curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.9.2-stable.zip
   unzip flutter_macos_3.9.2-stable.zip
   ```

2. Engade Flutter ao PATH editando `~/.zshrc` ou `~/.bash_profile`:
   ```bash
   export PATH="$PATH:$HOME/development/flutter/bin"
   ```

3. Recarga a configuración:
   ```bash
   source ~/.zshrc
   ```

4. Verifica a instalación:
   ```bash
   flutter doctor
   ```

### 2.3 Linux

1. Descarga o Flutter SDK:
   ```bash
   cd ~/development
   wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.9.2-stable.tar.xz
   tar xf flutter_linux_3.9.2-stable.tar.xz
   ```

2. Engade Flutter ao PATH editando `~/.bashrc` ou `~/.zshrc`:
   ```bash
   export PATH="$PATH:$HOME/development/flutter/bin"
   ```

3. Recarga a configuración:
   ```bash
   source ~/.bashrc
   ```

4. Verifica a instalación:
   ```bash
   flutter doctor
   ```

### 2.4 Verificación Completa do Entorno

Executa o comando Flutter Doctor para identificar compoñentes faltantes:

```bash
flutter doctor -v
```

Resolve calquera problema indicado cunha [✗] antes de continuar.

---

## 3. Clonación do Repositorio

1. Abre unha terminal no directorio onde desexas clonar o proxecto

2. Clona o repositorio:
   ```bash
   git clone <repository-url>
   ```

3. Navega ao directorio do proxecto:
   ```bash
   cd medicapp
   ```

4. Verifica que estás na rama correcta:
   ```bash
   git branch
   ```

---

## 4. Instalación de Dependencias

### 4.1 Dependencias de Flutter

Instala todas as dependencias do proxecto:

```bash
flutter pub get
```

Este comando instalará as seguintes dependencias principais:

- **sqflite:** ^2.3.0 - Base de datos SQLite local
- **flutter_local_notifications:** ^19.5.0 - Sistema de notificacións
- **timezone:** ^0.10.1 - Manexo de zonas horarias
- **intl:** ^0.20.2 - Internacionalización
- **android_intent_plus:** ^6.0.0 - Intents de Android
- **shared_preferences:** ^2.2.2 - Almacenamento clave-valor
- **file_picker:** ^8.0.0+1 - Selector de arquivos
- **share_plus:** ^10.1.4 - Compartir arquivos
- **path_provider:** ^2.1.5 - Acceso a directorios do sistema
- **uuid:** ^4.0.0 - Xeración de IDs únicos

### 4.2 Dependencias Específicas por Plataforma

#### Android

Non se requiren pasos adicionais. As dependencias de Android descargaranse automaticamente na primeira compilación.

#### iOS (só macOS)

Instala as dependencias de CocoaPods:

```bash
cd ios
pod install
cd ..
```

Se atopas erros, tenta actualizar o repositorio de CocoaPods:

```bash
cd ios
pod repo update
pod install
cd ..
```

---

## 5. Configuración do Entorno

### 5.1 Variables de Entorno

MedicApp non require variables de entorno especiais para executarse en desenvolvemento.

### 5.2 Permisos de Android

O arquivo `android/app/src/main/AndroidManifest.xml` xa inclúe os permisos necesarios:

```xml
<!-- Permisos para notificacións -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
```

**Importante para Android 13+ (API 33+):**

Os usuarios deberán conceder permiso de notificacións en tempo de execución. A aplicación solicitará este permiso automaticamente no primeiro inicio.

**Alarmas exactas (Android 12+):**

Para programar notificacións precisas, os usuarios deben habilitar "Alarmas e recordatorios" na configuración do sistema:
- Configuración > Aplicacións > MedicApp > Alarmas e recordatorios > Activar

### 5.3 Configuración de iOS

#### Permisos en Info.plist

Se estás a desenvolver para iOS, asegúrate de que `ios/Runner/Info.plist` conteña:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

#### Capacidades de Notificacións

As notificacións están configuradas automaticamente polo plugin `flutter_local_notifications`.

---

## 6. Execución en Desenvolvemento

### 6.1 Listar Dispositivos Dispoñibles

Antes de executar a aplicación, lista os dispositivos conectados:

```bash
flutter devices
```

Isto mostrará:
- Dispositivos Android conectados por USB
- Emuladores Android dispoñibles
- Simuladores iOS (só macOS)
- Navegadores web dispoñibles

### 6.2 Iniciar un Emulador/Simulador

#### Android Emulator:
```bash
flutter emulators
flutter emulators --launch <emulator-id>
```

#### iOS Simulator (só macOS):
```bash
open -a Simulator
```

### 6.3 Executar a Aplicación

#### Modo Debug (predeterminado):
```bash
flutter run
```

Este modo inclúe:
- Hot reload (recarga en quente)
- Hot restart (reinicio en quente)
- Debugging completo
- Rendemento máis lento

**Atallos útiles durante a execución:**
- `r` - Hot reload (recarga o código cambiado)
- `R` - Hot restart (reinicia a aplicación completa)
- `q` - Saír da aplicación

#### Modo Release:
```bash
flutter run --release
```

Este modo inclúe:
- Rendemento optimizado
- Sen debugging
- Tamaño reducido

#### Modo Profile:
```bash
flutter run --profile
```

Este modo é útil para:
- Análise de rendemento
- Debugging de rendemento
- Timeline tools

### 6.4 Executar nun Dispositivo Específico

Se tes múltiples dispositivos conectados:

```bash
flutter run -d <device-id>
```

Exemplo:
```bash
flutter run -d emulator-5554
flutter run -d "iPhone 14 Pro"
```

### 6.5 Executar con Logs Detallados

Para ver logs máis detallados:

```bash
flutter run -v
```

---

## 7. Execución de Tests

MedicApp inclúe unha suite completa de tests con máis de 432 probas.

### 7.1 Executar Todos os Tests

```bash
flutter test
```

### 7.2 Executar un Test Específico

```bash
flutter test test/nome_do_arquivo_test.dart
```

Exemplos:
```bash
flutter test test/settings_screen_test.dart
flutter test test/notification_actions_test.dart
flutter test test/multiple_fasting_prioritization_test.dart
```

### 7.3 Executar Tests con Cobertura

Para xerar un reporte de cobertura de código:

```bash
flutter test --coverage
```

O reporte xerarase en `coverage/lcov.info`.

### 7.4 Ver o Reporte de Cobertura

Para visualizar o reporte de cobertura en HTML:

```bash
# Instalar lcov (Linux/macOS)
sudo apt-get install lcov  # Linux
brew install lcov          # macOS

# Xerar reporte HTML
genhtml coverage/lcov.info -o coverage/html

# Abrir o reporte
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
start coverage/html/index.html  # Windows
```

### 7.5 Executar Tests con Logs Detallados

```bash
flutter test --verbose
```

---

## 8. Build para Produción

### 8.1 Android

#### APK (para distribución directa):

```bash
flutter build apk --release
```

O APK xerarase en: `build/app/outputs/flutter-apk/app-release.apk`

#### APK Split por ABI (reduce tamaño):

```bash
flutter build apk --split-per-abi --release
```

Isto xera múltiples APKs optimizados:
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM)
- `app-x86_64-release.apk` (64-bit Intel)

#### App Bundle (para Google Play Store):

```bash
flutter build appbundle --release
```

O App Bundle xerarase en: `build/app/outputs/bundle/release/app-release.aab`

**Vantaxes do App Bundle:**
- Tamaño de descarga optimizado
- Google Play xera APKs específicos para cada dispositivo
- Requirido para novas aplicacións en Play Store

#### Configuración de Firma para Android

Para builds de produción, necesitas configurar a firma da aplicación:

1. Xera un keystore:
   ```bash
   keytool -genkey -v -keystore ~/medicapp-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias medicapp
   ```

2. Crea o arquivo `android/key.properties`:
   ```properties
   storePassword=<túa-contrasinal>
   keyPassword=<túa-contrasinal>
   keyAlias=medicapp
   storeFile=/ruta/a/medicapp-release-key.jks
   ```

3. Actualiza `android/app/build.gradle.kts` para usar o keystore (xa está configurado no proxecto).

**IMPORTANTE:** Non inclúas `key.properties` nin o arquivo `.jks` no control de versións.

### 8.2 iOS (só macOS)

#### Build para Testing:

```bash
flutter build ios --release
```

#### Build para App Store:

```bash
flutter build ipa --release
```

O arquivo IPA xerarase en: `build/ios/ipa/medicapp.ipa`

#### Configuración de Firma para iOS

1. Abre o proxecto en Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. Configura o equipo de firma:
   - Selecciona o proxecto "Runner" no navegador
   - Vai a "Signing & Capabilities"
   - Selecciona o teu equipo de desenvolvemento de Apple
   - Configura o Bundle Identifier único

3. Crea un perfil de aprovisionamento en Apple Developer

4. Archive e distribúe desde Xcode:
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

# Limpar caché
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

#### Android: Notificacións non funcionan

**Verificar:**
1. O permiso POST_NOTIFICATIONS está en AndroidManifest.xml
2. O usuario concedeu permisos de notificación en Android 13+
3. As alarmas exactas están habilitadas en Configuración

**Solución programática:**
A app solicita permisos automaticamente. Se o usuario os denegou:
```dart
// A app inclúe un botón para abrir a configuración
// Configuración > Permisos > Notificacións
```

#### Android: Alarmas exactas non funcionan

**Síntomas:**
- As notificacións chegan tarde
- As notificacións non chegan á hora exacta

**Solución:**
1. Abre Configuración do sistema
2. Aplicacións > MedicApp > Alarmas e recordatorios
3. Activa a opción

A app inclúe un botón de axuda que dirixe ao usuario a esta configuración.

### 9.3 Problemas con Base de Datos

#### Error: "Database locked" ou "Cannot open database"

**Causa:** A base de datos SQLite está sendo accedida por múltiples procesos.

**Solución:**
```bash
# Reinstalar a aplicación
flutter clean
flutter run
```

#### Error: Migracións de base de datos fallan

**Verificar:**
1. O número de versión da base de datos en `database_helper.dart`
2. Os scripts de migración están completos

**Solución:**
```bash
# Desinstalar a aplicación do dispositivo
adb uninstall com.medicapp.medicapp  # Android
# Reinstalar
flutter run
```

### 9.4 Problemas con Notificacións

#### As notificacións non se reprograman despois de reiniciar

**Verificar:**
1. O permiso RECEIVE_BOOT_COMPLETED está en AndroidManifest.xml
2. O receiver de boot está rexistrado

**Solución:**
O arquivo `AndroidManifest.xml` xa inclúe a configuración necesaria:
```xml
<receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver"
    android:exported="false">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
    </intent-filter>
</receiver>
```

#### As notificacións non fan son/vibración

**Verificar:**
1. O volume do dispositivo non está en silencio
2. O modo "Non molestar" está desactivado
3. Os permisos de vibración están concedidos

### 9.5 Problemas de Compilación

#### Error: "Gradle build failed"

**Solución:**
```bash
# Limpar proxecto
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

#### Error: "Execution failed for task ':app:processDebugResources'"

**Causa:** Recursos duplicados ou conflitos.

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
1. A versión de Flutter: `flutter --version`
2. O arquivo `pubspec.yaml` require: `sdk: ^3.9.2`

**Solución:**
```bash
flutter upgrade
flutter doctor
```

### 9.6 Problemas de Rendemento

#### A aplicación é lenta en modo debug

**Explicación:**
Isto é normal. O modo debug inclúe ferramentas de desenvolvemento que reducen o rendemento.

**Solución:**
Proba en modo release para avaliar o rendemento real:
```bash
flutter run --release
```

#### Hot reload non funciona

**Solución:**
```bash
# Reinicia a aplicación
# Na terminal onde executaches 'flutter run', preme:
R  # (maiúscula) para hot restart
```

### 9.7 Problemas de Conectividade de Dispositivos

#### O dispositivo non aparece en `flutter devices`

**Android:**
```bash
# Verificar conexión ADB
adb devices

# Reiniciar servidor ADB
adb kill-server
adb start-server

# Verificar de novo
flutter devices
```

**iOS:**
```bash
# Verificar dispositivos conectados
instruments -s devices

# Confiar na computadora desde o dispositivo iOS
```

---

## 10. Recursos Adicionais

### Documentación Oficial

- **Flutter:** https://docs.flutter.dev/
- **Dart:** https://dart.dev/guides
- **Material Design 3:** https://m3.material.io/

### Plugins Utilizados

- **sqflite:** https://pub.dev/packages/sqflite
- **flutter_local_notifications:** https://pub.dev/packages/flutter_local_notifications
- **timezone:** https://pub.dev/packages/timezone
- **intl:** https://pub.dev/packages/intl

### Comunidade e Soporte

- **Flutter Community:** https://flutter.dev/community
- **Stack Overflow:** https://stackoverflow.com/questions/tagged/flutter
- **GitHub Issues:** (Repositorio do proxecto)

---

## 11. Próximos Pasos

Unha vez completada a instalación:

1. **Explora o código:**
   - Revisa a estrutura do proxecto en `lib/`
   - Examina os tests en `test/`

2. **Executa a aplicación:**
   ```bash
   flutter run
   ```

3. **Executa os tests:**
   ```bash
   flutter test
   ```

4. **Le a documentación adicional:**
   - [README.md](../README.md)
   - [Arquitectura do Proxecto](architecture.md) (se existe)
   - [Guía de Contribución](contributing.md) (se existe)

---

## Contacto e Axuda

Se atopas problemas non cubertos nesta guía, por favor:

1. Revisa os issues existentes no repositorio
2. Executa `flutter doctor -v` e comparte o resultado
3. Inclúe logs completos do erro
4. Describe os pasos para reproducir o problema

---

**Última actualización:** Novembro 2024
**Versión do documento:** 1.0.0
**Versión de MedicApp:** 1.0.0+1
