// models/route.dart
class MoveRouteRequest {
  final int routeId;
  final num xCord;
  final num yCord;

  MoveRouteRequest({
    required this.routeId,
    required this.xCord,
    required this.yCord
  });

  Map<String, dynamic> toJson() => {
    'routeId': routeId,
    'xCord': xCord,
    'yCord': yCord
  };
}
