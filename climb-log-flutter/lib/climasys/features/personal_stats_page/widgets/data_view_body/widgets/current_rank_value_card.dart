import 'package:climasys/climasys/features/personal_stats_page/widgets/data_view_body/functions/get_olympic_colors.dart';
import 'package:flutter/material.dart';

/// This card widget displays the current rank and current value
class CurrentRankValueCard extends StatelessWidget {
  final int currentRank;
  final int currentValue;

  const CurrentRankValueCard({
    super.key,
    required this.currentRank,
    required this.currentValue,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: getOlympicColors(currentRank),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Current Rank
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Rank $currentRank',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            // Current Value
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Value: $currentValue',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
