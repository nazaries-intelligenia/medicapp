# Funcionalitats de MedicApp

Aquest document detalla totes les característiques i capacitats de MedicApp, una aplicació avançada de gestió de medicaments dissenyada per a famílies i cuidadors.

---

## 1. Gestió Multi-Persona (V19+)

### Arquitectura Molts-a-Molts

MedicApp implementa una arquitectura sofisticada de gestió multi-persona que permet a múltiples usuaris compartir medicaments mentre mantenen configuracions de tractament individuals. Aquesta funcionalitat està dissenyada específicament per a famílies, cuidadors professionals i grups que necessiten coordinar la medicació de diverses persones.

L'arquitectura es basa en un model relacional de molts-a-molts, on cada medicament (identificat per nom, tipus i estoc compartit) pot ser assignat a múltiples persones, i cada persona pot tenir múltiples medicaments. L'estoc es gestiona de forma centralitzada i es descompta automàticament independentment de qui prengui el medicament, la qual cosa permet un control precís de l'inventari compartit sense duplicar dades.

Cada persona pot configurar la seva pròpia pauta de tractament per al mateix medicament, incloent horaris específics, dosis personalitzades, durada del tractament, i preferències de dejuni. Per exemple, si una mare i la seva filla comparteixen un mateix medicament, la mare pot tenir configurades preses a les 8:00 i 20:00, mentre que la filla només necessita una dosi diària a les 12:00. Ambdues comparteixen el mateix estoc físic, però cadascuna rep notificacions i seguiment independent segons la seva pauta.

### Casos d'Ús

Aquesta funcionalitat és especialment útil en diversos escenaris: famílies on diversos membres prenen el mateix medicament (com vitamines o suplements), cuidadors professionals que gestionen la medicació de múltiples pacients, llars multigeneracionals on es comparteixen medicaments comuns, i situacions on cal controlar l'estoc compartit per evitar desabastiments. El sistema permet realitzar un seguiment detallat de l'historial de dosis per persona, facilitant l'adherència terapèutica i el control mèdic individualitzat.

---

## 2. 14 Tipus de Medicaments

### Catàleg Complet de Formes Farmacèutiques

MedicApp suporta 14 tipus diferents de medicaments, cadascun amb iconografia distintiva, esquema de colors específic i unitats de mesura apropiades. Aquesta diversitat permet registrar pràcticament qualsevol forma farmacèutica que es trobi en un armari domèstic o professional.

**Tipus disponibles:**

1. **Pastilla** - Color blau, icona circular. Unitat: pastilles. Per a comprimit sòlids tradicionals.
2. **Càpsula** - Color morat, icona de càpsula. Unitat: càpsules. Per a medicaments en forma de càpsula gelatinosa.
3. **Injecció** - Color vermell, icona de xeringa. Unitat: injeccions. Per a medicaments que requereixen administració parenteral.
4. **Xarop** - Color taronja, icona de got. Unitat: ml (mil·lilitres). Per a medicaments líquids d'administració oral.
5. **Òvul** - Color rosa, icona ovalada. Unitat: òvuls. Per a medicaments d'administració vaginal.
6. **Supositori** - Color verd blavós (teal), icona específica. Unitat: supositoris. Per a administració rectal.
7. **Inhalador** - Color cian, icona d'aire. Unitat: inhalacions. Per a medicaments respiratoris.
8. **Sobre** - Color marró, icona de paquet. Unitat: sobres. Per a medicaments en pols o granulats.
9. **Esprai** - Color blau clar, icona de goteig. Unitat: ml (mil·lilitres). Per a nebulitzadors i aerosols nasals.
10. **Pomada** - Color verd, icona de gota opaca. Unitat: grams. Per a medicaments tòpics cremosos.
11. **Loció** - Color indi, icona d'aigua. Unitat: ml (mil·lilitres). Per a medicaments líquids tòpics.
12. **Apòsit** - Color ambre, icona de curació. Unitat: apòsits. Per a pegats medicats i apòsits terapèutics.
13. **Gota** - Color gris blavós, icona de gota invertida. Unitat: gotes. Per a col·liris i gotes òtiques.
14. **Altre** - Color gris, icona genèrica. Unitat: unitats. Per a qualsevol forma farmacèutica no categoritzada.

### Beneficis del Sistema de Tipus

Aquesta classificació detallada permet al sistema calcular automàticament l'estoc de forma precisa segons la unitat de mesura corresponent, mostrar icones i colors que faciliten la identificació visual ràpida, i generar notificacions contextuals que mencionen el tipus específic de medicament. Els usuaris poden gestionar des de tractaments simples amb pastilles fins a règims complexos que inclouen inhaladors, injeccions i gotes, tot dins d'una mateixa interfície coherent.

---

## 3. Flux d'Addició de Medicaments

### Medicaments Programats (8 Passos)

El procés d'addició d'un medicament amb horari programat és guiat i estructurat per assegurar que es configuri correctament tota la informació necessària:

**Pas 1: Informació Bàsica** - S'introdueix el nom del medicament i se selecciona el tipus d'entre les 14 opcions disponibles. El sistema valida que el nom no estigui buit.

**Pas 2: Freqüència de Tractament** - Es defineix el patró de presa amb sis opcions: tots els dies, fins acabar medicació, dates específiques, dies de la setmana, cada N dies, o segons necessitat. Aquesta configuració determina quan s'han de prendre les dosis.

**Pas 3: Configuració de Dosis** - S'estableixen els horaris específics de presa. L'usuari pot triar entre mode uniforme (mateixa dosi en tots els horaris) o dosis personalitzades per cada horari. Per exemple, es pot configurar 1 pastilla a les 8:00, 0.5 pastilles a les 14:00 i 2 pastilles a les 20:00.

**Pas 4: Horaris de Presa** - Se seleccionen les hores exactes en què s'ha de prendre el medicament utilitzant un selector de temps visual. Es poden configurar múltiples horaris per dia segons el que s'hagi prescrit.

**Pas 5: Durada del Tractament** - Si escau segons el tipus de freqüència, s'estableixen les dates d'inici i fi del tractament. Això permet programar tractaments amb durada definida o tractaments continus.

**Pas 6: Configuració de Dejuni** - Es defineix si el medicament requereix dejuni abans o després de la presa, la durada del període de dejuni en minuts, i si es volen notificacions de recordatori de dejuni.

**Pas 7: Estoc Inicial** - S'introdueix la quantitat de medicament disponible en les unitats corresponents al tipus seleccionat. El sistema utilitzarà aquest valor per al control d'inventari.

**Pas 8: Assignació de Persones** - Se seleccionen les persones que prendran aquest medicament. Per a cada persona, es pot configurar una pauta individual amb horaris i dosis personalitzades, o heretar la configuració base.

### Medicaments Ocasionals (2 Passos)

Per a medicaments d'ús esporàdic o "segons necessitat", el procés se simplifica significativament:

**Pas 1: Informació Bàsica** - Nom i tipus del medicament.

**Pas 2: Estoc Inicial** - Quantitat disponible. El sistema automàticament configura el medicament com a "segons necessitat", sense horaris programats ni notificacions automàtiques.

### Validacions Automàtiques

Durant tot el procés, MedicApp valida que s'hagin completat tots els camps obligatoris abans de permetre avançar al següent pas. Es verifica que els horaris siguin lògics, que les dosis siguin valors numèrics positius, que les dates d'inici no siguin posteriors a les de fi, i que almenys s'assigni una persona al medicament.

---

## 4. Registre de Preses

### Preses Programades

MedicApp gestiona automàticament les preses programades segons la configuració de cada medicament i persona. Quan arriba l'hora d'una dosi, l'usuari rep una notificació i pot registrar la presa des de tres punts: la pantalla principal on apareix llistada la dosi pendent, la notificació directament mitjançant accions ràpides, o en tocar la notificació que obre una pantalla de confirmació detallada.

En registrar una presa programada, el sistema descompta automàticament la quantitat corresponent de l'estoc compartit, marca la dosi com a presa en el dia actual per a aquesta persona específica, crea una entrada a l'historial de dosis amb timestamp exacte, i cancel·la la notificació pendent si existeix. Si el medicament requereix dejuni posterior, es programa immediatament una notificació de fi de dejuni i es mostra un compte enrere visual a la pantalla principal.

### Preses Ocasionals

Per a medicaments configurats com a "segons necessitat" o quan cal registrar una presa fora d'horari, MedicApp permet el registre manual. L'usuari accedeix al medicament des de l'armari, selecciona "Prendre dosi", introdueix la quantitat presa manualment, i el sistema descompta de l'estoc i registra a l'historial amb l'horari actual. Aquesta funcionalitat és essencial per a analgèsics, antitèrmics i altres medicaments d'ús esporàdic.

### Preses Excepcionals

El sistema també permet registrar dosis addicionals no programades per a medicaments amb horari fix. Per exemple, si un pacient necessita una dosi extra d'analgèsic entre les seves preses habituals, pot registrar-la com a "dosi extra". Aquesta dosi es registra a l'historial marcada com a excepcional, descompta estoc, però no afecta el seguiment d'adherència de les dosis programades regulars.

### Historial Automàtic

Cada acció de registre genera automàticament una entrada completa a l'historial que inclou: la data i hora programada de la dosi, la data i hora real d'administració, la persona que va prendre el medicament, el nom i tipus del medicament, la quantitat exacta administrada, l'estat (presa o omesa), i si va ser una dosi extra no programada. Aquest historial permet anàlisi detallada de l'adherència terapèutica i facilita informes mèdics.

---

## 5. Gestió de Dates de Caducitat

### Control de Caducitat de Medicaments

MedicApp permet registrar i monitoritzar les dates de caducitat dels medicaments per garantir la seguretat del tractament. Aquesta funcionalitat és especialment important per a medicaments ocasionals i suspesos que romanen emmagatzemats durant períodes prolongats.

El sistema utilitza un format simplificat MM/AAAA (mes/any) que coincideix amb el format estàndard imprès en els envasos de medicaments. Això facilita la introducció de dades sense necessitat de conèixer el dia exacte de caducitat.

### Detecció Automàtica d'Estat

MedicApp avalua automàticament l'estat de caducitat de cada medicament:

- **Caducat**: El medicament ha superat la seva data de caducitat i es mostra amb una etiqueta vermella d'advertència amb icona d'alerta.
- **Proper a caducar**: Falten 30 dies o menys per a la caducitat, es mostra amb una etiqueta taronja de precaució amb icona de rellotge.
- **En bon estat**: Més de 30 dies fins a la caducitat, no es mostra advertència especial.

Les alertes visuals apareixen directament a la targeta del medicament al botiquí, al costat de l'estat de suspensió si escau, permetent identificar ràpidament medicaments que requereixen atenció.

### Registre de Data de Caducitat

El sistema sol·licita la data de caducitat en tres moments específics:

1. **En crear medicament ocasional**: Com a últim pas del procés de creació (pas 2/2), es mostra un diàleg opcional per introduir la data de caducitat abans de desar el medicament.

2. **En suspendre medicament**: Quan se suspèn qualsevol medicament per a tots els usuaris que el comparteixen, se sol·licita la data de caducitat. Això permet registrar la data de l'envàs que quedarà emmagatzemat.

3. **En recarregar medicament ocasional**: Després d'afegir estoc a un medicament ocasional, s'ofereix actualitzar la data de caducitat per reflectir la data del nou envàs adquirit.

En tots els casos, el camp és opcional i es pot ometre. L'usuari pot cancel·lar l'operació o simplement deixar el camp buit.

### Format i Validacions

El diàleg d'entrada de data de caducitat proporciona dos camps separats:
- Camp de mes (MM): accepta valors de 01 a 12
- Camp d'any (AAAA): accepta valors de 2000 a 2100

El sistema valida automàticament que el mes estigui en el rang correcte i que l'any sigui vàlid. En completar el mes (2 dígits), el focus es mou automàticament al camp d'any per agilitzar l'entrada de dades.

La data s'emmagatzema en format "MM/AAAA" (exemple: "03/2025") i s'interpreta com l'últim dia d'aquell mes per a les comparacions de caducitat. Això significa que un medicament amb data "03/2025" es considerarà caducat a partir de l'1 d'abril de 2025.

### Beneficis del Sistema

Aquesta funcionalitat ajuda a:
- Prevenir l'ús de medicaments caducats que podrien ser inefectius o perillosos
- Gestionar eficientment l'estoc identificant medicaments propers a caducar
- Prioritzar l'ús de medicaments segons la seva data de caducitat
- Mantenir un botiquí segur amb control visual de l'estat de cada medicament
- Evitar malbarataments recordant revisar medicaments abans que caduquin

El sistema no impedeix el registre de dosis amb medicaments caducats, però sí proporciona advertències visuals clares perquè l'usuari prengui decisions informades.

---

## 6. Control d'Estoc (Pastiller)

### Indicadors Visuals Intuïtius

El sistema de control d'estoc de MedicApp proporciona informació en temps real de l'inventari disponible mitjançant un sistema de semàfors visuals. Cada medicament mostra la seva quantitat actual en les unitats corresponents, amb indicadors de color que alerten sobre l'estat de l'estoc.

El codi de colors és intuïtiu: verd indica estoc suficient per a més de 3 dies, groc/ambre alerta que l'estoc està baix (menys de 3 dies de subministrament), i vermell indica que el medicament està esgotat. Els llindars de dies són configurables per medicament, permetent ajustos segons la criticitat de cada tractament.

### Càlcul Automàtic Intel·ligent

El càlcul de dies restants es realitza automàticament considerant múltiples factors. Per a medicaments programats, el sistema analitza la dosi diària total sumant totes les preses configurades de totes les persones assignades, divideix l'estoc actual entre aquesta dosi diària, i estima els dies de subministrament restants.

Per a medicaments ocasionals o "segons necessitat", el sistema utilitza un algorisme adaptatiu que registra el consum de l'últim dia d'ús i l'empra com a predictor per estimar quants dies durarà l'estoc actual. Aquesta estimació s'actualitza automàticament cada vegada que es registra un ús del medicament.

### Llindar Configurable per Medicament

Cada medicament pot tenir un llindar d'alerta personalitzat que determina quan es considera que l'estoc està baix. El valor predeterminat és 3 dies, però pot ajustar-se entre 1 i 10 dies segons les necessitats. Per exemple, medicaments crítics com insulina poden configurar-se amb un llindar de 7 dies per permetre temps suficient de reposició, mentre que suplements menys crítics poden usar llindars d'1-2 dies.

### Alertes i Reposició

Quan l'estoc arriba al llindar configurat, MedicApp mostra alertes visuals destacades a la pantalla principal i a la vista de pastiller. El sistema suggereix automàticament la quantitat a reposar basant-se en l'últim reabastiment registrat, agilitzant el procés d'actualització d'inventari. Les alertes persisteixen fins que l'usuari registra nova quantitat en estoc, assegurant que no s'oblidin reposicions crítiques.

---

## 7. Armari

### Llista Alfabètica Organitzada

L'armari de MedicApp presenta tots els medicaments registrats en una llista ordenada alfabèticament, facilitant la localització ràpida de qualsevol medicament. Cada entrada mostra el nom del medicament, el tipus amb la seva icona i color distintiu, l'estoc actual en les unitats corresponents, i les persones assignades a aquest medicament.

La vista d'armari és especialment útil per tenir una visió global de l'inventari de medicaments disponibles, sense la informació d'horaris que pot resultar aclaparadora a la vista principal. És la pantalla ideal per a gestions d'inventari, cerca de medicaments específics i accions de manteniment.

### Cercador en Temps Real

Un camp de cerca a la part superior permet filtrar medicaments instantàniament mentre s'escriu. La cerca és intel·ligent i considera tant el nom del medicament com el tipus, la qual cosa permet trobar "tots els xarops" o "medicaments que continguin aspirina" amb rapidesa. Els resultats s'actualitzen en temps real sense necessitat de prémer botons addicionals.

### Accions Ràpides Integrades

Des de cada medicament a l'armari, es pot accedir a un menú contextual amb tres accions principals:

**Editar** - Obre l'editor complet del medicament on es poden modificar tots els aspectes: nom, tipus, horaris, dosis, persones assignades, configuració de dejuni, etc. Els canvis es guarden i es resincronitzen automàticament les notificacions.

**Eliminar** - Permet esborrar permanentment el medicament del sistema després d'una confirmació de seguretat. Aquesta acció cancel·la totes les notificacions associades i elimina el registre de l'historial futur, però preserva l'historial de dosis ja registrades per mantenir integritat de dades.

**Prendre dosi** - Drecera ràpida per registrar una presa manual, especialment útil per a medicaments ocasionals. Si el medicament està assignat a múltiples persones, primer sol·licita seleccionar qui el pren.

### Gestió d'Assignacions

L'armari també facilita la gestió d'assignacions persona-medicament. Es poden veure d'una ullada quins medicaments estan assignats a cada persona, afegir o treure persones d'un medicament existent, i modificar les pautes individuals de cada persona sense afectar els altres.

---

## 8. Navegació Temporal

### Lliscar Horitzontal per Dies

La pantalla principal de MedicApp implementa un sistema de navegació temporal que permet a l'usuari moure's entre diferents dies amb un simple gest de lliscar horitzontal. Lliscar cap a l'esquerra avança al dia següent, mentre que lliscar cap a la dreta retrocedeix al dia anterior. Aquesta navegació és fluida i utilitza transicions animades que proporcionen feedback visual clar del canvi de data.

La navegació temporal és pràcticament il·limitada cap al passat i el futur, permetent revisar l'historial de medicació de setmanes o mesos enrere, o planificar amb anticipació verificant quins medicaments estaran programats en dates futures. El sistema manté un punt central virtual que permet milers de pàgines en ambdues direccions sense impacte en el rendiment.

### Selector de Calendari

Per a salts ràpids a dates específiques, MedicApp integra un selector de calendari accessible des d'un botó a la barra superior. En tocar la icona de calendari, s'obre un widget de calendari visual on l'usuari pot seleccionar qualsevol data. En seleccionar, la vista s'actualitza instantàniament per mostrar els medicaments programats d'aquell dia específic.

El calendari marca visualment el dia actual amb un indicador destacat, facilita la selecció de dates passades per revisar adherència, permet saltar a dates futures per a planificació de viatges o esdeveniments, i mostra la data seleccionada actual a la barra superior de forma permanent.

### Vista Dia vs Vista Setmanal

Tot i que la navegació principal és per dia, MedicApp proporciona context temporal addicional mostrant informació rellevant del període seleccionat. A la vista principal, els medicaments s'agrupen per horari de presa, la qual cosa proporciona una línia temporal del dia. Els indicadors visuals mostren quines dosis ja van ser preses, quines van ser omeses, i quines estan pendents.

Per a medicaments amb patrons setmanals o intervals específics, la interfície indica clarament si el medicament correspon al dia seleccionat o no. Per exemple, un medicament configurat per a "dilluns, dimecres, divendres" només apareix a la llista quan es visualitzen aquells dies de la setmana.

### Beneficis de la Navegació Temporal

Aquesta funcionalitat és especialment valuosa per verificar si es va prendre un medicament en un dia passat, planificar quins medicaments portar en un viatge basant-se en les dates, revisar patrons d'adherència setmanals o mensuals, i coordinar medicacions de múltiples persones en una llar durant períodes específics.

---

## 9. Notificacions Intel·ligents

### Accions Directes des de Notificació

MedicApp revoluciona la gestió de medicaments mitjançant notificacions amb accions integrades que permeten gestionar les dosis sense obrir l'aplicació. Quan arriba l'hora d'una dosi, la notificació mostra tres botons d'acció directa:

**Prendre** - Registra la dosi immediatament, descompta de l'estoc, crea entrada a l'historial, cancel·la la notificació, i si escau, inicia el període de dejuni posterior amb compte enrere.

**Posposar** - Ajorna la notificació per 10, 30 o 60 minuts segons l'opció seleccionada. La notificació reapareix automàticament en el temps especificat.

**Saltar** - Registra la dosi com a omesa, crea entrada a l'historial amb estat "saltada" sense descomptar estoc, i cancel·la la notificació sense programar recordatoris addicionals.

Aquestes accions funcionen fins i tot quan el telèfon està bloquejat, fent que el registre de medicació sigui instantani i sense fricció. L'usuari pot gestionar la seva medicació completa des de les notificacions sense necessitat de desbloquejar el dispositiu o obrir l'app.

### Cancel·lació Intel·ligent

El sistema de notificacions implementa lògica avançada de cancel·lació per evitar alertes redundants o incorrectes. Quan un usuari registra una dosi manualment des de l'app (sense usar la notificació), el sistema cancel·la automàticament la notificació pendent d'aquella dosi específica per a aquell dia.

Si un medicament s'elimina o se suspèn, totes les seves notificacions futures es cancel·len immediatament en segon pla. Quan es modifica l'horari d'un medicament, les notificacions antigues es cancel·len i es reprogramen automàticament amb els nous horaris. Aquesta gestió intel·ligent assegura que l'usuari només rebi notificacions rellevants i actuals.

### Notificacions Persistents per a Dejuni

Per a medicaments que requereixen dejuni, MedicApp mostra una notificació persistent especial durant tot el període de dejuni. Aquesta notificació no pot ser rebutjada manualment i mostra un compte enrere en temps real del temps restant fins que es pugui menjar. Inclou l'hora exacta en què finalitzarà el dejuni, la qual cosa permet a l'usuari planificar els seus àpats.

La notificació de dejuni té prioritat alta però no emet so contínuament, evitant interrupcions molestes mentre manté visible la informació crítica. Quan finalitza el període de dejuni, la notificació es cancel·la automàticament i s'emet una alerta sonora breu per notificar a l'usuari que ja pot menjar.

### Configuració Personalitzada per Medicament

Cada medicament pot tenir la seva configuració de notificacions ajustada individualment. Els usuaris poden habilitar o deshabilitar notificacions completament per a medicaments específics, mantenint-los al sistema per a seguiment però sense alertes automàtiques. Aquesta flexibilitat és útil per a medicaments que l'usuari pren per rutina i no necessita recordatoris.

A més, la configuració de dejuni permet decidir si es volen notificacions d'inici de dejuni (per a medicaments amb dejuni previ) o simplement usar la funció sense alertes. MedicApp respecta aquestes preferències individuals mentre manté la consistència en el registre i seguiment de totes les dosis.

### Compatibilitat amb Android 12+

MedicApp està optimitzat per a Android 12 i versions superiors, requerint i gestionant els permisos de "Alarmes i recordatoris" necessaris per a notificacions exactes. L'aplicació detecta automàticament si aquests permisos no estan concedits i guia l'usuari per habilitar-los des de la configuració del sistema, assegurant que les notificacions arribin puntualment a l'hora programada.

### Configuració del To de Notificació (Android 8.0+)

En dispositius amb Android 8.0 (API 26) o superior, MedicApp ofereix accés directe a la configuració del to de notificació des dels ajustos de l'aplicació. Aquesta funcionalitat permet personalitzar el so, vibració i altres paràmetres de les notificacions utilitzant els canals de notificació del sistema.

L'opció "To de notificació" només apareix a la pantalla d'Ajustos quan el dispositiu compleix els requisits mínims de versió del sistema operatiu. En versions anteriors a Android 8.0, aquesta opció s'oculta automàticament ja que el sistema no suporta la configuració granular de canals de notificació.

---

## 10. Alertes d'Estoc Baix

### Notificacions Reactives d'Estoc Insuficient

MedicApp implementa un sistema intel·ligent d'alertes d'estoc que protegeix l'usuari de quedar-se sense medicació en moments crítics. Quan un usuari intenta registrar una dosi (ja sigui des de la pantalla principal o des de les accions ràpides de notificació), el sistema verifica automàticament si hi ha estoc suficient per completar la presa.

Si l'estoc disponible és menor que la quantitat requerida per a la dosi, MedicApp mostra immediatament una alerta d'estoc insuficient que impedeix el registre de la presa. Aquesta notificació reactiva indica clarament el nom del medicament afectat, la quantitat necessària versus la disponible, i suggereix reposar l'inventari abans d'intentar registrar la dosi novament.

Aquest mecanisme de protecció prevé registres incorrectes a l'historial i garanteix la integritat del control d'inventari, evitant que es descompti estoc que físicament no existeix. L'alerta és clara, no intrusiva, i guia l'usuari directament cap a l'acció correctiva (reposar estoc).

### Notificacions Proactives d'Estoc Baix

A més de les alertes reactives en el moment de prendre una dosi, MedicApp inclou un sistema proactiu de monitoratge diari d'estoc que anticipa problemes de desabastiment abans que ocorrin. Aquest sistema avalua automàticament l'inventari de tots els medicaments una vegada al dia, calculant els dies de subministrament restants segons el consum programat.

El càlcul considera múltiples factors per estimar amb precisió quant durarà l'estoc actual:

**Per a medicaments programats** - El sistema suma la dosi diària total de totes les persones assignades, multiplica pels dies configurats en el patró de freqüència (per exemple, si es pren només dilluns, dimecres i divendres, ajusta el càlcul), i divideix l'estoc actual entre aquest consum diari efectiu.

**Per a medicaments ocasionals ("segons necessitat")** - Utilitza el registre de l'últim dia de consum real com a predictor, proporcionant una estimació adaptativa que millora amb l'ús.

Quan l'estoc d'un medicament arriba al llindar configurat (per defecte 3 dies, però personalitzable entre 1-10 dies per medicament), MedicApp emet una notificació proactiva d'advertència. Aquesta notificació mostra:

- Nom del medicament i tipus
- Dies aproximats de subministrament restants
- Persona(es) afectada(es)
- Estoc actual en unitats corresponents
- Suggeriment de reposició

### Prevenció d'Spam de Notificacions

Per evitar bombardejar l'usuari amb alertes repetitives, el sistema de notificacions proactives implementa lògica intel·ligent de freqüència. Cada tipus d'alerta d'estoc baix s'emet màxim una vegada al dia per medicament. El sistema registra l'última data en què es va enviar cada alerta i no torna a notificar fins que:

1. Hagi passat almenys 24 hores des de l'última alerta, O
2. L'usuari hagi reposat l'estoc (restablint el comptador)

Aquesta prevenció d'spam assegura que les notificacions siguin útils i oportunes sense convertir-se en una molèstia que porti l'usuari a ignorar-les o deshabilitar-les.

### Integració amb Control d'Estoc Visual

Les alertes d'estoc baix no funcionen de forma aïllada, sinó que estan profundament integrades amb el sistema de semàfors visuals del pastiller. Quan un medicament té estoc baix:

- Apareix marcat en vermell o ambre a la llista del pastiller
- Mostra una icona d'advertència a la pantalla principal
- La notificació proactiva complementa aquests senyals visuals

Aquesta multicapa d'informació (visual + notificacions) garanteix que l'usuari sigui conscient de l'estat de l'inventari des de múltiples punts de contacte amb l'aplicació.

### Configuració i Personalització

Cada medicament pot tenir un llindar d'alerta personalitzat que determina quan es considera l'estoc "baix". Medicaments crítics com insulina o anticoagulants poden configurar-se amb llindars de 7-10 dies per permetre temps ampli de reposició, mentre que suplements menys urgents poden usar llindars d'1-2 dies.

El sistema respecta aquestes configuracions individuals, permetent que cada medicament tingui la seva pròpia política d'alertes adaptada a la seva criticitat i disponibilitat a farmàcies.

---

## 11. Configuració de Dejuni

### Tipus: Before (Abans) i After (Després)

MedicApp suporta dues modalitats de dejuni clarament diferenciades per adaptar-se a diferents prescripcions mèdiques:

**Dejuni Before (Abans)** - Es configura quan el medicament s'ha de prendre amb l'estómac buit. L'usuari ha d'haver dejunat durant el període especificat ABANS de prendre el medicament. Per exemple, "30 minuts de dejuni abans" significa no haver menjat res durant els 30 minuts previs a la presa. Aquest tipus és comú en medicaments que requereixen absorció òptima sense interferència alimentària.

**Dejuni After (Després)** - Es configura quan després de prendre el medicament s'ha d'esperar sense menjar. Per exemple, "60 minuts de dejuni després" significa que després de prendre el medicament, no es pot ingerir aliments durant 60 minuts. Aquest tipus és típic en medicaments que poden causar molèsties gàstriques o la efectivitat dels quals es redueix amb menjar.

La durada del dejuni és completament configurable en minuts, permetent ajustar-se a prescripcions específiques que poden variar des de 15 minuts fins a diverses hores.

### Compte Enrere Visual en Temps Real

Quan un medicament amb dejuni "després" ha estat pres, MedicApp mostra un compte enrere visual prominent a la pantalla principal. Aquest comptador s'actualitza en temps real cada segon, mostrant el temps restant en format MM:SS (minuts:segons). Al costat del compte enrere, s'indica l'hora exacta en què finalitzarà el període de dejuni, permetent planificació immediata.

El component visual del compte enrere és impossible d'ignorar: utilitza colors cridaners, es posiciona destacadament a la pantalla, inclou el nom del medicament associat, i mostra una icona de restricció alimentària. Aquesta visibilitat constant assegura que l'usuari no oblidi la restricció alimentària activa.

### Notificació Fixa Durant el Dejuni

Complementant el compte enrere visual a l'app, MedicApp mostra una notificació persistent del sistema durant tot el període de dejuni. Aquesta notificació és "ongoing" (en curs), la qual cosa significa que no pot ser rebutjada per l'usuari i roman fixa a la barra de notificacions amb màxima prioritat.

La notificació de dejuni mostra la mateixa informació que el compte enrere a l'app: nom del medicament, temps restant de dejuni, i hora estimada de finalització. S'actualitza periòdicament per reflectir el temps restant, encara que no en temps real constant per preservar bateria. Aquesta doble capa de recordatori (visual a l'app + notificació persistent) pràcticament elimina el risc de trencar accidentalment el dejuni.

### Cancel·lació Automàtica

El sistema gestiona automàticament el cicle de vida del dejuni sense intervenció manual. Quan el temps de dejuni es completa, diverses accions ocorren simultàniament i de forma automàtica:

1. El compte enrere visual desapareix de la pantalla principal
2. La notificació persistent es cancel·la automàticament
3. S'emet una notificació breu amb so indicant "Dejuni completat, ja pots menjar"
4. L'estat del medicament s'actualitza per reflectir que el dejuni ha finalitzat

Aquesta automatització assegura que l'usuari estigui sempre informat de l'estat actual sense necessitat de recordar manualment quan ha finalitzat el dejuni. Si l'app està en segon pla quan finalitza el dejuni, la notificació de finalització alerta a l'usuari immediatament.

### Configuració per Medicament

No tots els medicaments requereixen dejuni, i entre els que sí ho requereixen, les necessitats varien. MedicApp permet configurar individualment per a cada medicament: si requereix dejuni o no (sí/no), el tipus de dejuni (abans/després), la durada exacta en minuts, i si es volen notificacions d'inici de dejuni (per al tipus "abans").

Aquesta granularitat permet gestionar règims complexos on alguns medicaments es prenen en dejunes, altres requereixen espera post-ingesta, i altres no tenen restriccions, tot dins d'una interfície coherent que maneja automàticament cada cas segons la seva configuració específica.

---

## 12. Historial de Dosis

### Registre Automàtic Complet

MedicApp manté un registre detallat i automàtic de cada acció relacionada amb medicaments. Cada vegada que es registra una dosi (presa o omesa), el sistema crea immediatament una entrada a l'historial que captura informació exhaustiva de l'esdeveniment.

Les dades registrades inclouen: identificador únic de l'entrada, ID del medicament i el seu nom actual, tipus de medicament amb la seva icona i color, ID i nom de la persona que va prendre/ometre la dosi, data i hora programada originalment per a la dosi, data i hora real en què es va registrar l'acció, estat de la dosi (presa o omesa), quantitat exacta administrada en les unitats corresponents, i si va ser una dosi extra no programada.

Aquest registre automàtic funciona independentment de com es va registrar la dosi: des de l'app, des de les accions de notificació, o mitjançant registre manual. No requereix intervenció de l'usuari més enllà de l'acció de registre bàsica, garantint que l'historial estigui sempre complet i actualitzat.

### Estadístiques d'Adherència Terapèutica

A partir de l'historial de dosis, MedicApp calcula automàticament estadístiques d'adherència que proporcionen informació valuosa sobre el compliment del tractament. Les mètriques inclouen:

**Taxa d'Adherència Global** - Percentatge de dosis preses sobre el total de dosis programades, calculat com (dosis preses / (dosis preses + dosis omeses)) × 100.

**Total de Dosis Registrades** - Compte total d'esdeveniments a l'historial dins del període analitzat.

**Dosis Preses** - Nombre absolut de dosis registrades com a preses exitosament.

**Dosis Omeses** - Nombre de dosis que van ser saltades o no preses segons el programat.

Aquestes estadístiques es calculen dinàmicament basant-se en els filtres aplicats, permetent anàlisi per períodes específics, medicaments individuals o persones concretes. Són especialment útils per identificar patrons d'incompliment, avaluar l'efectivitat del règim d'horaris actual, i proporcionar informació objectiva en consultes mèdiques.

### Filtres Avançats Multidimensionals

La pantalla d'historial inclou un sistema de filtrat potent que permet analitzar les dades des de múltiples perspectives:

**Filtre per Persona** - Mostra només les dosis d'una persona específica, ideal per a seguiment individual en entorns multi-persona. Inclou opció "Totes les persones" per a vista global.

**Filtre per Medicament** - Permet enfocar-se en un medicament particular, útil per avaluar l'adherència de tractaments específics. Inclou opció "Tots els medicaments" per a vista completa.

**Filtre per Rang de Dates** - Defineix un període temporal específic amb data d'inici i data de fi. Útil per generar informes d'adherència mensual, trimestral o per a períodes personalitzats que coincideixin amb consultes mèdiques.

Els filtres són acumulatius i es poden combinar. Per exemple, es poden veure "totes les dosis d'Ibuprofèn preses per Maria al mes de gener", proporcionant anàlisi molt granulars. Els filtres actius es mostren visualment en chips informatius que poden eliminar-se individualment.

### Exportació de Dades

Tot i que la interfície actual no implementa exportació directa, l'historial de dosis s'emmagatzema a la base de dades SQLite de l'aplicació, que pot ser exportada completa mitjançant la funcionalitat de backup del sistema. Aquesta base de dades conté totes les entrades d'historial en format estructurat que pot ser processat posteriorment amb eines externes per generar informes personalitzats, gràfics d'adherència, o integració amb sistemes de gestió mèdica.

El format de les dades és relacional i normalitzat, amb claus foranes que vinculen medicaments, persones i entrades d'historial, facilitant anàlisi complexes i extracció d'informació per a presentacions mèdiques o auditories de tractament.

---

## 13. Localització i Internacionalització

### 8 Idiomes Completament Suportats

MedicApp està traduïda de forma professional i completa a 8 idiomes, cobrint la majoria de llengües parlades a la península ibèrica i ampliant el seu abast a Europa:

**Español (es)** - Idioma principal, traducció nativa amb tota la terminologia mèdica precisa.

**English (en)** - Anglès internacional, adaptat per a usuaris angloparlants globals.

**Deutsch (de)** - Alemany estàndard, amb terminologia mèdica europea.

**Français (fr)** - Francès europeu amb vocabulari farmacèutic apropiat.

**Italiano (it)** - Italià estàndard amb termes mèdics localitzats.

**Català (ca)** - Català amb termes mèdics específics del sistema sanitari català.

**Euskara (eu)** - Basc amb terminologia sanitària apropiada.

**Galego (gl)** - Gallec amb vocabulari mèdic regionalitzat.

Cada traducció no és una simple conversió automàtica, sinó una localització cultural que respecta les convencions mèdiques, formats de data/hora, i expressions idiomàtiques de cada regió. Els noms de medicaments, tipus farmacèutics i termes tècnics estan adaptats al vocabulari mèdic local de cada idioma.

### Canvi Dinàmic d'Idioma

MedicApp permet canviar l'idioma de la interfície en qualsevol moment des de la pantalla de configuració. En seleccionar un nou idioma, l'aplicació s'actualitza instantàniament sense necessitat de reiniciar. Tots els textos de la interfície, missatges de notificació, etiquetes de botons, descripcions d'ajuda i missatges d'error s'actualitzen immediatament a l'idioma seleccionat.

El canvi d'idioma és fluid i no afecta les dades emmagatzemades. Els noms de medicaments introduïts per l'usuari es mantenen tal com van ser ingressats, independentment de l'idioma de la interfície. Només els elements de UI generats pel sistema canvien d'idioma, preservant la informació mèdica personalitzada.

### Separadors Decimals Localitzats

MedicApp respecta les convencions numèriques de cada regió per als separadors decimals. En idiomes com espanyol, francès, alemany i italià, s'utilitza la coma (,) com a separador decimal: "1,5 pastilles", "2,25 ml". En anglès, s'utilitza el punt (.): "1.5 tablets", "2.25 ml".

Aquesta localització numèrica s'aplica automàticament en tots els camps d'entrada de quantitats: dosis de medicament, estoc disponible, quantitats a reposar. Els teclats numèrics es configuren automàticament per mostrar el separador decimal correcte segons l'idioma actiu, evitant confusions i errors d'entrada.

### Formats de Data i Hora Localitzats

Els formats de data i hora també s'adapten a les convencions regionals. Els idiomes europeus continentals utilitzen el format DD/MM/AAAA (dia/mes/any), mentre que l'anglès pot usar MM/DD/AAAA en algunes variants. Els noms de mesos i dies de la setmana apareixen traduïts en els selectors de calendari i a les vistes d'historial.

Les hores es mostren en format de 24 hores en tots els idiomes europeus (13:00, 18:30), que és l'estàndard mèdic internacional i evita ambigüitats AM/PM. Aquesta consistència és crítica en contextos mèdics on la precisió horària és vital per a l'efectivitat del tractament.

### Pluralització Intel·ligent

El sistema de localització inclou lògica de pluralització que adapta els textos segons les quantitats. Per exemple, en català: "1 pastilla" però "2 pastilles", "1 dia" però "3 dies". Cada idioma té les seves pròpies regles de pluralització que el sistema respecta automàticament, incloent casos complexos en català, basc i gallec que tenen regles de plural diferents a l'espanyol.

Aquesta atenció al detall lingüístic fa que MedicApp se senti natural i nativa en cada idioma, millorant significativament l'experiència de l'usuari i reduint la càrrega cognitiva en interactuar amb l'aplicació en contextos mèdics potencialment estressants.

---

## 14. Interfície Accessible i Usable

### Material Design 3

MedicApp està construïda seguint estrictament les directrius de Material Design 3 (Material You) de Google, el sistema de disseny més modern i accessible per a aplicacions Android. Aquesta decisió arquitectònica garanteix múltiples beneficis:

**Consistència Visual** - Tots els elements d'interfície (botons, targetes, diàlegs, camps de text) segueixen patrons visuals estàndard que els usuaris d'Android reconeixen instintivament. No cal aprendre una interfície completament nova.

**Tematització Dinàmica** - Material 3 permet que l'app adopti els colors del sistema de l'usuari (si està en Android 12+), creant una experiència visual cohesiva amb la resta del dispositiu. Els colors d'accent, fons i superfícies s'adapten automàticament.

**Components Accessibles Natius** - Tots els controls de Material 3 estan dissenyats des del principi per ser accessibles, amb àrees de toc generoses (mínim 48x48dp), contrastos adequats, i suport per a lectors de pantalla.

### Tipografia Ampliada i Llegible

L'aplicació utilitza una jerarquia tipogràfica clara amb mides de font generoses que faciliten la lectura sense fatiga visual:

**Títols de Pantalla** - Mida gran (24-28sp) per a orientació clara d'on està l'usuari.

**Noms de Medicaments** - Mida destacada (18-20sp) en negreta per a identificació ràpida.

**Informació Secundària** - Mida mitjana (14-16sp) per a detalls complementaris com horaris i quantitats.

**Text d'Ajuda** - Mida estàndard (14sp) per a instruccions i descripcions.

L'interlíneat és generós (1.5x) per evitar que les línies es confonguin, especialment important per a usuaris amb problemes de visió. Les fonts utilitzades són sense serifa (sans-serif) que han demostrat millor llegibilitat en pantalles digitals.

### Alt Contrast Visual

MedicApp implementa una paleta de colors amb ràtios de contrast que compleixen i superen les directrius WCAG 2.1 AA per a accessibilitat. El contrast mínim entre text i fons és de 4.5:1 per a text normal i 3:1 per a text gran, assegurant llegibilitat fins i tot en condicions d'il·luminació subòptimes.

Els colors s'utilitzen de forma funcional a més d'estètica: vermell per a alertes d'estoc baix o dejuni actiu, verd per a confirmacions i estoc suficient, ambre per a advertències intermèdies, blau per a informació neutra. Però crucialment, el color mai és l'únic indicador: sempre es complementa amb icones, text o patrons.

### Navegació Intuïtiva i Predictible

L'estructura de navegació de MedicApp segueix principis de simplicitat i previsibilitat:

**Pantalla Principal Central** - La vista de medicaments del dia és el hub principal des del qual tot és accessible en màxim 2 tocs.

**Navegació per Pestanyes** - La barra inferior amb 3 pestanyes (Medicaments, Armari, Historial) permet canvi instantani entre les vistes principals sense animacions confuses.

**Botons d'Acció Flotants** - Les accions primàries (afegir medicament, filtrar historial) es realitzen mitjançant botons flotants (FAB) en posició consistent, fàcils d'assolir amb el polze.

**Breadcrumbs i Back Button** - Sempre és clar en quina pantalla està l'usuari i com tornar enrere. El botó de retorn està sempre a la posició superior esquerra estàndard.

### Feedback Visual i Tàctil

Cada interacció produeix feedback immediat: els botons mostren efecte "ripple" en ser premuts, les accions reeixides es confirmen amb snackbars verds que apareixen breument, els errors s'indiquen amb diàlegs vermells explicatius, i els processos llargs (com exportar base de dades) mostren indicadors de progrés animats.

Aquest feedback constant assegura que l'usuari sempre sàpiga que la seva acció va ser registrada i el sistema està responent, reduint l'ansietat típica d'aplicacions mèdiques on un error podria tenir conseqüències importants.

### Disseny per a Ús amb Una Mà

Reconeixent que els usuaris freqüentment manegen medicaments amb una mà (mentre sostenen l'envàs amb l'altra), MedicApp optimitza l'ergonomia per a ús amb una mà:

- Elements interactius principals a la meitat inferior de la pantalla
- Botons d'acció flotant a cantonada inferior dreta, assolible amb el polze
- Evitació de menús a cantonades superiors que requereixen reajustar l'agafada
- Gestos de lliscar horitzontal (més còmodes que verticals) per a navegació temporal

Aquesta consideració ergonòmica redueix la fatiga física i fa que l'app sigui més còmoda d'usar en situacions reals de medicació, que sovint ocorren dempeus o en moviment.

---

## 18. Widget de Pantalla d'Inici (Android)

### Vista Ràpida de Dosis Diàries

MedicApp inclou un widget natiu d'Android per a la pantalla d'inici que permet visualitzar les dosis programades del dia actual sense obrir l'aplicació. Aquest widget proporciona informació essencial d'un cop d'ull, ideal per a usuaris que necessiten un recordatori visual constant de la seva medicació. Tocar qualsevol part del widget (capçalera, elements de la llista o espai buit) obre l'aplicació principal per a una gestió completa.

### Característiques del Widget

**Mida 2x2**: El widget ocupa un espai de 2x2 cel·les a la pantalla d'inici (aproximadament 146x146dp), prou compacte per no ocupar massa espai però amb informació clarament llegible.

**Llista de Dosis del Dia**: Mostra només les dosis programades per al dia actual, aplicant filtres intel·ligents:
- **Filtrat per durationType**: Només mostra medicaments programats per al dia actual segons el seu patró de freqüència (tots els dies, dies específics de la setmana, cada N dies, etc.)
- **Exclusió d'occasionals**: Els medicaments configurats com a "segons necessitat" (asNeeded) no apareixen al widget, ja que no tenen horaris programats
- Nom del medicament
- Hora programada de cada dosi
- Estat visual amb tres indicadors diferents

**Indicadors d'Estat Visual**:
- **Cercle verd ple amb marca de verificació (✓)**: Dosi ja presa - el text es mostra amb 70% d'opacitat per indicar que està completada
- **Cercle verd buit (○)**: Dosi pendent - el text es mostra al 100% d'opacitat per destacar que requereix atenció
- **Cercle gris de punts (◌)**: Dosi omesa - el text es mostra amb 50% d'opacitat per indicar que ja no es prendrà

**Comptador de Progrés**: A la capçalera del widget es mostra un comptador "X/Y" indicant quantes dosis s'han pres del total programat per al dia, proporcionant feedback immediat del compliment diari.

### Integració amb l'Aplicació

**Interacció Completa**: Tocar qualsevol part del widget obre MedicApp directament a la pantalla principal. Això permet a l'usuari passar ràpidament d'un cop d'ull al widget a la gestió completa dins de l'aplicació per registrar dosis, consultar detalls o fer canvis.

**Actualització Automàtica**: El widget s'actualitza automàticament cada vegada que:
- Es registra una dosi (presa, omesa o extra)
- S'afegeix o es modifica un medicament
- Canvia el dia (a mitjanit)
- Es modifica la persona predeterminada

**Comunicació Flutter-Android**: La integració utilitza un MethodChannel (`com.medicapp.medicapp/widget`) que permet a l'aplicació Flutter notificar al widget natiu quan les dades canvien.

**Lectura Directa de Base de Dades**: El widget accedeix directament a la base de dades SQLite de l'aplicació per obtenir les dades de medicaments, assegurant informació actualitzada fins i tot quan l'app no està en execució. Aplica els mateixos filtres que la pantalla principal per garantir coherència entre ambdues vistes.

### Tema Visual DeepEmerald

El widget utilitza la paleta de colors DeepEmerald, el tema per defecte de MedicApp:

- **Fons**: Verd fosc profund (#1E2623) amb 90% d'opacitat
- **Icones i accents**: Verd clar (#81C784)
- **Text**: Blanc amb diferents nivells d'opacitat segons l'estat (100% pendent, 70% presa, 50% omesa)
- **Divisors**: Verd clar amb transparència
- **Indicadors d'estat**: Cercles amb colors i estils diferenciats per a cada estat

### Limitacions Tècniques

**Només Android**: El widget és una funcionalitat nativa d'Android i no està disponible a iOS, web o altres plataformes.

**Persona per defecte**: El widget mostra les dosis de la persona configurada com a predeterminada a l'aplicació.

**Vista de només lectura**: Les dosis no es poden registrar directament des del widget. L'usuari ha de tocar el widget per obrir l'aplicació i realitzar accions.

### Arxius Relacionats

- `android/app/src/main/kotlin/.../MedicationWidgetProvider.kt` - Proveïdor principal del widget
- `android/app/src/main/kotlin/.../MedicationWidgetService.kt` - Servei per a la ListView del widget
- `android/app/src/main/res/layout/medication_widget_layout.xml` - Layout principal
- `lib/services/widget_service.dart` - Servei Flutter per a comunicació amb el widget

---

## 19. Optimització per a Tauletes

### Disseny Responsiu Adaptatiu

MedicApp està optimitzada per funcionar perfectament en tauletes i pantalles grans, adaptant automàticament la seva interfície segons la mida del dispositiu.

### Sistema de Punts de Ruptura

L'aplicació utilitza un sistema de breakpoints basat en les directrius de Material Design:

- **Telèfon**: < 600dp - Disseny d'una columna, navegació inferior
- **Tauleta**: 600-840dp - Disseny adaptatiu, NavigationRail lateral
- **Escriptori**: > 840dp - Disseny optimitzat amb contingut centrat

### Característiques Responsives

**Navegació Adaptativa**: En tauletes i mode horitzontal, l'aplicació mostra una NavigationRail lateral en lloc de la barra de navegació inferior.

**Contingut Centrat**: En pantalles grans, les llistes de medicaments, l'historial i la configuració es centren amb una amplada màxima de 700-900px per millorar la llegibilitat.

**Graelles Adaptatives**: El farmaciola i l'historial de dosis utilitzen layouts de graella que mostren 2-3 columnes en tauletes.

**Diàlegs Optimitzats**: Els diàlegs i formularis tenen una amplada màxima de 400-500px en tauletes.

### Fitxers Relacionats

- `lib/utils/responsive_helper.dart` - Utilitats de disseny responsiu
- `lib/widgets/responsive/adaptive_grid.dart` - Widgets adaptatius

---

## Integració de Funcionalitats

Totes aquestes característiques no funcionen de forma aïllada, sinó que estan profundament integrades per crear una experiència cohesiva. Per exemple:

- Un medicament afegit al flux de 8 passos s'assigna automàticament a persones, genera notificacions segons el seu tipus de freqüència, apareix a l'armari ordenat alfabèticament, registra les seves dosis a l'historial, i actualitza estadístiques d'adherència.

- Les notificacions respecten la configuració de dejuni, actualitzant automàticament el compte enrere visual quan es registra una dosi amb dejuni posterior.

- El control d'estoc multi-persona calcula correctament els dies restants considerant les dosis de totes les persones assignades, i alerta quan es arriba al llindar independentment de qui prengui el medicament.

- El canvi d'idioma actualitza instantàniament totes les notificacions pendents, les pantalles visibles, i els missatges del sistema, mantenint consistència total.

Aquesta integració profunda és el que converteix MedicApp d'una simple llista de medicaments en un sistema complet de gestió terapèutica familiar.

---

## Referències a Documentació Addicional

Per a informació més detallada sobre aspectes específics:

- **Arquitectura Multi-Persona**: Veure documentació de base de dades (taules `persons`, `medications`, `person_medications`)
- **Sistema de Notificacions**: Veure codi font a `lib/services/notification_service.dart`
- **Model de Dades**: Veure models a `lib/models/` (especialment `medication.dart`, `person.dart`, `person_medication.dart`)
- **Localització**: Veure arxius `.arb` a `lib/l10n/` per a cada idioma
- **Tests**: Veure suite de tests a `test/` amb 432+ tests que validen totes aquestes funcionalitats

---

## 15. Sistema de Memòria Cau Intel·ligent

### Optimització de Rendiment amb SmartCacheService

MedicApp implementa un sistema avançat de memòria cau (cache) que millora dramàticament el rendiment de l'aplicació reduint accessos repetitius a la base de dades. Aquest sistema és transparent per a l'usuari però proporciona beneficis significatius en velocitat i fluïdesa.

El sistema es basa en `SmartCacheService`, un servei genèric de memòria cau que pot emmagatzemar qualsevol tipus de dades amb expiració automàtica (TTL - Time To Live) i evicció intel·ligent quan s'assoleix el límit de capacitat. Utilitza l'algorisme LRU (Least Recently Used) per eliminar automàticament les entrades menys accedides quan la memòria cau s'omple.

### Arquitectura de Múltiples Memòries Cau

MedicApp no utilitza una sola memòria cau global, sinó quatre memòries cau especialitzades gestionades per `MedicationCacheService`, cadascuna optimitzada per a un tipus específic de dada amb configuracions diferents de TTL i capacitat:

**Memòria Cau de Medicacions** - Emmagatzema medicaments individuals accessits freqüentment. TTL de 10 minuts i capacitat per a 50 entrades. Ideal per a medicaments que l'usuari consulta repetidament des de diferents pantalles.

**Memòria Cau de Llistes** - Emmagatzema llistes de medicaments filtrades per persona o criteri. TTL de 5 minuts i capacitat per a 20 entrades. Optimitza la càrrega de la pantalla principal i vistes filtrades.

**Memòria Cau d'Historial** - Emmagatzema resultats de consultes a l'historial de dosis. TTL de 3 minuts i capacitat per a 30 entrades. Accelera la visualització de l'historial amb filtres aplicats.

**Memòria Cau d'Estadístiques** - Emmagatzema resultats de càlculs estadístics complexos d'adherència. TTL de 30 minuts i capacitat per a 10 entrades. Aquests càlculs són els més pesats computacionalment, per la qual cosa es memòritzen per més temps.

### Patró Cache-Aside amb getOrCompute()

El sistema implementa el patró cache-aside mitjançant el mètode `getOrCompute()` que simplifica enormement l'ús de la memòria cau:

```dart
final medications = await medicationsCache.getOrCompute(
  'person_$personId',
  () => database.getMedicationsForPerson(personId),
);
```

Aquest mètode primer verifica si les dades existeixen a la memòria cau i són vàlides (no caducades). Si existeixen, les retorna immediatament sense accedir a la base de dades (cache hit). Si no existeixen o han caducat, executa la funció de còmput proporcionada, emmagatzema el resultat a la memòria cau, i el retorna (cache miss). Aquesta simplificació evita duplicació de codi i assegura ús consistent de la memòria cau.

### Invalidació Intel·ligent

La memòria cau no seria útil si mostrés dades obsoletes. MedicApp implementa invalidació selectiva que neteja entrades específiques quan les dades subjacents canvien:

Quan es modifica un medicament, s'invalida la seva entrada individual i totes les llistes que el podrien contenir. Quan es registra una dosi, s'invalida l'historial i estadístiques afectats. Quan es canvia de persona activa, s'invaliden les llistes de la persona anterior i es precarreguen les de la nova persona.

A més de la invalidació manual, el sistema implementa auto-neteja automàtica mitjançant un timer que cada minut elimina totes les entrades caducades, alliberant memòria sense necessitat d'intervenció manual.

### Estadístiques i Monitoratge

Cada memòria cau manté estadístiques en temps real accessibles per a debug i optimització:

- **Hits**: Nombre de vegades que es va trobar una dada a la memòria cau
- **Misses**: Nombre de vegades que no es va trobar i va caldre computar
- **Hit Rate**: Percentatge de hits sobre el total de consultes (hits / (hits + misses))
- **Evictions**: Nombre d'entrades eliminades per límit de capacitat (LRU)
- **Size**: Nombre actual d'entrades emmagatzemades

Aquestes mètriques permeten afinar les configuracions de TTL i capacitat per a cada tipus de memòria cau segons els patrons d'ús reals de l'aplicació.

### Impacte en el Rendiment

Els tests interns mostren que el sistema de memòria cau redueix els accessos a la base de dades en un 60-80% per a operacions freqüents. Això es tradueix en:

- Càrrega instantània de la pantalla principal en navegació repetida
- Resposta immediata al canviar de persona sense esperes
- Estadístiques complexes calculades només una vegada cada 30 minuts
- Reducció de consum de bateria per menys operacions d'I/O

El sistema és especialment efectiu en escenaris multi-persona on els usuaris canvien freqüentment entre perfils, ja que les dades de la persona anterior romanen a la memòria cau i es carreguen instantàniament en tornar a ella.

---

## 16. Recordatoris Intel·ligents

### Anàlisi Predictiva d'Adherència Terapèutica

MedicApp va més enllà del simple seguiment de dosis preses i omeses implementant un sistema avançat d'anàlisi predictiva que aprèn dels patrons de comportament de l'usuari i proporciona insights accionables per millorar l'adherència terapèutica.

Aquest sistema, implementat a `IntelligentRemindersService`, analitza l'historial de dosis per detectar patrons temporals, predir omissions futures, i suggerir canvis d'horari que s'ajustin millor als hàbits reals de l'usuari. És com tenir un assistent personal que entén com et prens els medicaments i t'ajuda a optimitzar les teves pautes.

### Anàlisi d'Adherència Multidimensional

La funcionalitat central és `analyzeAdherence()`, que realitza una anàlisi exhaustiva de l'adherència terapèutica d'un medicament específic per a una persona concreta durant un període configurable (per defecte, últims 30 dies).

**Anàlisi per Dia de la Setmana** - El sistema calcula la taxa d'adherència per a cada dia de la setmana (dilluns a diumenge), identificant els dies amb millor i pitjor compliment. Per exemple, pot descobrir que els dissabtes tenen només 45% d'adherència mentre que els dilluns assoleixen el 95%, indicant que els caps de setmana són problemàtics.

**Anàlisi per Hora del Dia** - S'examinen els horaris de presa per identificar en quines hores l'usuari és més i menys consistent. Això revela patrons com "les dosis de 8:00 del matí tenen 92% d'adherència, però les de 22:00 de la nit només 58%", suggerint que l'horari nocturn és poc realista.

**Detecció de Dies Problemàtics** - El sistema identifica dies específics amb adherència inferior al 50%, marcant-los com a problemàtics. Aquests dies podrien coincidir amb esdeveniments especials, viatges o altres factors disruptius que afecten el compliment.

**Càlcul de Tendència** - Compara l'adherència de la primera meitat del període analitzat amb la segona meitat per determinar si la tendència és ascendent (millorant), estable o descendent (declinant). Una tendència descendent pot indicar fatiga del tractament o necessitat d'ajustos.

**Recomanacions Personalitzades** - Basant-se en tots aquests patrons, el sistema genera recomanacions específiques i accionables. Per exemple: "Considera moure la dosi de 22:00 a 20:00, on tens millor adherència històrica", o "Els caps de setmana necessiten recordatoris addicionals o canvis d'horari".

### Predicció de Probabilitat d'Omissió

La funcionalitat `predictSkipProbability()` utilitza anàlisi predictiva per estimar la probabilitat que una dosi específica sigui omesa basant-se en patrons històrics. Aquesta predicció considera:

**Context Temporal** - Dia de la setmana específic i hora exacta de la dosi. El sistema reconeix que el mateix medicament a diferents hores o dies té probabilitats d'omissió molt diferents.

**Patrons Històrics** - Examina l'historial per calcular quantes vegades s'ha omès una dosi en condicions similars (mateix dia i hora) versus quantes vegades es va prendre correctament.

**Classificació de Risc** - La probabilitat numèrica (0.0-1.0) es tradueix a una classificació de risc: baix (<30% probabilitat), mitjà (30-60%), o alt (>60%). Això facilita la comprensió intuïtiva sense necessitat d'interpretar percentatges.

**Factors Contribuents** - El sistema llista els factors que contribueixen a la predicció, com "Els dissabtes tenen 60% més omissions que dies laborables" o "L'horari de 22:00 és consistentment problemàtic amb 65% d'omissions".

Aquesta predicció permet alertes proactives abans que ocorrin les omissions. Per exemple, si el sistema detecta que la dosi de divendres a les 23:00 té risc alt d'omissió, pot enviar un recordatori reforçat o suggerir canviar l'horari permanentment.

### Suggeriments d'Horaris Òptims

La funcionalitat `suggestOptimalTimes()` és potser la més poderosa: analitza tots els horaris actuals d'un medicament, identifica aquells amb baixa adherència (<70%), i suggereix horaris alternatius amb millor historial de compliment.

Per a cada horari problemàtic, el sistema:

1. **Calcula l'adherència actual** a aquell horari específic basant-se en historial
2. **Busca horaris alternatius** dins d'un rang raonable (±3 hores) amb millor adherència històrica
3. **Estima l'adherència esperada** si es canviés a l'horari suggerit
4. **Calcula el potencial de millora** (diferència entre adherència esperada i actual)
5. **Genera una raó explicativa** de per què aquell horari seria millor

Exemple de suggeriment complet:
- **Horari actual**: 22:00 amb 45% d'adherència
- **Horari suggerit**: 20:00 amb 82% d'adherència esperada
- **Millora potencial**: +37%
- **Raó**: "L'adherència a les 20:00 és consistentment alta, mentre que les dosis després de les 21:00 mostren dificultat de compliment"

Aquests suggeriments permeten a l'usuari ajustar proactivament les seves pautes de medicació per alinear-les amb els seus hàbits reals, en lloc de lluitar constantment contra horaris poc realistes prescrits de forma teòrica.

### Casos d'Ús Pràctics

Aquest sistema d'intel·ligència no és només teòric sinó que s'integra a l'aplicació en diversos punts:

**Pantalla d'Estadístiques Millorada** - Mostra anàlisi detallada d'adherència per medicament amb visualització de millors/pitjors dies i horaris, gràfics de tendència temporal, i recomanacions accionables.

**Alertes Proactives** - Quan el sistema detecta patrons problemàtics (com adherència descendent durant 3 setmanes consecutives), pot generar alertes suggerint revisió de la pauta.

**Assistent d'Optimització** - Wizard interactiu que guia l'usuari per revisar horaris problemàtics i aplicar suggeriments amb un sol toc, re-programant automàticament notificacions.

**Informes Mèdics** - Generació d'informes complets amb mètriques d'adherència, patrons detectats, i factors que afecten el compliment, útils per compartir amb metges en consultes.

### Privacitat i Ètica

Tot aquest anàlisi es realitza 100% localment al dispositiu. No s'envien dades a servidors externs, no hi ha tracking, i l'usuari té control total de les seves dades mèdiques. El sistema només fa suggeriments: l'usuari sempre té l'última paraula sobre canvis a la seva medicació.

---

## 17. Tema Fosc Natiu

### Suport Complet per a Mode Fosc

MedicApp implementa un sistema complet de tematització amb suport natiu per a mode clar i fosc, dissenyat seguint les directrius de Material Design 3 (Material You) de Google. Aquesta funcionalitat va més enllà d'una simple inversió de colors: cada element de la interfície està cuidadosament estilitzat per proporcionar llegibilitat òptima, contrast adequat i coherència visual en ambdós modes.

El sistema de temes està basat en `ThemeProvider`, un ChangeNotifier que gestiona l'estat del tema a tota l'aplicació, i `AppTheme`, que defineix els esquemes de color i estils de components per a cada mode.

### Tres Modes de Funcionament

L'usuari pot triar entre tres modes de tema des de la pantalla de configuració:

**Mode Sistema (System)** - L'aplicació segueix automàticament la configuració del tema del sistema operatiu. Si l'usuari canvia el seu telèfon a mode fosc a les 20:00, MedicApp canviarà automàticament sense necessitat d'intervenció. Aquest és el mode recomanat per a la majoria d'usuaris.

**Mode Clar (Light)** - Força el tema clar independentment de la configuració del sistema. Útil per a usuaris que prefereixen el tema clar sempre, fins i tot quan el seu dispositiu està en mode fosc.

**Mode Fosc (Dark)** - Força el tema fosc en tot moment. Ideal per a usuaris que prefereixen el tema fosc constantment, fins i tot durant el dia quan el sistema suggereix mode clar.

El canvi entre modes és instantani i no requereix reiniciar l'aplicació. Tots els widgets s'actualitzen automàticament gràcies al patró ChangeNotifier de Flutter.

### Paleta de Colors Optimitzada

Cada mode té una paleta de colors cuidadosament dissenyada que no és simplement una inversió de l'altra, sinó una recreació pensada per a màxima llegibilitat i estètica:

**Tema Clar:**
- Fons blanc/gris molt clar per reduir fatiga visual
- Text negre/gris fosc amb contrast mínim 4.5:1 (WCAG AA)
- Colors d'accent blaus brillants per a botons d'acció
- Ombres subtils per a elevació de targetes i diàlegs
- Superfícies amb lleuger tint de color per a jerarquia visual

**Tema Fosc:**
- Fons gris fosc (no negre pur) per reduir bloom en pantalles OLED
- Text blanc/gris clar amb contrast adequat sobre fons fosc
- Colors d'accent ajustats per a llegibilitat en fons fosc
- Elevació representada amb lluminositat (superfícies elevades més clares)
- Estalvi de bateria en pantalles OLED amb predomini de píxels foscos

Ambdós temes respecten les mateixes jerarquies visuals: un botó primari es veu igual de destacat en clar i fosc, només amb paletes diferents.

### Personalització de Tots els Components

`AppTheme` no només defineix colors generals sinó que personalitza cada component de Material Design per garantir coherència:

**AppBarTheme** - Barres superiors amb colors de fons i text apropiats, elevació consistent, i icones amb contrast òptim.

**CardTheme** - Targetes amb elevació subtil, vores arrodonides, colors de fons que destaquen del fons general, i marge interior generós.

**FloatingActionButtonTheme** - Botons d'acció flotant amb colors d'accent destacats, ombres pronunciades per indicar interactivitat, i mides generoses per a accessibilitat tàctil.

**InputDecorationTheme** - Camps de text amb vores definides, etiquetes flotants, colors d'accent en focus, i missatges d'error visibles.

**DialogTheme** - Diàlegs amb fons adequats al tema, cantonades arrodonides, elevació destacada, i botons d'acció clarament visibles.

**SnackBarTheme** - Notificacions temporals amb fons contrastant, text llegible, i posicionament consistent.

**TextTheme** - Jerarquia tipogràfica completa amb mides, pesos i colors per a títols (displayLarge, displayMedium), encapçalaments (headlineLarge, headlineMedium), cos de text (bodyLarge, bodyMedium), i etiquetes (labelLarge).

Cada component està pensat per funcionar harmònicament amb els altres, creant una experiència visual cohesiva independentment del tema seleccionat.

### Persistència de Preferència

La preferència de tema de l'usuari es desa automàticament mitjançant `PreferencesService` utilitzant SharedPreferences. Quan l'usuari canvia el tema des de configuració, el canvi es persista immediatament i es restaura automàticament la propera vegada que obri l'aplicació.

Això significa que l'usuari només ha de configurar el seu tema preferit una vegada, i MedicApp ho recordarà per sempre fins que decideixi canviar-lo novament.

### Beneficis per a l'Usuari

**Reducció de Fatiga Visual** - El mode fosc redueix l'emissió de llum blava i és més còmode per a ús nocturn o en ambients amb poca llum. El mode clar proporciona millor llegibilitat en ambients molt il·luminats.

**Estalvi de Bateria** - En dispositius amb pantalles OLED o AMOLED (la majoria de smartphones moderns), el mode fosc pot estendre la vida de la bateria fins a un 30% perquè els píxels negres estan apagats completament.

**Accessibilitat Millorada** - Usuaris amb sensibilitat a la llum, migranes desencadenades per pantalles brillants, o problemes de visió nocturna es beneficien enormement del mode fosc. Usuaris amb baixa visió poden preferir el mode clar per major contrast.

**Personalització** - L'usuari té control total de com vol veure l'aplicació, adaptant-la a les seves preferències personals i condicions d'il·luminació ambiental.

**Integració amb el Sistema** - El mode Sistema permet que MedicApp s'integri perfectament amb la resta del dispositiu, canviant automàticament segons l'hora del dia o la configuració global de l'usuari.

### Implementació Tècnica

Tècnicament, el sistema utilitza el patró Provider de Flutter:

```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: Provider.of<ThemeProvider>(context).themeMode,
  // ...
)
```

Quan l'usuari canvia el tema des de configuració:

```dart
themeProvider.setThemeMode(ThemeMode.dark);
// Automàticament:
// 1. Actualitza estat intern
// 2. Desa a SharedPreferences
// 3. Notifica tots els listeners
// 4. MaterialApp reconstrueix amb nou tema
```

Tot el procés és instantani i no cal reiniciar l'app ni tornar a carregar dades.

---

Aquesta documentació reflecteix l'estat actual de MedicApp en la seva versió 1.0.0, una aplicació madura i completa per a gestió de medicaments familiars amb més del 75% de cobertura de tests i suport complet per a 8 idiomes.
