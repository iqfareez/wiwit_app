import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

final _amountFormat = NumberFormat('#,##0.00', 'en_US');
final _dateFormat = DateFormat('dd/MM/yyyy', 'en_US');
final _longDateFormat = DateFormat('EEE, d MMM yyyy', 'en_US');

/// Formats whole cents the way the amount field shows them, e.g. `1,234.50`.
String formatAmount(int cents) => _amountFormat.format(cents / 100);

/// Reads an amount the API sent us, e.g. `3.5`, as whole cents.
int parseAmountInCents(String amount) {
  final value = double.tryParse(amount) ?? 0;

  return (value * 100).round();
}

/// Format date to dd/MM/yyyy
String formatDate(DateTime date) => _dateFormat.format(date);

/// The full date the way the detail sheet spells it out, e.g. `Wed, 29 Jul
/// 2026`.
String formatLongDate(DateTime date) => _longDateFormat.format(date);

/// Format relative day
String formatRelativeDate(DateTime date) {
  final today = DateUtils.dateOnly(DateTime.now());
  final day = DateUtils.dateOnly(date);

  if (day == today) return 'Today';
  if (day == today.subtract(const Duration(days: 1))) return 'Yesterday';

  return formatDate(day);
}
