# Farbpalette - MedicApp

## "Deep Emerald" Theme (Standard)

MedicApp verwendet standardmäßig das "Deep Emerald" Theme, das speziell für ältere Benutzer (Silver Surfers) mit maximaler Lesbarkeit entwickelt wurde und gleichzeitig die grüne Markenidentität beibehält. Erfüllt WCAG AAA Standards (19:1 Kontrastverhältnis).

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

### Deep Emerald Dark Theme

| Rolle | Muster | HEX-Code | Verwendung |
|-------|--------|----------|-----------|
| **Hintergrund** | ⚫ | `#121212` | Tiefes Dunkel aber nicht reines Schwarz |
| **Oberfläche** | ⚫ | `#1E1E1E` | Leicht erhöht |
| **Karten** | ⚫ | `#2C2C2C` | Dunkelgrau für Karten |
| **Primär** | 🟢 | `#A5D6A7` | Hellgrün für Dunkelmodus |
| **Akzent** | 🟢 | `#66BB6A` | Sichtbares mittleres Grün |
| **Primärtext** | ⚪ | `#FAFAFA` | Fast Weiß |
| **Sekundärtext** | 🔘 | `#B0BEC5` | Hellgrau |

---

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

## "Hoher Kontrast" Thema

Speziell für ältere Menschen oder Personen mit Sehproblemen entwickelt. Erfüllt WCAG AAA (Kontrastverhältnis 7:1 oder höher).

### Helles Thema Hoher Kontrast

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

### Dunkles Thema Hoher Kontrast

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

## Designprinzipien

1. **Barrierefreiheit**: Alle Text-/Hintergrund-Paare erfüllen den WCAG 2.1 Level AA Kontrast (AAA für Hoher Kontrast).
2. **Konsistenz**: Die Primärfarben werden in der gesamten Anwendung konsistent verwendet.
3. **Visuelle Hierarchie**: Die Verwendung verschiedener Töne etabliert eine klare Informationshierarchie.
4. **Natürlichkeit**: Die grüne Palette vermittelt Gesundheit, Wohlbefinden und Vertrauen, passend für eine medizinische Anwendung.
5. **Inklusivität**: Die Hoher Kontrast Palette ermöglicht Menschen mit Sehproblemen eine komfortable Nutzung der Anwendung.

## Referenzen

- Material Design 3 Guidelines
- WCAG 2.1 Accessibility Standards
- Palette Light-Theme: `Captura de pantalla 2025-11-22 101545.png`
- Palette Dark-Theme: `Captura de pantalla 2025-11-22 102516.png`
