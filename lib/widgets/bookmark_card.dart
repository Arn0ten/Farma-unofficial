import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import '../models/product.dart';
import '../services/product/product_service.dart';
import '../pages/product_details_page.dart';

class BookmarkProductCard extends StatelessWidget {
  final String productId;

  const BookmarkProductCard({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('products').doc(productId).get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          return Text('Product not found');
        }

        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

        return Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          elevation: 0.1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 92,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: _getImageProvider(data['image']),
                    fit: BoxFit.cover,
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
                        data['name'],
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLines: 2,
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
                                      text: "₱${data['price']?.toStringAsFixed(2) ?? '0.00'}",
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    TextSpan(
                                      text: "/",
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                    TextSpan(
                                      text: data['unit'] ?? '',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: IconButton.filled(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                _removeBookmark(context, productId);
                              },
                              iconSize: 18,
                              icon: const Icon(IconlyBold.closeSquare),
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
        );
      },
    );
  }

  ImageProvider<Object> _getImageProvider(String imagePath) {
    if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    } else if (imagePath.startsWith('assets/')) {
      return AssetImage(imagePath);
    } else {
      String relativePath = imagePath.split('/cache/').last;
      return AssetImage(relativePath);
    }
  }

  Future<void> _removeBookmark(BuildContext context, String productId) async {
    try {
      // Get the current user
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Remove bookmark
        await FirebaseFirestore.instance
            .collection('bookmarks')
            .where('productId', isEqualTo: productId)
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

        print('Bookmark removed successfully.');
      } else {
        // Handle the case when the user is not authenticated
        print('User is not authenticated.');
      }
    } catch (error) {
      print('Error removing bookmark: $error');
      // Handle the error as needed
    }
  }
}
