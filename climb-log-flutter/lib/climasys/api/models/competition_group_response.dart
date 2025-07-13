class CompetitionGroupResponse {
  final int id;
  final String name;

  CompetitionGroupResponse({
    required this.id,
    required this.name,
  });

  factory CompetitionGroupResponse.fromJson(Map<String, dynamic> json) {
    return CompetitionGroupResponse(
      id: json['id'],
      name: json['name']
    );
  }
}