# MedicApp-en Funtzionalitateak

Dokumentu honek MedicApp-en ezaugarri eta gaitasun guztiak deskribatzen ditu, familien eta zaintzaileen sendagaien kudeaketa aurreratua aplikazio bat.

---

## 1. Pertsona Anitzeko Kudeaketa (V19+)

### Askotariko Arkitektura

MedicApp-ek pertsona anitzeko kudeaketa sofistikatua inplementatzen du, erabiltzaile anitzek sendagaiak partekatzeko aukera emanez, tratamendu konfigurazio indibidualak mantentzen dituzten bitartean. Funtzionalitate hau bereziki diseinatua dago familien, zaintzaile profesionalen eta hainbat pertsonaren sendagaien koordinazioa behar duten taldeen artean.

Arkitektura erlazio modelo askotariko batean oinarritzen da, non sendagaiek (izenaren, motaren eta partekatutako stockaren arabera identifikatuak) pertsona anitzei esleitu ahal zaizkien, eta pertsona bakoitzak sendagaiak asko izan ditzake. Stocka modu zentralizatuan kudeatzen da eta automatikoki kendu sendagaia nork hartzen duen kontuan hartu gabe, partekatutako inbentarioaren kontrol zehatza ahalbidetuz datuak bikoiztu gabe.

Pertsona bakoitzak bere tratamendu pauta propioa konfiguratu dezake sendagaia berarentzat, ordutegi espezifikoak, dosi pertsonalizatuak, tratamenduaren iraupena eta barazkaldiaren lehentasunak barne. Adibidez, ama bat eta bere alabak sendagaia bera partekatzen badute, amak 8:00 eta 20:00etan hartzeak konfiguratuak izan ditzake, alabak berriz 12:00etan bakarrik behar duen dosi bakarra. Biek stock fisiko bera partekatzen dute, baina bakoitzak bere pautaren araberako jakinarazpenak eta jarraipena jasotzen du.

### Erabilera Kasuak

Funtzionalitate hau bereziki erabilgarria da hainbat egoeratarako: sendagaia bera hartzen duten familia kideetan (bitaminak edo suplementuak bezalakoak), paziente anitzen sendagaia kudeatzen duten zaintzaile profesionaletan, sendagaiak ohikoak partekatzen diren belaunaldi anitzeko etxeetan, eta stock partekatuaren kontrola behar den hornidura faltak saihesteko egoeratan. Sistemak pertsonaren araberako dosi historiaren jarraipena xehatua egiteko aukera ematen du, terapia atxikipena eta kontrol mediku indibidualiza erraztuz.

---

## 2. 14 Sendagai Mota

### Forma Farmazeutikoen Katalogo Osoa

MedicApp-ek 14 sendagai mota desberdin onartzen ditu, bakoitza ikonografia bereizgarriarekin, kolore-eskema espezifikoarekin eta neurri unitate egokiekin. Aniztasun honek etxeko edo lanbide botikina batean aurki daitekeen ia edozein forma farmazeutiko erregistratzeko aukera ematen du.

**Mota eskuragarriak:**

1. **Pilula** - Urdin kolorea, ikono biribila. Unitatea: pilulak. Konprimido solido tradizionalentzat.
2. **Kapsula** - More kolorea, kapsula ikonoa. Unitatea: kapsulak. Kapsula jelatinazko forman dauden sendagaientzat.
3. **Injekzioa** - Kolore gorria, txiringa ikonoa. Unitatea: injekzioak. Administrazio parenterala behar duten sendagaientzat.
4. **Xarope** - Laranja kolorea, baso ikonoa. Unitatea: ml (mililtroak). Administrazio oraleko sendagai likidoentzat.
5. **Obuloa** - Kolore arrosa, forma obaloa ikonoa. Unitatea: obuluak. Administrazio baginalekorako sendagaientzat.
6. **Supositorioa** - Urdin-berde kolorea (teal), ikono espezifikoa. Unitatea: supositorioarrak. Administrazio rektalekorako.
7. **Inhaladorea** - Zian kolorea, aire ikonoa. Unitatea: inhalazioak. Arnasketa sendagaientzat.
8. **Gutun-azala** - Marroi kolorea, pakete ikonoa. Unitatea: gutun-azalak. Hautsa edo granularako sendagaientzat.
9. **Spray** - Urdin argia, tantagoite ikonoa. Unitatea: ml (mililtroak). Nebulizadore eta spray nasalentzat.
10. **Pomada** - Berde kolorea, tanta opaku ikonoa. Unitatea: gramoak. Sendagai topiko krematsuentzat.
11. **Lozioa** - Indigo kolorea, ur ikonoa. Unitatea: ml (mililtroak). Sendagai likido topikorent zat.
12. **Apositua** - Anbar kolorea, sendatze ikonoa. Unitatea: aposituak. Parche medikazatuak eta apositu terapeutikoentzat.
13. **Tanta** - Urdin-grisa kolorea, tanta alderantzikatua ikonoa. Unitatea: tantak. Kolirio eta tanta otikoentzat.
14. **Bestea** - Gris kolorea, ikono generikoa. Unitatea: unitateak. Kategorizatu gabeko edozein forma farmazeutikotarako.

### Moten Sistemaren Onurak

Sailkapen xehatua honek sistemari automatikoki stocka zehatza kalkulatzeko aukera ematen dio, neurri unitatearen arabera, identifikazio bisual azkarra errazten duten ikonoak eta koloreak bistaratzeko, eta sendagaien mota espezifikoa aipatzen duten jakinarazpen kontextualizatuak sortzeko. Erabiltzaileek pilulekin tratamendu sinpleetatik inhaladoreak, injekzioak eta tantak barne hartzen dituzten erregimen konplexuetara arte kudeatu ditzakete, interfaz koherente bakarra barruan.

---

## 3. Sendagaiak Gehitzeko Fluxua

### Programatutako Sendagaiak (8 Pauso)

Ordutegi programatua duen sendagai bat gehitzeko prozesua gidatua eta egituratua da beharrezko informazio guztia ondo konfiguratuta dagoela ziurtatzeko:

**1. Pausoa: Oinarrizko Informazioa** - Sendagaiaren izena sartzen da eta 14 aukeren artetik mota hautatzen da. Sistemak izena ez dagoela hutsik balidatzen du.

**2. Pausoa: Tratamenduaren Maiztasuna** - Hartzeko patroia definitzen da sei aukerarekin: egun guztietan, sendagaia amaitu arte, data espezifikoetan, asteko egunetan, N egunero, edo behar den arabera. Konfigurazio honek dosiak noiz hartu behar diren zehazten du.

**3. Pausoa: Dosien Konfigurazioa** - Hartzeko ordutegi espezifikoak ezartzen dira. Erabiltzaileak modu uniformearen (dosi bera ordutegi guztietan) edo ordutegi bakoitzeko dosi pertsonalizatuen artean aukeratu dezake. Adibidez, 8:00etan pilula 1, 14:00etan 0,5 pilula eta 20:00etan 2 pilula konfiguratu daitezke.

**4. Pausoa: Hartzeko Orduak** - Sendagaia hartu behar den ordu zehatzak hautatzen dira denbora hautatzaile bisual bat erabiliz. Egunean ordutegi anitz konfiguratu daitezke preskripzioan jartzen den bezala.

**5. Pausoa: Tratamenduaren Iraupena** - Aplikatzen bada maiztasun motaren arabera, tratamenduaren hasiera eta amaiera datak ezartzen dira. Honek iraupena finkatua duten tratamenduak edo tratamendu jarraituak programatzeko aukera ematen du.

**6. Pausoa: Barazkaldiaren Konfigurazioa** - Sendagaiak hartze aurretik edo ondoren baraurik behar duen definitzen da, baraualdi denboraren iraupena minututan, eta baraualdi oroigarriko jakinarazpenak nahi diren.

**7. Pausoa: Hasierako Stocka** - Eskuragarri dagoen sendagaiaren kantitatea sartzen da hautatutako motari dagozkion unitateetan. Sistemak balio hau erabiliko du inbentario kontrolerako.

**8. Pausoa: Pertsonen Esleipena** - Sendagai hau hartuko duten pertsonak hautatzen dira. Pertsona bakoitzarentzat, ordutegiak eta dosiekin pauta indibiduala konfiguratu daiteke, edo oinarrizko konfigurazioa heredatu.

### Sendagai Okasianalak (2 Pauso)

Erabilera esporadikoa edo "behar den arabera" duten sendagaientzat, prozesua nabarmen sinplifikatzen da:

**1. Pausoa: Oinarrizko Informazioa** - Sendagaiaren izena eta mota.

**2. Pausoa: Hasierako Stocka** - Eskuragarri dagoen kantitatea. Sistemak automatikoki sendagaia "behar den arabera" gisa konfiguratzen du, ordutegi programaturik edo jakinarazpen automatikorik gabe.

### Balidazio Automatikoak

Prozesu osoan zehar, MedicApp-ek derrigorrezko eremu guztiak bete direla balidatzen du hurrengo pausora aurrera egitea onartu aurretik. Egiaztatu ordutegia logikoa dela, dosiak balio numeriko positiboak direla, hasiera datak amaiera dataren ondorengoak ez direla, eta sendagaiari pertsona bat gutxienez esleitu zaiola.

---

## 4. Hartze Erregistroa

### Programatutako Hartzeak

MedicApp-ek automatikoki programatutako hartzeak kudeatzen ditu sendagairen eta pertsonaren konfigrazioaren arabera. Dosiaren ordua iristen denean, erabiltzaileak jakinarazpen bat jasotzen du eta hartzea hiru puntutik erregistratu dezake: pantaila nagusitik non dosi zain dagoena zerrendatuta agertzen den, jakinarazpenetik zuzenean ekintza azkarrren bidez, edo jakinarazpena ukitzean baieztapen pantaila xehakatua irekitzen duen.

Programatutako hartze bat erregistratzean, sistemak automatikoki dagokion kantitatea stock partekatutik kentzen du, dosia pertson espezifiko horrentzat gaur egunean hartu bezala markatzen du, timestamp zehatzekin dosi-historiako sarrera bat sortzen du, eta existitzen bada jakinarazpen zain dagoena ezeztatzen du. Sendagaiak ondorengo baraualdia behar badu, berehalako baraualdiaren amaierako jakinarazpena programatzen da eta pantaila nagusian kontu atzerako bisuala erakusten da.

### Hartze Okasianalak

"Behar den arabera" konfiguratutako sendagaientzat edo ordutegi kanpoko hartze bat erregistratu behar denean, MedicApp-ek eskuzko erregistroa onartzen du. Erabiltzaileak sendagaira botikintik sartzen du, "Dosia hartu" hautatzen du, hartutako kantitatea eskuz sartzen du, eta sistemak stocketik kentzen du eta uneko ordutegian historian erregistratzen du. Funtzionalitate hau ezinbestekoa da analgesikoak, antipiretikoak eta beste erabilera esporadikoko sendagai batzuentzat.

### Hartze Salbuespenak

Sistemak ordutegi finkoari programatu gabeko dosi gehigarriak erregistratzeko aukera ere ematen du. Adibidez, paziente batek bere ohiko hartzeen artean analgesikoko dosi gehigarri bat behar badu, "dosi extra" gisa erregistratu dezake. Dosi hau historian erregistratzen da salbuespena gisa markatuz, stocka kentzen du, baina ez du erregular programatutako dosien jarraipen atxikipenean eragiten.

### Historial Automatikoa

Erregistro ekintza bakoitzak automatikoki sarrera oso bat sortzen du historian honako hau barne: dosaren programatutako data eta ordua, administrazioaren benetako data eta ordua, sendagaia hartu duen pertsona, sendagaiaren izena eta mota, administratutako kantitate zehatza, egoera (hartua edo omititua), eta ea ordutegi kanpoko dosi extra bat zen. Historial honek terapia atxikipenaren analisi xehatua eta txosten medikuak errazteko aukera ematen du.

---

## 5. Stock Kontrola (Pilulariak)

### Ikur Bisual Intuitiboak

MedicApp-en stock kontrol sistemak denbora errealeko eskuragarri dagoen inbentarioaren informazioa ematen du semaforoen bisual sistemaaren bidez. Sendagai bakoitzak bere uneko kantitatea erakusten du dagokion unitateetan, stockaren egoerari buruzko alertak ematen dituzten kolore adierazleekin.

Kolore kodea intuitiboa da: berdea stock nahikoa adierazten du 3 egun baino gehiagorako, horia/anbarra ohartarazten du stocka baxua dagoela (3 egun baino gutxiagoko hornikuntza), eta gorria sendagaia agortuta dagoela adierazten du. Eguneko atalaseak sendagaiaren arabera konfiguragarriak dira, tratamendu bakoitzaren kritikotasunaren arabera doikuntzak egiteko aukera emanez.

### Kalkulu Automatiko Adimentsua

Geratzen diren egunen kalkulua automatikoki egiten da hainbat faktore kontuan hartuz. Programatutako sendagaientzat, sistemak egunkako dosi osoa aztertzen du esleitu diren pertsona guztien konfiguratutako hartze guztiak batuz, uneko stocka egunkako dosi honen artean zatitzen du, eta geratzen diren hornidura egunak estim atzen ditu.

Sendagai okazionalentzat edo "behar den arabera", sistemak algoritmo egokitzaile bat erabiltzen du erabilera egunaren azken kontsumoa erregistratzen duena eta prediktor gisa erabiltzen du uneko stockak zenbat egun iraungo duen estimatzeko. Estimazio hau automatikoki eguneratzen da sendagaia erabili den bakoitzean.

### Sendagaiaren araberako Atala Konfiguragarria

Sendagai bakoitzak alerta atala pertsonalizatua izan dezake stocka baxua denean zehazten duena. Balio lehenetsia 3 egun da, baina 1 eta 10 egunen artean doitu daiteke premien arabera. Adibidez, insulina bezalako sendagai kritikoak 7 eguneko atalarekin konfiguratu daitezke ordezkatzeko denbora nahikoa izateko, bitartean suplementu kritikoagoak 1-2 eguneko atalak erabili ditzakete.

### Alertak eta Ordezkapena

Stocka konfiguratutako atalasea iristen duenean, MedicApp-ek alerta bisualak nabarmenduak erakusten ditu pantaila nagusian eta pilularien ikuspegian. Sistemak ordezkatze kopuru automatiko bat proposatzen du azken hornidura erregistratuan oinarrituz, inbentario eguneraketa prozesuaren azkartasuna. Alertak irauten dute erabiltzaileak stockean kantitate berria erregistratzen duen arte, ordezkatze kritikoak ahaztu ez direla ziurtatuz.

---

## 6. Botikina

### Zerrenda Alfabetiko Antolatua

MedicApp-en botikinak erregistratutako sendagai guztiak alfabetikoki ordenatutako zerrendan aurkezten ditu, edozein sendagai azkarra aurkitzeko erraztuz. Sarrera bakoitzak sendagaiaren izena, ikonoa eta kolore bereizgarria duen mota, uneko stocka dagokion unitateetan, eta sendagai horri esleitutako pertsonak erakusten ditu.

Botikinen ikuspegia bereziki erabilgarria da eskuragarri dauden sendagaien inbentarioaren ikuspegi globala izateko, ordutegi informazioa gabe, pantaila nagusian gainezka izan daitekeena. Inbentario kudeaketentzat, sendagai espezifikoen bilaketarako eta mantentze ekintzarako pantaila ideala da.

### Denbora Errealeko Bilatzailea

Goiko aldean bilaketa-eremu batek berehalako sendagaiak iragazteko aukera ematen du idazten den bitartean. Bilaketa adimentsua da eta sendagaiaren izena eta mota kontuan hartzen du, "xarope guztiak" edo "aspirina daukan sendagaiak" azkar aurkitzeko aukera emanez. Emaitzak denbora errealean eguneratzen dira botoi gehigarririk sakatu gabe.

### Integraturiko Ekintza Azkarrak

Botikinen sendagai bakoitzetik, hiru ekintza nagusiko menu kontextuala eskuratu daiteke:

**Editatu** - Sendagaiaren editore osoa irekitzen du, non alderdi guztiak aldatu daitezkeen: izena, mota, orduak, dosiak, esleitutako pertsonak, barazkaldiaren konfigurazioa, etab. Aldaketak gordetzen dira eta jakinarazpenak automatikoki bersinkronizatzen dira.

**Ezabatu** - Sendagaia sistemako betiko ezabatzeko aukera ematen du segurtasun baieztatze baten ondoren. Ekintza honek lotutako jakinarazpen guztiak ezeztatzen ditu eta etorkizuneko historiako erregistroa ezabatzen du, baina erregistratutako dosien historiala mantentzen du datu osotasuna mantentze ko.

**Dosia hartu** - Eskuzko hartze bat erregistratzeko lasterbide azkarra, batez ere sendagai okazionalentzat erabilgarria. Sendagaia pertsona askori esleituta badago, lehenbizi nork hartzen duen hautatzeko eskatzen du.

### Esleipenen Kudeaketa

Botikinak pertsona-sendagai esleipenen kudeaketa ere errazten du. Sendagai zer pertsonari esleituta dauden ikusi daitezke zirrikitu batean, sendagai existentea pertsona bat gehitu edo kendu, eta pertsona bakoitzaren pauta indibidualak beste guztiei eragin gabe aldatu.

---

## 7. Denbora Nabigazioa

### Egun Artean Horizontal Lerrata

MedicApp-en pantaila nagusiak denbora nabigazio sistema bat inplementatzen du erabiltzaileari egun desberdinen artean mugitzeko keinua horizontal erraz batekin. Ezkerretara lerratuz hurrengo egunera aurreratzen da, eskuinetara lerratuz aurreko egunera atzera egiten da. Nabigazio hau leuna da eta data aldaketa argiaren ikusizko feedback ematen duten trantsizio animatuak erabiltzen ditu.

Denbora nabigazioa praktikoki mugagabea da iraganak eta etorkizunera, atzera edo aurrera aste edo hilabete osoen sendagai historiala berrikusteko edo aurretik sendagai zein programatuko diren data etorkizunetan egiaztatzeko. Sistemak puntu zentral birtuala mantentzen du bi norabideetan milaka orrialde ahalbidetuz errendimendua eragotzi gabe.

### Egutegiaren Hautatzailea

Data espezifikoetara jauzi azkarrak egiteko, MedicApp-ek egutegi hautatzaile bat integratzen du goiko barraren botoi batetik eskuragarria. Egutegiaren ikonoa ukitzean, egutegi bisualeko widget bat irekitzen da non erabiltzaileak edozein data hautatu dezakeen. Hautatzean, ikuspegia berehalako eguneratzen da egun espezifiko horretako programatutako sendagaiak erakusteko.

Egutegiak uneko eguna adierazle nabarmendua batekin markatzen du, atxikipena berrikusteko iraganaleko datak hautatzeko errazten du, bidaientzako edo ekitaldientzako plangintza data etorkizunetara jauzi egiteko aukera ematen du, eta hautatutako uneko data goiko barran etengabe erakusten du.

### Egunaren Ikuspegia vs Asteko Ikuspegia

Nabigazio nagusia egunekoa den arren, MedicApp-ek hautatutako aldiko informazio kontextu gehigarria ematen du. Pantaila nagusian, sendagaiak hartzeko ordutegi arabera taldekatzen dira, egunaren denbora-lerroa ematen duena. Adierazle bisualek erakusten dute zer dosi hartu diren jada, zeintzuk omititu diren, eta zeintzuk zain dauden.

Asteko patron edo tarte espezifikodun sendagaientzat, interfazeak argi adierazten du sendagaia hautatutako egunari dagokion ala ez. Adibidez, "astelehena, asteazkena, ostirala" konfiguratutako sendagai bat asteko egun horietan soilik agertzen da zerrendan.

### Denbora Nabigazioaren Onurak

Funtzionalitate hau bereziki baliotsua da iraganaaldiko egun batean sendagai bat hartu zen egiaztatzeko, bidaia baten sendagaiak datetan oinarrituz planifikatzeko, asteko edo hileko atxikipen patronak berrikusteko, eta etxe bateko pertsona anitzen sendagaiak aldiko espezifikoetan koordinatzeko.

---

## 8. Jakinarazpen Adimendun

### Jakinarazpenetik Ekintza Zuzenak

MedicApp-ek sendagaien kudeaketa iraultzea jakinarazpenekin integraturako ekintzak integratzen ditu, aplikazioa ireki gabe dosiak kudeatzeko aukera emanez. Dosiaren ordua iristen denean, jakinarazpenak hiru ekintza zuzeneko botoi erakusten ditu:

**Hartu** - Dosia berehalako erregistratzen du, stocketik kentzen du, historiala sortzen du, jakinarazpena ezeztatzen du, eta aplikatzen bada, ondorengo baraualdiaren kontu atzerako hasiera ematen du.

**Atzeratu** - Jakinarazpena 10, 30 edo 60 minutuz atzeratzen du hautatutako aukeraren arabera. Jakinarazpena automatikoki berriro agertzen da zehaztutako denboran.

**Salatu** - Dosia om ititua gisa erregistratzen du, historiala sortzen du "saltatua" egoerarekin stocka kendu gabe, eta jakinarazpena ezeztatzen du oroigarri gehigarriak programatu gabe.

Ekintza hauek telefonoa blokeatuta dagoenean ere funtzionatzen dute, sendagaien erregistroa berehalakoa eta frikziorik gabea egiten dutena. Erabiltzaileak bere sendagai guztia jakinarazpenetatik kudeatu dezake gailua desblokeatu edo aplikazioa ireki gabe.

### Ezeztapen Adimentsua

Jakinarazpen sistemak ezeztapen logika aurreratua inplementatzen du alerta erredundante edo okerrak saihesteko. Erabiltzaileak dosi bat eskuz erregistratzen duenean aplikaziotik (jakinarazpena erabili gabe), sistemak automatikoki ezeztatu egiten du egun horretako dosi horren jakinarazpen zain dagoena.

Sendagai bat ezabatu edo etetsi bada, bere etorkizuneko jakinarazpen guztiak bigarren planoan berehalako ezeztatzen dira. Sendagai baten ordutegia aldatzen denean, jakinarazpen zaharrak ezeztatzen dira eta ordutegi berriekin automatikoki berprogramatzen dira. Kudeaketa adimentsu honek ziurtatzen du erabiltzaileak jakinarazpen garrantzitsuak eta egunekoak soilik jasoko dituela.

### Barazkaldiaren Jakinarazpen Iraunkorrak

Baraualdia behar duten sendagaientzat, MedicApp-ek jakinarazpen iraunkorra berezia erakusten du baraualdi osoko denboran. Jakinarazpen hau ezin da eskuz desagertu eta baraualdi denboraren kontu atzera erakusten du denbora errealean. Baraualdia amaitzen denean ordu zehatza barne hartzen du, erabiltzaileari janari planifikatzeko aukera emanez.

Baraualdi jakinarazpenak lehentasun altua du baina ez du soinua etengabe egiten, etenaldi molestoak saihestuz informazio kritikoa ikusgai mantentzen den bitartean. Baraualdi aldea amaitzen denean, jakinarazpena automatikoki ezeztatzen da eta soinu laburra ematen da erabiltzaileari jada jan dezakeela jakinarazteko.

### Sendagaiaren araberako Konfigurazio Pertsonalizatua

Sendagai bakoitzak banaka doitutako jakinarazpen konfigurazioa izan dezake. Erabiltzaileek sendagai espezifikoetarako jakinarazpenak guztiz gaitu edo desgaitu ditzakete, sisteman jarraipenean mantentzen dituzten bitartean baina alerta automatikorik gabe. Malgutasun hau erabilgarria da errutinatik hartzen dituen eta oroigarririk behar ez duen sendagaientzat.

Gainera, barazkaldiaren konfigurak hasiera baraualdi jakinarazpenak nahi diren ala ez erabakitzeko aukera ematen du (barauzpena aurretik duten sendagaientzat) edo funtzionatu alertarik gabe. MedicApp lehentasun indibidual hauek errespetatzen ditu dosi guztien erregistroan eta jarraip enean koherentzia mantentzen duen bitartean.

### Android 12+ Bateragarritasuna

MedicApp Android 12 eta bertsio berriagorako optimizatua dago, jakinarazpen zehatzendako beharrezkoak diren "Alarmak eta oroigarriak" baimenak eskatuz eta kudeatuz. Aplikazioak automatikoki detektatzen du baimen hauek emanda ez badaude eta erabiltzailea gidatzen du sistemaoko ezarpenetatik gaitzeko, jakinarazpenak puntualki programatutako orduan iritsiko direla ziurtatuz.

---

## 9. Stock Baxuko Alertak

### Stock Nahiezko Jakinarazpen Erreaktiboak

MedicApp-ek stock alertetako sistema adimentsu bat inplementatzen du erabiltzailea une kritikoetan sendagairik gabe geratzeko babestuz. Erabiltzaile batek dosia erregistratu nahi duenean (pantaila nagusitik zein jakinarazpenen ekintza azkarretatik), sistemak automatikoki egiaztatzen du stock nahikoa dagoen hartzea osatzeko.

Stock eskuragarria dosiaren kantitate behar baino txikiagoa bada, MedicApp-ek berehalako stock nahiezko alerta erakusten du hartzea erregistratzea galarazten duena. Jakinarazpen erreaktibo honek argi adierazten du sendagai kaltetua izena, behar den kantitatea vs. eskuragarria, eta inbentarioa osatu aurretik dosia berriro erregistratzeko saiatzen aurretik proposatzen du.

Babes mekanismo honek erregistro okerrak historian galarazten ditu eta inbentario kontrolaren integritatea bermatzen du, fisikoki ez dagoen stocka kendu ez dadin ekidituz. Alerta argia da, ez intrusiboak, eta erabiltzailea zuzenean ekintza zuzentzailera gidatzen du (stocka osatu).

### Stock Baxuko Jakinarazpen Proaktiboak

Dosia hartzeko uneko alerta erreaktiboekin ez ezik, MedicApp-ek egunkako stockaren monitoritzazio sistemak proaktibo bat barne hartzen du horniketa arazoak gerta aurretik aurreikusten dituztenak. Sistema honek egunean behin sendagai guztien inbentarioa automatikoki ebaluatzen du, kontsumoak programatuaren arabera geratzen diren hornidura egunak kalkulatuz.

Kalkuluak faktore anitz kontuan hartzen ditu uneko stockak zenbat denbora iraungo duen zehaztasunez estimatzeko:

**Sendagai programatuetarako** - Sistemak esleitu diren pertsona guztien egunkako dosi osoa batzen du, maiztasun patroian konfiguratutako egunekin biderkatzen du (adibidez, astelehena, asteazkena eta ostirala soilik hartzen bada, kalkulua doitzen du), eta uneko stocka eguneko konsumo eraginkor honen artean zatitzen du.

**Sendagai okazionalentzat ("behar den arabera")** - Azken eguneko benetako kontsumoaren erregistroa prediktor gisa erabiltzen du, erabilerekin hobetzen den estimazio egokitzaile bat eskainiz.

Sendagai baten stockak konfiguratutako atala iristen duenean (lehenetsia 3 egun, baina sendagaiaren arabera 1-10 egunen artean pertsonalizagarria), MedicApp-ek abisu jakinarazpen proaktibo bat ematen du. Jakinarazpen honek erakusten du:

- Sendagaiaren izena eta mota
- Geratzen diren hornidura egun hurbilkoatzeak
- Kaltetutako pertsona(k)
- Uneko stocka dagokion unitateetan
- Ordezkatze proposamena

### Jakinarazpenen Spam Prebentzioa

Erabiltzailea alerta errepikatiboekin bonbardatzea saihesteko, jakinarazpen proaktiboen sistemak maiztasunaren logika adimentsua inplementatzen du. Stock baxuko alerta mota bakoitza sendagaiaren arabera egunean behin gehienez ematen da. Sistemak alerta bakoitza bidali den azken data erregistratzen du eta ez du berriro jakinarazten harik eta:

1. Azken alertatik 24 ordu gutxienez igaro diren arte, EDO
2. Erabiltzaileak stocka osatu duenean (kontadorea berrezarriz)

Spam prebentzioa honek ziurtatzen du jakinarazpenak baliogarriak eta garaiz kosuak direla, erabiltzailea alde batera uzteko edo desgaitzeko eramango lukeen aspaldia bihurtu gabe.

### Stock Kontrol Bisualarekin Integrazioa

Stock baxuko alertak ez dira modu isolatuan funtzionatzen, pilularien semaforo bisual sistemekin sakonki integratuak daude baizik. Sendagai batek stock baxua duenean:

- Botikinan gorriz edo anbarrez markatuta agertzen da zerrendan
- Pantaila nagusian abisu ikonoa erakusten du
- Jakinarazpen proaktiboa bisual seinaletxe hauek osatzen ditu

Informazio geruza anitz hau (bisuala + jakinarazpenak) bermatzen du erabiltzailea inbentarioaren egoeraren jakitun dela aplikazioarekin kontaktu puntu anitztatik.

### Konfigurazioa eta Pertsonalizazioa

Sendagai bakoitzak alerta atala pertsonalizatua izan dezake stocka "baxua" denean zehazten duena. Insulina edo antikoagulanteak bezalako sendagai kritikoak 7-10 eguneko atalekin konfiguratu daitezke ordezkatzerako denbora nahikoa izateko, bitartean premiako suplementuek 1-2 eguneko atalak erabili ditzakete.

Sistemak konfigurazio indibidual hauek errespetatzen ditu, sendagai bakoitzak bere alerta politika propioa izateko aukera emanez bere kritikotasunera eta farmazietako eskuragarritasunera egokitua.

---

## 10. Barazkaldiaren Konfigurazioa

### Motak: Before (Aurretik) eta After (Ondoren)

MedicApp-ek baraualdi modalitate bi onartzen ditu preskripzio mediku desberdineetara egokitzeko argi bereiztuak:

**Baraualdi Before (Aurretik)** - Sendagaia urdail hustuan hartu behar denean konfiguratzen da. Erabiltzaileak zehaztutako aldian baraualdia izan behar du sendagaia hartu AURRETIK. Adibidez, "30 minutuko baraualdia aurretik" esan nahi du aurretik 30 minutu osoan ezer jan gabe egon behar dela. Mota hau ohikoa da xurgapen optimoa behar duten sendagaientzat elikagaien eragozpenik gabe.

**Baraualdi After (Ondoren)** - Sendagaia hartu ondoren jan gabe itxaron behar denean konfiguratzen da. Adibidez, "60 minutuko baraualdia ondoren" esan nahi du sendagaia hartu ondoren, 60 minutuz elikagaiak ezin direla ingestatu. Mota hau tipikoa da molestia gastrikoar eragin ditzaketen sendagaientzat edo efikazia elikagaiarekin murrizten dena.

Barazkaldiaren iraupena guztiz konfiguragarria da minututan, 15 minutuetatik ordubete bat baino gehiagoko preskripzio espezifikoetara egokitzeko aukera emanez.

### Kontu Atzera Bisual Denbora Errealean

"Ondoren" baraualdia duen sendagai bat hartu denean, MedicApp-ek kontu atzera bisual nabarmena erakusten du pantaila nagusian. Kontaketa hau denbora errealean eguneratzen da segunduro, geratzen den denbora MM:SS formatuan (minutuak:segundoak) erakutsiz. Kontu atzeraarekin batera, baraualdi aldea amaitzen den ordu zehatza adierazten da, planifikazio berehalakoa ahalbidetuz.

Kontu atzeraren osagai bisuala ezinezkoa da ezikusiarena egitea: kolore dei egileak erabiltzen ditu, pantailan modu nabarmenean kokatzen da, lotutako sendagaiaren izena barne hartzen du, eta elikagaien murrizketa ikonoa erakusten du. Ikusgarritasun etengabe honek ziurtatzen du erabiltzaileak aktiboa den elikagaien murrizketa ez ahaztea.

### Jakinarazpen Finkoa Baraualdi Artean

Aplikazioko kontu atzera bisualari gehituz, MedicApp-ek baraualdi aldiko denbora osoan sistemaren jakinarazpen iraunkorra erakusten du. Jakinarazpen hau "ongoing" (jarraitutzen) da, hau da, erabiltzaileak ezin du desagertu eta jakinarazpenen barran finkatuta mantentzen da lehentasun maximoarekin.

Baraualdi jakinarazpenak aplikazioko kontu atzeraren informazio bera erakusten du: sendagaiaren izena, geratzen den baraualdi denbora, eta amaiera ordua estimatua. Geratzen den denbora islatzeko periodikoki eguneratzen da, baina ez denbora erreal etengabean bateria zaintzeko. Oroigarri geruza bikoitz hau (aplikazioko bisuala + jakinarazpen iraunkorra) praktikoki kentzen du baraualdi akzidentalki hausteko arriskua.

### Ezeztapen Automatikoa

Sistemak automatikoki baraualdi bizi-zikloa kudeatzen du eskuintza eskuzkorik gabe. Baraualdi denbora bukatzen denean, hainbat ekintza simulta neoki eta modu automatikoan gertatzen dira:

1. Kontu atzera bisuala pantaila nagusitik desagertzen da
2. Jakinarazpen iraunkorra automatikoki ezeztatzen da
3. Soinuarekin jakinarazpen laburra ematen da "Baraualdia amaituta, jada jan dezakezu" adieraziz
4. Sendagaiaren egoera eguneratzen da baraualdiak amaitu dela islatzeko

Automatizazio honek ziurtatzen du erabiltzailea beti eguneko egoeraz informatuta dagoela eskuz baraualdiak noiz amaitu behar duen gogoratzeko gabe. Aplikazioa bigarren planoan badago baraualdi amaitzen denean, amaierako jakinarazpenak berehalako erabiltzailea alertatzen du.

### Sendagaiaren araberako Konfigurazioa

Sendagai guztiek ez dute baraualdiarik behar, eta behar dutenen artean, beharrak aldatzen dira. MedicApp-ek sendagai bakoitzeko banaka konfiguratzeko aukera ematen du: baraualdiarik behar duen ala ez (bai/ez), baraualdi mota (aurretik/ondoren), iraupena zehatza minututan, eta hasiera baraualdi jakinarazpenak nahi diren (mota "aurretik" dutentzat).

Granulartasun honek erregimen konplexuak kudeatzeko aukera ematen du, non sendagai batzuk barau egoeretan hartzen baitira, beste batzuek ingesta ondorengo itxarona behar dute, eta beste batzuek ez daukate murrizketarik, guztia interfaz koherente bateko barruan barako kasuak automatikoki bere konfigurazio espezifikoaren arabera kudeatzen dituena.

---

## 11. Dosien Historiala

### Erregistro Automatiko Osoa

MedicApp-ek sendagaiekin lotutako ekintza bakoitzaren erregistro xehatua eta automatikoa mantentzen du. Dosi bat erregistratzen den bakoitzean (hartua edo omititua), sistemak berehalako gertatzearen informazio sakona harrapatu duen historiako sarrera bat sortzen du.

Erregistratutako datuek honako hauek barne hartzen dituzte: sarreraren identifikatzaile bakarra, sendagaiaren ID eta uneko izena, sendagai mota bere ikonoa eta kolorearekin, dosia hartu/omititu duen pertsonaren ID eta izena, jatorriz programatutako data eta ordua, ekintza erregistratu den benetako data eta ordua, dosiaren egoera (hartua edo omititua), dagokion unitateetan administratutako kantitate zehatza, eta ea programatu gabeko dosi extra bat zen.

Erregistro automatiko hau funtzionatzen du dosia nola erregistratu den kontuan hartu gabe: aplikaziotik, jakinarazpen ekintzeta tik, edo eskuzko erregistroaz. Ez du oinarrizko erregistro ekintza baino erabiltzailearen esku-hartzearik behar, historiala beti osatuta eta eguneratuta dagoela bermatuz.

### Terapia Atxikipenaren Estatistikak

Dosien historialatik, MedicApp-ek automatikoki atxikipen estatistikak kalkulatzen ditu tratamenduaren betetze buruzko informazio baliotsua ematen duena. Metrikek honako hauek barne hartzen dituzte:

**Atxikipa Global Tasa** - Hartutako dosien ehunekoa programatutako dosi osoaren gainean, (hartutako dosiak / (hartutako dosiak + omititutako dosiak)) × 100 gisa kalkulatua.

**Erregistratutako Dosi Osoak** - Aztertutako aldiko historiak ko gertaeren osoko kontaketa.

**Hartutako Dosiak** - Zenbaki absolutua arrakastaz hartutakotzat erregistratutako dosien.

**Omititutako Dosiak** - Programatutako bezala saltatu edo hartuta ez zeuden dosien zenbakia.

Estatistika hauek dinamikoki kalkulatzen dira aplikatutako iragazkietan oinarrituz, aldiko espezifikoetan, sendagai indibidualetan edo pertsona zehatzetan analisiak egiteko aukera emanez. Bereziki erabilgarriak dira betetze ezaren patronak identifikatzeko, uneko ordutegi erregimen eragingarritasuna ebaluatzeko, eta kontsulta medikoetan informazio objektiboa emateko.

### Iragazki Aurreratutako Dimentsi Askoak

Historialaren pantailak iragazkiak sistema indartsuak ditu datuak perspektiba desberdinetatik aztertzeko aukera emanez:

**Pertsonaren araberako Iragazia** - Pertsona espezifiko baten dosiak soilik erakusten ditu, ingurune anitz-pertsonean jarraipe n indibidualerako ideala. "Pertsona guztiak" aukera ikuspegi globalerako sartu.

**Sendagaiaren araberako Iragazia** - Sendagai jakin baten fokalizatzeko aukera ematen du, tratamentu espezifikoen atxikipena ebaluatzeko erabilgarria. "Sendagai guztiak" aukera ikuspegi osorakobegitu.

**Data Tartesaren araberako Iragazia** - Hasiera data eta amaiera datarekin aldiiko espezifikoa definitu. Erabilgarria hileko, hiruhileko atxikipen txostenak sortzeko edo kontsulta medikoekin bat datozen aldiko pertsonalizatuentzat.

Iragazkiak metatuak dira eta konbinatu daitezke. Adibidez, "urtarrilean Mariak hartutako Ibuprofeno dosi guztiak" ikusi daitezke, analisi oso granulatuak emanez. Aktibatutiako iragazkiak txip informatibotan bistaratzen dira banaka kendu daitezkeenak.

### Datuen Esportazioa

Uneko interfazeak ez du esportazio zuzena inplementatzen, dosien historiala aplikazioaren SQLite datu-basean gordetzen da, sistemaren backup funtzionalitatearen bidez guztiz esportatu daitekeena. Datu-base honek historiako sarrera guztiak dauzka formatu egituratuan, ondoren tresna kanpokoekin prozesatu daitezkeena txosten pertsonalizatuak sortzeko, atxikipen grafikoak, edo kudeaketa medikuaren sistemekin integrazioa.

Datuen formatua erlazio eta normalizatua da, sendagaiak, pertsonak eta historialaren sarrerak lotzen dituzten atzerriko gakoiekin, analisi konplexuak erraztuz eta informazio aurkezpen medikuetara edo tratamendu auditorietara ateratzea.

---

## 12. Lokalizazioa eta Nazioartekotzea

### 8 Hizkuntza Osoki Onartuta

MedicApp hizkuntz a zortzi modu profesionalean eta osoan itzulia dago, penintsular iberikoan hitz egiten diren hizkuntza gehienak estaltzen dituena eta Europa-etxea zabaltzen duena:

**Gaztelania (es)** - Hizkuntza nagusia, itzulpen natiboarekin terminologia mediku zehatza.

**English (en)** - Nazioarteko ingelesa, mundu mailako ingelesik hiztunentzat egokitua.

**Deutsch (de)** - Alemana estandarra, terminologia medikuarekin europarrarekin.

**Français (fr)** - Frantsesa europarrarki hiztegiarekin farmazeutiko egokiarekin.

**Italiano (it)** - Italiera estandarra hitz mediku lokalizatuekin.

**Català (ca)** - Katalan hitz mediku espezifikoekin katalan sistema sanitarioko.

**Euskara (eu)** - Euskara terminologia sanitario egokiarekin.

**Galego (gl)** - Galiziera hiztegiarekin mediko erregio nalizatuarekin.

Itzulpen bakoitza ez da bihurketa automatiko sinplea, kulturalki lokalizazioa baizik preskripzio medikoen konbenzioak, data/ordu formatuak eta eskualdeko espresio idiomatikoak errespetatzen dituena. Sendagai izenak, forma farmazeutikoak eta hitz teknikoak hizkuntza bakoitzaren hiztegi mediko lokalera egokituta daude.

### Hizkuntza Aldaketa Dinamikoa

MedicApp-ek edozein unean interfazearen hizkuntza ezarpenen pantailatik aldatzeko aukera ematen du. Hizkuntza berri bat hautatzen denean, aplikazioa berehalako eguneratzen da berrabiarazi behar gabe. Interfazearen testu guztiak, jakinarazpen mezuak, botoien etiketak, laguntza deskribapenak eta errore mezuak berehalako hautatutako hizkuntzara eguneratzen dira.

Hizkuntza aldaketa leuna da eta ez du gordetako datuetan eragiten. Erabiltzaileak sartutako sendagai izenak nola sartu ziren mantentzen dira, interfazearen hizkuntzatik independenteak. Sistemak sortutako UI elementuak soilik aldatzen dira hizkuntza, informazio mediku pertsonalizatua zaintzen dena.

### Dezimal Banatzaile Lokalizatuak

MedicApp-ek eskualdeko zenbaki konbenzioak errespetatzen ditu dezimal banatzaileent zat. Gaztelania, frantsesa, alemana eta italiera bezalako hizkuntzetan, koma (,) dezimal banatzaile gisa erabiltzen da: "1,5 pilulak", "2,25 ml". Ingelesean, puntua (.) erabiltzen da: "1.5 tablets", "2.25 ml".

Zenbaki lokalizazio hau automatikoki aplikatzen da kantitate sarrera eremu guztietan: sendagai dosia, stock eskuragarria, berriz hornitzeko kantitateak. Zenbaki teklatuak automatikoki konfiguratzen dira aktiboa den hizkuntzaren arabera dezimal banatzaile zuzena erakusteko, nahasmen eta sarrera erroreak saihestuz.

### Data eta Ordu Formatu Lokalizatuak

Data eta ordu formatuak ere eskualdeko konbenzioetara egokitzen dira. Europako kontinenteko hizkuntzak DD/MM/YYYY (eguna/hilabetea/urtea) formatua erabiltzen dute, ingelesak berriz MM/DD/YYYY erabiltzea variante batzuetan egin dezake. Hilabete eta asteko egunen izenak itzulita agertzen dira egutegi hautatzaileetan eta historialaren ikuspegien.

Orduak 24 orduko formatuan erakusten dira hizkuntza europear guztietan (13:00, 18:30), medikoaren nazioarteko estandarra eta AM/PM anbiguotasuna saihesten duena. Koherentzia hau kritikoa da ordu zehaztasuna bizitza medikoetan garrantzitsua den kontextuetan tratamenduaren eraginkortasunerako.

### Pluralizazio Adimentsua

Lokalizazio sistemak pluralizazio logika barne hartzen du kantitateen arabera testuak egokitzen dituena. Adibidez, gaztelaniaz: "1 pilula" baina "2 pilulak", "1 egun" baina "3 egun". Hizkuntza bakoitzak bere plural-arauak ditu sistemak automatikoki errespetatzen dituenak, katalanean, euskaran eta galizieran plural kasu konplexuak barne, gaztelaniatik desberdinak diren arauak dituztenak.

Hizkuntza xehetasun arreta honek MedicApp natural eta natiboaren sentitzen dela egiten du hizkuntza bakoitzean, erabiltzailearen esperientzia nabarmen hobetuz eta karga kognitiboa murriztuz kontextu medikoetan estresagarrietan aplikazioaren erabileran.

---

## 13. Interfaze Irisgarria eta Erabilgarria

### Material Design 3

MedicApp Material Design 3 (Material You) Google-ren diseinu-sistema modernoena eta irisgarriena erabiliz eraikia dago Android aplikazioentzat. Erabaki arkitektoniko honek onura anitz bermatzen ditu:

**Bisual Koherentzia** - Interfaze elementu guztiak (botoiak, txartelak, elkarrizketak, testu eremuak) Android erabiltzaileek instinktiboki ezagutzen dituzten bisual patron estandarren arabera jarraitzen dute. Ez da interfaze guztiz berria ikastea behar.

**Tematizazio Dinamikoa** - Material 3-k erabiltzailearen sistemaren koloreak (Android 12+ bada) aplikazioak har ditzakeela ahalbidetzen du, gailuaren gainerakoarekin bisual esperientzia koherentea sortuz. Kolore azentu, hondoak eta azalak automatikoki egokitzen dira.

**Osagai Irisgarri Natiboak** - Material 3 kontrol guztiak hasieratik irisgarria izateko diseinatuak daude, ukitze eremu emankorrak (gutxienez 48x48dp), kontraste egokiak eta pantaila irakurleentzako onartzearekin.

### Tipografia Zabaldu eta Irakurgarria

Aplikazioak hierarkia tipografiko argia erabiltzen du letra-tamaina emankorrak neke bisualik gabe irakurketa errazten dituenak:

**Pantaila Tituluak** - Tamaina handia (24-28sp) erabiltzailea non dagoen orientazio argiarako.

**Sendagai Izenak** - Tamaina nabarmentua (18-20sp) negatiboan identifikazio azkarreko.

**Informazio Sekundarioa** - Tamaina ertainaa (14-16sp) ordutegi eta kantitateen bezalako xehetasun osagarrientzat.

**Laguntza Testua** - Tamaina estandarra (14sp) argibide eta deskribapenent zat.

Lerroak artearen tartea emankorra da (1.5x) lerroak nahastu ez daitezen, bereziki ikuspegi arazoek daukatentzat garrantzitsua. Erabilitako letra-tipoak sans-serifa dira pantaila digitaletan erakutsi duen irakurgarritasun hobearekin.

### Kontraste Bisual Altua

MedicApp kolore paleta inplementatzen du WCAG 2.1 AA irisgarritasun gidalerroen gainetik eta gainditzen dituzten kontraste ratioek. Testua eta hondoak arteko kontraste minimoa 4,5:1 da testu normalentzat eta 3:1 testu handientzat, irakurgarritasuna argitze baldintza ez-optimoetan ere ziurtatuz.

Koloreak funtzionalki ez ezik estetikoki ere erabiltzen dira: gorria stockako alertentzat baxua edo baraualdi aktiboa, berdea baiezta peneta co eta stock nahikoa, anbarra tarteko oharrientzat, urdina informazio neutroa. Baina kritikoki, kolorea ez da iragarketa bakarra inoiz: beti ikonoak, testua edo patronak osatzen ditu.

### Nabigazio Intuitiboa eta Aurresangarria

MedicApp-en nabigazio egitura sinpletasunaren eta aurresangarritasunaren printzipioak jarraitzen ditu:

**Pantaila Nagusia Zentro** - Egunaren sendagaien ikuspegia hub nagusia da, guztia gehienez 2 ukituek eskuragarria den.

**Fitxa Nabigazioa** - Beheko barrako 3 fitxa (Sendagaiak, Botikina, Historiala) ikuspegi nagusien artean aldaketa berehalakoa ahalbidetzen dute nahaste-animaziorik gabe.

**Akzio Boton Flotan Flotan** - Akzio nagusiak (sendagai gehitu, historialaren iragazi) kokapena koherentean boton flotatzailean (FAB) egiten dira, behatzarekin erraz iritsi daitezen.

**Breadcrumbs eta Back Button** - Beti argia da zein pantailatan dagoen erabiltzailea eta nola atzera joan. Atzera botoia beti goiko ezkerreko posizio estandarrean dago.

### Feedback Bisual eta Taktilikoa

Interakzio bakoitzak feedback berehalakoa ekoizten du: botoiek "ripple" efektua erakusten dute sakatzen direnean, akzio arrakastasunak berriro snackbar berdeekin baieztatzen dira, erroreak elkarrizketa gorri azalpenarekin adierazten dira, eta prozesu luzeak (datu-basea esportatzea bezala) adierazle animatuko progresuarekin erakusten dira.

Feedback etengabe honek ziurtatzen du erabiltzaileak bere ekintza erregistratu dela eta sistemak erantzuten ari dela beti ezagutzen duuela, aplikazio medikuen antsietate tipikoa murriztuz non errore batek garrantziaren ondorioak izan ditzakeen.

### Esku Bakarreko Erabilera Diseinua

Ezagutzen erabiltzaileek sendagaiak esku bakarrarekin maiz kudeatzen dituztela (bestea ontzarekin eu tsiz), MedicApp-ek ergonomia esku bakarreko erabilerarako optimizatzen du:

- Pantailaren beheko erdian elementu interaktibo nagusiak
- Beheko eskuin eskuinean akzio boton flotatzailea, behatzarekin iritsi daitekeena
- Goiko ertzetan menuak saihesten dituzte eusten berregitea behar dutenak
- Lerrata horizontal gestuak (bertikalak baino erosoagoak) denbora nabigaziorako

Kontuan-hartze ergonomiko honek nekea fisikoa murrizten du eta aplikazioa erosoagoa egiten du sendagai hartzeko egoera errealeetan, askotan zutik edo mugimenduan gertatzen direnak.

---

## Funtzionalitaten Integrazioa

Ezaugarri hauek guztiak ez dira isolatuki funtzionatzen, esperientzia koherentea sortzeko sakonki integratuak daude baizik. Adibidez:

- 8 pausuetan flux-ean gehitutako sendagaia automatikoki pertsonetara esleitzen da, bere maiztasun motaren arabera jakinarazpenak sortzen ditu, alfabetikoki ordenatutako botikinan agertzen da, bere dosiak historian erregistratzen ditu, eta atxikipen estatistikak eguneratzen ditu.

- Jakinarazpenek baraualdi konfigurazioa errespetatzen dute, automatikoki bisual kontu atzera eguneratzen duena dosia ondorengo baraualdi batekin erregistratzen denean.

- Pertsona anitzeko stock kontrolak ondo kalkulatzen ditu geratzen diren egunak esleitu diren pertsona guztien dosiak kontuan hartuz, eta atalasea iristen duen alertak nork hartzen sendagaia kontuan hartu gabe.

- Hizkuntza aldaketak berehalako jakinarazpen pendente guztiak eguneratzen ditu, pantaila ikusgarriak, eta sistemaren mezuak, koherentzia osoa mantentzen duena.

Integra zio sakon hau da MedicApp sendagaien zerrenda sinple batetik familia tratamendu kudeaketa sistema oso bihurtzen duena.

---

## Dokumentazio Gehigarrien Erreferentziak

Alderdi espezifikoei buruzko informazio gehiagorako:

- **Pertsona Anitzeko Arkitektura**: Ikusi datu-basea dokumentazioa (taulak `persons`, `medications`, `person_medications`)
- **Jakinarazpen Sistema**: Ikusi iturburu kodea `lib/services/notification_service.dart`-en
- **Datu Modelo**: Ikusi modeloak `lib/models/`-en (bereziki `medication.dart`, `person.dart`, `person_medication.dart`)
- **Lokalizazioa**: Ikusi `.arb` fitxategiak `lib/l10n/`-en hizkuntza bakoitzarentzat
- **Probak**: Ikusi proba suite `test/`-en 432+ probekin funtzionalitate hauek guztiak balioztatzeko

---

Dokumentazio honek MedicApp-en uneko egoera islatzen du bere 1.0.0 bertsioan, familia sendagaien kudeaketatik heldu aplikazio oso bat %75 baino gehiagoko proba estaldurarekin eta 8 hizkuntzarako onarpen osoaz.
