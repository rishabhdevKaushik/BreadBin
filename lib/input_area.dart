import 'package:flutter/material.dart';
import 'theme.dart';

class InputArea extends StatefulWidget {
  final double total;
  final String input;
  // final VoidCallback onMinusTap;
  final VoidCallback onPlusOptionTap;
  final VoidCallback onMinusOptionTap;

  const InputArea({
    super.key,
    required this.total,
    required this.input,
    // required this.onMinusTap,
    required this.onPlusOptionTap,
    required this.onMinusOptionTap,
  });

  @override
  State<InputArea> createState() => _InputAreaState();
}

class _InputAreaState extends State<InputArea> {
  bool _isIncome = false;

  void _handleMenuSelected(int value) {
    setState(() {
      if (value == 1) {
        _isIncome = true;
        widget.onPlusOptionTap();
      } else if (value == -1) {
        _isIncome = false;
        widget.onMinusOptionTap();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 12,
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: AppTheme.pill,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Text(
                '₹ ${widget.total.toStringAsFixed(2)}',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: SizedBox(
            height: 72, // Fixed height for both pill and input
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // - pill with popup
                SizedBox(
                  height: 56,
                  child: Center(
                    child: MinusPill(
                      // onMinusTap: widget.onMinusTap,
                      onPlusOptionTap: widget.onPlusOptionTap,
                      onMinusOptionTap: widget.onMinusOptionTap,
                      onMenuSelected: _handleMenuSelected,
                      symbol: _isIncome ? '+' : '-',
                      symbolColor: _isIncome
                          ? AppTheme.income
                          : AppTheme.expense,
                    ),
                  ),
                ),
                // Input display
                SizedBox(
                  height: 72,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      alignment: Alignment.center,
                      child: Builder(
                        builder: (context) {
                          // Format input to only allow two digits after the decimal point
                          String formattedInput = widget.input;
                          if (formattedInput.contains('.')) {
                            final parts = formattedInput.split('.');
                            if (parts.length > 1) {
                              final decimals = parts[1].length > 2
                                  ? parts[1].substring(0, 2)
                                  : parts[1];
                              formattedInput =
                                  parts[0] +
                                  (decimals.isNotEmpty ? '.$decimals' : '.');
                            }
                          }
                          // Remove any extra decimals
                          if ('.'.allMatches(formattedInput).length > 1) {
                            formattedInput = formattedInput.replaceFirst(
                              '.',
                              '',
                            );
                          }
                          // Special case: if input is just '.' show '0.'
                          if (formattedInput == '.') {
                            formattedInput = '0.';
                          }
                          // Determine font size based on input length (excluding decimal point)
                          int digitCount = formattedInput
                              .replaceAll('.', '')
                              .length;
                          double fontSize = 56;
                          if (digitCount > 9) {
                            fontSize = 32;
                          } else if (digitCount > 6) {
                            fontSize = 40;
                          }
                          return Text(
                            formattedInput,
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: fontSize,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MinusPill extends StatelessWidget {
  // final VoidCallback onMinusTap;
  final VoidCallback onPlusOptionTap;
  final VoidCallback onMinusOptionTap;
  final void Function(int) onMenuSelected;
  final String symbol;
  final Color symbolColor;

  const MinusPill({
    super.key,
    // required this.onMinusTap,
    required this.onPlusOptionTap,
    required this.onMinusOptionTap,
    required this.onMenuSelected,
    required this.symbol,
    required this.symbolColor,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      color: AppTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onSelected: onMenuSelected,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.add, color: AppTheme.income),
              SizedBox(width: 8),
              Text('Income', style: TextStyle(color: AppTheme.textPrimary)),
            ],
          ),
        ),
        PopupMenuItem(
          value: -1,
          child: Row(
            children: [
              Icon(Icons.remove, color: AppTheme.expense),
              SizedBox(width: 8),
              Text('Expense', style: TextStyle(color: AppTheme.textPrimary)),
            ],
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.pill,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          symbol,
          style: TextStyle(
            color: symbolColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
