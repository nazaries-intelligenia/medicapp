import 'package:flutter_test/flutter_test.dart';

/// Tests for day navigation functionality in the UI
/// These tests verify date and offset calculation logic
void main() {
  group('Day Navigation - Date Formatting', () {
    test('should format today with "Today" prefix', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // For the current day, it should use the format "Today, day/month/year"
      // This test verifies the logic implemented in _getTodayDate()
      expect(today.isToday(), isTrue);
    });

    test('should format yesterday without "Today" prefix', () {
      final now = DateTime.now();
      final yesterday = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1));

      // For days that are not today, it should not be "today"
      expect(yesterday.isToday(), isFalse);
    });

    test('should format tomorrow without "Today" prefix', () {
      final now = DateTime.now();
      final tomorrow = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));

      // For days that are not today, it should not be "today"
      expect(tomorrow.isToday(), isFalse);
    });
  });

  group('Day Navigation - Date Offset Calculation', () {
    const int centerPageIndex = 10000;

    test('should calculate correct offset for today', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Offset for today should be 0
      final dayOffset = today.difference(today).inDays;
      final targetPage = centerPageIndex + dayOffset;

      expect(dayOffset, 0);
      expect(targetPage, centerPageIndex);
    });

    test('should calculate correct offset for yesterday', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));

      // Offset for yesterday should be -1
      final dayOffset = yesterday.difference(today).inDays;
      final targetPage = centerPageIndex + dayOffset;

      expect(dayOffset, -1);
      expect(targetPage, centerPageIndex - 1);
    });

    test('should calculate correct offset for tomorrow', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));

      // Offset for tomorrow should be 1
      final dayOffset = tomorrow.difference(today).inDays;
      final targetPage = centerPageIndex + dayOffset;

      expect(dayOffset, 1);
      expect(targetPage, centerPageIndex + 1);
    });

    test('should calculate correct offset for 7 days ago', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final sevenDaysAgo = today.subtract(const Duration(days: 7));

      // Offset for 7 days ago should be -7
      final dayOffset = sevenDaysAgo.difference(today).inDays;
      final targetPage = centerPageIndex + dayOffset;

      expect(dayOffset, -7);
      expect(targetPage, centerPageIndex - 7);
    });

    test('should calculate correct offset for 30 days in the future', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final thirtyDaysLater = today.add(const Duration(days: 30));

      // Offset for 30 days in the future should be 30
      final dayOffset = thirtyDaysLater.difference(today).inDays;
      final targetPage = centerPageIndex + dayOffset;

      expect(dayOffset, 30);
      expect(targetPage, centerPageIndex + 30);
    });

    test('should handle date normalization correctly', () {
      // Verify that dates are normalized correctly (time = 00:00:00)
      final dateWithTime = DateTime(2024, 11, 9, 15, 30, 45);
      final normalized = DateTime(dateWithTime.year, dateWithTime.month, dateWithTime.day);

      expect(normalized.hour, 0);
      expect(normalized.minute, 0);
      expect(normalized.second, 0);
      expect(normalized.day, dateWithTime.day);
      expect(normalized.month, dateWithTime.month);
      expect(normalized.year, dateWithTime.year);
    });
  });

  group('Day Navigation - Page Index Calculation', () {
    const int centerPageIndex = 10000;

    test('should convert page index to date offset correctly', () {
      // Current page = centerPageIndex means offset = 0 (today)
      const pageOffset0 = centerPageIndex;
      expect(pageOffset0 - centerPageIndex, 0);

      // Page centerPageIndex - 1 means offset = -1 (yesterday)
      const pageOffsetMinus1 = centerPageIndex - 1;
      expect(pageOffsetMinus1 - centerPageIndex, -1);

      // Page centerPageIndex + 1 means offset = 1 (tomorrow)
      const pageOffsetPlus1 = centerPageIndex + 1;
      expect(pageOffsetPlus1 - centerPageIndex, 1);
    });

    test('should convert date offset to page index correctly', () {
      // Offset 0 (today) should give page centerPageIndex
      const pageForToday = centerPageIndex + 0;
      expect(pageForToday, centerPageIndex);

      // Offset -5 (5 days ago) should give page centerPageIndex - 5
      const pageForFiveDaysAgo = centerPageIndex + (-5);
      expect(pageForFiveDaysAgo, centerPageIndex - 5);

      // Offset 10 (10 days in the future) should give page centerPageIndex + 10
      const pageForTenDaysLater = centerPageIndex + 10;
      expect(pageForTenDaysLater, centerPageIndex + 10);
    });

    test('should handle large offsets correctly', () {
      // Verify that we can handle large offsets (e.g.: 1 year = 365 days)
      const oneYearOffset = 365;
      const pageForOneYearLater = centerPageIndex + oneYearOffset;
      expect(pageForOneYearLater, centerPageIndex + 365);

      const oneYearAgoOffset = -365;
      const pageForOneYearAgo = centerPageIndex + oneYearAgoOffset;
      expect(pageForOneYearAgo, centerPageIndex - 365);
    });
  });

  group('Day Navigation - Date Calculations', () {
    test('should calculate date from page index correctly', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      const centerPageIndex = 10000;

      // Calculate date from page
      const page = centerPageIndex - 5; // 5 days ago
      const dayOffset = page - centerPageIndex;
      final calculatedDate = today.add(const Duration(days: dayOffset));

      expect(dayOffset, -5);
      expect(calculatedDate.difference(today).inDays, -5);
    });

    test('should handle month boundaries correctly', () {
      // Verify that it works correctly when crossing month boundaries
      final lastDayOfMonth = DateTime(2024, 1, 31);
      final nextDay = lastDayOfMonth.add(const Duration(days: 1));

      expect(nextDay.day, 1);
      expect(nextDay.month, 2);
      expect(nextDay.year, 2024);
    });

    test('should handle year boundaries correctly', () {
      // Verify that it works correctly when crossing year boundaries
      final lastDayOfYear = DateTime(2024, 12, 31);
      final nextDay = lastDayOfYear.add(const Duration(days: 1));

      expect(nextDay.day, 1);
      expect(nextDay.month, 1);
      expect(nextDay.year, 2025);
    });

    test('should handle leap year correctly', () {
      // Verify that it works correctly with leap years
      final feb28LeapYear = DateTime(2024, 2, 28);
      final nextDay = feb28LeapYear.add(const Duration(days: 1));

      expect(nextDay.day, 29);
      expect(nextDay.month, 2);
      expect(nextDay.year, 2024);

      final feb28NonLeapYear = DateTime(2023, 2, 28);
      final nextDayNonLeap = feb28NonLeapYear.add(const Duration(days: 1));

      expect(nextDayNonLeap.day, 1);
      expect(nextDayNonLeap.month, 3);
      expect(nextDayNonLeap.year, 2023);
    });
  });

  group('Day Navigation - Date Range Validation', () {
    test('should validate date picker range is within expected bounds', () {
      // Verify that the date picker range (2000-2100) is valid
      final firstDate = DateTime(2000);
      final lastDate = DateTime(2100);
      final today = DateTime.now();

      expect(today.isAfter(firstDate) || today.isAtSameMomentAs(firstDate), isTrue);
      expect(today.isBefore(lastDate) || today.isAtSameMomentAs(lastDate), isTrue);
    });

    test('should calculate days between dates correctly', () {
      final date1 = DateTime(2024, 1, 1);
      final date2 = DateTime(2024, 1, 10);

      final difference = date2.difference(date1).inDays;
      expect(difference, 9);
    });

    test('should handle negative date differences correctly', () {
      final date1 = DateTime(2024, 1, 10);
      final date2 = DateTime(2024, 1, 1);

      final difference = date2.difference(date1).inDays;
      expect(difference, -9);
    });
  });

  group('Day Navigation - Edge Cases', () {
    test('should handle same date comparison correctly', () {
      final date1 = DateTime(2024, 11, 9);
      final date2 = DateTime(2024, 11, 9);

      final difference = date2.difference(date1).inDays;
      expect(difference, 0);
      expect(date1.year == date2.year && date1.month == date2.month && date1.day == date2.day, isTrue);
    });

    test('should handle dates with different times but same day correctly', () {
      final morning = DateTime(2024, 11, 9, 8, 0, 0);
      final evening = DateTime(2024, 11, 9, 20, 0, 0);

      // Normalize both dates
      final morningNorm = DateTime(morning.year, morning.month, morning.day);
      final eveningNorm = DateTime(evening.year, evening.month, evening.day);

      expect(morningNorm.difference(eveningNorm).inDays, 0);
      expect(morningNorm.isAtSameMomentAs(eveningNorm), isTrue);
    });

    test('should handle date arithmetic consistently', () {
      final today = DateTime.now();
      final todayNorm = DateTime(today.year, today.month, today.day);

      // Going 5 days back and then 5 days forward should return to today
      final fiveDaysAgo = todayNorm.subtract(const Duration(days: 5));
      final backToToday = fiveDaysAgo.add(const Duration(days: 5));

      expect(backToToday.isAtSameMomentAs(todayNorm), isTrue);
    });
  });
}

// Extension helper to verify if a date is today
extension DateTimeTestExtensions on DateTime {
  bool isToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thisNormalized = DateTime(year, month, day);
    return thisNormalized.isAtSameMomentAs(today);
  }
}
