# MedicApp

[![Tests](https://img.shields.io/badge/tests-432%2B-brightgreen)](../../test)
[![Cobertura](https://img.shields.io/badge/cobertura-75--80%25-green)](../../test)
[![Flutter](https://img.shields.io/badge/Flutter-3.9.2%2B-02569B?logo=flutter)](https://flutter.dev)
[![Material Design](https://img.shields.io/badge/Material%20Design-3-757575?logo=material-design)](https://m3.material.io)
[![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?logo=dart)](https://dart.dev)
[![SQLite](https://img.shields.io/badge/SQLite-3-003B57?logo=sqlite)](https://www.sqlite.org)

**MedicApp** Flutter-ekin garatutako medikamentuen kudeaketa aplikazio mugikorra da, erabiltzaileei eta zaintzaileei pertsona anitzenentzako medikamentuen administrazioa modu eraginkorrean eta seguruan antolatu eta kontrolatzeko diseinatua.

---

## Edukien Taula

- [Proiektuaren Deskribapena](#proiektuaren-deskribapena)
- [Ezaugarri Nagusiak](#ezaugarri-nagusiak)
- [Pantaila-argazkiak](#pantaila-argazkiak)
- [Hasiera Bizkorra](#hasiera-bizkorra)
- [Dokumentazioa](#dokumentazioa)
- [Proiektuaren Egoera](#proiektuaren-egoera)
- [Lizentzia](#lizentzia)

---

## Proiektuaren Deskribapena

MedicApp medikamentuen kudeaketarako irtenbide integrala da, erabiltzaileei pertsona anitzenentzako tratamendu medikoak aplikazio bakar batetik kudeatzeko aukera ematen diena. Erabilgarritasunean eta irisgarritasunean oinarritutako enfokean diseinatua, MedicApp-ek hartzeko ordutegien jarraipena, stock-aren kontrola, barau aldiaren kudeaketa eta jakinarazpen adimendun erraztzen ditu.

Aplikazioak arduraz bereiztutako arkitektura garbia ezartzen du, Provider-ekin egoera kudeaketa, eta datu sinkronizazioa eta iraunkortasuna bermatzeko SQLite datu base sendoa. 8 hizkuntzetarako euskarriarekin eta Material Design 3-rekin, MedicApp-ek mundu osoko erabiltzaileentzako esperientzia modernoa eta irisgarria eskaintzen du.

Tratamendu konplexuak dituzten pazienteentzako ideala, zaintzaile profesionalentzako, familia kide anitzen medikaketa kudeatzen duten familientzako, eta medikamentuen gogorarazleen eta jarraipenaren sistema fidagarria behar duen edonorentzako.

---

## Ezaugarri Nagusiak

### 1. **Pertsona Anitzeko Kudeaketa**
Kudeatu pertsona anitzenentzako medikamentuak aplikazio bakar batetik. Pertsona bakoitzak bere profil, medikamentu, erregistratutako hartzeak eta estatistika independenteak ditu (V19+ datu basea).

### 2. **14 Medikamentu Mota**
Euskarri osoa medikamentu mota askotarakoentzat: Konprimidua, Kapsula, Xarabe, Injekzioa, Inhalatzailea, Krema, Tantak, Parche, Supositorioa, Spray, Hautsa, Gel, Apositua eta Besteak.

### 3. **Jakinarazpen Adimendunak**
Aurreratutako jakinarazpen sistema ekintza azkarrekin (Hartu/Atzeratu/Saltatu), gehienez 5 jakinarazpen aktibotara automatikoki mugatua, eta barau aldi aktiboentzako ongoing jakinarazpenak.

### 4. **Stock-aren Kontrol Aurreratua**
Irteeraren jarraipen automatikoa alerta konfiguragarriekin, stock baxuko jakinarazpenekin, eta medikamentuak agortu aurretik berritzeko gogorarazpenekin.

### 5. **Barau Aldien Kudeaketa**
Konfiguratu aurre/post medikamentu barau aldiak ongoing jakinarazpenekin, ordutegi balioztapenarekin, eta kursoan edo etorkizunean diren barauzko bakarrik erakusten dituzten alerta adimendunekin.

### 6. **Hartzen Historial Osoa**
Hartze guztien erregistro zehatza egoerekin (Hartua, Saltatua, Atzeratua), timestamp zehatzakin, stock-aren integrazioarekin, eta pertsonako itsaspen estatistikak.

### 7. **Hizkuntza Anitzeko Interfazea**
8 hizkuntzetan euskarri osoa: Gaztelania, Ingelesa, Frantsesa, Alemana, Italiera, Portugesa, Katalana eta Euskara, aplikazioa berrabiarazi gabe aldaketa dinamikoa.

### 8. **Material Design 3**
Interfaze modernoa argi/ilun gaiarekin, osagai adaptatiboekin, animazio jarioekin, eta pantaila tamaina desberdinetara egokitzen den diseinu responsive-rekin.

### 9. **Datu Base Sendoa**
SQLite V19 migrazio automatikoekin, indize optimizatuekin, erreferentzia osotasunaren balioztapenarekin, eta datuen koherentzia mantentzeko trigger sistema osoarekin.

### 10. **Azterketa Zehatza**
432 test automatizatu baino gehiago (75-80% estaldura) unitate testak, widget testak, integrazio testak, eta ertzeko kasuetarako test espezifikoak barne, hala nola gauerdiko jakinarazpenak.

---

## Pantaila-argazkiak

_Aplikazioaren etorkizuneko pantaila-argazkietarako atala erreserbatua._

---

## Hasiera Bizkorra

### Aurretiazko Baldintzak
- Flutter 3.9.2 edo handiagoa
- Dart 3.0 edo handiagoa
- Android Studio / VS Code Flutter luzapenekin

### Instalazioa

```bash
# Klonatu repositorioa
git clone <repository-url>
cd medicapp

# Instalatu dependentziak
flutter pub get

# Exekutatu aplikazioa
flutter run

# Exekutatu testak
flutter test

# Sortu estaldu txostena
flutter test --coverage
```

---

## Dokumentazioa

Proiektuaren dokumentazio osoa `docs/eu/` direktorioan eskuragarri dago:

- **[Instalazio Gida](installation.md)** - Baldintzak, instalazioa eta hasierako konfigurazioa
- **[Ezaugarriak](features.md)** - Funtzionalitate guztien dokumentazio zehatza
- **[Arkitektura](architecture.md)** - Proiektuaren egitura, ereduak eta diseinuko erabakiak
- **[Datu Basea](database.md)** - Eskema, migrazioak, trigger-ak eta optimizazioak
- **[Proiektuaren Egitura](project-structure.md)** - Fitxategi eta direktorioen antolamendua
- **[Teknologiak](technologies.md)** - Stack teknologikoa eta erabilitako dependentziak
- **[Azterketa](testing.md)** - Azterketa estrategia, test motak eta ekarpenen gidak
- **[Ekarpena](contributing.md)** - Proiektuari ekarpena egiteko gidak
- **[Arazoen Konponketa](troubleshooting.md)** - Arazo arrunten eta konponbideak

---

## Proiektuaren Egoera

- **Datu Basearen Bertsioa**: V19 (pertsona anitzeko euskarriarekin)
- **Testak**: 432+ test automatizatu
- **Estaldura**: 75-80%
- **Onartutako Hizkuntzak**: 8 (ES, EN, FR, DE, IT, PT, CA, EU)
- **Medikamentu Motak**: 14
- **Flutter**: 3.9.2+
- **Material Design**: 3
- **Egoera**: Garapen aktiboan

---

## Lizentzia

Proiektu hau [GNU Affero General Public License v3.0 (AGPL-3.0)](../../LICENSE) lizentziapean dago.

AGPL-3.0 copyleft software libre lizentzia bat da, sare zerbitzari batean exekutatzen den softwarearen edozein bertsio aldatua ere kode irekia bezala eskuragarri egotea eskatzen duena.

---

**Flutter eta Material Design 3-rekin garatua**
