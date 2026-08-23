import 'package:json_annotation/json_annotation.dart';

part 'txn_overview_response.g.dart';

@JsonSerializable()
class TxnOverviewResponse {
  final Period period;
  final String month;
  final TxnSummary summary;
  final TxnSeries series;
  final TxnCategories categories;

  TxnOverviewResponse({
    required this.period,
    required this.month,
    required this.summary,
    required this.series,
    required this.categories,
  });

  factory TxnOverviewResponse.fromJson(Map<String, dynamic> json) =>
      _$TxnOverviewResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TxnOverviewResponseToJson(this);

  @override
  String toString() {
    return 'TxnOverviewResponse('
        'period: $period, '
        'month: $month, '
        'summary: $summary, '
        'series: $series, '
        'categories: $categories'
        ')';
  }
}

@JsonSerializable()
class TxnSummary {
  final Period period;
  final double income;
  final double expense;
  final double net;
  @JsonKey(name: 'transaction_count')
  final int transactionCount;
  @JsonKey(name: 'opening_balance')
  final double openingBalance;
  @JsonKey(name: 'closing_balance')
  final double closingBalance;
  @JsonKey(name: 'daily_average_expense')
  final double dailyAverageExpense;

  TxnSummary({
    required this.period,
    required this.income,
    required this.expense,
    required this.net,
    required this.transactionCount,
    required this.openingBalance,
    required this.closingBalance,
    required this.dailyAverageExpense,
  });

  factory TxnSummary.fromJson(Map<String, dynamic> json) =>
      _$TxnSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$TxnSummaryToJson(this);
}

@JsonSerializable()
class TxnSeries {
  final Period period;
  final String interval;
  final SeriesMeta meta;
  final List<TxnSeriesPoint> data;

  TxnSeries({
    required this.period,
    required this.interval,
    required this.meta,
    required this.data,
  });

  factory TxnSeries.fromJson(Map<String, dynamic> json) =>
      _$TxnSeriesFromJson(json);
  Map<String, dynamic> toJson() => _$TxnSeriesToJson(this);
}

@JsonSerializable()
class SeriesMeta {
  @JsonKey(name: 'opening_balance')
  final double openingBalance;

  SeriesMeta({required this.openingBalance});

  factory SeriesMeta.fromJson(Map<String, dynamic> json) =>
      _$SeriesMetaFromJson(json);
  Map<String, dynamic> toJson() => _$SeriesMetaToJson(this);
}

@JsonSerializable()
class TxnSeriesPoint {
  final String period;
  @JsonKey(name: 'period_start')
  final DateTime periodStart;
  @JsonKey(name: 'period_end')
  final DateTime periodEnd;
  final double income;
  final double expense;
  final double net;

  TxnSeriesPoint({
    required this.period,
    required this.periodStart,
    required this.periodEnd,
    required this.income,
    required this.expense,
    required this.net,
  });

  factory TxnSeriesPoint.fromJson(Map<String, dynamic> json) =>
      _$TxnSeriesPointFromJson(json);
  Map<String, dynamic> toJson() => _$TxnSeriesPointToJson(this);
}

@JsonSerializable()
class TxnCategories {
  final Period period;
  final String type;
  final CategoriesMeta meta;
  final List<TxnCategoryPoint> data;

  TxnCategories({
    required this.period,
    required this.type,
    required this.meta,
    required this.data,
  });

  factory TxnCategories.fromJson(Map<String, dynamic> json) =>
      _$TxnCategoriesFromJson(json);
  Map<String, dynamic> toJson() => _$TxnCategoriesToJson(this);
}

@JsonSerializable()
class CategoriesMeta {
  final double total;
  @JsonKey(name: 'category_count')
  final int categoryCount;

  CategoriesMeta({required this.total, required this.categoryCount});

  factory CategoriesMeta.fromJson(Map<String, dynamic> json) =>
      _$CategoriesMetaFromJson(json);
  Map<String, dynamic> toJson() => _$CategoriesMetaToJson(this);
}

@JsonSerializable()
class TxnCategoryPoint {
  @JsonKey(name: 'category_id')
  final int? categoryId;
  @JsonKey(name: 'category_name')
  final String categoryName;
  final double total;
  final double share;

  TxnCategoryPoint({
    required this.categoryId,
    required this.categoryName,
    required this.total,
    required this.share,
  });

  factory TxnCategoryPoint.fromJson(Map<String, dynamic> json) =>
      _$TxnCategoryPointFromJson(json);
  Map<String, dynamic> toJson() => _$TxnCategoryPointToJson(this);

  @override
  String toString() {
    return 'TxnPoint(categoryName: $categoryName, total: $total, share: $share)';
  }
}

@JsonSerializable()
class Period {
  final DateTime from;
  final DateTime to;

  Period({required this.from, required this.to});

  factory Period.fromJson(Map<String, dynamic> json) => _$PeriodFromJson(json);
  Map<String, dynamic> toJson() => _$PeriodToJson(this);

  @override
  String toString() {
    return 'Period(from: $from, to: $to)';
  }
}
