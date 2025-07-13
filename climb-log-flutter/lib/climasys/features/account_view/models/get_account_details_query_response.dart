class GetAccountDetailsQueryResponse {
  final String? email;
  final String? friendlyName;
  final String userName;
  final String? profilePictureUrl;
  final String? bioText;
  final String? dateCreated;

  GetAccountDetailsQueryResponse({
    required this.email,
    required this.friendlyName,
    required this.userName,
    required this.profilePictureUrl,
    required this.bioText,
    required this.dateCreated
  });

  factory GetAccountDetailsQueryResponse.fromJson(Map<String, dynamic> json) {
    return GetAccountDetailsQueryResponse(
      email: json['email'],
      friendlyName: json['friendlyName'],
      userName: json['userName'],
      profilePictureUrl: json['profilePictureUrl'],
      bioText: json['bioText'],
      dateCreated: json['dateCreated']
    );
  }
}