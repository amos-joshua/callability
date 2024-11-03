
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../app_init/cubit.dart';
import '../../model/model.dart';
import '../groups/groups.dart';
import 'presets.dart';
import '../../repositories/repositories.dart';
import '../app_settings/app_settings.dart';
import '../../utils/editable_text.dart';
import '../../utils/dialogs.dart';
import '../schedules/widgets.dart';

/*
class PresetButton extends StatelessWidget {
  const PresetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSettingsCubit.builder((context, appSettingsState) {
      return PresetCubit.builder((context, presetState) {
        final presetsCubit = context.read<PresetsCubit>();
        final presetCubit = context.read<PresetCubit>();
        final appSettingsCubit = context.read<AppSettingsCubit>();
        final preset = presetState.preset;
        final isCurrent = presetsCubit.state.selectedPreset?.id == preset.id;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: isCurrent ? Colors.lightGreenAccent.shade100 : null),
            onPressed: () {
              presetsCubit.selectPreset(isCurrent ? null : preset);
            },
            child: isCurrent ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(preset.name),
                IconButton(
                    onPressed: () async {
                      presetCubit.syncSettingsWithGroups();
                      if (context.mounted) {
                        context.push(
                            '/preset_detail', extra: presetCubit);
                      }
                    },
                    icon: const Icon(Icons.edit)
                ),
                IconButton(
                    onPressed: () async {
                      final duration = await DurationSelectDialog(context).show(title:'', message: "Set availability to '${preset.name}' for");
                      if (duration == null) {
                        return;
                      }
                      if (context.mounted) {
                        appSettingsCubit.overridePreset(preset, duration);
                      }
                    },
                    icon: const Icon(Icons.play_circle_rounded)
                )
              ],
            ) : Text(presetState.preset.name),
          ),
        );
      });
    });
  }
}*/


class PresetTile extends StatelessWidget {
  const PresetTile({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppSettingsCubit.builder((context, appSettingsState) {
      return PresetCubit.builder((context, presetState) {
        final presetCubit = context.read<PresetCubit>();
        final preset = presetState.preset;

        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: const Icon(Icons.list),
            title: Text(preset.name),
            trailing: preset.isDefault ? Text('default', style: theme.textTheme.bodySmall) : null,
            onTap: () async {
              presetCubit.syncSettingsWithGroups();
              if (context.mounted) {
                context.push('/preset_detail', extra: presetCubit);
              }
            },
          ),
        );
      });
    });
  }
}

class PresetsList extends StatelessWidget {

  const PresetsList({super.key});

  Widget loadingSpinner() => const Center(
      child: CircularProgressIndicator()
  );

  Widget listView(PresetsState state) => ListView.builder(
      itemCount: state.presets.length,
      itemBuilder: (context, index) {
        final presetsCubit = context.read<PresetsCubit>();
        final preset = state.presets[index];
        return BlocProvider.value(
          value: presetsCubit.cubitFor(preset, appSettingsCubit: context.read<AppSettingsCubit>()),
          child: Builder(
            builder: (context) {
              return PresetTile(
                key: ValueKey('preset_${preset.name}_${preset.id}'),
              );
            }
          ),
        );
      }
  );

  Widget emptyList() => const Center(
      child: Text('(none)', style: TextStyle(color: Colors.black45))
  );

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PresetsCubit, PresetsState>(
          builder: (context, state) {
            return state.loading ? loadingSpinner() :
            state.presets.isEmpty ? emptyList() : listView(state);
          }
      );
}


class PresetListTitle extends StatelessWidget {
  const PresetListTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final presetsCubit = context.read<PresetsCubit>();

    return ListTile(
      title: const Text('Profiles'),
      trailing: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () async {
          final newPresetName = await presetsCubit.nextPresetName();
          final newPreset = Preset(name: newPresetName);
          presetsCubit.save(newPreset);
        },
      ),
    );
  }
}

class PresetsListWithAddButton extends StatelessWidget {
  const PresetsListWithAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PresetListTitle(),
        Expanded(child: PresetsList())
      ]
    );
  }
}


class PresetNameEditField extends StatelessWidget {
  const PresetNameEditField({super.key});

  Future<String?> validate(Preset preset, BuildContext context, String newName) async {
    final presetsCubit = context.read<PresetsCubit>();
    if (newName.trim().isEmpty) {
      return 'Cannot be empty';
    }
    if ((newName != preset.name) && await presetsCubit.hasPresetNamed(newName)) {
      return 'A preset with this name already exists';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final presetCubit = context.watch<PresetCubit>();
    final preset = presetCubit.state.preset;
    return EditableTitle(
      value: preset.name,
      validate: (context, newName) => validate(preset, context, newName),
      onConfirm: (newName) {
        presetCubit.updateName(newName);
      }
    );
  }
}

class PresetDetailView extends StatelessWidget {
  const PresetDetailView({super.key});

  Iterable<Widget> scheduleTiles(List<Schedule> schedules) => schedules.map((schedule) => ScheduleTile(
    schedule,
    key: ValueKey('schedule_${schedule.id}'),
  )
  );

  Iterable<Widget> presetSettingTiles(GroupsCubit groupsCubit, Preset preset) => preset.settings.map((setting) => Builder(
      builder: (context) {
        final group = setting.group.target;
        if (group == null) {
          return Text('unknown Group with id ${setting.group.targetId}');
        }
        return BlocProvider<GroupCubit>.value(
          value: groupsCubit.cubitFor(group),
          child: const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: GroupTilePriorities(
              readonly: false
            )
          ),
        );
      }
    )
  );

  Widget schedulesTitle(PresetCubit presetCubit) => ListTile(
    title: const Text('Schedule'),
    trailing: IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        presetCubit.addSchedule();
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return PresetCubit.builder(
      (context, state) {
        final presetCubit = context.read<PresetCubit>();
        final groupsCubit = context.watch<GroupsCubit>();
        final schedules = presetCubit.state.preset.schedules;

        return ListView(
          children: [
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: PresetNameEditField()
            ),
            const SizedBox(height: 16.0),
            ...presetSettingTiles(groupsCubit, state.preset),
            schedulesTitle(presetCubit),
            if (schedules.isEmpty) const Center(child: Text('(none)', style: TextStyle(color: Colors.blueGrey)))
            else ...scheduleTiles(schedules)
          ],
        );
      }
    );
  }
}

class PresetSettingRingButton extends StatelessWidget {
  final CallUrgency urgency;
  final bool readonly;

  const PresetSettingRingButton({required this.urgency, required this.readonly, super.key});

  @override
  Widget build(BuildContext context) {
    final settingCubit = context.watch<PresetSettingCubit>();
    final setting = settingCubit.state.presetSetting;
    final ringType = setting.ringTypeFor(urgency);

    return InkWell(
      onTap: readonly ? null : () {
        settingCubit.setRingTypeFor(urgency, ringType: ringType.nextRingType);
      },
      child: Card(
        color: ringType != RingType.silent ? urgency.color() : Colors.grey.shade400,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(ringType.icon, color: Colors.white)
        ),
      ),
    );
  }

}
class PresetSettingRingSummary extends StatelessWidget {
  final bool readonly;
  const PresetSettingRingSummary({required this.readonly, super.key});

  @override
  Widget build(BuildContext context) {
     return  Row(
      children: [
        Expanded(child: PresetSettingRingButton(urgency: CallUrgency.leisure, readonly: readonly)),
        Expanded(child: PresetSettingRingButton(urgency: CallUrgency.important, readonly: readonly)),
        Expanded(child: PresetSettingRingButton(urgency: CallUrgency.urgent, readonly: readonly)),
      ],
    );
  }
}

class ActivePresetTitle extends StatelessWidget {
  const ActivePresetTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appSettings = context.watch<AppSettingsCubit>();
    final activePresetData = appSettings.state.activePresetData;
    final endTime = TimeOfDay.fromDateTime(activePresetData.endTime);
    return ListTile(
      title: Text(activePresetData.preset.name, style:theme.textTheme.titleLarge),
      trailing: !activePresetData.isOverride ? null : IconButton(
          onPressed: () async {
            final confirmed = await ConfirmDialog(context).show(title: "Cancel '${activePresetData.preset.name}'?");
            if (confirmed) {
              appSettings.clearOverridePreset();
            }
          },
          icon: const Icon(Icons.cancel)
      ),
      subtitle: activePresetData.preset.isDefault ? null : Text('Until ${endTime.format(context)}'),
    );
  }

}

class PresetOverridePopupButton extends StatelessWidget {
  static const _icon = Icon(Icons.more_time_outlined);
  const PresetOverridePopupButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appInit = context.watch<AppInitCubit>();
    if (appInit.state.initOngoing) {
      return const IconButton(icon: _icon, onPressed: null);
    }

    final presetsFuture = context.read<DBRepository>().presets();

    return FutureBuilder(
        future: presetsFuture,
        builder: (context, snapshot) {
          final appSettingsCubit = context.read<AppSettingsCubit>();

          final presets = snapshot.data;
          if (presets == null) return const IconButton(icon: _icon, onPressed: null);
          return PopupMenuButton<Preset>(
            itemBuilder: (context) => presets.map((preset) => PopupMenuItem(
              value: preset,
              child: ListTile(
                leading: const Icon(Icons.list),
                title: Text(preset.name)
              ),
            )).toList(),
            onSelected: (preset) async {
              final duration = await DurationSelectDialog(context).show(title: 'Set to ${preset.name} for...');
              if (duration == null) return;
              if (context.mounted) {
                appSettingsCubit.overridePreset(preset, duration);
              }
            },
            icon: _icon,
          );
        }
    );
  }

}