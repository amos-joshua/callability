
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'blocs/groups/groups.dart';
import 'blocs/presets/presets.dart';
import 'pages/outgoing_call_page.dart';
import 'pages/settings_page.dart';
import 'pages/root_page.dart';
import 'pages/presets_page.dart';
import 'pages/groups_page.dart';
import 'pages/group_detail_page.dart';
import 'pages/preset_detail_page.dart';
import 'pages/calls_page.dart';
import 'pages/home_page.dart';
import 'pages/incoming_call_page.dart';
import 'blocs/app_settings/app_settings.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNavigatorKey');
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'homeNavigatorStateKey');
final _groupsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'groupsNavigatorStateKey');
final _presetsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'presetsNavigatorStateKey');
final _callsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'callsNavigatorStateKey');

// GoRouter configuration
final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScaffold(
        body: SettingsPage(),
      )
    ),
    StatefulShellRoute(
      builder: (context, state, navigationShell) {
        return RootScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/',
              builder: (context, state) => const HomePage(),
              routes: <RouteBase>[
                GoRoute(
                  path: 'group_detail',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final groupCubit = state.extra as GroupCubit;
                    return BlocProvider.value(
                      value: groupCubit,
                      child: const GroupDetailPage()
                    );
                  }
                ),
                GoRoute(
                    path: 'preset_detail',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final presetCubit = state.extra as PresetCubit;
                      return BlocProvider.value(
                        value: presetCubit,
                        child: const PresetDetailPage(),
                      );
                    }
                )
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _groupsNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/groups',
              builder: (context, state) => const GroupsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _presetsNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/presets',
              builder: (context, state) => const PresetsPage(),
            ),
          ],
        ),

        StatefulShellBranch(
          navigatorKey: _callsNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/calls',
              builder: (context, state) => const CallsPage(),
              routes: <RouteBase>[
                GoRoute(
                  path: 'outgoing_call',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (BuildContext context, GoRouterState state) {
                    return const Material(
                      child: OutgoingCallPage(),
                    );
                  },
                ),
                GoRoute(
                  path: 'incoming_call',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (BuildContext context, GoRouterState state) {
                    return const Material(
                      child: IncomingCallPage(),
                    );
                  },
                ),
              ],
            ),
          ],
        )
      ],
      navigatorContainerBuilder: (context, navigationShell, children) {
        return children[navigationShell.currentIndex];
      },
    )
  ],
);