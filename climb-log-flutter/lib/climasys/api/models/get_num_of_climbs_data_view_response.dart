class GetNumOfClimbsDataViewResponse {
  final int rank;
  final String name;
  final int numOfClimbs;

  GetNumOfClimbsDataViewResponse({
    required this.rank,
    required this.name,
    required this.numOfClimbs
  });

  factory GetNumOfClimbsDataViewResponse.fromJson(Map<String, dynamic> json) {
    return GetNumOfClimbsDataViewResponse(
      rank: json['rank'],
      name: json['name'],
        numOfClimbs: json['numOfClimbs']
    );
  }
}