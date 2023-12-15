import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../components/message_button.dart';
import '../../models/product.dart';
import '../../models/user.dart';
import '../../services/product/product_service.dart';
import '../similar_products.dart';

class ProductDetailsDesign extends StatelessWidget {
  final Product product;
  final bool showMore;
  final TapGestureRecognizer readMoreGestureRecognizer;
  final MessageButton messageButton;

  const ProductDetailsDesign({
    Key? key,
    required this.product,
    required this.showMore,
    required this.readMoreGestureRecognizer,
    required this.messageButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          height: 250,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(product.image),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Text(
          product.name,
          style: Theme.of(context).textTheme.headline6,
        ),
        Text(
          "Posted by: ${product.postedByUser?.displayName ?? 'Unknown User'}",
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
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
                    text: "\₱${product.price}",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  TextSpan(
                    text: "/${product.unit}",
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            )
          ],
        ),
        // ... other details
        Text(
          "Description",
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyText1,
            children: [
              TextSpan(
                text: showMore
                    ? product.description
                    : product.description.length > 100
                    ? '${product.description.substring(0, product.description.length - 100)}...'
                    : product.description,
              ),
              TextSpan(
                recognizer: readMoreGestureRecognizer,
                text: showMore ? " Read less" : " Read more",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Similar Products",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Container(

          // Adjust the height accordingly
          height: 400,
          child: FutureBuilder<List<Product>>(
            future: ProductService().fetchSimilarProducts(product),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No similar products found.');
              } else {
                List<Product> similarProducts = snapshot.data!;

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: similarProducts.length,
                  itemBuilder: (context, index) {
                    Product similarProduct = similarProducts[index];

                    return SimilarProductCard(
                      product: similarProduct,
                    );
                  },
                );
              }
            },
          ),
        ),
        const SizedBox(height: 20),
        // Display the MessageButton with the user who posted the product
        messageButton,
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(IconlyLight.bag2),
          label: const Text("Add to cart"),
        ),
      ],
    );
  }
}
