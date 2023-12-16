class Product {
  final String id;
  final String name;
  final String description;
  final String image;
  final double price;
  final String unit;


  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.unit,

  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      unit: map['unit'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'unit': unit,

    };
  }
}
