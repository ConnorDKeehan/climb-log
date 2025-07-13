import 'package:climasys/climasys/api/models/get_points_data_view_response.dart';
import 'package:flutter/material.dart';
import '../models/rank_table_model.dart';
import 'common_table.dart'; // import the file from step 1

class PointsTable extends StatelessWidget {
  final List<GetPointsDataViewResponse> pointsTableData;

  const PointsTable({
    super.key,
    required this.pointsTableData,
  });

  @override
  Widget build(BuildContext context) {
    List<RankTableModel> mapToRankTableModel(
        List<GetPointsDataViewResponse> pointsTableData) {
      return pointsTableData.map((item) {
        // Transform each item into the required format
        return RankTableModel(
          rank: item.rank,
          name: item.name,
          value: item.points,
        );
      }).toList();
    }

    return CommonTable<GetPointsDataViewResponse>(
      headerTitles: const ["Rank", "Name", "Points"],
      data: mapToRankTableModel(pointsTableData),
    );
  }
}
