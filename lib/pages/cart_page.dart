import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agriplant/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import '../services/order/order_service.dart';
import '../widgets/order_item.dart';
import '../models/product.dart'; // Import the Product class
import '../models/order.dart' as LocalOrder; // Import your local Order class and use an alias

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Stream<List<LocalOrder.Order>> ordersStream; // Use the alias for the local Order class

  @override
  void initState() {
    super.initState();
    ordersStream = OrderService().getOrdersStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<LocalOrder.Order>>( // Use the alias for the local Order class
        stream: ordersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No orders found.'),
            );
          } else {
            final List<LocalOrder.Order> orders = snapshot.data!; // Use the alias for the local Order class
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ...List.generate(
                    orders.length,
                        (index) {
                      final LocalOrder.Order order = orders[index]; // Use the alias for the local Order class
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: OrderItem(order: order),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  // Other UI components
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
