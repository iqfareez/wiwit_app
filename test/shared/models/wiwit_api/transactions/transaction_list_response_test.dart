import 'package:flutter_test/flutter_test.dart';
import 'package:wiwit_app/shared/models/wiwit_api/enums.dart';
import 'package:wiwit_app/shared/models/wiwit_api/transactions/transaction_list_response.dart';

void main() {
  test('parses transactions, nested categories, and pagination metadata', () {
    final response = TransactionListResponse.fromJson({
      'data': [
        {
          'id': 1,
          'title': 'Coffee',
          'type': 'expense',
          'amount': '113.24',
          'category': {'id': 1, 'name': 'enim', 'is_active': true},
          'notes': null,
          'transaction_date': '2026-07-12',
          'created_at': '2026-07-20T14:36:14.000000Z',
          'updated_at': '2026-07-20T14:36:14.000000Z',
          'links': {},
        },
      ],
      'meta': {'page': 1, 'per_page': 20, 'total': 1, 'last_page': 1},
      'links': {},
    });

    final transaction = response.data.single;
    expect(transaction.type, TransactionType.expense);
    expect(transaction.amount, '113.24');
    expect(transaction.category?.name, 'enim');
    expect(response.meta.lastPage, 1);
  });
}
