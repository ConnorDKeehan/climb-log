import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/climasys/api/models/get_main_data_view_response.dart';
import 'package:climasys/climasys/api/models/get_num_of_climbs_data_view_response.dart';
import 'package:climasys/climasys/api/models/get_points_data_view_response.dart';
import 'package:climasys/climasys/features/personal_stats_page/models/data_views_enum.dart';
import 'package:climasys/climasys/features/personal_stats_page/widgets/data_view_body/widgets/common_table.dart';
import 'package:climasys/climasys/features/personal_stats_page/widgets/data_view_body/data_view_body.dart';
import 'package:climasys/climasys/features/personal_stats_page/widgets/stats_info/stats_info_alert.dart';
import 'package:climasys/utils/storage_util.dart';
import 'package:climasys/widgets/loading_scaffold.dart';
import 'package:flutter/material.dart';
import 'models/data_views_labels_map.dart';
import 'widgets/data_view_body/widgets/num_of_climbs_table.dart';
import 'widgets/data_view_body/widgets/points_table.dart';

class MainDataView extends StatefulWidget {
  const MainDataView({super.key});

  @override
  State<MainDataView> createState() => _MainDataViewState();
}

class _MainDataViewState extends State<MainDataView> {
  bool isLoading = true;
  List<GetMainDataViewResponse> data = [];
  List<GetPointsDataViewResponse> pointsTableData = [];
  List<GetNumOfClimbsDataViewResponse> numOfClimbsTableData = [];
  late Table tableToShow;
  int graphOrTableIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeState();
  }

  void initializeState() async {
    String gymName = await getGymName(context);
    final apiResponse = await getMainDataView(gymName);
    final pointsTableResponse = await getPointsDataView(gymName);
    final numOfClimbsTableResponse = await getNumOfClimbsDataView(gymName);

    setState(() {
      data = apiResponse;
      pointsTableData = pointsTableResponse;
      numOfClimbsTableData = numOfClimbsTableResponse;
      isLoading = false;
    });
  }

  Widget dataViewBody(DataViewsEnum selectedView) {
    GetMainDataViewResponse maxItem = data.fold(
      data.first, // Start with the first item as the initial value
      (currentMax, item) => item.week > currentMax.week ? item : currentMax,
    );

    return DataViewBody(
      selectedView: selectedView,
      data: data,
      table: selectedView == DataViewsEnum.points
          ? PointsTable(pointsTableData: pointsTableData)
          : NumOfClimbsTable(numOfClimbsTableData: numOfClimbsTableData),
      graphOrTableIndex: graphOrTableIndex,
      currentRank: selectedView == DataViewsEnum.points
          ? maxItem.pointRank
          : maxItem.numOfClimbsLeftRank,
      currentValue: selectedView == DataViewsEnum.points
          ? maxItem.points
          : maxItem.numOfClimbsLeft,
    );
  }

  void showStatsInfoAlert() async {
    await showDialog<StatsInfoAlert>(
      context: context,
      builder: (context) => const StatsInfoAlert()
    );
  }

  @override
  Widget build(BuildContext context) {
    const String titleText = "Statistics";
    return isLoading
        ? const LoadingScaffold(titleText: titleText)
        : DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                bottom: TabBar(
                  tabs: [
                    Tab(text: dataViewsLabels[DataViewsEnum.points]),
                    Tab(text: dataViewsLabels[DataViewsEnum.numOfClimbsLeft]),
                  ],
                ),
                title: const Text(titleText),
                actions: [IconButton(onPressed: showStatsInfoAlert, icon: const Icon(Icons.info_outline))],
              ),
              body: TabBarView(
                children: [
                  dataViewBody(DataViewsEnum.points),
                  dataViewBody(DataViewsEnum.numOfClimbsLeft),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: graphOrTableIndex,
                onTap: (index) {
                  setState(() {
                    graphOrTableIndex = index;
                  });
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.show_chart),
                    label: 'Graph',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.table_chart),
                    label: 'Table',
                  ),
                ],
              ),
            ),
          );
  }
}
