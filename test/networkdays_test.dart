import 'package:flutter_test/flutter_test.dart';
import 'package:networkdays/networkdays.dart';

void main() {
  group('networkDays', () {
    test('basic count across a standard week', () {
      // Mon 2024-01-08 → Fri 2024-01-12: 5 working days
      expect(
        networkDays(DateTime(2024, 1, 8), DateTime(2024, 1, 12)),
        5,
      );
    });

    test('single day (same start and end) is 1', () {
      expect(networkDays(DateTime(2024, 1, 8), DateTime(2024, 1, 8)), 1);
    });

    test('holiday on a weekday reduces count', () {
      // Mon–Fri, one holiday on Wed
      expect(
        networkDays(
          DateTime(2024, 1, 8),
          DateTime(2024, 1, 12),
          holidays: [DateTime(2024, 1, 10)],
        ),
        4,
      );
    });

    test('holiday on a weekend has no effect on count', () {
      // Mon–Fri, holiday falls on Saturday
      expect(
        networkDays(
          DateTime(2024, 1, 8),
          DateTime(2024, 1, 12),
          holidays: [DateTime(2024, 1, 13)], // Saturday
        ),
        5,
      );
    });

    test('end before start returns negative count', () {
      // Fri 2024-01-12 → Mon 2024-01-08: reversed, still 5 days → -5
      expect(
        networkDays(DateTime(2024, 1, 12), DateTime(2024, 1, 8)),
        -5,
      );
    });

    test('DST boundary (spring-forward, US eastern)', () {
      // 2024-03-10 (Sun, DST change) → 2024-03-15 (Fri): Mon–Fri = 5 days
      expect(
        networkDays(DateTime(2024, 3, 10), DateTime(2024, 3, 15)),
        5,
      );
    });

    test('leap year Feb 29 is counted as a workday', () {
      // 2024-02-29 is a Thursday
      expect(
        networkDays(DateTime(2024, 2, 29), DateTime(2024, 2, 29)),
        1,
      );
    });

    test('multi-year range', () {
      // 2023-01-01 (Sun) → 2024-12-31 (Tue)
      // Pre-computed expected: use networkDaysIntl as reference and cross-check
      final result = networkDays(DateTime(2023, 1, 1), DateTime(2024, 12, 31));
      // 2 years ≈ 730 days; ~522 weekdays expected
      expect(result, greaterThan(500));
      expect(result, lessThan(540));
    });

    test('holiday datetime with time component is still recognized', () {
      // Holiday passed with a time part should be normalized
      expect(
        networkDays(
          DateTime(2024, 1, 8),
          DateTime(2024, 1, 12),
          holidays: [DateTime(2024, 1, 10, 9, 30)],
        ),
        4,
      );
    });
  });

  group('networkDaysIntl', () {
    test('custom weekend: only Sunday off', () {
      // Mon 2024-01-08 → Sun 2024-01-14: 6 working days (Sun excluded)
      expect(
        networkDaysIntl(
          DateTime(2024, 1, 8),
          DateTime(2024, 1, 14),
          weekendDays: {7},
        ),
        6,
      );
    });

    test('weekend days set to empty means every day counts', () {
      // Mon–Sun 7 days, no weekends
      expect(
        networkDaysIntl(
          DateTime(2024, 1, 8),
          DateTime(2024, 1, 14),
          weekendDays: {},
        ),
        7,
      );
    });

    test('holiday on a custom weekend day has no effect', () {
      // Saturday is not a weekend in this config; holiday on Sunday has no effect
      expect(
        networkDaysIntl(
          DateTime(2024, 1, 8),
          DateTime(2024, 1, 14),
          weekendDays: {7}, // only Sunday off
          holidays: [DateTime(2024, 1, 14)], // Sunday holiday — already excluded
        ),
        6,
      );
    });

    test('end before start returns negative count', () {
      expect(
        networkDaysIntl(
          DateTime(2024, 1, 12),
          DateTime(2024, 1, 8),
          weekendDays: {6, 7},
        ),
        -5,
      );
    });
  });

  group('getWorkdays', () {
    test('returns correct list for a standard Mon–Fri week', () {
      final days = getWorkdays(DateTime(2024, 1, 8), DateTime(2024, 1, 12));
      expect(days, [
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
      expect(days, [
        DateTime(2024, 1, 8),
        DateTime(2024, 1, 9),
        DateTime(2024, 1, 11),
        DateTime(2024, 1, 12),
      ]);
    });

    test('excludes weekends', () {
      // Mon 2024-01-08 → Sun 2024-01-14
      final days = getWorkdays(DateTime(2024, 1, 8), DateTime(2024, 1, 14));
      expect(days.length, 5);
      expect(days.first, DateTime(2024, 1, 8)); // Mon
      expect(days.last, DateTime(2024, 1, 12)); // Fri
    });

    test('end before start returns chronological list', () {
      final forward = getWorkdays(DateTime(2024, 1, 8), DateTime(2024, 1, 12));
      final reversed = getWorkdays(DateTime(2024, 1, 12), DateTime(2024, 1, 8));
      expect(reversed, forward);
    });

    test('leap year Feb 29 included when it is a weekday', () {
      // 2024-02-29 is Thursday
      final days = getWorkdays(DateTime(2024, 2, 28), DateTime(2024, 3, 1));
      expect(days.contains(DateTime(2024, 2, 29)), isTrue);
    });

    test('DST boundary dates are included correctly', () {
      final days = getWorkdays(DateTime(2024, 3, 10), DateTime(2024, 3, 15));
      // Sun excluded, Mon–Fri included = 5 days
      expect(days.length, 5);
    });

    test('multi-year range length matches networkDaysIntl', () {
      final s = DateTime(2022, 1, 1);
      final e = DateTime(2024, 12, 31);
      final days = getWorkdays(s, e);
      expect(days.length, networkDaysIntl(s, e));
    });
  });
}
