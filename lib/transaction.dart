import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionEntry {
  final double amount;
  final List<String> tags;
  final TransactionType type;
  final DateTime dateTime;

  TransactionEntry({
    required this.amount,
    List<String>? tags,
    required this.type,
    required this.dateTime,
  }) : tags = tags ?? [];

  // Convert object to Map<String, dynamic> for saving in SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'tags': tags,
      'type': type.toString().split('.').last,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  // Construct from map
  factory TransactionEntry.fromMap(Map<String, dynamic> map) {
    return TransactionEntry(
      amount: map['amount'],
      tags: map['tags'] != null ? List<String>.from(map['tags']) : [],
      type: map['type'] == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      dateTime: DateTime.parse(map['dateTime']),
    );
  }
}

enum TransactionType { income, expense }

Future<List<TransactionEntry>> loadTransactions() async {
  final prefs = await SharedPreferences.getInstance();
  final String? jsonString = prefs.getString('transaction_history');
  if (jsonString == null) return [];
  final List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((e) => TransactionEntry.fromMap(e)).toList();
}

Future<void> saveTransactions(List<TransactionEntry> transactions) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonList = transactions.map((e) => e.toMap()).toList();
  final jsonString = json.encode(jsonList);
  await prefs.setString('transaction_history', jsonString);
}
