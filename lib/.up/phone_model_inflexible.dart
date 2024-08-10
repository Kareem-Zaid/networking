class Phone {
  String id, name, color, capacity;

  Phone({
    required this.id,
    required this.name,
    required this.color,
    required this.capacity,
  });

  factory Phone.fromJson(Map<String, dynamic> json) {
    return Phone(
      id: json['id'],
      name: json['name'],
      color: json['data']['color'],
      capacity: json['data']['capacity'],
    );
  }
}
