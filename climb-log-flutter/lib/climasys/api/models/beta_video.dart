class BetaVideo {
  final int id;
  final int routeId;
  final String url;
  final String thumbnailUrl;

  BetaVideo({
    required this.id,
    required this.routeId,
    required this.url,
    required this.thumbnailUrl
  });

  factory BetaVideo.fromJson(Map<String, dynamic> json) {
    return BetaVideo(
        id: json['id'],
        routeId: json['routeId'],
        url: json['url'],
        thumbnailUrl: json['thumbnailUrl']
    );
  }
}
