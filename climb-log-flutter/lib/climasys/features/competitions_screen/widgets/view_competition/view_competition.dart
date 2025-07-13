import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/climasys/api/models/competition_group_response.dart';
import 'package:climasys/climasys/features/competitions_screen/widgets/view_competition/view_competitiongroup_leaderboard.dart';
import 'package:flutter/material.dart';

class ViewCompetition extends StatefulWidget {
  final int competitionId;
  const ViewCompetition({super.key, required this.competitionId});

  @override
  State<StatefulWidget> createState() => _ViewCompetitionState();
}

class _ViewCompetitionState extends State<ViewCompetition> {
  List<CompetitionGroupResponse> competitionGroups = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    final competitionGroupsResponse =
        await getCompetitionGroupsByCompId(widget.competitionId);

    setState(() {
      competitionGroups = competitionGroupsResponse;
    });

    isLoading = false;
  }

  void _goToViewCompetitionGroup(int competitionGroupId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ViewCompetitionGroupLeaderboard(
              competitionGroupId: competitionGroupId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Select Group'),
        ),
        body: ListView(children: [
          ...competitionGroups.map((competitionGroup) => ListTile(
                title: Text(competitionGroup.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  _goToViewCompetitionGroup(competitionGroup.id);
                },
              ))
        ]));
  }
}
