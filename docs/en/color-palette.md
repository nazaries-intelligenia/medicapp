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

## Dark Theme

The dark theme maintains colors that complement the "Sea Green" palette adapted for low-light environments:

- **Primary**: `#5BA3F5` (light blue)
- **Secondary**: `#66D98E` (mint green)
- **Background**: `#121212` (deep black)
- **Surface**: `#1E1E1E` (dark gray)
- **Cards**: `#2C2C2C` (medium gray)
- **Primary Text**: `#E0E0E0` (light gray)
- **Secondary Text**: `#B0B0B0` (medium gray)
- **Divider**: `#424242` (dark gray)

## Usage in Code

The colors are defined in `lib/theme/app_theme.dart`:

```dart
// Main colors - Light Theme "Sea Green"
static const Color primaryLight = Color(0xFF2E8B57);
static const Color primaryVariantLight = Color(0xFF3CB371);
static const Color accentLight = Color(0xFF00C853);
static const Color secondaryLight = Color(0xFF81C784);

// Background colors
static const Color backgroundLight = Color(0xFFE8F5E9);
static const Color surfaceLight = Color(0xFFC8E6C9);
static const Color cardLight = Color(0xFFC8E6C9);

// Text colors
static const Color textPrimaryLight = Color(0xFF0D2E1C);
static const Color textSecondaryLight = Color(0xFF577D6A);

// Divider and border colors
static const Color dividerLight = Color(0xFFA5D6A7);

// State colors
static const Color success = Color(0xFF43A047);
static const Color warning = Color(0xFFFF9800);
static const Color error = Color(0xFFF44336);
static const Color info = Color(0xFF2196F3);
```

## Design Principles

1. **Accessibility**: All text/background pairs comply with WCAG 2.1 Level AA for contrast.
2. **Consistency**: Primary colors are used consistently throughout the application.
3. **Visual Hierarchy**: The use of different green tones establishes a clear hierarchy of information.
4. **Naturalness**: The green palette conveys health, well-being, and trust, appropriate for a medical application.

## References

- Material Design 3 Guidelines
- WCAG 2.1 Accessibility Standards
- Original palette: `Captura de pantalla 2025-11-22 101545.png`
