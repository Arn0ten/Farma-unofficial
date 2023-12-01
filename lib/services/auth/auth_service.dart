import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  //Instance of Firebase
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      ///Firestore Collection if no data
      _firestore.collection('Farma Users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,

      },SetOptions(merge: true));

      notifyListeners(); // Notify listeners when authentication changes
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle exceptions
      throw e;
    }
  }

  /// Sign up with email and password
  Future<UserCredential> signUpWithEmailAndPassword(
      String email,
      String password,
      String fullName,
      String address,
      int age,
      int contactNumber,
      ) async {
    try {
      /// Create a user in Firebase Authentication
      UserCredential userCredential =
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      ///Firestore Collection
      _firestore.collection('Farma Users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'fullName': fullName,
        'address': address,
        'age': age,
        'contactNumber': contactNumber,

      });



      /// Store user details in Firestore using the email as the document ID
      await FirebaseFirestore.instance.collection("Users").doc(email).set({
        'email': email,
        'fullName': fullName.trim(),
        'address': address.trim(),
        'age': age,
        'contactNumber': contactNumber,
        'searchField': generateSearchField(fullName.trim()),
      });

      notifyListeners(); // Notify listeners when authentication changes
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  /// Generate a search field from the user's full name
  String generateSearchField(String input) {
    return input.toLowerCase().split(' ').join('');
  }

  /// Sign out the user
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
  /// Fetch products from Firestore
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      // Example: Fetch products from a 'Products' collection
      QuerySnapshot<Map<String, dynamic>> productsSnapshot =
      await _firestore.collection('Products').get();

      // Convert the products to a list of maps
      List<Map<String, dynamic>> products =
      productsSnapshot.docs.map((doc) => doc.data()).toList();

      return products;
    } catch (e) {
      // Handle exceptions
      print("Error fetching products: $e");
      return [];
    }
  }
}
