import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/climasys/features/competitions_screen/models/get_competition_by_gym_query_response.dart';
import 'package:climasys/climasys/features/competitions_screen/widgets/gym_competitions/join_competition_alert.dart';
import 'package:climasys/climasys/features/competitions_screen/widgets/view_competition/view_competition.dart';
import 'package:climasys/climasys/features/competitions_screen/widgets/view_competition/view_competitiongroup_leaderboard.dart';
import 'package:climasys/utils/confirm_action_dialog.dart';
import 'package:flutter/material.dart';

class GymCompetitions extends StatefulWidget {
  final List<GetCompetitionByGymQueryResponse> competitionsByGym;
  final String gymName;
  final bool isGymAdmin;
  final VoidCallback refreshCompetitions;
  const GymCompetitions(
      {super.key,
      required this.competitionsByGym,
      required this.gymName,
      required this.refreshCompetitions,
      required this.isGymAdmin});

  @override
  State<StatefulWidget> createState() => _GymCompetitionsState();
}

class _GymCompetitionsState extends State<GymCompetitions> {
  void _showJoinCompetitionAlert(int compId) async {
    await showDialog<JoinCompetitionAlert>(
        context: context,
        builder: (context) => JoinCompetitionAlert(
            competitionId: compId,
            refreshCompetitions: widget.refreshCompetitions));
  }

  void _leaveCompetition(int compId) async {
    try {
      await leaveCompetitionByCompetitionId(compId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully left competition')),
      );
      widget.refreshCompetitions();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to leave competition')),
      );
    }
  }

  void _startCompetition(int compId) async {
    try {
      await startCompetition(compId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully started competition')),
      );
      widget.refreshCompetitions();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to start competition')),
      );
    }
  }

  void _stopCompetition(int compId) async {
    try {
      await stopCompetition(compId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully stopped competition')),
      );
      widget.refreshCompetitions();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to stop competition')),
      );
    }
  }

  void _archiveCompetition(int compId) async {
    final bool? confirm = await confirmActionDialog(context);
    if (confirm != true) return;

    try {
      await archiveCompetition(compId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully archived competition')),
      );
      widget.refreshCompetitions();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to archive competition')),
      );
    }
  }

  void _goToViewCompetition(GetCompetitionByGymQueryResponse competition) {
    //If there's only a single group, no need to go to the group list screen.
    if(competition.singleGroupId != null){
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewCompetitionGroupLeaderboard(competitionGroupId: competition.singleGroupId!)),
      );
    }
    else{
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewCompetition(competitionId: competition.competitionId)),
      );
    }
  }

  Widget dropDownButtons(GetCompetitionByGymQueryResponse competition) {
    return MenuAnchor(
      menuChildren: [
        if (competition.isUserEntered)
          MenuItemButton(
            onPressed: () {
              _leaveCompetition(competition.competitionId);
            },
            child: const Text('Leave'),
          ),
        if (!competition.isUserEntered)
          MenuItemButton(
            onPressed: () {
              _showJoinCompetitionAlert(competition.competitionId);
            },
            child: const Text('Join'),
          ),
        if (competition.active && widget.isGymAdmin)
          MenuItemButton(
            onPressed: () {
              _stopCompetition(competition.competitionId);
            },
            child: const Text('End'),
          )
        else if (widget.isGymAdmin)
          MenuItemButton(
            onPressed: () {
              _startCompetition(competition.competitionId);
            },
            child: const Text('Start'),
          ),
        if (widget.isGymAdmin)
          MenuItemButton(
            onPressed: () {
              _archiveCompetition(competition.competitionId);
            }, // Handle archive action
            child: const Text('Archive'),
          ),
      ],
      builder: (context, controller, child) {
        return IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.competitionsByGym.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Ensures minimal vertical space
                children: [
                  const Icon(
                    Icons.emoji_events_outlined,
                    size: 48,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Competitions at ${widget.gymName}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Check back soon or create a new one if you're a gym admin!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

        ...widget.competitionsByGym.map((competition) => ListTile(
              onTap: () {
                _goToViewCompetition(competition);
              },
              title: Row(children: [
                Text(competition.competitionName,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                if (competition.active)
                  const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('In Progress',
                          style: TextStyle(color: Colors.green)))
              ]),
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (competition.isUserEntered)
                      Chip(
                        label: const Text(
                          'Entered',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          'From: ${competition.startDate?.toLocal().toString().split(' ')[0] ?? 'N/A'} '
                          'To: ${competition.endDate?.toLocal().toString().split(' ')[0] ?? 'N/A'}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ]),
              trailing: dropDownButtons(competition),
            ))
      ],
    );
  }
}
