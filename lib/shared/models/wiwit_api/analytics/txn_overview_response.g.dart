// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'txn_overview_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TxnOverviewResponse _$TxnOverviewResponseFromJson(Map<String, dynamic> json) =>
    TxnOverviewResponse(
      period: Period.fromJson(json['period'] as Map<String, dynamic>),
      month: json['month'] as String,
      summary: TxnSummary.fromJson(json['summary'] as Map<String, dynamic>),
      series: TxnSeries.fromJson(json['series'] as Map<String, dynamic>),
      categories: TxnCategories.fromJson(
        json['categories'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$TxnOverviewResponseToJson(
  TxnOverviewResponse instance,
) => <String, dynamic>{
  'period': instance.period,
  'month': instance.month,
  'summary': instance.summary,
  'series': instance.series,
  'categories': instance.categories,
};

TxnSummary _$TxnSummaryFromJson(Map<String, dynamic> json) => TxnSummary(
  period: Period.fromJson(json['period'] as Map<String, dynamic>),
  income: (json['income'] as num).toDouble(),
  expense: (json['expense'] as num).toDouble(),
  net: (json['net'] as num).toDouble(),
  transactionCount: (json['transaction_count'] as num).toInt(),
  openingBalance: (json['opening_balance'] as num).toDouble(),
  closingBalance: (json['closing_balance'] as num).toDouble(),
  dailyAverageExpense: (json['daily_average_expense'] as num).toDouble(),
);

Map<String, dynamic> _$TxnSummaryToJson(TxnSummary instance) =>
    <String, dynamic>{
      'period': instance.period,
      'income': instance.income,
      'expense': instance.expense,
      'net': instance.net,
      'transaction_count': instance.transactionCount,
      'opening_balance': instance.openingBalance,
      'closing_balance': instance.closingBalance,
      'daily_average_expense': instance.dailyAverageExpense,
    };

TxnSeries _$TxnSeriesFromJson(Map<String, dynamic> json) => TxnSeries(
  period: Period.fromJson(json['period'] as Map<String, dynamic>),
  interval: json['interval'] as String,
  meta: SeriesMeta.fromJson(json['meta'] as Map<String, dynamic>),
  data: (json['data'] as List<dynamic>)
      .map((e) => TxnSeriesPoint.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TxnSeriesToJson(TxnSeries instance) => <String, dynamic>{
  'period': instance.period,
  'interval': instance.interval,
  'meta': instance.meta,
  'data': instance.data,
};

SeriesMeta _$SeriesMetaFromJson(Map<String, dynamic> json) =>
    SeriesMeta(openingBalance: (json['opening_balance'] as num).toDouble());

Map<String, dynamic> _$SeriesMetaToJson(SeriesMeta instance) =>
    <String, dynamic>{'opening_balance': instance.openingBalance};

TxnSeriesPoint _$TxnSeriesPointFromJson(Map<String, dynamic> json) =>
    TxnSeriesPoint(
      period: json['period'] as String,
      periodStart: DateTime.parse(json['period_start'] as String),
      periodEnd: DateTime.parse(json['period_end'] as String),
      income: (json['income'] as num).toDouble(),
      expense: (json['expense'] as num).toDouble(),
      net: (json['net'] as num).toDouble(),
    );

Map<String, dynamic> _$TxnSeriesPointToJson(TxnSeriesPoint instance) =>
    <String, dynamic>{
      'period': instance.period,
      'period_start': instance.periodStart.toIso8601String(),
      'period_end': instance.periodEnd.toIso8601String(),
      'income': instance.income,
      'expense': instance.expense,
      'net': instance.net,
    };

TxnCategories _$TxnCategoriesFromJson(Map<String, dynamic> json) =>
    TxnCategories(
      period: Period.fromJson(json['period'] as Map<String, dynamic>),
      type: json['type'] as String,
      meta: CategoriesMeta.fromJson(json['meta'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>)
          .map((e) => TxnCategoryPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TxnCategoriesToJson(TxnCategories instance) =>
    <String, dynamic>{
      'period': instance.period,
      'type': instance.type,
      'meta': instance.meta,
      'data': instance.data,
    };

CategoriesMeta _$CategoriesMetaFromJson(Map<String, dynamic> json) =>
    CategoriesMeta(
      total: (json['total'] as num).toDouble(),
      categoryCount: (json['category_count'] as num).toInt(),
    );

Map<String, dynamic> _$CategoriesMetaToJson(CategoriesMeta instance) =>
    <String, dynamic>{
      'total': instance.total,
      'category_count': instance.categoryCount,
    };

TxnCategoryPoint _$TxnCategoryPointFromJson(Map<String, dynamic> json) =>
    TxnCategoryPoint(
      categoryId: (json['category_id'] as num?)?.toInt(),
      categoryName: json['category_name'] as String,
      total: (json['total'] as num).toDouble(),
      share: (json['share'] as num).toDouble(),
    );

Map<String, dynamic> _$TxnCategoryPointToJson(TxnCategoryPoint instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'total': instance.total,
      'share': instance.share,
    };

Period _$PeriodFromJson(Map<String, dynamic> json) => Period(
  from: DateTime.parse(json['from'] as String),
  to: DateTime.parse(json['to'] as String),
);

Map<String, dynamic> _$PeriodToJson(Period instance) => <String, dynamic>{
  'from': instance.from.toIso8601String(),
  'to': instance.to.toIso8601String(),
};
