import 'package:flutter/material.dart';
import 'package:agriplant/widgets/cart_item.dart';
import '../services/cart/cart_service.dart';
import '../services/order/order_service.dart';
import '../widgets/order_item.dart';
import '../models/product.dart'; // Import the Product class
import '../models/order.dart' as LocalOrder;
import 'checkout_page.dart'; // Import your local Order class and use an alias

// ... imports

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Stream<List<LocalOrder.Order>> ordersStream;

  @override
  void initState() {
    super.initState();
    ordersStream = OrderService().getOrdersStream();
  }
  Future<void> _confirmCheckout() async {
    // Show a confirmation dialog
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Checkout'),
        content: const Text('Are you sure you want to proceed to checkout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Proceed'),
          ),
        ],
      ),
    );

    // If the user confirms, navigate to the CheckoutPage
    if (confirm == true) {
      // Get cart items from CartService
      final cartItems = CartService().getCartItems();

      // Navigate to the CheckoutPage with the actual cart items
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CheckoutPage(checkoutItems: cartItems),
        ),
      );

      // Optionally, you can clear the cart after navigating to CheckoutPage
      CartService().clearCart();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<LocalOrder.Order>>(
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
          } else {
            final List<LocalOrder.Order> orders = snapshot.data ?? [];
            final cartItems = CartService().getCartItems();

            return ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                _buildHistoricalOrders(orders),
                _buildCurrentCart(cartItems),
                _buildCheckoutButton(cartItems),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildHistoricalOrders(List<LocalOrder.Order> orders) {
    if (orders.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Historical Orders',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...orders.map(
                (order) => Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: OrderItem(order: order),
            ),
          ),
          const Divider(),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildCurrentCart(List<Product> cartItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Current Cart',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        if (cartItems.isNotEmpty)
          ...cartItems.map(
                (product) => CartItem(cartItem: product),
          )
        else
          const Center(child: Text('No items in the cart')),
      ],
    );
  }

  Widget _buildCheckoutButton(List<Product> cartItems) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: ElevatedButton(
        onPressed:  cartItems.isNotEmpty ? () => _confirmCheckout() : null,
        child: Text('Checkout'),
      ),
    );
  }

  Future<void> _handleCheckout(List<Product> cartItems) async {
    // Place the order using the OrderService (if needed)
    await OrderService().placeOrder(cartItems);

    // Navigate to the CheckoutPage with the actual cart items
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CheckoutPage(checkoutItems: cartItems),
      ),
    );

    // Rebuild the widget tree to reflect the updated cart
    setState(() {
      // Optionally, you can clear the cart after placing the order
      CartService().clearCart();
    });

    // Show a SnackBar to notify that checkout was successful
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Checkout successful!'),
      ),
    );
  }
}
