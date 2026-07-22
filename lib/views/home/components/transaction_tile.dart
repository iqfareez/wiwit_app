import 'package:flutter/material.dart';

import '../../../shared/models/wiwit_api/enums.dart';
import '../../../shared/models/wiwit_api/transactions/transaction_response.dart';

/// A single transaction row in the recent transactions list.
class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction});

  final TransactionResponse transaction;

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ListTile(
        title: Text(
          transaction.title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          transaction.category?.name ?? 'Uncategorized',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isIncome ? '+' : '-'}RM${transaction.amount}',
              style: TextStyle(
                color: isIncome ? Colors.green : Colors.red,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              transaction.transactionDate,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
