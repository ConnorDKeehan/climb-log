import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/climasys/api/models/grade.dart';
import 'package:climasys/utils/storage_util.dart';
import 'package:flutter/material.dart';

class StatsInfoAlert extends StatefulWidget {
  const StatsInfoAlert({super.key});

  @override
  State<StatsInfoAlert> createState() => _StatsInfoModalState();
}

class _StatsInfoModalState extends State<StatsInfoAlert>
    with SingleTickerProviderStateMixin {
  List<Grade> standardGrades = [];
  List<Grade> colourGrades = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    initializeState();
  }

  Future<void> initializeState() async {
    final gymName = await getGymName(context);
    final gradeInfo = await getGymGradesByGymName(gymName);

    setState(() {
      standardGrades = gradeInfo.standardGrades;
      colourGrades = gradeInfo.grades;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // Rounded corners for the dialog
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      title: const Text('Grade Info'),
      content: SizedBox(
        // Manually set a wider width so the dialog is less narrow
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Info message
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                'If a route has a V Grade points will be calculated off of that, '
                    'if not it will use the points of the colour of the climb.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium
              ),
            ),

            // Tab bar
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Grades'),
                Tab(text: 'Colours'),
              ],
              // Styling for the selected/unselected tabs
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.black54,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
              indicatorColor: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 8.0),
            const SizedBox(height: 8.0),

            // Tab bar views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Grades tab
                  _buildGradeTable(context, standardGrades),
                  // Colours tab
                  _buildGradeTable(context, colourGrades),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Theme.of(context).primaryColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Close',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }

  Widget _buildGradeTable(BuildContext context, List<Grade> grades) {
    return SingleChildScrollView(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        child: DataTable(
          headingRowColor: MaterialStateProperty.resolveWith((states) {
            // Lightly color the header row
            return Theme.of(context).primaryColor.withOpacity(0.1);
          }),
          headingTextStyle: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.bold),
          dataRowHeight: 48.0,
          headingRowHeight: 50.0,
          horizontalMargin: 24.0,
          columnSpacing: 32.0,
          columns: const [
            DataColumn(label: Text('Grade Name')),
            DataColumn(label: Text('Points')),
          ],
          rows: grades
              .map(
                (grade) => DataRow(
              cells: [
                DataCell(Text(grade.gradeName)),
                DataCell(Text(grade.points.toString())),
              ],
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}
