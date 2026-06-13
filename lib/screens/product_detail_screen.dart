import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                product.thumbnail,
                height: 250,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              product.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Price: ₹ ${product.price}",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Rating: ⭐ ${product.rating}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Description",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              product.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}