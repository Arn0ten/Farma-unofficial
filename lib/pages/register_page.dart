import 'package:agriplant/components/my_button.dart';
import 'package:agriplant/components/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final fullNameController = TextEditingController();
  final ageController = TextEditingController();
  final addressController = TextEditingController();
  final contactNumberController = TextEditingController();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fullNameController.dispose();
    ageController.dispose();
    addressController.dispose();
    contactNumberController.dispose();

    super.dispose();
  }

  Future<void> signUserUp() async {
    try {
      // Check if password and confirm password match
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password do not match. Try Again!'),
            duration: Duration(seconds: 3),
          ),
        );
        return; // Stop the registration process if passwords don't match
      }

      // Passwords match, proceed with user registration
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Store user details in Firestore using the email as the document ID
      await FirebaseFirestore.instance.collection("Users").doc(emailController.text).set({
        'email': emailController.text,
        'fullName': fullNameController.text.trim(),
        'address': addressController.text.trim(),
        'age': int.parse(ageController.text.trim()),
        'contactNumber': int.parse(contactNumberController.text.trim()),
        // Add other fields as needed
      });

      // Store additional user details in Firestore
      await addUserDetails(
        fullNameController.text.trim(),
        int.parse(ageController.text.trim()),
        addressController.text.trim(),
        int.parse(contactNumberController.text.trim()),
      );

      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred. Please try again.';

      if (e.code == 'email-already-in-use') {
        errorMessage = 'The email address is already in use. Please use a different email.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak. Please use a stronger password.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> addUserDetails(String fullName, int age, String address, int contactNumber) async {
    if (mounted) {
      await FirebaseFirestore.instance.collection('users').add({
        'fullName': fullName,
        'age': age,
        'address': address,
        'contactNumber': contactNumber,
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // welcome back, you've been missed!
                Text(
                  "Let's create!",
                  style: GoogleFonts.bebasNeue(
                    color: Colors.black,
                    fontSize: 25,
                  ),
                ),

                const SizedBox(height: 10),

                // fullname textfield
                MyTextField(
                  controller: fullNameController,
                  hintText: 'Full name',
                  obscureText: false,
                  prefixIcon: IconlyLight.profile,
                ),

                const SizedBox(height: 10),

                // age textfield
                MyTextField(
                  controller: ageController,
                  hintText: 'Age',
                  obscureText: false,
                  prefixIcon: IconlyLight.calendar,
                ),

                const SizedBox(height: 10),

                // address textfield
                MyTextField(
                  controller: addressController,
                  hintText: 'Address',
                  obscureText: false,
                  prefixIcon: IconlyLight.location,
                ),

                const SizedBox(height: 10),

                // contact number textfield
                MyTextField(
                  controller: contactNumberController,
                  hintText: 'Contact number',
                  obscureText: false,
                  prefixIcon: IconlyLight.call,
                ),

                const SizedBox(height: 10),

                // username textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  prefixIcon: IconlyLight.message,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  prefixIcon: IconlyLight.lock,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                  prefixIcon: IconlyLight.lock,
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  onTap: signUserUp, text: 'Create account',
                ),

                const SizedBox(height: 50),

                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 100),


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
