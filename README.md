# networkdays

A pure-Dart package for counting and listing working days between two dates,
following Excel `NETWORKDAYS` / `NETWORKDAYS.INTL` semantics.

- Configurable weekend days (ISO weekday numbers Mon = 1 … Sun = 7)
- Optional holiday list (time components are ignored; holidays on weekends have
  no effect on the count)
- Negative count when `end` is before `start`, matching Excel behaviour
- `getWorkdays()` always returns dates in **chronological order** regardless of
  argument order

## Installation

```yaml
dependencies:
  networkdays: ^0.0.1
```

## Usage

```dart
import 'package:networkdays/networkdays.dart';
```

### `networkDays` — Excel NETWORKDAYS (Sat/Sun weekend)

```dart
// Mon 2024-01-08 → Fri 2024-01-12: 5 working days
final count = networkDays(
  DateTime(2024, 1, 8),
  DateTime(2024, 1, 12),
);
// count == 5

// With a public holiday on Wednesday
final withHoliday = networkDays(
  DateTime(2024, 1, 8),
  DateTime(2024, 1, 12),
  holidays: [DateTime(2024, 1, 10)],
);
// withHoliday == 4

// End before start → negative result
final negative = networkDays(DateTime(2024, 1, 12), DateTime(2024, 1, 8));
// negative == -5
```

### `networkDaysIntl` — custom weekend definition

```dart
// Middle-East work week: Friday–Saturday off (weekdays 5 and 6)
final count = networkDaysIntl(
  DateTime(2024, 1, 8),
  DateTime(2024, 1, 14),
  weekendDays: {5, 6},
);

// No weekend at all — every calendar day counts
final allDays = networkDaysIntl(
  DateTime(2024, 1, 8),
  DateTime(2024, 1, 14),
  weekendDays: {},
);
// allDays == 7
```

### `getWorkdays` — list of working days

```dart
final days = getWorkdays(
  DateTime(2024, 1, 8),
  DateTime(2024, 1, 12),
);
// [2024-01-08, 2024-01-09, 2024-01-10, 2024-01-11, 2024-01-12]

// Reversed arguments still return chronological order
final same = getWorkdays(DateTime(2024, 1, 12), DateTime(2024, 1, 8));
// same == days  ← always earliest → latest
```

### Integration with `almanac_sv`

[almanac_sv](https://pub.dev/packages/almanac_sv) provides a list of Swedish
public holidays as `DateTime` values. Pass them directly to the `holidays`
parameter:

```dart
import 'package:almanac_sv/almanac_sv.dart';
import 'package:networkdays/networkdays.dart';

// Fetch Swedish public holidays for the relevant years
final holidays = AlmanacSv.publicHolidays(year: 2024);

final workingDays = networkDays(
  DateTime(2024, 1, 1),
  DateTime(2024, 12, 31),
  holidays: holidays,
);

final workdayList = getWorkdays(
  DateTime(2024, 1, 1),
  DateTime(2024, 12, 31),
  holidays: holidays,
);
```

> **Note:** holidays that fall on a weekend are automatically ignored — they do
> not reduce the working-day count.

## Notes

- All `DateTime` inputs are normalised to date-only (`DateTime(y, m, d)`);
  time-of-day components are discarded.
- Day iteration uses field arithmetic (`day + 1`) rather than `Duration`
  addition, so DST transitions and leap-year boundaries are handled correctly.
- Multi-year ranges are supported; holidays are not auto-expanded across years.

## License

MIT — see [LICENSE](LICENSE).
