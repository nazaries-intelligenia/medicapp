# Color Palette - MedicApp

## Light Theme "Sea Green"

MedicApp uses a color palette inspired by nature with green tones that convey health, well-being, and trust.

### Primary Colors

| Role | Sample | HEX Code | Usage |
|-----|---------|------------|-----|
| **Primary (Brand)** | 🟢 | `#2E8B57` | Main buttons, active navigation bar, logo. A solid "Sea Green" green. |
| **Primary Variant** | 🟢 | `#3CB371` | "Hover" or "pressed" states of main buttons. A bit lighter. |
| **Accent / Interactive** | 🟢 | `#00C853` | Floating action buttons (FAB), important notifications, vibrant "call to action". |
| **Secondary / Support** | 🟢 | `#81C784` | Secondary elements, active toggles, lower hierarchy icons. |
| **State: Success** | 🟢 | `#43A047` | Confirmation messages, completed checkmarks. A standard functional green. |

### Text Colors

| Role | Sample | HEX Code | Usage |
|-----|---------|------------|-----|
| **Dark Text / Titles** | ⚫ | `#0D2E1C` | Main color for text. Not pure black, a very deep forest green. |
| **Secondary Text** | 🔘 | `#577D6A` | Subtitles, help text, inactive icons. |

### Background and Surface Colors

| Role | Sample | HEX Code | Usage |
|-----|---------|------------|-----|
| **Surface (Cards)** | 🟢 | `#C8E6C9` | Background for cards or containers over the main background. Soft mint. |
| **Main Background** | ⚪ | `#E8F5E9` | The general background color of the screen. Almost white with an imperceptible green tint. |
| **Divider / Border** | 🟢 | `#A5D6A7` | Subtle lines to separate sections or borders of inactive inputs. |

### State Colors

| State | HEX Code | Usage |
|--------|------------|-----|
| **Success** | `#43A047` | Successfully completed operations |
| **Warning** | `#FF9800` | Alerts that require attention |
| **Error** | `#F44336` | Critical errors or destructive actions |
| **Information** | `#2196F3` | General informational messages |

## Dark Theme "Dark Forest"

The dark theme uses a palette inspired by a nighttime forest with deep and mysterious green tones:

| Role | Sample | HEX Code | Usage |
|-----|---------|------------|-----|
| **Global Background** | ⚫ | `#050A06` | An almost imperceptibly black green. Deep and mysterious. |
| **Surface (Level 1)** | ⚫ | `#0D1F14` | A slightly lighter tone for the navigation bar or menus. |
| **Surface (Level 2)** | ⚫ | `#142B1E` | For floating cards or modals. |
| **Primary (Brand)** | 🟢 | `#A5D6A7` | Pale desaturated green. In dark mode, pastel colors look more elegant. |
| **Vibrant Accent** | 🟢 | `#4CAF50` | Classic green for important call-to-action (CTA) buttons. |
| **Primary Text** | ⚪ | `#E8F5E9` | A white with a very subtle greenish tint (ice mint). |
| **Secondary Text** | 🔘 | `#819CA9` | Gray with green/bluish hue for visual hierarchy. |
| **Inactive Icons** | 🔘 | `#455A64` | For elements that are present but don't require attention. |
| **Overlay (Layers)** | 🟢 | `#1E3B28` | Color to highlight a row or selected element in a list. |
| **Glow (Radiance)** | 🟢 | `#004D40` | A very dark teal tone for subtle gradient backgrounds. |

## Usage in Code

The colors are defined in `lib/theme/app_theme.dart`:

```dart
// Main colors - Light Theme "Sea Green"
static const Color primaryLight = Color(0xFF2E8B57);
static const Color primaryVariantLight = Color(0xFF3CB371);
static const Color accentLight = Color(0xFF00C853);

// Main colors - Dark Theme "Dark Forest"
static const Color primaryDark = Color(0xFFA5D6A7);
static const Color accentDark = Color(0xFF4CAF50);

static const Color secondaryLight = Color(0xFF81C784);
static const Color secondaryDark = Color(0xFF819CA9);

// Background colors
static const Color backgroundLight = Color(0xFFE8F5E9);
static const Color backgroundDark = Color(0xFF050A06);

static const Color surfaceLight = Color(0xFFC8E6C9);
static const Color surfaceDark = Color(0xFF0D1F14);

// Card colors
static const Color cardLight = Color(0xFFC8E6C9);
static const Color cardDark = Color(0xFF142B1E);

// Text colors
static const Color textPrimaryLight = Color(0xFF0D2E1C);
static const Color textPrimaryDark = Color(0xFFE8F5E9);

static const Color textSecondaryLight = Color(0xFF577D6A);
static const Color textSecondaryDark = Color(0xFF819CA9);

// Inactive icons
static const Color inactiveIconDark = Color(0xFF455A64);

// Overlay and selection
static const Color overlayDark = Color(0xFF1E3B28);

// Glow/Radiance
static const Color glowDark = Color(0xFF004D40);

// Divider and border colors
static const Color dividerLight = Color(0xFFA5D6A7);
static const Color dividerDark = Color(0xFF455A64);

// State colors
static const Color success = Color(0xFF43A047);
static const Color warning = Color(0xFFFF9800);
static const Color error = Color(0xFFF44336);
static const Color info = Color(0xFF2196F3);
```

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

## Design Principles

1. **Accessibility**: All text/background pairs comply with WCAG 2.1 Level AA for contrast (AAA for High Contrast).
2. **Consistency**: Primary colors are used consistently throughout the application.
3. **Visual Hierarchy**: The use of different tones establishes a clear hierarchy of information.
4. **Naturalness**: The green palette conveys health, well-being, and trust, appropriate for a medical application.
5. **Inclusivity**: The High Contrast palette allows people with vision problems to use the application comfortably.

## References

- Material Design 3 Guidelines
- WCAG 2.1 Accessibility Standards
- Light theme palette: `Captura de pantalla 2025-11-22 101545.png`
- Dark theme palette: `Captura de pantalla 2025-11-22 102516.png`
