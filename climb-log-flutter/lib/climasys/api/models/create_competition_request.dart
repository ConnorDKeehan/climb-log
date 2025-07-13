class CreateCompetitionRequest {
  final List<String> gymNames;
  final String competitionName;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<CompetitionGroupRequest> competitionGroupsRequest;

  CreateCompetitionRequest({
    required this.gymNames,
    required this.competitionName,
    this.startDate,
    this.endDate,
    required this.competitionGroupsRequest,
  });

  Map<String, dynamic> toJson() => {
    'gymNames': gymNames,
    'competitionName': competitionName,
    'startDate': startDate?.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'competitionGroupsRequest':
    competitionGroupsRequest.map((e) => e.toJson()).toList(),
  };
}

class CompetitionGroupRequest {
  final String name;
  final int? numberOfClimbsIncluded;

  CompetitionGroupRequest({
    required this.name,
    required this.numberOfClimbsIncluded,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'numberOfClimbsIncluded': numberOfClimbsIncluded,
  };
}
