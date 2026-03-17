import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Primary button with scale animation on tap
class SievePrimaryButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsets padding;

  const SievePrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  });

  @override
  State<SievePrimaryButton> createState() => _SievePrimaryButtonState();
}

class _SievePrimaryButtonState extends State<SievePrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null) {
      _controller.reverse().then((_) {
        widget.onPressed!();
      });
    }
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    if (disableAnimations) {
      return ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          padding: widget.padding,
        ),
        child: widget.child,
      );
    }

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: ElevatedButton(
              onPressed: null, // handled by GestureDetector
              style: ElevatedButton.styleFrom(
                padding: widget.padding,
                disabledBackgroundColor: SieveColors.accent,
                disabledForegroundColor: SieveColors.accentText,
              ),
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}

/// Secondary/ghost button with flash animation on tap
class SieveSecondaryButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsets padding;

  const SieveSecondaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  });

  @override
  State<SieveSecondaryButton> createState() => _SieveSecondaryButtonState();
}

class _SieveSecondaryButtonState extends State<SieveSecondaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _flashController;
  late AnimationController _scaleController;
  late Animation<double> _flashOpacity;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _flashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _flashOpacity = Tween<double>(begin: 0.0, end: 0.15).animate(
      CurvedAnimation(parent: _flashController, curve: Curves.easeOut),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _flashController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      _flashController.forward();
      _scaleController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) async {
    if (widget.onPressed != null) {
      await Future.delayed(const Duration(milliseconds: 100));
      await _flashController.reverse();
      await _scaleController.reverse();
      widget.onPressed!();
    }
  }

  void _onTapCancel() {
    _flashController.reverse();
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    if (disableAnimations) {
      return OutlinedButton(
        onPressed: widget.onPressed,
        style: OutlinedButton.styleFrom(
          padding: widget.padding,
        ),
        child: widget.child,
      );
    }

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: Listenable.merge([_flashController, _scaleController]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Stack(
              children: [
                OutlinedButton(
                  onPressed: null,
                  style: OutlinedButton.styleFrom(
                    padding: widget.padding,
                  ),
                  child: widget.child,
                ),
                Positioned.fill(
                  child: Container(
                    color: SieveColors.accent.withOpacity(_flashOpacity.value),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// List tile with subtle flash animation on tap
class SieveListTile extends StatefulWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const SieveListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
  });

  @override
  State<SieveListTile> createState() => _SieveListTileState();
}

class _SieveListTileState extends State<SieveListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _opacity = Tween<double>(begin: 0.0, end: 0.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) async {
    if (widget.onTap != null) {
      await _controller.reverse();
      widget.onTap!();
    }
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    if (disableAnimations || widget.onTap == null) {
      return ListTile(
        leading: widget.leading,
        title: widget.title,
        subtitle: widget.subtitle,
        trailing: widget.trailing,
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
      );
    }

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: _opacity,
        builder: (context, child) {
          return Container(
            color: SieveColors.accent.withOpacity(_opacity.value),
            child: ListTile(
              leading: widget.leading,
              title: widget.title,
              subtitle: widget.subtitle,
              trailing: widget.trailing,
              onTap: null,
            ),
          );
        },
      ),
    );
  }
}

/// Animated bottom navigation bar item with scale effect
class SieveNavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SieveNavBarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final disableAnimations = MediaQuery.of(context).disableAnimations;
    final color = isSelected ? SieveColors.accent : theme.sieveTextSecondary;

    if (disableAnimations) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: color, fontSize: 12)),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 1.0, end: isSelected ? 1.15 : 1.0),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: color),
                  const SizedBox(height: 4),
                  Text(label, style: TextStyle(color: color, fontSize: 12)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
