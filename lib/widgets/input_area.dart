import 'package:flutter/material.dart';
import '../theme.dart';

class InputArea extends StatefulWidget {
  final double total;
  final String input;
  final VoidCallback onPlusOptionTap;
  final VoidCallback onMinusOptionTap;
  final Function(List<String>) onTagsChanged;

  const InputArea({
    super.key,
    required this.total,
    required this.input,
    required this.onPlusOptionTap,
    required this.onMinusOptionTap,
    required this.onTagsChanged,
  });

  @override
  State<InputArea> createState() => _InputAreaState();
}

class _InputAreaState extends State<InputArea> {
  bool _isIncome = false;
  final List<String> _tags = [];
  final TextEditingController _tagController = TextEditingController();
  final ScrollController _tagsScrollController = ScrollController();
  bool _isAddingTag = false;

  void _notifyParent() {
    widget.onTagsChanged(List.from(_tags));
  }

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

  void _addTag(String tag) {
    if (tag.trim().isEmpty) return;
    setState(() {
      _tags.add(tag.trim());
    });
    _notifyParent();
    _tagController.clear();

    // Scroll to the end after short delay for layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_tagsScrollController.hasClients) {
        _tagsScrollController.animateTo(
          _tagsScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
    _notifyParent();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_tagsScrollController.hasClients) {
        _tagsScrollController.animateTo(
          _tagsScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Total Display
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

        /// Main Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Left Minus/Plus pill
                SizedBox(
                  height: 56,
                  child: Center(
                    child: MinusPill(
                      onPlusOptionTap: widget.onPlusOptionTap,
                      onMinusOptionTap: widget.onMinusOptionTap,
                      onMenuSelected: _handleMenuSelected,
                      symbol: _isIncome ? '+' : '-',
                      symbolColor: _isIncome
                          ? AppTheme.income
                          : AppTheme.expense,
                      isIncomeSelected: _isIncome,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Right Column (amount + tags)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Amount display
                      Builder(
                        builder: (context) {
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
                          if ('.'.allMatches(formattedInput).length > 1) {
                            formattedInput = formattedInput.replaceFirst(
                              '.',
                              '',
                            );
                          }
                          if (formattedInput == '.') {
                            formattedInput = '0.';
                          }
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
                      const SizedBox(height: 8),

                      // Horizontal scroll tags + add button
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _tagsScrollController,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ..._tags.map(
                                (tag) => Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: SizedBox(
                                    height: 44,
                                    child: Chip(
                                      label: Text(tag),
                                      backgroundColor: AppTheme.pill,
                                      shape: const StadiumBorder(
                                        side: BorderSide(
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      labelStyle: TextStyle(
                                        color: AppTheme.textPrimary,
                                      ),
                                      onDeleted: () => _removeTag(tag),
                                      deleteIconColor: AppTheme.textPrimary
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                                ),
                              ),

                              // Add tag pill at right
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _isAddingTag = true),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeInOut,
                                  width: _isAddingTag ? 100 : 68,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: AppTheme.pill,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  child: _isAddingTag
                                      ? TextField(
                                          controller: _tagController,
                                          autofocus: true,
                                          decoration: InputDecoration(
                                            hintText: 'Tag',
                                            hintStyle: TextStyle(
                                              color: AppTheme.textPrimary
                                                  .withValues(alpha: 0.6),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 9,
                                                ),
                                            border: InputBorder.none,
                                          ),
                                          style: TextStyle(
                                            color: AppTheme.textPrimary,
                                          ),
                                          onSubmitted: (value) {
                                            _addTag(value);
                                            setState(
                                              () => _isAddingTag = false,
                                            );
                                          },
                                          onEditingComplete: () => setState(
                                            () => _isAddingTag = false,
                                          ),
                                        )
                                      : Center(
                                          child: Icon(
                                            Icons.local_offer,
                                            color: AppTheme.textSecondary,
                                            size: 28,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
  final VoidCallback onPlusOptionTap;
  final VoidCallback onMinusOptionTap;
  final void Function(int) onMenuSelected;
  final String symbol;
  final Color symbolColor;
  final bool isIncomeSelected;

  const MinusPill({
    super.key,
    required this.onPlusOptionTap,
    required this.onMinusOptionTap,
    required this.onMenuSelected,
    required this.symbol,
    required this.symbolColor,
    required this.isIncomeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      color: AppTheme.surface,
      tooltip: 'Change type',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onSelected: onMenuSelected,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          padding: EdgeInsets.zero,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isIncomeSelected
                  ? AppTheme.income.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.add, color: AppTheme.income),
                const SizedBox(width: 8),
                Text(
                  'Income',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: isIncomeSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          value: -1,
          padding: EdgeInsets.zero,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: !isIncomeSelected
                  ? AppTheme.expense.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.remove, color: AppTheme.expense),
                const SizedBox(width: 8),
                Text(
                  'Expense',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: !isIncomeSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 6),
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
