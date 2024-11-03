import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/presets/presets.dart';
import '../model/model.dart';
import '../utils/dialogs.dart';

enum _PresetDetailMenu {
  delete
}
class PresetDetailPage extends StatelessWidget {
  const PresetDetailPage({super.key});

  void deletePreset(BuildContext context, Preset preset) async {
    if (preset.isDefault) {
      AlertMessageDialog(context).show(title: 'Cannot delete the default preset');
      return;
    }
    final presets = context.read<PresetsCubit>();
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final confirmed = await ConfirmDialog(context).show(
        title: "Delete '${preset.name}'?");
    if (confirmed) {
      presets.remove(preset);
      navigator.pop();
      final snackBar = SnackBar(
        content: ListTile(
          title: Text("Removed '${preset.name}'",
              style: const TextStyle(color: Colors.white)),
          trailing: TextButton(
              onPressed: () {
                presets.save(preset);
                scaffoldMessenger.hideCurrentSnackBar();
              },
              child: const Text('undo')
          ),
        ),
      );
      scaffoldMessenger.showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PresetCubit.builder(
      (context, state) => Scaffold(
          appBar: AppBar(
            title: const Text('Edit profile'),
            actions: [
              PopupMenuButton<_PresetDetailMenu>(
                  itemBuilder: (context) => <PopupMenuItem<_PresetDetailMenu>>[
                    const PopupMenuItem(
                      value: _PresetDetailMenu.delete,
                      child: ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Delete'),
                      ),
                    )
                  ],
                onSelected: (selection) {
                    switch (selection) {
                      case _PresetDetailMenu.delete:
                        deletePreset(context, state.preset);
                    }
                },
              )
              /*IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => deletePreset(context, state.preset)
              ),

               */
            ],
          ),
          body: const PresetDetailView()
      )
    );
  }
}
