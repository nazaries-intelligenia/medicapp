// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'MedicApp';

  @override
  String get navMedication => 'Farmaci';

  @override
  String get navPillOrganizer => 'Portapillole';

  @override
  String get navMedicineCabinet => 'Armadietto';

  @override
  String get navHistory => 'Cronologia';

  @override
  String get navSettings => 'Impostazioni';

  @override
  String get navInventory => 'Inventario';

  @override
  String get navMedicationShort => 'Home';

  @override
  String get navPillOrganizerShort => 'Stock';

  @override
  String get navMedicineCabinetShort => 'Armadietto';

  @override
  String get navHistoryShort => 'Cronologia';

  @override
  String get navSettingsShort => 'Impostazioni';

  @override
  String get navInventoryShort => 'Farmaci';

  @override
  String get btnContinue => 'Continua';

  @override
  String get btnBack => 'Indietro';

  @override
  String get btnSave => 'Salva';

  @override
  String get btnCancel => 'Annulla';

  @override
  String get btnDelete => 'Elimina';

  @override
  String get btnEdit => 'Modifica';

  @override
  String get btnClose => 'Chiudi';

  @override
  String get btnConfirm => 'Conferma';

  @override
  String get btnAccept => 'Accetta';

  @override
  String get medicationTypePill => 'Pillola';

  @override
  String get medicationTypeCapsule => 'Capsula';

  @override
  String get medicationTypeTablet => 'Compressa';

  @override
  String get medicationTypeSyrup => 'Sciroppo';

  @override
  String get medicationTypeDrops => 'Gocce';

  @override
  String get medicationTypeInjection => 'Iniezione';

  @override
  String get medicationTypePatch => 'Cerotto';

  @override
  String get medicationTypeInhaler => 'Inalatore';

  @override
  String get medicationTypeCream => 'Crema';

  @override
  String get medicationTypeOther => 'Altro';

  @override
  String get doseStatusTaken => 'Assunta';

  @override
  String get doseStatusSkipped => 'Saltata';

  @override
  String get doseStatusPending => 'In sospeso';

  @override
  String get durationContinuous => 'Continuo';

  @override
  String get durationSpecificDates => 'Date specifiche';

  @override
  String get durationAsNeeded => 'Al bisogno';

  @override
  String get mainScreenTitle => 'I Miei Farmaci';

  @override
  String get mainScreenEmptyTitle => 'Nessun farmaco registrato';

  @override
  String get mainScreenEmptySubtitle => 'Aggiungi farmaci usando il pulsante +';

  @override
  String get mainScreenTodayDoses => 'Assunzioni di oggi';

  @override
  String get mainScreenNoMedications => 'Non hai farmaci attivi';

  @override
  String get msgMedicationAdded => 'Farmaco aggiunto correttamente';

  @override
  String get msgMedicationUpdated => 'Farmaco aggiornato correttamente';

  @override
  String msgMedicationDeleted(String name) {
    return '$name eliminato correttamente';
  }

  @override
  String get validationRequired => 'Questo campo è obbligatorio';

  @override
  String get validationDuplicateMedication => 'Questo farmaco esiste già nella tua lista';

  @override
  String get validationInvalidNumber => 'Inserisci un numero valido';

  @override
  String validationMinValue(num min) {
    return 'Il valore deve essere maggiore di $min';
  }

  @override
  String get pillOrganizerTitle => 'Portapillole';

  @override
  String get pillOrganizerTotal => 'Totale';

  @override
  String get pillOrganizerLowStock => 'Stock basso';

  @override
  String get pillOrganizerNoStock => 'Senza stock';

  @override
  String get pillOrganizerAvailableStock => 'Stock disponibile';

  @override
  String get pillOrganizerMedicationsTitle => 'Farmaci';

  @override
  String get pillOrganizerEmptyTitle => 'Nessun farmaco registrato';

  @override
  String get pillOrganizerEmptySubtitle => 'Aggiungi farmaci per vedere il tuo portapillole';

  @override
  String get pillOrganizerCurrentStock => 'Stock attuale';

  @override
  String get pillOrganizerEstimatedDuration => 'Durata stimata';

  @override
  String get pillOrganizerDays => 'giorni';

  @override
  String get medicineCabinetTitle => 'Armadietto dei Farmaci';

  @override
  String get medicineCabinetSearchHint => 'Cerca farmaco...';

  @override
  String get medicineCabinetEmptyTitle => 'Nessun farmaco registrato';

  @override
  String get medicineCabinetEmptySubtitle => 'Aggiungi farmaci per vedere il tuo armadietto';

  @override
  String get medicineCabinetPullToRefresh => 'Trascina verso il basso per ricaricare';

  @override
  String get medicineCabinetNoResults => 'Nessun farmaco trovato';

  @override
  String get medicineCabinetNoResultsHint => 'Prova con un altro termine di ricerca';

  @override
  String get medicineCabinetStock => 'Stock:';

  @override
  String get medicineCabinetSuspended => 'Sospeso';

  @override
  String get medicineCabinetTapToRegister => 'Tocca per registrare';

  @override
  String get medicineCabinetResumeMedication => 'Riprendere farmaco';

  @override
  String get medicineCabinetRegisterDose => 'Registrare assunzione';

  @override
  String get medicineCabinetRefillMedication => 'Ricaricare farmaco';

  @override
  String get medicineCabinetEditMedication => 'Modificare farmaco';

  @override
  String get medicineCabinetDeleteMedication => 'Eliminare farmaco';

  @override
  String medicineCabinetRefillTitle(String name) {
    return 'Ricaricare $name';
  }

  @override
  String medicineCabinetRegisterDoseTitle(String name) {
    return 'Registrare assunzione di $name';
  }

  @override
  String get medicineCabinetCurrentStock => 'Stock attuale:';

  @override
  String get medicineCabinetAddQuantity => 'Quantità da aggiungere:';

  @override
  String get medicineCabinetAddQuantityLabel => 'Quantità da aggiungere';

  @override
  String get medicineCabinetExample => 'Es:';

  @override
  String get medicineCabinetLastRefill => 'Ultima ricarica:';

  @override
  String get medicineCabinetRefillButton => 'Ricarica';

  @override
  String get medicineCabinetAvailableStock => 'Stock disponibile:';

  @override
  String get medicineCabinetDoseTaken => 'Quantità assunta';

  @override
  String get medicineCabinetRegisterButton => 'Registra';

  @override
  String get medicineCabinetNewStock => 'Nuovo stock:';

  @override
  String get medicineCabinetDeleteConfirmTitle => 'Eliminare farmaco';

  @override
  String medicineCabinetDeleteConfirmMessage(String name) {
    return 'Sei sicuro di voler eliminare \"$name\"?\n\nQuesta azione non può essere annullata e tutta la cronologia di questo farmaco andrà persa.';
  }

  @override
  String get medicineCabinetNoStockAvailable => 'Non c\'è stock disponibile di questo farmaco';

  @override
  String medicineCabinetInsufficientStock(String needed, String unit, String available) {
    return 'Stock insufficiente per questa assunzione\nNecessario: $needed $unit\nDisponibile: $available';
  }

  @override
  String medicineCabinetRefillSuccess(String name, String amount, String unit, String newStock) {
    return 'Stock di $name ricaricato\nAggiunto: $amount $unit\nNuovo stock: $newStock';
  }

  @override
  String medicineCabinetDoseRegistered(String name, String amount, String unit, String remaining) {
    return 'Assunzione di $name registrata\nQuantità: $amount $unit\nStock rimanente: $remaining';
  }

  @override
  String medicineCabinetDeleteSuccess(String name) {
    return '$name eliminato correttamente';
  }

  @override
  String medicineCabinetResumeSuccess(String name) {
    return '$name ripreso correttamente\nNotifiche riprogrammate';
  }

  @override
  String get doseHistoryTitle => 'Cronologia delle Assunzioni';

  @override
  String get doseHistoryFilterTitle => 'Filtra cronologia';

  @override
  String get doseHistoryMedicationLabel => 'Farmaco:';

  @override
  String get doseHistoryAllMedications => 'Tutti i farmaci';

  @override
  String get doseHistoryDateRangeLabel => 'Intervallo di date:';

  @override
  String get doseHistoryClearDates => 'Cancella date';

  @override
  String get doseHistoryApply => 'Applica';

  @override
  String get doseHistoryTotal => 'Totale';

  @override
  String get doseHistoryTaken => 'Assunte';

  @override
  String get doseHistorySkipped => 'Saltate';

  @override
  String get doseHistoryClear => 'Cancella';

  @override
  String doseHistoryEditEntry(String name) {
    return 'Modificare registrazione di $name';
  }

  @override
  String get doseHistoryScheduledTime => 'Orario programmato:';

  @override
  String get doseHistoryActualTime => 'Orario reale:';

  @override
  String get doseHistoryStatus => 'Stato:';

  @override
  String get doseHistoryMarkAsSkipped => 'Segnare come Saltata';

  @override
  String get doseHistoryMarkAsTaken => 'Segnare come Assunta';

  @override
  String get doseHistoryConfirmDelete => 'Confermare eliminazione';

  @override
  String get doseHistoryConfirmDeleteMessage => 'Sei sicuro di voler eliminare questa registrazione?';

  @override
  String get doseHistoryRecordDeleted => 'Registrazione eliminata correttamente';

  @override
  String doseHistoryDeleteError(String error) {
    return 'Errore durante l\'eliminazione: $error';
  }

  @override
  String get changeRegisteredTime => 'Modificare orario di registrazione';

  @override
  String get selectRegisteredTime => 'Selezionare orario di registrazione';

  @override
  String get registeredTimeLabel => 'Orario di registrazione:';

  @override
  String get registeredTimeUpdated => 'Orario di registrazione aggiornato';

  @override
  String errorUpdatingTime(String error) {
    return 'Errore durante l\'aggiornamento dell\'orario: $error';
  }

  @override
  String get errorFindingDoseEntry => 'Registrazione della dose non trovata';

  @override
  String get registeredTimeCannotBeFuture => 'L\'orario di registrazione non può essere nel futuro';

  @override
  String get errorLabel => 'Errore';

  @override
  String get addMedicationTitle => 'Aggiungi Farmaco';

  @override
  String stepIndicator(int current, int total) {
    return 'Passo $current di $total';
  }

  @override
  String get medicationInfoTitle => 'Informazioni sul farmaco';

  @override
  String get medicationInfoSubtitle => 'Inizia fornendo il nome e il tipo di farmaco';

  @override
  String get medicationNameLabel => 'Nome del farmaco';

  @override
  String get medicationNameHint => 'Es: Paracetamolo';

  @override
  String get medicationTypeLabel => 'Tipo di farmaco';

  @override
  String get validationMedicationName => 'Per favore, inserisci il nome del farmaco';

  @override
  String get medicationDurationTitle => 'Tipo di Trattamento';

  @override
  String get medicationDurationSubtitle => 'Come prenderai questo farmaco?';

  @override
  String get durationContinuousTitle => 'Trattamento continuo';

  @override
  String get durationContinuousDesc => 'Tutti i giorni, con schema regolare';

  @override
  String get durationUntilEmptyTitle => 'Fino a esaurimento farmaco';

  @override
  String get durationUntilEmptyDesc => 'Termina quando finisce lo stock';

  @override
  String get durationSpecificDatesTitle => 'Date specifiche';

  @override
  String get durationSpecificDatesDesc => 'Solo giorni specifici selezionati';

  @override
  String get durationAsNeededTitle => 'Farmaco occasionale';

  @override
  String get durationAsNeededDesc => 'Solo quando necessario, senza orari';

  @override
  String get selectDatesButton => 'Selezionare date';

  @override
  String get selectDatesTitle => 'Seleziona le date';

  @override
  String get selectDatesSubtitle => 'Scegli i giorni esatti in cui prenderai il farmaco';

  @override
  String dateSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count date selezionate',
      one: '1 data selezionata',
    );
    return '$_temp0';
  }

  @override
  String get validationSelectDates => 'Per favore, seleziona almeno una data';

  @override
  String get medicationDatesTitle => 'Date del Trattamento';

  @override
  String get medicationDatesSubtitle => 'Quando inizierai e terminerai questo trattamento?';

  @override
  String get medicationDatesHelp => 'Entrambe le date sono opzionali. Se non le imposti, il trattamento inizierà oggi e non avrà data di fine.';

  @override
  String get startDateLabel => 'Data di inizio';

  @override
  String get startDateOptional => 'Opzionale';

  @override
  String get startDateDefault => 'Inizia oggi';

  @override
  String get endDateLabel => 'Data di fine';

  @override
  String get endDateDefault => 'Senza data di fine';

  @override
  String get startDatePickerTitle => 'Data di inizio del trattamento';

  @override
  String get endDatePickerTitle => 'Data di fine del trattamento';

  @override
  String get startTodayButton => 'Inizia oggi';

  @override
  String get noEndDateButton => 'Senza data di fine';

  @override
  String treatmentDuration(int days) {
    return 'Trattamento di $days giorni';
  }

  @override
  String get medicationFrequencyTitle => 'Frequenza di Assunzione';

  @override
  String get medicationFrequencySubtitle => 'Ogni quanti giorni devi prendere questo farmaco';

  @override
  String get frequencyDailyTitle => 'Tutti i giorni';

  @override
  String get frequencyDailyDesc => 'Farmaco giornaliero continuo';

  @override
  String get frequencyAlternateTitle => 'Giorni alterni';

  @override
  String get frequencyAlternateDesc => 'Ogni 2 giorni dall\'inizio del trattamento';

  @override
  String get frequencyWeeklyTitle => 'Giorni della settimana specifici';

  @override
  String get frequencyWeeklyDesc => 'Seleziona quali giorni prendere il farmaco';

  @override
  String get selectWeeklyDaysButton => 'Selezionare giorni';

  @override
  String get selectWeeklyDaysTitle => 'Giorni della settimana';

  @override
  String get selectWeeklyDaysSubtitle => 'Seleziona i giorni specifici in cui prenderai il farmaco';

  @override
  String daySelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giorni selezionati',
      one: '1 giorno selezionato',
    );
    return '$_temp0';
  }

  @override
  String get validationSelectWeekdays => 'Per favore, seleziona i giorni della settimana';

  @override
  String get medicationDosageTitle => 'Configurazione delle Dosi';

  @override
  String get medicationDosageSubtitle => 'Come preferisci configurare le dosi giornaliere?';

  @override
  String get dosageFixedTitle => 'Tutti i giorni uguale';

  @override
  String get dosageFixedDesc => 'Specifica ogni quante ore prendere il farmaco';

  @override
  String get dosageCustomTitle => 'Personalizzato';

  @override
  String get dosageCustomDesc => 'Definisci il numero di assunzioni al giorno';

  @override
  String get dosageIntervalLabel => 'Intervallo tra assunzioni';

  @override
  String get dosageIntervalHelp => 'L\'intervallo deve dividere 24 esattamente';

  @override
  String get dosageIntervalFieldLabel => 'Ogni quante ore';

  @override
  String get dosageIntervalHint => 'Es: 8';

  @override
  String get dosageIntervalUnit => 'ore';

  @override
  String get dosageIntervalValidValues => 'Valori validi: 1, 2, 3, 4, 6, 8, 12, 24';

  @override
  String get dosageTimesLabel => 'Numero di assunzioni al giorno';

  @override
  String get dosageTimesHelp => 'Definisci quante volte al giorno prenderai il farmaco';

  @override
  String get dosageTimesFieldLabel => 'Assunzioni al giorno';

  @override
  String get dosageTimesHint => 'Es: 3';

  @override
  String get dosageTimesUnit => 'assunzioni';

  @override
  String get dosageTimesDescription => 'Numero totale di assunzioni giornaliere';

  @override
  String get dosesPerDay => 'Assunzioni al giorno';

  @override
  String doseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count assunzioni',
      one: '1 assunzione',
    );
    return '$_temp0';
  }

  @override
  String get validationInvalidInterval => 'Per favore, inserisci un intervallo valido';

  @override
  String get validationIntervalTooLarge => 'L\'intervallo non può essere maggiore di 24 ore';

  @override
  String get validationIntervalNotDivisor => 'L\'intervallo deve dividere 24 esattamente (1, 2, 3, 4, 6, 8, 12, 24)';

  @override
  String get validationInvalidDoseCount => 'Per favore, inserisci un numero di assunzioni valido';

  @override
  String get validationTooManyDoses => 'Non puoi assumere più di 24 dosi al giorno';

  @override
  String get medicationTimesTitle => 'Orario delle Assunzioni';

  @override
  String dosesPerDayLabel(int count) {
    return 'Assunzioni al giorno: $count';
  }

  @override
  String frequencyEveryHours(int hours) {
    return 'Frequenza: Ogni $hours ore';
  }

  @override
  String get selectTimeAndAmount => 'Seleziona l\'orario e la quantità di ogni assunzione';

  @override
  String doseNumber(int number) {
    return 'Assunzione $number';
  }

  @override
  String get selectTimeButton => 'Selezionare orario';

  @override
  String get amountPerDose => 'Quantità per assunzione';

  @override
  String get amountHint => 'Es: 1, 0.5, 2';

  @override
  String get removeDoseButton => 'Eliminare assunzione';

  @override
  String get validationSelectAllTimes => 'Per favore, seleziona tutti gli orari delle assunzioni';

  @override
  String get validationEnterValidAmounts => 'Per favore, inserisci quantità valide (maggiori di 0)';

  @override
  String get validationDuplicateTimes => 'Gli orari delle assunzioni non possono essere duplicati';

  @override
  String get validationAtLeastOneDose => 'Deve esserci almeno un\'assunzione al giorno';

  @override
  String get medicationFastingTitle => 'Configurazione del Digiuno';

  @override
  String get fastingLabel => 'Digiuno';

  @override
  String get fastingHelp => 'Alcuni farmaci richiedono digiuno prima o dopo l\'assunzione';

  @override
  String get requiresFastingQuestion => 'Questo farmaco richiede digiuno?';

  @override
  String get fastingNo => 'No';

  @override
  String get fastingYes => 'Sì';

  @override
  String get fastingWhenQuestion => 'Quando è il digiuno?';

  @override
  String get fastingBefore => 'Prima dell\'assunzione';

  @override
  String get fastingAfter => 'Dopo l\'assunzione';

  @override
  String get fastingDurationQuestion => 'Quanto tempo di digiuno?';

  @override
  String get fastingHours => 'Ore';

  @override
  String get fastingMinutes => 'Minuti';

  @override
  String get fastingNotificationsQuestion => 'Desideri ricevere notifiche di digiuno?';

  @override
  String get fastingNotificationBeforeHelp => 'Ti avviseremo quando devi smettere di mangiare prima dell\'assunzione';

  @override
  String get fastingNotificationAfterHelp => 'Ti avviseremo quando potrai mangiare di nuovo dopo l\'assunzione';

  @override
  String get fastingNotificationsOn => 'Notifiche attivate';

  @override
  String get fastingNotificationsOff => 'Notifiche disattivate';

  @override
  String get validationCompleteAllFields => 'Per favore, completa tutti i campi';

  @override
  String get validationSelectFastingWhen => 'Per favore, seleziona quando è il digiuno';

  @override
  String get validationFastingDuration => 'La durata del digiuno deve essere almeno 1 minuto';

  @override
  String get medicationQuantityTitle => 'Quantità di Farmaco';

  @override
  String get medicationQuantitySubtitle => 'Imposta la quantità disponibile e quando desideri ricevere avvisi';

  @override
  String get availableQuantityLabel => 'Quantità disponibile';

  @override
  String get availableQuantityHint => 'Es: 30';

  @override
  String availableQuantityHelp(String unit) {
    return 'Quantità di $unit che hai attualmente';
  }

  @override
  String get lowStockAlertLabel => 'Avvisa quando rimangono';

  @override
  String get lowStockAlertHint => 'Es: 3';

  @override
  String get lowStockAlertUnit => 'giorni';

  @override
  String get lowStockAlertHelp => 'Giorni di anticipo per ricevere l\'avviso di stock basso';

  @override
  String get validationEnterQuantity => 'Per favore, inserisci la quantità disponibile';

  @override
  String get validationQuantityNonNegative => 'La quantità deve essere maggiore o uguale a 0';

  @override
  String get validationEnterAlertDays => 'Per favore, inserisci i giorni di anticipo';

  @override
  String get validationAlertMinDays => 'Deve essere almeno 1 giorno';

  @override
  String get validationAlertMaxDays => 'Non può essere maggiore di 30 giorni';

  @override
  String get summaryTitle => 'Riepilogo';

  @override
  String get summaryMedication => 'Farmaco';

  @override
  String get summaryType => 'Tipo';

  @override
  String get summaryDosesPerDay => 'Assunzioni al giorno';

  @override
  String get summarySchedules => 'Orari';

  @override
  String get summaryFrequency => 'Frequenza';

  @override
  String get summaryFrequencyDaily => 'Tutti i giorni';

  @override
  String get summaryFrequencyUntilEmpty => 'Fino a esaurimento farmaco';

  @override
  String summaryFrequencySpecificDates(int count) {
    return '$count date specifiche';
  }

  @override
  String summaryFrequencyWeekdays(int count) {
    return '$count giorni della settimana';
  }

  @override
  String summaryFrequencyEveryNDays(int days) {
    return 'Ogni $days giorni';
  }

  @override
  String get summaryFrequencyAsNeeded => 'Al bisogno';

  @override
  String msgMedicationAddedSuccess(String name) {
    return '$name aggiunto correttamente';
  }

  @override
  String msgMedicationAssignedSuccess(String name) {
    return '$name asignado correctamente';
  }

  @override
  String msgUsingSharedStock(String name) {
    return 'Usando stock compartido de \'$name\'. Si cambias la cantidad, se actualizará para todos.';
  }

  @override
  String msgMedicationAddError(String error) {
    return 'Errore durante il salvataggio del farmaco: $error';
  }

  @override
  String get saveMedicationButton => 'Salva Farmaco';

  @override
  String get savingButton => 'Salvataggio...';

  @override
  String get doseActionTitle => 'Azione Assunzione';

  @override
  String get doseActionLoading => 'Caricamento...';

  @override
  String get doseActionError => 'Errore';

  @override
  String get doseActionMedicationNotFound => 'Farmaco non trovato';

  @override
  String get doseActionBack => 'Indietro';

  @override
  String doseActionScheduledTime(String time) {
    return 'Orario programmato: $time';
  }

  @override
  String get doseActionThisDoseQuantity => 'Quantità di questa assunzione';

  @override
  String get doseActionWhatToDo => 'Cosa desideri fare?';

  @override
  String get doseActionRegisterTaken => 'Registrare assunzione';

  @override
  String get doseActionWillDeductStock => 'Verrà detratto dallo stock';

  @override
  String get doseActionMarkAsNotTaken => 'Segnare come non assunta';

  @override
  String get doseActionWillNotDeductStock => 'Non verrà detratto dallo stock';

  @override
  String get doseActionPostpone15Min => 'Posticipare 15 minuti';

  @override
  String get doseActionQuickReminder => 'Promemoria rapido';

  @override
  String get doseActionPostponeCustom => 'Posticipare (scegliere orario)';

  @override
  String doseActionInsufficientStock(String needed, String unit, String available) {
    return 'Stock insufficiente per questa assunzione\nNecessario: $needed $unit\nDisponibile: $available';
  }

  @override
  String doseActionTakenRegistered(String name, String time, String stock) {
    return 'Assunzione di $name registrata alle $time\nStock rimanente: $stock';
  }

  @override
  String doseActionSkippedRegistered(String name, String time, String stock) {
    return 'Assunzione di $name segnata come non assunta alle $time\nStock: $stock (senza modifiche)';
  }

  @override
  String doseActionPostponed(String name, String time) {
    return 'Assunzione di $name posticipata\nNuovo orario: $time';
  }

  @override
  String doseActionPostponed15(String name, String time) {
    return 'Assunzione di $name posticipata di 15 minuti\nNuovo orario: $time';
  }

  @override
  String get editMedicationMenuTitle => 'Modificare Farmaco';

  @override
  String get editMedicationMenuWhatToEdit => 'Cosa desideri modificare?';

  @override
  String get editMedicationMenuSelectSection => 'Seleziona la sezione che desideri modificare';

  @override
  String get editMedicationMenuBasicInfo => 'Informazioni di Base';

  @override
  String get editMedicationMenuBasicInfoDesc => 'Nome e tipo di farmaco';

  @override
  String get editMedicationMenuDuration => 'Durata del Trattamento';

  @override
  String get editMedicationMenuFrequency => 'Frequenza';

  @override
  String get editMedicationMenuSchedules => 'Orari e Quantità';

  @override
  String editMedicationMenuSchedulesDesc(int count) {
    return '$count assunzioni al giorno';
  }

  @override
  String get editMedicationMenuFasting => 'Configurazione del Digiuno';

  @override
  String get editMedicationMenuQuantity => 'Quantità Disponibile';

  @override
  String editMedicationMenuQuantityDesc(String quantity, String unit) {
    return '$quantity $unit';
  }

  @override
  String get editMedicationMenuFreqEveryday => 'Tutti i giorni';

  @override
  String get editMedicationMenuFreqUntilFinished => 'Fino a esaurimento farmaco';

  @override
  String editMedicationMenuFreqSpecificDates(int count) {
    return '$count date specifiche';
  }

  @override
  String editMedicationMenuFreqWeeklyDays(int count) {
    return '$count giorni della settimana';
  }

  @override
  String editMedicationMenuFreqInterval(int interval) {
    return 'Ogni $interval giorni';
  }

  @override
  String get editMedicationMenuFreqNotDefined => 'Frequenza non definita';

  @override
  String get editMedicationMenuFastingNone => 'Senza digiuno';

  @override
  String editMedicationMenuFastingDuration(String duration, String type) {
    return 'Digiuno $duration $type';
  }

  @override
  String get editMedicationMenuFastingBefore => 'prima';

  @override
  String get editMedicationMenuFastingAfter => 'dopo';

  @override
  String get editBasicInfoTitle => 'Modificare Informazioni di Base';

  @override
  String get editBasicInfoUpdated => 'Informazioni aggiornate correttamente';

  @override
  String get editBasicInfoSaving => 'Salvataggio...';

  @override
  String get editBasicInfoSaveChanges => 'Salvare Modifiche';

  @override
  String editBasicInfoError(String error) {
    return 'Errore durante il salvataggio delle modifiche: $error';
  }

  @override
  String get editDurationTitle => 'Modificare Durata';

  @override
  String get editDurationTypeLabel => 'Tipo di durata';

  @override
  String editDurationCurrentType(String type) {
    return 'Tipo attuale: $type';
  }

  @override
  String get editDurationChangeTypeInfo => 'Per cambiare il tipo di durata, modifica la sezione \"Frequenza\"';

  @override
  String get editDurationTreatmentDates => 'Date del trattamento';

  @override
  String get editDurationStartDate => 'Data di inizio';

  @override
  String get editDurationEndDate => 'Data di fine';

  @override
  String get editDurationNotSelected => 'Non selezionata';

  @override
  String editDurationDays(int days) {
    return 'Durata: $days giorni';
  }

  @override
  String get editDurationSelectDates => 'Per favore, seleziona le date di inizio e fine';

  @override
  String get editDurationUpdated => 'Durata aggiornata correttamente';

  @override
  String editDurationError(String error) {
    return 'Errore durante il salvataggio delle modifiche: $error';
  }

  @override
  String get editFastingTitle => 'Modificare Configurazione del Digiuno';

  @override
  String get editFastingCompleteFields => 'Per favore, completa tutti i campi';

  @override
  String get editFastingSelectWhen => 'Per favore, seleziona quando è il digiuno';

  @override
  String get editFastingMinDuration => 'La durata del digiuno deve essere almeno 1 minuto';

  @override
  String get editFastingUpdated => 'Configurazione del digiuno aggiornata correttamente';

  @override
  String editFastingError(String error) {
    return 'Errore durante il salvataggio delle modifiche: $error';
  }

  @override
  String get editFrequencyTitle => 'Modificare Frequenza';

  @override
  String get editFrequencyPattern => 'Schema di frequenza';

  @override
  String get editFrequencyQuestion => 'Con quale frequenza prenderai questo farmaco?';

  @override
  String get editFrequencyEveryday => 'Tutti i giorni';

  @override
  String get editFrequencyEverydayDesc => 'Assumere il farmaco quotidianamente';

  @override
  String get editFrequencyUntilFinished => 'Fino a esaurimento';

  @override
  String get editFrequencyUntilFinishedDesc => 'Fino a quando finisce il farmaco';

  @override
  String get editFrequencySpecificDates => 'Date specifiche';

  @override
  String get editFrequencySpecificDatesDesc => 'Selezionare date specifiche';

  @override
  String get editFrequencyWeeklyDays => 'Giorni della settimana';

  @override
  String get editFrequencyWeeklyDaysDesc => 'Selezionare giorni specifici ogni settimana';

  @override
  String get editFrequencyAlternateDays => 'Giorni alterni';

  @override
  String get editFrequencyAlternateDaysDesc => 'Ogni 2 giorni dall\'inizio del trattamento';

  @override
  String get editFrequencyCustomInterval => 'Intervallo personalizzato';

  @override
  String get editFrequencyCustomIntervalDesc => 'Ogni N giorni dall\'inizio';

  @override
  String get editFrequencySelectedDates => 'Date selezionate';

  @override
  String editFrequencyDatesCount(int count) {
    return '$count date selezionate';
  }

  @override
  String get editFrequencyNoDatesSelected => 'Nessuna data selezionata';

  @override
  String get editFrequencySelectDatesButton => 'Selezionare date';

  @override
  String get editFrequencyWeeklyDaysLabel => 'Giorni della settimana';

  @override
  String editFrequencyWeeklyDaysCount(int count) {
    return '$count giorni selezionati';
  }

  @override
  String get editFrequencyNoDaysSelected => 'Nessun giorno selezionato';

  @override
  String get editFrequencySelectDaysButton => 'Selezionare giorni';

  @override
  String get editFrequencyIntervalLabel => 'Intervallo di giorni';

  @override
  String get editFrequencyIntervalField => 'Ogni quanti giorni';

  @override
  String get editFrequencyIntervalHint => 'Es: 3';

  @override
  String get editFrequencyIntervalHelp => 'Deve essere almeno 2 giorni';

  @override
  String get editFrequencySelectAtLeastOneDate => 'Per favore, seleziona almeno una data';

  @override
  String get editFrequencySelectAtLeastOneDay => 'Per favore, seleziona almeno un giorno della settimana';

  @override
  String get editFrequencyIntervalMin => 'L\'intervallo deve essere almeno 2 giorni';

  @override
  String get editFrequencyUpdated => 'Frequenza aggiornata correttamente';

  @override
  String editFrequencyError(String error) {
    return 'Errore durante il salvataggio delle modifiche: $error';
  }

  @override
  String get editQuantityTitle => 'Modificare Quantità';

  @override
  String get editQuantityMedicationLabel => 'Quantità di farmaco';

  @override
  String get editQuantityDescription => 'Imposta la quantità disponibile e quando desideri ricevere avvisi';

  @override
  String get editQuantityAvailableLabel => 'Quantità disponibile';

  @override
  String editQuantityAvailableHelp(String unit) {
    return 'Quantità di $unit che hai attualmente';
  }

  @override
  String get editQuantityValidationRequired => 'Per favore, inserisci la quantità disponibile';

  @override
  String get editQuantityValidationMin => 'La quantità deve essere maggiore o uguale a 0';

  @override
  String get editQuantityThresholdLabel => 'Avvisa quando rimangono';

  @override
  String get editQuantityThresholdHelp => 'Giorni di anticipo per ricevere l\'avviso di stock basso';

  @override
  String get editQuantityThresholdValidationRequired => 'Per favore, inserisci i giorni di anticipo';

  @override
  String get editQuantityThresholdValidationMin => 'Deve essere almeno 1 giorno';

  @override
  String get editQuantityThresholdValidationMax => 'Non può essere maggiore di 30 giorni';

  @override
  String get editQuantityUpdated => 'Quantità aggiornata correttamente';

  @override
  String editQuantityError(String error) {
    return 'Errore durante il salvataggio delle modifiche: $error';
  }

  @override
  String get editScheduleTitle => 'Modificare Orari';

  @override
  String get editScheduleAddDose => 'Aggiungere assunzione';

  @override
  String get editScheduleValidationQuantities => 'Per favore, inserisci quantità valide (maggiori di 0)';

  @override
  String get editScheduleValidationDuplicates => 'Gli orari delle assunzioni non possono essere duplicati';

  @override
  String get editScheduleUpdated => 'Orari aggiornati correttamente';

  @override
  String editScheduleError(String error) {
    return 'Errore durante il salvataggio delle modifiche: $error';
  }

  @override
  String editScheduleDosesPerDay(int count) {
    return 'Assunzioni al giorno: $count';
  }

  @override
  String get editScheduleAdjustTimeAndQuantity => 'Regola l\'orario e la quantità di ogni assunzione';

  @override
  String get specificDatesSelectorTitle => 'Date specifiche';

  @override
  String get specificDatesSelectorSelectDates => 'Seleziona date';

  @override
  String get specificDatesSelectorDescription => 'Scegli le date specifiche in cui prenderai questo farmaco';

  @override
  String get specificDatesSelectorAddDate => 'Aggiungere data';

  @override
  String specificDatesSelectorSelectedDates(int count) {
    return 'Date selezionate ($count)';
  }

  @override
  String get specificDatesSelectorToday => 'OGGI';

  @override
  String get specificDatesSelectorContinue => 'Continua';

  @override
  String get specificDatesSelectorAlreadySelected => 'Questa data è già selezionata';

  @override
  String get specificDatesSelectorSelectAtLeastOne => 'Seleziona almeno una data';

  @override
  String get specificDatesSelectorPickerHelp => 'Seleziona una data';

  @override
  String get specificDatesSelectorPickerCancel => 'Annulla';

  @override
  String get specificDatesSelectorPickerConfirm => 'Accetta';

  @override
  String get weeklyDaysSelectorTitle => 'Giorni della settimana';

  @override
  String get weeklyDaysSelectorSelectDays => 'Seleziona i giorni';

  @override
  String get weeklyDaysSelectorDescription => 'Scegli quali giorni della settimana prenderai questo farmaco';

  @override
  String weeklyDaysSelectorSelectedCount(int count, String plural) {
    return '$count giorno$plural selezionato$plural';
  }

  @override
  String get weeklyDaysSelectorContinue => 'Continua';

  @override
  String get weeklyDaysSelectorSelectAtLeastOne => 'Seleziona almeno un giorno della settimana';

  @override
  String get weeklyDayMonday => 'Lunedì';

  @override
  String get weeklyDayTuesday => 'Martedì';

  @override
  String get weeklyDayWednesday => 'Mercoledì';

  @override
  String get weeklyDayThursday => 'Giovedì';

  @override
  String get weeklyDayFriday => 'Venerdì';

  @override
  String get weeklyDaySaturday => 'Sabato';

  @override
  String get weeklyDaySunday => 'Domenica';

  @override
  String get dateFromLabel => 'Da';

  @override
  String get dateToLabel => 'A';

  @override
  String get statisticsTitle => 'Statistiche';

  @override
  String get adherenceLabel => 'Aderenza';

  @override
  String get emptyDosesWithFilters => 'Nessuna assunzione con questi filtri';

  @override
  String get emptyDoses => 'Nessuna assunzione registrata';

  @override
  String get permissionRequired => 'Permesso necessario';

  @override
  String get notNowButton => 'Non ora';

  @override
  String get openSettingsButton => 'Apri impostazioni';

  @override
  String medicationUpdatedMsg(String name) {
    return '$name aggiornato';
  }

  @override
  String get noScheduledTimes => 'Questo farmaco non ha orari configurati';

  @override
  String get allDosesTakenToday => 'Hai già assunto tutte le dosi di oggi';

  @override
  String get extraDoseOption => 'Dose extra';

  @override
  String extraDoseConfirmationMessage(String name) {
    return 'Hai già registrato tutte le assunzioni programmate di oggi. Vuoi registrare una dose extra di $name?';
  }

  @override
  String get extraDoseConfirm => 'Registrare dose extra';

  @override
  String extraDoseRegistered(String name, String time, String stock) {
    return 'Dose extra di $name registrata alle $time ($stock disponibile)';
  }

  @override
  String registerDoseOfMedication(String name) {
    return 'Registrare assunzione di $name';
  }

  @override
  String refillMedicationTitle(String name) {
    return 'Ricaricare $name';
  }

  @override
  String doseRegisteredAt(String time) {
    return 'Registrata alle $time';
  }

  @override
  String statusUpdatedTo(String status) {
    return 'Stato aggiornato a: $status';
  }

  @override
  String get dateLabel => 'Data:';

  @override
  String get scheduledTimeLabel => 'Orario programmato:';

  @override
  String get currentStatusLabel => 'Stato attuale:';

  @override
  String get changeStatusToQuestion => 'Cambiare stato a:';

  @override
  String get filterApplied => 'Filtro applicato';

  @override
  String filterFrom(String date) {
    return 'Da $date';
  }

  @override
  String filterTo(String date) {
    return 'Fino a $date';
  }

  @override
  String get insufficientStockForDose => 'Stock insufficiente per segnare come assunta';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsDisplaySection => 'Visualizzazione';

  @override
  String get settingsShowActualTimeTitle => 'Mostrare orario reale dell\'assunzione';

  @override
  String get settingsShowActualTimeSubtitle => 'Mostra l\'orario reale in cui sono state assunte le dosi invece dell\'orario programmato';

  @override
  String get settingsShowFastingCountdownTitle => 'Mostrare conto alla rovescia del digiuno';

  @override
  String get settingsShowFastingCountdownSubtitle => 'Mostra il tempo rimanente del digiuno nella schermata principale';

  @override
  String get settingsShowFastingNotificationTitle => 'Notifica fissa del conto alla rovescia';

  @override
  String get settingsShowFastingNotificationSubtitle => 'Mostra una notifica fissa con il tempo rimanente del digiuno (solo Android)';

  @override
  String get settingsShowPersonTabsTitle => 'Vedere persone separate per schede';

  @override
  String get settingsShowPersonTabsSubtitle => 'Mostra ogni persona in una scheda separata. Se disattivato, tutte le persone vengono mescolate in un\'unica lista con etichette';

  @override
  String get selectPerson => 'Selezionare persona';

  @override
  String get fastingNotificationTitle => 'Digiuno in corso';

  @override
  String fastingNotificationBody(String medication, String timeRemaining, String endTime) {
    return '$medication • $timeRemaining rimanenti (fino alle $endTime)';
  }

  @override
  String fastingRemainingMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String fastingRemainingHours(int hours) {
    return '${hours}h';
  }

  @override
  String fastingRemainingHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String fastingActive(String time, String endTime) {
    return 'Digiuno: $time rimanenti (fino alle $endTime)';
  }

  @override
  String fastingUpcoming(String time, String endTime) {
    return 'Prossimo digiuno: $time (fino alle $endTime)';
  }

  @override
  String get settingsBackupSection => 'Copia di Sicurezza';

  @override
  String get settingsExportTitle => 'Esportare Database';

  @override
  String get settingsExportSubtitle => 'Salva una copia di tutti i tuoi farmaci e cronologia';

  @override
  String get settingsImportTitle => 'Importare Database';

  @override
  String get settingsImportSubtitle => 'Ripristina una copia di sicurezza precedentemente esportata';

  @override
  String get settingsInfoTitle => 'Informazioni';

  @override
  String get settingsInfoContent => '• Esportando, verrà creato un file di backup che potrai salvare sul tuo dispositivo o condividere.\n\n• Importando, tutti i dati attuali verranno sostituiti con quelli del file selezionato.\n\n• Si consiglia di fare copie di sicurezza regolarmente.';

  @override
  String get settingsShareText => 'Copia di sicurezza di MedicApp';

  @override
  String get settingsExportSuccess => 'Database esportato correttamente';

  @override
  String get settingsImportSuccess => 'Database importato correttamente';

  @override
  String settingsExportError(String error) {
    return 'Errore durante l\'esportazione: $error';
  }

  @override
  String settingsImportError(String error) {
    return 'Errore durante l\'importazione: $error';
  }

  @override
  String get settingsFilePathError => 'Non è stato possibile ottenere il percorso del file';

  @override
  String get settingsImportDialogTitle => 'Importare Database';

  @override
  String get settingsImportDialogMessage => 'Questa azione sostituirà tutti i tuoi dati attuali con i dati del file importato.\n\nSei sicuro di voler continuare?';

  @override
  String get settingsRestartDialogTitle => 'Importazione Completata';

  @override
  String get settingsRestartDialogMessage => 'Il database è stato importato correttamente.\n\nPer favore, riavvia l\'applicazione per vedere le modifiche.';

  @override
  String get settingsRestartDialogButton => 'Ho capito';

  @override
  String get notificationsWillNotWork => 'Le notifiche NON funzioneranno senza questo permesso.';

  @override
  String get debugMenuActivated => 'Menu di debug attivato';

  @override
  String get debugMenuDeactivated => 'Menu di debug disattivato';

  @override
  String nextDoseAt(String time) {
    return 'Prossima assunzione: $time';
  }

  @override
  String pendingDose(String time) {
    return '⚠️ Dose in sospeso: $time';
  }

  @override
  String nextDoseTomorrow(String time) {
    return 'Prossima assunzione: domani alle $time';
  }

  @override
  String nextDoseOnDay(String dayName, int day, int month, String time) {
    return 'Prossima assunzione: $dayName $day/$month alle $time';
  }

  @override
  String get dayNameMon => 'Lun';

  @override
  String get dayNameTue => 'Mar';

  @override
  String get dayNameWed => 'Mer';

  @override
  String get dayNameThu => 'Gio';

  @override
  String get dayNameFri => 'Ven';

  @override
  String get dayNameSat => 'Sab';

  @override
  String get dayNameSun => 'Dom';

  @override
  String get whichDoseDidYouTake => 'Quale assunzione hai fatto?';

  @override
  String insufficientStockForThisDose(String needed, String unit, String available) {
    return 'Stock insufficiente per questa assunzione\nNecessario: $needed $unit\nDisponibile: $available';
  }

  @override
  String doseRegisteredAtTime(String name, String time, String stock) {
    return 'Assunzione di $name registrata alle $time\nStock rimanente: $stock';
  }

  @override
  String get allDosesCompletedToday => '✓ Tutte le assunzioni di oggi completate';

  @override
  String remainingDosesToday(int count) {
    return 'Assunzioni rimanenti oggi: $count';
  }

  @override
  String manualDoseRegistered(String name, String quantity, String unit, String stock) {
    return 'Assunzione manuale di $name registrata\nQuantità: $quantity $unit\nStock rimanente: $stock';
  }

  @override
  String medicationSuspended(String name) {
    return '$name sospeso\nNon verranno più programmate notifiche';
  }

  @override
  String medicationReactivated(String name) {
    return '$name riattivato\nNotifiche riprogrammate';
  }

  @override
  String currentStock(String stock) {
    return 'Stock attuale: $stock';
  }

  @override
  String get quantityToAdd => 'Quantità da aggiungere';

  @override
  String example(String example) {
    return 'Es: $example';
  }

  @override
  String lastRefill(String amount, String unit) {
    return 'Ultima ricarica: $amount $unit';
  }

  @override
  String get refillButton => 'Ricarica';

  @override
  String stockRefilled(String name, String amount, String unit, String newStock) {
    return 'Stock di $name ricaricato\nAggiunto: $amount $unit\nNuovo stock: $newStock';
  }

  @override
  String availableStock(String stock) {
    return 'Stock disponibile: $stock';
  }

  @override
  String get quantityTaken => 'Quantità assunta';

  @override
  String get registerButton => 'Registra';

  @override
  String get registerManualDose => 'Registrare assunzione manuale';

  @override
  String get refillMedication => 'Ricaricare farmaco';

  @override
  String get resumeMedication => 'Riattivare farmaco';

  @override
  String get suspendMedication => 'Sospendere farmaco';

  @override
  String get editMedicationButton => 'Modificare farmaco';

  @override
  String get deleteMedicationButton => 'Eliminare farmaco';

  @override
  String medicationDeletedShort(String name) {
    return '$name eliminato';
  }

  @override
  String get noMedicationsRegistered => 'Nessun farmaco registrato';

  @override
  String get addMedicationHint => 'Premi il pulsante + per aggiungerne uno';

  @override
  String get pullToRefresh => 'Trascina verso il basso per ricaricare';

  @override
  String get batteryOptimizationWarning => 'Affinché le notifiche funzionino, disattiva le restrizioni della batteria:';

  @override
  String get batteryOptimizationInstructions => 'Impostazioni → Applicazioni → MedicApp → Batteria → \"Senza restrizioni\"';

  @override
  String get openSettings => 'Apri impostazioni';

  @override
  String get todayDosesLabel => 'Assunzioni di oggi:';

  @override
  String doseOfMedicationAt(String name, String time) {
    return 'Assunzione di $name alle $time';
  }

  @override
  String currentStatus(String status) {
    return 'Stato attuale: $status';
  }

  @override
  String get whatDoYouWantToDo => 'Cosa desideri fare?';

  @override
  String get deleteButton => 'Elimina';

  @override
  String get markAsSkipped => 'Segnare Saltata';

  @override
  String get markAsTaken => 'Segnare Assunta';

  @override
  String doseDeletedAt(String time) {
    return 'Assunzione delle $time eliminata';
  }

  @override
  String errorDeleting(String error) {
    return 'Errore durante l\'eliminazione: $error';
  }

  @override
  String doseMarkedAs(String time, String status) {
    return 'Assunzione delle $time segnata come $status';
  }

  @override
  String errorChangingStatus(String error) {
    return 'Errore durante il cambio di stato: $error';
  }

  @override
  String medicationUpdatedShort(String name) {
    return '$name aggiornato';
  }

  @override
  String get activateAlarmsPermission => 'Attivare \"Allarmi e promemoria\"';

  @override
  String get alarmsPermissionDescription => 'Questo permesso consente alle notifiche di apparire esattamente all\'orario configurato.';

  @override
  String get notificationDebugTitle => 'Debug delle Notifiche';

  @override
  String notificationPermissions(String enabled) {
    return '✓ Permessi di notifica: $enabled';
  }

  @override
  String exactAlarmsAndroid12(String enabled) {
    return '⏰ Allarmi esatti (Android 12+): $enabled';
  }

  @override
  String get importantWarning => '⚠️ IMPORTANTE';

  @override
  String get withoutPermissionNoNotifications => 'Senza questo permesso le notifiche NON appariranno.';

  @override
  String get alarmsSettings => 'Impostazioni → Applicazioni → MedicApp → Allarmi e promemoria';

  @override
  String pendingNotificationsCount(int count) {
    return '📊 Notifiche in sospeso: $count';
  }

  @override
  String medicationsWithSchedules(int withSchedules, int total) {
    return '💊 Farmaci con orari: $withSchedules/$total';
  }

  @override
  String get scheduledNotifications => 'Notifiche programmate:';

  @override
  String get noScheduledNotifications => '⚠️ Nessuna notifica programmata';

  @override
  String get notificationHistory => 'Cronologia delle Notifiche';

  @override
  String get last24Hours => 'Ultime 24 ore';

  @override
  String get noTitle => 'Senza titolo';

  @override
  String get medicationsAndSchedules => 'Farmaci e orari:';

  @override
  String get noSchedulesConfigured => '⚠️ Senza orari configurati';

  @override
  String get closeButton => 'Chiudi';

  @override
  String get testNotification => 'Provare notifica';

  @override
  String get testNotificationSent => 'Notifica di prova inviata';

  @override
  String get testScheduledNotification => 'Provare programmata (1 min)';

  @override
  String get scheduledNotificationInOneMin => 'Notifica programmata per 1 minuto';

  @override
  String get rescheduleNotifications => 'Riprogrammare notifiche';

  @override
  String get notificationsInfo => 'Info notifiche';

  @override
  String notificationsRescheduled(int count) {
    return 'Notifiche riprogrammate: $count';
  }

  @override
  String get yesText => 'Sì';

  @override
  String get noText => 'No';

  @override
  String get notificationTypeDynamicFasting => 'Digiuno dinamico';

  @override
  String get notificationTypeScheduledFasting => 'Digiuno programmato';

  @override
  String get notificationTypeWeeklyPattern => 'Schema settimanale';

  @override
  String get notificationTypeSpecificDate => 'Data specifica';

  @override
  String get notificationTypePostponed => 'Posticipata';

  @override
  String get notificationTypeDailyRecurring => 'Giornaliera ricorrente';

  @override
  String get beforeTaking => 'Prima dell\'assunzione';

  @override
  String get afterTaking => 'Dopo l\'assunzione';

  @override
  String get basedOnActualDose => 'Basato su assunzione reale';

  @override
  String get basedOnSchedule => 'Basato su orario';

  @override
  String today(int day, int month, int year) {
    return 'Oggi $day/$month/$year';
  }

  @override
  String get returnToToday => 'Tornare a oggi';

  @override
  String tomorrow(int day, int month, int year) {
    return 'Domani $day/$month/$year';
  }

  @override
  String get todayOrLater => 'Oggi o successivo';

  @override
  String get pastDueWarning => '⚠️ SCADUTA';

  @override
  String get batteryOptimizationMenu => '⚙️ Ottimizzazione batteria';

  @override
  String get alarmsAndReminders => '⚙️ Allarmi e promemoria';

  @override
  String get notificationTypeScheduledFastingShort => 'Digiuno programmato';

  @override
  String get basedOnActualDoseShort => 'Basato su assunzione reale';

  @override
  String get basedOnScheduleShort => 'Basato su orario';

  @override
  String pendingNotifications(int count) {
    return '📊 Notifiche in sospeso: $count';
  }

  @override
  String medicationsWithSchedulesInfo(int withSchedules, int total) {
    return '💊 Farmaci con orari: $withSchedules/$total';
  }

  @override
  String get noSchedulesConfiguredWarning => '⚠️ Senza orari configurati';

  @override
  String medicationInfo(String name) {
    return '💊 $name';
  }

  @override
  String notificationType(String type) {
    return '📋 Tipo: $type';
  }

  @override
  String scheduleDate(String date) {
    return '📅 Data: $date';
  }

  @override
  String scheduleTime(String time) {
    return '⏰ Orario: $time';
  }

  @override
  String notificationId(int id) {
    return 'ID: $id';
  }

  @override
  String get takenStatus => 'Assunta';

  @override
  String get skippedStatus => 'Saltata';

  @override
  String durationEstimate(String name, String stock, int days) {
    return '$name\nStock: $stock\nDurata stimata: $days giorni';
  }

  @override
  String errorChanging(String error) {
    return 'Errore durante il cambio di stato: $error';
  }

  @override
  String get testScheduled1Min => 'Provare programmata (1 min)';

  @override
  String get alarmsAndRemindersMenu => '⚙️ Allarmi e promemoria';

  @override
  String medicationStockInfo(String name, String stock) {
    return '$name\nStock: $stock';
  }

  @override
  String takenTodaySingle(String quantity, String unit, String time) {
    return 'Assunto oggi: $quantity $unit alle $time';
  }

  @override
  String takenTodayMultiple(int count, String quantity, String unit) {
    return 'Assunto oggi: $count volte ($quantity $unit)';
  }

  @override
  String get done => 'Fatto';

  @override
  String get suspended => 'Sospeso';

  @override
  String get activeFastingPeriodsTitle => 'Digiuni Attivi';

  @override
  String get fastingCompleted => 'Digiuno completato! Ora puoi mangiare';
}
