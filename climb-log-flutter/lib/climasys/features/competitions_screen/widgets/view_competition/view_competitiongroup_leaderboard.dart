import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/climasys/api/models/competition_leaderboard.dart';
import 'package:flutter/material.dart';

class ViewCompetitionGroupLeaderboard extends StatefulWidget {
  final int competitionGroupId;
  const ViewCompetitionGroupLeaderboard(
      {super.key, required this.competitionGroupId});

  @override
  State<StatefulWidget> createState() =>
      _ViewCompetitionGroupLeaderboardState();
}

class _ViewCompetitionGroupLeaderboardState
    extends State<ViewCompetitionGroupLeaderboard> {
  List<CompetitionLeaderboard> competitionLeaderboard = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    final competitionLeaderboardResponse =
        await getCompetitionGroupLeaderboard(widget.competitionGroupId);

    setState(() {
      competitionLeaderboard = competitionLeaderboardResponse;
    });

    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
      ),
      body: isLoading ? const Center(child: CircularProgressIndicator()) :
        ListView(children: [
          if (competitionLeaderboard.isEmpty)
            const Center(child: Text("Nobody has entered this group yet")),
          ...competitionLeaderboard.map((competitor) => ListTile(
                title: Text("${competitor.rank}. ${competitor.competitorName}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Points: ${competitor.points}"),
              ))
        ]));
  }
}
