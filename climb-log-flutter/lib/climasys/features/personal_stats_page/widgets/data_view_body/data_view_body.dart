import 'package:climasys/climasys/api/models/get_main_data_view_response.dart';
import 'package:climasys/climasys/features/personal_stats_page/widgets/data_view_body/widgets/current_rank_value_card.dart';
import 'package:flutter/material.dart';
import '../../models/data_views_enum.dart';
import 'widgets/line_chart_widget.dart';

class DataViewBody extends StatelessWidget {
  final DataViewsEnum selectedView;
  final List<GetMainDataViewResponse> data;
  final Widget table;
  final int graphOrTableIndex;
  final int currentRank;
  final int currentValue;
  const DataViewBody(
      {super.key,
      required this.selectedView,
      required this.data,
      required this.table,
      required this.graphOrTableIndex,
      required this.currentRank,
      required this.currentValue});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          IntrinsicHeight(
            child: CurrentRankValueCard(
              currentRank: currentRank,
              currentValue: currentValue,
            ),
          ),
          const Spacer(flex: 1),
          Expanded(
              flex: 40,
              child: graphOrTableIndex == 0
                  ? LineChartWidget(selectedView: selectedView, data: data)
                  : table)
        ]));
  }
}
