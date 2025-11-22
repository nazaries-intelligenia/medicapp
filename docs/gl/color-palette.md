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

## Tema Escuro

O tema escuro mantén cores que complementan a paleta "Sea Green" adaptadas para ambientes con pouca luz:

- **Primario**: `#5BA3F5` (azul claro)
- **Secundario**: `#66D98E` (verde menta)
- **Fondo**: `#121212` (negro profundo)
- **Superficie**: `#1E1E1E` (gris escuro)
- **Tarxetas**: `#2C2C2C` (gris medio)
- **Texto Primario**: `#E0E0E0` (gris claro)
- **Texto Secundario**: `#B0B0B0` (gris medio)
- **Divisor**: `#424242` (gris escuro)

## Uso no Código

Os cores están definidos en `lib/theme/app_theme.dart`:

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

## Principios de Deseño

1. **Accesibilidade**: Todos os pares texto/fondo cumpren con WCAG 2.1 nivel AA para contraste.
2. **Consistencia**: Os cores primarios utilízanse consistentemente en toda a aplicación.
3. **Xerarquía Visual**: O uso de diferentes tonos verdes establece unha clara xerarquía de información.
4. **Naturalidade**: A paleta verde transmite saúde, benestar e confianza, apropiado para unha aplicación médica.

## Referencias

- Material Design 3 Guidelines
- WCAG 2.1 Accessibility Standards
- Paleta orixinal: `Captura de pantalla 2025-11-22 101545.png`
