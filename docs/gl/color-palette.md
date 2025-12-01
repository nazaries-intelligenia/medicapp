# Paleta de Cores - MedicApp

MedicApp ofrece dúas paletas de cores optimizadas para accesibilidade:

- **Deep Emerald** (por defecto): Verde esmeralda de alto contraste
- **Alto Contraste**: Máximo contraste para persoas con problemas de visión

---

## Tema "Deep Emerald" (Por Defecto)

Deseñado especialmente para persoas maiores (Silver Surfers) con máxima lexibilidade mantendo a identidade verde da marca. Cumpre cos estándares WCAG AAA (ratio de contraste 19:1).

### Principios de Deseño

1. **Escurecemento do Primario**: Verde esmeralda profundo (#1B5E20) para garantir que o texto branco sobre os botóns sexa 100% lexible.
2. **Fondo e Superficie Limpos**: Brancos e grises moi claros sen matices verdes para evitar que as cores se "mesturen".
3. **Texto case Negro**: Texto principal (#051F12) escurecido ao máximo para o maior ratio de contraste.
4. **Bordes Explícitos**: Bordes sólidos para delimitar zonas táctiles, crucial para persoas con perda de percepción de profundidade.

### Cores Principais (Marca e Acción)

| Rol | Mostra | Código HEX | Uso |
|-----|---------|------------|-----|
| **Primario (Marca)** | 🟢 | `#1B5E20` | Verde esmeralda escuro. Garantiza contraste altísimo contra branco. |
| **Interactivo / Foco** | 🟢 | `#2E7D32` | Estados "pressed" ou elementos seleccionados. |
| **Acción Vibrante (FAB)** | 🟢 | `#00701A` | Verde vibrante pero sólido (non neón). |
| **Bordes de Elementos** | 🟢 | `#1B5E20` | Borde de 2px para delimitar zonas táctiles. |

### Cores de Texto (Lexibilidade Máxima)

| Rol | Mostra | Código HEX | Uso |
|-----|---------|------------|-----|
| **Texto Principal** | ⚫ | `#051F12` | Case negro con toque verde imperceptible. Contraste 19:1. |
| **Texto Secundario** | 🔘 | `#37474F` | Gris azulado escuro, lexible para ollos con cataratas. |
| **Texto sobre Primario** | ⚪ | `#FFFFFF` | Branco puro en negriña para botóns verdes. |

### Cores de Fondo e Superficie

| Rol | Mostra | Código HEX | Uso |
|-----|---------|------------|-----|
| **Fondo Principal** | ⚪ | `#F5F5F5` | Gris moi claro neutro. As tarxetas "flotan" claramente. |
| **Superficie (Tarxetas)** | ⚪ | `#FFFFFF` | Branco puro, mellor fondo para lectura. |
| **Borde de Tarxetas** | 🔘 | `#E0E0E0` | Define claramente os límites das tarxetas. |
| **Divisor Forte** | 🔘 | `#BDBDBD` | Gris medio para separacións claramente visibles. |

### Cores de Estado (Funcionais)

| Estado | Código HEX | Uso |
|--------|------------|-----|
| **Éxito** | `#1E7E34` | Verde escuro para checks nítidos |
| **Advertencia** | `#E65100` | Laranxa queimada de alta visibilidade |
| **Erro** | `#C62828` | Vermello profundo e serio |
| **Información** | `#0277BD` | Azul forte, evita o cian claro |

### Tema Escuro "Night Forest" (Accesible)

O tema escuro de Deep Emerald está deseñado especificamente para persoas maiores. Evita o negro absoluto (#000000) para reducir a fatiga visual e utiliza bordes iluminados para definir espazos.

#### Principios de Deseño Escuro

1. **Botóns como Lámpadas**: En modo escuro, os botóns teñen fondo claro e texto escuro para "brillar".
2. **Bordes en lugar de Sombras**: As sombras non funcionan ben en modo escuro. Úsanse bordes sutís (#424242).
3. **Sen Negro Puro**: O fondo é #121212 (gris moi escuro) para evitar o "smearing" en pantallas OLED.
4. **Texto Gris Perla**: O texto principal é #E0E0E0 (90% branco) para evitar o deslumbramento.

#### Cores Principais (Inversión Luminosa)

| Rol | Mostra | Código HEX | Uso |
|-----|---------|------------|-----|
| **Primario (Marca)** | 🟢 | `#81C784` | Verde Folla Claro. Botóns principais e estados activos. |
| **Texto sobre Primario** | ⚫ | `#003300` | O texto dentro do botón primario debe ser verde moi escuro. |
| **Primario Variante** | 🟢 | `#66BB6A` | Tono máis saturado para estados de "foco". |
| **Acento / Interactivo** | 🟢 | `#A5D6A7` | Para elementos flotantes (FAB) ou interruptores activados. |

#### Cores de Fondo e Superficie

| Rol | Mostra | Código HEX | Uso |
|-----|---------|------------|-----|
| **Fondo Principal** | ⚫ | `#121212` | Gris moi escuro estándar (Material Design). |
| **Superficie (Tarxetas)** | ⚫ | `#1E2623` | Gris verdoso escuro. |
| **Borde de Tarxeta** | 🔘 | `#424242` | Borde gris sutil arredor das tarxetas. |
| **Divisores** | 🔘 | `#555555` | Liñas de separación con maior contraste. |

#### Cores de Estado (Versións Pastel)

| Estado | Código HEX | Uso |
|--------|------------|-----|
| **Éxito** | `#81C784` | Mesmo verde claro do primario |
| **Advertencia** | `#FFB74D` | Laranxa pastel claro |
| **Erro** | `#E57373` | Vermello suave/rosado |
| **Información** | `#64B5F6` | Azul ceo claro |

---

## Tema "Alto Contraste"

Deseñado especialmente para persoas maiores ou con problemas de visión. Cumpre con WCAG AAA (ratio de contraste 7:1 ou superior).

### Tema Claro Alto Contraste

| Rol | Mostra | Código HEX | Uso |
|-----|---------|------------|-----|
| **Fondo** | ⚪ | `#FFFFFF` | Branco puro para máximo contraste |
| **Texto Primario** | ⚫ | `#000000` | Negro puro para máxima lexibilidade |
| **Texto Secundario** | ⚫ | `#333333` | Gris moi escuro, aínda con bo contraste |
| **Primario** | 🔵 | `#0000CC` | Azul escuro puro, máximo contraste sobre branco |
| **Acento** | 🟠 | `#CC5500` | Laranxa escuro vibrante |
| **Secundario** | 🟢 | `#006600` | Verde escuro |
| **Erro** | 🔴 | `#CC0000` | Vermello escuro |
| **Divisores/Bordos** | ⚫ | `#000000` | Negros e máis grosos (2px) |

### Tema Escuro Alto Contraste

| Rol | Mostra | Código HEX | Uso |
|-----|---------|------------|-----|
| **Fondo** | ⚫ | `#000000` | Negro puro |
| **Texto Primario** | ⚪ | `#FFFFFF` | Branco puro |
| **Texto Secundario** | ⚪ | `#CCCCCC` | Gris moi claro |
| **Primario** | 🟡 | `#FFFF00` | Amarelo brillante, máximo contraste sobre negro |
| **Acento** | 🔵 | `#00FFFF` | Cian brillante |
| **Secundario** | 🟢 | `#00FF00` | Verde lima brillante |
| **Erro** | 🔴 | `#FF6666` | Vermello claro |
| **Divisores/Bordos** | ⚪ | `#FFFFFF` | Brancos e máis grosos (2px) |

### Características de Accesibilidade

- **Textos máis grandes**: Tamaños de fonte aumentados en toda a interface
- **Maior peso tipográfico**: Uso de bold/semibold para mellor lexibilidade
- **Bordos máis grosos**: 2px en lugar do estándar para mellor visibilidade
- **Iconas máis grandes**: 28px en lugar de 24px
- **Maior espazado**: Padding aumentado en botóns e elementos interactivos
- **Ligazóns subliñadas**: TextButtons con subliñado para mellor identificación

---

## Uso no Código

As cores están definidas en `lib/theme/app_theme.dart`:

```dart
// Deep Emerald - Tema Claro
static const Color deepEmeraldPrimaryLight = Color(0xFF1B5E20);
static const Color deepEmeraldBackgroundLight = Color(0xFFF5F5F5);
static const Color deepEmeraldTextPrimaryLight = Color(0xFF051F12);

// Deep Emerald - Tema Escuro
static const Color deepEmeraldPrimaryDark = Color(0xFF81C784);
static const Color deepEmeraldBackgroundDark = Color(0xFF121212);
static const Color deepEmeraldTextPrimaryDark = Color(0xFFE0E0E0);

// Alto Contraste - Tema Claro
static const Color highContrastPrimaryLight = Color(0xFF0000CC);
static const Color highContrastBackgroundLight = Color(0xFFFFFFFF);
static const Color highContrastTextPrimaryLight = Color(0xFF000000);

// Alto Contraste - Tema Escuro
static const Color highContrastPrimaryDark = Color(0xFFFFFF00);
static const Color highContrastBackgroundDark = Color(0xFF000000);
static const Color highContrastTextPrimaryDark = Color(0xFFFFFFFF);
```

## Principios de Deseño

1. **Accesibilidade**: Todos os pares texto/fondo cumpren con WCAG 2.1 nivel AA para contraste (AAA para Alto Contraste).
2. **Consistencia**: As cores primarias utilízanse consistentemente en toda a aplicación.
3. **Xerarquía Visual**: O uso de diferentes tonos establece unha clara xerarquía de información.
4. **Naturalidade**: A paleta verde transmite saúde, benestar e confianza.
5. **Inclusividade**: A paleta Alto Contraste permite a persoas con problemas de visión usar a aplicación comodamente.

## Referencias

- Material Design 3 Guidelines
- WCAG 2.1 Accessibility Standards
