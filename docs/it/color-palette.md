# Tavolozza di Colori - MedicApp

## Tema Chiaro "Sea Green"

MedicApp utilizza una tavolozza di colori ispirata alla natura con tonalità verdi che trasmettono salute, benessere e fiducia.

### Colori Principali

| Ruolo | Campione | Codice HEX | Utilizzo |
|-------|----------|------------|----------|
| **Primario (Marchio)** | 🟢 | `#2E8B57` | Pulsanti principali, barra di navigazione attiva, logo. Un verde "Sea Green" solido. |
| **Variante Primaria** | 🟢 | `#3CB371` | Stati "hover" o "pressed" dei pulsanti principali. Un po' più chiaro. |
| **Accento / Interattivo** | 🟢 | `#00C853` | Pulsanti di azione fluttuanti (FAB), notifiche importanti, "call to action" vibrante. |
| **Secondario / Supporto** | 🟢 | `#81C784` | Elementi secondari, interruttori (toggle) attivi, icone di minore gerarchia. |
| **Stato: Successo** | 🟢 | `#43A047` | Messaggi di conferma, controlli completati. Un verde funzionale standard. |

### Colori di Testo

| Ruolo | Campione | Codice HEX | Utilizzo |
|-------|----------|------------|----------|
| **Testo Scuro / Titoli** | ⚫ | `#0D2E1C` | Colore principale per il testo. Non è nero puro, è un verde foresta molto profondo. |
| **Testo Secondario** | 🔘 | `#577D6A` | Sottotitoli, testo di aiuto, icone inattive. |

### Colori di Sfondo e Superficie

| Ruolo | Campione | Codice HEX | Utilizzo |
|-------|----------|------------|----------|
| **Superficie (Schede)** | 🟢 | `#C8E6C9` | Sfondo per schede o contenitori sopra lo sfondo principale. Menta morbida. |
| **Sfondo Principale** | ⚪ | `#E8F5E9` | Il colore di sfondo generale dello schermo. Quasi bianco con una tinta verde impercettibile. |
| **Divisore / Bordo** | 🟢 | `#A5D6A7` | Linee sottili per separare sezioni o bordi di input inattivi. |

### Colori di Stato

| Stato | Codice HEX | Utilizzo |
|-------|------------|----------|
| **Successo** | `#43A047` | Operazioni completate con successo |
| **Avvertenza** | `#FF9800` | Avvisi che richiedono attenzione |
| **Errore** | `#F44336` | Errori critici o azioni distruttive |
| **Informazione** | `#2196F3` | Messaggi informativi generali |

## Tema Scuro

Il tema scuro mantiene colori che completano la tavolozza "Sea Green" adattati per ambienti con poca luce:

- **Primario**: `#5BA3F5` (blu chiaro)
- **Secondario**: `#66D98E` (verde menta)
- **Sfondo**: `#121212` (nero profondo)
- **Superficie**: `#1E1E1E` (grigio scuro)
- **Schede**: `#2C2C2C` (grigio medio)
- **Testo Primario**: `#E0E0E0` (grigio chiaro)
- **Testo Secondario**: `#B0B0B0` (grigio medio)
- **Divisore**: `#424242` (grigio scuro)

## Utilizzo nel Codice

I colori sono definiti in `lib/theme/app_theme.dart`:

```dart
// Colori principali - Tema chiaro "Sea Green"
static const Color primaryLight = Color(0xFF2E8B57);
static const Color primaryVariantLight = Color(0xFF3CB371);
static const Color accentLight = Color(0xFF00C853);
static const Color secondaryLight = Color(0xFF81C784);

// Colori di sfondo
static const Color backgroundLight = Color(0xFFE8F5E9);
static const Color surfaceLight = Color(0xFFC8E6C9);
static const Color cardLight = Color(0xFFC8E6C9);

// Colori di testo
static const Color textPrimaryLight = Color(0xFF0D2E1C);
static const Color textSecondaryLight = Color(0xFF577D6A);

// Colori di divisori e bordi
static const Color dividerLight = Color(0xFFA5D6A7);

// Colori di stato
static const Color success = Color(0xFF43A047);
static const Color warning = Color(0xFFFF9800);
static const Color error = Color(0xFFF44336);
static const Color info = Color(0xFF2196F3);
```

## Principi di Progettazione

1. **Accessibilità**: Tutte le coppie testo/sfondo rispettano lo standard WCAG 2.1 livello AA per il contrasto.
2. **Coerenza**: I colori primari sono utilizzati coerentemente in tutta l'applicazione.
3. **Gerarchia Visiva**: L'uso di diverse tonalità verdi stabilisce una chiara gerarchia delle informazioni.
4. **Naturalità**: La tavolozza verde trasmette salute, benessere e fiducia, appropriata per un'applicazione medica.

## Riferimenti

- Material Design 3 Guidelines
- WCAG 2.1 Accessibility Standards
- Tavolozza originale: `Captura de pantalla 2025-11-22 101545.png`
