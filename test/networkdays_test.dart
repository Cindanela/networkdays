import 'package:checks/checks.dart';
import 'package:networkdays/networkdays.dart';
import 'package:test/test.dart';

void main() {
  group('networkDays', () {
    test('basic count across a standard week', () {
      // Mon 2024-01-08 → Fri 2024-01-12: 5 working days
      check(networkDays(DateTime(2024, 1, 8), DateTime(2024, 1, 12))).equals(5);
    });

    test('single day (same start and end) is 1', () {
      check(networkDays(DateTime(2024, 1, 8), DateTime(2024, 1, 8))).equals(1);
    });

    test('holiday on a weekday reduces count', () {
      // Mon–Fri, one holiday on Wed
      check(
        networkDays(
          DateTime(2024, 1, 8),
          DateTime(2024, 1, 12),
          holidays: [DateTime(2024, 1, 10)],
        ),
      ).equals(4);
    });

    test('holiday on a weekend has no effect on count', () {
      // Mon–Fri, holiday falls on Saturday
      check(
        networkDays(
          DateTime(2024, 1, 8),
          DateTime(2024, 1, 12),
          holidays: [DateTime(2024, 1, 13)], // Saturday
        ),
      ).equals(5);
    });

    test('end before start returns negative count', () {
      // Fri 2024-01-12 → Mon 2024-01-08: reversed → -5
      check(networkDays(DateTime(2024, 1, 12), DateTime(2024, 1, 8))).equals(-5);
    });

    test('DST boundary (spring-forward, US eastern)', () {
      // 2024-03-10 (Sun, DST change) → 2024-03-15 (Fri): Mon–Fri = 5 days
      check(
        networkDays(DateTime(2024, 3, 10), DateTime(2024, 3, 15)),
      ).equals(5);
    });

    test('leap year Feb 29 is counted as a workday', () {
      // 2024-02-29 is a Thursday
      check(
        networkDays(DateTime(2024, 2, 29), DateTime(2024, 2, 29)),
      ).equals(1);
    });

    test('multi-year range', () {
      // 2023-01-01 (Sun) → 2024-12-31 (Tue): ~522 weekdays
      final result = networkDays(DateTime(2023, 1, 1), DateTime(2024, 12, 31));
      check(result)
        ..isGreaterThan(500)
        ..isLessThan(540);
    });

    test('holiday datetime with time component is still recognized', () {
      // Holiday passed with a time part should be normalised
      check(
        networkDays(
          DateTime(2024, 1, 8),
          DateTime(2024, 1, 12),
          holidays: [DateTime(2024, 1, 10, 9, 30)],
        ),
      ).equals(4);
    });
  });

  group('networkDaysIntl', () {
    test('custom weekend: only Sunday off', () {
      // Mon 2024-01-08 → Sun 2024-01-14: 6 working days (Sun excluded)
      check(
        networkDaysIntl(
          DateTime(2024, 1, 8),
          DateTime(2024, 1, 14),
          weekendDays: {7},
        ),
      ).equals(6);
    });

    test('weekend days set to empty means every day counts', () {
      // Mon–Sun 7 days, no weekends
      check(
        networkDaysIntl(
          DateTime(2024, 1, 8),
          DateTime(2024, 1, 14),
          weekendDays: {},
        ),
      ).equals(7);
    });

    test('holiday on a custom weekend day has no effect', () {
      // Sunday is the only weekend day; holiday on Sunday is already excluded
      check(
        networkDaysIntl(
          DateTime(2024, 1, 8),
          DateTime(2024, 1, 14),
          weekendDays: {7},
          holidays: [DateTime(2024, 1, 14)], // Sunday
        ),
      ).equals(6);
    });

    test('end before start returns negative count', () {
      check(
        networkDaysIntl(
          DateTime(2024, 1, 12),
          DateTime(2024, 1, 8),
          weekendDays: {6, 7},
        ),
      ).equals(-5);
    });
  });

  group('getWorkdays', () {
    test('returns correct list for a standard Mon–Fri week', () {
      final days = getWorkdays(DateTime(2024, 1, 8), DateTime(2024, 1, 12));
      check(days).deepEquals([
        DateTime(2024, 1, 8),
        DateTime(2024, 1, 9),
        DateTime(2024, 1, 10),
        DateTime(2024, 1, 11),
        DateTime(2024, 1, 12),
      ]);
    });

    test('excludes holidays', () {
      final days = getWorkdays(
        DateTime(2024, 1, 8),
        DateTime(2024, 1, 12),
        holidays: [DateTime(2024, 1, 10)],
      );
      check(days).deepEquals([
        DateTime(2024, 1, 8),
        DateTime(2024, 1, 9),
        DateTime(2024, 1, 11),
        DateTime(2024, 1, 12),
      ]);
    });

    test('excludes weekends', () {
      // Mon 2024-01-08 → Sun 2024-01-14
      final days = getWorkdays(DateTime(2024, 1, 8), DateTime(2024, 1, 14));
      check(days)
        ..length.equals(5)
        ..first.equals(DateTime(2024, 1, 8)) // Mon
        ..last.equals(DateTime(2024, 1, 12)); // Fri
    });

    test('end before start returns chronological list', () {
      final forward = getWorkdays(DateTime(2024, 1, 8), DateTime(2024, 1, 12));
      final reversed = getWorkdays(DateTime(2024, 1, 12), DateTime(2024, 1, 8));
      check(reversed).deepEquals(forward);
    });

    test('leap year Feb 29 included when it is a weekday', () {
      // 2024-02-29 is Thursday
      final days = getWorkdays(DateTime(2024, 2, 28), DateTime(2024, 3, 1));
      check(days).contains(DateTime(2024, 2, 29));
    });

    test('DST boundary dates are included correctly', () {
      // Sun excluded, Mon–Fri included = 5 days
      final days = getWorkdays(DateTime(2024, 3, 10), DateTime(2024, 3, 15));
      check(days).length.equals(5);
    });

    test('multi-year range length matches networkDaysIntl', () {
      final s = DateTime(2022, 1, 1);
      final e = DateTime(2024, 12, 31);
      final days = getWorkdays(s, e);
      check(days).length.equals(networkDaysIntl(s, e));
    });
  });
}
