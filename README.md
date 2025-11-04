# MedicApp

MedicApp es una aplicación de recordatorio de medicamentos construida con Flutter. Te ayuda a gestionar tus tratamientos médicos, programar recordatorios y llevar un control de tu inventario de medicamentos.

**Novedades V19+**: Ahora con soporte multi-persona para gestionar medicamentos de toda la familia desde una única aplicación.

## Estado del Proyecto

![Tests](https://img.shields.io/badge/tests-432%20passing-success)
![Cobertura](https://img.shields.io/badge/coverage-75--80%25-green)
![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-blue)
![Material Design](https://img.shields.io/badge/Material%20Design-3-purple)

### Calidad de Código

- **Suite de tests completa**: ~432 tests cubriendo modelos, servicios, persistencia y widgets
- **Arquitectura modular**: Aplicación de principios KISS y DRY en pantallas y componentes
- **Test helpers optimizados**: MedicationBuilder pattern con 100% de adopción en la suite de tests
- **Cobertura**: ~75-80% estimada
- **Internacionalización**: 5 idiomas soportados (ES, EN, CA, GL, EU)

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
