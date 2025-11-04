# MedicApp

MedicApp es una aplicación de recordatorio de medicamentos construida con Flutter. Te ayuda a gestionar tus tratamientos médicos, programar recordatorios y llevar un control de tu inventario de medicamentos.

**Novedades V19+**: Ahora con soporte multi-persona para gestionar medicamentos de toda la familia desde una única aplicación.

## Estado del Proyecto

![Tests](https://img.shields.io/badge/tests-389%20passing-success)
![Cobertura](https://img.shields.io/badge/coverage-45.7%25-yellow)
![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-blue)
![Material Design](https://img.shields.io/badge/Material%20Design-3-purple)

### Calidad de Código

- **Suite de tests completa**: 389 tests cubriendo modelos, servicios, persistencia y widgets
- **Arquitectura modular**: Aplicación de principios KISS y DRY con reducción del 39.3% en código de pantallas principales
- **Test helpers optimizados**: MedicationBuilder pattern con 100% de adopción, reducción de 40-60% en código de tests
- **Cobertura**: 45.7% (2710 de 5927 líneas)
- **Internacionalización**: 5 idiomas soportados (ES, EN, CA, GL, EU)

### Refactorización Reciente (Octubre 2025)

La suite de tests ha sido completamente refactorizada para ser más limpia, rápida y mantenible:

- **MedicationBuilder**: 100% de tests migrados al patrón builder
- **Eliminación de redundancia**: 20+ tests duplicados removidos, ~480 líneas eliminadas
- **Performance**: Suite 35% más rápida sin pérdida de cobertura
- **Helpers unificados**: DatabaseTestHelper, test_helpers, medication_builder
- **Assertions mejoradas**: Reemplazo de assertions débiles por validaciones reales

### Arquitectura Multi-Persona V19+ (Noviembre 2025)

Migración completa a arquitectura muchos-a-muchos para soporte de múltiples usuarios:

- **3 tablas principales**: `persons`, `person_medications` (muchos-a-muchos), `medications`
- **Separación de datos**: Información compartida (nombre, stock) vs. configuración por persona (horarios, seguimiento)
- **Migración automática**: Sistema robusto que preserva datos existentes al actualizar
- **Notificaciones por persona**: Cada persona recibe sus propias notificaciones con su configuración
- **Tests actualizados**: 6 tests corregidos para adaptarse a la nueva arquitectura
- **Retrocompatibilidad**: API legacy sigue funcionando para transición suave

## Documentación

- [Tecnologías](TECNOLOGIAS.md): Describe las tecnologías, librerías y herramientas utilizadas en el desarrollo de la aplicación
- [Instalación](INSTALACION.md): Guía paso a paso para clonar el repositorio, instalar las dependencias y ejecutar la aplicación
- [Tests](TESTS.md): Detalla la suite de tests del proyecto, que cubre modelos, servicios, persistencia y widgets
- [Estructura del proyecto](ESTRUCTURA.md): Ofrece una visión general de cómo está organizado el código fuente en la carpeta `lib/`
- [Base de datos](BASE_DE_DATOS.md): Explica el esquema de la base de datos SQLite con arquitectura multi-persona, incluyendo las tablas `persons`, `person_medications`, `medications` y `dose_history`, y el sistema de migración automática
- [Arquitectura Multi-Persona](ARQUITECTURA_MULTI_PERSONA.md): Documentación técnica completa de la arquitectura V19+, incluyendo modelo de datos, flujos de uso, gestión de notificaciones, migración automática y decisiones de diseño
- [Funcionalidades](FUNCIONALIDADES.md): Presenta un listado completo de las características de la aplicación, desde la gestión de medicamentos hasta el seguimiento del historial de dosis
