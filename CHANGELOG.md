# Changelog

Todos los cambios notables en este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [Unreleased]

### Added
- Widget extensions para reducir boilerplate (`lib/utils/widget_extensions.dart`)
  - Extensions para `SizedBox`: `.verticalSpace`, `.horizontalSpace`
  - Extensions para `EdgeInsets`: `.allPadding`, `.verticalPadding`, `.horizontalPadding`
  - Extensions para `BorderRadius`: `.circular`, `.roundedShape`
  - Constantes útiles: `AppSpacing`, `AppPadding`, `AppBorderRadius`

### Changed
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
