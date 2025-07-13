class Gym {
  final int id;
  final String name;
  final int gradeSystemId;
  final int? standardGradeSystemId;
  final String floorPlanImgUrl;
  final int viewBoxXSize;
  final int viewBoxYSize;
  final bool enableSectors;

  Gym({
    required this.id,
    required this.name,
    required this.gradeSystemId,
    required this.standardGradeSystemId,
    required this.floorPlanImgUrl,
    required this.viewBoxXSize,
    required this.viewBoxYSize,
    required this.enableSectors
  });

  factory Gym.fromJson(Map<String, dynamic> json) {
    return Gym(
      id: json['id'],
      name: json['name'],
      gradeSystemId: json['gradeSystemId'],
      standardGradeSystemId: json['standardGradeSystemId'],
      floorPlanImgUrl: json['floorPlanSvgUrl'],
      viewBoxXSize: json['viewBoxXSize'],
      viewBoxYSize: json['viewBoxYSize'],
      enableSectors: json['enableSectors']
    );
  }
}