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

    // Set state to trigger UI changes
    setState(() {
      addingToCart = true;
    });

    // Simulate a delay to show the loading indicator
    Future.delayed(const Duration(seconds: 2), () {
      // Reset addingToCart after the delay
      setState(() {
        addingToCart = false;
        // Display a snackbar message when the product is added to the cart
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product added to cart'),
            duration: Duration(seconds: 2),
          ),
        );
      });
    });
  }

  void toggleBookmark() {
    // TODO: Implement the logic to toggle the bookmark status
    // You can use the BookmarkService to handle bookmarking/unbookmarking
    // Example: BookmarkService().toggleBookmark(widget.product);

    // Placeholder comment, replace with your logic
    print('Bookmark icon pressed');
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
        actions: [
          IconButton(
            onPressed: toggleBookmark,
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

        receiverUserEmail: widget.product.postedByUser.email,
        receiverUserId: widget.product.postedByUser.uid,
      ),
    );
  }
}