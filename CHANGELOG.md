## 0.0.2

* Added `example/networkdays_example.dart` with runnable usage examples.
* Added library-level dartdoc comment; all public API now fully documented.
* Migrated tests from `flutter_test`/`expect()` to `package:test` +
  `package:checks` assertions.
* Added `package:coverage` dev dependency; test suite achieves 100% line
  coverage.

## 0.0.1

* Initial release.
* `networkDays` — count working days between two dates (Saturday/Sunday weekend,
  Excel NETWORKDAYS semantics).
* `networkDaysIntl` — count working days with a configurable set of weekend days
  (Excel NETWORKDAYS.INTL semantics).
* `getWorkdays` — return a chronologically ordered `List<DateTime>` of all
  working days in a date range.
* All functions accept a `holidays` list and normalize inputs to date-only.
* Negative counts returned when `end` is before `start`, matching Excel
  behaviour.
