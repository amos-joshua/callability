import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../model/model.dart';
import '../../utils/editable_text.dart';
import '../../utils/dialogs.dart';
import '../contacts/contacts.dart';
import '../../repositories/repositories.dart';
import '../app_settings/app_settings.dart';
import '../presets/presets.dart';
import 'state.dart';
import 'cubit.dart';

class GroupTileSimple extends StatelessWidget {
  const GroupTileSimple({super.key});

  @override
  Widget build(BuildContext context) {
    final groupCubit = context.watch<GroupCubit>();
    return Card(
        elevation: 2.0,
        child: ListTile(
          leading: const Icon(Icons.group),
          title: Text(groupCubit.state.group.name),
          onTap: () {
            context.push('/group_detail', extra:groupCubit);
          },
        )
    );
  }
}

class GroupTilePriorities extends StatelessWidget {
  final bool readonly;

  const GroupTilePriorities({required this.readonly, super.key});

  @override
  Widget build(BuildContext context) {
    final groupCubit = context.watch<GroupCubit>();
    final presetCubit = context.watch<PresetCubit>();
    final presetSettingCubit = presetCubit.presetSettingCubitFor(groupCubit.state.group);

    return Card(
      elevation: 2.0,
      child: ListTile(
        leading: const Icon(Icons.group),
        title: Row(
          children: [
            Expanded(
                child: Text(groupCubit.state.group.name),
            ),
            Expanded(
              flex: 3,
              child: BlocProvider<PresetSettingCubit>.value(
                value: presetSettingCubit,
                child:  PresetSettingRingSummary(
                  readonly: readonly,
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GroupsPrioritiesLegend extends StatelessWidget {
  const GroupsPrioritiesLegend({super.key});

  Widget columnLabel(String label, Alignment alignment) => Expanded(child: FittedBox(fit: BoxFit.scaleDown, alignment: alignment, child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Text(label, style: const TextStyle(color: Colors.black54, fontSize: 14)),
  )));

  @override
  Widget build(BuildContext context) => ListTile(
    key: const ValueKey('groups_legend'),
    visualDensity: VisualDensity.compact,
    dense: true,
    leading: const SizedBox(width: 32,),
    title: Row(
      children: [
        const Expanded(flex: 1, child: SizedBox()),
        Expanded(flex: 3, child: Row(children: [
          columnLabel('Leisure', Alignment.centerLeft),
          columnLabel('Important', Alignment.centerLeft),
          columnLabel('Urgent', Alignment.centerLeft)
        ],),)
      ],
    ),
  );
}


class GroupsList extends StatelessWidget {
  final bool showPriorities;
  const GroupsList({required this.showPriorities, super.key});

  Widget loadingSpinner() => const Center(
      child: CircularProgressIndicator()
  );

  Widget listView(GroupsCubit groupsCubit) {
    final state = groupsCubit.state;
    final numItems = state.groups.length + (showPriorities ? 1 : 0);
    final delta = showPriorities ? 1 : 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView.builder(
        itemCount: numItems,
        itemBuilder: (context, index) {
          if (showPriorities && (index == 0)) {
            return const GroupsPrioritiesLegend();
          }
          final group = state.groups[index - delta];
          return BlocProvider.value(
            value: groupsCubit.cubitFor(group),
            child: Builder(
                builder: (context) {
                  return showPriorities ? GroupTilePriorities(
                    readonly: true,
                    //subtitle: showPriorities ? null : Text('${group.contacts.length} $contactsLabel'),
                    key: ValueKey('group_${group.name}_${group.id}')
                  ) : const GroupTileSimple();
                }
            ),
          );
        }
      ),
    );
  }

  Widget emptyList() => const Center(
    child: Text('(no groups)', style: TextStyle(color: Colors.black45))
  );

  @override
  Widget build(BuildContext context) {
    final groupsCubit = context.watch<GroupsCubit>();
    final state = groupsCubit.state;
      return state.loading ? loadingSpinner() :
             state.groups.isEmpty ? emptyList() : listView(groupsCubit);
  }
}

class GroupListTitle extends StatelessWidget {
  const GroupListTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final database = context.read<DBRepository>();
    final groupsCubit = context.read<GroupsCubit>();

    return ListTile(
      title: const Text('Groups'),
      trailing: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () async {
          final newName = await database.nextGroupName();
          final newGroup = ContactGroup(name: newName, catchAll: false);
          groupsCubit.save(newGroup);
          /*
          if (context.mounted) {
            context.push('/group_detail', extra: newGroupCubit??);
          }*/
        },
      ),
    );
  }
}

class GroupsListWithAddButton extends StatelessWidget {
  const GroupsListWithAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
        children: [
          GroupListTitle(),
          Expanded(
              child: GroupsList(
                showPriorities: false,
              )
          )
        ]
    );
  }
}

class GroupNameEditField extends StatelessWidget {

  const GroupNameEditField({super.key});

  Future<String?> validate(BuildContext context, ContactGroup group, String groupName) async {
    final database = context.read<DBRepository>();
    if (groupName.trim().isEmpty) {
      return 'Cannot be empty';
    }
    if ((groupName != group.name) && await database.hasGroupNamed(groupName)) {
      return 'A group with this name already exists';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final groupCubit = context.watch<GroupCubit>();
    final group = groupCubit.state.group;

    return EditableTitle(
        value: group.name,
        validate: (context, groupName) => validate(context, group, groupName),
        onConfirm: (newName) {
          groupCubit.updateName(newName);
        }
    );
  }
}

class GroupContactsListTitle extends StatelessWidget {
  const GroupContactsListTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final groupCubit = context.watch<GroupCubit>();
    final group = groupCubit.state.group;
    final contactsCubit = context.read<ContactsCubit>();
    return ListTile(
      title: const Text('Contacts'),
      trailing: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () async {
          final newContacts = await SelectContactsDialog(context).show(group.contacts);
          if (newContacts == null) {
            return;
          }
          contactsCubit.replaceContacts(newContacts);
        },
      ),
    );
  }

}

class GroupOthersDescription extends StatelessWidget {
  const GroupOthersDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text('This group contains all contacts that do not belong to any other group')
    );
  }
}

class GroupCatchAllSwitch extends StatelessWidget {
  const GroupCatchAllSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final groupCubit = context.watch<GroupCubit>();
    final group = groupCubit.state.group;

    return ListTile(
      leading: IconButton(
          onPressed: () {
            AlertMessageDialog(context).show(
                title: 'Catch all',
                message: 'When enabled, any contact not belonging to another group will be included in this one. Only one group can be a catch-all.'
            );
          },
          icon: const Icon(Icons.info)
      ),
      title: const Text('Catch all'),
      trailing: Switch(
          value: group.catchAll,
          onChanged: (newValue) {
            groupCubit.toggleCatchAll();
          }
      ),
    );
  }
}


class GroupDetailView extends StatelessWidget {
  const GroupDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final group = context.read<GroupCubit>().state.group;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: GroupNameEditField()
        ),
        const SizedBox(height: 16.0),
        if (group.catchAll) const GroupOthersDescription()
        else ... const [
          GroupContactsListTitle(),
          Expanded(
            child: ContactsListWithFilter(
              allowDelete: true,
            )
        ),]
        //GroupCatchAllSwitch(),
      ],
    );
  }
}
