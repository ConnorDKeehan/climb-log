// models/route.dart
class EditAccountDetailsRequest {
  final String friendlyName;
  final String? bioText;

  EditAccountDetailsRequest({
    required this.friendlyName,
    required this.bioText
  });

  Map<String, dynamic> toJson() => {
    'friendlyName': friendlyName,
    'bioText': bioText
  };
}