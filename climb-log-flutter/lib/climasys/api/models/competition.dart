class Competition {
  final int id;
  final DateTime? startDate;
  final DateTime? endDate;
  final String name;
  final List<GymCompetition>? gymCompetitions;
  final List<CompetitionGroup>? competitionGroups;

  Competition({
    required this.id,
    this.startDate,
    this.endDate,
    required this.name,
    this.gymCompetitions,
    this.competitionGroups,
  });

  factory Competition.fromJson(Map<String, dynamic> json) {
    return Competition(
      id: json['id'],
      startDate:
      json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate:
      json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      name: json['name'],
      gymCompetitions: json['gymCompetitions'] != null
          ? (json['gymCompetitions'] as List)
          .map((e) => GymCompetition.fromJson(e))
          .toList()
          : null,
      competitionGroups: json['competitionGroups'] != null
          ? (json['competitionGroups'] as List)
          .map((e) => CompetitionGroup.fromJson(e))
          .toList()
          : null,
    );
  }
}

class GymCompetition {
  final int id;
  final int gymId;
  final int competitionId;

  GymCompetition({
    required this.id,
    required this.gymId,
    required this.competitionId,
  });

  factory GymCompetition.fromJson(Map<String, dynamic> json) {
    return GymCompetition(
      id: json['id'],
      gymId: json['gymId'],
      competitionId: json['competitionId'],
    );
  }
}

class CompetitionGroup {
  final int id;
  final int competitionId;
  final int competitionGroupRuleId;
  final String name;

  CompetitionGroup({
    required this.id,
    required this.competitionId,
    required this.competitionGroupRuleId,
    required this.name,
  });

  factory CompetitionGroup.fromJson(Map<String, dynamic> json) {
    return CompetitionGroup(
      id: json['id'],
      competitionId: json['competitionId'],
      competitionGroupRuleId: json['competitionGroupRuleId'],
      name: json['name'],
    );
  }
}
