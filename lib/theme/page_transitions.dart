import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Custom page transitions for Sieve app
class SievePageTransitions {
  /// Slide left for forward navigation (300ms, easeInOut)
  static CustomTransitionPage<T> slideLeft<T>({
    required Widget child,
    required GoRouterState state,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Check for disabled animations
        if (MediaQuery.of(context).disableAnimations) {
          return child;
        }

        final tween = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  /// Fade out for back navigation (200ms)
  static CustomTransitionPage<T> fade<T>({
    required Widget child,
    required GoRouterState state,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 200),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Check for disabled animations
        if (MediaQuery.of(context).disableAnimations) {
          return child;
        }

        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  /// Tab switch fade (200ms)
  static Widget tabFade({
    required Widget child,
    required Animation<double> animation,
  }) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

/// Route observer for handling back navigation fade
class SieveRouteObserver extends NavigatorObserver {
  bool _isPopping = false;

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _isPopping = true;
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _isPopping = false;
    super.didPush(route, previousRoute);
  }

  bool get isPopping => _isPopping;
}

/// Helper widget for tab transitions
class SieveTabTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;

  const SieveTabTransition({
    super.key,
    required this.child,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) {
      return child;
    }

    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
