class GetAscentsGroupedByGradeByDateResponse {
  final DateTime date;
  final int week;
  final int month;
  final int year;
  final int numOfAscents;

  GetAscentsGroupedByGradeByDateResponse({
    required this.date,
    required this.week,
    required this.month,
    required this.year,
    required this.numOfAscents
  });

  factory GetAscentsGroupedByGradeByDateResponse.fromJson(Map<String, dynamic> json) {
    return GetAscentsGroupedByGradeByDateResponse(
      date: json['date'],
      week: json['week'],
      month: json['month'],
      year: json['year'],
      numOfAscents: json['numOfAscents']
    );
  }
}