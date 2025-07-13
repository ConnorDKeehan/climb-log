import 'package:climasys/climasys/features/route_view/widgets/route_details/attempt_bar_chart.dart';
import 'package:climasys/climasys/features/route_view/widgets/route_details/route_overview.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:climasys/climasys/features/route_view/models/get_route_info_query_response.dart';

class RouteDetails extends StatefulWidget {
  final GetRouteInfoQueryResponse routeInfo;

  const RouteDetails({
    super.key,
    required this.routeInfo,
  });

  @override
  State<RouteDetails> createState() => _RouteDetailsState();
}

class _RouteDetailsState extends State<RouteDetails>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    // 2 tabs: Users, Notes
    _tabController = TabController(length: 1, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild to show the correct tab content
    });
  }

  @override
  Widget build(BuildContext context) {
    final routeInfo = widget.routeInfo;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Route #${routeInfo.id}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          _buildRouteOverview(context),
          const SizedBox(height: 16),

          // Tab bar
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).primaryColor,
            tabs: const [
              Tab(text: 'Ascents'),
            ],
          ),

          // Single Container that holds the selected tab's content
          Container(
            width: double.infinity,
            color: Colors.grey.shade300,
            // We add padding so the cards inside have a comfortable margin
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildNotesTab(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteOverview(BuildContext context) {
    final difficultyVotes = widget.routeInfo.difficultyVotes;
    final attemptCounts = widget.routeInfo.attemptCounts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Created
        RouteOverview(routeInfo: widget.routeInfo),

        const Divider(height: 20),

        // Difficulty Votes Chart
        if (difficultyVotes.isNotEmpty) ...[
          Text(
            'Difficulty Votes',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: _buildDifficultyPieChart(difficultyVotes),
          ),
          const Divider(height: 20),
        ],

        // Attempt Counts Chart
        if (attemptCounts.isNotEmpty) ...[
          Text(
            'Attempt Counts',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 90,
            child: AttemptBarChart(attempts: attemptCounts),
          ),
          const Divider(height: 20),
        ],
      ],
    );
  }

  Widget _buildNotesTab() {
    // Pretend each "note" is actually a UserInfoResponse item
    final List<UserInfoResponse> notesList = widget.routeInfo.usersAscended;

    if (notesList.isEmpty) {
      return const Center(child: Text('No ascents logged.'));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notesList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final userInfo = notesList[index];

        // Decide how to phrase the attempt text:
        String attemptText;
        if (userInfo.attemptCount == null || userInfo.attemptCount == 0) {
          attemptText = 'No attempt data';
        } else if (userInfo.attemptCount! > 3) {
          attemptText = 'more than 3 tries (${userInfo.attemptCount})';
        } else if (userInfo.attemptCount == 1) {
          attemptText = 'Flash (${userInfo.attemptCount})';
        } else {
          attemptText = '${userInfo.attemptCount} tries';
        }

        return Card(
          color: Theme.of(context).cardColor, // or Colors.grey[850] for a darker look
          elevation: 2,
          margin: EdgeInsets.zero, // So cards abut each other vertically
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Circle avatar with first letter
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade500,
                  child: Text(
                    userInfo.displayName.isNotEmpty
                        ? userInfo.displayName.substring(0, 1).toUpperCase()
                        : '?',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                // Main info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Username in bold
                      Text(
                        userInfo.displayName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      // Attempt info
                      Text(
                        attemptText,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700, // or a lighter color
                        ),
                      ),
                      // Grade
                      if (userInfo.difficultyForGrade != null)
                        Text(
                          'Grade given: ${userInfo.difficultyForGrade}',
                          style: TextStyle(fontSize: 14),
                        ),
                      // If you have a climb date or angle, show it similarly:
                      // Text('Climbed: Wed, Mar 5, 2025 (Climbed at 40°)',
                      //     style: TextStyle(fontSize: 14)),

                      const SizedBox(height: 8),
                      // Notes block
                      if (userInfo.notes != null && userInfo.notes!.isNotEmpty)
                        Text(
                          userInfo.notes!,
                          style: const TextStyle(fontSize: 14),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds a PieChart for difficulty votes with a side legend.
  Widget _buildDifficultyPieChart(List<DifficultyVote> votes) {
    final colorPalette = [
      Colors.blueAccent,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.redAccent,
      Colors.teal,
    ];

    final totalVotes = votes.fold<int>(0, (sum, v) => sum + v.count);
    if (totalVotes == 0) {
      return const Center(child: Text('No difficulty votes yet.'));
    }

    int i = 0;
    final sections = votes.map((vote) {
      final color = colorPalette[i % colorPalette.length];
      i++;
      return PieChartSectionData(
        value: vote.count.toDouble(),
        color: color,
        radius: 80,
        showTitle: false, // Hide titles from the chart
      );
    }).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 140, // Adjust height as needed
          width: 140, // Adjust width as needed
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 0,
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        const SizedBox(width: 16), // Space between pie chart and legend
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(votes.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorPalette[index % colorPalette.length],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text('${votes[index].difficulty} (${votes[index].count})'),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
