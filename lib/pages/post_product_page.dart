import 'dart:io';
import 'package:agriplant/services/product/product_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:agriplant/models/product.dart';

class PostProductPage extends StatefulWidget {
  @override
  _PostProductPageState createState() => _PostProductPageState();
}

class _PostProductPageState extends State<PostProductPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late double _price;
  late String _unit;
  late double _rating;
  File? _image;

  // Image picker function
  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add an image picker button
              ElevatedButton(
                onPressed: _getImage,
                child: const Text('Pick Image'),
              ),
              // Display the selected image
              if (_image != null)
                Image.file(
                  _image!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name for the product';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              // ... (other form fields)

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _postProduct();
                  }
                },
                child: const Text('Post Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _postProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create the Product instance after saving the form fields
      final productPost = Product(
        name: _name,
        description: _description,
        price: _price,
        unit: _unit,
        rating: _rating,
        image: _image?.path ?? '', // Use the image path if available
      );

      // Save the product post to Firestore or wherever you store your data
      final productService = ProductService();
      await productService.addProduct(productPost);

      // After saving, you can navigate back to the ExplorePage or update the UI
      Navigator.pop(context);
    }
  }
}
