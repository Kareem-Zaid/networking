class Phone {
  String id;
  String name;
  String? color;
  String? capacity;
  double? price; // Added for cases where the price is present
  String? generation; // Added for cases where the generation is present
  int? screenSize; // Added for cases where the screen size is present

  Phone({
    required this.id,
    required this.name,
    this.color,
    this.capacity,
    this.price,
    this.generation,
    this.screenSize,
  });

  factory Phone.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return Phone(
      id: json['id'],
      name: json['name'],
      color: data['color'] as String?,
      // capacity: data['capacity'] != null ? data['capacity'].toString() : null,
      capacity: data['capacity']?.toString(),
      price: data['price'] is double
          ? data['price']
          : (data['price'] as num?)?.toDouble(),
      generation: data['generation'] as String?,
      screenSize: data['screen size'] is double
          ? (data['screen size'] as double).toInt()
          : (data['screen size'] as int?),
    );
  }
}

// https://chatgpt.com/c/213c9ecb-717e-4161-b044-bed1e1177c32
// https://chatgpt.com/share/bd910828-7127-454d-956e-127d7851b3be