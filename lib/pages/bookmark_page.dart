import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      // User is not authenticated, display a message or return an empty widget
      return Center(
        child: Text('Please log in to view bookmarks.'),
      );
    }

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('bookmarks')
          .where('userId', isEqualTo: currentUser.uid)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          // Handle error by displaying an error message to the user
          return Center(
            child: Text('Error fetching bookmarks: ${snapshot.error}'),
          );
        }

        List<String> bookmarkedProductIds = snapshot.data!.docs
            .map((doc) => doc['productId'] as String)
            .toList();

        if (bookmarkedProductIds.isEmpty) {
          // No bookmarks found for the current user
          return Center(
            child: Text('You have no bookmarks.'),
          );
        }

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