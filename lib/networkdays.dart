/// Strips the time-of-day component, returning a date-only [DateTime].
DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

/// Converts [holidays] to a [Set] of date-only [DateTime] values so that
/// lookup is O(1) and time components are ignored during comparison.
Set<DateTime> _normalizeHolidays(List<DateTime> holidays) =>
    holidays.map(_dateOnly).toSet();

/// Returns the number of working days between [start] and [end] (inclusive),
/// excluding [weekendDays] (ISO weekday numbers: Mon=1 … Sun=7) and [holidays].
///
/// Mirrors Excel NETWORKDAYS.INTL: returns a negative count when [end] is
/// before [start]. When [start] and [end] are the same date, returns 1 if that
/// day is a working day, or 0 if it falls on a weekend or holiday.
int networkDaysIntl(
  DateTime start,
  DateTime end, {
  Set<int> weekendDays = const {6, 7},
  List<DateTime> holidays = const [],
}) {
  final s = _dateOnly(start);
  final e = _dateOnly(end);
  final holidaySet = _normalizeHolidays(holidays);

  final forward = !e.isBefore(s);
  final from = forward ? s : e;
  final to = forward ? e : s;

  int count = 0;
  DateTime current = from;
  while (!current.isAfter(to)) {
    if (!weekendDays.contains(current.weekday) &&
        !holidaySet.contains(current)) {
      count++;
    }
    current = DateTime(current.year, current.month, current.day + 1);
  }

  return forward ? count : -count;
}

/// Returns the number of working days between [start] and [end] (inclusive),
/// excluding Saturday/Sunday and [holidays].
///
/// Mirrors Excel NETWORKDAYS: returns a negative count when [end] is
/// before [start]. When [start] and [end] are the same date, returns 1 if that
/// day is a working day, or 0 if it falls on a weekend or holiday.
int networkDays(
  DateTime start,
  DateTime end, {
  List<DateTime> holidays = const [],
}) =>
    networkDaysIntl(start, end, weekendDays: const {6, 7}, holidays: holidays);

/// Returns the list of working days between [start] and [end] (inclusive),
/// excluding [weekendDays] and [holidays].
///
/// Always iterates from the earlier date to the later date; the list is
/// returned in chronological order even when [end] is before [start].
List<DateTime> getWorkdays(
  DateTime start,
  DateTime end, {
  Set<int> weekendDays = const {6, 7},
  List<DateTime> holidays = const [],
}) {
  final s = _dateOnly(start);
  final e = _dateOnly(end);
  final holidaySet = _normalizeHolidays(holidays);

  final from = !e.isBefore(s) ? s : e;
  final to = !e.isBefore(s) ? e : s;

  final result = <DateTime>[];
  DateTime current = from;
  while (!current.isAfter(to)) {
    if (!weekendDays.contains(current.weekday) &&
        !holidaySet.contains(current)) {
      result.add(current);
    }
    current = DateTime(current.year, current.month, current.day + 1);
  }
  return result;
}
