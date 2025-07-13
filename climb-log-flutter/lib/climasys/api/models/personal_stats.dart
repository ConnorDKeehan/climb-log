class PersonalStats {
  final int totalPoints;
  final int totalAscents;
  final int totalGymRanking;
  final List<GradeAscended> totalGradeAscendedCount;
  final int lastWeekPoints;
  final int lastWeekAscents;
  final int lastWeekGymRanking;
  final List<GradeAscended> lastWeekAscendedCount;

  PersonalStats({
    required this.totalPoints,
    required this.totalAscents,
    required this.totalGymRanking,
    required this.totalGradeAscendedCount,
    required this.lastWeekPoints,
    required this.lastWeekAscents,
    required this.lastWeekGymRanking,
    required this.lastWeekAscendedCount,
  });

  factory PersonalStats.fromJson(Map<String, dynamic> json) {
    return PersonalStats(
      totalPoints: json['totalPoints'],
      totalAscents: json['totalAscents'],
      totalGymRanking: json['totalGymRanking'],
      totalGradeAscendedCount: (json['totalGradeAscendedCount'] as List<dynamic>)
          .map((e) => GradeAscended.fromJson(e))
          .toList(),
      lastWeekPoints: json['lastWeekPoints'],
      lastWeekAscents: json['lastWeekAscents'],
      lastWeekGymRanking: json['lastWeekGymRanking'],
      lastWeekAscendedCount: (json['lastWeekAscendedCount'] as List<dynamic>)
          .map((e) => GradeAscended.fromJson(e))
          .toList(),
    );
  }
}

class GradeAscended {
  final String gradeName;
  final int numOfAscents;

  GradeAscended({
    required this.gradeName,
    required this.numOfAscents,
  });

  factory GradeAscended.fromJson(Map<String, dynamic> json) {
    return GradeAscended(
      gradeName: json['gradeName'],
      numOfAscents: json['numOfAscents'],
    );
  }
}
