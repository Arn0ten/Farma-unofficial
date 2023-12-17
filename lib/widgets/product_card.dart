// Import necessary packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import '../models/product.dart';
import '../pages/product_details_page.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);
  final Product product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _bookmarksCollection =
  FirebaseFirestore.instance.collection('bookmarks');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to product details page
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductDetailsPage(product: widget.product),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        elevation: 0.1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 92,
              alignment: Alignment.topRight,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: _getImageProvider(widget.product.image),
                  fit: BoxFit.cover,
                ),
              ),
              child: SizedBox(
                width: 30,
                height: 30,
                child: StreamBuilder(
                  stream: _bookmarksCollection
                      .where('productId', isEqualTo: widget.product.id)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    bool isBookmarked = snapshot.hasData &&
                        snapshot.data!.docs.isNotEmpty;

                    return IconButton(
                      onPressed: () {
                        _toggleBookmark(isBookmarked);
                      },
                      iconSize: 18,
                      icon: isBookmarked
                          ? const Icon(IconlyBold.bookmark)
                          : const Icon(IconlyLight.bookmark),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      widget.product.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 2, // Limit the number of lines for the product name
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 32,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "₱${widget.product.price.toStringAsFixed(2)}", // Format as a string with 2 decimal places
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  TextSpan(
                                    text: "/",
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  TextSpan(
                                    text: widget.product.unit,
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: IconButton.filled(
                            padding: EdgeInsets.zero,
                            onPressed: () {

                            },
                            iconSize: 18,
                            icon: const Icon(Icons.add),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ImageProvider<Object> _getImageProvider(String imagePath) {
    if (imagePath.startsWith('http')) {
      // Assume it's a network image
      return NetworkImage(imagePath);
    } else if (imagePath.startsWith('assets/')) {
      // Assume it's a local asset
      return AssetImage(imagePath);
    } else {
      // Assuming imagePath is a local cache path
      // Modify this part based on your actual path structure
      String relativePath = imagePath.split('/cache/').last;
      return AssetImage(relativePath);
    }
  }
  void _toggleBookmark(bool isBookmarked) async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      if (isBookmarked) {
        // Remove bookmark
        await _bookmarksCollection
            .where('productId', isEqualTo: widget.product.id)
            .where('userId', isEqualTo: currentUser.uid)
            .get()
            .then((snapshot) {
          for (DocumentSnapshot doc in snapshot.docs) {
            doc.reference.delete();
          }
        });

        // Show SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product removed from bookmarks.'),
          ),
        );
      } else {
        // Add bookmark
        await _bookmarksCollection.add({
          'productId': widget.product.id,
          'userId': currentUser.uid,
        });

        // Show SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product added to bookmarks.'),
          ),
        );
      }
    } else {
      // Handle the case when the user is not authenticated
      print('User is not authenticated.');
    }
  }

}
