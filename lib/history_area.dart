import 'package:flutter/material.dart';
import 'theme.dart';
import 'transaction.dart';

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
  _HistoryAreaState createState() => _HistoryAreaState();
}

class _HistoryAreaState extends State<HistoryArea> {
  bool _showScrollDownButton = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final minScroll =
        widget.scrollController.position.minScrollExtent; // Usually zero
    final currentScroll = widget.scrollController.position.pixels;
    const threshold = 50.0;

    // Show the button if the user is scrolled away from bottom by more than threshold
    if (currentScroll - minScroll > threshold && !_showScrollDownButton) {
      setState(() {
        _showScrollDownButton = true;
      });
    }
    // Hide the button when near the bottom (within threshold)
    else if (currentScroll - minScroll <= threshold && _showScrollDownButton) {
      setState(() {
        _showScrollDownButton = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.transactions.isEmpty) {
      return Center(
        child: Text(
          'No history yet',
          style: TextStyle(color: AppTheme.textPrimary, fontSize: 20),
        ),
      );
    }
    return Stack(
      children: [
        ListView.builder(
          controller: widget.scrollController,
          reverse: true, // latest at bottom
          itemCount: widget.transactions.length,
          itemBuilder: (context, index) {
            // Access transactions in order: earliest at top (index 0), latest at bottom (last index)
            final txn =
                widget.transactions[widget.transactions.length - 1 - index];
            
            final localDateTime = txn.dateTime.toLocal();
            // Format date as YYYY-MM-DD
            final formattedDate =
                '${localDateTime.year.toString().padLeft(4, '0')}-'
                '${localDateTime.month.toString().padLeft(2, '0')}-'
                '${localDateTime.day.toString().padLeft(2, '0')}';
            // Format time as HH:mm
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
                // '${txn.type == TransactionType.income ? "+" : "-"}₹${txn.amount.toStringAsFixed(2)}',
                '₹${txn.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: txn.type == TransactionType.income
                      ? AppTheme.income
                      : AppTheme.expense,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '$formattedDate $formattedTime \n${txn.tags.join(", ")}',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
              isThreeLine: true,
            );
          },
        ),

        // Scroll down button
        if (_showScrollDownButton)
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              mini: true,
              tooltip: 'Scroll to latest',
              onPressed: () {
                widget.scrollController.animateTo(
                  widget.scrollController.position.minScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              },
              child: const Icon(Icons.arrow_downward),
            ),
          ),
      ],
    );
  }
}
