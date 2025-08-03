// utils/history_grouping.dart
import '../transaction.dart';

class DaySummary {
  final DateTime date;
  final double income;
  final double expense;

  DaySummary({
    required this.date,
    required this.income,
    required this.expense,
  });
}

class MonthSummaryHeader {
  final int year;
  final int month;
  final double income;
  final double expense;

  MonthSummaryHeader({
    required this.year,
    required this.month,
    required this.income,
    required this.expense,
  });
}

class DayGroup {
  final DaySummary daySummary;
  final List<TransactionEntry> transactions;

  DayGroup({
    required this.daySummary,
    required this.transactions,
  });
}

class MonthGroup {
  final MonthSummaryHeader monthSummary;
  final List<DayGroup> days;

  MonthGroup({
    required this.monthSummary,
    required this.days,
  });
}

List<MonthGroup> groupTransactionsByDayAndMonth(List<TransactionEntry> transactions) {
  final sortedTxns = List<TransactionEntry>.from(transactions)
    ..sort((a, b) => a.dateTime.compareTo(b.dateTime)); // earliest to latest

  final Map<String, List<TransactionEntry>> monthlyMap = {};

  for (var txn in sortedTxns) {
    final key = '${txn.dateTime.year}-${txn.dateTime.month}';
    monthlyMap.putIfAbsent(key, () => []).add(txn);
  }

  final List<MonthGroup> monthGroups = [];

  for (var entry in monthlyMap.entries) {
    final monthTxns = entry.value;
    final firstTxn = monthTxns.first;
    final year = firstTxn.dateTime.year;
    final month = firstTxn.dateTime.month;

    double monthIncome = 0;
    double monthExpense = 0;

    final Map<String, List<TransactionEntry>> dailyMap = {};

    for (var txn in monthTxns) {
      if (txn.type == TransactionType.income) {
        monthIncome += txn.amount;
      } else {
        monthExpense += txn.amount;
      }

      final dayKey = '${txn.dateTime.year}-${txn.dateTime.month}-${txn.dateTime.day}';
      dailyMap.putIfAbsent(dayKey, () => []).add(txn);
    }

    final monthSummary = MonthSummaryHeader(
      year: year,
      month: month,
      income: monthIncome,
      expense: monthExpense,
    );

    final List<DayGroup> dayGroups = [];

    for (var dailyEntry in dailyMap.entries) {
      final dayTxns = dailyEntry.value;
      final date = dayTxns.first.dateTime;

      double dayIncome = 0;
      double dayExpense = 0;

      for (var txn in dayTxns) {
        if (txn.type == TransactionType.income) {
          dayIncome += txn.amount;
        } else {
          dayExpense += txn.amount;
        }
      }

      final daySummary = DaySummary(
        date: date,
        income: dayIncome,
        expense: dayExpense,
      );

      dayGroups.add(DayGroup(daySummary: daySummary, transactions: dayTxns));
    }

    dayGroups.sort((a, b) => a.daySummary.date.compareTo(b.daySummary.date));

    monthGroups.add(MonthGroup(monthSummary: monthSummary, days: dayGroups));
  }

  monthGroups.sort((a, b) => a.monthSummary.year != b.monthSummary.year
      ? a.monthSummary.year.compareTo(b.monthSummary.year)
      : a.monthSummary.month.compareTo(b.monthSummary.month));

  return monthGroups;
}
