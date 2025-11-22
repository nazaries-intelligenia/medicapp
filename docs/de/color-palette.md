# Farbpalette - MedicApp

## Light-Theme "Sea Green"

MedicApp nutzt eine Farbpalette, die von der Natur inspiriert ist und grüne Töne verwendet, die Gesundheit, Wohlbefinden und Vertrauen vermitteln.

### Primärfarben

| Rolle | Muster | HEX-Code | Verwendung |
|-------|--------|----------|-----------|
| **Primär (Marke)** | 🟢 | `#2E8B57` | Hauptschaltflächen, aktive Navigationsleiste, Logo. Ein solides "Sea Green" Grün. |
| **Primär-Variante** | 🟢 | `#3CB371` | Status "hover" oder "pressed" von Hauptschaltflächen. Ein wenig heller. |
| **Akzent / Interaktiv** | 🟢 | `#00C853` | Schwebende Aktionsschaltflächen (FAB), wichtige Benachrichtigungen, lebendiger "call to action". |
| **Sekundär / Unterstützung** | 🟢 | `#81C784` | Sekundärelemente, aktive Schalter (toggles), Symbole mit niedrigerer Hierarchie. |
| **Status: Erfolg** | 🟢 | `#43A047` | Bestätigungsmeldungen, abgeschlossene Häkchen. Ein funktionales Standardgrün. |

### Textfarben

| Rolle | Muster | HEX-Code | Verwendung |
|-------|--------|----------|-----------|
| **Dunkeltext / Titel** | ⚫ | `#0D2E1C` | Primärfarbe für Text. Keine reine Schwarz, sondern ein sehr tiefes Waldgrün. |
| **Sekundärtext** | 🔘 | `#577D6A` | Untertitel, Hilfetext, inaktive Symbole. |

### Hintergrund- und Oberflächenfarben

| Rolle | Muster | HEX-Code | Verwendung |
|-------|--------|----------|-----------|
| **Oberfläche (Karten)** | 🟢 | `#C8E6C9` | Hintergrund für Karten oder Container über dem Haupthintergrund. Weiches Minz. |
| **Haupthintergrund** | ⚪ | `#E8F5E9` | Die allgemeine Hintergrundfarbe des Bildschirms. Fast Weiß mit unmerklichem Grünstich. |
| **Teiler / Rand** | 🟢 | `#A5D6A7` | Subtile Linien, um Abschnitte zu trennen oder Ränder von inaktiven Eingabefeldern. |

### Statusfarben

| Status | HEX-Code | Verwendung |
|--------|----------|-----------|
| **Erfolg** | `#43A047` | Erfolgreich abgeschlossene Operationen |
| **Warnung** | `#FF9800` | Warnungen, die Aufmerksamkeit erfordern |
| **Fehler** | `#F44336` | Kritische Fehler oder destruktive Aktionen |
| **Information** | `#2196F3` | Allgemeine Informationsmeldungen |

## Dark-Theme "Dark Forest"

Das Dark-Theme verwendet eine Palette, die von einem nächtlichen Wald mit tiefen und geheimnisvollen Grüntönen inspiriert ist:

| Rolle | Muster | HEX-Code | Verwendung |
|-------|--------|----------|-----------|
| **Globaler Hintergrund** | ⚫ | `#050A06` | Ein fast unmerklich schwarzes Grün. Tiefgreifend und geheimnisvoll. |
| **Oberfläche (Ebene 1)** | ⚫ | `#0D1F14` | Ein etwas hellerer Ton für die Navigationsleiste oder Menüs. |
| **Oberfläche (Ebene 2)** | ⚫ | `#142B1E` | Für schwebende Karten oder Modals. |
| **Primär (Marke)** | 🟢 | `#A5D6A7` | Blasses entsättigtes Grün. Im Dark-Mode wirken Pastellfarben eleganter. |
| **Akzent Vibrierend** | 🟢 | `#4CAF50` | Klassisches Grün für wichtige Call-to-Action (CTA) Schaltflächen. |
| **Primärtext** | ⚪ | `#E8F5E9` | Ein Weiß mit einem sehr subtilen grünlichen Farbton (Eisminte). |
| **Sekundärtext** | 🔘 | `#819CA9` | Grau mit Grün-/Blauton für visuelle Hierarchie. |
| **Inaktive Symbole** | 🔘 | `#455A64` | Für Elemente, die vorhanden sind, aber keine Aufmerksamkeit erfordern. |
| **Overlay (Schichten)** | 🟢 | `#1E3B28` | Farbe zur Hervorhebung einer Zeile oder eines ausgewählten Elements in einer Liste. |
| **Resplandor (Glow)** | 🟢 | `#004D40` | Ein sehr dunkler Teal-Ton für subtile degradierte Hintergründe. |

## Verwendung im Code

Die Farben sind in `lib/theme/app_theme.dart` definiert:

```dart
// Primärfarben - Light-Theme "Sea Green"
static const Color primaryLight = Color(0xFF2E8B57);
static const Color primaryVariantLight = Color(0xFF3CB371);
static const Color accentLight = Color(0xFF00C853);

// Primärfarben - Dark-Theme "Dark Forest"
static const Color primaryDark = Color(0xFFA5D6A7);
static const Color accentDark = Color(0xFF4CAF50);

static const Color secondaryLight = Color(0xFF81C784);
static const Color secondaryDark = Color(0xFF819CA9);

// Hintergrundfarben
static const Color backgroundLight = Color(0xFFE8F5E9);
static const Color backgroundDark = Color(0xFF050A06);

static const Color surfaceLight = Color(0xFFC8E6C9);
static const Color surfaceDark = Color(0xFF0D1F14);

// Kartenfarben
static const Color cardLight = Color(0xFFC8E6C9);
static const Color cardDark = Color(0xFF142B1E);

// Textfarben
static const Color textPrimaryLight = Color(0xFF0D2E1C);
static const Color textPrimaryDark = Color(0xFFE8F5E9);

static const Color textSecondaryLight = Color(0xFF577D6A);
static const Color textSecondaryDark = Color(0xFF819CA9);

// Inaktive Symbole
static const Color inactiveIconDark = Color(0xFF455A64);

// Overlay und Auswahl
static const Color overlayDark = Color(0xFF1E3B28);

// Resplandor/Glow
static const Color glowDark = Color(0xFF004D40);

// Teiler- und Randfarben
static const Color dividerLight = Color(0xFFA5D6A7);
static const Color dividerDark = Color(0xFF455A64);

// Statusfarben
static const Color success = Color(0xFF43A047);
static const Color warning = Color(0xFFFF9800);
static const Color error = Color(0xFFF44336);
static const Color info = Color(0xFF2196F3);
```

## Designprinzipien

1. **Barrierefreiheit**: Alle Text-/Hintergrund-Paare erfüllen den WCAG 2.1 Level AA Kontrast.
2. **Konsistenz**: Die Primärfarben werden in der gesamten Anwendung konsistent verwendet.
3. **Visuelle Hierarchie**: Die Verwendung verschiedener Grüntöne etabliert eine klare Informationshierarchie.
4. **Natürlichkeit**: Die grüne Palette vermittelt Gesundheit, Wohlbefinden und Vertrauen, passend für eine medizinische Anwendung.

## Referenzen

- Material Design 3 Guidelines
- WCAG 2.1 Accessibility Standards
- Palette Light-Theme: `Captura de pantalla 2025-11-22 101545.png`
- Palette Dark-Theme: `Captura de pantalla 2025-11-22 102516.png`
