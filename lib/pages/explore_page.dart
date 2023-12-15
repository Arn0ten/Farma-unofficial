import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product/product_service.dart';
import '../widgets/designs/explore_page_design.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

// _ExplorePageState in explore_page.dart
class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  Stream<List<Product>>? searchResultsStream;

  @override
  void initState() {
    super.initState();
    // Fetch products stream when the page is initialized
    searchResultsStream = ProductService().getProductsStream();
  }

  @override
  Widget build(BuildContext context) {
    return ExplorePageDesign.buildExplorePage(
      _searchController,
      [],
      searchResultsStream,
      context,
    );
  }
}
