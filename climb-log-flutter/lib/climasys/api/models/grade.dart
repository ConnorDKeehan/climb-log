// models/route.dart
class Grade {
  final int id;
  final int gradeSystemId;
  final String gradeName;
  final int points;
  final String? color;
  final int gradeOrder;

  Grade( {
    required this.id,
    required this.gradeName,
    required this.gradeOrder,
    required this.color,
    required this.gradeSystemId,
    required this.points,
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
        id: json['id'],
        gradeSystemId: json['gradeSystemId'],
        gradeName: json['gradeName'],
        gradeOrder: json['gradeOrder'],
        color: json['color'],
        points: json['points']
    );
  }
}
