import 'package:flutter/material.dart';

/// Formats whole cents the way the amount field shows them, e.g. `1,234.50`.
String formatAmount(int cents) {
  final whole = (cents ~/ 100).toString();
  final fraction = (cents % 100).toString().padLeft(2, '0');
  final grouped = StringBuffer();

  for (var index = 0; index < whole.length; index++) {
    if (index > 0 && (whole.length - index) % 3 == 0) grouped.write(',');

    grouped.write(whole[index]);
  }

  return '$grouped.$fraction';
}

/// Reads an amount the API sent us, e.g. `3.5`, as whole cents.
int parseAmountInCents(String amount) {
  final value = double.tryParse(amount) ?? 0;

  return (value * 100).round();
}

String formatDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

/// Names the day when it is one the user thinks of by name.
String formatRelativeDate(DateTime date) {
  final today = DateUtils.dateOnly(DateTime.now());
  final day = DateUtils.dateOnly(date);

  if (day == today) return 'Today';
  if (day == today.subtract(const Duration(days: 1))) return 'Yesterday';

  return formatDate(day);
}
