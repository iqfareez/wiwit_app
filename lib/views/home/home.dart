import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../shared/services/apis/transaction_service.dart';
import '../../shared/services/networking/chopper_instance.dart';
import 'components/home_header.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final Future<Response> _transactions;

  @override
  void initState() {
    super.initState();
    _transactions = ChopperInstance.client!
        .getService<TransactionService>()
        .getTransactions(perPage: 20);
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
                FutureBuilder<Response>(
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

                    final body = snapshot.data!.body as Map<String, dynamic>;
                    final transactions = body['data'] as List<dynamic>? ?? [];
                    if (transactions.isEmpty) {
                      return const Text('No transactions yet.');
                    }

                    return ListView.builder(
                      itemCount: transactions.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final transaction =
                            transactions[index] as Map<String, dynamic>;
                        final category =
                            transaction['category'] as Map<String, dynamic>?;
                        final isIncome = transaction['type'] == 'income';
                        final amount = transaction['amount'];

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: ListTile(
                            title: Text(
                              transaction['title'] as String? ?? 'Untitled',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              category?['name'] as String? ?? 'Uncategorized',
                              style: TextStyle(fontSize: 12),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${isIncome ? '+' : '-'}RM$amount',
                                  style: TextStyle(
                                    color: isIncome ? Colors.green : Colors.red,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  transaction['transaction_date'] as String? ??
                                      '',
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
        onPressed: () {},
        tooltip: 'Add Transaction',
        child: const Icon(Icons.add),
      ),
    );
  }
}
