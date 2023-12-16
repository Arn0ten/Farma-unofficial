// product_details_page.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/cart/cart_service.dart';
import '../widgets/designs/product_details_design.dart';
import 'cart_page.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late TapGestureRecognizer readMoreGestureRecognizer;
  bool showMore = false;
  bool addingToCart = false; // Track whether the product is being added to the cart

  void addToCart() {
    // Add the product to the cart
    CartService().addToCart(widget.product);

    // Navigate to the cart page after adding the product

  }

  @override
  void initState() {
    super.initState();
    readMoreGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        setState(() {
          showMore = !showMore;
        });
      };
  }

  @override
  void dispose() {
    super.dispose();
    readMoreGestureRecognizer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark),
          ),
        ],
      ),
      body: ProductDetailsDesign(
        product: widget.product,
        showMore: showMore,
        readMoreGestureRecognizer: readMoreGestureRecognizer,
        addToCart: addToCart,
        addingToCart: addingToCart,
      ),
    );
  }
}
