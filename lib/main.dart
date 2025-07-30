import 'package:flutter/material.dart';
import 'theme.dart';
import 'display_area.dart';
import 'numpad_area.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: AppTheme.darkTheme,
      home: const ExpenseHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

enum TransactionType { income, expense }

class ExpenseHomePage extends StatefulWidget {
  const ExpenseHomePage({super.key});

  @override
  State<ExpenseHomePage> createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  double _total = 0.0;
  String _input = '0';
  TransactionType _type = TransactionType.expense;
  bool _displayExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadTotal();
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
        // Prevent more than 2 digits after decimal
        if (_input.contains('.')) {
          final parts = _input.split('.');
          if (parts.length > 1 && parts[1].length >= 2) {
            // If already 2 digits after decimal, ignore further input
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

  void _onAddPressed() {
    double value = double.tryParse(_input) ?? 0.0;
    setState(() {
      if (_type == TransactionType.income) {
        _total += value;
      } else {
        _total -= value;
      }
      _input = '0';
    });
    _saveTotal();
  }

  // void _onMinusTap() {
  //   // Not used, handled by popup
  // }

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
              // NumpadArea positioned at the bottom
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

              // DisplayArea positioned at the top
              Positioned(
                // duration: const Duration(milliseconds: 300),
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
