import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:agriplant/models/product.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../widgets/designs/product_post_design.dart';


class ProductPostPage extends StatefulWidget {
  const ProductPostPage({Key? key}) : super(key: key);

  @override
  _ProductPostPageState createState() => _ProductPostPageState();
}

class _ProductPostPageState extends State<ProductPostPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();

  String _imagePath = '';

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProductPostPageDesign(
      nameController: _nameController,
      descriptionController: _descriptionController,
      priceController: _priceController,
      unitController: _unitController,
      imagePath: _imagePath,
      pickImage: _pickImage,
      postProduct: _validateAndSaveProduct, // Call your validation method here
    );
  }

  bool _validateForm() {
    // Implement your validation logic here
    // Return true if the form is valid, otherwise false
    return true;
  }

  void _validateAndSaveProduct() {
    if (_validateForm()) {
      _saveProduct();
    }
  }

  void _saveProduct() {
    Product newProduct = Product(
      name: _nameController.text,
      description: _descriptionController.text,
      image: _imagePath,
      price: double.parse(_priceController.text),
      unit: _unitController.text,
    );

    /// Save the 'newProduct' data to the database or perform necessary actions
    /// You can use Firebase, or any other database of your choice.
  }
}
