import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/climasys/api/models/competition_group_response.dart';
import 'package:flutter/material.dart';

class JoinCompetitionAlert extends StatefulWidget {
  final int competitionId;
  final VoidCallback refreshCompetitions;
  const JoinCompetitionAlert(
      {super.key,
      required this.competitionId,
      required this.refreshCompetitions});

  @override
  State<StatefulWidget> createState() => _JoinCompetitionAlertState();
}

class _JoinCompetitionAlertState extends State<JoinCompetitionAlert> {
  List<CompetitionGroupResponse> competitionGroups = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _onSubmit(int competitionGroupId) async {
    try {
      await enterCompetition(competitionGroupId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Competition created successfully!')),
      );
      Navigator.of(context).pop();
      widget.refreshCompetitions();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to join competition group.')));
    }
  }

  void _fetchData() async {
    final competitionGroupsResponse =
        await getCompetitionGroupsByCompId(widget.competitionId);

    setState(() {
      competitionGroups = competitionGroupsResponse;
    });

    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: SingleChildScrollView(
            child: Column(
      children: [
        Text("Select Group", style: Theme.of(context).textTheme.titleMedium),
        ...competitionGroups.map((competitionGroup) => ListTile(
                title: TextButton(
              child: Text(competitionGroup.name),
              onPressed: () {
                _onSubmit(competitionGroup.id);
              },
            )))
      ],
    )));
  }
}
