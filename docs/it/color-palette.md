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

## Tema Scuro "Dark Forest"

Il tema scuro utilizza una tavolozza ispirata a una foresta notturna con tonalità verdi profonde e misteriose:

| Ruolo | Campione | Codice HEX | Utilizzo |
|-------|----------|------------|----------|
| **Sfondo Globale** | ⚫ | `#050A06` | Un verde quasi impercettibilmente nero. Profondo e misterioso. |
| **Superficie (Livello 1)** | ⚫ | `#0D1F14` | Un tono un po' più chiaro per la barra di navigazione o i menu. |
| **Superficie (Livello 2)** | ⚫ | `#142B1E` | Per schede fluttuanti o modali. |
| **Primario (Marchio)** | 🟢 | `#A5D6A7` | Verde pallido desaturato. In dark mode, i colori pastello risultano più eleganti. |
| **Accento Vibrante** | 🟢 | `#4CAF50` | Verde classico per pulsanti di chiamata all'azione (CTA) importanti. |
| **Testo Principale** | ⚪ | `#E8F5E9` | Un bianco con una tinta verdognola molto sottile (menta ghiaccio). |
| **Testo Secondario** | 🔘 | `#819CA9` | Grigio con tonalità verde/azzurra per la gerarchia visiva. |
| **Icone Inattive** | 🔘 | `#455A64` | Per elementi che sono presenti ma non richiedono attenzione. |
| **Overlay (Strati)** | 🟢 | `#1E3B28` | Colore per evidenziare una riga o elemento selezionato in un elenco. |
| **Resplandore (Glow)** | 🟢 | `#004D40` | Una tonalità teal molto scura per sfondi sfumati sottili. |

## Utilizzo nel Codice

I colori sono definiti in `lib/theme/app_theme.dart`:

```dart
// Colori principali - Tema chiaro "Sea Green"
static const Color primaryLight = Color(0xFF2E8B57);
static const Color primaryVariantLight = Color(0xFF3CB371);
static const Color accentLight = Color(0xFF00C853);

// Colori principali - Tema scuro "Dark Forest"
static const Color primaryDark = Color(0xFFA5D6A7);
static const Color accentDark = Color(0xFF4CAF50);

static const Color secondaryLight = Color(0xFF81C784);
static const Color secondaryDark = Color(0xFF819CA9);

// Colori di sfondo
static const Color backgroundLight = Color(0xFFE8F5E9);
static const Color backgroundDark = Color(0xFF050A06);

static const Color surfaceLight = Color(0xFFC8E6C9);
static const Color surfaceDark = Color(0xFF0D1F14);

// Colori di schede
static const Color cardLight = Color(0xFFC8E6C9);
static const Color cardDark = Color(0xFF142B1E);

// Colori di testo
static const Color textPrimaryLight = Color(0xFF0D2E1C);
static const Color textPrimaryDark = Color(0xFFE8F5E9);

static const Color textSecondaryLight = Color(0xFF577D6A);
static const Color textSecondaryDark = Color(0xFF819CA9);

// Icone inattive
static const Color inactiveIconDark = Color(0xFF455A64);

// Overlay e selezione
static const Color overlayDark = Color(0xFF1E3B28);

// Resplandore/Glow
static const Color glowDark = Color(0xFF004D40);

// Colori di divisori e bordi
static const Color dividerLight = Color(0xFFA5D6A7);
static const Color dividerDark = Color(0xFF455A64);

// Colori di stato
static const Color success = Color(0xFF43A047);
static const Color warning = Color(0xFFFF9800);
static const Color error = Color(0xFFF44336);
static const Color info = Color(0xFF2196F3);
```

## Tema "Alto Contrasto"

Progettato appositamente per persone anziane o con problemi di vista. Conforme a WCAG AAA (rapporto di contrasto 7:1 o superiore).

### Tema Chiaro Alto Contrasto

| Ruolo | Campione | Codice HEX | Uso |
|-----|---------|------------|-----|
| **Sfondo** | ⚪ | `#FFFFFF` | Bianco puro per massimo contrasto |
| **Testo Primario** | ⚫ | `#000000` | Nero puro per massima leggibilità |
| **Testo Secondario** | ⚫ | `#333333` | Grigio molto scuro, ancora buon contrasto |
| **Primario** | 🔵 | `#0000CC` | Blu scuro puro, massimo contrasto su bianco |
| **Accento** | 🟠 | `#CC5500` | Arancione scuro vibrante |
| **Secondario** | 🟢 | `#006600` | Verde scuro |
| **Errore** | 🔴 | `#CC0000` | Rosso scuro |
| **Divisori/Bordi** | ⚫ | `#000000` | Neri e più spessi (2px) |

### Tema Scuro Alto Contrasto

| Ruolo | Campione | Codice HEX | Uso |
|-----|---------|------------|-----|
| **Sfondo** | ⚫ | `#000000` | Nero puro |
| **Testo Primario** | ⚪ | `#FFFFFF` | Bianco puro |
| **Testo Secondario** | ⚪ | `#CCCCCC` | Grigio molto chiaro |
| **Primario** | 🟡 | `#FFFF00` | Giallo brillante, massimo contrasto su nero |
| **Accento** | 🔵 | `#00FFFF` | Ciano brillante |
| **Secondario** | 🟢 | `#00FF00` | Verde lime brillante |
| **Errore** | 🔴 | `#FF6666` | Rosso chiaro |
| **Divisori/Bordi** | ⚪ | `#FFFFFF` | Bianchi e più spessi (2px) |

### Caratteristiche di Accessibilità

- **Testi più grandi**: Dimensioni dei caratteri aumentate in tutta l'interfaccia
- **Peso tipografico maggiore**: Uso di bold/semibold per migliore leggibilità
- **Bordi più spessi**: 2px invece dello standard per migliore visibilità
- **Icone più grandi**: 28px invece di 24px
- **Maggiore spaziatura**: Padding aumentato su pulsanti ed elementi interattivi
- **Link sottolineati**: TextButtons con sottolineatura per migliore identificazione

## Principi di Progettazione

1. **Accessibilità**: Tutte le coppie testo/sfondo rispettano lo standard WCAG 2.1 livello AA per il contrasto (AAA per Alto Contrasto).
2. **Coerenza**: I colori primari sono utilizzati coerentemente in tutta l'applicazione.
3. **Gerarchia Visiva**: L'uso di diverse tonalità stabilisce una chiara gerarchia delle informazioni.
4. **Naturalità**: La tavolozza verde trasmette salute, benessere e fiducia, appropriata per un'applicazione medica.
5. **Inclusività**: La tavolozza Alto Contrasto permette alle persone con problemi di vista di usare l'applicazione comodamente.

## Riferimenti

- Material Design 3 Guidelines
- WCAG 2.1 Accessibility Standards
- Tavolozza tema chiaro: `Captura de pantalla 2025-11-22 101545.png`
- Tavolozza tema scuro: `Captura de pantalla 2025-11-22 102516.png`
