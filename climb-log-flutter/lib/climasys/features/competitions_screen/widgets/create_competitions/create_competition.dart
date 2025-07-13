import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/climasys/api/models/create_competition_request.dart';
import 'package:climasys/climasys/features/competitions_screen/widgets/create_competitions/gyms_to_include_expansion_tile.dart';
import 'package:climasys/utils/storage_util.dart';
import 'package:flutter/material.dart';

class CreateCompetition extends StatefulWidget {
  final VoidCallback refreshCompetitions;
  const CreateCompetition({super.key, required this.refreshCompetitions});

  @override
  State<StatefulWidget> createState() => _CreateCompetitionState();
}

class _CreateCompetitionState extends State<CreateCompetition> {
  final nameController = TextEditingController();
  final groupNameController = TextEditingController();
  final numberOfClimbsController = TextEditingController();
  final competitionGroupRequests = <CompetitionGroupRequest>[];
  List<String> selectedGymNames = [];
  String competitionName = '';
  DateTime? startDate;
  DateTime? endDate;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  @override
  void initState() {
    super.initState();
    _setCurrentGym();
  }

  void _setCurrentGym() async {
    final String gymName = await getGymName(context);

    setState(() {
      selectedGymNames = [gymName];
    });
  }

  Future<void> _pickStartDate() async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: selectedStartDate ?? initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (newDate != null) {
      setState(() {
        selectedStartDate = newDate;
      });
    }
  }

  Future<void> _pickEndDate() async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: selectedEndDate ?? initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (newDate != null) {
      setState(() {
        selectedEndDate = newDate;
      });
    }
  }

  void _addGroup() async {
    final gName = groupNameController.text.trim();
    final nClimbs = int.tryParse(numberOfClimbsController.text.trim());
    if (gName.isNotEmpty) {
      competitionGroupRequests.add(
        CompetitionGroupRequest(
          name: gName,
          numberOfClimbsIncluded: nClimbs,
        ),
      );
      groupNameController.clear();
      numberOfClimbsController.clear();
      setState(() {});
    }
  }

  Future<void> _submit() async {
    competitionName = nameController.text.trim();

    if (competitionName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a competition name')),
      );
      return;
    }
    if (competitionGroupRequests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please add at least one competition group')),
      );
      return;
    }

    try {
      final request = CreateCompetitionRequest(
        gymNames: selectedGymNames,
        competitionName: competitionName,
        startDate: selectedStartDate,
        endDate: selectedEndDate,
        competitionGroupsRequest: competitionGroupRequests,
      );

      await createCompetition(request);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Competition created successfully!')),
      );
      widget.refreshCompetitions();
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating competition: $e')),
      );
    }
  }

  void updateSelectedGyms(List<String> childGyms) {
    setState(() {
      selectedGymNames = childGyms;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Competition'),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                  labelText: 'Competition Name',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16)),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickStartDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                    labelText: 'Start Date',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                child: Text(
                  selectedStartDate != null
                      ? "${selectedStartDate!.year}-${selectedStartDate!.month.toString().padLeft(2, '0')}-${selectedStartDate!.day.toString().padLeft(2, '0')}"
                      : 'Select a Start Date',
                ),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickEndDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                    labelText: 'End Date',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                child: Text(
                  selectedEndDate != null
                      ? "${selectedEndDate!.year}-${selectedEndDate!.month.toString().padLeft(2, '0')}-${selectedEndDate!.day.toString().padLeft(2, '0')}"
                      : 'Select an End Date',
                ),
              ),
            ),
            const SizedBox(height: 16),
            GymsToIncludeExpansionTile(
                gyms: selectedGymNames, updateSelectedGyms: updateSelectedGyms),
            const SizedBox(height: 32),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text("Competition Groups",
                      style: Theme.of(context).textTheme.titleLarge),
                  Text(
                      "Top X is the top climbs that will be counted for each group, leave empty for no limit.",
                      style: Theme.of(context).textTheme.bodyMedium),
                  Row(
                    children: [
                      Expanded(
                        flex: 7, // 70% of the row space
                        child: TextField(
                          controller: groupNameController,
                          decoration: const InputDecoration(
                            labelText: 'Group Name',
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3, // 30% of the row space
                        child: TextField(
                          controller: numberOfClimbsController,
                          decoration: const InputDecoration(
                            labelText: 'Top X',
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  ...competitionGroupRequests
                      .map((competitionGroupRequest) => ListTile(
                            title: Text(competitionGroupRequest.name),
                            subtitle: Text(
                                "Number of climbs included: ${competitionGroupRequest.numberOfClimbsIncluded ?? "∞"}"),
                          )),
                  ElevatedButton(
                    onPressed: _addGroup,
                    child: const Text('Add Group'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ])),
      bottomNavigationBar: ElevatedButton(
        onPressed: _submit,
        child: const Text('Create Competition'),
      ),
    );
  }
}
