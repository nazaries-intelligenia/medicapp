# Color Palette - MedicApp

MedicApp offers two color palettes optimized for accessibility:

- **Deep Emerald** (default): High contrast emerald green
- **High Contrast**: Maximum contrast for users with vision problems

---

## "Deep Emerald" Theme (Default)

Specially designed for elderly users (Silver Surfers) with maximum legibility while maintaining the green brand identity. Complies with WCAG AAA standards (19:1 contrast ratio).

### Design Principles

1. **Darkened Primary**: Deep emerald green (#1B5E20) ensures white text on buttons is 100% readable.
2. **Clean Background and Surface**: Pure whites and very light grays without green tints to prevent colors from "blending".
3. **Near-Black Text**: Primary text (#051F12) darkened to maximum for highest contrast ratio.
4. **Explicit Borders**: Solid borders to delimit touch zones, crucial for people with depth perception loss.

### Primary Colors (Brand and Action)

| Role | Sample | HEX Code | Usage |
|-----|---------|------------|-----|
| **Primary (Brand)** | 🟢 | `#1B5E20` | Dark emerald green. Guarantees very high contrast against white. |
| **Interactive / Focus** | 🟢 | `#2E7D32` | "Pressed" states or selected elements. |
| **Vibrant Action (FAB)** | 🟢 | `#00701A` | Vibrant but solid green (not neon). |
| **Element Borders** | 🟢 | `#1B5E20` | 2px border to delimit touch zones. |

### Text Colors (Maximum Legibility)

| Role | Sample | HEX Code | Usage |
|-----|---------|------------|-----|
| **Primary Text** | ⚫ | `#051F12` | Near-black with imperceptible green touch. 19:1 contrast. |
| **Secondary Text** | 🔘 | `#37474F` | Dark blue-gray, readable for eyes with cataracts. |
| **Text on Primary** | ⚪ | `#FFFFFF` | Pure white in bold for green buttons. |

### Background and Surface Colors

| Role | Sample | HEX Code | Usage |
|-----|---------|------------|-----|
| **Main Background** | ⚪ | `#F5F5F5` | Very light neutral gray. Cards clearly "float". |
| **Surface (Cards)** | ⚪ | `#FFFFFF` | Pure white, best background for reading. |
| **Card Border** | 🔘 | `#E0E0E0` | Clearly defines card boundaries. |
| **Strong Divider** | 🔘 | `#BDBDBD` | Medium gray for clearly visible separations. |

### State Colors (Functional)

| State | HEX Code | Usage |
|--------|------------|-----|
| **Success** | `#1E7E34` | Dark green for crisp check icons |
| **Warning** | `#E65100` | Burnt orange for high visibility |
| **Error** | `#C62828` | Deep serious red |
| **Information** | `#0277BD` | Strong blue, avoids light cyan |

### Dark Theme "Night Forest" (Accessible)

The Deep Emerald dark theme is specifically designed for elderly users. Avoids pure black (#000000) to reduce eye strain and uses illuminated borders to define spaces.

#### Dark Design Principles

1. **Buttons as Lamps**: In dark mode, buttons have light background and dark text to "glow".
2. **Borders Instead of Shadows**: Shadows don't work well in dark mode. Subtle borders (#424242) are used.
3. **No Pure Black**: Background is #121212 (very dark gray) to avoid "smearing" on OLED screens.
4. **Pearl Gray Text**: Primary text is #E0E0E0 (90% white) to avoid glare.

#### Primary Colors (Luminous Inversion)

| Role | Sample | HEX Code | Usage |
|-----|---------|------------|-----|
| **Primary (Brand)** | 🟢 | `#81C784` | Light Leaf Green. Main buttons and active states. |
| **Text on Primary** | ⚫ | `#003300` | Text inside primary button must be very dark green. |
| **Primary Variant** | 🟢 | `#66BB6A` | More saturated tone for "focus" states. |
| **Accent / Interactive** | 🟢 | `#A5D6A7` | For floating elements (FAB) or activated toggles. |

#### Background and Surface Colors

| Role | Sample | HEX Code | Usage |
|-----|---------|------------|-----|
| **Main Background** | ⚫ | `#121212` | Standard very dark gray (Material Design). |
| **Surface (Cards)** | ⚫ | `#1E2623` | Dark greenish gray. |
| **Card Border** | 🔘 | `#424242` | Subtle gray border around cards. |
| **Dividers** | 🔘 | `#555555` | Separation lines with higher contrast. |

#### State Colors (Pastel Versions)

| State | HEX Code | Usage |
|--------|------------|-----|
| **Success** | `#81C784` | Same light green as primary |
| **Warning** | `#FFB74D` | Light pastel orange |
| **Error** | `#E57373` | Soft pinkish red |
| **Information** | `#64B5F6` | Light sky blue |

---

## "High Contrast" Theme

Specially designed for elderly people or those with vision problems. Complies with WCAG AAA (contrast ratio 7:1 or higher).

### High Contrast Light Theme

| Role | Sample | HEX Code | Usage |
|-----|---------|------------|-----|
| **Background** | ⚪ | `#FFFFFF` | Pure white for maximum contrast |
| **Primary Text** | ⚫ | `#000000` | Pure black for maximum readability |
| **Secondary Text** | ⚫ | `#333333` | Very dark gray, still with good contrast |
| **Primary** | 🔵 | `#0000CC` | Pure dark blue, maximum contrast on white |
| **Accent** | 🟠 | `#CC5500` | Vibrant dark orange |
| **Secondary** | 🟢 | `#006600` | Dark green |
| **Error** | 🔴 | `#CC0000` | Dark red |
| **Dividers/Borders** | ⚫ | `#000000` | Black and thicker (2px) |

### High Contrast Dark Theme

| Role | Sample | HEX Code | Usage |
|-----|---------|------------|-----|
| **Background** | ⚫ | `#000000` | Pure black |
| **Primary Text** | ⚪ | `#FFFFFF` | Pure white |
| **Secondary Text** | ⚪ | `#CCCCCC` | Very light gray |
| **Primary** | 🟡 | `#FFFF00` | Bright yellow, maximum contrast on black |
| **Accent** | 🔵 | `#00FFFF` | Bright cyan |
| **Secondary** | 🟢 | `#00FF00` | Bright lime green |
| **Error** | 🔴 | `#FF6666` | Light red |
| **Dividers/Borders** | ⚪ | `#FFFFFF` | White and thicker (2px) |

### Accessibility Features

- **Larger text**: Increased font sizes throughout the interface
- **Heavier typography**: Use of bold/semibold for better readability
- **Thicker borders**: 2px instead of standard for better visibility
- **Larger icons**: 28px instead of 24px
- **More spacing**: Increased padding on buttons and interactive elements
- **Underlined links**: TextButtons with underline for better identification

---

## Usage in Code

The colors are defined in `lib/theme/app_theme.dart`:

```dart
// Deep Emerald - Light Theme
static const Color deepEmeraldPrimaryLight = Color(0xFF1B5E20);
static const Color deepEmeraldBackgroundLight = Color(0xFFF5F5F5);
static const Color deepEmeraldTextPrimaryLight = Color(0xFF051F12);

// Deep Emerald - Dark Theme
static const Color deepEmeraldPrimaryDark = Color(0xFF81C784);
static const Color deepEmeraldBackgroundDark = Color(0xFF121212);
static const Color deepEmeraldTextPrimaryDark = Color(0xFFE0E0E0);

// High Contrast - Light Theme
static const Color highContrastPrimaryLight = Color(0xFF0000CC);
static const Color highContrastBackgroundLight = Color(0xFFFFFFFF);
static const Color highContrastTextPrimaryLight = Color(0xFF000000);

// High Contrast - Dark Theme
static const Color highContrastPrimaryDark = Color(0xFFFFFF00);
static const Color highContrastBackgroundDark = Color(0xFF000000);
static const Color highContrastTextPrimaryDark = Color(0xFFFFFFFF);
```

## Design Principles

1. **Accessibility**: All text/background pairs comply with WCAG 2.1 Level AA for contrast (AAA for High Contrast).
2. **Consistency**: Primary colors are used consistently throughout the application.
3. **Visual Hierarchy**: The use of different tones establishes a clear hierarchy of information.
4. **Naturalness**: The green palette conveys health, well-being, and trust.
5. **Inclusivity**: The High Contrast palette allows people with vision problems to use the application comfortably.

## References

- Material Design 3 Guidelines
- WCAG 2.1 Accessibility Standards
