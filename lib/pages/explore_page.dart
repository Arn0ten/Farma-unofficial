import 'package:agriplant/pages/users_profile_page.dart';
import 'package:agriplant/widgets/designs/explore_page_design.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  Stream<List<Map<String, dynamic>>>? searchResultsStream;

  // Function to search for users in Firestore
  void searchUsers(String searchTerm) {
    if (searchTerm.isEmpty) {
      setState(() {
        searchResultsStream = null;
      });
    } else {
      setState(() {
        searchResultsStream = FirebaseFirestore.instance
            .collection("Users")
            .where('fullName', isGreaterThanOrEqualTo: searchTerm)
            .where('fullName', isLessThan: searchTerm + 'z')
            .snapshots()
            .map((snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
      });
    }
  }

  void navigateToUserProfile(BuildContext context, Map<String, dynamic> userData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfilePage(user: userData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExplorePageDesign.buildExplorePage(
      _searchController,
      searchResults,
      searchResultsStream,
      context,
      searchUsers,
      navigateToUserProfile,
    );
  }
}
