import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/enums.dart';

class AppInitState {
  final bool initOngoing;
  final Map<Init, String> errors;

  const AppInitState({
    this.initOngoing = true,
    this.errors = const {}
  });

  bool get initFinished => !initOngoing;
  bool get initSucceeded => errors.isEmpty;
}