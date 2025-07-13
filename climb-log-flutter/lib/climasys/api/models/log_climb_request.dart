// models/route.dart
class LogClimbRequest {
  final int routeId;
  final int? difficultyForGradeId;
  final int? attemptCount;
  final String? notes;

  LogClimbRequest({
    required this.routeId,
    required this.difficultyForGradeId,
    required this.attemptCount,
    required this.notes
  });

  Map<String, dynamic> toJson() => {
    'routeId': routeId,
    'difficultyForGradeId': difficultyForGradeId,
    'attemptCount': attemptCount,
    'notes': notes
  };
}
