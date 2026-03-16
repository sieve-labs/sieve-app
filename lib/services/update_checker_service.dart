import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

/// Service for checking app updates from GitHub releases.
class UpdateCheckerService {
  static const String _githubApiUrl =
      'https://api.github.com/repos/sieve-labs/sieve-app/releases/latest';
  static const String _githubReleasesUrl =
      'https://github.com/sieve-labs/sieve-app/releases/';

  /// Get the current app version from package info.
  Future<String> getCurrentVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  /// Check for updates by comparing current version with latest GitHub release.
  /// Returns [UpdateInfo] with update details, or null if no update available.
  Future<UpdateInfo?> checkForUpdate() async {
    try {
      final currentVersion = await getCurrentVersion();
      final response = await http.get(
        Uri.parse(_githubApiUrl),
        headers: {
          'Accept': 'application/vnd.github.v3+json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final latestVersion = (data['tag_name'] as String).replaceFirst('v', '');
        final releaseUrl = data['html_url'] as String;
        final releaseNotes = data['body'] as String?;

        if (_isNewerVersion(latestVersion, currentVersion)) {
          return UpdateInfo(
            currentVersion: currentVersion,
            latestVersion: latestVersion,
            releaseUrl: releaseUrl,
            releaseNotes: releaseNotes,
          );
        }
      }
      return null;
    } catch (e) {
      // Silently fail - don't block user if update check fails
      return null;
    }
  }

  /// Compare two version strings (e.g., "1.0.0" vs "1.1.0").
  bool _isNewerVersion(String latest, String current) {
    final latestParts = latest.split('.').map(int.parse).toList();
    final currentParts = current.split('.').map(int.parse).toList();

    for (int i = 0; i < latestParts.length && i < currentParts.length; i++) {
      if (latestParts[i] > currentParts[i]) return true;
      if (latestParts[i] < currentParts[i]) return false;
    }

    return latestParts.length > currentParts.length;
  }

  /// Open the releases page in browser.
  Future<void> openReleasesPage() async {
    final url = Uri.parse(_githubReleasesUrl);
    // Note: url_launcher will be called from UI layer
  }
}

/// Information about an available update.
class UpdateInfo {
  final String currentVersion;
  final String latestVersion;
  final String releaseUrl;
  final String? releaseNotes;

  const UpdateInfo({
    required this.currentVersion,
    required this.latestVersion,
    required this.releaseUrl,
    this.releaseNotes,
  });
}
