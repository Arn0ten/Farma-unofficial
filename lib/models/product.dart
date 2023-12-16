class Product {
  final String id;
  final String name;
  final String description;
  final String image;
  final double price;
  final String unit;

  // Include user-related properties
  final PostedByUser postedByUser;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.unit,
    required this.postedByUser,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      unit: map['unit'] ?? '',
      postedByUser: PostedByUser.fromMap(map['postedByUser']),
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
      'postedByUser': postedByUser.toMap(),
    };
  }
}

class PostedByUser {
  final String uid;
  final String email;

  PostedByUser({
    required this.uid,
    required this.email,
  });

  factory PostedByUser.fromMap(Map<String, dynamic> map) {
    return PostedByUser(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
    };
  }
}
