import 'package:agriplant/pages/users_profile_page.dart';
import 'package:agriplant/widgets/designs/explore_page_design.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth/auth_service.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  Stream<List<Map<String, dynamic>>>? searchResultsStream;
  final AuthService _authService =
      AuthService(); // Add this line to create an instance of AuthService

  String currentUserUid = "";

  void searchUsers(String searchTerm) {
    setState(() {
      searchResultsStream = _authService.searchUsers(searchTerm).asStream();
    });
  }

  void navigateToUserProfile(
      BuildContext context, Map<String, dynamic> userData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfilePage(user: userData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initialize currentUserUid if not already initialized
    if (currentUserUid.isEmpty) {
      currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? "";
    }

    return ExplorePageDesign.buildExplorePage(
      _searchController,
      searchResults,
      searchResultsStream,
      context,
      searchUsers,
      navigateToUserProfile,
      currentUserUid, // Pass the currentUserUid
    );
  }
}
