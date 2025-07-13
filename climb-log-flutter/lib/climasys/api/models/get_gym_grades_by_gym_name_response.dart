import 'package:climasys/climasys/api/models/grade.dart';

class GetGymGradesByGymNameResponse {
  final List<Grade> grades;
  final List<Grade> standardGrades;

  GetGymGradesByGymNameResponse({required this.grades, required this.standardGrades});

  factory GetGymGradesByGymNameResponse.fromJson(Map<String, dynamic> json) {
    return GetGymGradesByGymNameResponse(
        grades: (json['grades'] as List<dynamic>)
          .map((e) => Grade.fromJson(e))
          .toList(),
        standardGrades: (json['standardGrades'] as List<dynamic>)
          .map((e) => Grade.fromJson(e))
          .toList(),
    );
  }
}