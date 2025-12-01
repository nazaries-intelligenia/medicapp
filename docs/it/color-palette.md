# Tavolozza di Colori - MedicApp

MedicApp offre due tavolozze di colori ottimizzate per l'accessibilità:

- **Deep Emerald** (predefinito): Verde smeraldo ad alto contrasto
- **Alto Contrasto**: Massimo contrasto per persone con problemi di vista

---

## Tema "Deep Emerald" (Predefinito)

Progettato appositamente per utenti anziani (Silver Surfers) con massima leggibilità mantenendo l'identità verde del marchio. Conforme agli standard WCAG AAA (rapporto di contrasto 19:1).

### Principi di Design

1. **Scurimento del Primario**: Verde smeraldo profondo (#1B5E20) per garantire che il testo bianco sui pulsanti sia leggibile al 100%.
2. **Sfondo e Superficie Puliti**: Bianchi e grigi molto chiari senza sfumature verdi per evitare che i colori si "mescolino".
3. **Testo Quasi Nero**: Testo principale (#051F12) scurito al massimo per il più alto rapporto di contrasto.
4. **Bordi Espliciti**: Bordi solidi per delimitare le zone touch, cruciale per persone con perdita di percezione della profondità.

### Colori Principali (Marchio e Azione)

| Ruolo | Campione | Codice HEX | Utilizzo |
|-------|----------|------------|----------|
| **Primario (Marchio)** | 🟢 | `#1B5E20` | Verde smeraldo scuro. Garantisce contrasto altissimo contro il bianco. |
| **Interattivo / Focus** | 🟢 | `#2E7D32` | Stati "pressed" o elementi selezionati. |
| **Azione Vibrante (FAB)** | 🟢 | `#00701A` | Verde vibrante ma solido (non neon). |
| **Bordi Elementi** | 🟢 | `#1B5E20` | Bordo di 2px per delimitare le zone touch. |

### Colori di Testo (Leggibilità Massima)

| Ruolo | Campione | Codice HEX | Utilizzo |
|-------|----------|------------|----------|
| **Testo Principale** | ⚫ | `#051F12` | Quasi nero con tocco verde impercettibile. Contrasto 19:1. |
| **Testo Secondario** | 🔘 | `#37474F` | Grigio bluastro scuro, leggibile per occhi con cataratta. |
| **Testo su Primario** | ⚪ | `#FFFFFF` | Bianco puro in grassetto per pulsanti verdi. |

### Colori di Sfondo e Superficie

| Ruolo | Campione | Codice HEX | Utilizzo |
|-------|----------|------------|----------|
| **Sfondo Principale** | ⚪ | `#F5F5F5` | Grigio molto chiaro neutro. Le schede "galleggiano" chiaramente. |
| **Superficie (Schede)** | ⚪ | `#FFFFFF` | Bianco puro, miglior sfondo per la lettura. |
| **Bordo Schede** | 🔘 | `#E0E0E0` | Definisce chiaramente i limiti delle schede. |
| **Divisore Forte** | 🔘 | `#BDBDBD` | Grigio medio per separazioni chiaramente visibili. |

### Colori di Stato (Funzionali)

| Stato | Codice HEX | Utilizzo |
|--------|------------|----------|
| **Successo** | `#1E7E34` | Verde scuro per check nitidi |
| **Avvertimento** | `#E65100` | Arancione bruciato ad alta visibilità |
| **Errore** | `#C62828` | Rosso profondo e serio |
| **Informazione** | `#0277BD` | Blu forte, evita il ciano chiaro |

### Tema Scuro "Night Forest" (Accessibile)

Il tema scuro Deep Emerald è progettato specificamente per utenti anziani. Evita il nero assoluto (#000000) per ridurre l'affaticamento visivo e utilizza bordi illuminati per definire gli spazi.

#### Principi di Design Scuro

1. **Pulsanti come Lampade**: In modalità scura, i pulsanti hanno sfondo chiaro e testo scuro per "brillare".
2. **Bordi invece di Ombre**: Le ombre non funzionano bene in modalità scura. Si usano bordi sottili (#424242).
3. **Niente Nero Puro**: Lo sfondo è #121212 (grigio molto scuro) per evitare lo "smearing" sugli schermi OLED.
4. **Testo Grigio Perla**: Il testo principale è #E0E0E0 (90% bianco) per evitare l'abbagliamento.

#### Colori Principali (Inversione Luminosa)

| Ruolo | Campione | Codice HEX | Utilizzo |
|-------|----------|------------|----------|
| **Primario (Marchio)** | 🟢 | `#81C784` | Verde Foglia Chiaro. Pulsanti principali e stati attivi. |
| **Testo su Primario** | ⚫ | `#003300` | Il testo nel pulsante primario deve essere verde molto scuro. |
| **Variante Primaria** | 🟢 | `#66BB6A` | Tono più saturo per stati "focus". |
| **Accento / Interattivo** | 🟢 | `#A5D6A7` | Per elementi fluttuanti (FAB) o interruttori attivati. |

#### Colori di Sfondo e Superficie

| Ruolo | Campione | Codice HEX | Utilizzo |
|-------|----------|------------|----------|
| **Sfondo Principale** | ⚫ | `#121212` | Grigio molto scuro standard (Material Design). |
| **Superficie (Schede)** | ⚫ | `#1E2623` | Grigio verdastro scuro. |
| **Bordo Scheda** | 🔘 | `#424242` | Bordo grigio sottile intorno alle schede. |
| **Divisori** | 🔘 | `#555555` | Linee di separazione con contrasto maggiore. |

#### Colori di Stato (Versioni Pastello)

| Stato | Codice HEX | Utilizzo |
|--------|------------|----------|
| **Successo** | `#81C784` | Stesso verde chiaro del primario |
| **Avvertimento** | `#FFB74D` | Arancione pastello chiaro |
| **Errore** | `#E57373` | Rosso morbido/rosato |
| **Informazione** | `#64B5F6` | Azzurro cielo chiaro |

---

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

---

## Utilizzo nel Codice

I colori sono definiti in `lib/theme/app_theme.dart`:

```dart
// Deep Emerald - Tema Chiaro
static const Color deepEmeraldPrimaryLight = Color(0xFF1B5E20);
static const Color deepEmeraldBackgroundLight = Color(0xFFF5F5F5);
static const Color deepEmeraldTextPrimaryLight = Color(0xFF051F12);

// Deep Emerald - Tema Scuro
static const Color deepEmeraldPrimaryDark = Color(0xFF81C784);
static const Color deepEmeraldBackgroundDark = Color(0xFF121212);
static const Color deepEmeraldTextPrimaryDark = Color(0xFFE0E0E0);

// Alto Contrasto - Tema Chiaro
static const Color highContrastPrimaryLight = Color(0xFF0000CC);
static const Color highContrastBackgroundLight = Color(0xFFFFFFFF);
static const Color highContrastTextPrimaryLight = Color(0xFF000000);

// Alto Contrasto - Tema Scuro
static const Color highContrastPrimaryDark = Color(0xFFFFFF00);
static const Color highContrastBackgroundDark = Color(0xFF000000);
static const Color highContrastTextPrimaryDark = Color(0xFFFFFFFF);
```

## Principi di Progettazione

1. **Accessibilità**: Tutte le coppie testo/sfondo rispettano lo standard WCAG 2.1 livello AA per il contrasto (AAA per Alto Contrasto).
2. **Coerenza**: I colori primari sono utilizzati coerentemente in tutta l'applicazione.
3. **Gerarchia Visiva**: L'uso di diverse tonalità stabilisce una chiara gerarchia delle informazioni.
4. **Naturalità**: La tavolozza verde trasmette salute, benessere e fiducia.
5. **Inclusività**: La tavolozza Alto Contrasto permette alle persone con problemi di vista di usare l'applicazione comodamente.

## Riferimenti

- Material Design 3 Guidelines
- WCAG 2.1 Accessibility Standards
