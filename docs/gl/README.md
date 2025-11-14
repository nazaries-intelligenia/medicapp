# MedicApp

[![Tests](https://img.shields.io/badge/tests-432%2B-brightgreen)](../../test)
[![Cobertura](https://img.shields.io/badge/cobertura-75--80%25-green)](../../test)
[![Flutter](https://img.shields.io/badge/Flutter-3.9.2%2B-02569B?logo=flutter)](https://flutter.dev)
[![Material Design](https://img.shields.io/badge/Material%20Design-3-757575?logo=material-design)](https://m3.material.io)
[![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?logo=dart)](https://dart.dev)
[![SQLite](https://img.shields.io/badge/SQLite-3-003B57?logo=sqlite)](https://www.sqlite.org)

**MedicApp** é unha aplicación móbil completa de xestión de medicamentos desenvolvida con Flutter, deseñada para axudar a usuarios e coidadores a organizar e controlar a administración de medicamentos para múltiples persoas de forma eficiente e segura.

---

## Táboa de Contidos

- [Descrición do Proxecto](#descrición-do-proxecto)
- [Características Principais](#características-principais)
- [Capturas de Pantalla](#capturas-de-pantalla)
- [Inicio Rápido](#inicio-rápido)
- [Documentación](#documentación)
- [Estado do Proxecto](#estado-do-proxecto)
- [Licenza](#licenza)

---

## Descrición do Proxecto

MedicApp é unha solución integral para a xestión de medicamentos que permite aos usuarios administrar tratamentos médicos para múltiples persoas desde unha única aplicación. Deseñada cun enfoque na usabilidade e a accesibilidade, MedicApp facilita o seguimento de horarios de tomas, control de stock, xestión de períodos de xaxún e notificacións intelixentes.

A aplicación implementa arquitectura limpa con separación de responsabilidades, xestión de estado con Provider, e unha base de datos SQLite robusta que garante a persistencia e sincronización de datos. Con soporte para 8 idiomas e Material Design 3, MedicApp ofrece unha experiencia moderna e accesible para usuarios de todo o mundo.

Ideal para pacientes con tratamentos complexos, coidadores profesionais, familias que xestionan a medicación de varios membros, e calquera persoa que necesite un sistema fiable de recordatorios e seguimento de medicamentos.

---

## Características Principais

### 1. **Xestión Multi-Persoa**
Administre medicamentos para múltiples persoas desde unha soa aplicación. Cada persoa ten o seu propio perfil, medicamentos, tomas rexistradas e estatísticas independentes (Base de datos V19+).

### 2. **14 Tipos de Medicamentos**
Soporte completo para diversos tipos de medicamentos: Tableta, Cápsula, Xarope, Inxección, Inhalador, Crema, Gotas, Parche, Supositorio, Spray, Po, Xel, Apósito e Outro.

### 3. **Notificacións Intelixentes**
Sistema de notificacións avanzado con accións rápidas (Tomar/Pospor/Omitir), limitación automática a 5 notificacións activas, e notificacións ongoing para períodos de xaxún en curso.

### 4. **Control de Stock Avanzado**
Seguimento automático de stock con alertas configurables, notificacións de stock baixo, e recordatorios para renovar medicamentos antes de que se esgoten.

### 5. **Xestión de Períodos de Xaxún**
Configure períodos de xaxún pre/post medicamento con notificacións ongoing, validación de horarios, e alertas intelixentes que só mostran xaxúns en curso ou futuros.

### 6. **Historial Completo de Tomas**
Rexistro detallado de todas as tomas con estados (Tomado, Omitido, Posposto), timestamps precisos, integración con stock, e estatísticas de adherencia por persoa.

### 7. **Interface Multiidioma**
Soporte completo para 8 idiomas: Español, Inglés, Francés, Alemán, Italiano, Portugués, Catalán e Éuscaro, con cambio dinámico sen reiniciar a aplicación.

### 8. **Material Design 3**
Interface moderna con tema claro/escuro, compoñentes adaptativos, animacións fluídas, e deseño responsive que se adapta a diferentes tamaños de pantalla.

### 9. **Base de Datos Robusta**
SQLite V19 con migracións automáticas, índices optimizados, validación de integridade referencial, e sistema completo de triggers para manter consistencia de datos.

### 10. **Testing Exhaustivo**
Máis de 432 tests automatizados (75-80% cobertura) incluíndo tests unitarios, de widgets, de integración, e tests específicos para casos edge como notificacións á medianoite.

---

## Capturas de Pantalla

_Sección reservada para futuras capturas de pantalla da aplicación._

---

## Inicio Rápido

### Requisitos Previos
- Flutter 3.9.2 ou superior
- Dart 3.0 ou superior
- Android Studio / VS Code con extensións de Flutter

### Instalación

```bash
# Clonar o repositorio
git clone <repository-url>
cd medicapp

# Instalar dependencias
flutter pub get

# Executar a aplicación
flutter run

# Executar tests
flutter test

# Xerar reporte de cobertura
flutter test --coverage
```

---

## Documentación

A documentación completa do proxecto está dispoñible no directorio `docs/gl/`:

- **[Guía de Instalación](installation.md)** - Requisitos, instalación e configuración inicial
- **[Características](features.md)** - Documentación detallada de todas as funcionalidades
- **[Arquitectura](architecture.md)** - Estrutura do proxecto, patróns e decisións de deseño
- **[Base de Datos](database.md)** - Esquema, migracións, triggers e optimizacións
- **[Estrutura do Proxecto](project-structure.md)** - Organización de arquivos e directorios
- **[Tecnoloxías](technologies.md)** - Stack tecnolóxico e dependencias utilizadas
- **[Testing](testing.md)** - Estratexia de testing, tipos de tests e guías de contribución
- **[Contribución](contributing.md)** - Guías para contribuír ao proxecto
- **[Solución de Problemas](troubleshooting.md)** - Problemas comúns e solucións

---

## Estado do Proxecto

- **Versión Base de Datos**: V19 (con soporte multi-persoa)
- **Tests**: 432+ tests automatizados
- **Cobertura**: 75-80%
- **Idiomas Soportados**: 8 (ES, EN, FR, DE, IT, PT, CA, EU)
- **Tipos de Medicamentos**: 14
- **Flutter**: 3.9.2+
- **Material Design**: 3
- **Estado**: En desenvolvemento activo

---

## Licenza

Este proxecto está licenciado baixo a [GNU Affero General Public License v3.0 (AGPL-3.0)](../../LICENSE).

A AGPL-3.0 é unha licenza de software libre copyleft que require que calquera versión modificada do software que se execute nun servidor de rede tamén estea dispoñible como código aberto.

---

**Desenvolvido con Flutter e Material Design 3**
