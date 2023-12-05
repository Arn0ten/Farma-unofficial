import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agriplant/models/product.dart';

class ProductService {
  final CollectionReference _productsCollection =
  FirebaseFirestore.instance.collection('products');

  Future<List<Product>> getProducts() async {
    QuerySnapshot querySnapshot = await _productsCollection.get();
    List<Product> products = [];

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Product product = Product(
        name: data['name'],
        description: data['description'],
        image: data['image'],
        price: data['price'].toDouble(),
        unit: data['unit'],
      );
      products.add(product);
    });

    return products;
  }

  Future<void> addProduct(Product product, String userId) async {
    try {
      // Set the document ID explicitly to the product name
      await _productsCollection.doc(product.name).set({
        'userId': userId,
        'name': product.name,
        'description': product.description,
        'image': product.image,
        'price': product.price,
        'unit': product.unit,
        // Add other fields as needed
      });
    } catch (e) {
      // Handle errors, print or log them
      print('Error adding product: $e');
      throw e; // Rethrow the exception to notify the caller about the error
    }
  }

// Add other methods as needed, e.g., updateProduct, deleteProduct, etc.
}

