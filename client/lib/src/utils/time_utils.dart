import 'package:flutter/material.dart';

extension DateTimeUtils on DateTime {
  DateTime atTimeOfDay(TimeOfDay timeOfDay)  {
    final val = DateTime(year, month, day, timeOfDay.hour, timeOfDay.minute, 0, 0, 0);
    return val;
  }
  //=> DateTime(year, month, day, timeOfDay.hour, timeOfDay.minute, 11, 22, 33);

  bool isBetween(TimeOfDay timeOfDay, Duration duration) {
    final start = atTimeOfDay(timeOfDay);
    final end = start.add(duration);
    return isAfter(start) && isBefore(end);
  }

  int get adjustedWeekday => (weekday % 7) + 1; // Sun = 1, Monday = 2, ..., Saturday = 7

  int get nextAdjustedWeekday => (adjustedWeekday % 7) + 1;
}

extension TimeOfDayUtils on TimeOfDay {
  bool isBefore(TimeOfDay other) {
    return (hour < other.hour) || (hour == other.hour) && (minute < other.minute);
  }

  bool isAfter(TimeOfDay other) => !isBefore(other);

  Duration durationUntil(TimeOfDay other) {
    final delta = other.inMinutes - inMinutes;
    final minutes = delta >= 0 ? delta : (delta % 1440);
    return Duration(minutes: minutes);
  }

  int get inMinutes => hour*60 + minute;

  String get serialized => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

}

