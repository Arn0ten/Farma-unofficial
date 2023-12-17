// designs/profile_design.dart
import 'package:agriplant/components/circle_avatar_with_icon.dart';
import 'package:agriplant/components/text_box.dart';
import 'package:agriplant/pages/checkout_page.dart';
import 'package:agriplant/pages/orders_page.dart';
import 'package:agriplant/services/auth/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ProfileDesign {
  static Widget buildProfilePage({required Map<String, dynamic> userData, required Function signOut, required BuildContext context}) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        CircleAvatarWithIcon(
          icon: IconlyLight.profile,
          backgroundColor: Colors.white30,
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
        const SizedBox(height: 100),
        ListTile(
          title: const Text("Logout"),
          leading: const Icon(IconlyLight.logout),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  title: const Text("Logout"),
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        signOut();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AuthGate(),
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
  }
}
