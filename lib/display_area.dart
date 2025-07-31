import 'package:flutter/material.dart';
import 'history_area.dart';
import 'input_area.dart';
import 'theme.dart';

class DisplayArea extends StatefulWidget {
  final double total;
  final String input;
  final VoidCallback onPlusOptionTap;
  final VoidCallback onMinusOptionTap;
  final bool expanded;
  final VoidCallback onExpand;
  final VoidCallback onCollapse;

  const DisplayArea({
    super.key,
    required this.total,
    required this.input,
    required this.onPlusOptionTap,
    required this.onMinusOptionTap,
    required this.expanded,
    required this.onExpand,
    required this.onCollapse,
  });

  @override
  State<DisplayArea> createState() => _DisplayAreaState();
}

class _DisplayAreaState extends State<DisplayArea> with SingleTickerProviderStateMixin {
  double _dragOffset = 0.0;
  bool _isDragging = false;
  late double _collapsedHeight;
  late double _expandedHeight;
  AnimationController? _animationController;
  Animation<double>? _heightAnimation;

  late final ScrollController _historyScrollController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heightAnimation = Tween<double>(begin: 0, end: 0).animate(_animationController!);
    _historyScrollController = ScrollController();
  }

  @override
  void dispose() {
    _historyScrollController.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  void _onVerticalDragStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
      _dragOffset = 0.0;
    });
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.primaryDelta ?? 0.0;
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    _isDragging = false;
    double velocity = details.primaryVelocity ?? 0.0;
    double threshold = (_expandedHeight - _collapsedHeight) / 2;
    double currentHeight = widget.expanded ? _expandedHeight : _collapsedHeight;
    double newHeight = (currentHeight + _dragOffset).clamp(_collapsedHeight, _expandedHeight);

    bool shouldExpand;
    if (velocity > 700) {
      shouldExpand = true;
    } else if (velocity < -700) {
      shouldExpand = false;
    } else {
      shouldExpand = (newHeight - _collapsedHeight) > threshold;
    }

    if (shouldExpand && !widget.expanded) {
      widget.onExpand();
    } else if (!shouldExpand && widget.expanded) {
      widget.onCollapse();
    }

    double targetHeight = shouldExpand ? _expandedHeight : _collapsedHeight;

    if (_animationController != null) {
      _heightAnimation = Tween<double>(begin: newHeight, end: targetHeight).animate(_animationController!)
        ..addListener(() {
          setState(() {});
        });
      _animationController!.reset();
      _animationController!.forward();
    }

    setState(() {
      _dragOffset = 0.0;
    });
  }

  double _getDisplayHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final totalHeight = mediaQuery.size.height;
    _collapsedHeight = totalHeight * 0.55;
    _expandedHeight = totalHeight * 0.95;

    if (_isDragging) {
      double base = widget.expanded ? _expandedHeight : _collapsedHeight;
      double newHeight = (base + _dragOffset).clamp(_collapsedHeight, _expandedHeight);
      return newHeight;
    } else if (_animationController != null &&
        _animationController!.isAnimating &&
        _heightAnimation != null) {
      return _heightAnimation!.value;
    } else {
      return widget.expanded ? _expandedHeight : _collapsedHeight;
    }
  }

  double _getExpandProgress(double displayHeight) {
    if (_expandedHeight == _collapsedHeight) return 0.0;
    return ((displayHeight - _collapsedHeight) / (_expandedHeight - _collapsedHeight)).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    double displayHeight = _getDisplayHeight(context);
    double progress = _getExpandProgress(displayHeight);
    const double slideDistance = 40.0;

    return AnimatedContainer(
      duration: Duration(
        milliseconds: _isDragging || (_animationController?.isAnimating ?? false) ? 0 : 300,
      ),
      height: displayHeight,
      curve: Curves.ease,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onVerticalDragStart: _onVerticalDragStart,
                onVerticalDragUpdate: _onVerticalDragUpdate,
                onVerticalDragEnd: _onVerticalDragEnd,
                child: Stack(
                  children: [
                    Opacity(
                      opacity: progress <= 0.0
                          ? 1.0
                          : (progress < 0.45
                              ? (1.0 - (progress / 0.45) * 0.7)
                              : (progress < 0.55
                                  ? (0.3 - ((progress - 0.45) / 0.10) * 0.3)
                                  : 0.0)),
                      child: Transform.translate(
                        offset: Offset(0, slideDistance * progress),
                        child: IgnorePointer(
                          ignoring: progress > 0.55,
                          child: SizedBox.expand(
                            child: InputArea(
                              total: widget.total,
                              input: widget.input,
                              onPlusOptionTap: widget.onPlusOptionTap,
                              onMinusOptionTap: widget.onMinusOptionTap,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: progress < 0.45
                          ? 0.0
                          : (progress < 0.55
                              ? ((progress - 0.45) / 0.10 * 0.3)
                              : (progress < 1.0
                                  ? (0.3 + ((progress - 0.55) / 0.45) * 0.7)
                                  : 1.0)),
                      child: Transform.translate(
                        offset: Offset(0, -slideDistance * (1.0 - progress)),
                        child: IgnorePointer(
                          ignoring: progress < 0.45,
                          child: SizedBox.expand(
                            child: HistoryArea(
                              scrollController: _historyScrollController,
                              onCollapse: widget.onCollapse,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            DragBar(
              onVerticalDragStart: _onVerticalDragStart,
              onVerticalDragUpdate: _onVerticalDragUpdate,
              onVerticalDragEnd: _onVerticalDragEnd,
            ),
          ],
        ),
      ),
    );
  }
}

class DragBar extends StatelessWidget {
  final GestureDragStartCallback? onVerticalDragStart;
  final GestureDragUpdateCallback? onVerticalDragUpdate;
  final GestureDragEndCallback? onVerticalDragEnd;
  final Key? barKey;

  const DragBar({
    super.key,
    this.onVerticalDragStart,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.barKey,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: barKey,
      onVerticalDragStart: onVerticalDragStart,
      onVerticalDragUpdate: onVerticalDragUpdate,
      onVerticalDragEnd: onVerticalDragEnd,
      child: Container(
        height: 24,
        width: double.infinity,
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: 120,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ),
    );
  }
}
