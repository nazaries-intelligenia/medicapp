import 'dart:convert';
import 'treatment_duration_type.dart';

/// Modelo que representa la relación muchos-a-muchos entre personas y medicamentos.
///
/// IMPORTANTE: Esta tabla ahora almacena la PAUTA INDIVIDUAL de cada persona para un medicamento.
/// El medicamento base (nombre, tipo, stock) está en la tabla medications.
/// Cada persona puede tener su propia pauta (horarios, duración, etc.) para el mismo medicamento.
class PersonMedication {
  final String id;
  final String personId;
  final String medicationId;
  final String assignedDate;

  // === PAUTA INDIVIDUAL (datos específicos de cada persona) ===
  final TreatmentDurationType durationType;
  final int dosageIntervalHours;
  final Map<String, double> doseSchedule; // TimeString -> doseQuantity
  final List<String> takenDosesToday;
  final List<String> skippedDosesToday;
  final String? takenDosesDate;
  final List<String>? selectedDates;
  final List<int>? weeklyDays;
  final int? dayInterval;
  final String? startDate;
  final String? endDate;
  final bool requiresFasting;
  final String? fastingType;
  final int? fastingDurationMinutes;
  final bool notifyFasting;
  final bool isSuspended;

  PersonMedication({
    required this.id,
    required this.personId,
    required this.medicationId,
    required this.assignedDate,
    required this.durationType,
    required this.dosageIntervalHours,
    required this.doseSchedule,
    this.takenDosesToday = const [],
    this.skippedDosesToday = const [],
    this.takenDosesDate,
    this.selectedDates,
    this.weeklyDays,
    this.dayInterval,
    this.startDate,
    this.endDate,
    this.requiresFasting = false,
    this.fastingType,
    this.fastingDurationMinutes,
    this.notifyFasting = false,
    this.isSuspended = false,
  });

  /// Get dose times from the schedule
  List<String> get doseTimes => doseSchedule.keys.toList()..sort();

  /// Convierte el objeto a un Map para guardar en la base de datos
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personId': personId,
      'medicationId': medicationId,
      'assignedDate': assignedDate,
      'durationType': durationType.name,
      'dosageIntervalHours': dosageIntervalHours,
      'doseSchedule': jsonEncode(doseSchedule),
      'takenDosesToday': takenDosesToday.join(','),
      'skippedDosesToday': skippedDosesToday.join(','),
      'takenDosesDate': takenDosesDate,
      'selectedDates': selectedDates?.join(','),
      'weeklyDays': weeklyDays?.join(','),
      'dayInterval': dayInterval,
      'startDate': startDate,
      'endDate': endDate,
      'requiresFasting': requiresFasting ? 1 : 0,
      'fastingType': fastingType,
      'fastingDurationMinutes': fastingDurationMinutes,
      'notifyFasting': notifyFasting ? 1 : 0,
      'isSuspended': isSuspended ? 1 : 0,
    };
  }

  /// Crea un objeto PersonMedication desde un Map de la base de datos
  factory PersonMedication.fromJson(Map<String, dynamic> json) {
    // Parse doseSchedule from JSON string
    final doseScheduleStr = json['doseSchedule'] as String? ?? '{}';
    Map<String, double> doseSchedule = {};

    if (doseScheduleStr.isNotEmpty && doseScheduleStr != '{}') {
      try {
        final decoded = jsonDecode(doseScheduleStr) as Map<String, dynamic>;
        doseSchedule = decoded.map((key, value) => MapEntry(key, (value as num).toDouble()));
      } catch (e) {
        // If JSON parsing fails, try legacy regex parsing for backward compatibility
        final cleaned = doseScheduleStr.replaceAll('{', '').replaceAll('}', '').trim();
        if (cleaned.isNotEmpty) {
          for (final pair in cleaned.split(',')) {
            final parts = pair.trim().split(':');
            if (parts.length >= 2) {
              final timeMatch = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(pair);
              if (timeMatch != null) {
                final time = '${timeMatch.group(1)!.padLeft(2, '0')}:${timeMatch.group(2)}';
                final doseMatch = RegExp(r'(\d+\.?\d*)').allMatches(pair).toList();
                if (doseMatch.length >= 3) {
                  final dose = double.parse(doseMatch[2].group(0)!);
                  doseSchedule[time] = dose;
                }
              }
            }
          }
        }
      }
    }

    return PersonMedication(
      id: json['id'] as String,
      personId: json['personId'] as String,
      medicationId: json['medicationId'] as String,
      assignedDate: json['assignedDate'] as String,
      durationType: TreatmentDurationType.values.firstWhere(
        (e) => e.name == json['durationType'],
        orElse: () => TreatmentDurationType.everyday,
      ),
      dosageIntervalHours: json['dosageIntervalHours'] as int? ?? 0,
      doseSchedule: doseSchedule,
      takenDosesToday: (json['takenDosesToday'] as String?)?.split(',').where((s) => s.isNotEmpty).toList() ?? [],
      skippedDosesToday: (json['skippedDosesToday'] as String?)?.split(',').where((s) => s.isNotEmpty).toList() ?? [],
      takenDosesDate: json['takenDosesDate'] as String?,
      selectedDates: (json['selectedDates'] as String?)?.split(',').where((s) => s.isNotEmpty).toList(),
      weeklyDays: (json['weeklyDays'] as String?)?.split(',').where((s) => s.isNotEmpty).map((s) => int.parse(s)).toList(),
      dayInterval: json['dayInterval'] as int?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      requiresFasting: (json['requiresFasting'] as int?) == 1,
      fastingType: json['fastingType'] as String?,
      fastingDurationMinutes: json['fastingDurationMinutes'] as int?,
      notifyFasting: (json['notifyFasting'] as int?) == 1,
      isSuspended: (json['isSuspended'] as int?) == 1,
    );
  }

  /// Crea una copia del objeto con valores opcionales modificados
  PersonMedication copyWith({
    String? id,
    String? personId,
    String? medicationId,
    String? assignedDate,
    TreatmentDurationType? durationType,
    int? dosageIntervalHours,
    Map<String, double>? doseSchedule,
    List<String>? takenDosesToday,
    List<String>? skippedDosesToday,
    String? takenDosesDate,
    List<String>? selectedDates,
    List<int>? weeklyDays,
    int? dayInterval,
    String? startDate,
    String? endDate,
    bool? requiresFasting,
    String? fastingType,
    int? fastingDurationMinutes,
    bool? notifyFasting,
    bool? isSuspended,
  }) {
    return PersonMedication(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      medicationId: medicationId ?? this.medicationId,
      assignedDate: assignedDate ?? this.assignedDate,
      durationType: durationType ?? this.durationType,
      dosageIntervalHours: dosageIntervalHours ?? this.dosageIntervalHours,
      doseSchedule: doseSchedule ?? this.doseSchedule,
      takenDosesToday: takenDosesToday ?? this.takenDosesToday,
      skippedDosesToday: skippedDosesToday ?? this.skippedDosesToday,
      takenDosesDate: takenDosesDate ?? this.takenDosesDate,
      selectedDates: selectedDates ?? this.selectedDates,
      weeklyDays: weeklyDays ?? this.weeklyDays,
      dayInterval: dayInterval ?? this.dayInterval,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      requiresFasting: requiresFasting ?? this.requiresFasting,
      fastingType: fastingType ?? this.fastingType,
      fastingDurationMinutes: fastingDurationMinutes ?? this.fastingDurationMinutes,
      notifyFasting: notifyFasting ?? this.notifyFasting,
      isSuspended: isSuspended ?? this.isSuspended,
    );
  }

  @override
  String toString() {
    return 'PersonMedication(id: $id, personId: $personId, medicationId: $medicationId, assignedDate: $assignedDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PersonMedication &&
        other.id == id &&
        other.personId == personId &&
        other.medicationId == medicationId &&
        other.assignedDate == assignedDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        personId.hashCode ^
        medicationId.hashCode ^
        assignedDate.hashCode;
  }
}
