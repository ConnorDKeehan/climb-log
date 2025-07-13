class CreatePushNotificationForGymCommand {
  final String title;
  final String body;
  final String gymName;

  CreatePushNotificationForGymCommand({
    required this.title,
    required this.body,
    required this.gymName,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'body': body,
    'gymName': gymName
  };
}