# Paleta de Colores - MedicApp

## Tema "Deep Emerald" (Por Defecto)

MedicApp utiliza por defecto el tema "Deep Emerald", diseñado especialmente para personas mayores (Silver Surfers) con máxima legibilidad manteniendo la identidad verde de la marca. Cumple con los estándares WCAG AAA (ratio de contraste 19:1).

### Principios de Diseño

1. **Oscurecimiento del Primario**: Verde esmeralda profundo (#1B5E20) para garantizar que el texto blanco sobre los botones sea 100% legible.
2. **Fondo y Superficie Limpios**: Blancos y grises muy claros sin tintes verdes para evitar que los colores se "mezclen".
3. **Texto casi Negro**: Texto principal (#051F12) oscurecido al máximo para el mayor ratio de contraste.
4. **Bordes Explícitos**: Bordes sólidos para delimitar zonas táctiles, crucial para personas con pérdida de percepción de profundidad.

### Colores Principales (Marca y Acción)

| Rol | Muestra | Código HEX | Uso |
|-----|---------|------------|-----|
| **Primario (Marca)** | 🟢 | `#1B5E20` | Verde esmeralda oscuro. Garantiza contraste altísimo contra blanco. |
| **Interactivo / Foco** | 🟢 | `#2E7D32` | Estados "pressed" o elementos seleccionados. |
| **Acción Vibrante (FAB)** | 🟢 | `#00701A` | Verde vibrante pero sólido (no neón). |
| **Bordes de Elementos** | 🟢 | `#1B5E20` | Borde de 2px para delimitar zonas táctiles. |

### Colores de Texto (Legibilidad Máxima)

| Rol | Muestra | Código HEX | Uso |
|-----|---------|------------|-----|
| **Texto Principal** | ⚫ | `#051F12` | Casi negro con toque verde imperceptible. Contraste 19:1. |
| **Texto Secundario** | 🔘 | `#37474F` | Gris azulado oscuro, legible para ojos con cataratas. |
| **Texto sobre Primario** | ⚪ | `#FFFFFF` | Blanco puro en negrita para botones verdes. |

### Colores de Fondo y Superficie

| Rol | Muestra | Código HEX | Uso |
|-----|---------|------------|-----|
| **Fondo Principal** | ⚪ | `#F5F5F5` | Gris muy claro neutro. Las tarjetas "flotan" claramente. |
| **Superficie (Tarjetas)** | ⚪ | `#FFFFFF` | Blanco puro, mejor fondo para lectura. |
| **Borde de Tarjetas** | 🔘 | `#E0E0E0` | Define claramente los límites de las tarjetas. |
| **Divisor Fuerte** | 🔘 | `#BDBDBD` | Gris medio para separaciones claramente visibles. |

### Colores de Estado (Funcionales)

| Estado | Código HEX | Uso |
|--------|------------|-----|
| **Éxito** | `#1E7E34` | Verde oscuro para checks nítidos |
| **Advertencia** | `#E65100` | Naranja quemado de alta visibilidad |
| **Error** | `#C62828` | Rojo profundo y serio |
| **Información** | `#0277BD` | Azul fuerte, evita el cian claro |

### Tema Oscuro "Night Forest" (Accesible)

El tema oscuro de Deep Emerald se llama "Night Forest" y está diseñado específicamente para personas mayores. Evita el negro absoluto (#000000) para reducir la fatiga visual y utiliza bordes iluminados para definir espacios en lugar de sombras.

#### Principios de Diseño Oscuro

1. **Botones como Lámparas**: En modo oscuro, los botones tienen fondo claro y texto oscuro (inversión del tema claro) para que "brillen" sobre el fondo.
2. **Bordes en lugar de Sombras**: Las sombras no funcionan bien en modo oscuro. Se usan bordes sutiles (#424242) para delimitar tarjetas y contenedores.
3. **Sin Negro Puro**: El fondo es #121212 (gris muy oscuro) para evitar el "smearing" en pantallas OLED y reducir la fatiga visual.
4. **Texto Gris Perla**: El texto principal es #E0E0E0 (90% blanco) para evitar el deslumbramiento del blanco puro.

#### Colores Principales (Inversión Luminosa)

| Rol | Muestra | Código HEX | Uso |
|-----|---------|------------|-----|
| **Primario (Marca)** | 🟢 | `#81C784` | Verde Hoja Claro. Botones principales y estados activos. Es luminoso y fácil de ver. |
| **Texto sobre Primario** | ⚫ | `#003300` | **CRUCIAL**: El texto dentro del botón primario debe ser verde muy oscuro, NO blanco. |
| **Primario Variante** | 🟢 | `#66BB6A` | Tono más saturado para estados de "foco" o selección. |
| **Acento / Interactivo** | 🟢 | `#A5D6A7` | Para elementos flotantes (FAB) o interruptores activados. |
| **Borde de Foco** | 🟢 | `#81C784` | Borde de 2px alrededor de inputs activos. |

#### Colores de Fondo y Superficie

| Rol | Muestra | Código HEX | Uso |
|-----|---------|------------|-----|
| **Fondo Principal** | ⚫ | `#121212` | Gris muy oscuro estándar (Material Design). Evita el "smearing" en OLED. |
| **Superficie (Tarjetas)** | ⚫ | `#1E2623` | Gris verdoso oscuro. Ligeramente más claro con tinte verde. |
| **Borde de Tarjeta** | 🔘 | `#424242` | **Esencial para mayores**: Borde gris sutil alrededor de las tarjetas. |
| **Divisores** | 🔘 | `#555555` | Líneas de separación con mayor contraste. |

#### Colores de Texto

| Rol | Muestra | Código HEX | Uso |
|-----|---------|------------|-----|
| **Texto Principal** | ⚪ | `#E0E0E0` | Gris perla (90% blanco). Legible pero no "quema" la retina. |
| **Texto Secundario** | 🔘 | `#B0BEC5` | Gris azulado claro. Se lee mucho mejor que el gris oscuro. |

#### Colores de Estado (Versiones Pastel)

Los colores de estado oscuros no se ven bien en modo oscuro. Se usan versiones "pastel" o desaturadas:

| Estado | Código HEX | Uso |
|--------|------------|-----|
| **Éxito** | `#81C784` | Mismo verde claro del primario |
| **Advertencia** | `#FFB74D` | Naranja pastel claro, muy visible |
| **Error** | `#E57373` | Rojo suave/rosado. El rojo puro vibra demasiado sobre oscuro. |
| **Información** | `#64B5F6` | Azul cielo claro |

#### Comparativa Claro vs. Oscuro

| Elemento | Tema Claro (Deep Emerald) | Tema Oscuro (Night Forest) | ¿Por qué? |
|----------|---------------------------|----------------------------|-----------|
| **Botón** | Fondo Oscuro (#1B5E20), Texto Blanco | Fondo Claro (#81C784), Texto Oscuro | En modo oscuro, un botón oscuro se perdería. El botón debe ser una "lámpara". |
| **Tarjeta** | Fondo Blanco + Sombra | Fondo Gris Verdoso + Borde | Las sombras no funcionan en modo oscuro. El borde delimita la zona. |
| **Texto** | Negro casi puro | Blanco al 87% (#E0E0E0) | Reduce el deslumbramiento en entornos con poca luz. |

---

## Tema Claro "Sea Green"

MedicApp utiliza una paleta de colores inspirada en la naturaleza con tonos verdes que transmiten salud, bienestar y confianza.

### Colores Principales

| Rol | Muestra | Código HEX | Uso |
|-----|---------|------------|-----|
| **Primario (Marca)** | 🟢 | `#2E8B57` | Botones principales, barra de navegación activa, logo. Un verde "Sea Green" sólido. |
| **Primario Variante** | 🟢 | `#3CB371` | Estados "hover" o "pressed" de los botones principales. Un poco más claro. |
| **Acento / Interactivo** | 🟢 | `#00C853` | Botones de acción flotantes (FAB), notificaciones importantes, "call to action" vibrante. |
| **Secundario / Soporte** | 🟢 | `#81C784` | Elementos secundarios, interruptores (toggles) activos, íconos de menor jerarquía. |
| **Estado: Éxito** | 🟢 | `#43A047` | Mensajes de confirmación, checks de completado. Un verde estándar funcional. |

### Colores de Texto

| Rol | Muestra | Código HEX | Uso |
|-----|---------|------------|-----|
| **Texto Oscuro / Títulos** | ⚫ | `#0D2E1C` | Color principal para el texto. No es negro puro, es un verde bosque muy profundo. |
| **Texto Secundario** | 🔘 | `#577D6A` | Subtítulos, texto de ayuda, íconos inactivos. |

### Colores de Fondo y Superficie

| Rol | Muestra | Código HEX | Uso |
|-----|---------|------------|-----|
| **Superficie (Tarjetas)** | 🟢 | `#C8E6C9` | Fondo para tarjetas o contenedores sobre el fondo principal. Menta suave. |
| **Fondo Principal** | ⚪ | `#E8F5E9` | El color de fondo general de la pantalla. Casi blanco con un tinte verde imperceptible. |
| **Divisor / Borde** | 🟢 | `#A5D6A7` | Líneas sutiles para separar secciones o bordes de inputs inactivos. |

### Colores de Estado

| Estado | Código HEX | Uso |
|--------|------------|-----|
| **Éxito** | `#43A047` | Operaciones completadas exitosamente |
| **Advertencia** | `#FF9800` | Alertas que requieren atención |
| **Error** | `#F44336` | Errores críticos o acciones destructivas |
| **Información** | `#2196F3` | Mensajes informativos generales |

## Tema Oscuro "Dark Forest"

El tema oscuro utiliza una paleta inspirada en un bosque nocturno con tonos verdes profundos y misteriosos:

| Rol | Muestra | Código HEX | Uso |
|-----|---------|------------|-----|
| **Fondo Global** | ⚫ | `#050A06` | Un verde casi imperceptiblemente negro. Profundo y misterioso. |
| **Superficie (Nivel 1)** | ⚫ | `#0D1F14` | Un tono un poco más claro para la barra de navegación o menús. |
| **Superficie (Nivel 2)** | ⚫ | `#142B1E` | Para tarjetas flotantes o modales. |
| **Primario (Marca)** | 🟢 | `#A5D6A7` | Verde pálido desaturado. En dark mode, los colores pastel se ven más elegantes. |
| **Acento Vibrante** | 🟢 | `#4CAF50` | Verde clásico para botones de llamada a la acción (CTA) importantes. |
| **Texto Principal** | ⚪ | `#E8F5E9` | Un blanco con un tinte verdoso muy sutil (menta hielo). |
| **Texto Secundario** | 🔘 | `#819CA9` | Gris con matiz verde/azulado para jerarquía visual. |
| **Iconos Inactivos** | 🔘 | `#455A64` | Para elementos que están ahí pero no requieren atención. |
| **Overlay (Capas)** | 🟢 | `#1E3B28` | Color para destacar una fila o elemento seleccionado en una lista. |
| **Resplandor (Glow)** | 🟢 | `#004D40` | Un tono teal muy oscuro para fondos degradados sutiles. |

## Uso en el Código

Los colores están definidos en `lib/theme/app_theme.dart`:

```dart
// ============================================================
// Deep Emerald Colors - Light Theme (Default for Silver Surfers)
// ============================================================

static const Color deepEmeraldPrimaryLight = Color(0xFF1B5E20);
static const Color deepEmeraldPrimaryVariantLight = Color(0xFF2E7D32);
static const Color deepEmeraldAccentLight = Color(0xFF00701A);
static const Color deepEmeraldBackgroundLight = Color(0xFFF5F5F5);
static const Color deepEmeraldSurfaceLight = Color(0xFFFFFFFF);
static const Color deepEmeraldTextPrimaryLight = Color(0xFF051F12);
static const Color deepEmeraldTextSecondaryLight = Color(0xFF37474F);
static const Color deepEmeraldDividerLight = Color(0xFFBDBDBD);
static const Color deepEmeraldCardBorderLight = Color(0xFFE0E0E0);

// Deep Emerald State Colors (Light)
static const Color deepEmeraldSuccess = Color(0xFF1E7E34);
static const Color deepEmeraldWarning = Color(0xFFE65100);
static const Color deepEmeraldError = Color(0xFFC62828);
static const Color deepEmeraldInfo = Color(0xFF0277BD);

// ============================================================
// Deep Emerald Colors - Dark Theme "Night Forest" (Accessible)
// ============================================================

// Colores principales (inversión luminosa)
static const Color deepEmeraldPrimaryDark = Color(0xFF81C784);      // Verde hoja claro
static const Color deepEmeraldPrimaryVariantDark = Color(0xFF66BB6A);
static const Color deepEmeraldAccentDark = Color(0xFFA5D6A7);       // FABs y toggles
static const Color deepEmeraldOnPrimaryDark = Color(0xFF003300);    // Texto OSCURO sobre botones

// Fondos y superficies
static const Color deepEmeraldBackgroundDark = Color(0xFF121212);   // Gris oscuro (no negro puro)
static const Color deepEmeraldSurfaceDark = Color(0xFF1E2623);      // Gris verdoso oscuro
static const Color deepEmeraldCardDark = Color(0xFF1E2623);
static const Color deepEmeraldCardBorderDark = Color(0xFF424242);   // Borde visible para tarjetas

// Texto
static const Color deepEmeraldTextPrimaryDark = Color(0xFFE0E0E0);  // Gris perla (90% blanco)
static const Color deepEmeraldTextSecondaryDark = Color(0xFFB0BEC5);
static const Color deepEmeraldDividerDark = Color(0xFF555555);

// Estados (versiones pastel para modo oscuro)
static const Color deepEmeraldSuccessDark = Color(0xFF81C784);
static const Color deepEmeraldWarningDark = Color(0xFFFFB74D);
static const Color deepEmeraldErrorDark = Color(0xFFE57373);
static const Color deepEmeraldInfoDark = Color(0xFF64B5F6);
```

### Implementación de Bordes de Contenedor

Para asegurar que las tarjetas no desaparezcan visualmente en modo oscuro:

```dart
// En el tema claro, el borde puede ser sutil o transparente
cardTheme: CardThemeData(
  color: deepEmeraldCardLight,
  elevation: 1,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    side: const BorderSide(color: deepEmeraldCardBorderLight, width: 1),
  ),
),

// En el tema oscuro, el borde DEBE ser visible
cardTheme: CardThemeData(
  color: deepEmeraldCardDark,
  elevation: 0, // Sin sombra, usar borde
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    side: const BorderSide(color: deepEmeraldCardBorderDark, width: 1),
  ),
),
```

## Tema "Alto Contraste"

Diseñado especialmente para personas mayores o con problemas de visión. Cumple con WCAG AAA (ratio de contraste 7:1 o superior).

### Tema Claro Alto Contraste

| Rol | Muestra | Código HEX | Uso |
|-----|---------|------------|-----|
| **Fondo** | ⚪ | `#FFFFFF` | Blanco puro para máximo contraste |
| **Texto Primario** | ⚫ | `#000000` | Negro puro para máxima legibilidad |
| **Texto Secundario** | ⚫ | `#333333` | Gris muy oscuro, aún con buen contraste |
| **Primario** | 🔵 | `#0000CC` | Azul oscuro puro, máximo contraste sobre blanco |
| **Acento** | 🟠 | `#CC5500` | Naranja oscuro vibrante |
| **Secundario** | 🟢 | `#006600` | Verde oscuro |
| **Error** | 🔴 | `#CC0000` | Rojo oscuro |
| **Divisores/Bordes** | ⚫ | `#000000` | Negros y más gruesos (2px) |

### Tema Oscuro Alto Contraste

| Rol | Muestra | Código HEX | Uso |
|-----|---------|------------|-----|
| **Fondo** | ⚫ | `#000000` | Negro puro |
| **Texto Primario** | ⚪ | `#FFFFFF` | Blanco puro |
| **Texto Secundario** | ⚪ | `#CCCCCC` | Gris muy claro |
| **Primario** | 🟡 | `#FFFF00` | Amarillo brillante, máximo contraste sobre negro |
| **Acento** | 🔵 | `#00FFFF` | Cian brillante |
| **Secundario** | 🟢 | `#00FF00` | Verde lima brillante |
| **Error** | 🔴 | `#FF6666` | Rojo claro |
| **Divisores/Bordes** | ⚪ | `#FFFFFF` | Blancos y más gruesos (2px) |

### Características de Accesibilidad

- **Textos más grandes**: Tamaños de fuente aumentados en toda la interfaz
- **Mayor peso tipográfico**: Uso de bold/semibold para mejor legibilidad
- **Bordes más gruesos**: 2px en lugar del estándar para mejor visibilidad
- **Iconos más grandes**: 28px en lugar de 24px
- **Mayor espaciado**: Padding aumentado en botones y elementos interactivos
- **Enlaces subrayados**: TextButtons con subrayado para mejor identificación

## Principios de Diseño

1. **Accesibilidad**: Todos los pares texto/fondo cumplen con WCAG 2.1 nivel AA para contraste (AAA para Alto Contraste).
2. **Consistencia**: Los colores primarios se usan consistentemente en toda la aplicación.
3. **Jerarquía Visual**: El uso de diferentes tonos establece una clara jerarquía de información.
4. **Naturalidad**: La paleta verde transmite salud, bienestar y confianza, apropiado para una aplicación médica.
5. **Inclusividad**: La paleta Alto Contraste permite a personas con problemas de visión usar la aplicación cómodamente.

## Referencias

- Material Design 3 Guidelines
- WCAG 2.1 Accessibility Standards
- Paleta tema claro: `Captura de pantalla 2025-11-22 101545.png`
- Paleta tema oscuro: `Captura de pantalla 2025-11-22 102516.png`
