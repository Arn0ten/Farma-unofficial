import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import '../../components/message_button.dart';
import '../../models/product.dart';
import '../../models/user.dart';
import '../../pages/cart_page.dart';
import '../../pages/product_details_page.dart';
import '../../services/product/product_service.dart';
import '../similar_products.dart';

class ProductDetailsDesign extends StatefulWidget {
  final Product product;
  final bool showMore;
  final TapGestureRecognizer readMoreGestureRecognizer;
  final VoidCallback addToCart;
  final bool addingToCart;

  final String receiverUserEmail;
  final String receiverUserId;

  const ProductDetailsDesign({
    Key? key,
    required this.product,
    required this.showMore,
    required this.readMoreGestureRecognizer,
    required this.addToCart,
    required this.addingToCart,

    required this.receiverUserEmail,
    required this.receiverUserId,
  }) : super(key: key);

  @override
  State<ProductDetailsDesign> createState() => _ProductDetailsDesignState();
}

class _ProductDetailsDesignState extends State<ProductDetailsDesign> {
  int quantity = 1; // Default quantity

  void _handleMessageButtonPress() {
    if (widget.receiverUserEmail.isNotEmpty && widget.receiverUserId.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MessageButton(
            receiverUserEmail: widget.receiverUserEmail,
            receiverUserId: widget.receiverUserId,
          ),
        ),
      );
    } else {
      print("Cannot open chat. Missing user details.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        // Product Image
        Container(
          height: 250,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.product.image),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        // Product Name
        Text(
          widget.product.name,
          style: Theme.of(context).textTheme.headline5!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),

        // Posted by User
        Text(
          "Posted by: ${widget.product.postedByUser.email}",
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),

        // Stock and Price
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Available in stock",
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "\₱${widget.product.price}",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  TextSpan(
                    text: "/${widget.product.unit}",
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            )
          ],
        ),

        // Description Section
        Text(
          "Description:",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10),
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyText1,
              children: [
                TextSpan(
                  text: widget.showMore
                      ? widget.product.description
                      : widget.product.description.length > 100
                      ? '${widget.product.description.substring(0, 100)}...'
                      : widget.product.description,
                ),
                if (widget.product.description.length > 100)
                  TextSpan(
                    recognizer: widget.readMoreGestureRecognizer,
                    text: widget.showMore ? " Read less" : " Read more",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Quantity Section
        Row(
          children: [
            Text(
              "Quantity: ",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (quantity > 1) {
                        setState(() {
                          quantity--;
                        });
                      }
                    },
                  ),
                  Text(
                    "$quantity",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),

        // Similar Products Section
        Text(
          "Similar Products: ",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Container(
          height: 200,
          child: FutureBuilder<List<Product>>(
            future: ProductService().fetchSimilarProducts(widget.product),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(strokeWidth: 2.0),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No similar products found.');
              } else {
                List<Product> similarProducts = snapshot.data!;
                return ListView.builder(
                  itemCount: similarProducts.length,
                  itemBuilder: (context, index) {
                    Product similarProduct = similarProducts[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailsPage(product: similarProduct),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(similarProduct.image),
                        ),
                        title: Text(similarProduct.name,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            'Price: \₱${similarProduct.price.toStringAsFixed(2)}'),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),

        const SizedBox(height: 20),

        // Message Button Section
        MessageButton(
          receiverUserEmail: widget.receiverUserEmail,
          receiverUserId: widget.receiverUserId,
        ),
        const SizedBox(height: 20),

        // Add to Cart Button
        FilledButton.icon(
          onPressed: widget.addingToCart
              ? null
              : () {
            widget.addToCart();
          },
          icon: const Icon(IconlyLight.bag2),
          label: widget.addingToCart
              ? const CircularProgressIndicator()
              : const Text("Add to Cart"),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
