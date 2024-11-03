import 'package:equatable/equatable.dart';

import '../../model/model.dart';

class GroupsState extends Equatable {
  final List<ContactGroup> groups;
  final bool loading;
  final String filter;

  const GroupsState({
    this.groups = const [],
    this.loading = true,
    this.filter = ''
  });

  GroupsState copyWith({
    List<ContactGroup>? groups,
    bool? loading,
    String? filter
  }) => GroupsState(groups: groups ?? this.groups, loading: loading ?? this.loading, filter: filter ?? this.filter);

  @override
  List<Object> get props => [groups, loading, filter];
}


class GroupState extends Equatable {
  final ContactGroup group;
  final int nameNonce;
  final int catchAllNonce;

  const GroupState({
    required this.group,
    this.nameNonce = 0,
    this.catchAllNonce = 0
  });

  GroupState copyWith({
    int? nameNonce,
    int? catchAllNonce
  }) => GroupState(
    group: group,
    nameNonce: nameNonce ?? this.nameNonce,
    catchAllNonce: catchAllNonce ?? this.catchAllNonce
  );

  @override
  List<Object> get props => [group, nameNonce];
}