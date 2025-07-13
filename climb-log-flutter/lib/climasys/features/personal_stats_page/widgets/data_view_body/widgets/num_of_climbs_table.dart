import 'package:climasys/climasys/features/personal_stats_page/widgets/data_view_body/models/rank_table_model.dart';
import 'package:flutter/material.dart';
import 'package:climasys/climasys/api/models/get_num_of_climbs_data_view_response.dart';
import 'common_table.dart';

class NumOfClimbsTable extends StatelessWidget {
  final List<GetNumOfClimbsDataViewResponse> numOfClimbsTableData;

  const NumOfClimbsTable({
    super.key,
    required this.numOfClimbsTableData,
  });

  @override
  Widget build(BuildContext context) {
    List<RankTableModel> mapToRankTableModel(
        List<GetNumOfClimbsDataViewResponse> numOfClimbsTableData) {
      return numOfClimbsTableData.map((item) {
        // Transform each item into the required format
        return RankTableModel(
          rank: item.rank,
          name: item.name,
          value: item.numOfClimbs,
        );
      }).toList();
    }

    return CommonTable<GetNumOfClimbsDataViewResponse>(
        headerTitles: const ["Rank", "Name", "Climbs Remaining"],
        data: mapToRankTableModel(numOfClimbsTableData));
  }
}
