import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Graph paper background that scrolls with content
class GraphPaperBackground extends StatelessWidget {
  final Widget child;
  final ScrollController? scrollController;

  const GraphPaperBackground({
    super.key,
    required this.child,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        // Graph paper layer that fills the screen
        Positioned.fill(
          child: CustomPaint(
            painter: _GraphPaperPainter(
              gridLineColor: isDark ? SieveColors.darkGridLine : SieveColors.lightGridLine,
              gridLineMajorColor: isDark ? SieveColors.darkGridLineMajor : SieveColors.lightGridLineMajor,
              backgroundColor: isDark ? SieveColors.darkBackground : SieveColors.lightBackground,
              scrollController: scrollController,
            ),
          ),
        ),
        // Content on top
        child,
      ],
    );
  }
}

/// CustomPainter for drawing graph paper grid
class _GraphPaperPainter extends CustomPainter {
  final Color gridLineColor;
  final Color gridLineMajorColor;
  final Color backgroundColor;
  final ScrollController? scrollController;

  _GraphPaperPainter({
    required this.gridLineColor,
    required this.gridLineMajorColor,
    required this.backgroundColor,
    this.scrollController,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Fill background
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = backgroundColor,
    );

    final paint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const gridSize = 24.0;

    // Calculate scroll offset if available
    double scrollOffset = 0;
    if (scrollController != null && scrollController!.hasClients) {
      scrollOffset = scrollController!.offset;
    }

    // Adjust for scroll so grid appears to move with content
    final startY = -(scrollOffset % gridSize);

    // Draw horizontal lines
    for (double y = startY; y < size.height; y += gridSize) {
      if (y < 0) continue;

      // Every 5th line is major
      final isMajor = ((y + scrollOffset) / gridSize).round() % 5 == 0;
      paint.color = isMajor ? gridLineMajorColor : gridLineColor;

      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Draw vertical lines (these don't scroll horizontally in most layouts)
    for (double x = 0; x < size.width; x += gridSize) {
      final isMajor = (x / gridSize).round() % 5 == 0;
      paint.color = isMajor ? gridLineMajorColor : gridLineColor;

      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GraphPaperPainter oldDelegate) {
    // Repaint when scroll changes
    if (scrollController != null && oldDelegate.scrollController != null) {
      return scrollController!.offset != oldDelegate.scrollController!.offset ||
             gridLineColor != oldDelegate.gridLineColor ||
             gridLineMajorColor != oldDelegate.gridLineMajorColor ||
             backgroundColor != oldDelegate.backgroundColor;
    }
    return gridLineColor != oldDelegate.gridLineColor ||
           gridLineMajorColor != oldDelegate.gridLineMajorColor ||
           backgroundColor != oldDelegate.backgroundColor;
  }
}

/// Widget wrapper that adds graph paper background and handles scroll updates
class GraphPaperScaffold extends StatefulWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool extendBody;
  final bool extendBodyBehindAppBar;

  const GraphPaperScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
  });

  @override
  State<GraphPaperScaffold> createState() => _GraphPaperScaffoldState();
}

class _GraphPaperScaffoldState extends State<GraphPaperScaffold> {
  ScrollController? _scrollController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Try to find a scroll controller from context if available
    _scrollController = PrimaryScrollController.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return GraphPaperBackground(
      scrollController: _scrollController,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: widget.appBar,
        body: widget.body,
        bottomNavigationBar: widget.bottomNavigationBar,
        floatingActionButton: widget.floatingActionButton,
        extendBody: widget.extendBody,
        extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
      ),
    );
  }
}

/// Wraps a scrollable widget with graph paper background that scrolls with content
class GraphPaperScrollable extends StatelessWidget {
  final Widget child;
  final ScrollController? controller;

  const GraphPaperScrollable({
    super.key,
    required this.child,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        // Trigger repaint on scroll
        (context as Element).markNeedsBuild();
        return false;
      },
      child: GraphPaperBackground(
        scrollController: controller,
        child: child,
      ),
    );
  }
}
