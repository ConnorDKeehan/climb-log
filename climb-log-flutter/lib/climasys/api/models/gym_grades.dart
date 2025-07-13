class GymGrades {
  final List<String> grades;
  final List<String> standardGrades;

  GymGrades({required this.grades, required this.standardGrades});

  factory GymGrades.fromJson(Map<String, dynamic> json) {
    return GymGrades(
      grades: List<String>.from(json['grades']),
      standardGrades: List<String>.from(json['standardGrades'])
    );
  }
}