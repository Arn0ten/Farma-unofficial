import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product/product_service.dart';
import '../widgets/designs/explore_page_design.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> searchResults = [];
  late List<Product> allProducts; // To store all products initially

  @override
  void initState() {
    super.initState();
    // Fetch all products initially
    ProductService().getProducts().then((products) {
      setState(() {
        allProducts = products;
        searchResults = allProducts;
      });
    }).catchError((error) {
      print('Error fetching all products: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExplorePageDesign.buildExplorePage(
      _searchController,
      searchResults,
      ProductService().getProductsStream(),
      context,
      searchProducts,
    );
  }

  void searchProducts(String query) {
    // Use a filtering function based on your search algorithm
    // For simplicity, we'll use a basic case-insensitive substring matching
    List<Product> filteredResults = allProducts
        .where((product) =>
        product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      searchResults = filteredResults;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
