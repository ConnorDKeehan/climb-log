class LoginResponse {
  final int loginId;
  final String displayName;
  final bool isGymAdmin;
  final String? profileImageUrl;

  LoginResponse({required this.loginId, required this.displayName, required this.isGymAdmin, this.profileImageUrl});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      loginId: json['loginId'],
      displayName: json['displayName'],
      isGymAdmin: json['isGymAdmin'],
      profileImageUrl: json['profileImageUrl'],
    );
  }
}