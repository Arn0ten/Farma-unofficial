import 'package:agriplant/data/products.dart';
import 'package:agriplant/pages/checkout_page.dart';
import 'package:agriplant/widgets/cart_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final cartItems = products.take(4).toList();

  @override
  Widget build(BuildContext context) {
    final total =
        cartItems.map((cartItem) => cartItem.price).reduce((value, element) => value + element).toStringAsFixed(2);
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ...List.generate(
              cartItems.length,
              (index) {
                final cartItem = cartItems[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: CartItem(cartItem: cartItem),
                );
              },
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total (${cartItems.length} items)"),
                Text(
                  "\₱$total",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                )
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => const CheckOutPage()));
                },
                label: const Text("Proceed to Checkout"),
                icon: const Icon(IconlyBold.arrowRight),
              ),
            )
          ],
        ),
      ),
    );
  }
}
