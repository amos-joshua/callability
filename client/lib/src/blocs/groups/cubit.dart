import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../presets/presets.dart';
import '../../repositories/repositories.dart';
import '../../model/model.dart';
import 'state.dart';

class GroupsCubit extends Cubit<GroupsState> {
  final DBRepository database;
  final PresetsCubit presetsCubit;
  final _cubits = <int, GroupCubit>{};

  GroupsCubit({required this.database, required this.presetsCubit}): super(const GroupsState());

  Future<void> list(String filter) async {
    emit(state.copyWith(loading: true, filter: filter));
    final groups = await database.groups(filter);
    emit(state.copyWith(loading: false, groups: _sort(groups), filter: filter));
  }

  Future<void> save(ContactGroup group) async {
    emit(state.copyWith(loading: true));
    await database.saveGroup(group);
    final exists = state.groups.any((other) => other.id == group.id);
    if (exists) {
      emit(state.copyWith(loading: false, groups: _sort(state.groups)));
    }
    else {
      emit(state.copyWith(loading: false, groups: _sort([...state.groups, group])));
    }
    await presetsCubit.addPresetSettingsForGroup(group);
    presetsCubit.presetsModified();
  }

  Future<void> remove(ContactGroup group) async {
    await database.removeGroup(group);
    await presetsCubit.removePresetSettingsForGroup(group);
    emit(state.copyWith(groups: state.groups.where((existing) => existing.id != group.id).toList()));
    presetsCubit.presetsModified();
  }

  List<ContactGroup> _sort(List<ContactGroup> groups) {
    groups.sort((a, b) => a.name.compareTo(b.name));
    return groups;
  }

  GroupCubit cubitFor(ContactGroup group) {
    final existingCubit = _cubits[group.id];
    if (existingCubit != null) {
      return existingCubit;
    }
    final cubit = GroupCubit(group, database: database, presetsCubit: presetsCubit);
    _cubits[group.id] = cubit;
    return cubit;
  }

  static BlocBuilder builder(Widget Function(BuildContext, GroupsState) cubitBuilder) => BlocBuilder<GroupsCubit, GroupsState>(
      builder: cubitBuilder
  );
}

class GroupCubit extends Cubit<GroupState> {
  final DBRepository database;
  final PresetsCubit presetsCubit;
  GroupCubit(ContactGroup group, {required this.database, required this.presetsCubit}): super(GroupState(group: group));

  Future<void> updateName(String newName) async {
    state.group.name = newName;
    await database.saveGroup(state.group);
    presetsCubit.presetsModified();
    emit(state.copyWith(nameNonce: state.nameNonce + 1));
  }

  Future<void> toggleCatchAll() async {
    state.group.catchAll = !state.group.catchAll;
    await database.saveGroup(state.group);
    presetsCubit.presetsModified();
    emit(state.copyWith(catchAllNonce: state.catchAllNonce + 1));
  }

  static BlocBuilder builder(Widget Function(BuildContext, GroupState) cubitBuilder) => BlocBuilder<GroupCubit, GroupState>(
      builder: cubitBuilder
  );
}