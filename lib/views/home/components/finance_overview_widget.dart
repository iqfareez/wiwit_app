import 'package:animated_digit/animated_digit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart' as intl;
import 'package:material_ui/material_ui.dart';

import '../../../shared/models/wiwit_api/analytics/txn_overview_response.dart';
import '../../../shared/providers/overview_provider.dart';
import '../../../shared/utils/format_utils.dart';
import '../../../shared/utils/screen_breakpoints.dart';
import 'overview_categories_chart.dart';

class FinanceOverviewWidget extends ConsumerWidget {
  const FinanceOverviewWidget({super.key});

  /// constant height for the widget
  static const _placeholderHeight = 110.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = formatMonthKey(DateTime.now());
    final overviewAsync = ref.watch(txnOverviewProvider(month: month));

    final overview = overviewAsync.value;

    if (overview == null) {
      return _buildCard(
        context,
        child: SizedBox(
          height: _placeholderHeight,
          child: Center(
            child: overviewAsync.hasError
                ? TextButton.icon(
                    onPressed: () =>
                        ref.invalidate(txnOverviewProvider(month: month)),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try again'),
                  )
                : const CircularProgressIndicator(),
          ),
        ),
      );
    }

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
  }

  Widget _buildNetSummary(BuildContext context, TxnOverviewResponse overview) {
    final netInCents = parseAmountInCents(overview.summary.net.toString());

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
        Align(
          alignment: Alignment.centerLeft,
          child: AnimatedDigitWidget(
            value: netInCents / 100,
            prefix: 'RM ',
            fractionDigits: 2,
            enableSeparator: true,
            textStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
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
