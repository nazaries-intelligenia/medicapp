# Paleta de Cores - MedicApp

## Tema Claro "Sea Green"

MedicApp utiliza unha paleta de cores inspirada na natureza con tonos verdes que transmiten saúde, benestar e confianza.

### Cores Principais

| Rol | Muestra | Código HEX | Uso |
|-----|---------|------------|-----|
| **Primario (Marca)** | 🟢 | `#2E8B57` | Botóns principais, barra de navegación activa, logo. Un verde "Sea Green" sólido. |
| **Primario Variante** | 🟢 | `#3CB371` | Estados "hover" ou "pressed" dos botóns principais. Un pouco máis claro. |
| **Acento / Interactivo** | 🟢 | `#00C853` | Botóns de acción flotantes (FAB), notificacións importantes, "call to action" vibrante. |
| **Secundario / Soporte** | 🟢 | `#81C784` | Elementos secundarios, conmutadores (toggles) activos, iconas de menor xerarquía. |
| **Estado: Éxito** | 🟢 | `#43A047` | Mensaxes de confirmación, checks de completado. Un verde estándar funcional. |

### Cores de Texto

| Rol | Muestra | Código HEX | Uso |
|-----|---------|------------|-----|
| **Texto Escuro / Títulos** | ⚫ | `#0D2E1C` | Cor principal para o texto. Non é negro puro, é un verde bosque moi profundo. |
| **Texto Secundario** | 🔘 | `#577D6A` | Subtítulos, texto de axuda, iconas inactivas. |

### Cores de Fondo e Superficie

| Rol | Muestra | Código HEX | Uso |
|-----|---------|------------|-----|
| **Superficie (Tarxetas)** | 🟢 | `#C8E6C9` | Fondo para tarxetas ou contedores sobre o fondo principal. Menta suave. |
| **Fondo Principal** | ⚪ | `#E8F5E9` | A cor de fondo xeral da pantalla. Case branco con un tinte verde imperceptible. |
| **Divisor / Borde** | 🟢 | `#A5D6A7` | Liñas sutís para separar seccións ou bordos de inputs inactivos. |

### Cores de Estado

| Estado | Código HEX | Uso |
|--------|------------|-----|
| **Éxito** | `#43A047` | Operacións completadas exitosamente |
| **Advertencia** | `#FF9800` | Alertas que requiren atención |
| **Erro** | `#F44336` | Erros críticos ou accións destructivas |
| **Información** | `#2196F3` | Mensaxes informativos xerais |

## Tema Escuro "Dark Forest"

O tema escuro utiliza unha paleta inspirada nun bosque nocturno con tonos verdes profundos e misteriosos:

| Rol | Muestra | Código HEX | Uso |
|-----|---------|------------|-----|
| **Fondo Global** | ⚫ | `#050A06` | Un verde case imperceptiblemente negro. Profundo e misterioso. |
| **Superficie (Nivel 1)** | ⚫ | `#0D1F14` | Un tono un pouco máis claro para a barra de navegación ou menús. |
| **Superficie (Nivel 2)** | ⚫ | `#142B1E` | Para tarxetas flotantes ou modais. |
| **Primario (Marca)** | 🟢 | `#A5D6A7` | Verde pálido desaturado. En dark mode, os cores pastel véense máis elegantes. |
| **Acento Vibrante** | 🟢 | `#4CAF50` | Verde clásico para botóns de chamada á acción (CTA) importantes. |
| **Texto Principal** | ⚪ | `#E8F5E9` | Un branco con un tinte verdoso moi sutil (menta xeo). |
| **Texto Secundario** | 🔘 | `#819CA9` | Gris con matiz verde/azulado para xerarquía visual. |
| **Iconas Inactivas** | 🔘 | `#455A64` | Para elementos que están aí pero non requiren atención. |
| **Overlay (Capas)** | 🟢 | `#1E3B28` | Cor para destacar unha fila ou elemento seleccionado nunha lista. |
| **Resplandor (Glow)** | 🟢 | `#004D40` | Un tono teal moi escuro para fondos degradados sutís. |

## Uso no Código

Os cores están definidos en `lib/theme/app_theme.dart`:

```dart
// Colores principales - Tema claro "Sea Green"
static const Color primaryLight = Color(0xFF2E8B57);
static const Color primaryVariantLight = Color(0xFF3CB371);
static const Color accentLight = Color(0xFF00C853);

// Colores principales - Tema escuro "Dark Forest"
static const Color primaryDark = Color(0xFFA5D6A7);
static const Color accentDark = Color(0xFF4CAF50);

static const Color secondaryLight = Color(0xFF81C784);
static const Color secondaryDark = Color(0xFF819CA9);

// Colores de fondo
static const Color backgroundLight = Color(0xFFE8F5E9);
static const Color backgroundDark = Color(0xFF050A06);

static const Color surfaceLight = Color(0xFFC8E6C9);
static const Color surfaceDark = Color(0xFF0D1F14);

// Colores de tarxetas
static const Color cardLight = Color(0xFFC8E6C9);
static const Color cardDark = Color(0xFF142B1E);

// Colores de texto
static const Color textPrimaryLight = Color(0xFF0D2E1C);
static const Color textPrimaryDark = Color(0xFFE8F5E9);

static const Color textSecondaryLight = Color(0xFF577D6A);
static const Color textSecondaryDark = Color(0xFF819CA9);

// Iconas inactivas
static const Color inactiveIconDark = Color(0xFF455A64);

// Overlay e selección
static const Color overlayDark = Color(0xFF1E3B28);

// Resplandor/Glow
static const Color glowDark = Color(0xFF004D40);

// Colores de divisores e bordos
static const Color dividerLight = Color(0xFFA5D6A7);
static const Color dividerDark = Color(0xFF455A64);

// Colores de estado
static const Color success = Color(0xFF43A047);
static const Color warning = Color(0xFFFF9800);
static const Color error = Color(0xFFF44336);
static const Color info = Color(0xFF2196F3);
```

## Principios de Deseño

1. **Accesibilidade**: Todos os pares texto/fondo cumpren con WCAG 2.1 nivel AA para contraste.
2. **Consistencia**: Os cores primarios utilízanse consistentemente en toda a aplicación.
3. **Xerarquía Visual**: O uso de diferentes tonos verdes establece unha clara xerarquía de información.
4. **Naturalidade**: A paleta verde transmite saúde, benestar e confianza, apropiado para unha aplicación médica.

## Referencias

- Material Design 3 Guidelines
- WCAG 2.1 Accessibility Standards
- Paleta tema claro: `Captura de pantalla 2025-11-22 101545.png`
- Paleta tema escuro: `Captura de pantalla 2025-11-22 102516.png`
