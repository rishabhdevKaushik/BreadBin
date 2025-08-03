// /utils/scroll_to_bottom.dart

import 'package:flutter/material.dart';

class ScrollToBottomFAB extends StatefulWidget {
  final ScrollController scrollController;

  const ScrollToBottomFAB({super.key, required this.scrollController});

  @override
  State<ScrollToBottomFAB> createState() => _ScrollToBottomFABState();
}

class _ScrollToBottomFABState extends State<ScrollToBottomFAB> {
  bool _show = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    const threshold = 50.0;
    final offset = widget.scrollController.offset;
    final max = widget.scrollController.position.maxScrollExtent;
    if (offset < max - threshold && !_show) {
      setState(() => _show = true);
    } else if (offset >= max - threshold && _show) {
      setState(() => _show = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_show) return const SizedBox.shrink();
    return Positioned(
      right: 16,
      bottom: 16,
      child: FloatingActionButton(
        mini: true,
        tooltip: 'Scroll to latest',
        onPressed: () {
          widget.scrollController.animateTo(
            widget.scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        },
        child: const Icon(Icons.arrow_downward),
      ),
    );
  }
}
