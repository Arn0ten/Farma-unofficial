// explore_page_design.dart
import 'package:flutter/material.dart';
import 'package:agriplant/widgets/product_card.dart';
import '../../models/product.dart';


class ExplorePageDesign {
  static Widget buildExplorePage(
      TextEditingController searchController,
      List<Product> searchResults,
      Stream<List<Product>>? searchResultsStream,
      BuildContext context,
      ) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search product...",
                      isDense: true,
                      contentPadding: const EdgeInsets.all(12.0),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.all(
                          Radius.circular(99),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(99),
                        ),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      searchProducts(value, context);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Featured Products
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Featured Products",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () {},
                child: const Text("See all"),
              ),
            ],
          ),
          // GridView for Featured Products
          GridView.builder(
            itemCount: searchResults.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.9,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              return ProductCard(product: searchResults[index]);
            },
          ),
          // StreamBuilder for Search Results
          if (searchResultsStream != null)
            StreamBuilder<List<Product>>(
              stream: searchResultsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No results found.'),
                  );
                } else if (snapshot.hasData) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: snapshot.data![index]);
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
        ],
      ),
    );
  }

  static void searchProducts(String query, BuildContext context) {
    // Perform the search based on the query
    // You can use the ProductService to fetch search results
    // Update the searchResults list or stream accordingly
  }
}
