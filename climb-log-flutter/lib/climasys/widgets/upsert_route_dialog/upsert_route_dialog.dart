import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/climasys/api/models/competition.dart';
import 'package:climasys/climasys/api/models/grade.dart';
import 'package:climasys/climasys/api/models/sector.dart';
import 'package:climasys/climasys/features/map_view/functions/get_color_from_string.dart';
import 'package:climasys/climasys/features/map_view/map_view.dart';
import 'package:climasys/climasys/widgets/upsert_route_dialog/models/add_route_command.dart';
import 'package:climasys/climasys/widgets/upsert_route_dialog/models/edit_route_command.dart';
import 'package:climasys/climasys/widgets/upsert_route_dialog/models/get_info_for_upserting_route_response.dart';
import 'package:climasys/utils/storage_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UpsertRouteDialog extends StatefulWidget {
  final int? routeId;
  final double? xCord;
  final double? yCord;
  const UpsertRouteDialog({super.key, this.routeId, this.xCord, this.yCord});

  @override
  State<UpsertRouteDialog> createState() => _UpsertRouteDialogState();
}

class _UpsertRouteDialogState extends State<UpsertRouteDialog> {
  GetInfoForUpsertingRouteQueryResponse? routeInfo;
  Grade? selectedGrade;
  Grade? selectedStandardGrade;
  int? selectedCompetitionId;
  int? pointValue;
  int? selectedSectorId;
  TextEditingController pointValueController = TextEditingController();
  List<Grade> grades = [];
  List<Grade> standardGrades = [];
  List<Competition> competitions = [];
  List<Sector> sectors = [];
  bool isLoading = true;
  //This will be calculated during initialization.
  bool isNewRoute = true;
  String gymName = "";
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    try {
      gymName = await getGymName(context);
      final routeInfo = await getInfoForUpsertingRoute(widget.routeId, gymName);
      setState(() {
        isNewRoute = widget.routeId == null; //If routeId is null this is a new route.
        grades = routeInfo.grades;
        standardGrades = routeInfo.standardGrades;
        sectors = routeInfo.sectors;
        competitions = routeInfo.competitions;
        if (routeInfo.currentGrade != null) {
          selectedGrade = routeInfo.grades.firstWhere(
                  (g) => g.id == routeInfo.currentGrade!.id);
        }
        if (routeInfo.currentStandardGrade != null) {
          selectedStandardGrade = routeInfo.standardGrades.firstWhere(
                (g) => g.id == routeInfo.currentStandardGrade!.id);
        }
        selectedCompetitionId = routeInfo.currentCompetition?.id;
        if(selectedCompetitionId == null && competitions.length > 0){
          selectedCompetitionId = competitions[0].id;
        }
        selectedSectorId = routeInfo.currentSector?.id;
        if(selectedSectorId == null && widget.xCord!= null && widget.yCord != null){
          final sectorBasedOnCords = getSectorByCords(widget.xCord!, widget.yCord!, sectors);
          selectedSectorId = sectorBasedOnCords?.id;
        }
        pointValue = routeInfo.currentPointValue;
        pointValueController.text = routeInfo.currentPointValue?.toString() ??
            routeInfo.currentStandardGrade?.points.toString() ??
            routeInfo.currentGrade?.points.toString() ??
            "";

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Optionally, show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error fetching grades. Please try again later.')),
      );
    }
  }

  Sector? getSectorByCords(double xCord, double yCord, List<Sector> sectors){
    var sector = sectors.where((x) =>
    xCord >= x.xStart
        && xCord <= x.xEnd
        && yCord >= x.yStart
        && yCord <= x.yEnd).firstOrNull;

    return sector;
  }

  int getPointValue(){
    return 0;
  }

  Future<bool> submitAddRoute(int points) async {
    bool succeeded = false;

    if(widget.xCord == null || widget.yCord == null || widget.routeId != null){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sorry failed to add route due to an app error. Try restart or raise the error.")),
      );

      return succeeded; //false here
    }

    final addRouteCommand = AddRouteCommand(
      gymName: gymName,
      xCord: widget.xCord!,
      yCord: widget.yCord!,
      gradeId: selectedGrade!.id,
      standardGradeId: selectedStandardGrade?.id,
      sectorId: selectedSectorId,
      competitionId: selectedCompetitionId,
      pointValue: points
    );

    try {
      await addRoute(addRouteCommand);
    } catch(e){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sorry failed to add route due to an app error. Try restart or raise the error.")),
        );
      }

      return succeeded; //false here
    }

    succeeded = true;
    return succeeded; //true here
  }

  Future<bool> submitEditRoute(int points) async {
    bool succeeded = false;
    if(widget.routeId == null){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sorry failed to edit route due to an app error. Try restart or raise the error.")),
      );

      return succeeded; //false here
    }

    final editRouteCommand = EditRouteCommand(
      routeId: widget.routeId!,
      gradeId: selectedGrade!.id,
      standardGradeId: selectedStandardGrade?.id,
      competitionId: selectedCompetitionId,
      pointValue: points,
      sectorId: selectedSectorId
    );

    try{
      await editRoute(editRouteCommand, gymName);
    } catch(e){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sorry failed to edit route due to an app error. Try restart or raise the error.")),
        );

        return succeeded;
      }
    }

    succeeded = true;
    return succeeded; //true here
  }

  void _submit() async {
    //Doing this to avoid the strange async case Flutter is convinced exists.
    final navigator = Navigator.of(context);
    final scaffold = ScaffoldMessenger.of(context);

    if (selectedGrade == null) {
      scaffold.showSnackBar(
        const SnackBar(content: Text('Please select a grade')),
      );
      return;
    }

    final int? selectedPointValue = int.tryParse(pointValueController.text);

    if(selectedPointValue == null){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No valid point value is available. Please enter points.")),
      );

      return;
    }

    bool succeeded = false;
    if(isNewRoute){
      succeeded = await submitAddRoute(selectedPointValue);
    } else{
      succeeded = await submitEditRoute(selectedPointValue);
    }

    if(succeeded && mounted) {
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const MapView(),
        ),
            (Route<
            dynamic> route) => false, // This will remove all previous routes
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.routeId == null ? 'Add Route' : 'Edit Route'),
      content: isLoading
          ? const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      )
          : SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<Grade>(
              decoration: const InputDecoration(
                labelText: 'Colour',
                border: OutlineInputBorder(),
              ),
              value: selectedGrade,
              items: grades.map((Grade grade) {
                // Use your GetColorFromString function here:
                final Color color = getColorFromString(grade.gradeName);
                return DropdownMenuItem<Grade>(
                  value: grade,
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(grade.gradeName),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (Grade? newValue) {
                setState(() {
                  selectedGrade = newValue;
                  if(
                    newValue?.points != null
                    && (selectedStandardGrade == null || pointValueController.text.isEmpty)
                  ) {
                    pointValueController.text = newValue?.points.toString() ?? "";
                  }
                });
              },
              validator: (value) =>
              value == null ? 'Please select a colour' : null,
            ),
            const SizedBox(height: 16),
            if (standardGrades.isNotEmpty)
              DropdownButtonFormField<Grade>(
                decoration: const InputDecoration(
                  labelText: 'Grade',
                  border: OutlineInputBorder(),
                ),
                value: selectedStandardGrade,
                items: standardGrades.map((Grade grade) {
                  return DropdownMenuItem<Grade>(
                    value: grade,
                    child: Text(grade.gradeName),
                  );
                }).toList(),
                onChanged: (Grade? newValue) {
                  setState(() {
                    selectedStandardGrade = newValue;
                    if(newValue?.points != null){
                      pointValueController.text = newValue!.points.toString();
                    }
                  });
                },
                validator: (value) =>
                value == null ? 'Please select a grade' : null,
              ),
            const SizedBox(height: 16),
            if (sectors.isNotEmpty)
              Column(children: [
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Sector',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedSectorId,
                  items: sectors.map((Sector sector) {
                    return DropdownMenuItem<int>(
                      value: sector.id,
                      child: Text(sector.name),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedSectorId = newValue;
                    });
                  },
                  validator: (value) =>
                  value == null ? 'Please select a grade' : null,
                ),
                const SizedBox(height: 16)
              ]),
            if (competitions.isNotEmpty)
              Column(children: [
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Competitions',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedCompetitionId,
                  items: [
                    const DropdownMenuItem<int>(
                      value: null,
                      child: Text('None'),
                    ),
                    ...competitions.map((competition) {
                      return DropdownMenuItem<int>(
                        value: competition.id,
                        child: Text(competition.name),
                      );
                    }),
                  ],
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedCompetitionId = newValue;
                    });
                  },
                  validator: (value) =>
                  value == null ? 'Please select a grade' : null,
                ),
                const SizedBox(height: 16)
              ]),
            TextFormField(
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Boulder Point Value"),
              controller: pointValueController,
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop(null), // Return null on cancel
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit, // Handle submission
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
