class Sector {
  final int id;
  final String name;
  final num xStart;
  final num xEnd;
  final num yStart;
  final num yEnd;

  Sector({
    required this.id,
    required this.name,
    required this.xStart,
    required this.xEnd,
    required this.yStart,
    required this.yEnd,
  });

  factory Sector.fromJson(Map<String, dynamic> json) {
    return Sector(
      id: json['id'],
      name: json['name'],
      xStart: json['xStart'],
      xEnd: json['xEnd'],
      yStart: json['yStart'],
      yEnd: json['yEnd'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'xStart': xStart,
    'xEnd': xEnd,
    'yStart': yStart,
    'yEnd': yEnd,
  };
}