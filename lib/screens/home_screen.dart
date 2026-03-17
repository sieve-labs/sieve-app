import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/graph_paper_background.dart';
import 'gallery_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvoked: (didPop) {
        if (!didPop && _currentIndex == 1) {
          setState(() => _currentIndex = 0);
        }
      },
      child: GraphPaperBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Sieve'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => context.push('/settings'),
              ),
            ],
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: [
              _buildClassifyView(context),
              const GalleryScreen(),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.image_search_outlined),
                selectedIcon: Icon(Icons.image_search),
                label: 'Classify',
              ),
              NavigationDestination(
                icon: Icon(Icons.photo_library_outlined),
                selectedIcon: Icon(Icons.photo_library),
                label: 'Gallery',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassifyView(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _FeatureCard(
          icon: Icons.label,
          title: 'Label Sets',
          subtitle: 'Create and manage classification labels',
          onTap: () => context.push('/label-sets'),
        ),
        const SizedBox(height: 12),
        _FeatureCard(
          icon: Icons.image_search,
          title: 'Classify Images',
          subtitle: 'Select images and classify with AI',
          onTap: () => context.push('/classify'),
        ),
        const SizedBox(height: 12),
        _FeatureCard(
          icon: Icons.list_alt,
          title: 'Results',
          subtitle: 'View and export classification results',
          onTap: () => context.push('/results'),
        ),
        const SizedBox(height: 12),
        _ExternalFeatureCard(
          icon: Icons.menu_book,
          title: 'Documentation',
          subtitle: 'View the guide on GitBook',
          url: 'https://sieve-labs.gitbook.io/sieve/',
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 36),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _ExternalFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String url;

  const _ExternalFeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.url,
  });

  Future<void> _launchUrl(BuildContext context) async {
    final uri = Uri.parse(url);
    try {
      // Try to launch directly - canLaunchUrl often fails on Android
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open link')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening link: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 36, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.open_in_new),
        onTap: () => _launchUrl(context),
      ),
    );
  }
}
