import 'dart:convert';
import 'package:http/http.dart' as http;

class CartService {
  final String baseUrl = "http://10.0.2.2:8000/api";

  Future<List<dynamic>> getCart(int userId) async {
    final res = await http.get(Uri.parse("$baseUrl/cart/$userId"));

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Failed to load cart");
    }
  }

  Future<bool> addToCart(int userId, int productId) async {
    final res = await http.post(
      Uri.parse("$baseUrl/cart"),
      body: {"user_id": "$userId", "product_id": "$productId"},
    );
    return res.statusCode == 201 || res.statusCode == 200;
  }

  Future<bool> updateQuantity(int cartId, int quantity) async {
    final res = await http.put(
      Uri.parse("$baseUrl/cart/$cartId"),
      body: {"quantity": "$quantity"},
    );
    return res.statusCode == 200;
  }

  Future<bool> removeCartItem(int cartId) async {
    final res = await http.delete(Uri.parse("$baseUrl/cart/$cartId"));
    return res.statusCode == 200;
  }
}
