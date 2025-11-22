# Palette de Couleurs - MedicApp

## Thème Clair "Sea Green"

MedicApp utilise une palette de couleurs inspirée par la nature avec des tons verts qui transmettent la santé, le bien-être et la confiance.

### Couleurs Principales

| Rôle | Exemple | Code HEX | Utilisation |
|-----|---------|------------|-----|
| **Principal (Marque)** | 🟢 | `#2E8B57` | Boutons principaux, barre de navigation active, logo. Un vert "Sea Green" solide. |
| **Variante Principale** | 🟢 | `#3CB371` | États "hover" ou "pressed" des boutons principaux. Un peu plus clair. |
| **Accent / Interactif** | 🟢 | `#00C853` | Boutons d'action flottants (FAB), notifications importantes, "call to action" vibrant. |
| **Secondaire / Support** | 🟢 | `#81C784` | Éléments secondaires, commutateurs (toggles) actifs, icônes de hiérarchie inférieure. |
| **État : Succès** | 🟢 | `#43A047` | Messages de confirmation, coches d'achèvement. Un vert fonctionnel standard. |

### Couleurs de Texte

| Rôle | Exemple | Code HEX | Utilisation |
|-----|---------|------------|-----|
| **Texte Foncé / Titres** | ⚫ | `#0D2E1C` | Couleur principale pour le texte. Ce n'est pas du noir pur, c'est un vert forêt très profond. |
| **Texte Secondaire** | 🔘 | `#577D6A` | Sous-titres, texte d'aide, icônes inactives. |

### Couleurs de Fond et Surface

| Rôle | Exemple | Code HEX | Utilisation |
|-----|---------|------------|-----|
| **Surface (Cartes)** | 🟢 | `#C8E6C9` | Fond pour les cartes ou conteneurs sur le fond principal. Menthe douce. |
| **Fond Principal** | ⚪ | `#E8F5E9` | La couleur de fond générale de l'écran. Presque blanc avec une teinte verte imperceptible. |
| **Diviseur / Bordure** | 🟢 | `#A5D6A7` | Lignes subtiles pour séparer les sections ou les bordures des entrées inactives. |

### Couleurs d'État

| État | Code HEX | Utilisation |
|--------|------------|-----|
| **Succès** | `#43A047` | Opérations complétées avec succès |
| **Avertissement** | `#FF9800` | Alertes nécessitant une attention |
| **Erreur** | `#F44336` | Erreurs critiques ou actions destructives |
| **Information** | `#2196F3` | Messages informatifs généraux |

## Thème Sombre "Dark Forest"

Le thème sombre utilise une palette inspirée d'une forêt nocturne avec des tons verts profonds et mystérieux :

| Rôle | Exemple | Code HEX | Utilisation |
|-----|---------|------------|-----|
| **Fond Global** | ⚫ | `#050A06` | Un vert presque imperceptiblement noir. Profond et mystérieux. |
| **Surface (Niveau 1)** | ⚫ | `#0D1F14` | Un ton un peu plus clair pour la barre de navigation ou les menus. |
| **Surface (Niveau 2)** | ⚫ | `#142B1E` | Pour les cartes flottantes ou les modales. |
| **Principal (Marque)** | 🟢 | `#A5D6A7` | Vert pâle désaturé. En dark mode, les couleurs pastel semblent plus élégantes. |
| **Accent Vibrant** | 🟢 | `#4CAF50` | Vert classique pour les boutons d'appel à l'action (CTA) importants. |
| **Texte Principal** | ⚪ | `#E8F5E9` | Un blanc avec une teinte verdâtre très subtile (menthe glacée). |
| **Texte Secondaire** | 🔘 | `#819CA9` | Gris avec une teinte verte/bleutée pour la hiérarchie visuelle. |
| **Icônes Inactives** | 🔘 | `#455A64` | Pour les éléments qui sont là mais ne nécessitent pas d'attention. |
| **Overlay (Couches)** | 🟢 | `#1E3B28` | Couleur pour mettre en évidence une ligne ou un élément sélectionné dans une liste. |
| **Resplandissement (Glow)** | 🟢 | `#004D40` | Un ton teal très foncé pour les arrière-plans dégradés subtils. |

## Utilisation dans le Code

Les couleurs sont définies dans `lib/theme/app_theme.dart`:

```dart
// Couleurs principales - Thème clair "Sea Green"
static const Color primaryLight = Color(0xFF2E8B57);
static const Color primaryVariantLight = Color(0xFF3CB371);
static const Color accentLight = Color(0xFF00C853);

// Couleurs principales - Thème sombre "Dark Forest"
static const Color primaryDark = Color(0xFFA5D6A7);
static const Color accentDark = Color(0xFF4CAF50);

static const Color secondaryLight = Color(0xFF81C784);
static const Color secondaryDark = Color(0xFF819CA9);

// Couleurs de fond
static const Color backgroundLight = Color(0xFFE8F5E9);
static const Color backgroundDark = Color(0xFF050A06);

static const Color surfaceLight = Color(0xFFC8E6C9);
static const Color surfaceDark = Color(0xFF0D1F14);

// Couleurs de cartes
static const Color cardLight = Color(0xFFC8E6C9);
static const Color cardDark = Color(0xFF142B1E);

// Couleurs de texte
static const Color textPrimaryLight = Color(0xFF0D2E1C);
static const Color textPrimaryDark = Color(0xFFE8F5E9);

static const Color textSecondaryLight = Color(0xFF577D6A);
static const Color textSecondaryDark = Color(0xFF819CA9);

// Icônes inactives
static const Color inactiveIconDark = Color(0xFF455A64);

// Overlay et sélection
static const Color overlayDark = Color(0xFF1E3B28);

// Resplandissement/Glow
static const Color glowDark = Color(0xFF004D40);

// Couleurs de diviseurs et bordures
static const Color dividerLight = Color(0xFFA5D6A7);
static const Color dividerDark = Color(0xFF455A64);

// Couleurs d'état
static const Color success = Color(0xFF43A047);
static const Color warning = Color(0xFFFF9800);
static const Color error = Color(0xFFF44336);
static const Color info = Color(0xFF2196F3);
```

## Principes de Conception

1. **Accessibilité** : Tous les paires texte/fond respectent la norme WCAG 2.1 niveau AA pour le contraste.
2. **Cohérence** : Les couleurs principales sont utilisées de manière cohérente dans toute l'application.
3. **Hiérarchie Visuelle** : L'utilisation de différentes nuances de vert établit une hiérarchie claire de l'information.
4. **Naturalité** : La palette verte transmet la santé, le bien-être et la confiance, appropriée pour une application médicale.

## Références

- Material Design 3 Guidelines
- WCAG 2.1 Accessibility Standards
- Palette thème clair : `Captura de pantalla 2025-11-22 101545.png`
- Palette thème sombre : `Captura de pantalla 2025-11-22 102516.png`
