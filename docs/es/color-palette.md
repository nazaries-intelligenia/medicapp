# Paleta de Colores - MedicApp

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

## Tema Oscuro

El tema oscuro mantiene colores que complementan la paleta "Sea Green" adaptados para ambientes con poca luz:

- **Primario**: `#5BA3F5` (azul claro)
- **Secundario**: `#66D98E` (verde menta)
- **Fondo**: `#121212` (negro profundo)
- **Superficie**: `#1E1E1E` (gris oscuro)
- **Tarjetas**: `#2C2C2C` (gris medio)
- **Texto Primario**: `#E0E0E0` (gris claro)
- **Texto Secundario**: `#B0B0B0` (gris medio)
- **Divisor**: `#424242` (gris oscuro)

## Uso en el Código

Los colores están definidos en `lib/theme/app_theme.dart`:

```dart
// Colores principales - Tema claro "Sea Green"
static const Color primaryLight = Color(0xFF2E8B57);
static const Color primaryVariantLight = Color(0xFF3CB371);
static const Color accentLight = Color(0xFF00C853);
static const Color secondaryLight = Color(0xFF81C784);

// Colores de fondo
static const Color backgroundLight = Color(0xFFE8F5E9);
static const Color surfaceLight = Color(0xFFC8E6C9);
static const Color cardLight = Color(0xFFC8E6C9);

// Colores de texto
static const Color textPrimaryLight = Color(0xFF0D2E1C);
static const Color textSecondaryLight = Color(0xFF577D6A);

// Colores de divisores y bordes
static const Color dividerLight = Color(0xFFA5D6A7);

// Colores de estado
static const Color success = Color(0xFF43A047);
static const Color warning = Color(0xFFFF9800);
static const Color error = Color(0xFFF44336);
static const Color info = Color(0xFF2196F3);
```

## Principios de Diseño

1. **Accesibilidad**: Todos los pares texto/fondo cumplen con WCAG 2.1 nivel AA para contraste.
2. **Consistencia**: Los colores primarios se usan consistentemente en toda la aplicación.
3. **Jerarquía Visual**: El uso de diferentes tonos verdes establece una clara jerarquía de información.
4. **Naturalidad**: La paleta verde transmite salud, bienestar y confianza, apropiado para una aplicación médica.

## Referencias

- Material Design 3 Guidelines
- WCAG 2.1 Accessibility Standards
- Paleta original: `Captura de pantalla 2025-11-22 101545.png`
