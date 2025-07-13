class GetCompetitionByGymQueryResponse {
  final int competitionId;
  final int? competitionGroupId;
  final String competitionName;
  final bool isUserEntered;
  final bool active;
  final int? singleGroupId;
  final DateTime? startDate;
  final DateTime? endDate;

  GetCompetitionByGymQueryResponse({
    required this.competitionId,
    this.competitionGroupId,
    required this.competitionName,
    required this.isUserEntered,
    required this.active,
    this.singleGroupId,
    this.startDate,
    this.endDate,
  });

  factory GetCompetitionByGymQueryResponse.fromJson(Map<String, dynamic> json) {
    return GetCompetitionByGymQueryResponse(
      competitionId: json['competitionId'],
      competitionGroupId: json['competitionGroupId'],
      competitionName: json['competitionName'],
      isUserEntered: json['isUserEntered'],
      active: json['active'],
      singleGroupId: json['singleGroupId'],
      startDate:
      json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate:
      json['endDate'] != null ? DateTime.parse(json['endDate']) : null,

    );
  }
}
