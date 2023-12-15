import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
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
                      // searchUsers(value);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: IconButton(
                    onPressed: () {
                      // Add any filter functionality here
                    },
                    icon: const Icon(Icons.filter),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          SizedBox(
            height: 170,
            child: Card(
              color: Colors.green.shade50,
              elevation: 0.1,
              shadowColor: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Free consultation",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: Colors.green.shade700,
                                ),
                          ),
                          const Text(
                              "Get free support from our customer service"),
                          FilledButton(
                            onPressed: () {},
                            child: const Text("Call now"),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/contact_us.png',
                      width: 140,
                    )
                  ],
                ),
              ),
            ),
          ),
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
          // ... (rest of the ExplorePage code)
        ],
      ),
    );
  }

  // Define a method to get the title based on data type
  static String _getItemTitle(dynamic data) {
    if (data is Product) {
      return data.name;
    } else if (data is Map<String, dynamic>) {
      return data['fullName'];
    } else {
      return '';
    }
  }

  // Define a method to handle item tap based on data type
  static void _handleItemTap(dynamic data) {
    if (data is Product) {
      // Handle product tap
    } else if (data is Map<String, dynamic>) {
      // Handle map tap
    }
    // Add additional cases as needed
  }
}
