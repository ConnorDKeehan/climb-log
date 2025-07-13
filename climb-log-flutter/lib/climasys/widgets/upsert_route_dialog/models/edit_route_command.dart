class EditRouteCommand {
  final int routeId;
  final int gradeId;
  final int? standardGradeId;
  final int? competitionId;
  final int? pointValue;
  final int? sectorId;

  EditRouteCommand({
    required this.routeId,
    required this.gradeId,
    this.standardGradeId,
    this.competitionId,
    this.pointValue,
    this.sectorId
  });

  Map<String, dynamic> toJson() =>
    {
      'routeId': routeId,
      'gradeId': gradeId,
      'standardGradeId': standardGradeId,
      'competitionId': competitionId,
      'pointValue': pointValue,
      'sectorId': sectorId
    };
}