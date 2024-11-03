

import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final bool authorized;
  final String identifier;

  const AuthState({
    required this.authorized,
    required this.identifier
  });

  AuthState copyWith({
    bool? authorized,
    String? identifier
  }) => AuthState(authorized: authorized ?? this.authorized, identifier: identifier ?? this.identifier);

  @override
  List<Object> get props => [authorized, identifier];
}