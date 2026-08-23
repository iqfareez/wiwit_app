import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../shared/models/wiwit_api/analytics/txn_overview_response.dart';

class OverviewCategoriesChart extends StatefulWidget {
  const OverviewCategoriesChart({
    required this.categories,
    required this.centerLabel,
    super.key,
  });

  final TxnCategories? categories;
  final String centerLabel;

  @override
  State<OverviewCategoriesChart> createState() =>
      _OverviewCategoriesChartState();
}

class _OverviewCategoriesChartState extends State<OverviewCategoriesChart> {
  static const _maxCategories = 5;
  static const _chartHeight = 110.0;
  static const _sectionSpace = 1.8;
  static const _centerSpaceRadius = 40.0;
  static const _defaultSectionRadius = 15.0;
  static const _touchedSectionRadius = 16.0;
  static const _legendDotSize = 8.0;
  static const _legendVerticalPadding = 1.0;

  static const _chartColors = [
    Color(0xFFF04438),
    Color(0xFFE98A55),
    Color(0xFFB9E77D),
    Color(0xFFD6D8CF),
    Color(0xFF6C9BCF),
  ];

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final categories = _getTopCategories();

    if (categories.isEmpty) {
      return const SizedBox(
        height: _chartHeight,
        child: Center(child: Text('No category data yet.')),
      );
    }

    return SizedBox(
      height: _chartHeight,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse?.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }

                          touchedIndex = pieTouchResponse!
                              .touchedSection!
                              .touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: _sectionSpace,
                    centerSpaceRadius: _centerSpaceRadius,
                    sections: _buildSections(categories),
                  ),
                ),
                IgnorePointer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.centerLabel,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        'spent',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(flex: 7, child: _buildLegend(categories)),
        ],
      ),
    );
  }

  List<TxnCategoryPoint> _getTopCategories() =>
      [...?widget.categories?.data].take(_maxCategories).toList();

  List<PieChartSectionData> _buildSections(List<TxnCategoryPoint> categories) {
    return [
      for (var index = 0; index < categories.length; index++)
        PieChartSectionData(
          color: _chartColors[index % _chartColors.length],
          value: categories[index].total,
          title: '',
          radius: index == touchedIndex
              ? _touchedSectionRadius
              : _defaultSectionRadius,
        ),
    ];
  }

  Widget _buildLegend(List<TxnCategoryPoint> categories) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < categories.length; index++)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: _legendVerticalPadding,
            ),
            child: Row(
              children: [
                Container(
                  width: _legendDotSize,
                  height: _legendDotSize,
                  decoration: BoxDecoration(
                    color: _chartColors[index % _chartColors.length],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    categories[index].categoryName,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatShare(categories[index].share),
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
      ],
    );
  }

  // Format the percentage text
  String _formatShare(double share) {
    final percentage = share * 100;
    return '${percentage.round()}%';
  }
}
