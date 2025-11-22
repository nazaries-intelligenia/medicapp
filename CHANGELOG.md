# Changelog

Todos los cambios notables en este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [Unreleased]

### Added
- **Sistema de paletas de colores** con selección por usuario
  - Paleta "Sea Green": Tonos verdes naturales inspirados en el bosque (por defecto)
  - Paleta "Material 3": Paleta púrpura baseline de Material Design 3 (#6750A4)
  - Selector de paleta en pantalla de Ajustes (sección Apariencia)
  - Persistencia de preferencia de paleta del usuario
  - Soporte completo para temas claro y oscuro en ambas paletas
- **Selector de tono de notificación** (solo Android)
  - Botón en Ajustes que abre la configuración de notificaciones del sistema
  - Permite personalizar sonido, vibración y más opciones de notificación
  - Solo visible en Android (iOS no permite personalización por app)
- Gestión de estado con Provider para el tema y paletas
  - `ThemeProvider` con `ChangeNotifierProvider`
  - Soporte para `Consumer` en toda la aplicación
- Widget extensions para reducir boilerplate (`lib/utils/widget_extensions.dart`)
  - Extensions para `SizedBox`: `.verticalSpace`, `.horizontalSpace`
  - Extensions para `EdgeInsets`: `.allPadding`, `.verticalPadding`, `.horizontalPadding`
  - Extensions para `BorderRadius`: `.circular`, `.roundedShape`
  - Constantes útiles: `AppSpacing`, `AppPadding`, `AppBorderRadius`

### Fixed
- Integración correcta de `ThemeProvider` en el árbol de widgets principal
- Provider disponible para todos los widgets mediante `ChangeNotifierProvider`
- Tests actualizados para incluir `ThemeProvider` en configuración de test
- Uso de `AndroidIntent` en lugar de método inexistente para abrir ajustes de notificación

### Changed
- **Arquitectura de temas** refactorizada para soportar múltiples paletas
  - Nuevos métodos `getLightTheme()` y `getDarkTheme()` que aceptan paleta como parámetro
  - Métodos privados `_buildSeaGreenLightTheme()` y `_buildSeaGreenDarkTheme()`
  - Métodos privados `_buildMaterial3LightTheme()` y `_buildMaterial3DarkTheme()`
  - Enum `ColorPalette` con extensiones para nombres y descripciones localizadas
- `PreferencesService` extendido para persistir paleta de colores y tono de notificación
- `ThemeProvider` ahora gestiona tanto el modo de tema como la paleta de colores
- Actualizado Dart SDK de 3.9.2 a 3.10.0 para aprovechar nuevas características
- Refactorizado `MedicationType` con switch expressions de Dart 3.10
  - Reducción de 187 a 106 líneas (43% menos código)
  - 5 getters modernizados usando dot shorthand syntax
  - Código más limpio y mantenible
- Refactorizado `TreatmentDurationType` con switch expressions de Dart 3.10
  - Reducción de 49 a 33 líneas (33% menos código)
  - 2 getters modernizados
- Modernizado `SnackBarService` eliminando código repetido
  - Nuevo enum interno `_SnackBarType` con switch expressions
  - Consolidada lógica común en método privado `_show()`
  - 4 métodos públicos reducidos a 1 línea cada uno
  - Reducción de ~150 líneas a ~40 líneas de lógica (73% menos código)
  - Usa nuevas widget extensions para mayor consistencia

### Technical Improvements
- Total de ~200+ líneas de código eliminadas
- Aprovecha características modernas de Dart 3.10:
  - Switch expressions
  - Dot shorthand syntax para enums
  - Pattern matching mejorado
- Mejor mantenibilidad y legibilidad del código
- Código más idiomático y conforme a las mejores prácticas de Dart moderno

## [1.0.0] - 2025-11-18

### Initial Release
- Sistema de gestión multi-persona para medicamentos
- 14 tipos de medicamentos soportados
- Notificaciones inteligentes con soporte de ayuno
- Control de stock (Pastillero)
- Seguimiento de fechas de caducidad
- Historial automático de dosis
- 8 idiomas soportados (ES, EN, CA, DE, EU, FR, GL, IT)
- 570+ tests con >80% de cobertura
