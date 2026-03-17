import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../widgets/graph_paper_background.dart';
import '../providers/api_config_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _progressController;
  late Animation<double> _fadeIn;
  late Animation<double> _fadeOut;
  
  int _currentSentenceIndex = 0;
  bool _isVisible = true;
  bool _isComplete = false;

  final List<String> _sentences = [
    'Loading the sieve',
    'Preparing your workspace',
    'Checking the grid',
    'Almost ready',
  ];

  @override
  void initState() {
    super.initState();
    
    // Fade animation controller
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800), // 600ms in + 800ms hold + 400ms out
    );

    // Progress bar controller (2 seconds minimum)
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.0, 0.333, curve: Curves.easeIn), // First 600ms
      ),
    );

    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.778, 1.0, curve: Curves.easeOut), // Last 400ms
      ),
    );

    _fadeController.addStatusListener(_onAnimationStatusChanged);
    
    // Start animations
    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    _progressController.forward();
    _fadeController.forward();
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (_currentSentenceIndex < _sentences.length - 1) {
        // Move to next sentence
        setState(() {
          _currentSentenceIndex++;
        });
        _fadeController.reset();
        _fadeController.forward();
      } else {
        // All sentences shown, wait for progress then transition
        _completeSplash();
      }
    }
  }

  void _completeSplash() async {
    if (_isComplete) return;
    _isComplete = true;

    // Wait for minimum duration
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      // Fade out and navigate
      await Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            // Return appropriate initial screen based on setup state
            final hasSeenWelcome = ref.read(hasSeenWelcomeProvider);
            final hasKey = ref.read(hasApiKeyProvider).valueOrNull ?? false;
            final hasStorage = ref.read(hasGalleryPathProvider);
            
            // This will be handled by router, just fade to black first
            return const SizedBox.shrink();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    // Calculate current opacity
    double opacity = 1.0;
    if (!disableAnimations) {
      final value = _fadeController.value;
      if (value < 0.333) {
        opacity = _fadeIn.value;
      } else if (value > 0.778) {
        opacity = _fadeOut.value;
      }
    }

    return GraphPaperBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Image.asset(
                      'lib/img/logo.png',
                      width: 120,
                      height: 120,
                    ),
                    const SizedBox(height: 48),
                    // Animated loading sentence
                    AnimatedOpacity(
                      opacity: disableAnimations ? 1.0 : opacity,
                      duration: disableAnimations ? Duration.zero : const Duration(milliseconds: 200),
                      child: Text(
                        _sentences[_currentSentenceIndex],
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark ? SieveColors.darkTextSecondary : SieveColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Progress bar at bottom
            AnimatedBuilder(
              animation: _progressController,
              builder: (context, child) {
                return LinearProgressIndicator(
                  value: _progressController.value,
                  backgroundColor: isDark ? SieveColors.darkGridLine : SieveColors.lightGridLine,
                  valueColor: const AlwaysStoppedAnimation<Color>(SieveColors.accent),
                  minHeight: 2,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
