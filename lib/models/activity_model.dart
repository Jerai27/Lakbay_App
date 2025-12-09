class Activity {
  final String id;
  final String name;
  final String day;
  final String time;
  final String location;
  final int cost;

  Activity({
    required this.id,
    required this.name,
    required this.day,
    required this.time,
    required this.location,
    required this.cost,
  });

  // Copy with method for easy updates
  Activity copyWith({
    String? id,
    String? name,
    String? day,
    String? time,
    String? location,
    int? cost,
  }) {
    return Activity(
      id: id ?? this.id,
      name: name ?? this.name,
      day: day ?? this.day,
      time: time ?? this.time,
      location: location ?? this.location,
      cost: cost ?? this.cost,
    );
  }

  // Convert to JSON (for Firebase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'day': day,
      'time': time,
      'location': location,
      'cost': cost,
    };
  }

  // Create from JSON (for Firebase)
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      day: json['day'] ?? '',
      time: json['time'] ?? '',
      location: json['location'] ?? '',
      cost: (json['cost'] ?? 0).toInt(),
    );
  }
}
