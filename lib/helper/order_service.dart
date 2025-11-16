import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderService {
  final String baseUrl = "http://10.0.2.2:8000/api";

  Future<int> getUserOrderCount(int userId) async {
    final res = await http.get(Uri.parse("$baseUrl/orders/count/$userId"));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data["orders"] ?? 0;
    } else {
      return 0;
    }
  }
}
