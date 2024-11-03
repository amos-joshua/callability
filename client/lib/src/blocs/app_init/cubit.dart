import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/model.dart';

class AppInitCubit extends Cubit<AppInitState> {
  AppInitCubit(): super(const AppInitState());

  void finish() => emit(AppInitState(initOngoing: false, errors: state.errors));
  void addInitError(Init phase, String error) => emit(AppInitState(initOngoing: state.initOngoing, errors: {... state.errors, phase: error}));

  static BlocBuilder<AppInitCubit, AppInitState> builder(Widget Function(BuildContext, AppInitState) builder) {
    return BlocBuilder<AppInitCubit, AppInitState>(
      builder: builder,
    );
  }
}