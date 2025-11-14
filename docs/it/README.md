# MedicApp

[![Tests](https://img.shields.io/badge/tests-432%2B-brightgreen)](../../test)
[![Copertura](https://img.shields.io/badge/copertura-75--80%25-green)](../../test)
[![Flutter](https://img.shields.io/badge/Flutter-3.9.2%2B-02569B?logo=flutter)](https://flutter.dev)
[![Material Design](https://img.shields.io/badge/Material%20Design-3-757575?logo=material-design)](https://m3.material.io)
[![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?logo=dart)](https://dart.dev)
[![SQLite](https://img.shields.io/badge/SQLite-3-003B57?logo=sqlite)](https://www.sqlite.org)

**MedicApp** è un'applicazione mobile completa per la gestione dei farmaci sviluppata con Flutter, progettata per aiutare utenti e caregiver a organizzare e controllare la somministrazione di farmaci per più persone in modo efficiente e sicuro.

---

## Indice

- [Descrizione del Progetto](#descrizione-del-progetto)
- [Caratteristiche Principali](#caratteristiche-principali)
- [Screenshot](#screenshot)
- [Avvio Rapido](#avvio-rapido)
- [Documentazione](#documentazione)
- [Stato del Progetto](#stato-del-progetto)
- [Licenza](#licenza)

---

## Descrizione del Progetto

MedicApp è una soluzione integrale per la gestione dei farmaci che consente agli utenti di amministrare trattamenti medici per più persone da un'unica applicazione. Progettata con un focus su usabilità e accessibilità, MedicApp facilita il monitoraggio degli orari di assunzione, il controllo delle scorte, la gestione dei periodi di digiuno e le notifiche intelligenti.

L'applicazione implementa un'architettura pulita con separazione delle responsabilità, gestione dello stato con Provider, e un database SQLite robusto che garantisce la persistenza e la sincronizzazione dei dati. Con supporto per 8 lingue e Material Design 3, MedicApp offre un'esperienza moderna e accessibile per utenti di tutto il mondo.

Ideale per pazienti con trattamenti complessi, caregiver professionisti, famiglie che gestiscono la medicazione di diversi membri, e chiunque necessiti di un sistema affidabile di promemoria e monitoraggio dei farmaci.

---

## Caratteristiche Principali

### 1. **Gestione Multi-Persona**
Gestisci farmaci per più persone da un'unica applicazione. Ogni persona ha il proprio profilo, farmaci, assunzioni registrate e statistiche indipendenti (Database V19+).

### 2. **14 Tipi di Farmaci**
Supporto completo per vari tipi di farmaci: Compressa, Capsula, Sciroppo, Iniezione, Inalatore, Crema, Gocce, Cerotto, Supposta, Spray, Polvere, Gel, Medicazione e Altro.

### 3. **Notifiche Intelligenti**
Sistema di notifiche avanzato con azioni rapide (Prendi/Posticipa/Salta), limitazione automatica a 5 notifiche attive, e notifiche persistenti per i periodi di digiuno in corso.

### 4. **Controllo Scorte Avanzato**
Tracciamento automatico delle scorte con avvisi configurabili, notifiche di scorte basse, e promemoria per rinnovare i farmaci prima che si esauriscano.

### 5. **Gestione Periodi di Digiuno**
Configura periodi di digiuno pre/post farmaco con notifiche persistenti, validazione degli orari, e avvisi intelligenti che mostrano solo digiuni in corso o futuri.

### 6. **Storico Completo delle Assunzioni**
Registro dettagliato di tutte le assunzioni con stati (Preso, Saltato, Posticipato), timestamp precisi, integrazione con le scorte, e statistiche di aderenza per persona.

### 7. **Interfaccia Multilingua**
Supporto completo per 8 lingue: Spagnolo, Inglese, Francese, Tedesco, Italiano, Portoghese, Catalano ed Euskera, con cambio dinamico senza riavviare l'applicazione.

### 8. **Material Design 3**
Interfaccia moderna con tema chiaro/scuro, componenti adattivi, animazioni fluide, e design responsive che si adatta a diverse dimensioni dello schermo.

### 9. **Database Robusto**
SQLite V19 con migrazioni automatiche, indici ottimizzati, validazione dell'integrità referenziale, e sistema completo di trigger per mantenere la coerenza dei dati.

### 10. **Testing Esaustivo**
Oltre 432 test automatizzati (75-80% di copertura) inclusi test unitari, di widget, di integrazione, e test specifici per casi limite come notifiche a mezzanotte.

---

## Screenshot

_Sezione riservata per futuri screenshot dell'applicazione._

---

## Avvio Rapido

### Requisiti Preliminari
- Flutter 3.9.2 o superiore
- Dart 3.0 o superiore
- Android Studio / VS Code con estensioni Flutter

### Installazione

```bash
# Clonare il repository
git clone <repository-url>
cd medicapp

# Installare le dipendenze
flutter pub get

# Eseguire l'applicazione
flutter run

# Eseguire i test
flutter test

# Generare report di copertura
flutter test --coverage
```

---

## Documentazione

La documentazione completa del progetto è disponibile nella directory \`docs/it/\`:

- **[Guida all'Installazione](installation.md)** - Requisiti, installazione e configurazione iniziale
- **[Caratteristiche](features.md)** - Documentazione dettagliata di tutte le funzionalità
- **[Architettura](architecture.md)** - Struttura del progetto, pattern e decisioni di design
- **[Database](database.md)** - Schema, migrazioni, trigger e ottimizzazioni
- **[Struttura del Progetto](project-structure.md)** - Organizzazione di file e directory
- **[Tecnologie](technologies.md)** - Stack tecnologico e dipendenze utilizzate
- **[Testing](testing.md)** - Strategia di testing, tipi di test e guide per contribuire
- **[Contribuzione](contributing.md)** - Guide per contribuire al progetto
- **[Risoluzione Problemi](troubleshooting.md)** - Problemi comuni e soluzioni

---

## Stato del Progetto

- **Versione Database**: V19 (con supporto multi-persona)
- **Test**: 432+ test automatizzati
- **Copertura**: 75-80%
- **Lingue Supportate**: 8 (ES, EN, FR, DE, IT, PT, CA, EU)
- **Tipi di Farmaci**: 14
- **Flutter**: 3.9.2+
- **Material Design**: 3
- **Stato**: In sviluppo attivo

---

## Licenza

Questo progetto è licenziato sotto la [GNU Affero General Public License v3.0 (AGPL-3.0)](../../LICENSE).

L'AGPL-3.0 è una licenza software libero copyleft che richiede che qualsiasi versione modificata del software eseguita su un server di rete sia anch'essa disponibile come codice aperto.

---

**Sviluppato con Flutter e Material Design 3**
