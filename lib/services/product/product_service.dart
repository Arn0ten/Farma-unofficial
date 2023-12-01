import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agriplant/models/product.dart';

class ProductService {
  final CollectionReference _productsCollection =
  FirebaseFirestore.instance.collection('products');

  Future<void> addProduct(Product product) async {
    await _productsCollection.add({
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'unit': product.unit,
      'rating': product.rating,
      'image': product.image,
    });
  }

// Add other methods as needed, e.g., getProducts, updateProduct, etc.
}
