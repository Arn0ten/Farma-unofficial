import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../models/order.dart'as LocalOrder;
import '../../models/product.dart';
import '../../pages/checkout_page.dart';
import '../../services/cart/cart_service.dart';
import '../../services/order/order_service.dart';
import '../cart_item.dart';
import '../order_item.dart';
// Import your local Order class and use an alias

class CartPageDesign {
  final Stream<List<LocalOrder.Order>> ordersStream;
  final List<Product> cartItems;

  CartPageDesign({required this.ordersStream, required this.cartItems});

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: StreamBuilder<List<LocalOrder.Order>>(
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

                  return ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 16, bottom: 60), // Adjust bottom padding
                    children: [
                      _buildHistoricalOrders(orders),
                      _buildCurrentCart(cartItems),
                    ],
                  );
                }
              },
            ),
          ),

          // Positioned widget to place Checkout button at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildCheckoutButton(cartItems, context),
          ),
        ],
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



  Widget _buildCheckoutButton(List<Product> cartItems, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: InkWell(
        onTap: cartItems.isNotEmpty ? () => _confirmCheckout(context) : null,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: cartItems.isNotEmpty ? Colors.green : Colors.grey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              'Checkout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmCheckout(BuildContext context) async {
    if (cartItems.isNotEmpty) {
      // Show a confirmation dialog using AwesomeDialog
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.SCALE,
        title: 'Confirm Checkout',
        desc: 'Are you sure you want to proceed to checkout?',
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          await _handleCheckout(cartItems, context);
        },
      )..show();
    }
  }

  Future<void> _handleCheckout(List<Product> cartItems, BuildContext context) async {
    // Place the order using the OrderService (if needed)
    await OrderService().placeOrder(cartItems);

    // Show an AwesomeDialog to notify that checkout was successful
    AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.SCALE,
      title: 'Checkout Successful',
      desc: 'Your order has been placed successfully!',
      btnOkOnPress: () {
        // Navigate to the CheckoutPage with the actual cart items
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CheckoutPage(checkoutItems: cartItems),
          ),
        );

        // Rebuild the widget tree to reflect the updated cart

          // Optionally, you can clear the cart after placing the order
          CartService().clearCart();

      },
    )..show();
  }

}