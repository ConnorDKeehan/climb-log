class GetMainDataViewResponse {
  final int loginId;
  final int year;
  final int week;
  final int points;
  final int ascents;
  final int numOfClimbsLeft;
  final int pointRank;
  final int ascentRank;
  final int numOfClimbsLeftRank;

  GetMainDataViewResponse({
    required this.loginId,
    required this.year,
    required this.week,
    required this.points,
    required this.ascents,
    required this.numOfClimbsLeft,
    required this.pointRank,
    required this.ascentRank,
    required this.numOfClimbsLeftRank,
  });

  factory GetMainDataViewResponse.fromJson(Map<String, dynamic> json) {
    return GetMainDataViewResponse(
      loginId: json['loginId'],
      year: json['year'],
      week: json['week'],
      points: json['points'],
      ascents: json['ascents'],
      numOfClimbsLeft: json['numOfClimbsLeft'],
      pointRank: json['pointRank'],
      ascentRank: json['ascentRank'],
      numOfClimbsLeftRank: json['numOfClimbsLeftRank'],
    );
  }
}