# Funzionalità di MedicApp

Questo documento dettaglia tutte le caratteristiche e capacità di MedicApp, un'applicazione avanzata di gestione dei farmaci progettata per famiglie e caregiver.

---

## 1. Gestione Multi-Persona (V19+)

### Architettura Molti-a-Molti

MedicApp implementa un'architettura sofisticata di gestione multi-persona che consente a più utenti di condividere farmaci mantenendo configurazioni di trattamento individuali. Questa funzionalità è specificamente progettata per famiglie, caregiver professionali e gruppi che necessitano di coordinare la medicazione di più persone.

L'architettura si basa su un modello relazionale molti-a-molti, dove ogni farmaco (identificato per nome, tipo e scorta condivisa) può essere assegnato a più persone, e ogni persona può avere più farmaci. La scorta è gestita centralmente e viene decrementata automaticamente indipendentemente da chi assume il farmaco, permettendo un controllo preciso dell'inventario condiviso senza duplicare i dati.

Ogni persona può configurare la propria pauta di trattamento per lo stesso farmaco, includendo orari specifici, dosi personalizzate, durata del trattamento e preferenze di digiuno. Ad esempio, se una madre e sua figlia condividono lo stesso farmaco, la madre può avere configurate assunzioni alle 8:00 e 20:00, mentre la figlia necessita solo di una dose giornaliera alle 12:00. Entrambe condividono la stessa scorta fisica, ma ognuna riceve notifiche e monitoraggio indipendente secondo la propria pauta.

### Casi d'Uso

Questa funzionalità è particolarmente utile in diversi scenari: famiglie dove più membri assumono lo stesso farmaco (come vitamine o integratori), caregiver professionali che gestiscono la medicazione di più pazienti, nuclei familiari multigenerazionali dove si condividono farmaci comuni, e situazioni dove è necessario controllare la scorta condivisa per evitare esaurimenti. Il sistema permette di effettuare un monitoraggio dettagliato della cronologia delle dosi per persona, facilitando l'aderenza terapeutica e il controllo medico individualizzato.

---

## 2. 14 Tipi di Farmaci

### Catalogo Completo di Forme Farmaceutiche

MedicApp supporta 14 tipi diversi di farmaci, ognuno con iconografia distintiva, schema di colori specifico e unità di misura appropriate. Questa diversità permette di registrare praticamente qualsiasi forma farmaceutica presente in un armadietto domestico o professionale.

**Tipi disponibili:**

1. **Pillola** - Colore blu, icona circolare. Unità: pillole. Per compresse solide tradizionali.
2. **Capsula** - Colore viola, icona di capsula. Unità: capsule. Per farmaci in forma di capsula gelatinosa.
3. **Iniezione** - Colore rosso, icona di siringa. Unità: iniezioni. Per farmaci che richiedono somministrazione parenterale.
4. **Sciroppo** - Colore arancione, icona di bicchiere. Unità: ml (millilitri). Per farmaci liquidi di somministrazione orale.
5. **Ovulo** - Colore rosa, icona ovale. Unità: ovuli. Per farmaci di somministrazione vaginale.
6. **Supposta** - Colore verde acqua (teal), icona specifica. Unità: supposte. Per somministrazione rettale.
7. **Inalatore** - Colore ciano, icona d'aria. Unità: inalazioni. Per farmaci respiratori.
8. **Bustina** - Colore marrone, icona di pacchetto. Unità: bustine. Per farmaci in polvere o granulati.
9. **Spray** - Colore azzurro, icona di gocciolamento. Unità: ml (millilitri). Per nebulizzatori e aerosol nasali.
10. **Pomata** - Colore verde, icona di goccia opaca. Unità: grammi. Per farmaci topici cremosi.
11. **Lozione** - Colore indaco, icona d'acqua. Unità: ml (millilitri). Per farmaci liquidi topici.
12. **Cerotto** - Colore ambra, icona di guarigione. Unità: cerotti. Per cerotti medicati e cerotti terapeutici.
13. **Goccia** - Colore grigio-azzurro, icona di goccia invertita. Unità: gocce. Per colliri e gocce otiche.
14. **Altro** - Colore grigio, icona generica. Unità: unità. Per qualsiasi forma farmaceutica non categorizzata.

### Vantaggi del Sistema di Tipi

Questa classificazione dettagliata permette al sistema di calcolare automaticamente la scorta in modo preciso secondo l'unità di misura corrispondente, mostrare icone e colori che facilitano l'identificazione visiva rapida, e generare notifiche contestuali che menzionano il tipo specifico di farmaco. Gli utenti possono gestire dai trattamenti semplici con pillole ai regimi complessi che includono inalatori, iniezioni e gocce, tutto all'interno di una stessa interfaccia coerente.

---

## 3. Flusso di Aggiunta Farmaci

### Farmaci Programmati (8 Passaggi)

Il processo di aggiunta di un farmaco con orario programmato è guidato e strutturato per assicurare che si configuri correttamente tutta l'informazione necessaria:

**Passaggio 1: Informazioni di Base** - Si introduce il nome del farmaco e si seleziona il tipo tra le 14 opzioni disponibili. Il sistema valida che il nome non sia vuoto.

**Passaggio 2: Frequenza di Trattamento** - Si definisce il pattern di assunzione con sei opzioni: tutti i giorni, fino a esaurimento farmaco, date specifiche, giorni della settimana, ogni N giorni, o secondo necessità. Questa configurazione determina quando devono essere assunte le dosi.

**Passaggio 3: Configurazione delle Dosi** - Si stabiliscono gli orari specifici di assunzione. L'utente può scegliere tra modalità uniforme (stessa dose in tutti gli orari) o dosi personalizzate per ogni orario. Ad esempio, si può configurare 1 pillola alle 8:00, 0.5 pillole alle 14:00 e 2 pillole alle 20:00.

**Passaggio 4: Orari di Assunzione** - Si selezionano le ore esatte in cui deve essere assunto il farmaco utilizzando un selettore di tempo visuale. Si possono configurare più orari al giorno secondo prescrizione.

**Passaggio 5: Durata del Trattamento** - Se applicabile secondo il tipo di frequenza, si stabiliscono le date di inizio e fine del trattamento. Questo permette di programmare trattamenti con durata definita o trattamenti continui.

**Passaggio 6: Configurazione del Digiuno** - Si definisce se il farmaco richiede digiuno prima o dopo l'assunzione, la durata del periodo di digiuno in minuti, e se si desiderano notifiche di promemoria del digiuno.

**Passaggio 7: Scorta Iniziale** - Si introduce la quantità di farmaco disponibile nelle unità corrispondenti al tipo selezionato. Il sistema utilizzerà questo valore per il controllo dell'inventario.

**Passaggio 8: Assegnazione Persone** - Si selezionano le persone che assumeranno questo farmaco. Per ogni persona, si può configurare una pauta individuale con orari e dosi personalizzate, o ereditare la configurazione base.

### Farmaci Occasionali (2 Passaggi)

Per farmaci di uso sporadico o "secondo necessità", il processo si semplifica significativamente:

**Passaggio 1: Informazioni di Base** - Nome e tipo del farmaco.

**Passaggio 2: Scorta Iniziale** - Quantità disponibile. Il sistema configura automaticamente il farmaco come "secondo necessità", senza orari programmati né notifiche automatiche.

### Validazioni Automatiche

Durante tutto il processo, MedicApp valida che siano stati completati tutti i campi obbligatori prima di permettere di avanzare al passaggio successivo. Si verifica che gli orari siano logici, che le dosi siano valori numerici positivi, che le date di inizio non siano posteriori a quelle di fine, e che almeno una persona sia assegnata al farmaco.

---

## 4. Registrazione delle Assunzioni

### Assunzioni Programmate

MedicApp gestisce automaticamente le assunzioni programmate secondo la configurazione di ogni farmaco e persona. Quando arriva l'ora di una dose, l'utente riceve una notifica e può registrare l'assunzione da tre punti: la schermata principale dove appare elencata la dose pendente, la notifica direttamente mediante azioni rapide, o toccando la notifica che apre una schermata di conferma dettagliata.

Registrando un'assunzione programmata, il sistema decrementa automaticamente la quantità corrispondente dalla scorta condivisa, segna la dose come assunta nel giorno attuale per quella persona specifica, crea una voce nella cronologia delle dosi con timestamp esatto, e cancella la notifica pendente se esiste. Se il farmaco richiede digiuno posteriore, si programma immediatamente una notifica di fine digiuno e si mostra un conto alla rovescia visuale nella schermata principale.

### Assunzioni Occasionali

Per farmaci configurati come "secondo necessità" o quando è necessario registrare un'assunzione fuori orario, MedicApp permette la registrazione manuale. L'utente accede al farmaco dall'armadietto, seleziona "Assumere dose", introduce la quantità assunta manualmente, e il sistema decrementa dalla scorta e registra nella cronologia con l'orario attuale. Questa funzionalità è essenziale per analgesici, antipiretici e altri farmaci di uso sporadico.

### Assunzioni Eccezionali

Il sistema permette anche di registrare dosi aggiuntive non programmate per farmaci con orario fisso. Ad esempio, se un paziente necessita di una dose extra di analgesico tra le sue assunzioni abituali, può registrarla come "dose extra". Questa dose viene registrata nella cronologia marcata come eccezionale, decrementa la scorta, ma non influisce sul monitoraggio dell'aderenza delle dosi programmate regolari.

### Cronologia Automatica

Ogni azione di registrazione genera automaticamente una voce completa nella cronologia che include: la data e ora programmata della dose, la data e ora reale di somministrazione, la persona che ha assunto il farmaco, il nome e tipo del farmaco, la quantità esatta somministrata, lo stato (assunta o omessa), e se è stata una dose extra non programmata. Questa cronologia permette un'analisi dettagliata dell'aderenza terapeutica e facilita i report medici.

---

## 5. Controllo della Scorta (Armadietto)

### Indicatori Visuali Intuitivi

Il sistema di controllo della scorta di MedicApp fornisce informazioni in tempo reale dell'inventario disponibile mediante un sistema di semafori visuali. Ogni farmaco mostra la sua quantità attuale nelle unità corrispondenti, con indicatori di colore che allertano sullo stato della scorta.

Il codice di colori è intuitivo: verde indica scorta sufficiente per più di 3 giorni, giallo/ambra allerta che la scorta è bassa (meno di 3 giorni di fornitura), e rosso indica che il farmaco è esaurito. Le soglie di giorni sono configurabili per farmaco, permettendo aggiustamenti secondo la criticità di ogni trattamento.

### Calcolo Automatico Intelligente

Il calcolo dei giorni rimanenti si realizza automaticamente considerando molteplici fattori. Per farmaci programmati, il sistema analizza la dose giornaliera totale sommando tutte le assunzioni configurate di tutte le persone assegnate, divide la scorta attuale tra questa dose giornaliera, e stima i giorni di fornitura rimanenti.

Per farmaci occasionali o "secondo necessità", il sistema utilizza un algoritmo adattativo che registra il consumo dell'ultimo giorno d'uso e lo impiega come predittore per stimare quanti giorni durerà la scorta attuale. Questa stima si aggiorna automaticamente ogni volta che si registra un uso del farmaco.

### Soglia Configurabile per Farmaco

Ogni farmaco può avere una soglia di allerta personalizzata che determina quando si considera che la scorta sia bassa. Il valore predefinito è 3 giorni, ma può essere regolato tra 1 e 10 giorni secondo le necessità. Ad esempio, farmaci critici come l'insulina possono essere configurati con una soglia di 7 giorni per permettere tempo sufficiente di riapprovvigionamento, mentre integratori meno critici possono usare soglie di 1-2 giorni.

### Allerte e Riapprovvigionamento

Quando la scorta raggiunge la soglia configurata, MedicApp mostra allerte visuali evidenziate nella schermata principale e nella vista dell'armadietto. Il sistema suggerisce automaticamente la quantità da riapprovvigionare basandosi sull'ultimo rifornimento registrato, agilizzando il processo di aggiornamento dell'inventario. Le allerte persistono fino a quando l'utente registra una nuova quantità in scorta, assicurando che non si dimentichino riapprovvigionamenti critici.

---

## 6. Armadietto

### Lista Alfabetica Organizzata

L'armadietto di MedicApp presenta tutti i farmaci registrati in una lista ordinata alfabeticamente, facilitando la localizzazione rapida di qualsiasi farmaco. Ogni voce mostra il nome del farmaco, il tipo con la sua icona e colore distintivo, la scorta attuale nelle unità corrispondenti, e le persone assegnate a quel farmaco.

La vista dell'armadietto è particolarmente utile per avere una visione globale dell'inventario di farmaci disponibili, senza le informazioni di orari che possono risultare opprimenti nella vista principale. È la schermata ideale per gestioni di inventario, ricerca di farmaci specifici e azioni di manutenzione.

### Ricerca in Tempo Reale

Un campo di ricerca nella parte superiore permette di filtrare i farmaci istantaneamente mentre si scrive. La ricerca è intelligente e considera sia il nome del farmaco che il tipo, permettendo di trovare "tutti gli sciroppi" o "farmaci che contengono aspirina" rapidamente. I risultati si aggiornano in tempo reale senza necessità di premere pulsanti aggiuntivi.

### Azioni Rapide Integrate

Da ogni farmaco nell'armadietto, si può accedere a un menu contestuale con tre azioni principali:

**Modificare** - Apre l'editor completo del farmaco dove si possono modificare tutti gli aspetti: nome, tipo, orari, dosi, persone assegnate, configurazione del digiuno, ecc. Le modifiche vengono salvate e si risincronizzano automaticamente le notifiche.

**Eliminare** - Permette di cancellare permanentemente il farmaco dal sistema dopo una conferma di sicurezza. Questa azione cancella tutte le notifiche associate ed elimina il registro dalla cronologia futura, ma preserva la cronologia delle dosi già registrate per mantenere l'integrità dei dati.

**Assumere dose** - Scorciatoia rapida per registrare un'assunzione manuale, particolarmente utile per farmaci occasionali. Se il farmaco è assegnato a più persone, prima richiede di selezionare chi lo assume.

### Gestione delle Assegnazioni

L'armadietto facilita anche la gestione delle assegnazioni persona-farmaco. Si possono vedere a colpo d'occhio quali farmaci sono assegnati a ogni persona, aggiungere o rimuovere persone da un farmaco esistente, e modificare le paute individuali di ogni persona senza influire sugli altri.

---

## 7. Navigazione Temporale

### Scorrimento Orizzontale per Giorni

La schermata principale di MedicApp implementa un sistema di navigazione temporale che permette all'utente di muoversi tra diversi giorni con un semplice gesto di scorrimento orizzontale. Scorrere verso sinistra avanza al giorno successivo, mentre scorrere verso destra retrocede al giorno precedente. Questa navigazione è fluida e utilizza transizioni animate che forniscono feedback visuale chiaro del cambio di data.

La navigazione temporale è praticamente illimitata verso il passato e il futuro, permettendo di rivedere la cronologia di medicazione di settimane o mesi precedenti, o pianificare in anticipo verificando quali farmaci saranno programmati in date future. Il sistema mantiene un punto centrale virtuale che permette migliaia di pagine in entrambe le direzioni senza impatto sulle prestazioni.

### Selettore di Calendario

Per salti rapidi a date specifiche, MedicApp integra un selettore di calendario accessibile da un pulsante nella barra superiore. Toccando l'icona del calendario, si apre un widget di calendario visuale dove l'utente può selezionare qualsiasi data. Selezionando, la vista si aggiorna istantaneamente per mostrare i farmaci programmati di quel giorno specifico.

Il calendario marca visualmente il giorno attuale con un indicatore evidenziato, facilita la selezione di date passate per rivedere l'aderenza, permette di saltare a date future per la pianificazione di viaggi o eventi, e mostra la data selezionata attuale nella barra superiore in modo permanente.

### Vista Giorno vs Vista Settimanale

Benché la navigazione principale sia per giorno, MedicApp fornisce contesto temporale aggiuntivo mostrando informazioni rilevanti del periodo selezionato. Nella vista principale, i farmaci sono raggruppati per orario di assunzione, fornendo una linea temporale del giorno. Gli indicatori visuali mostrano quali dosi sono già state assunte, quali sono state omesse, e quali sono pendenti.

Per farmaci con pattern settimanali o intervalli specifici, l'interfaccia indica chiaramente se il farmaco corrisponde al giorno selezionato o no. Ad esempio, un farmaco configurato per "lunedì, mercoledì, venerdì" appare solo nella lista quando si visualizzano quei giorni della settimana.

### Vantaggi della Navigazione Temporale

Questa funzionalità è particolarmente preziosa per verificare se è stato assunto un farmaco in un giorno passato, pianificare quali farmaci portare in un viaggio basandosi sulle date, rivedere pattern di aderenza settimanali o mensili, e coordinare medicazioni di più persone in un nucleo familiare durante periodi specifici.

---

## 8. Notifiche Intelligenti

### Azioni Dirette dalla Notifica

MedicApp rivoluziona la gestione dei farmaci mediante notifiche con azioni integrate che permettono di gestire le dosi senza aprire l'applicazione. Quando arriva l'ora di una dose, la notifica mostra tre pulsanti di azione diretta:

**Assumere** - Registra la dose immediatamente, decrementa dalla scorta, crea una voce nella cronologia, cancella la notifica, e se applicabile, avvia il periodo di digiuno posteriore con conto alla rovescia.

**Posticipare** - Posticipa la notifica di 10, 30 o 60 minuti secondo l'opzione selezionata. La notifica riappare automaticamente nel tempo specificato.

**Saltare** - Registra la dose come omessa, crea una voce nella cronologia con stato "saltata" senza decrementare la scorta, e cancella la notifica senza programmare promemoria aggiuntivi.

Queste azioni funzionano anche quando il telefono è bloccato, rendendo la registrazione della medicazione istantanea e senza attrito. L'utente può gestire la sua medicazione completa dalle notifiche senza necessità di sbloccare il dispositivo o aprire l'app.

### Cancellazione Intelligente

Il sistema di notifiche implementa logica avanzata di cancellazione per evitare allerte ridondanti o incorrette. Quando un utente registra una dose manualmente dall'app (senza usare la notifica), il sistema cancella automaticamente la notifica pendente di quella dose specifica per quel giorno.

Se un farmaco viene eliminato o sospeso, tutte le sue notifiche future vengono cancellate immediatamente in background. Quando si modifica l'orario di un farmaco, le notifiche vecchie vengono cancellate e riprogrammate automaticamente con i nuovi orari. Questa gestione intelligente assicura che l'utente riceva solo notifiche rilevanti e attuali.

### Notifiche Persistenti per Digiuno

Per farmaci che richiedono digiuno, MedicApp mostra una notifica persistente speciale durante tutto il periodo di digiuno. Questa notifica non può essere scartata manualmente e mostra un conto alla rovescia in tempo reale del tempo rimanente fino a quando si potrà mangiare. Include l'ora esatta in cui finirà il digiuno, permettendo all'utente di pianificare i suoi pasti.

La notifica di digiuno ha priorità alta ma non emette suono continuamente, evitando interruzioni moleste mentre mantiene visibile l'informazione critica. Quando finisce il periodo di digiuno, la notifica viene cancellata automaticamente e si emette un'allerta sonora breve per notificare all'utente che già può mangiare.

### Configurazione Personalizzata per Farmaco

Ogni farmaco può avere la sua configurazione di notifiche regolata individualmente. Gli utenti possono abilitare o disabilitare completamente le notifiche per farmaci specifici, mantenendoli nel sistema per il monitoraggio ma senza allerte automatiche. Questa flessibilità è utile per farmaci che l'utente assume per routine e non necessita di promemoria.

Inoltre, la configurazione del digiuno permette di decidere se si desiderano notifiche di inizio digiuno (per farmaci con digiuno previo) o semplicemente usare la funzione senza allerte. MedicApp rispetta queste preferenze individuali mentre mantiene la consistenza nella registrazione e monitoraggio di tutte le dosi.

### Compatibilità con Android 12+

MedicApp è ottimizzata per Android 12 e versioni superiori, richiedendo e gestendo i permessi di "Allarmi e promemoria" necessari per notifiche esatte. L'applicazione rileva automaticamente se questi permessi non sono concessi e guida l'utente per abilitarli dalle impostazioni del sistema, assicurando che le notifiche arrivino puntualmente all'ora programmata.

---

## 9. Configurazione del Digiuno

### Tipi: Before (Prima) e After (Dopo)

MedicApp supporta due modalità di digiuno chiaramente differenziate per adattarsi a diverse prescrizioni mediche:

**Digiuno Before (Prima)** - Si configura quando il farmaco deve essere assunto a stomaco vuoto. L'utente deve aver digiunato durante il periodo specificato PRIMA di assumere il farmaco. Ad esempio, "30 minuti di digiuno prima" significa non aver mangiato nulla durante i 30 minuti precedenti all'assunzione. Questo tipo è comune in farmaci che richiedono assorbimento ottimale senza interferenza alimentare.

**Digiuno After (Dopo)** - Si configura quando dopo aver assunto il farmaco si deve aspettare senza mangiare. Ad esempio, "60 minuti di digiuno dopo" significa che dopo aver assunto il farmaco, non si possono ingerire alimenti durante 60 minuti. Questo tipo è tipico in farmaci che possono causare disturbi gastrici o la cui efficacia si riduce con il cibo.

La durata del digiuno è completamente configurabile in minuti, permettendo di adattarsi a prescrizioni specifiche che possono variare da 15 minuti a varie ore.

### Conto alla Rovescia Visuale in Tempo Reale

Quando un farmaco con digiuno "dopo" è stato assunto, MedicApp mostra un conto alla rovescia visuale prominente nella schermata principale. Questo contatore si aggiorna in tempo reale ogni secondo, mostrando il tempo rimanente in formato MM:SS (minuti:secondi). Insieme al conto alla rovescia, si indica l'ora esatta in cui finirà il periodo di digiuno, permettendo pianificazione immediata.

Il componente visuale del conto alla rovescia è impossibile da ignorare: utilizza colori chiamativi, si posiziona in modo evidente nella schermata, include il nome del farmaco associato, e mostra un'icona di restrizione alimentare. Questa visibilità costante assicura che l'utente non dimentichi la restrizione alimentare attiva.

### Notifica Fissa Durante il Digiuno

Complementando il conto alla rovescia visuale nell'app, MedicApp mostra una notifica persistente del sistema durante tutto il periodo di digiuno. Questa notifica è "ongoing" (in corso), il che significa che non può essere scartata dall'utente e rimane fissa nella barra delle notifiche con massima priorità.

La notifica di digiuno mostra la stessa informazione del conto alla rovescia nell'app: nome del farmaco, tempo rimanente di digiuno, e ora stimata di fine. Si aggiorna periodicamente per riflettere il tempo rimanente, sebbene non in tempo reale costante per preservare la batteria. Questo doppio strato di promemoria (visuale nell'app + notifica persistente) praticamente elimina il rischio di rompere accidentalmente il digiuno.

### Cancellazione Automatica

Il sistema gestisce automaticamente il ciclo di vita del digiuno senza intervento manuale. Quando il tempo di digiuno si completa, varie azioni avvengono simultaneamente e automaticamente:

1. Il conto alla rovescia visuale scompare dalla schermata principale
2. La notifica persistente viene cancellata automaticamente
3. Si emette una notifica breve con suono indicando "Digiuno completato, ora puoi mangiare"
4. Lo stato del farmaco si aggiorna per riflettere che il digiuno è finito

Questa automazione assicura che l'utente sia sempre informato dello stato attuale senza necessità di ricordare manualmente quando è finito il digiuno. Se l'app è in background quando finisce il digiuno, la notifica di fine allerta l'utente immediatamente.

### Configurazione per Farmaco

Non tutti i farmaci richiedono digiuno, e tra quelli che lo richiedono, le necessità variano. MedicApp permette di configurare individualmente per ogni farmaco: se richiede digiuno o no (sì/no), il tipo di digiuno (prima/dopo), la durata esatta in minuti, e se si desiderano notifiche di inizio digiuno (per il tipo "prima").

Questa granularità permette di gestire regimi complessi dove alcuni farmaci si assumono a digiuno, altri richiedono attesa post-ingestione, e altri non hanno restrizioni, tutto all'interno di un'interfaccia coerente che gestisce automaticamente ogni caso secondo la sua configurazione specifica.

---

## 10. Cronologia delle Dosi

### Registrazione Automatica Completa

MedicApp mantiene un registro dettagliato e automatico di ogni azione relazionata con i farmaci. Ogni volta che si registra una dose (assunta o omessa), il sistema crea immediatamente una voce nella cronologia che cattura informazioni esaustive dell'evento.

I dati registrati includono: identificatore univoco della voce, ID del farmaco e il suo nome attuale, tipo di farmaco con la sua icona e colore, ID e nome della persona che ha assunto/omesso la dose, data e ora programmata originalmente per la dose, data e ora reale in cui è stata registrata l'azione, stato della dose (assunta o omessa), quantità esatta somministrata nelle unità corrispondenti, e se è stata una dose extra non programmata.

Questa registrazione automatica funziona indipendentemente da come è stata registrata la dose: dall'app, dalle azioni della notifica, o mediante registrazione manuale. Non richiede intervento dell'utente oltre all'azione di registrazione base, garantendo che la cronologia sia sempre completa e aggiornata.

### Statistiche di Aderenza Terapeutica

Dalla cronologia delle dosi, MedicApp calcola automaticamente statistiche di aderenza che forniscono informazioni preziose sul rispetto del trattamento. Le metriche includono:

**Tasso di Aderenza Globale** - Percentuale di dosi assunte sul totale di dosi programmate, calcolato come (dosi assunte / (dosi assunte + dosi omesse)) × 100.

**Totale Dosi Registrate** - Conteggio totale di eventi nella cronologia all'interno del periodo analizzato.

**Dosi Assunte** - Numero assoluto di dosi registrate come assunte con successo.

**Dosi Omesse** - Numero di dosi che sono state saltate o non assunte secondo programmato.

Queste statistiche si calcolano dinamicamente basandosi sui filtri applicati, permettendo analisi per periodi specifici, farmaci individuali o persone concrete. Sono particolarmente utili per identificare pattern di non conformità, valutare l'efficacia del regime di orari attuale, e fornire informazioni obiettive nelle visite mediche.

### Filtri Avanzati Multidimensionali

La schermata della cronologia include un sistema di filtraggio potente che permette di analizzare i dati da molteplici prospettive:

**Filtro per Persona** - Mostra solo le dosi di una persona specifica, ideale per monitoraggio individuale in ambienti multi-persona. Include opzione "Tutte le persone" per vista globale.

**Filtro per Farmaco** - Permette di focalizzarsi su un farmaco particolare, utile per valutare l'aderenza di trattamenti specifici. Include opzione "Tutti i farmaci" per vista completa.

**Filtro per Intervallo di Date** - Definisce un periodo temporale specifico con data di inizio e data di fine. Utile per generare report di aderenza mensile, trimestrale o per periodi personalizzati che coincidano con visite mediche.

I filtri sono cumulativi e si possono combinare. Ad esempio, si possono vedere "tutte le dosi di Ibuprofene assunte da Maria nel mese di gennaio", fornendo analisi molto granulari. I filtri attivi si mostrano visualmente in chip informativi che possono essere rimossi individualmente.

### Esportazione dei Dati

Sebbene l'interfaccia attuale non implementi esportazione diretta, la cronologia delle dosi è archiviata nel database SQLite dell'applicazione, che può essere esportato completo mediante la funzionalità di backup del sistema. Questo database contiene tutte le voci della cronologia in formato strutturato che può essere processato successivamente con strumenti esterni per generare report personalizzati, grafici di aderenza, o integrazione con sistemi di gestione medica.

Il formato dei dati è relazionale e normalizzato, con chiavi esterne che collegano farmaci, persone e voci di cronologia, facilitando analisi complesse ed estrazione di informazioni per presentazioni mediche o audit di trattamento.

---

## 11. Localizzazione e Internazionalizzazione

### 8 Lingue Completamente Supportate

MedicApp è tradotta in modo professionale e completo in 8 lingue, coprendo la maggior parte delle lingue parlate nella penisola iberica ed estendendo la sua portata all'Europa:

**Spagnolo (es)** - Lingua principale, traduzione nativa con tutta la terminologia medica precisa.

**English (en)** - Inglese internazionale, adattato per utenti anglofoni globali.

**Deutsch (de)** - Tedesco standard, con terminologia medica europea.

**Français (fr)** - Francese europeo con vocabolario farmaceutico appropriato.

**Italiano (it)** - Italiano standard con termini medici localizzati.

**Català (ca)** - Catalano con termini medici specifici del sistema sanitario catalano.

**Euskara (eu)** - Basco con terminologia sanitaria appropriata.

**Galego (gl)** - Galiziano con vocabolario medico regionalizzato.

Ogni traduzione non è una semplice conversione automatica, ma una localizzazione culturale che rispetta le convenzioni mediche, formati di data/ora, ed espressioni idiomatiche di ogni regione. I nomi dei farmaci, tipi farmaceutici e termini tecnici sono adattati al vocabolario medico locale di ogni lingua.

### Cambio Dinamico di Lingua

MedicApp permette di cambiare la lingua dell'interfaccia in qualsiasi momento dalla schermata di configurazione. Selezionando una nuova lingua, l'applicazione si aggiorna istantaneamente senza necessità di riavviare. Tutti i testi dell'interfaccia, messaggi di notifica, etichette di pulsanti, descrizioni di aiuto e messaggi di errore si aggiornano immediatamente alla lingua selezionata.

Il cambio di lingua è fluido e non influisce sui dati archiviati. I nomi dei farmaci introdotti dall'utente si mantengono come furono inseriti, indipendentemente dalla lingua dell'interfaccia. Solo gli elementi di UI generati dal sistema cambiano lingua, preservando l'informazione medica personalizzata.

### Separatori Decimali Localizzati

MedicApp rispetta le convenzioni numeriche di ogni regione per i separatori decimali. In lingue come spagnolo, francese, tedesco e italiano, si utilizza la virgola (,) come separatore decimale: "1,5 pillole", "2,25 ml". In inglese, si utilizza il punto (.): "1.5 tablets", "2.25 ml".

Questa localizzazione numerica si applica automaticamente in tutti i campi di inserimento delle quantità: dose di farmaco, scorta disponibile, quantità da riapprovvigionare. Le tastiere numeriche si configurano automaticamente per mostrare il separatore decimale corretto secondo la lingua attiva, evitando confusioni ed errori di inserimento.

### Formati di Data e Ora Localizzati

I formati di data e ora si adattano anche alle convenzioni regionali. Le lingue europee continentali utilizzano il formato GG/MM/AAAA (giorno/mese/anno), mentre l'inglese può usare MM/GG/AAAA in alcune varianti. I nomi dei mesi e giorni della settimana appaiono tradotti nei selettori di calendario e nelle viste di cronologia.

Gli orari si mostrano in formato di 24 ore in tutte le lingue europee (13:00, 18:30), che è lo standard medico internazionale ed evita ambiguità AM/PM. Questa consistenza è critica in contesti medici dove la precisione oraria è vitale per l'efficacia del trattamento.

### Pluralizzazione Intelligente

Il sistema di localizzazione include logica di pluralizzazione che adatta i testi secondo le quantità. Ad esempio, in italiano: "1 pillola" ma "2 pillole", "1 giorno" ma "3 giorni". Ogni lingua ha le proprie regole di pluralizzazione che il sistema rispetta automaticamente, includendo casi complessi in catalano, basco e galiziano che hanno regole di plurale diverse dallo spagnolo.

Questa attenzione al dettaglio linguistico fa sì che MedicApp si senta naturale e nativa in ogni lingua, migliorando significativamente l'esperienza dell'utente e riducendo il carico cognitivo nell'interagire con l'applicazione in contesti medici potenzialmente stressanti.

---

## 12. Interfaccia Accessibile e Usabile

### Material Design 3

MedicApp è costruita seguendo strettamente le linee guida di Material Design 3 (Material You) di Google, il sistema di design più moderno e accessibile per applicazioni Android. Questa decisione architettonica garantisce molteplici vantaggi:

**Consistenza Visuale** - Tutti gli elementi dell'interfaccia (pulsanti, carte, dialoghi, campi di testo) seguono pattern visuali standard che gli utenti di Android riconoscono istintivamente. Non c'è bisogno di apprendere un'interfaccia completamente nuova.

**Tematizzazione Dinamica** - Material 3 permette che l'app adotti i colori del sistema dell'utente (se è in Android 12+), creando un'esperienza visuale coesa con il resto del dispositivo. I colori di accento, sfondi e superfici si adattano automaticamente.

**Componenti Accessibili Nativi** - Tutti i controlli di Material 3 sono progettati dall'inizio per essere accessibili, con aree di tocco generose (minimo 48x48dp), contrasti adeguati, e supporto per lettori di schermo.

### Tipografia Ampliata e Leggibile

L'applicazione utilizza una gerarchia tipografica chiara con dimensioni di carattere generose che facilitano la lettura senza fatica visiva:

**Titoli di Schermata** - Dimensione grande (24-28sp) per orientamento chiaro di dove si trova l'utente.

**Nomi di Farmaci** - Dimensione evidenziata (18-20sp) in grassetto per identificazione rapida.

**Informazioni Secondarie** - Dimensione media (14-16sp) per dettagli complementari come orari e quantità.

**Testo di Aiuto** - Dimensione standard (14sp) per istruzioni e descrizioni.

L'interlinea è generosa (1.5x) per evitare che le linee si confondano, specialmente importante per utenti con problemi di vista. I caratteri utilizzati sono sans-serif che hanno dimostrato migliore leggibilità su schermi digitali.

### Alto Contrasto Visuale

MedicApp implementa una palette di colori con rapporti di contrasto che rispettano e superano le linee guida WCAG 2.1 AA per accessibilità. Il contrasto minimo tra testo e sfondo è di 4.5:1 per testo normale e 3:1 per testo grande, assicurando leggibilità anche in condizioni di illuminazione subottimali.

I colori si utilizzano in modo funzionale oltre che estetico: rosso per allerte di scorta bassa o digiuno attivo, verde per conferme e scorta sufficiente, ambra per avvertenze intermedie, blu per informazioni neutre. Ma crucialmente, il colore non è mai l'unico indicatore: si complementa sempre con icone, testo o pattern.

### Navigazione Intuitiva e Prevedibile

La struttura di navigazione di MedicApp segue principi di semplicità e prevedibilità:

**Schermata Principale Centrale** - La vista dei farmaci del giorno è l'hub principale da cui tutto è accessibile in massimo 2 tocchi.

**Navigazione per Schede** - La barra inferiore con 3 schede (Farmaci, Armadietto, Cronologia) permette cambio istantaneo tra le viste principali senza animazioni confuse.

**Pulsanti di Azione Fluttuanti** - Le azioni primarie (aggiungere farmaco, filtrare cronologia) si realizzano mediante pulsanti fluttuanti (FAB) in posizione consistente, facili da raggiungere con il pollice.

**Breadcrumbs e Pulsante Indietro** - È sempre chiaro in quale schermata si trova l'utente e come tornare indietro. Il pulsante di ritorno è sempre nella posizione superiore sinistra standard.

### Feedback Visuale e Tattile

Ogni interazione produce feedback immediato: i pulsanti mostrano effetto "ripple" quando premuti, le azioni di successo si confermano con snackbar verdi che appaiono brevemente, gli errori si indicano con dialoghi rossi esplicativi, e i processi lunghi (come esportare database) mostrano indicatori di progresso animati.

Questo feedback costante assicura che l'utente sappia sempre che la sua azione è stata registrata e il sistema sta rispondendo, riducendo l'ansia tipica di applicazioni mediche dove un errore potrebbe avere conseguenze importanti.

### Design per Uso con Una Mano

Riconoscendo che gli utenti frequentemente gestiscono farmaci con una mano (mentre tengono il contenitore con l'altra), MedicApp ottimizza l'ergonomia per uso con una mano:

- Elementi interattivi principali nella metà inferiore dello schermo
- Pulsanti di azione fluttuanti nell'angolo inferiore destro, raggiungibili con il pollice
- Evitare menu negli angoli superiori che richiedono di riaggiustare la presa
- Gesti di scorrimento orizzontale (più comodi che verticali) per navigazione temporale

Questa considerazione ergonomica riduce la fatica fisica e rende l'app più comoda da usare in situazioni reali di medicazione, che spesso avvengono in piedi o in movimento.

---

## Integrazione di Funzionalità

Tutte queste caratteristiche non funzionano in modo isolato, ma sono profondamente integrate per creare un'esperienza coesa. Ad esempio:

- Un farmaco aggiunto nel flusso di 8 passaggi si assegna automaticamente a persone, genera notifiche secondo il suo tipo di frequenza, appare nell'armadietto ordinato alfabeticamente, registra le sue dosi nella cronologia, e aggiorna statistiche di aderenza.

- Le notifiche rispettano la configurazione del digiuno, aggiornando automaticamente il conto alla rovescia visuale quando si registra una dose con digiuno posteriore.

- Il controllo della scorta multi-persona calcola correttamente i giorni rimanenti considerando le dosi di tutte le persone assegnate, e allerta quando la soglia si raggiunge indipendentemente da chi assume il farmaco.

- Il cambio di lingua aggiorna istantaneamente tutte le notifiche pendenti, le schermate visibili, e i messaggi del sistema, mantenendo consistenza totale.

Questa integrazione profonda è ciò che converte MedicApp da una semplice lista di farmaci in un sistema completo di gestione terapeutica familiare.

---

## Riferimenti a Documentazione Aggiuntiva

Per informazioni più dettagliate su aspetti specifici:

- **Architettura Multi-Persona**: Vedere documentazione del database (tabelle `persons`, `medications`, `person_medications`)
- **Sistema di Notifiche**: Vedere codice sorgente in `lib/services/notification_service.dart`
- **Modello di Dati**: Vedere modelli in `lib/models/` (specialmente `medication.dart`, `person.dart`, `person_medication.dart`)
- **Localizzazione**: Vedere file `.arb` in `lib/l10n/` per ogni lingua
- **Test**: Vedere suite di test in `test/` con 432+ test che validano tutte queste funzionalità

---

Questa documentazione riflette lo stato attuale di MedicApp nella sua versione 1.0.0, un'applicazione matura e completa per gestione di farmaci familiari con più del 75% di copertura di test e supporto completo per 8 lingue.
