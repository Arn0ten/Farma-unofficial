import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/order.dart' as LocalOrder; // Import your local Order class
import '../../models/product.dart';

class OrderService {
  final CollectionReference _ordersCollection =
      FirebaseFirestore.instance.collection('orders');

  Stream<List<LocalOrder.Order>> getOrdersStream() {
    return _ordersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return LocalOrder.Order(
          id: doc.id,
          products: List<Product>.from(data['products']
              .map((productMap) => Product.fromMap(productMap))),
          date: (data['date'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }
}

// Fetch orders from Firestore using the OrderService
Stream<List<LocalOrder.Order>> ordersStream = OrderService().getOrdersStream();
