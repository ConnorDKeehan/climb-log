import 'package:climasys/climasys/features/route_view/models/get_route_info_query_response.dart';
import 'package:flutter/material.dart';

class RouteOverview extends StatelessWidget {
  final GetRouteInfoQueryResponse routeInfo;

  const RouteOverview({super.key, required this.routeInfo});

  @override
  Widget build(BuildContext context) {
    // 1. Extract fields / format as needed
    final dateCreatedStr = _formatDate(routeInfo.dateCreated);
    final difficultyConsensus = routeInfo.difficultyConsensus ?? 'N/A';
    final gymGradeName = routeInfo.grade.gradeName;
    final standardGradeName = routeInfo.standardGrade?.gradeName ?? 'Unknown';
    final competition = routeInfo.competition;
    final competitionStartDate = competition?.startDate != null
        ? _formatDate(competition!.startDate!)
        : null;
    final competitionEndDate = competition?.endDate != null
        ? _formatDate(competition!.endDate!)
        : null;

    // 2. Build the UI
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Created
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 16),
            const SizedBox(width: 8),
            Text(
              'Date Created: $dateCreatedStr',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const Divider(height: 20),

        // Difficulty & Grades
        _buildLabelValue('Difficulty Consensus', difficultyConsensus, context),
        const SizedBox(height: 8),

        _buildLabelValue('Colour', gymGradeName, context),
        _buildLabelValue('Grade', standardGradeName, context),
        _buildLabelValue('Points', routeInfo.points.toString(), context),

        if (competition != null) ...[
          const SizedBox(height: 8),
          _buildLabelValue('Competition', competition.name, context),
          if (competitionStartDate != null)
            _buildLabelValue('Start Date', competitionStartDate, context),
          if (competitionEndDate != null)
            _buildLabelValue('End Date', competitionEndDate, context),
        ]
      ],
    );
  }

  /// Helper to build “Label: Value” text with a bold label.
  Widget _buildLabelValue(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  /// Simple date formatting
  String _formatDate(DateTime date) {
    // e.g. "2025-03-25" from the full DateTime
    return date.toIso8601String().split('T').first;
  }
}