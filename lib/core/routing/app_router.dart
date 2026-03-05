import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:candix/features/game/presentation/screens/game_screen.dart';
import 'package:candix/features/game/presentation/screens/home_screen.dart';
import 'package:candix/features/game/presentation/screens/settings_screen.dart';

enum AppRoute {
  home('/'),
  game('/game'),
  settings('/settings');

  const AppRoute(this.path);
  final String path;
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoute.home.path,
    routes: [
      GoRoute(
        path: AppRoute.home.path,
        name: AppRoute.home.name,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: AppRoute.game.path,
        name: AppRoute.game.name,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const GameScreen(),
        ),
      ),
      GoRoute(
        path: AppRoute.settings.path,
        name: AppRoute.settings.name,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const SettingsScreen(),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text('Page not found: ${state.uri.path}'),
      ),
    ),
  );
});
