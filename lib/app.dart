import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers/api_config_provider.dart';
import 'screens/api_key_setup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/label_set_list_screen.dart';
import 'screens/label_set_editor_screen.dart';
import 'screens/classification_screen.dart';
import 'screens/results_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/storage_setup_screen.dart';
import 'providers/theme_provider.dart';

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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
          surface: const Color(0xFF1A1C1E),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xFF1A1C1E),
        ),
        scaffoldBackgroundColor: const Color(0xFF1A1C1E),
      ),
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
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/setup',
        builder: (context, state) => const ApiKeySetupScreen(),
      ),
      GoRoute(
        path: '/storage-setup',
        builder: (context, state) => const StorageSetupScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/label-sets',
        builder: (context, state) => const LabelSetListScreen(),
      ),
      GoRoute(
        path: '/label-sets/new',
        builder: (context, state) => const LabelSetEditorScreen(),
      ),
      GoRoute(
        path: '/label-sets/:id',
        builder: (context, state) => LabelSetEditorScreen(
          labelSetId: state.pathParameters['id'],
        ),
      ),
      GoRoute(
        path: '/classify',
        builder: (context, state) => const ClassificationScreen(),
      ),
      GoRoute(
        path: '/results',
        builder: (context, state) => const ResultsScreen(),
      ),
    ],
  );
});
