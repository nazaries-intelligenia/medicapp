# Paleta de Colors - MedicApp

MedicApp ofereix dues paletes de colors optimitzades per a l'accessibilitat:

- **Deep Emerald** (per defecte): Verd maragda d'alt contrast
- **Alt Contrast**: Màxim contrast per a persones amb problemes de visió

---

## Tema "Deep Emerald" (Per Defecte)

Dissenyat especialment per a persones grans (Silver Surfers) amb màxima llegibilitat mantenint la identitat verda de la marca. Compleix amb els estàndards WCAG AAA (ratio de contrast 19:1).

### Principis de Disseny

1. **Enfosquiment del Primari**: Verd maragda profund (#1B5E20) per garantir que el text blanc sobre els botons sigui 100% llegible.
2. **Fons i Superfície Nets**: Blancs i grisos molt clars sense matisos verds per evitar que els colors es "barregin".
3. **Text quasi Negre**: Text principal (#051F12) enfosquit al màxim per al major ratio de contrast.
4. **Vores Explícites**: Vores sòlides per delimitar zones tàctils, crucial per a persones amb pèrdua de percepció de profunditat.

### Colors Principals (Marca i Acció)

| Rol | Mostra | Codi HEX | Ús |
|-----|---------|----------|-----|
| **Primari (Marca)** | 🟢 | `#1B5E20` | Verd maragda fosc. Garanteix contrast altíssim contra blanc. |
| **Interactiu / Focus** | 🟢 | `#2E7D32` | Estats "pressed" o elements seleccionats. |
| **Acció Vibrant (FAB)** | 🟢 | `#00701A` | Verd vibrant però sòlid (no neó). |
| **Vores d'Elements** | 🟢 | `#1B5E20` | Vora de 2px per delimitar zones tàctils. |

### Colors de Text (Llegibilitat Màxima)

| Rol | Mostra | Codi HEX | Ús |
|-----|---------|----------|-----|
| **Text Principal** | ⚫ | `#051F12` | Quasi negre amb toc verd imperceptible. Contrast 19:1. |
| **Text Secundari** | 🔘 | `#37474F` | Gris blavós fosc, llegible per a ulls amb cataractes. |
| **Text sobre Primari** | ⚪ | `#FFFFFF` | Blanc pur en negreta per a botons verds. |

### Colors de Fons i Superfície

| Rol | Mostra | Codi HEX | Ús |
|-----|---------|----------|-----|
| **Fons Principal** | ⚪ | `#F5F5F5` | Gris molt clar neutre. Les targetes "floten" clarament. |
| **Superfície (Targetes)** | ⚪ | `#FFFFFF` | Blanc pur, millor fons per a lectura. |
| **Vora de Targetes** | 🔘 | `#E0E0E0` | Defineix clarament els límits de les targetes. |
| **Divisor Fort** | 🔘 | `#BDBDBD` | Gris mitjà per a separacions clarament visibles. |

### Colors d'Estat (Funcionals)

| Estat | Codi HEX | Ús |
|--------|----------|-----|
| **Èxit** | `#1E7E34` | Verd fosc per a checks nítids |
| **Advertència** | `#E65100` | Taronja cremat d'alta visibilitat |
| **Error** | `#C62828` | Vermell profund i seriós |
| **Informació** | `#0277BD` | Blau fort, evita el cian clar |

### Tema Fosc "Night Forest" (Accessible)

El tema fosc de Deep Emerald està dissenyat específicament per a persones grans. Evita el negre absolut (#000000) per reduir la fatiga visual i utilitza vores il·luminades per definir espais.

#### Principis de Disseny Fosc

1. **Botons com a Llums**: En mode fosc, els botons tenen fons clar i text fosc per "brillar".
2. **Vores en lloc d'Ombres**: Les ombres no funcionen bé en mode fosc. S'usen vores subtils (#424242).
3. **Sense Negre Pur**: El fons és #121212 (gris molt fosc) per evitar el "smearing" en pantalles OLED.
4. **Text Gris Perla**: El text principal és #E0E0E0 (90% blanc) per evitar l'enlluernament.

#### Colors Principals (Inversió Luminosa)

| Rol | Mostra | Codi HEX | Ús |
|-----|---------|----------|-----|
| **Primari (Marca)** | 🟢 | `#81C784` | Verd Fulla Clar. Botons principals i estats actius. |
| **Text sobre Primari** | ⚫ | `#003300` | El text dins del botó primari ha de ser verd molt fosc. |
| **Primari Variant** | 🟢 | `#66BB6A` | To més saturat per a estats de "focus". |
| **Accent / Interactiu** | 🟢 | `#A5D6A7` | Per a elements flotants (FAB) o interruptors activats. |

#### Colors de Fons i Superfície

| Rol | Mostra | Codi HEX | Ús |
|-----|---------|----------|-----|
| **Fons Principal** | ⚫ | `#121212` | Gris molt fosc estàndard (Material Design). |
| **Superfície (Targetes)** | ⚫ | `#1E2623` | Gris verdós fosc. |
| **Vora de Targeta** | 🔘 | `#424242` | Vora gris subtil al voltant de les targetes. |
| **Divisors** | 🔘 | `#555555` | Línies de separació amb major contrast. |

#### Colors d'Estat (Versions Pastel)

| Estat | Codi HEX | Ús |
|--------|----------|-----|
| **Èxit** | `#81C784` | Mateix verd clar del primari |
| **Advertència** | `#FFB74D` | Taronja pastel clar |
| **Error** | `#E57373` | Vermell suau/rosat |
| **Informació** | `#64B5F6` | Blau cel clar |

---

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

---

## Ús en el Codi

Els colors estan definits a `lib/theme/app_theme.dart`:

```dart
// Deep Emerald - Tema Clar
static const Color deepEmeraldPrimaryLight = Color(0xFF1B5E20);
static const Color deepEmeraldBackgroundLight = Color(0xFFF5F5F5);
static const Color deepEmeraldTextPrimaryLight = Color(0xFF051F12);

// Deep Emerald - Tema Fosc
static const Color deepEmeraldPrimaryDark = Color(0xFF81C784);
static const Color deepEmeraldBackgroundDark = Color(0xFF121212);
static const Color deepEmeraldTextPrimaryDark = Color(0xFFE0E0E0);

// Alt Contrast - Tema Clar
static const Color highContrastPrimaryLight = Color(0xFF0000CC);
static const Color highContrastBackgroundLight = Color(0xFFFFFFFF);
static const Color highContrastTextPrimaryLight = Color(0xFF000000);

// Alt Contrast - Tema Fosc
static const Color highContrastPrimaryDark = Color(0xFFFFFF00);
static const Color highContrastBackgroundDark = Color(0xFF000000);
static const Color highContrastTextPrimaryDark = Color(0xFFFFFFFF);
```

## Principis de Disseny

1. **Accessibilitat**: Tots els parells text/fons compleixen amb WCAG 2.1 nivell AA per al contrast (AAA per a Alt Contrast).
2. **Consistència**: Els colors primaris s'utilitzen consistentment a tota l'aplicació.
3. **Jerarquia Visual**: L'ús de diferents tons estableix una clara jerarquia d'informació.
4. **Naturalitat**: La paleta verda transmet salut, benestar i confiança.
5. **Inclusivitat**: La paleta Alt Contrast permet a persones amb problemes de visió utilitzar l'aplicació còmodament.

## Referències

- Material Design 3 Guidelines
- WCAG 2.1 Accessibility Standards
