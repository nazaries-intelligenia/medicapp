# Paleta de Colores - MedicApp

MedicApp ofrece dos paletas de colores optimizadas para accesibilidad:

- **Deep Emerald** (por defecto): Verde esmeralda de alto contraste
- **Alto Contraste**: Máximo contraste para personas con problemas de visión

---

## Tema "Deep Emerald" (Por Defecto)

Diseñado especialmente para personas mayores (Silver Surfers) con máxima legibilidad manteniendo la identidad verde de la marca. Cumple con los estándares WCAG AAA (ratio de contraste 19:1).

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

El tema oscuro de Deep Emerald está diseñado específicamente para personas mayores. Evita el negro absoluto (#000000) para reducir la fatiga visual y utiliza bordes iluminados para definir espacios.

#### Principios de Diseño Oscuro

1. **Botones como Lámparas**: En modo oscuro, los botones tienen fondo claro y texto oscuro para que "brillen".
2. **Bordes en lugar de Sombras**: Las sombras no funcionan bien en modo oscuro. Se usan bordes sutiles (#424242).
3. **Sin Negro Puro**: El fondo es #121212 (gris muy oscuro) para evitar el "smearing" en pantallas OLED.
4. **Texto Gris Perla**: El texto principal es #E0E0E0 (90% blanco) para evitar el deslumbramiento.

#### Colores Principales (Inversión Luminosa)

| Rol | Muestra | Código HEX | Uso |
|-----|---------|------------|-----|
| **Primario (Marca)** | 🟢 | `#81C784` | Verde Hoja Claro. Botones principales y estados activos. |
| **Texto sobre Primario** | ⚫ | `#003300` | El texto dentro del botón primario debe ser verde muy oscuro. |
| **Primario Variante** | 🟢 | `#66BB6A` | Tono más saturado para estados de "foco". |
| **Acento / Interactivo** | 🟢 | `#A5D6A7` | Para elementos flotantes (FAB) o interruptores activados. |

#### Colores de Fondo y Superficie

| Rol | Muestra | Código HEX | Uso |
|-----|---------|------------|-----|
| **Fondo Principal** | ⚫ | `#121212` | Gris muy oscuro estándar (Material Design). |
| **Superficie (Tarjetas)** | ⚫ | `#1E2623` | Gris verdoso oscuro. |
| **Borde de Tarjeta** | 🔘 | `#424242` | Borde gris sutil alrededor de las tarjetas. |
| **Divisores** | 🔘 | `#555555` | Líneas de separación con mayor contraste. |

#### Colores de Estado (Versiones Pastel)

| Estado | Código HEX | Uso |
|--------|------------|-----|
| **Éxito** | `#81C784` | Mismo verde claro del primario |
| **Advertencia** | `#FFB74D` | Naranja pastel claro |
| **Error** | `#E57373` | Rojo suave/rosado |
| **Información** | `#64B5F6` | Azul cielo claro |

---

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

---

## Uso en el Código

Los colores están definidos en `lib/theme/app_theme.dart`:

```dart
// Deep Emerald - Tema Claro
static const Color deepEmeraldPrimaryLight = Color(0xFF1B5E20);
static const Color deepEmeraldBackgroundLight = Color(0xFFF5F5F5);
static const Color deepEmeraldTextPrimaryLight = Color(0xFF051F12);

// Deep Emerald - Tema Oscuro
static const Color deepEmeraldPrimaryDark = Color(0xFF81C784);
static const Color deepEmeraldBackgroundDark = Color(0xFF121212);
static const Color deepEmeraldTextPrimaryDark = Color(0xFFE0E0E0);

// Alto Contraste - Tema Claro
static const Color highContrastPrimaryLight = Color(0xFF0000CC);
static const Color highContrastBackgroundLight = Color(0xFFFFFFFF);
static const Color highContrastTextPrimaryLight = Color(0xFF000000);

// Alto Contraste - Tema Oscuro
static const Color highContrastPrimaryDark = Color(0xFFFFFF00);
static const Color highContrastBackgroundDark = Color(0xFF000000);
static const Color highContrastTextPrimaryDark = Color(0xFFFFFFFF);
```

## Principios de Diseño

1. **Accesibilidad**: Todos los pares texto/fondo cumplen con WCAG 2.1 nivel AA (AAA para Alto Contraste).
2. **Consistencia**: Los colores primarios se usan consistentemente en toda la aplicación.
3. **Jerarquía Visual**: El uso de diferentes tonos establece una clara jerarquía de información.
4. **Naturalidad**: La paleta verde transmite salud, benestar y confianza.
5. **Inclusividad**: La paleta Alto Contraste permite a personas con problemas de visión usar la aplicación cómodamente.

## Referencias

- Material Design 3 Guidelines
- WCAG 2.1 Accessibility Standards
