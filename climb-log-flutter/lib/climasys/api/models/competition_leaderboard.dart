class CompetitionLeaderboard {
  final int loginId;
  final String competitorName;
  final int points;
  final int rank;

  CompetitionLeaderboard({
    required this.loginId,
    required this.competitorName,
    required this.points,
    required this.rank
  });

  factory CompetitionLeaderboard.fromJson(Map<String, dynamic> json) {
    return CompetitionLeaderboard(
        loginId: json['loginId'],
        competitorName: json['competitorName'],
        points: json['points'],
        rank: json['rank']
    );
  }
}