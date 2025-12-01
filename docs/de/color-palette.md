# Farbpalette - MedicApp

MedicApp bietet zwei für Barrierefreiheit optimierte Farbpaletten:

- **Deep Emerald** (Standard): Smaragdgrün mit hohem Kontrast
- **Hoher Kontrast**: Maximaler Kontrast für Menschen mit Sehproblemen

---

## "Deep Emerald" Theme (Standard)

Speziell für ältere Benutzer (Silver Surfers) mit maximaler Lesbarkeit entwickelt, unter Beibehaltung der grünen Markenidentität. Erfüllt WCAG AAA Standards (19:1 Kontrastverhältnis).

### Design-Prinzipien

1. **Verdunkeltes Primär**: Tiefes Smaragdgrün (#1B5E20) garantiert, dass weißer Text auf Schaltflächen zu 100% lesbar ist.
2. **Sauberer Hintergrund und Oberfläche**: Reine Weiße und sehr helle Grautöne ohne Grünstiche, um ein "Verschwimmen" der Farben zu verhindern.
3. **Fast schwarzer Text**: Primärtext (#051F12) maximal verdunkelt für höchstes Kontrastverhältnis.
4. **Explizite Rahmen**: Solide Rahmen zur Abgrenzung von Touch-Zonen, entscheidend für Menschen mit Tiefenwahrnehmungsverlust.

### Primärfarben (Marke und Aktion)

| Rolle | Muster | HEX-Code | Verwendung |
|-------|--------|----------|-----------|
| **Primär (Marke)** | 🟢 | `#1B5E20` | Dunkles Smaragdgrün. Garantiert sehr hohen Kontrast gegen Weiß. |
| **Interaktiv / Fokus** | 🟢 | `#2E7D32` | "Pressed" Zustände oder ausgewählte Elemente. |
| **Vibrierende Aktion (FAB)** | 🟢 | `#00701A` | Lebhaftes aber solides Grün (kein Neon). |
| **Element-Rahmen** | 🟢 | `#1B5E20` | 2px Rahmen zur Abgrenzung von Touch-Zonen. |

### Textfarben (Maximale Lesbarkeit)

| Rolle | Muster | HEX-Code | Verwendung |
|-------|--------|----------|-----------|
| **Primärtext** | ⚫ | `#051F12` | Fast Schwarz mit unmerklichem Grünstich. 19:1 Kontrast. |
| **Sekundärtext** | 🔘 | `#37474F` | Dunkles Blaugrau, lesbar für Augen mit grauem Star. |
| **Text auf Primär** | ⚪ | `#FFFFFF` | Reines Weiß in Fettschrift für grüne Schaltflächen. |

### Hintergrund- und Oberflächenfarben

| Rolle | Muster | HEX-Code | Verwendung |
|-------|--------|----------|-----------|
| **Haupthintergrund** | ⚪ | `#F5F5F5` | Sehr helles neutrales Grau. Karten "schweben" deutlich. |
| **Oberfläche (Karten)** | ⚪ | `#FFFFFF` | Reines Weiß, bester Hintergrund zum Lesen. |
| **Kartenrahmen** | 🔘 | `#E0E0E0` | Definiert klar die Kartengrenzen. |
| **Starker Trenner** | 🔘 | `#BDBDBD` | Mittelgrau für deutlich sichtbare Trennungen. |

### Statusfarben (Funktional)

| Status | HEX-Code | Verwendung |
|--------|----------|-----------|
| **Erfolg** | `#1E7E34` | Dunkles Grün für scharfe Häkchen |
| **Warnung** | `#E65100` | Verbranntes Orange für hohe Sichtbarkeit |
| **Fehler** | `#C62828` | Tiefes ernstes Rot |
| **Information** | `#0277BD` | Kräftiges Blau, vermeidet helles Cyan |

### Dunkles Theme "Night Forest" (Barrierefrei)

Das Deep Emerald Dark Theme ist speziell für ältere Benutzer konzipiert. Vermeidet reines Schwarz (#000000) um Augenbelastung zu reduzieren und verwendet beleuchtete Rahmen zur Definition von Bereichen.

#### Dunkle Design-Prinzipien

1. **Schaltflächen als Lampen**: Im Dunkelmodus haben Schaltflächen hellen Hintergrund und dunklen Text zum "Leuchten".
2. **Rahmen statt Schatten**: Schatten funktionieren im Dunkelmodus nicht gut. Subtile Rahmen (#424242) werden verwendet.
3. **Kein reines Schwarz**: Hintergrund ist #121212 (sehr dunkles Grau) um "Smearing" auf OLED-Bildschirmen zu vermeiden.
4. **Perlgrauer Text**: Primärtext ist #E0E0E0 (90% Weiß) um Blendung zu vermeiden.

#### Primärfarben (Leuchtende Umkehrung)

| Rolle | Muster | HEX-Code | Verwendung |
|-------|--------|----------|-----------|
| **Primär (Marke)** | 🟢 | `#81C784` | Helles Blattgrün. Hauptschaltflächen und aktive Zustände. |
| **Text auf Primär** | ⚫ | `#003300` | Text in Primärschaltfläche muss sehr dunkles Grün sein. |
| **Primär-Variante** | 🟢 | `#66BB6A` | Gesättigterer Ton für "Fokus"-Zustände. |
| **Akzent / Interaktiv** | 🟢 | `#A5D6A7` | Für schwebende Elemente (FAB) oder aktivierte Schalter. |

#### Hintergrund- und Oberflächenfarben

| Rolle | Muster | HEX-Code | Verwendung |
|-------|--------|----------|-----------|
| **Haupthintergrund** | ⚫ | `#121212` | Standard sehr dunkles Grau (Material Design). |
| **Oberfläche (Karten)** | ⚫ | `#1E2623` | Dunkles grünliches Grau. |
| **Kartenrahmen** | 🔘 | `#424242` | Subtiler grauer Rahmen um Karten. |
| **Trenner** | 🔘 | `#555555` | Trennlinien mit höherem Kontrast. |

#### Statusfarben (Pastellversionen)

| Status | HEX-Code | Verwendung |
|--------|----------|-----------|
| **Erfolg** | `#81C784` | Gleiches helles Grün wie Primär |
| **Warnung** | `#FFB74D` | Helles Pastellorange |
| **Fehler** | `#E57373` | Weiches Rosa-Rot |
| **Information** | `#64B5F6` | Helles Himmelblau |

---

## "Hoher Kontrast" Theme

Speziell für ältere Menschen oder Personen mit Sehproblemen entwickelt. Erfüllt WCAG AAA (Kontrastverhältnis 7:1 oder höher).

### Helles Theme Hoher Kontrast

| Rolle | Muster | HEX-Code | Verwendung |
|-----|---------|------------|-----|
| **Hintergrund** | ⚪ | `#FFFFFF` | Reines Weiß für maximalen Kontrast |
| **Primärtext** | ⚫ | `#000000` | Reines Schwarz für maximale Lesbarkeit |
| **Sekundärtext** | ⚫ | `#333333` | Sehr dunkles Grau, immer noch guter Kontrast |
| **Primär** | 🔵 | `#0000CC` | Reines Dunkelblau, maximaler Kontrast auf Weiß |
| **Akzent** | 🟠 | `#CC5500` | Lebhaftes Dunkelorange |
| **Sekundär** | 🟢 | `#006600` | Dunkelgrün |
| **Fehler** | 🔴 | `#CC0000` | Dunkelrot |
| **Teiler/Rahmen** | ⚫ | `#000000` | Schwarz und dicker (2px) |

### Dunkles Theme Hoher Kontrast

| Rolle | Muster | HEX-Code | Verwendung |
|-----|---------|------------|-----|
| **Hintergrund** | ⚫ | `#000000` | Reines Schwarz |
| **Primärtext** | ⚪ | `#FFFFFF` | Reines Weiß |
| **Sekundärtext** | ⚪ | `#CCCCCC` | Sehr helles Grau |
| **Primär** | 🟡 | `#FFFF00` | Helles Gelb, maximaler Kontrast auf Schwarz |
| **Akzent** | 🔵 | `#00FFFF` | Helles Cyan |
| **Sekundär** | 🟢 | `#00FF00` | Helles Limonengrün |
| **Fehler** | 🔴 | `#FF6666` | Helles Rot |
| **Teiler/Rahmen** | ⚪ | `#FFFFFF` | Weiß und dicker (2px) |

### Barrierefreiheitsfunktionen

- **Größerer Text**: Erhöhte Schriftgrößen in der gesamten Oberfläche
- **Stärkere Typografie**: Verwendung von Bold/Semibold für bessere Lesbarkeit
- **Dickere Rahmen**: 2px statt Standard für bessere Sichtbarkeit
- **Größere Symbole**: 28px statt 24px
- **Mehr Abstand**: Erhöhtes Padding bei Schaltflächen und interaktiven Elementen
- **Unterstrichene Links**: TextButtons mit Unterstreichung für bessere Identifizierung

---

## Verwendung im Code

Die Farben sind in `lib/theme/app_theme.dart` definiert:

```dart
// Deep Emerald - Helles Theme
static const Color deepEmeraldPrimaryLight = Color(0xFF1B5E20);
static const Color deepEmeraldBackgroundLight = Color(0xFFF5F5F5);
static const Color deepEmeraldTextPrimaryLight = Color(0xFF051F12);

// Deep Emerald - Dunkles Theme
static const Color deepEmeraldPrimaryDark = Color(0xFF81C784);
static const Color deepEmeraldBackgroundDark = Color(0xFF121212);
static const Color deepEmeraldTextPrimaryDark = Color(0xFFE0E0E0);

// Hoher Kontrast - Helles Theme
static const Color highContrastPrimaryLight = Color(0xFF0000CC);
static const Color highContrastBackgroundLight = Color(0xFFFFFFFF);
static const Color highContrastTextPrimaryLight = Color(0xFF000000);

// Hoher Kontrast - Dunkles Theme
static const Color highContrastPrimaryDark = Color(0xFFFFFF00);
static const Color highContrastBackgroundDark = Color(0xFF000000);
static const Color highContrastTextPrimaryDark = Color(0xFFFFFFFF);
```

## Designprinzipien

1. **Barrierefreiheit**: Alle Text-/Hintergrund-Paare erfüllen den WCAG 2.1 Level AA Kontrast (AAA für Hoher Kontrast).
2. **Konsistenz**: Die Primärfarben werden in der gesamten Anwendung konsistent verwendet.
3. **Visuelle Hierarchie**: Die Verwendung verschiedener Töne etabliert eine klare Informationshierarchie.
4. **Natürlichkeit**: Die grüne Palette vermittelt Gesundheit, Wohlbefinden und Vertrauen.
5. **Inklusivität**: Die Hoher Kontrast Palette ermöglicht Menschen mit Sehproblemen eine komfortable Nutzung der Anwendung.

## Referenzen

- Material Design 3 Guidelines
- WCAG 2.1 Accessibility Standards
