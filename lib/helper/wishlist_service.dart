import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/wishlist_model.dart';

class WishlistService {
  final String baseUrl = "http://10.0.2.2:8000/api";

  Future<List<WishlistItem>> getWishlist(int userId) async {
    final response = await http.get(Uri.parse("$baseUrl/wishlist/$userId"));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((item) => WishlistItem.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load wishlist");
    }
  }

  Future<bool> addToWishlist(int userId, int productId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/wishlist"),
      body: {"user_id": "$userId", "product_id": "$productId"},
    );

    return response.statusCode == 201;
  }

  Future<bool> removeWishlist(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/wishlist/$id"));
    return response.statusCode == 200;
  }
}
