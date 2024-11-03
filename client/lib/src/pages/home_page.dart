import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/app_settings/app_settings.dart';
import '../blocs/groups/groups.dart';
import '../blocs/presets/presets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ActivePresetTitle(),
        Expanded(
          flex: 4,
          child: AppSettingsCubit.builder((context, appSettingsState) {
            final presetsCubit = context.watch<PresetsCubit>();
            final appSettingsCubit = context.read<AppSettingsCubit>();
              return BlocProvider.value(
                value: presetsCubit.cubitFor(appSettingsState.activePresetData.preset, appSettingsCubit: appSettingsCubit),
                child: const GroupsList(
                  showPriorities: true,
                ),
              );
            }
          )
        ),
      ],
    );
  }
}