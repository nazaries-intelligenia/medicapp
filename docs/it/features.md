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

## 5. Gestione delle Date di Scadenza

### Controllo della Scadenza dei Farmaci

MedicApp consente di registrare e monitorare le date di scadenza dei farmaci per garantire la sicurezza del trattamento. Questa funzionalità è particolarmente importante per i farmaci al bisogno e sospesi che rimangono conservati per periodi prolungati.

Il sistema utilizza un formato semplificato MM/AAAA (mese/anno) che corrisponde al formato standard stampato sulle confezioni dei farmaci. Ciò facilita l'inserimento dei dati senza dover conoscere il giorno esatto di scadenza.

### Rilevamento Automatico dello Stato

MedicApp valuta automaticamente lo stato di scadenza di ogni farmaco:

- **Scaduto**: Il farmaco ha superato la sua data di scadenza e viene visualizzato con un'etichetta rossa di avvertimento con icona di allerta.
- **Prossimo alla scadenza**: 30 giorni o meno fino alla scadenza, viene visualizzato con un'etichetta arancione di precauzione con icona di orologio.
- **In buono stato**: Più di 30 giorni fino alla scadenza, non viene visualizzato alcun avvertimento speciale.

Gli avvisi visivi appaiono direttamente sulla scheda del farmaco nell'armadietto, accanto allo stato di sospensione se applicabile, consentendo di identificare rapidamente i farmaci che richiedono attenzione.

### Registrazione della Data di Scadenza

Il sistema richiede la data di scadenza in tre momenti specifici:

1. **Durante la creazione di un farmaco al bisogno**: Come ultimo passo del processo di creazione (passo 2/2), viene visualizzata una finestra di dialogo opzionale per inserire la data di scadenza prima di salvare il farmaco.

2. **Durante la sospensione del farmaco**: Quando si sospende qualsiasi farmaco per tutti gli utenti che lo condividono, viene richiesta la data di scadenza. Ciò consente di registrare la data della confezione che rimarrà conservata.

3. **Durante il rifornimento di un farmaco al bisogno**: Dopo aver aggiunto scorte a un farmaco al bisogno, il sistema offre di aggiornare la data di scadenza per riflettere la data della nuova confezione acquisita.

In tutti i casi, il campo è facoltativo e può essere omesso. L'utente può annullare l'operazione o semplicemente lasciare il campo vuoto.

### Formato e Validazioni

La finestra di dialogo per l'inserimento della data di scadenza fornisce due campi separati:
- Campo del mese (MM): accetta valori da 01 a 12
- Campo dell'anno (AAAA): accetta valori da 2000 a 2100

Il sistema valida automaticamente che il mese sia nell'intervallo corretto e che l'anno sia valido. Al completamento del mese (2 cifre), il focus si sposta automaticamente al campo dell'anno per velocizzare l'inserimento dei dati.

La data viene memorizzata nel formato "MM/AAAA" (esempio: "03/2025") e viene interpretata come l'ultimo giorno di quel mese per i confronti di scadenza. Ciò significa che un farmaco con data "03/2025" sarà considerato scaduto a partire dal 1° aprile 2025.

### Vantaggi del Sistema

Questa funzionalità aiuta a:
- Prevenire l'uso di farmaci scaduti che potrebbero essere inefficaci o pericolosi
- Gestire efficacemente le scorte identificando i farmaci prossimi alla scadenza
- Dare priorità all'uso dei farmaci in base alla loro data di scadenza
- Mantenere un armadietto sicuro con controllo visivo dello stato di ogni farmaco
- Evitare sprechi ricordando di controllare i farmaci prima che scadano

Il sistema non impedisce la registrazione delle dosi con farmaci scaduti, ma fornisce avvisi visivi chiari in modo che l'utente possa prendere decisioni informate.

---

## 6. Controllo della Scorta (Armadietto)

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

## 7. Armadietto

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

## 8. Navigazione Temporale

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

## 9. Notifiche Intelligenti

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

### Configurazione del Suono di Notifica (Android 8.0+)

Sui dispositivi con Android 8.0 (API 26) o superiore, MedicApp offre accesso diretto alla configurazione del suono di notifica dalle impostazioni dell'applicazione. Questa funzionalità permette di personalizzare il suono, la vibrazione e altri parametri delle notifiche utilizzando i canali di notifica del sistema.

L'opzione "Suono di notifica" appare nella schermata Impostazioni solo quando il dispositivo soddisfa i requisiti minimi della versione del sistema operativo. Nelle versioni precedenti ad Android 8.0, questa opzione viene nascosta automaticamente poiché il sistema non supporta la configurazione granulare dei canali di notifica.

---

## 10. Avvisi di Scorte Basse

### Notifiche Reattive di Stock Insufficiente

MedicApp implementa un sistema intelligente di avvisi di stock che protegge l'utente dal rimanere senza farmaci in momenti critici. Quando un utente tenta di registrare una dose (sia dalla schermata principale che dalle azioni rapide di notifica), il sistema verifica automaticamente se c'è scorta sufficiente per completare l'assunzione.

Se la scorta disponibile è inferiore alla quantità richiesta per la dose, MedicApp mostra immediatamente un avviso di stock insufficiente che impedisce la registrazione dell'assunzione. Questa notifica reattiva indica chiaramente il nome del farmaco interessato, la quantità necessaria rispetto a quella disponibile, e suggerisce di ripristinare l'inventario prima di tentare nuovamente di registrare la dose.

Questo meccanismo di protezione previene registrazioni incorrette nella cronologia e garantisce l'integrità del controllo dell'inventario, evitando che venga decrementata scorta che fisicamente non esiste. L'avviso è chiaro, non intrusivo, e guida l'utente direttamente verso l'azione correttiva (ripristinare lo stock).

### Notifiche Proattive di Stock Basso

Oltre agli avvisi reattivi nel momento di assumere una dose, MedicApp include un sistema proattivo di monitoraggio giornaliero dello stock che anticipa problemi di esaurimento prima che si verifichino. Questo sistema valuta automaticamente l'inventario di tutti i farmaci una volta al giorno, calcolando i giorni di fornitura rimanenti secondo il consumo programmato.

Il calcolo considera molteplici fattori per stimare con precisione quanto durerà la scorta attuale:

**Per farmaci programmati** - Il sistema somma la dose giornaliera totale di tutte le persone assegnate, moltiplica per i giorni configurati nel pattern di frequenza (ad esempio, se si assume solo lunedì, mercoledì e venerdì, aggiusta il calcolo), e divide la scorta attuale per questo consumo giornaliero effettivo.

**Per farmaci occasionali ("secondo necessità")** - Utilizza il registro dell'ultimo giorno di consumo reale come predittore, fornendo una stima adattativa che migliora con l'uso.

Quando la scorta di un farmaco raggiunge la soglia configurata (per default 3 giorni, ma personalizzabile tra 1-10 giorni per farmaco), MedicApp emette una notifica proattiva di avvertimento. Questa notifica mostra:

- Nome del farmaco e tipo
- Giorni approssimativi di fornitura rimanente
- Persona/e interessata/e
- Scorta attuale in unità corrispondenti
- Suggerimento di rifornimento

### Prevenzione dello Spam di Notifiche

Per evitare di bombardare l'utente con avvisi ripetitivi, il sistema di notifiche proattive implementa una logica intelligente di frequenza. Ogni tipo di avviso di stock basso viene emesso massimo una volta al giorno per farmaco. Il sistema registra l'ultima data in cui è stato inviato ogni avviso e non notifica nuovamente finché:

1. Non sono trascorse almeno 24 ore dall'ultimo avviso, O
2. L'utente non ha rifornito lo stock (reimpostando il contatore)

Questa prevenzione dello spam assicura che le notifiche siano utili e tempestive senza diventare un fastidio che porti l'utente a ignorarle o disabilitarle.

### Integrazione con Controllo di Stock Visuale

Gli avvisi di stock basso non funzionano in modo isolato, ma sono profondamente integrati con il sistema di semafori visuali dell'armadietto. Quando un farmaco ha stock basso:

- Appare contrassegnato in rosso o ambra nella lista dell'armadietto
- Mostra un'icona di avvertimento nella schermata principale
- La notifica proattiva complementa questi segnali visuali

Questo strato multiplo di informazioni (visuale + notifiche) garantisce che l'utente sia consapevole dello stato dell'inventario da più punti di contatto con l'applicazione.

### Configurazione e Personalizzazione

Ogni farmaco può avere una soglia di avviso personalizzata che determina quando si considera lo stock "basso". Farmaci critici come insulina o anticoagulanti possono essere configurati con soglie di 7-10 giorni per permettere un tempo ampio di rifornimento, mentre integratori meno urgenti possono usare soglie di 1-2 giorni.

Il sistema rispetta queste configurazioni individuali, permettendo che ogni farmaco abbia la propria politica di avvisi adattata alla sua criticità e disponibilità nelle farmacie.

---

## 11. Configurazione del Digiuno

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

## 12. Cronologia delle Dosi

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

## 13. Localizzazione e Internazionalizzazione

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

## 14. Sistema di Cache Intelligente

### Architettura di Cache Multi-Livello

MedicApp implementa un sistema di cache sofisticato che riduce drasticamente gli accessi al database, migliorando significativamente le prestazioni e la reattività dell'applicazione. Il sistema è progettato specificamente per ottimizzare le query più frequenti relative a farmaci, cronologia delle dosi e statistiche di aderenza.

### Componenti del Sistema

**SmartCacheService** - Il nucleo del sistema è un'implementazione generica di cache che combina due potenti strategie di evizione:

- **TTL (Time-To-Live) automatico**: Ogni voce nella cache ha una data di scadenza configurabile. Quando una voce scade, viene considerata non valida e la prossima query forza un ricaricamento dal database. Questo assicura che i dati non siano mai troppo obsoleti.

- **Algoritmo LRU (Least Recently Used)**: Quando la cache raggiunge la sua capacità massima, evicta automaticamente la voce acceduta meno recentemente. Questo algoritmo garantisce che i dati consultati più frequentemente rimangano in memoria.

**MedicationCacheService** - Questo livello specializzato gestisce quattro cache indipendenti, ciascuna ottimizzata per un tipo specifico di dati:

1. **medicationsCache** (10 minuti TTL, 50 voci massimo):
   - Memorizza farmaci individuali per ID
   - Ideale per query ripetute dello stesso farmaco
   - TTL moderato perché i farmaci possono essere modificati frequentemente

2. **listsCache** (5 minuti TTL, 20 voci massimo):
   - Mette in cache liste complete di farmaci filtrate per persona o criteri
   - TTL più breve perché le liste cambiano quando si aggiungono/modificano farmaci
   - Migliora drammaticamente il caricamento della schermata principale

3. **historyCache** (3 minuti TTL, 30 voci massimo):
   - Memorizza query di cronologia delle dosi
   - TTL breve perché la cronologia si aggiorna costantemente con nuove dosi
   - Ottimizza le viste della cronologia con filtri specifici

4. **statisticsCache** (30 minuti TTL, 10 voci massimo):
   - Mette in cache calcoli statistici pesanti (aderenza, tendenze)
   - TTL lungo perché le statistiche non cambiano drasticamente minuto per minuto
   - Riduce calcoli costosi di analisi dell'aderenza

### Pattern Cache-Aside

Il sistema implementa il pattern cache-aside mediante il metodo `getOrCompute()`:

```dart
final medications = await cache.getOrCompute(
  'medications_person123',
  () => database.getMedicationsForPerson('person123'),
);
```

Questo pattern verifica prima la cache. Se la voce esiste e non è scaduta (cache hit), la ritorna immediatamente. Se non esiste o è scaduta (cache miss), esegue la funzione di calcolo, memorizza il risultato nella cache e lo ritorna. Questa astrazione semplifica l'uso della cache in tutta l'applicazione.

### Invalidazione Intelligente

Quando i dati vengono modificati, il sistema invalida selettivamente solo le cache interessate:

- **Alla creazione/modifica farmaco**: Invalida cache del farmaco specifico e liste che lo contengono
- **Alla registrazione dose**: Invalida cronologia del farmaco e statistiche della persona
- **All'eliminazione farmaco**: Pulisce tutte le cache correlate a quell'ID

Questa invalidazione selettiva evita di pulire l'intero sistema di cache, preservando dati validi che non sono stati interessati dalla modifica.

### Metriche e Monitoraggio

Ogni cache mantiene statistiche in tempo reale:

- **Hit Rate**: Percentuale di richieste soddisfatte dalla cache senza accedere al DB
- **Hits**: Contatore di accessi riusciti dalla cache
- **Misses**: Contatore di accessi che hanno richiesto query al DB
- **Evictions**: Numero di voci rimosse da LRU o scadenza

Queste metriche sono preziose per regolare i parametri della cache (TTL e dimensione massima) secondo i pattern di utilizzo reali.

### Benefici Misurati

Il sistema di cache fornisce miglioramenti tangibili delle prestazioni:

- **Riduzione del 60-80%** nelle query al database per dati acceduti frequentemente
- **Lista farmaci**: Da 50-200ms a 2-5ms nei cache hit (40-100x più veloce)
- **Query cronologia**: Da 300-500ms a 5-10ms nei cache hit (60-100x più veloce)
- **Calcoli statistici**: Da 800-1200ms a 10-15ms nei cache hit (80-120x più veloce)

Questi numeri si traducono in un'esperienza utente notevolmente più fluida, specialmente quando si naviga ripetutamente tra schermate o si cambiano filtri.

### Gestione Responsabile della Memoria

Il sistema limita rigorosamente l'uso della memoria mediante:

- Dimensioni massime configurate per tipo di cache
- Algoritmo LRU che evicta automaticamente voci vecchie
- Timer di pulizia che elimina voci scadute ogni minuto
- Invalidazione proattiva alla modifica di dati correlati

Questa gestione assicura che la cache migliori le prestazioni senza causare problemi di memoria su dispositivi con risorse limitate.

---

## 15. Sistema di Promemoria Intelligenti

### Analisi dell'Aderenza Terapeutica

MedicApp include un sistema avanzato di analisi dell'aderenza che va oltre il semplice monitoraggio di dosi assunte/omesse. Il sistema esamina pattern storici per identificare tendenze, problemi ricorrenti e opportunità di miglioramento.

**Analisi Multi-Dimensionale** - Il metodo `analyzeAdherence()` realizza un'analisi esaustiva della cronologia delle dosi di un paziente per un farmaco specifico:

**Metriche per Giorno della Settimana**: Calcola il tasso di aderenza individuale per ogni giorno (lunedì a domenica). Questo rivela se certi giorni della settimana sono problematici. Ad esempio, può rilevare che i fine settimana hanno il 30% in meno di aderenza rispetto ai giorni lavorativi, indicando che la routine lavorativa aiuta a ricordare le dosi.

**Metriche per Ora del Giorno**: Analizza l'aderenza secondo l'orario della dose (mattina, mezzogiorno, pomeriggio, notte). Identifica se certi orari sono costantemente problematici. Ad esempio, può rivelare che le dosi delle 22:00 hanno solo il 40% di aderenza, mentre quelle delle 08:00 hanno il 90%.

**Identificazione dei Migliori/Peggiori Periodi**: Il sistema determina automaticamente qual è il miglior giorno della settimana e il miglior orario del giorno in termini di aderenza. Questo fornisce insights preziosi su quando il paziente è più consistente con la sua medicazione.

**Giorni Problematici**: Elenca specificamente i giorni dove l'aderenza scende sotto il 50%, marcandoli come critici per intervento. Questa lista permette di focalizzare gli sforzi di miglioramento sui periodi più problematici.

**Raccomandazioni Personalizzate**: Basandosi su tutti i pattern rilevati, il sistema genera suggerimenti automatici come:
- "Considera di spostare la dose dalle 22:00 alle 20:00 (migliore aderenza storica)"
- "I fine settimana necessitano promemoria aggiuntivi"
- "La tua aderenza mattutina è eccellente, prova a consolidare le dosi al mattino"

**Calcolo della Tendenza**: Confronta l'aderenza recente (ultimi 7 giorni) con l'aderenza storica (ultimi 30 giorni) per determinare se il pattern sta migliorando, si mantiene stabile o sta declinando. Una tendenza positiva indica che le strategie attuali stanno funzionando.

### Previsione di Omissioni

**Modello Predittivo** - Il metodo `predictSkipProbability()` utilizza machine learning di base per predire la probabilità che una dose specifica venga omessa:

**Input del Modello**: Riceve informazione contestuale sulla dose da predire:
- Giorno della settimana specifico (es: sabato)
- Ora del giorno specifica (es: 22:00)
- ID di persona e farmaco

**Analisi di Pattern Storici**: Esamina la cronologia delle dosi per situazioni simili (stesso giorno della settimana, stessa ora) e calcola quale percentuale di quelle dosi è stata omessa nel passato.

**Classificazione del Rischio**: Converte la probabilità numerica in una classificazione qualitativa:
- **Rischio Basso**: <30% probabilità di omissione
- **Rischio Medio**: 30-60% probabilità
- **Rischio Alto**: >60% probabilità

**Identificazione dei Fattori**: Fornisce spiegazioni sul perché si predice quel livello di rischio:
- "I sabati hanno il 60% in più di omissioni rispetto ai giorni lavorativi"
- "L'orario 22:00 è costantemente problematico"
- "La tua aderenza è declinata nelle ultime 2 settimane"

**Casi d'Uso**: Questa funzionalità abilita allerte proattive. Ad esempio, se il sistema rileva che una dose del sabato alle 22:00 ha il 75% di probabilità di omissione, può inviare una notifica preventiva aggiuntiva o suggerire all'utente di riprogrammare quella dose.

### Ottimizzazione degli Orari

**Suggerimenti Intelligenti** - Il metodo `suggestOptimalTimes()` agisce come un assistente personale che aiuta l'utente a trovare i migliori orari per i suoi farmaci:

**Identificazione di Orari Problematici**: Analizza tutti gli orari attuali del farmaco e marca quelli con aderenza inferiore al 70% come candidati per ottimizzazione.

**Ricerca di Alternative**: Per ogni orario problematico, cerca nella cronologia orari alternativi dove l'utente storicamente ha avuto migliore aderenza.

**Calcolo del Potenziale di Miglioramento**: Confronta l'aderenza attuale dell'orario problematico con l'aderenza attesa dell'orario suggerito, calcolando il potenziale di miglioramento. Ad esempio: "Spostare dalle 22:00 (45% aderenza) alle 20:00 (82% aderenza) = +37% potenziale di miglioramento".

**Prioritizzazione per Impatto**: Ordina i suggerimenti per impatto atteso, mostrando prima quelli che hanno maggior potenziale di migliorare l'aderenza globale.

**Giustificazioni Basate sui Dati**: Ogni suggerimento viene accompagnato da una ragione specifica derivata dalla cronologia:
- "La tua aderenza alle 20:00 è costantemente alta (82%)"
- "Non hai mai omesso dosi tra le 08:00-09:00"
- "Le dosi mattutine hanno il 40% in più di aderenza rispetto a quelle notturne"

### Integrazione con l'Applicazione

Queste funzionalità di analisi intelligente sono progettate per essere integrate in vari punti dell'applicazione:

**Schermata Statistiche Dettagliate**: Una vista dedicata che mostra l'analisi completa dell'aderenza con grafici visuali di tendenze, mappe di calore per giorno/ora, e lista di raccomandazioni prioritizzate.

**Allerte Proattive**: Notifiche automatiche quando si rilevano pattern preoccupanti:
- "La tua aderenza per [Farmaco] è diminuita del 20% questa settimana"
- "Rileviamo che ometti dosi i venerdì costantemente"

**Assistente Configurazione Orari**: Durante la creazione o modifica di farmaci, il sistema può suggerire orari ottimali basandosi sulla cronologia di aderenza dell'utente con altri farmaci.

**Report Medici**: Generazione automatica di report di aderenza con insights da condividere con professionisti sanitari durante le visite.

---

## 16. Tema Scuro Nativo

### Sistema Completo di Tematizzazione

MedicApp implementa un sistema professionale di temi con supporto nativo per modalità chiara e oscura, seguendo rigorosamente le linee guida di Material Design 3 (Material You) di Google.

### Tre Modalità di Funzionamento

**Modalità System (Automatica)**: L'applicazione rileva e segue la configurazione del tema del sistema operativo del dispositivo. Se l'utente cambia il suo telefono in modalità oscura nelle impostazioni di sistema, MedicApp cambia automaticamente al suo tema scuro senza intervento. Questa modalità è quella predefinita e fornisce l'esperienza più integrata con il dispositivo.

**Modalità Light (Chiaro Forzato)**: Forza l'applicazione a usare il tema chiaro indipendentemente dalla configurazione di sistema. Utile per utenti che preferiscono modalità oscura nel sistema ma vogliono MedicApp in modalità chiara per leggibilità in contesti medici.

**Modalità Dark (Oscuro Forzato)**: Forza il tema oscuro anche se il sistema è in modalità chiara. Ideale per utenti che usano l'app frequentemente di notte e vogliono ridurre la fatica visiva e risparmiare batteria su schermi OLED.

### Schemi di Colore Coesivi

**Tema Chiaro**: Progettato per massima leggibilità in condizioni di buona illuminazione:
- Sfondi bianchi e superfici grigio molto chiaro
- Testo nero con contrasto sufficiente (rapporto 4.5:1 o superiore)
- Colori primari vibranti per elementi interattivi
- Ombre sottili per gerarchia visuale

**Tema Scuro**: Ottimizzato per uso notturno e riduzione di fatica visuale:
- Sfondi nero puro (#000000) per massimo risparmio batteria su OLED
- Superfici in grigi scuri con elevazione visibile
- Colori desaturati che non affaticano la vista
- Testo bianco/grigio chiaro con rapporti di contrasto appropriati
- Eliminazione del bianco puro che può essere abbagliante

### Personalizzazione Esaustiva dei Componenti

Ogni componente Material Design è stilizzato in modo consistente in entrambi i temi:

**AppBar**: Barre superiori con colori di sfondo che riflettono la superficie principale, testo leggibile e icone contrastate.

**Cards**: Schede con elevazione appropriata (più pronunciata in scuro), bordi arrotondati morbidi, e colori di superficie differenziati dallo sfondo.

**FloatingActionButton**: Pulsanti di azione prominenti con colori primari evidenziati, ombre appropriate e icone chiare.

**InputFields**: Campi di testo con bordi visibili in entrambe le modalità, etichette fluttuanti, colori di errore distinguibili e stati di focus chiari.

**Dialogs**: Dialog modali con angoli arrotondati, superfici elevate che si distinguono dallo sfondo, e azioni dei pulsanti chiaramente differenziate.

**SnackBars**: Notifiche temporanee con sfondo semi-opaco, testo leggibile e posizionamento consistente.

**Text Hierarchy**: Gerarchia tipografica completa con dimensioni, pesi e colori appropriati per titoli, sottotitoli, corpo ed etichette in entrambe le modalità.

### Gestione dello Stato Reattiva

**ThemeProvider**: Un `ChangeNotifier` che gestisce lo stato del tema attuale:
- Mantiene il `ThemeMode` attivo (system/light/dark)
- Notifica a tutti i widget sottoscritti quando cambia il tema
- Persiste la scelta dell'utente in SharedPreferences
- Carica il tema salvato automaticamente all'avvio dell'app

**Integrazione con MaterialApp**: L'applicazione ascolta i cambiamenti del ThemeProvider e si aggiorna istantaneamente senza riavviare:

```dart
MaterialApp(
  theme: AppTheme.lightTheme,        // Tema chiaro
  darkTheme: AppTheme.darkTheme,     // Tema scuro
  themeMode: themeProvider.themeMode, // Modalità attuale
)
```

### Transizioni Fluide

I cambiamenti di tema sono completamente fluidi:
- Senza necessità di riavviare l'applicazione
- Animazione fluida di transizione dei colori
- Preservazione completa dello stato dell'app
- Aggiornamento istantaneo di tutti i widget visibili

### Benefici per l'Utente

**Accessibilità Migliorata**: Utenti con sensibilità alla luce intensa possono usare la modalità oscura comodamente. Utenti con bassa visione possono beneficiare dell'alto contrasto della modalità chiara.

**Risparmio Batteria**: Su dispositivi con schermi OLED/AMOLED, il tema scuro con neri puri può risparmiare il 30-60% di energia dello schermo rispetto al tema chiaro.

**Riduzione della Fatica Visuale**: La modalità oscura riduce significativamente l'emissione di luce blu, essendo più comoda per uso notturno o prolungato.

**Integrazione con il Sistema**: La modalità automatica crea un'esperienza coesiva dove MedicApp si sente come parte nativa del sistema operativo.

**Preferenza Persistente**: La scelta dell'utente viene salvata e mantenuta tra le sessioni, non richiedendo riconfigurazioni ripetute.

---

## 17. Interfaccia Accessibile e Usabile

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

## 18. Widget della Schermata Home (Android)

### Vista Rapida delle Dosi Giornaliere

MedicApp include un widget nativo Android per la schermata home che permette di visualizzare le dosi programmate del giorno corrente senza aprire l'applicazione. Questo widget fornisce informazioni essenziali a colpo d'occhio, ideale per utenti che necessitano di un promemoria visivo costante della loro medicazione.

### Caratteristiche del Widget

**Dimensione 2x2**: Il widget occupa uno spazio di 2x2 celle sulla schermata home (circa 146x146dp), abbastanza compatto da non occupare troppo spazio ma con informazioni chiaramente leggibili.

**Lista delle Dosi del Giorno**: Mostra tutte le dosi programmate per il giorno corrente, incluso:
- Nome del farmaco
- Ora programmata di ogni dose
- Stato visivo (in sospeso, assunta o saltata)

**Indicatori di Stato Visuali**:
Il widget utilizza tre stati visuali distinti per rappresentare chiaramente lo stato di ogni dose:
- **Cerchio verde pieno con segno di spunta (✓)**: Dose assunta - il testo viene visualizzato al 70% di opacità per indicare completamento
- **Cerchio verde vuoto (○)**: Dose in sospeso - il testo viene visualizzato al 100% di opacità per evidenziare l'azione pendente
- **Cerchio grigio tratteggiato (◌)**: Dose saltata - il testo viene visualizzato al 50% di opacità per indicare che la dose è stata omessa

**Contatore di Progresso**: L'intestazione del widget mostra un contatore "X/Y" che indica quante dosi sono state assunte sul totale programmato per la giornata.

### Filtraggio Intelligente dei Farmaci

**Filtraggio per Tipo di Durata**: Il widget applica un filtraggio intelligente che mostra solo i farmaci rilevanti per la giornata corrente, basandosi sul `durationType` configurato per ogni farmaco. Questo assicura che vengano visualizzate solo le dosi effettivamente programmate per il giorno corrente secondo la frequenza del trattamento.

**Esclusione di Farmaci al Bisogno**: I farmaci configurati come "asNeeded" (al bisogno o secondo necessità) non vengono mostrati nel widget, poiché non hanno orari programmati e quindi non necessitano di promemoria visuali nella schermata home. Questi farmaci si gestiscono esclusivamente dall'interno dell'applicazione.

### Integrazione con l'Applicazione

**Apertura Diretta dell'App**: Toccando qualsiasi parte del widget - che sia l'intestazione, un elemento della lista, o uno spazio vuoto - si apre immediatamente l'applicazione principale di MedicApp. Questa interazione rapida permette di accedere istantaneamente a tutte le funzionalità dell'app per gestire le dosi, aggiornare la scorta o rivedere la cronologia.

**Aggiornamento Automatico**: Il widget si aggiorna automaticamente ogni volta che:
- Viene registrata una dose (assunta, saltata o extra)
- Viene aggiunto o modificato un farmaco
- Cambia il giorno (a mezzanotte)

**Comunicazione Flutter-Android**: L'integrazione utilizza un MethodChannel (`com.medicapp.medicapp/widget`) che permette all'applicazione Flutter di notificare il widget nativo quando i dati cambiano.

**Lettura Diretta del Database**: Il widget accede direttamente al database SQLite dell'applicazione per ottenere i dati dei farmaci, assicurando informazioni aggiornate anche quando l'app non è in esecuzione.

### Tema Visivo DeepEmerald

Il widget utilizza la palette di colori DeepEmerald, il tema predefinito di MedicApp:

- **Sfondo**: Verde scuro profondo (#1E2623) con 90% di opacità
- **Icone e accenti**: Verde chiaro (#81C784)
- **Testo**: Bianco con diversi livelli di opacità secondo lo stato (100% per dosi in sospeso, 70% per assunte, 50% per saltate)
- **Divisori**: Verde chiaro con trasparenza

### Limitazioni Tecniche

**Solo Android**: Il widget è una funzionalità nativa Android e non è disponibile su iOS, web o altre piattaforme.

**Persona predefinita**: Il widget mostra le dosi della persona configurata come predefinita nell'applicazione.

### File Correlati

- `android/app/src/main/kotlin/.../MedicationWidgetProvider.kt` - Provider principale del widget
- `android/app/src/main/kotlin/.../MedicationWidgetService.kt` - Servizio per la ListView del widget
- `android/app/src/main/res/layout/medication_widget_layout.xml` - Layout principale
- `lib/services/widget_service.dart` - Servizio Flutter per comunicazione con il widget

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
