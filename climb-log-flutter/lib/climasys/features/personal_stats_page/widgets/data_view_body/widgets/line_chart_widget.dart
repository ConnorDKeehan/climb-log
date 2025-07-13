import 'package:climasys/climasys/api/models/get_main_data_view_response.dart';
import 'package:climasys/climasys/features/personal_stats_page/models/data_views_enum.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget {
  final DataViewsEnum selectedView;
  final List<GetMainDataViewResponse> data;
  const LineChartWidget(
      {super.key, required this.data, required this.selectedView});

  @override
  Widget build(BuildContext context) {
    final yValues = selectedView == DataViewsEnum.points
        ? data.map((e) => e.points.toDouble()).toList()
        : data.map((e) => e.numOfClimbsLeft.toDouble()).toList();
    final minY = yValues.reduce((a, b) => a < b ? a : b);
    final maxY = yValues.reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        Expanded(
          child: LineChart(
            LineChartData(
              minY: selectedView == DataViewsEnum.numOfClimbsLeft ? 0 : minY,
              maxY: maxY,
              lineBarsData: [
                if (selectedView == DataViewsEnum.points)
                  createLineChartBarData(
                    data
                        .map((e) =>
                            FlSpot(e.week.toDouble(), e.points.toDouble()))
                        .toList(),
                    Colors.blue,
                  ),
                if (selectedView == DataViewsEnum.numOfClimbsLeft)
                  createLineChartBarData(
                    data
                        .map((e) => FlSpot(
                            e.week.toDouble(), e.numOfClimbsLeft.toDouble()))
                        .toList(),
                    Colors.green,
                  )
              ],
              titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      maxIncluded: false,
                      minIncluded: false,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        if ((value - value.round()).abs() < 1e-5) {
                          return Center(
                              child: Text(value.round().toString(),
                                  style: const TextStyle(fontSize: 14)));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameWidget: const Text('Week',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    axisNameSize: 30,
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        if ((value - value.toInt()).abs() < 1e-6) {
                          return Text(value.toInt().toString(),
                              style: const TextStyle(fontSize: 14));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false))),
            ),
          ),
        )
      ],
    );
  }

  LineChartBarData createLineChartBarData(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: false,
      color: color,
      barWidth: 2,
      isStrokeCapRound: true,
      belowBarData: BarAreaData(show: false),
    );
  }
}
