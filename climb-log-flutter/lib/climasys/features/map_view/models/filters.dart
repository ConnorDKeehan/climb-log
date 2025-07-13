import 'grade.dart';

class Filters {
  List<Grade> availableGrades;
  List<String> selectedGrades;
  List<Grade> availableStandardGrades;
  Grade? minSelectedStandardGrade;
  Grade? maxSelectedStandardGrade;
  bool showAscended;
  bool filtersApplied;
  bool applyStandardGradeFilter;
  int? competitionId;

  Filters({
    required this.availableGrades,
    required this.selectedGrades,
    required this.availableStandardGrades,
    required this.minSelectedStandardGrade,
    required this.maxSelectedStandardGrade,
    required this.showAscended,
    this.filtersApplied = false,
    this.applyStandardGradeFilter = false,
    this.competitionId
  });

  @override
  String toString() {
    if(minSelectedStandardGrade != null) {
      String min = minSelectedStandardGrade!.gradeName;
      return '{minSelectedStandardGrade: $min';
    }

    return 'min is null';
  }
}
