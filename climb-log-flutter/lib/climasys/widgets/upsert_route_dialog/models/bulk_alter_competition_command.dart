class BulkAlterCompetitionCommand {
  final List<int> routeIds;
  final int competitionId;

  BulkAlterCompetitionCommand({
    required this.routeIds,
    required this.competitionId
  });

  Map<String, dynamic> toJson() =>
      {
        'routeIds': routeIds,
        'competitionId': competitionId
      };
}