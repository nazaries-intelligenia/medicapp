# MedicApp

[![Tests](https://img.shields.io/badge/tests-570%2B-brightgreen)](../../test)
[![Cobertura](https://img.shields.io/badge/cobertura-%3E80%25-green)](../../test)
[![Flutter](https://img.shields.io/badge/Flutter-3.9.2%2B-02569B?logo=flutter)](https://flutter.dev)
[![Material Design](https://img.shields.io/badge/Material%20Design-3-757575?logo=material-design)](https://m3.material.io)
[![Dart](https://img.shields.io/badge/Dart-3.10.0-0175C2?logo=dart)](https://dart.dev)
[![SQLite](https://img.shields.io/badge/SQLite-3-003B57?logo=sqlite)](https://www.sqlite.org)

**MedicApp** és una aplicació mòbil completa de gestió de medicaments desenvolupada amb Flutter, dissenyada per ajudar a usuaris i cuidadors a organitzar i controlar l'administració de medicaments per a múltiples persones de forma eficient i segura.

---

## Taula de Continguts

- [Descripció del Projecte](#descripció-del-projecte)
- [Característiques Principals](#característiques-principals)
- [Captures de Pantalla](#captures-de-pantalla)
- [Inici Ràpid](#inici-ràpid)
- [Documentació](#documentació)
- [Estat del Projecte](#estat-del-projecte)
- [Llicència](#llicència)

---

## Descripció del Projecte

MedicApp és una solució integral per a la gestió de medicaments que permet als usuaris administrar tractaments mèdics per a múltiples persones des d'una única aplicació. Dissenyada amb un enfocament en la usabilitat i l'accessibilitat, MedicApp facilita el seguiment d'horaris de preses, control d'estoc, gestió de períodes de dejuni i notificacions intel·ligents.

L'aplicació implementa arquitectura neta amb separació de responsabilitats, gestió d'estat amb Provider, i una base de dades SQLite robusta que garanteix la persistència i sincronització de dades. Amb suport per a 8 idiomes i Material Design 3, MedicApp ofereix una experiència moderna i accessible per a usuaris de tot el món.

Ideal per a pacients amb tractaments complexos, cuidadors professionals, famílies que gestionen la medicació de diversos membres, i qualsevol persona que necessiti un sistema fiable de recordatoris i seguiment de medicaments.

---

## Característiques Principals

### 1. **Gestió Multi-Persona**
Administri medicaments per a múltiples persones des d'una sola aplicació. Cada persona té el seu propi perfil, medicaments, preses registrades i estadístiques independents (Base de dades V19+).

### 2. **14 Tipus de Medicaments**
Suport complet per a diversos tipus de medicaments: Pastilla, Càpsula, Xarop, Injecció, Inhalador, Crema, Gotes, Pedaç, Supositòri, Esprai, Pols, Gel, Apòsit i Altre.

### 3. **Notificacions Intel·ligents**
Sistema de notificacions avançat amb accions ràpides (Prendre/Ajornar/Ometre), limitació automàtica a 5 notificacions actives, i notificacions contínues per a períodes de dejuni en curs.

### 4. **Control d'Estoc Avançat**
Seguiment automàtic d'estoc amb alertes configurables, notificacions d'estoc baix, i recordatoris per renovar medicaments abans que s'acabin.

### 5. **Gestió de Períodes de Dejuni**
Configuri períodes de dejuni pre/post medicament amb notificacions contínues, validació d'horaris, i alertes intel·ligents que només mostren dejunis en curs o futurs.

### 6. **Historial Complet de Preses**
Registre detallat de totes les preses amb estats (Pres, Omès, Ajornat), timestamps precisos, integració amb estoc, i estadístiques d'adherència per persona.

### 7. **Interfície Multiidioma**
Suport complet per a 8 idiomes: Espanyol, Anglès, Francès, Alemany, Italià, Portuguès, Català i Euskera, amb canvi dinàmic sense reiniciar l'aplicació.

### 8. **Material Design 3**
Interfície moderna amb tema clar/fosc, components adaptatius, animacions fluides, i disseny responsiu que s'adapta a diferents mides de pantalla.

### 9. **Base de Dades Robusta**
SQLite V19 amb migracions automàtiques, índexs optimitzats, validació d'integritat referencial, i sistema complet de triggers per mantenir consistència de dades.

### 10. **Testing Exhaustiu**
Més de 570 tests automatitzats (>80% cobertura) incloent tests unitaris, de widgets, d'integració, i tests específics per a casos límit com notificacions a mitjanit.

### 11. **Sistema de Personalització d'Aparença**
Triï entre múltiples paletes de colors segons les seves preferències:
- **Sea Green**: Tons verds naturals inspirats en el bosc (per defecte)
- **Material 3**: Paleta porpra baseline de Material Design 3 (#6750A4)
- Selector intuïtiu a la pantalla d'Ajustos amb vista prèvia
- Persistència de preferència per usuari
- Suport complet per a temes clar i fosc en ambdues paletes

### 12. **Configuració de Notificacions (Android)**
Personalitzi completament el so i comportament de les notificacions:
- Accés directe als ajustos de notificació del sistema des de l'app
- Configuri to, vibració, prioritat i més opcions avançades
- Gestió per canals de notificació (Android 8.0+)
- Opció oculta automàticament en plataformes no compatibles (iOS)

---

## Captures de Pantalla

_Secció reservada per a futures captures de pantalla de l'aplicació._

---

## Inici Ràpid

### Requisits Previs
- Flutter 3.9.2 o superior
- Dart 3.10.0 o superior
- Android Studio / VS Code amb extensions de Flutter

### Instal·lació

```bash
# Clonar el repositori
git clone <repository-url>
cd medicapp

# Instal·lar dependències
flutter pub get

# Executar l'aplicació
flutter run

# Executar tests
flutter test

# Generar informe de cobertura
flutter test --coverage
```

---

## Documentació

La documentació completa del projecte està disponible al directori `docs/ca/`:

- **[Guia d'Instal·lació](installation.md)** - Requisits, instal·lació i configuració inicial
- **[Característiques](features.md)** - Documentació detallada de totes les funcionalitats
- **[Arquitectura](architecture.md)** - Estructura del projecte, patrons i decisions de disseny
- **[Base de Dades](database.md)** - Esquema, migracions, triggers i optimitzacions
- **[Estructura del Projecte](project-structure.md)** - Organització d'arxius i directoris
- **[Tecnologies](technologies.md)** - Stack tecnològic i dependències utilitzades
- **[Testing](testing.md)** - Estratègia de testing, tipus de tests i guies de contribució
- **[Contribució](contributing.md)** - Guies per contribuir al projecte
- **[Solució de Problemes](troubleshooting.md)** - Problemes comuns i solucions

---

## Estat del Projecte

- **Versió Base de Dades**: V19 (amb suport multi-persona)
- **Tests**: 570+ tests automatitzats
- **Cobertura**: >80%
- **Idiomes Suportats**: 8 (ES, EN, CA, DE, EU, FR, GL, IT)
- **Tipus de Medicaments**: 14
- **Paletes de Colors**: 2 (Sea Green, Material 3)
- **Flutter**: 3.9.2+
- **Dart**: 3.10.0
- **Material Design**: 3
- **Estat**: En desenvolupament actiu

---

## Llicència

Aquest projecte està llicenciat sota la [GNU Affero General Public License v3.0 (AGPL-3.0)](../../LICENSE).

L'AGPL-3.0 és una llicència de programari lliure copyleft que requereix que qualsevol versió modificada del programari que s'executi en un servidor de xarxa també estigui disponible com a codi obert.

---

**Desenvolupat amb Flutter i Material Design 3**
