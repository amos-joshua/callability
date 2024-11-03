import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app_settings/app_settings.dart';
import '../../repositories/repositories.dart';
import '../../model/model.dart';
import 'state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final DBRepository database;
  final AppSettingsCubit appSettingsCubit;
  ScheduleCubit(Schedule schedule, {required this.appSettingsCubit,  required this.database}): super(ScheduleState(schedule: schedule));
  
  void toggleDay(int day) {
    if (state.schedule.days.contains(day)) {
      state.schedule.days.remove(day);
    }
    else {
      state.schedule.days.add(day);
    }
    database.saveSchedule(state.schedule).then((val) async {
      appSettingsCubit.determineActivePreset();
    });
    emit(state.copyWith(daysNonce: state.daysNonce + 1));
  }

  void updateDays(List<int> newDays) {
    state.schedule.days = newDays;
    database.saveSchedule(state.schedule).then((val) async {
      appSettingsCubit.determineActivePreset();
    });
    emit(state.copyWith(daysNonce: state.daysNonce + 1));
  }

  void updateStartTime(TimeOfDay newTime) {
    state.schedule.startTime = newTime;
    database.saveSchedule(state.schedule).then((val) async {
      appSettingsCubit.determineActivePreset();
    });
    emit(state.copyWith(timeRangeNonce: state.timeRangeNonce + 1));
  }

  void updateEndTime(TimeOfDay newTime) {
    state.schedule.endTime = newTime;
    database.saveSchedule(state.schedule).then((val) async {
      appSettingsCubit.determineActivePreset();
    });
    emit(state.copyWith(timeRangeNonce: state.timeRangeNonce + 1));
  }

  static Widget provider(Schedule schedule, {required Widget child}) {
    return BlocProvider(
      create: (context) => ScheduleCubit(schedule, appSettingsCubit: context.read<AppSettingsCubit>(), database: context.read<DBRepository>()),
      child: child,
    );
  }

  static BlocBuilder<ScheduleCubit, ScheduleState> builder(Widget Function(BuildContext, ScheduleState) builder) =>
      BlocBuilder(
          builder: builder
      );

}
