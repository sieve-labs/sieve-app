import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers/api_config_provider.dart';
import 'providers/theme_provider.dart';
import 'theme/app_theme.dart';
import 'theme/page_transitions.dart';
import 'screens/api_key_setup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/label_set_list_screen.dart';
import 'screens/label_set_editor_screen.dart';
import 'screens/classification_screen.dart';
import 'screens/results_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/storage_setup_screen.dart';

class SieveApp extends ConsumerWidget {
  const SieveApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(_routerProvider);
    final themeModeAsync = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Sieve',
      debugShowCheckedModeBanner: false,
      themeMode: themeModeAsync.valueOrNull ?? ThemeMode.system,
      theme: createSieveLightTheme(),
      darkTheme: createSieveDarkTheme(),
      routerConfig: router,
    );
  }
}

final _routerProvider = Provider<GoRouter>((ref) {
  final hasKeyAsync = ref.watch(hasApiKeyProvider);
  final hasGalleryPath = ref.watch(hasGalleryPathProvider);
  final hasSeenWelcome = ref.watch(hasSeenWelcomeProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final hasKey = hasKeyAsync.valueOrNull ?? false;
      final hasStorage = hasGalleryPath;
      final seenWelcome = hasSeenWelcome;

      final isWelcomeRoute = state.matchedLocation == '/welcome';
      final isSetupRoute = state.matchedLocation == '/setup';
      final isStorageSetupRoute = state.matchedLocation == '/storage-setup';

      // 1. Force Welcome screen first (before API key setup)
      if (!seenWelcome && !hasKey) {
        return isWelcomeRoute ? null : '/welcome';
      }

      // 2. Force API Key Setup second
      if (!hasKey) {
        return isSetupRoute ? null : '/setup';
      }

      // 3. Force Storage Setup third
      if (!hasStorage) {
        return isStorageSetupRoute ? null : '/storage-setup';
      }

      // 4. User is fully setup, but trying to access setup screens
      if (hasKey && hasStorage && (isWelcomeRoute || isSetupRoute || isStorageSetupRoute)) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => SievePageTransitions.fade(
          child: const HomeScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: '/welcome',
        pageBuilder: (context, state) => SievePageTransitions.slideLeft(
          child: const WelcomeScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: '/setup',
        pageBuilder: (context, state) => SievePageTransitions.slideLeft(
          child: const ApiKeySetupScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: '/storage-setup',
        pageBuilder: (context, state) => SievePageTransitions.slideLeft(
          child: const StorageSetupScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => SievePageTransitions.slideLeft(
          child: const SettingsScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: '/label-sets',
        pageBuilder: (context, state) => SievePageTransitions.slideLeft(
          child: const LabelSetListScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: '/label-sets/new',
        pageBuilder: (context, state) => SievePageTransitions.slideLeft(
          child: const LabelSetEditorScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: '/label-sets/:id',
        pageBuilder: (context, state) => SievePageTransitions.slideLeft(
          child: LabelSetEditorScreen(
            labelSetId: state.pathParameters['id'],
          ),
          state: state,
        ),
      ),
      GoRoute(
        path: '/classify',
        pageBuilder: (context, state) => SievePageTransitions.slideLeft(
          child: const ClassificationScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: '/results',
        pageBuilder: (context, state) => SievePageTransitions.slideLeft(
          child: const ResultsScreen(),
          state: state,
        ),
      ),
    ],
  );
});
