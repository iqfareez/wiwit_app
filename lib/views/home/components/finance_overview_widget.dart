import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart' as intl;

import '../../../shared/models/wiwit_api/analytics/txn_overview_response.dart';
import '../../../shared/providers/chopper_provider.dart';
import '../../../shared/utils/format_utils.dart';
import '../../../shared/utils/screen_breakpoints.dart';
import 'overview_categories_chart.dart';

class FinanceOverviewWidget extends ConsumerStatefulWidget {
  const FinanceOverviewWidget({super.key});

  @override
  ConsumerState<FinanceOverviewWidget> createState() =>
      _FinanceOverviewWidgetState();
}

class _FinanceOverviewWidgetState extends ConsumerState<FinanceOverviewWidget> {
  late Future<TxnOverviewResponse> _financeOverviewResponseFuture;

  @override
  void initState() {
    super.initState();
    var currentMonth = intl.DateFormat("y-MM").format(DateTime.now());
    _financeOverviewResponseFuture = ref
        .read(analyticsServiceProvider)
        .getOverview(month: currentMonth);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TxnOverviewResponse>(
      future: _financeOverviewResponseFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildCard(
            context,
            child: SizedBox(
              height: 110,
              child: Center(
                child: TextButton.icon(
                  onPressed: () => setState(() {
                    _financeOverviewResponseFuture = ref
                        .read(analyticsServiceProvider)
                        .getOverview(
                          month: intl.DateFormat('y-MM').format(DateTime.now()),
                        );
                  }),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try again'),
                ),
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return _buildCard(
            context,
            child: const SizedBox(
              height: 110,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final overview = snapshot.requireData;
        return _buildCard(
          context,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final netSummary = _buildNetSummary(context, overview);
              final categories = _buildCategories(context, overview);

              if (constraints.maxWidth < ResponsiveBreakpoints.widescreen) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [netSummary, const Gap(14), categories],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: netSummary),
                  const Gap(24),
                  Expanded(child: categories),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildNetSummary(BuildContext context, TxnOverviewResponse overview) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Net in ${intl.DateFormat("MMMM").format(DateTime.now())}'
              .toUpperCase(),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const Gap(2),
        Text(
          'RM ${formatAmount(parseAmountInCents(overview.summary.net.toString()))}',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildCategories(BuildContext context, TxnOverviewResponse overview) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Top categories'.toUpperCase(),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const Gap(8),
        OverviewCategoriesChart(
          categories: overview.categories,
          centerLabel: formatAmount(
            parseAmountInCents(overview.categories.meta.total.toString()),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, {required Widget child}) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
        child: child,
      ),
    );
  }
}
