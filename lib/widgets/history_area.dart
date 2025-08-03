import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
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
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await Future.delayed(const Duration(milliseconds: 100));

      if (widget.scrollController.hasClients) {
        widget.scrollController.jumpTo(
          widget.scrollController.position.maxScrollExtent,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final grouped = groupTransactionsByDayAndMonth(widget.transactions);

    if (grouped.isEmpty) {
      return const Center(child: Text("No history yet"));
    }

    return Stack(
      children: [
        CustomScrollView(
          controller: widget.scrollController,
          slivers: [
            for (final month in grouped) ...[
              SliverStickyHeader(
                header: _buildMonthHeader(month.monthSummary),
                sliver: const SliverToBoxAdapter(child: SizedBox.shrink()),
              ),
              for (final day in month.days)
                SliverStickyHeader(
                  header: _buildDayHeader(day.daySummary),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          _buildTransactionTile(day.transactions[index]),
                      childCount: day.transactions.length,
                    ),
                  ),
                ),
            ],
          ],
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
        style: const TextStyle(color: Colors.white),
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
      "Febuary",
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

    String label;
    if (current == today) {
      label = "Today";
    } else if (current == yesterday) {
      label = "Yesterday";
    } else {
      label = "${day.date.day} ${_monthName(day.date.month)}";
    }
    return label;
  }
}
