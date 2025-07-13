import 'package:climasys/climasys/features/personal_stats_page/widgets/data_view_body/functions/get_olympic_colors.dart';
import 'package:climasys/climasys/features/personal_stats_page/widgets/data_view_body/models/rank_table_model.dart';
import 'package:flutter/material.dart';

class CommonTable<T> extends StatelessWidget {
  final List<String> headerTitles;
  final List<RankTableModel> data;

  const CommonTable({
    super.key,
    required this.headerTitles,
    required this.data,
  });

  TableRow _buildHeaderRow(BuildContext context) {
    return TableRow(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      ),
      children: headerTitles
          .map(
            (title) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget tableCell(String value) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(value),
      );

  TableRow _buildDataRow(RankTableModel item, {required int rank}) {
    //Add one to the row index as it starts from 0
    Color rowColor = getOlympicColors(rank);

    return TableRow(
        // Give alternating row colors (optional)
        decoration: BoxDecoration(color: rowColor),
        children: [
          tableCell('${item.rank}'),
          tableCell(item.name),
          tableCell('${item.value}'),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      // A lighter, thinner border
      border: const TableBorder.symmetric(
          inside: BorderSide(width: 1, color: Colors.black38),
          outside: BorderSide(width: 1)),
      // Control how columns size themselves: for instance, IntrinsicColumnWidth
      // keeps columns tight to their content. Experiment for your desired look.
      columnWidths: const {
        0: IntrinsicColumnWidth(), // Fixed width for Rank column
        1: FlexColumnWidth(), // Flexible width for Name column
        2: IntrinsicColumnWidth(), // Fixed width for Climbs Remaining
      },
      // Align cells vertically to the middle
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        _buildHeaderRow(context),
        for (int i = 0; i < data.length; i++)
          _buildDataRow(data[i], rank: data[i].rank),
      ],
    );
  }
}
