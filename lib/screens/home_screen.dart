import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../screens/product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();

  List<Product> allProducts = [];
  List<Product> filteredProducts = [];

  int limit = 10;
  int skip = 0;

  bool isLoading = false;
  bool hasMore = true;

  final ScrollController scrollController = ScrollController();

  String selectedCategory = "All";
  List<String> categories = ["All"];

  String searchQuery = "";

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    loadProducts();

    scrollController.addListener(() {
      if (!isLoading &&
          hasMore &&
          scrollController.position.extentAfter < 300) {
        loadProducts();
      }
    });
  }

  Future<void> loadProducts() async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    print("Loading products with skip = $skip");

    final newProducts = await apiService.fetchProducts(
      limit: limit,
      skip: skip,
    );

    if (newProducts.isEmpty) {
      setState(() {
        hasMore = false;
        isLoading = false;
      });
      return;
    }

    allProducts.addAll(newProducts);

    categories = ["All", ...allProducts.map((e) => e.category).toSet()];

    applyFilters();

    setState(() {
      skip += limit;
      isLoading = false;
    });
  }

  void applyFilters() {
    filteredProducts = allProducts.where((product) {
      final matchesSearch = product.title.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );

      final matchesCategory =
          selectedCategory == "All" || product.category == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  applyFilters();
                });
              },
              decoration: InputDecoration(
                hintText: "Search Products",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedCategory,
              items: categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                  applyFilters();
                });
              },
            ),
          ),

          if (allProducts.isEmpty && isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];

                  return Card(
                    child: ListTile(
                      leading: Image.network(product.thumbnail, width: 60),
                      title: Text(product.title),
                      subtitle: Text("\$${product.price}"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailScreen(product: product),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
