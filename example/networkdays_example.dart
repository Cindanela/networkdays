// ignore_for_file: avoid_print
import 'package:networkdays/networkdays.dart';

void main() {
  // --- networkDays (Sat/Sun weekend, Excel NETWORKDAYS) ---
  final count = networkDays(
    DateTime(2024, 1, 8), // Monday
    DateTime(2024, 1, 12), // Friday
  );
  print('Working days Mon–Fri: $count'); // 5

  final withHoliday = networkDays(
    DateTime(2024, 1, 8),
    DateTime(2024, 1, 12),
    holidays: [DateTime(2024, 1, 10)], // Wednesday public holiday
  );
  print('Working days with mid-week holiday: $withHoliday'); // 4

  final negative = networkDays(
    DateTime(2024, 1, 12), // end before start → negative
    DateTime(2024, 1, 8),
  );
  print('Reversed range: $negative'); // -5

  // --- networkDaysIntl (custom weekend) ---
  final middleEast = networkDaysIntl(
    DateTime(2024, 1, 8),
    DateTime(2024, 1, 14),
    weekendDays: {5, 6}, // Friday + Saturday off
  );
  print('Middle-East work week (Fri–Sat off): $middleEast'); // 5

  // --- getWorkdays (returns a List<DateTime>) ---
  final days = getWorkdays(
    DateTime(2024, 1, 8),
    DateTime(2024, 1, 12),
  );
  print('Workday dates:');
  for (final d in days) {
    print('  $d');
  }

  // Arguments can be reversed — list is always chronological
  final reversed = getWorkdays(
    DateTime(2024, 1, 12),
    DateTime(2024, 1, 8),
  );
  print('Same list despite reversed args: ${reversed == days}'); // true (equal values)
}
