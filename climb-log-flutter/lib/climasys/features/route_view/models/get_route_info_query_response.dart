import 'package:climasys/climasys/api/models/competition.dart';
import 'package:climasys/climasys/api/models/grade.dart';

class GetRouteInfoQueryResponse {
  final int id;
  final DateTime dateCreated;
  final String? difficultyConsensus;
  final int? averageAttemptCount;
  final Grade grade;
  final Grade? standardGrade;
  final int points;
  final Competition? competition;
  final List<DifficultyVote> difficultyVotes;
  final List<AttemptCount> attemptCounts;
  final List<UserInfoResponse> usersAscended;
  final List<String> notes;

  GetRouteInfoQueryResponse({
    required this.id,
    required this.dateCreated,
    required this.difficultyConsensus,
    required this.averageAttemptCount,
    required this.grade,
    required this.standardGrade,
    required this.points,
    required this.competition,
    required this.difficultyVotes,
    required this.attemptCounts,
    required this.usersAscended,
    required this.notes,
  });

  factory GetRouteInfoQueryResponse.fromJson(Map<String, dynamic> json) {
    return GetRouteInfoQueryResponse(
      id: json['id'],
      dateCreated: DateTime.parse(json['dateCreated']),
      difficultyConsensus: json['difficultyConsensus'],
      averageAttemptCount: json['averageAttemptCount'],
      grade: Grade.fromJson(json['grade']),
      standardGrade: json['standardGrade'] != null ? Grade.fromJson(json['standardGrade']) : null,
      points: json['points'],
      competition: json['competition'] != null ? Competition.fromJson(json['competition']) : null,
      difficultyVotes: (json['difficultyVotes'] as List)
          .map((e) => DifficultyVote.fromJson(e))
          .toList(),
      attemptCounts: (json['attemptCounts'] as List)
          .map((e) => AttemptCount.fromJson(e))
          .toList(),
      usersAscended: (json['usersAscended'] as List)
          .map((e) => UserInfoResponse.fromJson(e))
          .toList(),
      notes: List<String>.from(json['notes']),
    );
  }
}

class DifficultyVote {
  final String difficulty;
  final int count;

  DifficultyVote({
    required this.difficulty,
    required this.count,
  });

  factory DifficultyVote.fromJson(Map<String, dynamic> json) {
    return DifficultyVote(
      difficulty: json['key'],
      count: json['value'],
    );
  }
}

class AttemptCount {
  final int attemptNumber;
  final int count;

  AttemptCount({
    required this.attemptNumber,
    required this.count,
  });

  factory AttemptCount.fromJson(Map<String, dynamic> json) {
    return AttemptCount(
      attemptNumber: json['key'],
      count: json['value'],
    );
  }
}

class UserInfoResponse {
  final int id;
  final String displayName;
  final int? attemptCount;
  final String? difficultyForGrade;
  final String? notes;

  UserInfoResponse({
    required this.id,
    required this.displayName,
    required this.attemptCount,
    required this.difficultyForGrade,
    required this.notes
  });

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) {
    return UserInfoResponse(
      id: json['id'],
      displayName: json['displayName'],
      attemptCount: json['attemptCount'],
      difficultyForGrade: json['difficultyForGrade'],
      notes: json['notes'],
    );
  }
}