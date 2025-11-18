import 'package:flutter/material.dart';

enum TreatmentDurationType {
  everyday('Todos los días'),
  untilFinished('Hasta acabar la medicación'),
  specificDates('Fechas específicas'),
  weeklyPattern('Días de la semana'),
  intervalDays('Cada N días'),
  asNeeded('Según necesidad');

  final String displayName;

  const TreatmentDurationType(this.displayName);

  IconData get icon => switch (this) {
        .everyday => Icons.event_repeat,
        .untilFinished => Icons.medical_services,
        .specificDates => Icons.calendar_today,
        .weeklyPattern => Icons.date_range,
        .intervalDays => Icons.repeat,
        .asNeeded => Icons.healing,
      };

  Color getColor(BuildContext context) => switch (this) {
        .everyday => Theme.of(context).colorScheme.primary,
        .untilFinished => Theme.of(context).colorScheme.tertiary,
        .specificDates => Colors.deepPurple,
        .weeklyPattern => Colors.teal,
        .intervalDays => Colors.orange,
        .asNeeded => Colors.indigo,
      };
}
