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

## Dark-Theme

Das Dark-Theme behält Farben bei, die die "Sea Green" Palette ergänzen und für Umgebungen mit schwachem Licht angepasst sind:

- **Primär**: `#5BA3F5` (helles Blau)
- **Sekundär**: `#66D98E` (Minzgrün)
- **Hintergrund**: `#121212` (tiefes Schwarz)
- **Oberfläche**: `#1E1E1E` (dunkles Grau)
- **Karten**: `#2C2C2C` (mittleres Grau)
- **Primärtext**: `#E0E0E0` (helles Grau)
- **Sekundärtext**: `#B0B0B0` (mittleres Grau)
- **Teiler**: `#424242` (dunkles Grau)

## Verwendung im Code

Die Farben sind in `lib/theme/app_theme.dart` definiert:

```dart
// Primärfarben - Light-Theme "Sea Green"
static const Color primaryLight = Color(0xFF2E8B57);
static const Color primaryVariantLight = Color(0xFF3CB371);
static const Color accentLight = Color(0xFF00C853);
static const Color secondaryLight = Color(0xFF81C784);

// Hintergrundfarben
static const Color backgroundLight = Color(0xFFE8F5E9);
static const Color surfaceLight = Color(0xFFC8E6C9);
static const Color cardLight = Color(0xFFC8E6C9);

// Textfarben
static const Color textPrimaryLight = Color(0xFF0D2E1C);
static const Color textSecondaryLight = Color(0xFF577D6A);

// Teiler- und Randfarben
static const Color dividerLight = Color(0xFFA5D6A7);

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
- Ursprüngliche Palette: `Captura de pantalla 2025-11-22 101545.png`
