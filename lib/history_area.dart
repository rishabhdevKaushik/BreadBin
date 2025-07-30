import 'package:flutter/material.dart';
import 'theme.dart';

class HistoryArea extends StatelessWidget {
  final ScrollController scrollController;
  final VoidCallback onCollapse;
  const HistoryArea({
    super.key,
    required this.scrollController,
    required this.onCollapse,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Text(
              'History of Expenses and Incomes',
              style: TextStyle(color: AppTheme.textPrimary, fontSize: 24),
            ),
          ),
        ),
      ],
    );
  }
}
