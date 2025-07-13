class Facility {
  final int id;
  final String? iconName;
  final String name;

  Facility({
    required this.id,
    required this.iconName,
    required this.name,
  });

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      id: json['id'],
      iconName: json['iconName'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'iconName': iconName,
    'name': name,
  };
}