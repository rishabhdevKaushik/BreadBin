import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../transaction.dart';
import '../utils/history_grouping.dart';
import '../theme.dart';
import '../utils/scroll_to_bottom.dart';

class HistoryArea extends StatefulWidget {
  final List<TransactionEntry> transactions;
  final ScrollController scrollController;
  final VoidCallback onCollapse;

  const HistoryArea({
    super.key,
    required this.transactions,
    required this.scrollController,
    required this.onCollapse,
  });

  @override
  State<HistoryArea> createState() => _HistoryAreaState();
}

class _HistoryAreaState extends State<HistoryArea> {
  late List<MonthGroup> grouped;

  @override
  void initState() {
    super.initState();
    grouped = groupTransactionsByDayAndMonth(widget.transactions);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.scrollController.hasClients) {
        // Scroll to bottom on initial load
        widget.scrollController.jumpTo(
          widget.scrollController.position.maxScrollExtent,
        );
      }
    });
  }

  @override
  void didUpdateWidget(covariant HistoryArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.transactions != widget.transactions) {
      setState(() {
        grouped = groupTransactionsByDayAndMonth(widget.transactions);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (grouped.isEmpty) {
      return const Center(child: Text("No history yet"));
    }

    return Stack(
      children: [
        SafeArea(
          child: CustomScrollView(
            controller: widget.scrollController,
            slivers: [
              // For each month, a sticky header that wraps day sticky headers
              for (final month in grouped)
                SliverStickyHeader(
                  header: _buildMonthHeader(month.monthSummary),
                  sliver: MultiSliver(
                    children: [
                      for (final day in month.days)
                        SliverStickyHeader(
                          header: _buildDayHeader(day.daySummary),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => _buildTransactionTile(
                                day.transactions[index],
                              ),
                              childCount: day.transactions.length,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        ScrollToBottomFAB(scrollController: widget.scrollController),
      ],
    );
  }

  Widget _buildMonthHeader(MonthSummaryHeader month) {
    return Container(
      color: Colors.blue.shade700,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      alignment: Alignment.centerLeft,
      child: Text(
        "${_monthName(month.month)} ${month.year} | "
        "Income ₹${month.income.toStringAsFixed(0)}, "
        "Expense ₹${month.expense.toStringAsFixed(0)}",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildDayHeader(DaySummary day) {
    return Container(
      color: Colors.blue.shade300,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        "${_dateBuilder(day)} | "
        "Income ₹${day.income.toStringAsFixed(0)}, "
        "Expense ₹${day.expense.toStringAsFixed(0)}",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildTransactionTile(TransactionEntry txn) {
    final localDateTime = txn.dateTime.toLocal();
    final formattedTime =
        '${localDateTime.hour.toString().padLeft(2, '0')}:${localDateTime.minute.toString().padLeft(2, '0')}';

    return ListTile(
      leading: Icon(
        txn.type == TransactionType.income
            ? Icons.arrow_downward
            : Icons.arrow_upward,
        color: txn.type == TransactionType.income
            ? AppTheme.income
            : AppTheme.expense,
      ),
      title: Text(
        '₹${txn.amount.toStringAsFixed(2)}',
        style: TextStyle(
          color: txn.type == TransactionType.income
              ? AppTheme.income
              : AppTheme.expense,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        '$formattedTime\n${txn.tags.join(", ")}',
        style: TextStyle(color: AppTheme.textSecondary),
      ),
      isThreeLine: true,
    );
  }

  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
  }

  String _dateBuilder(DaySummary day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final current = DateTime(day.date.year, day.date.month, day.date.day);

    if (current == today) {
      return "Today";
    } else if (current == yesterday) {
      return "Yesterday";
    } else {
      return "${day.date.day} ${_monthName(day.date.month)}";
    }
  }
}
