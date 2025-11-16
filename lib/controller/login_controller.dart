import 'dart:convert';
import 'package:clothes_shop/Home/home_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  final storage = GetStorage();

  Future<void> login(String email, String password) async {
    try {
      var res = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/login"),
        body: {"email": email, "password": password},
      );

      final data = jsonDecode(res.body);
      print("LOGIN RESPONSE: $data");

      if (res.statusCode == 200 && data["user"] != null) {
        var user = data["user"];

        // ==========================================
        // SAVE ALL USER DATA (REQUIRED FOR PROFILE)
        // ==========================================
        storage.write("user_id", user["id"]);
        storage.write("user", {
          "id": user["id"],
          "name": user["name"],
          "email": user["email"],
          "avatar": user["avatar"] ?? null,
          "orders": user["orders_count"] ?? 0,
        });

        // Save token if provided
        if (data["token"] != null) {
          storage.write("token", data["token"]);
        }

        Get.snackbar("Success", "Login Successful");
        Get.offAll(() => const HomeScreen());
      } else {
        Get.snackbar("Login Failed", data["message"] ?? "Invalid Login");
      }
    } catch (e) {
      print("Login error: $e");
      Get.snackbar("Error", "Cannot connect to server");
    }
  }
}
