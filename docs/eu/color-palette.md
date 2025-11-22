# Koloreak Paleta - MedicApp

## "Sea Green" Gaia Arina

MedicApp naturatik inspiratutako kolore paleta bat erabiltzen du, berdeen tonak osasuna, ongizatea eta konfiantza transmititzen dituztena.

### Kolore Nagusiak

| Rola | Lagina | Kodigo HEX | Erabilera |
|-----|---------|------------|-----|
| **Nagusia (Marka)** | 🟢 | `#2E8B57` | Botoi nagusiak, nabigazioa barra aktiboa, logoa. Solidoa "Sea Green" berdea. |
| **Nagusia Aldaera** | 🟢 | `#3CB371` | "Hover" edo "pressed" egoerak botoi nagusietan. Argi pixka bat gehiago. |
| **Akzentua / Interaktiboa** | 🟢 | `#00C853` | Flotatzaile ekintzaren botoiak (FAB), jakinarazpen garrantzitsua, "call to action" bibe. |
| **Sekundarioa / Laguntza** | 🟢 | `#81C784` | Elemuntu sekundarioak, aldatzaile aktiboa (toggles), jerarki baxuko ikonak. |
| **Egoera: Arrakasta** | 🟢 | `#43A047` | Konfirmazio mezuak, osatuta dago kontrolak. Funtzionala berdea estandarra. |

### Testua Kolorea

| Rola | Lagina | Kodigo HEX | Erabilera |
|-----|---------|------------|-----|
| **Testua Iluna / Titulua** | ⚫ | `#0D2E1C` | Testua naguaren kolorea. Ez da zuriz puruari, boskar osagarri berdea oso sakonari. |
| **Testua Sekundarioa** | 🔘 | `#577D6A` | Azpititulua, laguntza testua, aktiboak ez diren ikonak. |

### Fondo eta Gainazaleko Kolorea

| Rola | Lagina | Kodigo HEX | Erabilera |
|-----|---------|------------|-----|
| **Gainazala (Txartelak)** | 🟢 | `#C8E6C9` | Fondo txartelak edo edukigailuak naguaren fondon. Menta liraina. |
| **Fondo Nagusia** | ⚪ | `#E8F5E9` | Pantailaren orokorrean fondo kolorea. Ia zuriz berdeen kutsadura nabaritzailea. |
| **Zatitzailea / Bordea** | 🟢 | `#A5D6A7` | Lerro jostak sekzioak edo sartze inaktiboen bordeak bereizten. |

### Egoeraren Kolorea

| Egoera | Kodigo HEX | Erabilera |
|--------|------------|-----|
| **Arrakasta** | `#43A047` | Operazioak behar bezala osatua |
| **Abisua** | `#FF9800` | Alertak arreta behar duten |
| **Errorea** | `#F44336` | Errore kritikoak edo zerstatzaile ekintzak |
| **Informazioa** | `#2196F3` | Orokorrean informazio mezuak |

## Gaia Iluna

Gaia iluna "Sea Green" paleta osagarri kolorea mantentzen du argitasun gutxiko ingurunetarako aldatua:

- **Nagusia**: `#5BA3F5` (urdin arina)
- **Sekundarioa**: `#66D98E` (menta berdea)
- **Fondo**: `#121212` (beltz sakonari)
- **Gainazala**: `#1E1E1E` (gris iluna)
- **Txartelak**: `#2C2C2C` (gris ertaina)
- **Testua Nagusia**: `#E0E0E0` (gris arina)
- **Testua Sekundarioa**: `#B0B0B0` (gris ertaina)
- **Zatitzailea**: `#424242` (gris iluna)

## Kodeari Erabilera

Kolorea `lib/theme/app_theme.dart` definitzen dira:

```dart
// Kolore nagusiak - Gaia arina "Sea Green"
static const Color primaryLight = Color(0xFF2E8B57);
static const Color primaryVariantLight = Color(0xFF3CB371);
static const Color accentLight = Color(0xFF00C853);
static const Color secondaryLight = Color(0xFF81C784);

// Fondo kolorea
static const Color backgroundLight = Color(0xFFE8F5E9);
static const Color surfaceLight = Color(0xFFC8E6C9);
static const Color cardLight = Color(0xFFC8E6C9);

// Testua kolorea
static const Color textPrimaryLight = Color(0xFF0D2E1C);
static const Color textSecondaryLight = Color(0xFF577D6A);

// Zatitzaile eta borde kolorea
static const Color dividerLight = Color(0xFFA5D6A7);

// Egoeraren kolorea
static const Color success = Color(0xFF43A047);
static const Color warning = Color(0xFFFF9800);
static const Color error = Color(0xFFF44336);
static const Color info = Color(0xFF2196F3);
```

## Diseinua Printzipioa

1. **Atzegarritasuna**: Testu/fondo bikote guztiak WCAG 2.1 mailan AA kontraste dute.
2. **Koherentzia**: Kolore nagusiak aplikazio osoan koherentziaz erabiltzen dira.
3. **Hierarkia Bisuala**: Berdeen tonu desberdinak informazioaren hierarki argia ezartzen du.
4. **Naturalitatea**: Berdeen paleta osasuna, ongizatea eta konfiantza transmititzen du, aplikazio medikoarentzat egokia.

## Erreferentzia

- Material Design 3 Guidelines
- WCAG 2.1 Accessibility Standards
- Jatorrizko paleta: `Captura de pantalla 2025-11-22 101545.png`
