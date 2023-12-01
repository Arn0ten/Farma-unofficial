import 'package:agriplant/components/profile_design.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class UserProfilePage extends StatefulWidget {
  final Map<String, dynamic> user;

  const UserProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  Future<void> getUserData(String userEmail) async {
    final userDocument =
    await FirebaseFirestore.instance.collection("Users").doc(userEmail).get();
    // Access user data using userDocument.data()
    Map<String, dynamic> userData = userDocument.data() as Map<String, dynamic>;
    // Update the UI with user data
    setState(() {
      // Update state variables or use the data as needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(IconlyLight.arrowLeft2),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('User Profile'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(widget.user['email'])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            // Call the ProfileDesign
            return ProfileDesign.buildProfilePage(
              context: context,
              userData: userData,
              signOut: () {
                // Implement sign out logic
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error ${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
