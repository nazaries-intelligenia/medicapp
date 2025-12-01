# Palette de Couleurs - MedicApp

MedicApp propose deux palettes de couleurs optimisées pour l'accessibilité :

- **Deep Emerald** (par défaut) : Vert émeraude à contraste élevé
- **Contraste Élevé** : Contraste maximum pour les personnes ayant des problèmes de vision

---

## Thème "Deep Emerald" (Par Défaut)

Conçu spécialement pour les personnes âgées (Silver Surfers) avec une lisibilité maximale tout en maintenant l'identité verte de la marque. Conforme aux standards WCAG AAA (ratio de contraste 19:1).

### Principes de Design

1. **Assombrissement du Primaire** : Vert émeraude profond (#1B5E20) pour garantir que le texte blanc sur les boutons soit 100% lisible.
2. **Fond et Surface Propres** : Blancs et gris très clairs sans teintes vertes pour éviter que les couleurs ne se "mélangent".
3. **Texte Presque Noir** : Texte principal (#051F12) assombri au maximum pour le plus grand ratio de contraste.
4. **Bordures Explicites** : Bordures solides pour délimiter les zones tactiles, crucial pour les personnes avec perte de perception de la profondeur.

### Couleurs Principales (Marque et Action)

| Rôle | Exemple | Code HEX | Utilisation |
|-----|---------|------------|-----|
| **Principal (Marque)** | 🟢 | `#1B5E20` | Vert émeraude foncé. Garantit un contraste très élevé contre le blanc. |
| **Interactif / Focus** | 🟢 | `#2E7D32` | États "pressed" ou éléments sélectionnés. |
| **Action Vibrante (FAB)** | 🟢 | `#00701A` | Vert vibrant mais solide (pas néon). |
| **Bordures d'Éléments** | 🟢 | `#1B5E20` | Bordure de 2px pour délimiter les zones tactiles. |

### Couleurs de Texte (Lisibilité Maximale)

| Rôle | Exemple | Code HEX | Utilisation |
|-----|---------|------------|-----|
| **Texte Principal** | ⚫ | `#051F12` | Presque noir avec touche verte imperceptible. Contraste 19:1. |
| **Texte Secondaire** | 🔘 | `#37474F` | Gris bleuté foncé, lisible pour les yeux avec cataractes. |
| **Texte sur Primaire** | ⚪ | `#FFFFFF` | Blanc pur en gras pour boutons verts. |

### Couleurs de Fond et Surface

| Rôle | Exemple | Code HEX | Utilisation |
|-----|---------|------------|-----|
| **Fond Principal** | ⚪ | `#F5F5F5` | Gris très clair neutre. Les cartes "flottent" clairement. |
| **Surface (Cartes)** | ⚪ | `#FFFFFF` | Blanc pur, meilleur fond pour la lecture. |
| **Bordure de Cartes** | 🔘 | `#E0E0E0` | Définit clairement les limites des cartes. |
| **Diviseur Fort** | 🔘 | `#BDBDBD` | Gris moyen pour des séparations clairement visibles. |

### Couleurs d'État (Fonctionnelles)

| État | Code HEX | Utilisation |
|--------|------------|-----|
| **Succès** | `#1E7E34` | Vert foncé pour des coches nettes |
| **Avertissement** | `#E65100` | Orange brûlé haute visibilité |
| **Erreur** | `#C62828` | Rouge profond et sérieux |
| **Information** | `#0277BD` | Bleu fort, évite le cyan clair |

### Thème Sombre "Night Forest" (Accessible)

Le thème sombre Deep Emerald est conçu spécifiquement pour les personnes âgées. Évite le noir absolu (#000000) pour réduire la fatigue visuelle et utilise des bordures illuminées pour définir les espaces.

#### Principes de Design Sombre

1. **Boutons comme Lampes** : En mode sombre, les boutons ont un fond clair et un texte sombre pour "briller".
2. **Bordures au lieu d'Ombres** : Les ombres ne fonctionnent pas bien en mode sombre. Des bordures subtiles (#424242) sont utilisées.
3. **Pas de Noir Pur** : Le fond est #121212 (gris très sombre) pour éviter le "smearing" sur les écrans OLED.
4. **Texte Gris Perle** : Le texte principal est #E0E0E0 (90% blanc) pour éviter l'éblouissement.

#### Couleurs Principales (Inversion Lumineuse)

| Rôle | Exemple | Code HEX | Utilisation |
|-----|---------|------------|-----|
| **Principal (Marque)** | 🟢 | `#81C784` | Vert Feuille Clair. Boutons principaux et états actifs. |
| **Texte sur Principal** | ⚫ | `#003300` | Le texte dans le bouton principal doit être vert très foncé. |
| **Variante Principale** | 🟢 | `#66BB6A` | Ton plus saturé pour les états "focus". |
| **Accent / Interactif** | 🟢 | `#A5D6A7` | Pour éléments flottants (FAB) ou commutateurs activés. |

#### Couleurs de Fond et Surface

| Rôle | Exemple | Code HEX | Utilisation |
|-----|---------|------------|-----|
| **Fond Principal** | ⚫ | `#121212` | Gris très sombre standard (Material Design). |
| **Surface (Cartes)** | ⚫ | `#1E2623` | Gris verdâtre sombre. |
| **Bordure de Carte** | 🔘 | `#424242` | Bordure grise subtile autour des cartes. |
| **Diviseurs** | 🔘 | `#555555` | Lignes de séparation avec contraste plus élevé. |

#### Couleurs d'État (Versions Pastel)

| État | Code HEX | Utilisation |
|--------|------------|-----|
| **Succès** | `#81C784` | Même vert clair que le principal |
| **Avertissement** | `#FFB74D` | Orange pastel clair |
| **Erreur** | `#E57373` | Rouge doux/rosé |
| **Information** | `#64B5F6` | Bleu ciel clair |

---

## Thème "Contraste Élevé"

Conçu spécialement pour les personnes âgées ou ayant des problèmes de vision. Conforme à WCAG AAA (rapport de contraste 7:1 ou supérieur).

### Thème Clair Contraste Élevé

| Rôle | Échantillon | Code HEX | Utilisation |
|-----|---------|------------|-----|
| **Fond** | ⚪ | `#FFFFFF` | Blanc pur pour un contraste maximum |
| **Texte Principal** | ⚫ | `#000000` | Noir pur pour une lisibilité maximale |
| **Texte Secondaire** | ⚫ | `#333333` | Gris très foncé, toujours bon contraste |
| **Principal** | 🔵 | `#0000CC` | Bleu foncé pur, contraste maximum sur blanc |
| **Accent** | 🟠 | `#CC5500` | Orange foncé vibrant |
| **Secondaire** | 🟢 | `#006600` | Vert foncé |
| **Erreur** | 🔴 | `#CC0000` | Rouge foncé |
| **Diviseurs/Bordures** | ⚫ | `#000000` | Noirs et plus épais (2px) |

### Thème Sombre Contraste Élevé

| Rôle | Échantillon | Code HEX | Utilisation |
|-----|---------|------------|-----|
| **Fond** | ⚫ | `#000000` | Noir pur |
| **Texte Principal** | ⚪ | `#FFFFFF` | Blanc pur |
| **Texte Secondaire** | ⚪ | `#CCCCCC` | Gris très clair |
| **Principal** | 🟡 | `#FFFF00` | Jaune brillant, contraste maximum sur noir |
| **Accent** | 🔵 | `#00FFFF` | Cyan brillant |
| **Secondaire** | 🟢 | `#00FF00` | Vert citron brillant |
| **Erreur** | 🔴 | `#FF6666` | Rouge clair |
| **Diviseurs/Bordures** | ⚪ | `#FFFFFF` | Blancs et plus épais (2px) |

### Caractéristiques d'Accessibilité

- **Textes plus grands** : Tailles de police augmentées dans toute l'interface
- **Poids typographique supérieur** : Utilisation de bold/semibold pour une meilleure lisibilité
- **Bordures plus épaisses** : 2px au lieu du standard pour une meilleure visibilité
- **Icônes plus grandes** : 28px au lieu de 24px
- **Espacement supérieur** : Padding augmenté sur les boutons et éléments interactifs
- **Liens soulignés** : TextButtons avec soulignement pour une meilleure identification

---

## Utilisation dans le Code

Les couleurs sont définies dans `lib/theme/app_theme.dart` :

```dart
// Deep Emerald - Thème Clair
static const Color deepEmeraldPrimaryLight = Color(0xFF1B5E20);
static const Color deepEmeraldBackgroundLight = Color(0xFFF5F5F5);
static const Color deepEmeraldTextPrimaryLight = Color(0xFF051F12);

// Deep Emerald - Thème Sombre
static const Color deepEmeraldPrimaryDark = Color(0xFF81C784);
static const Color deepEmeraldBackgroundDark = Color(0xFF121212);
static const Color deepEmeraldTextPrimaryDark = Color(0xFFE0E0E0);

// Contraste Élevé - Thème Clair
static const Color highContrastPrimaryLight = Color(0xFF0000CC);
static const Color highContrastBackgroundLight = Color(0xFFFFFFFF);
static const Color highContrastTextPrimaryLight = Color(0xFF000000);

// Contraste Élevé - Thème Sombre
static const Color highContrastPrimaryDark = Color(0xFFFFFF00);
static const Color highContrastBackgroundDark = Color(0xFF000000);
static const Color highContrastTextPrimaryDark = Color(0xFFFFFFFF);
```

## Principes de Conception

1. **Accessibilité** : Tous les paires texte/fond respectent la norme WCAG 2.1 niveau AA pour le contraste (AAA pour Contraste Élevé).
2. **Cohérence** : Les couleurs principales sont utilisées de manière cohérente dans toute l'application.
3. **Hiérarchie Visuelle** : L'utilisation de différentes nuances établit une hiérarchie claire de l'information.
4. **Naturalité** : La palette verte transmet la santé, le bien-être et la confiance.
5. **Inclusivité** : La palette Contraste Élevé permet aux personnes ayant des problèmes de vision d'utiliser l'application confortablement.

## Références

- Material Design 3 Guidelines
- WCAG 2.1 Accessibility Standards
