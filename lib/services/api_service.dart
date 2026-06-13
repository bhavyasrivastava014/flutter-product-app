import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  Future<List<Product>> fetchProducts({
    required int limit,
    required int skip,
  }) async {
    final url =
        "https://dummyjson.com/products?limit=$limit&skip=$skip";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return (data["products"] as List)
          .map((e) => Product.fromJson(e))
          .toList();
    }

    throw Exception("Failed to load products");
  }
}
