import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/climasys/api/models/personal_stats.dart';
import 'package:climasys/utils/storage_util.dart';
import 'package:flutter/material.dart';

class PointsAndRank extends StatefulWidget {
  const PointsAndRank({super.key});

  @override
  State<PointsAndRank> createState() => _PointsAndRankState();
}

class _PointsAndRankState extends State<PointsAndRank> {
  Future<PersonalStats>? _personalStatsFuture;

  @override
  void initState() {
    super.initState();
    _initializePersonalStats();
  }

  Future<void> _initializePersonalStats() async {
    String gymName = await getGymName(context);
    setState(() {
      _personalStatsFuture = getPersonalStats(gymName);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_personalStatsFuture == null) {
      // While _gymFuture is null, show a loading indicator or placeholder
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Stats'),
      ),
      body: FutureBuilder<PersonalStats>(
        future: _personalStatsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the future is loading, show a loading spinner
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If the future failed, show an error message
            return const Center(child: Text('Error loading stats'));
          } else if (!snapshot.hasData) {
            // If the future completed successfully but there's no data, show a message
            return const Center(child: Text('No data available'));
          } else {
            // When data is available, display it
            PersonalStats stats = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Total Stats Card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Total Stats',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatColumn('Points', stats.totalPoints),
                              _buildStatColumn('Ascents', stats.totalAscents),
                              _buildStatColumn('Ranking', stats.totalGymRanking)
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (stats.totalGradeAscendedCount.isNotEmpty)
                            Column(children: [
                              const Text(
                                'Grades Ascended',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 4.0,
                                children: stats.totalGradeAscendedCount
                                    .map((gradeAscended) => Chip(
                                          label: Text(
                                              '${gradeAscended.gradeName} (${gradeAscended.numOfAscents})'),
                                        ))
                                    .toList(),
                              )
                            ])
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Last Week Stats Card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'This Weeks Stats',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatColumn('Points', stats.lastWeekPoints),
                              _buildStatColumn(
                                  'Ascents', stats.lastWeekAscents),
                              _buildStatColumn(
                                  'Ranking', stats.lastWeekGymRanking)
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (stats.lastWeekAscendedCount.isNotEmpty)
                            Column(children: [
                              const Text(
                                'Grades Ascended',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 4.0,
                                children: stats.lastWeekAscendedCount
                                    .map((gradeAscended) => Chip(
                                          label: Text(
                                              '${gradeAscended.gradeName} (${gradeAscended.numOfAscents})'),
                                        ))
                                    .toList(),
                              ),
                            ])
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildStatColumn(String label, int value) {
    String displayValue =
        (label == 'Ranking' && value == 9999) ? 'N/A' : '$value';

    return Column(
      children: [
        Text(
          displayValue,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }
}
