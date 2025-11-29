// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'MedicApp';

  @override
  String get navMedication => 'Medikation';

  @override
  String get navPillOrganizer => 'Tablettendose';

  @override
  String get navMedicineCabinet => 'Hausapotheke';

  @override
  String get navHistory => 'Verlauf';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get navInventory => 'Inventar';

  @override
  String get navMedicationShort => 'Start';

  @override
  String get navPillOrganizerShort => 'Vorrat';

  @override
  String get navMedicineCabinetShort => 'Apotheke';

  @override
  String get navHistoryShort => 'Verlauf';

  @override
  String get navSettingsShort => 'Einst.';

  @override
  String get navInventoryShort => 'Medikamente';

  @override
  String get btnContinue => 'Weiter';

  @override
  String get btnBack => 'Zurück';

  @override
  String get btnSave => 'Speichern';

  @override
  String get btnCancel => 'Abbrechen';

  @override
  String get btnDelete => 'Löschen';

  @override
  String get btnEdit => 'Bearbeiten';

  @override
  String get btnClose => 'Schließen';

  @override
  String get btnConfirm => 'Bestätigen';

  @override
  String get btnAccept => 'Akzeptieren';

  @override
  String get btnSkip => 'Überspringen';

  @override
  String get medicationTypePill => 'Tablette';

  @override
  String get medicationTypeCapsule => 'Kapsel';

  @override
  String get medicationTypeInjection => 'Injektion';

  @override
  String get medicationTypeSyrup => 'Sirup';

  @override
  String get medicationTypeOvule => 'Ovulum';

  @override
  String get medicationTypeSuppository => 'Zäpfchen';

  @override
  String get medicationTypeInhaler => 'Inhalator';

  @override
  String get medicationTypeSachet => 'Beutel';

  @override
  String get medicationTypeSpray => 'Spray';

  @override
  String get medicationTypeOintment => 'Salbe';

  @override
  String get medicationTypeLotion => 'Lotion';

  @override
  String get medicationTypeBandage => 'Verband';

  @override
  String get medicationTypeDrops => 'Tropfen';

  @override
  String get medicationTypeOther => 'Andere';

  @override
  String get stockUnitPills => 'Tabletten';

  @override
  String get stockUnitCapsules => 'Kapseln';

  @override
  String get stockUnitInjections => 'Injektionen';

  @override
  String get stockUnitMl => 'ml';

  @override
  String get stockUnitOvules => 'Ovula';

  @override
  String get stockUnitSuppositories => 'Zäpfchen';

  @override
  String get stockUnitInhalations => 'Inhalationen';

  @override
  String get stockUnitSachets => 'Beutel';

  @override
  String get stockUnitGrams => 'Gramm';

  @override
  String get stockUnitBandages => 'Verbände';

  @override
  String get stockUnitDrops => 'Tropfen';

  @override
  String get stockUnitUnits => 'Einheiten';

  @override
  String get stockUnitPill => 'Tablette';

  @override
  String get stockUnitCapsule => 'Kapsel';

  @override
  String get stockUnitInjection => 'Injektion';

  @override
  String get stockUnitOvule => 'Ovulum';

  @override
  String get stockUnitSuppository => 'Zäpfchen';

  @override
  String get stockUnitInhalation => 'Inhalation';

  @override
  String get stockUnitSachet => 'Beutel';

  @override
  String get stockUnitGram => 'Gramm';

  @override
  String get stockUnitBandage => 'Verband';

  @override
  String get stockUnitDrop => 'Tropfen';

  @override
  String get stockUnitUnit => 'Einheit';

  @override
  String get doseStatusTaken => 'Eingenommen';

  @override
  String get doseStatusSkipped => 'Ausgelassen';

  @override
  String get doseStatusPending => 'Ausstehend';

  @override
  String get durationContinuous => 'Kontinuierlich';

  @override
  String get durationSpecificDates => 'Bestimmte Daten';

  @override
  String get durationAsNeeded => 'Nach Bedarf';

  @override
  String get mainScreenTitle => 'Meine Medikamente';

  @override
  String get mainScreenEmptyTitle => 'Keine Medikamente registriert';

  @override
  String get mainScreenEmptySubtitle =>
      'Fügen Sie Medikamente über die Schaltfläche + hinzu';

  @override
  String get mainScreenTodayDoses => 'Heutige Einnahmen';

  @override
  String get mainScreenNoMedications => 'Sie haben keine aktiven Medikamente';

  @override
  String get msgMedicationAdded => 'Medikament erfolgreich hinzugefügt';

  @override
  String get msgMedicationUpdated => 'Medikament erfolgreich aktualisiert';

  @override
  String msgMedicationDeleted(String name) {
    return '$name erfolgreich gelöscht';
  }

  @override
  String get validationRequired => 'Dieses Feld ist erforderlich';

  @override
  String get validationDuplicateMedication =>
      'Dieses Medikament ist bereits in Ihrer Liste vorhanden';

  @override
  String get validationInvalidNumber => 'Geben Sie eine gültige Zahl ein';

  @override
  String validationMinValue(num min) {
    return 'Der Wert muss größer als $min sein';
  }

  @override
  String get pillOrganizerTitle => 'Tablettendose';

  @override
  String get pillOrganizerTotal => 'Gesamt';

  @override
  String get pillOrganizerLowStock => 'Niedriger Vorrat';

  @override
  String get pillOrganizerNoStock => 'Kein Vorrat';

  @override
  String get pillOrganizerAvailableStock => 'Verfügbarer Vorrat';

  @override
  String get pillOrganizerMedicationsTitle => 'Medikamente';

  @override
  String get pillOrganizerEmptyTitle => 'Keine Medikamente registriert';

  @override
  String get pillOrganizerEmptySubtitle =>
      'Fügen Sie Medikamente hinzu, um Ihre Tablettendose zu sehen';

  @override
  String get pillOrganizerCurrentStock => 'Aktueller Vorrat';

  @override
  String get pillOrganizerEstimatedDuration => 'Geschätzte Dauer';

  @override
  String get pillOrganizerDays => 'Tage';

  @override
  String get medicineCabinetTitle => 'Hausapotheke';

  @override
  String get medicineCabinetSearchHint => 'Medikament suchen...';

  @override
  String get medicineCabinetEmptyTitle => 'Keine Medikamente registriert';

  @override
  String get medicineCabinetEmptySubtitle =>
      'Fügen Sie Medikamente hinzu, um Ihre Hausapotheke zu sehen';

  @override
  String get medicineCabinetPullToRefresh =>
      'Ziehen Sie nach unten, um zu aktualisieren';

  @override
  String get medicineCabinetNoResults => 'Keine Medikamente gefunden';

  @override
  String get medicineCabinetNoResultsHint =>
      'Versuchen Sie einen anderen Suchbegriff';

  @override
  String get medicineCabinetStock => 'Vorrat:';

  @override
  String get medicineCabinetSuspended => 'Ausgesetzt';

  @override
  String get medicineCabinetTapToRegister => 'Tippen Sie, um zu registrieren';

  @override
  String get medicineCabinetResumeMedication => 'Medikation fortsetzen';

  @override
  String get medicineCabinetRegisterDose => 'Einnahme registrieren';

  @override
  String get medicineCabinetRefillMedication => 'Medikament auffüllen';

  @override
  String get medicineCabinetEditMedication => 'Medikament bearbeiten';

  @override
  String get medicineCabinetDeleteMedication => 'Medikament löschen';

  @override
  String medicineCabinetRefillTitle(String name) {
    return '$name auffüllen';
  }

  @override
  String medicineCabinetRegisterDoseTitle(String name) {
    return 'Einnahme von $name registrieren';
  }

  @override
  String get medicineCabinetCurrentStock => 'Aktueller Vorrat:';

  @override
  String get medicineCabinetAddQuantity => 'Hinzuzufügende Menge:';

  @override
  String get medicineCabinetAddQuantityLabel => 'Hinzuzufügende Menge';

  @override
  String get medicineCabinetExample => 'Bsp.:';

  @override
  String get medicineCabinetLastRefill => 'Letzte Auffüllung:';

  @override
  String get medicineCabinetRefillButton => 'Auffüllen';

  @override
  String get medicineCabinetAvailableStock => 'Verfügbarer Vorrat:';

  @override
  String get medicineCabinetDoseTaken => 'Eingenommene Menge';

  @override
  String get medicineCabinetRegisterButton => 'Registrieren';

  @override
  String get medicineCabinetNewStock => 'Neuer Vorrat:';

  @override
  String get medicineCabinetDeleteConfirmTitle => 'Medikament löschen';

  @override
  String medicineCabinetDeleteConfirmMessage(String name) {
    return 'Sind Sie sicher, dass Sie \"$name\" löschen möchten?\n\nDiese Aktion kann nicht rückgängig gemacht werden und der gesamte Verlauf dieses Medikaments geht verloren.';
  }

  @override
  String get medicineCabinetNoStockAvailable =>
      'Von diesem Medikament ist kein Vorrat verfügbar';

  @override
  String medicineCabinetInsufficientStock(
    String needed,
    String unit,
    String available,
  ) {
    return 'Unzureichender Vorrat für diese Einnahme\nBenötigt: $needed $unit\nVerfügbar: $available';
  }

  @override
  String medicineCabinetRefillSuccess(
    String name,
    String amount,
    String unit,
    String newStock,
  ) {
    return 'Vorrat von $name aufgefüllt\nHinzugefügt: $amount $unit\nNeuer Vorrat: $newStock';
  }

  @override
  String medicineCabinetDoseRegistered(
    String name,
    String amount,
    String unit,
    String remaining,
  ) {
    return 'Einnahme von $name registriert\nMenge: $amount $unit\nVerbleibender Vorrat: $remaining';
  }

  @override
  String medicineCabinetDeleteSuccess(String name) {
    return '$name erfolgreich gelöscht';
  }

  @override
  String medicineCabinetResumeSuccess(String name) {
    return '$name erfolgreich fortgesetzt\nBenachrichtigungen neu geplant';
  }

  @override
  String get doseHistoryTitle => 'Einnahmeverlauf';

  @override
  String get doseHistoryFilterTitle => 'Verlauf filtern';

  @override
  String get doseHistoryMedicationLabel => 'Medikament:';

  @override
  String get doseHistoryAllMedications => 'Alle Medikamente';

  @override
  String get doseHistoryDateRangeLabel => 'Datumsbereich:';

  @override
  String get doseHistoryClearDates => 'Daten löschen';

  @override
  String get doseHistoryApply => 'Anwenden';

  @override
  String get doseHistoryTotal => 'Gesamt';

  @override
  String get doseHistoryTaken => 'Eingenommen';

  @override
  String get doseHistorySkipped => 'Ausgelassen';

  @override
  String get doseHistoryClear => 'Löschen';

  @override
  String doseHistoryEditEntry(String name) {
    return 'Eintrag von $name bearbeiten';
  }

  @override
  String get doseHistoryScheduledTime => 'Geplante Zeit:';

  @override
  String get doseHistoryActualTime => 'Tatsächliche Zeit:';

  @override
  String get doseHistoryStatus => 'Status:';

  @override
  String get doseHistoryMarkAsSkipped => 'Als ausgelassen markieren';

  @override
  String get doseHistoryMarkAsTaken => 'Als eingenommen markieren';

  @override
  String get doseHistoryConfirmDelete => 'Löschen bestätigen';

  @override
  String get doseHistoryConfirmDeleteMessage =>
      'Sind Sie sicher, dass Sie diesen Eintrag löschen möchten?';

  @override
  String get doseHistoryRecordDeleted => 'Eintrag erfolgreich gelöscht';

  @override
  String doseHistoryDeleteError(String error) {
    return 'Fehler beim Löschen: $error';
  }

  @override
  String get changeRegisteredTime => 'Registrierungszeit ändern';

  @override
  String get selectRegisteredTime => 'Registrierungszeit auswählen';

  @override
  String get registeredTimeLabel => 'Registrierungszeit:';

  @override
  String get registeredTimeUpdated => 'Registrierungszeit aktualisiert';

  @override
  String errorUpdatingTime(String error) {
    return 'Fehler beim Aktualisieren der Zeit: $error';
  }

  @override
  String get errorFindingDoseEntry => 'Dosiseintrag wurde nicht gefunden';

  @override
  String get registeredTimeCannotBeFuture =>
      'Die Registrierungszeit kann nicht in der Zukunft liegen';

  @override
  String get errorLabel => 'Fehler';

  @override
  String get addMedicationTitle => 'Medikament hinzufügen';

  @override
  String stepIndicator(int current, int total) {
    return 'Schritt $current von $total';
  }

  @override
  String get medicationInfoTitle => 'Medikamenteninformation';

  @override
  String get medicationInfoSubtitle =>
      'Beginnen Sie mit der Angabe des Namens und der Art des Medikaments';

  @override
  String get medicationNameLabel => 'Medikamentenname';

  @override
  String get medicationNameHint => 'z.B.: Paracetamol';

  @override
  String get medicationTypeLabel => 'Medikamententyp';

  @override
  String get validationMedicationName =>
      'Bitte geben Sie den Medikamentennamen ein';

  @override
  String get medicationDurationTitle => 'Behandlungsart';

  @override
  String get medicationDurationSubtitle =>
      'Wie werden Sie dieses Medikament einnehmen?';

  @override
  String get durationContinuousTitle => 'Kontinuierliche Behandlung';

  @override
  String get durationContinuousDesc => 'Jeden Tag, mit regelmäßigem Muster';

  @override
  String get durationUntilEmptyTitle => 'Bis Medikament aufgebraucht';

  @override
  String get durationUntilEmptyDesc =>
      'Endet, wenn der Vorrat aufgebraucht ist';

  @override
  String get durationSpecificDatesTitle => 'Bestimmte Daten';

  @override
  String get durationSpecificDatesDesc => 'Nur ausgewählte konkrete Tage';

  @override
  String get durationAsNeededTitle => 'Gelegentliches Medikament';

  @override
  String get durationAsNeededDesc => 'Nur bei Bedarf, ohne Zeitplan';

  @override
  String get selectDatesButton => 'Daten auswählen';

  @override
  String get selectDatesTitle => 'Daten auswählen';

  @override
  String get selectDatesSubtitle =>
      'Wählen Sie die genauen Tage, an denen Sie das Medikament einnehmen werden';

  @override
  String dateSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Daten ausgewählt',
      one: '1 Datum ausgewählt',
    );
    return '$_temp0';
  }

  @override
  String get validationSelectDates =>
      'Bitte wählen Sie mindestens ein Datum aus';

  @override
  String get medicationDatesTitle => 'Behandlungsdaten';

  @override
  String get medicationDatesSubtitle =>
      'Wann beginnen und enden Sie diese Behandlung?';

  @override
  String get medicationDatesHelp =>
      'Beide Daten sind optional. Wenn Sie sie nicht festlegen, beginnt die Behandlung heute und hat kein Enddatum.';

  @override
  String get startDateLabel => 'Startdatum';

  @override
  String get startDateOptional => 'Optional';

  @override
  String get startDateDefault => 'Beginnt heute';

  @override
  String get endDateLabel => 'Enddatum';

  @override
  String get endDateDefault => 'Kein Enddatum';

  @override
  String get startDatePickerTitle => 'Startdatum der Behandlung';

  @override
  String get endDatePickerTitle => 'Enddatum der Behandlung';

  @override
  String get startTodayButton => 'Heute beginnen';

  @override
  String get noEndDateButton => 'Kein Enddatum';

  @override
  String treatmentDuration(int days) {
    return 'Behandlung von $days Tagen';
  }

  @override
  String get medicationFrequencyTitle => 'Medikationshäufigkeit';

  @override
  String get medicationFrequencySubtitle =>
      'Alle wie viele Tage müssen Sie dieses Medikament einnehmen';

  @override
  String get frequencyDailyTitle => 'Jeden Tag';

  @override
  String get frequencyDailyDesc => 'Tägliche kontinuierliche Medikation';

  @override
  String get frequencyAlternateTitle => 'Jeden zweiten Tag';

  @override
  String get frequencyAlternateDesc => 'Alle 2 Tage ab Behandlungsbeginn';

  @override
  String get frequencyWeeklyTitle => 'Bestimmte Wochentage';

  @override
  String get frequencyWeeklyDesc =>
      'Wählen Sie aus, an welchen Tagen Sie das Medikament einnehmen';

  @override
  String get selectWeeklyDaysButton => 'Tage auswählen';

  @override
  String get selectWeeklyDaysTitle => 'Wochentage';

  @override
  String get selectWeeklyDaysSubtitle =>
      'Wählen Sie die spezifischen Tage aus, an denen Sie das Medikament einnehmen werden';

  @override
  String daySelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage ausgewählt',
      one: '1 Tag ausgewählt',
    );
    return '$_temp0';
  }

  @override
  String get validationSelectWeekdays => 'Bitte wählen Sie die Wochentage aus';

  @override
  String get medicationDosageTitle => 'Dosierungskonfiguration';

  @override
  String get medicationDosageSubtitle =>
      'Wie möchten Sie die täglichen Dosen konfigurieren?';

  @override
  String get dosageFixedTitle => 'Jeden Tag gleich';

  @override
  String get dosageFixedDesc =>
      'Geben Sie an, alle wie viele Stunden Sie das Medikament einnehmen';

  @override
  String get dosageCustomTitle => 'Benutzerdefiniert';

  @override
  String get dosageCustomDesc =>
      'Legen Sie die Anzahl der Einnahmen pro Tag fest';

  @override
  String get dosageIntervalLabel => 'Intervall zwischen Einnahmen';

  @override
  String get dosageIntervalHelp => 'Das Intervall muss 24 genau teilen';

  @override
  String get dosageIntervalFieldLabel => 'Alle wie viele Stunden';

  @override
  String get dosageIntervalHint => 'z.B.: 8';

  @override
  String get dosageIntervalUnit => 'Stunden';

  @override
  String get dosageIntervalValidValues =>
      'Gültige Werte: 1, 2, 3, 4, 6, 8, 12, 24';

  @override
  String get dosageTimesLabel => 'Anzahl der Einnahmen pro Tag';

  @override
  String get dosageTimesHelp =>
      'Legen Sie fest, wie oft am Tag Sie das Medikament einnehmen werden';

  @override
  String get dosageTimesFieldLabel => 'Einnahmen pro Tag';

  @override
  String get dosageTimesHint => 'z.B.: 3';

  @override
  String get dosageTimesUnit => 'Einnahmen';

  @override
  String get dosageTimesDescription => 'Gesamtzahl der täglichen Einnahmen';

  @override
  String get dosesPerDay => 'Einnahmen pro Tag';

  @override
  String doseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einnahmen',
      one: '1 Einnahme',
    );
    return '$_temp0';
  }

  @override
  String get validationInvalidInterval =>
      'Bitte geben Sie ein gültiges Intervall ein';

  @override
  String get validationIntervalTooLarge =>
      'Das Intervall darf nicht größer als 24 Stunden sein';

  @override
  String get validationIntervalNotDivisor =>
      'Das Intervall muss 24 genau teilen (1, 2, 3, 4, 6, 8, 12, 24)';

  @override
  String get validationInvalidDoseCount =>
      'Bitte geben Sie eine gültige Anzahl von Einnahmen ein';

  @override
  String get validationTooManyDoses =>
      'Sie können nicht mehr als 24 Dosen pro Tag einnehmen';

  @override
  String get medicationTimesTitle => 'Einnahmeplan';

  @override
  String dosesPerDayLabel(int count) {
    return 'Einnahmen pro Tag: $count';
  }

  @override
  String frequencyEveryHours(int hours) {
    return 'Häufigkeit: Alle $hours Stunden';
  }

  @override
  String get selectTimeAndAmount =>
      'Wählen Sie die Zeit und Menge jeder Einnahme';

  @override
  String doseNumber(int number) {
    return 'Einnahme $number';
  }

  @override
  String get selectTimeButton => 'Zeit auswählen';

  @override
  String get amountPerDose => 'Menge pro Einnahme';

  @override
  String get amountHint => 'z.B.: 1, 0.5, 2';

  @override
  String get removeDoseButton => 'Einnahme entfernen';

  @override
  String get validationSelectAllTimes =>
      'Bitte wählen Sie alle Zeiten der Einnahmen aus';

  @override
  String get validationEnterValidAmounts =>
      'Bitte geben Sie gültige Mengen ein (größer als 0)';

  @override
  String get validationDuplicateTimes =>
      'Die Zeiten der Einnahmen dürfen sich nicht wiederholen';

  @override
  String get validationAtLeastOneDose =>
      'Es muss mindestens eine Einnahme pro Tag geben';

  @override
  String get medicationFastingTitle => 'Nüchternheitskonfiguration';

  @override
  String get fastingLabel => 'Nüchternheit';

  @override
  String get fastingHelp =>
      'Einige Medikamente erfordern Nüchternheit vor oder nach der Einnahme';

  @override
  String get requiresFastingQuestion =>
      'Erfordert dieses Medikament Nüchternheit?';

  @override
  String get fastingNo => 'Nein';

  @override
  String get fastingYes => 'Ja';

  @override
  String get fastingWhenQuestion => 'Wann ist die Nüchternheit?';

  @override
  String get fastingBefore => 'Vor der Einnahme';

  @override
  String get fastingAfter => 'Nach der Einnahme';

  @override
  String get fastingDurationQuestion =>
      'Wie lange soll die Nüchternheit dauern?';

  @override
  String get fastingHours => 'Stunden';

  @override
  String get fastingMinutes => 'Minuten';

  @override
  String get fastingNotificationsQuestion =>
      'Möchten Sie Nüchternheitsbenachrichtigungen erhalten?';

  @override
  String get fastingNotificationBeforeHelp =>
      'Wir benachrichtigen Sie, wann Sie vor der Einnahme aufhören müssen zu essen';

  @override
  String get fastingNotificationAfterHelp =>
      'Wir benachrichtigen Sie, wann Sie nach der Einnahme wieder essen können';

  @override
  String get fastingNotificationsOn => 'Benachrichtigungen aktiviert';

  @override
  String get fastingNotificationsOff => 'Benachrichtigungen deaktiviert';

  @override
  String get validationCompleteAllFields => 'Bitte füllen Sie alle Felder aus';

  @override
  String get validationSelectFastingWhen =>
      'Bitte wählen Sie aus, wann die Nüchternheit ist';

  @override
  String get validationFastingDuration =>
      'Die Nüchternheitsdauer muss mindestens 1 Minute betragen';

  @override
  String get medicationQuantityTitle => 'Medikamentenmenge';

  @override
  String get medicationQuantitySubtitle =>
      'Legen Sie die verfügbare Menge fest und wann Sie Warnungen erhalten möchten';

  @override
  String get availableQuantityLabel => 'Verfügbare Menge';

  @override
  String get availableQuantityHint => 'z.B.: 30';

  @override
  String availableQuantityHelp(String unit) {
    return 'Menge an $unit, die Sie derzeit haben';
  }

  @override
  String get lowStockAlertLabel => 'Warnen, wenn nur noch';

  @override
  String get lowStockAlertHint => 'z.B.: 3';

  @override
  String get lowStockAlertUnit => 'Tage';

  @override
  String get lowStockAlertHelp =>
      'Tage im Voraus, um die Warnung über niedrigen Vorrat zu erhalten';

  @override
  String get validationEnterQuantity =>
      'Bitte geben Sie die verfügbare Menge ein';

  @override
  String get validationQuantityNonNegative =>
      'Die Menge muss größer oder gleich 0 sein';

  @override
  String get validationEnterAlertDays =>
      'Bitte geben Sie die Tage im Voraus ein';

  @override
  String get validationAlertMinDays => 'Es muss mindestens 1 Tag sein';

  @override
  String get validationAlertMaxDays => 'Es darf nicht mehr als 30 Tage sein';

  @override
  String get summaryTitle => 'Zusammenfassung';

  @override
  String get summaryMedication => 'Medikament';

  @override
  String get summaryType => 'Typ';

  @override
  String get summaryDosesPerDay => 'Einnahmen pro Tag';

  @override
  String get summarySchedules => 'Zeitpläne';

  @override
  String get summaryFrequency => 'Häufigkeit';

  @override
  String get summaryFrequencyDaily => 'Jeden Tag';

  @override
  String get summaryFrequencyUntilEmpty => 'Bis Medikament aufgebraucht';

  @override
  String summaryFrequencySpecificDates(int count) {
    return '$count bestimmte Daten';
  }

  @override
  String summaryFrequencyWeekdays(int count) {
    return '$count Wochentage';
  }

  @override
  String summaryFrequencyEveryNDays(int days) {
    return 'Alle $days Tage';
  }

  @override
  String get summaryFrequencyAsNeeded => 'Nach Bedarf';

  @override
  String msgMedicationAddedSuccess(String name) {
    return '$name erfolgreich hinzugefügt';
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
    return 'Fehler beim Speichern des Medikaments: $error';
  }

  @override
  String get saveMedicationButton => 'Medikament speichern';

  @override
  String get savingButton => 'Wird gespeichert...';

  @override
  String get doseActionTitle => 'Einnahmeaktion';

  @override
  String get doseActionLoading => 'Wird geladen...';

  @override
  String get doseActionError => 'Fehler';

  @override
  String get doseActionMedicationNotFound => 'Medikament nicht gefunden';

  @override
  String get doseActionBack => 'Zurück';

  @override
  String doseActionScheduledTime(String time) {
    return 'Geplante Zeit: $time';
  }

  @override
  String get doseActionThisDoseQuantity => 'Menge dieser Einnahme';

  @override
  String get doseActionWhatToDo => 'Was möchten Sie tun?';

  @override
  String get doseActionRegisterTaken => 'Einnahme registrieren';

  @override
  String get doseActionWillDeductStock => 'Wird vom Vorrat abgezogen';

  @override
  String get doseActionMarkAsNotTaken => 'Als nicht eingenommen markieren';

  @override
  String get doseActionWillNotDeductStock => 'Wird nicht vom Vorrat abgezogen';

  @override
  String get doseActionPostpone15Min => '15 Minuten verschieben';

  @override
  String get doseActionQuickReminder => 'Schnelle Erinnerung';

  @override
  String get doseActionPostponeCustom => 'Verschieben (Zeit wählen)';

  @override
  String doseActionInsufficientStock(
    String needed,
    String unit,
    String available,
  ) {
    return 'Unzureichender Vorrat für diese Einnahme\nBenötigt: $needed $unit\nVerfügbar: $available';
  }

  @override
  String doseActionTakenRegistered(String name, String time, String stock) {
    return 'Einnahme von $name um $time registriert\nVerbleibender Vorrat: $stock';
  }

  @override
  String doseActionSkippedRegistered(String name, String time, String stock) {
    return 'Einnahme von $name um $time als nicht eingenommen markiert\nVorrat: $stock (keine Änderung)';
  }

  @override
  String doseActionPostponed(String name, String time) {
    return 'Einnahme von $name verschoben\nNeue Zeit: $time';
  }

  @override
  String doseActionPostponed15(String name, String time) {
    return 'Einnahme von $name um 15 Minuten verschoben\nNeue Zeit: $time';
  }

  @override
  String get editMedicationMenuTitle => 'Medikament bearbeiten';

  @override
  String get editMedicationMenuWhatToEdit => 'Was möchten Sie bearbeiten?';

  @override
  String get editMedicationMenuSelectSection =>
      'Wählen Sie den Abschnitt aus, den Sie ändern möchten';

  @override
  String get editMedicationMenuBasicInfo => 'Grundinformationen';

  @override
  String get editMedicationMenuBasicInfoDesc => 'Name und Art des Medikaments';

  @override
  String get editMedicationMenuDuration => 'Behandlungsdauer';

  @override
  String get editMedicationMenuFrequency => 'Häufigkeit';

  @override
  String get editMedicationMenuSchedules => 'Zeitpläne und Mengen';

  @override
  String editMedicationMenuSchedulesDesc(int count) {
    return '$count Einnahmen pro Tag';
  }

  @override
  String get editMedicationMenuFasting => 'Nüchternheitskonfiguration';

  @override
  String get editMedicationMenuQuantity => 'Verfügbare Menge';

  @override
  String editMedicationMenuQuantityDesc(String quantity, String unit) {
    return '$quantity $unit';
  }

  @override
  String get editMedicationMenuFreqEveryday => 'Jeden Tag';

  @override
  String get editMedicationMenuFreqUntilFinished =>
      'Bis Medikament aufgebraucht';

  @override
  String editMedicationMenuFreqSpecificDates(int count) {
    return '$count bestimmte Daten';
  }

  @override
  String editMedicationMenuFreqWeeklyDays(int count) {
    return '$count Wochentage';
  }

  @override
  String editMedicationMenuFreqInterval(int interval) {
    return 'Alle $interval Tage';
  }

  @override
  String get editMedicationMenuFreqNotDefined => 'Häufigkeit nicht definiert';

  @override
  String get editMedicationMenuFastingNone => 'Keine Nüchternheit';

  @override
  String editMedicationMenuFastingDuration(String duration, String type) {
    return 'Nüchternheit $duration $type';
  }

  @override
  String get editMedicationMenuFastingBefore => 'vorher';

  @override
  String get editMedicationMenuFastingAfter => 'nachher';

  @override
  String get editBasicInfoTitle => 'Grundinformationen bearbeiten';

  @override
  String get editBasicInfoUpdated => 'Informationen erfolgreich aktualisiert';

  @override
  String get editBasicInfoSaving => 'Wird gespeichert...';

  @override
  String get editBasicInfoSaveChanges => 'Änderungen speichern';

  @override
  String editBasicInfoError(String error) {
    return 'Fehler beim Speichern der Änderungen: $error';
  }

  @override
  String get editDurationTitle => 'Dauer bearbeiten';

  @override
  String get editDurationTypeLabel => 'Dauertyp';

  @override
  String editDurationCurrentType(String type) {
    return 'Aktueller Typ: $type';
  }

  @override
  String get editDurationChangeTypeInfo =>
      'Um den Dauertyp zu ändern, bearbeiten Sie den Abschnitt \"Häufigkeit\"';

  @override
  String get editDurationTreatmentDates => 'Behandlungsdaten';

  @override
  String get editDurationStartDate => 'Startdatum';

  @override
  String get editDurationEndDate => 'Enddatum';

  @override
  String get editDurationNotSelected => 'Nicht ausgewählt';

  @override
  String editDurationDays(int days) {
    return 'Dauer: $days Tage';
  }

  @override
  String get editDurationSelectDates =>
      'Bitte wählen Sie Start- und Enddatum aus';

  @override
  String get editDurationUpdated => 'Dauer erfolgreich aktualisiert';

  @override
  String editDurationError(String error) {
    return 'Fehler beim Speichern der Änderungen: $error';
  }

  @override
  String get editFastingTitle => 'Nüchternheitskonfiguration bearbeiten';

  @override
  String get editFastingCompleteFields => 'Bitte füllen Sie alle Felder aus';

  @override
  String get editFastingSelectWhen =>
      'Bitte wählen Sie aus, wann die Nüchternheit ist';

  @override
  String get editFastingMinDuration =>
      'Die Nüchternheitsdauer muss mindestens 1 Minute betragen';

  @override
  String get editFastingUpdated =>
      'Nüchternheitskonfiguration erfolgreich aktualisiert';

  @override
  String editFastingError(String error) {
    return 'Fehler beim Speichern der Änderungen: $error';
  }

  @override
  String get editFrequencyTitle => 'Häufigkeit bearbeiten';

  @override
  String get editFrequencyPattern => 'Häufigkeitsmuster';

  @override
  String get editFrequencyQuestion =>
      'Wie oft werden Sie dieses Medikament einnehmen?';

  @override
  String get editFrequencyEveryday => 'Jeden Tag';

  @override
  String get editFrequencyEverydayDesc => 'Medikament täglich einnehmen';

  @override
  String get editFrequencyUntilFinished => 'Bis aufgebraucht';

  @override
  String get editFrequencyUntilFinishedDesc =>
      'Bis das Medikament aufgebraucht ist';

  @override
  String get editFrequencySpecificDates => 'Bestimmte Daten';

  @override
  String get editFrequencySpecificDatesDesc => 'Konkrete Daten auswählen';

  @override
  String get editFrequencyWeeklyDays => 'Wochentage';

  @override
  String get editFrequencyWeeklyDaysDesc =>
      'Bestimmte Tage jede Woche auswählen';

  @override
  String get editFrequencyAlternateDays => 'Jeden zweiten Tag';

  @override
  String get editFrequencyAlternateDaysDesc =>
      'Alle 2 Tage ab Behandlungsbeginn';

  @override
  String get editFrequencyCustomInterval => 'Benutzerdefiniertes Intervall';

  @override
  String get editFrequencyCustomIntervalDesc => 'Alle N Tage ab Beginn';

  @override
  String get editFrequencySelectedDates => 'Ausgewählte Daten';

  @override
  String editFrequencyDatesCount(int count) {
    return '$count Daten ausgewählt';
  }

  @override
  String get editFrequencyNoDatesSelected => 'Kein Datum ausgewählt';

  @override
  String get editFrequencySelectDatesButton => 'Daten auswählen';

  @override
  String get editFrequencyWeeklyDaysLabel => 'Wochentage';

  @override
  String editFrequencyWeeklyDaysCount(int count) {
    return '$count Tage ausgewählt';
  }

  @override
  String get editFrequencyNoDaysSelected => 'Kein Tag ausgewählt';

  @override
  String get editFrequencySelectDaysButton => 'Tage auswählen';

  @override
  String get editFrequencyIntervalLabel => 'Tagesintervall';

  @override
  String get editFrequencyIntervalField => 'Alle wie viele Tage';

  @override
  String get editFrequencyIntervalHint => 'z.B.: 3';

  @override
  String get editFrequencyIntervalHelp => 'Muss mindestens 2 Tage sein';

  @override
  String get editFrequencySelectAtLeastOneDate =>
      'Bitte wählen Sie mindestens ein Datum aus';

  @override
  String get editFrequencySelectAtLeastOneDay =>
      'Bitte wählen Sie mindestens einen Wochentag aus';

  @override
  String get editFrequencyIntervalMin =>
      'Das Intervall muss mindestens 2 Tage betragen';

  @override
  String get editFrequencyUpdated => 'Häufigkeit erfolgreich aktualisiert';

  @override
  String editFrequencyError(String error) {
    return 'Fehler beim Speichern der Änderungen: $error';
  }

  @override
  String get editQuantityTitle => 'Menge bearbeiten';

  @override
  String get editQuantityMedicationLabel => 'Medikamentenmenge';

  @override
  String get editQuantityDescription =>
      'Legen Sie die verfügbare Menge fest und wann Sie Warnungen erhalten möchten';

  @override
  String get editQuantityAvailableLabel => 'Verfügbare Menge';

  @override
  String editQuantityAvailableHelp(String unit) {
    return 'Menge an $unit, die Sie derzeit haben';
  }

  @override
  String get editQuantityValidationRequired =>
      'Bitte geben Sie die verfügbare Menge ein';

  @override
  String get editQuantityValidationMin =>
      'Die Menge muss größer oder gleich 0 sein';

  @override
  String get editQuantityThresholdLabel => 'Warnen, wenn nur noch';

  @override
  String get editQuantityThresholdHelp =>
      'Tage im Voraus, um die Warnung über niedrigen Vorrat zu erhalten';

  @override
  String get editQuantityThresholdValidationRequired =>
      'Bitte geben Sie die Tage im Voraus ein';

  @override
  String get editQuantityThresholdValidationMin =>
      'Es muss mindestens 1 Tag sein';

  @override
  String get editQuantityThresholdValidationMax =>
      'Es darf nicht mehr als 30 Tage sein';

  @override
  String get editQuantityUpdated => 'Menge erfolgreich aktualisiert';

  @override
  String editQuantityError(String error) {
    return 'Fehler beim Speichern der Änderungen: $error';
  }

  @override
  String get editScheduleTitle => 'Zeitpläne bearbeiten';

  @override
  String get editScheduleAddDose => 'Einnahme hinzufügen';

  @override
  String get editScheduleValidationQuantities =>
      'Bitte geben Sie gültige Mengen ein (größer als 0)';

  @override
  String get editScheduleValidationDuplicates =>
      'Die Zeiten der Einnahmen dürfen sich nicht wiederholen';

  @override
  String get editScheduleUpdated => 'Zeitpläne erfolgreich aktualisiert';

  @override
  String editScheduleError(String error) {
    return 'Fehler beim Speichern der Änderungen: $error';
  }

  @override
  String editScheduleDosesPerDay(int count) {
    return 'Einnahmen pro Tag: $count';
  }

  @override
  String get editScheduleAdjustTimeAndQuantity =>
      'Passen Sie die Zeit und Menge jeder Einnahme an';

  @override
  String get specificDatesSelectorTitle => 'Bestimmte Daten';

  @override
  String get specificDatesSelectorSelectDates => 'Daten auswählen';

  @override
  String get specificDatesSelectorDescription =>
      'Wählen Sie die spezifischen Daten aus, an denen Sie dieses Medikament einnehmen werden';

  @override
  String get specificDatesSelectorAddDate => 'Datum hinzufügen';

  @override
  String specificDatesSelectorSelectedDates(int count) {
    return 'Ausgewählte Daten ($count)';
  }

  @override
  String get specificDatesSelectorToday => 'HEUTE';

  @override
  String get specificDatesSelectorContinue => 'Weiter';

  @override
  String get specificDatesSelectorAlreadySelected =>
      'Dieses Datum ist bereits ausgewählt';

  @override
  String get specificDatesSelectorSelectAtLeastOne =>
      'Wählen Sie mindestens ein Datum aus';

  @override
  String get specificDatesSelectorPickerHelp => 'Wählen Sie ein Datum aus';

  @override
  String get specificDatesSelectorPickerCancel => 'Abbrechen';

  @override
  String get specificDatesSelectorPickerConfirm => 'Akzeptieren';

  @override
  String get weeklyDaysSelectorTitle => 'Wochentage';

  @override
  String get weeklyDaysSelectorSelectDays => 'Tage auswählen';

  @override
  String get weeklyDaysSelectorDescription =>
      'Wählen Sie aus, an welchen Wochentagen Sie dieses Medikament einnehmen werden';

  @override
  String weeklyDaysSelectorSelectedCount(int count, String plural) {
    return '$count Tag$plural ausgewählt';
  }

  @override
  String get weeklyDaysSelectorContinue => 'Weiter';

  @override
  String get weeklyDaysSelectorSelectAtLeastOne =>
      'Wählen Sie mindestens einen Wochentag aus';

  @override
  String get weeklyDayMonday => 'Montag';

  @override
  String get weeklyDayTuesday => 'Dienstag';

  @override
  String get weeklyDayWednesday => 'Mittwoch';

  @override
  String get weeklyDayThursday => 'Donnerstag';

  @override
  String get weeklyDayFriday => 'Freitag';

  @override
  String get weeklyDaySaturday => 'Samstag';

  @override
  String get weeklyDaySunday => 'Sonntag';

  @override
  String get dateFromLabel => 'Von';

  @override
  String get dateToLabel => 'Bis';

  @override
  String get statisticsTitle => 'Statistiken';

  @override
  String get adherenceLabel => 'Therapietreue';

  @override
  String get emptyDosesWithFilters => 'Keine Einnahmen mit diesen Filtern';

  @override
  String get emptyDoses => 'Keine Einnahmen registriert';

  @override
  String get permissionRequired => 'Berechtigung erforderlich';

  @override
  String get notNowButton => 'Nicht jetzt';

  @override
  String get openSettingsButton => 'Einstellungen öffnen';

  @override
  String medicationUpdatedMsg(String name) {
    return '$name aktualisiert';
  }

  @override
  String get noScheduledTimes =>
      'Dieses Medikament hat keine konfigurierten Zeitpläne';

  @override
  String get allDosesTakenToday =>
      'Sie haben bereits alle heutigen Dosen eingenommen';

  @override
  String get extraDoseOption => 'Zusätzliche Einnahme';

  @override
  String extraDoseConfirmationMessage(String name) {
    return 'Sie haben bereits alle geplanten Einnahmen von heute registriert. Möchten Sie eine zusätzliche Einnahme von $name registrieren?';
  }

  @override
  String get extraDoseConfirm => 'Zusätzliche Einnahme registrieren';

  @override
  String extraDoseRegistered(String name, String time, String stock) {
    return 'Zusätzliche Einnahme von $name um $time registriert ($stock verfügbar)';
  }

  @override
  String registerDoseOfMedication(String name) {
    return 'Einnahme von $name registrieren';
  }

  @override
  String refillMedicationTitle(String name) {
    return '$name auffüllen';
  }

  @override
  String doseRegisteredAt(String time) {
    return 'Registriert um $time';
  }

  @override
  String statusUpdatedTo(String status) {
    return 'Status aktualisiert auf: $status';
  }

  @override
  String get dateLabel => 'Datum:';

  @override
  String get scheduledTimeLabel => 'Geplante Zeit:';

  @override
  String get currentStatusLabel => 'Aktueller Status:';

  @override
  String get changeStatusToQuestion => 'Status ändern zu:';

  @override
  String get filterApplied => 'Filter angewendet';

  @override
  String filterFrom(String date) {
    return 'Von $date';
  }

  @override
  String filterTo(String date) {
    return 'Bis $date';
  }

  @override
  String get insufficientStockForDose =>
      'Nicht genügend Vorrat, um als eingenommen zu markieren';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsDisplaySection => 'Anzeige';

  @override
  String get settingsShowActualTimeTitle =>
      'Tatsächliche Einnahmezeit anzeigen';

  @override
  String get settingsShowActualTimeSubtitle =>
      'Zeigt die tatsächliche Zeit an, zu der die Dosen eingenommen wurden, anstelle der geplanten Zeit';

  @override
  String get settingsShowFastingCountdownTitle =>
      'Nüchternheits-Countdown anzeigen';

  @override
  String get settingsShowFastingCountdownSubtitle =>
      'Zeigt die verbleibende Nüchternheitszeit auf dem Hauptbildschirm an';

  @override
  String get settingsShowFastingNotificationTitle =>
      'Feste Countdown-Benachrichtigung';

  @override
  String get settingsShowFastingNotificationSubtitle =>
      'Zeigt eine feste Benachrichtigung mit der verbleibenden Nüchternheitszeit (nur Android)';

  @override
  String get settingsShowPersonTabsTitle =>
      'Personen in separaten Registerkarten anzeigen';

  @override
  String get settingsShowPersonTabsSubtitle =>
      'Zeigt jede Person in einer separaten Registerkarte an. Wenn deaktiviert, werden alle Personen in einer einzigen Liste mit Tags gemischt';

  @override
  String get selectPerson => 'Person auswählen';

  @override
  String get fastingNotificationTitle => 'Nüchternheit im Gange';

  @override
  String fastingNotificationBody(
    String medication,
    String timeRemaining,
    String endTime,
  ) {
    return '$medication • $timeRemaining verbleibend (bis $endTime)';
  }

  @override
  String fastingRemainingMinutes(int minutes) {
    return '$minutes Min.';
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
    return 'Nüchternheit: $time verbleibend (bis $endTime)';
  }

  @override
  String fastingUpcoming(String time, String endTime) {
    return 'Nächste Nüchternheit: $time (bis $endTime)';
  }

  @override
  String get settingsBackupSection => 'Datensicherung';

  @override
  String get settingsExportTitle => 'Datenbank exportieren';

  @override
  String get settingsExportSubtitle =>
      'Speichern Sie eine Kopie aller Ihrer Medikamente und Ihres Verlaufs';

  @override
  String get settingsImportTitle => 'Datenbank importieren';

  @override
  String get settingsImportSubtitle =>
      'Stellen Sie eine zuvor exportierte Sicherung wieder her';

  @override
  String get settingsInfoTitle => 'Information';

  @override
  String get settingsInfoContent =>
      '• Beim Exportieren wird eine Sicherungsdatei erstellt, die Sie auf Ihrem Gerät speichern oder teilen können.\n\n• Beim Importieren werden alle aktuellen Daten durch die Daten der ausgewählten Datei ersetzt.\n\n• Es wird empfohlen, regelmäßig Sicherungen zu erstellen.';

  @override
  String get settingsShareText => 'Datensicherung von MedicApp';

  @override
  String get settingsExportSuccess => 'Datenbank erfolgreich exportiert';

  @override
  String get settingsImportSuccess => 'Datenbank erfolgreich importiert';

  @override
  String settingsExportError(String error) {
    return 'Fehler beim Exportieren: $error';
  }

  @override
  String settingsImportError(String error) {
    return 'Fehler beim Importieren: $error';
  }

  @override
  String get settingsFilePathError => 'Dateipfad konnte nicht abgerufen werden';

  @override
  String get settingsImportDialogTitle => 'Datenbank importieren';

  @override
  String get settingsImportDialogMessage =>
      'Diese Aktion ersetzt alle Ihre aktuellen Daten durch die Daten der importierten Datei.\n\nSind Sie sicher, dass Sie fortfahren möchten?';

  @override
  String get settingsRestartDialogTitle => 'Import abgeschlossen';

  @override
  String get settingsRestartDialogMessage =>
      'Die Datenbank wurde erfolgreich importiert.\n\nBitte starten Sie die Anwendung neu, um die Änderungen zu sehen.';

  @override
  String get settingsRestartDialogButton => 'Verstanden';

  @override
  String get settingsLanguageTitle => 'Sprache';

  @override
  String get settingsLanguageSystem => 'Systemstandard';

  @override
  String get settingsNotificationSoundTitle => 'Benachrichtigungston';

  @override
  String get settingsNotificationSoundSubtitle =>
      'Ton, Vibration und mehr konfigurieren';

  @override
  String get settingsColorPaletteTitle => 'Farbpalette';

  @override
  String medicationStartsOn(Object date) {
    return 'Beginnt am $date';
  }

  @override
  String medicationFinishedOn(Object date) {
    return 'Beendet am $date';
  }

  @override
  String medicationDayOfTotal(Object current, Object total) {
    return 'Tag $current von $total';
  }

  @override
  String get notificationsWillNotWork =>
      'Benachrichtigungen funktionieren NICHT ohne diese Berechtigung.';

  @override
  String get debugMenuActivated => 'Debug-Menü aktiviert';

  @override
  String get debugMenuDeactivated => 'Debug-Menü deaktiviert';

  @override
  String nextDoseAt(String time) {
    return 'Nächste Einnahme: $time';
  }

  @override
  String pendingDose(String time) {
    return '⚠️ Ausstehende Dosis: $time';
  }

  @override
  String nextDoseTomorrow(String time) {
    return 'Nächste Einnahme: morgen um $time';
  }

  @override
  String nextDoseOnDay(String dayName, int day, int month, String time) {
    return 'Nächste Einnahme: $dayName $day/$month um $time';
  }

  @override
  String get dayNameMon => 'Mo';

  @override
  String get dayNameTue => 'Di';

  @override
  String get dayNameWed => 'Mi';

  @override
  String get dayNameThu => 'Do';

  @override
  String get dayNameFri => 'Fr';

  @override
  String get dayNameSat => 'Sa';

  @override
  String get dayNameSun => 'So';

  @override
  String get whichDoseDidYouTake => 'Welche Einnahme haben Sie eingenommen?';

  @override
  String insufficientStockForThisDose(
    String needed,
    String unit,
    String available,
  ) {
    return 'Unzureichender Vorrat für diese Einnahme\nBenötigt: $needed $unit\nVerfügbar: $available';
  }

  @override
  String doseRegisteredAtTime(String name, String time, String stock) {
    return 'Einnahme von $name um $time registriert\nVerbleibender Vorrat: $stock';
  }

  @override
  String get allDosesCompletedToday =>
      '✓ Alle heutigen Einnahmen abgeschlossen';

  @override
  String remainingDosesToday(int count) {
    return 'Verbleibende Einnahmen heute: $count';
  }

  @override
  String manualDoseRegistered(
    String name,
    String quantity,
    String unit,
    String stock,
  ) {
    return 'Manuelle Einnahme von $name registriert\nMenge: $quantity $unit\nVerbleibender Vorrat: $stock';
  }

  @override
  String medicationSuspended(String name) {
    return '$name ausgesetzt\nEs werden keine weiteren Benachrichtigungen geplant';
  }

  @override
  String medicationReactivated(String name) {
    return '$name reaktiviert\nBenachrichtigungen neu geplant';
  }

  @override
  String currentStock(String stock) {
    return 'Aktueller Vorrat: $stock';
  }

  @override
  String get quantityToAdd => 'Hinzuzufügende Menge';

  @override
  String example(String example) {
    return 'Bsp.: $example';
  }

  @override
  String lastRefill(String amount, String unit) {
    return 'Letzte Auffüllung: $amount $unit';
  }

  @override
  String get refillButton => 'Auffüllen';

  @override
  String stockRefilled(
    String name,
    String amount,
    String unit,
    String newStock,
  ) {
    return 'Vorrat von $name aufgefüllt\nHinzugefügt: $amount $unit\nNeuer Vorrat: $newStock';
  }

  @override
  String availableStock(String stock) {
    return 'Verfügbarer Vorrat: $stock';
  }

  @override
  String get quantityTaken => 'Eingenommene Menge';

  @override
  String get registerButton => 'Registrieren';

  @override
  String get registerManualDose => 'Manuelle Einnahme registrieren';

  @override
  String get refillMedication => 'Medikament auffüllen';

  @override
  String get resumeMedication => 'Medikament reaktivieren';

  @override
  String get suspendMedication => 'Medikament aussetzen';

  @override
  String get editMedicationButton => 'Medikament bearbeiten';

  @override
  String get deleteMedicationButton => 'Medikament löschen';

  @override
  String medicationDeletedShort(String name) {
    return '$name gelöscht';
  }

  @override
  String get noMedicationsRegistered => 'Keine Medikamente registriert';

  @override
  String get addMedicationHint =>
      'Drücken Sie die Schaltfläche +, um eines hinzuzufügen';

  @override
  String get pullToRefresh => 'Ziehen Sie nach unten, um zu aktualisieren';

  @override
  String get batteryOptimizationWarning =>
      'Damit Benachrichtigungen funktionieren, deaktivieren Sie die Batteriebeschränkungen:';

  @override
  String get batteryOptimizationInstructions =>
      'Einstellungen → Apps → MedicApp → Batterie → \"Keine Einschränkungen\"';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get todayDosesLabel => 'Heutige Einnahmen:';

  @override
  String doseOfMedicationAt(String name, String time) {
    return 'Einnahme von $name um $time';
  }

  @override
  String currentStatus(String status) {
    return 'Aktueller Status: $status';
  }

  @override
  String get whatDoYouWantToDo => 'Was möchten Sie tun?';

  @override
  String get deleteButton => 'Löschen';

  @override
  String get markAsSkipped => 'Als ausgelassen markieren';

  @override
  String get markAsTaken => 'Als eingenommen markieren';

  @override
  String doseDeletedAt(String time) {
    return 'Einnahme um $time gelöscht';
  }

  @override
  String errorDeleting(String error) {
    return 'Fehler beim Löschen: $error';
  }

  @override
  String doseMarkedAs(String time, String status) {
    return 'Einnahme um $time als $status markiert';
  }

  @override
  String errorChangingStatus(String error) {
    return 'Fehler beim Ändern des Status: $error';
  }

  @override
  String medicationUpdatedShort(String name) {
    return '$name aktualisiert';
  }

  @override
  String get activateAlarmsPermission =>
      '\"Alarme und Erinnerungen\" aktivieren';

  @override
  String get alarmsPermissionDescription =>
      'Diese Berechtigung ermöglicht es, dass Benachrichtigungen genau zur konfigurierten Zeit erscheinen.';

  @override
  String get notificationDebugTitle => 'Benachrichtigungs-Debug';

  @override
  String notificationPermissions(String enabled) {
    return '✓ Benachrichtigungsberechtigungen: $enabled';
  }

  @override
  String exactAlarmsAndroid12(String enabled) {
    return '⏰ Genaue Alarme (Android 12+): $enabled';
  }

  @override
  String get importantWarning => '⚠️ WICHTIG';

  @override
  String get withoutPermissionNoNotifications =>
      'Ohne diese Berechtigung werden Benachrichtigungen NICHT erscheinen.';

  @override
  String get alarmsSettings =>
      'Einstellungen → Apps → MedicApp → Alarme und Erinnerungen';

  @override
  String pendingNotificationsCount(int count) {
    return '📊 Ausstehende Benachrichtigungen: $count';
  }

  @override
  String medicationsWithSchedules(int withSchedules, int total) {
    return '💊 Medikamente mit Zeitplänen: $withSchedules/$total';
  }

  @override
  String get scheduledNotifications => 'Geplante Benachrichtigungen:';

  @override
  String get noScheduledNotifications =>
      '⚠️ Keine geplanten Benachrichtigungen';

  @override
  String get notificationHistory => 'Benachrichtigungsverlauf';

  @override
  String get last24Hours => 'Letzte 24 Stunden';

  @override
  String get noTitle => 'Kein Titel';

  @override
  String get medicationsAndSchedules => 'Medikamente und Zeitpläne:';

  @override
  String get noSchedulesConfigured => '⚠️ Keine Zeitpläne konfiguriert';

  @override
  String get closeButton => 'Schließen';

  @override
  String get testNotification => 'Benachrichtigung testen';

  @override
  String get testNotificationSent => 'Testbenachrichtigung gesendet';

  @override
  String get testScheduledNotification => 'Geplante testen (1 Min.)';

  @override
  String get scheduledNotificationInOneMin =>
      'Benachrichtigung für 1 Minute geplant';

  @override
  String get rescheduleNotifications => 'Benachrichtigungen neu planen';

  @override
  String get notificationsInfo => 'Benachrichtigungsinformationen';

  @override
  String notificationsRescheduled(int count) {
    return 'Benachrichtigungen neu geplant: $count';
  }

  @override
  String get yesText => 'Ja';

  @override
  String get noText => 'Nein';

  @override
  String get notificationTypeDynamicFasting => 'Dynamische Nüchternheit';

  @override
  String get notificationTypeScheduledFasting => 'Geplante Nüchternheit';

  @override
  String get notificationTypeWeeklyPattern => 'Wöchentliches Muster';

  @override
  String get notificationTypeSpecificDate => 'Bestimmtes Datum';

  @override
  String get notificationTypePostponed => 'Verschoben';

  @override
  String get notificationTypeDailyRecurring => 'Täglich wiederkehrend';

  @override
  String get beforeTaking => 'Vor der Einnahme';

  @override
  String get afterTaking => 'Nach der Einnahme';

  @override
  String get basedOnActualDose => 'Basierend auf tatsächlicher Einnahme';

  @override
  String get basedOnSchedule => 'Basierend auf Zeitplan';

  @override
  String today(String date) {
    return 'Heute $date';
  }

  @override
  String get returnToToday => 'Zurück zu heute';

  @override
  String tomorrow(String date) {
    return 'Morgen $date';
  }

  @override
  String get todayOrLater => 'Heute oder später';

  @override
  String get pastDueWarning => '⚠️ ÜBERFÄLLIG';

  @override
  String get batteryOptimizationMenu => '⚙️ Batterieoptimierung';

  @override
  String get alarmsAndReminders => '⚙️ Alarme und Erinnerungen';

  @override
  String get notificationTypeScheduledFastingShort => 'Geplante Nüchternheit';

  @override
  String get basedOnActualDoseShort => 'Basierend auf tatsächlicher Einnahme';

  @override
  String get basedOnScheduleShort => 'Basierend auf Zeitplan';

  @override
  String pendingNotifications(int count) {
    return '📊 Ausstehende Benachrichtigungen: $count';
  }

  @override
  String medicationsWithSchedulesInfo(int withSchedules, int total) {
    return '💊 Medikamente mit Zeitplänen: $withSchedules/$total';
  }

  @override
  String get noSchedulesConfiguredWarning => '⚠️ Keine Zeitpläne konfiguriert';

  @override
  String medicationInfo(String name) {
    return '💊 $name';
  }

  @override
  String notificationType(String type) {
    return '📋 Typ: $type';
  }

  @override
  String scheduleDate(String date) {
    return '📅 Datum: $date';
  }

  @override
  String scheduleTime(String time) {
    return '⏰ Zeit: $time';
  }

  @override
  String notificationId(int id) {
    return 'ID: $id';
  }

  @override
  String get takenStatus => 'Eingenommen';

  @override
  String get skippedStatus => 'Ausgelassen';

  @override
  String durationEstimate(String name, String stock, int days) {
    return '$name\nVorrat: $stock\nGeschätzte Dauer: $days Tage';
  }

  @override
  String errorChanging(String error) {
    return 'Fehler beim Ändern des Status: $error';
  }

  @override
  String get testScheduled1Min => 'Geplante testen (1 Min.)';

  @override
  String get alarmsAndRemindersMenu => '⚙️ Alarme und Erinnerungen';

  @override
  String medicationStockInfo(String name, String stock) {
    return '$name\nVorrat: $stock';
  }

  @override
  String takenTodaySingle(String quantity, String unit, String time) {
    return 'Heute eingenommen: $quantity $unit um $time';
  }

  @override
  String takenTodayMultiple(int count, String quantity, String unit) {
    return 'Heute eingenommen: $count Mal ($quantity $unit)';
  }

  @override
  String get done => 'Erledigt';

  @override
  String get suspended => 'Ausgesetzt';

  @override
  String get activeFastingPeriodsTitle => 'Aktive Nüchternheit';

  @override
  String get fastingCompleted => 'Fasten beendet! Du kannst jetzt essen';

  @override
  String get fastingConflictTitle => 'Conflicto con Período de Ayuno';

  @override
  String fastingConflictMessage(String medicationName) {
    return 'Esta hora coincide con el período de ayuno del medicamento $medicationName';
  }

  @override
  String get fastingConflictSelectedTime => 'Hora seleccionada';

  @override
  String get fastingConflictPeriod => 'Período de ayuno';

  @override
  String get fastingConflictType => 'Tipo de ayuno';

  @override
  String get fastingTypeBefore => 'Antes de tomar';

  @override
  String get fastingTypeAfter => 'Después de tomar';

  @override
  String fastingConflictExplanationBefore(String medicationName) {
    return 'Durante este período, no debes comer antes de tomar $medicationName. Si tomas otro medicamento en esta hora, podrías tener comida en el estómago.';
  }

  @override
  String fastingConflictExplanationAfter(String medicationName) {
    return 'Durante este período, no debes comer después de tomar $medicationName. Si tomas otro medicamento en esta hora, no podrías comer.';
  }

  @override
  String fastingConflictUseSuggested(String time) {
    return 'Usar hora sugerida ($time)';
  }

  @override
  String get fastingConflictOverride => 'Omitir y continuar';

  @override
  String get expirationDateLabel => 'Verfallsdatum';

  @override
  String get expirationDateHint => 'MM/JJJJ (z.B.: 03/2025)';

  @override
  String get expirationDateOptional => 'Verfallsdatum (optional)';

  @override
  String get expirationDateRequired => 'Bitte geben Sie das Verfallsdatum ein';

  @override
  String get expirationDateInvalidFormat =>
      'Ungültiges Format. Verwenden Sie MM/JJJJ (z.B.: 03/2025)';

  @override
  String get expirationDateInvalidMonth =>
      'Der Monat muss zwischen 01 und 12 liegen';

  @override
  String get expirationDateInvalidYear => 'Das Jahr muss gültig sein';

  @override
  String get expirationDateExpired => 'Dieses Medikament ist abgelaufen';

  @override
  String expirationDateExpiredOn(String date) {
    return 'Abgelaufen am $date';
  }

  @override
  String get expirationDateNearExpiration => 'Läuft bald ab';

  @override
  String expirationDateExpiresOn(String date) {
    return 'Läuft ab am $date';
  }

  @override
  String expirationDateExpiresIn(int days) {
    return 'Läuft in $days Tagen ab';
  }

  @override
  String get expirationDateExpiredWarning =>
      'Dieses Medikament ist abgelaufen. Bitte überprüfen Sie das Verfallsdatum, bevor Sie es verwenden.';

  @override
  String get expirationDateNearExpirationWarning =>
      'Dieses Medikament läuft bald ab. Erwägen Sie, es zu ersetzen.';

  @override
  String get expirationDateDialogTitle => 'Verfallsdatum des Medikaments';

  @override
  String get expirationDateDialogMessage =>
      'Geben Sie das Verfallsdatum des Medikaments ein (befindet sich auf der Verpackung).';

  @override
  String get expirationDateUpdateTitle => 'Verfallsdatum aktualisieren';

  @override
  String get expirationDateUpdateMessage =>
      'Sie haben das Medikament nachgefüllt. Möchten Sie das Verfallsdatum aktualisieren?';
}
