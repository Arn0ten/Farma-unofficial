import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../components/message_button.dart';
import '../models/product.dart';
import '../widgets/designs/product_details_design.dart';

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
        messageButton: MessageButton(
          // Check if postedByUser is of type User before accessing its properties
          receiverUserEmail: widget.product.postedByUser is User
              ? (widget.product.postedByUser as User).email ?? 'Unknown Email'
              : 'Unknown Email',
          receiverUserId: widget.product.postedByUser is User
              ? (widget.product.postedByUser as User).uid ?? 'Unknown UID'
              : 'Unknown UID',
        ),
      ),
    );
  }
}
