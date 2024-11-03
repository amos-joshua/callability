import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit.dart';

class DeviceTile extends StatelessWidget {
  final String description;
  const DeviceTile({required this.description, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.phone_android),
      title: Text(description),
    );
  }
}

class DeviceList extends StatelessWidget {
  const DeviceList({super.key});

  @override
  Widget build(BuildContext context) {
    final devicesCubit = context.watch<DevicesCubit>();
    Future.microtask((){
      devicesCubit.updateIfStale();
    });

    return ListView(
      children: [
        ...devicesCubit.state.devices.map((device) => DeviceTile(description: device)),
        if (devicesCubit.state.loading) const ListTile(leading: CircularProgressIndicator())
      ]
    );
  }
}