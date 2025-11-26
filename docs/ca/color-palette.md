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

## Tema Fosc "Dark Forest"

El tema fosc utilitza una paleta inspirada en un bosc nocturn amb tons verds profunds i misteriosos:

| Rol | Mostra | Codi HEX | Ús |
|-----|---------|----------|-----|
| **Fons Global** | ⚫ | `#050A06` | Un verd gairebé imperceptiblement negre. Profund i misteriós. |
| **Superfície (Nivell 1)** | ⚫ | `#0D1F14` | Un to una mica més clar per a la barra de navegació o menús. |
| **Superfície (Nivell 2)** | ⚫ | `#142B1E` | Per a targetes flotants o modals. |
| **Primari (Marca)** | 🟢 | `#A5D6A7` | Verd pàl·lid desaturat. En dark mode, els colors pastel es veuen més elegants. |
| **Accent Vibrant** | 🟢 | `#4CAF50` | Verd clàssic per a botons de crida a l'acció (CTA) importants. |
| **Text Principal** | ⚪ | `#E8F5E9` | Un blanc amb un tint verdós molt subtil (menta gel). |
| **Text Secundari** | 🔘 | `#819CA9` | Gris amb matís verd/blauada per a jerarquia visual. |
| **Icones Inactives** | 🔘 | `#455A64` | Per a elements que estan allà però no requereixen atenció. |
| **Overlay (Capes)** | 🟢 | `#1E3B28` | Color per a destacar una fila o element seleccionat en una llista. |
| **Resplandor (Glow)** | 🟢 | `#004D40` | Un to teal molt fosc per a fons amb degradats subtils. |

## Ús en el Codi

Els colors estan definits a `lib/theme/app_theme.dart`:

```dart
// Colors principals - Tema clar "Sea Green"
static const Color primaryLight = Color(0xFF2E8B57);
static const Color primaryVariantLight = Color(0xFF3CB371);
static const Color accentLight = Color(0xFF00C853);

// Colors principals - Tema fosc "Dark Forest"
static const Color primaryDark = Color(0xFFA5D6A7);
static const Color accentDark = Color(0xFF4CAF50);

static const Color secondaryLight = Color(0xFF81C784);
static const Color secondaryDark = Color(0xFF819CA9);

// Colors de fons
static const Color backgroundLight = Color(0xFFE8F5E9);
static const Color backgroundDark = Color(0xFF050A06);

static const Color surfaceLight = Color(0xFFC8E6C9);
static const Color surfaceDark = Color(0xFF0D1F14);

// Colors de targetes
static const Color cardLight = Color(0xFFC8E6C9);
static const Color cardDark = Color(0xFF142B1E);

// Colors de text
static const Color textPrimaryLight = Color(0xFF0D2E1C);
static const Color textPrimaryDark = Color(0xFFE8F5E9);

static const Color textSecondaryLight = Color(0xFF577D6A);
static const Color textSecondaryDark = Color(0xFF819CA9);

// Icones inactives
static const Color inactiveIconDark = Color(0xFF455A64);

// Overlay i selecció
static const Color overlayDark = Color(0xFF1E3B28);

// Resplandor/Glow
static const Color glowDark = Color(0xFF004D40);

// Colors de divisors i vores
static const Color dividerLight = Color(0xFFA5D6A7);
static const Color dividerDark = Color(0xFF455A64);

// Colors d'estat
static const Color success = Color(0xFF43A047);
static const Color warning = Color(0xFFFF9800);
static const Color error = Color(0xFFF44336);
static const Color info = Color(0xFF2196F3);
```

## Tema "Alt Contrast"

Dissenyat especialment per a persones grans o amb problemes de visió. Compleix amb WCAG AAA (ràtio de contrast 7:1 o superior).

### Tema Clar Alt Contrast

| Rol | Mostra | Codi HEX | Ús |
|-----|---------|------------|-----|
| **Fons** | ⚪ | `#FFFFFF` | Blanc pur per a màxim contrast |
| **Text Primari** | ⚫ | `#000000` | Negre pur per a màxima llegibilitat |
| **Text Secundari** | ⚫ | `#333333` | Gris molt fosc, encara amb bon contrast |
| **Primari** | 🔵 | `#0000CC` | Blau fosc pur, màxim contrast sobre blanc |
| **Accent** | 🟠 | `#CC5500` | Taronja fosc vibrant |
| **Secundari** | 🟢 | `#006600` | Verd fosc |
| **Error** | 🔴 | `#CC0000` | Vermell fosc |
| **Divisors/Voreres** | ⚫ | `#000000` | Negres i més gruixuts (2px) |

### Tema Fosc Alt Contrast

| Rol | Mostra | Codi HEX | Ús |
|-----|---------|------------|-----|
| **Fons** | ⚫ | `#000000` | Negre pur |
| **Text Primari** | ⚪ | `#FFFFFF` | Blanc pur |
| **Text Secundari** | ⚪ | `#CCCCCC` | Gris molt clar |
| **Primari** | 🟡 | `#FFFF00` | Groc brillant, màxim contrast sobre negre |
| **Accent** | 🔵 | `#00FFFF` | Cian brillant |
| **Secundari** | 🟢 | `#00FF00` | Verd llima brillant |
| **Error** | 🔴 | `#FF6666` | Vermell clar |
| **Divisors/Voreres** | ⚪ | `#FFFFFF` | Blancs i més gruixuts (2px) |

### Característiques d'Accessibilitat

- **Textos més grans**: Mides de font augmentades a tota la interfície
- **Major pes tipogràfic**: Ús de bold/semibold per a millor llegibilitat
- **Voreres més gruixudes**: 2px en lloc de l'estàndard per a millor visibilitat
- **Icones més grans**: 28px en lloc de 24px
- **Major espaiat**: Padding augmentat en botons i elements interactius
- **Enllaços subratllats**: TextButtons amb subratllat per a millor identificació

## Principis de Disseny

1. **Accessibilitat**: Tots els parells text/fons compleixen amb WCAG 2.1 nivell AA per al contrast (AAA per a Alt Contrast).
2. **Consistència**: Els colors primaris s'utilitzen consistentment a tota l'aplicació.
3. **Jerarquia Visual**: L'ús de diferents tons estableix una clara jerarquia d'informació.
4. **Naturalitat**: La paleta verda transmet salut, benestar i confiança, apropiat per a una aplicació mèdica.
5. **Inclusivitat**: La paleta Alt Contrast permet a persones amb problemes de visió utilitzar l'aplicació còmodament.

## Referències

- Material Design 3 Guidelines
- WCAG 2.1 Accessibility Standards
- Paleta tema clar: `Captura de pantalla 2025-11-22 101545.png`
- Paleta tema fosc: `Captura de pantalla 2025-11-22 102516.png`
