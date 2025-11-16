import 'package:clothes_shop/Home/login_screen.dart';
import 'package:clothes_shop/helper/order_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final box = GetStorage();
  int orderCount = 0;
  bool loadingOrders = true;

  @override
  void initState() {
    super.initState();
    _loadOrderCount();
  }

  Future<void> _loadOrderCount() async {
    final userId = box.read("user_id") ?? 0;

    if (userId != 0) {
      orderCount = await OrderService().getUserOrderCount(userId);
    }

    setState(() => loadingOrders = false);
  }

  @override
  Widget build(BuildContext context) {
    final token = box.read("token");
    final user = box.read("user");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: token != null && user != null
          ? _buildUserProfile(user)
          : _buildLoginPrompt(),
    );
  }

  // ==================================
  // ⭐ PROFILE UI
  // ==================================
  Widget _buildUserProfile(Map user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          const SizedBox(height: 20),

          CircleAvatar(
            radius: 55,
            backgroundImage: user["avatar"] != null
                ? NetworkImage(user["avatar"])
                : null,
            child: user["avatar"] == null
                ? const Icon(Icons.person, size: 55, color: Colors.white)
                : null,
          ),

          const SizedBox(height: 20),

          Text(
            user["name"],
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 5),

          Text(user["email"], style: const TextStyle(fontSize: 16)),

          const SizedBox(height: 30),

          // ORDER COUNT BOX
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shopping_bag, color: Colors.purple),
                const SizedBox(width: 10),
                Text(
                  loadingOrders ? "Loading..." : "$orderCount Orders Completed",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // LOGOUT
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await box.erase();
                Get.offAll(() => const LoginScreen());
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                "Logout",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================================
  // 🚫 NOT LOGGED-IN UI
  // ==================================
  Widget _buildLoginPrompt() {
    return Center(child: Text("Please log in"));
  }
}
