class AddRouteCommand {
  final String gymName;
  final double xCord;
  final double yCord;
  final int gradeId;
  final int? standardGradeId;
  final int? competitionId;
  final int pointValue;
  final int? sectorId;

  AddRouteCommand({
    required this.gymName,
    required this.xCord,
    required this.yCord,
    required this.gradeId,
    required this.pointValue,
    this.standardGradeId,
    this.competitionId,
    this.sectorId
  });

  Map<String, dynamic> toJson() =>
    {
      'gymName': gymName,
      'xCord': xCord,
      'yCord': yCord,
      'gradeId': gradeId,
      'pointValue': pointValue,
      'standardGradeId': standardGradeId,
      'competitionId': competitionId,
      'sectorId': sectorId
    };
}