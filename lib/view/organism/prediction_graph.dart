/// Dart imports
import 'dart:math';
import 'dart:ui' as ui;

/// Package imports
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:kakeibo/view_model/category_sum_getter.dart';
import 'package:kakeibo/view_model/provider/active_datetime.dart';
import 'package:kakeibo/view_model/reference_day_impl.dart';
import 'package:google_fonts/google_fonts.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import 'package:kakeibo/constant/colors.dart';

import 'package:kakeibo/util/util.dart';

import 'package:kakeibo/view_model/provider/update_DB_count.dart';

import 'package:kakeibo/model/db_read_impl.dart';

class PredictionGraph extends ConsumerStatefulWidget {
  const PredictionGraph({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PredictionGraphState();
}

class _PredictionGraphState extends ConsumerState<PredictionGraph> {
  // チャートデータ
  List<ChartData> chartDataList = <ChartData>[];

  // 予測データ
  List<ChartData> predictionData = <ChartData>[];

  // 収入データ
  List<ChartData> incomeData = <ChartData>[];

  // 予算データ
  List<ChartData> budgetData = <ChartData>[];

  // 表示開始日
  late DateTime fromDate;

  // 次の月の表示開始日
  late DateTime toDate;

  // 現在の支出額の合計
  late int latestCumulativePrice;

  // 予測支出額合計
  late int finalPredictionPrice;

  // 月の給与
  late int income;

  // グラフ内の最高額
  late double graphHeight;

  // 目標設定額
  late Future<List<Map<String, dynamic>>> allBudgetSum;

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(activeDatetimeNotifierProvider);

    final activeDt = DateTime.now();

    final Future<List<Map<String, dynamic>>> cumulativePriceByDateFuture =
        cumulativePriceByDateRowsGetter(activeDt);

    final Future<List<Map<String, dynamic>>> incomeFuture =
        incomeGetter(activeDt);

    // 目標設定額
    final Future<List<Map<String, dynamic>>> allBudgetSum =
        AllBudgetGetter().build(provider);

    return FutureBuilder(
        future: Future.wait(
            [cumulativePriceByDateFuture, incomeFuture, allBudgetSum]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final int allBudgetSum = snapshot.data![2][0]['budget_sum'] as int;

            // チャートデータの作成
            final cumulativePriceDataList = snapshot.data![0];
            for (int i = 0; i < cumulativePriceDataList.length; i++) {
              // DateTime型に変換
              final datetime =
                  DateTime.parse(cumulativePriceDataList[i]['date'].toString());
              final buff = ChartData(
                  x: datetime,
                  y: cumulativePriceDataList[i]['sum_price_daily']);
              // 配列chartDataListに追加
              chartDataList.add(buff);
            }

            // 予測ラインデータの作成
            final lastValue = cumulativePriceDataList.last;
            if (lastValue.isNotEmpty) {
              latestCumulativePrice = latestCumulativePriceGetter(lastValue);
              setPredictionData(lastValue);
            }

            // 収入合計の設定
            if (snapshot.data![1][0].isNotEmpty) {
              income = snapshot.data![1][0]['sum_price'];
            } else {
              income = 0;
            }

            // 説明ラベルとラインデータの作成
            setTargetData(allBudgetSum);

            setGraphHeight(allBudgetSum);

            return Padding(
                padding: const EdgeInsets.only(
                  right: 16,
                  left: 16,
                  top: 0,
                  bottom: 8,
                ),
                child: Container(
                  height: 213,
                  width: 714,
                  decoration: BoxDecoration(
                      color: MyColors.quarternarySystemfill,
                      borderRadius: BorderRadius.circular(8)),
                  child: _buildCustomizedLineChart(allBudgetSum),
                ));
          } else {
            return Container();
          }
        });
  }

  /// Returns the customized Line chart.
  SfCartesianChart _buildCustomizedLineChart(int allBudgetSum) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      borderWidth: 10,
      // margin: EdgeInsets.all(10),

      // 横軸
      primaryXAxis: DateTimeAxis(
        // 間隔
        intervalType: DateTimeIntervalType.days,
        interval: 7,
        // 最大最小
        minimum: fromDate,
        maximum: toDate.add(const Duration(days: 1) * -1),
        // 軸の設定
        axisLine: const AxisLine(color: MyColors.systemGray, width: 1.0),
        // ラベル設定
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        dateFormat: DateFormat.Md(),
        labelStyle: const TextStyle(
          fontSize: 14,
          color: MyColors.secondaryLabel,
          fontFamily: 'sf_ui',
        ),
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(width: 0),
      ),

      // 縦軸
      primaryYAxis: NumericAxis(
        isVisible: false,
        // 最大最小
        minimum: 0,
        maximum: graphHeight * 1.2,
        // 表示しないために以下記述
        axisLine: const AxisLine(width: 0),
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(width: 0),
      ),

      // グラフ内描画
      series: <CartesianSeries<ChartData, DateTime>>[
        // トレンドライン
        LineSeries<ChartData, DateTime>(
          // 線のスタイルはonCreateRenderで記述
          color: Colors.transparent,
          width: 0,
          // dashArray: const [1, 1.5],
          onCreateRenderer: (ChartSeries<dynamic, dynamic> series) {
            return _CustomTrendLineSeriesRenderer(finalPredictionPrice,
                series as LineSeries<ChartData, DateTime>);
          },
          // アニメーションの設定
          animationDuration: 500,
          dataSource: predictionData,
          xValueMapper: (ChartData sales, _) => sales.x as DateTime,
          yValueMapper: (ChartData sales, _) => sales.y,
        ),

        // 累積グラフ
        AreaSeries<ChartData, DateTime>(
          // 境界線の設定
          borderWidth: 1.0,
          borderColor: MyColors.pink,
          // グラデーションカラーの設定
          gradient: const LinearGradient(colors: <Color>[
            Colors.transparent,
            Colors.red,
          ], stops: <double>[
            0.0,
            0.999,
          ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
          // アニメーションの設定
          animationDuration: 500,
          dataSource: chartDataList,
          xValueMapper: (ChartData sales, _) => sales.x as DateTime,
          yValueMapper: (ChartData sales, _) => sales.y,
        ),

        // 収入ライン
        LineSeries<ChartData, DateTime>(
          color: MyColors.separater,
          width: 1,
          onCreateRenderer: (ChartSeries<dynamic, dynamic> series) {
            return _CustomIncomeLineSeriesRenderer(income, allBudgetSum,
                series as LineSeries<ChartData, DateTime>);
          },
          // アニメーションの設定
          animationDuration: 0,
          dataSource: incomeData,
          xValueMapper: (ChartData sales, _) => sales.x,
          yValueMapper: (ChartData sales, _) => sales.y,
        ),

        // 予算ライン
        LineSeries<ChartData, DateTime>(
          color: MyColors.separater,
          width: 1,
          onCreateRenderer: (ChartSeries<dynamic, dynamic> series) {
            return _CustomBudgetLineSeriesRenderer(income, allBudgetSum,
                series as LineSeries<ChartData, DateTime>);
          },
          // アニメーションの設定
          animationDuration: 0,
          dataSource: budgetData,
          xValueMapper: (ChartData sales, _) => sales.x,
          yValueMapper: (ChartData sales, _) => sales.y,
        ),
      ],
    );
  }

  // 取得した日毎の支出合計を、その日時点での累積支出合計に変換する処理
  Future<List<Map<String, dynamic>>> cumulativePriceByDateRowsGetter(
      DateTime activeDt) async {
    fromDate = getReferenceDay(activeDt);
    toDate = getNextReferenceDay(fromDate).add(const Duration(days: 1) * -1);

    // {
    //  sum_price_daily:
    //  date:
    // }
    final List<Map<String, dynamic>> DataList =
        await TBL001Impl().queryPriceByDateCrossMonthRows(fromDate, toDate);
    int cumulativeSum = 0;
    for (int i = 0; i < DataList.length; i++) {
      final int sumPriceDaily = DataList[i]['sum_price_daily'];
      cumulativeSum += sumPriceDaily;
      DataList[i]['sum_price_daily'] = cumulativeSum;
    }
    return DataList;
  }

  // 予測データの作成処理
  void setPredictionData(Map<String, dynamic> lastValue) {
    // 最新日
    final lastValueDt = DateTime.parse(lastValue['date'].toString());

    final startPoint =
        ChartData(x: lastValueDt, y: lastValue['sum_price_daily']);
    predictionData.add(startPoint);

    // 月の開始から最新レコードまでの日数
    final elapsed_days = lastValueDt.difference(fromDate).inDays + 1;

    // 月の開始からその月の終了までの日数
    final daysInMonth = toDate.difference(fromDate).inDays + 1;

    // 予測支出額
    finalPredictionPrice =
        ((lastValue['sum_price_daily'] / elapsed_days) * daysInMonth).toInt();

    final endPoint = ChartData(
        x: toDate.add(const Duration(days: 1) * -1), y: finalPredictionPrice);
    predictionData.add(endPoint);
  }

  // 最新の累積支出額を取得
  int latestCumulativePriceGetter(Map<String, dynamic> lastValue) {
    return lastValue['sum_price_daily'];
  }

  // グラフ内で最高の値段がどの値か決める処理
  void setGraphHeight(int allBudgetSum) {
    graphHeight = latestCumulativePrice.toDouble();
    if (graphHeight < finalPredictionPrice) {
      graphHeight = finalPredictionPrice.toDouble();
    }
    if (graphHeight < allBudgetSum) {
      graphHeight = allBudgetSum.toDouble();
    }
    if (graphHeight < income) {
      graphHeight = income.toDouble();
    }
  }

  // 目標データの設定
  void setTargetData(int allBudgetSum) {
    incomeData.add(ChartData(x: fromDate, y: income));
    incomeData
        .add(ChartData(x: toDate.add(const Duration(days: 1) * -1), y: income));
    budgetData.add(ChartData(x: fromDate, y: allBudgetSum));
    budgetData.add(ChartData(
        x: toDate.add(const Duration(days: 1) * -1), y: allBudgetSum));
  }

  Future<List<Map<String, dynamic>>> incomeGetter(DateTime activeDt) {
    fromDate = getReferenceDay(activeDt);
    toDate = getNextReferenceDay(fromDate).add(const Duration(days: 1) * -1);
    return getMonthIncomeSum(fromDate, toDate);
  }
}

late double? _textIncomeXOffset, _textIncomeYOffset;
late double? _textBudgetXOffset, _textBudgetYOffset;

// 収入ラベルの描写
/// custom  series class overriding the original  series class.
class _CustomIncomeLineSeriesRenderer<T, D> extends LineSeriesRenderer<T, D> {
  _CustomIncomeLineSeriesRenderer(this.income, this.budget, this.series);

  final int income;
  final int budget;
  final LineSeries<dynamic, dynamic> series;

  @override
  LineSegment<T, D> createSegment() {
    return _IncomeLineCustomPainter(income, budget);
  }
}

/// custom  painter class for customized  series.
class _IncomeLineCustomPainter<T, D> extends LineSegment<T, D> {
  _IncomeLineCustomPainter(this.income, this.budget);

  final int income;
  final int budget;

  @override
  void onPaint(Canvas canvas) {
    if (isEmpty) {
      return;
    }

    final double x1 = points[0].dx,
        y1 = points[0].dy,
        x2 = points[1].dx,
        y2 = points[1].dy;

    // 線の形状を決める
    final Path path = Path();
    path.moveTo(x1, y1);
    path.lineTo(x2, y2);
    canvas.drawPath(path, getStrokePaint());

    // ラベルの作成
    final String priceLabel = yenFormattedPriceGetter(income);
    final String label = '給与 $priceLabel';

    // グラフ内のテキストの表示設定
    if (income <= budget) {
      _textIncomeXOffset = x1 + 5;
      _textIncomeYOffset = y1 - 7;
    }
    if (income >= budget) {
      _textIncomeXOffset = x1 + 5;
      _textIncomeYOffset = y1 - 25;
    }

    TextSpan span = TextSpan(
      style: const TextStyle(
        fontSize: 14,
        color: MyColors.secondaryLabel,
        fontFamily: 'sf_ui',
      ),
      text: label,
    );
    final TextPainter tp =
        TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(_textIncomeXOffset!, _textIncomeYOffset!));
  }
}

// 目標ラベルの描写
/// custom  series class overriding the original  series class.
class _CustomBudgetLineSeriesRenderer<T, D> extends LineSeriesRenderer<T, D> {
  _CustomBudgetLineSeriesRenderer(this.income, this.budget, this.series);

  final int income;
  final int budget;
  final LineSeries<dynamic, dynamic> series;

  @override
  LineSegment<T, D> createSegment() {
    return _BudgetLineCustomPainter(income, budget);
  }
}

/// custom  painter class for customized  series.
class _BudgetLineCustomPainter<T, D> extends LineSegment<T, D> {
  _BudgetLineCustomPainter(this.income, this.budget);

  final int income;
  final int budget;

  @override
  void onPaint(Canvas canvas) {
    if (isEmpty) {
      return;
    }

    final double x1 = points[0].dx,
        y1 = points[0].dy,
        x2 = points[1].dx,
        y2 = points[1].dy;

    // 線の形状を決める
    final Path path = Path();
    path.moveTo(x1, y1);
    path.lineTo(x2, y2);
    canvas.drawPath(path, getStrokePaint());

    // ラベルの作成
    final String priceLabel = yenFormattedPriceGetter(budget);
    final String label = '予算 $priceLabel';

    // グラフ内のテキストの表示設定
    if (income <= budget) {
      _textBudgetXOffset = x1 + 5;
      _textBudgetYOffset = y1 - 30;
    }
    if (income >= budget) {
      _textBudgetXOffset = x1 + 5;
      _textBudgetYOffset = y1 - 0;
    }

    TextSpan span = TextSpan(
      text: label,
      style: const TextStyle(
        fontSize: 14,
        color: MyColors.secondaryLabel,
        fontFamily: 'sf_ui',
      ),
    );
    final TextPainter tp =
        TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(_textBudgetXOffset!, _textBudgetYOffset!));
  }
}

// 予想支出ラベルの描写
/// custom  series class overriding the original  series class.
class _CustomTrendLineSeriesRenderer<T, D> extends LineSeriesRenderer<T, D> {
  _CustomTrendLineSeriesRenderer(this.finalPredictionPrice, this.series);
  final int finalPredictionPrice;
  final LineSeries<dynamic, dynamic> series;

  @override
  LineSegment<T, D> createSegment() {
    return _TrendLineCustomPainter(finalPredictionPrice);
  }
}

/// custom  painter class for customized  series.
class _TrendLineCustomPainter<T, D> extends LineSegment<T, D> {
  _TrendLineCustomPainter(this.finalPredictionPrice);

  final int finalPredictionPrice;

  @override
  void onPaint(Canvas canvas) {
    if (isEmpty) {
      return;
    }

    final double x1 = points[0].dx,
        y1 = points[0].dy,
        x2 = points[1].dx,
        y2 = points[1].dy;

    // 線の形状を決める
    final Path path = Path();
    path.moveTo(x1, y1);
    path.lineTo(x2, y2);
    canvas.drawPath(path, getStrokePaint());

    final Paint paint = Paint()
      ..color = MyColors.pink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // ラベルの作成
    final String priceLabel = yenFormattedPriceGetter(finalPredictionPrice);
    final String label = '予想支出 $priceLabel';

    // グラフ内のテキストの表示設定
    _textBudgetXOffset = x2 - 130;
    _textBudgetYOffset = y2 - 18;

    canvas.drawPath(
        _dashPath(
          path,
          dashArray: _CircularIntervalList<double>(<double>[3, 2]),
        )!,
        paint);

    TextSpan span = TextSpan(
        text: label,
        style: const TextStyle(
          fontSize: 14,
          color: MyColors.secondaryLabel,
          fontFamily: 'sf_ui',
        ));
    final TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, Offset(_textBudgetXOffset!, _textBudgetYOffset!));
  }
}

Path? _dashPath(
  Path source, {
  required _CircularIntervalList<double> dashArray,
}) {
  if (source == null) {
    return null;
  }
  const double intialValue = 0.0;
  final Path path = Path();
  for (final measurePath in source.computeMetrics()) {
    double distance = intialValue;
    bool draw = true;
    while (distance < measurePath.length) {
      final double length = dashArray.next;
      if (draw) {
        path.addPath(
            measurePath.extractPath(distance, distance + length), Offset.zero);
      }
      distance += length;
      draw = !draw;
    }
  }
  return path;
}

class _CircularIntervalList<T> {
  _CircularIntervalList(this._values);
  final List<T> _values;
  int _index = 0;
  T get next {
    if (_index >= _values.length) {
      _index = 0;
    }
    return _values[_index++];
  }
}

class ChartData {
  /// Holds the datapoint values like x, y, etc.,
  ChartData(
      {this.x,
      this.y,
      this.lineType,
      this.xValue,
      this.yValue,
      this.secondSeriesYValue,
      this.thirdSeriesYValue,
      this.pointColor,
      this.size,
      this.text,
      this.open,
      this.close,
      this.low,
      this.high,
      this.volume});

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num? y;

  final List<double>? lineType;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num? yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num? thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color? pointColor;

  /// Holds size of the datapoint
  final num? size;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;

  /// Holds open value of the datapoint
  final num? open;

  /// Holds close value of the datapoint
  final num? close;

  /// Holds low value of the datapoint
  final num? low;

  /// Holds high value of the datapoint
  final num? high;

  /// Holds open value of the datapoint
  final num? volume;
}
