import 'package:dio/dio.dart';

class CheckoutService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:8000/api/",
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
      headers: {"Accept": "application/json"},
    ),
  );

  Future<bool> checkout(Map<String, dynamic> payload) async {
    try {
      print("📤 Checkout Payload:");
      print(payload);

      final res = await dio.post("checkout", data: payload);

      print("📥 Checkout Response:");
      print(res.data);

      return (res.statusCode == 200 || res.statusCode == 201) &&
          res.data["success"] == true;
    } catch (e) {
      if (e is DioException) {
        print("❌ Checkout Dio error: ${e.response?.data}");
      } else {
        print("❌ Checkout Error: $e");
      }
      return false;
    }
  }
}
