// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'MedicApp';

  @override
  String get navMedication => 'Médication';

  @override
  String get navPillOrganizer => 'Pilulier';

  @override
  String get navMedicineCabinet => 'Armoire à pharmacie';

  @override
  String get navHistory => 'Historique';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get navInventory => 'Inventaire';

  @override
  String get navMedicationShort => 'Accueil';

  @override
  String get navPillOrganizerShort => 'Stock';

  @override
  String get navMedicineCabinetShort => 'Pharmacie';

  @override
  String get navHistoryShort => 'Historique';

  @override
  String get navSettingsShort => 'Réglages';

  @override
  String get navInventoryShort => 'Médicaments';

  @override
  String get btnContinue => 'Continuer';

  @override
  String get btnBack => 'Retour';

  @override
  String get btnSave => 'Enregistrer';

  @override
  String get btnCancel => 'Annuler';

  @override
  String get btnDelete => 'Supprimer';

  @override
  String get btnEdit => 'Modifier';

  @override
  String get btnClose => 'Fermer';

  @override
  String get btnConfirm => 'Confirmer';

  @override
  String get btnAccept => 'Accepter';

  @override
  String get medicationTypePill => 'Pilule';

  @override
  String get medicationTypeCapsule => 'Gélule';

  @override
  String get medicationTypeTablet => 'Comprimé';

  @override
  String get medicationTypeSyrup => 'Sirop';

  @override
  String get medicationTypeDrops => 'Gouttes';

  @override
  String get medicationTypeInjection => 'Injection';

  @override
  String get medicationTypePatch => 'Patch';

  @override
  String get medicationTypeInhaler => 'Inhalateur';

  @override
  String get medicationTypeCream => 'Crème';

  @override
  String get medicationTypeOther => 'Autre';

  @override
  String get doseStatusTaken => 'Prise';

  @override
  String get doseStatusSkipped => 'Omise';

  @override
  String get doseStatusPending => 'En attente';

  @override
  String get durationContinuous => 'Continu';

  @override
  String get durationSpecificDates => 'Dates spécifiques';

  @override
  String get durationAsNeeded => 'Selon besoin';

  @override
  String get mainScreenTitle => 'Mes Médicaments';

  @override
  String get mainScreenEmptyTitle => 'Aucun médicament enregistré';

  @override
  String get mainScreenEmptySubtitle =>
      'Ajoutez des médicaments à l\'aide du bouton +';

  @override
  String get mainScreenTodayDoses => 'Prises d\'aujourd\'hui';

  @override
  String get mainScreenNoMedications =>
      'Vous n\'avez pas de médicaments actifs';

  @override
  String get msgMedicationAdded => 'Médicament ajouté correctement';

  @override
  String get msgMedicationUpdated => 'Médicament mis à jour correctement';

  @override
  String msgMedicationDeleted(String name) {
    return '$name supprimé correctement';
  }

  @override
  String get validationRequired => 'Ce champ est obligatoire';

  @override
  String get validationDuplicateMedication =>
      'Ce médicament existe déjà dans votre liste';

  @override
  String get validationInvalidNumber => 'Veuillez entrer un nombre valide';

  @override
  String validationMinValue(num min) {
    return 'La valeur doit être supérieure à $min';
  }

  @override
  String get pillOrganizerTitle => 'Pilulier';

  @override
  String get pillOrganizerTotal => 'Total';

  @override
  String get pillOrganizerLowStock => 'Stock faible';

  @override
  String get pillOrganizerNoStock => 'Stock épuisé';

  @override
  String get pillOrganizerAvailableStock => 'Stock disponible';

  @override
  String get pillOrganizerMedicationsTitle => 'Médicaments';

  @override
  String get pillOrganizerEmptyTitle => 'Aucun médicament enregistré';

  @override
  String get pillOrganizerEmptySubtitle =>
      'Ajoutez des médicaments pour voir votre pilulier';

  @override
  String get pillOrganizerCurrentStock => 'Stock actuel';

  @override
  String get pillOrganizerEstimatedDuration => 'Durée estimée';

  @override
  String get pillOrganizerDays => 'jours';

  @override
  String get medicineCabinetTitle => 'Armoire à pharmacie';

  @override
  String get medicineCabinetSearchHint => 'Rechercher un médicament...';

  @override
  String get medicineCabinetEmptyTitle => 'Aucun médicament enregistré';

  @override
  String get medicineCabinetEmptySubtitle =>
      'Ajoutez des médicaments pour voir votre pharmacie';

  @override
  String get medicineCabinetPullToRefresh => 'Tirez vers le bas pour recharger';

  @override
  String get medicineCabinetNoResults => 'Aucun médicament trouvé';

  @override
  String get medicineCabinetNoResultsHint =>
      'Essayez avec un autre terme de recherche';

  @override
  String get medicineCabinetStock => 'Stock :';

  @override
  String get medicineCabinetSuspended => 'Suspendu';

  @override
  String get medicineCabinetTapToRegister => 'Appuyez pour enregistrer';

  @override
  String get medicineCabinetResumeMedication => 'Reprendre le traitement';

  @override
  String get medicineCabinetRegisterDose => 'Enregistrer la prise';

  @override
  String get medicineCabinetRefillMedication => 'Recharger le médicament';

  @override
  String get medicineCabinetEditMedication => 'Modifier le médicament';

  @override
  String get medicineCabinetDeleteMedication => 'Supprimer le médicament';

  @override
  String medicineCabinetRefillTitle(String name) {
    return 'Recharger $name';
  }

  @override
  String medicineCabinetRegisterDoseTitle(String name) {
    return 'Enregistrer la prise de $name';
  }

  @override
  String get medicineCabinetCurrentStock => 'Stock actuel :';

  @override
  String get medicineCabinetAddQuantity => 'Quantité à ajouter :';

  @override
  String get medicineCabinetAddQuantityLabel => 'Quantité à ajouter';

  @override
  String get medicineCabinetExample => 'Ex. :';

  @override
  String get medicineCabinetLastRefill => 'Dernier rechargement :';

  @override
  String get medicineCabinetRefillButton => 'Recharger';

  @override
  String get medicineCabinetAvailableStock => 'Stock disponible :';

  @override
  String get medicineCabinetDoseTaken => 'Quantité prise';

  @override
  String get medicineCabinetRegisterButton => 'Enregistrer';

  @override
  String get medicineCabinetNewStock => 'Nouveau stock :';

  @override
  String get medicineCabinetDeleteConfirmTitle => 'Supprimer le médicament';

  @override
  String medicineCabinetDeleteConfirmMessage(String name) {
    return 'Êtes-vous sûr de vouloir supprimer \"$name\" ?\n\nCette action est irréversible et tout l\'historique de ce médicament sera perdu.';
  }

  @override
  String get medicineCabinetNoStockAvailable =>
      'Aucun stock disponible pour ce médicament';

  @override
  String medicineCabinetInsufficientStock(
    String needed,
    String unit,
    String available,
  ) {
    return 'Stock insuffisant pour cette prise\nNécessaire : $needed $unit\nDisponible : $available';
  }

  @override
  String medicineCabinetRefillSuccess(
    String name,
    String amount,
    String unit,
    String newStock,
  ) {
    return 'Stock de $name rechargé\nAjouté : $amount $unit\nNouveau stock : $newStock';
  }

  @override
  String medicineCabinetDoseRegistered(
    String name,
    String amount,
    String unit,
    String remaining,
  ) {
    return 'Prise de $name enregistrée\nQuantité : $amount $unit\nStock restant : $remaining';
  }

  @override
  String medicineCabinetDeleteSuccess(String name) {
    return '$name supprimé correctement';
  }

  @override
  String medicineCabinetResumeSuccess(String name) {
    return '$name repris correctement\nNotifications reprogrammées';
  }

  @override
  String get doseHistoryTitle => 'Historique des Prises';

  @override
  String get doseHistoryFilterTitle => 'Filtrer l\'historique';

  @override
  String get doseHistoryMedicationLabel => 'Médicament :';

  @override
  String get doseHistoryAllMedications => 'Tous les médicaments';

  @override
  String get doseHistoryDateRangeLabel => 'Plage de dates :';

  @override
  String get doseHistoryClearDates => 'Effacer les dates';

  @override
  String get doseHistoryApply => 'Appliquer';

  @override
  String get doseHistoryTotal => 'Total';

  @override
  String get doseHistoryTaken => 'Prises';

  @override
  String get doseHistorySkipped => 'Omises';

  @override
  String get doseHistoryClear => 'Effacer';

  @override
  String doseHistoryEditEntry(String name) {
    return 'Modifier l\'enregistrement de $name';
  }

  @override
  String get doseHistoryScheduledTime => 'Heure programmée :';

  @override
  String get doseHistoryActualTime => 'Heure réelle :';

  @override
  String get doseHistoryStatus => 'État :';

  @override
  String get doseHistoryMarkAsSkipped => 'Marquer comme Omise';

  @override
  String get doseHistoryMarkAsTaken => 'Marquer comme Prise';

  @override
  String get doseHistoryConfirmDelete => 'Confirmer la suppression';

  @override
  String get doseHistoryConfirmDeleteMessage =>
      'Êtes-vous sûr de vouloir supprimer cet enregistrement ?';

  @override
  String get doseHistoryRecordDeleted => 'Enregistrement supprimé correctement';

  @override
  String doseHistoryDeleteError(String error) {
    return 'Erreur lors de la suppression : $error';
  }

  @override
  String get changeRegisteredTime => 'Modifier l\'heure d\'enregistrement';

  @override
  String get selectRegisteredTime => 'Sélectionner l\'heure d\'enregistrement';

  @override
  String get registeredTimeLabel => 'Heure d\'enregistrement :';

  @override
  String get registeredTimeUpdated => 'Heure d\'enregistrement mise à jour';

  @override
  String errorUpdatingTime(String error) {
    return 'Erreur lors de la mise à jour de l\'heure : $error';
  }

  @override
  String get errorFindingDoseEntry => 'Entrée de dose introuvable';

  @override
  String get registeredTimeCannotBeFuture =>
      'L\'heure d\'enregistrement ne peut pas être dans le futur';

  @override
  String get errorLabel => 'Erreur';

  @override
  String get addMedicationTitle => 'Ajouter un Médicament';

  @override
  String stepIndicator(int current, int total) {
    return 'Étape $current sur $total';
  }

  @override
  String get medicationInfoTitle => 'Informations sur le médicament';

  @override
  String get medicationInfoSubtitle =>
      'Commencez par fournir le nom et le type de médicament';

  @override
  String get medicationNameLabel => 'Nom du médicament';

  @override
  String get medicationNameHint => 'Ex : Paracétamol';

  @override
  String get medicationTypeLabel => 'Type de médicament';

  @override
  String get validationMedicationName => 'Veuillez entrer le nom du médicament';

  @override
  String get medicationDurationTitle => 'Type de Traitement';

  @override
  String get medicationDurationSubtitle =>
      'Comment allez-vous prendre ce médicament ?';

  @override
  String get durationContinuousTitle => 'Traitement continu';

  @override
  String get durationContinuousDesc =>
      'Tous les jours, avec un schéma régulier';

  @override
  String get durationUntilEmptyTitle => 'Jusqu\'à épuisement du médicament';

  @override
  String get durationUntilEmptyDesc => 'Se termine lorsque le stock est épuisé';

  @override
  String get durationSpecificDatesTitle => 'Dates spécifiques';

  @override
  String get durationSpecificDatesDesc =>
      'Uniquement les jours spécifiques sélectionnés';

  @override
  String get durationAsNeededTitle => 'Médicament occasionnel';

  @override
  String get durationAsNeededDesc => 'Uniquement si nécessaire, sans horaires';

  @override
  String get selectDatesButton => 'Sélectionner les dates';

  @override
  String get selectDatesTitle => 'Sélectionnez les dates';

  @override
  String get selectDatesSubtitle =>
      'Choisissez les jours exacts où vous prendrez le médicament';

  @override
  String dateSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dates sélectionnées',
      one: '1 date sélectionnée',
    );
    return '$_temp0';
  }

  @override
  String get validationSelectDates => 'Veuillez sélectionner au moins une date';

  @override
  String get medicationDatesTitle => 'Dates du Traitement';

  @override
  String get medicationDatesSubtitle =>
      'Quand commencerez-vous et terminerez-vous ce traitement ?';

  @override
  String get medicationDatesHelp =>
      'Les deux dates sont facultatives. Si vous ne les définissez pas, le traitement commencera aujourd\'hui et n\'aura pas de date limite.';

  @override
  String get startDateLabel => 'Date de début';

  @override
  String get startDateOptional => 'Facultatif';

  @override
  String get startDateDefault => 'Commence aujourd\'hui';

  @override
  String get endDateLabel => 'Date de fin';

  @override
  String get endDateDefault => 'Sans date limite';

  @override
  String get startDatePickerTitle => 'Date de début du traitement';

  @override
  String get endDatePickerTitle => 'Date de fin du traitement';

  @override
  String get startTodayButton => 'Commencer aujourd\'hui';

  @override
  String get noEndDateButton => 'Sans date limite';

  @override
  String treatmentDuration(int days) {
    return 'Traitement de $days jours';
  }

  @override
  String get medicationFrequencyTitle => 'Fréquence de Médication';

  @override
  String get medicationFrequencySubtitle =>
      'Tous les combien de jours devez-vous prendre ce médicament';

  @override
  String get frequencyDailyTitle => 'Tous les jours';

  @override
  String get frequencyDailyDesc => 'Médication quotidienne continue';

  @override
  String get frequencyAlternateTitle => 'Jours alternés';

  @override
  String get frequencyAlternateDesc =>
      'Tous les 2 jours à partir du début du traitement';

  @override
  String get frequencyWeeklyTitle => 'Jours de la semaine spécifiques';

  @override
  String get frequencyWeeklyDesc =>
      'Sélectionnez les jours pour prendre le médicament';

  @override
  String get selectWeeklyDaysButton => 'Sélectionner les jours';

  @override
  String get selectWeeklyDaysTitle => 'Jours de la semaine';

  @override
  String get selectWeeklyDaysSubtitle =>
      'Sélectionnez les jours spécifiques où vous prendrez le médicament';

  @override
  String daySelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours sélectionnés',
      one: '1 jour sélectionné',
    );
    return '$_temp0';
  }

  @override
  String get validationSelectWeekdays =>
      'Veuillez sélectionner les jours de la semaine';

  @override
  String get medicationDosageTitle => 'Configuration des Doses';

  @override
  String get medicationDosageSubtitle =>
      'Comment préférez-vous configurer les doses quotidiennes ?';

  @override
  String get dosageFixedTitle => 'Tous les jours pareil';

  @override
  String get dosageFixedDesc =>
      'Spécifiez toutes les combien d\'heures prendre le médicament';

  @override
  String get dosageCustomTitle => 'Personnalisé';

  @override
  String get dosageCustomDesc => 'Définissez le nombre de prises par jour';

  @override
  String get dosageIntervalLabel => 'Intervalle entre les prises';

  @override
  String get dosageIntervalHelp => 'L\'intervalle doit diviser 24 exactement';

  @override
  String get dosageIntervalFieldLabel => 'Toutes les combien d\'heures';

  @override
  String get dosageIntervalHint => 'Ex : 8';

  @override
  String get dosageIntervalUnit => 'heures';

  @override
  String get dosageIntervalValidValues =>
      'Valeurs valides : 1, 2, 3, 4, 6, 8, 12, 24';

  @override
  String get dosageTimesLabel => 'Nombre de prises par jour';

  @override
  String get dosageTimesHelp =>
      'Définissez combien de fois par jour vous prendrez le médicament';

  @override
  String get dosageTimesFieldLabel => 'Prises par jour';

  @override
  String get dosageTimesHint => 'Ex : 3';

  @override
  String get dosageTimesUnit => 'prises';

  @override
  String get dosageTimesDescription => 'Nombre total de prises quotidiennes';

  @override
  String get dosesPerDay => 'Prises par jour';

  @override
  String doseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count prises',
      one: '1 prise',
    );
    return '$_temp0';
  }

  @override
  String get validationInvalidInterval =>
      'Veuillez entrer un intervalle valide';

  @override
  String get validationIntervalTooLarge =>
      'L\'intervalle ne peut pas dépasser 24 heures';

  @override
  String get validationIntervalNotDivisor =>
      'L\'intervalle doit diviser 24 exactement (1, 2, 3, 4, 6, 8, 12, 24)';

  @override
  String get validationInvalidDoseCount =>
      'Veuillez entrer un nombre de prises valide';

  @override
  String get validationTooManyDoses =>
      'Vous ne pouvez pas prendre plus de 24 doses par jour';

  @override
  String get medicationTimesTitle => 'Horaire des Prises';

  @override
  String dosesPerDayLabel(int count) {
    return 'Prises par jour : $count';
  }

  @override
  String frequencyEveryHours(int hours) {
    return 'Fréquence : Toutes les $hours heures';
  }

  @override
  String get selectTimeAndAmount =>
      'Sélectionnez l\'heure et la quantité de chaque prise';

  @override
  String doseNumber(int number) {
    return 'Prise $number';
  }

  @override
  String get selectTimeButton => 'Sélectionner l\'heure';

  @override
  String get amountPerDose => 'Quantité par prise';

  @override
  String get amountHint => 'Ex : 1, 0.5, 2';

  @override
  String get removeDoseButton => 'Supprimer la prise';

  @override
  String get validationSelectAllTimes =>
      'Veuillez sélectionner toutes les heures des prises';

  @override
  String get validationEnterValidAmounts =>
      'Veuillez entrer des quantités valides (supérieures à 0)';

  @override
  String get validationDuplicateTimes =>
      'Les heures des prises ne peuvent pas être identiques';

  @override
  String get validationAtLeastOneDose =>
      'Il doit y avoir au moins une prise par jour';

  @override
  String get medicationFastingTitle => 'Configuration du Jeûne';

  @override
  String get fastingLabel => 'Jeûne';

  @override
  String get fastingHelp =>
      'Certains médicaments nécessitent un jeûne avant ou après la prise';

  @override
  String get requiresFastingQuestion =>
      'Ce médicament nécessite-t-il un jeûne ?';

  @override
  String get fastingNo => 'Non';

  @override
  String get fastingYes => 'Oui';

  @override
  String get fastingWhenQuestion => 'Quand est le jeûne ?';

  @override
  String get fastingBefore => 'Avant la prise';

  @override
  String get fastingAfter => 'Après la prise';

  @override
  String get fastingDurationQuestion => 'Combien de temps de jeûne ?';

  @override
  String get fastingHours => 'Heures';

  @override
  String get fastingMinutes => 'Minutes';

  @override
  String get fastingNotificationsQuestion =>
      'Souhaitez-vous recevoir des notifications de jeûne ?';

  @override
  String get fastingNotificationBeforeHelp =>
      'Nous vous notifierons quand vous devrez arrêter de manger avant la prise';

  @override
  String get fastingNotificationAfterHelp =>
      'Nous vous notifierons quand vous pourrez manger à nouveau après la prise';

  @override
  String get fastingNotificationsOn => 'Notifications activées';

  @override
  String get fastingNotificationsOff => 'Notifications désactivées';

  @override
  String get validationCompleteAllFields => 'Veuillez remplir tous les champs';

  @override
  String get validationSelectFastingWhen =>
      'Veuillez sélectionner quand est le jeûne';

  @override
  String get validationFastingDuration =>
      'La durée du jeûne doit être d\'au moins 1 minute';

  @override
  String get medicationQuantityTitle => 'Quantité de Médicament';

  @override
  String get medicationQuantitySubtitle =>
      'Définissez la quantité disponible et quand vous souhaitez recevoir des alertes';

  @override
  String get availableQuantityLabel => 'Quantité disponible';

  @override
  String get availableQuantityHint => 'Ex : 30';

  @override
  String availableQuantityHelp(String unit) {
    return 'Quantité de $unit que vous avez actuellement';
  }

  @override
  String get lowStockAlertLabel => 'Avertir quand il reste';

  @override
  String get lowStockAlertHint => 'Ex : 3';

  @override
  String get lowStockAlertUnit => 'jours';

  @override
  String get lowStockAlertHelp =>
      'Jours d\'avance pour recevoir l\'alerte de stock faible';

  @override
  String get validationEnterQuantity =>
      'Veuillez entrer la quantité disponible';

  @override
  String get validationQuantityNonNegative =>
      'La quantité doit être supérieure ou égale à 0';

  @override
  String get validationEnterAlertDays => 'Veuillez entrer les jours d\'avance';

  @override
  String get validationAlertMinDays => 'Doit être au moins 1 jour';

  @override
  String get validationAlertMaxDays => 'Ne peut pas dépasser 30 jours';

  @override
  String get summaryTitle => 'Résumé';

  @override
  String get summaryMedication => 'Médicament';

  @override
  String get summaryType => 'Type';

  @override
  String get summaryDosesPerDay => 'Prises par jour';

  @override
  String get summarySchedules => 'Horaires';

  @override
  String get summaryFrequency => 'Fréquence';

  @override
  String get summaryFrequencyDaily => 'Tous les jours';

  @override
  String get summaryFrequencyUntilEmpty => 'Jusqu\'à épuisement du médicament';

  @override
  String summaryFrequencySpecificDates(int count) {
    return '$count dates spécifiques';
  }

  @override
  String summaryFrequencyWeekdays(int count) {
    return '$count jours de la semaine';
  }

  @override
  String summaryFrequencyEveryNDays(int days) {
    return 'Tous les $days jours';
  }

  @override
  String get summaryFrequencyAsNeeded => 'Selon besoin';

  @override
  String msgMedicationAddedSuccess(String name) {
    return '$name ajouté correctement';
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
    return 'Erreur lors de l\'enregistrement du médicament : $error';
  }

  @override
  String get saveMedicationButton => 'Enregistrer le Médicament';

  @override
  String get savingButton => 'Enregistrement...';

  @override
  String get doseActionTitle => 'Action de Prise';

  @override
  String get doseActionLoading => 'Chargement...';

  @override
  String get doseActionError => 'Erreur';

  @override
  String get doseActionMedicationNotFound => 'Médicament introuvable';

  @override
  String get doseActionBack => 'Retour';

  @override
  String doseActionScheduledTime(String time) {
    return 'Heure programmée : $time';
  }

  @override
  String get doseActionThisDoseQuantity => 'Quantité de cette prise';

  @override
  String get doseActionWhatToDo => 'Que voulez-vous faire ?';

  @override
  String get doseActionRegisterTaken => 'Enregistrer la prise';

  @override
  String get doseActionWillDeductStock => 'Déduira du stock';

  @override
  String get doseActionMarkAsNotTaken => 'Marquer comme non prise';

  @override
  String get doseActionWillNotDeductStock => 'Ne déduira pas du stock';

  @override
  String get doseActionPostpone15Min => 'Reporter de 15 minutes';

  @override
  String get doseActionQuickReminder => 'Rappel rapide';

  @override
  String get doseActionPostponeCustom => 'Reporter (choisir l\'heure)';

  @override
  String doseActionInsufficientStock(
    String needed,
    String unit,
    String available,
  ) {
    return 'Stock insuffisant pour cette prise\nNécessaire : $needed $unit\nDisponible : $available';
  }

  @override
  String doseActionTakenRegistered(String name, String time, String stock) {
    return 'Prise de $name enregistrée à $time\nStock restant : $stock';
  }

  @override
  String doseActionSkippedRegistered(String name, String time, String stock) {
    return 'Prise de $name marquée comme non prise à $time\nStock : $stock (sans changement)';
  }

  @override
  String doseActionPostponed(String name, String time) {
    return 'Prise de $name reportée\nNouvelle heure : $time';
  }

  @override
  String doseActionPostponed15(String name, String time) {
    return 'Prise de $name reportée de 15 minutes\nNouvelle heure : $time';
  }

  @override
  String get editMedicationMenuTitle => 'Modifier le Médicament';

  @override
  String get editMedicationMenuWhatToEdit => 'Que voulez-vous modifier ?';

  @override
  String get editMedicationMenuSelectSection =>
      'Sélectionnez la section que vous souhaitez modifier';

  @override
  String get editMedicationMenuBasicInfo => 'Informations de Base';

  @override
  String get editMedicationMenuBasicInfoDesc => 'Nom et type de médicament';

  @override
  String get editMedicationMenuDuration => 'Durée du Traitement';

  @override
  String get editMedicationMenuFrequency => 'Fréquence';

  @override
  String get editMedicationMenuSchedules => 'Horaires et Quantités';

  @override
  String editMedicationMenuSchedulesDesc(int count) {
    return '$count prises par jour';
  }

  @override
  String get editMedicationMenuFasting => 'Configuration du Jeûne';

  @override
  String get editMedicationMenuQuantity => 'Quantité Disponible';

  @override
  String editMedicationMenuQuantityDesc(String quantity, String unit) {
    return '$quantity $unit';
  }

  @override
  String get editMedicationMenuFreqEveryday => 'Tous les jours';

  @override
  String get editMedicationMenuFreqUntilFinished =>
      'Jusqu\'à épuisement du médicament';

  @override
  String editMedicationMenuFreqSpecificDates(int count) {
    return '$count dates spécifiques';
  }

  @override
  String editMedicationMenuFreqWeeklyDays(int count) {
    return '$count jours de la semaine';
  }

  @override
  String editMedicationMenuFreqInterval(int interval) {
    return 'Tous les $interval jours';
  }

  @override
  String get editMedicationMenuFreqNotDefined => 'Fréquence non définie';

  @override
  String get editMedicationMenuFastingNone => 'Sans jeûne';

  @override
  String editMedicationMenuFastingDuration(String duration, String type) {
    return 'Jeûne $duration $type';
  }

  @override
  String get editMedicationMenuFastingBefore => 'avant';

  @override
  String get editMedicationMenuFastingAfter => 'après';

  @override
  String get editBasicInfoTitle => 'Modifier les Informations de Base';

  @override
  String get editBasicInfoUpdated => 'Informations mises à jour correctement';

  @override
  String get editBasicInfoSaving => 'Enregistrement...';

  @override
  String get editBasicInfoSaveChanges => 'Enregistrer les Modifications';

  @override
  String editBasicInfoError(String error) {
    return 'Erreur lors de l\'enregistrement des modifications : $error';
  }

  @override
  String get editDurationTitle => 'Modifier la Durée';

  @override
  String get editDurationTypeLabel => 'Type de durée';

  @override
  String editDurationCurrentType(String type) {
    return 'Type actuel : $type';
  }

  @override
  String get editDurationChangeTypeInfo =>
      'Pour changer le type de durée, modifiez la section \"Fréquence\"';

  @override
  String get editDurationTreatmentDates => 'Dates du traitement';

  @override
  String get editDurationStartDate => 'Date de début';

  @override
  String get editDurationEndDate => 'Date de fin';

  @override
  String get editDurationNotSelected => 'Non sélectionnée';

  @override
  String editDurationDays(int days) {
    return 'Durée : $days jours';
  }

  @override
  String get editDurationSelectDates =>
      'Veuillez sélectionner les dates de début et de fin';

  @override
  String get editDurationUpdated => 'Durée mise à jour correctement';

  @override
  String editDurationError(String error) {
    return 'Erreur lors de l\'enregistrement des modifications : $error';
  }

  @override
  String get editFastingTitle => 'Modifier la Configuration du Jeûne';

  @override
  String get editFastingCompleteFields => 'Veuillez remplir tous les champs';

  @override
  String get editFastingSelectWhen =>
      'Veuillez sélectionner quand est le jeûne';

  @override
  String get editFastingMinDuration =>
      'La durée du jeûne doit être d\'au moins 1 minute';

  @override
  String get editFastingUpdated =>
      'Configuration du jeûne mise à jour correctement';

  @override
  String editFastingError(String error) {
    return 'Erreur lors de l\'enregistrement des modifications : $error';
  }

  @override
  String get editFrequencyTitle => 'Modifier la Fréquence';

  @override
  String get editFrequencyPattern => 'Schéma de fréquence';

  @override
  String get editFrequencyQuestion =>
      'À quelle fréquence prendrez-vous ce médicament ?';

  @override
  String get editFrequencyEveryday => 'Tous les jours';

  @override
  String get editFrequencyEverydayDesc =>
      'Prendre le médicament quotidiennement';

  @override
  String get editFrequencyUntilFinished => 'Jusqu\'à épuisement';

  @override
  String get editFrequencyUntilFinishedDesc =>
      'Jusqu\'à ce que le médicament soit terminé';

  @override
  String get editFrequencySpecificDates => 'Dates spécifiques';

  @override
  String get editFrequencySpecificDatesDesc =>
      'Sélectionner des dates spécifiques';

  @override
  String get editFrequencyWeeklyDays => 'Jours de la semaine';

  @override
  String get editFrequencyWeeklyDaysDesc =>
      'Sélectionner des jours spécifiques chaque semaine';

  @override
  String get editFrequencyAlternateDays => 'Jours alternés';

  @override
  String get editFrequencyAlternateDaysDesc =>
      'Tous les 2 jours à partir du début du traitement';

  @override
  String get editFrequencyCustomInterval => 'Intervalle personnalisé';

  @override
  String get editFrequencyCustomIntervalDesc =>
      'Tous les N jours depuis le début';

  @override
  String get editFrequencySelectedDates => 'Dates sélectionnées';

  @override
  String editFrequencyDatesCount(int count) {
    return '$count dates sélectionnées';
  }

  @override
  String get editFrequencyNoDatesSelected => 'Aucune date sélectionnée';

  @override
  String get editFrequencySelectDatesButton => 'Sélectionner les dates';

  @override
  String get editFrequencyWeeklyDaysLabel => 'Jours de la semaine';

  @override
  String editFrequencyWeeklyDaysCount(int count) {
    return '$count jours sélectionnés';
  }

  @override
  String get editFrequencyNoDaysSelected => 'Aucun jour sélectionné';

  @override
  String get editFrequencySelectDaysButton => 'Sélectionner les jours';

  @override
  String get editFrequencyIntervalLabel => 'Intervalle de jours';

  @override
  String get editFrequencyIntervalField => 'Tous les combien de jours';

  @override
  String get editFrequencyIntervalHint => 'Ex : 3';

  @override
  String get editFrequencyIntervalHelp => 'Doit être au moins 2 jours';

  @override
  String get editFrequencySelectAtLeastOneDate =>
      'Veuillez sélectionner au moins une date';

  @override
  String get editFrequencySelectAtLeastOneDay =>
      'Veuillez sélectionner au moins un jour de la semaine';

  @override
  String get editFrequencyIntervalMin =>
      'L\'intervalle doit être d\'au moins 2 jours';

  @override
  String get editFrequencyUpdated => 'Fréquence mise à jour correctement';

  @override
  String editFrequencyError(String error) {
    return 'Erreur lors de l\'enregistrement des modifications : $error';
  }

  @override
  String get editQuantityTitle => 'Modifier la Quantité';

  @override
  String get editQuantityMedicationLabel => 'Quantité de médicament';

  @override
  String get editQuantityDescription =>
      'Définissez la quantité disponible et quand vous souhaitez recevoir des alertes';

  @override
  String get editQuantityAvailableLabel => 'Quantité disponible';

  @override
  String editQuantityAvailableHelp(String unit) {
    return 'Quantité de $unit que vous avez actuellement';
  }

  @override
  String get editQuantityValidationRequired =>
      'Veuillez entrer la quantité disponible';

  @override
  String get editQuantityValidationMin =>
      'La quantité doit être supérieure ou égale à 0';

  @override
  String get editQuantityThresholdLabel => 'Avertir quand il reste';

  @override
  String get editQuantityThresholdHelp =>
      'Jours d\'avance pour recevoir l\'alerte de stock faible';

  @override
  String get editQuantityThresholdValidationRequired =>
      'Veuillez entrer les jours d\'avance';

  @override
  String get editQuantityThresholdValidationMin => 'Doit être au moins 1 jour';

  @override
  String get editQuantityThresholdValidationMax =>
      'Ne peut pas dépasser 30 jours';

  @override
  String get editQuantityUpdated => 'Quantité mise à jour correctement';

  @override
  String editQuantityError(String error) {
    return 'Erreur lors de l\'enregistrement des modifications : $error';
  }

  @override
  String get editScheduleTitle => 'Modifier les Horaires';

  @override
  String get editScheduleAddDose => 'Ajouter une prise';

  @override
  String get editScheduleValidationQuantities =>
      'Veuillez entrer des quantités valides (supérieures à 0)';

  @override
  String get editScheduleValidationDuplicates =>
      'Les heures des prises ne peuvent pas être identiques';

  @override
  String get editScheduleUpdated => 'Horaires mis à jour correctement';

  @override
  String editScheduleError(String error) {
    return 'Erreur lors de l\'enregistrement des modifications : $error';
  }

  @override
  String editScheduleDosesPerDay(int count) {
    return 'Prises par jour : $count';
  }

  @override
  String get editScheduleAdjustTimeAndQuantity =>
      'Ajustez l\'heure et la quantité de chaque prise';

  @override
  String get specificDatesSelectorTitle => 'Dates spécifiques';

  @override
  String get specificDatesSelectorSelectDates => 'Sélectionner les dates';

  @override
  String get specificDatesSelectorDescription =>
      'Choisissez les dates spécifiques où vous prendrez ce médicament';

  @override
  String get specificDatesSelectorAddDate => 'Ajouter une date';

  @override
  String specificDatesSelectorSelectedDates(int count) {
    return 'Dates sélectionnées ($count)';
  }

  @override
  String get specificDatesSelectorToday => 'AUJOURD\'HUI';

  @override
  String get specificDatesSelectorContinue => 'Continuer';

  @override
  String get specificDatesSelectorAlreadySelected =>
      'Cette date est déjà sélectionnée';

  @override
  String get specificDatesSelectorSelectAtLeastOne =>
      'Sélectionnez au moins une date';

  @override
  String get specificDatesSelectorPickerHelp => 'Sélectionnez une date';

  @override
  String get specificDatesSelectorPickerCancel => 'Annuler';

  @override
  String get specificDatesSelectorPickerConfirm => 'Accepter';

  @override
  String get weeklyDaysSelectorTitle => 'Jours de la semaine';

  @override
  String get weeklyDaysSelectorSelectDays => 'Sélectionner les jours';

  @override
  String get weeklyDaysSelectorDescription =>
      'Choisissez les jours de la semaine où vous prendrez ce médicament';

  @override
  String weeklyDaysSelectorSelectedCount(int count, String plural) {
    return '$count jour$plural sélectionné$plural';
  }

  @override
  String get weeklyDaysSelectorContinue => 'Continuer';

  @override
  String get weeklyDaysSelectorSelectAtLeastOne =>
      'Sélectionnez au moins un jour de la semaine';

  @override
  String get weeklyDayMonday => 'Lundi';

  @override
  String get weeklyDayTuesday => 'Mardi';

  @override
  String get weeklyDayWednesday => 'Mercredi';

  @override
  String get weeklyDayThursday => 'Jeudi';

  @override
  String get weeklyDayFriday => 'Vendredi';

  @override
  String get weeklyDaySaturday => 'Samedi';

  @override
  String get weeklyDaySunday => 'Dimanche';

  @override
  String get dateFromLabel => 'Du';

  @override
  String get dateToLabel => 'Au';

  @override
  String get statisticsTitle => 'Statistiques';

  @override
  String get adherenceLabel => 'Observance';

  @override
  String get emptyDosesWithFilters => 'Aucune prise avec ces filtres';

  @override
  String get emptyDoses => 'Aucune prise enregistrée';

  @override
  String get permissionRequired => 'Permission nécessaire';

  @override
  String get notNowButton => 'Pas maintenant';

  @override
  String get openSettingsButton => 'Ouvrir les paramètres';

  @override
  String medicationUpdatedMsg(String name) {
    return '$name mis à jour';
  }

  @override
  String get noScheduledTimes =>
      'Ce médicament n\'a pas d\'horaires configurés';

  @override
  String get allDosesTakenToday =>
      'Vous avez déjà pris toutes les doses d\'aujourd\'hui';

  @override
  String get extraDoseOption => 'Prise supplémentaire';

  @override
  String extraDoseConfirmationMessage(String name) {
    return 'Vous avez déjà enregistré toutes les prises programmées d\'aujourd\'hui. Voulez-vous enregistrer une prise supplémentaire de $name ?';
  }

  @override
  String get extraDoseConfirm => 'Enregistrer la prise supplémentaire';

  @override
  String extraDoseRegistered(String name, String time, String stock) {
    return 'Prise supplémentaire de $name enregistrée à $time ($stock disponible)';
  }

  @override
  String registerDoseOfMedication(String name) {
    return 'Enregistrer la prise de $name';
  }

  @override
  String refillMedicationTitle(String name) {
    return 'Recharger $name';
  }

  @override
  String doseRegisteredAt(String time) {
    return 'Enregistrée à $time';
  }

  @override
  String statusUpdatedTo(String status) {
    return 'État mis à jour à : $status';
  }

  @override
  String get dateLabel => 'Date :';

  @override
  String get scheduledTimeLabel => 'Heure programmée :';

  @override
  String get currentStatusLabel => 'État actuel :';

  @override
  String get changeStatusToQuestion => 'Changer l\'état à :';

  @override
  String get filterApplied => 'Filtre appliqué';

  @override
  String filterFrom(String date) {
    return 'Du $date';
  }

  @override
  String filterTo(String date) {
    return 'Au $date';
  }

  @override
  String get insufficientStockForDose =>
      'Stock insuffisant pour marquer comme prise';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsDisplaySection => 'Affichage';

  @override
  String get settingsShowActualTimeTitle => 'Afficher l\'heure réelle de prise';

  @override
  String get settingsShowActualTimeSubtitle =>
      'Affiche l\'heure réelle de prise des doses au lieu de l\'heure programmée';

  @override
  String get settingsShowFastingCountdownTitle =>
      'Afficher le compte à rebours du jeûne';

  @override
  String get settingsShowFastingCountdownSubtitle =>
      'Affiche le temps restant de jeûne sur l\'écran principal';

  @override
  String get settingsShowFastingNotificationTitle =>
      'Notification fixe du compte à rebours';

  @override
  String get settingsShowFastingNotificationSubtitle =>
      'Affiche une notification fixe avec le temps restant de jeûne (Android uniquement)';

  @override
  String get settingsShowPersonTabsTitle =>
      'Voir les personnes par onglets séparés';

  @override
  String get settingsShowPersonTabsSubtitle =>
      'Affiche chaque personne dans un onglet séparé. Si désactivé, toutes les personnes sont mélangées dans une seule liste avec des étiquettes';

  @override
  String get selectPerson => 'Sélectionner une personne';

  @override
  String get fastingNotificationTitle => 'Jeûne en cours';

  @override
  String fastingNotificationBody(
    String medication,
    String timeRemaining,
    String endTime,
  ) {
    return '$medication • $timeRemaining restantes (jusqu\'à $endTime)';
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
    return 'Jeûne : $time restantes (jusqu\'à $endTime)';
  }

  @override
  String fastingUpcoming(String time, String endTime) {
    return 'Prochain jeûne : $time (jusqu\'à $endTime)';
  }

  @override
  String get settingsBackupSection => 'Sauvegarde';

  @override
  String get settingsExportTitle => 'Exporter la Base de Données';

  @override
  String get settingsExportSubtitle =>
      'Enregistrez une copie de tous vos médicaments et historique';

  @override
  String get settingsImportTitle => 'Importer la Base de Données';

  @override
  String get settingsImportSubtitle =>
      'Restaurez une sauvegarde précédemment exportée';

  @override
  String get settingsInfoTitle => 'Informations';

  @override
  String get settingsInfoContent =>
      '• Lors de l\'exportation, un fichier de sauvegarde sera créé que vous pourrez enregistrer sur votre appareil ou partager.\n\n• Lors de l\'importation, toutes les données actuelles seront remplacées par celles du fichier sélectionné.\n\n• Il est recommandé de faire des sauvegardes régulièrement.';

  @override
  String get settingsShareText => 'Sauvegarde de MedicApp';

  @override
  String get settingsExportSuccess => 'Base de données exportée correctement';

  @override
  String get settingsImportSuccess => 'Base de données importée correctement';

  @override
  String settingsExportError(String error) {
    return 'Erreur lors de l\'exportation : $error';
  }

  @override
  String settingsImportError(String error) {
    return 'Erreur lors de l\'importation : $error';
  }

  @override
  String get settingsFilePathError =>
      'Impossible d\'obtenir le chemin du fichier';

  @override
  String get settingsImportDialogTitle => 'Importer la Base de Données';

  @override
  String get settingsImportDialogMessage =>
      'Cette action remplacera toutes vos données actuelles par les données du fichier importé.\n\nÊtes-vous sûr de vouloir continuer ?';

  @override
  String get settingsRestartDialogTitle => 'Importation Terminée';

  @override
  String get settingsRestartDialogMessage =>
      'La base de données a été importée correctement.\n\nVeuillez redémarrer l\'application pour voir les modifications.';

  @override
  String get settingsRestartDialogButton => 'Compris';

  @override
  String get notificationsWillNotWork =>
      'Les notifications NE fonctionneront PAS sans cette permission.';

  @override
  String get debugMenuActivated => 'Menu de débogage activé';

  @override
  String get debugMenuDeactivated => 'Menu de débogage désactivé';

  @override
  String nextDoseAt(String time) {
    return 'Prochaine prise : $time';
  }

  @override
  String pendingDose(String time) {
    return '⚠️ Dose en attente : $time';
  }

  @override
  String nextDoseTomorrow(String time) {
    return 'Prochaine prise : demain à $time';
  }

  @override
  String nextDoseOnDay(String dayName, int day, int month, String time) {
    return 'Prochaine prise : $dayName $day/$month à $time';
  }

  @override
  String get dayNameMon => 'Lun';

  @override
  String get dayNameTue => 'Mar';

  @override
  String get dayNameWed => 'Mer';

  @override
  String get dayNameThu => 'Jeu';

  @override
  String get dayNameFri => 'Ven';

  @override
  String get dayNameSat => 'Sam';

  @override
  String get dayNameSun => 'Dim';

  @override
  String get whichDoseDidYouTake => 'Quelle prise avez-vous prise ?';

  @override
  String insufficientStockForThisDose(
    String needed,
    String unit,
    String available,
  ) {
    return 'Stock insuffisant pour cette prise\nNécessaire : $needed $unit\nDisponible : $available';
  }

  @override
  String doseRegisteredAtTime(String name, String time, String stock) {
    return 'Prise de $name enregistrée à $time\nStock restant : $stock';
  }

  @override
  String get allDosesCompletedToday =>
      '✓ Toutes les prises d\'aujourd\'hui terminées';

  @override
  String remainingDosesToday(int count) {
    return 'Prises restantes aujourd\'hui : $count';
  }

  @override
  String manualDoseRegistered(
    String name,
    String quantity,
    String unit,
    String stock,
  ) {
    return 'Prise manuelle de $name enregistrée\nQuantité : $quantity $unit\nStock restant : $stock';
  }

  @override
  String medicationSuspended(String name) {
    return '$name suspendu\nAucune autre notification ne sera programmée';
  }

  @override
  String medicationReactivated(String name) {
    return '$name réactivé\nNotifications reprogrammées';
  }

  @override
  String currentStock(String stock) {
    return 'Stock actuel : $stock';
  }

  @override
  String get quantityToAdd => 'Quantité à ajouter';

  @override
  String example(String example) {
    return 'Ex : $example';
  }

  @override
  String lastRefill(String amount, String unit) {
    return 'Dernier rechargement : $amount $unit';
  }

  @override
  String get refillButton => 'Recharger';

  @override
  String stockRefilled(
    String name,
    String amount,
    String unit,
    String newStock,
  ) {
    return 'Stock de $name rechargé\nAjouté : $amount $unit\nNouveau stock : $newStock';
  }

  @override
  String availableStock(String stock) {
    return 'Stock disponible : $stock';
  }

  @override
  String get quantityTaken => 'Quantité prise';

  @override
  String get registerButton => 'Enregistrer';

  @override
  String get registerManualDose => 'Enregistrer une prise manuelle';

  @override
  String get refillMedication => 'Recharger le médicament';

  @override
  String get resumeMedication => 'Réactiver le médicament';

  @override
  String get suspendMedication => 'Suspendre le médicament';

  @override
  String get editMedicationButton => 'Modifier le médicament';

  @override
  String get deleteMedicationButton => 'Supprimer le médicament';

  @override
  String medicationDeletedShort(String name) {
    return '$name supprimé';
  }

  @override
  String get noMedicationsRegistered => 'Aucun médicament enregistré';

  @override
  String get addMedicationHint => 'Appuyez sur le bouton + pour en ajouter un';

  @override
  String get pullToRefresh => 'Tirez vers le bas pour recharger';

  @override
  String get batteryOptimizationWarning =>
      'Pour que les notifications fonctionnent, désactivez les restrictions de batterie :';

  @override
  String get batteryOptimizationInstructions =>
      'Paramètres → Applications → MedicApp → Batterie → \"Sans restrictions\"';

  @override
  String get openSettings => 'Ouvrir les paramètres';

  @override
  String get todayDosesLabel => 'Prises d\'aujourd\'hui :';

  @override
  String doseOfMedicationAt(String name, String time) {
    return 'Prise de $name à $time';
  }

  @override
  String currentStatus(String status) {
    return 'État actuel : $status';
  }

  @override
  String get whatDoYouWantToDo => 'Que voulez-vous faire ?';

  @override
  String get deleteButton => 'Supprimer';

  @override
  String get markAsSkipped => 'Marquer comme Omise';

  @override
  String get markAsTaken => 'Marquer comme Prise';

  @override
  String doseDeletedAt(String time) {
    return 'Prise de $time supprimée';
  }

  @override
  String errorDeleting(String error) {
    return 'Erreur lors de la suppression : $error';
  }

  @override
  String doseMarkedAs(String time, String status) {
    return 'Prise de $time marquée comme $status';
  }

  @override
  String errorChangingStatus(String error) {
    return 'Erreur lors du changement d\'état : $error';
  }

  @override
  String medicationUpdatedShort(String name) {
    return '$name mis à jour';
  }

  @override
  String get activateAlarmsPermission => 'Activer \"Alarmes et rappels\"';

  @override
  String get alarmsPermissionDescription =>
      'Cette permission permet aux notifications de se déclencher exactement à l\'heure configurée.';

  @override
  String get notificationDebugTitle => 'Débogage des Notifications';

  @override
  String notificationPermissions(String enabled) {
    return '✓ Permissions de notifications : $enabled';
  }

  @override
  String exactAlarmsAndroid12(String enabled) {
    return '⏰ Alarmes exactes (Android 12+) : $enabled';
  }

  @override
  String get importantWarning => '⚠️ IMPORTANT';

  @override
  String get withoutPermissionNoNotifications =>
      'Sans cette permission, les notifications NE se déclencheront PAS.';

  @override
  String get alarmsSettings =>
      'Paramètres → Applications → MedicApp → Alarmes et rappels';

  @override
  String pendingNotificationsCount(int count) {
    return '📊 Notifications en attente : $count';
  }

  @override
  String medicationsWithSchedules(int withSchedules, int total) {
    return '💊 Médicaments avec horaires : $withSchedules/$total';
  }

  @override
  String get scheduledNotifications => 'Notifications programmées :';

  @override
  String get noScheduledNotifications => '⚠️ Aucune notification programmée';

  @override
  String get notificationHistory => 'Historique des Notifications';

  @override
  String get last24Hours => 'Dernières 24 heures';

  @override
  String get noTitle => 'Sans titre';

  @override
  String get medicationsAndSchedules => 'Médicaments et horaires :';

  @override
  String get noSchedulesConfigured => '⚠️ Aucun horaire configuré';

  @override
  String get closeButton => 'Fermer';

  @override
  String get testNotification => 'Tester la notification';

  @override
  String get testNotificationSent => 'Notification de test envoyée';

  @override
  String get testScheduledNotification => 'Tester programmée (1 min)';

  @override
  String get scheduledNotificationInOneMin =>
      'Notification programmée dans 1 minute';

  @override
  String get rescheduleNotifications => 'Reprogrammer les notifications';

  @override
  String get notificationsInfo => 'Infos sur les notifications';

  @override
  String notificationsRescheduled(int count) {
    return 'Notifications reprogrammées : $count';
  }

  @override
  String get yesText => 'Oui';

  @override
  String get noText => 'Non';

  @override
  String get notificationTypeDynamicFasting => 'Jeûne dynamique';

  @override
  String get notificationTypeScheduledFasting => 'Jeûne programmé';

  @override
  String get notificationTypeWeeklyPattern => 'Schéma hebdomadaire';

  @override
  String get notificationTypeSpecificDate => 'Date spécifique';

  @override
  String get notificationTypePostponed => 'Reportée';

  @override
  String get notificationTypeDailyRecurring => 'Quotidienne récurrente';

  @override
  String get beforeTaking => 'Avant de prendre';

  @override
  String get afterTaking => 'Après avoir pris';

  @override
  String get basedOnActualDose => 'Basé sur la prise réelle';

  @override
  String get basedOnSchedule => 'Basé sur l\'horaire';

  @override
  String today(int day, int month, int year) {
    return 'Aujourd\'hui $day/$month/$year';
  }

  @override
  String get returnToToday => 'Retour à aujourd\'hui';

  @override
  String tomorrow(int day, int month, int year) {
    return 'Demain $day/$month/$year';
  }

  @override
  String get todayOrLater => 'Aujourd\'hui ou ultérieur';

  @override
  String get pastDueWarning => '⚠️ EN RETARD';

  @override
  String get batteryOptimizationMenu => '⚙️ Optimisation de la batterie';

  @override
  String get alarmsAndReminders => '⚙️ Alarmes et rappels';

  @override
  String get notificationTypeScheduledFastingShort => 'Jeûne programmé';

  @override
  String get basedOnActualDoseShort => 'Basé sur la prise réelle';

  @override
  String get basedOnScheduleShort => 'Basé sur l\'horaire';

  @override
  String pendingNotifications(int count) {
    return '📊 Notifications en attente : $count';
  }

  @override
  String medicationsWithSchedulesInfo(int withSchedules, int total) {
    return '💊 Médicaments avec horaires : $withSchedules/$total';
  }

  @override
  String get noSchedulesConfiguredWarning => '⚠️ Aucun horaire configuré';

  @override
  String medicationInfo(String name) {
    return '💊 $name';
  }

  @override
  String notificationType(String type) {
    return '📋 Type : $type';
  }

  @override
  String scheduleDate(String date) {
    return '📅 Date : $date';
  }

  @override
  String scheduleTime(String time) {
    return '⏰ Heure : $time';
  }

  @override
  String notificationId(int id) {
    return 'ID : $id';
  }

  @override
  String get takenStatus => 'Prise';

  @override
  String get skippedStatus => 'Omise';

  @override
  String durationEstimate(String name, String stock, int days) {
    return '$name\nStock : $stock\nDurée estimée : $days jours';
  }

  @override
  String errorChanging(String error) {
    return 'Erreur lors du changement d\'état : $error';
  }

  @override
  String get testScheduled1Min => 'Tester programmée (1 min)';

  @override
  String get alarmsAndRemindersMenu => '⚙️ Alarmes et rappels';

  @override
  String medicationStockInfo(String name, String stock) {
    return '$name\nStock : $stock';
  }

  @override
  String takenTodaySingle(String quantity, String unit, String time) {
    return 'Pris aujourd\'hui : $quantity $unit à $time';
  }

  @override
  String takenTodayMultiple(int count, String quantity, String unit) {
    return 'Pris aujourd\'hui : $count fois ($quantity $unit)';
  }

  @override
  String get done => 'Terminé';

  @override
  String get suspended => 'Suspendu';

  @override
  String get activeFastingPeriodsTitle => 'Jeûnes Actifs';

  @override
  String get fastingCompleted =>
      'Jeûne terminé ! Vous pouvez manger maintenant';
}
