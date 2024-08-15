class Phone {
  String id;
  String name;
  String? color;
  String? capacity;
  // double? price;
  String? price;
  String? generation;
  // int? screenSize;
  String? screenSize;
  Map<dynamic, dynamic> additionalData; // To store any additional fields

  Phone({
    required this.id,
    required this.name,
    this.color,
    this.capacity,
    this.price,
    this.generation,
    this.screenSize,
    required this.additionalData,
  });

  factory Phone.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    // Normalize the keys by making them lowercase or using a map for specific keys
    String? getValue(Map map, List<String> keys) {
      for (String key in keys) {
        if (map.containsKey(key)) {
          return map[key]?.toString();
        }
      }
      return null;
    }

    // Collect additional data that's not specifically mapped
    Map collectAdditionalData(
        Map<dynamic, dynamic> map, List<String> knownKeys) {
      final additionalData = {};
      map.forEach((key, value) {
        if (!knownKeys.contains(key)) {
          additionalData[key] = value;
        }
      });
      return additionalData;
    }

    return Phone(
      id: json['id'],
      name: json['name'],
      color: getValue(data, ['color', 'Color']),
      capacity: getValue(data, ['capacity', 'Capacity']),
      price: data['price'] is double
          ? data['price']
          : (data['price'] as num?)?.toDouble(),
      generation: getValue(data, ['generation', 'Generation']),
      screenSize: data['screen size'] is int
          ? data['screen size']
          : (data['screen size'] is double
              ? (data['screen size'] as double).toInt()
              : null),
      additionalData: collectAdditionalData(data, [
        'color',
        'Color',
        'capacity',
        'Capacity',
        'price',
        'generation',
        'Generation',
        'screen size'
      ]),
    );
  }

  // Method to convert all properties to a map
  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'Name': name,
      'Color': color,
      'Capacity': capacity,
      'Price': price,
      'Generation': generation,
      'Screen Size': screenSize,
      ...additionalData, // Include any additional fields
    };
  }

  // Method to convert all properties to a JSON-valid map
  Map<String, dynamic> toJsonMap() {
    return {
      'id': id,
      'name': name,
      'data': {
        'color': color,
        'capacity': capacity,
        'price': price,
        'generation': generation,
        'screenSize': screenSize,
        ...additionalData, // Include any additional fields under 'data'
      },
    };
  }
}

// Model variety: https://chatgpt.com/c/213c9ecb-717e-4161-b044-bed1e1177c32
// Model variety: https://chatgpt.com/share/bd910828-7127-454d-956e-127d7851b3be
// toMap(): https://chatgpt.com/c/b29834a7-5bba-40cf-ad03-737cce1a197f