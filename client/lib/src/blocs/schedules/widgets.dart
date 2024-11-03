
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/model.dart';
import '../../utils/dialogs.dart';
import '../presets/presets.dart';
import 'cubit.dart';

class ScheduleTimeButton extends StatelessWidget {
  final bool isStartTime;
  const ScheduleTimeButton({required this.isStartTime, super.key});

  const ScheduleTimeButton.start({super.key}): isStartTime = true;
  const ScheduleTimeButton.end({super.key}): isStartTime = false;

  String buttonLabel(BuildContext context, Schedule schedule) => isStartTime ?
    'From ${schedule.startTime.format(context)}' :
    'Until ${schedule.endTime.format(context)}';

  @override
  Widget build(BuildContext context) {
    final scheduleCubit = context.watch<ScheduleCubit>();
    final schedule = scheduleCubit.state.schedule;
    return ElevatedButton(
      onPressed: () async {
        final newTime = await showTimePicker(context: context, initialTime: isStartTime ? schedule.startTime : schedule.endTime);
        if (newTime == null) return;
        try {
          if (isStartTime) {
            scheduleCubit.updateStartTime(newTime);
          }
          else {
            scheduleCubit.updateEndTime(newTime);
          }
        }
        catch (exc){
          if (context.mounted) {
            AlertMessageDialog(context).show(
                title: 'Attention', message: '$exc');
          }
        }
      },
      child: Text(buttonLabel(context, schedule)),
    );
  }
}

class DaysSelectorRow extends StatelessWidget {
  const DaysSelectorRow({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheduleCubit = context.watch<ScheduleCubit>();
    final schedule = scheduleCubit.state.schedule;
    return SegmentedButton(
      multiSelectionEnabled: true,
      showSelectedIcon: false,
      segments: Days.values.map((day) => ButtonSegment<Days>(
        value: day,
        label: Text(day.shortLabel())
      )).toList(growable: false),
      selected: schedule.days.map((day) => Days.values[day - 1]).toSet(),
      onSelectionChanged: (days) {
        scheduleCubit.updateDays([...days.map((day)=>day.index + 1)]);
      },
    );
  }
}


class ScheduleTile extends StatelessWidget {
  final Schedule schedule;
  const ScheduleTile(this.schedule, {super.key});

  @override
  Widget build(BuildContext context) {
    return ScheduleCubit.provider(
      schedule,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 64,
              child: Row(
                children: [
                  const Spacer(),
                  const ScheduleTimeButton.start(),
                  const Text(' - '),
                  const ScheduleTimeButton.end(),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<PresetCubit>().removeSchedule(schedule);
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 64,
              child: DaysSelectorRow()
            )
          ],
        )
      ),
    );
  }
}
