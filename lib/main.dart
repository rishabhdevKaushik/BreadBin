import 'package:flutter/material.dart';
import 'theme.dart';
import 'widgets/display_area.dart';
import 'widgets/numpad_area.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'transaction.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bread Bin',
      theme: AppTheme.darkTheme,
      home: const ExpenseHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ExpenseHomePage extends StatefulWidget {
  const ExpenseHomePage({super.key});

  @override
  State<ExpenseHomePage> createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  List<TransactionEntry> _transactionHistory = [];
  final ScrollController _historyScrollController = ScrollController();

  double _total = 0.0;
  String _input = '0';
  TransactionType _type = TransactionType.expense;
  bool _displayExpanded = false;

  // NEW: store tags from InputArea
  List<String> _currentTags = [];

  @override
  void initState() {
    super.initState();
    _loadTotal();
    _loadTransactions();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_historyScrollController.hasClients) {
        _historyScrollController.animateTo(
          _historyScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _loadTransactions() async {
    final loaded = await loadTransactions();
    setState(() {
      _transactionHistory = loaded;
    });
    _scrollToBottom();
  }

  Future<void> _loadTotal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _total = prefs.getDouble('total_amount') ?? 0.0;
    });
  }

  Future<void> _saveTotal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('total_amount', _total);
  }

  void _onNumberPressed(String value) {
    setState(() {
      if (_input == '0') {
        _input = value;
      } else {
        if (_input.contains('.')) {
          final parts = _input.split('.');
          if (parts.length > 1 && parts[1].length >= 2) {
            return;
          }
        }
        _input += value;
      }
    });
  }

  void _onDotPressed() {
    setState(() {
      if (!_input.contains('.')) {
        _input += '.';
      }
    });
  }

  void _onBackspacePressed() {
    setState(() {
      if (_input.length == 1) {
        _input = '0';
      } else {
        _input = _input.substring(0, _input.length - 1);
      }
    });
  }

  void _onAddPressed() async {
    double value = double.tryParse(_input) ?? 0.0;
    if (value == 0.0) return;

    final now = DateTime.now();

    final newEntry = TransactionEntry(
      amount: value,
      tags: _currentTags, // ✅ attach current tags
      type: _type,
      dateTime: now,
    );

    List<TransactionEntry> currentTransactions = await loadTransactions();
    currentTransactions.add(newEntry);
    await saveTransactions(currentTransactions);

    setState(() {
      if (_type == TransactionType.income) {
        _total += value;
      } else {
        _total -= value;
      }
      _input = '0';
      _transactionHistory.add(newEntry);
      _currentTags = []; // clear tags after saving
    });
    _saveTotal();
    _scrollToBottom();
  }

  void _onPlusOptionTap() {
    setState(() {
      _type = TransactionType.income;
    });
  }

  void _onMinusOptionTap() {
    setState(() {
      _type = TransactionType.expense;
    });
  }

  void _expandDisplay() {
    setState(() {
      _displayExpanded = true;
    });
  }

  void _collapseDisplay() {
    setState(() {
      _displayExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: NumpadArea(
                  onNumberPressed: _onNumberPressed,
                  onDotPressed: _onDotPressed,
                  onAddPressed: _onAddPressed,
                  onBackspacePressed: _onBackspacePressed,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: DisplayArea(
                  total: _total,
                  input: _input,
                  onPlusOptionTap: _onPlusOptionTap,
                  onMinusOptionTap: _onMinusOptionTap,
                  expanded: _displayExpanded,
                  onExpand: _expandDisplay,
                  onCollapse: _collapseDisplay,
                  transactionHistory: _transactionHistory,
                  historyScrollController: _historyScrollController,

                  // NEW: pass tags change handler
                  onTagsChanged: (tags) {
                    _currentTags = List.from(tags);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
