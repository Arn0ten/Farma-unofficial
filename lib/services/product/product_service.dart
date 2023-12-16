  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:agriplant/models/product.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:firebase_storage/firebase_storage.dart';
  import 'dart:io';

  class ProductService {
    final CollectionReference _productsCollection =
    FirebaseFirestore.instance.collection('products');
    final FirebaseStorage _storage = FirebaseStorage.instance;

    Future<List<Product>> getProducts() async {
      try {
        QuerySnapshot querySnapshot = await _productsCollection.get();
        List<Product> products = [];

        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          products.add(Product(
            id: doc.id,
            name: data['name'],
            description: data['description'],
            image: data['image'],
            price: data['price'].toDouble(),
            unit: data['unit'],
            postedByUser: PostedByUser.fromMap(data['postedByUser']),
          ));
        });

        return products;
      } catch (e) {
        print('Error getting products: $e');
        throw e;
      }
    }


    // Update the addProduct method in ProductService
    Future<void> addProduct(Product product) async {
      try {
        // Get the current user from Firebase Authentication
        User? currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser != null) {
          // Use the product name as the document ID
          await _productsCollection.doc(product.name).set({
            'name': product.name,
            'description': product.description,
            'image': product.image,
            'price': product.price,
            'unit': product.unit,
            'postedByUser': {
              'uid': currentUser.uid,
              'email': currentUser.email,
              'fullName': currentUser.displayName,
            },
          });
        } else {
          // Handle the case when the user is not authenticated
          print('User is not authenticated.');
        }
      } catch (e) {
        print('Error adding product: $e');
        throw e;
      }
    }

    Stream<List<Product>> getProductsStream() {
      return _productsCollection.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          return Product(
            id: doc.id,
            name: data['name'],
            description: data['description'],
            image: data['image'],
            price: data['price'].toDouble(),
            unit: data['unit'],
            postedByUser: PostedByUser.fromMap(data['postedByUser']),
          );
        }).toList();
      });
    }
    Future<List<Product>> fetchProducts() async {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('products').get();
      return snapshot.docs.map((doc) {
        return Product.fromMap({
          'id': doc.id,
          'name': doc['name'],
          'description': doc['description'],
          'price': doc['price']?.toDouble() ?? 0.0,
          'image': doc['image'],
          'unit': doc['unit'] ?? '',
        });
      }).toList();
    }

    Future<List<Product>> fetchSimilarProducts(Product product) async {
      try {
        QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('products')
            .where('unit', isEqualTo: product.unit)
            .get();

        return snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          return Product(
            id: doc.id,
            name: data['name'],
            price: data['price'].toDouble(),
            unit: data['unit'],
            description: data['description'],
            image: data['image'],
            postedByUser: PostedByUser.fromMap(data['postedByUser']),
          );
        }).toList();
      } catch (e) {
        print('Error fetching similar products: $e');
        throw e;
      }
    }

    Future<String> uploadImage(File imageFile) async {
      try {
        // Generate a unique ID for the image
        String imageId = DateTime.now() .millisecondsSinceEpoch.toString();

        // Create a reference for the image using a specific path (e.g., 'product_images/imageId.jpg')
        Reference storageReference = _storage.ref().child('product_images/$imageId.jpg');

        // Upload the image to Firebase Storage
        UploadTask uploadTask = storageReference.putFile(imageFile);

        // Get the task snapshot to track the upload progress
        TaskSnapshot taskSnapshot = await uploadTask;

        // Check if the upload is complete
        if (taskSnapshot.state == TaskState.success) {
          // Image upload successful, get the download URL
          String downloadUrl = await storageReference.getDownloadURL();
          return downloadUrl;
        } else {
          // Image upload failed, throw an error
          throw ('Image upload failed');
        }
      } catch (e) {
        print('Error uploading image: $e');
        throw e; // Re-throw the exception for the caller to handle
      }
    }

  // Add other methods as needed, e.g., updateProduct, deleteProduct, etc.
  }