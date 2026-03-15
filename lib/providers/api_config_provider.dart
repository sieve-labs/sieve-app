import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/api_config.dart';
import '../services/secure_storage_service.dart';

/// Provider for the SecureStorageService singleton.
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

/// Manages the API configuration state.
class ApiConfigNotifier extends AsyncNotifier<ApiConfig?> {
  @override
  FutureOr<ApiConfig?> build() async {
    final service = ref.read(secureStorageServiceProvider);
    return service.readApiConfig();
  }

  /// Save a new API configuration.
  Future<void> saveConfig(ApiConfig config) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(secureStorageServiceProvider);
      await service.saveApiConfig(config);
      state = AsyncValue.data(config);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Clear the stored API configuration.
  Future<void> clearConfig() async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(secureStorageServiceProvider);
      await service.deleteApiConfig();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Provider for the API config state.
final apiConfigProvider =
    AsyncNotifierProvider<ApiConfigNotifier, ApiConfig?>(() {
  return ApiConfigNotifier();
});

/// Convenience provider that checks if an API key is configured.
final hasApiKeyProvider = FutureProvider<bool>((ref) async {
  final config = await ref.watch(apiConfigProvider.future);
  return config != null && config.isValid;
});

/// Manages the Gallery storage path state.
class GalleryPathNotifier extends AsyncNotifier<String?> {
  @override
  FutureOr<String?> build() async {
    final service = ref.read(secureStorageServiceProvider);
    return service.getGalleryPath();
  }

  Future<void> savePath(String path) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(secureStorageServiceProvider);
      await service.saveGalleryPath(path);
      state = AsyncValue.data(path);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> clearPath() async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(secureStorageServiceProvider);
      // service.deleteGalleryPath() isn't implemented in service, 
      // but we can save empty. 
      await service.saveGalleryPath('');
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Provider for the Gallery path state.
final galleryPathProvider =
    AsyncNotifierProvider<GalleryPathNotifier, String?>(() {
  return GalleryPathNotifier();
});

/// Convenience provider that checks if a gallery path is configured.
final hasGalleryPathProvider = Provider<bool>((ref) {
  final pathAsync = ref.watch(galleryPathProvider);
  return pathAsync.maybeWhen(
    data: (path) => path != null && path.isNotEmpty,
    orElse: () => false,
  );
});
