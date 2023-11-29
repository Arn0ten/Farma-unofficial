import 'package:agriplant/components/text_box.dart';
import 'package:agriplant/pages/auth_page.dart';
import 'package:agriplant/pages/checkout_page.dart';
import 'package:agriplant/pages/login_page.dart';
import 'package:agriplant/pages/onboarding_page.dart';
import 'package:agriplant/pages/orders_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void signUserOut (){
    FirebaseAuth.instance.signOut();
  }
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("Users").doc(currentUser.email!).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 15),
                child: CircleAvatar(
                  radius: 62,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const CircleAvatar(
                    radius: 60,
                    foregroundImage: AssetImage(
                        'assets/profile.jpeg'),
                  ),
                ),
              ),
              Center(
                child: Text(
                   userData['fullName'],
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: Text(
                    'My details',
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              MyTextBox(
                text: userData['email'],
                sectionName: 'Email',
              ),

              MyTextBox(
                text: userData['fullName'],
                sectionName: 'Full Name',
              ),
              MyTextBox(
                text: userData['age'].toString(),
                sectionName: 'Age',
              ),

              MyTextBox(
                text: userData['address'],
                sectionName: 'Address',
              ),

              MyTextBox(
                text: userData['contactNumber'].toString(),
                sectionName: 'Contact Number',
              ),

              const SizedBox(height: 10),
              ListTile(
                title: const Text("My orders"),
                leading: const Icon(IconlyLight.bag),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrdersPage(),
                      ));
                },
              ),
              ListTile(
                title: const Text("My checkouts"),
                leading: const Icon(IconlyLight.bag2),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CheckOutPage(),
                      ));
                },
              ),ListTile(
                title: const Text("Bookmarks"),
                leading: const Icon(IconlyLight.bookmark),
                onTap: () {},
              ),
              ListTile(
                title: const Text("About us"),
                leading: const Icon(IconlyLight.infoSquare),
                onTap: () {},
              ),
              ListTile(
                title: const Text("Logout"),
                leading: const Icon(IconlyLight.logout),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0), // Adjust the value as needed
                        ),
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              signUserOut();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AuthPage(),
                                ),
                              );
                            },
                            child: const Text("Logout"),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),

            ],
          );
        }else if (snapshot.hasError) {
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