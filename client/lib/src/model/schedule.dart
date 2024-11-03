
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'preset.dart';
import '../utils/time_utils.dart';

@Entity()
class Schedule {
  static const everyDay = [1, 2, 3, 4, 5, 6, 7];
  static const weekdays = [2, 3, 4, 5, 6];
  
  @Id()
  int id;

  List<int> days; // allowed to contain only 1-7 ~ sunday-saturday

  @Transient()
  TimeOfDay startTime; // INCLUSIVE (up to a minute resolution)

  @Transient()
  TimeOfDay endTime; // EXCLUSIVE (up to a minute resolution)

  int get dbStartTime => startTime.hour * 100 + startTime.minute;
  set dbStartTime(int value) {
    startTime = TimeOfDay(hour: value ~/ 100, minute: value % 100);
  }

  int get dbEndTime => endTime.hour * 100 + endTime.minute;
  set dbEndTime(int value) {
    endTime = TimeOfDay(hour: value ~/ 100, minute: value % 100);
  }
  
  final preset = ToOne<Preset>();

  Schedule({this.id = 0, required this.days, this.startTime = const TimeOfDay(hour: 13, minute: 00), this.endTime = const TimeOfDay(hour: 14, minute: 00)});

  bool activeAt(DateTime time) {
    final duration = startTime.durationUntil(endTime);
    final startDate = time.atTimeOfDay(startTime);
    final endDate = startDate.add(duration);
    if (startDate.day == endDate.day) {
      if (days.contains(startDate.adjustedWeekday)) {
        final isAfterStart = (time == startDate) || time.isAfter(startDate);
        if (!isAfterStart) return false;
        return time.isBefore(endDate);
      }
    }
    else {
      final timeInMinutes = TimeOfDay.fromDateTime(time).inMinutes;
      if (days.contains(time.adjustedWeekday) && (timeInMinutes >= startTime.inMinutes)) {
        return true;
      }
      else if (days.contains(time.nextAdjustedWeekday) && (timeInMinutes < endTime.inMinutes)) {
        return true;
      }
    }

    return false;
  }

  Map asMap() => {
    'days': days,
    'startTimeHours': startTime.hour,
    'startTimeMinutes': startTime.minute,
    'endTimeHours': endTime.hour,
    'endTimeMinutes': endTime.minute
  };

  @override
  String toString() => 'Schedule(id $id, days: $days, $startTime - $endTime)';
}