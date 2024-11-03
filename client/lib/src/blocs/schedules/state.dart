import 'package:equatable/equatable.dart';
import '../../model/model.dart';

class ScheduleState extends Equatable {
  final Schedule schedule;
  final int daysNonce;
  final int timeRangeNonce;

  const ScheduleState({required this.schedule, this.daysNonce = 0, this.timeRangeNonce = 0});

  ScheduleState copyWith({
    int? daysNonce,
    int? timeRangeNonce
  }) => ScheduleState(schedule: schedule, daysNonce: daysNonce ?? this.daysNonce, timeRangeNonce: timeRangeNonce ?? this.timeRangeNonce);

  @override
  List<Object?> get props => [schedule, daysNonce, timeRangeNonce];
}