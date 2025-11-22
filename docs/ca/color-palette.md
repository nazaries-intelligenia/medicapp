# Paleta de Colors - MedicApp

## Tema Clar "Sea Green"

MedicApp utilitza una paleta de colors inspirada en la natura amb tons verds que transmeten salut, benestar i confiança.

### Colors Principals

| Rol | Mostra | Codi HEX | Ús |
|-----|---------|----------|-----|
| **Primari (Marca)** | 🟢 | `#2E8B57` | Botons principals, barra de navegació activa, logo. Un verd "Sea Green" sòlid. |
| **Primari Variant** | 🟢 | `#3CB371` | Estats "hover" o "pressed" dels botons principals. Una mica més clar. |
| **Accent / Interactiu** | 🟢 | `#00C853` | Botons d'acció flotants (FAB), notificacions importants, "call to action" vibrant. |
| **Secundari / Suport** | 🟢 | `#81C784` | Elements secundaris, interruptors (toggles) actius, icones de menor jerarquia. |
| **Estat: Èxit** | 🟢 | `#43A047` | Missatges de confirmació, checks de completat. Un verd estàndard funcional. |

### Colors de Text

| Rol | Mostra | Codi HEX | Ús |
|-----|---------|----------|-----|
| **Text Fosc / Títols** | ⚫ | `#0D2E1C` | Color principal per al text. No és negre pur, és un verd bosc molt profund. |
| **Text Secundari** | 🔘 | `#577D6A` | Subtítols, text d'ajuda, icones inactives. |

### Colors de Fons i Superfície

| Rol | Mostra | Codi HEX | Ús |
|-----|---------|----------|-----|
| **Superfície (Targetes)** | 🟢 | `#C8E6C9` | Fons per a targetes o contenidors sobre el fons principal. Menta suau. |
| **Fons Principal** | ⚪ | `#E8F5E9` | El color de fons general de la pantalla. Gairebé blanc amb un tint verd imperceptible. |
| **Divisor / Vora** | 🟢 | `#A5D6A7` | Línies subtils per a separar seccions o vores d'inputs inactius. |

### Colors d'Estat

| Estat | Codi HEX | Ús |
|--------|----------|-----|
| **Èxit** | `#43A047` | Operacions completades exitosament |
| **Advertència** | `#FF9800` | Alertes que requereixen atenció |
| **Error** | `#F44336` | Errors crítics o accions destructives |
| **Informació** | `#2196F3` | Missatges informatius generals |

## Tema Fosc

El tema fosc manté colors que complementen la paleta "Sea Green" adaptats per a ambients amb poca llum:

- **Primari**: `#5BA3F5` (blau clar)
- **Secundari**: `#66D98E` (verd menta)
- **Fons**: `#121212` (negre profund)
- **Superfície**: `#1E1E1E` (gris fosc)
- **Targetes**: `#2C2C2C` (gris mitjà)
- **Text Primari**: `#E0E0E0` (gris clar)
- **Text Secundari**: `#B0B0B0` (gris mitjà)
- **Divisor**: `#424242` (gris fosc)

## Ús en el Codi

Els colors estan definits a `lib/theme/app_theme.dart`:

```dart
// Colors principals - Tema clar "Sea Green"
static const Color primaryLight = Color(0xFF2E8B57);
static const Color primaryVariantLight = Color(0xFF3CB371);
static const Color accentLight = Color(0xFF00C853);
static const Color secondaryLight = Color(0xFF81C784);

// Colors de fons
static const Color backgroundLight = Color(0xFFE8F5E9);
static const Color surfaceLight = Color(0xFFC8E6C9);
static const Color cardLight = Color(0xFFC8E6C9);

// Colors de text
static const Color textPrimaryLight = Color(0xFF0D2E1C);
static const Color textSecondaryLight = Color(0xFF577D6A);

// Colors de divisors i vores
static const Color dividerLight = Color(0xFFA5D6A7);

// Colors d'estat
static const Color success = Color(0xFF43A047);
static const Color warning = Color(0xFFFF9800);
static const Color error = Color(0xFFF44336);
static const Color info = Color(0xFF2196F3);
```

## Principis de Disseny

1. **Accessibilitat**: Tots els parells text/fons compleixen amb WCAG 2.1 nivell AA per al contrast.
2. **Consistència**: Els colors primaris s'utilitzen consistentment a tota l'aplicació.
3. **Jerarquia Visual**: L'ús de diferents tons verds estableix una clara jerarquia d'informació.
4. **Naturalitat**: La paleta verda transmet salut, benestar i confiança, apropiat per a una aplicació mèdica.

## Referències

- Material Design 3 Guidelines
- WCAG 2.1 Accessibility Standards
- Paleta original: `Captura de pantalla 2025-11-22 101545.png`
