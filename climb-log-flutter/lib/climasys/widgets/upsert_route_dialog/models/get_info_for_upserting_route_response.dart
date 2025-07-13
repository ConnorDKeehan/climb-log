import 'dart:core';
import 'package:climasys/climasys/api/models/competition.dart';
import 'package:climasys/climasys/api/models/grade.dart';
import 'package:climasys/climasys/api/models/sector.dart';

class GetInfoForUpsertingRouteQueryResponse {
  final List<Grade> grades;
  final List<Grade> standardGrades;
  final List<Competition> competitions;
  final List<Sector> sectors;
  final Grade? currentGrade;
  final Grade? currentStandardGrade;
  final Competition? currentCompetition;
  final Sector? currentSector;
  final int? currentPointValue;

  GetInfoForUpsertingRouteQueryResponse( {
    required this.grades,
    required this.standardGrades,
    required this.competitions,
    required this.sectors,
    required this.currentGrade,
    required this.currentStandardGrade,
    required this.currentCompetition,
    required this.currentSector,
    required this.currentPointValue
  });

  factory GetInfoForUpsertingRouteQueryResponse.fromJson(Map<String, dynamic> json) {

    List<Sector> sectors = (json['sectors'] as List<dynamic>)
        .map((sectorJson) => Sector.fromJson(sectorJson as Map<String, dynamic>))
        .toList();

    List<Grade> grades = (json['grades'] as List<dynamic>)
        .map((gradeJson) => Grade.fromJson(gradeJson as Map<String, dynamic>))
        .toList();

    List<Grade> standardGrades = (json['standardGrades'] as List<dynamic>)
        .map((standardGradesJson) => Grade.fromJson(standardGradesJson as Map<String, dynamic>))
        .toList();

    List<Competition> competitions = (json['competitions'] as List<dynamic>)
        .map((competitionJson) => Competition.fromJson(competitionJson as Map<String, dynamic>))
        .toList();

    return GetInfoForUpsertingRouteQueryResponse(
        grades: grades,
        standardGrades: standardGrades,
        sectors: sectors,
        competitions: competitions,
        currentGrade: json['currentGrade'] != null ? Grade.fromJson(json['currentGrade']) : null,
        currentStandardGrade: json['currentStandardGrade'] != null
            ? Grade.fromJson(json['currentStandardGrade']) : null,
        currentCompetition: json['currentCompetition'] != null
            ? Competition.fromJson(json['currentCompetition']) : null,
        currentSector: json['currentSector'] != null
            ? Sector.fromJson(json['currentSector']) : null,
        currentPointValue: json['currentPointValue']
    );
  }
}
