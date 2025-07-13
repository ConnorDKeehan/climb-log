// models/route.dart
class Route {
  final int id;
  num xCord;
  num yCord;
  final String gradeName;
  final int gradeOrder;
  final String? standardGradeName;
  final int? standardGradeOrder;
  final String color;
  final bool hasAscended;
  final int? competitionId;
  final int? sectorId;
  final String? sectorName;
  bool isSelected;

  Route({
    required this.id,
    required this.xCord,
    required this.yCord,
    required this.gradeName,
    required this.gradeOrder,
    required this.standardGradeName,
    required this.standardGradeOrder,
    required this.color,
    required this.hasAscended,
    required this.competitionId,
    required this.sectorId,
    required this.sectorName,
    this.isSelected = false
  });

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      id: json['id'],
      xCord: json['xCord'],
      yCord: json['yCord'],
      gradeName: json['gradeName'],
      gradeOrder: json['gradeOrder'],
      standardGradeName: json['standardGradeName'],
      standardGradeOrder: json['standardGradeOrder'],
      color: json['color'],
      hasAscended: json['hasAscended'],
      competitionId: json['competitionId'],
      sectorId: json['sectorId'],
      sectorName: json['sectorName']
    );
  }
}
