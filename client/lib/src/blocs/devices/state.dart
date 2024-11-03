
import 'package:equatable/equatable.dart';

class DevicesState extends Equatable {
  final List<String> devices;
  final bool loading;
  final DateTime? lastUpdated;

  const DevicesState({required this.devices, required this.loading, this.lastUpdated});

  DevicesState copyWith({
    List<String>? devices,
    bool? loading,
    DateTime? lastUpdated,
  }) => DevicesState(devices: devices ?? this.devices, loading: loading ?? this.loading, lastUpdated: lastUpdated ?? this.lastUpdated);

  @override
  List<Object?> get props => [loading, lastUpdated, ...devices];
}