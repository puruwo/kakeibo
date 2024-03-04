import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kakeibo/constant/colors.dart';

class LineChartSample extends StatefulWidget {
  const LineChartSample({super.key});

  @override
  State<LineChartSample> createState() => _LineChartSampleState();
}

class _LineChartSampleState extends State<LineChartSample> {
  List<Color> gradientColors = [
    MyColors.red,
    MyColors.blue,
  ];

  ScrollController? _scrollController;

  @override
  void initState() {
    // スクロール位置の初期設定
    _scrollController = ScrollController(initialScrollOffset: 600);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            right: 16,
            left: 16,
            top: 16,
            bottom: 16,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            child: Container(
              height: 213,
              width: 714,
              child: LineChart(
                mainData(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('1月', style: style);
        break;
      case 2:
        text = const Text('2月', style: style);
        break;
      case 3:
        text = const Text('3月', style: style);
        break;
      case 4:
        text = const Text('4月', style: style);
        break;
      case 5:
        text = const Text('5月', style: style);
        break;
      case 6:
        text = const Text('6月', style: style);
        break;
      case 7:
        text = const Text('7月', style: style);
        break;
      case 8:
        text = const Text('8月', style: style);
        break;
      case 9:
        text = const Text('9月', style: style);
        break;
      case 10:
        text = const Text('10月', style: style);
        break;
      case 11:
        text = const Text('11月', style: style);
        break;
      case 12:
        text = const Text('12月', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 12,
    );
    String text;
    switch (value.toInt()) {
      case 10:
        text = '10万';
        break;
      case 20:
        text = '20万';
        break;
      case 30:
        text = '30万';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 10,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: MyColors.dimGray,
            strokeWidth: 0.01,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: MyColors.dimGray,
            strokeWidth: 0.5,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: MyColors.black),
      ),
      minX: 0,
      maxX: 12,
      minY: 0,
      maxY: 30,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 19.5),
            FlSpot(1, 20.2),
            FlSpot(2, 17.0),
            FlSpot(3, 21.3),
            FlSpot(4, 23.8),
            FlSpot(5, 30.6),
            FlSpot(6, 21.0),
            FlSpot(7, 19.5),
            FlSpot(8, 20.2),
            FlSpot(9, 17.0),
            FlSpot(10, 21.3),
            FlSpot(11, 23.8),
            FlSpot(12, 30.6),
          ],
          isCurved: false,
          preventCurveOverShooting: true,
          preventCurveOvershootingThreshold: 1,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
        LineChartBarData(
          spots: const [
            FlSpot(0, 20.2),
            FlSpot(1, 17.0),
            FlSpot(2, 21.3),
            FlSpot(3, 23.8),
            FlSpot(4, 30.6),
            FlSpot(5, 21.0),
            FlSpot(6, 19.5),
            FlSpot(7, 20.2),
            FlSpot(8, 17.0),
            FlSpot(9, 21.3),
            FlSpot(10, 23.8),
            FlSpot(11, 30.6),
            FlSpot(12, 19.5),
          ],
          isCurved: false,
          preventCurveOverShooting: true,
          preventCurveOvershootingThreshold: 1,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
