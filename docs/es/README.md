# MedicApp

[![Tests](https://img.shields.io/badge/tests-432%2B-brightgreen)](../../test)
[![Cobertura](https://img.shields.io/badge/cobertura-75--80%25-green)](../../test)
[![Flutter](https://img.shields.io/badge/Flutter-3.9.2%2B-02569B?logo=flutter)](https://flutter.dev)
[![Material Design](https://img.shields.io/badge/Material%20Design-3-757575?logo=material-design)](https://m3.material.io)
[![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?logo=dart)](https://dart.dev)
[![SQLite](https://img.shields.io/badge/SQLite-3-003B57?logo=sqlite)](https://www.sqlite.org)

**MedicApp** es una aplicación móvil completa de gestión de medicamentos desarrollada con Flutter, diseñada para ayudar a usuarios y cuidadores a organizar y controlar la administración de medicamentos para múltiples personas de forma eficiente y segura.

---

## Tabla de Contenidos

- [Descripción del Proyecto](#descripción-del-proyecto)
- [Características Principales](#características-principales)
- [Capturas de Pantalla](#capturas-de-pantalla)
- [Inicio Rápido](#inicio-rápido)
- [Documentación](#documentación)
- [Estado del Proyecto](#estado-del-proyecto)
- [Licencia](#licencia)

---

## Descripción del Proyecto

MedicApp es una solución integral para la gestión de medicamentos que permite a los usuarios administrar tratamientos médicos para múltiples personas desde una única aplicación. Diseñada con un enfoque en la usabilidad y la accesibilidad, MedicApp facilita el seguimiento de horarios de tomas, control de stock, gestión de períodos de ayuno y notificaciones inteligentes.

La aplicación implementa arquitectura limpia con separación de responsabilidades, gestión de estado con Provider, y una base de datos SQLite robusta que garantiza la persistencia y sincronización de datos. Con soporte para 8 idiomas y Material Design 3, MedicApp ofrece una experiencia moderna y accesible para usuarios de todo el mundo.

Ideal para pacientes con tratamientos complejos, cuidadores profesionales, familias que gestionan la medicación de varios miembros, y cualquier persona que necesite un sistema confiable de recordatorios y seguimiento de medicamentos.

---

## Características Principales

### 1. **Gestión Multi-Persona**
Administre medicamentos para múltiples personas desde una sola aplicación. Cada persona tiene su propio perfil, medicamentos, tomas registradas y estadísticas independientes (Base de datos V19+).

### 2. **14 Tipos de Medicamentos**
Soporte completo para diversos tipos de medicamentos: Tableta, Cápsula, Jarabe, Inyección, Inhalador, Crema, Gotas, Parche, Supositorio, Spray, Polvo, Gel, Apósito y Otro.

### 3. **Notificaciones Inteligentes**
Sistema de notificaciones avanzado con acciones rápidas (Tomar/Posponer/Omitir), limitación automática a 5 notificaciones activas, y notificaciones ongoing para períodos de ayuno en curso.

### 4. **Control de Stock Avanzado**
Seguimiento automático de stock con alertas configurables, notificaciones de stock bajo, y recordatorios para renovar medicamentos antes de que se agoten.

### 5. **Gestión de Períodos de Ayuno**
Configure períodos de ayuno pre/post medicamento con notificaciones ongoing, validación de horarios, y alertas inteligentes que solo muestran ayunos en curso o futuros.

### 6. **Historial Completo de Tomas**
Registro detallado de todas las tomas con estados (Tomado, Omitido, Pospuesto), timestamps precisos, integración con stock, y estadísticas de adherencia por persona.

### 7. **Interfaz Multiidioma**
Soporte completo para 8 idiomas: Español, Inglés, Francés, Alemán, Italiano, Portugués, Catalán y Euskera, con cambio dinámico sin reiniciar la aplicación.

### 8. **Material Design 3**
Interfaz moderna con tema claro/oscuro, componentes adaptativos, animaciones fluidas, y diseño responsive que se adapta a diferentes tamaños de pantalla.

### 9. **Base de Datos Robusta**
SQLite V19 con migraciones automáticas, índices optimizados, validación de integridad referencial, y sistema completo de triggers para mantener consistencia de datos.

### 10. **Testing Exhaustivo**
Más de 432 tests automatizados (75-80% cobertura) incluyendo tests unitarios, de widgets, de integración, y tests específicos para casos edge como notificaciones a medianoche.

---

## Capturas de Pantalla

_Sección reservada para futuras capturas de pantalla de la aplicación._

---

## Inicio Rápido

### Requisitos Previos
- Flutter 3.9.2 o superior
- Dart 3.0 o superior
- Android Studio / VS Code con extensiones de Flutter

### Instalación

```bash
# Clonar el repositorio
git clone <repository-url>
cd medicapp

# Instalar dependencias
flutter pub get

# Ejecutar la aplicación
flutter run

# Ejecutar tests
flutter test

# Generar reporte de cobertura
flutter test --coverage
```

---

## Documentación

La documentación completa del proyecto está disponible en el directorio `docs/es/`:

- **[Guía de Instalación](installation.md)** - Requisitos, instalación y configuración inicial
- **[Características](features.md)** - Documentación detallada de todas las funcionalidades
- **[Arquitectura](architecture.md)** - Estructura del proyecto, patrones y decisiones de diseño
- **[Base de Datos](database.md)** - Esquema, migraciones, triggers y optimizaciones
- **[Estructura del Proyecto](project-structure.md)** - Organización de archivos y directorios
- **[Tecnologías](technologies.md)** - Stack tecnológico y dependencias utilizadas
- **[Testing](testing.md)** - Estrategia de testing, tipos de tests y guías de contribución
- **[Contribución](contributing.md)** - Guías para contribuir al proyecto
- **[Solución de Problemas](troubleshooting.md)** - Problemas comunes y soluciones

---

## Estado del Proyecto

- **Versión Base de Datos**: V19 (con soporte multi-persona)
- **Tests**: 432+ tests automatizados
- **Cobertura**: 75-80%
- **Idiomas Soportados**: 8 (ES, EN, FR, DE, IT, PT, CA, EU)
- **Tipos de Medicamentos**: 14
- **Flutter**: 3.9.2+
- **Material Design**: 3
- **Estado**: En desarrollo activo

---

## Licencia

Este proyecto está licenciado bajo la [GNU Affero General Public License v3.0 (AGPL-3.0)](../../LICENSE).

La AGPL-3.0 es una licencia de software libre copyleft que requiere que cualquier versión modificada del software que se ejecute en un servidor de red también esté disponible como código abierto.

---

**Desarrollado con Flutter y Material Design 3**
