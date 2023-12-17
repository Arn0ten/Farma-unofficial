import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/bookmark_card.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
      ),
      body: _buildBookmarkList(),
    );
  }

  Widget _buildBookmarkList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('bookmarks').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        List<String> bookmarkedProductIds = snapshot.data!.docs
            .map((doc) => doc['productId'] as String)
            .toList();

        return ListView.builder(
          itemCount: bookmarkedProductIds.length,
          itemBuilder: (context, index) {
            return BookmarkProductCard(
              productId: bookmarkedProductIds[index],
            );
          },
        );
      },
    );
  }
}
