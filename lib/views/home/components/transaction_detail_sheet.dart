import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../shared/models/wiwit_api/enums.dart';
import '../../../shared/models/wiwit_api/transactions/transaction_response.dart';
import '../../../shared/utils/format_utils.dart';
import 'section_label.dart';

/// The read only view of a transaction.
///
/// Pops with `true` when the user asks to edit.
class TransactionDetailSheet extends StatelessWidget {
  const TransactionDetailSheet({super.key, required this.transaction});

  final TransactionResponse transaction;

  /// The same filled pill the form uses for its text fields, minus the input.
  Widget _buildValueBox(BuildContext context, String value) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Text(value, style: const TextStyle(fontSize: 15)),
    );
  }

  Widget _buildFootnote(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final createdAt = transaction.createdAt.toLocal();
    final updatedAt = transaction.updatedAt.toLocal();

    // Every record updates itself on save, so only call it edited once the
    // timestamps have actually drifted apart.
    final wasEdited = updatedAt.difference(createdAt).inMinutes >= 1;

    return Text(
      'Added ${formatDate(createdAt)}'
      '${wasEdited ? '  ·  Edited ${formatDate(updatedAt)}' : ''}',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 12, color: colorScheme.outline),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isIncome = transaction.type == TransactionType.income;
    final notes = transaction.notes?.trim() ?? '';
    final date =
        DateTime.tryParse(transaction.transactionDate) ??
        transaction.createdAt.toLocal();

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const Gap(20),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Transaction',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () => Navigator.pop(context, true),
                    style: FilledButton.styleFrom(
                      backgroundColor: isIncome
                          ? colorScheme.primary
                          : colorScheme.secondary,
                    ),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Edit'),
                  ),
                ],
              ),
              const Gap(16),
              Center(
                child: Chip(
                  avatar: Icon(
                    isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                    size: 18,
                  ),
                  label: Text(isIncome ? 'Income' : 'Expense'),
                ),
              ),
              const Gap(16),
              Text(
                'Amount',
                textAlign: TextAlign.center,
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${isIncome ? '+' : '-'}RM',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(8),
                  Flexible(
                    child: Text(
                      formatAmount(parseAmountInCents(transaction.amount)),
                      style: TextStyle(
                        color: isIncome ? Colors.green : Colors.red,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(20),
              SectionLabel(label: 'Title'),
              _buildValueBox(context, transaction.title),
              const Gap(16),
              SectionLabel(label: 'Category'),
              Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  label: Text(transaction.category?.name ?? 'Uncategorized'),
                ),
              ),
              const Gap(16),
              SectionLabel(label: 'Date'),
              Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  avatar: const Icon(Icons.calendar_today_outlined, size: 18),
                  label: Text(formatRelativeDate(date)),
                ),
              ),
              if (notes.isNotEmpty) ...[
                const Gap(16),
                SectionLabel(label: 'Notes'),
                _buildValueBox(context, notes),
              ],
              const Gap(20),
              _buildFootnote(context),
            ],
          ),
        ),
      ),
    );
  }
}
