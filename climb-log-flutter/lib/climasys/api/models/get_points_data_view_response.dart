class GetPointsDataViewResponse {
  final int rank;
  final String name;
  final int points;

  GetPointsDataViewResponse({
    required this.rank,
    required this.name,
    required this.points,
  });

  factory GetPointsDataViewResponse.fromJson(Map<String, dynamic> json) {
    return GetPointsDataViewResponse(
      rank: json['rank'],
      name: json['name'],
      points: json['points'],
    );
  }
}