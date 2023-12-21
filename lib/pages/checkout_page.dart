import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/cart/cart_service.dart';
import '../widgets/cart_item.dart';

class CheckoutPage extends StatefulWidget {
  final List<Product> checkoutItems;

  CheckoutPage({Key? key, required this.checkoutItems}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          _buildCheckoutItems(),
          const SizedBox(height: 20),
          _buildTotal(),
          const SizedBox(height: 15),
          _buildPlaceOrderButton(),
        ],
      ),
    );
  }

  Widget _buildCheckoutItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Checkout Items',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        if (widget.checkoutItems.isNotEmpty)
          ...widget.checkoutItems.map(
                (product) => CartItem(cartItem: product),
          )
        else
          const Text("No items in the checkout"),
      ],
    );
  }

  Widget _buildTotal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total: \₱${calculateTotal(widget.checkoutItems)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceOrderButton() {
    final bool hasItemsInCheckout = widget.checkoutItems.isNotEmpty;

    return ElevatedButton(
      onPressed: hasItemsInCheckout ? () => _confirmPlaceOrder() : null,
      child: Text('Place Order'),
    );
  }

  Future<void> _confirmPlaceOrder() async {
    // Show a confirmation dialog using AwesomeDialog
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,  // Use DialogType.INFO instead of DialogType.QUESTION
      animType: AnimType.SCALE,
      title: 'Confirm Order',
      desc: 'Are you sure you want to place this order?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await _placeOrder();
      },
    )..show();
  }

  Future<void> _placeOrder() async {
    try {
      // Implement the logic to place the order or perform other checkout actions
      // For example, you can call a method in OrderService to place the order.
      // await OrderService().placeOrder(widget.checkoutItems);

      setState(() {
        // Optionally, you can clear the cart after placing the order
        CartService().clearCart();
      });


      // Show a SnackBar to notify that checkout was successful
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Order placed successfully!'),
        ),
      );

      // Optionally, you can navigate to a success page or perform any other action
    } catch (e) {
      // Handle the error (e.g., show an error message)
      print('Error placing order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error placing order. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String calculateTotal(List<Product> items) {
    // Calculate the total amount based on the checkout items
    double total = 0.0;
    for (var item in items) {
      total += item.price * item.quantity;
    }
    return total.toStringAsFixed(2);
  }
}
