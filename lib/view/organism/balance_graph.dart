import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class LineChartSample extends StatelessWidget {
  // 12ヶ月分のデータ
  final List<FlSpot> data1 = [
    FlSpot(0, 100),
    FlSpot(1, 120),
    FlSpot(2, 140),
    FlSpot(3, 160),
    FlSpot(4, 180),
    FlSpot(5, 200),
    FlSpot(6, 220),
    FlSpot(7, 240),
    FlSpot(8, 260),
    FlSpot(9, 280),
    FlSpot(10, 300),
    FlSpot(11, 320),
  ];

  final List<FlSpot> data2 = [
    FlSpot(0, 150),
    FlSpot(1, 170),
    FlSpot(2, 190),
    FlSpot(3, 210),
    FlSpot(4, 230),
    FlSpot(5, 250),
    FlSpot(6, 270),
    FlSpot(7, 290),
    FlSpot(8, 310),
    FlSpot(9, 330),
    FlSpot(10, 350),
    FlSpot(11, 370),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 300,
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: data1,
                isCurved: true,
                color: Colors.blue,
                barWidth: 2,
              ),
              LineChartBarData(
                spots: data2,
                isCurved: true,
                color: Colors.red,
                barWidth: 2,
              ),
            ],
            // titlesData: FlTitlesData(
            //   bottomTitles: SideTitles(showTitles: true),
            //   leftTitles: SideTitles(showTitles: true),
            // ),
            borderData: FlBorderData(show: true),
            gridData: FlGridData(show: true),
          ),
        ),
      ),
    );
  }
}
