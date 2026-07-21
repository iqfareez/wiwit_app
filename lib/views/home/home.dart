import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../shared/services/apis/transaction_service.dart';
import '../../shared/models/wiwit_api/enums.dart';
import '../../shared/models/wiwit_api/transactions/transaction_list_response.dart';
import '../../shared/services/networking/chopper_instance.dart';
import 'components/add_transaction_sheet.dart';
import 'components/home_header.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<Response<TransactionListResponse>> _transactions;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() {
    _transactions = ChopperInstance.client!
        .getService<TransactionService>()
        .getTransactions(perPage: 20);
  }

  void _showAddTransactionSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: false,
      builder: (_) =>
          AddTransactionSheet(onSaved: () => setState(_loadTransactions)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const HomeHeader(name: 'Fareez'),
                const Gap(12),
                const Text(
                  'Recent Transactions',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const Gap(12),
                FutureBuilder<Response<TransactionListResponse>>(
                  future: _transactions,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError || !snapshot.data!.isSuccessful) {
                      return Text(
                        snapshot.hasError
                            ? '${snapshot.error}'
                            : 'Could not load transactions (${snapshot.data!.statusCode}).',
                      );
                    }

                    final transactions = snapshot.data!.body?.data ?? [];
                    if (transactions.isEmpty) {
                      return const Text('No transactions yet.');
                    }

                    return ListView.builder(
                      itemCount: transactions.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        final isIncome =
                            transaction.type == TransactionType.income;

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: ListTile(
                            title: Text(
                              transaction.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              transaction.category?.name ?? 'Uncategorized',
                              style: TextStyle(fontSize: 12),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${isIncome ? '+' : '-'}RM${transaction.amount}',
                                  style: TextStyle(
                                    color: isIncome ? Colors.green : Colors.red,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  transaction.transactionDate,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: .normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTransactionSheet,
        tooltip: 'Add Transaction',
        child: const Icon(Icons.add),
      ),
    );
  }
}
